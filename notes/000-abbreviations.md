---
title: "000 — Abbreviations & Notasi Standar"
section: Dasar Teori
tags: [dasar]
summary: Simbol dan singkatan standar yang dipakai di seluruh catatan ini. Paper lain mungkin memakai notasi berbeda — kita konversikan ke notasi di sini.
permalink: /000-abbreviations.html
folder: notes
last_updated: Jul 23, 2026
---

Halaman ini mengumpulkan **notasi standar kita** — simbol dan singkatan yang dipakai konsisten di seluruh catatan. Paper yang akan dibahas berikutnya kadang memakai lambang berbeda; rujukannya selalu ke tabel di sini, dan notasi paper itu kita konversikan menjadi notasi kita.

## Singkatan

| Singkatan | Kepanjangan |
|---|---|
| CSTR | *Continuous Stirred Tank Reactor* |
| SISO | *Single-Input Single-Output* |
| MIMO | *Multi-Input Multi-Output* |
| LTI | *Linear Time-Invariant* |
| LTV | *Linear Time-Varying* |
| I/O | *Input-Output* |
| GLC | *Globally Linearizing Control* |
| FL | *Feedback Linearization* |
| PI / PID | *Proportional-Integral / -Derivative* |
| ODE / PDE | *Ordinary / Partial Differential Equation* |

## Sistem & sinyal

| Simbol | Arti | Nota |
|---|---|---|
| $x$ | vektor state internal, $x = (x_1, \dots, x_n)$ | 001 |
| $x_i$ | komponen ke-$i$ dari state | 001 |
| $n$ | dimensi ruang state | 001 |
| $u$ | input kendali (*manipulated input*), skalar | 001 |
| $y$ | output terukur, skalar | 001 |
| $d$ | vektor gangguan (*disturbance*) | 002 |
| $p$ | dimensi vektor gangguan | 002 |
| $m$ | jumlah input (kasus MIMO) | 004 |
| $t$ | waktu | 003 |
| $\dot{x}$ | turunan waktu, $dx/dt$ | 001 |
| $x^{(k)}$ | turunan waktu ke-$k$ dari $x$ | 201 |
| $x^\circ$ | titik operasi / titik acuan | 202 |
| $\mathbb{R}^n$ | ruang Euclid $n$-dimensi | 001 |

## Vector field & fungsi

| Simbol | Arti | Nota |
|---|---|---|
| $f(x)$ | *drift* vector field, $f : \mathbb{R}^n \to \mathbb{R}^n$ | 001, 004 |
| $g(x)$ | input (*control*) vector field | 001 |
| $p(x)$ | *disturbance* vector field (bentuk affine) | 002 |
| $h(x)$ | fungsi output, $h : \mathbb{R}^n \to \mathbb{R}$ | 001 |
| $f(x, d, u)$ | drift model nonlinier umum (non-affine) | 002 |
| $f(x, d, u, t)$ | bentuk *non-autonomous* | 003 |

## Sistem linier

| Simbol | Arti | Nota |
|---|---|---|
| $A$ | matriks state | 001 |
| $B$ | matriks input | 001 |
| $C$ | matriks output | 001 |
| $H(s)$ | transfer function, $C(sI - A)^{-1}B$ | 202 |
| $s$ | variabel Laplace | 001 |
| $T$ | matriks *change of coordinates* linier, $z = Tx$ | 008 |

## Geometri diferensial

| Simbol | Arti | Nota |
|---|---|---|
| $U$ | himpunan terbuka $\subseteq \mathbb{R}^n$ (ruang state) | 004 |
| $V,\; V^\star$ | ruang vektor dan *dual space*-nya | 005 |
| $w^\star$ | covector (vektor baris) | 005 |
| $\langle w^\star, v \rangle$ | *inner product* / pemasangan covector–vektor | 005 |
| $\omega(x)$ | covector field | 005 |
| $d\lambda$ | *differential* (gradient) dari fungsi $\lambda$ | 006 |
| $\dfrac{\partial \lambda}{\partial x}$ | Jacobian / gradient | 006 |
| $L_f h$ | *Lie derivative* $h$ sepanjang $f$ | 007 |
| $L_f^k h$ | Lie derivative ber-iterasi $k$ kali | 007 |
| $L_g L_f h$ | Lie derivative campuran | 007 |
| $[f, g]$ | *Lie bracket* (*Lie product*) | 007 |
| $\mathrm{ad}_f^k g$ | Lie bracket berulang (*adjoint*) | 007 |
| $\Phi(x)$ | *change of coordinates* (diffeomorphism) | 008 |
| $\Phi^{-1}$ | inversnya | 008 |
| $z$ | koordinat baru, $z = \Phi(x)$ | 008 |
| $\phi_i(x)$ | fungsi koordinat ke-$i$ | 008, 203 |

