@echo off
REM Save the clipboard image into figures\ and copy its Markdown line back to
REM the clipboard, ready to Ctrl+V into a note.
REM Usage:  paste "skema dua cstr"
REM         paste "skema dua cstr" -Caption "Gambar 1. Dua CSTR seri."
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0paste.ps1" %*
