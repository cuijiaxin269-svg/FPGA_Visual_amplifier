# 2026-11-03 资料补充与版本边界

本次只整理原版项目的配套资料。工程源码、封存 IP、BD、约束、固件、构建及仿真入口均保持公开基线 `a9ab041021c269b446be4e5aa00ae3141f01ec8d`；后续算法改进、方形选区工程与其调试产物不在本次发布中。

## 阅读与下载

| 内容 | 仓库入口 | 完整附件 |
|---|---|---|
| 串口屏 HMI/TFT、交接与检查 | [屏端资料](../board/hmi/README.md) | [原 ZIP](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/materials-20261103/hmi_project_20261101.zip) |
| 芯片 BOM、供电链路、拨码照片 | [硬件资料](../board/hardware/README.md) | [原 7z](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/materials-20261103/hardware_documents_20261103.7z) |
| v19 实板验收与软件黄金参考 | [验收范围和原始记录](../board/results/v19_acceptance_20261103/README.md) | [完整验收包](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/materials-20261103/v19_acceptance_20261103.7z) |
| 26 页设计报告与 LaTeX 工程 | [报告 PDF](design_report/report_competition_review.pdf)、[发布说明](design_report/PUBLICATION_NOTE.md) | [报告源码包](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/materials-20261103/design_report_latex_20261103.zip) |
| 作品演示视频 | [文件信息](../media/README.md) | [完整视频](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/materials-20261103/demo_complete_20261103.mp4) |
| 作者 AI 协作记录 | [本人协作摘要](ai_logs/author_collaboration_summary_20261103.md) | [记录目录](ai_logs/README.md) |

附件大小与 SHA-256 见 [release_assets.json](release_assets.json)；发布页提供 `SHA256SUMS.txt`。仓库可读文件的逐项校验在 [file_manifest.json](file_manifest.json)，运行 `python build/scripts/verify_package.py` 可检查。

## 证据应如何对应

- **v19 / 2021.2 原版实板**：本次包支持 3 次真实冷启动、实体 KEY0 两次、STOP 与用户确认的触屏/HDMI/频谱效果。稳定性采样中有调参、两次 JTAG 中断，不能标为 60 分钟连续固定参数验收通过。约 60.3796 FPS 是首尾处理计数的平均速率，跨度含观测空档，不能替代端到端延迟或画面逐帧测量。
- **2025.2 原版重新构建**：沿用已有 71 IP、实现、BIT/XSA/BOOT 静态检查证据；新 v19 包不能转记为这套新产物的整机实测。两套启动文件不可混用。
- **量化对比**：已有同输入、参数、帧号的独立黄金参考与 HLS C 模型输出/误差；这些是软件结果，数值范围不包含实板逐像素比较、端到端延迟或实际位移倍率。

作者于 2026-11-03 最新确认整套系统已上板、可以正常使用，视频和本人 AI 协作摘要已补充归档，当前仅剩 **HLS 验证结果整理与归档**，其他交付内容已完成，见[当前清单](submission_gaps.md)。报告 PDF 与 LaTeX 已修订为 26 页，纳入补充验收、C 模型误差和当前资料状态；原始测量记录保持不变。新版源码包标记为 `design_report_latex_20261103.zip`，旧 11 月 1 日附件保留供历史追溯。HLS 只在报告中记录已核实的阶段进度，新候选 IP 与完整验证附件仍等待单独整理。

历史日志的本地路径、未上传字段、待办和失败记录保留产生时的含义；本次通过外围说明更新状态，不倒改原始证据。原验收完整清单覆盖 Release 完整包，仓库轻量副本的省略项见其 README。
