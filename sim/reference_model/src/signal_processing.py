import numpy as np

def preprocess(positions, detrend=False):
    x = np.asarray(positions, dtype=np.float64)
    if x.ndim != 1 or len(x) < 8 or not np.isfinite(x).all():
        raise ValueError('Need a finite 1-D sequence with at least 8 samples')
    centered = x-x.mean()
    processed = centered.copy()
    if detrend:
        t = np.arange(len(x), dtype=float)
        t -= t.mean()
        processed -= np.dot(t, processed)/np.dot(t, t)*t
    # Periodic Hann: appropriate for an N-point DFT, coherent gain = 1/2.
    window = 0.5 - 0.5*np.cos(2*np.pi*np.arange(len(x))/len(x))
    return centered, processed, window, processed*window
