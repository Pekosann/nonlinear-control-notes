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
if ($staged) {
    git commit -m $Message
    if ($LASTEXITCODE -ne 0) { throw "git commit failed." }
} else {
    Write-Host "Nothing new to commit — pushing existing commits." -ForegroundColor Yellow
}

# First push on a fresh repo needs -u to create the upstream branch; without it
# git errors with "the current branch main has no upstream branch".
$branch = (git rev-parse --abbrev-ref HEAD).Trim()
$hasUpstream = $null -ne (git rev-parse --abbrev-ref "$branch@{upstream}" 2>$null)
if ($hasUpstream) { git push } else { git push -u origin $branch }

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "PUSH FAILED — nothing reached GitHub." -ForegroundColor Red
    Write-Host "Check that https://github.com/Pekosann/nonlinear-control-notes exists" -ForegroundColor Red
    Write-Host "and that you are signed in to GitHub in Git Credential Manager." -ForegroundColor Red
    throw "git push failed."
}

Write-Host ""
Write-Host "Pushed. Build status: https://github.com/Pekosann/nonlinear-control-notes/actions" -ForegroundColor Cyan
Write-Host "Live site:            https://pekosann.github.io/nonlinear-control-notes/" -ForegroundColor Cyan
Write-Host "(first deploy takes ~1-2 minutes)" -ForegroundColor DarkGray
