"""Prevent Vivado address replication across a RAMB36 cascade pair.

This adds a synthesis-only attribute; FIFO storage/control/latency are unchanged.
Run after HLS export, before creating or rebuilding the Vivado project.
"""
import argparse,hashlib,json
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('files',nargs='+',type=Path);a=p.parse_args()
rows=[]
for path in a.files:
 raw=path.read_bytes();text=raw.decode()
 for name in ('raddr','waddr'):
  old=f'    reg  [MEM_AWIDTH-1:0] {name};'
  new=f'    (* DONT_TOUCH = "true" *) reg  [MEM_AWIDTH-1:0] {name};'
  if text.count(new)==1:continue
  if text.count(old)!=1:raise ValueError(f'Unexpected FIFO template: {path}')
  text=text.replace(old,new)
 path.write_bytes(text.encode())
 rows.append(dict(path=str(path),before=hashlib.sha256(raw).hexdigest(),after=hashlib.sha256(path.read_bytes()).hexdigest()))
print(json.dumps(rows,indent=2))
