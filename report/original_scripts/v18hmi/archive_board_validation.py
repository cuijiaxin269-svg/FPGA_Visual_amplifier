"""Archive bounded board evidence and derive claims; never infer touch/visual pass."""
from pathlib import Path
import hashlib, json, shutil

ROOT = Path(__file__).resolve().parents[1]
B = ROOT/'board'
OUT = ROOT/'reports/board_evidence'
OUT.mkdir(exist_ok=True)
def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()
def text(p):
    return p.read_text(encoding='utf-8-sig', errors='replace')
loaded_path = ROOT/'provenance/revision_03/loaded_manifest.json'
loaded = json.loads(text(loaded_path))
progress = dict(line.split('=', 1) for line in text(B/'idle_reload_01/progress.txt').splitlines())
assert progress['manifest_sha256'] == sha(loaded_path)
assert 'HMI_IDLE_FIRMWARE_RELOAD_PASSED' in text(B/'idle_reload_01.log')
entries = {x['path']: x['sha256'] for x in loaded['files']}
elf = ROOT/'build/candidate/motion60.elf'
bit = ROOT/'build/candidate/capture.bit'
assert sha(elf) == entries['build/candidate/motion60.elf']
assert sha(bit) == entries['build/candidate/capture.bit']
soak_logs = sorted(B.glob('soak_60m_*.log'))
completed_soaks = [p for p in soak_logs if 'HMI_MONITOR_PASSED mode=soak seconds=3600' in text(p)]
chosen_soak = completed_soaks[-1] if completed_soaks else B/'soak_60m_01.log'
checks = {
 'screen_link': ('probe_link_04.log', 'HMI_P4_SCREEN_LINK_READBACK_PASSED'),
 'five_commands': ('runtime_commands_03.log', 'HMI_FIVE_COMMANDS_BOARD_READBACK_PASSED'),
 'protocol_edges': ('protocol_edges_01.log', 'HMI_PROTOCOL_EDGES_BOARD_PASSED'),
 'screen_soft_restart': ('screen_restart_01.log', 'HMI_SCREEN_SOFT_RESTART_RESYNC_PASSED'),
 'native_three_second_timer': ('prepare_soak_01.log', 'HMI_NATIVE_THREE_SECOND_TIMER_PASSED'),
 'final_stop_drain': ('finish_run_01.log', 'HMI_FINAL_STOP_DRAIN_READBACK_PASSED'),
 'smoke_10_minutes': ('interaction_smoke_01.log', 'HMI_TEN_MINUTE_AUTOMATED_INTERACTION_PASSED'),
 'soak_60_minutes': (chosen_soak.name, 'HMI_MONITOR_PASSED mode=soak seconds=3600'),
}
result = {'elf_sha256': sha(elf), 'bit_sha256': sha(bit),
          'loaded_manifest_sha256': sha(loaded_path), 'checks': {},
          'physical_screen_hdmi_passed': False,
          'scope': 'Five-command hardware readback and automated real-UART tests; full 17-item physical acceptance is separate.'}
archive = ['idle_reload_01.log', 'idle_reload_01/progress.txt']
if (B/'server_cleanup.json').exists():
    archive.append('server_cleanup.json')
for p in sorted(B.glob('prepare_soak_*.log')):
    archive.append(p.name)
for name in ('load_01.log', 'recover_01.log', 'irq_registers_02.log',
             'abort_recovery_03.log', 'irq_load_01.log'):
    if (B/name).exists():
        archive.append(name)
for name, (filename, marker) in checks.items():
    p = B/filename
    result['checks'][name] = p.exists() and marker in text(p)
    if p.exists():
        archive.append(filename)
for p in sorted(B.glob('soak_60m_*')):
    if p.is_file() and p.suffix in ('.log', '.jsonl') and p.name not in archive:
        archive.append(p.name)
