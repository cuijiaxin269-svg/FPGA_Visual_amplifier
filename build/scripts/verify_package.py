"""Verify the published file inventory without modifying files or contacting hardware."""
from pathlib import Path
import argparse, hashlib, json, sys
import xml.etree.ElementTree as ET

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--manifest',type=Path)
    a=p.parse_args();root=Path(__file__).resolve().parents[2]
    manifest=a.manifest or root/'report/file_manifest.json'
    if not manifest.is_file():raise SystemExit(f'Manifest not found: {manifest}')
    data=json.loads(manifest.read_text(encoding='utf-8'));errors=[]
    for row in data['files']:
        f=root/row['path']
        if not f.is_file():errors.append('missing: '+row['path']);continue
        if hashlib.sha256(f.read_bytes()).hexdigest()!=row['sha256']:errors.append('changed: '+row['path'])
    ns={'s':'http://www.spiritconsortium.org/XMLSchema/SPIRIT/1685-2009'}
    checked=0
    for f in (root/'src/ip').glob('*/component.xml'):
        tree=ET.parse(f)
        for node in tree.findall('.//s:file/s:name',ns):
            name=node.text or ''
            if '$' in name:continue
            checked+=1
            if not (f.parent/name).exists():errors.append(f'IP reference missing: {f.relative_to(root)} -> {name}')
    print(json.dumps({'inventory_files':len(data['files']),'ip_references_checked':checked,'errors':errors,'passed':not errors},ensure_ascii=False,indent=2))
    return 1 if errors else 0

if __name__=='__main__':sys.exit(main())
