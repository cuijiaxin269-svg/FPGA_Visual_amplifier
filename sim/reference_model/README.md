# 视频微振动检测：Python 算法可行性验证

本目录保留独立 Python 参考模型的代码和说明，下文的“本工程”“本阶段”均指该模型。历史数值来自模型运行记录；FPGA 系统的实现与上板情况见[项目首页](../../README.md)。历史汇总报告随仓库保留，逐试次 CSV、视频、图表及环境记录可按下述命令重新生成。

本工程验证：**连续视频 → ROI 灰度边缘 → 每帧位置 x[n] → 去直流/可选去趋势 → Hann 窗 → 一维 FFT → 主频**。
默认 640×480、120 fps、10 Hz、2 pixel 峰值振幅、5 s，共 600 帧。所有正式扫描都实际写入并解码 MP4，检测器不接收理论位置或真实频率。

该参考模型用于检查图像定位与频率分析方法，不调用 Verilog、HLS 或板端硬件。日常使用已完成的整机无需重新执行本目录的全部扫描。

## 快速开始

建议 Python 3.10+。从提交仓库根目录打开 Windows PowerShell：

```powershell
Set-Location sim/reference_model
py -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe main.py --stage baseline
.\.venv\Scripts\python.exe main.py --stage all
.\.venv\Scripts\python.exe -m unittest discover -s tests -v
```

如果已有依赖，直接 `py main.py --stage all`。Linux/macOS 使用 `python3`，虚拟环境解释器为 `.venv/bin/python`。无需摄像头、显示窗口或额外数据集。完整扫描需几分钟，含噪声的视频通常更慢；终端逐试次打印进度。

分阶段运行：

```powershell
py main.py --stage baseline   # 仅整数定位 + 默认频率
py main.py --stage demo       # 整数与亚像素对比
py main.py --stage frequency  # 7 个频率 + 非频点频率 + 静止对照
py main.py --stage amplitude  # 6 个振幅 × 3 个空间偏移
py main.py --stage noise      # 7 种噪声 × 2 个振幅 × 3 个种子
py -m tests.codec_diagnostic # 原始浮点/8位/MP4/无损 FFV1 对照
py -m tests.replot           # 从已保存数据重画，无需重生成视频
py -m src.render_video      # 从仿真视频生成带检测标注的视频与4倍慢放版
```

`demo` 和 `all` 会额外生成 `results/processed_video.mp4`（原速）及 `results/processed_video_slow.mp4`（默认 4 倍慢放）。画面包括原视频、ROI、整数/亚像素边缘、ROI 中央条带的空间放大、滚动位移曲线和完整记录的 FFT 主频。FFT 为离线全片结果，并非当时已经得到的实时估计；慢放版的频率和时间轴仍以原始采样时间为准。空间放大仅便于观察，不是运动放大算法。可用 `py -m src.render_video --results results_custom --slow-factor 8` 调整目录和慢放倍数。

`baseline` 只输出最小链路所需文件；`all` 产生全部交付物。每次相同输出目录中的同名结果会更新。对比不同配置时请使用不同的 `--output` 目录，避免混用旧扫描结果。

## 配置

所有默认参数集中在 `config.py` 的 `Config`。也可通过 JSON 覆盖部分参数，未写字段使用默认值：

```json
{
  "fps": 120,
  "frequency_hz": 10,
  "amplitude_px": 0.2,
  "duration_s": 5,
  "roi": [280, 160, 80, 160],
  "detrend": false,
  "seed": 2026
}
```

保存为 `my_config.json` 后：

```powershell
py main.py --config my_config.json --stage all --output results_custom
```

也可复制现成的 `example_config.json`。每个输出目录都会保存自己的 `ground_truth.npz`；默认输出另复制一份至 `data/ground_truth.npz`，自定义输出不会覆盖默认真值。

