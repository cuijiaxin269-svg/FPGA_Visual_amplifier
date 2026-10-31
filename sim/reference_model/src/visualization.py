"""Headless, colorblind-safe plots. All axes state physical units."""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

COLORS = {'integer': '#0072B2', 'subpixel': '#D55E00'}
STYLES = {'integer': '--', 'subpixel': '-.'}
plt.rcParams.update({'font.size': 10, 'axes.grid': True, 'grid.alpha': 0.2, 'svg.fonttype': 'none'})

def save(fig, path):
    fig.savefig(path, dpi=300)
    fig.savefig(path.with_suffix('.svg'))
    plt.close(fig)

def plot_demo(t, true_position, detected, spectra, cfg, output):
    shown = t <= cfg.plot_seconds
    fig, axes = plt.subplots(2, 1, figsize=(10, 6), layout='constrained')
    for ax, index in zip(axes, (slice(None), shown)):
        ax.plot(t[index], (true_position-cfg.x0)[index], 'k-', label='True displacement', linewidth=1.2)
        for method, values in detected.items():
            ax.plot(t[index], (values-cfg.x0)[index], STYLES[method], color=COLORS[method], label=method)
        ax.set(xlabel='Time (s)', ylabel='Displacement from x0 (pixel)')
    axes[0].set_title('Decoded video: true and measured displacement')
    axes[0].legend(loc='upper left', bbox_to_anchor=(1, 1))
    axes[1].set_title(f'First {cfg.plot_seconds:g} s (detail)')
    save(fig, output/'displacement_comparison.png')
    fig, axes = plt.subplots(3, 1, figsize=(10, 8), layout='constrained')
    for method, values in detected.items():
        for ax, signal in zip(axes, (values, spectra[method].centered, spectra[method].windowed)):
            ax.plot(t, signal, STYLES[method], color=COLORS[method], label=method, linewidth=0.8)
    for ax, title in zip(axes, ('Raw edge position', 'DC removed (before optional detrend)', 'Processed signal with Hann window')):
        ax.set(xlabel='Time (s)', ylabel='Position / displacement (pixel)', title=title)
    axes[0].legend(loc='upper left', bbox_to_anchor=(1, 1))
    save(fig, output/'displacement_signal.png')
    fig, ax = plt.subplots(figsize=(10, 4.5), layout='constrained')
    for method, spectrum in spectra.items():
        ax.plot(spectrum.frequencies, spectrum.amplitudes, STYLES[method], color=COLORS[method], label=method)
        if spectrum.frequency_hz is not None:
            ax.plot(spectrum.frequency_hz, spectrum.peak_amplitude_px, 'o', color=COLORS[method], label=f'{method} peak: {spectrum.frequency_hz:.4f} Hz')
    ax.axvline(cfg.frequency_hz, color='k', linestyle=':', label=f'True: {cfg.frequency_hz:g} Hz')
    ax.set(xlabel='Frequency (Hz)', ylabel='Single-sided amplitude (pixel)', xlim=(0, cfg.fps/2), title=f'Hann spectrum; bin spacing = {cfg.fps/cfg.n_frames:.3f} Hz')
    ax.legend(loc='upper left', bbox_to_anchor=(1, 1))
    save(fig, output/'fft_spectrum.png')

