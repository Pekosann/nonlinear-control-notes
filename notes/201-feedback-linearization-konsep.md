---
title: "201 — Feedback Linearization: Konsep Intuitif"
section: Feedback Linearization
tags: [feedback-linearization]
summary: "Ide dasar feedback linearization lewat contoh kontrol level tangki, lalu bentuk umumnya untuk sistem companion form (Slotine & Li 6.1)."
permalink: /201-feedback-linearization-konsep.html
folder: notes
last_updated: Jul 23, 2026
---

Dalam bentuk paling sederhana, **feedback linearization** berarti membatalkan nonlinieritas sebuah sistem sehingga dinamika *closed-loop*-nya menjadi linier [@slotine1991]. Setelah linier, teknik kendali linier yang sudah matang bisa dipakai. Cara paling gampang memahaminya adalah lewat satu contoh.

## Contoh: kontrol level tangki

Tinjau level cairan $h$ dalam sebuah tangki yang ingin dijaga pada level $h_d$. Input kendalinya adalah laju alir masuk $u$, dan levelnya mula-mula $h_0$ [@slotine1991]. Model dinamiknya:

$$
\frac{d}{dt}\int_0^h A(h)\,dh = u(t) - a\sqrt{2gh} \tag{1}
$$

dengan $A(h)$ luas penampang tangki pada ketinggian $h$, dan $a$ luas penampang pipa keluar. Karena $\int_0^h A(h)\,dh$ adalah volume cairan, persamaan ini bisa ditulis ulang:

$$
A(h)\,\dot{h} = u - a\sqrt{2gh} \tag{2}
$$

### Membatalkan nonlinieritas

Ini kuncinya. Pilih $u$ yang tepat untuk membatalkan suku nonlinier $a\sqrt{2gh}$:

$$
u(t) = a\sqrt{2gh} + A(h)\,v \tag{3}
$$

Substitusikan ke Pers. (2), semua yang nonlinier hilang dan yang tersisa linier:

$$
\dot{h} = v
$$

$v$ di sini berperan sebagai **input ekuivalen** — input untuk sistem yang sekarang sudah linier. Tinggal dirancang seperti sistem linier biasa.

### Merancang $v$

Pilih $v$ sebanding dengan error level:

$$
v = -\alpha\,\tilde{h} \tag{4}
$$

dengan $\tilde{h} = h(t) - h_d$ adalah error level, dan $\alpha$ konstanta positif tegas. Dinamika closed-loop-nya menjadi

$$
\dot{\tilde{h}} + \alpha\,\tilde{h} = 0 \tag{5}
$$

yang berarti $\tilde{h}(t) \to 0$ secara eksponensial saat $t \to \infty$. Errornya meluruh, level menuju $h_d$.

### Hukum kendali sebenarnya

Gabungkan Pers. (3) dan (4):

$$
u(t) = a\sqrt{2gh} - A(h)\,\alpha\,\tilde{h} \tag{6}
$$

Bagian pertama, $a\sqrt{2gh}$, menyediakan aliran untuk mengimbangi keluaran dari pipa; bagian kedua menaikkan level sesuai dinamika linier yang diinginkan [@slotine1991].

Kalau level yang diinginkan berubah terhadap waktu, $h_d(t)$, input ekuivalennya cukup diganti

$$
v = \dot{h}_d(t) - \alpha\,\tilde{h}
$$

sehingga $\tilde{h}(t) \to 0$ tetap tercapai.

## Bentuk umum: *companion form*

Ide ini — membatalkan nonlinieritas untuk memaksakan dinamika linier — bisa diterapkan pada kelas sistem yang ditulis dalam **companion form** (atau *controllability canonical form*) [@slotine1991]:

$$
x^{(n)} = f(x) + b(x)\,u \tag{7}
$$

dengan $u$ input skalar, $x$ output skalar yang diperhatikan, dan vektor state $\mathbf{x} = [x, \dot{x}, \dots, x^{(n-1)}]^T$. Ciri khas bentuk ini: yang muncul hanya turunan-turunan $x$, dan **tidak ada turunan input** $u$.

Karena $u$ masuk secara linier (lihat [001 — Sistem Nonlinier Control Affine](001-sistem-nonlinier-control-affine.html)), asalkan $b \neq 0$ pilih

$$
u = \frac{1}{b}\,[\,v - f\,] \tag{8}
$$

Nonlinieritas terbatalkan dan tersisa hubungan input-output yang sederhana, yaitu rantai integrator:

$$
x^{(n)} = v
$$

Sekarang $v$ dirancang seperti sistem linier. Pilih

$$
v = -k_0 x - k_1 \dot{x} - \dots - k_{n-1} x^{(n-1)}
$$

dengan $k_i$ dipilih supaya polinomial $p^n + k_{n-1}p^{n-1} + \dots + k_0$ punya semua akar di paruh kiri bidang kompleks. Hasilnya dinamika yang stabil secara eksponensial:

$$
x^{(n)} + k_{n-1}x^{(n-1)} + \dots + k_0 x = 0
$$

Untuk *tracking* output yang diinginkan $x_d(t)$, hukum kendalinya menjadi

$$
v = x_d^{(n)} - k_0 e - k_1 \dot{e} - \dots - k_{n-1} e^{(n-1)} \tag{9}
$$

dengan $e(t) = x(t) - x_d(t)$ adalah error tracking, sehingga tracking-nya konvergen secara eksponensial [@slotine1991].

## Catatan

Contoh tangki di atas adalah bentuk paling sederhana: relative degree satu, jadi satu kali substitusi langsung melinierkan. Sistem yang lebih rumit butuh menurunkan output beberapa kali sampai input muncul — konsep *relative degree* — dan hanya berlaku kalau sistemnya *control-affine* seperti dibahas di [001 — Sistem Nonlinier Control Affine](001-sistem-nonlinier-control-affine.html). Contoh reaktor yang memenuhi syarat ini ada di [102 — CSTR Orde-n Adebekun](102-adebekun-cstr-orde-n.html).
