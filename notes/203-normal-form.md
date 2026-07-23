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

Kunci utamanya: $r$ fungsi $h, L_f h, \dots, L_f^{r-1}h$ memenuhi syarat sebagai sebagian koordinat baru di sekitar $x^\circ$, karena differential-nya saling bebas linier.

**Lemma 4.1.1** [@isidori1995]. *The row vectors*

$$
dh(x^\circ),\; dL_f h(x^\circ),\; \dots,\; dL_f^{r-1}h(x^\circ)
$$

*are linearly independent.*

### Kenapa saling bebas linier

Buktinya bertumpu pada satu trik: pasangkan $r$ covector itu dengan $r$ vektor khusus $g,\, \mathrm{ad}_f g,\, \dots,\, \mathrm{ad}_f^{r-1}g$ — yaitu $g$ beserta *Lie bracket* berulangnya dengan $f$ (lihat $\mathrm{ad}_f^k g$ di [007 — Three Types of Differential Operation](007-differential-operations.html)). Susun matriks $r \times r$ dengan entri

$$
M_{ji} = \langle dL_f^{\,j} h(x^\circ),\; \mathrm{ad}_f^{\,i} g(x^\circ) \rangle, \qquad i, j = 0, 1, \dots, r-1
$$

Dari definisi relative degree ([202 — Relative Degree](202-relative-degree.html)) diperoleh dua fakta:

$$
\langle dL_f^{\,j} h,\; \mathrm{ad}_f^{\,i} g \rangle = 0 \;\; (i + j \leq r-2), \qquad
\langle dL_f^{\,j} h(x^\circ),\; \mathrm{ad}_f^{\,i} g(x^\circ) \rangle = (-1)^{\,r-1-j}\, L_g L_f^{r-1}h(x^\circ) \;\; (i + j = r-1)
$$

Artinya $M$ **anti-triangular**: semua entri di atas anti-diagonal ($i+j \leq r-2$) nol, dan seluruh anti-diagonal ($i+j = r-1$) bernilai $\pm L_g L_f^{r-1}h(x^\circ)$ yang **tidak nol** menurut syarat (ii) relative degree. Determinan matriks anti-triangular sama dengan $\pm$ hasil kali anti-diagonalnya, jadi $\det M \neq 0$ — matriks ini **rank $r$** (invertible).

Sekarang perhatikan: $M$ adalah hasil kali [tumpukan covector sebagai baris] $\times$ [tumpukan vektor sebagai kolom]. Kalau $r$ covector $dL_f^{\,j} h$ itu saling bergantung linier, tumpukan barisnya ber-rank $< r$, sehingga hasil kali $M$ pun ber-rank $< r$ — bertentangan dengan $\mathrm{rank}\,M = r$. Jadi covector-covector itu **pasti** saling bebas linier.

> Intuisinya: syarat relative degree memastikan tiap turunan $L_f^k h$ baru "menyentuh" arah input $g$ tepat di langkah $k = r-1$, tidak lebih awal. Memasangkannya dengan menara $g, \mathrm{ad}_f g, \dots$ menghasilkan matriks segitiga (di sepanjang anti-diagonal) yang jelas invertible — dan himpunan covector yang bergantung linier tak mungkin menghasilkan matriks pasangan berrank penuh.

Karena saling bebas, lewat kriteria Jacobian di [204 — Change of Coordinates](204-change-of-coordinates.html) fungsi-fungsi $h, L_f h, \dots, L_f^{r-1}h$ sah dipakai sebagai sebagian koordinat baru.

**Proposition 4.1.3** [@isidori1995]. *Suppose the system has relative degree $r$ at $x^\circ$. Then $r \leq n$. Set*

$$
\phi_1(x) = h(x), \quad \phi_2(x) = L_f h(x), \quad \dots, \quad \phi_r(x) = L_f^{r-1}h(x)
$$

*If $r$ is strictly less than $n$, it is always possible to find $n-r$ more functions $\phi_{r+1}(x), \dots, \phi_n(x)$ such that the mapping $\Phi(x) = (\phi_1(x), \dots, \phi_n(x))^T$ has a jacobian matrix which is nonsingular at $x^\circ$ and therefore qualifies as a local coordinates transformation in a neighborhood of $x^\circ$. The value at $x^\circ$ of these additional functions can be fixed arbitrarily. Moreover, it is always possible to choose $\phi_{r+1}(x), \dots, \phi_n(x)$ in such a way that*

$$
L_g \phi_i(x) = 0, \qquad r+1 \leq i \leq n
$$

*for all $x$ around $x^\circ$.* Ambil koordinat baru $z_i = \phi_i(x)$.

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

**Remark 4.1.3** [@isidori1995]. *Note that sometimes it is not easy to construct $n-r$ functions $\phi_{r+1}(x), \dots, \phi_n(x)$ such that $L_g \phi_i(x) = 0$, because this ... amounts to solve a system of $n-r$ partial differential equations. Usually, it is much simpler to find functions $\phi_{r+1}(x), \dots, \phi_n(x)$ with the only property that the jacobian matrix of $\Phi(x)$ is nonsingular at $x^\circ$, and this is sufficient to define a coordinates transformation. Using a transformation constructed in this way, one gets the same structure for the first $r$ equations ... but it is not possible to obtain anything special for the last $n-r$ ones, that therefore will appear in a form like*

$$
\dot{z}_{r+1} = q_{r+1}(z) + p_{r+1}(z)\,u, \quad \dots, \quad
\dot{z}_n = q_n(z) + p_n(z)\,u
$$

*with the input $u$ explicitly present.*

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
