---
title: 005 — Covector Field
section: Differential Geometry
tags: [differential-geometry]
summary: Objek dual dari vector field — memberi satu covector (vektor baris) pada tiap titik, dan cara memasangkannya dengan vektor.
permalink: /005-covector-field.html
folder: notes
last_updated: Jul 23, 2026
---

[004 — Vector Field](004-vector-field.html) memberi satu vektor kolom pada tiap titik. Objek dualnya, yang memberi satu **covector**, disebut **covector field** [@isidori1995].

## Dual space

*Dual space* $V^\star$ dari sebuah ruang vektor $V$ adalah himpunan semua fungsi linier bernilai real yang didefinisikan pada $V$ [@isidori1995]. Dual space dari ruang berdimensi $n$ juga berdimensi $n$, dan elemennya disebut **covector**.

Sebuah elemen $V$ ditulis sebagai vektor kolom, dan elemen $V^\star$ sebagai vektor baris:

$$
v =
\begin{bmatrix} v_1 \\ v_2 \\ \vdots \\ v_n \end{bmatrix} \in V,
\qquad
w^\star = \begin{bmatrix} w_1 & w_2 & \cdots & w_n \end{bmatrix} \in V^\star
$$

Karena $w^\star$ adalah pemetaan linier dari ruang $n$-dimensi ke $\mathbb{R}$, ia bisa diwakili oleh matriks satu baris — jadi wajar mengidentikkan $(\mathbb{R}^n)^\star$ dengan himpunan semua vektor baris $n$-dimensi [@isidori1995].

## Memasangkan covector dengan vektor

Nilai $w^\star$ pada $v$ diberikan oleh perkalian

$$
w^\star v = \sum_{i=1}^{n} w_i v_i
$$

Seperti lazim di literatur, nilai ini sering ditulis sebagai *inner product*, $\langle w^\star, v \rangle$, ketimbang sekadar $w^\star v$ [@isidori1995].

## Covector field

Sebuah **covector field** adalah pemetaan mulus yang memberikan kepada tiap titik $x \in U$ sebuah elemen dual space $(\mathbb{R}^n)^\star$, yaitu vektor baris

$$
\omega(x) = \begin{bmatrix} \omega_1(x) & \omega_2(x) & \cdots & \omega_n(x) \end{bmatrix}
$$

dengan tiap $\omega_i$ fungsi mulus dari $x_1, \dots, x_n$ [@isidori1995].

Contoh covector field yang paling penting adalah *differential* dari sebuah fungsi skalar, dibahas di [006 — Exact Differential](006-exact-differential.html).
