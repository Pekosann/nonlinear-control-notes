---
title: "301b — Wu (1999): Stable Inversion (metode)"
section: Paper Review
tags: [paper-review, feedback-linearization]
summary: Bagian 2 review Wu 1999 — metode stable inversion 4 langkah (shooting method), lalu skema dual feedforward/feedback (DFF/FB) untuk menolak gangguan terukur.
permalink: /301b-wu-1999-stable-inversion.html
folder: notes
last_updated: Jul 23, 2026
---

Lanjutan [301a — Wu (1999): Motivasi & Exact I/O Linearization](301a-wu-1999-motivasi.html). Bagian ini metode inti paper [@weiwu1999]: **stable inversion** untuk sistem nonminimum-phase, lalu perluasannya untuk menolak gangguan (**DFF/FB**).

## Sistem galat (error system)

Wu bekerja dengan sistem dalam bentuk deviasi, digeser supaya kesetimbangannya di origin. $f_0, g_0, h_0$ adalah $f, g, h$ dalam bentuk galat, dengan $f_0(0) = 0$. Ditinjau *perturbed error system* (eq 14):

$$
\dot{x} = f_0(x) + g_0(x)u, \qquad e = h_0(x), \qquad x(0) = 0
$$

dengan $e = y - y_d$ *tracking error*, dan $\omega(\cdot) \in \mathbb{R}^p$ gangguan ($\omega(0) = 0$).

Untuk melacak $y_d$ secara persis (kasus $\omega = 0$), dipakai kendali berbasis inversi (Devasia et al., eq 15):

$$
u(t) = u_d(t) + K\bigl(x_d(t) - x(t)\bigr) \tag{15}
$$

dengan $(u_d, x_d)$ pasangan trajektori input–state yang diinginkan, dan $K \in \mathbb{R}^{1 \times n}$ gain penstabil. **Masalah stable inversion**: temukan $u_d(t)$ dan $x_d(t)$ yang **terbatas** (bounded) sedemikian model galat terpenuhi, $y = y_d$ sepanjang waktu, dan $u_d, x_d \to 0$ saat $t \to \pm\infty$ (eq 16).

## §2.1 Prosedur stable inversion (4 langkah)

Kuncinya bukan menyelesaikan *initial-value problem* biasa, melainkan **two-point boundary value problem** — dari situlah trajektori yang stabil didapat.

**Assumption 1** (eq 19) — suku nonlinier $F(\cdot, \cdot)$ *locally Lipschitz* di sekitar origin (ada konstanta $l_1, l_2 > 0$ dan matriks $A = \partial F/\partial x$ dievaluasi di $(0,0)$). **Theorem 1** [@weiwu1999]: kalau pertumbuhan $F$ memenuhi Lipschitz (19) dan $y_d$ terbatas, maka untuk $l_1, l_2$ cukup kecil, $u_d(t) \to 0$, $x_d(t) \to 0$ saat $t \to +\infty$, dan ada solusi tunggal.

Prosedurnya:

- **Step 1** — pastikan relative degree $r$ terdefinisi baik: $L_{g_0}L_{f_0}^{r-1}h_0(x) \neq 0$ (eq 21).
- **Step 2** — definisikan koordinat $\bar{\xi}_i = L_{f_0}^{i-1}h_0(x)$ (eq 22); sistem jadi bentuk [normal form](203-normal-form.html) (eq 23). Feedback law (eq 24):
$$
u = \bigl(L_{g_0}L_{f_0}^{r-1}h_0(x)\bigr)^{-1}\bigl[v - L_{f_0}^r h_0(x)\bigr] \equiv \alpha(\bar{\xi}, \bar{\eta}, v)
$$
memberi hubungan I/O linier $y^{(r)} = v$ (eq 25). Pilih $v = y_d^{(r)}$ (eq 26), sehingga internal dynamics tereduksi jadi (eq 27) $\dot{\bar{\eta}} = s_0(\bar{\xi}_d, \bar{\eta}, y_d^{(r)})$, $\bar{\eta}(+\infty) = 0$.
- **Step 3** — cari trajektori kausal $\bar{\eta}_d(\cdot)$ dengan menyelesaikan BVP (27) memakai syarat batas hampiran $x(T) = 0$, $T$ cukup besar. Wu memakai **shooting method** (paket IMSL) atau trial-and-error dengan interpolasi linier.
- **Step 4** — trajektori state asli dari inversi $\bar{\varpi}^{-1}$ (eq 28) $x_d = \bar{\varpi}(\bar{\xi}_d, \bar{\eta}_d)$, dan input feedforward yang diinginkan (eq 29) $u_d = \alpha(\bar{\xi}_d, \bar{\eta}_d, y_d^{(r)})$.

