# CLAUDE.md — 碩士論文撰寫專案

本資料夾是撰寫碩士論文的專案（主題：multipole / hexapole 電磁致動器的 lumped-parameter 建模、校正與性能指標）。
語言：中文為主，英文技術名詞保留原文。

## 資料架構

```
thesis/
├─ CLAUDE.md            本檔：規則、架構、符號表
├─ reference/           參考論文 PDF（notation 權威來源：Lumped parameter model.pdf）
├─ doc/                 學校規範（格式條例 docx/pdf）+ NTHU 範本原始 zip（備份，勿改）
├─ pdf/                 thesis.pdf 編譯成品（latexmk 成功後自動從 latex/build/ 複製）+ template.pdf 學校範本原版（參考用，不覆蓋）
└─ latex/               論文本體，可獨立編譯的 LaTeX 專案
   ├─ main.tex          主檔：填基本資料（題目/姓名/學號/口試年月）+ 依序 \input 各部分；不寫內文
   ├─ nthu_thesis.cls   學校文件類別（版面/字型/行距/章節樣式）；僅改字型兩處，標 [thesis 修改]
   ├─ 2025Titlepage.tex 封面/書名頁版面（main.tex 引入兩次），不動
   ├─ notation.tex      符號巨集（規則 1 的唯一實作），main.tex 前言 \input
   ├─ .latexmkrc        編譯設定（xelatex、輸出到 build/、nomencl/glossaries 規則）
   ├─ front/            正文前頁面
   │   ├─ C_Abstract.tex / Eng_Abstract.tex   中/英文摘要
   │   ├─ acknowledgement.tex                 致謝
   │   └─ *.pdf          授權書/指導教授推薦書/考試委員審定書（簽名後掃描替換）
   ├─ contents/         正文：chapter01.tex ~ chapter05.tex，一章一檔（增減章在 main.tex 改）
   ├─ back/             appendix01.tex, appendix02.tex 附錄 + references.bib 參考文獻庫
   ├─ figures/          論文用圖（最終輸出檔）；正式內容依章分子夾 ch01/ ~ ch05/
   ├─ fonts/            範本附字型；中文用 fonts/chinese/BiauKai.ttf（標楷體 DFKai-SB）
   └─ build/            編譯產物（aux/log/bbl… 與 main.pdf），可整夾刪除重編
```

## 規則

### 規則 1：Notation 一律依照 `reference/Lumped parameter model.pdf`

論文中所有符號、命名、上下標、粗體/斜體慣例，**一律以 Menq, Kuo, Fan, Li, Long,
"Lumped-Parameter Modeling, Calibration, and Performance Measure of Flux Generation in
Multipole Electromagnetic Actuators"（IEEE/ASME T-Mech 投稿版）為準**。

- 不得自創符號；若需要論文中沒有的新符號，先提出並經使用者同意，再補進下表。
- 舊專案 / code 中的變數名（如 `A`, `Dv`, `Bstack`, `G`=電荷量 等）**不得**直接帶入論文，需轉成下表符號。
- 若下表與 PDF 有出入，以 PDF 為準並更正下表。

#### 排版慣例（取自該 paper）

- 向量、矩陣：粗體正體（**b**, **p**, **S**, **K**）；純量：斜體（ℓ, q, n）。
- 左上標 `B` 表示「以 flux density **b** 為輸出」的量：ᴮg_I, ᴮ**H**_I, ᴮ**G**_I。
- 下標 `I` = current-based，`V` = sensor-voltage-based。
- 帽子 ˆ = 校正估計值（ℓ̂, ê, ᴮĝ_I, ᴮ**Ĥ**_I）；上橫線 ¯ = 正規化量（**p̄**, **K̄**, **M̄**）。
- 下標 i = 空間校正點（i = 1…N_c）；j = 激發組（j = 1…N_I）；k = 第 k 個 sensor / 第 k 個奇異值。

#### 符號表

