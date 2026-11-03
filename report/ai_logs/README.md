# AI 协作记录

作者于 2026-11-03 确认整套系统已上板并可正常使用。当前收尾仅有 **HLS 验证、演示视频和 AI 协作记录**；本目录负责第三项，项目状态统一见 [当前待办](../submission_gaps.md)。

现有工程已经保存交接摘要、失败记录、修复说明和技能快照。[current_session_summary.md](current_session_summary.md) 是早期会话的用户原话摘录与助手处理摘要，其中的待办和发布状态属于当时记录，不代表当前项目状态。

现在需要补充真实的原始对话导出，保留与项目有关的提问、模型回答、纠错过程及必要工具结果。已有摘要可作检索入口，不能改写成原始对话，也不为补齐记录重新编造或重复执行实验。

| 主题 | 已有材料入口 |
|---|---|
| 工程接力与判断依据 | [历史交接记录](../../skill/references/original_handoff.txt) |
| 串口短包、未对齐访问、空闲中断 | [v18 说明](../original_notes/v18hmi/readme.txt)、[验收记录](../original_notes/v18hmi/acceptance.txt) |
| QSPI 传输失败、恢复与冷启动 | [v19 说明](../original_notes/v19boot/readme.txt)、[验收记录](../original_notes/v19boot/acceptance.txt)、[板端证据](../../board/results/v19boot/) |
| 2025.2 迁移 | [构建记录](../../build/reports/vivado_2025_2/README.md)、[证据索引](../evidence_index.md) |

可保留原始导出格式，或按主题整理为 UTF-8 Markdown/文本。保留真实时间及先后顺序，模型和工具版本仅填写可确认的信息，并关联相关源码或测试材料。公开前可脱敏个人信息，说明删减范围；影响技术判断的报错、失败与纠正过程应保留。
