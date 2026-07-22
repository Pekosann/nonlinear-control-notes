# Nonlinear Control Notes: 001 Sistem Nonlinier
Misalkan sebuah sistem dapat dibentuk menjadi persamaan *nonlinear differential* dengan bentuk:
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

Kasus spesial dari sistem nonlinear adalah sistem linear. Bentuknya berupa:
$\dot{x}=Ax+Bu\quad (3)$
$y=Cx\quad(4)$
Persamaan ini yang biasa kita gunakan dalam membentuk *transfer function* dengan metode transformasi Laplace. Dengan ini, semakin jelas apa yang sebenarnya terjadi ketika kita melakukan linierisasi pada persamaan nonlinier menjadi bentuk aproksimasi liniernya. Limitasi dari melakukan aproksimasi linierisasi menjadi sangat besar ketika persamaan sangat jauh dari bentuk linier. Karena itu juga, *transfer function* hanya dapat dibentuk dari bentuk sistem linier.
