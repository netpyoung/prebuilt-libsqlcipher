@echo off
setlocal

set VERSION=v4.10.0
git clone -b %VERSION% --depth 1 https://github.com/sqlcipher/sqlcipher.git

set "SQLITE3DLL=sqlcipher.dll"
set "LTLINKOPTS=C:\OpenSSL-Win64\lib\VC\x64\MT\libcrypto.lib"
set "OPT_FEATURE_FLAGS="^
-DSQLITE_TEMP_STORE=2 ^
-DSQLITE_HAS_CODEC=1 ^
-DSQLITE_ENABLE_FTS3=1 ^
-DSQLITE_ENABLE_FTS5=1 ^
-DSQLITE_ENABLE_FTS3_PARENTHESIS=1 ^
-DSQLITE_ENABLE_STAT4=1 ^
-DSQLITE_SOUNDEX=1 ^
-DSQLITE_ENABLE_JSON1=1 ^
-DSQLITE_ENABLE_GEOPOLY=1 ^
-DSQLITE_ENABLE_RTREE=1 ^
-DSQLCIPHER_CRYPTO_OPENSSL=1 ^
-DSQLITE_MAX_ATTACHED=125 ^
-IC:\OpenSSL-Win64\include ^
-DSQLITE_EXTRA_INIT=sqlcipher_extra_init ^
-DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown ^
""

echo ==clean===============================================================
del /f /q sqlite3.c
del /f /q sqlcipher.dll

echo ==sqlite3.c===========================================================
nmake /f Makefile.msc sqlite3.c USE_AMALGAMATION=1 NO_TCL=1 LTLINKOPTS=%LTLINKOPTS% OPT_FEATURE_FLAGS=%OPT_FEATURE_FLAGS% || exit /b

echo ==update=sqlite3.c====================================================
echo typedef unsigned long long uint64_t; > temp.c && type sqlite3.c >> temp.c && move /Y temp.c sqlite3.c

echo ==sqlcipher.dll=======================================================
nmake /f Makefile.msc sqlcipher.dll USE_AMALGAMATION=1 NO_TCL=1 SQLITE3DLL=%SQLITE3DLL% LTLINKOPTS=%LTLINKOPTS% OPT_FEATURE_FLAGS=%OPT_FEATURE_FLAGS% || exit /b

echo ==output==============================================================
set SRC_DIR=%CD%
set OUTPUT_DIR=%SRC_DIR%\output
copy /Y "%SRC_DIR%\sqlcipher.dll" "%OUTPUT_DIR%\"
copy /Y "C:\OpenSSL-Win64\libcrypto-3-x64.dll" "%OUTPUT_DIR%\"

endlocal

