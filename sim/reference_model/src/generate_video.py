"""Render continuous moving edges, then encode an actual video."""
import cv2
import numpy as np

def theoretical_motion(cfg):
    t = np.arange(cfg.n_frames, dtype=np.float64) / cfg.fps
    displacement = cfg.amplitude_px * np.sin(2*np.pi*cfg.frequency_hz*t + cfg.phase_rad)
    return t, cfg.x0 + displacement, displacement

def generate_video(cfg, path, truth_path=None):
    cfg.validate()
    path.parent.mkdir(parents=True, exist_ok=True)
    t, positions, displacement = theoretical_motion(cfg)
    rng = np.random.default_rng(cfg.seed)
    # Area-sample a continuous blurred step; never round the edge coordinate.
    offsets = (np.arange(cfg.pixel_samples)+0.5)/cfg.pixel_samples - 0.5
    pixel_x = np.arange(cfg.width)[:, None] + offsets
    writer = cv2.VideoWriter(str(path), cv2.VideoWriter_fourcc(*cfg.codec), cfg.fps, (cfg.width, cfg.height))
    if not writer.isOpened():
        raise RuntimeError(f'Cannot open video writer ({cfg.codec}): {path}')
    try:
        for n, edge_x in enumerate(positions):
            coverage = (0.5 + 0.5*np.tanh((pixel_x-edge_x)/cfg.blur_scale_px)).mean(axis=1)
            row = cfg.dark_level + (cfg.bright_level-cfg.dark_level)*coverage
            row += cfg.brightness_amplitude*np.sin(2*np.pi*cfg.brightness_hz*t[n])
            frame = np.broadcast_to(row, (cfg.height, cfg.width)).astype(np.float32).copy()
            if cfg.gaussian_std:
                frame += rng.standard_normal(frame.shape, dtype=np.float32)*cfg.gaussian_std
            if cfg.impulse_probability:
                # Independent Bernoulli contamination, half black and half white.
                mask = rng.random(frame.shape, dtype=np.float32)
                frame[mask < cfg.impulse_probability/2] = 0
                frame[mask > 1-cfg.impulse_probability/2] = 255
            gray = np.clip(np.rint(frame), 0, 255).astype(np.uint8)
            writer.write(cv2.cvtColor(gray, cv2.COLOR_GRAY2BGR))
    finally:
        writer.release()
    if truth_path:
        truth_path.parent.mkdir(parents=True, exist_ok=True)
        np.savez_compressed(truth_path, time_s=t, position_true_px=positions, displacement_true_px=displacement)
    return t, positions, displacement