|参数|含义|
|---|---|
|width / height|图像尺寸；MP4 要求正偶数|
|fps / duration_s|帧率和时长；帧数 `round(fps*duration_s)`，不重复终点|
|frequency_hz / amplitude_px|正弦频率和峰值振幅；峰峰值是 2A|
|x0 / phase_rad|初始中心位置和时间相位；坐标以像素中心为整数|
|roi|`[左上x, 左上y, 宽, 高]`，必须覆盖整个运动范围与质心邻域|
|dark_level / bright_level|默认灰度 25/230，保留一定亮度变化余量|
|blur_scale_px / pixel_samples|连续 tanh 边缘扩散宽度 / 每像素空间积分采样数|
|centroid_radius|梯度峰左右各 4 pixel 的质心范围|
|gaussian_std|8 位灰度单位的高斯噪声标准差|
|brightness_amplitude / brightness_hz|全图加性正弦亮度变化幅度 / 频率，默认 1.3 Hz|
|impulse_probability|每帧每像素椒盐噪声概率，一半黑、一半白|
|codec|主流程默认 `mp4v`，须使用支持 MP4 容器的编码器；FFV1 仅诊断脚本采用 AVI|
|detrend|是否进一步去掉线性趋势|
|min_signal_std_px|去均值/趋势后标准差不超过该值，输出 `no_signal`|
|min_peak_fraction|峰及相邻两个频点的能量占非 DC 总能量的下限，默认 0.25|
|frequency_tolerance_hz|仿真频率通过判据，默认绝对误差 ≤ 0.2 Hz|
|max_normalized_rmse|位移可靠判据：位移 RMSE / 真值 RMS ≤ 0.25|
|frequencies_hz / amplitudes_px|频率扫描 / 振幅扫描列表|
|spatial_offsets_px|初始边缘相对默认 x0 的偏移，默认 0、0.25、0.5 pixel|
|noise_amplitudes_px / noise_seeds / noise_cases|噪声实验振幅、种子、场景参数|

修改帧率后也要检查扫描频率列表：所有仿真频率须严格小于 fps/2。默认扫描在无噪声配置下进行；噪声扫描由 `noise_cases` 控制，单次 demo 则直接使用配置中的噪声参数。修改分辨率时应同时调整 x0 和 ROI。

## 文件结构与模块职责

以下包含运行后生成的文件；随仓库附带的历史汇总另存于 `results/historical_test_report.md`，不会被默认生成的 `TEST_REPORT.md` 覆盖。

```text
sim/reference_model/
├── README.md
├── requirements.txt
├── config.py
├── main.py                      命令行与单次演示
├── src/
│   ├── generate_video.py         理论轨迹、连续边缘渲染、噪声、视频编码
│   ├── edge_detector.py          视频解码、ROI、整数定位、梯度质心
│   ├── signal_processing.py      去均值、去趋势、周期 Hann 窗
│   ├── fft_analysis.py           单边幅频谱、置信状态、峰值与插值
│   ├── experiments.py            扫描、评价、CSV、自动测试报告
│   └── visualization.py          时域/频域/扫描图，PNG 与 SVG
├── tests/
│   ├── test_frequency.py         FFT 标度、奇偶长度、Nyquist、视频端到端
│   ├── test_amplitude.py         微小运动、无损对照、随机种子、无边缘
│   ├── test_noise.py             噪声峰/混叠/不合法输入检查
│   ├── codec_diagnostic.py       压缩误差分解实验
│   └── replot.py                 读取已保存数据重画
├── data/ground_truth.npz          默认 demo 的理论时间、位置与位移
└── results/
    ├── simulation_video.mp4
    ├── displacement.csv
    ├── displacement_comparison.png / .svg
    ├── displacement_signal.png / .svg
    ├── fft_spectrum.png / .svg
    ├── frequency_test.csv / .png / .svg
    ├── amplitude_test.csv / .png / .svg
    ├── noise_test.csv / .png / .svg
    ├── micro_displacement.png / .svg
    ├── control_test.csv
    ├── codec_diagnostic.csv
    ├── TEST_REPORT.md             实际数据自动汇总
    ├── demo_summary.json / config_used.json / environment.json
    └── traces/                   每试次理论/检测序列 NPZ 与完整配置 JSON
```

批量 MP4 在临时目录生成，解码完成后自动清理，避免留下大量噪声视频。逐试次序列与配置保留，可重现输入；不将全部视频帧加载进内存。原有 `D:\vision\mo_ni\IMG_9824.MP4` 未参与本阶段测试。

## 算法原理

### 1. 连续边缘和像素采样

理论位置为 `p[n] = x0 + A*sin(2*pi*f*n/fps + phase)`，理论位移为 `d[n] = p[n]-x0`。图像是固定的明暗半平面，只有中间垂直边界左右移动。

用 `0.5 + 0.5*tanh((x-p[n])/blur_scale_px)` 模拟有限清晰度的边缘，像素覆盖范围 `[j-0.5, j+0.5]` 内取 8 个空间采样平均，再映射灰度、加噪、裁剪、量化至 uint8。**不把 p[n] 先取整**；否则亚像素运动在输入阶段便消失，无法检验亚像素算法。

空间积分不是曝光时间积分。当前仿真没有运动曝光模糊、滚动快门或镜头畸变。tanh 是简化边缘扩散模型，不是已经标定的真实镜头 PSF。

### 2. ROI、灰度梯度和定位

