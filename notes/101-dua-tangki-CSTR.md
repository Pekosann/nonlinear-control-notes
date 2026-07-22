---
title: "101 — Dua Tangki CSTR"
section: Example
tags: [cstr, control-affine]
summary: "Model dua CSTR seri dengan pendingin cocurrent — persamaan model dari Henson & Seborg (1990)."
permalink: /101-dua-tangki-CSTR.html
folder: notes
last_updated: Jul 22, 2026
---

Dua CSTR terpasang seri, didinginkan oleh satu aliran pendingin yang mengalir
*cocurrent* (searah dengan aliran proses). Reaksi eksotermik ireversibel $A \to B$
terjadi di kedua tangki [@henson1990].

![Skema dua CSTR seri dengan pendingin cocurrent](figures/henson1990-dua-cstr-seri.png)
*Gambar 1. Sistem dua CSTR seri. Pendingin masuk jaket 1 pada $T_{cf}$, keluar pada
$T_{c1}$, lalu masuk jaket 2 — inilah alasan Pers. 4 memakai $T_{c1}$, bukan $T_{cf}$.*

## Model Proses (Pers. 1–4)

$$
\begin{align}
\dot{C}_{A1} &= \frac{q}{V_1}(C_{Af} - C_{A1}) - k_0 C_{A1} \exp\!\left(-\frac{E}{RT_1}\right) \tag{1}\\[8pt]
\dot{T}_1 &= \frac{q}{V_1}(T_f - T_1) + \frac{(-\Delta H)\,k_0\,C_{A1}}{\rho C_p}\exp\!\left(-\frac{E}{RT_1}\right) \notag\\
&\quad + \frac{\rho_c C_{pc}}{\rho C_p V_1}\,q_c\left[1 - \exp\!\left(-\frac{hA_1}{q_c\,\rho_c\,C_{pc}}\right)\right](T_{cf} - T_1) \tag{2}\\[8pt]
\dot{C}_{A2} &= \frac{q}{V_2}(C_{A1} - C_{A2}) - k_0 C_{A2} \exp\!\left(-\frac{E}{RT_2}\right) \tag{3}\\[8pt]
\dot{T}_2 &= \frac{q}{V_2}(T_1 - T_2) + \frac{(-\Delta H)\,k_0\,C_{A2}}{\rho C_p}\exp\!\left(-\frac{E}{RT_2}\right) \notag\\
&\quad + \frac{\rho_c C_{pc}}{\rho C_p V_2}\,q_c\left[1 - \exp\!\left(-\frac{hA_2}{q_c\,\rho_c\,C_{pc}}\right)\right]\notag\\
&\quad\cdot\left[T_1 - T_2 + \exp\!\left(-\frac{hA_1}{q_c\,\rho_c\,C_{pc}}\right)(T_{cf} - T_1)\right] \tag{4}
\end{align}
$$

### Catatan untuk Pers. 4

Temperatur pendingin yang masuk ke jaket kedua **bukan** $T_{cf}$, melainkan
temperatur keluar pendingin dari jaket pertama. Untuk aliran *cocurrent*,
temperatur pendingin setelah tangki 1 adalah:

$$
T_{c,\text{out},1} = T_1 + \exp\!\left(-\frac{hA_1}{q_c\,\rho_c\,C_{pc}}\right)(T_{cf} - T_1)
$$

Inilah temperatur pendingin masuk untuk tangki 2. Jadi suku dalam kurung siku di
Pers. 4 sebenarnya adalah $T_{c,\text{out},1} - T_2$.

## Definisi State, Input, Gangguan, dan Output (Pers. 5)

$$
x \triangleq [C_{A1},\; T_1,\; C_{A2},\; T_2]^T, \quad
d \triangleq [C_{Af},\; T_{cf}]^T, \quad
u \triangleq q_c, \quad
y \triangleq C_{A2} \tag{5}
$$

## Bentuk Umum Persamaan Diferensial Nonlinier

Dengan definisi di atas, Pers. 1–4 bisa dipadatkan jadi satu persamaan vektor:

