"""Detection consumes decoded images only; it has no access to ground truth."""
import cv2
import numpy as np

def locate_edge(frame, roi, radius=4, subpixel=False):
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY) if frame.ndim == 3 else frame
    x, y, w, h = roi
    if min(x, y) < 0 or w < 3 or h < 1 or x+w > gray.shape[1] or y+h > gray.shape[0]:
        raise ValueError('ROI outside decoded image')
    profile = gray[y:y+h, x:x+w].astype(np.float64).mean(axis=0)
    # Central difference lives at integer pixel centers: no hidden half-pixel offset.
    gradient = np.abs((profile[2:] - profile[:-2])/2)
    peak = int(np.argmax(gradient)) + 1
    if gradient[peak-1] <= 1e-12:
        raise ValueError('No visible edge in ROI')
    integer_x = float(x+peak)
    if not subpixel:
        return integer_x
    lo, hi = max(1, peak-radius), min(w-2, peak+radius)
    coordinates = np.arange(lo, hi+1)
    weights = gradient[coordinates-1]
    return float(x + np.dot(coordinates, weights)/weights.sum())

def detect_video(path, cfg, methods=('integer',)):
    if not methods or set(methods) - {'integer', 'subpixel'}:
        raise ValueError('Methods must be integer and/or subpixel')
    capture = cv2.VideoCapture(str(path))
    if not capture.isOpened():
        raise RuntimeError(f'Cannot read video: {path}')
    fps = capture.get(cv2.CAP_PROP_FPS)
    results = {method: [] for method in methods}
    try:
        while True:
            ok, frame = capture.read()
            if not ok:
                break
            for method in methods:
                results[method].append(locate_edge(frame, cfg.roi, cfg.centroid_radius, method == 'subpixel'))
    finally:
        capture.release()
    if any(len(values) != cfg.n_frames for values in results.values()):
        raise RuntimeError(f'Decoded frame count does not match {cfg.n_frames}')
    if not np.isclose(fps, cfg.fps, rtol=1e-4):
        raise RuntimeError(f'Video fps mismatch: {fps} != {cfg.fps}')
    return {key: np.asarray(values) for key, values in results.items()}, fps
