import hashlib, json, os, random, re, subprocess, sys
from pathlib import Path
import requests

BASE = "https://game.aq.com/game"
OUT = Path("client")            # committed tree
STATE = Path("state.json")
FFDEC = os.environ.get("FFDEC", "ffdec/ffdec-cli.jar")  # pinned version
UA = {"User-Agent": "Mozilla/5.0 (aqw-datamine)"}

def get_version():
    r = requests.get(f"{BASE}/api/data/gameversion",
                     params={"ver": random.random()}, headers=UA, timeout=30)
    r.raise_for_status()
    return r.json()

def download(info, dest: Path):
    url = f"{BASE}/gamefiles/{info['sFile']}"
    r = requests.get(url, params={"ver": info["sVersion"]}, headers=UA, timeout=120)
    r.raise_for_status()
    dest.write_bytes(r.content)

def ffdec(swf: Path, out: Path):
    out.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        ["java", "-jar", FFDEC, "-format", "script:as",
         "-export", "script", str(out / "scripts"), str(swf)],
        check=True)
    # assets: binaryData/text/images are safe to hash; skip shapes/sprites at first
    subprocess.run(
        ["java", "-jar", FFDEC, "-export", "image,binaryData,sound,text",
         str(out / "assets_raw"), str(swf)],
        check=False)

LOC = re.compile(r"_loc(\d+)_")
def renumber_locals(method_src: str) -> str:
    seen = {}
    def sub(m):
        seen.setdefault(m.group(1), len(seen) + 1)
        return f"_loc{seen[m.group(1)]}_"
    return LOC.sub(sub, method_src)

def normalize(src: str) -> str:
    src = re.sub(r"/\*.*?\*/", "", src, flags=re.S)       # block comments
    src = re.sub(r"[ \t]+$", "", src, flags=re.M)
    src = re.sub(r"\n{3,}", "\n\n", src)
    return renumber_locals(src).strip() + "\n"

def normalize_tree(raw: Path, dest: Path):
    for f in raw.rglob("*.as"):
        rel = f.relative_to(raw)
        target = dest / rel
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(normalize(f.read_text(errors="replace")))

def hash_assets(raw: Path, dest: Path):
    manifest = {}
    for f in sorted(raw.rglob("*")):
        if f.is_file():
            manifest[str(f.relative_to(raw))] = hashlib.sha256(f.read_bytes()).hexdigest()
    (dest / "assets.json").write_text(json.dumps(manifest, indent=1, sort_keys=True))

def main():
    info = get_version()
    state = json.loads(STATE.read_text()) if STATE.exists() else {}
    if state.get("sFile") == info["sFile"] and state.get("sVersion") == info["sVersion"]:
        print("no change"); return
    work = Path("work"); work.mkdir(exist_ok=True)
    swf = work / info["sFile"]
    download(info, swf)
    ffdec(swf, work / "raw")
    if OUT.exists():
        subprocess.run(["rm", "-rf", str(OUT)])
    normalize_tree(work / "raw" / "scripts", OUT / "scripts")
    hash_assets(work / "raw" / "assets_raw", OUT)
    (OUT / "gameversion.json").write_text(json.dumps(info, indent=1, sort_keys=True))
    STATE.write_text(json.dumps(info))
    print(f"updated to {info['sFile']} {info['sVersion']}")

if __name__ == "__main__":
    main()