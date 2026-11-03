"""V19 evidence analysis. No hardware access; never invent missing measurements.

Dependencies: numpy. Each command takes a metadata JSON and a fresh output directory.
Metadata files contain hashed source descriptors {path, sha256}; paths are relative
to the metadata file. Results report metrics, not an automatic acceptance verdict.
"""
import argparse
import csv
import hashlib
import json
from pathlib import Path
import struct
import numpy as np

BOOT_SHA = 'eae2d50a02ab3f8aaa2574d2fcd9573cc657461bc64690f1b1f17b84ba013e54'
TEXT_SHA = 'dfb0041ccc0be071ae750dd9eb7f293dda556df764a3a278e184f0f35f0c2719'

def require(ok, message):
    if not ok:
        raise ValueError(message)

def sha(path):
    with Path(path).open('rb') as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()

def source(meta, base, key):
    item = meta['sources'][key]
    path = base / item['path']
    require(sha(path)==item['sha256'], 'Source hash mismatch: '+key)
    return path

def table(path):
    with path.open(encoding='utf-8-sig',newline='') as f:
        return list(csv.DictReader(f))

def times(values):
    t = np.asarray(values,dtype=float)
    require(t.ndim==1 and len(t)>=2 and np.isfinite(t).all() and np.all(np.diff(t)>0),
            'Timestamps must be finite and strictly increasing')
    return t

def finite(values):
    x = np.asarray(values,dtype=float)
    require(np.isfinite(x).all(),'NaN/Inf measurement')
    return x

def summary(x):
    x = finite(x)
    require(len(x)>0,'Empty measurement')
    return dict(n=len(x),mean=float(x.mean()),median=float(np.median(x)),
                p95=float(np.percentile(x,95)),minimum=float(x.min()),maximum=float(x.max()))

def error_metrics(golden, actual):
    error = finite(actual)-finite(golden)
    require(error.size>0,'Empty frames')
    mse = float(np.mean(error**2))
    return dict(mae=float(np.mean(np.abs(error))),rmse=float(np.sqrt(mse)),
                max_abs=float(np.max(np.abs(error))),bias=float(np.mean(error)),
                psnr_db=None if mse==0 else float(10*np.log10(1023**2/mse)),
                exact_match=bool(mse==0))

def frame_ids(rows):
    require(len(rows)>0,'Missing frame map')
    ids = [int(r['input_id']) for r in rows]
    require(all(int(r['golden_input_id'])==int(r['fpga_input_id'])==i
                for r,i in zip(rows,ids)),'Input / golden / FPGA frame identity mismatch')
    require(len(set(ids))==len(ids) and all(b>a for a,b in zip(ids,ids[1:])),
            'Duplicate or reordered frame IDs')
    return ids

def frames(meta,base,out):
    require(meta['output_origin'] in ('physical_fpga','hls_csim','rtl_sim'), 'Label output origin')
    require(meta['golden_input_sha256']==meta['fpga_input_sha256']==meta['sources']['input']['sha256'],
            'Golden and FPGA must consume the identical input sequence')
    contract = source(meta,base,'contract')
    require(meta['golden_contract_sha256']==meta['fpga_contract_sha256']==sha(contract),
            'Golden / FPGA parameter or reset contract differs')
    arrays = [np.load(source(meta,base,k),mmap_mode='r',allow_pickle=False)
              for k in ('input','golden','fpga')]
    require(all(a.ndim==3 and a.shape==arrays[0].shape for a in arrays),'Expected equal [frame,y,x] arrays')
    ids = frame_ids(table(source(meta,base,'frame_map')))
    require(len(ids)==len(arrays[0]),'Frame map length mismatch')
    require(all(a.dtype==np.dtype('<u2') for a in arrays),'Expected RAW10 values stored as little-endian uint16')
    rows=[];n=0;abs_sum=sq_sum=signed_sum=0.;worst=0.
    for i, fid in enumerate(ids):
        require(all(a[i].max()<=1023 for a in arrays),'RAW10 value exceeds 1023')
        g,a = arrays[1][i],arrays[2][i]
        e = a.astype(float)-g.astype(float)
        n+=e.size;abs_sum+=np.abs(e).sum();sq_sum+=(e*e).sum();signed_sum+=e.sum()
        worst=max(worst,float(np.abs(e).max()))
        rows.append(dict(input_id=fid,**error_metrics(g,a)))
    with (out/'per_frame.csv').open('w',newline='',encoding='utf-8') as f:
        w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
    mse=sq_sum/n
    return dict(origin_declared=meta['output_origin'],shape=list(arrays[0].shape),
                mae=float(abs_sum/n),rmse=float(np.sqrt(mse)),max_abs=worst,bias=float(signed_sum/n),
                psnr_db=None if mse==0 else float(10*np.log10(1023**2/mse)),exact_match=bool(mse==0),
                input_sha256=meta['sources']['input']['sha256'],contract_sha256=sha(contract),
                frame_map_sha256=meta['sources']['frame_map']['sha256'],
                physical_gain_measured=False,latency_measured=False)

