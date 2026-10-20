from pathlib import Path
import json
from semantic_transform import ROOT,fmt,open_module,close_module

UNITS=['None','Peasants','Soldiers','Archers','Spearmen','Cavalry','Knights','Nomads','Celts','Vikings','Wolves','Orcs',
       'Elves','Ogres','Trolls','Giants','Dragons','Ghosts','Skeletons','Zombies','Spectres','Vampires','Dwarves','Druids','Warlocks','Demons']

def main():
    structures={item['name']:item for item in json.loads((ROOT/'Docs/Structures.json').read_text(encoding='utf-8'))}
    symbols=json.loads((ROOT/'Docs/Symbols.json').read_text(encoding='utf-8'))
    manifest=json.loads((ROOT/'Disk/manifest.json').read_text(encoding='utf-8'))
    coverage=json.loads((ROOT/'Docs/coverage.json').read_text(encoding='utf-8'))
    blocks={block['slot']:block for block in coverage if block['offset']==0}
    data_tables=[]
    def original(slot): return (ROOT/(manifest['entries'][slot]['path']+'.bin')).read_bytes()
    const=ROOT/'Includes/Const';const.mkdir(parents=True,exist_ok=True)
    lines=['; идентификаторы типов совпадают с порядком исходных записей SOLDIERS',fmt('module UnitID')]
    for index,name in enumerate(UNITS):
        text='пустой отряд' if index==0 else original(21)[(index-1)*42:(index-1)*42+12].decode('cp866').rstrip()
        lines.append(fmt('EQU %d'%index,text,name));symbols['values']['UnitID.'+name]=index
    lines+=[fmt('endmodule'),'']
    (const/'UnitID.inc').write_text('\n'.join(lines),encoding='utf-8')
    map_consts=[('Width',161,'число колонок континента'),('Height',100,'число строк континента'),
                ('TileMask',0x3F,'маска графического ID клетки'),('Mirror',0x40,'горизонтальное отражение тайла'),
                ('Occupied',0x80,'занятость клетки объектом')]
    lines=[fmt('module MapConst')]
    for name,value,meaning in map_consts:
        lines.append(fmt('EQU %d'%value,meaning,name));symbols['values']['MapConst.'+name]=value
    lines+=[fmt('endmodule'),'']
    (const/'Map.inc').write_text('\n'.join(lines),encoding='utf-8')
    include=ROOT/'Includes/Include.inc'
    content=include.read_text(encoding='utf-8')
    for name in ('UnitID','Map'):
        entry='include "Includes/Const/'+name+'.inc"'
        if entry not in content: content+=fmt(entry)+'\n'
    include.write_text(content,encoding='utf-8')

    def raw_lines(data,address):
        return [fmt('DB '+', '.join('#%02X'%v for v in data[offset:offset+8]),'%04X исходные данные'%(address+offset)) for offset in range(0,len(data),8)]

    def record(data,name,typename,address,module):
        layout=structures[typename];assert len(data)==layout['size']
        out=['',fmt('',typename+', исходная запись',name)]
        symbols['values'][module+'.'+name]=address
        fields=[]
        for part in layout['fields']:
            start,size,field=part['offset'],part['size'],part['name']
            value=data[start:start+size];assert len(value)==size
            label='.'+field
            if len(label)>15: label=label[:15]
            meaning=part.get('meaning','исходное поле')
            out.append('; '+typename+'.'+field+', смещение #%02X'%start)
            if size==2 and part.get('type') in (None,'WORD'):
                out.append(fmt('DW #%04X'%int.from_bytes(value,'little'),meaning,label))
            elif typename=='FSoldier' and field in ('UpgradeID','DegradeID') and value[0]<len(UNITS):
                out.append(fmt('DB UnitID.'+UNITS[value[0]],meaning,label))
            else:
                for offset in range(0,size,8):
                    out.append(fmt('DB '+', '.join('#%02X'%v for v in value[offset:offset+8]),
                        meaning if offset==0 else 'продолжение поля '+field,label if offset==0 else ''))
            out.append(fmt('assert %s - %s = %s.%s'%(label,name,typename,field)))
            fields.append(dict(name=field,offset=start,size=size,hex=value.hex(' ')))
        out.append(fmt('assert $ - %s = %s'%(name,typename)))
        data_tables.append(dict(module=module,label=name,address=address,type=typename,fields=fields))
        return out

    def header(block,module):
        return ['; исходные данные с полями структур, размеры и размещение сохранены']+open_module(module)+[fmt('org #%04X'%block['origin'])]
    def footer(block,module): return ['',fmt('assert $ = #%04X'%(block['origin']+block['length']))]+close_module(module)+['']

    block=blocks[21];data=original(21);lines=header(block,'UnitTypes')
    for index,name in enumerate(UNITS[1:]):
        lines+=record(data[index*42:(index+1)*42],name,'FSoldier',block['origin']+index*42,'UnitTypes')
    lines+=footer(block,'UnitTypes');(ROOT/block['source']).write_text('\n'.join(lines),encoding='utf-8')

    for slot in range(11,19):
        block=blocks[slot];data=original(slot);module='Data.Person%d'%(slot-10)
        typename='FPerson7' if slot==17 else 'FPerson'
        assert len(data)==structures[typename]['size']
        lines=header(block,module)+record(data,'Template',typename,block['origin'],module)+footer(block,module)
        (ROOT/block['source']).write_text('\n'.join(lines),encoding='utf-8')

    # Коэффициенты рукопашной атаки, строки ID атакующего и колонки ID защищающегося
    block=blocks[46];data=original(46);lines=header(block,'Data.Battle')
    lines+=['',fmt('','25 строк по 25 слов, используется #F3F5','MeleeFactors')]
    tsv=['атакующий\t'+'\t'.join(UNITS[1:])]
    for row,name in enumerate(UNITS[1:]):
        part=data[row*50:(row+1)*50]
        numbers=[int.from_bytes(part[i:i+2],'little') for i in range(0,50,2)]
        tsv.append(name+'\t'+'\t'.join(str(value) for value in numbers))
        for index in range(0,25,8):
            lines.append(fmt('DW '+', '.join('#%04X'%v for v in numbers[index:index+8]),
                'коэффициенты против типов %d..%d'%(index+1,min(index+8,25)),('Vs'+name) if index==0 else ''))
    lines+=raw_lines(data[1250:0x8B1],block['origin']+1250)
    for index in range(15):
        offset=0x8B1+index*28
        lines+=record(data[offset:offset+28],'Ruler%02d'%(index+1),'FRuler',block['origin']+offset,'Data.Battle')
    for index in range(10):
        offset=0xA55+index*23
        lines+=record(data[offset:offset+23],'Spell%02d'%(index+1),'FSpell',block['origin']+offset,'Data.Battle')
    cursor=0xA55+10*23
    chunks=[item for item in symbols.get('resource_chunks',[]) if item['slot']==46 and item['offset']>=cursor]
    chunks.sort(key=lambda item:item['offset'])
    for item in chunks:
        if item['offset']>cursor:
            lines+=raw_lines(data[cursor:item['offset']],block['origin']+cursor)
        assert item['offset']>=cursor
        lines.append(fmt('INCBIN "'+item['path']+'"','встроенный графический ресурс','Gfx%04X'%item['offset']))
        cursor=item['offset']+item['length']
    lines+=raw_lines(data[cursor:],block['origin']+cursor)+footer(block,'Data.Battle')
    (ROOT/block['source']).write_text('\n'.join(lines),encoding='utf-8')
    (ROOT/'Docs/UnitMatchups.tsv').write_text('\n'.join(tsv)+'\n',encoding='utf-8-sig')
    (ROOT/'Docs/DataTables.json').write_text(json.dumps(data_tables,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    (ROOT/'Docs/Symbols.json').write_text(json.dumps(symbols,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print('Typed records:',len(data_tables))

if __name__=='__main__': main()
