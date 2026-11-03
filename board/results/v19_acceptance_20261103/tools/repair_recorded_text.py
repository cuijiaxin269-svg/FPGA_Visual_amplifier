"""Restore exact chat confirmations damaged by Windows shell argument encoding."""
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
texts={
 'soak_gain_adjustment':'是，我刚才操作了增益，最后恢复为 12',
 'soak_original_end_time':'仍按原计划约 21:22 结束，如实记录中途调参',
 'usb_failure_video_still_running':'HDMI 和频谱仍正常，刚才没有动线缆',
 'second_jtag_failure_video_still_running':'HDMI 和频谱仍正常，板卡没有断电或复位',
}
def write(p,d):p.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
p=ROOT/'user_observations.json';d=json.loads(p.read_text(encoding='utf-8'))
for row in d['observations']:
    if row['id'] in texts:row['statement']=texts[row['id']]
write(p,d)
p=ROOT/'spectrum_restart_01.json';d=json.loads(p.read_text(encoding='utf-8'))
d['user_confirmation']=texts['soak_gain_adjustment'];d['end_time_choice']=texts['soak_original_end_time'];write(p,d)
for filename,key in [('transport_interruption_01.json','usb_failure_video_still_running'),
                     ('transport_interruption_02.json','second_jtag_failure_video_still_running')]:
    p=ROOT/filename;d=json.loads(p.read_text(encoding='utf-8'));d['user_observation']=texts[key];write(p,d)
write(ROOT/'text_encoding_correction.json',dict(reason='Chinese text passed through a shell -c argument was corrupted; restored from exact user chat replies using this UTF-8 source file',
      scope=list(texts),old_report='final_report is an unsealed draft with corrupted terminal_failure.user_observation text; use final_report_v2'))
print('CONFIRMATION_TEXT_UTF8_RESTORED')