| 符號 | LaTeX 建議 | 維度 | 意義 | 式 |
|---|---|---|---|---|
| n_p | `n_p` | 純量 | 磁極數（hexapole：n_p = 6），n_p ≥ 2n | §II-A |
| n | `n` | 純量 | 工作空間維度（n = 3） | §II-A |
| P1…P6 | `\mathrm{P1}` | — | 磁極編號 | Fig.1 |
| x_a, y_a, z_a | `x_a` | — | actuator 座標系軸 | Fig.1 |
| Φ | `\Phi` | 純量 | 單極磁通 | §II-A |
| **Φ** | `\boldsymbol{\Phi}` | 6×1 | pole-tip flux vector | (16) |
| q | `q` | 純量 | 磁荷，q = Φ/μ_o | §II-B |
| μ_o | `\mu_o` | 純量 | 真空磁導率（下標用 o，非 0） | §II-B |
| **p** | `\mathbf{p}` | 3×1 | 工作空間任一點位置 | §II-B |
| **p**_c, **p**_ci | `\mathbf{p}_c` | 3×1 | 磁荷位置（第 i 極） | §II-B |
| ℓ | `\ell` | 純量 | characteristic length（正規化尺度） | §II-B |
| ℓ_o | `\ell_o` | 純量 | ℓ 的設計值 | §II-C |
| **p̄**, **p̄**_c | `\bar{\mathbf{p}}` | 3×1 | 無因次位置，**p̄** = **p**/ℓ | §II-B |
| **s**_c(**p̄**) | `\mathbf{s}_c` | 3×1 | spatial distribution vector，(**p̄**−**p̄**_c)/‖**p̄**−**p̄**_c‖³ | (1) |
| **S**(**p̄**) | `\mathbf{S}` | 3×6 | spatial-distribution matrix [**s**_c1 … **s**_c6] | (3) |
| **b** | `\mathbf{b}` | 3×1 | magnetic flux density | (2) |
| **Q** | `\mathbf{Q}` | 6×1 | magnetic-charge vector [q_1 … q_6]ᵀ | (2) |
| **I** | `\mathbf{I}` | 6×1 | input current vector | (4) |
| N_T | `N_T` | 純量 | 線圈匝數 | (4) |
| ℛ_a | `\mathcal{R}_a` | 純量 | lumped magnetic reluctance | (4) |
| **K** | `\mathbf{K}` | 6×6 | flux-distribution matrix（理論：對角 5/6、非對角 −1/6） | (4) |
| k_11 | `k_{11}` | 純量 | **K** 第一對角元素 | (7) |
| **K̄** | `\bar{\mathbf{K}}` | 6×6 | 正規化 flux-distribution matrix，**K̄** = 5/(6\|k_11\|)·**K** | (7) |
| **U** | `\mathbf{U}` | 3×6 | 標準基底矩陣 [î −î ĵ −ĵ k̂ −k̂] | (5) |
| **E** | `\mathbf{E}` | 3×6 | 無因次 offset matrix（各欄 = 正規化電荷 offset） | (5) |
| e_1x … e_6z | `e_{1x}` | 純量 | offset 分量；e_6z = e_1x − e_2x + e_3y − e_4y + e_5z | (6) |
| **e** | `\mathbf{e}` | 17×1 | 堆疊的 17 個 offset 參數 | (7) |
| ᴮg_I | `{}^{B}g_I` | 純量 | actuation gain（current-based） | (7) |
| ᴮ**H**_I | `{}^{B}\mathbf{H}_I` | 6×6 | input-current-flux matrix，= ᴮg_I **K̄** | §II-D |
| N_c | `N_c` | 純量 | 空間校正點數，**p**_i, i = 1…N_c | Phase 1 |
| N_I | `N_I` | 純量 | 激發組數，**I**_j, j = 1…N_I | Phase 1 |
| **F** | `\mathbf{F}` | 6×N_I | combined excitation matrix [**I**_1 … **I**_N_I]，rank = 6 | Phase 1 |
| **b**_ij | `\mathbf{b}_{ij}` | 3×1 | 第 j 組激發下第 i 點的 flux density | Phase 1, (8) |
| **W**(ℓ̂, ê) | `\mathbf{W}` | 6×6 | spatial-distribution weighting matrix，Σ_i **S**ᵀ**S** | (9) |
| **b̃**_ij | `\tilde{\mathbf{b}}_{ij}` | 6×1 | 投影到 spatial-distribution basis，**S**ᵀ**b**_ij | (10) |
| J(ℓ̂, ê) | `J` | 純量 | geometric-parameter cost function | (11) |
| **η**_j | `\boldsymbol{\eta}_j` | 6×1 | **W**⁻¹ Σ_i **b̃**_ij | (12) |
| **Θ** | `\boldsymbol{\Theta}` | 6×N_I | [**η**_1 … **η**_N_I] | (13) |
| ᴮ**Ĥ**_I | `{}^{B}\hat{\mathbf{H}}_I` | 6×6 | 校正得 input-current-flux matrix，**Θ****F**ᵀ(**F****F**ᵀ)⁻¹ | (14) |
| ĥ_11 | `\hat{h}_{11}` | 純量 | ᴮ**Ĥ**_I 第一對角元素 | (15) |
| ᴮĝ_I, **K̂̄** | `{}^{B}\hat{g}_I` | — | ᴮĝ_I = (6/5)\|ĥ_11\|，**K̂̄** = 5/(6ĥ_11)·ᴮ**Ĥ**_I | (15) |
| **Ê** | `\hat{\mathbf{E}}` | 3×6 | 校正得 offset matrix | (16) |
| **I**_6×6 | `\mathbf{I}_{6\times 6}` | 6×6 | 單位矩陣（注意與電流 **I** 區分） | §II-E |
| **v** | `\mathbf{v}` | 6×1 | Hall sensor voltage vector | §III-A |
| **M** | `\mathbf{M}` | 6×6 | sensor-network measurement matrix，**Φ** = **M****v** | (16) |
| m_11, **M̄** | `\bar{\mathbf{M}}` | 6×6 | **M̄** = 5/(6m_11)·**M** | (17) |
| ᴮg_V | `{}^{B}g_V` | 純量 | sensor-voltage-based actuation gain | (17) |
| ᴮ**H**_V | `{}^{B}\mathbf{H}_V` | 6×6 | sensor-voltage-flux matrix，= ᴮg_V **M̄** | §III-B |
| **v**_j, **V** | `\mathbf{V}` | 6×N_I | 第 j 組 sensor 電壓；combined voltage matrix [**v**_1 … **v**_N_I] | Addition |
| ᴮ**Ĥ**_V | `{}^{B}\hat{\mathbf{H}}_V` | 6×6 | **Θ****V**ᵀ(**V****V**ᵀ)⁻¹ | (19) |
| ᴮĝ_V, **M̂̄** | `{}^{B}\hat{g}_V` | — | ᴮĝ_V = (6/5)\|m̂_11\|，**M̂̄** = 5/(6m̂_11)·ᴮ**Ĥ**_V | (20) |
| v_kj | `v_{kj}` | 純量 | 第 j 次模擬第 k 個 sensor 電壓，s_H **n̂**_k·**b**_kj | (21) |
| s_H | `s_H` | 純量 | Hall sensor 靈敏度（mV/mT） | (21) |
| **n̂**_k | `\hat{\mathbf{n}}_k` | 3×1 | 第 k 個 sensor 表面法向量 | (21) |
| d | `d` | 純量 | sensor 距 pole tip 距離 | §III-A |
| h | `h` | 純量 | sensor 與表面間隙（housing 厚度決定） | §III-A |
| MAEP | `\mathrm{MAEP}` | % | mean absolute error percentage | (24) |
| ᴮ**G**_I(**p**) | `{}^{B}\mathbf{G}_I` | 3×6 | position-dependent actuation gain matrix，**S**(**p**/ℓ̂, ê)ᴮ**Ĥ**_I | (27) |
| **UΣV**ᵀ, σ_k, **u**_k, **v**_k | `\sigma_k` | — | ᴮ**G**_I 的 SVD（σ_1 ≥ σ_2 ≥ σ_3）；此處 **U**/**V** 與 (5) 的 **U**、電壓 **V** 不同義 | (28) |
| ℰ(ᴮ**G**_I(**p**)) | `\mathcal{E}` | 純量 | efficiency index，(Π σ_k)^(1/3) | (29) |
| κ(ᴮ**G**_I(**p**)) | `\kappa` | 純量 | isotropy index，σ_min/σ_max = σ_3/σ_1 | (30) |

#### 已知與舊工作區用語的衝突（寫論文時以 paper 為準）

- 舊 memory / code 把「點電荷量」叫 **G**（code `Dv`）；paper 中電荷投影量是 **η**_j / **Θ**，**G** 專指 ᴮ**G**_I(**p**)（3×6 gain matrix）。
- 舊 code 的 `A`（堆疊幾何核）→ 論文用 **S**(**p**_i/ℓ̂, ê)；`Bstack` → **b**_ij。
- 舊稱 gain/iso 指標 𝒞 → 論文用 ℰ（efficiency index）與 κ（isotropy index）。
