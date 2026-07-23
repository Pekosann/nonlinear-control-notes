---
title: 003 — Sistem Autonomous dan Non-Autonomous
section: Dasar Teori
tags: [dasar]
summary: Kapan waktu ikut masuk sebagai variabel, istilah autonomous vs non-autonomous, dan kenapa pembedaan ini penting untuk analisis kestabilan.
permalink: /003-autonomous-dan-non-autonomous.html
folder: notes
last_updated: Jul 22, 2026
---

Model di [002 — Sistem Nonlinier Umum](002-sistem-nonlinier.html) menganggap bentuk $f$ tetap sepanjang waktu. Kalau karakteristik prosesnya sendiri berubah — katalis terdeaktivasi, permukaan penukar panas ter-*fouling*, kondisi ambient bergeser — waktu harus ikut masuk sebagai variabel tersendiri.

## Definisi

[@slotine1991] menulis sistem dinamik nonlinier secara umum sebagai

$\dot{x} = f(x,t)\quad(1)$

dengan $f$ fungsi vektor nonlinier berukuran $n \times 1$ dan $x$ vektor state $n \times 1$.

**Definisi 3.1** [@slotine1991]: sistem Pers. (1) disebut **autonomous** kalau $f$ tidak bergantung secara eksplisit pada waktu, yaitu bisa ditulis

$\dot{x} = f(x)\quad(2)$

Kalau $f$ bergantung eksplisit pada waktu, sistemnya disebut **non-autonomous**.

## Sistem linier

Pada sistem linier kita menggunakan *time-invariant* dan *time-varying*, tergantung apakah matriks $A$ berubah terhadap waktu atau tidak. Untuk konteks nonlinier yang lebih umum, [@slotine1991] mencatat bahwa kedua kata sifat itu secara tradisional diganti menjadi **autonomous** dan **non-autonomous**. Konsekuensinya, sistem LTI bersifat autonomous dan sistem LTV bersifat non-autonomous.

## Dengan input dan gangguan

Untuk model proses seperti di [002 — Sistem Nonlinier Umum](002-sistem-nonlinier.html), bentuk autonomous dan non-autonomous-nya menjadi

$\dot{x} = f(x, d, u)\quad\text{(autonomous)}\quad(3)$
$\dot{x} = f(x, d, u, t)\quad\text{(non-autonomous)}\quad(4)$

dengan output $y = h(x)$ pada keduanya. [@slotine1991] sendiri menulis dinamika plant sebagai $\dot{x} = f(x, u, t)$; suku gangguan $d$ ditambahkan mengikuti [@henson1990].

## Dua catatan penting

**Semua sistem fisik sebenarnya non-autonomous.** Menurut [@slotine1991], tidak ada karakteristik dinamik yang benar-benar tetap terhadap waktu. Sistem autonomous adalah idealisasi, sama seperti konsep sistem linier. Yang membuatnya berguna: dalam praktik sifat sistem sering berubah sangat lambat, sehingga variasi waktunya bisa diabaikan tanpa kesalahan yang berarti.

**Definisinya berlaku untuk dinamika *closed-loop*, bukan plant saja.** Ini yang sering terlewat. Sebuah sistem kendali terdiri dari pengendali dan plant, jadi sifat non-autonomous bisa datang dari mana saja di antara keduanya. Plant yang autonomous,

$\dot{x} = f(x,u)$

tetap menghasilkan closed-loop yang non-autonomous kalau hukum kendalinya bergantung pada waktu, $u = g(x,t)$ [@slotine1991]. Sebaliknya, kalau $u = g(x)$ saja, closed-loop-nya

$\dot{x} = f[x, g(x)]$

kembali berbentuk Pers. (2) — autonomous.

## Kenapa pembedaan ini penting

Analisis kestabilannya berbeda tingkat kesulitannya. [@slotine1991] menyusun teori Lyapunov dalam dua tahap: hasil-hasil dasarnya dibahas untuk sistem autonomous lebih dulu supaya kerumitan matematisnya tidak menutupi konsepnya, dan topik yang lebih lanjut untuk sistem non-autonomous ditinggalkan ke bab berikutnya.

Praktisnya: kalau prosesmu bisa dianggap autonomous, perangkat analisisnya jauh lebih sederhana. Jadi pertanyaan "apakah ini autonomous?" layak ditanyakan di awal, sebelum masuk ke perancangan pengendali.
