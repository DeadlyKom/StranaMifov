"""Generate an annotated, lossless source transcription; never invokes an assembler."""
from analyze import *
from dataclasses import dataclass, field
from collections import defaultdict
import re
import textwrap
import shutil

P = ROOT
for sub in ('Source/Files','Source/Loader','Source/Overlays','Source/Decoded','Docs','Disk/Keys','Tools','Build'):
    (P/sub).mkdir(parents=True,exist_ok=True)

@dataclass
class Block:
    ident: str
    title: str
    slot: int
    origin: int
    raw_offset: int
    data: bytes
    path: str
    seeds: set = field(default_factory=set)
    code_ranges: list = field(default_factory=list)
    known_data: list = field(default_factory=list)
    annotations: dict = field(default_factory=dict)
    instructions: dict = field(default_factory=dict)
    calculator: dict = field(default_factory=dict)
    conflicts: list = field(default_factory=list)
    functions: set = field(default_factory=set)

    @property
    def end(self): return self.origin+len(self.data)
    def mem(self):
        m=[0]*65536
        m[self.origin:self.end]=self.data
        return m
    def is_code(self,a):
        return self.origin<=a<self.end and (not self.code_ranges or any(s<=a<e for s,e in self.code_ranges)) and not any(s<=a<e for s,e in self.known_data)


blocks=[]
descriptions={
0:'BASIC-загрузчик дисковой версии',1:'BASIC-страница авторов версии',2:'BASIC и скрытые блоки дискового меню',
3:'многоступенчатый защищённый загрузчик BL3',4:'начальная настройка игры и загрузка ресурсов',
5:'определение схемы расширенной памяти и установка переключателя банков',6:'графические данные заставки',
7:'шрифт и общие графические данные',8:'банка изображений героев с исполняемым распаковщиком',
9:'русские описания героев',10:'основной игровой модуль',19:'исходные данные строений',20:'названия объектов',
21:'25 записей воинов по 42 байта',32:'таблица стоимости найма',33:'первая банка изображений с распаковщиком',
34:'вторая банка изображений с распаковщиком',35:'первая банка графики',44:'вторая банка графики',45:'третья банка графики',
46:'табличные данные боевого модуля',47:'боевой модуль',48:'первые 13 оверлеев',49:'следующие 9 оверлеев',
50:'экран ошибки, 6144 байта пикселей и 768 атрибутов',51:'текст сообщения об улучшенной версии',
52:'описание игры, зашифрованное через R и положение файла на диске',53:'пользовательское сохранение DEADLY'}
for n in range(11,19): descriptions[n]='исходная запись героя '+str(n-10)
for n in range(22,25): descriptions[n]='параметры найма воинов, набор '+str(n-21)
for n in range(25,28): descriptions[n]='параметры магических сил, набор '+str(n-24)
for n in range(28,32): descriptions[n]='стратегическая карта '+str(n-27)+', 100 строк по 161 байту'
for n in range(36,44): descriptions[n]='графический блок героя '+str(n-35)+', 144 байта'

loader_ann=json.loads((WORK/'loader/annotations.json').read_text(encoding='utf-8'))
main_ann={}
for ap in ('main_analysis/annotations.json','kb/battle_annotations.json','loader/overlay_annotations.json','kb/bl3_annotations.json','loader/bl3_annotations.json','overlay_root_annotations.json','loader/nearby_group_annotations.json','kb/rebellion_annotations.json','special_group_annotations.json','kb/protection_contracts.json','loader/animation_resource_annotations.json','semantic/pres_annotations.json'):
    if (WORK/ap).exists():
        for key,fields in json.loads((WORK/ap).read_text(encoding='utf-8')).items():
            main_ann.setdefault(key,{}).update(fields)

def annotation_for(slot):
    if isinstance(main_ann,dict):
        found={}
        for k,v in main_ann.items():
            if k.startswith(str(slot)+':'):
                v=dict(v)
                if not v.get('description') and (v.get('purpose') or v.get('name')):
                    v['description']=v.get('purpose',v.get('name'))
                if not v.get('algorithm') and v.get('details'):
                    v['algorithm']=v['details']
                found[k.split(':',1)[1].upper()]=v
        return found
    return {}

