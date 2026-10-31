"""Prove that reused PL and the new PS boot platform differ only at QSPI MIO."""
from pathlib import Path
import copy, hashlib, json, re, zipfile
import xml.etree.ElementTree as E
R=Path(__file__).resolve().parents[1]; B=R.parent/'v18hmi'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def canonical(n):
    return (n.tag,tuple(sorted(n.attrib.items())),(n.text or '').strip(),tuple(sorted(canonical(c) for c in n)))
with zipfile.ZipFile(B/'build/candidate/capture.xsa') as a, zipfile.ZipFile(R/'build/candidate/capture.xsa') as b:
    x,y=E.fromstring(a.read('capture.hwh')),E.fromstring(b.read('capture.hwh'))
    x.attrib.pop('TIMESTAMP');y.attrib.pop('TIMESTAMP')
    px=x.find(".//MODULE[@INSTANCE='ps']/PARAMETERS");py=y.find(".//MODULE[@INSTANCE='ps']/PARAMETERS")
    assert px is not None and py is not None
    dx={p.get('NAME'):p.get('VALUE') for p in px};dy={p.get('NAME'):p.get('VALUE') for p in py}
    assert dx.keys()==dy.keys()
    changes={k:[dx[k],dy[k]] for k in dx if dx[k]!=dy[k]}
    allowed={'PCW_ACT_QSPI_PERIPHERAL_FREQMHZ','PCW_QSPI_PERIPHERAL_DIVISOR0','PCW_EN_QSPI',
      'PCW_QSPI_PERIPHERAL_ENABLE','PCW_QSPI_QSPI_IO','PCW_QSPI_GRP_SINGLE_SS_ENABLE',
      'PCW_QSPI_GRP_SINGLE_SS_IO','PCW_SINGLE_QSPI_DATA_MODE','PCW_MIO_TREE_PERIPHERALS','PCW_MIO_TREE_SIGNALS'}
    allowed|={f'PCW_MIO_{i}_{s}' for i in range(1,7) for s in ('PULLUP','IOTYPE','DIRECTION','SLEW')}
    assert changes.keys()<=allowed,changes.keys()-allowed
    for k in ('PCW_MIO_TREE_PERIPHERALS','PCW_MIO_TREE_SIGNALS'):
        assert all(i in range(1,7) or aa==bb for i,(aa,bb) in enumerate(zip(dx[k].split('#'),dy[k].split('#'))))
    for p in py:
        if p.get('NAME') in changes:p.set('VALUE',dx[p.get('NAME')])
    assert canonical(x)==canonical(y),'Non-QSPI hardware difference'
    cx,cy=E.fromstring(a.read('capture_csi_0.hwh')),E.fromstring(b.read('capture_csi_0.hwh'))
    cx.attrib.pop('TIMESTAMP');cy.attrib.pop('TIMESTAMP')
    assert canonical(cx)==canonical(cy)
    assert a.read('capture.bit')==(R/'build/candidate/capture.bit').read_bytes()
    for name in ('ps7_init.c','ps7_init.h','ps7_init.tcl'):(R/'build/candidate'/name).write_bytes(b.read(name))
    # ps7_init write sequences: permit only QSPI MIO, QSPI clock/reset/enable.
    def writes(data):
        return [s.strip() for s in data.decode().splitlines() if s.strip().startswith(('mask_write','mask_poll','mask_delay'))]
    wa,wb=writes(a.read('ps7_init.tcl')),writes(b.read('ps7_init.tcl'))
    addresses={0xf8000700+4*i for i in range(1,7)}|{0xf800014c,0xf800012c,0xf800020c}
    def unrelated(w):
        return [s for s in w if int(s.split()[1],16) not in addresses]
    assert unrelated(wa)==unrelated(wb),'PS init changed beyond QSPI registers'
    # APER_CLK_CTRL shares other peripherals: only QSPI bit 23 may change.
    for old,new in zip([s for s in wa if '0XF800012C' in s.upper()],[s for s in wb if '0XF800012C' in s.upper()]):
        assert all(((int(aa,16)^int(bb,16))&~(1<<23))==0 for aa,bb in zip(old.split()[2:],new.split()[2:]))
report={'pl_semantically_identical':True,'csi_hwh_identical':True,'bit_reused_sha256':sha(R/'build/candidate/capture.bit'),
        'xsa_sha256':sha(R/'build/candidate/capture.xsa'),'ps_changes':changes,
        'ps_init_non_qspi_identical':True,'layout_route_inherited_from':'v18hmi verified implementation',
        'new_place_route_performed':False,'new_xsa_contains_bit':False}
(R/'reports/platform_compatibility.json').write_text(json.dumps(report,indent=2)+'\n')
print('V19_PLATFORM_COMPATIBILITY_PASSED',len(changes),'QSPI-only parameters')
