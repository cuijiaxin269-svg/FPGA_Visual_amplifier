"""Verify package/source pairing and the explicit electrical hold before loading."""
from pathlib import Path
import hashlib, json, struct, sys

ROOT = Path(__file__).resolve().parents[2]
W = ROOT.parents[1]
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def gate(package):
    assert package.resolve() == (ROOT/'build/candidate').resolve(), 'Use this candidate package'
    evidence = json.loads((ROOT/'provenance/electrical/evidence.json').read_text(encoding='utf-8'))
    assert evidence['safe_connection_confirmed'] and not evidence['download_hold'], 'Electrical hold: screen TX reported 5V; safe FPGA-side voltage not yet confirmed'
    manifest = json.loads((package/'manifest.json').read_text(encoding='utf-8'))
    assert manifest['schema'] == 'motion60-hmi-uart1-v1'
    assert manifest['host_tests_passed'] and manifest['physical_build_gates_passed']
    for entry in manifest['files']:
        path = (ROOT/entry['path']).resolve()
        assert ROOT.resolve() in path.parents, 'Manifest path outside candidate'
        assert sha(path) == entry['sha256'], 'Changed artifact: '+entry['path']
    base = W/'vision/v16alpha50/build/candidate'
    baseline = json.loads((ROOT/'provenance/baseline.json').read_text())
    assert sha(base/'manifest.json') == baseline['manifest_sha256']
    assert sha(base/'motion60.elf') == baseline['elf_sha256']
    b = (base/'motion60.elf').read_bytes()
    off = struct.unpack_from('<I', b, 32)[0]
    size, count, names_index = struct.unpack_from('<HHH', b, 46)
    sections = [struct.unpack_from('<10I', b, off+i*size) for i in range(count)]
    ns = sections[names_index]; names = b[ns[4]:ns[4]+ns[5]]
    for section in sections:
        if names[section[0]:].split(b'\0', 1)[0] == b'.text':
            assert section[3] == 0x100000
            text = b[section[4]:section[4]+section[5]]
            break
    else:
        raise AssertionError('Baseline ELF has no text')
    assert Path(__file__).with_name('expected_old_text.bin').read_bytes() == text
    return dict(marker='HMI_CANDIDATE_PREFLIGHT_PASSED', manifest_sha256=sha(package/'manifest.json'),
                bit=package/'capture.bit', xsa=package/'capture.xsa', elf=package/'motion60.elf',
                ps_init=package/'ps7_init.tcl', old_xsa=base/'capture.xsa', old_text_words=(len(text)+3)//4)

if __name__ == '__main__':
    for k, v in gate(Path(sys.argv[1])).items():
        v = str(v).replace('\\', '/')
        assert not any(c in v for c in '{}\r\n')
        print(f'{k} {{{v}}}', end=' ')
    print()
