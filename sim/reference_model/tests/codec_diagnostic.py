"""Reproduce the 0.1 pixel codec limitation: py -m tests.codec_diagnostic."""
from dataclasses import replace
from pathlib import Path
import tempfile
import numpy as np
from config import Config, ROOT
from src.generate_video import generate_video, theoretical_motion
from src.edge_detector import detect_video, locate_edge
from src.fft_analysis import analyze
from src.experiments import write_csv

def main():
    cfg = replace(Config(), amplitude_px=0.1, duration_s=1)
    _, truth, _ = theoretical_motion(cfg)
    offsets = (np.arange(cfg.pixel_samples)+0.5)/cfg.pixel_samples-0.5
    pixel_x = np.arange(cfg.width)[:, None]+offsets
    traces = {}
    for quantized in (False, True):
        positions = []
        for x in truth:
            coverage = (0.5+0.5*np.tanh((pixel_x-x)/cfg.blur_scale_px)).mean(axis=1)
            row = cfg.dark_level+(cfg.bright_level-cfg.dark_level)*coverage
            if quantized:
                row = np.rint(row).astype(np.uint8)
            positions.append(locate_edge(np.broadcast_to(row, (cfg.height, cfg.width)), cfg.roi, cfg.centroid_radius, True))
        traces['raw_uint8' if quantized else 'raw_float'] = np.array(positions)
    with tempfile.TemporaryDirectory() as folder:
        for codec, suffix in [('mp4v', 'mp4'), ('FFV1', 'avi')]:
            current = replace(cfg, codec=codec)
            path = Path(folder)/f'trial.{suffix}'
            generate_video(current, path)
            traces[codec] = detect_video(path, current, ('subpixel',))[0]['subpixel']
    rows = []
    for name, x in traces.items():
        rmse = float(np.sqrt(np.mean(((x-x.mean())-(truth-truth.mean()))**2)))
        s = analyze(x, cfg.fps)
        rows.append(dict(source=name, displacement_rmse_px=rmse, estimated_frequency_hz=s.frequency_hz, peak_amplitude_px=s.peak_amplitude_px))
        print(rows[-1])
    (ROOT/'results').mkdir(exist_ok=True)
    write_csv(ROOT/'results'/'codec_diagnostic.csv', rows)

if __name__ == '__main__':
    main()