def add(ident,title,slot,origin,offset,data,path,seeds=(),ranges=(),known=(),ann=None):
    b=Block(ident,title,slot,origin,offset,bytes(data),path,set(seeds),list(ranges),list(known),ann or {})
    blocks.append(b)
    return b

e,cp=entry(2,True)
m2=(WORK/'loader/stage2.bin').read_bytes()
hidden=(WORK/'loader/hidden_stage2.bin').read_bytes()
add('CTPB','BASIC-часть CTPAHA и оформление первого сектора',2,0x5D3B,0,cp[:256],
    'Source/Loader/Basic.asm',[0x5D57],[(0x5D57,0x5D65)],ann=annotation_for('CTPB'))
add('CTPL','два слоя расшифровки секторного загрузчика',2,0x8000,256,m2[:256],
    'Source/Loader/Sectors.asm',[0x8000],[(0x8000,0x80BC)],ann={
    '8000':dict(description='очистка экрана и первый слой защиты',algorithm='Обнуляет экран и область системных данных #4000..#5AFF. Инициализирует R=#AC и расшифровывает 109 байтов начиная с #804F. В каждой итерации переключает #1FFD, выполняет длинный LDIR и восстанавливает HL/DE из системных переменных, поэтому ключ зависит от точного числа выборок команд.',inputs='нет явных аргументов',outputs='переход к #804F',corrupt='HL, DE, BC, AF, R',effects='экран, #5C08, #5C3D, #E2DB..#E940, порт #1FFD'),
    '804F':dict(description='второй слой защиты секторного загрузчика',algorithm='Расшифровывает 50 байтов #808A..#80BB, используя R, адрес HL и старший байт остатка D. Длинный LDIR намеренно участвует в формировании ключа через R.',inputs='R после первого слоя',outputs='переход к #808A',corrupt='HL, DE, BC, AF, R',effects='#808A..#80BB, #5C08, #5C3D, #1FFD'),
    '808A':dict(description='чтение двух скрытых блоков дискового меню',algorithm='Выбирает обычную страницу памяти через #7FFD. Читает 22 сектора в #6171 и 12 секторов в #E000. Подпрограмма #80A2 расшифровывает каждый байт XOR старшего и младшего байтов его адреса. Заранее помещает в стек #6171 и завершает хвостовым переходом к чтению второго блока.',inputs='#5CF4 — текущая позиция чтения TR-DOS',outputs='управление на #6171',corrupt='HL, DE, BC, AF',effects='память #6171..#7770, #E000..#EBFF, порт #7FFD'),
    '80A2':dict(description='чтение секторов и адресное XOR-преобразование',algorithm='Сохраняет адрес назначения и число секторов. Вызывает TR-DOS с C=5 и DE из #5CF4. Затем преобразует B*256 байтов по формуле value XOR H XOR L.',inputs='HL — назначение, B — число секторов',outputs='HL после прочитанного блока, BC=0',corrupt='HL, DE, BC, AF',effects='область назначения и состояние TR-DOS')})
lc=[(0x6171,0x6419),(0x6429,0x6672),(0x6938,0x6C11),(0x6C86,0x6E04),(0x6E07,0x6EC5),(0x6ECC,0x6F24)]
add('CTPM','скрытое меню, редактор и библиотека интерфейса',2,0x6171,512,hidden[0x6171:0x7771],
    'Source/Loader/Menu.asm',[0x6171,0x619D,0x61A8,0x6429],lc,ann={**loader_ann,**annotation_for('CTPM')})
music=(WORK/'loader/hidden_memory.bin').read_bytes()
add('CTPA','AY-плеер и музыкальный модуль меню',2,0xE000,6144,music[0xE000:0xEC00],
    'Source/Loader/Music.asm',[0xE000,0xE006],[(0xE000,0xE070),(0xE0AF,0xE35F),(0xE41F,0xE43C)],ann=loader_ann)

