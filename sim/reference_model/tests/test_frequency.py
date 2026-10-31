"""Independent signal and actual encoded-video regression checks."""
from dataclasses import replace
from pathlib import Path
import tempfile
import unittest
import numpy as np
from config import Config
from src.fft_analysis import analyze
from src.generate_video import generate_video
from src.edge_detector import detect_video

class FrequencyTests(unittest.TestCase):
    def test_frequency_grid_and_amplitude_normalization(self):
        for count in (600, 601):
            for bin_index in (10, 50, 150, 200):
                t = np.arange(count)/120
                frequency = bin_index*120/count
                s = analyze(320+2*np.sin(2*np.pi*frequency*t), 120)
                self.assertAlmostEqual(s.frequency_hz, frequency, places=8)
                self.assertAlmostEqual(s.peak_amplitude_px, 2, places=8)

    def test_off_bin_frequency(self):
        t = np.arange(600)/120
        s = analyze(100+0.2*np.sin(2*np.pi*10.07*t), 120)
        self.assertLess(abs(s.frequency_hz-10.07), 0.005)

    def test_nyquist_amplitude_not_doubled(self):
        s = analyze(2*(-1.)**np.arange(600), 120)
        self.assertAlmostEqual(s.amplitudes[-1], 2, places=8)

    def test_stationary_and_detrended_signal(self):
        for x, detrend in ((np.full(600, 320.), False), (320+np.arange(600)*0.1, True)):
            s = analyze(x, 120, detrend=detrend)
            self.assertIsNone(s.frequency_hz)
            self.assertEqual(s.status, 'no_signal')

    def test_nyquist_and_bad_roi_rejected(self):
        for cfg in (replace(Config(), frequency_hz=60), replace(Config(), frequency_hz=70), replace(Config(), roi=(630, 0, 80, 40))):
            with self.assertRaises(ValueError):
                cfg.validate()

    def test_encoded_video_chain(self):
        cfg = replace(Config(), duration_s=1)
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder)/'test.mp4'
            generate_video(cfg, path)
            detected, fps = detect_video(path, cfg, ('integer', 'subpixel'))
        for values in detected.values():
            self.assertEqual(len(values), 120)
            self.assertLess(abs(analyze(values, fps).frequency_hz-10), 0.03)

if __name__ == '__main__':
    unittest.main()
