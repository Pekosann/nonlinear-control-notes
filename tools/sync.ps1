<#
.SYNOPSIS
  Turns the plain Markdown files in notes\ into a valid Jekyll site.

.DESCRIPTION
  Run this after adding or editing anything in notes\. It is idempotent — running
  it twice changes nothing the second time. For each notes\*.md it:

    1. Adds/repairs the YAML front matter (title, permalink, sidebar, tags...).
    2. Removes a leading "# Heading" from the body (the theme prints the title).
    3. Rewrites inline math  $x$  ->  $$x$$  so kramdown does not mangle
       subscripts like x_1 ... x_2 into italics.
    4. Rewrites Obsidian syntax:  ![[img.png]] -> ![](figures/img.png)
                                  [[other-note]] -> [Title](other-note.html)
    5. Stamps last_updated.

  Then it regenerates _data\sidebars\notes_sidebar.yml (grouped by the `section`
  field, ordered by filename) and creates any missing tag pages.

.PARAMETER Check
  Report what would change without writing anything.
#>
[CmdletBinding()]
param([switch]$Check)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$notesDir = Join-Path $root 'notes'
$changed = @()

function Write-IfChanged($path, $content) {
    $existing = if (Test-Path $path) { [IO.File]::ReadAllText($path) } else { $null }
    if ($existing -eq $content) { return $false }
    if (-not $Check) {
        [IO.File]::WriteAllText($path, $content, (New-Object Text.UTF8Encoding $false))
    }
    return $true
}

# ---------------------------------------------------------------- helpers ----

function Get-Slug($text) {
    $s = $text.ToLower()
    $s = $s -replace '[–—]', '-'         # en/em dash
    $s = $s -replace '[^a-z0-9]+', '-'
    return $s.Trim('-')
}

# Convert single-dollar math to double-dollar, skipping code.
function Convert-Math([string[]]$lines) {
    $out = New-Object System.Collections.Generic.List[string]
    $inFence = $false
    foreach ($line in $lines) {
        if ($line -match '^\s*(```|~~~)') { $inFence = -not $inFence; $out.Add($line); continue }
        if ($inFence -or $line -match '^\s{4,}\S') { $out.Add($line); continue }

        # Protect inline code spans, then convert $...$ outside of them.
        $spans = New-Object System.Collections.Generic.List[string]
        $work = [regex]::Replace($line, '`[^`]*`', {
            param($m)
            $spans.Add($m.Value)
            return "!!CODE$($spans.Count - 1)!!"
        })
        $work = [regex]::Replace($work, '(?<![$\\])\$(?!\$)([^$\r\n]+?)(?<![$\\])\$(?!\$)', '$$$$$1$$$$')
        for ($i = $spans.Count - 1; $i -ge 0; $i--) { $work = $work.Replace("!!CODE$i!!", $spans[$i]) }
        $out.Add($work)
    }
    return $out
}

# ------------------------------------------------------- scrub .bib files ----
# A .bib dropped in notes\ would be published verbatim by Jekyll (and its Zotero
# file = {...} paths with it), and the citation plugin would not even see it —
# it only reads _bibliography\. So move any stray .bib there first.

$bibDir = Join-Path $root '_bibliography'
foreach ($stray in (Get-ChildItem $notesDir -Filter *.bib -ErrorAction SilentlyContinue)) {
    if (-not (Test-Path $bibDir)) {
        if (-not $Check) { New-Item -ItemType Directory $bibDir | Out-Null }
    }
    $dest = Join-Path $bibDir $stray.Name
    if (-not $Check) { Move-Item $stray.FullName $dest -Force }
    $changed += "moved notes\$($stray.Name) -> _bibliography\  (notes\ is published; _bibliography\ is not)"
}

# Zotero writes  file = {C:\Users\<you>\Zotero\storage\...}  into every entry.
# The repo is public and nothing renders that field, so strip it on every sync —
# otherwise each re-export from Zotero puts your username back in the repo.

if (Test-Path $bibDir) {
    foreach ($bib in (Get-ChildItem $bibDir -Filter *.bib)) {
        $text = [IO.File]::ReadAllText($bib.FullName)
        # a file/annotation field on its own line, with or without a trailing comma
        $stripped = [regex]::Replace($text, '(?im)^[ \t]*(file|annotation)[ \t]*=[ \t]*\{[^}]*\},?[ \t]*\r?\n', '')
        # tidy a dangling comma before the closing brace
        $stripped = [regex]::Replace($stripped, ',(\s*\n\s*\})', '$1')
        if (Write-IfChanged $bib.FullName $stripped) {
            $changed += "_bibliography\$($bib.Name)  (stripped local file paths)"
        }
    }
}