# All disjoint source blocks retain the disk byte positions supplied by the original.
for e in MANIFEST['entries']:
    slot=e['slot']
    if e['deleted'] or slot in (2,3,48,49): continue
    raw=(P/(e['path']+'.bin')).read_bytes()
    origin=e['start'] if e['type']!='B' else 0x5D3B
    seeds=[]; ranges=[]; known=[]; ann=annotation_for(slot)
    if slot==4:
        raw=(WORK/'kb/bl3_stage2.bin').read_bytes(); seeds=[0x6149,0x615E,0x6161,0x631C]
        kbinfo=json.loads((WORK/'kb/segments.json').read_text(encoding='utf-8'))
        seeds+=kbinfo['bl3CodeSeeds']; known+=list(map(tuple,kbinfo['bl3ConfirmedDataRanges']))
        known.append((0x7D33,0x7D34))
        for f in kbinfo['bl3Functions']:
            if f['name'].endswith('Data') or f['name']=='Names': continue
            key='%04X'%f['address']
            defaults=dict(description='процедура начального модуля #%04X'%f['address'],algorithm=f['descriptionRu'])
            ann[key]={**defaults,**{k:v for k,v in ann.get(key,{}).items() if v}}
    elif slot==6:
        origin=0xC000
        seeds=[0xE200]
        known=[(0xC000,0xE200),(0xE33D,0xE3A7),(0xE656,0xE65E),(0xE710,0xEC1F)]
    elif slot==5:
        seeds=[0x7D34,0x7DBE,0x7E8F,0x7E97,0x7E9F,0x7EA7,0x7EB6,0x7EDA,0x7EF1,0x7F32,0x7F4F]
        ranges=[(0x7D34,0x7DE5),(0x7E8F,0x7ED7),(0x7EDA,0x7F31),(0x7F32,0x7F80)]
    elif slot in (8,33,34):
        seeds=[origin,origin+6]; ranges=[(origin,origin+2),(origin+6,origin+0x113)]
    elif slot==10:
        seeds=[origin,0x6161,0x631C,0x91D1,0x91E1,0x91EE,0x91FE,0x920B,0x921B,0x9228,0x9238,0x9270]; known=[(0x62A5,0x631C),(0x653A,0x6B8D)]
    elif slot==47:
        seeds=[origin,0xE5E1,0xE67D,0xE6A2,0xE6C7,0xE6EC,0xE711,0xE736,0xE75B,0xE780,0xFB87,0xFC7D,0xFCB0]
        known=[(0xDBA4,0xE013),(0xE0BD,0xE0BF),(0xE639,0xE67D),(0xFCB8,origin+len(raw))]
    elif slot==52:
        raw=(WORK/'loader/help_decoded.bin').read_bytes()
    if slot not in (3,4,5,6,8,10,33,34,47): known=[(origin,origin+len(raw))]
    add('S%02d'%slot,descriptions.get(slot,e['name']),slot,origin,0,raw,
        'Source/Files/%02d_%s.asm'%(slot,e['name'].replace('.','_')),seeds,ranges,known,ann)

kbmeta=json.loads((WORK/'kb/segments.json').read_text(encoding='utf-8'))
kb_titles=['наружные шесть проходов защиты','перенос следующего слоя защиты','самостирание наружного слоя',
           'подготовка стекового цикла расшифровки','побайтовая расшифровка со сдвигом на один адрес',
           'недостигаемая в нормальном ходе ветвь защиты','соседнее XOR-преобразование через стек',
           'построение имени проверяемого BASIC-файла','проверка положения BASIC-файла в каталоге',
           'построение имени BL3 и настройка ветви защиты','загрузка BL3 через TR-DOS',
           'пятнадцать проходов расшифровки BL3','ветвь проверки каталога и повреждения при ошибке',
           'данные повреждающей ветви','запись имени файла из самомодифицируемых операндов']
kbann={('%04X'%f['address']):dict(description=kb_titles[index],algorithm=f['descriptionRu']) for index,f in enumerate(kbmeta['kbFunctions'])}
for kb in kbmeta['blocks']:
    if kb['slot']!=3: continue
    data=(WORK.parent/kb['binPath']).read_bytes()
    known=[(kb['origin'],kb['origin']+kb['length'])] if kb['kind']=='data' else []
    if kb['id']=='KB_LoadBL3': known=[(0xC0D0,0xC0DA)]
    ident={'KB_Outer':'KBO','KB_Relocate':'KBR','KB_Difference':'KBD','KB_LoadBL3':'KBL','KB_Tail':'KBT'}[kb['id']]
    combined_ann={key:{**value,**annotation_for(ident).get(key,{})} for key,value in kbann.items()}
    add(ident,'защищённый загрузчик, '+kb['id'],3,kb['origin'],kb['rawOffset'],data,
        'Source/Loader/'+kb['id']+'.asm',kb['entryPoints'],known=known,ann=combined_ann)
