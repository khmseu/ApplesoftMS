#!/usr/bin/env python3
"""Compare disassembled/asrom.s and work/asrom.s in parallel to extract
AS_*/MS_* symbol renames, then emit a rename-apply script to stdout.

Usage:
    python3 build_rename_map.py > rename_syms.py
    chmod +x rename_syms.py
    ./rename_syms.py somefile.asm
"""
import sys

FILE_A = "disassembled/asrom.s"
FILE_B = "work/asrom.s"


def is_target(words):
    """Return True if the line's first word starts with AS_ or MS_."""
    return bool(words) and (words[0].startswith("AS_") or words[0].startswith("MS_"))


pairs = []

with open(FILE_A) as fa, open(FILE_B) as fb:
    for lineno, (la, lb) in enumerate(zip(fa, fb), 1):
        wa = la.split()
        wb = lb.split()

        # Discard if either line is not an AS_/MS_ symbol line
        if not is_target(wa) or not is_target(wb):
            continue

        w1a, w1b = wa[0], wb[0]
        w2a = wa[1] if len(wa) > 1 else ""
        w2b = wb[1] if len(wb) > 1 else ""

        # Same first word → no rename needed
        if w1a == w1b:
            continue

        # Equate definitions (second word is '=') → skip
        if w2a == "=" or w2b == "=":
            continue

        # Sanity check: second tokens must match between the two files
        if w2a != w2b:
            sys.exit(
                f"ERROR line {lineno}: second-word mismatch\n"
                f"  {FILE_A}: {la.rstrip()}\n"
                f"  {FILE_B}: {lb.rstrip()}"
            )

        pairs.append((w1a, w1b))

# ---------------------------------------------------------------------------
# Emit the rename-apply script
# ---------------------------------------------------------------------------
lines = [
    "#!/usr/bin/env python3",
    '"""Apply symbol renames produced by build_rename_map.py.',
    "",
    "Usage: rename_syms.py <file>  (edits the file in place)",
    '"""',
    "import sys, re",
    "",
    "PAIRS = [",
]
for old, new in pairs:
    lines.append(f"    ({old!r}, {new!r}),")
lines += [
    "]",
    "",
    "if len(sys.argv) < 2:",
    '    print(f"Usage: {sys.argv[0]} <file>", file=sys.stderr)',
    "    sys.exit(1)",
    "",
    "path = sys.argv[1]",
    "with open(path) as f:",
    "    text = f.read()",
    "",
    "for old, new in PAIRS:",
    "    text = re.sub('\\\\b' + re.escape(old) + '\\\\b', new, text)",
    "",
    "with open(path, 'w') as f:",
    "    f.write(text)",
    "",
]
print("\n".join(lines))