def plot_sweep(rows, output, kind):
    if kind == 'noise':
        amplitudes = sorted({r['amplitude_px'] for r in rows}, reverse=True)
        fig, axes = plt.subplots(len(amplitudes), 2, figsize=(12, 4*len(amplitudes)), squeeze=False, layout='constrained')
        names = list(dict.fromkeys(r['noise_case'] for r in rows))
        for i, amplitude in enumerate(amplitudes):
            for j, metric in enumerate(('displacement_rmse_px', 'absolute_error_hz')):
                ax = axes[i, j]
                for method, marker, offset in [('integer', 'o', -0.12), ('subpixel', 'x', 0.12)]:
                    for k, name in enumerate(names):
                        rs = [r for r in rows if r['method'] == method and r['amplitude_px'] == amplitude and r['noise_case'] == name]
                        values = [r[metric] if r[metric] is not None else np.nan for r in rs]
                        ax.scatter(k+offset+np.linspace(-0.035, 0.035, len(values)), values, marker=marker, color=COLORS[method], label=method if k == 0 else None)
                ax.set_xticks(range(len(names)), [n.replace('_', '\n') for n in names], fontsize=8)
                ax.set(ylabel='Displacement RMSE (pixel)' if j == 0 else 'Frequency error (Hz)', title=f'Amplitude = {amplitude:g} pixel; all seed trials')
                ax.set_yscale('symlog', linthresh=0.01)
                numeric = [r[metric] for r in rows if r['amplitude_px'] == amplitude and r[metric] is not None]
                ax.set_ylim(-0.001, max(0.02, max(numeric, default=0)*2))
                ax.set_ylabel(ax.get_ylabel() + '; symlog')
                ax.legend(loc='upper left')
        fig.suptitle('Noise tests: all 3 seeds; missing estimates stay blank (see CSV); symlog linear below 0.01')
        save(fig, output/'noise_test.png')
        return
    key = 'true_frequency_hz' if kind == 'frequency' else 'amplitude_px'
    metrics = ('absolute_error_hz', 'displacement_rmse_px', 'frequency_success', 'displacement_reliable')
    fig, axes = plt.subplots(2, 2, figsize=(10, 7), layout='constrained')
    axes = axes.ravel()
    for method in ('integer', 'subpixel'):
        xs = sorted({r[key] for r in rows})
        for ax, metric in zip(axes, metrics):
            ys = []
            for x in xs:
                rs = [r for r in rows if r[key] == x and r['method'] == method]
                values = [r[metric] for r in rs if r[metric] is not None]
                ys.append(float(np.mean(values)) if values else np.nan)
                if metric != 'frequency_success':
                    ax.scatter([x]*len(values), values, color=COLORS[method], marker='o' if method == 'integer' else 'x', alpha=0.6, s=22)
            ax.plot(xs, ys, STYLES[method], color=COLORS[method], label=method)
            ax.set_xlabel('True frequency (Hz)' if kind == 'frequency' else 'Vibration amplitude (pixel, log scale)')
            if kind == 'amplitude':
                ax.set_xscale('log')
        axes[0].legend()
    for ax, label in zip(axes, ('Frequency error (Hz)', 'Displacement RMSE (pixel)', 'Frequency success fraction', 'Displacement reliable fraction')):
        ax.set_ylabel(label)
    errors = [r['absolute_error_hz'] for r in rows if r['absolute_error_hz'] is not None]
    axes[0].set_ylim(-0.0005, max(0.01, max(errors, default=0)*1.1))
    axes[2].set_ylim(-0.05, 1.05)
    axes[3].set_ylim(-0.05, 1.05)
    fig.suptitle(f'{kind.title()} sweep: lines = means; points = individual trials\nUndefined frequency estimates are omitted from error panel and count as failures')
    save(fig, output/f'{kind}_test.png')

def plot_micro(rows, output):
    amplitudes = sorted({r['amplitude_px'] for r in rows})[:3]
    fig, axes = plt.subplots(len(amplitudes), 1, figsize=(10, 2.6*len(amplitudes)), squeeze=False, layout='constrained')
    for ax, amplitude in zip(axes.ravel(), amplitudes):
        row = next(r for r in rows if r['amplitude_px'] == amplitude)
        with np.load(output/'traces'/f'{row["trial"]}.npz') as data:
            time = data['time_s']
            mask = time <= 0.4
            truth = data['true_position']-data['true_position'].mean()
            ax.plot(time[mask], truth[mask], 'k-', label='True')
            for method in ('integer', 'subpixel'):
                ac = data[method]-data[method].mean()
                ax.plot(time[mask], ac[mask], STYLES[method], color=COLORS[method], label=method, marker='o' if method == 'integer' else 'x', markersize=3)
        ax.set(xlabel='Time (s)', ylabel='Centered displacement (pixel)', title=f'Amplitude = {amplitude:g} pixel; first configured spatial offset')
    axes[0, 0].legend(loc='upper left', bbox_to_anchor=(1, 1))
    save(fig, output/'micro_displacement.png')