for source,targetname in [('kb_outer_xor.bin','KB_Outer.xor'),('kb_relocate_xor.bin','KB_Relocate.xor')]:
    shutil.copyfile(WORK/'kb'/source,P/'Disk/Keys'/targetname)

overlay_id=1
for slot in (48,49):
    e,raw=entry(slot)
    pos=0
    while pos<len(raw):
        marker=raw.find(b'overlay',pos)
        assert marker>=pos,(slot,pos)
        size=marker+7-pos
        data=raw[pos:pos+size]
        oa=annotation_for('O%02d'%overlay_id)
        physical=annotation_for(slot).get('%04X'%(0xC000+pos))
        if physical: oa.setdefault('B200',physical)
        seeds=[0xB200]
        if overlay_id==17: seeds += [0xB405,0xB6D8,0xB749,0xB8F3,0xB819]
        add('O%02d'%overlay_id,'оверлей %02d из %s'%(overlay_id,e['name']),slot,0xB200,pos,data,
            'Source/Overlays/%02d.asm'%overlay_id,seeds,known=[(0xB200+size-7,0xB200+size)],ann=oa)
        pos+=size; overlay_id+=1
assert overlay_id==23

# Извлечённая графика является данными даже при совпадении байтов с командами
graphics_plan=WORK/'semantic/graphics_chunks.json'
if graphics_plan.exists():
    for chunk in json.loads(graphics_plan.read_text(encoding='utf-8')):
        for block in blocks:
            if block.slot!=chunk['slot']: continue
            start=chunk['offset']-block.raw_offset
            if start<0 or start+chunk['length']>len(block.data): continue
            raw=(P/chunk['path']).read_bytes()
            assert raw==block.data[start:start+chunk['length']],(block.ident,chunk['path'])
            block.known_data.append((block.origin+start,block.origin+start+chunk['length']))

COND={'NZ':'флаг Z сброшен','Z':'флаг Z установлен','NC':'флаг C сброшен','C':'флаг C установлен',
      'PO':'флаг P/V сброшен','PE':'флаг P/V установлен','P':'флаг S сброшен','M':'флаг S установлен'}
CALC={0x00:'jump-true, переход по ненулевому условию',0x03:'subtract, вычитание',0x04:'multiply, умножение',
      0x05:'division, деление',0x0F:'addition, сложение',0x24:'atn, арктангенс',
      0x27:'int, округление вниз',0x28:'sqr, квадратный корень',0x31:'duplicate, дублирование вершины',
      0x38:'end-calc, возврат в Z80',0xA1:'stk-one, константа 1',0xA2:'stk-half, константа 1/2',0xA3:'stk-pi/2, константа pi/2'}

def target(op):
    m=re.search(r'\$([0-9A-F]{4})$',op)
    return int(m[1],16) if m else None

def discover(b,extra=()):
    mem=b.mem(); dec=decoder(mem)
    queue=list(b.seeds|set(extra)|{int(k,16) for k in b.annotations if re.fullmatch('[0-9A-Fa-f]{4}',k) and b.is_code(int(k,16))})
    b.functions.update(queue)
    occupied={}
    for a,i in b.instructions.items():
        for p in range(a,a+len(i.data)): occupied[p]=a
    while queue:
        a=queue.pop()
        while b.is_code(a) and a not in b.instructions:
            if a in occupied:
                b.conflicts.append((a,occupied[a])); break
            ins=dec.disassemble(a,a+1,'h')[0]
            if a+len(ins.data)>b.end or any(not b.is_code(p) for p in range(a,a+len(ins.data))): break
            if any(p in occupied for p in range(a,a+len(ins.data))):
                b.conflicts.append((a,'overlap')); break
            b.instructions[a]=ins
            for p in range(a,a+len(ins.data)): occupied[p]=a
            after=a+len(ins.data); op=ins.operation
            if op=='RST $28':
                end=after
                while end<b.end:
                    value=mem[end]; end+=1
                    if value==0x38: break
                b.calculator[after]=end
                for p in range(after,end): occupied[p]=a
                after=end
            elif op.startswith(('CALL ','JP ','JR ','DJNZ ')):
                t=target(op)
                if t is not None and b.is_code(t):
                    queue.append(t)
                    if op.startswith('CALL '): b.functions.add(t)
                if op.startswith(('JP $','JR $','JP (')): break
            if op in ('RET','RETI','RETN') or (op.startswith('RST ') and op!='RST $28'): break
            a=after

