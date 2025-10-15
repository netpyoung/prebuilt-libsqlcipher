#!/usr/bin/env bash
# ref: https://github.com/jfcontart/SqlCipher4Unity3D_Apple
set -e

#---------------------------------------------------------------------------------------------
# | Platforms            | Arch    |
# | -------------------- | ------- |
# | macOS                | arm64   |
# | macOS                | x86_64  |

# | Platforms            | Arch   |
# | -------------------- | ------ |
# | iOS                  | arm64  |
# | iOS (Simulator)      | arm64 |
# | tvOS                 | arm64  |
# | tvOS (Simulator)     | arm64 |
# | visionOS             | arm64  |
# | visionOS (Simulator) | arm64 |

#---------------------------------------------------------------------------------------------


# [variable]
VERSION=v4.10.0
ROOT=$(pwd)
DIR_SOURCE=${ROOT}/sqlcipher
DIR_OUTPUT=${ROOT}/output

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
-DSQLCIPHER_CRYPTO_CC \
-DSQLITE_EXTRA_INIT=sqlcipher_extra_init \
-DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown \
"

COMPILE_OPTION=" \
--disable-tcl \
--disable-readline \
--enable-threadsafe \
--with-tempstore=yes \
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
# git clone -b ${VERSION} --depth 1 https://github.com/sqlcipher/sqlcipher.git 
cd $DIR_SOURCE

##---------------------------------------------------------------------------------------------
## macOS            (arm64)
##---------------------------------------------------------------------------------------------
echo "============================================================= macOS            (arm64)"
git clean -Xdf

# configure
ARCH=arm64
MACOS_MIN_SDK_VERSION=13.0
HOST="aarch64-apple-darwin"
OS_COMPILER="MacOSX"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"
export SYSROOT="${CROSS_TOP}/SDKs/${CROSS_SDK}"
echo "SYSROOT: ${SYSROOT}"

CFLAGS=" \
-arch ${ARCH}  \
-target arm64-apple-macos \
-isysroot ${ISYSROOT} \
-mmacos-version-min=${MACOS_MIN_SDK_VERSION} \
-I${SYSROOT}/usr/include \
-L${SYSROOT}/usr/lib \
-F${SYSROOT}/System/Library/Frameworks \
"

LDFLAGS="\
-framework Security \
-framework Foundation \
-L${SYSROOT}/usr/lib \
-F${SYSROOT}/System/Library/Frameworks \
"

./configure ${COMPILE_OPTION} --host="$HOST" CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"
sed -i '' 's/#define HAVE_STRCHRNUL 1/#define HAVE_STRCHRNUL 0/' sqlite_cfg.h

# compile
make

# copy
libsqlcipher_fpath=`greadlink -f libsqlite3.dylib`
mkdir -p ${DIR_OUTPUT}/macOS/${ARCH}
cp ${libsqlcipher_fpath} ${DIR_OUTPUT}/macOS/${ARCH}/sqlcipher.dylib


##---------------------------------------------------------------------------------------------
## macOS            (x86_64)
##---------------------------------------------------------------------------------------------
echo "============================================================= macOS            (x86_64)"
git clean -Xdf

# configure
ARCH=x86_64
HOST="x86_64-apple-darwin"
OS_COMPILER="MacOSX"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"
export SYSROOT="${CROSS_TOP}/SDKs/${CROSS_SDK}"
echo "SYSROOT: ${SYSROOT}"

CFLAGS=" \
-arch ${ARCH}  \
-isysroot ${ISYSROOT} \
-mmacos-version-min=10.10 \
-I${SYSROOT}/usr/include \
-L${SYSROOT}/usr/lib \
-F${SYSROOT}/System/Library/Frameworks \
"

LDFLAGS="\
-framework Security \
-framework Foundation \
-L${SYSROOT}/usr/lib \
-F${SYSROOT}/System/Library/Frameworks \
"

# mmacos-version-min, MACOSX_DEPLOYMENT_TARGET?
./configure ${COMPILE_OPTION} --host="$HOST" CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"
sed -i '' 's/#define HAVE_STRCHRNUL 1/#define HAVE_STRCHRNUL 0/' sqlite_cfg.h

