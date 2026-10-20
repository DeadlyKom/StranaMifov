from pathlib import Path
import re,json
s=Path('outputs/MYTHLAND/Source/Files/47_bitwa_co.asm').read_text(encoding='utf-8');r=[]
for line in s.splitlines():
 if not re.search(r'\bDB\s+#',line):continue
 ops,comment=line.split(';',1)
 vals=re.findall(r'#([0-9A-F]{2})(?![0-9A-F])',ops)
 addr=re.findall(r'\b([D-F][0-9A-F]{3})\b',comment)
 if vals and addr:r.append((int(addr[-1],16),len(vals),comment.strip()))
r.sort();runs=[]
for a,n,c in r:
 if runs and runs[-1][1]==a:runs[-1][1]+=n;runs[-1][3]+=1
 else:runs.append([a,a+n,c,1])
for a,b,c,n in runs:print(f'{a:04X}..{b-1:04X} {b-a:4d} bytes lines{n} {c[:55]}')
Path('work/kb/battle_db_ranges.json').write_text(json.dumps(runs,ensure_ascii=False,indent=2),encoding='utf-8')
