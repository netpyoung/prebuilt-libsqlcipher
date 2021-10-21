#!/usr/bin/env bash
# ref: https://github.com/jfcontart/SqlCipher4Unity3D_Apple
set -e

#---------------------------------------------------------------------------------------------
# | Platforms        | Arch   | action? |
# | ---------------- | ------ | ------- |
# | macOS            | x86_64 | o       |
# | macOS            | arm64  | x       |
# | iOS              | armv7  | o       |
# | iOS              | armv7s | o       |
# | iOS              | arm64  | o       |
# | iOS (Simulator)  | x86_64 | o       |
# | tvOS             | arm64  | o       |
# | tvOS (Simulator) | x86_64 | o       |
#
# lipo iOS (armv7, armv7s, arm64, x86_64(simulator))
# lipo tvOS(               arm64, x86_64(simulator))
#
# armv6 
# armv7
# armv7s 
# armv8
# arm64
# arm64e 
#---------------------------------------------------------------------------------------------


# [variable]
VERSION=v4.4.3
ROOT=$(pwd)
DIR_SOURCE=${ROOT}/sqlcipher
DIR_OUTPUT=${ROOT}/output

#---------------------------------------------------------------------------------------------
# Config
#---------------------------------------------------------------------------------------------

SQLITE_CFLAGS=" \
-DSQLITE_HAS_CODEC \
-DSQLITE_THREADSAFE=1 \
-DSQLITE_TEMP_STORE=2 \
"

LDFLAGS="\
-framework Security \
-framework Foundation \
"

COMPILE_OPTION=" \
--with-pic \
--disable-tcl \
--enable-tempstore=yes \
--enable-threadsafe=yes \
--with-crypto-lib=commoncrypto \
"

#---------------------------------------------------------------------------------------------
# for Apple©
#---------------------------------------------------------------------------------------------
DEVELOPER=$(xcode-select -print-path)
TOOLCHAIN_BIN="${DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin"
export CC="${TOOLCHAIN_BIN}/clang"
export AR="${TOOLCHAIN_BIN}/ar"
export RANLIB="${TOOLCHAIN_BIN}/ranlib"
export STRIP="${TOOLCHAIN_BIN}/strip"
export LIBTOOL="${TOOLCHAIN_BIN}/libtool"
export NM="${TOOLCHAIN_BIN}/nm"
export LD="${TOOLCHAIN_BIN}/ld"

# [src] libsodium
git clone -b ${VERSION} --depth 1 https://github.com/sqlcipher/sqlcipher.git && cd $DIR_SOURCE



##---------------------------------------------------------------------------------------------
## macOS            (arm64)
##---------------------------------------------------------------------------------------------
echo "============================================================= macOS            (arm64)"
git clean -Xdf

# configure
ARCH=arm64
HOST="aarch64-apple-darwin"

ln -s /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Security.framework/Versions/A/Headers/ Security
ln -s /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/CoreFoundation.framework/Versions/A/Headers/ CoreFoundation

ISYSROOT=`xcrun --sdk macosx --show-sdk-path`

CFLAGS=" \
-arch ${ARCH}  \
-target arm64-apple-macos \
-isysroot ${ISYSROOT} \
-mmacos-version-min=13.0 \
-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include \
"

# mmacos-version-min, MACOSX_DEPLOYMENT_TARGET?
./configure ${COMPILE_OPTION} --host="$HOST" CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"

# compile
make


# cleanup
unlink Security
unlink CoreFoundation

# copy
# cp ./tmp/${VERSION}/sqlcipher-${VERSION}/.libs/libsqlcipher.0.dylib ./${VERSION}/macOS/sqlcipher.bundle
libsqlcipher_fpath=`greadlink -f .libs/libsqlcipher.dylib`
mkdir -p ${DIR_OUTPUT}/macOS/${ARCH}
cp ${libsqlcipher_fpath} ${DIR_OUTPUT}/macOS/${ARCH}/sqlcipher.bundle

lipo -info ${DIR_OUTPUT}/macOS/${ARCH}/sqlcipher.bundle

file ${DIR_OUTPUT}/macOS/${ARCH}/sqlcipher.bundle

#---------------------------------------------------------------------------------------------
# print DIR_OUTPUT
find ${DIR_OUTPUT} -not -type d -exec ls -l {} \;