for b in blocks: discover(b)
# Resolve cross-file calls into resident code and the interrupt/boot module.
# Overlay address B200 is intentionally ambiguous, so never merge overlay identities.
for _ in range(3):
    extra=defaultdict(set)
    for b in blocks:
        if b.slot not in (10,47,48,49): continue
        for i in b.instructions.values():
            if i.operation.startswith(('CALL ','JP ')):
                t=target(i.operation)
                if t is None: continue
                for candidate in blocks:
                    if candidate is b or candidate.ident.startswith('O'): continue
                    if candidate.slot in (10,47) and candidate.is_code(t):
                        extra[candidate.ident].add(t)
    old=sum(len(b.instructions) for b in blocks)
    for b in blocks:
        if extra[b.ident]: discover(b,extra[b.ident])
    if sum(len(b.instructions) for b in blocks)==old: break

def wrap_comment(text,prefix='; '):
    text=str(text).replace(';',',').replace('\n',' ')
    text=re.sub(r'\bbank(?=\d)','банк ',text,flags=re.I)
    text=re.sub(r'([А-Яа-яЁё])(?=\d)',r'\1 ',text)
    text=re.sub(r'(\d)(?=[А-Яа-яЁё])',r'\1 ',text)
    text=re.sub(r'([А-Яа-яЁё])(?=[A-Z#])',r'\1 ',text)
    text=re.sub(r'([A-Z])(?=[А-Яа-яЁё])',r'\1 ',text)
    text=re.sub(r',(?=[A-Za-zА-Яа-яЁё#])',', ',text)
    text=re.sub(r':(?!\s*$)',',',text)
    return textwrap.wrap(text,width=100-len(prefix),initial_indent=prefix,subsequent_indent=prefix,break_long_words=False,break_on_hyphens=False) or [prefix.rstrip()]

def formatted(code,comment='',label=''):
    lead=(label.ljust(16) if label else ' '*16)+code
    return lead.ljust(80)+'; '+comment.replace(';',',') if comment else lead

def collect_function(b,a):
    queue=[a]; done=set(); calls=set(); reads=set(); writes=set(); exits=[]
    while queue and len(done)<10000:
        p=queue.pop()
        while p in b.instructions and p not in done:
            if p!=a and p in b.functions: break
            done.add(p); ins=b.instructions[p]; op=ins.operation
            for mode,addr in re.findall(r'(\(?)(\$[0-9A-F]{4})',op):
                pass
            m=re.match(r'LD \(\$([0-9A-F]{4})\),(.+)',op)
            if m: writes.add(int(m[1],16))
            m=re.match(r'LD [^,]+,\(\$([0-9A-F]{4})\)',op)
            if m: reads.add(int(m[1],16))
            if op.startswith(('CALL ','JP ','JR ','DJNZ ')):
                t=target(op)
                if op.startswith('CALL ') and t is not None: calls.add(t)
                if op.startswith(('JP ','JR ','DJNZ ')) and t is not None:
                    if t in b.functions and t!=a: calls.add(t)
                    else: queue.append(t)
                if op.startswith(('JP $','JR $','JP (')): exits.append(op); break
            if op.startswith(('RET','RETI','RETN')):
                exits.append(op)
                if op in ('RET','RETI','RETN'): break
            after=p+len(ins.data)
            if after in b.calculator: after=b.calculator[after]
            p=after
    return dict(address=a,instructions=sorted(done),calls=sorted(calls),reads=sorted(reads),writes=sorted(writes),exits=sorted(set(exits)))

