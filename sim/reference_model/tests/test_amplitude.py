from dataclasses import replace
from pathlib import Path
import tempfile
import unittest
import numpy as np
from config import Config
from src.generate_video import generate_video
from src.edge_detector import detect_video, locate_edge
from src.fft_analysis import analyze

class AmplitudeTests(unittest.TestCase):
    def test_subpixel_recovers_small_motion_after_video_codec(self):
        cfg = replace(Config(), amplitude_px=0.1, duration_s=1)
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder)/'small.mp4'
            _, truth, _ = generate_video(cfg, path)
            result, fps = detect_video(path, cfg, ('integer', 'subpixel'))
        sub = result['subpixel']-result['subpixel'].mean()
        rmse = np.sqrt(np.mean((sub-(truth-truth.mean()))**2))
        # MP4 is lossy: require improvement over integer localization, not an
        # unsupported absolute precision promise. The sweep separately reports
        # normalized RMSE and marks inadequate waveform accuracy as a failure.
        integer_ac = result['integer']-result['integer'].mean()
        integer_rmse = np.sqrt(np.mean((integer_ac-(truth-truth.mean()))**2))
        self.assertLess(rmse, integer_rmse)
        self.assertLess(abs(analyze(result['subpixel'], fps).frequency_hz-10), 0.05)
        self.assertIsNone(analyze(result['integer'], fps).frequency_hz)

    def test_lossless_separates_codec_error_from_localization(self):
        cfg = replace(Config(), amplitude_px=0.1, duration_s=1, codec='FFV1')
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder)/'lossless.avi'
            _, truth, _ = generate_video(cfg, path)
            values = detect_video(path, cfg, ('subpixel',))[0]['subpixel']
        rmse = np.sqrt(np.mean(((values-values.mean())-(truth-truth.mean()))**2))
        self.assertLess(rmse, 0.005)

    def test_flat_roi_does_not_invent_edge(self):
        with self.assertRaises(ValueError):
            locate_edge(np.zeros((20, 20), dtype=np.uint8), (0, 0, 20, 20))

    def test_seeded_noise_reproducible_and_not_clean(self):
        cfg = replace(Config(), duration_s=0.1, gaussian_std=10, impulse_probability=0.005)
        with tempfile.TemporaryDirectory() as folder:
            traces = []
            for index, seed in enumerate((2026, 2026, 2027)):
                path = Path(folder)/f'{index}.mp4'
                current = replace(cfg, seed=seed)
                generate_video(current, path)
                traces.append(detect_video(path, current, ('subpixel',))[0]['subpixel'])
        np.testing.assert_array_equal(traces[0], traces[1])
        self.assertGreater(np.max(np.abs(traces[0]-traces[2])), 0.001)

if __name__ == '__main__':
    unittest.main()
