v19boot — v18 HMI 的独立 QSPI 固化版本

2026-10-30：板载第一片 Flash 固化完成，完整镜像与未涉及尾部读回校验通过。
实际断电上电后 BOOT_MODE=1（QSPI），应用代码逐字节一致且保持 STOPPED，冷启动通过。
当前实板拨码位置已验证正确，保持该位置即可；未验证项目见 ACCEPTANCE.txt。
交付包：build/v19boot_source_and_candidate.zip；逐文件哈希：build/candidate/manifest.json。

启动策略：上电加载程序后 STOPPED；VIEW 2，alpha 12，曝光 320。
用户通过触屏 START 启动采集。没有掉电参数保存或自动 START。
保留 HDMI 1080p30、alpha 上限 50 和 v18 原有算法/频谱界面。

构建
1. scripts/initialize_candidate.py 验证并复制封存的 v18 输入，仅用于空目录首次建立。
2. Vivado 2021.2 执行 scripts/prepare_qspi_platform.tcl，独立工程 b19boot/c.xpr。
3. scripts/audit_platform.py 核对 HWH 的结构和连接、CSI 子系统、PS 初始化。
   只允许 QSPI0 MIO1..6 及其时钟变化；capture.bit 与 v18 封存位流完全相同。
   新 capture.xsa 不内嵌 bit；必须使用本候选显式配对的 capture.bit。
   scripts/create_standalone_qspi.tcl 提供从本目录源码重建 BD 的入口，本轮未额外运行；
   本轮实际启动平台来自上述 b19boot 导出，PL 复用经过差异检查的 v18 位流。
4. scripts/build_firmware.ps1；scripts/test_hmi.ps1。
5. XSCT 2021.2 执行 scripts/create_fsbl.tcl；scripts/build_boot.ps1；scripts/audit_boot.py。
   FSBL 来自本机 AMD 2021.2 官方模板，CPU0，stdout UART0；启用 FSBL_DEBUG_INFO。
   BIF 顺序：fsbl.elf、capture.bit、motion60.elf。

应用启动改动
sw/start.S 增加同步/指令缓存、分支预测和 TLB 失效处理，并独立清零整个
0x00ff0000..0x00ffffff 保留区，避免 NOLOAD 遥测/请求继承历史 DDR 内容。
main.c 在启用 UART1 中断之前建立 CPU0 GIC、私有计时器和全局计时器初始状态。
AMD FSBL 负责在交接前清洗/关闭数据缓存，本应用不是任意运行中系统的热跳转入口。
UART 修复保持：-mno-unaligned-access、RXWM=1、RXTOUT=0。

实物与烧录范围
2026-10-30 实测第一片 Flash JEDEC EF 40 18，128 Mbit / 16 MiB；SR1=0，SR2=2。
选择 QSPI0 单片 x4，只使用第一片 U11 对应接口，不把第二片当作 A/B 回退。
BOOT.BIN 13,299,932 字节；从 0 写入，64 KiB 擦除边界到 0x00cb0000（不含）。
尾部 0x00cb0000..0x00ffffff 不在计划擦除范围。
备份及实板日志：board_checks/20261030_v19boot_01（以工作区为根）。
完整 16 MiB 备份已独立重读比对，主机下载 CRC32 也一致。封包时同步放入 recovery/。
SHA256：ad98a3cefadddc84ecb12c1ee796295cff5cfdc90a6de38a1fa299b97cab2bfc。

本轮最终写入方法
两次官方 program_flash 在主机传输阶段停滞，不能按进程退出码 0 当作通过。
后续 USB 传输也曾中断；用户更换 USB 数据线后，保留 DDR，从 8,060,928 字节
断点继续传输，整包 CRC32 通过后再恢复写 Flash。未重新擦除。
board/qspi_program.c 使用官方 XQspiPs 驱动，先校验 DDR 镜像、JEDEC、未改尾部及
目标位兼容性，再由主机显式启动写入；已相同页面跳过，新增页面逐页读回。
首版恢复程序的发送/接收参数错误已修正，失败和修复记录完整保留。
最终恢复写入 39,153 页，跳过相同内容 12,800 页；整包 Flash CRC32=84cb6227。
末尾未涉及区域 CRC32=15890968，最终 SR1=0。完整证据见 reports/flash_verified.json。
恢复程序只绑定本 BOOT.BIN 的长度和哈希，不可用于其他镜像；不替代通用烧录工具。
provenance/executed_board_tools 是原工作区执行脚本存档，内含历史失败版本，不应批量执行。

拨码（以本次实物回读为准）
用户无法可靠辨认实板 ON 与 1/2 标记，因此不把原理图推导的开关编号当作实物操作依据。
最终两个拨杆是一开一关，实际断电启动回读 BOOT_MODE=1，已确认 QSPI 启动。
本轮反向的“一开一关”组合曾读到 4，不是 QSPI；两个拨杆都反向后读到 1。
保持最终已验证的位置即可。历史回读还包括 JTAG=0、SD=5；改变模式应先断电。

恢复
保留 HS3 JTAG。断电设置 JTAG；用本候选匹配的 FSBL 和 program_flash
将 flash_before_16MiB.bin 从 offset 0 写回 qspi-x4-single，并执行 -verify。
这会恢复第一片 Flash 的完整原内容。v18 原候选可用于易失性 JTAG 回退。
不要单独写入 capture.bit，不使用 eFuse/加密，不混配 v16/v18/v19 的初始化与应用。

验收边界
reports/platform_compatibility.json：平台比较。
reports/boot_image_audit.json：启动头、分区校验、加载入口和哈希。
board_checks 内的 volatile_handoff 是调试器辅助的 FSBL 交接测试：人为选择 JTAG
分支并下载 PL/应用，不等于 BootROM 从 Flash 完整自启动。
最终烧录、读回及一次真正断电启动均已通过，见 ACCEPTANCE.txt 和最终冷启动记录。
boot_image_audit.json 是构建时静态审计快照，其中 physical_flash_boot_validated=false
表示当时尚未开展实板冷启动；最终结论以 cold_boot_verified.json 和封存 manifest 为准。
不得将 v18 的 32 分钟运行证据改称 v19 的长稳或 60 分钟通过。

官方依据
https://docs.amd.com/r/en-US/ug821-zynq-7000-swdev/First-Stage-Bootloader
https://docs.amd.com/r/en-US/ug585-zynq-7000-SoC-TRM/Boot-Mode-Pin-Settings
https://docs.amd.com/r/2025.1-English/ug1165-zynq-embedded-design-tutorial/Programming-QSPI-Flash-with-the-Flash-Programming-Tool
