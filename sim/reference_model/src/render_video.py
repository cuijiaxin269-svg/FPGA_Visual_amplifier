"""Annotated video of the measured edge and its temporal spectrum.

This is an offline analysis visualization, not a motion magnification algorithm.
The inset enlarges the decoded ROI spatially; FFT uses the complete recording.
"""
import argparse
from pathlib import Path
import cv2
import numpy as np
from config import ROOT, load_config
from .edge_detector import detect_video
from .fft_analysis import analyze

BG = (24, 21, 18)
WHITE = (240, 240, 240)
MUTED = (185, 175, 165)
BLUE = (230, 170, 65)
ORANGE = (65, 155, 250)
GREEN = (140, 210, 100)

def label(canvas, text, x, y, color=WHITE, size=0.58):
    cv2.putText(canvas, text, (int(x), int(y)), cv2.FONT_HERSHEY_SIMPLEX,
                size, color, 1, cv2.LINE_AA)

def series(canvas, xs, ys, box, xlim, ylim, color, thickness=2):
    if len(xs) < 2:
        return
    left, top, width, height = box
    px = left+(np.asarray(xs)-xlim[0])/(xlim[1]-xlim[0])*width
    py = top+height-(np.asarray(ys)-ylim[0])/(ylim[1]-ylim[0])*height
    points = np.column_stack((np.clip(px, left, left+width), np.clip(py, top, top+height)))
    cv2.polylines(canvas, [np.rint(points).astype(np.int32)], False, color, thickness, cv2.LINE_AA)

