---
title: 008 — Global Diffeomorphism
section: Differential Geometry
tags: [differential-geometry]
summary: Change of coordinates nonlinier z = Phi(x), dua syaratnya (invertible dan smooth dua arah), dan beda global vs local diffeomorphism.
permalink: /008-global-diffeomorphism.html
folder: notes
last_updated: Jul 23, 2026
---

*Change of coordinates* pada ruang state sering berguna untuk menonjolkan sifat tertentu — misalnya reachability, observability — atau untuk memudahkan persoalan seperti stabilisasi dan decoupling [@isidori1995].

## Kasus linier

Untuk sistem linier, biasanya hanya *linear change of coordinates* yang dipakai: mengganti vektor state $x$ dengan vektor baru $z$ lewat

$$
z = Tx
$$

dengan $T$ matriks $n \times n$ nonsingular. Deskripsi $\dot{x} = Ax + Bu,\; y = Cx$ menjadi $\dot{z} = \bar{A}z + \bar{B}u,\; y = \bar{C}z$ dengan

$$
\bar{A} = TAT^{-1}, \qquad \bar{B} = TB, \qquad \bar{C} = CT^{-1}
$$

## Kasus nonlinier

Kalau sistemnya nonlinier, lebih bermakna memakai *nonlinear change of coordinates*

$$
z = \Phi(x)
$$

dengan $\Phi(x)$ fungsi bernilai $\mathbb{R}^n$ dari $n$ variabel:

$$
\Phi(x) =
\begin{bmatrix} \phi_1(x) \\ \phi_2(x) \\ \vdots \\ \phi_n(x) \end{bmatrix}
=
\begin{bmatrix} \phi_1(x_1, \dots, x_n) \\ \phi_2(x_1, \dots, x_n) \\ \vdots \\ \phi_n(x_1, \dots, x_n) \end{bmatrix}
$$

## Definisi: global diffeomorphism

Pemetaan $\Phi$ disebut **global diffeomorphism** pada $\mathbb{R}^n$ kalau memenuhi dua sifat [@isidori1995]:

- **(i) Invertible.** Ada fungsi $\Phi^{-1}$ sehingga

$$
\Phi^{-1}(\Phi(x)) = x \quad \text{untuk semua } x \in \mathbb{R}^n
$$

- **(ii) Smooth dua arah.** $\Phi(x)$ dan $\Phi^{-1}(z)$ dua-duanya pemetaan mulus, yaitu punya turunan parsial kontinu sampai orde berapa pun.

Sifat pertama diperlukan supaya transformasinya bisa dibalik untuk memulihkan state semula, $x = \Phi^{-1}(z)$. Sifat kedua menjamin deskripsi sistem dalam koordinat baru tetap mulus [@isidori1995].

## Global vs local

Kadang transformasi yang memenuhi kedua sifat itu **dan** berlaku untuk semua $x$ sulit ditemukan, atau sifatnya sulit diperiksa. Karena itu sering orang cukup melihat transformasi yang terdefinisi hanya di sebuah *neighborhood* dari suatu titik. Transformasi seperti ini disebut **local diffeomorphism** [@isidori1995].
