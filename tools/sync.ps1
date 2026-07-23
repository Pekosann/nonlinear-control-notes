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

# Quote a scalar for YAML if it contains anything that would break a bare value:
# a colon (mapping), leading special chars, brackets, quotes, #, etc. A title
# like "201 — Feedback Linearization: Konsep" MUST be quoted or the parser dies.
function Format-YamlScalar($text) {
    $s = "$text"
    if ($s -match '^\s*$') { return '""' }
    # already wrapped in matching double quotes -> leave as-is
    if ($s -match '^".*"$') { return $s }
    if ($s -match '[:#\[\]\{\}&\*!\|>%@`"'']' -or $s -match '^[\s\-\?]' -or $s -match '\s$') {
        return '"' + ($s -replace '\\', '\\' -replace '"', '\"') + '"'
    }
    return $s
}

# Normalise inline math back to Obsidian's single-dollar form.
# The site no longer needs $$...$$ inline — _plugins/inline_math.rb does that
# conversion at build time — and in Obsidian $$...$$ means a centred display
# equation, so keeping it inline would render wrongly there.
# A line that is exactly "$$" delimits a real display block and is left alone.
function Convert-Math([string[]]$lines) {
    $out = New-Object System.Collections.Generic.List[string]
    $inFence = $false
    $inDisplay = $false
    foreach ($line in $lines) {
        if ($line -match '^\s*(```|~~~)') { $inFence = -not $inFence; $out.Add($line); continue }
        if ($inFence) { $out.Add($line); continue }
        if ($line.Trim() -eq '$$') { $inDisplay = -not $inDisplay; $out.Add($line); continue }
        if ($inDisplay) { $out.Add($line); continue }

        # Protect inline code spans, then collapse $$...$$ pairs on this line.
        $spans = New-Object System.Collections.Generic.List[string]
        $work = [regex]::Replace($line, '`[^`]*`', {
            param($m)
            $spans.Add($m.Value)
            return "!!CODE$($spans.Count - 1)!!"
        })
        $work = [regex]::Replace($work, '\$\$([^$\r\n]+?)\$\$', '$$$1$$')
        for ($i = $spans.Count - 1; $i -ge 0; $i--) { $work = $work.Replace("!!CODE$i!!", $spans[$i]) }
        $out.Add($work)
    }
    return $out
}

# ------------------------------------------------------- scrub .bib files ----
# A .bib dropped in notes\ would be published verbatim by Jekyll (and its Zotero
# file = {...} paths with it), and the citation plugin would not even see it —
# it only reads _bibliography\. So move any stray .bib there first.

# Obsidian and VS Code drop pasted images next to the .md. Pages are served from
# the site root, so an image left in notes\ 404s live. Move them to figures\ and
# slugify the name — "Pasted image 20260722174535.png" has spaces, which break
# the Markdown link. References in the notes are rewritten further down.
$figDir = Join-Path $root 'figures'
$movedImages = @{}
$imageExt = @('.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp')
foreach ($img in (Get-ChildItem $notesDir -File -ErrorAction SilentlyContinue |
                  Where-Object { $imageExt -contains $_.Extension.ToLower() })) {
    if (-not (Test-Path $figDir)) {
        if (-not $Check) { New-Item -ItemType Directory $figDir | Out-Null }
    }
    $newName = (Get-Slug ([IO.Path]::GetFileNameWithoutExtension($img.Name))) + $img.Extension.ToLower()
    $dest = Join-Path $figDir $newName
    $n = 2
    while ((Test-Path $dest) -and -not $Check) {
        $newName = (Get-Slug ([IO.Path]::GetFileNameWithoutExtension($img.Name))) + "-$n" + $img.Extension.ToLower()
        $dest = Join-Path $figDir $newName
        $n++
    }
    if (-not $Check) { Move-Item $img.FullName $dest -Force }
    $movedImages[$img.Name] = $newName
    $changed += "moved notes\$($img.Name) -> figures\$newName"
}

