# Nonlinear Control Notes

Catatan terbuka tentang kendali nonlinier — teori, turunan matematis, dan implementasinya
pada sistem proses kimia. Dibangun dengan [Jekyll Documentation Theme](https://github.com/tomjoht/documentation-theme-jekyll).

**Live:** https://pekosann.github.io/nonlinear-control-notes/

---

## Cara kerja sehari-hari

Semua tulisan ada di **`notes\`**. Satu file `.md` = satu halaman. Tulis Markdown biasa
persis seperti di Obsidian — math pakai `$...$`, gambar pakai `![[gambar.png]]`.
Skrip `sync` mengurus front matter, sidebar, permalink, dan tag secara otomatis.

> **Pakai file `.cmd`, bukan `.ps1`.** Windows PowerShell secara default menolak
> menjalankan skrip (`running scripts is disabled on this system`). File `.cmd` di
> folder ini adalah pembungkus yang melewati pembatasan itu tanpa mengubah setelan
> keamanan komputermu — bisa diketik di terminal atau diklik dua kali.
>
> Kalau kamu lebih suka menjalankan `.ps1` langsung, sekali saja jalankan:
> `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`

### 1. Bikin catatan baru

```powershell
.\new.cmd "Relative Degree" -Section "Dasar Teori" -Tags dasar,glc
```

Membuat `notes\002-relative-degree.md` (nomor otomatis), mengisi front matter,
menjalankan sync, lalu membuka file di VS Code.

### 2. Tulis / edit

> **Jangan tekan Enter di tengah kalimat.** Satu paragraf = satu baris panjang;
> biarkan editor yang membungkusnya sendiri (word wrap sudah aktif di VS Code).
> Situs ini memakai `hard_wrap`, jadi setiap newline jadi ganti baris beneran di
> halaman — kalau kamu wrap manual, tampilannya jadi patah di tengah kalimat.
> Ganti baris tetap dipakai kalau memang disengaja, misalnya satu persamaan per
> baris seperti di catatan 001.

Edit file di `notes\` pakai editor apa pun. Yang perlu kamu isi cuma bagian atas file:

```yaml
---
title: "002 — Relative Degree"
section: Dasar Teori     # jadi judul grup di sidebar
tags: [dasar, glc]       # halaman tag dibuat otomatis
summary: "Satu kalimat, muncul di daftar catatan & hasil pencarian."
---
```

Sisanya (`permalink`, `folder`, `last_updated`) diisi otomatis — biarkan saja.

### 3. Lihat hasilnya

```powershell
.\serve.cmd
```

Buka http://127.0.0.1:4000/. Simpan file → halaman rebuild sendiri.
Restart hanya perlu kalau kamu menambah file baru atau mengubah `_config.yml`.

### 4. Publish

```powershell
.\publish.cmd "tambah catatan relative degree"
```

Sync → build (gagal build = tidak di-push) → commit → push.
GitHub Actions menerbitkan ke GitHub Pages sekitar 1 menit kemudian.

---

## Urutan & pengelompokan

| Yang mengatur | Caranya |
|---|---|
| Urutan di sidebar | Nomor di depan nama file: `001-`, `002-`, ... |
| Grup di sidebar | Field `section:` di front matter |
| Urutan grup | Urutan kemunculan pertama (jadi ikut nomor file) |
| URL halaman | Nama file: `002-relative-degree.md` → `/002-relative-degree.html` |

Mau menyisipkan catatan di tengah? Ganti nama filenya jadi `002a-...` atau
nomori ulang, lalu jalankan `.\sync.cmd`.

## Menulis math

**Persis seperti Obsidian.** File `.md`-mu tidak diubah sama sekali.

| Kamu tulis | Hasilnya |
|---|---|
| `$x \in \mathbb{R}^n$` | inline, menyatu dengan kalimat |
| `$$ ... $$` di baris sendiri | display, di tengah dan lebih besar |

```markdown
Bentuk umumnya $\dot{x} = f(x) + g(x)u$ dengan $x \in \mathbb{R}^n$.

$$
\begin{align}
\dot{x} &= f(x) + g(x)u \tag{1}\\
y &= h(x) \tag{2}
\end{align}
$$
```

Kalau perlu tanda dolar sungguhan (harga, dsb.), tulis `\$`.

<details>
<summary>Kenapa perlu plugin untuk ini</summary>

kramdown (mesin Markdown-nya Jekyll) cuma mengenali `$$...$$` sebagai math.
Math dolar-tunggal dianggap teks biasa, jadi isinya ikut diproses Markdown:
`\\` di dalam `\pmatrix` menyusut jadi `\`, dan `_` atau `*` bisa berubah jadi
*italic*. Sebaliknya di Obsidian `$$...$$` berarti persamaan display — jadi
menulis `$$...$$` inline akan salah tampil di Obsidian.

`_plugins/inline_math.rb` menyelesaikan keduanya: waktu build, `$x$` diubah jadi
`$$x$$` **di memori saja**, tepat sebelum kramdown jalan. Blok `$$ ... $$`,
fenced code, dan `` `inline code` `` dilewati. File sumbermu tetap utuh.
</details>

Makro tambahan: `\RR` (= `\mathbb{R}`), `\dd`, `\pmatrix{...}`, `\bmatrix{...}`.
Penomoran pakai `\tag{1}` — nomornya milik catatanmu sendiri, tidak harus ikut
nomor di paper aslinya.

## Sitasi & referensi

Export library Zotero-mu ke **`_bibliography/references.bib`** (BibTeX atau BibLaTeX
sama saja). Lalu di catatan tulis kunci sitasinya dalam kurung siku:

```markdown
Metode ini diperkenalkan oleh [@henson1990].
Buku teks standarnya [@seborg]. Dua sekaligus: [@henson1990; @guan2023].
```

Hasilnya:

```
Metode ini diperkenalkan oleh [1]. Buku teks standarnya [2]. Dua sekaligus: [1, 3].

## Referensi
1. Henson, M. A. & Seborg, D. E. (1990). Input‐output Linearization of General
   Nonlinear Processes. AIChE Journal, 36(11), 1753–1757. https://doi.org/...
2. Seborg, D. E., Edgar, T. F., Mellichamp, D. A., & Doyle, F. J., III (2016).
   Process Dynamics and Control (4th ed.). Hoboken, NJ: John Wiley & Sons.
3. Guan, H., Ye, L., ... (2023). Dynamic Modeling and Sensitivity Analysis ...
```

- Nomor diberikan **per halaman**, urut sesuai kemunculan pertama. Kunci yang sama
  dipakai dua kali tetap dapat nomor yang sama.
- Daftar **Referensi** ditambahkan otomatis di bawah halaman — hanya di halaman
  yang memang menyitasi sesuatu.
- Kunci yang tidak ada di `.bib` tetap tampil (dengan teks merah) dan memunculkan
  peringatan kuning waktu build, jadi salah ketik ketahuan.
- `_bibliography/` tidak ikut dipublish, dan `sync` membuang field `file = {...}`
  (berisi path Zotero lokalmu) setiap kali jalan — repo ini publik.
- Kalau Zotero mengekspor ke `notes\`, `sync` otomatis memindahkannya ke
  `_bibliography\`. Tidak perlu diingat-ingat.

Mesinnya ada di `_plugins/bibliography.rb`. Plugin Jekyll hanya jalan karena situs ini
dibangun lewat GitHub Actions sendiri, bukan build bawaan GitHub Pages (yang mode-nya
aman dan mengabaikan `_plugins/`). Jangan pindah ke "Deploy from a branch".

## Gambar

### Cara tercepat: copy-paste screenshot

Screenshot dengan **Win+Shift+S**, lalu:

```powershell
paste.cmd "skema dua cstr"
```

File tersimpan sebagai `figures\skema-dua-cstr.png`, dan baris Markdown-nya
langsung ada di clipboard — tinggal **Ctrl+V** di catatanmu:

```markdown
![skema dua cstr](figures/skema-dua-cstr.png)
```

Mau sekalian caption: `paste.cmd "skema dua cstr" -Caption "Gambar 1. Dua CSTR seri."`
Tanpa nama juga boleh (`paste.cmd`) — otomatis jadi `gambar-001.png`, `gambar-002.png`, …
Sumbernya bebas: Snipping Tool, PrtScn, "Copy image" di browser, Ctrl+C dari draw.io,
Excel, atau MATLAB.

### Kalau pakai VS Code

Ctrl+V gambar langsung ke dalam file `.md` juga jalan — `.vscode\settings.json`
sudah diatur supaya filenya masuk ke `figures\`, bukan ke sebelah `.md`-nya.
VS Code menulis link `../figures/x.png`; `sync` membetulkannya jadi `figures/x.png`.

> **Kenapa harus di `figures\`?** Halaman disajikan dari root situs
> (`/101-dua-tangki-cstr.html`), bukan dari `/notes/`. Gambar yang diletakkan di
> `notes\` akan tampil waktu preview lokal tapi 404 di situs live.

### Menulis manual

```markdown
![[skema-tangki.png]]              ← gaya Obsidian, otomatis jadi figures/…
![Skema tangki](figures/skema-tangki.png)
*Gambar 1. Keterangan gambar.*     ← baris italic setelah gambar jadi caption
```

## Fitur tema yang berguna

```markdown
{% include note.html content="Catatan penting di sini." %}
{% include tip.html content="Tips." %}
{% include warning.html content="Peringatan." %}
{% include important.html content="Wajib dibaca." %}
{% include callout.html content="Kotak bebas." type="primary" %}
```

Daftar isi halaman muncul otomatis; matikan dengan `toc: false` di front matter.

---

## Struktur folder

```
notes\          ← TULISANMU ADA DI SINI
figures\        ← gambar
_bibliography\  ← references.bib dari Zotero (tidak dipublish)
_plugins\       ← mesin sitasi [@key] + math inline
tags\           ← halaman tag (dibuat otomatis oleh sync)
_data\sidebars\ ← sidebar (dibuat otomatis oleh sync)
_archive\       ← draft lama, tidak ikut dipublish
tools\sync.ps1  ← mesin di balik layar
new.cmd serve.cmd publish.cmd sync.cmd   ← yang kamu jalankan
new.ps1 serve.ps1 publish.ps1            ← isinya
_includes\ _layouts\ css\ js\ fonts\ images\   ← tema, jarang disentuh
```

## Setup di komputer baru

1. Install Ruby+DevKit: `winget install RubyInstallerTeam.RubyWithDevKit.3.3`
2. `git clone https://github.com/Pekosann/nonlinear-control-notes.git`
3. `bundle install`
4. `.\serve.cmd`

## Lisensi

Isi catatan: bebas dipakai dengan atribusi. Tema: lihat `LICENSE` (Apache 2.0, Google LLC).
