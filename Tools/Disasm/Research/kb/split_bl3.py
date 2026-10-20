import json
from pathlib import Path
fs=json.loads(Path('outputs/MYTHLAND/Docs/functions.json').read_text())
sel=[f for f in fs if f['slot']==4 and 0x65a9<=f['address']<0x7196]
print('COUNT',len(sel));print(' '.join(f'{f["address"]:04X}' for f in sel))
mem=(Path('work/kb/bl3_stage2_ram.bin')).read_bytes()
import sys
sys.path.insert(0,str(Path('work').resolve()))
from analyze import listing
out=[]
for n,f in enumerate(sel):
 a=f['address'];end=sel[n+1]['address'] if n+1<len(sel) else 0x7196
 out.append(f'\nFUNCTION {a:04X}');out.append(listing(list(mem),a,end))
Path('work/kb/bl3_functions.txt').write_text('\n'.join(out),encoding='utf-8')
