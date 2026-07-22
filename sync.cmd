@echo off
REM Regenerate front matter, sidebar and tag pages from notes\*.md.
REM Usage:  sync          (write changes)
REM         sync -Check   (report only, change nothing)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\sync.ps1" %*
