---
title: "301 — Wu (1999): Stable Inverse Control (Motivation & I/O Linearization)"
section: Paper Review
tags: [paper-review, feedback-linearization]
summary: "Review Wu 1999 tentang stable inverse control untuk proses nonminimum-phase. Bagian 1: motivasi dan exact I/O linearization sampai control law (eq 6)."
permalink: /301-wu-1999-stable-inverse-control.html
folder: notes
last_updated: Jul 23, 2026
---

Review paper [@weiwu1999] — *"Stable inverse control for nonminimum-phase nonlinear processes"* (W. Wu, *Journal of Process Control*, 1999). Kita bahas bertahap; bagian ini sampai **§1.1, control law (eq 6)**.

## Tentang paper ini

Feedback linearization membatalkan nonlinieritas dan membentuk peta I/O linier ([201 — Feedback Linearization: Konsep Intuitif](201-feedback-linearization-konsep.html)), tapi butuh dua syarat: *stable inversion* dan *state feedback*. Untuk sistem **nonminimum-phase**, syarat itu gagal — inversinya tidak stabil. Wu mengembangkan teknik *stable inversion* untuk sistem nonminimum-phase, lalu mengujinya pada reaksi Van de Vusse di CSTR isotermal/adiabatik.

## Notasi paper vs notasi kita

Notasi Wu hampir sama dengan [000 — Abbreviations & Notasi Standar](000-abbreviations.html). Yang perlu dipetakan:

| Paper | Notasi kita | Keterangan |
|---|---|---|
| $x,\; u,\; y$ | $x,\; u,\; y$ | sama |
| $f,\; g,\; h$ | $f,\; g,\; h$ | sama |
| $r$ | $r$ | relative degree (202) |
| $x_s$ | $x^\circ$ | titik kesetimbangan |
| $\xi = (\xi_1, \dots, \xi_r)$ | $z_1, \dots, z_r$ | koordinat output (rantai integrator) |
| $\eta = (\eta_1, \dots, \eta_{n-r})$ | $z_{r+1}, \dots, z_n$ | *internal dynamics* (203) |
| $q(\xi, \eta)$ | $q_i(z)$ | fungsi internal dynamics |
| $v$ | $v$ | input ekuivalen |
| $T$ | $\Phi$ | change of coordinates (204) |
| $y_d$ | $x_d,\; h_d$ | *reference trajectory* |

## §1 Motivation

Motivasi Wu: kelemahan serius *exact feedback linearization* — ia bertumpu penuh pada asumsi *stable inversion* dan pembatalan nonlinieritas plant yang sempurna. Model nominal yang ditinjau (eq 1):

$$
\dot{x} = f(x) + g(x)u, \qquad y = h(x), \qquad x(0) = x_s \tag{1}
$$

dengan $x \in \mathbb{R}^n$, $u, y \in \mathbb{R}$, $f : \mathbb{R}^n \to \mathbb{R}^n$ dan $g : \mathbb{R}^n \to \mathbb{R}^n$ smooth vector field, $h : \mathbb{R}^n \to \mathbb{R}$ fungsi output skalar, dan $x_s \in \mathbb{R}^n$ titik kesetimbangan. Ini persis sistem control-affine SISO di [001 — Sistem Nonlinier Control Affine](001-sistem-nonlinier-control-affine.html).

## §1.1 Exact input/output linearization

Sistem (1) dibawa ke [normal form](203-normal-form.html) lewat nonlinear change of coordinates (eq 2):

$$
(\xi^T, \eta^T)^T = \bigl(h(x),\; L_f h(x),\; \dots,\; L_f^{r-1}h(x),\; \eta_1(x),\; \dots,\; \eta_{n-r}(x)\bigr)^T \tag{2}
$$

dengan syarat pada koordinat internal (eq 3):

$$
L_g \eta_i(x) = 0, \qquad i = 1, 2, \dots, n-r \tag{3}
$$

Di sini $r > 0$ relative degree, dan $L_f^i h(x)$ adalah [Lie derivative](007-differential-operations.html): $L_f h(x) = (\partial h/\partial x)f(x)$ dan $L_f^i h(x) = (\partial L_f^{i-1}h/\partial x)f(x)$. Ini sama persis dengan konstruksi koordinat di [203 — Normal Form](203-normal-form.html) — $\xi$ adalah rantai $z_1, \dots, z_r$ dan $\eta$ adalah sisa koordinat.

Dalam koordinat baru, sistemnya menjadi (eq 4):

$$
\begin{aligned}
\dot{\xi}_i &= \xi_{i+1}, \quad i = 1, \dots, r-1 \\
\dot{\xi}_r &= L_f^r h(x) + L_g L_f^{r-1}h(x)\,u \\
\dot{\eta} &= q(\xi, \eta) \\
y &= \xi_1
\end{aligned}
\tag{4}
$$

### Internal dynamics dan minimum-phase

Subsistem berdimensi $n - r$ (eq 5):

$$
\dot{\eta} = q(\xi, \eta) \tag{5}
$$

**benar-benar tak teramati** (*completely unobservable*) dari output, dan disebut **internal dynamics**. Di sinilah konsep kunci paper ini masuk:

- **Minimum-phase** — kalau internal dynamics (5) stabil (lokal). Analog nonlinier dari sistem linier yang semua zero-nya di paruh kiri.
- **Nonminimum-phase** — kalau (5) tidak stabil.

### Control law (eq 6)

Kalau (5) stabil lokal, maka untuk $L_g L_f^{r-1}h(x) \neq 0$ dan $v$ sebagai input eksternal, hukum *static state feedback* (eq 6):

$$
u = \frac{v - L_f^r h(x)}{L_g L_f^{r-1}h(x)} \tag{6}
$$

bisa melinierkan peta I/O sistem. Ini persis hukum feedback linearization di [201 — Feedback Linearization: Konsep Intuitif](201-feedback-linearization-konsep.html) — membatalkan $L_f^r h$ (drift output) lalu membagi dengan $L_g L_f^{r-1}h$ (koefisien input, yaitu $a(z)$ di [203 — Normal Form](203-normal-form.html)). Substitusi eq 6 ke $\dot{\xi}_r$ memberi $\dot{\xi}_r = v$, jadi rantai integrator murni dari $v$ ke $y$.

**Tapi ada masalah kalau nonminimum-phase.** Kalau internal dynamics (5) tidak stabil, feedback linearization ini **gagal**: mode tak teramati yang tak stabil tetap ada. Jadi exact I/O linearization **tidak bisa dicapai** untuk sistem nonlinier nonminimum-phase, karena skema linearisasi malah menghasilkan hukum kendali dengan inversi tak stabil. Inilah persoalan yang mau diselesaikan Wu di bagian-bagian berikutnya.

---

*Bersambung: §1.2 (approximate output tracking control) dan seterusnya.*