def header(b,a,info):
    ann=b.annotations.get('%04X'%a,{})
    desc=ann.get('description',ann.get('title','процедура #%04X'%a))
    lines=['; -----------------------------------------']+wrap_comment(desc)
    if ann.get('algorithm'): lines+=wrap_comment(ann['algorithm'])
    else:
        lines+=wrap_comment('Разбор ниже фиксирует поток команд, вызываемые процедуры и прямые обращения к памяти. Назначение на уровне правил игры требует уточнения по вызывающему контексту.')
    for field,key in [('In','inputs'),('Out','outputs'),('Corrupt','corrupt')]:
        lines+=['; '+field+':']
        if ann.get(key): lines+=wrap_comment(ann[key],';   ')
        else: lines+=[';   полный контракт не установлен статическим разбором']
    lines+=['; Note:']
    if info['calls']: lines+=wrap_comment('прямые вызовы и хвостовые переходы, '+', '.join('#%04X'%x for x in info['calls']),';   ')
    if info['reads']: lines+=wrap_comment('прямое чтение состояния, '+', '.join('#%04X'%x for x in info['reads']),';   ')
    if info['writes']: lines+=wrap_comment('прямое изменение состояния, '+', '.join('#%04X'%x for x in info['writes']),';   ')
    if ann.get('effects'): lines+=wrap_comment(ann['effects'],';   ')
    lines+=wrap_comment('проверка исполнения в полной машине не выполнена',';   ')
    lines+=['; -----------------------------------------']
    return lines,desc

def call_purpose(b,addr):
    if addr==0x3D13: return 'вызов сервиса TR-DOS, номер операции находится в C'
    if addr==0x5FA1: return 'переключение логического банка через установленный драйвер памяти'
    if b.slot in (10,47,48,49):
        if addr==0xB200: return 'выполнение выбранного оверлея после копирования в общую область'
        entry=annotation_for(10).get('%04X'%addr) if 0x615E<=addr<0xB200 else annotation_for(47).get('%04X'%addr)
    elif b.ident=='CTPM': entry=loader_ann.get('%04X'%addr)
    elif b.ident=='CTPA': entry=loader_ann.get('%04X'%addr)
    else: entry=b.annotations.get('%04X'%addr)
    if entry: return entry.get('description',entry.get('purpose',''))
    if addr==0x007C and b.slot in (8,33,34): return 'возврат через RET ПЗУ для определения собственного адреса'
    return ''

def op_comment(ins,b):
    op=ins.operation
    branch=re.match(r'(JP|JR|CALL|RET) (NZ|Z|NC|C|PO|PE|P|M)(?:,|$)',op)
    if branch:
        verb,cond=branch.groups()
        return ('выход, если ' if verb=='RET' else 'переход, если ' if verb in ('JP','JR') else 'вызов процедуры, если ')+COND[cond]
    if op.startswith('CALL '):
        return call_purpose(b,target(op))
    if op=='RST $28': return 'передача вычисления стековому калькулятору ПЗУ, токены следуют ниже'
    if op.startswith('OUT '): return 'вывод в порт, назначение определяется адресом порта и выбранной схемой памяти'
    if op=='LDIR': return 'копирование BC байтов, при перекрытии областей учитывается порядок записи'
    if op=='LDDR': return 'копирование BC байтов от старших адресов к младшим'
    if op.startswith('LD R,'): return 'инициализация регистра регенерации, значение участвует в защите или случайной последовательности'
    if op=='LD A,R':
        if b.ident=='KBD': return 'фиктивное чтение R, значение отбрасывается последующим XOR A'
        return 'получение состояния регенерации для ключа защиты или случайной последовательности'
    return ''

