"""Small-image C-source vs independent golden comparison, explicitly not hardware."""
from pathlib import Path
import csv
import json
import os
import subprocess
import numpy as np
from measure import sha, require, BOOT_SHA, frames
from golden import Golden
import argparse

OUT=Path(__file__).resolve().parents[1]
ROOT=OUT.parents[1]

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--full-resolution',action='store_true')
    args=parser.parse_args()
    width,height,count=(1280,800,8) if args.full_resolution else (64,64,128)
    dest=OUT/('golden_validation_full' if args.full_resolution else 'golden_validation');dest.mkdir(exist_ok=False)
    v16=ROOT/'vision/v16alpha50/ip_repo/motion60_shared/hdl/verilog'
    v19=ROOT/'vision/v19boot/ip_repo/motion60_shared/hdl/verilog'
    names={p.name for p in v16.glob('*.v')}
    require(names=={p.name for p in v19.glob('*.v')},'IP HDL inventory differs')
    matches={n:sha(v19/n) for n in sorted(names) if sha(v16/n)==sha(v19/n)}
    require(len(matches)==len(names),'V16 / sealed V19 motion IP differs')
    provenance=dict(shared_hdl_files=len(matches),shared_hdl_sha256=matches,
                    hls_sources={str(p.relative_to(ROOT)):sha(p) for p in
                     (ROOT/'vision/v16alpha50/hls/motion60_shared').glob('*') if p.is_file()},
                    scope=f'{width}x{height}, {count} frames, host C simulation; no physical FPGA or timing proof')
    (dest/'source_binding.json').write_text(json.dumps(provenance,indent=2)+'\n')
    env=dict(os.environ)
    env['PATH']=';'.join(['C:/msys64/ucrt64/bin','D:/xilinx/Vitis_HLS/2021.2/win64/lib/csim',
                          'D:/xilinx/Vitis_HLS/2021.2/win64/tools/fpo_v7_0',env.get('PATH','')])
    n=np.arange(count);x=np.arange(width)[None,:];y=np.arange(height)[:,None]
    shifts=.08*np.sin(2*np.pi*5.3*n/60.379777)
    data=np.clip(np.rint(np.array([512+180*np.cos(2*np.pi*(x-s)/16)*(1+.2*np.cos(2*np.pi*y/24)) for s in shifts])),0,1023).astype('<u2')
    np.save(dest/'input.npy',data);data.tofile(dest/'input.raw')
    rows=[]
    for alpha in (0,12,30,50):
        case=dest/f'alpha{alpha}';case.mkdir()
        runner=OUT/('offline/source_oracle_full.exe' if args.full_resolution else 'offline/source_oracle.exe')
        command=[str(runner),str(dest/'input.raw'),str(case/'csim.raw'),str(count),str(alpha)]
        run=subprocess.run(command,env=env,capture_output=True,text=True,timeout=600)
        (case/'csim.log').write_text(run.stdout+run.stderr,encoding='utf-8')
        require(run.returncode==0 and 'HOST_CSIM_COMPLETE' in run.stdout,f'C source run failed: {run.returncode}')
        coeff=[float(v) for v in next(l for l in run.stdout.splitlines() if l.startswith('COEFFICIENTS ')).split()[1:5]]
        contract=dict(mode=0,levels=3,alpha=alpha,coefficients_b0_b2_a1_a2=coeff,
                       reset_indices=[0],frame_ids=list(range(count)),sampling_hz_for_synthetic_input=60.379777)
        (case/'contract.json').write_text(json.dumps(contract,indent=2)+'\n')
        model=Golden(coeff,alpha)
        expected=np.stack([model.process(frame,reset=i==0) for i,frame in enumerate(data)])
        actual=np.fromfile(case/'csim.raw',dtype='<u2').reshape(data.shape)
        np.save(case/'golden.npy',expected);np.save(case/'csim.npy',actual)
        with (case/'frames.csv').open('w',newline='') as f:
            w=csv.writer(f);w.writerow(['input_id','golden_input_id','fpga_input_id']);w.writerows((i,i,i) for i in range(count))
        paths=dict(input=dest/'input.npy',golden=case/'golden.npy',fpga=case/'csim.npy',contract=case/'contract.json',frame_map=case/'frames.csv')
        meta=dict(run_id=f'HOST_CSIM_alpha{alpha}',firmware_boot_sha256=BOOT_SHA,output_origin='hls_csim',
                  sources={k:dict(path=os.path.relpath(p,case),sha256=sha(p)) for k,p in paths.items()},
                  golden_input_sha256=sha(dest/'input.npy'),fpga_input_sha256=sha(dest/'input.npy'),
                  golden_contract_sha256=sha(case/'contract.json'),fpga_contract_sha256=sha(case/'contract.json'))
        (case/'comparison.json').write_text(json.dumps(meta,indent=2)+'\n')
        result=frames(meta,case,case)
        result.update(alpha=alpha,physical_fpga_output=False,scope=provenance['scope'],
                      runner_sha256=sha(runner),golden_source_sha256=sha(Path(__file__).with_name('golden.py')))
        (case/'metrics.json').write_text(json.dumps(result,indent=2)+'\n')
        rows.append(result);print(json.dumps(result),flush=True)
    (dest/'summary.json').write_text(json.dumps(rows,indent=2)+'\n')

if __name__=='__main__':main()
