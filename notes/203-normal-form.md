---
title: 203 — Normal Form
section: Feedback Linearization
tags: [feedback-linearization]
summary: Change of coordinates yang membawa sistem relative degree r ke normal form — rantai integrator plus internal dynamics (Isidori 4.1).
permalink: /203-normal-form.html
folder: notes
last_updated: Jul 23, 2026
---

Kalau sebuah sistem punya [relative degree](202-relative-degree.html) $r$, ada change of coordinates yang membawanya ke bentuk baku yang disebut **normal form** [@isidori1995]. Bentuk ini yang membuat banyak persoalan kendali jadi transparan.

## Koordinat baru

Kunci utamanya: $r$ fungsi berikut memenuhi syarat sebagai koordinat baru di sekitar $x^\circ$.

**Lemma 4.1.1** [@isidori1995] — vektor baris $dh(x^\circ),\, dL_f h(x^\circ),\, \dots,\, dL_f^{r-1}h(x^\circ)$ saling bebas linier. Karena itu (lewat kriteria Jacobian di [204 — Change of Coordinates](204-change-of-coordinates.html)) fungsi-fungsi $h, L_f h, \dots, L_f^{r-1}h$ layak menjadi sebagian koordinat baru.

**Proposition 4.1.3** [@isidori1995] — kalau sistem punya relative degree $r$ di $x^\circ$, maka $r \leq n$. Ambil

$$
z_1 = \phi_1(x) = h(x), \quad
z_2 = \phi_2(x) = L_f h(x), \quad \dots, \quad
z_r = \phi_r(x) = L_f^{r-1}h(x)
$$

Kalau $r < n$, selalu bisa dicari $n - r$ fungsi tambahan $\phi_{r+1}(x), \dots, \phi_n(x)$ sehingga pemetaan $\Phi(x) = (\phi_1(x), \dots, \phi_n(x))^T$ punya Jacobian nonsingular di $x^\circ$ — jadi memenuhi syarat sebagai change of coordinates lokal. Fungsi tambahan ini bahkan bisa dipilih supaya

$$
L_g \phi_i(x) = 0, \qquad r+1 \leq i \leq n
$$

## Menurunkan persamaannya

Dalam koordinat $z_i = \phi_i(x)$, tiap $\dot{z}_i$ tinggal dihitung. Untuk $r$ koordinat pertama:

$$
\dot{z}_1 = \frac{\partial h}{\partial x}\dot{x} = L_f h(x) = \phi_2(x) = z_2
$$

dan seterusnya $\dot{z}_2 = z_3, \dots, \dot{z}_{r-1} = z_r$. Untuk koordinat ke-$r$, input muncul (persis definisi relative degree):

$$
\dot{z}_r = L_f^r h(x) + L_g L_f^{r-1}h(x)\,u
$$

Nyatakan $x = \Phi^{-1}(z)$ dan definisikan

$$
a(z) = L_g L_f^{r-1}h(\Phi^{-1}(z)), \qquad b(z) = L_f^r h(\Phi^{-1}(z))
$$

sehingga $\dot{z}_r = b(z) + a(z)\,u$. Di titik $z^\circ = \Phi(x^\circ)$, koefisien $a(z^\circ) \neq 0$ menurut definisi, jadi $a(z)$ tak nol di sekitar $z^\circ$.

Untuk koordinat sisanya, karena dipilih $L_g \phi_i = 0$:

$$
\dot{z}_i = \frac{\partial \phi_i}{\partial x}\bigl(f(x) + g(x)u\bigr) = L_f \phi_i(x), \qquad r+1 \leq i \leq n
$$

Definisikan $q_i(z) = L_f \phi_i(\Phi^{-1}(z))$, maka $\dot{z}_i = q_i(z)$ — tanpa input.

## Normal form

Ringkasnya, deskripsi state-space dalam koordinat baru menjadi [@isidori1995]:

