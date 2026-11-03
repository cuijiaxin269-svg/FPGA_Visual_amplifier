# FPGA_Visual_amplifier

区域相位运动放大与微振检测。基于 Zynq-7000 `xc7z100ffg900-2`，结合 OV9281 图像采集、PL 图像处理与频谱、HDMI 1080p30 显示及 PS 裸机串口屏交互。

本目录由已有工程整理而来，以 `v19boot` 为源码起点，保留 `v18hmi` 和 `v19boot` 的原始验证记录。原工程未改动。正式材料缺项见 [submission_gaps.md](report/submission_gaps.md)；历史证据与本轮验证分开保存。

**2026-11-03 资料已补充：** [资料总索引](report/materials_20261103.md)包含串口屏 HMI/TFT、硬件 BOM/供电/拨码照片、v19 验收与黄金参考、24 页报告及 LaTeX 源码。完整原始资料包放在[资料发布页](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/tag/materials-20261103)。视频与 HLS 第 6 项按用户最新要求暂缓发布。本次保持 `a9ab041` 原版工程，后续算法改进与方形选区工程不发布。

新 v19 证据支持 3 次冷启动、实体按键、启停及用户确认的屏幕效果；长稳采样中断，仍未完成完整验收。黄金参考对比中的输出来自 HLS C 仿真，实板逐帧输出、端到端延迟及真实位移倍率仍待测。这些结果不等于下表 2025.2 新构建产物的整机验证。

## 当前验证

下表保留 2025.2 构建基线的验证范围；11 月 3 日 v19 实板增补见[独立验收说明](board/results/v19_acceptance_20261103/README.md)。

| 项目 | 状态与证据 |
|---|---|
| 现有 8 项主机测试 | 迁移到新目录后全部通过；[结果](sim/results/current_host/result.json) |
| ARM 裸机程序 | 使用 AMD 2025.2 配套编译器重新编译通过；[结果](build/reports/firmware_2025_2/result.json) |
| 频谱 UI RTL 对比 | Vivado 2025.2 的 xvlog/xelab/xsim 通过；[结果](sim/results/vivado_2025_2/result.json) |
| Vivado 2025.2 完整硬件构建 | 71 个 IP、顶层综合、布局布线、位流/XSA/LTX 导出全部通过；WNS +0.177 ns、WHS +0.010 ns；[硬件构建报告](build/reports/vivado_2025_2/README.md) |
| 2025.2 匹配启动包 | 新 XSA 生成 FSBL，bootgen 与镜像静态检查通过；BOOT 13,357,152 字节；[启动包报告](build/reports/boot_2025_2/README.md) |
| 2025.2 新构建的板级运行 | 尚未验证；编译/仿真通过不能替代上板结果 |

历史 v18 记录包括部分实体屏/HDMI 确认、10 分钟自动交互和 32 分钟连续运行；历史 v19 包括 Flash 固化和一次真实冷启动，当时未接相机、HDMI 或串口屏。详情见 [证据索引](report/evidence_index.md) 和 `report/original_notes/`。

