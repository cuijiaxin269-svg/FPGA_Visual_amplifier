# 硬件与接线资料（从现有工程整理）

本页记录已有约束和实测笔记，不替代板卡原理图、连接器照片或新板卡核验。工程目标器件为 `xc7z100ffg900-2`；原约束注明 OS-ZYNQ7100 Dock Lite / REV_A 核心板。完整 BOM、板卡照片和摄像头排线方向仍需作者补充。

## 串口屏

依据 `src/constraints/hmi_uart_p4.xdc` 及 `report/original_notes/v18hmi/readme.txt`：

| 板端信号 | 接口/封装引脚 | 连接 |
|---|---|---|
| `hmi_uart_tx` | P4.3 / AH12 | 板 TX 至屏 RX |
| `hmi_uart_rx` | P4.4 / AG12 | 屏 TX 经适当电平转换后至板 RX |
| 地 | P4.1 | 屏与板共地 |

该约束采用 LVCMOS33，原资料假定 Bank 10 的 VCC_ADJ1 为 3.3V。历史用户报告屏 TX 为 5V，电平处理后 FPGA RX 侧测得 2.7V；记录没有示波器波形，不能据此认证其他接法或线路。屏供电与 UART 逻辑电平分别核对。UART0/CH340 日志与本 UART1 EMIO 通道独立。

原 XDC 的注释保留初次离线准备时的状态；后来 v18 的串口验证见 `board/results/v18hmi/`。屏型号、屏编辑器版本和实际 `.hmi/.tft` 工程尚未补齐。

## 摄像头与显示

相机采用 OV9281。原工程涉及相机时钟、SCCB 配置和两路 MIPI 数据。引脚分配的权威输入是 `src/constraints/camera_amd.xdc` 与 `common.xdc`，HDMI 分配见 `motion60_hdmi.xdc`；仅凭 FPGA 封装引脚不能推断排线方向。

原相机约束注明板上已有固定终端，设 `DIFF_TERM FALSE`，并使用特定 Bank 电压配置。迁移到其他板卡时必须重新根据该板硬件确定这些条件。此配置不能作为任意 OV9281 转接板的通用约束。

现有显示配置为 HDMI 1080p30。实际显示和触屏部分历史确认见 `report/original_notes/v18hmi/acceptance.txt`；工具升级后的新位流需要重新确认相机、显示和交互。

## QSPI 与启动

历史 v19 使用第一片 16 MiB Flash、QSPI0 单片 x4。已有记录在真实断电后读到 BOOT_MODE=1，并保持 STOPPED、VIEW 2、alpha 12、曝光 320。

原记录未可靠确认实物开关的 ON/编号方向，因此这里不提供猜测的拨码图。作者需要补充实际已验证位置的清晰照片，并与 Boot Mode 读回对应。历史恢复工具绑定特定镜像及校验条件，不能直接用于新生成的 2025.2 镜像。

## 复现前需补充

- 板卡准确型号/版本、供电、相机模块和连接器朝向照片。
- 屏型号、连接线及电平处理实物图。
- 正式提交版本的完整接线图、QSPI 拨码位置和配套初始化/固件清单。
