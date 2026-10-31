# Vivado 2025.2 编译验证

2026-10-30 已使用 **Vivado 2025.2（SW build 6299465）** 从本次整理的源码副本完整生成位流、XSA 和调试探针，主进程退出码为 0。71 个独立 IP 综合、顶层综合、布局布线及原有物理检查均完成。构建目录为 `D:/vision/submission/_build/v25`，没有复用历史 2021.2 或先前 C 盘尝试的实现检查点。

| 本轮最终指标 | 结果 |
| --- | ---: |
| WNS / TNS | +0.177 / 0.000 ns |
| WHS / THS | +0.010 / 0.000 ns |
| WPWS / TPWS | +0.264 / 0.000 ns |
| LUT | 138026 / 277400（49.76%） |
| FF | 206397 / 554800（37.20%） |
| BRAM | 744.5 / 755 tiles（98.61%） |
| DSP | 826 / 2020（40.89%） |

最终 DRC 无 Error/Critical Warning，CDC 无 Critical，methodology 无 Critical Warning，bus-skew 无违反项；无时钟、无约束内部端点、异常生成时钟均为 0。外部 I/O 的无延迟计数为输入 9、输出 4，具体范围见下文。BRAM 已使用 98.61%，后续扩展的容量余量较小。

产物位于 `D:/vision/submission/_build/v25/artifacts/`：`capture.bit`（13198397 字节）、`capture.xsa`（5886039 字节）、`capture.ltx`（139492 字节）。XSA ZIP 完整性检查通过，内嵌位流 SHA256 与独立 `capture.bit` 一致。完整哈希及状态见 `result.json`。

本目录保留创建/构建主日志、73 份独立运行日志、资源/时序/DRC/CDC/bus-skew/IO/methodology 报告和 IP 状态。`input_sha256.json` 的 825 个输入文件在构建后逐一重算，全部一致。本验证不包含板卡下载、Flash 写入或硬件功能实测。

## 复现入口

从仓库根目录执行（输出目录必须不存在，且应有足够剩余空间）：

```powershell
./build/scripts/build_hardware.ps1 -Vivado 'D:/tool/vivado/2025.2/Vivado/bin/vivado.bat' -BuildDirectory 'D:/vision/submission/_build/fresh_visual_amplifier'
```

工具路径可替换为本机的 Vivado 2025.2 安装路径。创建过程从 `src/rtl`、`src/ip`、`src/constraints` 和 `src/bd` 读取输入；不会打开历史 `b18hw`，也不依赖历史增量布局检查点。

## 本轮适配

- 将原独立构建入口的路径调整到提交目录结构。
- 目标器件保持 `xc7z100ffg900-2`。
- Block Design 的 MIPI CSI-2 RX Subsystem 从 5.1 改为 2025.2 已安装的 6.0。原通道数、RAW10 格式、速率、缓冲和 AXI 地址配置继续交由 2025.2 检查。
- HLS 导出 RTL 中的厂商子 IP 会由 Vivado 在生成输出产品时升级，例如 Floating-point 7.1 的 revision 13 到 revision 21；生成结果只写构建目录。
- 保留原有 alpha50 导出 RTL 一致性检查、按键同步与引脚检查、单显示时钟检查，以及实现后的时序、CDC、bus-skew、DRC 门槛。

## 验证边界

此流程使用已整理的 HLS 导出 IP，不等于从 HLS C++ 重新综合全部 IP。有关原始 HLS 源码对应关系见 `../../../report/hls_provenance.md`。

2025.2 会重新生成厂商 IP，即使位流编译成功，也需要用同版本导出的 XSA 和固件进行整机复测，才能说明摄像头、HDMI、触屏和启动行为在实板上一致。历史 2021.2 的实测证据不自动变成 2025.2 实测结论。

原设计在 BD 校验阶段出现 HDMI 复位域以及 AXI interconnect 内部 MAX_BURST_LENGTH 元数据相关 Critical Warning。本轮保留原连接并记录提示，不通过屏蔽必要约束或关闭物理检查来获取成功结论。

## CSI 升级的静态核对

比较旧 XSA 和新 HWH：PS 的全部参数，以及 motion、roi、spec_fft、VDMA 的参数一致。CSI 寄存器总窗口仍为 `0x44a00000–0x44a01fff`，其中 RX 偏移为 `0`，DPHY 偏移为 `0x1000`。真实嵌套 DPHY 的速率仍为 400 Mbps、双通道、FIXED、IDELAY 初值 1；详见 `hwh_parameter_comparison.json`。

