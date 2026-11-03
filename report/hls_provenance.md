# HLS 源码、导出 IP 与验证边界

整理日期：2026-10-30。目标器件：`xc7z100ffg900-2`。

**后续验证入口（2026-11-03）：** 已从公开基线冻结源码，实际完成五个 IP 的 C 仿真、生产综合/导出和声明接口比对。新增结果、RTL 覆盖范围、候选实现状态和完整证据见 [HLS 重生成与验证](hls_regeneration_20261103/README.md)，新目录重建步骤见 [复现说明](hls_regeneration_20261103/REPRODUCE.md)。下文保留 10 月 30 日的来源核对与当时状态；仓库主工程仍使用原封存 IP。

本报告说明已找到并整理的源码，不把源码收集、历史 C 仿真和本次 Vivado 构建等同于从 C++ 完整重生成 IP 的证明。原工程保持只读。

## 已收集的来源

| 封存 IP | 已收集源码 | 版本依据 |
| --- | --- | --- |
| `motion60_shared` | `src/hls/motion60_shared/pipeline.cpp`、`phase_core.cpp`、`phase_core.hpp` | 从 `vision/v16alpha50/hls/motion60_shared` 复制；三份源与 `vision/alpha50_probe/hls` 逐字节一致。当前源包含 alpha≤50。 |
| `clip_copy_checked` | 同目录的 `clip_copy_checked.cpp` 及测试 | 从 `vision/ab12` 复制；v19 的该导出 IP 与 ab12 全部 35 个文件一致。 |
| `motion60_full_temporal_v2` | 同目录的 `clip_temporal_v2.cpp`、`test_temporal_v2.cpp` 和其包含的 `test_temporal.cpp` | 已有构建脚本 `build_motion60_full_temporal_v2.tcl` 明确以 `clip_temporal_v2.cpp` 生成顶层 `clip_temporal_full`。未把旧 `clip_temporal_full.cpp` 冒充 v2 源。 |
| `roi256_v3` | `src/hls/roi256/` 与 `spectrum256/tables.hpp` | `ab12/scripts/build_roi256.tcl` 指向该源和 ROI v3 输出目录；生成参考数据的 Python 模型一并收集。 |
| `spectrum256_pl` | `src/hls/spectrum256_pl/` 与 `src/hls/spectrum256/` | 已有构建脚本包含 PL 源、频谱参考源与比较测试；查表常量随源保留。 |

在原目录执行的全文件 SHA-256 比较确认：v19boot 与 v16alpha50 对应 IP 的全部文件一致，分别为 `motion60_shared` 444/444、`clip_copy_checked` 35/35、`motion60_full_temporal_v2` 104/104、`roi256_v3` 92/92、`spectrum256_pl` 96/96。真实的 `phase_core_shared_1.v` 等实例模块计入比较，未按 `_1` 后缀误删。

`motion60_full_temporal_v2`、`roi256_v3`、`spectrum256_pl` 的 v19 与 ab12 比较中，差异只出现在浮点子 IP 的 `.xci` 配置；对应生成 HDL 未发现差异。该结果支持沿用关系，但不能证明任意 HLS 工具版本重生成后的数值、接口和时序都相同。

## alpha50 是有记录的导出 RTL 修补

已有 `alpha50_probe/scripts/prepare_candidate.py` 和 `v16alpha50/scripts/prepare_gate_eco_2021.tcl` 记录了以下过程：

1. 将已通过 2021.2 C 仿真的 alpha50 C++ 收入 v16 候选。
2. 保留已有运算、FIFO、接口和调度，仅把四个生成 Verilog 中的比较常量由 30 改为 50。
3. 使用已有 Vivado 2021.2 工程完成当时的后续实现。

修补记录为 [gate_only_patch.json](../src/hls/provenance/alpha50/gate_only_patch.json)。本次核对四个源目录 Verilog 的 SHA-256，全部与其中的 `after_sha256` 相符。

历史 [C 仿真日志](../src/hls/provenance/alpha50/csim_2021.stdout.log) 包含 `ALPHA50_CSIM_PASSED`。其测试覆盖 alpha30 的相位输出/历史状态对照、alpha0/30/50 数值重建、非法值拒绝和 128×96 管线测试。它不是全尺寸 RTL 协同仿真、当前工具版本验证或实际物理放大倍数证明。

## 工具版本的含义

原硬件工程使用 Vivado 2021.2；五个自定义 HLS IP 的 `component.xml` 记录 `xilinxVersion=2025.2.1`。这些标记与上面的历史 C 仿真及手工常量修补应分别保留。

本次要求的 Vivado 2025.2 构建使用仓库内已导出的 IP；最终是否通过以本次 Vivado 构建日志和报告为准。它不会自动证明 HLS C++ 可以在 2025.2 环境下重新导出完全等价的 IP。

## 此次整理已完成的检查

- 34 份复制文件 SHA-256 与来源一致，复制清单由仓库总清单收录。
- C++ 的项目内双引号包含文件已全部找到；AMD HLS 头文件由工具安装提供。
- 可选 `build_hls.tcl` 已进行 Tcl 语法完整性检查，Python 脚本已通过 AST 解析。
- 迁移后的 ROI 参考数据生成器已运行，其四帧输入和黄金输出与原生成器结果逐字节相同。
- 检查摘要位于 [collection_validation.json](../src/hls/provenance/collection_validation.json)。

## 当时尚未完成的环节（2026-10-30）

1. 在明确版本的 Vitis HLS 环境执行收集后的 C 测试、综合、导出和必要的 RTL 协同仿真。
2. 对重生成 IP 与本次封存 IP 比较寄存器接口、浮点配置、数值误差、资源和延迟；检查 FIFO 导出后处理是否仍适用。
3. 若用重生成 IP 替换封存 IP，重新完成 Vivado 物理检查和整机验证，并保存新的版本/哈希绑定。

这些条目记录 10 月 30 日的待验证状态；后续实际执行结果以本页开头链接的新报告为准。已有导出 IP、对应源、测试和历史证据均继续保留。
