<#
.SYNOPSIS
  Sync, build once to catch errors, then commit and push. GitHub Actions
  publishes the site a minute or so later.

  Usage:  .\publish.ps1 "tambah catatan relative degree"
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)][string]$Message,
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
if (Test-Path 'C:\Ruby33-x64\bin') { $env:Path = 'C:\Ruby33-x64\bin;' + $env:Path }

& .\tools\sync.ps1

if (-not $SkipBuild) {
    Write-Host "Building to check for errors..." -ForegroundColor Cyan
    bundle exec jekyll build
    if ($LASTEXITCODE -ne 0) { throw "Jekyll build failed — not pushing." }
    Write-Host "Build OK." -ForegroundColor Green
}

if (-not $Message) {
    $Message = "update notes ({0})" -f (Get-Date -Format 'yyyy-MM-dd HH:mm')
}

git add -A
$staged = git diff --cached --name-only
if (-not $staged) { Write-Host "Nothing to commit." -ForegroundColor Yellow; return }

git commit -m $Message
git push

Write-Host ""
Write-Host "Pushed. Build status: https://github.com/Pekosann/nonlinear-control-notes/actions" -ForegroundColor Cyan
Write-Host "Live site:            https://pekosann.github.io/nonlinear-control-notes/" -ForegroundColor Cyan
