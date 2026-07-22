@echo off
REM Wrapper so you can run this without changing your PowerShell execution policy.
REM Usage:  serve          (or double-click this file)
REM         serve -Port 4001
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0serve.ps1" %*
