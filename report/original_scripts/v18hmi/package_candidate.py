"""Seal only a fully built/tested candidate. Never claims physical acceptance."""
from pathlib import Path
import hashlib, json, shutil, zipfile
from input_receipt import ROOT, digest, verify

W = ROOT.parents[1]
BASE = W/'vision/v16alpha50'
OUT = ROOT/'build/candidate'
verify('host')
verify('firmware')
baseline = json.loads((ROOT/'provenance/baseline.json').read_text())
assert digest(BASE/'build/candidate/manifest.json') == baseline['manifest_sha256']
assert digest(BASE/'build/candidate/capture.bit') == baseline['bit_sha256']
assert digest(BASE/'build/candidate/motion60.elf') == baseline['elf_sha256']
for entry in baseline['files']:
    assert digest(BASE/entry['path']) == entry['sha256'], 'Baseline changed: '+entry['path']
for entry in json.loads((ROOT/'provenance/hardware_sources.json').read_text()):
    assert digest(Path(entry['active_path'])) == entry['sha256'], 'Active HDL changed during build'
    assert digest(ROOT/entry['independent_path']) == entry['sha256'], 'Independent HDL differs from build'
for entry in json.loads((BASE/'build/candidate/manifest.json').read_text())['files']:
    if entry['path'].startswith('ip_repo/'):
        assert digest(BASE/entry['path']) == entry['sha256'], 'Baseline IP changed'
        assert digest(ROOT/entry['path']) == entry['sha256'], 'Independent IP differs from build'
# The Vivado completion marker is emitted only after all physical build gates.
log = ROOT/'reports/build_hardware_complete.log'
if not log.exists():
    live = W/'vivado.log'
    assert 'HMI_2021_BIT_BUILT_REQUIRES_RUNTIME_VALIDATION' in live.read_text(errors='replace')
    shutil.copy2(live, log)
assert 'HMI_2021_BIT_BUILT_REQUIRES_RUNTIME_VALIDATION' in log.read_text(errors='replace')
for name in ('routed_timing.txt', 'routed_drc.txt', 'routed_cdc.txt', 'routed_bus_skew.txt', 'routed_io.txt'):
    assert (ROOT/'reports'/name).stat().st_size > 0
with zipfile.ZipFile(OUT/'capture.xsa') as archive:
    names = archive.namelist()
    bits = [n for n in names if n.endswith('.bit')]
    assert len(bits) == 1 and archive.read(bits[0]) == (OUT/'capture.bit').read_bytes(), 'Unpaired bit/XSA'
    for wanted in ('ps7_init.tcl', 'ps7_init.c', 'ps7_init.h'):
        matches = [n for n in names if n.rsplit('/', 1)[-1] == wanted]
        assert len(matches) == 1, f'Cannot identify {wanted}'
        (OUT/wanted).write_bytes(archive.read(matches[0]))
shutil.copy2(ROOT/'build/firmware/motion60.elf', OUT/'motion60.elf')
shutil.copy2(ROOT/'build/firmware/motion60.map', OUT/'motion60.map')
files = []
for folder in ('sw', 'sim', 'rtl', 'ip_repo', 'constraints', 'project', 'scripts', 'reports', 'provenance', 'build/candidate', 'board/tools'):
    for path in sorted((ROOT/folder).rglob('*')):
        if not path.is_file() or path == OUT/'manifest.json' or '__pycache__' in path.parts:
            continue
        files.append({'path': path.relative_to(ROOT).as_posix(), 'sha256': digest(path), 'bytes': path.stat().st_size})
board = {}
board_report = ROOT/'reports/board_validation.json'
if board_report.exists():
    board = json.loads(board_report.read_text(encoding='utf-8'))
    assert board['elf_sha256'] == digest(OUT/'motion60.elf')
    assert board['bit_sha256'] == digest(OUT/'capture.bit')
    for item in board['evidence']:
        assert digest(ROOT/item['path']) == item['sha256']
board_checks = board.get('checks', {})
data = {
    'schema': 'motion60-hmi-uart1-v1', 'baseline_manifest_sha256': baseline['manifest_sha256'],
    'toolchain': 'Vivado/Vitis 2021.2', 'host_tests_passed': True, 'physical_build_gates_passed': True,
    'board_readback_passed': board_checks.get('five_commands', False) and board_checks.get('screen_link', False),
    'board_readback_scope': 'Five command types, parameter boundaries, hardware commits and screen property readback; not full physical acceptance.',
    'physical_screen_hdmi_passed': board.get('physical_screen_hdmi_passed', False),
    'smoke_10_minutes_passed': board_checks.get('smoke_10_minutes', False),
    'smoke_scope': 'Automated real-screen UART interactions; physical touch remains separately recorded.',
    'soak_60_minutes_passed': board_checks.get('soak_60_minutes', False),
    'continuous_run_observation': board.get('user_ended_continuous_run'),
    'boot': {'run': 'STOPPED', 'view': 2, 'alpha': 12, 'exposure': 320},
    'uart': {'controller': 1, 'route': 'EMIO', 'baud': 115200, 'format': '8N1', 'tx_pin': 'AH12', 'rx_pin': 'AG12'},
    'electrical_evidence': json.loads((ROOT/'provenance/electrical/evidence.json').read_text(encoding='utf-8')),
    'files': files,
}
(OUT/'manifest.json').write_text(json.dumps(data, indent=2, ensure_ascii=False)+'\n', encoding='utf-8')
with zipfile.ZipFile(ROOT/'build/v18hmi_source_and_candidate.zip', 'w', zipfile.ZIP_DEFLATED) as archive:
    for entry in files:
        archive.write(ROOT/entry['path'], 'v18hmi/'+entry['path'])
    archive.write(OUT/'manifest.json', 'v18hmi/build/candidate/manifest.json')
    archive.write(ROOT/'README.txt', 'v18hmi/README.txt')
    archive.write(ROOT/'ACCEPTANCE.txt', 'v18hmi/ACCEPTANCE.txt')
print('HMI_CANDIDATE_SEALED_REQUIRES_BOARD_ACCEPTANCE')
