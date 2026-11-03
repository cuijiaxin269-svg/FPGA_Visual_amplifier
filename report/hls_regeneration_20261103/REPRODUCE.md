# 初始五项 HLS IP 重生成

从 [hls-validation-20261103 Release](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/tag/hls-validation-20261103) 获取 [完整初始 HLS 证据 ZIP](https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier/releases/download/hls-validation-20261103/hls_regeneration_evidence_20261103.zip)：

- 文件：`hls_regeneration_evidence_20261103.zip`
- 大小：**36,069,995 字节**
- SHA-256：`1517b58043683e6e360c38ef32b02e4fc1a216e88f3add1fb91e745cab53722a`

下载后，在新目录按 ZIP 内的 **`tools/reproduce_five_ip.md` 完整配方**顺序执行，并将 `$archivePath` 改为本机下载路径。本页同步展示该已核对配方，更新下载说明、示例下载路径和包的大小/SHA 校验；五项 C 仿真、生产综合/导出与 motion 候选封装命令沿用原入口，没有新增通用一键脚本。

输入基于公开基线 `a9ab041021c269b446be4e5aa00ae3141f01ec8d`。这是初始 HLS 证据及其重生成入口，不能把历史回执直接当作新运行成功。后续 RTL、系统实现和板级验证的最新范围见[本轮说明](README.md)；本页末尾保留的是初始配方自身的验证边界，不替代后续独立验收记录。归档完整性记录见[证据 ZIP 校验收据](deliverables/hls_regeneration_evidence_20261103.verification.json)。

证据包保留源码快照、脚本、测试、向量、回执和选定报告，**不包含完整的原 `syn`、`.autopilot`、`sim`、`impl` 运行状态**。解压后可以查阅已有结果；要再次运行，必须先在新目录重建组件。本步骤完整重跑五项初始 C 仿真与生产综合/导出，不是一键恢复已经完成的 RTL co-sim，也不重放全部失败尝试。

## 1. 软件与新工作区

本次实用环境为 Windows、Python 3.14、Vitis HLS/Vivado **2025.2**，Vitis build 6295257。`run_tcl.py` 和 `run_stage.py` 当前固定调用 `D:/tool/vivado/2025.2/Vitis/bin/vitis-run.bat`，**没有工具路径环境变量覆盖接口**。下面命令适用于该实际安装路径；其他安装位置应仅调整新工作区内 wrapper 的工具路径并记录修改与 SHA，不改冻结源码。本说明没有假设一个未实现的 tool-path 参数。

Python 包依赖按实际入口区分：

- **本页初始五项流程及候选封装**使用已冻结 ROI 向量；`run_tcl.py`、`run_stage.py`、motion FIFO 后处理和 `package_motion_candidate.py` 均只依赖 Python 标准库，无需额外安装 NumPy 或 psutil。
- **可选重新生成 ROI 向量**的 `source_snapshot/build/scripts/hls/generate_roi_vectors.py` 及其同快照 `src/hls/reference/motion60_spectrum.py` 需要 NumPy。本页不运行该生成器，也不以新黄金文件替换冻结向量。
- **可选 RTL 资源监控** `tools/watch_sim_resources.py` 需要 psutil。它属于额外 RTL 流程，不是下面五项初始命令的依赖。

新工作目录使用短、无空格路径：无空格是已验证 include 修复的条件；短目录可避开本次 temporal 导出实际遇到的 Windows 长路径问题。`tools/build_hls_verified.tcl` 从自己的位置定位 `../source_snapshot`，因此下面的根目录可以迁移。

