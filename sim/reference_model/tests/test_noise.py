import unittest
import numpy as np
from src.fft_analysis import analyze

class NoiseTests(unittest.TestCase):
    def test_white_noise_peak_is_low_confidence(self):
        for seed in (2026, 2027, 2028):
            signal = 320+np.random.default_rng(seed).normal(0, 0.2, 600)
            spectrum = analyze(signal, 120)
            self.assertEqual(spectrum.status, 'low_confidence')
            self.assertIsNotNone(spectrum.frequency_hz)

    def test_above_nyquist_alias_cannot_be_recovered(self):
        t = np.arange(600)/120
        spectrum = analyze(np.sin(2*np.pi*70*t), 120)
        self.assertAlmostEqual(spectrum.frequency_hz, 50, places=8)

    def test_invalid_samples_are_rejected(self):
        for signal in (np.zeros(3), np.ones((8, 2)), np.r_[np.ones(10), np.nan]):
            with self.assertRaises(ValueError):
                analyze(signal, 120)

if __name__ == '__main__':
    unittest.main()
