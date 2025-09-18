@echo off
setlocal enabledelayedexpansion
title Configure Server Emulator IP
color 0e

echo ==========================================
echo   BFBC2 Server - Emulator IP Configurator
echo ==========================================
echo.
echo This tool updates only the 'emulator_ip' line
echo inside config.ini. Other settings stay safe.
echo.

REM Ask for new IP
set /p NEW_IP= Enter new IPv4 (e.g. 192.168.1.200): 

if "%NEW_IP%"=="" (
  echo No IP entered. Exiting.
  pause
  exit /b 1
)

REM Find config.ini
set "CFG=config.ini"

if not exist "%CFG%" (
  echo ERROR: config.ini not found! Put this BAT in the same folder.
  pause
  exit /b 2
)

echo Creating backup: "%CFG%.bak"
copy /y "%CFG%" "%CFG%.bak" >nul

REM Rewrite only emulator_ip line
set "TMP=%CFG%.new"

(
  for /f "usebackq tokens=* delims=" %%A in ("%CFG%") do (
    set "line=%%A"
    echo !line! | findstr /b /i "emulator_ip" >nul
    if !errorlevel! == 0 (
      echo emulator_ip = %NEW_IP%
    ) else (
      echo !line!
    )
  )
) > "%TMP%"

move /y "%TMP%" "%CFG%" >nul

echo.
echo ✅ Done! Updated 'emulator_ip' to: %NEW_IP%
echo.
pause
