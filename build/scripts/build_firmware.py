"""Build the existing bare-metal ARM application with an explicitly selected AMD toolchain."""
from pathlib import Path
import argparse, datetime, hashlib, json, os, subprocess, sys

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--tool-root', default=os.environ.get('AMD_TOOLS_ROOT'), help='AMD unified installation root, e.g. .../2025.2')
    parser.add_argument('--output', type=Path, required=True, help='Fresh/output build directory outside the source tree')
    parser.add_argument('--report-dir', type=Path, help='Override the report directory for an isolated run')
    args = parser.parse_args()
    repo = Path(__file__).resolve().parents[2]
    report = (args.report_dir or repo/'build/reports/firmware_2025_2').resolve()
    report.mkdir(parents=True,exist_ok=True)
    receipt = {'timestamp':datetime.datetime.now().astimezone().isoformat(),'status':'running','passed':False,'board_tested':False,'tool_root':args.tool_root}
    def save_receipt():
        temporary = report/'result.json.tmp'
        temporary.write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
        temporary.replace(report/'result.json')
    save_receipt()
    exit_code = 1
    try:
        if not args.tool_root: raise ValueError('--tool-root or AMD_TOOLS_ROOT is required')
        tool = Path(args.tool_root).resolve()
        gccdir = tool/'gnu/aarch32/nt/gcc-arm-none-eabi/bin'
        suffix = '.exe' if os.name == 'nt' else ''
        gcc = gccdir/('arm-none-eabi-gcc'+suffix)
        size = gccdir/('arm-none-eabi-size'+suffix)
        for executable in (gcc,size):
            if not executable.is_file(): raise FileNotFoundError(f'Tool not found: {executable}')
        out = args.output.resolve(); out.mkdir(parents=True, exist_ok=True)
        sources = ['start.S','main.c','platform.c','ov9281.c','motion60.c','motion60_spectrum_pl_driver.c','motion60_clip_record.c','motion60_clip_driver.c','motion60_clip_pl.c','motion60_clip_playback.c','hmi_protocol.c','hmi_link.c','hmi_uart.c']
        defines = ['MOTION60_HMI','MOTION60_BUTTON','MOTION60_CAMERA_CONTROLS','MOTION60_FIRMWARE','MOTION60_SPECTRUM','MOTION60_CLIP','MOTION60_PL_OFFLINE','MOTION60_PL_SPECTRUM']
        cmd = [str(gcc)] + ['-D'+x for x in defines] + ['-mcpu=cortex-a9','-marm','-mfloat-abi=soft','-mno-unaligned-access','-O2','-g','-ffreestanding','-fno-builtin','-Wall','-Wextra','-Werror','-nostdlib',f'-Wl,--build-id=none,-Map={out / "motion60.map"}','-T',str(repo/'src/ps/link.ld')] + [str(repo/'src/ps'/x) for x in sources] + ['-lgcc','-o',str(out/'motion60.elf')]
        receipt.update(command=cmd,compiler_version=subprocess.check_output([str(gcc),'--version'],text=True),source_sha256={p.relative_to(repo).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted((repo/'src/ps').rglob('*')) if p.is_file()})
        save_receipt()
        result = subprocess.run(cmd, cwd=out, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, errors='replace')
        (report/'compile.log').write_text(result.stdout,encoding='utf-8')
        print(result.stdout)
        receipt['compile_returncode'] = result.returncode
        if result.returncode: raise RuntimeError(f'ARM compilation failed with exit code {result.returncode}')
        receipt['elf_sha256'] = hashlib.sha256((out/'motion60.elf').read_bytes()).hexdigest()
        receipt['elf_path'] = str(out/'motion60.elf')
        receipt['size'] = subprocess.check_output([str(size),str(out/'motion60.elf')],text=True)
        print(receipt['size'])
        receipt.update(status='passed',passed=True)
        exit_code = 0
    except Exception as exc:
        receipt.update(status='failed',passed=False,error=f'{type(exc).__name__}: {exc}')
        print(receipt['error'],file=sys.stderr)
    finally:
        receipt.update(returncode=exit_code,completed_at=datetime.datetime.now().astimezone().isoformat())
        save_receipt()
    raise SystemExit(exit_code)

if __name__ == '__main__': main()
