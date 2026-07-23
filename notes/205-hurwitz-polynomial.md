---
title: 205 — Hurwitz Polynomial
section: Feedback Linearization
tags: [feedback-linearization]
summary: Polinomial yang semua akarnya di paruh kiri bidang kompleks — syarat agar dinamika error hasil pole placement meluruh stabil.
permalink: /205-hurwitz-polynomial.html
folder: notes
last_updated: Jul 23, 2026
---

Di langkah *pole placement* pada [feedback linearization](201-feedback-linearization-konsep.html), gain $k_i$ dipilih supaya sebuah polinomial karakteristik jadi **Hurwitz**. Halaman ini menjelaskan artinya.

## Definisi

Sebuah polinomial

$$
p(s) = s^n + a_{n-1}s^{n-1} + \dots + a_1 s + a_0
$$

disebut **Hurwitz** (atau *stabil*) kalau **semua akarnya punya bagian real negatif tegas** — yaitu semua akar berada di **paruh kiri terbuka** bidang kompleks ($\operatorname{Re}(s) < 0$).

## Kenapa penting

Setelah feedback linearization, dinamika error $e = y - y_d$ menjadi persamaan diferensial **linier** dengan polinomial karakteristik $p(s)$:

$$
e^{(n)} + a_{n-1}e^{(n-1)} + \dots + a_1 \dot{e} + a_0 e = 0
$$

Solusinya berupa kombinasi $e^{\lambda_i t}$ dengan $\lambda_i$ akar-akar $p(s)$. Jadi:

$$
p(s) \text{ Hurwitz} \iff e(t) \to 0 \text{ secara eksponensial}
$$

Kalau ada satu akar saja dengan $\operatorname{Re}(\lambda) \geq 0$, error tidak meluruh — trackingnya gagal. Itulah kenapa syarat Hurwitz muncul di [201 — Feedback Linearization: Konsep Intuitif](201-feedback-linearization-konsep.html) dan di control law [Wu (eq 13)](301a-wu-1999-motivasi.html).

## Syarat perlu: semua koefisien positif

Syarat **perlu** (tapi belum tentu cukup) agar $p(s)$ Hurwitz: semua koefisien $a_i > 0$ (bertanda sama). Kalau ada koefisien nol atau berlawanan tanda, pasti **bukan** Hurwitz. Untuk $n \leq 2$ syarat ini sekaligus cukup; untuk $n \geq 3$ belum tentu.

## Kriteria Routh–Hurwitz

Untuk mengecek tanpa menghitung akar, dipakai **kriteria Routh–Hurwitz** [@seborg]: $p(s)$ Hurwitz jika dan hanya jika semua elemen kolom pertama *array Routh* bertanda sama (positif). Kasus kecil yang sering dipakai:

| Orde | $p(s)$ | Syarat Hurwitz |
|---|---|---|
| $n=1$ | $s + a_0$ | $a_0 > 0$ |
| $n=2$ | $s^2 + a_1 s + a_0$ | $a_1 > 0,\; a_0 > 0$ |
| $n=3$ | $s^3 + a_2 s^2 + a_1 s + a_0$ | $a_2, a_1, a_0 > 0$ dan $a_2 a_1 > a_0$ |

## Kaitan dengan pole placement

Di feedback linearization, setelah nonlinieritas dibatalkan, kita bebas menaruh akar-akar $p(s)$ di mana saja lewat gain $k_i$. Menaruhnya di paruh kiri (membuat $p$ Hurwitz) memberi dinamika error yang stabil. Makin jauh ke kiri akarnya, makin cepat error meluruh — tapi butuh usaha kendali lebih besar. Ini pertukaran (*trade-off*) baku dalam desain.
