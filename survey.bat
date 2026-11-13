@echo off
chcp 65001 >nul
cd /d "%~dp0"
if "%~1"=="" (
  echo Usage: survey.bat "D:\path\to\song-library"
  pause
  exit /b 2
)
dotnet run --project "tools\Zaia.Cli" -c Release -- scan "%~1"
pause
