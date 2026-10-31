"""Create an independent v18-derived boot candidate without editing the baseline."""
from pathlib import Path
import hashlib, json, shutil

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT.parent / 'v18hmi'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
manifest = BASE / 'build/candidate/manifest.json'
assert sha(manifest) == '5c29b09fd43420001547bc04a418e1dbeaba76a6c8f97ded8eb345d9e3576855'
data = json.loads(manifest.read_text(encoding='utf-8'))
for entry in data['files']:
    p = BASE / entry['path']
    assert sha(p) == entry['sha256'], str(p)
for folder in ('sw', 'sim', 'rtl', 'constraints', 'ip_repo', 'project'):
    assert not (ROOT/folder).exists(), 'Refuse to overwrite candidate sources'
    shutil.copytree(BASE/folder, ROOT/folder)
for folder in ('reports', 'provenance', 'build/candidate', 'board/tools'):
    (ROOT/folder).mkdir(parents=True, exist_ok=True)
for name in ('build_firmware.ps1', 'input_receipt.py', 'test_hmi.ps1', 'test_firmware.ps1',
             'test_alpha50_controls.ps1', 'test_stable_ui.ps1', 'test_spectrum.ps1'):
    shutil.copy2(BASE/'scripts'/name, ROOT/'scripts'/name)
shutil.copy2(manifest, ROOT/'provenance/v18_manifest.json')
for name in ('capture.bit', 'capture.ltx'):
    shutil.copy2(BASE/'build/candidate'/name, ROOT/'build/candidate'/name)
(ROOT/'provenance/baseline.json').write_text(json.dumps({
    'baseline': str(BASE), 'manifest_sha256': sha(manifest),
    'copied_source_files': {str(p.relative_to(ROOT)): sha(p) for f in
        ('sw','sim','rtl','constraints','ip_repo','project') for p in (ROOT/f).rglob('*') if p.is_file()},
    'boot_policy': {'run':'STOPPED','view':2,'alpha':12,'exposure':320},
    'board_boot_validated': False,
}, indent=2)+'\n')
evidence = ROOT.parents[1]/'board_checks/20261030_v19boot_01'
(evidence/'tools').mkdir(parents=True, exist_ok=False)
for name in ('start_owned_server.ps1','close_owned_server.ps1','load_helpers.tcl','inspect_entry.tcl','hmi_helpers.tcl'):
    shutil.copy2(BASE/'board/tools'/name, evidence/'tools'/name)
print('V19_BASELINE_VERIFIED_AND_COPIED',len(data['files']))