for p in sorted(B.glob('soak_60m_*.jsonl')):
    records = [json.loads(x) for x in text(p).splitlines()]
    if not any(x.get('event') == 'user_requested_stop' for x in records):
        continue
    samples = [x for x in records if 'elapsed_ms' in x]
    assert samples and not any('failed' in x for x in records)
    for sample in samples:
        assert sample['run'] == 4 and sample['sensor_continuity_ok'] == 1
        assert all(sample[k] == 0 for k in ('rx_overflow', 'rx_errors', 'capture_error', 'algorithm_error', 'discontinuities', 'sequence_gaps'))
        assert [sample[k] for k in ('view', 'alpha', 'exposure', 'commands')] == [samples[0][k] for k in ('view', 'alpha', 'exposure', 'commands')]
    result['user_ended_continuous_run'] = {
        'log': p.name, 'observed_interval_ms': samples[-1]['elapsed_ms']-samples[0]['elapsed_ms'],
        'samples': len(samples), 'processed_frames': samples[-1]['processed_frames']-samples[0]['processed_frames'],
        'display_frames': samples[-1]['display_frames']-samples[0]['display_frames'],
        'user_requested_early_finish': True, 'is_60_minute_pass': False,
        'jtag_reconnects': sum(x.get('event') == 'jtag_reconnect' for x in records)}
for name in ('interaction_smoke_01.jsonl',
             'manual_observation_01.log', 'manual_observation_01.jsonl',
             'manual_observation_02.log', 'manual_observation_02.jsonl'):
    if (B/name).exists():
        archive.append(name)
if result['checks']['smoke_10_minutes']:
    samples = [json.loads(x) for x in text(B/'interaction_smoke_01.jsonl').splitlines()]
    assert samples[-1]['passed'] and samples[-1]['elapsed_ms'] >= 600000
    assert not samples[-1]['physical_touch_test']
    result['smoke_summary'] = samples[-1]
if result['checks']['soak_60_minutes']:
    records = [json.loads(x) for x in text(chosen_soak.with_suffix('.jsonl')).splitlines()]
    samples = [x for x in records if 'elapsed_ms' in x]
    assert not any('failed' in x for x in records)
    assert samples[-1]['elapsed_ms']-samples[0]['elapsed_ms'] >= 3600000
    assert len(samples) >= 361
    for sample in samples:
        assert sample['run'] == 4
        assert [sample[k] for k in ('view', 'alpha', 'exposure', 'commands')] == [samples[0][k] for k in ('view', 'alpha', 'exposure', 'commands')]
        assert all(sample[k] == 0 for k in ('rx_overflow', 'rx_errors', 'capture_error',
            'algorithm_error', 'discontinuities', 'sequence_gaps'))
        assert sample['sensor_continuity_ok'] == 1
    for prior, later in zip(samples, samples[1:]):
        assert later['processed_frames'] > prior['processed_frames'] and later['display_frames'] > prior['display_frames']
    result['soak_summary'] = {'log': chosen_soak.name, 'duration_ms': samples[-1]['elapsed_ms'], 'samples': len(samples),
        'jtag_reconnects': sum(x.get('event') == 'jtag_reconnect' for x in records),
        'processed_frames': samples[-1]['processed_frames']-samples[0]['processed_frames'],
        'display_frames': samples[-1]['display_frames']-samples[0]['display_frames']}
for folder in ('final_snapshot', 'protocol_snapshot', 'manual_touch_snapshot', 'jtag_recheck_01'):
    if (B/folder).exists():
        archive.extend(p.relative_to(B).as_posix() for p in (B/folder).rglob('*') if p.is_file())
if (B/'user_observations.json').exists():
    archive.append('user_observations.json')
    result['user_observations'] = json.loads(text(B/'user_observations.json'))
result['evidence'] = []
for name in archive:
    source = B/name; target = OUT/name
    target.parent.mkdir(exist_ok=True, parents=True)
    shutil.copy2(source, target)
    result['evidence'].append({'path': target.relative_to(ROOT).as_posix(), 'sha256': sha(target)})
(ROOT/'reports/board_validation.json').write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
print(json.dumps(result['checks']))
