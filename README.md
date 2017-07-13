# rust-ino64
A patch to fix breakage on FreeBSD12-CURRENT post ino64

The issue is described here https://github.com/rust-lang/rust/issues/42681

Inspired by the FreeBSD port lang/rust's Makefile
(BIG thanks to whomever did this!)


This is meant to be used on Rust nightly installed via rustup. 


```
$ git clone https://github.com/johalun/rust-ino64
$ cd rust-ino64
$ ./patch.sh
```
