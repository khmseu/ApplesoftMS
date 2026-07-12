#!/usr/bin/env python3
"""Normalize symbol casing in a target file using a listing symbol table.

The script parses symbol names from lines like:
    SYMBOL_NAME = $ABCD (43981)  [label]

Then it rewrites full-word matches in a target file, case-insensitively,
to the exact symbol spelling from the listing.

Usage:
    python3 utils/fix_symbol_case_from_listing.py <listing.lst> <target-file>
    python3 utils/fix_symbol_case_from_listing.py <listing.lst> <target-file> --dry-run
"""

from __future__ import annotations

import argparse
import pathlib
import re
import sys


SYMBOL_LINE_RE = re.compile(r"^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*\$[0-9A-Fa-f]+\b")


def parse_symbols_from_listing(listing_path: pathlib.Path) -> dict[str, str]:
    symbols_by_lower: dict[str, str] = {}

    with listing_path.open("r", encoding="utf-8", errors="replace") as f:
        for line in f:
            match = SYMBOL_LINE_RE.match(line)
            if not match:
                continue

            symbol = match.group(1)
            key = symbol.lower()
            if key not in symbols_by_lower:
                symbols_by_lower[key] = symbol

    return symbols_by_lower


def build_symbol_regex(symbols_by_lower: dict[str, str]) -> re.Pattern[str]:
    escaped = [re.escape(symbol) for symbol in symbols_by_lower.values()]
    escaped.sort(key=len, reverse=True)

    # Word boundary for assembler-like symbols: letters/digits/underscore.
    pattern = r"(?<![A-Za-z0-9_])(" + "|".join(escaped) + r")(?![A-Za-z0-9_])"
    return re.compile(pattern, flags=re.IGNORECASE)


def normalize_symbol_case(text: str, symbol_pattern: re.Pattern[str], symbols_by_lower: dict[str, str]) -> tuple[str, int]:
    replacements = 0

    def repl(match: re.Match[str]) -> str:
        nonlocal replacements
        token = match.group(1)
        canonical = symbols_by_lower.get(token.lower())
        if canonical is None or token == canonical:
            return token

        replacements += 1
        return canonical

    return symbol_pattern.sub(repl, text), replacements


def main() -> int:
    parser = argparse.ArgumentParser(description="Normalize symbol case using listing symbol table")
    parser.add_argument("listing", type=pathlib.Path, help="Listing file with symbol table (e.g. asrom.k65t.lst)")
    parser.add_argument("target", type=pathlib.Path, help="File to rewrite")
    parser.add_argument("--dry-run", action="store_true", help="Report changes without writing")
    args = parser.parse_args()

    symbols_by_lower = parse_symbols_from_listing(args.listing)
    if not symbols_by_lower:
        print(f"No symbols were found in listing: {args.listing}", file=sys.stderr)
        return 2

    pattern = build_symbol_regex(symbols_by_lower)

    original = args.target.read_text(encoding="utf-8", errors="replace")
    updated, replacements = normalize_symbol_case(original, pattern, symbols_by_lower)

    print(f"Loaded {len(symbols_by_lower)} symbols from {args.listing}")
    print(f"Matched {replacements} symbol occurrence(s) in {args.target}")

    if not args.dry_run and updated != original:
        args.target.write_text(updated, encoding="utf-8")
        print("Updated target file")
    elif args.dry_run:
        print("Dry run: target file not modified")
    else:
        print("No changes needed")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
