from pathlib import Path
import json

BASE=Path(__file__).resolve().parents[2]
SOURCE=BASE/'work/main_analysis'
DEST=Path(__file__).resolve().parent
graphs=json.loads((SOURCE/'overlay_graphs.json').read_text(encoding='utf-8'))
segments={s['module_id']:s for s in json.loads((SOURCE/'segments.json').read_text(encoding='utf-8'))}
all_lines=[]
for graph in graphs:
    number=graph['module_id']
    if number<13: continue
    seg=segments[number]
    starts=sorted(set(graph['seeds'])|{int(k) for k in graph['call_targets'] if graph['origin']<=int(k)<graph['end']})
    print(number,seg['purpose'],','.join(f'{s:04X}' for s in starts),len(graph['instructions']))
    lines=[f'OVERLAY {number}: {seg["purpose"]}', 'CALL TARGETS '+','.join(f'{s:04X}' for s in starts)]
    for ins in graph['instructions']:
        if ins['address'] in starts: lines+=['','ROUTINE '+f'{ins["address"]:04X}']
        lines.append(f'{ins["address"]:04X} {ins["hex"]:<12} {ins["op"]}')
    (DEST/f'overlay{number:02d}.txt').write_text('\n'.join(lines)+'\n',encoding='utf-8')
    all_lines+=lines+['','']
(DEST/'overlay13_22.txt').write_text('\n'.join(all_lines)+'\n',encoding='utf-8')
