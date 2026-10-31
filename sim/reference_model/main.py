"""Run the minimal chain first: py main.py --stage baseline."""
import argparse
from dataclasses import asdict
import json
import numpy as np
from config import ROOT, load_config
from src.generate_video import generate_video
from src.edge_detector import detect_video
from src.fft_analysis import analyze
from src.visualization import plot_demo

def run_demo(cfg, output, baseline=False):
    output.mkdir(parents=True, exist_ok=True)
    t, truth, displacement = generate_video(cfg, output/'simulation_video.mp4', output/'ground_truth.npz')
    if output.resolve() == (ROOT/'results').resolve():
        import shutil
        (ROOT/'data').mkdir(exist_ok=True)
        shutil.copyfile(output/'ground_truth.npz', ROOT/'data'/'ground_truth.npz')
    methods = ('integer',) if baseline else ('integer', 'subpixel')
    detected, fps = detect_video(output/'simulation_video.mp4', cfg, methods)
    spectra = {}
    summary = {}
    for method, positions in detected.items():
        s = analyze(positions, fps, cfg.detrend, cfg.min_signal_std_px, cfg.min_peak_fraction)
        spectra[method] = s
        error = abs(s.frequency_hz-cfg.frequency_hz) if s.frequency_hz is not None else None
        rmse = float(np.sqrt(np.mean(((positions-positions.mean())-(truth-truth.mean()))**2)))
        summary[method] = dict(true_frequency_hz=cfg.frequency_hz, estimated_frequency_hz=s.frequency_hz, frequency_error_hz=error, displacement_rmse_px=rmse, status=s.status)
        print(f'[{method}] True frequency = {cfg.frequency_hz:.3f} Hz', flush=True)
        print(f'Estimated frequency = {s.frequency_hz:.6f} Hz; Frequency error = {error:.6f} Hz; RMSE = {rmse:.6f} pixel' if error is not None else f'Estimated frequency = unavailable ({s.status})', flush=True)
    np.savetxt(output/'displacement.csv', np.column_stack([t, truth, displacement]+[detected[m] for m in methods]), delimiter=',', header=','.join(['time_s','position_true_px','displacement_true_px']+[f'position_{m}_px' for m in methods]), comments='')
    (output/'config_used.json').write_text(json.dumps(asdict(cfg), indent=2), encoding='utf-8')
    (output/'demo_summary.json').write_text(json.dumps(summary, indent=2), encoding='utf-8')
    plot_demo(t, truth, detected, spectra, cfg, output)
    if not baseline:
        from src.render_video import render_processed
        render_processed(cfg, output, detected)
    return summary

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--config', help='Optional JSON override file; omitted fields use config.py defaults')
    parser.add_argument('--stage', choices=['baseline', 'demo', 'all', 'frequency', 'amplitude', 'noise'], default='all')
    parser.add_argument('--output', type=str, default=str(ROOT/'results'))
    args = parser.parse_args()
    from pathlib import Path
    cfg, output = load_config(args.config), Path(args.output).resolve()
    output.mkdir(parents=True, exist_ok=True)
    (output/'config_used.json').write_text(json.dumps(asdict(cfg), indent=2), encoding='utf-8')
    if args.stage in ('baseline', 'demo', 'all'):
        run_demo(cfg, output, args.stage == 'baseline')
    if args.stage in ('all', 'frequency', 'amplitude', 'noise'):
        from src.experiments import run_experiments
        run_experiments(cfg, output, args.stage)

if __name__ == '__main__':
    main()
