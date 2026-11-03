"""Recheck sealed V19 and rebuild host regressions without editing the release."""
from pathlib import Path
from datetime import datetime, timezone, timedelta
import hashlib
import json
import os
import subprocess

OUT = Path(__file__).resolve().parents[1]
ROOT = OUT.parents[1]
V19 = ROOT / 'vision/v19boot'

def sha(p):
    with Path(p).open('rb') as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()

def main():
    dest = OUT / 'offline'
    dest.mkdir(exist_ok=False)
    manifest = V19 / 'build/candidate/manifest.json'
    records = json.loads(manifest.read_text(encoding='utf-8'))['files']
    checked = []
    for item in records:
        p = V19 / item['path']
        checked.append(dict(path=item['path'], passed=p.is_file() and
                            p.stat().st_size == item['bytes'] and sha(p) == item['sha256']))
    result = dict(recorded_at=datetime.now(timezone(timedelta(hours=8))).isoformat(),
                  manifest_sha256=sha(manifest), files_checked=len(checked),
                  files_passed=sum(x['passed'] for x in checked), files=checked)
    reflash = ROOT / 'vision/v19boot_reflash_20261103'
    result['candidate'] = {}
    for name in ('BOOT.BIN', 'capture.bit', 'motion60.elf', 'fsbl.elf', 'capture.xsa'):
        p, q = V19/'build/candidate'/name, reflash/'candidate'/name
        result['candidate'][name] = dict(sha256=sha(p), bytes=p.stat().st_size,
                                         reflash_same=q.is_file() and sha(p)==sha(q))
    cold_path = reflash/'evidence/cold_boot_verified.json'
    cold = json.loads(cold_path.read_text(encoding='utf-8'))
    result['previous_cold_boot'] = dict(report=str(cold_path), sha256=sha(cold_path),
        evidence_hashes_match=all(Path(v['path']).is_file() and sha(v['path'])==v['sha256']
                                 for v in cold['evidence'].values()),
        elf_matches=cold['runtime_text']['elf']['sha256']==result['candidate']['motion60.elf']['sha256'],
        recorded_at=cold['recorded_at'], new_power_cycle_this_run=False)
    assert result['files_checked']==result['files_passed'], 'Sealed source mismatch'
    assert all(x['reflash_same'] for x in result['candidate'].values()), 'Reflash candidate mismatch'
    assert result['previous_cold_boot']['evidence_hashes_match'] and result['previous_cold_boot']['elf_matches']
    prior = json.loads((ROOT/'reports/v19_report_20261031/verification/summary.json').read_text())
    env = dict(os.environ)
    env['PATH'] = 'C:/msys64/ucrt64/bin;' + env.get('PATH','')
    result['host_tests'] = []
    for test in prior['tests']:
        name = test['name']
        sources = [V19 / p for p in test['source_sha256']]
        exe = dest / (name+'.exe')
        command = ['C:/msys64/ucrt64/bin/g++.exe','-std=c++14','-O2','-Wall','-Wextra','-Werror',
                   '-D_Static_assert=static_assert','-DMOTION60_PL_SPECTRUM',
                   *map(str,sources),'-o',str(exe)]
        build = subprocess.run(command, env=env, capture_output=True, text=True)
        (dest/(name+'_compile.log')).write_text(build.stdout+build.stderr,encoding='utf-8')
        entry = dict(name=name, command=command, compile_exit=build.returncode,
                     sources={str(p.relative_to(V19)):sha(p) for p in sources})
        if build.returncode==0:
            run = subprocess.run([str(exe)],env=env,capture_output=True,text=True,timeout=120)
            (dest/(name+'.log')).write_text(run.stdout+run.stderr,encoding='utf-8')
            entry.update(run_exit=run.returncode,passed=run.returncode==0)
        else:
            entry['passed'] = False
        result['host_tests'].append(entry)
        print(name,entry['passed'],flush=True)
    result['host_tests_passed'] = all(t['passed'] for t in result['host_tests'])
    result['new_board_measurements'] = False
    (dest/'audit.json').write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
    print(json.dumps({k:v for k,v in result.items() if k not in ('files','host_tests')},indent=2))
    return 0 if result['host_tests_passed'] else 1

if __name__ == '__main__':
    raise SystemExit(main())
