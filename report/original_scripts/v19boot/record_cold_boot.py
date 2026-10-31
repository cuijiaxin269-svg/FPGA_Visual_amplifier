"""Bind a read-only physical power-cycle observation to the exact application ELF."""
from pathlib import Path
from datetime import datetime, timezone, timedelta
import argparse, hashlib, json, re, struct

p=argparse.ArgumentParser()
p.add_argument('evidence_directory', type=Path)
p.add_argument('log', type=Path)
p.add_argument('--power-cycle-confirmed', action='store_true', required=True)
a=p.parse_args()
R=Path(__file__).resolve().parents[1]
E=R.parents[1]/'board_checks/20261030_v19boot_01'
sha=lambda b:hashlib.sha256(b).hexdigest()
log=a.log.read_text(encoding='utf-8',errors='replace')
assert 'V19_QSPI_COLD_BOOT_READ_ONLY_STANDBY_PASSED' in log
assert 'COLD_BOOT_MODE 0x1' in log
elf=(R/'build/candidate/motion60.elf').read_bytes()
assert elf[:6]==b'\x7fELF\x01\x01'
shoff=struct.unpack_from('<I',elf,32)[0]
shsize,shnum,shstr=struct.unpack_from('<HHH',elf,46)
headers=[struct.unpack_from('<10I',elf,shoff+i*shsize) for i in range(shnum)]
s=headers[shstr];names=elf[s[4]:s[4]+s[5]]
sections={names[h[0]:].split(b'\0',1)[0].decode():h for h in headers}
t=sections['.text'];assert t[3]==0x100000 and t[5]==69876
actual=(a.evidence_directory/'application_text.bin').read_bytes()
assert actual==elf[t[4]:t[4]+t[5]],'Actual runtime code must exactly match this candidate'
h=struct.unpack('<64I',(a.evidence_directory/'hmi.bin').read_bytes())
assert h[0]==0x484d4931 and (h[5],h[6],h[7],h[19])==(2,12,320,5)
regs=(a.evidence_directory/'boot_registers.txt').read_text(encoding='utf-8')
assert re.search(r'0xf800025c 0x00000001',regs)
first=int(re.search(r'uptime_first=(\d+)',regs).group(1))
last=int(re.search(r'uptime_last=(\d+)',regs).group(1))
assert last>first
report={
 'verified':True,'recorded_at':datetime.now(timezone(timedelta(hours=8))).isoformat(),
 'power_cycle':'Physical power-off/on confirmed by user; switches changed while off.',
 'boot_mode':1,'source':'QSPI','inspection':'Read-only; no reset, halt, ELF/bit download, START, or parameter write.',
 'application_text_bytes':len(actual),'application_text_sha256':sha(actual),
 'application_elf_sha256':sha(elf),
 'uptime_before_ms':first,'uptime_after_ms':last,
 'defaults':{'run':'STOPPED','view':2,'alpha':12,'exposure':320},
 'peripheral_functional_validation':False,'attached_peripherals':[],
 'limitations':['No camera, HDMI or HMI test.','One observed cold boot; no repeated power-cycle or long soak test.'],
 'evidence_directory':str(a.evidence_directory.resolve()),
 'evidence':{str(f.resolve()):sha(f.read_bytes()) for f in [a.log,*a.evidence_directory.iterdir()] if f.is_file()}
}
(E/'cold_boot_verified.json').write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print('V19_COLD_BOOT_RUNTIME_TEXT_AND_DEFAULTS_VERIFIED')
