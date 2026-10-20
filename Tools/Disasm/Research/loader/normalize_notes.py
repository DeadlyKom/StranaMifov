from pathlib import Path
import re,json

ROOT=Path(__file__).resolve().parent

def clean(value):
    if isinstance(value,str):
        value=re.sub(r'\bbank(?=\d)','банк ',value)
        value=re.sub(r'\bbit(?=\d)','бит ',value)
        value=re.sub(r'(?<=[А-Яа-яЁё])(?=[0-9A-Za-z#])',' ',value)
        value=re.sub(r'(?<=[0-9A-Za-z])(?=[А-Яа-яЁё])',' ',value)
        value=re.sub(r'(?<=[A-Za-z0-9])(?=#)',' ',value)
        value=re.sub(r',(?=\S)',', ',value)
        value=re.sub(r':(?=\S)',': ',value)
        value=re.sub(r'(?<=\))(?=[А-Яа-яЁё])',' ',value)
        value=value.replace('из банк ','из банка ')
        return value
    if isinstance(value,dict):return {k:clean(v) for k,v in value.items()}
    if isinstance(value,list):return [clean(v) for v in value]
    return value

for filename in ['annotations.json','overlay_annotations.json','bl3_annotations.json','regions.json']:
    path=ROOT/filename
    value=json.loads(path.read_text(encoding='utf-8'))
    path.write_text(json.dumps(clean(value),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for filename in ['data_formats.txt','report.txt']:
    path=ROOT/filename
    path.write_text(clean(path.read_text(encoding='utf-8')),encoding='utf-8')
print('Russian note spacing normalized')
