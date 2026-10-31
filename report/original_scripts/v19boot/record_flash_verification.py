"""Require board-side final readback proof before recording programming success."""
from pathlib import Path
from datetime import datetime, timezone, timedelta
import hashlib, json, struct, zlib

R = Path(__file__).resolve().parents[1]
E = R.parents[1] / 'board_checks/20261030_v19boot_01'
C = R / 'build/candidate'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
plan = json.loads((E/'programming_plan.json').read_text(encoding='utf-8'))
log = (E/'recover_program.log').read_text(encoding='utf-8', errors='replace')
assert 'RECOVERY_DDR_CRC_ID_BIT_COMPATIBILITY_AND_UNTOUCHED_TAIL_VERIFIED' in log
assert 'V19_FULL_IMAGE_READBACK_AND_UNTOUCHED_TAIL_VERIFIED' in log
image = (C/'BOOT.BIN').read_bytes()
assert sha(C/'BOOT.BIN') == plan['image_sha256']
assert sha(Path(plan['backup'])) == plan['backup_sha256']
before = struct.unpack('<64I', (E/'recovery_ready.bin').read_bytes())
after = struct.unpack('<64I', (E/'recovery_verified.bin').read_bytes())
assert before[0] == after[0] == 0x51575031
assert before[1] == 3 and after[1] == 6
assert before[2] == after[2] == after[9] == zlib.crc32(image) == 0x84cb6227
assert before[3] == after[3] == 0xef4018
assert before[5] == after[5] == len(image)
assert before[6] == after[6] == 0
assert before[8] == after[8] == after[13] == 0x15890968
assert after[10] == 0x41524d31 and after[14] == 0
assert after[11] + after[12] == (len(image) + 255)//256
evidence = ['recover_program.log', 'recovery_ready.bin', 'recovery_verified.bin',
            'program_flash_attempt01.log', 'program_flash_attempt02.log',
            'recover_program_bulk_attempt01.log', 'recover_program_guard_attempt02.log',
            'recover_program_cpu_attempt03.log', 'recover_program_api_attempt04.log',
            'recover_program_ap_attempt05.log', 'recover_program_ap_attempt06.log',
            'recover_program_resume_attempt07.log', 'recover_program_page_attempt08.log',
            'failed_page_rx.bin', 'failed_page_expected.bin', 'failed_page_diag.bin',
            'qspi_program_attempt01.c', 'qspi_program_attempt01.elf']
report = {
    'verified': True,
    'recorded_at': datetime.now(timezone(timedelta(hours=8))).isoformat(),
    'image_bytes': len(image), 'image_sha256': sha(C/'BOOT.BIN'),
    'image_crc32': f'{after[9]:08x}', 'jedec': f'{after[3]:06x}',
    'method': 'Board-side XQspiPs writer; bounded 256-byte page programs; no additional erase.',
    'verification': 'Every page compared byte-for-byte against CRC-checked DDR image; complete final Flash image CRC32; unchanged tail CRC32.',
    'programmed_pages': after[11], 'identical_skipped_pages': after[12],
    'final_status_register_1': after[14],
    'untouched_tail': {'start': 0xcb0000, 'end_exclusive': 0x1000000, 'crc32': f'{after[13]:08x}'},
    'initial_erase': 'Official program_flash attempt 1 erased and blank-checked [0, 0xcb0000).',
    'official_programmer_attempts': {'count': 2, 'successful': False, 'reason': 'Stalled during host chunk transfer.'},
    'bulk_upload_attempt': 'FT_Write I/O error; helper rejected incomplete DDR image before issuing Flash commands.',
    'upload_recovery': 'User replaced USB cable; preserved DDR and resumed at byte 8060928; complete DDR CRC verified before programming.',
    'initial_recovery_page_program': 'Readback rejected the first new page at 0x320000 after only its first four data bytes were programmed. Fixed writer to pass NULL receive buffer for transmit-only commands, as required by qspips_v3_9 dummy-data optimization. Same image retained in DDR and revalidated; no new erase.',
    'helper_source_sha256': sha(R/'board/qspi_program.c'),
    'helper_elf_sha256': sha(R/'build/qspi_program.elf'),
    'backup_sha256': plan['backup_sha256'],
    'evidence': {name: sha(E/name) for name in evidence},
    'cold_boot_validated_by_this_report': False,
}
(E/'flash_verified.json').write_text(json.dumps(report, indent=2, ensure_ascii=False)+'\n', encoding='utf-8')
print('V19_FLASH_VERIFICATION_RECORDED', after[11], 'programmed;', after[12], 'already identical pages')