# compile
make

# copy
libsqlcipher_fpath=`greadlink -f libsqlite3.dylib`
mkdir -p ${DIR_OUTPUT}/macOS/${ARCH}
cp ${libsqlcipher_fpath} ${DIR_OUTPUT}/macOS/${ARCH}/sqlcipher.dylib


#---------------------------------------------------------------------------------------------
# lipo macOS (arm64, x86_64)
#---------------------------------------------------------------------------------------------
echo "=========================================================== lipo macOS (arm64, x86_64)"

mkdir -p ${DIR_OUTPUT}/macOS/lipo

lipo -create -output ${DIR_OUTPUT}/macOS/lipo/sqlcipher.dylib \
  ${DIR_OUTPUT}/macOS/arm64/sqlcipher.dylib                   \
  ${DIR_OUTPUT}/macOS/x86_64/sqlcipher.dylib

lipo -info ${DIR_OUTPUT}/macOS/lipo/sqlcipher.dylib

#---------------------------------------------------------------------------------------------
# loader_path macOS (arm64, x86_64)
#---------------------------------------------------------------------------------------------
install_name_tool -id @loader_path/sqlcipher.dylib ${DIR_OUTPUT}/macOS/lipo/sqlcipher.dylib


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
export SYSROOT="${CROSS_TOP}/SDKs/${CROSS_SDK}"
echo "SYSROOT: ${SYSROOT}"

CFLAGS="\
-arch ${ARCH} \
-isysroot ${SYSROOT} \
-mios-version-min=${IOS_MIN_SDK_VERSION} \
-F${SYSROOT}/System/Library/Frameworks \
-L${SYSROOT}/usr/lib \
"

LDFLAGS="\
-framework Security \
-framework Foundation \
-F${SYSROOT}/System/Library/Frameworks \
-L${SYSROOT}/usr/lib \
"

./configure ${COMPILE_OPTION} --host="$HOST" CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"
sed -i '' 's/#define HAVE_STRCHRNUL 1/#define HAVE_STRCHRNUL 0/' sqlite_cfg.h

# compile
make clean
make sqlite3.h
make sqlite3ext.h
make libsqlite3.a

# copy
mkdir -p ${DIR_OUTPUT}/iOS/${ARCH}
cp libsqlite3.a ${DIR_OUTPUT}/iOS/${ARCH}/libsqlcipher.a

#---------------------------------------------------------------------------------------------
# iOS (Simulator)  (arm64)
#---------------------------------------------------------------------------------------------
echo "============================================================= iOS (Simulator)  (arm64)"
git clean -Xdf

# configure
ARCH=arm64
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneSimulator"
HOST="arm64-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"
export SYSROOT="${CROSS_TOP}/SDKs/${CROSS_SDK}"
echo "SYSROOT: ${SYSROOT}"

CFLAGS="\
-arch ${ARCH} \
-isysroot ${SYSROOT} \
-mios-simulator-version-min=${IOS_MIN_SDK_VERSION} \
-F${SYSROOT}/System/Library/Frameworks \
-L${SYSROOT}/usr/lib \
"

LDFLAGS="\
-framework Security \
-framework Foundation \
-F${SYSROOT}/System/Library/Frameworks \
-L${SYSROOT}/usr/lib \
"

./configure ${COMPILE_OPTION} --host="$HOST" CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"
sed -i '' 's/#define HAVE_STRCHRNUL 1/#define HAVE_STRCHRNUL 0/' sqlite_cfg.h

# compile
make clean
make sqlite3.h
make sqlite3ext.h
make libsqlite3.a

# copy
mkdir -p ${DIR_OUTPUT}/iOS/sim_${ARCH}
cp libsqlite3.a ${DIR_OUTPUT}/iOS/sim_${ARCH}/libsqlcipher.a

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
export SYSROOT="${CROSS_TOP}/SDKs/${CROSS_SDK}"
echo "SYSROOT: ${SYSROOT}"

CFLAGS="\
-arch ${ARCH} \
-isysroot ${SYSROOT} \
-mtvos-version-min=${TVOS_MIN_SDK_VERSION} \
-F${SYSROOT}/System/Library/Frameworks \
-L${SYSROOT}/usr/lib \
"

