---
title: "101 — Dua Tangki CSTR"
section: Example
tags: [cstr]
summary: "Model dua CSTR seri dengan pendingin cocurrent — persamaan model dari Henson & Seborg (1990)."
permalink: /101-dua-tangki-CSTR.html
folder: notes
last_updated: Jul 22, 2026
---

Dua CSTR terpasang seri, didinginkan oleh satu aliran pendingin yang mengalir
*cocurrent* (searah dengan aliran proses). Reaksi eksotermik ireversibel $$A \to B$$
terjadi di kedua tangki [@henson1990] (Pers. 24–28 di paper aslinya).

## Model Proses (Pers. 1–4)

$$
\begin{align}
\dot{C}_{A1} &= \frac{q}{V_1}(C_{Af} - C_{A1}) - k_0 C_{A1} \exp\!\left(-\frac{E}{RT_1}\right) \tag{1}\\[8pt]
\dot{T}_1 &= \frac{q}{V_1}(T_f - T_1) + \frac{(-\Delta H)\,k_0\,C_{A1}}{\rho C_p}\exp\!\left(-\frac{E}{RT_1}\right) \notag\\
&\quad + \frac{\rho_c C_{pc}}{\rho C_p V_1}\,q_c\left[1 - \exp\!\left(-\frac{hA_1}{q_c\,\rho_c\,C_{pc}}\right)\right](T_{cf} - T_1) \tag{2}\\[8pt]
\dot{C}_{A2} &= \frac{q}{V_2}(C_{A1} - C_{A2}) - k_0 C_{A2} \exp\!\left(-\frac{E}{RT_2}\right) \tag{3}\\[8pt]
\dot{T}_2 &= \frac{q}{V_2}(T_1 - T_2) + \frac{(-\Delta H)\,k_0\,C_{A2}}{\rho C_p}\exp\!\left(-\frac{E}{RT_2}\right) \notag\\
&\quad + \frac{\rho_c C_{pc}}{\rho C_p V_2}\,q_c\left[1 - \exp\!\left(-\frac{hA_2}{q_c\,\rho_c\,C_{pc}}\right)\right]\notag\\
&\quad\cdot\left[T_1 - T_2 + \exp\!\left(-\frac{hA_1}{q_c\,\rho_c\,C_{pc}}\right)(T_{cf} - T_1)\right] \tag{4}
\end{align}
$$

### Catatan untuk Pers. 4

Temperatur pendingin yang masuk ke jaket kedua **bukan** $$T_{cf}$$, melainkan
temperatur keluar pendingin dari jaket pertama. Untuk aliran *cocurrent*,
temperatur pendingin setelah tangki 1 adalah:

$$
T_{c,\text{out},1} = T_1 + \exp\!\left(-\frac{hA_1}{q_c\,\rho_c\,C_{pc}}\right)(T_{cf} - T_1)
$$

Inilah temperatur pendingin masuk untuk tangki 2. Jadi suku dalam kurung siku di
Pers. 4 sebenarnya adalah $$T_{c,\text{out},1} - T_2$$.

## Definisi State, Input, Gangguan, dan Output (Pers. 5)

$$
x \triangleq [C_{A1},\; T_1,\; C_{A2},\; T_2]^T, \quad
d \triangleq [C_{Af},\; T_{cf}]^T, \quad
u \triangleq q_c, \quad
y \triangleq C_{A2} \tag{5}
$$
