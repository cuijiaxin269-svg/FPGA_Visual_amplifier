from pathlib import Path
p=Path(__file__).resolve().parents[1]/'sw/motion60.c'
s=p.read_text()
needle='if(tm[8]==2){button_cancel();tm[8]=0;stop_requested=1;}'
assert s.count(needle)==3
s=s.replace(needle,'''if(tm[8]==2){button_cancel();tm[8]=0;stop_requested=1;
#ifdef MOTION60_HMI
 hmi_external_stop();
#endif
 }''')
needle='if(tm[8]==2){tm[8]=0;stop_requested=1;}'
assert s.count(needle)==1
s=s.replace(needle,'''if(tm[8]==2){tm[8]=0;stop_requested=1;
#ifdef MOTION60_HMI
 hmi_external_stop();
#endif
 }''')
for action,engine,view in ((1,1,'spectrum_enable?2u:1u'),(3,2,'0u')):
 needle=f'if(tm[8]=={action} && mailbox.status!=2 && !busy&&!spectrum_has_work()){{tm[8]=0;enabled={engine};first=1;last_slot=3;last_events=0;stop_requested=0;mailbox.electrical_ok=0x9281;mailbox.command=4;}}'
 assert needle in s
 s=s.replace(needle,needle[:-1]+f'''
#ifdef MOTION60_HMI
 hdev.target[HMI_VIEW]={view};hdev.requested_run=1;hbooting=1;
 hstatus(HMI_RUN,HMI_WAIT);hstatus(HMI_VIEW,HMI_WAIT);
#endif
 }}''')
p.write_text(s)