def operation_prefix(ins):
    op=ins.operation
    if op=='OR A' or op=='AND A': return 'проверка нуля и знака текущего значения A'
    if op.startswith('CP '): return 'проверка текущего A сравнением с '+op[3:].replace('$','#')
    if op.startswith('BIT '): return 'проверка выбранного бита перед обработкой состояния'
    if op.startswith('AND '): return 'выделение маской нужных битов текущего значения'
    if op.startswith('OR '): return 'объединение битов текущего значения с '+op[3:].replace('$','#')
    m=re.match(r'(ADD|ADC|SUB|SBC) (.*)',op)
    if m:
        args=m[2].split(',')
        if len(args)==1: args=['A',args[0]]
        sign='+' if m[1] in ('ADD','ADC') else '-'
        return 'расчёт '+args[0]+' '+sign+' '+args[1].replace('$','#')+(' с учётом входного переноса C' if m[1] in ('ADC','SBC') else ' в исходной разрядности Z80')
    if op.startswith(('INC ','DEC ')):
        return 'расчёт следующего значения '+op[4:]+(' + 1' if op.startswith('INC ') else ' - 1')
    if op.startswith(('SLA ','SRA ','SRL ','RL ','RR ')):
        return 'расчёт следующего набора битов сдвигом или вращением исходного значения'
    if op=='LDIR' or op=='LDDR': return 'перенос блока в рабочую область памяти'
    if re.match(r'LD \(\$[0-9A-F]{4}\),',op): return 'обновление состояния или операнда самомодифицируемой команды по исходному адресу'
    return ''

coverage=[]; funcs=[]
for b in blocks:
    label_addresses=set(b.functions)&set(b.instructions)
    for ins in b.instructions.values():
        if ins.operation.startswith(('CALL ','JP ','JR ','DJNZ ')):
            t=target(ins.operation)
            if t in b.instructions: label_addresses.add(t)
    labels={a:('F' if a in b.functions else 'L')+'%04X'%a for a in label_addresses}
    lines=['; '+b.title,'; исходный файл каталога %02d, смещение #%04X'%(b.slot,b.raw_offset),
           '; адреса и длины восстановлены из исходного образа, размещение игры не меняется',
           formatted('module '+b.ident),formatted('org #%04X'%b.origin),'']
    a=b.origin; recorded=bytearray(); db_bytes=0; code_bytes=0; calc_bytes=0
    while a<b.end:
        if a in b.instructions:
            ins=b.instructions[a]
            info=None
            if a in b.functions:
                info=collect_function(b,a)
                hdr,desc=header(b,a,info)
                lines+=['']+hdr
                info.update(block=b.ident,slot=b.slot,source=b.path,line=len(lines)+1,description=desc,
                            annotated=('%04X'%a) in b.annotations,analysis=b.annotations.get('%04X'%a,{}))
                funcs.append(info)
            before=operation_prefix(ins)
            if before: lines+=[' '*16+'; '+before]
            op=ins.operation
            if ins.variant or op.startswith('DEFB '):
                comment='исходная кодировка '+op.replace('$','#')+', сохранена без нормализации ассемблером'
                code='DB '+', '.join('#%02X'%x for x in ins.data)
            else:
                t=target(op)
                if t in labels and op.startswith(('CALL ','JP ','JR ','DJNZ ')):
                    op=re.sub(r'\$[0-9A-F]{4}$',labels[t],op)
                code=re.sub(r'\$([0-9A-F]+)',r'#\1',op).upper()
                comment=op_comment(ins,b)
            suffix=('%04X '%a)+bytes(ins.data).hex(' ').upper()
            comment=(comment+', ' if comment else '')+suffix
            if info is not None: info['line']=len(lines)+1
            lines.append(formatted(code,comment,labels.get(a,'')))
            recorded.extend(ins.data); code_bytes+=len(ins.data); a+=len(ins.data)
            if a in b.calculator:
                end=b.calculator[a]
                while a<end:
                    v=b.data[a-b.origin]
                    meaning=CALC.get(v,'токен калькулятора, исходное значение')
                    if b.slot==47 and a==0xF5BD: meaning='самомодифицируемый токен, записывается через #F599 из C'
                    lines.append(formatted('DB #%02X'%v,meaning+', %04X'%a))
                    recorded.append(v); calc_bytes+=1; a+=1
        else:
            if b.ident=='S47' and a==0xE0BD:
                lines+=['',' '*16+'; слово исходного SP боя, записывается по #D255 и читается при нелокальном выходе']
            stop=min(b.end,a+8)
            for p in range(a+1,stop):
                if p in b.instructions or p in labels: stop=p; break
            data=b.data[a-b.origin:stop-b.origin]
            if a==b.origin or a-1 in {p+len(i.data)-1 for p,i in b.instructions.items()}:
                lines+=['',' '*16+'; исходные данные и неразмеченные байты, трактовка как команд без точки входа не выполняется']
            printable=''.join(chr(v) if 32<=v<127 else '.' for v in data)
            lines.append(formatted('DB '+', '.join('#%02X'%v for v in data),'%04X '%a+printable))
            recorded.extend(data); db_bytes+=len(data); a=stop
    assert recorded==b.data,b.ident
    lines+=['',formatted('assert $ = #%04X'%b.end),formatted('endmodule'),'']
    (P/b.path).write_text('\n'.join(lines),encoding='utf-8')
    # A stream key records the exact original on-disk representation of this source block.
    e,raw=entry(b.slot,True)
    original=raw[b.raw_offset:b.raw_offset+len(b.data)]
    key=bytes(x^y for x,y in zip(original,b.data))
    keypath=None
    if any(key) and b.slot!=3:
        keypath='Disk/Keys/'+b.ident+'.xor'
        (P/keypath).write_bytes(key)
    coverage.append(dict(block=b.ident,slot=b.slot,origin=b.origin,length=len(b.data),offset=b.raw_offset,
                         source=b.path,code_bytes=code_bytes,calculator_bytes=calc_bytes,data_or_unclassified_bytes=db_bytes,
                         instructions=len(b.instructions),functions=len([f for f in funcs if f['block']==b.ident]),
                         semantically_annotated=sum(f['annotated'] for f in funcs if f['block']==b.ident),
                         conflicts=sorted(set(map(str,b.conflicts))),key=keypath))

