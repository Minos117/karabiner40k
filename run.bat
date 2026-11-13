@echo off
cd /d "%~dp0"
if exist "dist\ZaiaKaraoke.exe" goto start
call "%~dp0build_all.bat"
exit /b %errorlevel%
:start
start "" "dist\ZaiaKaraoke.exe"
