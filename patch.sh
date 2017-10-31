#!/bin/sh

CURDIR=`pwd`
TMP=$CURDIR/build
FULLPATH=`find $HOME/.rustup/toolchains/nightly-x86_64-unknown-freebsd/lib/rustlib/x86_64-unknown-freebsd -name "libstd-*.rlib"`
FILE=`basename $FULLPATH`
HASH=`echo $FILE | sed -e 's/.*-\([a-f0-9]*\).*/\1/g'`
STDINNER=std-$HASH.0.o

echo Temp dir $TMP
echo Found target library at $FULLPATH
echo Filename $FILE
echo Hash $HASH

mkdir -p $TMP || exit 1
cd $TMP || exit 1
cp $FULLPATH $FILE || exit 1
cp $FULLPATH $FILE.orig || exit 1
cc -c -fPIC -O2 -pipe -fstack-protector -fno-strict-aliasing -o old_fstat.o $CURDIR/old_fstat.c || exit 1
ar x $FULLPATH $STDINNER || exit 1
ld -r -o std.xx.o $STDINNER old_fstat.o || exit 1
mv std.xx.o $STDINNER || exit 1
ar r $FILE $STDINNER || exit 1
cp $FILE $FULLPATH || exit 1

echo Rust std patched for ino64!
echo A copy of the original $FILE is kept in $TMP/
