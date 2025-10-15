sqlcipher v4.5.6 에서 v4.10.0 변경사항

-enable-tempstore=yes가 --with-tempstore=yes로 이름 변경
--with-crypto-lib 플래그 제거, 대신 -DSQLCIPHER_CRYPTO_* CFLAG 사용.


v4.7.0에서
--enable-threadsafe \
--with-tempstore=yes \


DSQLCIPHER_CRYPTO_CC를 지정하여 CommonCrypto // --with-crypto-lib=commoncrypto \
DSQLCIPHER_CRYPTO_OPENSSL
DSQLCIPHER_CRYPTO_LIBTOMCRYPT
DSQLCIPHER_CRYPTO_CUSTOM
DSQLCIPHER_CRYPTO_NSS - Mozilla의 Network Security Services(NSS)
SQLCIPHER_CRYPTO_MBEDTLS - mbedTLS(구 PolarSSL)
SQLCIPHER_CRYPTO_NONE


DSQLITE_THREADSAFE // --enable-threadsafe=yes \
- https://www.sqlite.org/threadsafe.html
- https://www.sqlite.org/compile.html#threadsafe

SQLITE_EXTRA_INIT=sqlcipher_extra_init
SQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown


 || { echo "fail"; false; }
 
## android

- https://www.zetetic.net/sqlcipher/sqlcipher-for-android/

- maven
  - 4.5.2 ~ 
    - https://mvnrepository.com/artifact/net.zetetic/sqlcipher-android
  - 3.3.1 ~ 4.5.4
    - https://mvnrepository.com/artifact/net.zetetic/android-database-sqlcipher
  

  
  - https://greenday96.blogspot.com/2025/06/sqlcipher-windows-build.html
  - https://github.com/sqlitebrowser/sqlitebrowser/blob/master/.github/workflows/cppcmake-windows.yml

## ios

https://github.com/netpyoung/SqlCipher4Unity3D/issues/52

- XCode > Build Settings > Linking General > Other Linker Flags
  - add : `-Wl,-undefined,dynamic_lookup`

|                |                                                                                   |
| -------------- | --------------------------------------------------------------------------------- |
| -Wl            | 컴파일러(gcc 또는 clang)에서 링커(ld)로 직접 플래그를 전달하도록 지시.            |
| -undefined     | 링커가 정의되지 않은 심볼(undefined symbols)을 처리하는 방식을 지정.              |
| dynamic_lookup | 정의되지 않은 심볼을 빌드 타임에 검사하지 않고, 런타임에 동적으로 확인하도록 설정 |



// https://sqlite.org/c3ref/column_database_name.html
// https://sqlite.org/compile.html - SQLITE_ENABLE_COLUMN_METADATA
Undefined symbol: _sqlite3_column_database_name
Undefined symbol: _sqlite3_column_database_name16
Undefined symbol: _sqlite3_column_origin_name
Undefined symbol: _sqlite3_column_origin_name16
Undefined symbol: _sqlite3_column_table_name
Undefined symbol: _sqlite3_column_table_name16

// https://www.sqlite.org/c3ref/mutex_held.html
Undefined symbol: _sqlite3_mutex_held
Undefined symbol: _sqlite3_mutex_notheld


// https://sqlite.org/compile.html - SQLITE_ENABLE_SNAPSHOT
Undefined symbol: _sqlite3_snapshot_cmp
Undefined symbol: _sqlite3_snapshot_free
Undefined symbol: _sqlite3_snapshot_get
Undefined symbol: _sqlite3_snapshot_open
Undefined symbol: _sqlite3_snapshot_recover

// --enable-stmt-scanstatus
// https://sqlite.org/compile.html - SQLITE_ENABLE_STMT_SCANSTATUS
Undefined symbol: _sqlite3_stmt_scanstatus
Undefined symbol: _sqlite3_stmt_scanstatus_reset
Undefined symbol: _sqlite3_stmt_scanstatus_v2

// https://sqlite.org/c3ref/unlock_notify.html
Undefined symbol: _sqlite3_unlock_notify

