from pathlib import Path
import sys,json,hashlib
ROOT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT.parent/'figures/_deps'))
import pymupdf
doc=pymupdf.open(ROOT/'report_competition_review.pdf')
expected='787db8fa20de80a88e406e5eb8bc8c3076d71592635851045bb8a8cbfb4aaadc'
assert hashlib.sha256((ROOT/'figures/template-header-logo.png').read_bytes()).hexdigest()==expected
pages=[]
for i,page in enumerate(doc):
    images=[x for x in page.get_images(full=True) if x[2:4]==(564,103)]
    rects=[r for x in images for r in page.get_image_rects(x[0])]
    assert len(rects)==1,(i,len(rects))
    rect=rects[0]
    assert 30<rect.y0<60 and rect.y1<95,(i,rect)
    assert abs((rect.x0+rect.x1)/2-page.rect.width/2)<1,(i,rect)
    text_spans=[s for b in page.get_text('dict')['blocks'] if 'lines' in b for l in b['lines'] for s in l['spans']]
    first_text_y=min(s['bbox'][1] for s in text_spans)
    assert first_text_y>rect.y1+5,(i,first_text_y,rect)
    pages.append({'page':i+1,'logo_bbox_pt':list(rect),'first_text_y_pt':first_text_y,'logo_present':True,'centered':True,'header_body_separated':True})
record={'pdf':'report_competition_review.pdf','logo_sha256':expected,'source_image_unchanged':True,'page_count':len(doc),'all_pages_have_logo':True,'pages':pages}
(ROOT/'header_validation.json').write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'pages':len(doc),'header_checks':'passed','first_page':pages[0]},ensure_ascii=False))
