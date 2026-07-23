---
title: 006 — Exact Differential
section: Differential Geometry
tags: [differential-geometry]
summary: Differential (gradient) sebuah fungsi skalar sebagai covector field, dan syarat sebuah covector field disebut exact.
permalink: /006-exact-differential.html
folder: notes
last_updated: Jul 23, 2026
---

Di antara semua [005 — Covector Field](005-covector-field.html), ada satu yang paling penting: **differential** (atau *gradient*) dari sebuah fungsi skalar [@isidori1995].

## Differential sebuah fungsi

Misalkan $\lambda$ fungsi bernilai real yang didefinisikan pada himpunan terbuka $U \subseteq \mathbb{R}^n$. **Differential** dari $\lambda$ adalah covector field, dilambangkan $d\lambda$, berupa vektor baris $1 \times n$ yang elemen ke-$i$-nya adalah turunan parsial $\lambda$ terhadap $x_i$:

$$
d\lambda(x) = \begin{bmatrix} \dfrac{\partial \lambda}{\partial x_1} & \dfrac{\partial \lambda}{\partial x_2} & \cdots & \dfrac{\partial \lambda}{\partial x_n} \end{bmatrix}
$$

Ruas kanannya persis matriks Jacobian dari $\lambda$. Notasi yang lebih ringkas kadang lebih disukai:

$$
d\lambda(x) = \frac{\partial \lambda}{\partial x}
$$

## Definisi *exact*

Sebuah covector field yang berbentuk seperti di atas — yaitu yang merupakan differential dari suatu fungsi bernilai real $\lambda$ — disebut **exact differential** [@isidori1995].

Perhatikan implikasinya: tidak semua covector field itu exact. Hanya yang bisa ditulis sebagai gradient $\partial \lambda / \partial x$ dari suatu fungsi skalar $\lambda$ yang disebut exact. Membedakan mana covector field yang exact dan mana yang tidak adalah persoalan penting dalam analisis geometri sistem nonlinier.

Operasi diferensial yang melibatkan differential $d\lambda$ bersama vector field dibahas di [007 — Three Types of Differential Operation](007-differential-operations.html).
