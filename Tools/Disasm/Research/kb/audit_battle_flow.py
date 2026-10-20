import json,re,sys
from pathlib import Path
sys.path.insert(0,str(Path('work').resolve()))
from analyze import *
mem=memory(47);dec=decoder(mem)
fs=json.loads(Path('outputs/MYTHLAND/Docs/functions.json').read_text(encoding='utf-8'))
addrs=sorted({a for f in fs if f['slot']==47 for a in f['instructions']})
runs=json.loads(Path('work/kb/battle_db_ranges.json').read_text(encoding='utf-8'))
def in_db(a):return next((r for r in runs if r[0]<=a<r[1]),None)
branches=[];patches=[]
for a in addrs:
 ins=dec.disassemble(a,a+1,'h')[0];op=ins.operation
 m=re.search(r'^(?:CALL|JP|JR|DJNZ) (?:[A-Z]+,)?\$([0-9A-F]{4})$',op)
 if m:
  t=int(m[1],16)
  if in_db(t):branches.append({'source':a,'target':t,'instruction':op})
 m=re.match(r'LD \(\$([0-9A-F]{4})\),(A|HL|DE|BC|SP|IX|IY)$',op)
 if m:
  t=int(m[1],16)
  if 0xD255<=t<0xFF94:
   targetins=next((x for x in addrs if x<=t<x+len(dec.disassemble(x,x+1,'h')[0].data)),None)
   if targetins is not None or t in (0xF3F2,0xF5BD):patches.append({'source':a,'target':t,'instruction':op,'targetInstruction':targetins,'originalAtTarget':mem[t]})
notes={
 'scope':'независимая проверка прямых переходов, вычисленного RET и изменяемых операндов боевого модуля, без сборки и полного запуска игры',
 'directBranchesIntoDB':branches,
 'additionalProvenCodeInDB':[],
 'computedRET':{'dispatcher':0xE5B0,'continuation':0xE5E1,'pointerTable':[0xE66D,0xE67D],'targets':[0xE67D,0xE6A2,0xE6C7,0xE6EC,0xE711,0xE736,0xE75B,0xE780],'allTargetsAlreadyInstructions':True},
 'dynamicCalculatorOpcodes':[
 {'address':0xF3F2,'writers':[0xF198,0xF24C],'values':[5,4],'meaning':'комбинирование отношения эффектов с основой урона, деление при первой атаке и умножение при ответе, это байт программы ROM-калькулятора после RST28, DB здесь нужен'},
 {'address':0xF5BD,'writers':[0xF599],'values':[3,15],'meaning':'03 вычитает воздействие, 0F прибавляет лечение, исходный00 перед достижением RST28 всегда заменяется входнымC, исходный байт не является исполняемым jump-true нормального хода'}
 ],
 'dataRangesRu':[
 [0xDBA4,0xE013,'строки интерфейса, численные вставки и меню, не найдено прямых переходов внутрь'],
 [0xE639,0xE66D,'два списка восьми троек соседей и временные указатели цели и действующего отряда'],
 [0xE66D,0xE67D,'восемь указателей процедур, которые уже размечены кодом'],
 [0xE8D7,0xE8E3,'две пятибайтные оценки и указатель выбранного отряда'],
 [0xE922,0xE94A,'байт режима ИИ и группы правил приоритета целей'],
 [0xEB8B,0xEBA9,'счётчик целей, рабочий указатель и список троек тип+указатель'],
 [0xF05C,0xF0A0,'поля выбора заклинания, пятибайтные оценки, строка, десять флагов доступности и правила целей'],
 [0xF335,0xF337,'сохранённый указатель на пятибайтный урон'],
 [0xF414,0xF44F,'коэффициенты удара, указатели участников, пятибайтные уроны и таблицы поправок'],
 [0xF482,0xF4A3,'строка сообщения о магическом щите'],
 [0xF849,0xF84D,'два сохранённых указателя участников'],
 [0xFA1C,0xFAAF,'счётчик2байта, номер кадра1байт и фон курсора144байта'],
 [0xFCB8,0xFF94,'параметры боя, координаты, две армии, маски и карты поля, коэффициенты заклинаний']
 ],
 'savedSP':{'address':0xE0BD,'length':2,'writer':0xD255,'meaning':'данные, даже если технический каталог функций содержит отдельную метку E0BD'},
 'codeOperandPatches':patches,
 'limits':'не доказывает отсутствие всех возможных скрытых путей в полной машине, устанавливает что просмотренные прямые и вычисленные переходы не оставляют дополнительного доказанного кода в DB'
}
assert not branches,branches
Path('work/kb/battle_independent_audit.json').write_text(json.dumps(notes,ensure_ascii=False,indent=2),encoding='utf-8')
p=Path('work/kb/battle_annotations.json');d=json.loads(p.read_text(encoding='utf-8'));d['47:FC7D']['outputs']='сорок объектов 6611..6930 подготовлены, IX после карты, IY=6931';p.write_text(json.dumps(d,ensure_ascii=False,indent=2),encoding='utf-8')
print('proven code left in DB',len(notes['additionalProvenCodeInDB']),'direct target to DB',len(branches),'SMC',len(patches))
