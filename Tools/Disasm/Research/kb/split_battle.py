import json
from pathlib import Path
d=json.loads(Path('work/main_analysis/bitwa_reachable.json').read_text())
ts=sorted(int(x) for x in d['call_targets'] if int(x)>=d['origin'])
print(len(ts));print(' '.join(f'{x:04X}' for x in ts))
out=[];ins=d['instructions'];ts=[d['origin']]+ts
for n,a in enumerate(ts):
    out.append(f'\nFUNCTION {a:04X}')
    end=ts[n+1] if n+1<len(ts) else d['end']
    out.extend(f'{i["address"]:04X} {i["op"]}' for i in ins if a<=i['address']<end)
Path('work/kb/battle_functions.txt').write_text('\n'.join(out))
