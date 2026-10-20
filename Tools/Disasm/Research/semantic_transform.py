"""Add named modules, functions, data layouts and extracted resource references."""
from pathlib import Path
import json
import re

WORK=Path(__file__).resolve().parent
ROOT=WORK.parent/'outputs/MYTHLAND'
SEM=WORK/'semantic'
MODULES={'CTPB':'Loader.Basic','CTPL':'Loader.Sectors','CTPM':'Loader.Menu','CTPA':'Music.Menu',
    'S04':'Startup','S05':'MemoryDriver','S08':'Graphics.Heroes','S10':'Engine',
    'S33':'Graphics.Scenes1','S34':'Graphics.Scenes2','S47':'Battle',
    'KBO':'Protection.Outer','KBR':'Protection.Move','KBD':'Protection.Xor','KBL':'Protection.Load','KBT':'Protection.Tail'}
OVERLAYS=['Capture','City','Temple','Recruit','Treasure','Join','Bandits','Army','Save','Dismiss','TakeOff','Land',
    'Maps','Sail','TargetMap','Victory','Info','Friendly','Hostile','Defeat','Castle','Help']
MODULES.update({'O%02d'%i:'Overlay.'+name for i,name in enumerate(OVERLAYS,1)})
MODULES.update({'S00':'Basic.Boot','S01':'Basic.Credits','S06':'Presentation','S07':'Data.Core',
    'S09':'Data.HeroText','S19':'Data.WorldObjects','S20':'Data.Names','S21':'UnitTypes',
    'S32':'Data.Recruits','S35':'Graphics.World','S44':'Graphics.Battle','S45':'Graphics.Units',
    'S46':'Data.Battle','S50':'Graphics.Defeat','S51':'Data.Version','S52':'Data.Help','S53':'SavedGame'})
MODULES.update({'S%02d'%slot:'Data.Person%d'%(slot-10) for slot in range(11,19)})
MODULES.update({'S%02d'%slot:'Maps.Continent%d'%(slot-27) for slot in range(28,32)})
MODULES.update({'S%02d'%slot:'Graphics.Portrait%d'%(slot-35) for slot in range(36,44)})
SHORT={'MainEntry':'Entry','Initialize':'Init','Interrupt':'Interrupt','UpdateNearbyArmies':'StepArmies',
    'MoveSixByteObjects':'StepMapTroops','HandleRebellion':'CheckRevolt','CastleThreat':'TickCastle',
    'BattleEntry':'Entry','BattleInputLoop':'InputLoop','SelectNextPlayerUnit':'NextUnit'}
ABBREVIATIONS={'Descriptor':'Desc','Character':'Char','Keyboard':'Keys','Background':'Back','Calculate':'Calc',
    'Coordinates':'Coords','Coordinate':'Coord','Remaining':'Left','Strategic':'World','Quantity':'Count',
    'Generate':'Make','Direction':'Dir','Selected':'Chosen','Animation':'Anim','Information':'Info',
    'Initialize':'Init','Current':'Cur','Computer':'AI','Opponent':'Enemy','Protection':'Guard','Controller':'Control'}

def fmt(code='',comment='',label=''):
    assert len(label)<16,label
    comment=re.sub(r'([А-Яа-яЁё])(?=[0-9A-Za-z#])',r'\1 ',comment)
    comment=re.sub(r'([0-9A-Za-z])(?=[А-Яа-яЁё])',r'\1 ',comment)
    comment=re.sub(r',(?=\S)',', ',comment)
    if not code and label and comment: return label.ljust(16)+'; '+comment.replace(';',',')
    lead=(label.ljust(16) if label else ' '*16)+code
    if comment:
        assert len(lead)<=80,(label,code)
        return lead.ljust(80)+'; '+comment.replace(';',',')
    return lead

def read_json(path,default):
    return json.loads(path.read_text(encoding='utf-8')) if path.exists() else default