def fit_tone(t,x,hz):
    t=times(t);x=finite(x)
    require(x.shape==t.shape and len(x)>=20,'Need >=20 matched displacement samples')
    require(np.isfinite(hz) and hz>0 and hz*np.max(np.diff(t))<.5,'Frequency exceeds sampling limit')
    require((t[-1]-t[0])*hz>=5,'Record at least five steady-state periods')
    u=t-t[0]
    design=np.column_stack([np.sin(2*np.pi*hz*u),np.cos(2*np.pi*hz*u),np.ones(len(u)),u])
    require(np.linalg.matrix_rank(design)==4,'Degenerate sinusoidal fit')
    coef=np.linalg.lstsq(design,x,rcond=None)[0]
    residual=x-design@coef
    return dict(peak_amplitude_px=float(np.hypot(*coef[:2])),
                residual_rms_px=float(np.sqrt(np.mean(residual**2))),samples=len(t),
                duration_s=float(t[-1]-t[0]),frequency_hz=hz)

def displacement(meta,base,out):
    hz=float(meta['reference_frequency_hz'])
    require(meta['steady_state_only'] is True,'Exclude startup and parameter-change transients first')
    result={}
    for name in ('input_trace','output_trace'):
        rows=table(source(meta,base,name))
        result[name]=fit_tone([float(r['t_s']) for r in rows],[float(r['dx_px']) for r in rows],hz)
    # mm/px may also represent object-plane pixel pitch. Screen pixels must be
    # converted to the same image/object scale before forming a gain ratio.
    si,so=finite([meta['input_scale'],meta['output_scale']])
    require(si>0 and so>0 and meta['scale_unit'] in ('mm_per_pixel','input_pixels_per_pixel'),
            'Positive calibrated scales in a shared coordinate system required')
    source(meta,base,'calibration')
    ai=result['input_trace']['peak_amplitude_px']*si
    ao=result['output_trace']['peak_amplitude_px']*so
    floor=float(meta['input_amplitude_floor'])
    require(np.isfinite(floor) and floor>0,'Specify positive input noise/calibration floor')
    reliable=bool(ai>floor)
    result.update(input_amplitude=float(ai),output_amplitude=float(ao),
                  gain=float(ao/ai) if reliable else None,gain_resolved=reliable,
                  scale_unit=meta['scale_unit'],input_amplitude_floor=floor,
                  alpha_setting=meta['alpha'],
                  interpretation='Fitted fundamental peak amplitude; residual and calibration uncertainty must be reviewed')
    return result

def latency_values(rows):
    ids=[r['event_id'] for r in rows]
    require(len(ids)>0 and len(set(ids))==len(ids),'Duplicate/missing event IDs')
    a=finite([float(r['scene_time_s']) for r in rows]);b=finite([float(r['screen_time_s']) for r in rows])
    require(np.all(b>=a),'Screen event precedes source event; check pairing/clocks')
    return (b-a)*1000

def latency(meta,base,out):
    require(meta['common_clock'] is True,'End-to-end latency needs a common timebase')
    require(meta['method'] in ('high_speed_same_view','oscilloscope_photodiodes'),
            'Use physical scene and display events')
    uncertainty=float(meta['timing_uncertainty_ms'])
    require(np.isfinite(uncertainty) and uncertainty>0,'Record timing uncertainty')
    source(meta,base,'raw_capture')
    result=summary(latency_values(table(source(meta,base,'events'))))
    result.update(unit='ms',method=meta['method'],timing_uncertainty_ms=uncertainty,
                  automatic_acceptance=False)
    return result

def capture_errors(c):
    flags=[(c[33]>>10)&1,(c[33]>>11)&1,(c[33]>>9)&1]
    errors=[c[15],c[16],*flags,c[20]|int(bool(c[33]&0x587471ff or c[34]&10))]
    return flags,errors

