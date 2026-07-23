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

## Aplikasi: laju perubahan output terukur

Kenapa perlu membedakan vektor dan covector? Karena keduanya muncul sebagai objek yang berbeda dalam persoalan kendali, dan *inner product* di atas justru yang menyatukannya jadi besaran fisik.

Sebuah sensor mengukur output $y = h(x)$ — fungsi skalar dari state. Gradiennya, $dh$, adalah sebuah **covector field** (dibahas di [006 — Exact Differential](006-exact-differential.html)). Di sisi lain, dinamika sistem memberi laju state $\dot{x} = f(x)$ — sebuah **vector field** ([004 — Vector Field](004-vector-field.html)). Pertanyaan "seberapa cepat nilai yang saya ukur berubah?" ternyata persis pemasangan keduanya lewat inner product tadi:

$$
\dot{y} = \sum_{i=1}^{n} \frac{\partial h}{\partial x_i}\,\dot{x}_i = \langle dh(x),\, f(x) \rangle = L_f h(x)
$$

Inilah maksud konkret dari covector: velocity (vektor) dan gradient dari besaran terukur (covector) adalah dua objek berbeda, dan inner product $\langle w^\star, v \rangle$-lah yang mengubah keduanya jadi satu laju.

### Contoh: CSTR dua tangki

Ambil model di [101 — Dua Tangki CSTR](101-dua-tangki-CSTR.html), dengan output konsentrasi keluaran $y = C_{A2} = x_3$. Differential-nya adalah covector konstan

$$
dh = \begin{bmatrix} 0 & 0 & 1 & 0 \end{bmatrix}
$$

Memasangkannya dengan vector field $f$ hanya memungut komponen ketiga:

$$
\dot{y} = \langle dh,\, f(x) \rangle = f_3(x) = \dot{C}_{A2}
$$

yaitu tepat neraca massa tangki kedua. Di paper Henson & Seborg langkah ini muncul sebagai $[L_f^1 h] = f_3$ — turunan Lie pertama dari output.

Kalau diulang — memasangkan $d(L_f h)$ dengan $f$ lagi, dan seterusnya sampai input $u$ muncul — kita mendapatkan konsep *relative degree*, fondasi dari [201 — Feedback Linearization: Konsep Intuitif](201-feedback-linearization-konsep.html).

Covector field yang paling penting, yaitu *differential* $dh$ yang baru saja dipakai di atas, dibahas lebih lanjut di [006 — Exact Differential](006-exact-differential.html).
