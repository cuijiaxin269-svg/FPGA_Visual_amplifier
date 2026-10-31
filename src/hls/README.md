# HLS 源码与来源

本目录收集当前封存 IP 对应的已有 C++、头文件、测试和参考模型。算法源码按原字节复制，没有为整理目录更改计算流程。

| 目录 | 内容 | 来源 |
| --- | --- | --- |
| `motion60_shared/` | alpha 上限为 50 的多尺度运动放大；离线 temporal v2；检查型帧复制 | `v16alpha50` 的放大源码与 `ab12` 的离线/复制源码 |
| `roi256/` | 256×256 区域位移估计与测试 | `ab12/hls/roi256` |
| `spectrum256_pl/` | PL 频谱计算、环形缓存和测试 | `ab12/hls/spectrum256_pl` |
| `spectrum256/` | 频谱黄金参考、查表常量及参考测试 | `ab12/hls/spectrum256` |
| `clip_copy/` | 检查型复制测试复用的旧测试体 | `ab12/hls/clip_copy/test_clip_copy.cpp` |
| `tests/alpha50/` | alpha=30 的旧相位参考与 alpha=0/30/50 测试 | `alpha50_probe/sim` |
| `reference/` | ROI 测试向量使用的 Python 黄金参考 | `ab12/algorithm/motion60_spectrum.py` |
| `provenance/` | 历史 C 仿真、RTL 常量修补记录和本次收集检查 | 见各记录 |

主工程在 Vivado 中使用 `../ip/` 的已导出 IP。当前目录的完整重新 HLS 综合不属于这次目录整理已验证的结果。两条路线的区别及仍需验证的环节见 [HLS 来源报告](../../report/hls_provenance.md)。

可选的 HLS Tcl 入口位于 [build/scripts/hls](../../build/scripts/hls/README.md)。C++ 还需要 AMD HLS 提供的 `ap_int.h`、`hls_stream.h`、`hls_math.h` 等工具库；这些库由工具安装提供，不复制到本仓库。
