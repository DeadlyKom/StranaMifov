from pathlib import Path
import json,re
ROOT=Path(__file__).resolve().parent
notes=json.loads((ROOT/'overlay_annotations.json').read_text(encoding='utf-8'))
result=[]
for num in range(13,23):
    path=ROOT/('overlay17_expanded.txt' if num==17 else f'overlay{num:02d}.txt')
    lines=path.read_text(encoding='utf-8').splitlines()
    for key,note in notes.items():
        if not key.startswith(f'O{num}:'):continue
        addr=int(key.split(':')[1],16)
        starts=sorted(int(k.split(':')[1],16) for k in notes if k.startswith(f'O{num}:'))
        end=next((a for a in starts if a>addr),0x10000)
        block=[line for line in lines if re.match(r'^[0-9A-F]{4} ',line) and addr<=int(line[:4],16)<end]
        result+=['',key,note['purpose'],'IN '+note['inputs'],'OUT '+note['outputs'],'EFFECTS '+note.get('effects','')]
        result+= [line for line in block if re.search(r'\b(CALL|JP|PUSH|POP|EXX|EX |LD IX|LD IY|ADD IX|ADD IY|RET)\b',line)]
(ROOT/'contract_evidence.txt').write_text('\n'.join(result)+'\n',encoding='utf-8')
print('evidence written')
