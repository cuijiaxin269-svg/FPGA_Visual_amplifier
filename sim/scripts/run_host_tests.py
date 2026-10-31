"""Run the migrated project's existing host tests; does not access hardware."""
from pathlib import Path
import argparse, datetime, hashlib, json, os, shutil, subprocess, sys

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--cxx',default=os.environ.get('CXX','g++'))
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--report-dir',type=Path,help='Override the report directory for an isolated run')
    a=p.parse_args(); repo=Path(__file__).resolve().parents[2]
    reports=(a.report_dir or repo/'sim/results/current_host').resolve()
    reports.mkdir(parents=True,exist_ok=True)
    receipt={'timestamp':datetime.datetime.now().astimezone().isoformat(),'status':'running','passed':False,'tests':[],'hardware_test':False,'requested_cxx':a.cxx}
    def save_receipt():
        temporary=reports/'result.json.tmp'
        temporary.write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
        temporary.replace(reports/'result.json')
    save_receipt(); exit_code=1
    try:
        cxx=shutil.which(a.cxx)
        if not cxx: raise FileNotFoundError(f'C++ compiler not found: {a.cxx}')
        out=a.output.resolve();out.mkdir(parents=True,exist_ok=True)
        env=os.environ.copy();env['PATH']=str(Path(cxx).resolve().parent)+os.pathsep+env.get('PATH','')
        receipt['cxx_version']=subprocess.check_output([cxx,'--version'],env=env,text=True)
        receipt['input_sha256']={f.relative_to(repo).as_posix():hashlib.sha256(f.read_bytes()).hexdigest() for folder in ['src/ps','sim/tests'] for f in sorted((repo/folder).rglob('*')) if f.is_file()}
        save_receipt()
        scheduler=['motion60_clip_record.c','motion60_clip_driver.c','motion60_clip_pl.c','motion60_clip_playback.c','motion60_spectrum_pl_driver.c']
        common=['hmi_protocol.c','hmi_link.c']
        tests={'test_hmi_protocol':common,'test_hmi_device':common+scheduler,'test_hmi_uart':common,'test_mode_button':scheduler,'test_alpha50_controls':scheduler,'test_border_controls':scheduler,'test_spectrum_ui':[],'test_stability':[]}
        for name,extra in tests.items():
            exe=out/(name+('.exe' if os.name=='nt' else ''))
            cmd=[cxx,'-std=c++14','-O2','-Wall','-Wextra','-Werror','-D_Static_assert=static_assert','-DMOTION60_PL_SPECTRUM',str(repo/'sim/tests'/f'{name}.cpp')]+[str(repo/'src/ps'/s) for s in extra]+['-o',str(exe)]
            test={'name':name,'compile_returncode':None,'run_returncode':None,'passed':False,'command':cmd}
            receipt['tests'].append(test);save_receipt()
            comp=subprocess.run(cmd,cwd=out,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,errors='replace')
            text=comp.stdout;test['compile_returncode']=comp.returncode
            if comp.returncode==0:
                run=subprocess.run([str(exe)],cwd=out,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,errors='replace')
                text+=run.stdout;test['run_returncode']=run.returncode
            (reports/f'{name}.log').write_text(text,encoding='utf-8')
            test['passed']=test['compile_returncode']==0 and test['run_returncode']==0
            save_receipt();print(name,'PASS' if test['passed'] else 'FAIL',flush=True)
        passed=all(x['passed'] for x in receipt['tests'])
        receipt.update(passed=passed,status='passed' if passed else 'failed')
        if passed: exit_code=0
        else: receipt['error']='One or more host tests failed; inspect tests and logs.'
    except Exception as exc:
        receipt.update(status='failed',passed=False,error=f'{type(exc).__name__}: {exc}')
        print(receipt['error'],file=sys.stderr)
    finally:
        receipt.update(returncode=exit_code,completed_at=datetime.datetime.now().astimezone().isoformat())
        save_receipt()
    raise SystemExit(exit_code)

if __name__=='__main__':main()
