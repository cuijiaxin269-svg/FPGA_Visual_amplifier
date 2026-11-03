# 2025.2 启动包构建入口

`build_boot.py` 用于在完整硬件编译成功后，将新 XSA、匹配位流和新 ARM 应用组成独立的 QSPI 启动包。2026-10-30 已用 AMD 2025.2 实际完成 XSCT/HSI 生成、FSBL 编译、bootgen、bootgen 读回解析与镜像静态审计，所有子进程退出码为 0；详见[启动包报告](../reports/boot_2025_2/README.md)。此处记录主机构建流程，整机使用状态见[项目首页](../../README.md)。

它调用 `create_fsbl.tcl`，使用所选 AMD 安装中的官方 `zynq_fsbl` 模板生成 FSBL。流程只在主机运行，不调用板卡连接、下载或 Flash 编程工具。

## 输入和输出

- XSA 必须包含恰好一个 `.bit`，其大小和 SHA256 必须与 `--bit` 完全一致；不接受不带位流的旧 v19 XSA。
- `--app` 是本次重新编译的 ARM ELF。可通过 `--app-receipt` 校验 ELF 与成功的固件构建收据相符，并保留对应源码哈希。
- `--output` 必须是仓库外尚不存在的新目录。原有结果不会覆盖。
- 所有子工具工作目录及 TEMP/TMP 均在该输出目录中。脚本不会向原工程写入文件。

示例从仓库根目录运行，以下路径须指向同一次 2025.2 构建的配套产物：

```powershell
$amdRoot = 'D:/tool/vivado/2025.2'
$hardwareArtifacts = 'D:/vision/submission/_build/v25/artifacts'
python build/scripts/build_boot.py `
    --tool-root $amdRoot `
    --xsa "$hardwareArtifacts/capture.xsa" `
    --bit "$hardwareArtifacts/capture.bit" `
    --app 'D:/vision/submission/_build/firmware_2025_2/motion60.elf' `
    --app-receipt 'build/reports/firmware_2025_2/result.json' `
    --output 'D:/vision/submission/_build/my_boot_reproduction'
if ($LASTEXITCODE -ne 0) { throw 'Boot package failed; inspect its reports/result.json and step logs.' }
```

通过后，`artifacts/` 中包含配套 XSA、bit、应用 ELF、FSBL ELF、生成的 PS 初始化 C/H、BIF 和 `boot.bin`。本次 HSI 同时在该目录展开 XSA 的 `ps7_init.tcl/html` 与 GPL 变体；发布归档时逐一确认六个初始化文件与新 XSA 内容字节一致。BIF 顺序固定为 FSBL、位流、应用。`reports/` 保存每一步命令及退出码、输入/输出 SHA256、生成的 FSBL 源文件哈希和启动镜像检查结果。

## 检查与接口边界

脚本要求生成的 BSP 使用 UART0 stdout（`0xe0000000`），存在 QSPI 线性地址（`0xfc000000`），镜像不超过 16 MiB。QSPI 宏接受 2025.2 官方 FSBL 源码兼容的 `XPAR_PS7_QSPI_LINEAR_0_S_AXI_BASEADDR` 或 `XPAR_PS7_QSPI_LINEAR_0_BASEADDRESS`，若同时存在则都须符合地址要求。静态检查沿用本项目原启动合同：未加密的三分区 Zynq 镜像、应用入口 `0x00100000`、NOLOAD mailbox `0x00ff0000`，并比对应用 ELF 与镜像载荷。

本机 2025.2 的 XSCT、make、ARM GCC、bootgen 路径及 `hsi::generate_app` 已经过本工程新 XSA 的实际执行验证。外层 make 使用 `-j1`；官方生成的 BSP Makefile 会为驱动库显式启用内部并行，本机本次为 `-j22`。日志保留 XSCT 弃用提示、无文件系统接口提示以及部分厂商驱动配置字段缺少初始化的编译警告。

这是本项目的检查规则，不是任意 Zynq 地址布局的通用打包程序。若 2025.2 的 HSI 接口不生成预期 Makefile/BSP，或 ELF/bootgen 格式不满足该合同，会明确失败并保留日志；需要据实际工具输出调整，不能跳过检查直接宣称成功。

输出目录的 `reports/result.json` 先写为 `running/passed=false`，异常改为 `failed` 并记录原因，所有步骤及静态审计通过后改为 `passed`。脚本不操作开发板，因此其 `physical_flash_boot_validated` 和 `board_runtime_validated` 字段保留 false；它们描述本次主机构建收据，不代表当前整机不可使用。
