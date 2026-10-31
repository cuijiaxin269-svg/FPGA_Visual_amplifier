"""End-to-end sweeps: every trial writes and decodes a real MP4."""
import csv
from dataclasses import asdict, replace
import json
import platform
from pathlib import Path
import tempfile
import cv2
import numpy as np
from .generate_video import generate_video
from .edge_detector import detect_video
from .fft_analysis import analyze

def write_csv(path, rows):
    with path.open('w', newline='', encoding='utf-8-sig') as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)

def measure(cfg, output, trial, extra=None):
    # TemporaryDirectory removes only this trial's generated movie after decoding.
    with tempfile.TemporaryDirectory(prefix='vibration_') as directory:
        video = Path(directory)/'trial.mp4'
        t, truth, _ = generate_video(cfg, video)
        detected, fps = detect_video(video, cfg, ('integer', 'subpixel'))
    trace_dir = output/'traces'
    trace_dir.mkdir(exist_ok=True)
    np.savez_compressed(trace_dir/f'{trial}.npz', time_s=t, true_position=truth, **detected)
    (trace_dir/f'{trial}.json').write_text(json.dumps(asdict(cfg), indent=2), encoding='utf-8')
    rows = []
    true_ac = truth-truth.mean()
    for method, positions in detected.items():
        s = analyze(positions, fps, cfg.detrend, cfg.min_signal_std_px, cfg.min_peak_fraction)
        ac = positions-positions.mean()
        rmse = float(np.sqrt(np.mean((ac-true_ac)**2)))
        position_rmse = float(np.sqrt(np.mean((positions-truth)**2)))
        normalized = rmse/float(np.sqrt(np.mean(true_ac**2))) if cfg.amplitude_px > 0 else None
        error = abs(s.frequency_hz-cfg.frequency_hz) if s.frequency_hz is not None and cfg.amplitude_px > 0 else None
        frequency_ok = error is not None and error <= cfg.frequency_tolerance_hz and s.status == 'ok'
        rows.append(dict(trial=trial, method=method, true_frequency_hz=cfg.frequency_hz,
            estimated_frequency_hz=s.frequency_hz, peak_bin_hz=s.peak_bin_hz,
            absolute_error_hz=error, relative_error_pct=100*error/cfg.frequency_hz if error is not None else None,
            amplitude_px=cfg.amplitude_px, x0_px=cfg.x0, seed=cfg.seed,
            displacement_rmse_px=rmse, position_rmse_px=position_rmse,
            position_bias_px=float(np.mean(positions-truth)), normalized_rmse=normalized,
            peak_amplitude_px=s.peak_amplitude_px, peak_fraction=s.peak_fraction, status=s.status,
            frequency_success=frequency_ok,
            displacement_reliable=bool(frequency_ok and normalized <= cfg.max_normalized_rmse),
            false_positive=bool(cfg.amplitude_px == 0 and s.status == 'ok'),
            fps=fps, n_frames=len(t), bin_spacing_hz=fps/len(t), **(extra or {})))
    errors = ', '.join(f'{r["method"]}: {r["estimated_frequency_hz"]}, {r["status"]}' for r in rows)
    print(f'{trial}: {errors}', flush=True)
    return rows

def run_experiments(cfg, output, stage='all'):
    from .visualization import plot_sweep, plot_micro
    base = replace(cfg, gaussian_std=0, brightness_amplitude=0, impulse_probability=0)
    (output/'environment.json').write_text(json.dumps(dict(python=platform.python_version(), numpy=np.__version__, opencv=cv2.__version__, platform=platform.platform()), indent=2), encoding='utf-8')
    if stage in ('all', 'frequency'):
        rows = []
        for index, f in enumerate(cfg.frequencies_hz):
            rows += measure(replace(base, frequency_hz=f), output, f'frequency_{index:02d}')
        write_csv(output/'frequency_test.csv', rows)
        plot_sweep(rows, output, 'frequency')
        # Non-bin-centered frequencies expose interpolation accuracy; zero-motion
        # controls expose false peaks instead of assuming every FFT means vibration.
        controls = []
        for index, f in enumerate((7.13, 10.07, 23.37)):
            if f < cfg.fps/2:
                controls += measure(replace(base, frequency_hz=f), output, f'control_offbin_{index}', dict(control='off_bin'))
        controls += measure(replace(base, amplitude_px=0), output, 'control_stationary', dict(control='stationary_clean'))
        for seed in cfg.noise_seeds:
            controls += measure(replace(base, amplitude_px=0, gaussian_std=15, seed=seed), output, f'control_stationary_{seed}', dict(control='stationary_noise'))
        write_csv(output/'control_test.csv', controls)
    if stage in ('all', 'amplitude'):
        rows = []
        for index, amplitude in enumerate(cfg.amplitudes_px):
            for phase_index, offset in enumerate(cfg.spatial_offsets_px):
                rows += measure(replace(base, amplitude_px=amplitude, x0=cfg.x0+offset), output,
                    f'amplitude_{index:02d}_offset_{phase_index}', dict(spatial_offset_px=offset))
        write_csv(output/'amplitude_test.csv', rows)
        plot_sweep(rows, output, 'amplitude')
        plot_micro(rows, output)
    if stage in ('all', 'noise'):
        rows = []
        for amplitude_index, amplitude in enumerate(cfg.noise_amplitudes_px):
            for case_index, case in enumerate(cfg.noise_cases):
                params = {k: v for k, v in case.items() if k != 'name'}
                for seed in cfg.noise_seeds:
                    rows += measure(replace(base, amplitude_px=amplitude, seed=seed, **params), output,
                        f'noise_a{amplitude_index}_c{case_index}_{seed}', dict(noise_case=case['name'], **params))
                    # Checkpoint after every trial: failures are not silently discarded.
                    write_csv(output/'noise_test.csv', rows)
        plot_sweep(rows, output, 'noise')
    if all((output/f'{name}_test.csv').exists() for name in ('frequency', 'amplitude', 'noise')):
        write_report(output, cfg)

