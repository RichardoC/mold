#!/bin/bash
export LANG=
set -e
cd $(dirname $0)
mold=`pwd`/../../mold
echo -n "Testing $(basename -s .sh $0) ... "
t=$(pwd)/../../out/test/elf/$(basename -s .sh $0)
mkdir -p $t

cat <<EOF | cc -o $t/a.o -c -xc -
#include <stdio.h>
int main() {
  printf("Hello world\n");
}
EOF

clang -fuse-ld=$mold -o $t/exe $t/a.o -Wl,-no-threads
clang -fuse-ld=$mold -o $t/exe $t/a.o -Wl,-thread-count=1
clang -fuse-ld=$mold -o $t/exe $t/a.o -Wl,-threads
clang -fuse-ld=$mold -o $t/exe $t/a.o -Wl,-threads=1
clang -fuse-ld=$mold -o $t/exe $t/a.o -Wl,--threads=1

echo OK