# The skeleton preserves disk metadata and sector tails. Assembled bytes replace ALL active payloads.
disk=bytearray((P/'Disk/original.trd').read_bytes())
for c in coverage:
    e=MANIFEST['entries'][c['slot']]
    start=e['offset']+c['offset']
    disk[start:start+c['length']]=b'\0'*c['length']
(P/'Disk/layout.bin').write_bytes(disk)

main=['; восстановление исходного MYTHLAND.TRD средствами sjasmplus',
      '; запускать из корня проекта, см. README.txt',
      formatted('device ZXSPECTRUM48'),formatted('EQU 1',label='VerifyOriginal'),
      formatted('emptytrd "Build/MYTHLAND.trd", "MYTHLAND"'),
      '', '                ; создание структуры диска с сохранением служебных данных и удалённых файлов',
      formatted('lua pass3'),'                    dofile("Tools/pack.lua")','                    begin_image()',formatted('endlua'),'']
for c in coverage:
    e=MANIFEST['entries'][c['slot']]
    store=('capture_kb(%d, %d, %d)'%(c['origin'],c['length'],c['offset'])) if c['slot']==3 else ('store_block(%d, %d, %d, %s)'%(c['origin'],c['length'],e['offset']+c['offset'],('"'+c['key']+'"') if c['key'] else 'nil'))
    main+=['                ; компиляция блока '+c['block']+' и размещение по исходному смещению диска',
           formatted('include "'+c['source']+'"'),formatted('lua pass3'),
           '                    '+store,
           formatted('endlua'),'']
main+=['                ; обратное преобразование многослойного загрузчика и завершение образа',formatted('lua pass3'),
       '                    finish_kb(%d)'%MANIFEST['entries'][3]['offset'],
       '                    finish_image(_c("VerifyOriginal") ~= 0)',formatted('endlua'),'']
(P/'Main.asm').write_text('\n'.join(main),encoding='utf-8')
(P/'Docs/coverage.json').write_text(json.dumps(coverage,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(P/'Docs/functions.json').write_text(json.dumps(funcs,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
instruction_reference={b.ident:{str(a):[i.operation.replace('$','#').upper(),bytes(i.data).hex(),int(i.variant)] for a,i in b.instructions.items()} for b in blocks}
(P/'Docs/InstructionReference.json').write_text(json.dumps(instruction_reference,ensure_ascii=False,separators=(',',':'))+'\n',encoding='utf-8')
print(json.dumps(dict(blocks=len(blocks),instructions=sum(c['instructions'] for c in coverage),
    procedures=len(funcs),annotated=sum(f['annotated'] for f in funcs),bytes=sum(c['length'] for c in coverage),
    conflicts=sum(len(c['conflicts']) for c in coverage)),indent=2))
