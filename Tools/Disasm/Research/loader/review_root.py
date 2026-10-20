from pathlib import Path
import json
ROOT=Path(__file__).resolve().parent
graphs=json.loads((ROOT.parent/'main_analysis/overlay_graphs.json').read_text(encoding='utf-8'))
for g in graphs:
    if g['module_id']>12:continue
    lines=[f'ROOT REVIEW OVERLAY {g["module_id"]}']
    lines.extend(f'{i["address"]:04X} {i["hex"]:<12} {i["op"]}' for i in g['instructions'])
    (ROOT/f'rootcheck{g["module_id"]:02d}.txt').write_text('\n'.join(lines)+'\n',encoding='utf-8')