# ------------------------------------------------------------ read notes ----

if (-not (Test-Path $notesDir)) { throw "No notes\ directory at $notesDir" }
$files = Get-ChildItem $notesDir -Filter *.md | Sort-Object Name
if ($files.Count -eq 0) { Write-Host "notes\ is empty — nothing to do." -ForegroundColor Yellow; return }

# First pass: collect titles so [[wikilinks]] can be resolved.
$meta = @{}
foreach ($f in $files) {
    $slug = [IO.Path]::GetFileNameWithoutExtension($f.Name)
    $raw = [IO.File]::ReadAllText($f.FullName)
    $title = $null
    if ($raw -match '(?m)^title:\s*["'']?(.+?)["'']?\s*$') { $title = $Matches[1] }
    elseif ($raw -match '(?m)^#\s+(.+?)\s*$') { $title = $Matches[1] }
    else { $title = $slug }
    $meta[$slug] = @{ Title = $title.Trim(); Slug = $slug }
}

$allTags = New-Object System.Collections.Generic.HashSet[string]
$entries = @()

foreach ($f in $files) {
    $slug = [IO.Path]::GetFileNameWithoutExtension($f.Name)
    $raw = [IO.File]::ReadAllText($f.FullName)

    # --- split front matter -------------------------------------------------
    $fm = [ordered]@{}
    $body = $raw
    if ($raw -match '(?s)^﻿?---\r?\n(.*?)\r?\n---\r?\n?(.*)$') {
        $fmText = $Matches[1]; $body = $Matches[2]
        foreach ($l in ($fmText -split "\r?\n")) {
            if ($l -match '^([A-Za-z_][A-Za-z0-9_]*):\s*(.*)$') { $fm[$Matches[1]] = $Matches[2].Trim() }
        }
    }

    # --- title: front matter > H1 > filename --------------------------------
    $h1 = $null
    if ($body -match '(?m)^#\s+(.+?)\s*$') { $h1 = $Matches[1].Trim() }
    if (-not $fm.Contains('title') -or [string]::IsNullOrWhiteSpace($fm['title'])) {
        $t = if ($h1) { $h1 } else { ($slug -replace '[-_]', ' ') }
        $fm['title'] = '"' + ($t -replace '"', "'") + '"'
    }
    # Drop the H1 — the theme already renders the title as the page heading.
    if ($h1) { $body = [regex]::Replace($body, '(?m)^#\s+.+?\s*\r?\n', '', 1) }

    if (-not $fm.Contains('section') -or [string]::IsNullOrWhiteSpace($fm['section'])) { $fm['section'] = 'Catatan' }
    if (-not $fm.Contains('summary')) { $fm['summary'] = '""' }
    $fm['permalink'] = "/$slug.html"
    $fm['folder'] = 'notes'
    $fm['last_updated'] = (Get-Date $f.LastWriteTime -Format 'MMM d, yyyy')

    # --- tags ---------------------------------------------------------------
    $tags = @()
    if ($fm.Contains('tags') -and $fm['tags']) {
        $tags = ($fm['tags'] -replace '[\[\]]', '') -split ',' |
                ForEach-Object { $_.Trim().Trim('"').Trim("'") } | Where-Object { $_ }
    }
    foreach ($t in $tags) { [void]$allTags.Add($t) }
    $fm['tags'] = '[' + (($tags | ForEach-Object { $_ }) -join ', ') + ']'

    # --- body rewrites ------------------------------------------------------
    # VS Code inserts image links relative to the .md file (../figures/x.png),
    # but pages are served from the site root, so they need figures/x.png.
    $body = $body -replace '\]\((?:\.\./)+figures/', '](figures/'
    $body = $body -replace '(src=")(?:\.\./)+figures/', '$1figures/'
    $body = [regex]::Replace($body, '!\[\[([^\]|]+?)(\|[^\]]*)?\]\]', {
        param($m) "![]({0})" -f "figures/$($m.Groups[1].Value)"
    })
    $body = [regex]::Replace($body, '(?<!!)\[\[([^\]|]+?)(\|([^\]]*))?\]\]', {
        param($m)
        $target = $m.Groups[1].Value.Trim()
        $label = if ($m.Groups[3].Success) { $m.Groups[3].Value } else { $target }
        $key = $meta.Keys | Where-Object { $_ -eq $target -or $meta[$_].Title -eq $target } | Select-Object -First 1
        if ($key) {
            if (-not $m.Groups[3].Success) { $label = $meta[$key].Title }
            "[$label]($key.html)"
        } else { $label }
    })
    $body = (Convert-Math ($body -split "\r?\n")) -join "`n"
    $body = $body.TrimStart("`n")

    # --- reassemble ---------------------------------------------------------
    $order = @('title', 'section', 'tags', 'summary', 'permalink', 'folder', 'last_updated')
    $lines = @('---')
    foreach ($k in $order) { $lines += "{0}: {1}" -f $k, $fm[$k] }
    foreach ($k in $fm.Keys) { if ($order -notcontains $k) { $lines += "{0}: {1}" -f $k, $fm[$k] } }
    $lines += '---'
    $new = ($lines -join "`n") + "`n`n" + $body.TrimEnd() + "`n"

    if (Write-IfChanged $f.FullName $new) { $changed += "notes\$($f.Name)" }

    $entries += [pscustomobject]@{
        Slug    = $slug
        Title   = $fm['title'].Trim('"')
        Section = $fm['section'].Trim('"')
        Tags    = $tags
    }
}

