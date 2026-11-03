"""Compact read-only progress summary; safe while the collector is writing."""
from pathlib import Path
import json
import struct
import sys

def progress(folder):
    samples=[]
    # Only include rows committed by the collector after its seqlock checks.
    rows=(folder/'samples.csv').read_text().splitlines()[1:]
    for row in rows:
        fields=row.split(',')
        if len(fields)!=5 or fields[-1]!='1':continue
        p=folder/f'hmi_{int(fields[0]):05d}.bin'
        if not p.exists() or p.stat().st_size!=256:continue
        d=struct.unpack('<64I',p.read_bytes())
        if d[2]!=int(fields[3]) or d[2]&1:continue
        samples.append(d)
    if not samples:return {'samples':0}
    a,b=samples[0],samples[-1]
    dt=((b[3]+(b[4]<<32))-(a[3]+(a[4]<<32)))/1000
    fields=(31,32,36,37,47,48)
    result=dict(samples=len(samples),elapsed_s=dt,view=b[5],alpha=b[6],exposure=b[7],
         running=b[14],processed_delta=b[49]-a[49],display_delta=b[50]-a[50],
         error_seen=any(d[i] for d in samples for i in fields),
         config_constant=all(d[5:8]==a[5:8] for d in samples),
         all_running=all(d[14]==1 and d[19]==4 for d in samples),
         processed_fps=(b[49]-a[49])/dt if dt>0 else None,
         display_hz=(b[50]-a[50])/dt if dt>0 else None)
    records=sorted(folder.glob('spectrum_*.bin'))
    if records:
        s=struct.unpack('<32I',records[-1].read_bytes())
        result.update(spectrum_error=s[2],spectrum_results=s[5],spectrum_publications=s[22],spectrum_fs_millihz=s[27])
    return result

if __name__=='__main__':print(json.dumps(progress(Path(sys.argv[1])),indent=2))
