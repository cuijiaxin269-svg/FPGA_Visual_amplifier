from pathlib import Path
import re, json

ROOT=Path(__file__).resolve().parent
REPO_URL='https://github.com/cuijiaxin269-svg/FPGA_Visual_amplifier'
expected={
 'overview.tex': [('section','作品概述'),('subsection','功能与特性'),('subsection','应用领域'),('subsection','主要技术特点'),('subsection','主要性能指标'),('subsection','主要创新点'),('subsection','设计流程')],
 'methods.tex': [('section','系统组成及功能说明'),('subsection','整体介绍'),('subsection','硬件系统介绍'),('subsubsection','硬件整体介绍'),('subsubsection','机械设计介绍'),('subsubsection','电路各模块介绍'),('subsection','软件系统介绍'),('subsubsection','软件整体介绍'),('subsubsection','软件各模块介绍')],
 'results.tex': [('section','完成情况及性能参数'),('subsection','整体介绍'),('subsection','工程成果'),('subsubsection','机械成果'),('subsubsection','电路成果'),('subsubsection','软件成果'),('subsection','特性成果')],
 'conclusion.tex': [('section','总结'),('subsection','可扩展之处'),('subsection','心得体会')],
 'references.tex': [('section','参考文献')]
}
sources={p.name:p.read_text(encoding='utf-8') for p in (ROOT/'sections').glob('*.tex')}
for name, headings in expected.items():
    pos=-1
    for level,title in headings:
        match=re.search(r'\\'+level+r'\{'+re.escape(title)+r'\}',sources[name][pos+1:])
        assert match,(name,level,title)
        pos+=1+match.end()

def visible(s):
    s=re.sub(r'(?<!\\)%[^\n]*','',s)
    s=re.sub(r'\\reportfig\{[^}]*\}\{[^}]*\}\{([^}]*)\}\{[^}]*\}',r'\1',s)
    s=re.sub(r'\\(?:label|addcontentsline)\{[^}]*\}(?:\{[^}]*\}){0,2}','',s)
    s=re.sub(r'\\cite\{[^}]*\}','[1]',s)
    s=re.sub(r'\\ref\{[^}]*\}','0-0',s)
    s=re.sub(r'\\begin\{tabularx\}[^\n]*','',s)
    s=re.sub(r'\\(?:begin|end)\{[^}]*\}(?:\[[^]]*\])?','',s)
    s=re.sub(r'\\(?:zihao|vspace|hspace|Needspace)\*?\{[^}]*\}','',s)
    for cmd,char in [('times','×'),('alpha','α')]:s=s.replace('\\'+cmd,char)
    s=s.replace(r'\%','%').replace(r'\_','_')
    s=re.sub(r'\\[A-Za-z]+\*?','',s)
    s=re.sub(r'[{}$&~\\\s]','',s)
    return s

lengths=[]
abstract=sources['abstract.tex'].split(r'\vspace',1)[0]
# The abstract heading is included, making the count conservative.
lengths.append({'section':'摘要','count':len(visible(abstract)),'limit':800})
for fname, limits in [('overview.tex',[400,400,400,200,200,200]),('conclusion.tex',[300,1000])]:
    parts=re.split(r'\\subsection\{([^}]*)\}',sources[fname])
    for i,limit in enumerate(limits):
        title, body=parts[1+2*i:3+2*i]
        lengths.append({'section':title,'count':len(visible(body)),'limit':limit})
assert all(x['count']<=x['limit'] for x in lengths),lengths
references=len(re.findall(r'\\bibitem(?:\[[^]]*\])?\{',sources['references.tex']))
assert references<=20
main=(ROOT/'main.tex').read_text(encoding='utf-8')
assert REPO_URL in main and REPO_URL in sources['results.tex'] and REPO_URL in sources['references.tex']
assert r'\begin{titlepage}' not in main
assert 'template-header-logo.png' in main and r'\fancyhead[C]{\templateheader}' in main
assert r'\renewcommand{\headrulewidth}{0.75pt}' in main
assert not re.search(r'大学|学院|学校名称|指导教师|参赛队员','\n'.join(sources.values()))
record={'template':'D:/Download/qq/技术文档模板.docx','format_requirements':'D:/Download/qq/排版.txt','structure':'五部分及模板固定小节已按顺序检查；允许增加内部细分','word_limit_method':'移除LaTeX控制命令后按非空可见字符保守计数，含数字、英文、标点、表格及题注，不计图内文字','word_limits':lengths,'references':references,'reference_limit':20,'school_or_team_identifiers_found':False,'github':{'url':REPO_URL,'in_title_page':True,'in_reproduction_section':True,'in_references':True},'rubric_weights':[30,20,20,15,15],'rubric_note':'内容与证据对应，不代表评委评分结果','paragraph_layout':'A4纵向、四边2.5cm、小四正文及1.5倍行距按用户明确排版要求；不复制Word模板的空段或编号残留'}
record['paragraph_layout']='A4纵向，正文左右/下边距2.5cm；模板原图页眉距顶约1.5cm，预留顶部约3.3cm正文起点；正文小四及1.5倍行距'
record['template_visuals']={'header_asset':'figures/template-header-logo.png','source_member':'word/media/image1.png','all_pages_including_first':True,'width_mm':65.158,'height_mm':11.924,'bottom_rule_pt':0.75,'footer':'居中9pt页码'}
(ROOT/'template_validation.json').write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(record,ensure_ascii=False))
