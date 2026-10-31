"""Relocated existing ROI reference-vector generator; requires NumPy."""
from pathlib import Path
import argparse
import json
import sys

import numpy as np

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / "src/hls/reference"))
from motion60_spectrum import MotionSpectrum, SpectrumConfig


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "_build/hls/roi256_vectors")
    args = parser.parse_args()
    folder = args.output.resolve()
    if folder.exists():
        raise SystemExit(f"Use a fresh output directory: {folder}")
    folder.mkdir(parents=True)
    rng = np.random.default_rng(7100)
    base = rng.uniform(100, 900, (256, 256))
    transform = np.fft.fft2(base)
    fy = np.fft.fftfreq(256)[:, None]
    fx = np.fft.fftfreq(256)[None, :]
    model = MotionSpectrum(SpectrumConfig())
    shifts = [(0, 0), (.4, -.3), (2.3, 1.7), (-3.2, -1.2)]
    expected = []
    for i, (dx, dy) in enumerate(shifts):
        roi = np.fft.ifft2(transform * np.exp(-2j * np.pi * (fx * dx + fy * dy))).real
        frame = np.zeros((800, 1280), dtype="<u2")
        frame[272:528, 512:768] = np.clip(np.rint(roi), 0, 1023).astype("<u2")
        frame.tofile(folder / f"input{i}.bin")
        result = model.push(frame, i)
        expected.append([result["dx_px"], result["dy_px"], result["correlation_peak"], result["variance_dn2"]])
    np.array(expected, dtype="<f4").tofile(folder / "expected.bin")
    metadata = dict(shifts=shifts, expected=expected,
                    maximum_displacement_error_px=.002, maximum_peak_error=.002)
    (folder / "metadata.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
    print(folder)


if __name__ == "__main__":
    main()
