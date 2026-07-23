---
title: 204 — Change of Coordinates
section: Feedback Linearization
tags: [feedback-linearization]
summary: Bagaimana change of coordinates z = Phi(x) mengubah persamaan sistem, dan kriteria Jacobian untuk memastikan transformasinya sah (Isidori 1.2).
permalink: /204-change-of-coordinates.html
folder: notes
last_updated: Jul 23, 2026
---

[203 — Normal Form](203-normal-form.html) memakai sebuah change of coordinates tertentu untuk membawa sistem ke bentuk baku. Di sini kita mundur sedikit: bagaimana sebenarnya sebuah change of coordinates $z = \Phi(x)$ mengubah persamaan sistem, dan kapan transformasinya sah [@isidori1995]. Definisi global vs local diffeomorphism-nya sendiri ada di [008 — Global Diffeomorphism](008-global-diffeomorphism.html).

## Efek pada persamaan sistem

Ambil change of coordinates $z(t) = \Phi(x(t))$ dan turunkan terhadap waktu:

$$
\dot{z}(t) = \frac{\partial \Phi}{\partial x}\frac{dx}{dt} = \frac{\partial \Phi}{\partial x}\bigl[f(x(t)) + g(x(t))u(t)\bigr]
$$

Nyatakan $x(t) = \Phi^{-1}(z(t))$, maka sistem dalam koordinat baru menjadi

$$
\dot{z}(t) = \bar{f}(z(t)) + \bar{g}(z(t))\,u(t), \qquad y(t) = \bar{h}(z(t))
$$

dengan

$$
\bar{f}(z) = \left[\frac{\partial \Phi}{\partial x}f(x)\right]_{x = \Phi^{-1}(z)}, \quad
\bar{g}(z) = \left[\frac{\partial \Phi}{\partial x}g(x)\right]_{x = \Phi^{-1}(z)}, \quad
\bar{h}(z) = \bigl[h(x)\bigr]_{x = \Phi^{-1}(z)}
$$

Inilah rumus yang menghubungkan deskripsi baru sistem dengan yang lama [@isidori1995]. Kalau sistemnya linier dan $\Phi(x) = Tx$, rumus ini menyusut jadi $\bar{A} = TAT^{-1},\; \bar{B} = TB,\; \bar{C} = CT^{-1}$ yang sudah dikenal ([008 — Global Diffeomorphism](008-global-diffeomorphism.html)).

## Kriteria Jacobian untuk local diffeomorphism

Bagaimana memastikan $\Phi$ benar-benar change of coordinates yang sah, minimal secara lokal? Tidak perlu membuktikan invertibilitas global — cukup cek Jacobian-nya.

**Proposition 1.2.3** [@isidori1995]. *Suppose $\Phi(x)$ is a smooth function defined on some subset $U$ of $\mathbb{R}^n$. Suppose the jacobian matrix of $\Phi$ is nonsingular at a point $x = x^\circ$. Then, on a suitable open subset $U^\circ$ of $U$, containing $x^\circ$, $\Phi(x)$ defines a local diffeomorphism.*

Ini konsekuensi *inverse function theorem*, dan inilah kriteria praktis yang dipakai [203 — Normal Form](203-normal-form.html): cukup pastikan $\partial \Phi / \partial x$ nonsingular, tak perlu mencari inversnya secara eksplisit.

## Contoh

**Example 1.2.2** [@isidori1995] — fungsi

$$
\begin{bmatrix} z_1 \\ z_2 \end{bmatrix} = \Phi(x_1, x_2) = \begin{bmatrix} x_1 + x_2 \\ \sin x_2 \end{bmatrix}
$$

punya Jacobian

$$
\frac{\partial \Phi}{\partial x} = \begin{bmatrix} 1 & 1 \\ 0 & \cos x_2 \end{bmatrix}
$$

yang ber-rank 2 di $x^\circ = (0, 0)$. Pada himpunan $U^\circ = \{(x_1, x_2) : |x_2| < \pi/2\}$ fungsi ini adalah diffeomorphism. Tapi pada himpunan yang lebih besar sifat invertibilitasnya hilang: untuk tiap $x_2$ dengan $|x_2| > \pi/2$ ada $x_2'$ dengan $|x_2'| < \pi/2$ dan $\sin x_2 = \sin x_2'$, sehingga $\Phi$ tak lagi injektif. Ini menegaskan beda **local** dan **global** diffeomorphism ([008 — Global Diffeomorphism](008-global-diffeomorphism.html)).

**Example 1.2.3** [@isidori1995] — fungsi

$$
\begin{bmatrix} z_1 \\ z_2 \end{bmatrix} = \Phi(x_1, x_2) = \begin{bmatrix} x_1 \\ x_2 - \dfrac{1}{x_1 + 1} \end{bmatrix}
$$

adalah diffeomorphism (ke image-nya) pada $U^\circ = \{(x_1, x_2) : x_1 > -1\}$, karena $\Phi(x_1, x_2) = \Phi(x_1', x_2')$ memaksa $x_1 = x_1'$ dan $x_2 = x_2'$. Tapi fungsi ini tidak terdefinisi di seluruh $\mathbb{R}^2$ (singular di $x_1 = -1$).