def open_module(name): return [fmt('module '+part) for part in name.split('.')]
def close_module(name): return [fmt('endmodule') for _ in name.split('.')]

def short_name(name):
    if name in SHORT: return SHORT[name]
    for original,short in ABBREVIATIONS.items(): name=name.replace(original,short)
    return name if re.fullmatch('[A-Za-z_][A-Za-z0-9_]{0,14}',name) else None

def generate_structures():
    shared=read_json(SEM/'structures.json',{})
    records=shared.get('structures',[]) if isinstance(shared,dict) else shared
    records+=read_json(SEM/'unit_structures.json',[])
    graphics=read_json(SEM/'graphics_formats.json',{})
    if isinstance(graphics,dict): records+=graphics.get('structures',[])
    folder=ROOT/'Includes/Structs';folder.mkdir(parents=True,exist_ok=True)
    values={'FWord':2,'FWord.Low':0,'FWord.High':1,'FFloat5':5,'FFloat5.Data':0}
    includes=['; структуры описывают исходные записи и не выделяют новую память',fmt('include "Includes/Structs/Word.inc"'),fmt('include "Includes/Structs/Float5.inc"')]
    (folder/'Word.inc').write_text('\n'.join([fmt('struct FWord','16-битное слово little-endian'),
        fmt('DB #00','младший байт','Low'),fmt('DB #00','старший байт','High'),fmt('ends'),'']),encoding='utf-8')
    (folder/'Float5.inc').write_text('\n'.join([fmt('struct FFloat5','пять исходных байтов числа калькулятора ПЗУ'),
        fmt('DS 5, #00','формат ROM, включая особое представление целого','Data'),fmt('ends'),'']),encoding='utf-8')
    schema={}
    record_sizes={item['name']:item['size'] for item in records}
    arrays=set()
    for item in records:
        name=item['name']
        if name in schema: continue
        fields=sorted(item['fields'],key=lambda field:field['offset'])
        schema[name]={**item,'fields':fields}
        text=['; '+item.get('purpose',item.get('meaning',name)),fmt('struct '+name)]
        cursor=0
        for field in fields:
            offset,size=field['offset'],field['size']
            assert offset>=cursor,(name,field)
            if offset>cursor:
                text.append(fmt('DS %d, #00'%(offset-cursor),'неописанные исходные байты','Reserved%02X'%cursor))
            field_name=field['name']
            type_name=field.get('type')
            if type_name=='WORD': type_name='FWord'
            if type_name=='Float5': type_name='FFloat5'
            count=field.get('count',1)
            if type_name and count>1:
                element=type_name
                type_name=element+'A'+str(count)
                if type_name not in arrays:
                    element_size=record_sizes[element]
                    array_text=[fmt('struct '+type_name,'массив из %d записей %s'%(count,element))]
                    for index in range(count):
                        array_text.append(fmt(element,'элемент %d'%index,'Item%d'%index))
                        values[type_name+'.Item%d'%index]=index*element_size
                    array_text+=[fmt('ends'),fmt('assert %s = %d'%(type_name,size)),'']
                    (folder/(type_name[1:]+'.inc')).write_text('\n'.join(array_text),encoding='utf-8')
                    includes.append(fmt('include "Includes/Structs/'+type_name[1:]+'.inc"'))
                    values[type_name]=size;arrays.add(type_name)
            if type_name:
                declaration=type_name
            elif size==1: declaration='DB #00'
            elif size==2: declaration='FWord'
            else: declaration='DS %d, #00'%size
            comment=field.get('meaning',field.get('description','исходное поле'))
            text.append(fmt(declaration,comment,field_name))
            values[name+'.'+field_name]=offset
            if size==2:
                values[name+'.'+field_name+'.Low']=offset
                values[name+'.'+field_name+'.High']=offset+1
            cursor=offset+size
        assert cursor<=item['size'],(name,cursor,item['size'])
        if cursor<item['size']: text.append(fmt('DS %d, #00'%(item['size']-cursor),'неописанный хвост','Reserved%02X'%cursor))
        text.extend([fmt('ends'),fmt('assert %s = %d'%(name,item['size'])),''])
        values[name]=item['size']
        (folder/(name[1:]+'.inc')).write_text('\n'.join(text),encoding='utf-8')
        includes.append(fmt('include "Includes/Structs/'+name[1:]+'.inc"'))
    (folder/'Include.inc').write_text('\n'.join(includes)+'\n',encoding='utf-8')
    (ROOT/'Docs/Structures.json').write_text(json.dumps(list(schema.values()),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    return values,schema

def load_symbol_input():
    data=read_json(SEM/'engine_symbols.json',{})
    return data.get('symbols',[]) if isinstance(data,dict) else data

def transform():
    values,schema=generate_structures()
    functions=read_json(ROOT/'Docs/functions.json',[])
    coverage=read_json(ROOT/'Docs/coverage.json',[])
    supplied=load_symbol_input()
    explicit={(s['module'],s['address']):s for s in supplied if s.get('kind') in ('function','procedure','entry')}
    labels={};used={}
    manual={('S10',0x8DDA):'StepArmies',('S10',0x92CB):'StepMapTroops',('S10',0xA2E0):'CheckRevolt',('S10',0xA5AE):'TickCastle',
        ('S05',0x7D34):'Detect',('S05',0x7DBE):'CheckBanks',('S05',0x7EB6):'BankCode',
        ('S05',0x7EDA):'FillAttr',('S05',0x7EF1):'DrawGlyph',('S05',0x7F32):'AttrAddress',('S05',0x7F4F):'Print',
        ('S08',0x7D33):'Draw',('S08',0x7D39):'Unpack',('S33',0xC000):'Draw',('S33',0xC006):'Unpack',
        ('S34',0xC000):'Draw',('S34',0xC006):'Unpack',('CTPM',0x61A8):'MainMenu',('CTPM',0x620B):'ShowHelp',('CTPM',0x627F):'EditUnits',
        ('KBO',0x6149):'Decode',('KBR',0x6165):'Relocate',('KBR',0x6170):'EraseOuter',('KBR',0x617D):'SetStack',
        ('KBR',0x6192):'DecodeShift',('KBR',0x619E):'DeadBranch',('KBD',0xBFDD):'DecodeAdjacent',
        ('KBL',0xC000):'MakeCheckName',('KBL',0xC03E):'FindBasic',('KBL',0xC050):'MakeLoaderName',('KBL',0xC07F):'Load',
        ('KBL',0xC08D):'Decode',('KBL',0xC0AB):'CheckPosition',('KBL',0xC0DA):'WriteName'}
    manual.update({('S04',0x6149):'DecodeBoot',('S04',0x615E):'Entry',('S04',0x6161):'Interrupt',('S04',0x631C):'Init',
        ('CTPB',0x5D57):'LoadSector',('CTPM',0x6171):'DecodeMenu',('CTPM',0x619D):'PrintHook',
        ('S05',0x7E8F):'PortDFFD',('S05',0x7E97):'PortFDFD',('S05',0x7E9F):'Port1FFD',('S05',0x7EA7):'Port7FFD',
        ('O01',0xB593):'NewMapPiece',('O02',0xB7AB):'RefuseEntry',('O02',0xB7BA):'RefreshMoney',
        ('O02',0xB7DB):'SiegePrice',('O02',0xB7EB):'ShipPrice',('O03',0xB4AC):'CheckLanding',
        ('O09',0xB2D8):'InvertState',('O09',0xB2E2):'AddSectors',('O10',0xB406):'ShowUnitDialog'})
    for fn in functions:
        block,address=fn['block'],fn['address'];key=(block,address)
        candidate=manual.get(key) or explicit.get(key,{}).get('name') or short_name(fn['analysis'].get('name',''))
        if block.startswith('O') and address==0xB200: candidate='Entry'
        if not candidate: candidate='F%04X'%address
        assert len(candidate)<16,(key,candidate)
        if candidate in used.setdefault(block,set()): candidate='F%04X'%address
        used[block].add(candidate);labels[key]=candidate
        qualified=MODULES.get(block,block)+'.'+candidate
        values[qualified]=address
    constants=[dict(module='Memory',address=0x5FA0,name='CurrentBank',meaning='текущий логический банк'),
        dict(module='Memory',address=0x5FA1,name='SelectBank',meaning='установленный драйвер выбора банка'),
        dict(module='Overlay',address=0xB200,name='Entry',meaning='область исполнения выбранного оверлея'),
        dict(module='State',address=0x9294,name='AwaySteps',meaning='смещённая база направлений отступления от героя'),
        dict(module='State',address=0x92A4,name='TowardSteps',meaning='смещённая база направлений движения к герою')]
    for s in supplied:
        if s.get('kind') not in ('function','procedure','entry'): constants.append(s)
    const_text=['; исходные адреса, объявления EQU не выделяют память']
    by_group={}
    for entry in constants:
        name=entry['name'];group=entry.get('namespace',entry.get('module','State'))
        if group in MODULES: group='State'
        assert len(name)<16,(group,name)
        qualified=group+'.'+name
        if qualified in values: continue
        values[qualified]=entry['address']
        by_group.setdefault(group,[]).append(entry)
    for group,entries in by_group.items():
        const_text+=['']+open_module(group)
        for entry in entries:
            const_text.append(fmt('EQU #%04X'%entry['address'],entry.get('meaning',entry.get('description','исходное состояние')),entry['name']))
        const_text+=close_module(group)
    (ROOT/'Includes/Address.inc').write_text('\n'.join(const_text)+'\n',encoding='utf-8')
    (ROOT/'Includes/Include.inc').write_text('\n'.join([fmt('include "Includes/Structs/Include.inc"'),fmt('include "Includes/Address.inc"'),'']),encoding='utf-8')
    # Названия констант состояния применяются только к доказанным абсолютным адресам
    state_by_address={entry['address']:group+'.'+entry['name'] for group,entries in by_group.items() for entry in entries
                      if entry['name'] not in ('AwaySteps','TowardSteps')}
    field_contexts=read_json(SEM/'engine_symbols.json',{}).get('register_contexts',[]) if isinstance(read_json(SEM/'engine_symbols.json',{}),dict) else []
    field_contexts+=read_json(SEM/'unit_contexts.json',[])
    def resolve_function(block,address):
        if (block,address) in labels: return labels[(block,address)]
        if block=='S04' and address==0x7D33: return 'Graphics.Heroes.Draw'
        if block=='S04' and ('S06',address) in labels: return 'Presentation.'+labels[('S06',address)]
        if block in ('S10','S47') or block.startswith('O'):
            target='S10' if 0x615E<=address<0xB200 else 'S47'
            if (target,address) in labels: return MODULES[target]+'.'+labels[(target,address)]
        name=state_by_address.get(address)
        return name if name in ('Memory.SelectBank','Overlay.Entry') else None
    sources={}
    for block in coverage:
        ident=block['block'];path=ROOT/block['source'];out=[]
        address_names={address:name for address,name in state_by_address.items() if
            (name.startswith('Memory.') or name.startswith('System.')) or
            ((ident in ('S10','S47') or ident.startswith('O')) and address<0xC000) or
            (ident=='S47' and name.startswith('Battle.'))}
        for line in path.read_text(encoding='utf-8').splitlines():
            code,sep,comment=line.partition(';')
            if not code.strip(): out.append(line);continue
            label=code[:16].strip() if code and code[0]!=' ' else ''
            instruction=code[16:].strip()
            original=instruction
            address_match=re.search(r'([0-9A-F]{4}) (?:[0-9A-F]{2})(?: [0-9A-F]{2})*$',comment)
            address=int(address_match[1],16) if address_match else None
            if instruction.lower().startswith('module '):
                out+=open_module(MODULES.get(ident,ident));continue
            if instruction.lower()=='endmodule':
                out+=close_module(MODULES.get(ident,ident));continue
            if label.startswith('F') and re.fullmatch('F[0-9A-F]{4}',label): label=labels.get((ident,int(label[1:],16)),label)
            instruction=re.sub(r'\bF([0-9A-F]{4})\b',lambda m:labels.get((ident,int(m[1],16)),m[0]),instruction)
            if address is not None and instruction.startswith(('CALL ','JP ')):
                branch=re.search(r'#([0-9A-F]{4})$',instruction)
                if branch:
                    replacement=resolve_function(ident,int(branch[1],16))
                    if replacement: instruction=instruction[:branch.start()]+replacement
            if address is not None and not instruction.startswith('DB '):
                instruction=re.sub(r'#([0-9A-F]{4})',lambda m:address_names.get(int(m[1],16),m[0]),instruction)
                if ident=='S10' and address in (0x8E8A,0x9363): instruction='LD IY, State.TowardSteps'
                if ident=='S10' and address==0x8E91: instruction='LD IY, State.AwaySteps'
                for ctx in field_contexts:
                    context_end=ctx['end']+(1 if ctx.get('end_inclusive') else 0)
                    if ctx['module']!=ident or not(ctx['start']<=address<context_end): continue
                    if any((item['start']<=address<=item['end']) if isinstance(item,dict) else address==item
                           for item in ctx.get('exceptions',[])): continue
                    typename=ctx['type'];reg=ctx['register'];base=ctx.get('base_offset',0)
                    if typename not in schema: continue
                    def field_replace(match):
                        offset=(1 if match[1]=='+' else -1)*int(match[2],16)+base
                        for field in schema[typename]['fields']:
                            if field['offset']<=offset<field['offset']+field['size']:
                                extra=offset-field['offset']
                                if field['size']==2 and extra in (0,1): suffix='.High' if extra else '.Low'
                                else: suffix=(' + %d'%extra) if extra else ''
                                adjust=(' - %d'%base) if base>0 else (' + %d'%-base if base<0 else '')
                                return reg+' + '+typename+'.'+field['name']+suffix+adjust
                        return match[0]
                    instruction=re.sub(reg+r'([+-])#([0-9A-F]{2})',field_replace,instruction)
            if instruction.startswith(('LD ','CALL ','JP ','JR ','PUSH ','POP ','ADD ','ADC ','SBC ','BIT ','SET ','RES ','EX ','IN ','OUT ')):
                instruction=re.sub(r',\s*',', ',instruction)
            if len(instruction)>64: instruction=original
            out.append(fmt(instruction,comment.strip() if sep else '',label))
        sources[ident]=out
    # Ресурсные секции заменяют исходные DB, не скрывая команды распаковщиков
    assets=read_json(ROOT/'Docs/ScreenAssets.json',[])
    chunks=[]
    for item in assets:
        if item['kind']=='portrait':
            stem=Path(item['raw']).with_suffix('')
            chunks.extend([dict(slot=item['slot'],offset=0,length=128,path=stem.with_suffix('.ink').as_posix(),label='Bitmap'),
                dict(slot=item['slot'],offset=128,length=16,path=stem.with_suffix('.attr').as_posix(),label='Attributes')])
        else:
            chunks.append(dict(slot=item['slot'],offset=item['offset'],length=item['length'],path=item.get('packed',item['raw']),
                label=('Image'+item['id'].split('.')[-1]) if item.get('packed') else 'Screen',picture_header=bool(item.get('packed'))))
    # Секции других графических ресурсов добавляются экспортёром спрайтов
    chunks+=read_json(SEM/'graphics_chunks.json',[])
    for block in coverage:
        ident=block['block'];origin=block['origin']
        by_address={origin+c['offset']-block['offset']:c for c in chunks if c['slot']==block['slot'] and
            block['offset']<=c['offset'] and c['offset']+c['length']<=block['offset']+block['length']}
        if not by_address: continue
        lines=sources[ident];out=[];skip_until=-1;resource_labels=set()
        for line in lines:
            code,_,comment=line.partition(';')
            address_match=re.match(r'([0-9A-F]{4})(?: |$)',comment.strip())
            address=int(address_match[1],16) if address_match else None
            data_line=address is not None and code[16:].strip().startswith('DB ')
            if not data_line:
                out.append(line);continue
            data=bytes(int(value.strip()[1:],16) for value in code[16:].strip()[3:].split(','))
            end=address+len(data);position=address
            while position<end:
                if position<skip_until:
                    position=min(skip_until,end);continue
                if position in by_address:
                    item=by_address[position]
                    raw=(ROOT/item['path']).read_bytes();assert len(raw)==item['length']
                    label=item.get('label','')
                    if label in resource_labels: label='Res%04X'%item['offset']
                    resource_labels.add(label)
                    if item.get('picture_header'):
                        rle_path=item['path'].replace('.packed.bin','.rle')
                        assert (ROOT/rle_path).read_bytes()==raw[5:]
                        out.append(fmt('DW #%04X'%int.from_bytes(raw[:2],'little'),'FPictureHeader.NextOffset, относительная ссылка',label))
                        out.append(fmt('DB #%02X'%raw[2],'начальная треть экрана','.FirstThird'))
                        out.append(fmt('DB #%02X'%raw[3],'число третей экрана','.ThirdCount'))
                        out.append(fmt('DB #%02X'%raw[4],'порядок обхода и рабочие флаги','.Flags'))
                        out.append(fmt('INCBIN "'+rle_path+'"','исходный поток RLE, включая сохранённый хвост'))
                    else:
                        out.append(fmt('INCBIN "'+item['path']+'"','графический ресурс, исходное смещение #%04X'%item['offset'],label))
                    skip_until=position+item['length'];position=min(skip_until,end)
                else:
                    next_start=min([value for value in by_address if position<value<end],default=end)
                    part=data[position-address:next_start-address]
                    out.append(fmt('DB '+', '.join('#%02X'%value for value in part),'%04X исходные данные'%position))
                    position=next_start
        sources[ident]=out
    for block in coverage:
        (ROOT/block['source']).write_text('\n'.join(sources[block['block']])+'\n',encoding='utf-8')
    for fn in functions:
        label=labels[(fn['block'],fn['address'])]
        lines=sources[fn['block']]
        fn['symbol']=MODULES.get(fn['block'],fn['block'])+'.'+label
        fn['line']=next(i for i,line in enumerate(lines,1) if line[:16].strip()==label and line[:1]!=';')
    main=(ROOT/'Main.asm').read_text(encoding='utf-8')
    main=main.replace('                device ZXSPECTRUM48','                device ZXSPECTRUM48\n                include "Includes/Include.inc"',1)
    (ROOT/'Main.asm').write_text(main,encoding='utf-8')
    (ROOT/'Docs/functions.json').write_text(json.dumps(functions,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    symbol_report=dict(values=values,functions=[dict(block=fn['block'],address=fn['address'],symbol=fn['symbol'],source=fn['source'],line=fn['line']) for fn in functions],
        modules=MODULES,resource_chunks=chunks)
    (ROOT/'Docs/Symbols.json').write_text(json.dumps(symbol_report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(dict(named_functions=sum(not symbol['symbol'].split('.')[-1].startswith('F') or not re.fullmatch('F[0-9A-F]{4}',symbol['symbol'].split('.')[-1]) for symbol in symbol_report['functions']),
        structures=len(schema),constant_symbols=sum(len(entries) for entries in by_group.values()),resource_chunks=len(chunks))))

if __name__=='__main__': transform()
