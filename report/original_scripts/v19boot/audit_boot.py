from pathlib import Path
import hashlib,json,struct,zlib
R=Path(__file__).resolve().parents[1];C=R/'build/candidate'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
b=(C/'BOOT.BIN').read_bytes();u=lambda offset:struct.unpack_from('<I',b,offset)[0]
assert len(b)<=0x1000000
assert u(0x20)==0xaa995566 and u(0x24)==0x584c4e58 and u(0x28)==0
assert sum(struct.unpack_from('<11I',b,0x20))&0xffffffff==0xffffffff
assert u(0x38)==u(0x3c)==0 and u(0x34)<0x30000
assert u(u(0x98)+4)==3
offset=u(0x9c);partitions=[]
for i,name in enumerate(('fsbl.elf','capture.bit','motion60.elf')):
    p=struct.unpack_from('<16I',b,offset+i*64)
    assert sum(p)&0xffffffff==0xffffffff
    start=p[5]*4;size=p[2]*4
    assert start+size<=len(b) and p[0]==p[1]==p[2]
    assert p[6]==(0x20 if i==1 else 0x10)
    assert p[3]==p[4]==(0x100000 if i==2 else 0)
    partitions.append(dict(name=name,offset=start,bytes=size,load=p[3],entry=p[4]))
app=(C/'motion60.elf').read_bytes();phoff=struct.unpack_from('<I',app,28)[0]
phsize,phcount=struct.unpack_from('<HH',app,42)
loads=[]
for n in range(phcount):
    p=struct.unpack_from('<8I',app,phoff+phsize*n)
    if p[0]==1:loads.append(dict(address=p[3],file_bytes=p[4],memory_bytes=p[5]))
    if p[0]==1 and p[4]:
        assert p[3]==0x100000
        a=partitions[2];assert b[a['offset']:a['offset']+p[4]]==app[p[1]:p[1]+p[4]]
assert any(p['address']==0xff0000 and p['file_bytes']==0 for p in loads)
data={'boot_bytes':len(b),'flash_bytes':0x1000000,'erase_start':0,'erase_end_exclusive':(len(b)+65535)&~65535,
      'partitions':partitions,'application_segments':loads,
      'defaults':{'run':'STOPPED','view':2,'alpha':12,'exposure':320},
      'artifacts':{p.name:{'bytes':p.stat().st_size,'sha256':sha(p)} for p in C.iterdir() if p.is_file()},
      'physical_flash_boot_validated':False}
(R/'reports/boot_image_audit.json').write_text(json.dumps(data,indent=2)+'\n')
print('V19_BOOT_IMAGE_AUDIT_PASSED',len(b),'bytes; erase end',hex(data['erase_end_exclusive']))
