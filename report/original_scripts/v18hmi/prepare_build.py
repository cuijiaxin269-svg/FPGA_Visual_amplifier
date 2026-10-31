"""Create the candidate build driver from the baseline's complete physical gates."""
from pathlib import Path
import hashlib,json
r=Path(__file__).resolve().parents[1]
b=r.parent/'v16alpha50'
p=r/'scripts/build_hardware.tcl'
assert not p.exists(), 'Do not overwrite an existing build driver'
s=(b/'scripts/build_hardware_2021.tcl').read_text()
s=s.replace('b16hw c.xpr','b18hw c.xpr')
s=s.replace('[file join $root provenance v15_postroute.dcp]', '[file join $workspace b16hw c.runs impl_1 capture_wrapper_routed.dcp]')
s=s.replace('set variant alpha502021','set variant hmi2021')
s=s.replace('ALPHA50_2021_BIT_BUILT_REQUIRES_RUNTIME_VALIDATION','HMI_2021_BIT_BUILT_REQUIRES_RUNTIME_VALIDATION')
needle='set key [get_ports key0_n]'
s=s.replace(needle, '''foreach {name pin direction} {hmi_uart_tx AH12 OUT hmi_uart_rx AG12 IN} {
 set port [get_ports $name]
 if {[llength $port]!=1 || [get_property PACKAGE_PIN $port] ne $pin || [get_property IOSTANDARD $port] ne "LVCMOS33" || [get_property DIRECTION $port] ne $direction} {error "HMI UART pin binding: $name"}
}
puts HMI_P4_IO_BINDING_VERIFIED
'''+needle)
p.write_text(s)
s=(b/'scripts/verify_gate_sources.tcl').read_text().replace('b16hw','b18hw')
s=s.replace('[file join $root ip_repo', '[file join $workspace vision v16alpha50 ip_repo')
(r/'scripts/verify_gate_sources.tcl').write_text(s)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
(r/'provenance/baseline.json').write_text(json.dumps(dict(
 baseline='vision/v16alpha50',manifest_sha256=sha(b/'build/candidate/manifest.json'),
 bit_sha256=sha(b/'build/candidate/capture.bit'),elf_sha256=sha(b/'build/candidate/motion60.elf'),
 files=[dict(path=p.relative_to(b).as_posix(),sha256=sha(p)) for sub in ('sw','rtl','constraints') for p in sorted((b/sub).rglob('*')) if p.is_file()]
),indent=2))
