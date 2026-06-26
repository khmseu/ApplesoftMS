#!/bin/bash -x

cd "$(dirname "$0")" || exit

k65asm -o asrom.bin -l asrom.lst asrom.s