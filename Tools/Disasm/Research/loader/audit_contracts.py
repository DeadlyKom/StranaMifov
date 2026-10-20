from pathlib import Path
import json

ROOT=Path(__file__).resolve().parent
for name in ('overlay_annotations.json','bl3_annotations.json'):
    notes=json.loads((ROOT/name).read_text(encoding='utf-8'))
    missing={}
    print(name, len(notes))
    for key,note in notes.items():
        absent=[field for field in ('inputs','outputs','corrupt') if not note.get(field)]
        if absent:
            missing[key]=absent
            print(key, ','.join(absent), note.get('purpose'))
    print('missing procedures',len(missing),'missing fields',sum(map(len,missing.values())))