$bibDir = Join-Path $root '_bibliography'
foreach ($stray in (Get-ChildItem $notesDir -Filter *.bib -ErrorAction SilentlyContinue)) {
    if (-not (Test-Path $bibDir)) {
        if (-not $Check) { New-Item -ItemType Directory $bibDir | Out-Null }
    }
    # Always land on the one canonical name. A Zotero export is a full dump of
    # whatever you exported, so re-exporting should replace the file, not pile up
    # a second copy with the same keys in it.
    $dest = Join-Path $bibDir 'references.bib'
    if (-not $Check) { Move-Item $stray.FullName $dest -Force }
    $changed += "moved notes\$($stray.Name) -> _bibliography\references.bib"
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
$citedKeys = @{}       # citation key -> list of notes citing it
$internalLinks = @{}   # linked page slug -> list of notes linking to it

foreach ($f in $files) {
    $slug = [IO.Path]::GetFileNameWithoutExtension($f.Name)
    $raw = [IO.File]::ReadAllText($f.FullName)

    # --- split front matter -------------------------------------------------
    $fm = [ordered]@{}
    $body = $raw
    if ($raw -match '(?s)^﻿?---\r?\n(.*?)\r?\n---\r?\n?(.*)$') {
        $fmText = $Matches[1]; $body = $Matches[2]
        # Handles both inline (tags: [a, b]) and the block style Obsidian writes:
        #   tags:
        #     - a
        #     - b
        # Block lists are folded into the inline form. Missing this silently
        # dropped every tag written the Obsidian way.
        $lastKey = $null
        foreach ($l in ($fmText -split "\r?\n")) {
            if ($l -match '^([A-Za-z_][A-Za-z0-9_]*):\s*(.*)$') {
                $lastKey = $Matches[1]
                $fm[$lastKey] = $Matches[2].Trim()
            }
            elseif ($lastKey -and $l -match '^\s*-\s*(.+?)\s*$') {
                $item = $Matches[1].Trim().Trim('"').Trim("'")
                if ([string]::IsNullOrWhiteSpace($fm[$lastKey])) { $fm[$lastKey] = "[$item]" }
                else { $fm[$lastKey] = $fm[$lastKey].TrimEnd(']') + ", $item]" }
            }
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

    # Point references at whatever names the images ended up with in figures\.
    foreach ($old in $movedImages.Keys) {
        $new = $movedImages[$old]
        $body = $body.Replace("![[$old]]", "![](figures/$new)")
        $body = $body.Replace("]($old)", "](figures/$new)")
        $body = $body.Replace("](figures/$old)", "](figures/$new)")
    }
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

    # Note which pages this one links to, so renaming a note cannot silently
    # leave dead links behind. (Wikilinks are resolved to real links above, so
    # after a rename the old target survives in the source as plain Markdown.)
    foreach ($m in [regex]::Matches($body, '\]\((?!https?:|#|mailto:)([^)\s#]+?)\.html(?:#[^)]*)?\)')) {
        $target = $m.Groups[1].Value.TrimStart('/')
        if (-not $internalLinks.ContainsKey($target)) { $internalLinks[$target] = @() }
        $internalLinks[$target] += $f.Name
    }

    # Note which references this page cites, so a shrinking .bib can be caught.
    foreach ($m in [regex]::Matches($body, '\[@([A-Za-z0-9_:.\-]+(?:\s*;\s*@[A-Za-z0-9_:.\-]+)*)\]')) {
        foreach ($k in ($m.Groups[1].Value -split ';')) {
            $key = $k.Trim().TrimStart('@')
            if (-not $citedKeys.ContainsKey($key)) { $citedKeys[$key] = @() }
            $citedKeys[$key] += $f.Name
        }
    }

    # --- reassemble ---------------------------------------------------------
    $order = @('title', 'section', 'tags', 'summary', 'permalink', 'folder', 'last_updated')
    $lines = @('---')
    # title and summary are free text and may contain colons -> YAML-quote them.
    foreach ($k in $order) {
        $val = if ($k -eq 'title' -or $k -eq 'summary') { Format-YamlScalar $fm[$k] } else { $fm[$k] }
        $lines += "{0}: {1}" -f $k, $val
    }
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
    $sb.Add("  - title: $(Format-YamlScalar $sec)")
    $sb.Add('    output: web')
    $sb.Add('    folderitems:')
    $sb.Add('')
    foreach ($e in ($entries | Where-Object Section -eq $sec)) {
        $sb.Add("    - title: $(Format-YamlScalar $e.Title)")
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

# ------------------------------------------------------- broken page links ---

$knownPages = New-Object System.Collections.Generic.HashSet[string]
foreach ($e in $entries) { [void]$knownPages.Add($e.Slug) }
[void]$knownPages.Add('index')
[void]$knownPages.Add('tag_index')
[void]$knownPages.Add('404')
foreach ($t in $tagList) { [void]$knownPages.Add("tag_$t") }

$deadLinks = $internalLinks.Keys | Where-Object { -not $knownPages.Contains($_) } | Sort-Object
if ($deadLinks) {
    Write-Host ""
    Write-Host "!! LINK KE HALAMAN YANG TIDAK ADA :" -ForegroundColor Red
    foreach ($l in $deadLinks) {
        Write-Host ("   {0}.html  ditaut dari: {1}" -f $l, (($internalLinks[$l] | Sort-Object -Unique) -join ', ')) -ForegroundColor Red
    }
    Write-Host "   Catatannya mungkin baru diganti nama — perbarui tautannya." -ForegroundColor Yellow
}

# ------------------------------------------------- cited-but-missing keys ----
# A Zotero re-export overwrites the .bib wholesale. Export a different collection
# and keys silently vanish, leaving red "[?]" citations on the live site. Catch it
# here instead.

$bibKeys = New-Object System.Collections.Generic.HashSet[string]
if (Test-Path $bibDir) {
    foreach ($bib in (Get-ChildItem $bibDir -Filter *.bib)) {
        foreach ($m in [regex]::Matches([IO.File]::ReadAllText($bib.FullName), '(?m)^\s*@\w+\s*\{\s*([^,\s}]+)')) {
            [void]$bibKeys.Add($m.Groups[1].Value)
        }
    }
}

$missing = $citedKeys.Keys | Where-Object { -not $bibKeys.Contains($_) } | Sort-Object
if ($missing) {
    Write-Host ""
    Write-Host "!! SITASI TIDAK KETEMU di _bibliography\ :" -ForegroundColor Red
    foreach ($k in $missing) {
        Write-Host ("   [@{0}]  dipakai di: {1}" -f $k, (($citedKeys[$k] | Sort-Object -Unique) -join ', ')) -ForegroundColor Red
    }
    Write-Host "   Kemungkinan export Zotero-nya beda koleksi, atau citation key-nya berubah." -ForegroundColor Yellow
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
