import json, os, re, time
import requests

IS_V2 = 1 << 15
SUPPRESS_NOTIFS = 1 << 12
MAX_COMPONENTS, MAX_TEXT = 40, 4000
MAX_FILES, MAX_MESSAGES = 30, 12

ACTION_ROW, BUTTON, SECTION, TEXT, THUMB, FILE, SEP, CONTAINER = 1, 2, 9, 10, 11, 13, 14, 17
BLURPLE, GREEN, RED, YELLOW = 0x5865F2, 0x57F287, 0xED4245, 0xFEE75C
KIND = {"added": ("🆕", GREEN), "removed": ("🗑️", RED), "changed": ("✏️", BLURPLE)}

# ---------- component constructors ----------
def text(s):            return {"type": TEXT, "content": s}
def sep(big=False):     return {"type": SEP, "divider": True, "spacing": 2 if big else 1}
def file_c(name):       return {"type": FILE, "file": {"url": f"attachment://{name}"}}
def thumb(url, alt):    return {"type": THUMB, "media": {"url": url}, "description": alt}
def link_btn(label, url, emoji):
    return {"type": BUTTON, "style": 5, "label": label, "url": url, "emoji": {"name": emoji}}
def row(*btns):         return {"type": ACTION_ROW, "components": list(btns)}
def section(texts, accessory):
    return {"type": SECTION, "components": [text(t) for t in texts], "accessory": accessory}
def container(children, color=None):
    c = {"type": CONTAINER, "components": children}
    if color is not None: c["accent_color"] = color
    return c

def measure(c):
    """(component count incl. nested, text chars)"""
    n, t = 1, len(c["content"]) if c["type"] == TEXT else 0
    for k in c.get("components", []):
        a, b = measure(k); n += a; t += b
    if "accessory" in c:
        a, b = measure(c["accessory"]); n += a; t += b
    return n, t

# ---------- text helpers ----------
def fit(s, limit):
    if len(s) <= limit: return s
    s = s[:limit - 20].rstrip()
    if s.count("```") % 2: s += "\n```"
    return s + "\n*…truncated*"

def pack(rows, limit=1700):
    out, cur = [], ""
    for r in rows:
        r = fit(r, limit)
        if cur and len(cur) + len(r) + 1 > limit: out.append(cur); cur = r
        else: cur = f"{cur}\n{r}" if cur else r
    if cur: out.append(cur)
    return out

def counts(rows):
    add = sum(r.startswith("+ method") for r in rows)
    rem = sum(r.startswith("- method") for r in rows)
    mod = sum(r.startswith("~ ") for r in rows)
    return add, rem, mod

# ---------- blocks ----------
def file_container(name, kind, rows, budget=3300):
    icon, color = KIND[kind]
    mod, _, path = name.partition("/")
    kids = [text(f"### {icon} `{path or name}`\n-# {mod} · {kind}"), sep()]
    blocks, used, dropped = pack(rows) or ["*no textual changes*"], 0, 0
    for b in blocks:
        if used + len(b) > budget: dropped += 1; continue
        kids.append(text(b)); used += len(b)
    if dropped: kids.append(text(f"-# …{dropped} more block(s), see the attached .diff"))
    return container(kids, color)

