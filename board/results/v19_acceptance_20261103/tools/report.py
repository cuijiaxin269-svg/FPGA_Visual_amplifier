"""Generate a scoped acceptance result from preserved raw records, never guesses."""
from datetime import datetime,timezone,timedelta
import argparse
import json
from pathlib import Path
import struct
import numpy as np
from measure import telemetry, sha, require, BOOT_SHA

ROOT=Path(__file__).resolve().parents[1]

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('output',type=Path)
    p.add_argument('--final',action='store_true')
    p.add_argument('--interrupted',action='store_true',help='Seal a failed sampling attempt; never imply completion')
    args=p.parse_args();require(not args.output.exists(),'Fresh report directory required')
    args.output.mkdir(parents=True)
    audit=json.loads((ROOT/'offline/audit.json').read_text(encoding='utf-8'))
    cold=[]
    for i in range(1,4):
        folder=ROOT/f'cold_{i:02d}';result=telemetry(folder)
        reg=dict(line.split() for line in (folder/'registers.txt').read_text().splitlines())
        ok=all(r['running']==0 and r['run_status']==5 and
               (r['view'],r['alpha'],r['exposure_target'])==(2,12,320) and
               r['processed']==r['display']==r['capture_error']==r['algorithm_error']==0 for r in result['records'])
        ok=ok and int(reg['0xf800025c'],16)==1 and int(reg['0xf8000240'],16)==0
        cold.append(dict(cycle=i,passed=ok,uptime_first_ms=result['records'][0]['uptime_ms'],
                         uptime_last_ms=result['records'][-1]['uptime_ms'],runtime_text_sha256=sha(folder/'application_text.bin')))
    buttons=struct.unpack('<16I',(ROOT/'buttons_after_01/button.bin').read_bytes())
    stopped=telemetry(ROOT/'stopped_01')
    stop_ok=all(r['running']==0 and r['run_status']==5 and not r['capture_error'] and not r['algorithm_error']
                for r in stopped['records'])
    soak=telemetry(ROOT/'soak_60m_01')
    transport_path=ROOT/'transport_interruption_01.json'
    interrupted=transport_path.exists()
    terminal_folder='soak_resume_01' if interrupted else 'soak_60m_01'
    segment_names=['soak_60m_01','reconnect_01','soak_resume_01'] if interrupted else ['soak_60m_01']
    segment_results=[(name,telemetry(ROOT/name)) for name in segment_names]
    segment_summary=[dict(folder=name,samples=value['samples'],duration_s=value['duration_s'],
                         processed_fps=value['processed_counter_fps'],display_hz=value['display_counter_hz'])
                     for name,value in segment_results]
    gaps=[]
    if interrupted:
        for (an,a),(bn,b) in zip(segment_results,segment_results[1:]):
            gaps.append(dict(before=an,after=bn,seconds=(b['records'][0]['uptime_ms']-a['records'][-1]['uptime_ms'])/1000))
        soak['records']=[];soak['diagnostics']=[]
        for name,value in segment_results:
            for record in value['records']:
                soak['records'].append(dict(record,source_segment=name))
            for diagnostic in value['diagnostics']:
                soak['diagnostics'].append(dict(diagnostic,source_segment=name,source_sample=diagnostic['sample'],sample=len(soak['diagnostics'])))
        soak['samples']=len(soak['records'])
        soak['duration_s']=(soak['records'][-1]['uptime_ms']-soak['records'][0]['uptime_ms'])/1000
        for key in ('continuous_running_samples','stable_configuration','runtime_text_matches'):
            soak[key]=all(value[key] for _,value in segment_results)
        soak['sample_errors_observed']=any(value['sample_errors_observed'] for _,value in segment_results)
        soak['processed_counter_fps']=(soak['records'][-1]['processed']-soak['records'][0]['processed'])/soak['duration_s']
        soak['display_counter_hz']=(soak['records'][-1]['display']-soak['records'][0]['display'])/soak['duration_s']
        soak['limitation']+='; endpoint rates include explicitly recorded unobserved transport gaps'
    r=soak['records'];d=soak['diagnostics'];dt=soak['duration_s']
    times=np.array([v['uptime_ms']/1000 for v in r]);intervals=np.diff(times)
    all_defaults=all((v['view'],v['alpha'],v['exposure_target'])==(2,12,320) and
                      (v['view_actual'],v['alpha_actual'],v['exposure_actual'])==(2,12,320) and
                      v['view_valid'] and v['alpha_valid'] and v['exposure_valid'] for v in r)
    diagnostics_clean=bool(d) and all(not any(v['camera_error_counters']) and not v['camera_overflow'] and
                        not v['csi_sticky_error_bits'] and not v['first_error_isr'] and not v['diagnostic_rearm_enabled'] and
                        not v['camera_sequence_gaps'] and
                        v['sensor_id']==0x9281 and v['input_width']==1280 and v['input_height']==800 and
                        v['capture_state']==2 and v['motion_state']==2 and
                        v['capture_error']==v['motion_error']==v['spectrum_error']==0 and not v['bypass'] for v in d)
    no_resets=len({v['history_resets'] for v in d})==1 and len({v['spectrum_epoch'] for v in d})==1
    spectrum_progress=all(b['spectrum_publications']>a['spectrum_publications'] for a,b in zip(d,d[1:]))
    completed='V19_READ_ONLY_OBSERVATION_COMPLETE' in (ROOT/(terminal_folder+'.log')).read_text(encoding='utf-8-sig')
    final_failure_path=ROOT/'transport_interruption_02.json'
    sampling_failed=final_failure_path.exists() and not completed
    failure=json.loads(final_failure_path.read_text(encoding='utf-8')) if sampling_failed else None
    if args.interrupted:
        require(args.final and sampling_failed and failure['process_exit']==1,'Interrupted finalization requires recorded failed collector')
    command_changes=[i for i in range(1,len(r)) if r[i]['received_commands']!=r[i-1]['received_commands']]
    epoch_changes=[i for i in range(1,len(d)) if d[i]['spectrum_epoch']!=d[i-1]['spectrum_epoch']]
    event_path=ROOT/'spectrum_restart_01.json'
    event=json.loads(event_path.read_text(encoding='utf-8')) if event_path.exists() else {}
    known_user_change=(event.get('status')=='user_confirmed_parameter_adjustment' and
                       command_changes==[161] and epoch_changes==[161])
    continuous_run_ok=bool(completed and dt>=3600 and soak['samples']==361 and soak['continuous_running_samples'] and
                  soak['stable_configuration'] and not soak['sample_errors_observed'] and
                  all_defaults and diagnostics_clean and len({v['history_resets'] for v in d})==1 and
                  spectrum_progress and max(intervals)<20 and
                  soak['processed_counter_fps'] and soak['display_counter_hz'])
    soak_pass=continuous_run_ok and no_resets and not command_changes and not interrupted
    recovered_complete=bool(interrupted and completed and dt>=3600 and
                 soak['continuous_running_samples'] and not soak['sample_errors_observed'] and
                 all_defaults and diagnostics_clean and known_user_change and spectrum_progress and
                 len({v['history_resets'] for v in d})==1)
    status=('SAMPLING_INTERRUPTED_NOT_COMPLETE' if sampling_failed else
            'PASS_SCOPED' if soak_pass else 'IN_PROGRESS' if not completed else
            'COMPLETED_WITH_PARAMETER_CHANGE_AND_OBSERVATION_GAPS' if recovered_complete else
            'COMPLETED_WITH_USER_PARAMETER_CHANGES' if continuous_run_ok and known_user_change else 'REVIEW_REQUIRED')
    segments=[]
    def add_segment(start,last):
        if last>start:
            segments.append(dict(first_sample=start,last_sample=last,
                                 source_segment=r[start].get('source_segment','soak_60m_01'),
                                 duration_s=(r[last]['uptime_ms']-r[start]['uptime_ms'])/1000))
    start=0
    for i in range(1,len(r)):
        if i in command_changes:
            add_segment(start,i-1);start=i+1
        elif r[i].get('source_segment')!=r[i-1].get('source_segment'):
            add_segment(start,i-1);start=i
    add_segment(start,len(r)-1)
    summary=dict(recorded_at=datetime.now(timezone(timedelta(hours=8))).isoformat(),
       firmware_boot_sha256=BOOT_SHA,source_manifest_passed=audit['files_passed']==audit['files_checked'],
       source_files=audit['files_checked'],host_tests_passed=sum(t['passed'] for t in audit['host_tests']),
       physical_key_passed=buttons[3]==buttons[4]==buttons[6]==2 and buttons[7]==0,
       physical_key_counts=dict(presses=buttons[3],accepted=buttons[4],completed=buttons[6]),
       stopped_passed=stop_ok,cold_boot=cold,
       soak=dict(status=status,fixed_configuration_60min_passed=soak_pass,
                 duration_s=dt,samples=soak['samples'],collector_complete=completed,
                 sampling_terminated=sampling_failed,terminal_failure=failure,
                 terminal_collector=terminal_folder,transport_interrupted=interrupted,
                 observation_segments=segment_summary,unobserved_gaps=gaps,
                 observed_segment_duration_s=sum(v['duration_s'] for _,v in segment_results),
                 rate_scope='Endpoint counter rate across observed span, including unobserved gaps' if interrupted else 'Continuous sampled segment',
                 command_change_samples=command_changes,spectrum_epoch_change_samples=epoch_changes,
                 user_confirmed_parameter_adjustment=known_user_change,
                 sampled_unchanged_control_segments=segments,
                 parameters_applied=all_defaults,diagnostics_clean=diagnostics_clean,no_history_or_spectrum_resets=no_resets,
                 all_spectrum_intervals_advanced=spectrum_progress,max_sample_gap_s=float(max(intervals)),
                 capture_mid_publish_samples=[v['sample'] for v in d if v['raw_stats_mid_publish']],
                 processed_frames=r[-1]['processed']-r[0]['processed'],display_frames=r[-1]['display']-r[0]['display'],
                 processed_fps=soak['processed_counter_fps'],display_counter_hz=soak['display_counter_hz'],
                 spectrum_publication_hz=(d[-1]['spectrum_publications']-d[0]['spectrum_publications'])/dt),
       physical_video_evidence='User-confirmed HDMI image/spectrum at start; no continuous independent receiver recording',
       incomplete=['Physical FPGA frame-by-frame input / golden / output comparison',
                   'End-to-end scene-to-screen latency','Calibrated physical displacement amplification',
                   'Absolute frequency error against known vibration reference'],
       overall_final_acceptance='INCOMPLETE')
    if args.final:
        require(completed or args.interrupted,'Collector still running; cannot create final report')
        require((ROOT/'post_soak_01/application_text.bin').is_file(),'Need final running-code identity snapshot')
        summary['post_soak_runtime_text_matches']=sha(ROOT/'post_soak_01/application_text.bin')==sha(ROOT/'soak_60m_01/application_text.bin')
        require(summary['post_soak_runtime_text_matches'],'End code differs from start')
        end_check=telemetry(ROOT/'post_soak_01')
        summary['post_soak_last_state']=end_check['records'][-1]
        summary['post_soak_last_diagnostic']=end_check['diagnostics'][-1]
    if known_user_change:
        summary['incomplete'].append('Uninterrupted 60-minute fixed-parameter soak; user chose the original end time after adjusting gain')
    if interrupted:
        summary['incomplete'].append('Uninterrupted observation: JTAG USB FT_Write failure interrupted sampling; resumed without board reset')
    for name in ('golden_validation','golden_validation_full'):
        path=ROOT/name/'summary.json'
        if path.exists():summary[name]=json.loads(path.read_text())
    (args.output/'summary.json').write_text(json.dumps(summary,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
    (args.output/'telemetry.json').write_text(json.dumps(soak,indent=2)+'\n')
    lines=['V19 本轮验收结果（2026-11-03）',
      '总体：尚未完成全部最终验收；具体通过范围与剩余项如下。',
      f"封存版本：{audit['files_passed']}/{audit['files_checked']} 文件哈希匹配，8/8 主机回归通过。",
      f"实体 KEY0：按下/接受/完成={buttons[3]}/{buttons[4]}/{buttons[6]}；STOP 检查={stop_ok}。",
      f"真实冷启动：{sum(x['passed'] for x in cold)}/3 次，均有用户断电确认、QSPI 寄存器与 V19 运行代码。",
      f"采样点参数：VIEW2 / alpha12 / 曝光320；长稳状态={summary['soak']['status']}。",
      ('20:48 左右用户确认操作过增益并恢复12，频谱epoch由3变11；用户选择仍按原计划结束。此轮不能称为60分钟固定参数无重建通过。' if known_user_change else '未记录已确认的人工中途调参。'),
      (f"USB/JTAG采样中断后只读重连；各段观测累计 {summary['soak']['observed_segment_duration_s']:.3f} s，观测空档共 {sum(x['seconds'] for x in gaps):.3f} s。以下全程平均速率来自首尾计数，包含未观测区间，不能称为无间断采样。" if interrupted else '本段未记录采样链路中断。'),
      ('续采再次出现 Invalid context，采样进程退出；唯一一次只读结束核验仍匹配V19且应用运行正常。没有继续重试，60分钟验收未完成。首次错误为FT_Write failed，二者根因未独立确定。' if sampling_failed else '未记录续采失败。'),
      f"首尾计数跨度 {dt:.3f} s（含已列出的观测空档），{soak['samples']} 个样本；处理 {summary['soak']['processed_frames']} 帧，显示 {summary['soak']['display_frames']} 次。",
      f"处理吞吐 {soak['processed_counter_fps']} FPS；显示计数 {soak['display_counter_hz']} Hz；频谱发布 {summary['soak']['spectrum_publication_hz']:.4f} 次/s。",
      f"错误诊断清洁={diagnostics_clean}；历史/频谱未重置={no_resets}；各频谱采样区间均有更新={spectrum_progress}。",
      'HDMI 画面/频谱与按键触屏效果有用户现场确认；没有独立全时 HDMI 接收录像。',
      '量化软件：独立黄金参考和 HLS C 模型已建立同输入、同参数、同帧号与逐帧误差对应，详见 golden_validation*。',
      '以上仿真输出不是实板 FPGA 像素；实际 FPGA 逐帧闭环、端到端延迟、位移倍率和已知源频率误差仍待测。',
      '完整方法、输入格式、测量限制见上级 MEASUREMENT_GUIDE.txt；人工观察记录见 user_observations.json。']
    (args.output/'验收结果.txt').write_text('\n\n'.join(lines)+'\n',encoding='utf-8')
    print(json.dumps({k:v for k,v in summary.items() if not k.startswith('golden_')},indent=2,ensure_ascii=False))

if __name__=='__main__':main()
