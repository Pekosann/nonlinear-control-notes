---
title: 102 — CSTR Orde-n Adebekun
section: Example
tags: [cstr, control-affine]
summary: "CSTR non-isotermal reaksi orde-n dalam bentuk tak berdimensi (Adebekun & Schork 1991), dan kenapa modelnya control-affine."
permalink: /102-adebekun-cstr-orde-n.html
folder: notes
last_updated: Jul 23, 2026
---

CSTR dengan kinetika eksotermik adalah sistem nonlinier kanonik: bisa punya *steady-state multiplicity*, *limit cycle*, dan perilaku eksotik lain [@adebekun1991]. [@adebekun1991] merumuskan pengendali *reference model* untuk reaktor ini dan membuktikan **stabilisasi global** untuk reaksi eksotermik orde tak-negatif berapa pun, $n \in [0, \infty)$. Variabel yang dimanipulasi adalah temperatur jaket.

## Model Reaktor (Tak Berdimensi)

State-nya $x = [x_1, x_2]^T$: $x_1$ konversi tak berdimensi, $x_2$ temperatur tak berdimensi. Untuk reaksi orde-$n$, modelnya [@adebekun1991]:

Neraca massa (Pers. 10 di paper):

$\dot{x}_1 = -x_1 + \mathrm{Da}\,(1 - x_1)^n \exp\!\left[\dfrac{x_2}{1 + x_2/\gamma}\right]\quad(1)$

Neraca energi (Pers. 11 di paper):

$\dot{x}_2 = -x_2 + B\,\mathrm{Da}\,(1 - x_1)^n \exp\!\left[\dfrac{x_2}{1 + x_2/\gamma}\right] - \beta(x_2 - x_{2c}) + \beta\,u + d\quad(2)$

Kasus orde-satu ($n = 1$) tinggal mengganti $(1-x_1)^n \to (1-x_1)$. Untuk orde-nol ($n = 0$), suku $(1-x_1)^n$ di-set identik dengan satu — laju konsumsi reaksi orde-nol memang tidak bergantung pada konsentrasi [@adebekun1991].

## Variabel dan Kelompok Tak Berdimensi

$$
\tau = \frac{t'F}{V}, \quad
x_1 = \frac{c_{af} - c_a}{c_{af}}, \quad
x_2 = \frac{T - T_{f0}}{T_{f0}}\,\gamma
$$

$$
x_{2c} = \frac{T_{c0} - T_{f0}}{T_{f0}}\,\gamma, \quad
u = x_2(T_c) - x_2(T_{c0}), \quad
d = \frac{T_f - T_{f0}}{T_{f0}}\,\gamma
$$

Kelompok tak berdimensinya:

$$
B = \frac{(-\Delta H)\,c_{af}\,\gamma}{\rho\,c_p\,T_{f0}}, \quad
\beta = \frac{hA}{F\rho\,c_p}, \quad
\gamma = \frac{E}{R\,T_{f0}}, \quad
\mathrm{Da} = \frac{k_0\,V\,e^{-\gamma}}{F}
$$

$B$ = kalor reaksi, $\beta$ = koefisien perpindahan panas, $\gamma$ = energi aktivasi, dan $\mathrm{Da}$ = bilangan Damköhler (bergantung $n$). Semua turunan waktu diambil terhadap waktu tak berdimensi $\tau$. Input $u$ adalah simpangan temperatur jaket, dan $d$ adalah gangguan dari temperatur umpan.

## Bentuk Umum dan Struktur Control-Affine

Dengan $x = [x_1, x_2]^T$, model Pers. (1)–(2) bisa ditulis padat sebagai

$$
\dot{x} = f(x) + g\,u + p\,d, \qquad y = h(x) \tag{3}
$$

Berbeda dengan [101 — Dua Tangki CSTR](101-dua-tangki-CSTR.html) yang non-affine, sistem ini **control-affine** (lihat [001 — Sistem Nonlinier Control Affine](001-sistem-nonlinier-control-affine.html)). Sebabnya: input $u$ hanya muncul sekali, di suku $+\beta u$ pada neraca energi, secara linier. Jadi

$$
f(x) =
\begin{bmatrix}
-x_1 + \mathrm{Da}\,(1 - x_1)^n \exp\!\left[\dfrac{x_2}{1 + x_2/\gamma}\right] \\[10pt]
-x_2 + B\,\mathrm{Da}\,(1 - x_1)^n \exp\!\left[\dfrac{x_2}{1 + x_2/\gamma}\right] - \beta(x_2 - x_{2c})
\end{bmatrix}, \quad
g = \begin{bmatrix} 0 \\ \beta \end{bmatrix}, \quad
p = \begin{bmatrix} 0 \\ 1 \end{bmatrix}
$$

$g$ dan $p$ konstan — tidak bergantung $x$ — karena $u$ dan $d$ sama-sama masuk secara linier ke neraca energi. Inilah struktur pada Pers. (1) di [002 — Sistem Nonlinier Umum](002-sistem-nonlinier.html), dengan gangguan $d$ yang juga affine.

> Karena affine, hukum kendali untuk membatalkan dinamika drift bisa diturunkan secara eksplisit. Di sinilah [@adebekun1991] membangun pengendali reference model-nya, dan membuktikan stabilisasi global asalkan gain pengendali $k > 0$ — tanpa perlu tuning ulang ketika orde reaksi $n$ berubah.