LDFLAGS="\
-framework Security \
-framework Foundation \
-F${SYSROOT}/System/Library/Frameworks \
-L${SYSROOT}/usr/lib \
"

./configure ${COMPILE_OPTION} --host="$HOST" CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"
sed -i '' 's/#define HAVE_STRCHRNUL 1/#define HAVE_STRCHRNUL 0/' sqlite_cfg.h

# compile
make clean
make sqlite3.h
make sqlite3ext.h
make libsqlite3.a

# copy
mkdir -p ${DIR_OUTPUT}/tvOS/${ARCH}
cp libsqlite3.a ${DIR_OUTPUT}/tvOS/${ARCH}/libsqlcipher.a

#---------------------------------------------------------------------------------------------
# tvOS (Simulator) (arm64)
#---------------------------------------------------------------------------------------------
echo "============================================================= tvOS (Simulator) (arm64)"
git clean -Xdf

# configure
ARCH=arm64
TVOS_MIN_SDK_VERSION=10.0
OS_COMPILER="AppleTVSimulator"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"
export SYSROOT="${CROSS_TOP}/SDKs/${CROSS_SDK}"
echo "SYSROOT: ${SYSROOT}"

CFLAGS="\
-arch ${ARCH} \
-isysroot ${SYSROOT} \
-mtvos-simulator-version-min=${TVOS_MIN_SDK_VERSION} \
-F${SYSROOT}/System/Library/Frameworks \
-L${SYSROOT}/usr/lib \
"

LDFLAGS="\
-framework Security \
-framework Foundation \
-F${SYSROOT}/System/Library/Frameworks \
-L${SYSROOT}/usr/lib \
"

./configure ${COMPILE_OPTION} --host="$HOST" CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" LDFLAGS="${LDFLAGS}"
sed -i '' 's/#define HAVE_STRCHRNUL 1/#define HAVE_STRCHRNUL 0/' sqlite_cfg.h

# compile
make clean
make sqlite3.h
make sqlite3ext.h
make libsqlite3.a

# copy
mkdir -p ${DIR_OUTPUT}/tvOS/sim_${ARCH}
cp libsqlite3.a ${DIR_OUTPUT}/tvOS/sim_${ARCH}/libsqlcipher.a


#---------------------------------------------------------------------------------------------
# XCFramework
# iOS (arm64, arm64(simulator))
# tvOS (arm64, arm64(simulator))
#---------------------------------------------------------------------------------------------
echo "=================================== XCFramework iOS/tvOS (arm64, arm64(simulator))"

mkdir -p ${DIR_OUTPUT}/iOS/

xcodebuild -create-xcframework \
  -library ${DIR_OUTPUT}/iOS/arm64/libsqlcipher.a                       \
  -library ${DIR_OUTPUT}/iOS/sim_arm64/libsqlcipher.a                   \
  -library ${DIR_OUTPUT}/tvOS/arm64/libsqlcipher.a                      \
  -library ${DIR_OUTPUT}/tvOS/sim_arm64/libsqlcipher.a                  \
  -output ${DIR_OUTPUT}/libsqlcipher.xcframework

plutil -p ${DIR_OUTPUT}/libsqlcipher.xcframework/Info.plist

#---------------------------------------------------------------------------------------------
# sha256
#---------------------------------------------------------------------------------------------
shasum -a 256 ${DIR_OUTPUT}/macOS/lipo/sqlcipher.dylib

shasum -a 256 ${DIR_OUTPUT}/libsqlcipher.xcframework/ios-arm64/libsqlcipher.a
shasum -a 256 ${DIR_OUTPUT}/libsqlcipher.xcframework/ios-arm64-simulator/libsqlcipher.a
shasum -a 256 ${DIR_OUTPUT}/libsqlcipher.xcframework/tvos-arm64/libsqlcipher.a
shasum -a 256 ${DIR_OUTPUT}/libsqlcipher.xcframework/tvos-arm64-simulator/libsqlcipher.a


#---------------------------------------------------------------------------------------------
# print DIR_OUTPUT
find ${DIR_OUTPUT} -not -type d -exec ls -l {} \;
