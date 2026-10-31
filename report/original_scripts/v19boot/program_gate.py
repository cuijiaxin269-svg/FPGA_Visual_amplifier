"""Offline preflight immediately before the explicitly requested flash write."""
from pathlib import Path
import hashlib,json,struct,zlib
from input_receipt import verify
R=Path(__file__).resolve().parents[1];W=R.parents[1];C=R/'build/candidate'
E=W/'board_checks/20261030_v19boot_01'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
verify('firmware');verify('host')
a=json.loads((R/'reports/boot_image_audit.json').read_text(encoding='utf-8'))
for name,item in a['artifacts'].items():assert sha(C/name)==item['sha256'],name
assert sha(C/'motion60.elf')==sha(R/'build/firmware/motion60.elf')
assert sha(C/'fsbl.elf')==sha(R/'build/fsbl/executable.elf')
assert sha(C/'ps7_init.c')==sha(R/'build/fsbl/ps7_init.c')
b=json.loads((E/'backup_verified.json').read_text(encoding='utf-8'))
assert b['jedec_id']=='ef4018' and b['independent_second_flash_read_matches'] and b['host_download_crc_matches']
backup=E/'flash_before_16MiB.bin';assert sha(backup)==b['full_backup_sha256']
assert backup.stat().st_size==0x1000000
v18=W/'vision/v18hmi';m=v18/'build/candidate/manifest.json'
assert sha(m)=='5c29b09fd43420001547bc04a418e1dbeaba76a6c8f97ded8eb345d9e3576855'
for f in json.loads(m.read_text(encoding='utf-8'))['files']:assert sha(v18/f['path'])==f['sha256'],f['path']
p={'authorized_task':'User requested flash consolidation; board only, functional peripheral tests deferred.',
   'mode':'qspi-x4-single','target':'first QSPI flash on MIO1..6','jedec':'ef4018',
   'image':str(C/'BOOT.BIN'),'image_sha256':sha(C/'BOOT.BIN'),
   'fsbl':str(C/'fsbl.elf'),'fsbl_sha256':sha(C/'fsbl.elf'),
   'offset':0,'bytes':a['boot_bytes'],'erase_end_exclusive':a['erase_end_exclusive'],
   'backup':str(backup),'backup_sha256':sha(backup),'baseline_preserved':True,
   'expected_jtag_boot_mode':0,'expected_runtime':'STOPPED',
   'functional_peripheral_validation':False}
(E/'programming_plan.json').write_text(json.dumps(p,indent=2)+'\n')
print('V19_PROGRAMMING_PREFLIGHT_PASSED')
