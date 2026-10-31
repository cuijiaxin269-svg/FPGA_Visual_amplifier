# 2025.2 匹配启动包构建与静态检查

2026-10-30，使用本次完整硬件构建导出的 XSA/bit，以及 AMD 2025.2 配套 GCC 已通过编译的 ARM 应用，实际生成并验证了新的 FSBL 和 BOOT。入口进程及 XSCT、make、bootgen、bootgen 解析全部退出码为 0。没有执行板卡连接、下载、Flash 烧录或冷启动。

| 检查 | 结果 |
|---|---|
| XSA 与独立位流 | 新 XSA 含一个 `capture.bit`，大小及 SHA256 完全一致 |
| FSBL 生成 | XSCT 2025.2 / HSI，官方 `zynq_fsbl` 模板，`ps7_cortexa9_0` / standalone |
| FSBL BSP | UART0 stdout `0xe0000000`；QSPI 线性窗口 `0xfc000000` |
| FSBL 编译 | AMD 配套 ARM GCC 13.3.0；`-DFSBL_DEBUG_INFO -mno-unaligned-access`；编译/链接成功 |
| 启动镜像 | Bootgen 2025.2；13,357,152 字节，小于 16 MiB |
| 三分区 | FSBL → bit → application；头校验、长度、目标属性和地址检查通过 |
| ARM 应用 | ELF32 ARM，入口 `0x00100000`，71,008 字节加载载荷与 BOOT 中对应区域一致；mailbox `0x00ff0000` 为 NOLOAD |
| 新初始化文件 | C/H、Tcl、HTML、GPL C/H 共六个文件均与新 XSA 内成员逐字节一致 |
| 实板运行 / Flash 启动 | 未测试；两个状态字段均为 false |

完整输入/输出和脚本 SHA256、实际命令、工作目录、步骤退出码见 [result.json](result.json)。镜像结构见 [boot_image_audit.json](boot_image_audit.json)，初始化来源见 [xsa_init_match.json](xsa_init_match.json)。`generated_fsbl_sources.json` 记录了编译前生成的 FSBL/BSP 文件哈希；各步骤原始日志保留在本目录。

主要产物 SHA256：

| 文件 | SHA256 |
|---|---|
| capture.bit | `d05b1a2806b50cbcfc7e642b6c4166afee59d63c74d284197401a1332e67336a` |
| capture.xsa | `7744a47aed5b654eb9866f4d7be723e2a7ab7e5c47400b5a3e6ed6bc5a2d078a` |
| motion60.elf | `bc29cac57037406e232d877df2157608d4ae62f74c546e254251e95f192b8e6d` |
| fsbl.elf | `d31c0717af961b5c57129b37773d9ed3f1e95a60a0e31bb01cce340d814e4569` |
| boot.bin | `21d3d6c99f9706e048382a6e0c95861261b04fd70db77836948e8f273c02c589` |

构建目录为 `D:/vision/submission/_build/boot_2025_2`。成套附件保存于提交目录旁 `release_assets/vivado_2025_2/`，包括 LTX 和 SHA256 清单；不将旧 v19 初始化文件混入新附件。重新构建使用[启动包入口说明](../../scripts/README.md)，输出必须为尚不存在的新目录。路径和生成时间可能影响调试信息或二进制哈希，复现需核对本次生成的收据与产物，而不是预设所有机器必然产生相同 SHA。

本次真实运行确认了 2025.2 仍支持所用 HSI 生成方式。日志保留 XSCT 弃用提示、无文件系统接口提示，以及厂商驱动配置字段缺少初始化的普通编译警告。外层 make 使用 `-j1`，生成的 BSP 内层 Makefile 显式采用 `-j22`；未将警告删除或声称全流程单任务运行。

此检查只证明主机上的构建和镜像静态一致性。最终器件的 MIPI HS / HDMI 板外时序窗口边界见[硬件构建报告](../vivado_2025_2/README.md)。新镜像的 Flash 操作入口、真实冷启动、相机/HDMI/HMI、反复启停和稳定性仍需实板验证；历史 v19 的一次冷启动不能证明本镜像可运行。完整 HLS C++ 重生成仍另列为未验证。
