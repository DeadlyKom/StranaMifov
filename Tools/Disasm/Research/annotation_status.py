from pathlib import Path
import json
from collections import Counter

work=Path(__file__).resolve().parent
root=work.parent/'outputs/MYTHLAND'
functions=json.loads((root/'Docs/functions.json').read_text(encoding='utf-8'))
missing=Counter()
for fn in functions:
    ann=fn['analysis']
    absent=[key for key in ('inputs','outputs','corrupt') if key not in ann or not ann[key]]
    if absent:
        missing[fn['block']]+=1
        print(fn['block'],hex(fn['address']),','.join(absent),fn['description'])
print(dict(missing))
