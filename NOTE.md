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
  

  