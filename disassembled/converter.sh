#! /bin/bash -e
workdir=disassembled
base=asrom
intrunk=$workdir/$base
source=$intrunk.s
outtrunk=$intrunk.k65t
temp=$outtrunk.tmp
dest=$outtrunk.s
sed -E \
	-e 's,\*=,.org ,' \
	-e 's,\.byt\>,.byte,i' \
	-e 's,^([A-Z_0-9]+)([[:space:]]+[A-Z_0-9]+),\1:\2,i' \
	-e 's,^([A-Z_0-9]+)([[:space:]]*)$,\1:\2,i' \
	-e 's,^([A-Z_0-9]+)([[:space:]]*;),\1:\2,i' \
	$source >$temp
k65fmt $temp $dest
k65asm $dest
