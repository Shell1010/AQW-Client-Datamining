import argparse, collections, difflib, json, os, re, sys, time
from pathlib import Path
import requests
from asparse import split_methods

def load_tree(root):
    d = {}
    base = Path(root) / "scripts"
    for f in base.rglob("*.as"):
        d[str(f.relative_to(base))] = f.read_text(errors="replace")
    return d

def parse(src):
    methods, fields = {}, []
    for p in split_methods(src):
        if p[0] == 'method': methods[p[1]] = p[2]
        else: fields += [l.strip() for l in p[1].split('\n') if l.strip()]
    return methods, fields

def squash(s): return re.sub(r'\s+', ' ', s)

def dlines(a, b, limit):
    out = [l[0] + l[1:].strip() for l in difflib.unified_diff(
        a.split('\n') if isinstance(a, str) else a,
        b.split('\n') if isinstance(b, str) else b, lineterm='', n=0)
        if l[:1] in '+-' and not l.startswith(('+++', '---'))]
    return out[:limit], max(0, len(out) - limit)

STR = re.compile(r'"((?:[^"\\\n]|\\.)*)"')
PKT = re.compile(r'(?:case\s+"([\w:+*\-]+)"\s*:|sendXtMessage\(\s*"zm"\s*,\s*"(\w+)")')

def symbols(tree):
    strings, packets = set(), set()
    for src in tree.values():
        strings |= {s for s in STR.findall(src) if len(s) >= 3}
        for a, b in PKT.findall(src): packets.add(a or b)
    return strings, packets

def asset_diff(old, new):
    def counts(root):
        p = Path(root) / "assets.json"
        if not p.exists(): return collections.Counter()
        return collections.Counter(h for h in json.loads(p.read_text()).values()
                                   if not h.startswith("e3b0c442"))
    o, n = counts(old), counts(new)
    return sum((n - o).values()), sum((o - n).values())

def build(old, new):
    ot, nt = load_tree(old), load_tree(new)
    files, patch = [], []
    for name in sorted(set(ot) | set(nt)):
        a, b = ot.get(name), nt.get(name)
        if a == b: continue
        if a is None:
            files.append((name, "added", [f"+ new class ({b.count(chr(10))} lines)"])); 
        elif b is None:
            files.append((name, "removed", []))
        else:
            am, af = parse(a); bm, bf = parse(b)
            rows = []
            for m in sorted(bm.keys() - am.keys()): rows.append(f"+ method `{m}`")
            for m in sorted(am.keys() - bm.keys()): rows.append(f"- method `{m}`")
            for m in sorted(am.keys() & bm.keys()):
                if squash(am[m]) != squash(bm[m]):
                    d, more = dlines(am[m], bm[m], 14)
                    rows.append(f"~ `{m}`\n```diff\n" + "\n".join(d) +
                                (f"\n… +{more} more" if more else "") + "\n```")
            d, more = dlines(sorted(set(af)), sorted(set(bf)), 20)
            d = [x for x in d]
            if d: rows.append("fields/consts\n```diff\n" + "\n".join(d) + "\n```")
            if rows: files.append((name, "changed", rows))
        patch += list(difflib.unified_diff((a or '').split('\n'), (b or '').split('\n'),
                                           f"a/{name}", f"b/{name}", lineterm='', n=2))
    os_, op = symbols(ot); ns, np_ = symbols(nt)
    return files, sorted(np_ - op), sorted(op - np_), \
        sorted(s for s in ns - os_ if s.startswith("http")), \
        sorted(ns - os_), "\n".join(patch)

def chunk_embed(title, text, color=0x5865F2):
    return {"title": title[:250], "description": text[:4000], "color": color}

def make_embeds(files, newp, gonep, urls, newstr, assets):
    emb = []
    sumry = [f"{len(files)} file(s) changed", f"assets: +{assets[0]} / -{assets[1]} unique blobs"]
    if newp: sumry.append("**New packet cmds:** " + ", ".join(f"`{p}`" for p in newp[:40]))
    if gonep: sumry.append("**Removed packet cmds:** " + ", ".join(f"`{p}`" for p in gonep[:40]))
    if urls: sumry.append("**New URLs:**\n" + "\n".join(f"`{u}`" for u in urls[:15]))
    emb.append(chunk_embed("Summary", "\n".join(sumry), 0x57F287))
    for name, kind, rows in files:
        text = f"*{kind}*\n" + "\n".join(rows)
        emb.append(chunk_embed(name, text, {"added": 0x57F287, "removed": 0xED4245}.get(kind, 0x5865F2)))
    other = [s for s in newstr if not s.startswith("http")]
    if other:
        emb.append(chunk_embed("New string literals", "\n".join(f"`{s[:100]}`" for s in other[:60]), 0xFEE75C))
    return emb

