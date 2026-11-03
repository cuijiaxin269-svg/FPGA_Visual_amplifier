# 串口屏工程与复现资料

2026-11-03 收入用户提供的串口屏资料。默认归档为 [archive_20261101](archive_20261101)，保留原文件名、原始说明和 SHA256 清单；7 个清单文件的哈希均已核对。完整原 ZIP 见[发布附件](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/materials-20261103/hmi_project_20261101.zip)。

| 文件 | 用途 |
|---|---|
| [motion60_control.HMI](archive_20261101/motion60_control.HMI) | 可编辑屏端源工程 |
| [motion60_control.tft](archive_20261101/motion60_control.tft) | 对应编译文件，4,518,152 字节 |
| [使用说明](archive_20261101/使用说明.md)、[接口交接](archive_20261101/docs/串口屏_FPGA_HDMI接口交接说明_20261029.md) | 页面、串口格式、下载与交接说明 |
| [verification.json](archive_20261101/verification.json)、[SHA256SUMS.txt](archive_20261101/SHA256SUMS.txt) | 原屏端编译/检查记录和完整性校验 |
| [amd_boot_final.HMI](source_variants/amd_boot_final.HMI) | 用户另供的源文件变体，未提供配套 TFT，功能版本及与默认工程的关系尚未核定 |

屏型号记录为 TJC1060X570_011C，1024×600；运行串口 115200、8N1。屏到板命令以 CR LF 结束，板到屏原生指令以三个 FF 字节结束。下载速率和运行速率应分别使用原说明的约定。

原交接说明描述的是 2026-10-25 旧固件，所述“VIEW 未实现、板端 alpha 上限 30”不代表本仓库 a9ab041 基线。基线板端已支持 VIEW 和 alpha≤50；归档文件保留原文，不把历史待办重复当成当前缺陷。该屏工程没有新增 MAGROI 方形选区协议。

作者已确认整套系统上板可正常使用；后续 v19 的[人工交互记录](../results/v19_acceptance_20261103/README.md)已归档。原 verification 的 `physical_touch_tested=false`、`controller_integrated=false` 属于屏工程独立检查时的历史状态。

复现默认工程时使用上表对应的 HMI/TFT；独立 `amd_boot_final.HMI` 作为源文件变体保留，不作为默认烧录文件。归档未记录编辑器精确版本，本机工具路径仅作来源信息。标识与字库沿用[现有许可状态](../../report/third_party.md)。
