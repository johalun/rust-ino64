#!/bin/sh

CURDIR=`pwd`
TMP=$CURDIR/build
FULLPATH=`find $HOME/.rustup/toolchains/nightly-x86_64-unknown-freebsd/ -name "libstd-*.rlib"`
FILE=`basename $FULLPATH`
HASH=`echo $FILE | sed -e 's/.*-\([a-f0-9]*\).*/\1/g'`
STDINNER=std-$HASH.0.o

echo Temp dir $TMP
echo Found target library at $FULLPATH
echo Filename $FILE
echo Hash $HASH

mkdir -p $TMP
cd $TMP
cp $FULLPATH $FILE
cp $FULLPATH $FILE.orig
cc -c -fPIC -O2 -pipe -fstack-protector -fno-strict-aliasing -o old_fstat.o $CURDIR/old_fstat.c
ar x $FULLPATH $STDINNER
ld -r -o std.xx.o $STDINNER old_fstat.o
mv std.xx.o $STDINNER
ar r $FILE $STDINNER
cp $FILE $FULLPATH
echo Rust std patched for ino64!
echo A copy of the original $FILE is kept in $TMP/
