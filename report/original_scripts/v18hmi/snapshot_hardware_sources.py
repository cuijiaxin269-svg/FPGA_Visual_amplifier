"""Capture and verify all custom HDL/IP inputs; generate a relocatable project recipe."""
from pathlib import Path
import hashlib, json, shutil, xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
W = ROOT.parents[1]
PROJECT = W/'b18hw'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def quote(s):
    assert not any(c in s for c in '{}\r\n')
    return '{'+s+'}'

manifest = json.loads((W/'vision/v16alpha50/build/candidate/manifest.json').read_text())
for entry in manifest['files']:
    if entry['path'].startswith('ip_repo/'):
        source = W/'vision/v16alpha50'/entry['path']
        assert sha(source) == entry['sha256'], 'Baseline IP changed: '+entry['path']
        target = ROOT/entry['path']
        target.parent.mkdir(parents=True, exist_ok=True)
        if target.exists(): assert sha(target) == entry['sha256']
        else: shutil.copy2(source, target)

lines = ['# Generated from the actual b18hw file list; custom inputs verified byte-for-byte.',
         'set root [file normalize [file join [file dirname [info script]] ..]]',
         'if {$argc!=1} {error "Usage: fresh-project-directory"}',
         'set destination [file normalize [lindex $argv 0]]',
         'if {[file exists $destination]} {error "Preserve existing destination"}',
         'create_project c $destination -part xc7z100ffg900-2',
         'set_property target_language Verilog [current_project]',
         'set_property ip_repo_paths [glob -types d [file join $root ip_repo *]] [current_project]',
         'update_ip_catalog']
receipt = []
tree = ET.parse(PROJECT/'c.xpr')
for fs in tree.findall('./FileSets/FileSet'):
    if fs.get('Name') not in ('sources_1', 'constrs_1'): continue
    for node in fs.findall('File'):
        path = node.get('Path')
        if '/rtl/' not in path and '/constraints/' not in path: continue
        assert path.startswith('$PPRDIR/')
        source = (PROJECT/path[len('$PPRDIR/'):]).resolve()
        folder = 'rtl' if '/rtl/' in path else 'constraints'
        target = ROOT/folder/source.name
        assert sha(source) == sha(target), 'Candidate HDL differs from active project: '+source.name
        relative = target.relative_to(ROOT).as_posix()
        receipt.append({'active_path': source.as_posix(), 'independent_path': relative, 'sha256': sha(source)})
        lines += ['set f [file join $root '+quote(relative)+']', f'add_files -fileset {fs.get("Name")} -norecurse $f']
        attrs = node.findall('./FileInfo/Attr')
        used = [a.get('Val') for a in attrs if a.get('Name') == 'UsedIn']
        for kind in ('synthesis', 'implementation', 'simulation'):
            if fs.get('Name') == 'constrs_1' and kind == 'simulation': continue
            lines.append(f'set_property USED_IN_{kind.upper()} '+('true' if kind in used else 'false')+' [get_files $f]')
        for attr in attrs:
            if attr.get('Name') == 'ProcessingOrder':
                lines.append('set_property PROCESSING_ORDER '+attr.get('Val')+' [get_files $f]')
lines += ['source [file join $root project capture_hmi_bd.tcl]',
          'validate_bd_design', 'save_bd_design',
          'generate_target all [get_files capture.bd]',
          'add_files -norecurse [make_wrapper -files [get_files capture.bd] -top]',
          'set_property top capture_wrapper [current_fileset]',
          'set_property IS_ENABLED false [get_files -all *rgb2dvi_clocks.xdc]',
          'update_compile_order -fileset sources_1',
          'puts HMI_STANDALONE_PROJECT_CREATED', 'close_project', 'exit']
(ROOT/'scripts/create_standalone.tcl').write_text('\n'.join(lines)+'\n')
(ROOT/'provenance/hardware_sources.json').write_text(json.dumps(receipt, indent=2)+'\n')
shutil.copy2(W/'vision/v11resetfix/scripts/check_motion60_single_clock.tcl', ROOT/'scripts/check_motion60_single_clock.tcl')
# Keep the tested physical acceptance gates for a standalone full rebuild,
# while removing only the dependency on the original workspace/checkpoint.
driver = (ROOT/'scripts/build_hardware.tcl').read_text()
driver = driver.replace('set workspace [file normalize [file join $root .. ..]]\nset baseline [file join $workspace vision v11resetfix]\nset project [file join $workspace b18hw c.xpr]',
    'if {!$argc} {error "Usage: project.xpr ?restart-impl?"}\n'
    'set project [file normalize [lindex $argv 0]]\n'
    'set argv [lrange $argv 1 end];incr argc -1\n'
    'set report_root [file join $root reports standalone];file mkdir $report_root')
driver = driver.replace('verify_gate_sources.tcl', 'verify_standalone_sources.tcl')
driver = driver.replace('[file join $root reports ', '[file join $report_root ')
# The report_root declaration must continue to name the source root.
driver = driver.replace('set report_root [file join $report_root standalone]', 'set report_root [file join $root reports standalone]')
driver = driver.replace('set_property INCREMENTAL_CHECKPOINT [file join $workspace b16hw c.runs impl_1 capture_wrapper_routed.dcp]', 'set_property INCREMENTAL_CHECKPOINT {}')
driver = driver.replace('set variant hmi2021', 'set variant standalone_hmi2021')
driver = driver.replace('[file join $baseline scripts check_motion60_single_clock.tcl]', '[file join $root scripts check_motion60_single_clock.tcl]')
driver = driver.replace('set output [file join $root build candidate]', 'set output [file join $root build standalone_candidate]')
assert '$workspace' not in driver and '$baseline' not in driver
(ROOT/'scripts/build_standalone.tcl').write_text(driver)
check = (ROOT/'scripts/verify_gate_sources.tcl').read_text()
check = check.replace('set own [file normalize [file join $workspace b18hw]]', 'set own [file normalize [get_property DIRECTORY [current_project]]]')
check = check.replace('[file join $workspace vision v16alpha50 ip_repo', '[file join $root ip_repo')
assert '$workspace' not in check
(ROOT/'scripts/verify_standalone_sources.tcl').write_text(check)
print('HMI_INDEPENDENT_HDL_IP_SOURCES_VERIFIED')
