echo on
SetLocal EnableDelayedExpansion

REM This is the recommended way to choose the toolchain version, according to
REM Appveyor's documentation.
SET PATH=C:\Program Files (x86)\MSBuild\%TOOLCHAIN_VERSION%\Bin;%PATH%

set VCVARSALL="C:\Program Files (x86)\Microsoft Visual Studio %TOOLCHAIN_VERSION%\VC\vcvarsall.bat"
set MSVCYEAR=vs2015
set MSVCVERSION=v140

if [%Platform%] NEQ [x64] goto win32
set TARGET_ARCH=x86_64
set TARGET_PROGRAM_FILES=%ProgramFiles%
rem call %VCVARSALL% amd64
rem if %ERRORLEVEL% NEQ 0 exit 1
goto download

:win32
echo on
if [%Platform%] NEQ [Win32] exit 1
set TARGET_ARCH=i686
set TARGET_PROGRAM_FILES=%ProgramFiles(x86)%
rem call %VCVARSALL% amd64_x86
rem if %ERRORLEVEL% NEQ 0 exit 1
goto download

:download
REM vcvarsall turns echo off
echo on

cd %ORIGINAL_PATH%

cd ..
echo on

link /?
cl /?
rustc --version
cargo --version

set RUST_BACKTRACE=1

cargo build --all
cargo test --all
cargo run --manifest-path vcpkg_cli\Cargo.toml -- probe sqlite3
cargo run --manifest-path systest\Cargo.toml 
