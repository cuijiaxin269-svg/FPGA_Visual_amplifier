# 验证证据索引

本索引区分主机软件测试、RTL 仿真、硬件构建、板内读回、人工视觉确认和真实冷启动。路径相对于仓库根目录。原始记录中的旧绝对路径作为历史来源保留，不是本仓库的执行入口。

## 本轮目录整理与 2025.2 验证

| 项目 | 证据路径 | 范围 |
|---|---|---|
| 8 项主机测试 | `sim/results/current_host/result.json` 及各测试日志 | 协议、设备调度、UART、按键、增益、边界、频谱 UI、稳定性相关测试通过；不是实板测试 |
| ARM 应用重新编译 | `build/reports/firmware_2025_2/result.json` | AMD 2025.2 配套 GCC 13.3.0 编译/链接成功，包含源码哈希；`board_tested=false` |
| 频谱 UI 软件/RTL 比对 | `sim/results/vivado_2025_2/result.json` | Vivado 2025.2 xvlog、xelab、xsim 执行结果及输入哈希；不是全系统仿真 |
| 完整硬件构建 | [硬件报告](../build/reports/vivado_2025_2/README.md)、`result.json`、`input_sha256.json` | 71 个 IP、顶层综合、实现、bit/XSA/LTX 导出通过；825 个输入哈希对应本次构建；WNS +0.177 ns、WHS +0.010 ns；外部 MIPI HS/HDMI 时序边界仍待实测 |
| 匹配 FSBL 与 BOOT | [启动包报告](../build/reports/boot_2025_2/README.md)、`result.json`、`boot_image_audit.json`、`xsa_init_match.json` | 新 XSA 与 bit 一致；FSBL/bootgen/三分区及应用载荷静态检查通过；六个初始化文件匹配新 XSA；未烧录/冷启动/上板 |
| 通过记录与输入对应 | [输入收据复核](validation_receipt_check.json) | 主机 58、RTL 6、ARM 43 个输入哈希均与相应通过记录对应 |
| 本机工具链失败记录 | `sim/results/environment_failure/` | 保留迁移中遇到的工具环境失败，不与最终通过记录混淆 |

## 历史 v18hmi

结论由 `board/results/v18hmi/board_validation.json` 绑定到原位流和 ELF：

- ELF SHA256：`d192c7066773cdc7c3e7141eb392fd204e0974490a05902f88319536fd0d4f77`。
- bit SHA256：`9836f502522085ff01fde7f3194b2dfe9491ffe7e30447ca391e50e4363cc134`。
- 五类命令真实串口链路、协议边界、屏幕软重启及停止排空有通过记录。
- 自动交互 602631 ms、30 轮；`physical_touch_test=false`。
- 第五段连续观察 1920000 ms、193 个样本，115929 个处理帧和 57600 个显示帧增量，期间无 JTAG 重连。该段是 32 分钟，不能因文件名 `soak_60m_05.jsonl` 而称为 60 分钟测试。
- `physical_screen_hdmi_passed=false` 表示完整 17 项物理验收未覆盖完；`user_observations` 保留已确认的部分实体操作。

| 原始证据 | 可复查内容 |
|---|---|
| `board/results/v18hmi/board_evidence/probe_link_04.log`、`runtime_commands_03.log` | 屏幕链路和五类命令读回 |
| `board/results/v18hmi/board_evidence/interaction_smoke_01.jsonl` | 自动交互全过程 |
| `board/results/v18hmi/board_evidence/soak_60m_05.jsonl` | 单次 32 分钟连续观察 |
| `board/results/v18hmi/board_evidence/user_observations.json` | 用户现场观察及其解释边界 |
| `sim/results/original_v18/` | 原版本主机回归日志 |
| `build/reports/original_2021_2/` | 原版本综合、实现、资源、时序、CDC 与 DRC |
| `report/original_notes/v18hmi/acceptance.txt` | 已完成与待测项的完整原记录 |

## 历史 v19boot

| 原始证据 | 可支持结论 |
|---|---|
| `board/results/v19boot/platform_compatibility.json` | 历史 QSPI 平台变更检查，PL 复用 v18 位流 |
| `board/results/v19boot/boot_image_audit.json` | 构建时启动镜像静态检查；其中未上板字段属于当时快照 |
| `board/results/v19boot/flash_verified.json` | 最终 Flash 镜像读回及未涉及尾部的验证 |
| `board/results/v19boot/cold_boot_verified.json` | 一次真实断电/上电；BOOT_MODE=1；.text 69876 字节与原候选逐字节一致，运行计时增长，状态 STOPPED |
| `board/results/v19boot/board_evidence/` | 传输失败、恢复、读回与冷启动的原始记录 |
| `report/original_notes/v19boot/acceptance.txt` | 摄像头/HDMI/HMI、重复掉电和长稳尚未验证 |

冷启动证据绑定的应用 ELF SHA256 是 `b066d1e63a11929eae0b8ca86c233da6d40929d3daa14621ef4b7a88622c7d98`，与本轮 2025.2 编译得到的 ELF 不同。它只证明历史候选的那次冷启动。文件 `volatile_handoff*.log` 属于调试器辅助交接，不能单独证明 BootROM 从 Flash 自启动。

## 后续补证规则

新运行结果另建目录，记录版本、输入、参数、执行命令、工具版本、时间和产物哈希。需要对比时只合并统计表，不改写历史日志。若源码、IP、平台初始化或固件改变，明确哪些旧结果仍适用，哪些必须重测。
