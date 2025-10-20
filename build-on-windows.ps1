$VERSION = "v4.10.0"

$srcDir = Get-Location
$dstDir = Join-Path $srcDir "output"
$sqlcipherDir = Join-Path $srcDir "sqlcipher"

# ---------------------------------------------------------------------------------------------
# Clone
# ---------------------------------------------------------------------------------------------
Write-Host "Cloning SQLCipher repository..."
git clone -b $VERSION --depth 1 https://github.com/sqlcipher/sqlcipher.git
Set-Location $sqlcipherDir

# ---------------------------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------------------------
$sqlite3dll = "sqlcipher.dll"
$ltlinkopts = "C:\OpenSSL-Win64\lib\VC\x64\MT\libcrypto.lib"
$optFeatureFlagsRaw = @'
-DSQLITE_TEMP_STORE=2
-DSQLITE_HAS_CODEC=1
-DSQLITE_ENABLE_FTS3=1
-DSQLITE_ENABLE_FTS5=1
-DSQLITE_ENABLE_FTS3_PARENTHESIS=1
-DSQLITE_ENABLE_STAT4=1
-DSQLITE_SOUNDEX=1
-DSQLITE_ENABLE_JSON1=1
-DSQLITE_ENABLE_GEOPOLY=1
-DSQLITE_ENABLE_RTREE=1
-DSQLCIPHER_CRYPTO_OPENSSL=1
-DSQLITE_MAX_ATTACHED=125
-IC:\OpenSSL-Win64\include
-DSQLITE_EXTRA_INIT=sqlcipher_extra_init
-DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown
'@
$optFeatureFlags = ($optFeatureFlagsRaw -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ }) -join ' '

# ---------------------------------------------------------------------------------------------
# Windows (x86_64)
# ---------------------------------------------------------------------------------------------
Write-Host "==clean===============================================================`n"
Remove-Item -Force "sqlite3.c" -ErrorAction SilentlyContinue
Remove-Item -Force "sqlcipher.dll" -ErrorAction SilentlyContinue

Write-Host "==sqlite3.c===========================================================`n"
& nmake /f Makefile.msc sqlite3.c USE_AMALGAMATION=1 NO_TCL=1 LTLINKOPTS=$ltlinkopts OPT_FEATURE_FLAGS=$optFeatureFlags
if ($LASTEXITCODE -ne 0) { exit 1 }

# NOTE(pyoung): monkey patch
Write-Host "==update=sqlite3.c====================================================`n"
$typedefLine = "typedef unsigned long long uint64_t;`n"
$content = Get-Content "sqlite3.c" -Raw
Set-Content "sqlite3.c" ($typedefLine + $content)

Write-Host "==sqlcipher.dll=======================================================`n"
& nmake /f Makefile.msc sqlcipher.dll USE_AMALGAMATION=1 NO_TCL=1 SQLITE3DLL=$sqlite3dll LTLINKOPTS=$ltlinkopts OPT_FEATURE_FLAGS=$optFeatureFlags
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "==output==============================================================`n"
Set-Location $srcDir
New-Item -ItemType Directory -Force -Path $dstDir | Out-Null

Copy-Item -Force "$sqlcipherDir\sqlcipher.dll" $dstDir
if ($LASTEXITCODE -ne 0) { exit 1 }

Copy-Item -Force "C:\OpenSSL-Win64\libcrypto-3-x64.dll" $dstDir
if ($LASTEXITCODE -ne 0) { exit 1 }