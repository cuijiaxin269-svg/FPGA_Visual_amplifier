# 已有测试数据

`inputs/multitone/` 原样收录原工程 `board_checks/20261029_multitone_01/mix_01/` 的 49 个小文件，包括频谱采样、前后状态、时间戳、物理设置和分析记录。

这些是历史多频输入测试的证据。其具体条件以 `physical_setup.json` 和 `multitone_report.json` 为准，不能称为本次 2025.2 新硬件的实测输出。频谱 UI 回归使用 `spectrum_00_values.bin`，已有测试会从原始记录读取所需字段。

尚需针对最终提交版本整理统一的输入、黄金参考、实际输出和误差判据；历史数据目录内的既有分析记录保留原文。
