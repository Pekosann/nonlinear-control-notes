---
title: Catatan Nonlinear Control
keywords: nonlinear control, feedback linearization, glc, cstr
sidebar: notes_sidebar
permalink: index.html
toc: false
summary: Kumpulan catatan tentang kendali nonlinier — dari bentuk umum sistem nonlinier sampai implementasinya di reaktor.
---

Ini kumpulan catatan saya tentang **nonlinear control**: teori, turunan matematisnya,
dan implementasinya pada sistem proses kimia (tangki, CSTR, reaktor batch).
Semuanya terbuka — silakan dipakai, dikoreksi, atau dikutip.

{% assign notes = site.pages | where: "folder", "notes" | sort: "permalink" %}
{% assign sections = notes | map: "section" | uniq %}

{% for section in sections %}
## {{ section }}

<table class="note-index">
<thead><tr><th>Catatan</th><th>Ringkasan</th></tr></thead>
<tbody>
{% for note in notes %}{% if note.section == section %}
<tr>
  <td><a href="{{ note.url | remove: "/" }}">{{ note.title }}</a></td>
  <td>{% if note.summary and note.summary != "" %}{{ note.summary | strip_html }}{% else %}{{ note.content | strip_html | truncatewords: 25 }}{% endif %}</td>
</tr>
{% endif %}{% endfor %}
</tbody>
</table>
{% endfor %}

{% if notes.size == 0 %}
{% include note.html content="Belum ada catatan. Jalankan <code>.\new.ps1 \"Judul Catatan\"</code> untuk membuat yang pertama." %}
{% endif %}
