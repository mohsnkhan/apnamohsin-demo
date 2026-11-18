@echo off
title NovaByte.com local domain setup
cd /d "%~dp0"

net session >nul 2>&1
if %errorlevel%==0 goto run

echo Requesting administrator rights...
powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
exit /b

:run
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\setup-novabyte-domain.ps1"
echo.
pause
