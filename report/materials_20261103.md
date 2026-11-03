# 2026-11-03 资料补充与版本边界

本次只整理原版项目的配套资料。工程源码、封存 IP、BD、约束、固件、构建及仿真入口均保持公开基线 `a9ab041021c269b446be4e5aa00ae3141f01ec8d`；后续算法改进、方形选区工程与其调试产物不在本次发布中。

## 阅读与下载

| 内容 | 仓库入口 | 完整附件 |
|---|---|---|
| 串口屏 HMI/TFT、交接与检查 | [屏端资料](../board/hmi/README.md) | [原 ZIP](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/materials-20261103/hmi_project_20261101.zip) |
| 芯片 BOM、供电链路、拨码照片 | [硬件资料](../board/hardware/README.md) | [原 7z](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/materials-20261103/hardware_documents_20261103.7z) |
| v19 实板验收与软件黄金参考 | [验收范围和原始记录](../board/results/v19_acceptance_20261103/README.md) | [完整验收包](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/materials-20261103/v19_acceptance_20261103.7z) |
| 24 页设计报告与 LaTeX 工程 | [报告 PDF](design_report/report_competition_review.pdf)、[发布说明](design_report/PUBLICATION_NOTE.md) | [报告源码包](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/materials-20261103/design_report_latex_20261101.zip) |

附件大小与 SHA-256 见 [release_assets.json](release_assets.json)；发布页提供 `SHA256SUMS.txt`。仓库可读文件的逐项校验在 [file_manifest.json](file_manifest.json)，运行 `python build/scripts/verify_package.py` 可检查。

## 证据应如何对应

- **v19 / 2021.2 原版实板**：本次包支持 3 次真实冷启动、实体 KEY0 两次、STOP 与用户确认的触屏/HDMI/频谱效果。稳定性采样中有调参、两次 JTAG 中断，不能标为 60 分钟连续固定参数验收通过。约 60.3796 FPS 是首尾处理计数的平均速率，跨度含观测空档，不能替代端到端延迟或画面逐帧测量。
- **2025.2 原版重新构建**：沿用已有 71 IP、实现、BIT/XSA/BOOT 静态检查证据；新 v19 包不能转记为这套新产物的整机实测。两套启动文件不可混用。
- **量化对比**：已有同输入、参数、帧号的独立黄金参考与 HLS C 模型输出/误差；这些是软件结果，仍缺实板 FPGA 像素闭环、端到端延迟和实际位移放大倍率。

报告 PDF 为 2026-11-01 既有稿，原文未纳入本次补充，归档不等于作者最终审定。视频将重新制作，HLS 第 6 项等待单独处理；按用户最新要求，两项均不纳入本次发布。串口屏编辑器版本、完整硬件接线细节、原始 AI 完整对话、项目 LICENSE/署名与第三方许可核对仍待补齐，详见 [缺项表](submission_gaps.md)。

历史日志的本地路径、未上传字段、待办和失败记录保留产生时的含义；本次通过外围说明更新状态，不倒改原始证据。原验收完整清单覆盖 Release 完整包，仓库轻量副本的省略项见其 README。
