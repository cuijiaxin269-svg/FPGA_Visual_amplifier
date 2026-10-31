串口屏 / Zynq-7100 对接候选版本 v18hmi
基线：已封存的 v16alpha50，HDMI 1080p30，α 0..50，保留既有频谱布局。

验证边界
本目录是独立对接候选，不代表整机验收完成。具体构建结果以 reports、build/candidate/manifest.json 为准；
实体屏、HDMI、10 分钟交互与 60 分钟运行的完成情况以 ACCEPTANCE.txt 和 board 目录中的实际记录为准。
生成清单只根据已归档、绑定当前 ELF 的记录更新板端及长时间运行结果，不把主机测试当作实板结果。
本次已完成五类命令板端闭环、用户正常触摸/实体键确认、10 分钟自动交互及 32 分钟连续运行记录。
用户要求结束测试，60 分钟长稳未完成；具体未覆盖项目见 ACCEPTANCE.txt。最终设备保持 STOPPED。

当前电气条件
用户最初报告屏 TX 为 3.3V，随后于 2026-10-30 更正为 5V。更正后的报告有效。
随后用户在分压/电平转换指导后确认 FPGA RX 侧测得 2.7V，已解除该电气下载阻止。
这是一项用户现场测量记录，尚无示波器波形；实际串口质量仍须通过板端收发验证。
P4.3/AH12：FPGA TX -> 屏 RX。
P4.4/AG12：FPGA RX <- 经电平转换后的屏 TX。
P4.1：GND，与屏 GND 共地。
Bank 10 按板卡原理图的 VCC_ADJ1=3.3V、LVCMOS33 配置；供电如有改动须按实物重新核对。
TTL 短线临时联调可用：屏 TX -- 2.2kΩ -- 中点 -- P4.4；中点 -- 3.3kΩ -- GND。
计算值：5V 输入得到 3.0V，4.5V 输入得到 2.7V；中点先不接 FPGA，测量确认后断电接线。
这是信号分压，不是屏幕电源；不能用于 RS232 信号，也不能仅凭串联一个电阻就认定输入安全。
provenance/electrical/evidence.json 记录当前状态，board/tools/candidate_gate.py 在下载前检查它。
参考：https://wiki.tjc1688.com/debug/base/tjc2mcu.html
参考：https://docs.amd.com/api/khub/documents/0QG6MaFUXxeum~9JNcCOPw/content

代码结构
sw/hmi_uart.c：PS UART1 EMIO、IRQ82、GIC、4096 字节 RX 环和独立 TX 环。
采用 1 字节 RX 触发并在中断内排空 FIFO；禁用空闲超时中断，避免空 FIFO 周期性中断负担。
sw/start.S、link.ld：IRQ 入口、4KiB IRQ 栈；UART0/CH340 日志通道保持独立。
ARM 构建必须保留 -mno-unaligned-access：本裸机程序关闭 MMU，数值回包的非对齐字节不能合成为非对齐字加载。
sw/hmi_protocol.c：严格 CRLF 文本解析，96 字节行缓冲，按包型解析 TJC 二进制应答。
sw/hmi_link.c：原生属性指令及 FF FF FF 封包；页面查询、四组状态及重同步。
sw/motion60_hmi.inc：设备状态机，接入实际相机、算法、显示提交及实体按键。
sw/hmi_diagnostics.h：独立诊断及字节记录，不改原有 133-word 采集 mailbox ABI。
所有业务操作在主循环执行，中断仅处理通信。相机初始化阻塞期间 RX 中断仍接收。

命令与结果（屏 -> 板，ASCII，末尾必须为 CR LF）
VIEW 0：原画；VIEW 1：放大无面板；VIEW 2：放大加原有频谱面板。
运行中跨原画/放大切换：停止、排空、设置新模式、自动重启；显式 STOP 会取消该自动重启。
VIEW 1/2 互换只在显示帧边界提交面板，不重启相机，隐藏面板仍计算频谱。
停止时 VIEW 回 QUEUED，不隐含 START；实体键在原画与最近选择的放大视图间切换。
ALPHA n：整数 0..50；配置寄存器读回且新的处理帧完成才回 APPLIED。
EXPOSURE n：整数 1..898；只在停止/空闲时接受并回 QUEUED，下次启动读回一致才回 APPLIED。
运行中提交曝光回 BUSY。
START：进入连续运行；相机/处理/显示链路实际就绪后回 RUNNING。
STOP：取消待执行重启，排空相关任务后回 STOPPED；启动、处理或排空出错不回成功。
参数请求合并为最新目标，发布前检查当前代次；START/STOP 为明确的启动/停止请求。
VIEW/ALPHA/EXPOSURE/RUN 分别写 vstatus/astatus/estatus/rstatus；不混入 UART0 普通日志。

