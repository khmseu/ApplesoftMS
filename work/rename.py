#!/usr/bin/env python3
"""Rename whole words in the disassembly using work/rename.csv.

The CSV has two columns: "as" (word to rename) and "ms" (replacement).
Matching is case-insensitive on whole words; the replacement is written
in upper case. Reads disassembled/asrom.k65t.s and writes work/asrom.s,
then runs work/asm.sh.
"""

import csv
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
CSV_PATH = os.path.join(HERE, "rename.csv")
INPUT_PATH = os.path.join(ROOT, "disassembled", "asrom.k65t.s")
OUTPUT_PATH = os.path.join(HERE, "asrom.s")
ASM_SCRIPT = os.path.join(HERE, "asm.sh")


def load_renames(path):
    renames = {}
    with open(path, newline="") as fh:
        for row in csv.DictReader(fh):
            src = (row.get("as") or "").strip()
            dst = (row.get("ms") or "").strip()
            if src:
                renames[src.upper()] = dst.upper()
    return renames


def main():
    renames = load_renames(CSV_PATH)
    if not renames:
        print("No rename rules found in rename.csv", file=sys.stderr)
        return 1

    pattern = re.compile(
        r"\b(" + "|".join(re.escape(k) for k in renames) + r")\b",
        re.IGNORECASE,
    )

    def replace(match):
        return renames[match.group(0).upper()]

    with open(INPUT_PATH) as fh:
        text = fh.read()

    with open(OUTPUT_PATH, "w") as fh:
        fh.write(pattern.sub(replace, text))

    print(f"Wrote {OUTPUT_PATH}")
    subprocess.run([ASM_SCRIPT], check=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
