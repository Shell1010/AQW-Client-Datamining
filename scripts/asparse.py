import re

FUNC = re.compile(
    r'^[ \t]*(?:(?:public|private|internal|protected|static|override|final|native)\s+)*'
    r'function\s+(?:(get|set)\s+)?([A-Za-z_$][\w$]*)\s*\(', re.M)
LOC = re.compile(r'_loc(\d+)_')

def _match_brace(src, i):
    depth, n, q = 0, len(src), None
    while i < n:
        c = src[i]
        if q:
            if c == '\\': i += 2; continue
            if c == q: q = None
        elif c in '"\'': q = c
        elif c == '{': depth += 1
        elif c == '}':
            depth -= 1
            if depth == 0: return i + 1
        i += 1
    return n

def split_methods(src):
    """-> [('text', str) | ('method', name, str)], concatenation == src"""
    parts, pos = [], 0
    while True:
        m = FUNC.search(src, pos)
        if not m: break
        b = src.find('{', m.end())
        if b == -1: break
        end = _match_brace(src, b)
        parts.append(('text', src[pos:m.start()]))
        name = (m.group(1) + ' ' if m.group(1) else '') + m.group(2)
        parts.append(('method', name, src[m.start():end]))
        pos = end
    parts.append(('text', src[pos:]))
    return parts

def renumber(text):
    seen = {}
    def sub(m):
        seen.setdefault(m.group(1), len(seen) + 1)
        return f'_loc{seen[m.group(1)]}_'
    return LOC.sub(sub, text)

def normalize(src):
    src = re.sub(r'\r\n?', '\n', src)
    src = re.sub(r'/\*.*?\*/', '', src, flags=re.S)
    src = re.sub(r'^[ \t]*//.*$', '', src, flags=re.M)
    src = re.sub(r'[ \t]+$', '', src, flags=re.M)
    lines = src.split('\n')
    idx = [i for i, l in enumerate(lines) if l.strip().startswith('import ')]
    for i, l in zip(idx, sorted(lines[i] for i in idx)):
        lines[i] = l
    src = '\n'.join(lines)
    out = []
    for p in split_methods(src):
        out.append(renumber(p[2]) if p[0] == 'method' else p[1])
    return re.sub(r'\n{3,}', '\n\n', ''.join(out)).strip() + '\n'