$$
\begin{aligned}
\dot{z}_1 &= z_2 \\
\dot{z}_2 &= z_3 \\
&\;\;\vdots \\
\dot{z}_{r-1} &= z_r \\
\dot{z}_r &= b(z) + a(z)\,u \\
\dot{z}_{r+1} &= q_{r+1}(z) \\
&\;\;\vdots \\
\dot{z}_n &= q_n(z)
\end{aligned}
\tag{4.8}
$$

dengan output

$$
y = z_1 \tag{4.9}
$$

$r$ persamaan pertama adalah **rantai integrator murni** ($\dot{z}_1 = z_2, \dots, \dot{z}_{r-1} = z_r$), lalu satu persamaan tempat input masuk ($\dot{z}_r = b + a\,u$). Sisa $n - r$ persamaan — $\dot{z}_{r+1} = q_{r+1}, \dots$ — adalah **internal dynamics**: bagian yang tidak terlihat dari output dan tidak langsung disentuh input.

## Kalau syarat $L_g \phi_i = 0$ tidak dipenuhi

**Remark 4.1.3** [@isidori1995] — mencari $\phi_{r+1}, \dots, \phi_n$ dengan $L_g \phi_i = 0$ berarti menyelesaikan $n - r$ persamaan diferensial parsial, yang tak selalu mudah. Lebih praktis cukup mencari fungsi yang membuat Jacobian $\Phi$ nonsingular saja. $r$ persamaan pertama tetap sama, tapi $n - r$ terakhir kini memuat input:

$$
\dot{z}_{r+1} = q_{r+1}(z) + p_{r+1}(z)\,u, \quad \dots, \quad
\dot{z}_n = q_n(z) + p_n(z)\,u
$$

## Contoh (Example 4.1.4)

Tinjau sistem [@isidori1995]

$$
\dot{x} =
\begin{bmatrix} -x_1 \\ x_1 x_2 \\ x_2 \end{bmatrix}
+ \begin{bmatrix} \exp(x_2) \\ 1 \\ 0 \end{bmatrix} u,
\qquad y = h(x) = x_3
$$

Hitung:

$$
\frac{\partial h}{\partial x} = \begin{bmatrix} 0 & 0 & 1 \end{bmatrix}, \quad
L_g h = 0, \quad L_f h = x_2, \quad
\frac{\partial (L_f h)}{\partial x} = \begin{bmatrix} 0 & 1 & 0 \end{bmatrix}, \quad
L_g L_f h = 1
$$

jadi relative degree $= 2$. Ambil $z_1 = h = x_3$, $z_2 = L_f h = x_2$, dan cari $\phi_3$ dengan $\dfrac{\partial \phi_3}{\partial x}g = \dfrac{\partial \phi_3}{\partial x_1}\exp(x_2) + \dfrac{\partial \phi_3}{\partial x_2} = 0$. Fungsi

$$
\phi_3(x) = 1 + x_1 - \exp(x_2)
$$

memenuhinya. Ketiga fungsi ini membentuk $z = \Phi(x)$ dengan Jacobian

$$
\frac{\partial \Phi}{\partial x} =
\begin{bmatrix} 0 & 0 & 1 \\ 0 & 1 & 0 \\ 1 & -\exp(x_2) & 0 \end{bmatrix}
$$

yang nonsingular untuk semua $x$, dan inversnya $x_1 = -1 + z_3 + \exp(z_2),\; x_2 = z_2,\; x_3 = z_1$ (dengan $\Phi(0) = 0$). Dalam koordinat baru sistemnya menjadi

$$
\begin{aligned}
\dot{z}_1 &= z_2 \\
\dot{z}_2 &= (-1 + z_3 + \exp(z_2))z_2 + u \\
\dot{z}_3 &= (1 - z_3 - \exp(z_2))(1 + z_2 \exp(z_2))
\end{aligned}
$$

$\dot{z}_1 = z_2$ adalah integrator, $\dot{z}_2$ memuat input $u$, dan $\dot{z}_3$ adalah internal dynamics. Karena transformasinya global, persamaan ini berlaku global juga — mekanisme change of coordinates-nya dibahas di [204 — Change of Coordinates](204-change-of-coordinates.html).
