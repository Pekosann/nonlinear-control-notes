---
title: 002 — Sistem Nonlinier Umum
section: Dasar Teori
tags: [dasar]
summary: Model nonlinier umum di mana input boleh muncul secara nonlinier, dan perilaku khas yang tidak dimiliki sistem linier.
permalink: /002-sistem-nonlinier.html
folder: notes
last_updated: Jul 22, 2026
---

Di [001 — Sistem Nonlinier Control Affine](001-sistem-nonlinier-control-affine.html) input $u$ masuk secara linier. Syarat itu tidak selalu terpenuhi. Kalau input boleh muncul di dalam fungsi nonlinier, yang tersisa adalah bentuk **nonlinier umum**.

## Model Nonlinier Umum

Teknik input-output linearization yang sudah ada biasanya bertumpu pada model di mana input dan gangguan muncul secara linier [@henson1990]:

$\dot{x} = f(x) + g(x)\,u + p(x)\,d\quad(1)$
$y = h(x)$

[@henson1990] meninjau kelas yang lebih umum, yaitu ketika input dan gangguan boleh muncul secara nonlinier:

$\dot{x} = f(x, d, u)\quad(2)$
$y = h(x)$

dengan $x$ vektor state berdimensi $n$, $d$ vektor gangguan berdimensi $p$, $u$ input manipulasi skalar, dan $y$ output skalar. Bedanya cuma satu tapi menentukan: pada Pers. (1) suku input bisa dipisah jadi $g(x)u$, sedangkan pada Pers. (2) $u$ menyatu di dalam $f$ dan tidak bisa ditarik keluar.

Dua asumsi yang dipakai [@henson1990] untuk model ini: state proses dapat diukur atau diestimasi dengan akurat, dan prosesnya *minimum phase*.

Contoh konkretnya ada di [101 — Dua Tangki CSTR](101-dua-tangki-CSTR.html), di mana laju alir pendingin muncul di dalam suku eksponensial.

Pers. (2) masih menganggap bentuk $f$ tetap sepanjang waktu. Kalau waktu ikut masuk sebagai variabel, sistemnya jadi *non-autonomous* — dibahas terpisah di [003 — Sistem Autonomous dan Non-Autonomous](003-autonomous-dan-non-autonomous.html).

## Kenapa sistem nonlinier perlu perlakuan khusus

Sistem linier waktu-invarian punya sifat yang membuat analisisnya mudah [@slotine1991]: titik kesetimbangannya tunggal kalau matriks $A$ nonsingular, kestabilannya ditentukan eigenvalue tanpa peduli kondisi awal, berlaku prinsip superposisi, dan input sinusoidal menghasilkan output sinusoidal dengan frekuensi yang sama.

Sistem nonlinier tidak begitu. [@slotine1991] mendaftar beberapa perilaku yang khas nonlinier:

- **Multiple equilibrium points** — titik kesetimbangan bisa lebih dari satu, dan perilaku sistem sangat bergantung pada kondisi awal.
- **Limit cycles** — osilasi mandiri dengan amplitudo tertentu, tanpa perlu eksitasi dari luar.
- **Bifurcations** — perubahan kecil pada parameter dapat mengubah struktur kualitatif responsnya.
- **Chaos** — respons yang sangat sensitif terhadap kondisi awal.

> Menurut [@slotine1991], semua sistem fisik sebenarnya nonlinier. Pendekatan linier baru masuk akal kalau rentang operasinya sempit dan nonlinieritasnya mulus. Di luar itu, linierisasi kehilangan perilaku yang justru penting.
