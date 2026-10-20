from pathlib import Path
import json,sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import decoder
BASE=Path(__file__).resolve().parents[2]
ROOT=Path(__file__).resolve().parent
functions=json.loads((BASE/'outputs/MYTHLAND/Docs/functions.json').read_text(encoding='utf-8'))
memory=[0]*65536
source=(BASE/'work/kb/bl3_stage2.bin').read_bytes()
memory[0x6149:0x6149+len(source)]=source
dec=decoder(memory)
subset=[f for f in functions if f['block']=='S04' and f['address']>=0x7196]
print('FUNCTIONS',len(subset))
lines=[]
for func in subset:
    address=func['address']
    print(f'{address:04X}',func['description'],len(func['instructions']))
    lines+=['',f'ROUTINE {address:04X}',func['description']]
    for a in func['instructions']:
        ins=dec.disassemble(a,a+1,'h')[0]
        lines.append(f'{a:04X} {bytes(ins.data).hex(" "):<15} {ins.operation}')
(ROOT/'bl3_functions7196.txt').write_text('\n'.join(lines)+'\n',encoding='utf-8')