## Feedback linearization & relative degree

| Simbol | Arti | Nota |
|---|---|---|
| $r$ | *relative degree* | 202 |
| $v$ | input ekuivalen (*synthetic input*) | 201 |
| $\tilde{h}$ | error, $h(t) - h_d$ | 201 |
| $h_d,\; x_d$ | nilai / lintasan yang diinginkan (*desired*) | 201 |
| $\alpha$ | konstanta positif tegas (gain) | 201 |
| $k_i$ | gain umpan balik (*pole placement*) | 201 |
| $e(t)$ | *tracking error*, $x(t) - x_d(t)$ | 201 |
| $a(z),\; b(z)$ | koefisien *normal form* | 203 |
| $q_i(z),\; p_i(z)$ | fungsi *internal dynamics* | 203 |
| $\bar{f},\; \bar{g},\; \bar{h}$ | $f, g, h$ dinyatakan dalam koordinat baru $z$ | 204 |

## Simbol khusus contoh (proses / CSTR)

Simbol berikut **bergantung contoh** — tiap paper mendefinisikan sendiri. Yang tercantum di sini adalah yang dipakai di catatan reaktor.

| Simbol | Arti | Nota |
|---|---|---|
| $C_A,\; C_{Ai}$ | konsentrasi reaktan A (di tangki $i$) | 101 |
| $T,\; T_i$ | temperatur (tangki $i$) | 101 |
| $q$ | laju alir proses | 101 |
| $q_c$ | laju alir pendingin — *input* pada contoh 101 | 101 |
| $V_i$ | volume tangki $i$ | 101 |
| $T_{cf},\; T_f$ | temperatur umpan pendingin / proses | 101 |
| $k_0,\; E,\; R$ | faktor pre-eksponensial, energi aktivasi, konstanta gas | 101 |
| $\Delta H,\; \rho,\; C_p$ | kalor reaksi, densitas, kapasitas panas | 101 |
| $hA_i$ | koefisien $\times$ luas perpindahan panas | 101 |
| $\mathrm{Da}$ | bilangan Damköhler (tak berdimensi) | 102 |
| $B,\; \beta,\; \gamma$ | kalor reaksi, koef. perpindahan panas, energi aktivasi (tak berdimensi) | 102 |
| $\tau$ | waktu tak berdimensi | 102 |

## Awas tabrakan simbol

Beberapa lambang dipakai untuk hal berbeda tergantung konteks — perhatikan baik-baik saat membaca:

- $g$ — vector field input $g(x)$ (kendali), **tapi** di contoh tangki 201 $g$ adalah percepatan gravitasi.
- $a$ — koefisien $a(z)$ pada normal form 203, **tapi** di contoh tangki $a$ adalah luas penampang pipa keluar.
- $B$ — matriks input sistem linier, **tapi** di 102 $B$ adalah kalor reaksi tak berdimensi.
- $p$ — dimensi vektor gangguan, **tapi** juga dipakai untuk $p(x)$ (disturbance vector field) dan $p_i(z)$ (internal dynamics).
- $h$ — fungsi output $h(x)$, **tapi** di contoh tangki $h$ adalah tinggi cairan.

## Cara konversi

Saat membaca paper baru dengan notasi berbeda, langkahnya sederhana: identifikasi peran tiap lambang (mana state, mana input, mana output, mana vector field), lalu petakan ke kolom **Simbol** di atas. Misalnya paper yang menulis state sebagai $\xi$, input sebagai $\nu$, dan output sebagai $\eta$ kita tuliskan ulang sebagai $x$, $u$, $y$. Tujuannya supaya seluruh catatan memakai satu bahasa simbol yang sama.