def post(url, payload, filename=None, content=None):
    for _ in range(6):
        if filename:
            r = requests.post(url, data={"payload_json": json.dumps(payload)},
                              files={"files[0]": (filename, content)}, timeout=60)
        else:
            r = requests.post(url, json=payload, timeout=60)
        if r.status_code == 429:
            time.sleep(float(r.json().get("retry_after", 2)) + 0.5); continue
        r.raise_for_status(); return
    raise RuntimeError("discord rate-limited")

def send(url, header, embeds, patch, tag):
    batch, size = [], 0
    first = True
    def flush():
        nonlocal batch, size, first
        if not batch: return
        payload = {"content": header if first else "", "embeds": batch}
        if first and patch:
            post(url, payload, f"{tag}.diff", patch.encode()[:8_000_000])
        else:
            post(url, payload)
        first, batch, size = False, [], 0
    for e in embeds:
        n = len(e["title"]) + len(e["description"])
        if batch and (len(batch) >= 8 or size + n > 5500): flush()
        batch.append(e); size += n
    flush()

def vars_diff(old, new):
    def load(r):
        p = Path(r) / "clientvars.json"
        return json.loads(p.read_text()) if p.exists() else None
    o, n = load(old), load(new)
    if o is None or n is None: return []
    return [f"`{k}`: `{o.get(k)}` → `{n.get(k)}`"
            for k in sorted(set(o) | set(n)) if o.get(k) != n.get(k)]

def symbols_diff(old, new):
    def load(r):
        p = Path(r) / "symbols.json"
        return set(json.loads(p.read_text())) if p.exists() else None
    o, n = load(old), load(new)
    if o is None or n is None: return [], []
    return sorted(n - o), sorted(o - n)

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--old", required=True); ap.add_argument("--new", required=True)
    ap.add_argument("--dry-run", action="store_true")
    a = ap.parse_args()
    old, new = Path(a.old), Path(a.new)

    files, newp, gonep, urls, newstr, patches = [], set(), set(), set(), set(), []
    assets = [0, 0]; link_lines = []
    for mod in sorted(p.name for p in new.iterdir() if (p / "scripts").exists()):
        if not (old / mod / "scripts").exists():
            print(f"{mod}: no previous tree (baseline) - skipping"); continue
        f, np_, gp, u, ns, patch = build(old / mod, new / mod)
        files += [(f"{mod}/{n}", k, r) for n, k, r in f]
        newp |= set(np_); gonep |= set(gp); urls |= set(u); newstr |= set(ns)
        if patch: patches.append(f"# module {mod}\n{patch}")
        d = asset_diff(old / mod, new / mod); assets[0] += d[0]; assets[1] += d[1]
        add, rem = symbols_diff(old / mod, new / mod)
        if add: link_lines.append(f"**{mod} +linkage ({len(add)}):** " + ", ".join(f"`{x}`" for x in add[:40]))
        if rem: link_lines.append(f"**{mod} -linkage ({len(rem)}):** " + ", ".join(f"`{x}`" for x in rem[:40]))

    vd = vars_diff(old, new)
    if not files and not vd and not link_lines and tuple(assets) == (0, 0):
        print("no meaningful changes"); sys.exit(0)

    def get(root, key, fn="gameversion.json"):
        p = Path(root) / fn
        return json.loads(p.read_text()).get(key, "?") if p.exists() else "?"
    ov, nv = get(old, "sVersion"), get(new, "sVersion")
    oa, na = get(old, "sAssets", "clientvars.json"), get(new, "sAssets", "clientvars.json")
    header = f"**AQW client update** {ov} → {nv}" + (f"\nAssets: `{oa}` → `{na}`" if oa != na else "")
    tag = f"AQW_{ov}_to_{nv}"

    embeds = make_embeds(files, sorted(newp), sorted(gonep), sorted(urls), sorted(newstr), tuple(assets))
    extra = []
    if vd: extra.append("**clientvars**\n" + "\n".join(vd))
    extra += link_lines
    if extra: embeds.insert(1, chunk_embed("Vars / linkage", "\n".join(extra), 0xEB459E))
    patch = "\n".join(patches)
    if a.dry_run:
        print(header); [print(e["title"], "\n", e["description"], "\n---") for e in embeds]; sys.exit(0)
    send(os.environ["DISCORD_WEBHOOK"], header, embeds, patch, tag)