Skema lengkapnya (**stable inverse control, SIC**) berupa *stable inversion* menghasilkan $u_d$, lalu $u = u_d + K(x_d - x)$ (Fig. 1 di paper). Kalau origin sistemnya stabil, $K = 0$ boleh — jadi kendali *output feedback* murni.

> **Remark 3** [@weiwu1999]. *We utilize the constructive iteration on the basis of the shooting method to replace the contraction mapping for the Picard-like process.* Inilah bedanya dengan Devasia et al.: shooting method menggantikan iterasi Picard yang noncausal, jadi tak perlu *preactuation*.

## §2.2 Penolakan gangguan (DFF/FB)

Karena SIC "murni" dihasilkan dari model matematis semata, gangguan kecil pun bisa merusak tracking. Wu memperluasnya. Tinjau sistem terganggu (eq 30):

$$
\dot{x} = f_0(x) + g_0(x)u + \omega(t) = F_d(x, u, \omega), \qquad x(+\infty) = 0 \tag{30}
$$

**Theorem 2** [@weiwu1999] menjamin: untuk perturbasi konstan yang cukup kecil, tracking error tetap terbatas.

Andaikan gangguan $\omega(t)$ **terukur dan hanya muncul di ruang input** (*matched disturbance*), yaitu (eq 33) $L_\omega L_{f_0}^{i-1}h_0(x) = 0$ untuk $i = 1, \dots, r-1$. Maka sintesis feedforward/feedback (eq 35):

$$
u = \bigl(L_{g_0}L_{f_0}^{r-1}h_0\bigr)^{-1}\bigl[v - L_{f_0}^r h_0\bigr] - \bigl(L_{g_0}L_{f_0}^{r-1}h_0\bigr) \equiv \beta(\bar{\xi}, \bar{\eta}, v, \omega)
$$

Input feedforward yang diinginkan jadi (eq 38) $u_d = \beta(\bar{\xi}_d, \bar{\eta}_d, y_d^{(r)}, \omega)$. **Theorem 3** [@weiwu1999]: kalau matched disturbance (33) terukur dan konstantanya cukup kecil, ada solusi tunggal dan tracking asimptotik tercapai.

Rancangan ini disebut **dual feedforward/feedback (DFF/FB)**: menggabungkan feedforward gangguan terukur dengan feedforward trajektori yang diinginkan, plus feedback penstabil $K(x_d - x)$ (Fig. 2 di paper). Untuk proses kimia, matched disturbance ini bisa berupa gangguan laju alir umpan.

## Ringkasan tiga skema

| Skema | Untuk | Kendali |
|---|---|---|
| I/O linearization (§1.1) | minimum-phase | eq 6 — gagal kalau NMP |
| AOTC (§1.2) | *slightly* NMP | eq 11 — kurang robust ke gangguan |
| **SIC** (§2.1) | NMP "murni" | $u = u_d + K(x_d - x)$, $u_d$ dari shooting |
| **DFF/FB** (§2.2) | NMP + gangguan terukur | tambah feedforward gangguan (eq 35, 38) |

Penerapan ke reaksi Van de Vusse ada di [§3](301c-wu-1999-van-de-vusse.html).