def axes(canvas, box, xlim, ylim, title, xlabel, yunit):
    left, top, width, height = box
    label(canvas, title, left, top-24)
    for fraction in np.linspace(0, 1, 5):
        x, y = int(left+fraction*width), int(top+fraction*height)
        cv2.line(canvas, (x, top), (x, top+height), (60, 53, 46), 1)
        cv2.line(canvas, (left, y), (left+width, y), (60, 53, 46), 1)
        label(canvas, f'{xlim[0]+fraction*(xlim[1]-xlim[0]):.2f}', x-16, top+height+21, MUTED, 0.4)
        label(canvas, f'{ylim[1]-fraction*(ylim[1]-ylim[0]):.2f}', left-48, y+5, MUTED, 0.4)
    label(canvas, xlabel, left+width//2-40, top+height+46, MUTED, 0.45)
    label(canvas, yunit, left, top-5, MUTED, 0.4)

def render_processed(cfg, output, detected=None, slow_factor=4.0):
    output = Path(output)
    source = output/'simulation_video.mp4'
    normal_path = output/'processed_video.mp4'
    slow_path = output/'processed_video_slow.mp4'
    if not np.isfinite(slow_factor) or slow_factor < 1:
        raise ValueError('slow_factor must be finite and >= 1')
    if detected is None:
        detected, _ = detect_video(source, cfg, ('integer', 'subpixel'))
    if not all(key in detected and len(detected[key]) == cfg.n_frames for key in ('integer', 'subpixel')):
        raise ValueError('Need both detection sequences, one sample per frame')
    spectrum = analyze(detected['subpixel'], cfg.fps, cfg.detrend,
                       cfg.min_signal_std_px, cfg.min_peak_fraction)
    centered = {method: values-values.mean() for method, values in detected.items()}
    displacement_limit = max(0.1, max(float(np.max(np.abs(x))) for x in centered.values())*1.2)
    canvas_size = (1280, 900)
    cap = cv2.VideoCapture(str(source))
    if not cap.isOpened():
        raise RuntimeError(f'Cannot open {source}')
    writers = []
    try:
        for path, fps in ((normal_path, cfg.fps), (slow_path, cfg.fps/slow_factor)):
            writer = cv2.VideoWriter(str(path), cv2.VideoWriter_fourcc(*'mp4v'), fps, canvas_size)
            writers.append(writer)
            if not writer.isOpened():
                raise RuntimeError(f'Cannot write {path}')
        fft_box = (714, 648, 510, 160)
        spectrum_max = max(0.1, float(spectrum.amplitudes.max())*1.2)
        template = np.full((900, 1280, 3), BG, dtype=np.uint8)
        label(template, 'VIDEO VIBRATION ANALYSIS', 24, 35, WHITE, 0.9)
        label(template, 'Integer edge', 24, 66, BLUE)
        label(template, 'Subpixel edge', 190, 66, ORANGE)
        label(template, 'Fixed ROI', 375, 66, GREEN)
        axes(template, fft_box, (0, cfg.fps/2), (0, spectrum_max),
             'Hann FFT - complete recording (offline)', 'Frequency (Hz)', 'Amplitude (pixel)')
        series(template, spectrum.frequencies, spectrum.amplitudes, fft_box,
               (0, cfg.fps/2), (0, spectrum_max), ORANGE)
        if spectrum.frequency_hz is not None:
            peak_x = round(fft_box[0]+spectrum.frequency_hz/(cfg.fps/2)*fft_box[2])
            cv2.line(template, (peak_x, fft_box[1]), (peak_x, fft_box[1]+fft_box[3]), GREEN, 1)
        x, y, w, h = cfg.roi
        strip_h = max(1, min(h, round(w*0.4)))
        strip_y = y+(h-strip_h)//2
        zoom = min(600/w, 240/strip_h)
        zoom_w, zoom_h = round(w*zoom), round(strip_h*zoom)
        zoom_x, zoom_y = 654+(600-zoom_w)//2, 137
        scale = min(600/cfg.width, 450/cfg.height)
        view_w, view_h = round(cfg.width*scale), round(cfg.height*scale)
        view_x, view_y = 24+(600-view_w)//2, 102+(450-view_h)//2
        frequency_text = f'{spectrum.frequency_hz:.4f} Hz' if spectrum.frequency_hz is not None else 'No signal'
        label(template, 'Decoded video + detected edge', 24, 94, MUTED, 0.55)
        label(template, f'ROI center strip: {zoom:.1f}x spatial zoom', 654, 111, WHITE, 0.58)
        label(template, 'Blue = integer; orange = subpixel', 654, 410, MUTED, 0.53)
        label(template, f'Estimated frequency: {frequency_text}', 654, 445, ORANGE, 0.75)
        label(template, f'Status: {spectrum.status} | Capture: {cfg.fps:g} fps', 654, 477, MUTED)
        label(template, f'FFT uses all {cfg.n_frames} samples, not a live estimate.', 654, 507, MUTED, 0.5)
        label(template, 'Inset: image zoom only; displacement values stay in source pixels.', 654, 535, MUTED, 0.43)
        count = 0
        while True:
            ok, frame = cap.read()
            if not ok:
                break
            if count >= cfg.n_frames:
                raise RuntimeError('Source has more frames than the detection sequence')
            canvas = template.copy()
            canvas[view_y:view_y+view_h, view_x:view_x+view_w] = cv2.resize(frame, (view_w, view_h))
            cv2.rectangle(canvas, (round(view_x+x*scale), round(view_y+y*scale)),
                          (round(view_x+(x+w)*scale), round(view_y+(y+h)*scale)), GREEN, 1)
            crop = frame[strip_y:strip_y+strip_h, x:x+w]
            canvas[zoom_y:zoom_y+zoom_h, zoom_x:zoom_x+zoom_w] = cv2.resize(crop, (zoom_w, zoom_h), interpolation=cv2.INTER_NEAREST)
            for method, color, fraction in (('integer', BLUE, (0, 0.48)), ('subpixel', ORANGE, (0.52, 1))):
                position = detected[method][count]
                # Separate vertical segments keep coincident estimates visible.
                original_x = round(view_x+position*scale)
                cv2.line(canvas, (original_x, round(view_y+(y+h*fraction[0])*scale)),
                         (original_x, round(view_y+(y+h*fraction[1])*scale)), color, 2)
                inset_x = round(zoom_x+(position-x+0.5)*zoom-0.5)
                cv2.line(canvas, (inset_x, round(zoom_y+zoom_h*fraction[0])),
                         (inset_x, round(zoom_y+(zoom_h-1)*fraction[1])), color, 2)
            time = count/cfg.fps
            label(canvas, f't = {time:.3f} s | frame {count+1}/{cfg.n_frames}', 740, 34, WHITE, 0.63)
            label(canvas, f'x(integer) = {detected["integer"][count]:.3f} px', 24, 581, BLUE)
            label(canvas, f'x(subpixel) = {detected["subpixel"][count]:.3f} px', 340, 581, ORANGE)
            width_s = cfg.plot_seconds
            end = max(width_s, time)
            start = end-width_s
            first = max(0, int(np.ceil(start*cfg.fps)))
            indices = np.arange(first, count+1)
            box = (77, 648, 525, 160)
            axes(canvas, box, (start, end), (-displacement_limit, displacement_limit),
                 'Measured displacement - recent time window', 'Source time (s)', 'Displacement (pixel)')
            for method, color in (('integer', BLUE), ('subpixel', ORANGE)):
                series(canvas, indices/cfg.fps, centered[method][indices], box,
                       (start, end), (-displacement_limit, displacement_limit), color)
            for writer, playback in zip(writers, ('Original speed', f'{slow_factor:g}x slow playback; source-time axes unchanged')):
                canvas[870:900] = BG
                label(canvas, playback, 24, 891, MUTED, 0.5)
                writer.write(canvas)
            if count == min(15, cfg.n_frames-1):
                cv2.imwrite(str(output/'processed_video_preview.png'), canvas)
            count += 1
        if count != cfg.n_frames:
            raise RuntimeError(f'Expected {cfg.n_frames} frames, got {count}')
    finally:
        cap.release()
        for writer in writers:
            writer.release()
    print(f'Processed video: {normal_path}\nSlow playback: {slow_path}', flush=True)
    return normal_path, slow_path

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--results', type=Path, default=ROOT/'results')
    parser.add_argument('--slow-factor', type=float, default=4)
    args = parser.parse_args()
    render_processed(load_config(args.results/'config_used.json'), args.results, slow_factor=args.slow_factor)
