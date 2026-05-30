@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "DIST_DIR=%SCRIPT_DIR%dist"
set "PACKAGE_PATTERN=mcp-experto-codebase.v*.tar.gz"

where py >nul 2>nul
if %errorlevel%==0 (
  set "PY_CMD=py -3"
) else (
  where python >nul 2>nul
  if %errorlevel%==0 (
    set "PY_CMD=python"
  ) else (
    set "PY_CMD="
  )
)

if not defined PY_CMD (
  echo [warn] Python 3.11+ not found.
  where winget >nul 2>nul
  if %errorlevel%==0 (
    echo [info] Trying automatic Python installation via winget...
    winget install --id Python.Python.3.11 -e --silent
    where py >nul 2>nul
    if %errorlevel%==0 set "PY_CMD=py -3"
    if not defined PY_CMD (
      where python >nul 2>nul
      if %errorlevel%==0 set "PY_CMD=python"
    )
  )
)

if not defined PY_CMD (
  echo [error] Could not install Python automatically.
  echo Install Python 3.11+ from https://www.python.org/downloads/windows/
  exit /b 1
)

%PY_CMD% -c "import sys; raise SystemExit(0 if sys.version_info >= (3,11) else 1)"
if errorlevel 1 (
  echo [error] Python 3.11+ is required.
  exit /b 1
)

echo [ok] Python runtime validated.

if defined LOCALAPPDATA (
  set "TARGET_DIR=%LOCALAPPDATA%\mcp-experto-codebase"
) else (
  set "TARGET_DIR=%USERPROFILE%\.local\mcp-experto-codebase"
)

if not exist "%DIST_DIR%" (
  echo [error] Distribution directory not found: %DIST_DIR%
  exit /b 1
)

set "ARCHIVE_PATH="
for %%F in ("%DIST_DIR%\%PACKAGE_PATTERN%") do (
  if not defined ARCHIVE_PATH set "ARCHIVE_PATH=%%~fF"
)

if not defined ARCHIVE_PATH (
  echo [error] No package found in %DIST_DIR%
  echo Run installer\build-dist.sh first.
  exit /b 1
)

set "STAGING_DIR=%TEMP%\mcp-experto-codebase-install-%RANDOM%%RANDOM%"
mkdir "%STAGING_DIR%" >nul 2>nul
if errorlevel 1 (
  echo [error] Failed to create staging directory.
  exit /b 1
)

echo [info] Extracting package...
tar -xf "%ARCHIVE_PATH%" -C "%STAGING_DIR%"
if errorlevel 1 (
  echo [error] Failed to extract archive.
  rmdir /s /q "%STAGING_DIR%" >nul 2>nul
  exit /b 1
)

set "PACKAGE_ROOT=%STAGING_DIR%\mcp-experto-codebase"
if not exist "%PACKAGE_ROOT%" (
  echo [error] Invalid package contents.
  rmdir /s /q "%STAGING_DIR%" >nul 2>nul
  exit /b 1
)

mkdir "%TARGET_DIR%" >nul 2>nul
if errorlevel 1 (
  echo [error] Failed to create target directory: %TARGET_DIR%
  rmdir /s /q "%STAGING_DIR%" >nul 2>nul
  exit /b 1
)

if exist "%TARGET_DIR%\src" rmdir /s /q "%TARGET_DIR%\src"
if exist "%TARGET_DIR%\install" rmdir /s /q "%TARGET_DIR%\install"
if exist "%TARGET_DIR%\installer" rmdir /s /q "%TARGET_DIR%\installer"

xcopy /E /I /Y "%PACKAGE_ROOT%\src" "%TARGET_DIR%\src" >nul
xcopy /E /I /Y "%PACKAGE_ROOT%\install" "%TARGET_DIR%\install" >nul
xcopy /E /I /Y "%PACKAGE_ROOT%\installer" "%TARGET_DIR%\installer" >nul
copy /Y "%PACKAGE_ROOT%\pyproject.toml" "%TARGET_DIR%\pyproject.toml" >nul
copy /Y "%PACKAGE_ROOT%\README.md" "%TARGET_DIR%\README.md" >nul

echo [ok] Installation complete at %TARGET_DIR%
echo If uv is installed, run:
echo   uv --directory "%TARGET_DIR%" sync --extra retrieval --no-dev
echo   uv --directory "%TARGET_DIR%" run python -m server

rmdir /s /q "%STAGING_DIR%" >nul 2>nul
exit /b 0