```powershell
$archivePath = 'D:/Download/hls_regeneration_evidence_20261103.zip' # 改为实际下载位置
$evidenceRoot = 'D:/hls_evidence_20261103'
$hlsRerunRoot = 'D:/hls_repro_20261103'
$vitisRun = 'D:/tool/vivado/2025.2/Vitis/bin/vitis-run.bat'
$vivadoRun = 'D:/tool/vivado/2025.2/Vivado/bin/vivado.bat'

if (-not (Test-Path -LiteralPath $archivePath -PathType Leaf)) { throw '请先下载初始证据 ZIP，并设置本机下载路径' }
$expectedArchiveSha256 = '1517b58043683e6e360c38ef32b02e4fc1a216e88f3add1fb91e745cab53722a'
if ((Get-Item -LiteralPath $archivePath).Length -ne 36069995 -or
    (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $expectedArchiveSha256) {
    throw '下载包大小或 SHA-256 不匹配；停止解压和运行'
}
if (-not (Test-Path -LiteralPath $vitisRun -PathType Leaf)) { throw '缺少本配方所需的 Vitis 2025.2 安装路径' }
if ((Test-Path -LiteralPath $evidenceRoot) -or (Test-Path -LiteralPath $hlsRerunRoot)) { throw '请改用两个尚不存在的新目录' }
py -3.14 --version
if ($LASTEXITCODE -ne 0) { throw '需要 Python 3.14' }

Expand-Archive -LiteralPath $archivePath -DestinationPath $evidenceRoot
New-Item -ItemType Directory -Path $hlsRerunRoot | Out-Null
foreach ($name in @('tools', 'tests', 'vectors')) {
    Copy-Item -LiteralPath "$evidenceRoot/$name" -Destination "$hlsRerunRoot/$name" -Recurse
}
foreach ($name in @('source_manifest.json', 'source_snapshot.zip')) {
    Copy-Item -LiteralPath "$evidenceRoot/$name" -Destination "$hlsRerunRoot/$name"
}
Expand-Archive -LiteralPath "$hlsRerunRoot/source_snapshot.zip" -DestinationPath "$hlsRerunRoot/source_snapshot"
```

不把旧 `runs/`、`receipts/`、`logs/`、候选目录或完成标记复制进重跑目录。`tests/` 包含额外全尺寸/分组测试的输入合同；本节初始五项入口直接使用冻结快照里的原 TB。ROI 使用证据包中的 `input0.bin`…`input3.bin` 和 `expected.bin`，不要用重生成黄金文件代替它们。`source_manifest.json` 中原绝对 `snapshot_root` 是历史来源，实际逐文件相对路径不变，不必改写该清单。

下载校验通过后，再核对解出的冻结文件。初始 ZIP 的历史 CRC 与逐文件解压核验见上述归档收据；新的运行结果必须保存自己的回执和哈希。

```powershell
$sourceManifest = Get-Content -LiteralPath "$hlsRerunRoot/source_manifest.json" -Raw | ConvertFrom-Json
foreach ($entry in $sourceManifest.files) {
    $sourceFile = Join-Path "$hlsRerunRoot/source_snapshot" $entry.path
    if (-not (Test-Path -LiteralPath $sourceFile -PathType Leaf)) { throw "缺少冻结文件：$($entry.path)" }
    $actualHash = (Get-FileHash -LiteralPath $sourceFile -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actualHash -ne $entry.sha256 -or (Get-Item -LiteralPath $sourceFile).Length -ne $entry.bytes) {
        throw "冻结文件不匹配：$($entry.path)"
    }
}
```

## 2. 五项初始 C 仿真

使用修正入口 `tools/build_hls_verified.tcl`，不是仍用于证据留存的旧错误入口。修正仅为相对快照定位及去除本机 `-I` 路径里的内嵌引号，记录见 `tools/build_entry_fix.patch/.json`；C++ 未改。以下所有调用串行执行，任一步失败即停止。

