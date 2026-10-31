from dataclasses import dataclass
import numpy as np
from .signal_processing import preprocess

@dataclass
class Spectrum:
    frequencies: np.ndarray
    amplitudes: np.ndarray
    centered: np.ndarray
    windowed: np.ndarray
    frequency_hz: float | None
    peak_bin_hz: float | None
    peak_amplitude_px: float
    peak_fraction: float
    status: str

def analyze(positions, fps, detrend=False, min_std=1e-6, min_peak_fraction=0.25):
    if not np.isfinite(fps) or fps <= 0:
        raise ValueError('fps must be positive and finite')
    centered, processed, window, windowed = preprocess(positions, detrend)
    amplitudes = np.abs(np.fft.rfft(windowed))/window.sum()
    amplitudes[1:-1 if len(positions) % 2 == 0 else None] *= 2
    frequencies = np.fft.rfftfreq(len(positions), 1/fps)
    if np.std(processed) <= min_std:
        return Spectrum(frequencies, amplitudes, centered, windowed, None, None, 0, 0, 'no_signal')
    peak = int(np.argmax(amplitudes[1:]))+1  # never search DC
    power = np.abs(np.fft.rfft(windowed))**2
    fraction = float(power[max(1, peak-1):peak+2].sum()/power[1:].sum())
    status = 'ok' if fraction >= min_peak_fraction else 'low_confidence'
    # Keep raw bin as well as a three-bin log-spectrum interpolation.
    delta = 0.0
    if 1 < peak < len(amplitudes)-1:
        a, b, c = np.log(np.maximum(amplitudes[peak-1:peak+2], 1e-300))
        denominator = a-2*b+c
        if denominator < -1e-12:
            delta = float(np.clip(0.5*(a-c)/denominator, -0.5, 0.5))
    frequency = float((peak+delta)*fps/len(positions))
    return Spectrum(frequencies, amplitudes, centered, windowed, frequency, float(frequencies[peak]), float(amplitudes[peak]), fraction, status)
