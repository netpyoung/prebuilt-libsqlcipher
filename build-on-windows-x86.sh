#!/usr/bin/env bash
# set -e

# export CC=i686-w64-mingw32-gcc     # x86
# export CC_FOR_windows_amd64=x86_64-w64-mingw32-gcc # x86_64

# export CXX=i686-w64-mingw32-g++     # x86
# export CXX_FOR_windows_amd64=x86_64-w64-mingw32-g++ # x86_64

# /mingw32/bin #x86
# /mingw64/bin #x86_64


# [variable]
VERSION=v4.4.3
ROOT=$(pwd)
DIR_SOURCE=${ROOT}/sqlcipher
DIR_OUTPUT=${ROOT}/output


# [src] libsodium
git clone -b ${VERSION} --depth 1 https://github.com/sqlcipher/sqlcipher.git && cd $DIR_SOURCE

# dependency(openssl)
# /c/PROGRA~1 # Program Files
# /c/PROGRA~2 # Program Files (x86)
## choco install openssl -y --x86   # C:\OpenSSL-Win32 # x86    
## choco install openssl -y         # C:\OpenSSL-Win64 # x86_64 
## C:\OpenSSL-Win32\bin\libcrypto-1_1.dll     # x86
## C:\OpenSSL-Win32\bin\libcrypto-1_1-x64.dll # x86_64

# open_ssl_dir=/d/OpenSSL-Win64                                # x86_64
# libcrypto_fpath=${open_ssl_dir}/bin/libcrypto-1_1-x64.dll    # x86_64

# open_ssl_dir=/d/OpenSSL-Win32                                # x86
open_ssl_dir='/c/PROGRA~2/OpenSSL-Win32'
libcrypto_fpath=${open_ssl_dir}/bin/libcrypto-1_1.dll        # x86

sed -i 's/for ac_option in --version -v -V -qversion; do/for ac_option in --version -v; do/' configure


# msys
## pacman --noconfirm --needed -Syu
## pacman --noconfirm --needed -S git
## pacman --noconfirm --needed -S base-devel
## pacman --noconfirm --needed -S mingw32/mingw-w64-i686-gcc     # x86
## pacman --noconfirm --needed -S mingw64/mingw-w64-x86_64-gcc   # x86_64
## pacman --noconfirm --needed -S tcl

# configure
# ./configure --with-crypto-lib=none --disable-tcl CFLAGS="-DSQLITE_HAS_CODEC -DSQLCIPHER_CRYPTO_OPENSSL -I#{open_ssl_dir}/include #{open_ssl_dir}/bin/libcrypto-1_1-x64.dll -L#{pwd} -static-libgcc" LDFLAGS="-llibcrypto-1_1-x64"
cp ${libcrypto_fpath} ./
ls -al libcrypto-1_1.dll
./configure --with-pic --disable-tcl --enable-tempstore=yes --enable-threadsafe=yes --with-crypto-lib=none CFLAGS="-DSQLITE_HAS_CODEC -DSQLITE_TEMP_STORE=2 -DSQLITE_THREADSAFE=1 -DSQLCIPHER_CRYPTO_OPENSSL -I${open_ssl_dir}/include -static-libgcc ${libcrypto_fpath}" LDFLAGS="-lcrypto-1_1 -L${open_ssl_dir}/bin -L${DIR_SOURCE}"

echo "======================================================"
cat config.log
echo "======================================================"

# compile
make clean
make sqlite3.c
make
make dll

# copy
libsqlcipher_fpath=sqlite3.dll

ls -al

mkdir -p ${DIR_OUTPUT}
cp ${libsqlcipher_fpath} ${DIR_OUTPUT}/sqlcipher.dll
cp ${libcrypto_fpath}    ${DIR_OUTPUT}/libcrypto-1_1.dll

ls -al ${DIR_OUTPUT}

# zip -r lib.zip libsodium/.libs/*
