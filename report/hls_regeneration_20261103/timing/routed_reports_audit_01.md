# 最终 routed 报告独立审核

审核时间：2026-11-04T00:45:39.870222+08:00。结论：**本次最终 routed 报告通过既有验收门槛，保留普通警告与报告展示范围限制。** 八份报告均非空，读取前后 SHA-256 一致；时间、路径和设计状态对应本次 resume_02，而非旧报告。

| 范围 | WNS | TNS | WHS | THS | WPWS | TPWS |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 全设计，ns | 0.177 | 0 | 0.010 | 0 | 0.264 | 0 |
| FCLK1，ns | 0.177 | 0 | 0.010 | 0 | 2.565 | 0 |

两行的 setup/hold/pulse-width 失败端点均为0。全设计端点总数为520460/519856/225476，FCLK1为484949/484949/208990。实际报告为 Physopt postRoute，显示所有已指定时序约束满足。原目标150MHz未放宽；Clock Summary沿用原约束显示6.666ns/150.015MHz，属于报告精度下的表示，不是新增频率精度或板测结论。

`no_clock`、`constant_clock`、`pulse_width_clock`、`unconstrained_internal_endpoints`、`multiple_clock`、`generated_clocks`、`loops`、`partial_input_delay`、`partial_output_delay`、`latch_loops`均为0。`no_input_delay=9`、`no_output_delay=4`与公开基线一致。八个缺输入延迟端口为 dphy_clk_lp_n/p、dphy_data_hs_p[0:1]、dphy_data_lp_n[0:1]、dphy_data_lp_p[0:1]，另有KEY0到首级同步器的异步false path；输出范围是四组HDMI TMDS。没有加入虚构外部延迟消除这些项。内部STA不能证明MIPI/TMDS外部窗口、眼图、抖动或板级信号完整性。

## DRC、CDC与偏斜

- routed DRC：Error0、Critical Warning0。16类、2973条已展示详情的分类计数与基线一致；普通Warning合计2056、Advisory917。包括DSP输入/输出流水、BRAM异步控制、LUT方程和无可布线负载等提示，未降级或屏蔽。
- 使用此前已逐标识符审核的temporal行号命名映射后，2972/2973条DRC详情多重集相同。唯一不同为RTSTAT-10展示端点：两份均报告956个无负载net、633个listed nets/buses，但仅展示前15，当前15项与旧不同。不能据此宣称全部633项完全相同。REQP-1839/1840也各在20项截断；这些显示限制保留在JSON中。
- CDC：Critical0；CDC3 Info135、CDC9 Info5、CDC6 Warning6、CDC15 Warning6。152条完整显示行按源/目的时钟、深度、例外和端点比较，多重集与基线完全一致。CDC6对应既有CSI计数/控制跨域；CDC15仍含4项CSI PHY和2项pixel VIO隐藏路径。加密内部未被独立展开验证。
- bus skew：非空的42条约束全部MET，逐条requirement/actual/slack已核对，最小slack6.019ns、最大39.899ns；完整正文与基线一致。不是仅凭没有VIOLATED字符串判定通过。
- 新鲜methodology报告：Error0、Critical Warning0；PDRC190两项、TIMING9一项、TIMING18八项、XDCB5一项均为Warning。完整详情除明确的本地XDC路径前缀外与旧一致，未依赖timing报告内可能过时的methodology摘要。

## 时钟、引脚与复位

实际clock-source gate为PASSED：一个显示MMCM，pixel74.25MHz、serial371.25MHz，均追溯到100MHz FCLK0。HMI标记存在，且routed I/O确认TX=AH12、RX=AG12、LVCMOS33；KEY0=Y22、输入、LVCMOS33。日志在HMI之后继续完成两级KEY0 ASYNC_REG、16级pixel reset FDCE、6个camera HS端口及DIFF_TERM=false检查，成功close_design后才于00:40:28启动write_bitstream。这样确认后续检查实际执行，而不是只用HMI标记推断。

最终利用率与基线报告正文一致：LUT138026/277400=49.76%，FF206397/554800=37.20%，BRAM744.5/755=98.61%，DSP826/2020=40.89%。BRAM余量很小，时序通过不等于资源余量充裕。

旧对照八份报告及说明文件均已用Git blob核实属于公开提交a9ab041。八份新旧SHA、全部CDC显示端点、42条skew数值、DRC分类与剩余端点差异及实际gate日志行保存在[routed_reports_audit_01.json](routed_reports_audit_01.json)。读取报告的脚本为同名.py；只读取文件并新建本次审核输出，没有启动AMD工具或修改工程。

本审核时runner状态为running，guard状态为running且无termination。**这份审核只接受最终routed报告及上述检查，不声称BIT/XSA/LTX已交付、runner已终态、完整motion/ROI功能RTL仿真通过或新候选已上板。** 后续执行和交付物结论由独立终态回执确认。
