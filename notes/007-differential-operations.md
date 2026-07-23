---
title: 007 — Three Types of Differential Operation
section: Differential Geometry
tags: [differential-geometry]
summary: Tiga operasi diferensial yang sering dipakai di kendali nonlinier — Lie derivative fungsi, Lie bracket vektor, dan Lie derivative covector.
permalink: /007-differential-operations.html
folder: notes
last_updated: Jul 23, 2026
---

Ada tiga jenis operasi diferensial yang melibatkan [004 — Vector Field](004-vector-field.html) dan [005 — Covector Field](005-covector-field.html) dan sering dipakai dalam analisis sistem kendali nonlinier [@isidori1995].

## Tipe 1: Lie derivative sebuah fungsi

Melibatkan fungsi bernilai real $\lambda$ dan vector field $f$. Hasilnya fungsi bernilai real baru, yang di tiap titik $x$ sama dengan *inner product* dari [differential](006-exact-differential.html) $d\lambda$ dengan $f$:

$$
\langle d\lambda(x),\, f(x) \rangle = \frac{\partial \lambda}{\partial x} f(x) = \sum_{i=1}^{n} \frac{\partial \lambda}{\partial x_i} f_i(x)
$$

Fungsi ini disebut **derivative of $\lambda$ along $f$**, dan ditulis $L_f \lambda$ [@isidori1995]:

$$
L_f \lambda(x) = \sum_{i=1}^{n} \frac{\partial \lambda}{\partial x_i} f_i(x)
$$

Operasi ini bisa diulang. Menurunkan $\lambda$ lebih dulu sepanjang $f$ lalu sepanjang $g$:

$$
L_g L_f \lambda(x) = \frac{\partial (L_f \lambda)}{\partial x} g(x)
$$

Kalau $\lambda$ diturunkan $k$ kali sepanjang $f$, dipakai notasi $L_f^k \lambda$ dengan rekursi

$$
L_f^k \lambda(x) = \frac{\partial \left( L_f^{k-1} \lambda \right)}{\partial x} f(x), \qquad L_f^0 \lambda(x) = \lambda(x)
$$

## Tipe 2: Lie bracket dua vector field

Melibatkan dua vector field $f$ dan $g$. Hasilnya vector field baru, ditulis $[f, g]$ dan didefinisikan

$$
[f, g](x) = \frac{\partial g}{\partial x} f(x) - \frac{\partial f}{\partial x} g(x)
$$

dengan $\partial g/\partial x$ dan $\partial f/\partial x$ adalah matriks Jacobian dari $g$ dan $f$. Vector field ini disebut **Lie product** (atau **bracket**) dari $f$ dan $g$ [@isidori1995]. Bracketing berulang didefinisikan secara rekursif untuk menghindari notasi bertumpuk:

$$
\mathrm{ad}_f^k\, g(x) = [f,\, \mathrm{ad}_f^{k-1}\, g](x), \qquad \mathrm{ad}_f^0\, g(x) = g(x)
$$

**Proposition 1.2.1** [@isidori1995]. *The Lie product of vector fields has the following properties:*

*(i) is bilinear over $\mathbb{R}$, i.e. if $f_1, f_2, g_1, g_2$ are vector fields and $r_1, r_2$ real numbers, then*

$$
[r_1 f_1 + r_2 f_2,\, g_1] = r_1[f_1, g_1] + r_2[f_2, g_1], \qquad
[f_1,\, r_1 g_1 + r_2 g_2] = r_1[f_1, g_1] + r_2[f_1, g_2]
$$

*(ii) is skew commutative, i.e.*

$$
[f, g] = -[g, f]
$$

*(iii) satisfies the Jacobi identity, i.e. if $f, g, p$ are vector fields, then*

$$
[f, [g, p]] + [g, [p, f]] + [p, [f, g]] = 0
$$

## Tipe 3: Lie derivative sebuah covector field

Melibatkan covector field $\omega$ dan vector field $f$. Hasilnya covector field baru, ditulis $L_f \omega$ dan didefinisikan

$$
L_f \omega(x) = f^T(x) \left( \frac{\partial \omega^T}{\partial x} \right)^T + \omega(x) \frac{\partial f}{\partial x}
$$

dengan superskrip $T$ menandakan transpos. Covector field ini disebut **derivative of $\omega$ along $f$** [@isidori1995].
