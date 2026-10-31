"""Build a matching, unencrypted Zynq QSPI image in a fresh output directory.

Uses XSCT/HSI and the selected AMD tool installation. Never accesses a board.
The checks target this project's CPU0 / UART0 / QSPI / 16 MiB boot contract.
"""
from pathlib import Path
import argparse
import datetime
import hashlib
import json
import os
import re
import shutil
import struct
import subprocess
import sys
import zipfile


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def sha256_file(path):
    digest = hashlib.sha256()
    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(block)
    return digest.hexdigest()


def fingerprint(path):
    path = Path(path)
    return {'path': str(path), 'bytes': path.stat().st_size,
            'sha256': sha256_file(path)}


def write_json(path, data):
    temporary = path.with_suffix(path.suffix + '.tmp')
    temporary.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n',
                         encoding='utf-8')
    temporary.replace(path)


def check_xsa_bit(xsa, bit):
    with zipfile.ZipFile(xsa) as archive:
        members = [info for info in archive.infolist()
                   if not info.is_dir() and info.filename.lower().endswith('.bit')]
        require(len(members) == 1,
                f'XSA must contain exactly one bitstream; found {len(members)}')
        member = members[0]
        require(member.file_size == bit.stat().st_size,
                'Embedded XSA bitstream and supplied bitstream have different lengths')
        digest = hashlib.sha256()
        with archive.open(member) as stream:
            for block in iter(lambda: stream.read(1024 * 1024), b''):
                digest.update(block)
        expected = sha256_file(bit)
        require(digest.hexdigest() == expected,
                'Embedded XSA bitstream does not match supplied bitstream')
        return {'member': member.filename, 'bytes': member.file_size,
                'sha256': expected, 'matched': True}


def check_fsbl_parameters(fsbl):
    headers = list(fsbl.rglob('xparameters.h'))
    require(len(headers) == 1,
            f'Expected one generated BSP xparameters.h; found {len(headers)}')
    text = headers[0].read_text(encoding='utf-8', errors='replace')
    macros = dict(re.findall(r'^\s*#define\s+(\w+)\s+([^\r\n]+)', text, re.M))

    def number(name):
        seen = set()
        for _ in range(16):
            require(name in macros and name not in seen,
                    f'Unable to resolve generated BSP macro: {name}')
            seen.add(name)
            value = macros[name].split('/*', 1)[0].split('//', 1)[0].strip()
            value = value.strip('() \t')
            if re.fullmatch(r'(?:0[xX][0-9a-fA-F]+|[0-9]+)[uUlL]*', value):
                return int(re.sub(r'[uUlL]+$', '', value), 0)
            require(re.fullmatch(r'\w+', value),
                    f'Unsupported BSP macro expression: {name}={value}')
            name = value
        raise RuntimeError('BSP macro recursion limit exceeded')

    stdout = number('STDOUT_BASEADDRESS')
    # AMD's 2025.2 FSBL accepts both the legacy HSI and newer base-address name.
    qspi_names = [name for name in ('XPAR_PS7_QSPI_LINEAR_0_S_AXI_BASEADDR',
                                  'XPAR_PS7_QSPI_LINEAR_0_BASEADDRESS') if name in macros]
    require(qspi_names, 'Generated BSP has no supported QSPI linear address macro')
    qspi_values = {name: number(name) for name in qspi_names}
    require(stdout == 0xE0000000, f'FSBL stdout must be UART0, found {stdout:#x}')
    require(all(value == 0xFC000000 for value in qspi_values.values()),
            f'Expected Zynq QSPI linear address, found {qspi_values}')
    return {'header': str(headers[0]), 'sha256': sha256_file(headers[0]),
            'stdout_baseaddress': stdout, 'qspi_linear_baseaddress': 0xFC000000,
            'qspi_macros': qspi_values}