$$
\dot{x} = f(x, u, d), \qquad y = h(x) \tag{6}
$$

Perhatikan $f$ bergantung pada $u$ — bukan cuma pada $x$. Alasannya dibahas di
bagian terakhir catatan ini, dan itulah inti dari [@henson1990].

### Notasi ringkas

Supaya matriksnya terbaca, definisikan dulu:

$$
k(T) \triangleq k_0 \exp\!\left(-\frac{E}{RT}\right), \qquad
\beta_i(q_c) \triangleq 1 - \exp\!\left(-\frac{hA_i}{q_c\,\rho_c\,C_{pc}}\right)
$$

$$
\lambda \triangleq \frac{-\Delta H}{\rho C_p}, \qquad
\mu_i \triangleq \frac{\rho_c C_{pc}}{\rho C_p V_i}
$$

$k(T)$ adalah konstanta laju Arrhenius, dan $\beta_i(q_c)$ adalah efektivitas
perpindahan panas jaket ke-$i$ — inilah suku yang membuat $q_c$ masuk secara
nonlinier.

### Bentuk Persamaan Matriks

Dengan $x = [x_1, x_2, x_3, x_4]^T = [C_{A1}, T_1, C_{A2}, T_2]^T$ dan $u = q_c$:

$$
\begin{bmatrix} \dot{x}_1 \\[6pt] \dot{x}_2 \\[6pt] \dot{x}_3 \\[6pt] \dot{x}_4 \end{bmatrix}
=
\begin{bmatrix}
\dfrac{q}{V_1}\left(C_{Af} - x_1\right) - k(x_2)\,x_1 \\[10pt]
\dfrac{q}{V_1}\left(T_f - x_2\right) + \lambda\,k(x_2)\,x_1 + \mu_1\,u\,\beta_1(u)\left(T_{cf} - x_2\right) \\[10pt]
\dfrac{q}{V_2}\left(x_1 - x_3\right) - k(x_4)\,x_3 \\[10pt]
\dfrac{q}{V_2}\left(x_2 - x_4\right) + \lambda\,k(x_4)\,x_3 + \mu_2\,u\,\beta_2(u)\Bigl[x_2 - x_4 + \bigl(1 - \beta_1(u)\bigr)\left(T_{cf} - x_2\right)\Bigr]
\end{bmatrix} \tag{7}
$$

dengan $C_{Af} = d_1$ dan $T_{cf} = d_2$. Outputnya linier terhadap state:

$$
y = h(x) = x_3 = \begin{bmatrix} 0 & 0 & 1 & 0 \end{bmatrix} x \tag{8}
$$

### Kenapa bukan $\dot{x} = f(x) + g(x)u$

Di [001 — Sistem Nonlinier Control-Affine](001-sistem-nonlinier-control-affine.html) bentuk umum yang dipakai adalah *control-affine*:
$\dot{x} = f(x) + g(x)u$, yaitu $u$ masuk secara linier. Sistem ini **tidak**
bisa ditulis begitu.

Lihat suku pendingin di baris kedua Pers. 7:

$$
\mu_1\,u\,\beta_1(u)\left(T_{cf} - x_2\right)
= \mu_1\,u\left[1 - \exp\!\left(-\frac{hA_1}{u\,\rho_c\,C_{pc}}\right)\right]\left(T_{cf} - x_2\right)
$$

$u$ muncul dua kali: sebagai faktor pengali **dan** di dalam eksponensial. Jadi
suku ini tidak bisa dipisah menjadi "sesuatu yang hanya bergantung $x$" dikali $u$.
Tidak ada $g(x)$ yang memenuhi.

Karena itu bentuk yang benar adalah Pers. 6, $\dot{x} = f(x, u, d)$ — model
nonlinier *umum*. Metode yang mensyaratkan struktur affine tidak bisa langsung
dipakai di sini, dan justru inilah alasan Henson & Seborg menulis papernya:
laju alir pendingin lewat jaket adalah contoh khas input yang masuk secara
nonlinier [@henson1990].