# --------------------------------------------------------------- sidebar ----

$sb = New-Object System.Collections.Generic.List[string]
$sb.Add('# GENERATED BY tools\sync.ps1 — do not edit by hand.')
$sb.Add('# Order follows the note filenames; grouping follows the `section:` field.')
$sb.Add('')
$sb.Add('entries:')
$sb.Add('- title: sidebar')
$sb.Add('  product: Nonlinear Control')
$sb.Add('  version: Notes')
$sb.Add('  folders:')
$sb.Add('')
$sb.Add('  - title: Mulai')
$sb.Add('    output: web')
$sb.Add('    folderitems:')
$sb.Add('')
$sb.Add('    - title: Daftar catatan')
$sb.Add('      url: /index.html')
$sb.Add('      output: web')
$sb.Add('      type: homepage')
$sb.Add('')
$sb.Add('    - title: Indeks tag')
$sb.Add('      url: /tag_index.html')
$sb.Add('      output: web')
$sb.Add('')

$sections = $entries | Group-Object Section
# preserve first-appearance order rather than alphabetical
$orderedSections = @()
foreach ($e in $entries) { if ($orderedSections -notcontains $e.Section) { $orderedSections += $e.Section } }

foreach ($sec in $orderedSections) {
    $sb.Add("  - title: $sec")
    $sb.Add('    output: web')
    $sb.Add('    folderitems:')
    $sb.Add('')
    foreach ($e in ($entries | Where-Object Section -eq $sec)) {
        $sb.Add("    - title: $($e.Title)")
        $sb.Add("      url: /$($e.Slug).html")
        $sb.Add('      output: web')
        $sb.Add('')
    }
}

$sidebarPath = Join-Path $root '_data\sidebars\notes_sidebar.yml'
if (Write-IfChanged $sidebarPath (($sb -join "`n") + "`n")) { $changed += '_data\sidebars\notes_sidebar.yml' }

# ------------------------------------------------------------ tag pages -----

$tagList = $allTags | Sort-Object
$tagsYml = @('# Managed by tools\sync.ps1 — new tags in notes\*.md are appended automatically.',
             '# Do not leave a blank line at the end of this file.',
             'allowed-tags:')
foreach ($t in $tagList) { $tagsYml += "  - $t" }
if (Write-IfChanged (Join-Path $root '_data\tags.yml') (($tagsYml -join "`n") + "`n")) { $changed += '_data\tags.yml' }

foreach ($t in $tagList) {
    $page = @"
---
title: "Catatan bertag: $t"
tagName: $t
search: exclude
permalink: tag_$t.html
sidebar: notes_sidebar
folder: tags
---
{% include taglogic.html %}
"@
    $p = Join-Path $root "tags\tag_$t.md"
    if (Write-IfChanged $p ($page -replace "`r`n", "`n")) { $changed += "tags\tag_$t.md" }
}

# Remove tag pages for tags no longer used anywhere.
Get-ChildItem (Join-Path $root 'tags') -Filter 'tag_*.md' -ErrorAction SilentlyContinue | ForEach-Object {
    $name = $_.BaseName -replace '^tag_', ''
    if ($name -ne 'index' -and $tagList -notcontains $name) {
        if (-not $Check) { Remove-Item $_.FullName }
        $changed += "removed tags\$($_.Name)"
    }
}

# --------------------------------------------------------------- report -----

Write-Host ""
Write-Host ("{0} note(s), {1} section(s), {2} tag(s)." -f $entries.Count, $orderedSections.Count, $tagList.Count) -ForegroundColor Cyan
if ($changed.Count -eq 0) {
    Write-Host "Everything already in sync." -ForegroundColor Green
} else {
    $verb = if ($Check) { "Would update" } else { "Updated" }
    Write-Host "$verb :" -ForegroundColor Yellow
    $changed | ForEach-Object { Write-Host "  $_" }
}
Write-Host ""