```powershell
$buildEntry = "$hlsRerunRoot/tools/build_hls_verified.tcl"
$jobs = @(
    @{ Target='clip_copy_checked';          C='c01'; Production='copy01' },
    @{ Target='spectrum256_pl';             C='c02'; Production='spec01' },
    @{ Target='roi256';                     C='c03'; Production='roi01' },
    @{ Target='motion60_full_temporal_v2';   C='c04'; Production='t03' },
    @{ Target='motion60_shared';            C='c05'; Production='m02' }
)

foreach ($job in $jobs) {
    $runName = '{0}_csim_repro01' -f $job.Target
    $marker = 'HLS_LOCAL_RUN_COMPLETED target={0} mode=csim' -f $job.Target
    py -3.14 -B "$hlsRerunRoot/tools/run_tcl.py" --name $runName --script $buildEntry --marker $marker `
        --set "FPGA_HLS_TARGET=$($job.Target)" --set 'FPGA_HLS_MODE=csim' `
        --set "FPGA_HLS_OUTPUT_DIR=$hlsRerunRoot/runs/$($job.C)" `
        --set "FPGA_HLS_VECTOR_DIR=$hlsRerunRoot/vectors"
    if ($LASTEXITCODE -ne 0) { throw "C 仿真失败，保留回执和日志：$runName" }
}
```

wrapper 自动将 `FPGA_PYTHON` 设为当前 Python 解释器，设置新目录的 `TEMP`/`TMP` 和 `OMP_NUM_THREADS=1`，并保存实际脚本 SHA 快照、命令、日志、退出码和完成标记。目标/模式/输出/ROI 向量目录通过上述 `FPGA_*` 参数传入；`--set` 不接受任意普通环境变量。

这里 motion 初始 C 仿真仍为 **128×96 alpha50** 套件，不是生产尺寸验证。已有额外 `motion_fullsize_csim_01` 和 RTL 分组有独立范围，不混入“五项初始 C 仿真”的定义。

## 3. 五项生产配置综合与导出

继续使用上面的新根目录和 `$jobs`，各生产输出与 C 仿真目录不同。时钟 6.666667 ns、器件 `xc7z100ffg900-2` 由已核对入口固定；motion 生产编译宏为 1280×800。

```powershell
foreach ($job in $jobs) {
    $runName = '{0}_synth_repro01' -f $job.Target
    $marker = 'HLS_LOCAL_RUN_COMPLETED target={0} mode=synth' -f $job.Target
    py -3.14 -B "$hlsRerunRoot/tools/run_tcl.py" --name $runName --script $buildEntry --marker $marker `
        --set "FPGA_HLS_TARGET=$($job.Target)" --set 'FPGA_HLS_MODE=synth' `
        --set "FPGA_HLS_OUTPUT_DIR=$hlsRerunRoot/runs/$($job.Production)" `
        --set "FPGA_HLS_VECTOR_DIR=$hlsRerunRoot/vectors"
    if ($LASTEXITCODE -ne 0) { throw "生产综合/导出失败，保留回执和日志：$runName" }
}
```

非 motion 的四项在 synth 模式内会再次执行原 Csim，再进行 `csynth_design` 和 `export_design -format ip_catalog`；motion 生产 synth 分支没有 TB，不进行生产全尺寸 Csim。这样不会将小尺寸 C 仿真误写成生产尺寸 C/RTL 已通过。

| 目标 | 新生产组件 | 导出位置 |
| --- | --- | --- |
| clip_copy_checked | `runs/copy01` | `runs/copy01/hls/impl/ip/` |
| spectrum256_pl | `runs/spec01` | `runs/spec01/hls/impl/ip/` |
| roi256 | `runs/roi01` | `runs/roi01/hls/impl/ip/` |
| clip_temporal_full | `runs/t03` | `runs/t03/hls/impl/ip/` |
| motion60_shared | `runs/m02` | `runs/m02/hls/impl/ip/` |

每项综合报告位于组件下 `hls/syn/report/`，导出目录包含 component.xml、HDL、驱动及原 vendor ZIP。成功以新 `receipts/*_repro01.json` 的退出码 0 和实际完成标记为准；保留报告中的 Timing Violation、II 和 undef 等警告。再次重跑须改根目录或同时改回执名、C/生产输出名；脚本拒绝覆盖旧产物。

## 4. motion 导出后修正与候选封装的顺序

motion 的 synth 入口先生成原 vendor ZIP，再调用冻结脚本 `source_snapshot/build/scripts/hls/preserve_motion60_fifo_address.py` 检查并补上导出 Verilog FIFO 的两个地址 `DONT_TOUCH` 属性。入口完成标记在这个检查之后。**原 vendor ZIP 不会自动刷新为修正后的目录内容**，不能把它作为最终修正候选 ZIP。

后续是已有的三阶段工具：复制修正后导出到新的候选目录 → Vivado 2025.2 刷新 IP-XACT checksum 并检查完整性 → 对新日志的警告完成审核后 finalize。准备与元数据刷新的具体入口如下；它们应在五项重任务结束后串行执行。

```powershell
$motionExport = "$hlsRerunRoot/runs/m02/hls/impl/ip"
$motionVendorZip = "$motionExport/xilinx_com_hls_motion60_shared_1_0.zip"
$motionCandidate = "$hlsRerunRoot/candidates/motion_repro01"
py -3.14 -B "$hlsRerunRoot/tools/package_motion_candidate.py" prepare `
    --export-dir $motionExport --vendor-zip $motionVendorZip --label motion_repro01
if ($LASTEXITCODE -ne 0) { throw '候选准备失败；保留新目录，不覆盖重试' }

if (-not (Test-Path -LiteralPath $vivadoRun -PathType Leaf)) { throw '缺少 Vivado 2025.2' }
& $vivadoRun -mode batch -nojournal -log "$motionCandidate/metadata_refresh.log" `
    -source "$hlsRerunRoot/tools/refresh_motion_candidate.tcl" -tclargs $motionCandidate
$refreshExit = $LASTEXITCODE
if ($refreshExit -ne 0) { throw '候选元数据刷新失败；保留日志' }
```

如新日志有 Critical warnings，finalize 必须使用**绑定这次候选路径、实际日志 SHA、当前 component SHA 及全部诊断**的新审核 JSON。旧 `comparisons/motion_candidate_warning_review.json` 不可复用。现有 `review_motion_package_warnings.py` 是原 m01 的一次性审核脚本，含原 candidate/log/封存 component.xml 的固定路径；它不是可迁移的通用 CLI，不能直接在新根目录当作已完成审核。新的审核需基于新日志/元数据实际完成，保留所用基线及路径修改记录。

审核已实际完成后，已有 finalize 命令为：

```powershell
$newDiagnosticReview = "$hlsRerunRoot/comparisons/motion_repro01_warning_review.json"
if (-not (Test-Path -LiteralPath $newDiagnosticReview -PathType Leaf)) { throw '尚缺这次运行的实际警告审核文件' }
py -3.14 -B "$hlsRerunRoot/tools/package_motion_candidate.py" finalize `
    --candidate-root $motionCandidate --vivado-log "$motionCandidate/metadata_refresh.log" `
    --vivado-exit-code $refreshExit --diagnostic-review $newDiagnosticReview
if ($LASTEXITCODE -ne 0) { throw '候选封装未通过；保留失败证据' }
```

这是条件性候选封装流程，不是用一个空文件或旧收据补齐新审核。若本机新日志没有 Critical warnings，可使用不带 `--diagnostic-review` 的同一 finalize 接口；仍须实际 Vivado 成功日志、明确 integrity-pass 消息且无 ERROR。具体核验条件见 `tools/motion_candidate_packaging.md`。本次历史候选为 9 Critical/31 Warning，不能假定新运行诊断完全相同。

五项生产重生成到第 3 步可从本证据输入完成；独立的修正 motion ZIP 还需第 4 步的新日志审核。`package_five_ip_candidates.py` 是本次固定组件名和固定 motion archive SHA 的交付收集器，不是以上新组件名的通用打包 CLI，不能对新运行直接照抄使用。

新目录生成的报告、元数据和 ZIP 应记录新的文件清单与 SHA，不把本次产物的哈希或通过收据复制为新运行结果。

## 5. RTL 复现范围

完整 RTL 重跑必须在新生产组件完成后，重新生成适合这些新路径的保护配置、克隆/owner 绑定、C audit/fixture 与哈希合同，再按选定范围运行。证据包中的旧 clone receipts、绝对 config 路径和旧完成结果用于审计，不能套到新组件。仅复制选定报告无法恢复原模拟器状态。

copy 的独立相邻关系覆盖、temporal 的 depth=15360、ROI 的 reference 状态分组及 motion 的 cold/warm C-state 链各有独立验收条件；原无中断事务序列、完整生产内存范围、VHDL、FIFO 导出后改动、实现时序和板测限制仍适用。本配方不自动运行 RTL 或修改正式仓库，也不使候选变成生产已验收 IP。
