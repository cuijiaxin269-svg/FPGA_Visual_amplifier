"""Simulate square-ROI composition and display; use a fresh external output directory."""
from pathlib import Path
import argparse
import datetime
import hashlib
import json
import os
import re
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--vivado-root', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    repo = Path(__file__).resolve().parents[2]
    output = args.output.resolve()
    if output.is_relative_to(repo):
        parser.error('--output must be outside the source repository')
    if output.exists():
        parser.error('--output must be a fresh directory; existing results are preserved')
    output.mkdir(parents=True)
    reports = output / 'reports'
    reports.mkdir()
    temporary = output / 'tmp'
    temporary.mkdir()
    receipt = {
        'timestamp': datetime.datetime.now().astimezone().isoformat(),
        'status': 'running', 'passed': False, 'steps': [],
        'hardware_test': False, 'board_runtime_validated': False,
        'vivado_root': str(args.vivado_root.resolve()),
    }

    def save_receipt():
        pending = reports / 'result.json.tmp'
        pending.write_text(json.dumps(receipt, indent=2), encoding='utf-8')
        pending.replace(reports / 'result.json')

    sources = [
        'src/rtl/motion60_roi_compose.v',
        'sim/tests/tb_roi_compose.sv',
        'src/rtl/motion60_video.v',
        'src/rtl/motion60_video_osd.v',
        'src/rtl/motion60_spectrum_overlay.v',
        'sim/tests/tb_roi_border.sv',
        'sim/tests/tb_border_alignment.sv',
        'sim/scripts/run_roi_rtl.py',
    ]

    def source_hashes():
        return {name: hashlib.sha256((repo / name).read_bytes()).hexdigest()
                for name in sources}

    save_receipt()
    exit_code = 1
    try:
        tool = args.vivado_root.resolve() / 'bin'
        for name in ('xvlog.bat', 'xelab.bat', 'xsim.bat'):
            if not (tool / name).is_file():
                raise FileNotFoundError(f'Vivado simulator tool not found: {tool / name}')
        receipt['source_sha256'] = source_hashes()
        save_receipt()
        env = os.environ.copy()
        env['TEMP'] = str(temporary)
        env['TMP'] = str(temporary)
        cases = [
            ('compose', 'tb_roi_compose', 'ROI_COMPOSE_PASS'),
            ('compose_full', 'tb_roi_compose_full', 'ROI_COMPOSE_FULL_PASS'),
            ('border', 'tb_roi_border', 'ROI_BORDER_RTL_PASSED'),
            ('alignment', 'tb_border_alignment', 'BORDER_WRAPPER_ALIGNMENT_PASSED'),
        ]
        receipt['cases'] = [{'name': name, 'top': top, 'pass_marker': marker}
                            for name, top, marker in cases]
        commands = [('xvlog', [str(tool / 'xvlog.bat'), '--sv'] +
                    [str(repo / name) for name in sources if name.endswith(('.v', '.sv'))])]
        for name, top, _ in cases:
            snapshot = f'roi_{name}_test'
            commands.extend([
                (f'xelab_{name}', [str(tool / 'xelab.bat'), top,
                                   '--timescale', '1ns/1ps', '-s', snapshot]),
                (f'xsim_{name}', [str(tool / 'xsim.bat'), snapshot,
                                  '-runall', '-log', str(output / f'{name}.log')]),
            ])
        for name, command in commands:
            step = {'name': name, 'command': command, 'returncode': None}
            receipt['steps'].append(step)
            save_receipt()
            try:
                result = subprocess.run(command, cwd=output, env=env,
                                        stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                        text=True, errors='replace', timeout=600)
            except subprocess.TimeoutExpired as exc:
                captured = exc.stdout or b''
                if isinstance(captured, bytes):
                    captured = captured.decode(errors='replace')
                (reports / f'{name}.log').write_text(captured, encoding='utf-8')
                step['timed_out'] = True
                raise
            (reports / f'{name}.log').write_text(result.stdout, encoding='utf-8')
            step['returncode'] = result.returncode
            save_receipt()
            print(name, result.returncode, flush=True)
            if result.returncode:
                raise RuntimeError(f'{name} failed with exit code {result.returncode}')
        for name, _, marker in cases:
            log = (output / f'{name}.log').read_text(errors='replace')
            if marker not in log or re.search(r'^\s*(Fatal|FATAL|ERROR):', log, re.M):
                raise RuntimeError(f'RTL simulation did not produce a valid {marker} result')
        receipt['source_sha256_after'] = source_hashes()
        if receipt['source_sha256_after'] != receipt['source_sha256']:
            raise RuntimeError('Simulation sources changed during the run; use a fresh run')
        receipt.update(status='passed', passed=True)
        exit_code = 0
    except Exception as exc:
        receipt.update(status='failed', passed=False, error=f'{type(exc).__name__}: {exc}')
        print(receipt['error'], file=sys.stderr)
    finally:
        receipt.update(returncode=exit_code,
                       completed_at=datetime.datetime.now().astimezone().isoformat())
        save_receipt()
    raise SystemExit(exit_code)


if __name__ == '__main__':
    main()
