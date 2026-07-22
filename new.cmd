@echo off
REM Usage:  new "Relative Degree"
REM         new "Relative Degree" -Section "Dasar Teori" -Tags dasar,glc
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0new.ps1" %*
