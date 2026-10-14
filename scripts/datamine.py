import hashlib, json, os, random, shutil, struct, subprocess, zlib
from pathlib import Path
import requests
from asparse import normalize

BASE = "https://game.aq.com/game"
FILES = f"{BASE}/gamefiles"
OUT, STATE, WORK = Path("client"), Path("state.json"), Path("work")
FFDEC = os.environ.get("FFDEC", "ffdec/ffdec-cli.jar")
ENABLED = os.environ.get("MODULES", "main,assets").split(",")
UA = {"User-Agent": "Mozilla/5.0 (aqw-datamine)"}

def get_json(path):
    r = requests.get(f"{BASE}/{path}", params={"ver": random.random()}, headers=UA, timeout=30)
    r.raise_for_status()
    return r.json()

def module_urls(info, cv):
    all_ = {
        "main":     f"{FILES}/{info['sFile']}",
        "assets":   f"{FILES}/interface/Assets/{cv['sAssets']}",
        "map":      f"{FILES}/{cv['sMap']}",
        "book":     f"{FILES}/{cv['sBook']}",
        "gamemenu": f"{FILES}/{cv['gMenu']}",
    }
    return {k: v for k, v in all_.items() if k in ENABLED}

def fetch(url, ver, etag):
    h = dict(UA)
    if etag: h["If-None-Match"] = etag
    r = requests.get(url, params={"ver": ver}, headers=h, timeout=180)
    if r.status_code == 304: return None, etag
    r.raise_for_status()
    return r.content, r.headers.get("ETag")

def swf_symbols(data):
    if data[:3] == b"CWS": body = zlib.decompress(data[8:])
    elif data[:3] == b"FWS": body = data[8:]
    else: return []
    nbits = body[0] >> 3
    pos = (5 + nbits * 4 + 7) // 8 + 4
    names = []
    while pos + 2 <= len(body):
        h = struct.unpack_from("<H", body, pos)[0]; pos += 2
        code, ln = h >> 6, h & 63
        if ln == 63:
            ln = struct.unpack_from("<I", body, pos)[0]; pos += 4
        if code == 0: break
        if code == 76:
            n = struct.unpack_from("<H", body, pos)[0]; p = pos + 2
            for _ in range(n):
                p += 2
                e = body.index(b"\0", p)
                names.append(body[p:e].decode("utf8", "replace")); p = e + 1
        pos += ln
    return sorted(set(names))

def ffdec(swf, raw):
    raw.mkdir(parents=True, exist_ok=True)
    subprocess.run(["java", "-jar", FFDEC, "-format", "script:as",
                    "-export", "script", str(raw / "scripts"), str(swf)], check=True)
    subprocess.run(["java", "-jar", FFDEC, "-export", "image,binaryData,sound,text",
                    str(raw / "assets_raw"), str(swf)], check=False)

def process(name, data):
    work = WORK / name
    shutil.rmtree(work, ignore_errors=True); work.mkdir(parents=True)
    swf = work / "module.swf"; swf.write_bytes(data)
    ffdec(swf, work / "raw")
    dest = OUT / name
    shutil.rmtree(dest, ignore_errors=True)
    raw_scripts = work / "raw" / "scripts"
    for f in raw_scripts.rglob("*.as"):
        t = dest / "scripts" / f.relative_to(raw_scripts)
        t.parent.mkdir(parents=True, exist_ok=True)
        t.write_text(normalize(f.read_text(errors="replace")))
    manifest = {}
    ar = work / "raw" / "assets_raw"
    if ar.exists():
        for f in sorted(ar.rglob("*")):
            if f.is_file():
                manifest[str(f.relative_to(ar))] = hashlib.sha256(f.read_bytes()).hexdigest()
    dest.mkdir(parents=True, exist_ok=True)
    (dest / "assets.json").write_text(json.dumps(manifest, indent=1, sort_keys=True))
    (dest / "symbols.json").write_text(json.dumps(swf_symbols(data), indent=1))

def main():
    info, cv = get_json("api/data/gameversion"), get_json("api/data/clientvars")
    OUT.mkdir(exist_ok=True)
    (OUT / "gameversion.json").write_text(json.dumps(info, indent=1, sort_keys=True))
    (OUT / "clientvars.json").write_text(json.dumps(cv, indent=1, sort_keys=True))
    state = json.loads(STATE.read_text()) if STATE.exists() else {}
    for name, url in module_urls(info, cv).items():
        st = state.get(name, {})
        data, etag = fetch(url, info["sVersion"], st.get("etag"))
        if data is None:
            print(f"{name}: 304 unchanged"); continue
        sha = hashlib.sha256(data).hexdigest()
        if sha == st.get("sha") and (OUT / name).exists():
            print(f"{name}: same content"); st["etag"] = etag; state[name] = st; continue
        print(f"{name}: changed -> {url}")
        process(name, data)
        state[name] = {"sha": sha, "etag": etag, "url": url}
    STATE.write_text(json.dumps(state, indent=1, sort_keys=True))

if __name__ == "__main__":
    main()