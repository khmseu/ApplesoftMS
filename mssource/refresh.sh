#! /bin/bash

set -euo pipefail

cd -- "$(dirname -- "$0")" || exit 1

readonly SRC_BASE='../../M6502asm'

FILES=(
	'BASIC-M6502/m6502.asm'
	'examples/converted/m6502_ca65.asm'
	'examples/converted/m6502_ca65.lst'
	'examples/converted/m6502_original_m6502asm.lst'
	'examples/converted/m6502_xa65.asm'
	'examples/converted/m6502_xa65.lst'
)

for rel_path in "${FILES[@]}"; do
	cp -av -- "$SRC_BASE/$rel_path" .
done
