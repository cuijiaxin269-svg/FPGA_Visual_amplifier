"""Replot recorded outputs, useful for visual QA without regenerating videos."""
import argparse
import csv
from pathlib import Path
import numpy as np
from config import ROOT, load_config
from src.fft_analysis import analyze
from src.visualization import plot_demo, plot_sweep, plot_micro

def read_rows(path):
    with path.open(encoding='utf-8-sig') as stream:
        raw = list(csv.DictReader(stream))
    rows = []
    for item in raw:
        row = {}
        for key, value in item.items():
            if value in ('True', 'False'):
                row[key] = value == 'True'
            elif value == '':
                row[key] = None
            else:
                try:
                    row[key] = float(value)
                except ValueError:
                    row[key] = value
        rows.append(row)
    return rows

def replot(output):
    cfg = load_config(output/'config_used.json')
    data = np.genfromtxt(output/'displacement.csv', delimiter=',', names=True)
    detected = {method: data[f'position_{method}_px'] for method in ('integer', 'subpixel') if f'position_{method}_px' in data.dtype.names}
    spectra = {method: analyze(values, cfg.fps, cfg.detrend, cfg.min_signal_std_px, cfg.min_peak_fraction) for method, values in detected.items()}
    plot_demo(data['time_s'], data['position_true_px'], detected, spectra, cfg, output)
    for kind in ('frequency', 'amplitude', 'noise'):
        path = output/f'{kind}_test.csv'
        if path.exists():
            rows = read_rows(path)
            plot_sweep(rows, output, kind)
            if kind == 'amplitude':
                plot_micro(rows, output)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', type=Path, default=ROOT/'results')
    replot(parser.parse_args().output)
