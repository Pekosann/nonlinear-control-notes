<#
.SYNOPSIS
  Create a new note. Usage:  .\new.ps1 "Relative Degree"  [-Section "Dasar Teori"] [-Tags dasar,glc]

  Picks the next number automatically (002, 003, ...), writes a stub with front
  matter filled in, runs sync, and opens the file in your editor.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)][string]$Title,
    [string]$Section = 'Catatan',
    [string[]]$Tags = @(),
    [switch]$NoOpen
)

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$notesDir = Join-Path $root 'notes'
if (-not (Test-Path $notesDir)) { New-Item -ItemType Directory $notesDir | Out-Null }

# next free number
$max = 0
Get-ChildItem $notesDir -Filter *.md -ErrorAction SilentlyContinue | ForEach-Object {
    if ($_.BaseName -match '^(\d+)') { $n = [int]$Matches[1]; if ($n -gt $max) { $max = $n } }
}
$num = '{0:D3}' -f ($max + 1)

$slugBody = ($Title.ToLower() -replace '[–—]', '-' -replace '[^a-z0-9]+', '-').Trim('-')
$slug = "$num-$slugBody"
$path = Join-Path $notesDir "$slug.md"
if (Test-Path $path) { throw "$path already exists." }

$tagStr = '[' + ($Tags -join ', ') + ']'
$content = @"
---
title: "$num — $Title"
section: $Section
tags: $tagStr
summary: ""
---

Tulis catatanmu di sini. Math pakai ``$``…``$`` seperti di Obsidian, misalnya
`$\dot{x} = f(x) + g(x)u$`.

## Sub-bagian

"@
[IO.File]::WriteAllText($path, ($content -replace "`r`n", "`n"), (New-Object Text.UTF8Encoding $false))
Write-Host "Created notes\$slug.md" -ForegroundColor Green

& (Join-Path $root 'tools\sync.ps1')

if (-not $NoOpen) {
    if (Get-Command code -ErrorAction SilentlyContinue) { code $path } else { Start-Process $path }
}
