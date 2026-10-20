import json
from pathlib import Path
p=Path('work/kb/battle_annotations.json');d=json.loads(p.read_text(encoding='utf-8'))
for k,v in d.items():
 missing=[f for f in ('inputs','outputs','corrupt') if not v.get(f)]
 if missing:print(k,','.join(missing),v['name'])
print('total',len(d),'missingfields',sum(not v.get(f) for v in d.values() for f in ('inputs','outputs','corrupt')))
