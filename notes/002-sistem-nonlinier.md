---
title: 002 — Sistem Nonlinier Umum
section: Dasar Teori
tags: [dasar]
summary: Model nonlinier umum di mana input boleh muncul secara nonlinier, sistem autonomous vs non-autonomous, dan perilaku khas yang tidak dimiliki sistem linier.
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

### Sistem *autonomous* dan *non-autonomous*

Pers. (2) menganggap bentuk $f$ tetap sepanjang waktu. Kalau karakteristik prosesnya sendiri berubah — katalis terdeaktivasi, permukaan penukar panas ter-*fouling*, kondisi ambient bergeser — maka waktu masuk sebagai variabel tersendiri:

$\dot{x} = f(x, d, u, t)\quad(3)$
$y = h(x)$

Untuk membedakan keduanya, [@slotine1991] memakai istilah **autonomous** dan **non-autonomous**, bukan *time-invariant* dan *time-varying*. Kedua pasangan istilah itu memang sepadan, tapi yang pertama dipakai untuk sistem nonlinier dan yang kedua untuk sistem linier.

Definisi 3.1 di [@slotine1991]: sistem disebut **autonomous** kalau $f$ tidak bergantung secara eksplisit pada waktu, yaitu bisa ditulis $\dot{x} = f(x)$. Kalau bergantung, sistemnya **non-autonomous**. Jadi Pers. (2) adalah bentuk autonomous, dan Pers. (3) bentuk non-autonomous.

Dua catatan halus dari [@slotine1991] soal ini:

- Secara ketat semua sistem fisik itu non-autonomous, karena tidak ada karakteristik dinamik yang benar-benar tetap terhadap waktu. Sistem autonomous adalah idealisasi, sama seperti konsep sistem linier. Dalam praktik sifat sistem sering berubah sangat lambat sehingga variasi waktunya bisa diabaikan tanpa kesalahan yang berarti.
- Untuk sistem kendali, definisi itu dikenakan pada dinamika *closed-loop*. Plant yang autonomous, $\dot{x} = f(x,u)$, tetap menghasilkan closed-loop non-autonomous kalau hukum kendalinya bergantung waktu, $u = g(x,t)$. Jadi sifat non-autonomous bisa datang dari pengendalinya, bukan cuma dari plant-nya.

## Kenapa sistem nonlinier perlu perlakuan khusus

Sistem linier waktu-invarian punya sifat yang membuat analisisnya mudah [@slotine1991]: titik kesetimbangannya tunggal kalau matriks $A$ nonsingular, kestabilannya ditentukan eigenvalue tanpa peduli kondisi awal, berlaku prinsip superposisi, dan input sinusoidal menghasilkan output sinusoidal dengan frekuensi yang sama.

Sistem nonlinier tidak begitu. [@slotine1991] mendaftar beberapa perilaku yang khas nonlinier:

- **Multiple equilibrium points** — titik kesetimbangan bisa lebih dari satu, dan perilaku sistem sangat bergantung pada kondisi awal.
- **Limit cycles** — osilasi mandiri dengan amplitudo tertentu, tanpa perlu eksitasi dari luar.
- **Bifurcations** — perubahan kecil pada parameter dapat mengubah struktur kualitatif responsnya.
- **Chaos** — respons yang sangat sensitif terhadap kondisi awal.

> Menurut [@slotine1991], semua sistem fisik sebenarnya nonlinier. Pendekatan linier baru masuk akal kalau rentang operasinya sempit dan nonlinieritasnya mulus. Di luar itu, linierisasi kehilangan perilaku yang justru penting.
