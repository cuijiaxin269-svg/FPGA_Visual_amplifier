# 已有测试数据

`inputs/multitone/` 原样收录原工程 `board_checks/20261029_multitone_01/mix_01/` 的 49 个小文件，包括频谱采样、前后状态、时间戳、物理设置和分析记录。

这些是历史多频输入测试的证据。其具体条件以 `physical_setup.json` 和 `multitone_report.json` 为准，不能称为本次 2025.2 新硬件的实测输出。频谱 UI 回归使用 `spectrum_00_values.bin`，已有测试会从原始记录读取所需字段。

后续同输入、同参数、同帧号的黄金参考与 HLS C 模型对比见 [v19 量化记录](../board/results/v19_acceptance_20261103/README.md)。其中 C 模型输出与板端频谱采样分别标注来源，历史分析记录保留原文。