def audit_boot_image(boot, app):
    """Apply the existing project's unencrypted, three-partition boot contract."""
    data = boot.read_bytes()
    require(0xA0 <= len(data) <= 0x1000000,
            'Boot image is empty/truncated or exceeds the 16 MiB Flash')

    def words(offset, count):
        require(0 <= offset and offset + count * 4 <= len(data),
                'Boot header points outside the image')
        return struct.unpack_from(f'<{count}I', data, offset)

    u = lambda offset: words(offset, 1)[0]
    require(u(0x20) == 0xAA995566 and u(0x24) == 0x584C4E58,
            'Invalid Zynq boot header magic')
    require(u(0x28) == 0, 'This entry supports unencrypted boot images only')
    require(sum(words(0x20, 11)) & 0xFFFFFFFF == 0xFFFFFFFF,
            'Boot header checksum failed')
    require(u(0x38) == 0 and u(0x3C) == 0 and 0 < u(0x34) < 0x30000,
            'FSBL load/entry/size differs from the supported OCM boot contract')
    require(u(u(0x98) + 4) == 3, 'Expected exactly three boot image partitions')
    partitions = []
    base = u(0x9C)
    for index, name in enumerate(('fsbl.elf', 'capture.bit', 'motion60.elf')):
        header = words(base + index * 64, 16)
        require(sum(header) & 0xFFFFFFFF == 0xFFFFFFFF,
                f'Partition checksum failed: {name}')
        start, size = header[5] * 4, header[2] * 4
        require(start > 0 and size > 0 and start + size <= len(data),
                f'Partition extent invalid: {name}')
        require(header[0] == header[1] == header[2],
                f'Unexpected encrypted/compressed partition lengths: {name}')
        require(header[6] == (0x20 if index == 1 else 0x10),
                f'Unexpected partition target attributes: {name}')
        expected_address = 0x100000 if index == 2 else 0
        require(header[3] == header[4] == expected_address,
                f'Partition load/entry mismatch: {name}')
        partitions.append({'name': name, 'offset': start, 'bytes': size,
                           'load': header[3], 'entry': header[4]})

    elf = app.read_bytes()
    require(len(elf) >= 52 and elf[:7] == b'\x7fELF\x01\x01\x01',
            'Application must be ELF32 little-endian')
    require(struct.unpack_from('<H', elf, 18)[0] == 40,
            'Application ELF is not ARM')
    require(struct.unpack_from('<I', elf, 24)[0] == 0x100000,
            'Application ELF entry must be 0x00100000')
    phoff = struct.unpack_from('<I', elf, 28)[0]
    phsize, phcount = struct.unpack_from('<HH', elf, 42)
    require(phsize >= 32 and phcount > 0 and phoff + phsize * phcount <= len(elf),
            'Invalid application ELF program headers')
    segments = []
    payload_segments = 0
    for index in range(phcount):
        segment = struct.unpack_from('<8I', elf, phoff + phsize * index)
        if segment[0] != 1:
            continue
        address, file_bytes, memory_bytes = segment[3:6]
        segments.append({'address': address, 'file_bytes': file_bytes,
                         'memory_bytes': memory_bytes})
        require(file_bytes <= memory_bytes and segment[1] + file_bytes <= len(elf),
                'Invalid application ELF segment extent')
        if file_bytes:
            payload_segments += 1
            require(address == 0x100000,
                    'Application file-backed segment differs from the supported linker layout')
            partition = partitions[2]
            require(file_bytes <= partition['bytes'], 'Application partition is too short')
            expected = elf[segment[1]:segment[1] + file_bytes]
            actual = data[partition['offset']:partition['offset'] + file_bytes]
            require(actual == expected, 'Application payload differs from supplied ELF')
    require(payload_segments == 1, 'Expected one file-backed application load segment')
    require(any(item['address'] == 0xFF0000 and item['file_bytes'] == 0
                for item in segments), 'Expected NOLOAD mailbox at 0x00ff0000')
    return {'passed': True, 'boot_bytes': len(data), 'flash_bytes': 0x1000000,
            'partitions': partitions, 'application_segments': segments,
            'physical_flash_boot_validated': False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--tool-root', default=os.environ.get('AMD_TOOLS_ROOT'),
                        help='AMD 2025.2 unified installation root')
    parser.add_argument('--xsa', type=Path, required=True, help='New XSA including its bitstream')
    parser.add_argument('--bit', type=Path, required=True, help='Bitstream matching the XSA')
    parser.add_argument('--app', type=Path, required=True, help='New ARM application ELF')
    parser.add_argument('--app-receipt', type=Path,
                        help='Optional successful build_firmware.py result.json to bind ELF and source hashes')
    parser.add_argument('--output', type=Path, required=True, help='New output directory; must not exist')
    args = parser.parse_args()
    repo = Path(__file__).resolve().parents[2]
    out = args.output.resolve()
    if out == repo or repo in out.parents:
        parser.error('--output must be outside the source repository')
    if out.exists():
        parser.error('--output already exists; use a fresh directory, preserving previous results')
    out.mkdir(parents=True, exist_ok=False)
    reports = out/'reports'; reports.mkdir()
    receipt = {'timestamp': datetime.datetime.now().astimezone().isoformat(),
               'status': 'running', 'passed': False, 'stage': 'preflight',
               'requested_toolchain': '2025.2', 'steps': [],
               'board_runtime_validated': False, 'physical_flash_boot_validated': False}
    save = lambda: write_json(reports/'result.json', receipt)
    save()
    exit_code = 1
    try:
        require(os.name == 'nt', 'This entry currently supports the installed Windows AMD tools layout')
        require(args.tool_root, '--tool-root or AMD_TOOLS_ROOT is required')
        tool = Path(args.tool_root).resolve()
        gccdir = tool/'gnu/aarch32/nt/gcc-arm-none-eabi/bin'
        make_dir = tool/'Vitis/gnuwin/bin'
        tools = {'xsct': tool/'Vitis/bin/xsct.bat', 'make': make_dir/'make.exe',
                 'gcc': gccdir/'arm-none-eabi-gcc.exe', 'bootgen': tool/'Vitis/bin/bootgen.bat'}
        for name, executable in tools.items():
            require(executable.is_file(), f'{name} not found: {executable}')
        receipt['tools'] = {name: fingerprint(path) for name, path in tools.items()}
        source_script = Path(__file__).resolve()
        fsbl_script = source_script.with_name('create_fsbl.tcl')
        require(fsbl_script.is_file(), f'FSBL generation script not found: {fsbl_script}')
        receipt['script_sha256'] = {path.relative_to(repo).as_posix(): sha256_file(path)
                                   for path in (source_script, fsbl_script)}
        inputs = {'capture.xsa': args.xsa.resolve(), 'capture.bit': args.bit.resolve(),
                  'motion60.elf': args.app.resolve()}
        for path in inputs.values():
            require(path.is_file() and path.stat().st_size > 0, f'Input missing or empty: {path}')
        receipt['inputs'] = {name: fingerprint(path) for name, path in inputs.items()}
        receipt['xsa_bit_match'] = check_xsa_bit(inputs['capture.xsa'], inputs['capture.bit'])
        if args.app_receipt:
            app_receipt_path = args.app_receipt.resolve()
            app_receipt = json.loads(app_receipt_path.read_text(encoding='utf-8'))
            require(app_receipt.get('status') == 'passed' and app_receipt.get('passed') is True
                    and app_receipt.get('returncode') == 0, 'Application build receipt is not passed')
            require(app_receipt.get('elf_sha256') == receipt['inputs']['motion60.elf']['sha256'],
                    'Application ELF differs from its build receipt')
            receipt['app_build_receipt'] = fingerprint(app_receipt_path)
            receipt['application_source_sha256'] = app_receipt.get('source_sha256', {})
        artifacts = out/'artifacts'; artifacts.mkdir()
        for name, path in inputs.items():
            shutil.copy2(path, artifacts/name)
            require(sha256_file(artifacts/name) == receipt['inputs'][name]['sha256'],
                    f'Input changed during copy: {name}')
        # Verify the frozen copies that will actually be passed to XSCT and bootgen.
        check_xsa_bit(artifacts/'capture.xsa', artifacts/'capture.bit')
        temporary = out/'tmp'; temporary.mkdir()
        env = os.environ.copy()
        env.update(TEMP=str(temporary), TMP=str(temporary), PYTHONUTF8='1')
        env['PATH'] = os.pathsep.join((str(gccdir), str(make_dir), str(tool/'Vitis/bin'), env.get('PATH', '')))

        def run(name, command, cwd):
            receipt['stage'] = name
            step = {'name': name, 'command': [str(item) for item in command],
                    'cwd': str(cwd), 'returncode': None}
            receipt['steps'].append(step); save()
            with (reports/f'{name}.log').open('w', encoding='utf-8') as log:
                result = subprocess.run(step['command'], cwd=cwd, env=env,
                                        stdout=log, stderr=subprocess.STDOUT)
            step['returncode'] = result.returncode; save()
            require(result.returncode == 0,
                    f'{name} failed with exit code {result.returncode}; inspect {name}.log')

        run('compiler_version', [tools['gcc'], '--version'], out)
        fsbl = out/'fsbl'
        run('generate_fsbl', [tools['xsct'], fsbl_script, artifacts/'capture.xsa', fsbl], out)
        require((fsbl/'Makefile').is_file(),
                'XSCT/HSI did not generate the expected FSBL Makefile; this tool interface requires adaptation')
        receipt['fsbl_parameters'] = check_fsbl_parameters(fsbl)
        generated_sources = {path.relative_to(fsbl).as_posix(): sha256_file(path)
                             for path in fsbl.rglob('*') if path.is_file()}
        write_json(reports/'generated_fsbl_sources.json', generated_sources)
        receipt['generated_fsbl_sources'] = fingerprint(reports/'generated_fsbl_sources.json')
        save()
        run('build_fsbl', [tools['make'], '-j1', '-B', 'CFLAGS=-DFSBL_DEBUG_INFO -mno-unaligned-access'], fsbl)
        require((fsbl/'executable.elf').is_file(), 'FSBL build did not produce executable.elf')
        shutil.copy2(fsbl/'executable.elf', artifacts/'fsbl.elf')
        for name in ('ps7_init.c', 'ps7_init.h'):
            candidates = list(fsbl.rglob(name))
            require(candidates, f'Generated initialization source missing: {name}')
            require(len({sha256_file(path) for path in candidates}) == 1,
                    f'Conflicting generated initialization sources: {name}')
            shutil.copy2(candidates[0], artifacts/name)
        (artifacts/'boot.bif').write_text(
            'the_ROM_image:\n{\n  [bootloader] fsbl.elf\n  capture.bit\n  motion60.elf\n}\n',
            encoding='ascii')
        run('bootgen', [tools['bootgen'], '-arch', 'zynq', '-image', 'boot.bif',
                        '-o', 'boot.bin', '-w', 'on'], artifacts)
        require((artifacts/'boot.bin').is_file(), 'Bootgen did not produce boot.bin')
        require((artifacts/'boot.bin').stat().st_size <= 0x1000000,
                'Boot image exceeds the physical 16 MiB Flash')
        run('bootgen_read', [tools['bootgen'], '-arch', 'zynq', '-read', 'boot.bin'], artifacts)
        receipt['stage'] = 'static_boot_audit'; save()
        audit = audit_boot_image(artifacts/'boot.bin', artifacts/'motion60.elf')
        write_json(reports/'boot_image_audit.json', audit)
        receipt['outputs'] = {path.name: fingerprint(path) for path in artifacts.iterdir() if path.is_file()}
        receipt.update(status='passed', passed=True, stage='complete')
        exit_code = 0
        print(f'BOOT_IMAGE_BUILT_AND_STATICALLY_CHECKED: {artifacts / "boot.bin"}')
        print('No Flash programming, board download, or cold-boot test was performed.')
    except (Exception, KeyboardInterrupt) as exc:
        receipt.update(status='failed', passed=False, error=f'{type(exc).__name__}: {exc}')
        print(receipt['error'], file=sys.stderr)
    finally:
        receipt.update(returncode=exit_code, completed_at=datetime.datetime.now().astimezone().isoformat())
        save()
    raise SystemExit(exit_code)


if __name__ == '__main__':
    main()
