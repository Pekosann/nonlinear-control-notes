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

## Intuisi: covector sebagai "alat ukur"

Definisi di atas terasa abstrak. Ada satu cara berpikir yang membuatnya jauh lebih konkret: **sebuah covector adalah semacam alat ukur (*ruler*).** Kamu "menempelkan" sebuah vektor padanya lalu membaca satu angka. Di $\mathbb{R}^n$ alat ukur ini adalah vektor baris, dan "mengukur" berarti dot product — persis $w^\star v = \sum w_i v_i$ tadi. Itulah kenapa vektor ditulis kolom dan covector ditulis baris: pengukurannya adalah perkalian baris $\times$ kolom yang menghasilkan satu skalar.

Secara geometris di $\mathbb{R}^2$, sebuah covector bisa dibayangkan sebagai **sekumpulan garis sejajar** (level set-nya). Kamu masukkan sebuah vektor, dan nilainya ditentukan oleh garis ke berapa yang disentuh ujung vektor itu. Makin rapat garisnya, makin "kuat" alat ukurnya — vektor yang sama memberi angka lebih besar.

Di dimensi $\geq 3$, atau di ruang vektor abstrak (ruang polinomial, ruang fungsi), gambar garis-garis ini hilang. Tapi idenya tetap sama: **dual space adalah ruang berisi semua "alat" yang bisa mengukur vektor di ruangmu**, seaneh apa pun vektor itu.

> Soal membayangkan dimensi tinggi, ada nasihat setengah bercanda dari Geoffrey Hinton: *"Untuk membayangkan hyperplane di ruang 14 dimensi, bayangkan ruang 3 dimensi lalu ucapkan 'empat belas' keras-keras pada dirimu sendiri. Semua orang begitu."*

### Analogi menu dan pesanan

Analogi yang paling pas untuk memisahkan dua objek ini: bayangkan kamu memesan makanan.

- **Vektor = sebuah pesanan**, misalnya "3 pizza keju, 1 pepperoni, 1 sosis". Pesanan bisa dijumlahkan dan dikali skalar (pesan $3\times$ lebih banyak), jadi ruang semua pesanan adalah ruang vektor $V$.
- **Covector = sebuah menu**, yaitu daftar harga. Menu menerima satu pesanan dan mengembalikan satu angka: harganya. Dan ia melakukannya secara linier — pesan $3\times$ lipat maka harganya $3\times$; gabungan dua pesanan harganya jumlah dari masing-masing.

Menu yang berbeda memberi harga berbeda untuk pesanan yang sama (satu tempat pepperoni-nya mahal, tempat lain murah), tapi satu menu memberi harga untuk pesanan apa pun. **Ruang semua menu itulah dual space $V^\star$.**

Kuncinya: menu (covector) dan pesanan (vektor) adalah dua jenis benda yang berbeda. Kamu tidak pernah "menjumlahkan menu dengan pesanan" — kamu memakai menu untuk *mengukur* pesanan. Persis seperti covector yang mengukur vektor, bukan bagian dari ruang vektor yang sama.

Dan tidak apa-apa kalau gambaran geometrisnya terasa hilang di ruang abstrak. Intuisi sering justru datang belakangan, setelah cukup lama bekerja dengan objeknya — bukan syarat di awal.

Kembali ke konteks kendali: di [bagian aplikasi](#aplikasi-laju-perubahan-output-terukur) di bawah, gradient output $dh$ adalah persis "menu" itu — ia memberi harga pada vektor kecepatan $f$, dan harganya adalah laju perubahan output $\dot{y}$.

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

## Bacaan lanjut

- 3Blue1Brown — [*Dot products and duality* (Essence of Linear Algebra, Ch. 9)](https://www.youtube.com/watch?v=LyGKycYT2v0). Membangun intuisi "alat ukur" di atas secara visual: kenapa sebuah vektor baris sebenarnya adalah pemetaan linier ke garis bilangan, dan bagaimana dot product muncul dari dualitas ini.
- eigenchris — [*Introducing Dual Vectors: Intuition and Definition*](https://www.youtube.com/watch?v=wZ2G-b-Ttww). Memperkenalkan covector (dual vector / one-form) sebagai fungsi yang bekerja pada vektor, langsung dari sudut pandang tensor calculus.
