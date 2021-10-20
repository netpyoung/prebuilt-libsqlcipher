#!/usr/bin/env bash
set -e

# [variable]
VERSION=v4.4.3
ROOT=$(pwd)
DIR_SOURCE=${ROOT}/sqlcipher
DIR_OUTPUT=${ROOT}/output


# [src] libsodium
git clone -b ${VERSION} --depth 1 https://github.com/sqlcipher/sqlcipher.git && cd $DIR_SOURCE


# configure
./configure -enable-tempstore=no --disable-tcl CFLAGS="-DSQLITE_HAS_CODEC -DSQLCIPHER_CRYPTO_OPENSSL"

# compile
make clean
make sqlite3.c
make

# copy
libsqlcipher_fpath=`readlink -f .libs/libsqlcipher.so`
libcrypto_fpath=`readlink -f /usr/lib/x86_64-linux-gnu/libcrypto.so`

mkdir -p ${DIR_OUTPUT}
cp ${libsqlcipher_fpath} ${DIR_OUTPUT}/libsqlcipher.so
cp ${libcrypto_fpath} ${DIR_OUTPUT}/libcrypto.so

# zip -r lib.zip libsodium/.libs/*
ls -al ${DIR_OUTPUT}