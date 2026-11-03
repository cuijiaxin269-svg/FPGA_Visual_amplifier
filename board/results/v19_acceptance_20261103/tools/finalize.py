"""Seal this completed acceptance record, preserving previous failed attempts."""
import hashlib
import json
from pathlib import Path
import zipfile
import argparse
from datetime import datetime,timezone,timedelta
from measure import sha, require

ROOT=Path(__file__).resolve().parents[1]

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--report-dir',default='final_report')
    args=parser.parse_args()
    report=(ROOT/args.report_dir/'summary.json').resolve()
    require(report.is_relative_to(ROOT.resolve()),'Report must remain inside this evidence directory')
    require(report.is_file(),'Final report missing')
    for owner in [ROOT/'server_ownership.json',*ROOT.glob('session_*/server_ownership.json')]:
        if owner.exists():
            cleanup=owner.with_name('server_cleanup.json')
            require(cleanup.is_file() and json.loads(cleanup.read_text(encoding='utf-8-sig'))['stopped'],
                    'Owned JTAG server cleanup not recorded: '+str(owner))
    result=json.loads(report.read_text(encoding='utf-8'))
    require(result['soak']['collector_complete'] or result['soak'].get('sampling_terminated'),
            'Collector is neither completed nor a documented terminated attempt')
    archive=ROOT.parent/'V19_acceptance_20261103.zip'
    manifest=ROOT/'evidence_manifest.json'
    require(not archive.exists() and not manifest.exists(),'Preserve existing sealed evidence')
    paths=sorted(p for p in ROOT.rglob('*') if p.is_file() and '__pycache__' not in p.parts)
    content=dict(created_at=datetime.now(timezone(timedelta(hours=8))).isoformat(),
                 current_report=report.relative_to(ROOT).as_posix(),
                 firmware_boot_sha256=result['firmware_boot_sha256'],
                 overall_final_acceptance=result['overall_final_acceptance'],
                 files=[dict(path=p.relative_to(ROOT).as_posix(),bytes=p.stat().st_size,sha256=sha(p)) for p in paths])
    manifest.write_text(json.dumps(content,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
    with zipfile.ZipFile(archive,'x',compression=zipfile.ZIP_DEFLATED,compresslevel=6) as z:
        for p in paths+[manifest]:z.write(p,ROOT.name+'/'+p.relative_to(ROOT).as_posix())
    with zipfile.ZipFile(archive) as z:
        require(z.testzip() is None,'Archive CRC failed')
        for item in content['files']:
            with z.open(ROOT.name+'/'+item['path']) as f:
                require(hashlib.file_digest(f,'sha256').hexdigest()==item['sha256'],'Archive content hash mismatch')
    receipt=dict(path=str(archive),bytes=archive.stat().st_size,sha256=sha(archive),file_count=len(paths)+1,archive_verified=True)
    (ROOT.parent/'V19_acceptance_20261103_zip_receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
    print(json.dumps(receipt,indent=2))

if __name__=='__main__':main()
