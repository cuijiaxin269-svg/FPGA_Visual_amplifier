# 硬件与接线资料

工程目标器件为 `xc7z100ffg900-2`，原约束注明 OS-ZYNQ7100 Dock Lite / REV_A 核心板。作者已确认整套系统上板可正常使用。本页整理已有引脚约定；芯片 BOM、供电说明和启动拨码照片见[硬件资料](../hardware/README.md)，HMI/TFT 见[串口屏工程](../hmi/README.md)。

## 串口屏

依据 `src/constraints/hmi_uart_p4.xdc` 及 `report/original_notes/v18hmi/readme.txt`：

| 板端信号 | 接口/封装引脚 | 连接 |
|---|---|---|
| `hmi_uart_tx` | P4.3 / AH12 | 板 TX 至屏 RX |
| `hmi_uart_rx` | P4.4 / AG12 | 屏 TX 经适当电平转换后至板 RX |
| 地 | P4.1 | 屏与板共地 |

该约束采用 LVCMOS33，原资料假定 Bank 10 的 VCC_ADJ1 为 3.3V。历史用户报告屏 TX 为 5V，电平处理后 FPGA RX 侧测得 2.7V；记录没有示波器波形，不能据此认证其他接法或线路。屏供电与 UART 逻辑电平分别核对。UART0/CH340 日志与本 UART1 EMIO 通道独立。

屏型号记录为 `TJC1060X570_011C`、1024×600，运行波特率为 115200、8N1。原 XDC 注释保留初次离线准备时的状态；后续交互证据见 [v19 验收记录](../results/v19_acceptance_20261103/README.md)。

## 摄像头与显示

相机采用 OV9281。原工程涉及相机时钟、SCCB 配置和两路 MIPI 数据。引脚分配的权威输入是 `src/constraints/camera_amd.xdc` 与 `common.xdc`，HDMI 分配见 `motion60_hdmi.xdc`；仅凭 FPGA 封装引脚不能推断排线方向。

原相机约束注明板上已有固定终端，设 `DIFF_TERM FALSE`，并使用特定 Bank 电压配置。迁移到其他板卡时必须重新根据该板硬件确定这些条件。此配置不能作为任意 OV9281 转接板的通用约束。

现有显示配置为 HDMI 1080p30。显示、触屏与实体按键记录见 [v19 验收说明](../results/v19_acceptance_20261103/README.md)。

## QSPI 与启动

历史 v19 使用第一片 16 MiB Flash、QSPI0 单片 x4。已有记录在真实断电后读到 BOOT_MODE=1，并保持 STOPPED、VIEW 2、alpha 12、曝光 320。

实物位置见[启动拨码照片 1](../hardware/archive_20261103/启动拨码1.jpg)和[照片 2](../hardware/archive_20261103/启动拨码2.jpg)，读回依据见 [v19 三次冷启动记录](../results/v19_acceptance_20261103/README.md)。历史恢复工具绑定特定镜像及校验条件，不能直接用于新生成的 2025.2 镜像。

## 迁移到其他硬件

本页引脚和 Bank 配置仅对应当前板卡。更换板卡、相机转接板或串口屏时，按实际原理图核对供电、信号电平和排线方向，并使用同一版本配套的 bit、XSA、初始化文件和固件。
