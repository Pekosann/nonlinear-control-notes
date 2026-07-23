---
title: 004 — Vector Field
section: Differential Geometry
tags: [differential-geometry]
summary: Vector field sebagai pemetaan mulus yang memberi satu vektor pada tiap titik ruang state.
permalink: /004-vector-field.html
folder: notes
last_updated: Jul 23, 2026
---

Sistem nonlinier yang ditinjau [@isidori1995] berbentuk

$$
\dot{x} = f(x) + \sum_{i=1}^{m} g_i(x)\,u_i, \qquad y_j = h_j(x)
$$

Pemetaan $f, g_1, \dots, g_m$ di sini adalah objek yang disebut **vector field**.

## Definisi

Sebuah **smooth vector field** pada himpunan terbuka $U \subseteq \mathbb{R}^n$ adalah pemetaan mulus

$$
f : U \to \mathbb{R}^n
$$

yang memberikan kepada tiap titik $x \in U$ sebuah vektor $f(x) \in \mathbb{R}^n$ [@isidori1995]. Vektornya ditulis sebagai vektor kolom:

$$
f(x) =
\begin{bmatrix} f_1(x) \\ f_2(x) \\ \vdots \\ f_n(x) \end{bmatrix},
\qquad f_i(x) = f_i(x_1, \dots, x_n)
$$

Kata *smooth* berarti semua komponen $f_i$ punya turunan parsial kontinu sampai orde berapa pun ($C^\infty$) terhadap $x_1, \dots, x_n$ [@isidori1995].

## Ruang state $U$, bukan seluruh $\mathbb{R}^n$

State space diambil sebagai himpunan bagian $U \subseteq \mathbb{R}^n$, bukan seluruh $\mathbb{R}^n$ [@isidori1995]. Batasan ini bisa datang dari persamaan sistemnya sendiri (solusinya mungkin tidak bebas berkembang di seluruh $\mathbb{R}^n$) atau dari kendala pada input, misalnya untuk menghindari titik-titik singular. Dalam banyak kasus boleh saja mengambil $U = \mathbb{R}^n$.

Objek dualnya — yang memberi satu *covector* pada tiap titik, bukan vektor — dibahas di [005 — Covector Field](005-covector-field.html).
