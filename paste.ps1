<#
.SYNOPSIS
  Save the image currently on the clipboard into figures\ and put the Markdown
  line for it back on the clipboard, ready to paste into your note.

  Usage:  .\paste.cmd "skema dua cstr"
          .\paste.cmd                     (auto-names it gambar-001, gambar-002, ...)

  Works with anything that puts a bitmap on the clipboard: Win+Shift+S, Snipping
  Tool, PrtScn, "Copy image" in a browser, Ctrl+C in draw.io / Excel / MATLAB.
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)][string]$Name,
    [string]$Caption
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$root = $PSScriptRoot
$figDir = Join-Path $root 'figures'
if (-not (Test-Path $figDir)) { New-Item -ItemType Directory $figDir | Out-Null }

$img = [Windows.Forms.Clipboard]::GetImage()
if ($null -eq $img) {
    Write-Host "Tidak ada gambar di clipboard." -ForegroundColor Red
    Write-Host "Screenshot dulu (Win+Shift+S), baru jalankan perintah ini." -ForegroundColor Yellow
    exit 1
}

if ([string]::IsNullOrWhiteSpace($Name)) {
    $n = 1
    while (Test-Path (Join-Path $figDir ('gambar-{0:D3}.png' -f $n))) { $n++ }
    $slug = 'gambar-{0:D3}' -f $n
} else {
    $slug = ($Name.ToLower() -replace '[^a-z0-9]+', '-').Trim('-')
}

$path = Join-Path $figDir "$slug.png"
if (Test-Path $path) {
    $n = 2
    while (Test-Path (Join-Path $figDir "$slug-$n.png")) { $n++ }
    $slug = "$slug-$n"
    $path = Join-Path $figDir "$slug.png"
}

$img.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
$img.Dispose()

$alt = if ($Name) { $Name } else { $slug }
$md = "![$alt](figures/$slug.png)"
if ($Caption) { $md += "`n*$Caption*" }

Set-Clipboard -Value $md

$size = [math]::Round((Get-Item $path).Length / 1KB, 1)
Write-Host ""
Write-Host "Tersimpan: figures\$slug.png  ($size KB)" -ForegroundColor Green
Write-Host "Markdown sudah ada di clipboard — tinggal Ctrl+V di catatanmu:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  $md" -ForegroundColor White
Write-Host ""
