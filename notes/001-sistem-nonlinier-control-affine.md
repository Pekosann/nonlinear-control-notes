---
title: 001 — Sistem Nonlinier Control
section: Dasar Teori
tags: [dasar, control-affine]
summary: Bentuk control-affine, arti kata affine, dan kenapa sistem linier hanyalah kasus spesialnya.
permalink: /001-sistem-nonlinier-control-affine.html
folder: notes
last_updated: Jul 22, 2026
---

Misalkan sebuah sistem dapat dibentuk menjadi persamaan *nonlinear differential* dengan bentuk [@zotero-item-11]:
$\dot{x}=f(x)+g(x)u\quad (1)$
$y=h(x)\quad(2)$
memiliki *internal state* $x=(x_1,x_2,...,x_n)\in\mathbb{R}^n$
*control input* $u\in\mathbb{R}$
dan *measured output* $y\in\mathbb{R}$
dan fungsi $f:\mathbb{R}^n\rightarrow\mathbb{R}^n$ dan $g:\mathbb{R}^n\rightarrow\mathbb{R}^n$
sedangkan $h:\mathbb{R}^n\rightarrow\mathbb{R}$ adalah fungsi output skalar.

>simbol $f:\mathbb{R}^n\rightarrow\mathbb{R}^n$ adalah kependekan dari:
>$f(x)=\pmatrix{f_1(x_1,x_2,...,x_n)\\f_2(x_1,x_2,...,x_n)\\...\\f_n(x_1,x_2,...,x_n)}$
>berarti f adalah sebuah fungsi matrix yang mengubah x sebanyak n menjadi bentuk lain yang juga sebanyak n.

Bentuk Pers. (1) punya nama khusus: **control-affine**.

## Apa itu *control-affine*?

*Affine* artinya "linier ditambah konstanta" — fungsi berbentuk $a + bu$.
Jadi $3 + 2u$ affine terhadap $u$, sedangkan $u^2$ atau $e^u$ tidak.

Kuncinya: ambil satu nilai $x$ tertentu, lalu bekukan. Pada saat itu $f(x)$ dan
$g(x)$ cuma vektor angka, jadi Pers. (1) menjadi

$\dot{x} = \underbrace{f(x)}_{\text{konstanta } a} + \underbrace{g(x)}_{\text{konstanta } b}\,u$

persis bentuk $a + bu$. Itulah maksudnya: **linier terhadap input $u$**, walaupun
boleh serumit apa pun terhadap state $x$. Yang disyaratkan cuma soal bagaimana
$u$ dilibatkan dalam persamaan, bukan soal seberapa nonlinier sistemnya.

Istilah "affine terhadap input yang dimanipulasi" ini dipakai [@corriou] untuk
menandai kelas sistem yang bisa ditangani *nonlinear geometric control*.
Kedua fungsinya disebut **vector field of the dynamics** ($f$) dan
**vector field of the control** ($g$) [@corriou]:

- $f(x)$ — vector field dinamika: ke mana sistem bergerak sendiri kalau inputnya
  dimatikan ($u=0$). Di literatur *differential-geometric* sering disebut *drift*.
- $g(x)$ — vector field kontrol: ke arah mana dan seberapa kuat input menggeser
  state. Sering juga ditulis *input vector field*.

> Menurut [@corriou], sebagian besar sistem di teknik kimia memang berbentuk
> Pers. (1). Alasannya sederhana: input yang dimanipulasi biasanya laju alir atau
> bukaan valve, dan besaran itu masuk secara linier ke dalam model.
> Jadi syarat affine tidak seketat kelihatannya — walau [101 — Dua Tangki CSTR](101-dua-tangki-CSTR.html)
> menunjukkan bahwa ada pengecualiannya.

Yang **tidak boleh** adalah $u$ terjebak di dalam fungsi nonlinier, misalnya
$e^{u}$, $u^2$, atau $\sqrt{u}$. Kalau itu terjadi, sistemnya hanya bisa ditulis
$\dot{x} = f(x,u)$ — bentuk nonlinier umum, bukan control-affine.
Contoh nyatanya ada di [101 — Dua Tangki CSTR](101-dua-tangki-CSTR.html): di sana laju alir pendingin muncul
di dalam eksponensial, jadi tidak ada $g(x)$ yang bisa dipisahkan.

### Kenapa strukturnya penting

Karena $u$ masuk secara linier, $u$ bisa **dicari secara eksplisit**. Kalau $y$
diturunkan terhadap waktu sampai $u$ muncul, hasilnya

$y^{(r)} = L_f^r h(x) + L_g L_f^{r-1} h(x)\,u$

dan $u$ tinggal dipindah ruas:

$u = \dfrac{v - L_f^r h(x)}{L_g L_f^{r-1} h(x)}$

Inilah inti *feedback linearization*. Kalau sistemnya tidak affine, langkah
pembagian ini tidak ada — $u$ harus dicari secara numerik tiap langkah waktu.

## Sistem linier sebagai kasus spesial

Kasus spesial dari sistem nonlinear adalah sistem linear. Bentuknya berupa:
$\dot{x}=Ax+Bu\quad (3)$
$y=Cx\quad(4)$
yaitu control-affine dengan $f(x)=Ax$ dan $g(x)=B$ yang konstan (tidak bergantung $x$).

Persamaan ini yang biasa kita gunakan dalam membentuk *transfer function* dengan metode transformasi Laplace [@seborg]. Dengan ini, semakin jelas apa yang sebenarnya terjadi ketika kita melakukan linierisasi pada persamaan nonlinier menjadi bentuk aproksimasi liniernya. Limitasi dari melakukan aproksimasi linierisasi menjadi sangat besar ketika persamaan sangat jauh dari bentuk linier. Karena itu juga, *transfer function* hanya dapat dibentuk dari bentuk sistem linier.
