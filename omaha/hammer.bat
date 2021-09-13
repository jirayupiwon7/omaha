@echo off

:: Hammer does not need this variable but the unit
:: tests do.
set OMAHA_PSEXEC_DIR=%ProgramFiles(x86)%\pstools

setlocal

rem -- Set all environment variables used by Hammer and Omaha. --

:: VS2003/VC71 is 1310 (not supported by the current build).
:: VS2005/VC80 is 1400 (not supported by the current build).
:: VS2008/VC90 is 1500 (not supported by the current build).
:: VS2010/VC10 is 1600 (not supported by the current build).
:: VS2012/VC11 is 1700 (not supported by the current build).
:: VS2013/VC12 is 1800.
:: VS2015/VC14 is 1900.
:: VS2017/VC14.1 is 1910.
:: VS2019/VC16.0 is 1920.

if "%VisualStudioVersion%"=="" goto error_no_vc
if "%VisualStudioVersion%"=="12.0" goto vc120
if "%VisualStudioVersion%"=="14.0" goto vc140
if "%VisualStudioVersion%"=="15.0" goto vc141
if "%VisualStudioVersion%"=="16.0" goto vc160
goto error_vc_not_supported

:vc120
set OMAHA_MSC_VER=1800
goto set_env_variables

:vc140
set OMAHA_MSC_VER=1900
goto set_env_variables

:vc141
set OMAHA_MSC_VER=1910
goto set_env_variables

:vc160
set OMAHA_MSC_VER=1920
goto set_env_variables

:set_env_variables

:: Change these variables to match the local build environment.

:: Directory where the Go programming language toolchain is installed.
set GOROOT=C:\Go

:: This directory is needed to find protoc.exe, which is the protocol buffer
:: compiler. From the release page https://github.com/google/protobuf/releases,
:: download the zip file protoc-$VERSION-win32.zip. It contains the protoc
:: binary. Unzip the contents under third_party\protoc.
set OMAHA_PROTOBUF_BIN_DIR=%~dp0\..\third_party\protoc\bin

:: This directory is needed to find the protocol buffer source files. From the
:: release page https://github.com/google/protobuf/releases, download the zip
:: file protobuf-cpp-$VERSION.zip. Unzip the contents under
:: third_party\protobuf.
set OMAHA_PROTOBUF_SRC_DIR=%~dp0\..\third_party\protobuf\src

:: Directory where Python (python.exe) is installed.
set OMAHA_PYTHON_DIR=C:\Python27

:: Directory in WiX where candle.exe and light.exe are installed.
set OMAHA_WIX_DIR=%WIX%\bin

:: Root directory of the WTL installation.
set OMAHA_WTL_DIR=%~dp0\..\third_party\wtl

set OMAHA_PLATFORM_SDK_DIR=%WindowsSdkDir%\
set OMAHA_WINDOWS_SDK_10_0_VERSION=%WindowsSDKVersion:~0,-1%

:: Directory which includes the sign.exe tool for Authenticode signing.
set OMAHA_SIGNTOOL_SDK_DIR="%WindowsSdkVerBinPath%\x86"
set PYTHONPATH=%OMAHA_PYTHON_DIR%

:: Directory of Scons (http://www.scons.org/).
set SCONS_DIR=C:\Python27\scons-1.3.1

:: Directory of the Google's Software Construction Toolkit.
set SCT_DIR=%~dp0\..\third_party\swtoolkit

set PROXY_CLSID_TARGET=%~dp0proxy_clsids.txt
set CUSTOMIZATION_UT_TARGET=%~dp0common\omaha_customization_proxy_clsid.h

rem Force Hammer to use Python 2.7
set PYTHON_TO_USE=python_27
call "%SCT_DIR%\hammer.bat" %*

if /i {%1} == {-c} (
  del /q /f "%PROXY_CLSID_TARGET%" 2> NUL
  del /q /f "%CUSTOMIZATION_UT_TARGET%" 2> NUL
)

goto end

:error_no_vc
echo VisualStudioVersion variable is not set. Have you run vcvarsall.bat before running this script?
goto end

:error_vc_not_supported
echo Visual Studio version %VisualStudioVersion% is not supported.
goto end

:end
