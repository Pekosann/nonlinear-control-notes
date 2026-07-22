<#
.SYNOPSIS
  Sync the notes, then serve the site at http://127.0.0.1:4000 with live rebuild.
  Ctrl+C to stop. Edits to notes\*.md rebuild automatically; edits to _config.yml
  or new files need a restart.
#>
[CmdletBinding()]
param([int]$Port = 4000, [switch]$NoSync)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
if (Test-Path 'C:\Ruby33-x64\bin') { $env:Path = 'C:\Ruby33-x64\bin;' + $env:Path }

if (-not $NoSync) { & .\tools\sync.ps1 }

Write-Host "Serving on http://127.0.0.1:$Port/ — Ctrl+C to stop" -ForegroundColor Cyan
# --baseurl "" so the local URL is a clean http://127.0.0.1:4000/ instead of
# http://127.0.0.1:4000/nonlinear-control-notes/. The theme uses relative links,
# so this changes nothing about how the pages behave.
# "--baseurl=" (one token, empty value) makes the local URL a clean
# http://127.0.0.1:4000/ instead of http://127.0.0.1:4000/nonlinear-control-notes/.
# The theme uses relative links, so this changes nothing about how pages behave.
# Written as one token because PowerShell 5.1 drops a separate empty "" argument.
bundle exec jekyll serve --host 127.0.0.1 --port $Port "--baseurl=" --livereload --incremental
