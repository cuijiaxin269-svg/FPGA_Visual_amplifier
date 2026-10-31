"""Run the existing spectrum UI host/RTL comparison with Vivado's simulator."""
from pathlib import Path
import argparse, datetime, hashlib, json, os, shutil, subprocess, sys

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--vivado-root',required=True)
    p.add_argument('--cxx',default=os.environ.get('CXX','g++'))
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--report-dir',type=Path,help='Override the report directory for an isolated run')
    a=p.parse_args();repo=Path(__file__).resolve().parents[2]
    report=(a.report_dir or repo/'sim/results/vivado_2025_2').resolve()
    report.mkdir(parents=True,exist_ok=True)
    receipt={'timestamp':datetime.datetime.now().astimezone().isoformat(),'status':'running','passed':False,'steps':[],'hardware_test':False,'requested_cxx':a.cxx,'vivado_root':a.vivado_root}
    def save_receipt():
        temporary=report/'result.json.tmp'
        temporary.write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
        temporary.replace(report/'result.json')
    save_receipt();exit_code=1
    try:
        cxx=shutil.which(a.cxx)
        if not cxx: raise FileNotFoundError(f'C++ compiler not found: {a.cxx}')
        tool=Path(a.vivado_root).resolve()/'bin'
        for name in ['xvlog.bat','xelab.bat','xsim.bat']:
            if not (tool/name).is_file():raise FileNotFoundError(f'Vivado simulator tool not found: {tool/name}')
        out=a.output.resolve();out.mkdir(parents=True,exist_ok=True)
        env=os.environ.copy();env['PATH']=str(Path(cxx).resolve().parent)+os.pathsep+env.get('PATH','')
        exe=out/'test_spectrum_ui.exe'
        files=['src/rtl/motion60_spectrum_overlay.v','sim/tests/reference_spectrum_overlay.v','sim/tests/tb_spectrum_ui.sv','sim/tests/test_spectrum_ui.cpp','src/ps/spectrum_ui.h','data/inputs/multitone/spectrum_00_values.bin']
        receipt['source_sha256']={f:hashlib.sha256((repo/f).read_bytes()).hexdigest() for f in files}
        save_receipt()
        commands=[('compile_host',[cxx,'-std=c++14','-O2','-Wall','-Wextra','-Werror',str(repo/'sim/tests/test_spectrum_ui.cpp'),'-o',str(exe)]),('prepare_packet',[str(exe),str(repo/'data/inputs/multitone/spectrum_00_values.bin'),str(out/'ui_packet.hex')]),('xvlog',[str(tool/'xvlog.bat'),'--sv',str(repo/'src/rtl/motion60_spectrum_overlay.v'),str(repo/'sim/tests/reference_spectrum_overlay.v'),str(repo/'sim/tests/tb_spectrum_ui.sv')]),('xelab',[str(tool/'xelab.bat'),'tb_spectrum_ui','--timescale','1ns/1ps','-s','ui_test']),('xsim',[str(tool/'xsim.bat'),'ui_test','-runall','-log',str(out/'ui_rtl.log')])]
        for name,cmd in commands:
            step={'name':name,'command':cmd,'returncode':None}
            receipt['steps'].append(step);save_receipt()
            result=subprocess.run(cmd,cwd=out,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,errors='replace')
            (report/f'{name}.log').write_text(result.stdout,encoding='utf-8')
            step['returncode']=result.returncode;save_receipt();print(name,result.returncode,flush=True)
            if result.returncode: raise RuntimeError(f'{name} failed with exit code {result.returncode}')
        log=(out/'ui_rtl.log').read_text(errors='replace')
        (report/'ui_rtl.log').write_text(log,encoding='utf-8')
        if 'SPECTRA_RTL_PASSED' not in log or 'Fatal:' in log:
            raise RuntimeError('RTL simulation did not produce a valid SPECTRA_RTL_PASSED result')
        receipt.update(passed=True,status='passed');exit_code=0
    except Exception as exc:
        receipt.update(status='failed',passed=False,error=f'{type(exc).__name__}: {exc}')
        print(receipt['error'],file=sys.stderr)
    finally:
        receipt.update(returncode=exit_code,completed_at=datetime.datetime.now().astimezone().isoformat())
        save_receipt()
    raise SystemExit(exit_code)

if __name__=='__main__':main()
