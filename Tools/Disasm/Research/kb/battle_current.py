import json
from pathlib import Path
fs=json.loads(Path('outputs/MYTHLAND/Docs/functions.json').read_text(encoding='utf-8'));s=[f for f in fs if f['slot']==47]
print('count',len(s));print(' '.join(f'{f["address"]:04X}' for f in s))
print(s[0]['source'])
for f in s:
 if f['address'] in [0xfb87,0xfc7d,0xfcb0]:print(f)
