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
