# 2026-11-03 HLS 重生成与验证

本次从公开提交 [`a9ab041021c269b446be4e5aa00ae3141f01ec8d`](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/tree/a9ab041021c269b446be4e5aa00ae3141f01ec8d) 冻结源码，已完成 **5 个 IP 的 C 仿真、生产配置综合/导出及声明接口比对**。RTL 联合仿真的实际覆盖见下表；当前不能将全部五项功能验证记为通过。

候选均来自该公开基线。基线已有的 `roi256` 和 alpha50 路线包含在验证中，尚未跑通的后续算法改进、方形选区改动没有加入本次候选或发布材料。仓库中的封存 IP 保持原样，本目录仅增加证据。

## 固定输入与结果

- Vitis HLS 2025.2，build 6295257，clang-16，Vivado flow。
- 器件 `xc7z100ffg900-2`；生产 HLS 时钟约束 `6.666667 ns`，约 150 MHz。
- [源码清单](source_manifest.json) 固定 40 份文件；生产 C++ 未改。外部运行入口修正了本机 include 路径引号问题，差异及复现步骤保存在完整证据包中。
- 本次 RTL 路线为 Verilog / XSim。接口匹配和 HDL 文件比对不等于形式等价、任意输入数值等价或布局布线时序通过。

| IP / 实际 top | C 仿真、生产综合/导出、声明接口 | 实际 RTL 联合仿真结论 |
| --- | --- | --- |
| `clip_copy_checked` | 均完成 | G0 与 P2…P10 共 10 个独立通过进程、21 次调用，覆盖原 12 个案例及 11 个相邻关系；完整生产 AXI 深度。不能证明连续 12 调用不中断执行。 |
| `spectrum256_pl` | 均完成 | 原测试范围 311/311 事务通过，保留原 exact-float 检查。 |
| `roi256` | 均完成 | LOW、RANGE 两个拒绝分支通过。正常帧 P1 在最后记录 0/2 进度时被资源守卫终止；P2/P3/GAP/BOUND 未运行，正常 FFT/位移路径未取得 RTL 通过结果。 |
| `motion60_full_temporal_v2` / `clip_temporal_full` | 均完成 | G0…G3 共 11 调用通过。测试深度 15360，70 份综合 HDL 与生产相同；不验证生产深度 122880000 的完整内存范围或连续 11 调用。 |
| `motion60_shared` | 均完成 | 1280×800、alpha50/mode0 的 cold 单调用在最后记录 0/1 进度时被资源守卫终止；warm 未运行，没有完整帧 RTL 通过结果。 |

完整冻结结果为 [results.json](results.json)，精简索引为 [rtl_coverage_summary.json](rtl_coverage_summary.json)。本目录包含实际运行回执和对应 co-sim 报告，包括失败结果；原日志、C 审核、后置哈希合同、测试及参考数据保存在完整证据包中。准备成功、C 前处理标记和后置哈希一致均不单独计为 RTL Pass。

另有 [motion 全尺寸 C 仿真回执](receipts/motion_fullsize_csim_01.json)：1280×800、mode0，alpha0/30/50 各两帧，以及 6 个非法参数拒绝调用通过。这是 C 层测试，不能替代上述缺少的完整帧 RTL 结果。ROI/motion 的中止由整机可用提交内存触发，未观察到数值不符；资源中止也不能反向证明数值正确。原阈值和断言未为求通过而放宽。

## 候选封装与后续实现

五个候选的逐包 SHA-256 见 [候选 manifest](deliverables/five_ip_candidates_20261103.manifest.json)，封装完整性见 [实际收据](receipts/five_ip_candidate_bundle_01.json)。motion 新导出已包含源码中的 alpha50；候选另保留 Verilog FIFO 的两处地址寄存器 `DONT_TOUCH` 后处理并刷新元数据校验和。原导出包和封存 IP 没有被覆盖。

motion 封装状态是 **带警告候选**：完整性检查通过，但保留 9 条 Critical Warning、31 条 Warning、0 条 Error，详见 [诊断审核](comparisons/motion_candidate_warning_review.json)。这些封装诊断与实现 DRC 分开记录。语言视图保留；本次不宣称 VHDL FIFO 或功能验证通过。

**Vivado 最终 routed 报告已通过验收，保留原有普通警告与报告范围限制。** 五个候选在隔离的 Vivado 2025.2 工程中完成本阶段检查：全局 WNS `+0.177 ns`、WHS `+0.010 ns`，TNS/THS 为 0；42 条 bus skew 约束全部满足。详细时序、DRC、CDC、时钟/引脚检查和原始证据见[时序验收记录](timing/README.md)。整轮构建于 2026-11-04 00:58:19（UTC+08:00）正常完成；BIT/XSA/LTX 的哈希、XSA CRC 与内嵌位流、器件/时钟/地址配置已独立核验，封装元数据差异另有审核，见[交付校验](timing/delivery_validation.json)。

本次新候选尚未进行上板验收。既有系统的展示、HMI 和实板材料沿用参赛材料中的版本及作者确认；这里的待验证范围只针对新生成候选，不重新定义既有系统的完成状态。

## 完整证据与下载

完整证据与候选通过独立 [Release](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/tag/hls-validation-20261103) 提供；大 ZIP 不加入 Git 源码目录。文件清单见 [release_assets.json](deliverables/release_assets.json)，校验值见 [SHA256SUMS.txt](deliverables/SHA256SUMS.txt)。

| 资产 | 字节数 | SHA-256 |
| --- | ---: | --- |
| [初始 HLS 完整证据 ZIP](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/hls-validation-20261103/hls_regeneration_evidence_20261103.zip) | 36,069,995 | `1517b58043683e6e360c38ef32b02e4fc1a216e88f3add1fb91e745cab53722a` |
| [五个候选 IP ZIP](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/hls-validation-20261103/five_ip_candidates_20261103.zip) | 51,650,930 | `73e250fbd0e809b92b06d6cb3bf61cbb4b7446c8a445ed2f43c054a3f3ddf2c3` |
| [完整时序证据与最终检查点 ZIP](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/hls-validation-20261103/timing_validation_evidence_20261103.zip) | 192,972,631 | `6c1f60d40dec6433d35a641bdc9db1389a5c466f709b0aeb5ca19f102269e3f2` |

初始证据 ZIP 已完成 CRC、重新解压后的逐文件 SHA-256 和源码清单核对，见 [归档校验收据](deliverables/hls_regeneration_evidence_20261103.verification.json)；它只证明归档完整性。五项重建步骤见该 ZIP 中的 `tools/reproduce_five_ip.md`。初始 HLS 轻量原始证据共 70 份，逐文件来源与 SHA-256 见 [selection_manifest.json](selection_manifest.json)。后续时序证据另见 [timing/selection_manifest.json](timing/selection_manifest.json)；完整大报告及最终实现检查点收录于[独立时序证据 ZIP](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/hls-validation-20261103/timing_validation_evidence_20261103.zip)。该 ZIP 的 1709 个成员已通过 CRC、逐成员 SHA 和输入前后稳定性核验，见[归档回执](deliverables/timing_validation_evidence_20261103.receipt.json)。

原始 JSON、候选 manifest 及 ZIP 内 README 保留生成当时的状态，包括 `github_uploaded=false`、时序未完成等字段；它们不会因后续发布而回写。`results.json` 的冻结时间为 2026-11-03 19:48:56（UTC+08:00）。后续时序验收与上传状态以本页和新增报告为准，历史失败与验证边界继续保留。