旧 BSP 的 CSI v1.5 与 2025.2 驱动 CSI v1.8 中已有寄存器 offset/mask 一致；新驱动新增 `XCSI_VC_SEL_OFFSET=0x2c`。本工程 `src/ps/main.c` 原本就向该地址写 1，在新核中表示选择 VC0；实板仍需确认摄像头虚拟通道。DPHY v1.5/v1.8 的寄存器宏保持一致。

2025.2 附带 DPHY changelog 记录过 7 系列校准逻辑修正，因此固定 tap8、运行时 HS_SETTLE147、冷启动/反复启停、首帧与 CRC/ECC/FIFO/丢帧计数属于升级后的实板回归范围。静态兼容不替代上述测试。

## 许可检查范围

IP 状态报告的 CSI6.0 `New License` 列为 `Included`，没有发现 Evaluation、Design Linking 或 Locked 提示；CSI RX 和 DPHY 子核综合已获取 Synthesis/xc7z100 许可。最终 `write_bitstream` 已取得 Implementation/xc7z100 许可并成功完成，未出现授权阻断。该步骤报告 0 Warning、0 Critical Warning、0 Error。

## 保留的提示

BD 创建时仍有原拓扑相关提示：HDMI 复位的关联时钟声明，以及三个 AXI interconnect 连接的 MAX_BURST_LENGTH 元数据 16/256 不一致，原文保留在 `result.json` 和创建日志。最终实现阶段没有对应 DRC Error/Critical Warning。综合报告的厂商 FIFO 未驱动网线 NDRV 项已由正常 `opt_design` 清理。

最终报告也保留普通 Warning：CDC-6 和 CDC-15 各 6 项；methodology 的 PDRC-190 两项、TIMING-9 一项、TIMING-18 八项、XDCB-5 一项。它们及 DSP/BRAM 等普通 DRC 提示均未被屏蔽；本报告不将“通过既有检查门槛”表述为“没有任何警告”。

## 原设计的外部 I/O 约束边界

本轮保留原设计约束。历史 2021.2 最终报告有 `no_input_delay=9`、`no_output_delay=4`；本轮最终实际计数见 `result.json` 和 `routed_timing.txt`。差分通道的统计数与物理 P/N 引脚数不同。

| 接口 | 原约束及本次验证边界 |
| --- | --- |
| MIPI LP 六根状态输入 | PHY 同步器入口使用 false path；自定义监测分支是 `lp_meta`、`lp_sync` 两级 `ASYNC_REG`。这些异步状态应按 CDC 和实际 LP 行为验证。 |
| KEY0 异步按键 | 两级同步，仅外部输入到第一拍设 false path；构建检查引脚 Y22 和同步属性。 |
| MIPI HS 两组差分数据输入 | PHY XDC 定义 5 ns 接收时钟，但未定义外部数据输入窗口。HS pad → IBUFDS → IDELAY → ISERDES 的板外采样裕量不能由内部正 WNS 证明。 |
| HDMI 四组 TMDS 差分输出 | 内部 pixel/serial 时钟的 MMCM、BUFIO、BUFR 关系受检查，但没有外部 `set_output_delay`；TMDS 眼图、抖动及通道偏斜不在内部 STA 结论内。 |

实际加入的是 `src/constraints/camera_amd.xdc`，没有加入含旧输入窗口的 `camera.xdc`。MIPI PHY 使用 FIXED 模式；原约束文件中 “runtime-calibrated” 注释不等于已验证自动校准。UART 经 PS EMIO、SCCB 经桥接到 PS，它们不属于上述 MIPI/TMDS 无延迟路径清单；这也不代表这些外设已通过本轮实板测试。没有为了减少上述计数而臆造板级延迟或放松检查。

## 可比的历史基线

v19 实际复用 v18 的 2021.2 位流，未重新布局布线；两个 `capture.bit` 的 SHA256 都是 `9836f502522085ff01fde7f3194b2dfe9491ffe7e30447ca391e50e4363cc134`。v18 最终资源和时序报告的哈希也与 v19 封存清单一致。下列数值仅作历史比较，不代表本次 2025.2 验证结果。

| 指标 | 历史 2021.2 最终实现 |
| --- | ---: |
| WNS / TNS | +0.008 / 0.000 ns |
| WHS / THS | +0.023 / 0.000 ns |
| WPWS | +0.264 ns |
| LUT / FF | 136531 / 202922 |
| BRAM / DSP | 743.5 tiles / 826 |