def write_report(output, cfg):
    def read(name):
        with (output/f'{name}_test.csv').open(encoding='utf-8-sig') as stream:
            return list(csv.DictReader(stream))
    frequency, amplitude, noise = (read(name) for name in ('frequency', 'amplitude', 'noise'))
    lines = ['# 实际运行结果', '', '数据来源：本目录 CSV；所有测试均经过视频编码/解码。空频率/误差表示无可检测信号，不能当作零误差。', '',
        f'可靠频率判据：status=ok 且误差 ≤ {cfg.frequency_tolerance_hz} Hz；位移可靠还要求去均值位移 RMSE / 真值 RMS ≤ {cfg.max_normalized_rmse}。', '',
        '## 频率扫描', '', '|真实 Hz|方法|估计 Hz|绝对误差 Hz|位移 RMSE pixel|', '|---|---|---|---|---|']
    for r in frequency:
        lines.append(f'|{r["true_frequency_hz"]}|{r["method"]}|{float(r["estimated_frequency_hz"]):.6f}|{float(r["absolute_error_hz"]):.6f}|{float(r["displacement_rmse_px"]):.6f}|' if r['estimated_frequency_hz'] else f'|{r["true_frequency_hz"]}|{r["method"]}|无信号|—|{r["displacement_rmse_px"]}|')
    lines += ['', '## 幅度扫描（三种空间偏移；通过数 / 实验数）', '', '|振幅 pixel|方法|频率通过|位移可靠|最大位移 RMSE pixel|', '|---|---|---|---|---|']
    for a in sorted({float(r['amplitude_px']) for r in amplitude}, reverse=True):
        for method in ('integer', 'subpixel'):
            rs = [r for r in amplitude if float(r['amplitude_px']) == a and r['method'] == method]
            lines.append(f'|{a:g}|{method}|{sum(r["frequency_success"] == "True" for r in rs)}/{len(rs)}|{sum(r["displacement_reliable"] == "True" for r in rs)}/{len(rs)}|{max(float(r["displacement_rmse_px"]) for r in rs):.6f}|')
    lines += ['', '## 噪声扫描（3 个随机种子；最大值包括失败案例）', '', '|振幅|噪声|方法|频率通过|最大 RMSE pixel|最大频率误差 Hz|', '|---|---|---|---|---|---|']
    for a in sorted({float(r['amplitude_px']) for r in noise}, reverse=True):
        for name in dict.fromkeys(r['noise_case'] for r in noise):
            for method in ('integer', 'subpixel'):
                rs = [r for r in noise if float(r['amplitude_px']) == a and r['noise_case'] == name and r['method'] == method]
                errors = [float(r['absolute_error_hz']) for r in rs if r['absolute_error_hz']]
                maximum = f'{max(errors):.6f}' if errors else '无信号'
                lines.append(f'|{a:g}|{name}|{method}|{sum(r["frequency_success"] == "True" for r in rs)}/{len(rs)}|{max(float(r["displacement_rmse_px"]) for r in rs):.6f}|{maximum}|')
    lines += ['', '这些通过数仅描述当前仿真条件，不是统计置信度，也不是实物摄像头的检测下限。', 'MP4 有损压缩、ROI 160 行平均、理想直边与强对比度均影响本次结果。', '指定频率恰好落在 0.2 Hz FFT 频点；应同时查看 control_test.csv 的非整数频点和静止对照。']
    (output/'TEST_REPORT.md').write_text('\n'.join(lines)+'\n', encoding='utf-8')
