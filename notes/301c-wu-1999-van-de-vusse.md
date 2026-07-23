---
title: "301c — Wu (1999): Van de Vusse & Kesimpulan"
section: Paper Review
tags: [paper-review, cstr]
summary: "Bagian akhir review Wu 1999 — contoh reaksi Van de Vusse (CSTR isotermal & adiabatik) yang nonminimum-phase, hasil simulasi SIC vs AOTC, dan kesimpulan."
permalink: /301c-wu-1999-van-de-vusse.html
folder: notes
last_updated: Jul 23, 2026
---

Bagian akhir review [@weiwu1999], lanjutan [301b — Wu (1999): Stable Inversion (metode)](301b-wu-1999-stable-inversion.html). Di sini metodenya diuji pada reaksi **Van de Vusse** — contoh klasik CSTR nonminimum-phase.

## §3.1 CSTR isotermal

Reaksi Van de Vusse seri/paralel ($A \to B \to C$, $2A \to D$) di CSTR isotermal (eq 41):

$$
\begin{aligned}
\dot{C}_A &= -k_1 C_A - k_3 C_A^2 + \frac{F}{V_r}(C_{Af} - C_A) \\
\dot{C}_B &= k_1 C_A - k_2 C_B - \frac{F}{V_r}C_B
\end{aligned}
\tag{41}
$$

dengan $F$ laju alir umpan, $V_r$ volume reaktor, $C_A, C_B$ konsentrasi reaktan dan intermediate, $C_{Af} = 10$ kmol m⁻³ konsentrasi umpan. Konstanta laju $k_1 = 0.05$ h⁻¹, $k_2 = 0.1$ h⁻¹, $k_3 = 0.01$ (kmol h)⁻¹. **Output** $C_B$ dikendalikan dengan memanipulasi *dilution rate* $F/V_r$.

Pada $(F/V_r)_s = 0.1$ titik kesetimbangannya $(C_A^s, C_B^s) = (2.49, 0.622)$. Dengan variabel geser $x_1 = C_A - C_A^s$, $x_2 = C_B - C_B^s$, $u = (F/V_r) - (F/V_r)_s$, sistem jadi bentuk (eq 42) dengan origin sebagai titik operasi.

Output $x_2$ melacak trajektori (eq 43):

$$
y_d(t) = \begin{cases} a(1 - \cos t) & a > 0,\; t \in [0, 2\pi] \\ 0 & \text{lainnya} \end{cases}
\tag{43}
$$

**Relative degree = 1** ($\dot{y} = \dot{x}_2 = \dot{y}_d$). Control law I/O linearization (eq 44), dengan internal dynamics lewat transformasi $\eta = x_1$ (eq 45).

**Sifat nonminimum-phase.** Untuk $a \geq 0.02$, dinamika $\eta$ **tak stabil** dan input $u$ jadi tak terbatas (Fig. 3). Jadi reaktor ini nonminimum-phase begitu amplitudo sinyal tracking melebihi 0.02 — bukan sekadar *slightly* NMP, sehingga [AOTC](301a-wu-1999-motivasi.html) tak memadai.

**Hasil.** Dengan [stable inversion](301b-wu-1999-stable-inversion.html), initial estimate $(x_1(0), x_2(0)) = (0.7564, 0)$ dari shooting method memberi tracking eksak (Fig. 4). Dibandingkan AOTC (dengan $\rho = 2$, eq 48), **SIC memberi tracking lebih baik dan gerak kendali lebih mulus** (Fig. 5). Untuk gangguan konsentrasi umpan $C_{Af}(1 + d(t))$, skema DFF/FB berhasil mengompensasi gangguan step $\pm 50\%$ secara asimptotik, sementara I/O linearization biasa gagal bahkan pada $d = 10\%$ (Fig. 6–7).

## §3.2 CSTR adiabatik

Contoh kedua: Van de Vusse di CSTR adiabatik (3 state, dengan temperatur $x_3$), eq 49:

$$
\begin{aligned}
\dot{x}_1 &= \kappa_1(x_3)(x_1 + C_A^s) - \kappa_3(x_3)(x_1 + C_A^s)^2 + [u + (F/V_r)_s](C_{Af} - x_1 - C_A^s) \\
\dot{x}_2 &= \kappa_1(x_3)(x_1 + C_A^s) - \kappa_2(x_3)(x_2 + C_B^s) - [u + (F/V_r)_s](x_2 + C_B^s) \\
\dot{x}_3 &= (\rho_0 c_p)^{-1}\bigl[-\delta H_1 \kappa_1(x_3)(x_1 + C_A^s) - \Delta H_2 \kappa_2(x_3)(x_2 + C_B^s) \\
&\qquad - \Delta H_3 \kappa_3(x_3)(x_1 + C_A^s)^2\bigr] + [u + (F/V_r)_s](T_f - x_3 - T_s)
\end{aligned}
\tag{49}
$$

dengan $\kappa_i(x_3) = k_{i0}\exp(-E_i / R(x_3 + T_s))$, dan parameter di Tabel 1 (misalnya $\Delta H_1 = -5$, $\Delta H_2 = -15$, $\Delta H_3 = -20$, $T_f = 100$). Kesetimbangan stabil $(C_A^s, C_B^s, T_s) = (2.499, 0.624, 240.659)$.

Lagi-lagi **relative degree = 1** dan **nonminimum-phase** untuk $a \geq 0.02$ ($\eta_1, \eta_2$ tak stabil, Fig. 8). Dengan stable inversion, initial estimate $(x_1(0), x_2(0), x_3(0)) = (0.7449, 0, -14.5631)$ memberi tracking eksak (Fig. 9). **SIC lebih memuaskan daripada AOTC**; AOTC dengan $k = 0$ malah tak stabil karena galat aproksimasi (Fig. 10). DFF/FB kembali menolak gangguan $+50\%$ (Fig. 11).

## §4 Kesimpulan

Poin-poin penutup [@weiwu1999]:

- Studi ini dimotivasi keterbatasan I/O linearization — butuh *stable inversion* dan *state feedback*.
- Di bawah asumsi *trackability* dan pembatasan ruang input, skema feedforward dari stable inversion menstabilkan sistem closed-loop. **Kuncinya**: menetapkan ulang kondisi awal dari dinamika tak stabil lewat **shooting method**.
- Karena SIC "murni" rusak oleh perturbasi, skema **DFF/FB** dirancang untuk menolak gangguan terukur sambil menjamin kestabilan closed-loop.
- Keunggulan atas metode lain: **(1)** pengendalinya bisa jadi *output feedback* kalau sistem open-loop stabil; **(2)** dengan info trajektori diinginkan dan gangguan konstan, tracking dan gerak kendali bagus, dengan *no-offset*.

## Catatan penutup review

Benang merahnya untuk catatan kita: paper ini berdiri di atas fondasi [relative degree](202-relative-degree.html) dan [normal form](203-normal-form.html), lalu menyerang titik lemah [feedback linearization](201-feedback-linearization-konsep.html) — yaitu *internal dynamics* yang tak stabil pada sistem nonminimum-phase. Solusinya bukan mengubah hukum kendali aljabar (eq 6 tetap dipakai), melainkan **cara mencari trajektori referensi**: lewat BVP + shooting method, bukan integrasi maju biasa.
