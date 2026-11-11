# FPGA_Visual_amplifier

基于 OS-ZYNQ7100 开发板（主芯片 Zynq-7100 / `XC7Z100-2FFG900I`，Vivado 目标 `xc7z100ffg900-2`） 的区域相位运动放大与微振检测系统，包含 OV9281 图像采集、PL 图像处理与频谱分析、HDMI 1080p30 显示，以及 PS 裸机串口屏和实体按键交互。

## 方形选区版本

本分支增加串口控制的方形局部振动放大。框内显示运动放大结果，框外保留同帧原画。相机内容区为 1280×800，HDMI 输出时序为 1920×1080、30 Hz。

已在 Zynq 7100 上完成 QSPI 固化、重新上电启动，以及 COM8 控制的方框移动、改大小和 α 调节。JTAG 回读验证了框外像素与原画一致。使用步骤见[串口使用说明](report/方框振动放大串口使用说明.md)，实现与验证范围见[方形选区实现说明](report/square_roi_implementation.md)。

以下项目资料、演示视频和既有发布附件对应比赛提交版。源码以 `v19boot` 为整理起点，构建资料保留历史 2021.2 和 2025.2 的版本信息。

## 项目资料

| 内容 | 入口 |
|---|---|
| 设计报告（2026-11-04 事实复检版） | [26 页 PDF](report/design_report/report_competition_review.pdf)、[LaTeX 源码与说明](report/design_report/PUBLICATION_NOTE.md) |
| 串口屏 | [HMI/TFT 工程、页面及串口接口](board/hmi/README.md) |
| 硬件 | [芯片 BOM、供电和启动拨码照片](board/hardware/README.md)、[接线说明](board/wiring/README.md) |
| 实板与量化记录 | [v19 验收记录](board/results/v19_acceptance_20261103/README.md)、[证据索引](report/evidence_index.md) |
| 全部配套材料 | [资料索引](report/materials_20261103.md)、[完整资料包](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/tag/materials-20261103) |
| 演示视频 | [约 3 分钟完整视频及下载](media/README.md) |
| HLS 与 AI 记录 | [HLS 阶段结果](report/hls_regeneration_20261103/README.md)、[复现说明](report/hls_regeneration_20261103/REPRODUCE.md)、[来源说明](report/hls_provenance.md)、[AI 协作记录](report/ai_logs/README.md) |

历史记录保留各自的版本和测量条件。当前作者使用确认与原始实验数据分别记录，不将软件仿真输出当作实板像素输出，也不新增未经测量的延迟或位移倍率。

## 工程目录

| 目录 | 内容 |
|---|---|
| `src/rtl`、`src/ps` | RTL 与 PS 裸机程序 |
| `src/hls`、`src/ip` | HLS 源码与主工程使用的封存 IP |
| `src/bd`、`src/constraints` | BD Tcl、引脚及时序约束 |
| `build`、`sim` | 构建入口、功能测试、参考模型及已有结果 |
| `board`、`data` | 硬件/屏端资料、实板记录与输入测试数据 |
| `report`、`skill` | 报告、资料索引、协作记录及复用经验 |

## 环境与复现

方形选区版使用 Windows、AMD unified tools 2025.2 和 Python 3 构建。完整硬件构建包含 75 个 IP、综合、布局布线和 BIT/XSA/LTX 导出，WNS +0.091 ns、WHS +0.009 ns。主机测试使用 AMD 安装内附的 MinGW 工具链。

从仓库根目录执行以下命令，并将工具安装路径改为本机实际位置。输出放到仓库外的新目录：

```powershell
$repoRoot = (Get-Location).Path
$amdRoot = 'D:/tool/vivado/2025.2'
$vivado = "$amdRoot/Vivado/bin/vivado.bat"
$cxx = "$amdRoot/tps/mingw/10.0.0/win64.o/nt/bin/g++.exe"
$outputRoot = 'D:/vision/submission/_build/my_reproduction'
New-Item -ItemType Directory -Force $outputRoot | Out-Null
$env:TEMP = Join-Path $outputRoot 'tmp'
$env:TMP = $env:TEMP
New-Item -ItemType Directory -Force $env:TEMP | Out-Null

py -3 sim/scripts/run_host_tests.py --cxx $cxx --output "$outputRoot/host" --report-dir "$outputRoot/host/reports"
if ($LASTEXITCODE -ne 0) { throw 'Host tests failed; inspect the result receipt.' }
py -3 build/scripts/build_firmware.py --tool-root $amdRoot --output "$outputRoot/firmware" --report-dir "$outputRoot/firmware/reports"
if ($LASTEXITCODE -ne 0) { throw 'ARM firmware build failed; inspect the result receipt.' }
py -3 sim/scripts/run_spectrum_rtl.py --cxx $cxx --vivado-root "$amdRoot/Vivado" --output "$outputRoot/rtl_sim" --report-dir "$outputRoot/rtl_sim/reports"
if ($LASTEXITCODE -ne 0) { throw 'Spectrum RTL comparison failed; inspect the result receipt.' }
py -3 sim/scripts/run_roi_rtl.py --vivado-root "$amdRoot/Vivado" --output "$outputRoot/roi_sim"
if ($LASTEXITCODE -ne 0) { throw 'ROI RTL simulation failed; inspect the result receipt.' }

$env:FPGA_BUILD_JOBS = '1'
& "$repoRoot/build/scripts/build_hardware.ps1" -Vivado $vivado -BuildDirectory "$outputRoot/hardware"

py -3 build/scripts/build_boot.py --tool-root $amdRoot `
    --xsa "$outputRoot/hardware/artifacts/capture.xsa" `
    --bit "$outputRoot/hardware/artifacts/capture.bit" `
    --app "$outputRoot/firmware/motion60.elf" `
    --app-receipt "$outputRoot/firmware/reports/result.json" `
    --output "$outputRoot/boot"
if ($LASTEXITCODE -ne 0) { throw 'Boot package failed; inspect its reports/result.json.' }
```

构建与启动包说明见 [build/scripts/README.md](build/scripts/README.md)。上述命令生成文件和运行软件/RTL 测试，不执行烧录。不同版本的 BIT、XSA、初始化文件、ELF 和 BOOT 应成套使用。

主工程继续使用 `src/ip` 中的封存 IP，未替换为新候选。HLS 重生成的阶段结果、验证范围和最终实现状态见[专门记录](report/hls_regeneration_20261103/README.md)，独立工作目录中的复现步骤见[REPRODUCE](report/hls_regeneration_20261103/REPRODUCE.md)。新候选的正常 ROI 和 motion 全帧 RTL 仍待补验。

## 发布与文件校验

[GitHub Releases](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases) 提供成套构建产物和完整资料附件。2025.2 构建附件包含 BIT、XSA、LTX、应用/FSBL ELF、BOOT/BIF、初始化文件和 SHA-256 清单；资料补充附件包含串口屏、硬件、v19 验收及报告工程。

当前仓库文件清单可运行 `python build/scripts/verify_package.py` 核对；完整附件按发布页的 `SHA256SUMS.txt` 校验。重复阶段报告和失效交接等材料仅在完整附件或历史提交中保留，具体见[收录范围](report/excluded_files.md)。

版权和来源说明见 [third_party.md](report/third_party.md)。各文件保留原有声明，本次整理不改变授权范围。
