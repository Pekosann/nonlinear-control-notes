---
title: 202 — Relative Degree
section: Feedback Linearization
tags: [feedback-linearization]
summary: Definisi relative degree, tafsirannya sebagai berapa kali output diturunkan sampai input muncul, kasus sistem linier, dan contoh Van der Pol (Isidori 4.1).
permalink: /202-relative-degree.html
folder: notes
last_updated: Jul 23, 2026
---

Titik berangkat seluruh analisis feedback linearization adalah **relative degree** [@isidori1995]. Konsep ini yang menentukan berapa kali kita perlu menurunkan output sebelum bisa "menyentuh" input — dan itulah yang menjadi tulang punggung [201 — Feedback Linearization: Konsep Intuitif](201-feedback-linearization-konsep.html).

## Definisi

Tinjau sistem nonlinier *single-input single-output* yang [control-affine](001-sistem-nonlinier-control-affine.html):

$$
\dot{x} = f(x) + g(x)u, \qquad y = h(x) \tag{1}
$$

Sistem ini dikatakan punya **relative degree $r$** pada titik $x^\circ$ jika [@isidori1995]:

- **(i)** $\; L_g L_f^k h(x) = 0\;$ untuk semua $x$ di sekitar $x^\circ$ dan semua $k < r - 1$;
- **(ii)** $\; L_g L_f^{r-1} h(x^\circ) \neq 0$.

Di sini $L_f$ dan $L_g$ adalah [Lie derivative](007-differential-operations.html) sepanjang $f$ dan $g$.

## Tafsiran: berapa kali output diturunkan sampai input muncul

Ini tafsiran yang paling terpakai. Misalkan pada waktu $t^\circ$ sistem berada di state $x(t^\circ) = x^\circ$, dan kita hitung output beserta turunan-turunannya terhadap waktu.

Turunan pertama — persis pemasangan gradient output dengan dinamika yang dibahas di [005 — Covector Field](005-covector-field.html):

$$
y^{(1)} = \frac{\partial h}{\partial x}\dot{x} = \frac{\partial h}{\partial x}\bigl(f(x) + g(x)u\bigr) = L_f h(x) + L_g h(x)\,u
$$

Kalau $r > 1$, suku $L_g h(x) = 0$ di sekitar $x^\circ$, jadi $u$ **belum** muncul:

$$
y^{(1)} = L_f h(x)
$$

Turunkan sekali lagi:

$$
y^{(2)} = L_f^2 h(x) + L_g L_f h(x)\,u
$$

Kalau $r > 2$, lagi-lagi $L_g L_f h(x) = 0$ dan $u$ belum muncul. Begini seterusnya, sampai akhirnya di turunan ke-$r$:

$$
y^{(k)} = L_f^k h(x), \quad k < r; \qquad
y^{(r)} = L_f^r h(x) + \underbrace{L_g L_f^{r-1} h(x)}_{\neq\,0}\,u
$$

Di turunan ke-$r$ inilah input $u$ akhirnya muncul secara eksplisit, karena syarat (ii) menjamin koefisiennya tidak nol. Jadi:

> **Relative degree $r$ adalah berapa kali output $y(t)$ harus diturunkan terhadap waktu agar input $u$ muncul secara eksplisit** [@isidori1995].

Kalau $L_g L_f^k h(x) = 0$ untuk semua $k \geq 0$ (relative degree tak terdefinisi), artinya output sama sekali tidak dipengaruhi input.

## Kasus sistem linier

Untuk sistem linier $\dot{x} = Ax + Bu,\; y = Cx$ — yaitu $f(x) = Ax$, $g(x) = B$, $h(x) = Cx$ — mudah diperoleh

$$
L_f^k h(x) = C A^k x, \qquad L_g L_f^k h(x) = C A^k B
$$

sehingga $r$ dicirikan oleh

$$
C A^k B = 0 \;\; (k < r-1), \qquad C A^{r-1} B \neq 0
$$

Angka ini persis **selisih antara derajat penyebut dan derajat pembilang** dari transfer function $H(s) = C(sI - A)^{-1}B$ [@isidori1995]. Jadi relative degree adalah generalisasi nonlinier dari "pole minus zero" yang sudah dikenal di kendali linier.

## Contoh: osilator Van der Pol

Tinjau osilator Van der Pol terkendali [@isidori1995]:

$$
\dot{x} = f(x) + g(x)u =
\begin{bmatrix} x_2 \\ 2\omega\zeta(1 - \mu x_1^2)x_2 - \omega^2 x_1 \end{bmatrix}
+ \begin{bmatrix} 0 \\ 1 \end{bmatrix} u
$$

Ambil output $y = h(x) = x_1$. Maka

$$
L_g h(x) = \frac{\partial h}{\partial x} g(x) = \begin{bmatrix} 1 & 0 \end{bmatrix}\begin{bmatrix} 0 \\ 1 \end{bmatrix} = 0
$$

$$
L_f h(x) = \frac{\partial h}{\partial x} f(x) = \begin{bmatrix} 1 & 0 \end{bmatrix}\begin{bmatrix} x_2 \\ \cdots \end{bmatrix} = x_2
$$

$$
L_g L_f h(x) = \frac{\partial (L_f h)}{\partial x} g(x) = \begin{bmatrix} 0 & 1 \end{bmatrix}\begin{bmatrix} 0 \\ 1 \end{bmatrix} = 1 \neq 0
$$

Karena $L_g h = 0$ tapi $L_g L_f h = 1 \neq 0$, sistem ini punya **relative degree 2** di titik mana pun.

Kalau outputnya diganti $y = h(x) = \sin x_2$, maka $L_g h(x) = \cos x_2$. Sistemnya punya relative degree 1 di sembarang $x^\circ$ **asalkan** $(x^\circ)_2 \neq (2k+1)\pi/2$. Kalau syarat ini dilanggar, relative degree tak terdefinisi di titik itu.

## Kaitan dengan contoh reaktor

Di [101 — Dua Tangki CSTR](101-dua-tangki-CSTR.html) output $y = C_{A2} = x_3$ menghasilkan $L_f h = f_3$ yang tidak memuat $u = q_c$, jadi perlu diturunkan sekali lagi — persis kesimpulan Henson & Seborg bahwa reaktornya punya relative degree 2. Titik penting: relative degree hanya terdefinisi rapi kalau sistemnya control-affine ([001 — Sistem Nonlinier Control Affine](001-sistem-nonlinier-control-affine.html)); untuk model non-affine seperti CSTR itu, [@henson1990] harus memakai *generalized* Lie derivative.
