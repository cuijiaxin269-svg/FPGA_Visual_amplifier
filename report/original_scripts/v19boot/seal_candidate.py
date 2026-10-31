"""Seal source/build evidence only after successful board-side verification."""
from pathlib import Path
import hashlib,json,shutil,zipfile
from datetime import datetime,timezone,timedelta
R=Path(__file__).resolve().parents[1];W=R.parents[1];C=R/'build/candidate';E=W/'board_checks/20261030_v19boot_01'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
log=(E/'recover_program.log').read_text(encoding='utf-8',errors='replace')
assert 'V19_FULL_IMAGE_READBACK_AND_UNTOUCHED_TAIL_VERIFIED' in log
verified=json.loads((E/'flash_verified.json').read_text(encoding='utf-8'))
assert verified['verified'] and verified['image_sha256']==sha(C/'BOOT.BIN')
assert verified['helper_source_sha256']==sha(R/'board/qspi_program.c')
assert verified['helper_elf_sha256']==sha(R/'build/qspi_program.elf')
for name,digest in verified['evidence'].items():assert sha(E/name)==digest
plan=json.loads((E/'programming_plan.json').read_text(encoding='utf-8'))
assert sha(C/'BOOT.BIN')==plan['image_sha256']
assert sha(C/'fsbl.elf')==plan['fsbl_sha256']
assert sha(Path(plan['backup']))==plan['backup_sha256']
for n in ('routed_timing.txt','routed_drc.txt','routed_cdc.txt','routed_bus_skew.txt','board_validation.json'):
    shutil.copy2(R.parent/'v18hmi/reports'/n,R/'provenance'/('v18_'+n))
for name in ('programming_plan.json','backup_verified.json','handoff_assessment.json','flash_verified.json'):
    shutil.copy2(E/name,R/'reports'/name)
board_evidence=R/'reports/board_evidence';board_evidence.mkdir(exist_ok=True)
for p in E.iterdir():
    if p.is_file() and p.suffix in ('.json','.log','.bin','.txt','.c','.elf') and p.name!='flash_before_16MiB.bin':
        shutil.copy2(p,board_evidence/p.name)
for p in E.glob('cold_boot*'):
    if p.is_dir():shutil.copytree(p,board_evidence/p.name,dirs_exist_ok=True)
recovery=R/'recovery';recovery.mkdir(exist_ok=True)
shutil.copy2(Path(plan['backup']),recovery/'flash_before_16MiB.bin')
shutil.copy2(E/'backup_verified.json',recovery/'backup_verified.json')
for name in ('qspi_program.elf','qspi_read.elf','qspi_verify.elf'):
    p=R/'build'/name
    if p.exists():shutil.copy2(p,recovery/name)
shutil.copytree(E/'tools',R/'provenance/executed_board_tools',dirs_exist_ok=True)
fsbl=R/'build/fsbl';dest=R/'provenance/fsbl_sources';dest.mkdir(exist_ok=True)
for p in fsbl.iterdir():
    if p.is_file() and (p.suffix in ('.c','.h','.S','.ld') or p.name=='Makefile'):shutil.copy2(p,dest/p.name)
shutil.copy2(fsbl/'zynq_fsbl_bsp/system.mss',dest/'system.mss')
shutil.copy2(fsbl/'zynq_fsbl_bsp/ps7_cortexa9_0/include/xparameters.h',dest/'xparameters.h')
cold_file=E/'cold_boot_verified.json'
cold=json.loads(cold_file.read_text(encoding='utf-8')) if cold_file.exists() else {'verified':False}
if cold['verified']:
    assert cold['application_elf_sha256']==sha(C/'motion60.elf')
    for path,digest in cold['evidence'].items():assert sha(Path(path))==digest
if cold_file.exists():shutil.copy2(cold_file,R/'reports/cold_boot_verified.json')
paths=[]
for folder in ('sw','sim','rtl','constraints','ip_repo','project','scripts','provenance','reports','board','recovery','build/candidate'):
    paths.extend(p for p in (R/folder).rglob('*') if p.is_file() and '__pycache__' not in p.parts and p.name!='manifest.json')
paths += [R/'README.txt',R/'ACCEPTANCE.txt']
data={'schema':'motion60-qspi-boot-v1','sealed_at':datetime.now(timezone(timedelta(hours=8))).isoformat(),
      'baseline':'v18hmi','toolchain':'Vivado/Vitis 2021.2','pl_reused':True,
      'flash_program_verified':True,'flash_platform':'qspi-x4-single','flash_id':'ef4018',
      'programming_method':verified['method'],'official_programmer_success':False,
      'cold_boot':cold,'boot_defaults':{'run':'STOPPED','view':2,'alpha':12,'exposure':320},
      'peripheral_functional_validation':False,'reason':'User has only the board; camera, HDMI and HMI not attached.',
      'backup':plan['backup'],'backup_sha256':plan['backup_sha256'],
      'files':[{'path':p.relative_to(R).as_posix(),'bytes':p.stat().st_size,'sha256':sha(p)} for p in sorted(set(paths))]}
(C/'manifest.json').write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
with zipfile.ZipFile(R/'build/v19boot_source_and_candidate.zip','w',zipfile.ZIP_DEFLATED) as z:
    for p in sorted(set(paths+[C/'manifest.json'])):z.write(p,'v19boot/'+p.relative_to(R).as_posix())
print('V19_SOURCE_AND_BOOT_CANDIDATE_SEALED',len(paths),'files')
