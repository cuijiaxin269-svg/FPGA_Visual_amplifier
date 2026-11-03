# 重生成候选的 Vivado 时序验收

2026-11-04 00:45（UTC+08:00），五个公开基线重生成候选在隔离工程 `v26c02` 中的**最终 routed 报告通过既有验收门槛**。工具为 Vivado 2025.2，器件为 `xc7z100ffg900-2`。普通警告、外部接口约束边界和报告展示限制均保留；本记录不等于新候选上板通过。

## 实际时序与资源

数据来自本次完成的 [routed_timing.txt](routed_timing.txt)，设计状态为 `Physopt postRoute`。

| 范围 | WNS/ns | TNS/ns | WHS/ns | THS/ns | WPWS/ns | TPWS/ns |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 全设计 | +0.177 | 0 | +0.010 | 0 | +0.264 | 0 |
| FCLK1 | +0.177 | 0 | +0.010 | 0 | +2.565 | 0 |

setup、hold、pulse-width 的失败端点均为 0。原目标 **150 MHz** 未放宽；Clock Summary 沿用原约束显示 `6.666 ns / 150.015 MHz`，这是报告精度下的表示，不是新的实测频率或频率精度结论。`no_clock`、`generated_clocks`、`unconstrained_internal_endpoints` 等十项检查均为 0。

[最终利用率](routed_utilization.txt)：LUT 138026/277400（49.76%）、FF 206397/554800（37.20%）、BRAM 744.5/755（98.61%）、DSP 826/2020（40.89%）。BRAM 余量较小。

## 保留的警告与检查范围

- **DRC**：Error 0、Critical Warning 0；2056 条普通 Warning、917 条 Advisory。与公开基线比较，2972/2973 条已展示详情在精确对应已审核的 temporal 标识符命名后相同。RTSTAT-10 都报告 956 个无可布线负载 net、633 个 listed nets/buses，但只展示前 15 项，当前这 15 项与旧不同；不宣称全部端点相同。REQP-1839/1840 各在 20 项截断。
- **CDC**：[报告](routed_cdc.txt) 的 152 条显示记录按时钟、深度、例外和端点完整比较，与基线一致。Critical 0；CDC-6 与 CDC-15 各 6 条 Warning。加密 CSI PHY 和 VIO 的隐藏路径仍受工具显示范围限制。
- **bus skew**：42 条约束全部 MET，最小裕量 **6.019 ns**，最大 39.899 ns；逐条 requirement、actual、slack 已检查，完整正文与基线一致。
- **methodology**：[新鲜报告](methodology_standalone_qspi2025_2.txt) 无 Error/Critical Warning；保留 PDRC-190 两项、TIMING-9 一项、TIMING-18 八项、XDCB-5 一项 Warning，详情除本地工程路径外与旧一致。
- **外部延迟**：`no_input_delay=9`、`no_output_delay=4` 与基线一致，涉及既有 MIPI 输入、KEY0 异步入口和四组 TMDS 输出。未为减少计数而填入虚构外部延迟；内部 STA 不证明接口眼图、抖动或板级信号完整性。

[时钟来源 gate](clock_source_gate_standalone_qspi2025_2.txt) 实际通过：一个显示 MMCM，74.25 MHz pixel、371.25 MHz serial，均追溯到 100 MHz FCLK0。实际日志及 I/O 报告同时确认 HMI TX=AH12、RX=AG12、KEY0=Y22，均为 LVCMOS33；两级 KEY0 同步器、16 级 pixel reset guard、6 个摄像头 HS 端口及 `DIFF_TERM=false` 检查已执行通过。

## 原始证据与交付状态

[独立审核报告](routed_reports_audit_01.md)和[机器可读审核](routed_reports_audit_01.json)保留完整检查结果、42 条偏斜数值、CDC 显示端点、原报告 SHA-256 及实际 gate 日志行。本目录 7 份原始报告/审核文件逐字节复制，原来源、大小与 SHA-256 见 [selection_manifest.json](selection_manifest.json)。历史对照文件已核实属于公开提交 `a9ab041021c269b446be4e5aa00ae3141f01ec8d`。

完整 `routed_drc.txt`、`routed_bus_skew.txt`、`routed_io.txt`、审核脚本和执行日志放入[独立时序证据 ZIP](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/hls-validation-20261103/timing_validation_evidence_20261103.zip)，不在本目录伪造副本。ZIP 共 192,972,631 字节，SHA-256 `6c1f60d40dec6433d35a641bdc9db1389a5c466f709b0aeb5ca19f102269e3f2`；包含最终 `capture_wrapper_postroute_physopt.dcp`。1709 个成员的 CRC、SHA 和归档输入稳定性检查通过，见[归档回执](../deliverables/timing_validation_evidence_20261103.receipt.json)。

审核冻结时执行器仍在运行；之后整轮构建于 **2026-11-04 00:58:19（UTC+08:00）正常完成，退出码 0**。最终[执行审计](execution_audit_02.json)与[产物校验汇总](delivery_validation.json)确认源文件、复用检查点、三份产物哈希和 XSA 内嵌位流一致。XSA 的五项封装修订号及一项文档路径差异已[逐项审核](artifact_configuration_review_01.json)，时间戳另列，未发现参数、端口、总线、地址或连接配置差异。原始 `needs_review` 和首份执行审计的检查条件误判保留在完整 ZIP 中，后续审核另写，不回改历史回执。原始审核及选择清单保留各自记录时的状态。新候选尚未上板；本次时序通过不补足 [HLS 总结](../README.md) 中 ROI 正常帧及 motion 全帧 RTL 仿真的资源限制缺口，也不重新否定既有系统已有的实板材料。

本地生成的 BIT/XSA/LTX 大小和 SHA-256 见[交付校验汇总](delivery_validation.json)；本次 Release 提供候选与证据，未把这些产物包装为已经上板验收的启动镜像。最后交付证据的原样复制清单见 [delivery_selection_manifest.json](delivery_selection_manifest.json)。
