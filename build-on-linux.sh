#!/usr/bin/env bash
set -e

# [variable]
VERSION=v4.10.0
ROOT=$(pwd)
DIR_SOURCE=${ROOT}/sqlcipher
DIR_OUTPUT=${ROOT}/output

##---------------------------------------------------------------------------------------------
## Clone
##---------------------------------------------------------------------------------------------

# [src] libsodium
git clone -b ${VERSION} --depth 1 https://github.com/sqlcipher/sqlcipher.git
cd $DIR_SOURCE

#---------------------------------------------------------------------------------------------
# Config
#---------------------------------------------------------------------------------------------

SQLITE_CFLAGS=" \
-fPIC \
-DPIC \
-DNDEBUG \
-DSQLITE_HAS_CODEC \
-DSQLITE_THREADSAFE=1 \
-DSQLITE_TEMP_STORE=2 \
-DSQLCIPHER_CRYPTO_OPENSSL \
-DSQLITE_EXTRA_INIT=sqlcipher_extra_init \
-DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown \
"

LDFLAGS=" \
-lcrypto \
"

COMPILE_OPTION=" \
--disable-tcl \
--disable-readline \
--enable-threadsafe \
--with-tempstore=yes \
"

##---------------------------------------------------------------------------------------------
## Linux            (x86_64)
##---------------------------------------------------------------------------------------------
echo "============================================================= Linux            (x86_64)"

# configure
echo ./configure ${COMPILE_OPTION} CFLAGS="${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"
./configure ${COMPILE_OPTION} CFLAGS="${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"

# compile
make clean
make sqlite3.c
make

# copy
libsqlcipher_fpath=`readlink -f libsqlite3.so`
libcrypto_fpath=`readlink -f /usr/lib/x86_64-linux-gnu/libcrypto.so`

mkdir -p ${DIR_OUTPUT}
cp ${libsqlcipher_fpath} ${DIR_OUTPUT}/libsqlcipher.so
cp ${libcrypto_fpath} ${DIR_OUTPUT}/libcrypto.so

# zip -r lib.zip libsodium/.libs/*
ls -al ${DIR_OUTPUT}