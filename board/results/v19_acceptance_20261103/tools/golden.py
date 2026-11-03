"""Independent float64 mathematical reference for V19 motion60_shared mode 0.

This is a new host reference, not a bit-accurate FPGA model. Validate numeric
tolerances against V19 hardware; do not label this output as a board measurement.
Uses explicit half-pixel bilinear resize, reflect-101 filters and 3-scale history.
Coefficients must come from the tested V19 run, not a nominal frame-rate guess.
"""
import argparse
import json
from pathlib import Path
import numpy as np
from measure import require, sha

EVEN=np.array([1,4,6,4,1],dtype=float)/16
ODD=np.array([-1,-2,0,2,1],dtype=float)/8

def sep(x,kx,ky):
    h,w=x.shape
    p=np.pad(x,((0,0),(2,2)),mode='reflect')
    a=sum(kx[i]*p[:,i:i+w] for i in range(5))
    p=np.pad(a,((2,2),(0,0)),mode='reflect')
    return sum(ky[i]*p[i:i+h,:] for i in range(5))

def up(x):
    h,w=x.shape
    def coords(n):
        p=(np.arange(2*n)+.5)/2-.5
        lo=np.floor(p).astype(int)
        return np.clip(lo,0,n-1),np.clip(lo+1,0,n-1),p-lo
    l,r,wx=coords(w);lo,hi,wy=coords(h)
    a=x[:,l]*(1-wx)+x[:,r]*wx
    return a[lo,:]*(1-wy[:,None])+a[hi,:]*wy[:,None]

class Golden:
    def __init__(self,coefficients,alpha):
        self.c=np.asarray(coefficients,dtype=float)
        require(self.c.shape==(4,) and np.isfinite(self.c).all(),'Need b0,b2,a1,a2')
        require(np.isfinite(alpha) and 0<=alpha<=50,'Alpha outside V19 range')
        self.alpha=alpha;self.state=[]

    def process(self,frame,reset=False):
        x=np.asarray(frame,dtype=float)
        require(x.ndim==2 and min(x.shape)>=64 and all(n%8==0 for n in x.shape),
                'V19 needs dimensions >=64 divisible by eight')
        require(np.isfinite(x).all() and x.min()>=0 and x.max()<=1023,'Expected RAW10 input')
        if reset:self.state=[]
        if self.state:require(self.state[0][0].shape==x.shape,'Shape changed without reset')
        bands=[]
        for _ in range(3):
            blur=sep(x,EVEN,EVEN)
            small=blur.reshape(blur.shape[0]//2,2,blur.shape[1]//2,2).mean(axis=(1,3))
            bands.append(blur-up(small));x=small
        output=[];b0,b2,a1,a2=self.c
        for level,b in enumerate(bands):
            rx,ry=sep(b,ODD,EVEN),sep(b,EVEN,ODD)
            r=np.sqrt(rx*rx+ry*ry)+1e-6
            phi=np.arctan2(b,r)
            if level>=len(self.state):self.state.append((phi.copy(),np.zeros_like(b),np.zeros_like(b)))
            phi0,z1,z2=self.state[level]
            delta=phi-phi0;y=b0*delta+z1
            self.state[level]=(phi0,-a1*y+z2,b2*delta-a2*y)
            angle=self.alpha*y
            output.append(b*np.cos(angle)+r*np.sin(angle))
        for b in reversed(output):x=b+up(x)
        return np.floor(np.clip(x,0,1023)+.5).astype('<u2')

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('input',type=Path);p.add_argument('contract',type=Path);p.add_argument('output',type=Path)
    a=p.parse_args();require(not a.output.exists(),'Fresh output directory required')
    contract=json.loads(a.contract.read_text(encoding='utf-8-sig'))
    require(contract['mode']==0 and contract['levels']==3,'Only V19 live causal three-scale mode supported')
    frames=np.load(a.input,mmap_mode='r',allow_pickle=False)
    require(frames.ndim==3 and frames.dtype==np.dtype('<u2') and len(frames)>0,'Expected uint16 [frame,y,x]')
    ids=contract['frame_ids'];resets=contract['reset_indices']
    require(len(ids)==len(frames) and len(set(ids))==len(ids) and all(b>a for a,b in zip(ids,ids[1:])), 'Invalid frame sequence')
    require(0 in resets and all(isinstance(i,int) and 0<=i<len(ids) for i in resets),'Explicit first-frame reset required')
    require(all(ids[i]==ids[i-1]+1 or i in resets for i in range(1,len(ids))), 'Frame gap requires a history reset')
    model=Golden(contract['coefficients_b0_b2_a1_a2'],contract['alpha'])
    a.output.mkdir(parents=True)
    output=np.lib.format.open_memmap(a.output/'golden.npy',mode='w+',dtype='<u2',shape=frames.shape)
    for i,frame in enumerate(frames):output[i]=model.process(frame,reset=i in resets)
    output.flush();del output
    report=dict(input_sha256=sha(a.input),contract_sha256=sha(a.contract),
                golden_sha256=sha(a.output/'golden.npy'),source_sha256=sha(__file__),
                arithmetic='float64 mathematical model, rounded/clipped RAW10 output',
                validated_against_physical_v19=False,shape=list(frames.shape))
    (a.output/'golden_receipt.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(report,indent=2))

if __name__=='__main__':main()