页面与连接
sendme 每 500ms 最多一条，查询超时 300ms；page0=0、动画=1、键盘=2。
动画期间等待；键盘期间只更新全局状态，返回主页后再更新私有按钮和计时器。
正常轮询不覆盖尚未提交的曝光草稿。初始化/重连时重新同步；启动默认为 STOPPED。
默认目标：VIEW 2、α=12、曝光=320。无隐含 START，无屏端默认值冒充实际值。
协议没有请求序号：保证最终状态一致并抑制板端已知的过期结果，无法逐条对应高速交错请求。

构建及主机测试（从工程工作区调用）
PowerShell: ./vision/v18hmi/scripts/test_hmi.ps1
PowerShell: ./vision/v18hmi/scripts/test_alpha50_controls.ps1
PowerShell: ./vision/v18hmi/scripts/test_stable_ui.ps1
PowerShell: ./vision/v18hmi/scripts/build_firmware.ps1
Vivado 2021.2: -mode batch -source vision/v18hmi/scripts/build_hardware.tcl
Python: vision/v18hmi/scripts/package_candidate.py
host_inputs.json / firmware_inputs.json 将测试、ELF 与实际源码哈希绑定，源码变化后必须重跑。
本次工作区硬件工程：b18hw/c.xpr。构建严格执行原有时序、DRC、CDC、bus skew、单时钟、KEY0、复位与 CSI 检查。
UART1 新 bit 必须配对使用新 XSA、ps7_init 和 ELF，不能只替换旧 ELF。
独立源码包含逐字节核对的 rtl、constraints、ip_repo 与 capture_hmi_bd.tcl。
scripts/create_standalone.tcl 可在一个全新目录重建 Vivado 工程，不需改动原 v16 工程；全新布局布线须重新执行物理检查。
独立完整重建入口：Vivado -mode batch -source scripts/build_standalone.tcl -tclargs 新工程路径/c.xpr。
该入口保留相同的物理检查，省去原 v16 增量布局参考；输出 build/standalone_candidate，避免覆盖本次封存包。
独立工程创建/BD 校验已实测通过；独立完整布局布线尚未额外执行，本次正式构建使用 b18hw。

板端联调与记录
board/tools/start_owned_server.ps1：检查其他控制者后启动独占 JTAG 服务，记录 PID。
inspect_entry.tcl：只读识别实际复位及固件状态；不依据旧记录猜测当前板卡。
candidate_gate.py：检查源码/产物哈希、bit/XSA 配对来源和电气条件。
load_warm.tcl：仅接受可证明的 v16alpha50 可执行代码，先正常 STOP/排空，再进行易失性加载。
load_cold.tcl：仅接受 DDR/PL 复位保持的冷入口，再执行成套初始化/下载。
以上两个脚本参数均为 candidate-package fresh-evidence-directory。不会写 Flash 或 SD。
snapshot.tcl fresh-directory：不 halt、不读清除型 HLS AP_CTRL，读取 HMI、相机、运行遥测与串口环形记录。
decode_snapshot.py fresh-directory：生成 summary.json、rx/tx.bin、rx/tx.txt。
0x00ff6300：JTAG 原生串口诊断请求；仅将主机提交的指令送入现有 TX 队列，不直接修改设备状态。
完成标记仅表示进入 UART 发送队列，不能当作屏幕确认；hmi_helpers.tcl 另外等待真实屏幕回包及设备状态。
probe_link.tcl 读取实体屏全局值；runtime_commands.tcl 让实体屏用 printh 发出完整 CRLF 命令，验证真实 P4 收发闭环。
interaction_smoke.tcl fresh-log-path 执行 10 分钟真实 UART 自动交互，不等价于手指触屏测试。
monitor.tcl soak 3600 fresh-log-path 只读观察 60 分钟连续运行，期间不要发新命令或触摸控件。
这类自动检查不能代替手指触摸和 HDMI 视觉验收，运行时应避免同时触摸或用另一个 JTAG 控制者修改状态。
0x00ff2000：64-word HMI 诊断；0x00ff2100：16-byte trace header + RX8192 + TX8192。
快照中的 trace 是 UART FIFO 字节证据，不等价于示波器/逻辑分析仪波形。
环形记录只保留最近 8192 字节，解码器剔除读取期间可能被覆盖的部分；长期记录应定期取快照。
close_owned_server.ps1：只关闭有身份凭据的本任务服务，不向板卡发送命令。

回退
原封存包仍位于 vision/v16alpha50/build/candidate，baseline.json 固定其哈希。
严禁混用 v16 bit 与 v18 ELF。回退应成套使用 v16 bit/XSA/ps7_init/ELF。
旧回退入口 board_checks/20261029_alpha50_reload_02/tools/load_cold.tcl 只接受已证明的冷复位入口。
该旧 warm loader 不认识 v18 可执行代码，不能直接用于热回退；先正常停止并按冷启动流程操作。

本次范围不含：HDMI 1080p60、离线回放修复、Flash/SD 固化、屏端工程改动。
