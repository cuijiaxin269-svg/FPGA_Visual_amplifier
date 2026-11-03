# 收录范围

本次以 v19boot 的有效源码、依赖和必要历史证据为中心整理，没有批量删除原工程文件。

以下内容继续保留在原工程，不放入当前源码提交副本：

- `b12hw` 至 `b19boot` 等 Vivado 工作目录、`.Xil`、`.runs`、`.cache`、`.gen` 和大量中间 DCP。
- 旧交接 ZIP、RAW 数据压缩包、历史录像全集和重复交付包。
- `vision/tmp/python_deps` 等临时依赖安装目录。
- 未被最终工程引用的早期试验版本。与当前版本来源、优化或失败经验相关的材料已精选保存。
- 全量 Flash 恢复备份继续在原工程保存，当前发布附件收录成套旧固件及其核验记录。

`src/ip/` 中由 HLS 生成、但当前独立重建确实需要的 HDL 和配置属于有效构建输入，已保留。真实模块名中的 `_1` 不当作重复文件删除。

`sim/reference_model/` 是已有摄像头成像与微振分析的 Python 仿真源码，仅作为算法可行性参考；本轮没有额外运行该模型，也不将它的结论作为 2025.2 硬件实测。

`report/original_notes`、`report/original_scripts` 和历史结果保留原文，因此可能含旧绝对路径。当前构建入口单独置于 `build/scripts`、`sim/scripts`，旧路径仅作来源记录。

## 2026-11-03 文档与冗余验证文件清理

作者确认除 HLS 验证、视频、AI 协作记录外，其他交付内容均已完成。本次同步项目介绍和维护文档，移除过时待办；当前清单见 [submission_gaps.md](submission_gaps.md)。

本轮从工作树移出 43 个文件，合计 1,662,029 字节：

| 类别 | 数量 | 保留入口 |
|---|---:|---|
| 旧 final_report 与五份 progress_report 的阶段快照 | 18 | [final_report_v2](../board/results/v19_acceptance_20261103/final_report_v2/) |
| 空日志 | 14 | 同次运行的有效记录继续保留 |
| 与 metrics.json 逐字节相同的分析日志 | 4 | 对应分析目录的 metrics.json |
| session 子目录中与顶层 tools 相同的脚本副本 | 4 | [验收工具](../board/results/v19_acceptance_20261103/tools/) |
| 包含旧进程、会话及未结束采样指令的交接说明 | 2 | [当前验收资料入口](../board/results/v19_acceptance_20261103/README.md) |
| 10 月 31 日旧 Git 上传清单检查收据 | 1 | 当前 [文件清单](file_manifest.json) 与 [包检查](package_verification.json) |

前 42 个文件仍包含在[完整 v19 原始附件](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/materials-20261103/v19_acceptance_20261103.7z)。旧 Git 收据保留在[清理前提交](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/blob/723c3601f4cfeb4a4bd4676faf0421125025e17f/report/git_upload_check.json)。本地也保留了移出文件及哈希清单。

2033 个带时间点意义的原始运行代码/寄存器读回仍保留；相同字节不意味着不同时间的观测无用。功能测试、算法代码、固件、封存 IP、BD、约束及构建执行脚本均未修改。报告 PDF、LaTeX 正文和原始实测结论也未改写。
