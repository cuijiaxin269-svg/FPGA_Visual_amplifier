"""All experiment defaults. Coordinates refer to pixel centers (0, 1, ...)."""
from dataclasses import asdict, dataclass, field
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent

@dataclass
class Config:
    width: int = 640
    height: int = 480
    fps: float = 120.0
    frequency_hz: float = 10.0
    amplitude_px: float = 2.0
    duration_s: float = 5.0
    x0: float = 320.0
    phase_rad: float = 0.0
    roi: tuple = (280, 160, 80, 160)  # x, y, width, height
    dark_level: float = 25.0
    bright_level: float = 230.0
    blur_scale_px: float = 0.8  # tanh optical edge spread scale
    pixel_samples: int = 8  # integrate each pixel's finite area
    gaussian_std: float = 0.0  # gray levels, before 8-bit clipping
    brightness_amplitude: float = 0.0  # additive gray levels
    brightness_hz: float = 1.3
    impulse_probability: float = 0.0  # salt-and-pepper pixels/frame
    seed: int = 2026
    codec: str = 'mp4v'
    centroid_radius: int = 4
    detrend: bool = False
    min_signal_std_px: float = 1e-6
    min_peak_fraction: float = 0.25  # energy in peak +/- 1 bin / non-DC energy
    frequency_tolerance_hz: float = 0.2
    max_normalized_rmse: float = 0.25
    plot_seconds: float = 0.5
    frequencies_hz: tuple = (2, 5, 10, 15, 20, 30, 40)
    amplitudes_px: tuple = (5, 2, 1, 0.5, 0.2, 0.1)
    spatial_offsets_px: tuple = (0.0, 0.25, 0.5)
    noise_amplitudes_px: tuple = (2.0, 0.2)
    noise_seeds: tuple = (2026, 2027, 2028)
    noise_cases: list = field(default_factory=lambda: [
        dict(name='clean', gaussian_std=0, brightness_amplitude=0, impulse_probability=0),
        dict(name='gaussian_5', gaussian_std=5, brightness_amplitude=0, impulse_probability=0),
        dict(name='brightness_40', gaussian_std=0, brightness_amplitude=40, impulse_probability=0),
        dict(name='impulse_001', gaussian_std=0, brightness_amplitude=0, impulse_probability=0.001),
        dict(name='mixed_moderate', gaussian_std=15, brightness_amplitude=30, impulse_probability=0.005),
        dict(name='mixed_strong', gaussian_std=50, brightness_amplitude=80, impulse_probability=0.02),
        dict(name='stress_saturation', gaussian_std=90, brightness_amplitude=260, impulse_probability=0.1),
    ])

    @property
    def n_frames(self):
        return int(round(self.fps * self.duration_s))

    def validate(self):
        import math
        for key in ('width', 'height', 'pixel_samples', 'centroid_radius', 'seed'):
            value = getattr(self, key)
            if isinstance(value, bool) or not isinstance(value, int):
                raise ValueError(f'{key} must be an integer')
        for key, value in asdict(self).items():
            if isinstance(value, (int, float)) and not math.isfinite(value):
                raise ValueError(f'{key} must be finite')
        if self.fps <= 0 or self.duration_s <= 0 or self.n_frames < 8:
            raise ValueError('Need positive fps/duration and at least 8 frames')
        if not 0 < self.frequency_hz < self.fps / 2:
            raise ValueError('Require 0 < frequency < fps/2 (strict Nyquist limit)')
        if self.width <= 0 or self.height <= 0 or self.width % 2 or self.height % 2:
            raise ValueError('MP4 requires positive even frame dimensions')
        if self.amplitude_px < 0 or self.blur_scale_px <= 0 or self.pixel_samples < 1:
            raise ValueError('Invalid amplitude/blur/pixel sampling')
        if not 0 <= self.dark_level < self.bright_level <= 255:
            raise ValueError('Require 0 <= dark < bright <= 255')
        x, y, w, h = self.roi
        if any(int(v) != v for v in self.roi) or min(x, y) < 0 or w < 12 or h < 1 or x+w > self.width or y+h > self.height:
            raise ValueError('ROI must be an integer rectangle inside the frame')
        margin = self.centroid_radius + 3 + 3*self.blur_scale_px
        if self.centroid_radius < 1 or not x+margin < self.x0-self.amplitude_px <= self.x0+self.amplitude_px < x+w-1-margin:
            raise ValueError('Edge excursion and centroid support must remain inside ROI')
        if min(self.gaussian_std, self.brightness_amplitude) < 0 or not 0 <= self.impulse_probability <= 1:
            raise ValueError('Invalid noise parameters')
        if len(self.codec) != 4 or self.min_signal_std_px < 0 or not 0 <= self.min_peak_fraction <= 1:
            raise ValueError('Invalid codec or detection thresholds')
        if self.frequency_tolerance_hz < 0 or self.max_normalized_rmse <= 0 or self.plot_seconds <= 0 or self.seed < 0:
            raise ValueError('Invalid evaluation/plot/seed parameters')

def load_config(path=None):
    cfg = Config(**json.loads(Path(path).read_text(encoding='utf-8'))) if path else Config()
    cfg.validate()
    return cfg