def overview(r, diff_name):
    old, new = r["old"], r["new"]
    files = r["files"]
    add = rem = mod = 0
    for _, _, rows in files:
        a, b, c = counts(rows); add += a; rem += b; mod += c
    aa, ar = r["assets"]

    head = [f"# AQW Client Update\n`{old}` → `{new}`"]
    if r.get("assets_change"):
        head.append(f"Assets `{r['assets_change'][0]}` → `{r['assets_change'][1]}`")
    run = None
    if os.environ.get("GITHUB_RUN_ID"):
        run = (f"{os.environ['GITHUB_SERVER_URL']}/{os.environ['GITHUB_REPOSITORY']}"
               f"/actions/runs/{os.environ['GITHUB_RUN_ID']}")
    icon_url = os.environ.get("AQW_ICON_URL")
    if icon_url:   acc = thumb(icon_url, "AQW")
    elif run:      acc = link_btn("Run", run, "⚙️")
    else:          acc = None

    kids = [section(head, acc) if acc else text("\n".join(head)), sep(big=True)]
    kids.append(text(
        f"**{len(files)}** files • **+{add}** / **−{rem}** methods • **{mod}** modified\n"
        f"assets **+{aa}** / **−{ar}** unique blobs"))

    idx = []
    for name, kind, rows in files[:12]:
        a, b, c = counts(rows)
        idx.append(f"{KIND[kind][0]} `{name.partition('/')[2] or name}` +{a} −{b} ~{c}")
    if len(files) > 12: idx.append(f"-# …and {len(files) - 12} more")
    if idx: kids.append(text(fit("\n".join(idx), 900)))

    hl = r.get("highlights", [])[:5]
    if hl:
        kids.append(sep())
        for h, body in hl:
            kids.append(text(f"**{h}**\n{fit(body, 450)}"))

    if diff_name:
        kids += [sep(), file_c(diff_name)]

    btns = []
    if run: btns.append(link_btn("Workflow run", run, "⚙️"))
    if os.environ.get("GITHUB_REPOSITORY"):
        repo = f"{os.environ['GITHUB_SERVER_URL']}/{os.environ['GITHUB_REPOSITORY']}"
        btns += [link_btn("Repository", repo, "📁"), link_btn("History", f"{repo}/commits", "🕘")]
    if btns: kids += [sep(), row(*btns)]
    kids.append(text(f"-# <t:{int(time.time())}:R> • aqw-datamine"))
    return container(kids, BLURPLE)

# ---------- assembly ----------
def pack_messages(tops):
    msgs, cur, n, t = [], [], 0, 0
    for c in tops:
        cn, ct = measure(c)
        if cur and (n + cn > MAX_COMPONENTS or t + ct > MAX_TEXT - 50):
            msgs.append(cur); cur, n, t = [], 0, 0
        cur.append(c); n += cn; t += ct
    if cur: msgs.append(cur)
    return msgs

def render(r, diff_name=None):
    files = r["files"]
    tops = [overview(r, diff_name)]
    for name, kind, rows in files[:MAX_FILES]:
        tops.append(file_container(name, kind, rows))
    extra = files[MAX_FILES:]
    if extra:
        names = ", ".join(f"`{n}`" for n, _, _ in extra)
        tops.append(container([text(f"### 📚 Also changed ({len(extra)})\n{fit(names, 1800)}")], YELLOW))
    msgs = pack_messages(tops)
    if len(msgs) > MAX_MESSAGES:
        msgs = msgs[:MAX_MESSAGES]
        msgs[-1].append(container([text("-# Output truncated, see the attached .diff")], YELLOW))
    out = []
    for i, comps in enumerate(msgs):
        flags = IS_V2 | (SUPPRESS_NOTIFS if i else 0)
        out.append({"flags": flags, "components": comps,
                    "allowed_mentions": {"parse": []}, "username": "AQW Datamine"})
    return out

# ---------- transport ----------
def post(url, payload, attachment=None):
    params = {"with_components": "true", "wait": "true"}
    for _ in range(6):
        if attachment:
            fname, data = attachment
            payload = {**payload, "attachments": [{"id": 0, "filename": fname}]}
            resp = requests.post(url, params=params,
                                 data={"payload_json": json.dumps(payload)},
                                 files={"files[0]": (fname, data)}, timeout=60)
        else:
            resp = requests.post(url, params=params, json=payload, timeout=60)
        if resp.status_code == 429:
            time.sleep(float(resp.json().get("retry_after", 2)) + 0.5); continue
        if not resp.ok:
            print("Discord error:", resp.status_code, resp.text)
            resp.raise_for_status()
        return resp.json()
    raise RuntimeError("discord rate-limited")

def send_report(url, r, patch=None, tag="aqw"):
    diff_name = re.sub(r"[^\w.-]", "_", tag) + ".diff" if patch else None
    payloads = render(r, diff_name)
    attach = (diff_name, patch.encode()[:8_000_000]) if patch else None
    for i, p in enumerate(payloads):
        post(url, p, attach if i == 0 else None)
        time.sleep(0.6)