每帧解码为 BGR → 灰度 → 固定 ROI。在 ROI 内沿高度平均，得到每列的平均灰度 `P[j]`，再计算中心差分：

`g[j] = abs(P[j+1]-P[j-1])/2`。

中心差分对应整数像素中心，不会引入前向差分容易遗漏的 0.5 pixel 坐标偏移。平均和线性差分可交换；先平均可以减少运算，并降低不同行独立图像噪声。ROI 默认高 160 行，此优势依赖边缘竖直、各行运动一致。

- 整数版：`j_peak = argmax(g)`，全图位置是 `roi_x+j_peak`。
- 亚像素版：在峰附近 ±4 pixel 内，`j_sub = sum(j*g[j])/sum(g[j])`，再加 ROI 左边界坐标。

没有使用真值引导局部搜索、修正输出、选择频率带或补偿误差。无可见梯度会明确报错；固定 ROI 内存在更强干扰边缘时仍可能错误跟踪。

### 3. 时间信号与 FFT

每帧只有一个横向位置，600 帧组成长度为 600 的一维序列。振动频率描述**位置随时间**的重复速度，因此沿帧序号（时间）做 FFT。对单帧图像沿空间做 FFT 得到的是空间频率（周期/像素），不能直接当作 Hz。

处理顺序：

1. 减去均值：`x_ac = x_detect-mean(x_detect)`。
2. 可选线性去趋势；短记录下去趋势也可能影响低频真实运动。
3. 周期 Hann：`w[n] = 0.5-0.5*cos(2*pi*n/N)`。
4. `X = np.fft.rfft(x_processed*w)`。
5. 频率轴 `np.fft.rfftfreq(N, d=1/fps)`。
6. 单边振幅先除以 `sum(w)` 修正窗的相干增益，再将非 DC、非偶数长度 Nyquist 频点乘 2。单位是 pixel；不是功率谱密度。
7. 搜索所有非 DC 频点的最大值，保留原始 `peak_bin_hz`；峰两侧存在有效邻点时，对对数幅度做三点抛物线插值，输出 `estimated_frequency_hz`。

Hann 抑制泄漏但会展宽主瓣。幅度峰值对于不落频点的正弦仍有栅栏效应；频谱插值只改善单峰估计，不提高真实频率分辨能力。默认 N=600，`Δf=fps/N=0.2 Hz=1/5 s`。本工程不靠零填充伪造更高分辨率。

标准差过小输出 `no_signal`，频率留空。随机噪声也总会有“最大峰”，因此额外计算峰 ±1 bin 能量比例；低于 0.25 标 `low_confidence`，仍保留候选频率以分析失败。`ok` 只表示此启发式门限通过，不等于已证明是真实振动；周期性照明也可能产生高置信假峰。

### 4. 采样与 Nyquist

120 fps 的严格无混叠频带是 `0 < f < 60 Hz`。恰好 60 Hz 时，正弦采样值可能全为零，取决于相位；本工程拒绝把边界频率作为正常仿真输入。70 Hz 被 120 fps 采样会看起来像 50 Hz，单靠 FFT 无法恢复真实频率。

实践应让帧率高于最高目标频率的两倍并留余量，保证足够的周期内样本数。曝光时间还会抑制高频位移；记录越长频点间距越小，帧率越高可测频带越宽。这两者作用不同。真实视频应检查实际时间戳、掉帧和可变帧率，不能把播放帧率无条件当作物理采样率。

## 评价指标和实验设计

CSV 中同时保存真实/估计频率、绝对误差、相对误差（百分数）、位移 RMSE、位置 RMSE、偏差、归一化 RMSE、谱峰幅度、能量比例、状态与通过标记。

- `position_rmse_px`：直接比较完整位置坐标，包含恒定偏差。
- `displacement_rmse_px`：分别去均值后比较位移，用于振动波形评价；不拟合幅度、不调整相位、不平移时间。
- `normalized_rmse`：位移 RMSE / 真值位移 RMS。A=0 时未定义，留空。
- `frequency_success`：非零运动、`status=ok` 且绝对频差 ≤ 0.2 Hz。
- `displacement_reliable`：频率通过，且 normalized_rmse ≤ 0.25。
- `false_positive`：静止物体的结果却是 `status=ok`。

缺失的频率/误差是“无法估计”，不是零误差。低置信候选频率仍记录其实际误差，不剔除失败数据。报告中的通过数是本批次的计数，不是统计置信区间。

