"""Bind successful host/ARM builds to the actual inputs used in this checkout."""
from pathlib import Path
import hashlib, json, sys

ROOT = Path(__file__).resolve().parents[1]

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def inputs(kind):
    folders = ('sw', 'sim') if kind == 'host' else ('sw',)
    paths = [p for f in folders for p in (ROOT/f).rglob('*') if p.is_file()]
    paths += [ROOT/'scripts'/('test_hmi.ps1' if kind == 'host' else 'build_firmware.ps1')]
    return {p.relative_to(ROOT).as_posix(): digest(p) for p in sorted(paths)}

def verify(kind):
    receipt = json.loads((ROOT/'reports'/f'{kind}_inputs.json').read_text())
    assert receipt['inputs'] == inputs(kind), f'{kind} inputs changed after verification'
    for name, expected in receipt['outputs'].items():
        assert digest(ROOT/name) == expected, f'{kind} output changed: {name}'

if __name__ == '__main__':
    kind = sys.argv[1]
    assert kind in ('host', 'firmware')
    outputs = (['reports/test_hmi_protocol.log', 'reports/test_hmi_device.log', 'reports/test_hmi_uart.log']
               if kind == 'host' else ['build/firmware/motion60.elf'])
    data = {'kind': kind, 'inputs': inputs(kind), 'outputs': {p: digest(ROOT/p) for p in outputs}}
    (ROOT/'reports'/f'{kind}_inputs.json').write_text(json.dumps(data, indent=2)+'\n')
    print(f'HMI_{kind.upper()}_INPUT_RECEIPT_WRITTEN')
