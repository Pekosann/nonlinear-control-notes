@echo off
REM Usage:  publish "pesan commit"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0publish.ps1" %*