2025.2 最终资源为 LUT 138026、FF 206397、BRAM 744.5/755、DSP 826。原约束中 MIPI HS 输入及 HDMI 输出的板外时序窗口仍需实测，内部正时序余量不能证明板外采样/输出裕量，详见[硬件报告的约束边界](build/reports/vivado_2025_2/README.md#原设计的外部-io-约束边界)。

## 目录

| 目录 | 内容 |
|---|---|
| `src/rtl`、`src/ps` | 自研 RTL 与 PS 裸机程序 |
| `src/hls` | 追溯得到的 HLS 源码及相关测试；[来源与限制](report/hls_provenance.md) |
| `src/ip`、`src/bd`、`src/constraints` | 当前导出 IP、BD Tcl、引脚与时序约束 |
| `sim` | 原有测试、移植后的运行入口、新旧结果 |
| `build` | 可配置构建入口与报告，编译中间目录另置 |
| `board` | 接线资料、历史运行脚本、对应版本的板级证据 |
| `data` | 已有多频输入测试记录 |
| `skill` | 从已有失败与观察中整理的可复用经验 |
| `report` | 设计材料、协作记录状态、来源清单及缺项 |

## 2025.2 环境与构建

本轮验证环境为 Windows、AMD unified tools 2025.2、Python 3。主机 C++ 测试使用 AMD 安装内附的完整 MinGW 工具链；系统原有 `D:/mingw64` 缺失标准头文件，失败记录保留于 `sim/results/environment_failure/`。配置安装路径时请使用实际目录。

以下 PowerShell 示例假设当前目录为仓库根目录。所有大型输出放到独立目录，避免将 Vivado 缓存提交到 Git。创建工程的输出目录必须尚不存在。

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

python sim/scripts/run_host_tests.py --cxx $cxx --output "$outputRoot/host"
if ($LASTEXITCODE -ne 0) { throw 'Host tests failed; inspect the result receipt.' }
python build/scripts/build_firmware.py --tool-root $amdRoot --output "$outputRoot/firmware"
if ($LASTEXITCODE -ne 0) { throw 'ARM firmware build failed; inspect the result receipt.' }
python sim/scripts/run_spectrum_rtl.py --cxx $cxx --vivado-root "$amdRoot/Vivado" --output "$outputRoot/rtl_sim"
if ($LASTEXITCODE -ne 0) { throw 'Spectrum RTL comparison failed; inspect the result receipt.' }

& "$repoRoot/build/scripts/build_hardware.ps1" -Vivado $vivado -BuildDirectory "$outputRoot/hardware"

python build/scripts/build_boot.py --tool-root $amdRoot `
    --xsa "$outputRoot/hardware/artifacts/capture.xsa" `
    --bit "$outputRoot/hardware/artifacts/capture.bit" `
    --app "$outputRoot/firmware/motion60.elf" `
    --app-receipt 'build/reports/firmware_2025_2/result.json' `
    --output "$outputRoot/boot"
if ($LASTEXITCODE -ne 0) { throw 'Boot package failed; inspect its reports/result.json.' }
```

三个 Python 入口在有效命令启动后先将收据标为 `running`，正常结束标为 `passed` 或 `failed`；缺少工具或子进程异常也会写入失败原因。可用 `--report-dir` 指向独立报告目录进行诊断，避免覆盖正式验证记录。

当前硬件入口使用随仓库保存的已导出 IP。`motion60_shared` 的历史版本包含 alpha 上限常量 ECO，不能将重新生成的 HLS IP 未经比对直接覆盖；完整 C++ 到 IP 的重生成状态见 HLS 来源报告。


启动包入口生成新的 FSBL、BIF 和 BOOT，并检查 XSA 内位流、UART0/QSPI 配置和应用载荷；细节见 [build/scripts/README.md](build/scripts/README.md)。此入口只构建文件，不执行上板或烧写。

## 发布附件和许可

公开源码仓库为 [cuijiaxin269-svg/FPGA_Visual_amplifier](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier)，配套构建产物通过 [GitHub Releases](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases) 提供。`fpga_visual_amplifier_vivado_2025_2_artifacts.zip` 包含匹配的 bit、XSA、LTX、应用/FSBL ELF、BOOT/BIF、新平台初始化文件、SHA256 清单及验证范围说明。

本地成套文件仍位于提交目录旁 `release_assets/vivado_2025_2/`。原 2021.2 历史产物单独保存在本地 `release_assets/v19_2021_2/`，本次发布附件采用 2025.2 版本，不能混用两套初始化文件和产物。源码仓库不包含 Vivado 构建缓存；从仓库根可运行 `python build/scripts/verify_package.py` 核对文件清单与 IP 引用。

项目级开源协议尚待确定，当前未添加声称覆盖所有第三方文件的 LICENSE。[第三方说明](report/third_party.md) 保留待核对项；公开仓库不表示第三方文件已被重新许可。
