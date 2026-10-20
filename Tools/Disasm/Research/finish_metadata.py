from pathlib import Path
import json

work=Path(__file__).resolve().parent
battle_path=work/'kb/battle_annotations.json'
battle=json.loads(battle_path.read_text(encoding='utf-8'))
battle['47:D2B5']['details']=battle['47:D2B5']['details'].replace('исход случайного выбора из пяти значений 0 разрешает перенос или объединение, остальные четыре оставляют отряд в первой армии','нулевой результат #7C0D при DE=5 разрешает перенос или объединение, ненулевой результат оставляет отряд в первой армии')
battle_path.write_text(json.dumps(battle,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
path=work/'kb/segments.json'
data=json.loads(path.read_text(encoding='utf-8'))
annotations={}
for name in ('kb/bl3_annotations.json','loader/bl3_annotations.json'):
    annotations.update(json.loads((work/name).read_text(encoding='utf-8')))
for fn in data['bl3Functions']:
    key='4:%04X'%fn['address']
    if key in annotations:
        fn['descriptionRu']=annotations[key].get('details',fn['descriptionRu'])
rebuild=data['kbReconstruction'] if 'kbReconstruction' in data else data['reconstruction']
rebuild.pop('assemblyOrRuntimeTest',None)
rebuild['assemblerTest']=True
rebuild['fullMachineRuntimeTest']=False
rebuild['assemblerEvidence']='Docs/BuildVerification.json'
data['warningsRu']=[text for text in data['warningsRu'] if 'большей части игровых процедур' not in text]
data['warningsRu'].append('Функции BL3 разобраны в Source/Files/04_BL3.asm и индексированы в Docs/Functions.tsv, полный запуск игры не выполнялся')
path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
