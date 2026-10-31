# 可选 HLS 生成入口

主 Vivado 构建使用仓库中的已导出 IP。本目录用于进一步检查 C++ 或重新生成候选 IP，生成结果保存在独立目录，不自动替换 `src/ip/`。

`build_hls.tcl` 根据已有脚本调整相对路径，使用支持 `open_component` 的 Vitis HLS Tcl 环境。此次只做了 Tcl 语法完整性和输入路径检查，尚未在 HLS 工具中运行；具体 HLS 运行环境及结果仍需验证。已归档的 alpha50 历史 C 仿真实际使用 2021.2，其原脚本在 `archive/test_alpha50_2021.tcl.txt`。

## 配置

将下面的环境变量传给运行 `build_hls.tcl` 的 HLS 进程：

| 变量 | 默认值或要求 |
| --- | --- |
| `FPGA_HLS_TARGET` | `motion60_shared`；也支持 `clip_copy_checked`、`motion60_full_temporal_v2`、`roi256`、`spectrum256_pl` |
| `FPGA_HLS_MODE` | `csim`；可选 `synth` |
| `FPGA_HLS_OUTPUT_DIR` | 仓库下 `_build/hls/<target>_<mode>`；必须是尚不存在的新目录，可指定空间充足的磁盘 |
| `FPGA_HLS_VECTOR_DIR` | ROI 向量目录，默认 `_build/hls/roi256_vectors` |
| `FPGA_PYTHON` | 完整 Python 3 可执行文件路径；`motion60_shared` 的 `synth` 模式必填，用于保留原流程的 FIFO 地址寄存器约束 |

运动放大 `csim` 模式使用已有 128×96 的 alpha50 测试；`synth` 模式使用 1280×800。其余模块在综合前先运行已有 C 测试。这里没有新增 RTL 协同仿真通过的声明。

## ROI 参考数据

先安装 Python 和 NumPy，从仓库根运行：

```powershell
python -B build/scripts/hls/generate_roi_vectors.py
```

也可以通过 `--output` 指向其他磁盘的全新目录，并把同一路径交给 `FPGA_HLS_VECTOR_DIR`。生成器创建四帧 1280×800 的 RAW10 容器数据、参考结果和元数据，总计约 8.2 MB。新的输出目录保护用于防止覆盖已有测试数据。

此次已将迁移后的生成器与原生成器比较：四个输入二进制与 `expected.bin` 逐字节相同。该检查验证路径迁移，没有验证 HLS 计算结果或板上精度。

## 导出后的复核

`motion60_shared` 的历史导出流程带有 FIFO 地址寄存器 `DONT_TOUCH` 处理。本入口保留该步骤，并在生成模板不符合预期时停止。处理对象是导出目录中的 Verilog；使用其他压缩封装前须检查它是否包含处理后的内容。

当前封存 IP 还包含 alpha30→alpha50 的四处 Verilog 常量修补，详见 [来源报告](../../../report/hls_provenance.md)。本目录的 C++ 已含 alpha50 检查；重新 HLS 生成可能改变调度、资源及物理实现，须重新进行接口、数值、时序、资源和板端验证后才能选为正式 IP。

`archive/` 保留原始脚本的字节副本并附加 `.txt`。它们含旧目录及安装环境，用于来源追溯，不作为新仓库直接执行入口。