频率扫描覆盖 2/5/10/15/20/30/40 Hz。由于这些频率都落在 0.2 Hz 频点，还额外测试 7.13/10.07/23.37 Hz，避免只给理想案例。幅度扫描的每个幅度测试 3 个空间位置；这不是独立噪声重复，而是检查像素网格敏感性。

噪声包含无噪声、高斯 σ=5、亮度波动 ±40、0.1% 椒盐、中等混合、强混合以及饱和压力场景。分别测试 2 和 0.2 pixel，每场景 3 个固定种子。亮度变化是确定性的，因此纯亮度场景的重复结果相同；不能把它们视为 3 次独立观测。噪声图显示每个种子的点，采用 symlog 轴同时展示零误差和大误差，不以平均值掩盖失败。

## 历史实际验证（整理前结果）

历史汇总见 [results/historical_test_report.md](results/historical_test_report.md)，按原文件字节归档。本节数值沿用原参考模型说明，未在本轮重新测量。原逐次 CSV 和 `environment.json` 尚未收录；运行上述扫描后，新的汇总、逐次数据与环境信息分别生成到 `results/TEST_REPORT.md`、对应 CSV 和 `results/environment.json`，应与这份历史结果区分。

- 最小整数链路：10 Hz → 10.000000 Hz，位移 RMSE 0.154701 pixel。
- 默认亚像素链路：10 Hz → 10.000000 Hz，位移 RMSE 0.019151 pixel。
- 7 个指定频率，两种算法均检出，误差在显示精度内为零。这是频点对齐的理想仿真结果，不能推广为真实测量零误差。
- 非频点频率误差约 0.0022–0.0031 Hz。
- 整数定位：三种空间位置均检出主频的最小已测幅度是 1 pixel；更小振幅可能变成恒定序列，或因跨越像素边界而偶然检出。
- 亚像素定位：0.1 pixel 仍在三种位置全部检出 10 Hz；要求归一化位移 RMSE ≤25% 时，最小全部通过的已测幅度为 0.2 pixel，0.1 pixel 三种位置均未通过。
- 0.1 pixel 压缩诊断：浮点原始图 RMSE 0.000052 pixel，8 位原始/FFV1 约 0.003116 pixel，MP4 约 0.027755 pixel。MP4 可保留频率，同时明显损害波形与振幅。
- 0.2 pixel + 中等混合噪声：亚像素 3/3 检频通过，最大频差 0.002510 Hz，最大位移 RMSE 0.056206 pixel；波形准确度未达到上述 25% 判据。
- 0.2 pixel + 强混合噪声：亚像素 0/3 检频通过，错误峰约 1.3 Hz，与照明扰动一致，最大频差 8.703318 Hz；即使状态 `ok` 也会选错物理来源。
- 过曝饱和压力场景：两种振幅、两种算法均 0/3 通过；最大位移 RMSE 超过 8 pixel。失败结果全部保留。

## 局限性

1. 当前为单条高对比竖直直边、单频平移；旋转、形变、多个边缘、遮挡和非刚体运动不在保证范围内。
2. ROI 高度平均对独立噪声非常有利；真实散斑、固定图样噪声和相机抖动未必能平均掉。
3. 缺少曝光积分、滚动快门、镜头标定、运动模糊、时间抖动和掉帧模型。
4. 有损视频压缩、8 位量化和亮度饱和会损伤亚像素信息；增大质心窗口也可能纳入更多噪声或干扰边缘。
5. 频率可检测下限与位移准确度下限不同。本次 0.1 pixel 检频成功不是普遍的最小可测振幅，更不是微米级精度证明；物理单位需要 pixel/mm 标定。
6. 单最大峰方法可能把谐波、周期性照明、相机抖动当主频；置信门限未做真实场景 ROC 标定。
7. 固定采样率是假设；极低频需要更长记录，多频近邻需要分辨率与谱估计方面的额外验证。

## 与整机资料的关系

本目录保留早期独立模型，原来的“后续移植到 Zynq”规划已不作为项目待办。当前 FPGA 代码位于 `src/`；同输入黄金参考与 HLS C 模型对比见 [v19 量化记录](../../board/results/v19_acceptance_20261103/README.md)，当前收尾安排见[项目清单](../../report/submission_gaps.md)。

## 参考

- [NumPy rFFT 文档](https://numpy.org/doc/stable/reference/generated/numpy.fft.rfft.html)：实数输入的非负频率 FFT。
- [NumPy rfftfreq 文档](https://numpy.org/doc/stable/reference/generated/numpy.fft.rfftfreq.html)：由采样间隔构造频率轴。
- [SciPy Hann 文档](https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.windows.hann.html)：周期窗与对称窗的区分。本工程直接用 NumPy 计算窗，不依赖 SciPy。