def telemetry(folder):
    require(sha(folder/'application_text.bin')==TEXT_SHA,'Running .text does not match sealed V19')
    records=[]
    for row in table(folder/'samples.csv'):
        require(row['stable']=='1','Unstable HMI snapshot')
        d=struct.unpack('<64I',(folder/f"hmi_{int(row['sample']):05d}.bin").read_bytes())
        require(d[:2]==(0x484d4931,1) and d[2]==int(row['sequence']) and not d[2]&1,'Invalid HMI seqlock')
        records.append(dict(uptime_ms=d[3]+(d[4]<<32),running=d[14],run_status=d[19],
            view=d[5],alpha=d[6],view_actual=d[8],alpha_actual=d[9],view_valid=d[11],alpha_valid=d[12],
            exposure_target=d[7],exposure_actual=d[10],exposure_valid=d[13],
            capture_error=d[47],algorithm_error=d[48],processed=d[49],display=d[50],
            control_generations=list(d[20:24]),received_commands=d[26],
            rx_overflow=d[36],rx_errors=d[37],transport_faults=d[31],native_errors=d[32]))
    t=times([r['uptime_ms']/1000 for r in records]);duration=t[-1]-t[0]
    continuous=all(r['running']==1 and r['run_status']==4 for r in records)
    same_config=len({(r['view'],r['alpha'],r['exposure_target']) for r in records})==1
    counters_ok=all(b[k]>=a[k] for a,b in zip(records,records[1:]) for k in ('processed','display'))
    valid=continuous and same_config and counters_ok
    first,last=records[0],records[-1]
    diagnostics=[]
    for row in table(folder/'samples.csv'):
        i=int(row['sample'])
        paths=[folder/f'{name}_{i:05d}.bin' for name in ('capture','motion','spectrum','button')]
        if not all(p.exists() for p in paths):continue
        c,m,s,b=[struct.unpack('<'+str(p.stat().st_size//4)+'I',p.read_bytes()) for p in paths]
        # main.c snapshot() first copies raw sensor metadata into stats[5:7],
        # then overwrites those slots with sticky CSI error flags. JTAG can see
        # the intermediate values. Use the dedicated sticky copies at words
        # 33/34 and preserve raw stats as evidence, not as a false error count.
        flags,errors=capture_errors(c)
        diagnostics.append(dict(sample=i,sensor_id=c[6],capture_state=c[3],capture_error=c[4],
            camera_frames=c[13],camera_error_counters=errors,raw_stats_3_through_8=list(c[15:21]),
            raw_stats_mid_publish=list(c[17:20])!=flags,
            csi_sticky_isr=c[33],csi_sticky_error_bits=c[33]&0x58747fff,csi_sticky_csr=c[34],
            first_error_isr=c[53],diagnostic_rearm_enabled=c[54],camera_sequence_gaps=c[29],
            sensor_counter_mode=c[66],sensor_frame_metadata=list(c[46:50]),camera_overflow=bool(c[25]&2),
            input_width=c[26],input_height=c[27],motion_state=m[1],motion_error=m[5],
            motion_last_us=m[3],motion_max_us=m[4],history_resets=m[7],bypass=m[28],
            spectrum_state=s[1],spectrum_error=s[2],spectrum_samples=s[3],spectrum_results=s[5],
            spectrum_epoch=s[11],spectrum_fs_millihz=s[27],spectrum_publications=s[22],
            button_presses=b[3],button_accepted=b[4],button_ignored=b[7]))
    return dict(samples=len(records),duration_s=float(duration),runtime_text_matches=True,
        continuous_running_samples=continuous,stable_configuration=same_config,
        processed_counter_fps=(last['processed']-first['processed'])/duration if valid and first['view']!=0 else None,
        display_counter_hz=(last['display']-first['display'])/duration if valid else None,
        sample_errors_observed=any(r[k] for r in records for k in ('capture_error','algorithm_error','rx_overflow','rx_errors','transport_faults','native_errors')),
        records=records,diagnostics=diagnostics,physical_hdmi_verified=False,
        limitation='Sampled software counters; no claim of physical video, gap-free intersample operation or end-to-end latency')

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('mode',choices=('frames','displacement','latency','telemetry'))
    p.add_argument('input',type=Path);p.add_argument('output',type=Path)
    a=p.parse_args()
    require(not a.output.exists(),'Output must be fresh')
    a.output.mkdir(parents=True)
    if a.mode=='telemetry':
        result=telemetry(a.input)
    else:
        meta=json.loads(a.input.read_text(encoding='utf-8-sig'))
        require(meta['firmware_boot_sha256']==BOOT_SHA,'Metadata must identify sealed V19 BOOT.BIN')
        result=globals()[a.mode](meta,a.input.parent,a.output)
        result['metadata_sha256']=sha(a.input)
        result['run_id']=meta['run_id']
    result.update(analysis_tool_sha256=sha(__file__),acceptance_verdict='NOT_ASSIGNED')
    (a.output/'metrics.json').write_text(json.dumps(result,ensure_ascii=False,indent=2,allow_nan=False)+'\n',encoding='utf-8')
    print(json.dumps(result,ensure_ascii=False,indent=2,allow_nan=False))

if __name__=='__main__':
    main()
