"""Decode a read-only snapshot; discard trace bytes overwritten during the read."""
from pathlib import Path
import json, struct, sys

STATUSES = ['SET', 'QUEUED', 'WAIT ACK', 'APPLIED', 'RUNNING', 'STOPPED', 'BUSY', 'REJECTED', 'ERROR']
def decode(folder):
    d = struct.unpack('<64I', (folder/'hmi.bin').read_bytes())
    assert d[0:2] == (0x484d4931, 1) and not d[2]&1
    names = ['VIEW', 'ALPHA', 'EXPOSURE', 'RUN']
    result = {'uptime_ms': d[3]+(d[4]<<32), 'sequence': d[2], 'running': d[14], 'requested_run': d[15],
              'page': d[24], 'online': d[25], 'fields': {}}
    for i, name in enumerate(names):
        entry = {'status': STATUSES[d[16+i]], 'generation': d[20+i]}
        if i < 3:
            entry.update(target=d[5+i], actual=d[8+i] if d[11+i] else None)
        result['fields'][name] = entry
    counters = ['commands','rejected','native_packets','corrupt_packets','overlong','transport_faults',
                'native_errors','reconnects','rx_bytes','tx_bytes','rx_overflow','rx_errors','tx_full','interrupts','unexpected_irq']
    result['counters'] = dict(zip(counters, d[26:41]))
    owners = ['start_pending','switch_pending','booting','stop_requested','algorithm_busy','capture_status',
              'capture_error','algorithm_error','processed_frames','display_frames','display_generation',
              'panel_visible','config_generation','camera_revision','applied_revision','exposure_readback']
    result['device'] = dict(zip(owners, d[41:57]))
    trace = (folder/'trace.bin').read_bytes()
    assert len(trace) == 16400 and struct.unpack_from('<2I', trace) == (0x484d5431, 1)
    window = dict(line.split('=', 1) for line in (folder/'trace_window.txt').read_text().splitlines())
    result['trace'] = {}
    for direction, offset in [('rx',16), ('tx',8208)]:
        before, after = int(window[direction+'_before']), int(window[direction+'_after'])
        assert after >= before, 'Counter wrap: start a new capture interval'
        # Bytes written after `before` might be captured partially; bytes older
        # than after-8192 might already be overwritten. Retain only the overlap.
        start = max(0, after-8192)
        raw = bytes(trace[offset+(n&8191)] for n in range(start, before))
        (folder/(direction+'.bin')).write_bytes(raw)
        escaped = ''.join(chr(c) if 32<=c<=126 else '\\r' if c==13 else '\\n\n' if c==10 else f'\\x{c:02x}' for c in raw)
        (folder/(direction+'.txt')).write_text(escaped, encoding='utf-8')
        result['trace'][direction] = {'retained_from': start, 'retained_until': before, 'bytes': len(raw),
                                      'counter_after': after, 'electrical_waveform': False}
    (folder/'summary.json').write_text(json.dumps(result, indent=2)+'\n')
    return result

if __name__ == '__main__':
    print(json.dumps(decode(Path(sys.argv[1])), indent=2))
