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
## macOS            (x86_64)
##---------------------------------------------------------------------------------------------
echo "============================================================= macOS            (x86_64)"
# CPUARCHOPT? [MacOS Apple Silicon 에서 universal binary 만들기](https://rageworx.pe.kr/1959)
git clean -Xdf

# configure
ARCH=x86_64
HOST="x86_64-apple-darwin"

ln -s /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Security.framework/Versions/A/Headers/ Security
ln -s /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/CoreFoundation.framework/Versions/A/Headers/ CoreFoundation

CFLAGS=" \
-arch ${ARCH}  \
-mmacos-version-min=10.10 \
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

#---------------------------------------------------------------------------------------------
# macOS            (arm64)
#---------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------
# iOS              (armv7)
#---------------------------------------------------------------------------------------------
echo "============================================================= iOS              (armv7) "
git clean -Xdf

# configure
ARCH=armv7
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
-fembed-bitcode \
-arch ${ARCH} \
-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
-mios-version-min=${IOS_MIN_SDK_VERSION} \
"

./configure ${COMPILE_OPTION} --host="$HOST" CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"


# compile
make clean
make sqlite3.h
make sqlite3ext.h
make libsqlcipher.la

# copy
mkdir -p ${DIR_OUTPUT}/iOS/${ARCH}
cp .libs/libsqlcipher.a ${DIR_OUTPUT}/iOS/${ARCH}/libsqlcipher.a

#---------------------------------------------------------------------------------------------
# iOS              (armv7s)
#---------------------------------------------------------------------------------------------
echo "============================================================= iOS              (armv7s)"
git clean -Xdf

# configure
ARCH=armv7s
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
-fembed-bitcode \
-arch ${ARCH} \
-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
-mios-version-min=${IOS_MIN_SDK_VERSION} \
"

./configure ${COMPILE_OPTION} --host="$HOST" CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"

# compile
make clean
make sqlite3.h
make sqlite3ext.h
make libsqlcipher.la

# copy
mkdir -p ${DIR_OUTPUT}/iOS/${ARCH}
cp .libs/libsqlcipher.a ${DIR_OUTPUT}/iOS/${ARCH}/libsqlcipher.a


#---------------------------------------------------------------------------------------------
# iOS              (arm64)
#---------------------------------------------------------------------------------------------
echo "============================================================= iOS              (arm64) "
git clean -Xdf

# configure
ARCH=arm64
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
-fembed-bitcode \
-arch ${ARCH} \
-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
-mios-version-min=${IOS_MIN_SDK_VERSION} \
"

./configure ${COMPILE_OPTION} --host="$HOST" CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"

# compile
make clean
make sqlite3.h
make sqlite3ext.h
make libsqlcipher.la

# copy
mkdir -p ${DIR_OUTPUT}/iOS/${ARCH}
cp .libs/libsqlcipher.a ${DIR_OUTPUT}/iOS/${ARCH}/libsqlcipher.a

#---------------------------------------------------------------------------------------------
# iOS (Simulator)  (x86_64)
#---------------------------------------------------------------------------------------------
echo "============================================================= iOS (Simulator)  (x86_64)"
git clean -Xdf

# configure
ARCH=x86_64
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneSimulator"
HOST="x86_64-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
-fembed-bitcode \
-arch ${ARCH} \
-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
-mios-version-min=${IOS_MIN_SDK_VERSION} \
"

./configure ${COMPILE_OPTION} --host="$HOST" CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"

# compile
make clean
make sqlite3.h
make sqlite3ext.h
make libsqlcipher.la

# copy
mkdir -p ${DIR_OUTPUT}/iOS/${ARCH}
cp .libs/libsqlcipher.a ${DIR_OUTPUT}/iOS/${ARCH}/libsqlcipher.a

#---------------------------------------------------------------------------------------------
# lipo iOS (armv7, armv7s, arm64, x86_64(simulator))
#---------------------------------------------------------------------------------------------
echo "=================================== lipo iOS (armv7, armv7s, arm64, x86_64(simulator))"

mkdir -p ${DIR_OUTPUT}/iOS/lipo

lipo -create -output ${DIR_OUTPUT}/iOS/lipo/libsqlcipher.a     \
  ${DIR_OUTPUT}/iOS/armv7/libsqlcipher.a                       \
  ${DIR_OUTPUT}/iOS/armv7s/libsqlcipher.a                      \
  ${DIR_OUTPUT}/iOS/arm64/libsqlcipher.a                       \
  ${DIR_OUTPUT}/iOS/x86_64/libsqlcipher.a

lipo -info ${DIR_OUTPUT}/iOS/lipo/libsqlcipher.a





#---------------------------------------------------------------------------------------------
# tvOS             (arm64)
#---------------------------------------------------------------------------------------------
echo "============================================================= tvOS             (arm64)"
git clean -Xdf

# configure
ARCH=arm64
TVOS_MIN_SDK_VERSION=10.0
OS_COMPILER="AppleTVOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
-fembed-bitcode \
-arch ${ARCH} \
-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
-mtvos-version-min=${TVOS_MIN_SDK_VERSION} \
"
./configure ${COMPILE_OPTION} --host="$HOST" CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"

# compile
make clean
make sqlite3.h
make sqlite3ext.h
make libsqlcipher.la

# copy
mkdir -p ${DIR_OUTPUT}/tvOS/${ARCH}
cp .libs/libsqlcipher.a ${DIR_OUTPUT}/tvOS/${ARCH}/libsqlcipher.a

#---------------------------------------------------------------------------------------------
# tvOS (Simulator) (x86_64)
#---------------------------------------------------------------------------------------------
echo "============================================================= tvOS (Simulator) (x86_64)"
git clean -Xdf

# configure
ARCH=x86_64
TVOS_MIN_SDK_VERSION=10.0
OS_COMPILER="AppleTVSimulator"
HOST="x86_64-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
-arch ${ARCH} \
-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
-mtvos-version-min=${TVOS_MIN_SDK_VERSION} \
"

./configure ${COMPILE_OPTION} --host="$HOST" CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"

# compile
make clean
make sqlite3.h
make sqlite3ext.h
make libsqlcipher.la

# copy
mkdir -p ${DIR_OUTPUT}/tvOS/${ARCH}
cp .libs/libsqlcipher.a ${DIR_OUTPUT}/tvOS/${ARCH}/libsqlcipher.a

#---------------------------------------------------------------------------------------------
# lipo tvOS(               arm64, x86_64(simulator))
#---------------------------------------------------------------------------------------------
echo "=================================== lipo tvOS(               arm64, x86_64(simulator))"
mkdir -p ${DIR_OUTPUT}/tvOS/lipo

lipo -create -output ${DIR_OUTPUT}/tvOS/lipo/libsqlcipher.a     \
  ${DIR_OUTPUT}/tvOS/arm64/libsqlcipher.a                       \
  ${DIR_OUTPUT}/tvOS/x86_64/libsqlcipher.a

lipo -info ${DIR_OUTPUT}/tvOS/lipo/libsqlcipher.a






#---------------------------------------------------------------------------------------------
# print DIR_OUTPUT
find ${DIR_OUTPUT} -not -type d -exec ls -l {} \;