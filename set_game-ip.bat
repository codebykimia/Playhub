@echo off
setlocal enabledelayedexpansion
title Configure Game Server IP (BFBC2)
color 0a

echo ===============================================
echo      BFBC2 - Game Server IP Configurator
echo ===============================================
echo.
echo This tool updates the 'host=' line inside bfbc2.ini
echo (client connect IP). No other settings are modified.
echo.

REM Ask for the new IP
set /p NEW_IP= Enter new IPv4 (e.g. 192.168.1.100): 

if "%NEW_IP%"=="" (
  echo No IP entered. Exiting.
  pause
  exit /b 1
)

REM Try to locate bfbc2.ini - prefer current directory
set "CFG=bfbc2.ini"

if not exist "%CFG%" (
  echo bfbc2.ini not found in current folder. Searching subfolders...
  for /r %%F in (bfbc2.ini) do (
    set "CFG=%%~fF"
    goto :found
  )
  echo ERROR: Could not find bfbc2.ini. Put this BAT next to bfbc2.ini and run again.
  pause
  exit /b 2
)

:found
echo Using config: "%CFG%"
echo Creating backup: "%CFG%.bak"
copy /y "%CFG%" "%CFG%.bak" >nul

REM Rewrite file: only replace line that begins with host=
set "TMP=%CFG%.new"

(
  for /f "usebackq tokens=* delims=" %%A in ("%CFG%") do (
    set "line=%%A"
    echo !line! | findstr /b /i "host=" >nul
    if !errorlevel! == 0 (
      echo host=%NEW_IP%
    ) else (
      echo !line!
    )
  )
) > "%TMP%"

move /y "%TMP%" "%CFG%" >nul

echo.
echo ✅ Done! Updated 'host=' to: %NEW_IP%
echo.
echo Press any key to close...
pause >nul