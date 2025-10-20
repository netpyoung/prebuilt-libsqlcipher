@ECHO OFF
SETLOCAL

SET VERSION=v4.10.0

SET SRC_DIR=%CD%
SET DST_DIR=%SRC_DIR%\output
SET SQLCIPHER_DIR=%SRC_DIR%\sqlcipher

@REM ---------------------------------------------------------------------------------------------
@REM  Clone
@REM ---------------------------------------------------------------------------------------------
git clone -b %VERSION% --depth 1 https://github.com/sqlcipher/sqlcipher.git
CD sqlcipher

@REM ---------------------------------------------------------------------------------------------
@REM  Config
@REM ---------------------------------------------------------------------------------------------
SET "SQLITE3DLL=sqlcipher.dll"
SET "LTLINKOPTS=C:\OpenSSL-Win64\lib\VC\x64\MT\libcrypto.lib"
SET "OPT_FEATURE_FLAGS="^
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

@REM ---------------------------------------------------------------------------------------------
@REM  Windows            (x86_64)
@REM ---------------------------------------------------------------------------------------------

ECHO ==clean===============================================================
DEL /f /q sqlite3.c
DEL /f /q sqlcipher.dll

ECHO ==sqlite3.c===========================================================
nmake /f Makefile.msc sqlite3.c USE_AMALGAMATION=1 NO_TCL=1 LTLINKOPTS=%LTLINKOPTS% OPT_FEATURE_FLAGS=%OPT_FEATURE_FLAGS% || EXIT /b

ECHO ==update=sqlite3.c====================================================
ECHO typedef unsigned long long uint64_t; > temp.c && type sqlite3.c >> temp.c && move /Y temp.c sqlite3.c

ECHO ==sqlcipher.dll=======================================================
nmake /f Makefile.msc sqlcipher.dll USE_AMALGAMATION=1 NO_TCL=1 SQLITE3DLL=%SQLITE3DLL% LTLINKOPTS=%LTLINKOPTS% OPT_FEATURE_FLAGS=%OPT_FEATURE_FLAGS% || EXIT /b

ECHO ==output==============================================================
CD %SRC_DIR%
MKDIR %DST_DIR%

COPY /Y "%SQLCIPHER_DIR%\sqlcipher.dll" "%DST_DIR%\" || EXIT /b
COPY /Y "C:\OpenSSL-Win64\libcrypto-3-x64.dll" "%DST_DIR%\" || EXIT /b

ENDLOCAL