--enable-rtree
// https://sqlite.org/compile.html - SQLITE_ENABLE_RTREE
Undefined symbol: _sqlite3_rtree_geometry_callback
Undefined symbol: _sqlite3_rtree_query_callback

Windows 전용
Undefined symbol: _sqlite3_win32_set_directory
Undefined symbol: _sqlite3_win32_set_directory16
Undefined symbol: _sqlite3_win32_set_directory8


macOS 15.4 - strchrnul
Checking for strchrnul...ok
sed -i '' 's/#define HAVE_STRCHRNUL 1/#define HAVE_STRCHRNUL 0/' sqlite_cfg.h
nm - display name list (symbol table)
  -g     Display only global (external) symbols.
nm -g lipo/sqlcipher.dylib | grep strchrnul


-mmacos-version-min
-mios-version-min
-mios-simulator-version-min
-mtvos-version-min
-mtvos-simulator-version-min
-mxros-version-min # 비전OS
-mxros-simulator-version-min


- arm에도 여러개가 있는데 arm64만 하면 될듯
  - armv6 
  - armv7
  - armv7s
  - armv8
  - arm64
  - arm64e 


bundle -> dylib
Unity 공식 문서와 포럼에서도 .bundle 형식을 macOS 플러그인으로 권장했으며
.dylib의 안정적인 지원은 Unity 2019.3부터 시작되었으며, Unity 2020.1 이후로 완전히 문제없이 사용할 수 있습니다.

lipo
lipo -create -output ${DIR_OUTPUT}/macOS/lipo/sqlcipher.bundle \
  ${DIR_OUTPUT}/macOS/arm64/sqlcipher.bundle                   \
  ${DIR_OUTPUT}/macOS/x86_64/sqlcipher.bundle
lipo -info ${DIR_OUTPUT}/macOS/lipo/sqlcipher.bundle
https://developer.apple.com/documentation/apple-silicon/building-a-universal-macos-binary
https://ss64.com/mac/lipo.html
“lipo” = “liposuction (지방흡입)” → fat binary에서 지방(fat)을 흡입(thin)한다 😄
iOS용과 iOS-simulator용을 같은 아키텍처라도 병합할 수 없게됨.
-  CPUARCHOPT란것도 있는데 lipo 랑 비슷한 역활.
   -  [MacOS Apple Silicon 에서 universal binary 만들기](https://rageworx.pe.kr/1959)

XCFramework
https://developer.apple.com/documentation/xcode/creating-a-multi-platform-binary-framework-bundle
xcodebuild -create-xcframework \
  -library ios/libMy.a \
  -library ios-simulator/libMy.a \
  -output MyLib.xcframework
plutil -p MyLib.xcframework/Info.plist

loader_path
install_name_tool -id @loader_path/sqlcipher.dylib ${DIR_OUTPUT}/macOS/${ARCH}/sqlcipher.dylib
otool -L macOS/arm64/sqlcipher.dylib
@rpath - runpath search path
@loader_path
@executable_path



macos역시 xcframework로 하려고 하는데, 폴더에 있어서 그런지 못불러오네
mkdir -p ${DIR_OUTPUT}/macOS/

xcodebuild -create-xcframework \
  -library ${DIR_OUTPUT}/macOS/arm64/sqlcipher.dylib \
  -output ${DIR_OUTPUT}/macOS/sqlcipher-dynamic.xcframework

plutil -p ${DIR_OUTPUT}/macOS/sqlcipher-dynamic.xcframework/Info.plist


TBD 파일은 macOS의 Xcode 개발 환경에서 사용하는 텍스트 기반 동적 라이브러리 스텁(Text-based Dynamic Library Stub) 파일입니다. 이는 .dylib 파일(실제 바이너리 라이브러리)을 텍스트 형식으로 요약한 버전으로, Xcode가 앱을 빌드할 때 링커(연결기)가 필요한 심볼과 정보를 참조할 수 있게 해줍니다.