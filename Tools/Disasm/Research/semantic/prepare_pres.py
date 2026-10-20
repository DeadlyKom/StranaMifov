from pathlib import Path
import sys,json,re,hashlib
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import decoder,listing
from decode_graphics import PALETTE,monochrome,atlas
from PIL import Image

BASE=Path(__file__).resolve().parents[2]
ROOT=Path(__file__).resolve().parent
SRC=BASE/'outputs/MYTHLAND/Extracted/Active/06_PRES.C.bin'
raw=SRC.read_bytes()
origin=0xc000
mem=[0]*65536
mem[origin:origin+len(raw)]=raw

def graph(memory,lo,hi,seeds):
    dec=decoder(memory)
    queue=list(seeds)
    seen={}
    calls={}
    while queue:
        address=queue.pop()
        while lo<=address<hi and address not in seen:
            ins=dec.disassemble(address,address+1,'h')[0]
            op=ins.operation
            seen[address]={'address':address,'hex':bytes(ins.data).hex(),'op':op}
            match=re.search(r'\$([0-9A-F]{4})$',op)
            if op.startswith(('CALL ','JP ','JR ','DJNZ ')) and match:
                target=int(match[1],16)
                if op.startswith('CALL '):calls.setdefault(target,[]).append(address)
                if lo<=target<hi:queue.append(target)
                if op.startswith(('JP $','JR $')):break
            if op in ('RET','RETI','RETN') or op.startswith('JP ('):break
            address+=len(ins.data)
    return {'instructions':[seen[a] for a in sorted(seen)],'calls':calls}

g=graph(mem,origin,origin+len(raw),[0xe200])
entries=sorted({0xe200}|{int(a) for a in g['calls'] if origin<=int(a)<origin+len(raw)})
assert len(entries)==18
code_ranges=[[0xe200,0xe33d],[0xe3a7,0xe656],[0xe65e,0xe710]]
data_ranges=[[0xc000,0xe200],[0xe33d,0xe3a7],[0xe656,0xe65e],[0xe710,origin+len(raw)]]
for ins in g['instructions']:
    a=ins['address']
    assert any(lo<=a and a+len(bytes.fromhex(ins['hex']))<=hi for lo,hi in code_ranges)
assert sum(len(bytes.fromhex(i['hex'])) for i in g['instructions'])==sum(hi-lo for lo,hi in code_ranges)
(ROOT/'pres_graph.json').write_text(json.dumps(g,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(ROOT/'pres_reachable.txt').write_text('\n'.join(f"{i['address']:04X} {i['hex']:<12} {i['op']}" for i in g['instructions'])+'\n',encoding='utf-8')
rom=list((BASE/'work/vendor/skoolkit-10.0/skoolkit/resources/48.rom').read_bytes())+[0]*49152
keyboard=graph(rom,0,0x4000,[0x028e])
assert not any(i['op'] in ('EXX',"EX AF,AF'") for i in keyboard['instructions'])

dest=ROOT/'graphics/PRES'
dest.mkdir(parents=True,exist_ok=True)
font_dir=dest/'font'
font_dir.mkdir(exist_ok=True)
screen=raw[:0x1b00]
font=raw[0x1b00:0x2200]
(dest/'PRES_screen.scr').write_bytes(screen)
(dest/'PRES_font.bin').write_bytes(font)
im=Image.new('RGB',(256,192))
pix=im.load()
for y in range(192):
    for x in range(256):
        offset=((y&0xc0)<<5)|((y&7)<<8)|((y&0x38)<<2)|(x>>3)
        attr=screen[6144+(y>>3)*32+(x>>3)]
        on=bool(screen[offset]&(0x80>>(x&7)))
        colour=((attr&7) if on else ((attr>>3)&7))+(8 if attr&0x40 else 0)
        pix[x,y]=PALETTE[colour]
im.save(dest/'PRES_screen.png')
glyphs=[]
for code in range(32,256):
    data=font[(code-32)*8:(code-31)*8]
    (font_dir/f'glyph_{code:02X}.bin').write_bytes(data)
    glyph=monochrome(data,1,8)
    glyph.save(font_dir/f'glyph_{code:02X}.png')
    glyphs.append(glyph)
atlas(glyphs,16,(8,8),[f'{code:02X}' for code in range(32,256)]).save(dest/'PRES_font.png')

chunks=[]
for start,end,name in (
 (0xc000,0xdb00,'PRES_screen.scr'),(0xdb00,0xe200,'PRES_font.bin'),
 (0xe33d,0xe33f,'PRES_cell_position.bin'),(0xe33f,0xe3a7,'PRES_credits.bin'),
 (0xe656,0xe65e,'PRES_rng.bin'),(0xe710,0xe7d8,'PRES_stars.bin'),
 (0xe7d8,origin+len(raw),'PRES_story.bin')):
    data=raw[start-origin:end-origin]
    (dest/name).write_bytes(data)
    assert (dest/name).read_bytes()==data
    chunks.append({'slot':6,'offset':start-origin,'length':len(data),'source':str((dest/name).relative_to(BASE)),
      'path':'Assets/Gfx/PRES/'+name,'label':name.split('.')[0],'representation':'original','sha256':hashlib.sha256(data).hexdigest()})
(dest/'PRES_story.txt').write_text(raw[0x27d8:].decode('cp866').replace('\r','\n').replace('▒','\n<СТРАНИЦА>\n'),encoding='utf-8')
(dest/'PRES_credits.txt').write_text(raw[0x233f:0x23a7].decode('cp866').replace('\x00','\n'),encoding='utf-8')

layout={
 'slot':6,'source':str(SRC),'catalog_origin':0x8000,'runtime_origin':origin,
 'length':len(raw),'end_exclusive':origin+len(raw),'entry_points':entries,
 'range_convention':'все пары диапазонов [start,endExclusive] заданы runtime-адресами',
 'code_ranges':code_ranges,'confirmed_data_ranges':data_ranges,
 'data_parts':[
  {'start':0xc000,'endExclusive':0xdb00,'kind':'screen_scr','format':'6144 пикселей в экранном порядке Spectrum +768 атрибутов'},
  {'start':0xdb00,'endExclusive':0xe200,'kind':'font_8x8','format':'224 глифа с кодами32..255, по8байтов, указатель DA00+8*A'},
  {'start':0xe33d,'endExclusive':0xe33f,'kind':'variables','format':'координаты последнего проявляемого знакоместа'},
  {'start':0xe33f,'endExclusive':0xe3a7,'kind':'credit_script','format':'атрибут,x,y,ASCII-строка с0, FF разделяет страницы, FE завершает'},
  {'start':0xe656,'endExclusive':0xe65e,'kind':'rng_state','format':'временное слово предела и три16битных слова состояния'},
  {'start':0xe710,'endExclusive':0xe7d8,'kind':'star_points','format':'100пар y,x, значения в файле заменяются при старте'},
  {'start':0xe7d8,'endExclusive':origin+len(raw),'kind':'story_script','format':'B1 разделяет страницы, затем строка/длительность и CP866-текст сCR, FF завершает'}
 ],
 'load_evidence':['BL3 #6372..#637D, банк4, имя PRES по#62C2, DE=C000','BL3 #63A4..#63A9 и #63E4..#63E9 -> CALL E200'],
 'chunks':chunks,'pngs':['Assets/Gfx/PRES/PRES_screen.png','Assets/Gfx/PRES/PRES_font.png'],
 'screen_zero_attributes':screen[6144:].count(0),
 'instruction_count':len(g['instructions']),'code_bytes':sum(hi-lo for lo,hi in code_ranges),
 'external_calls':{f'{a:04X}':sites for a,sites in g['calls'].items() if not origin<=a<origin+len(raw)},
 'keyboard_rom_no_alternative_mutations':True,
 'unclassified_bytes':0,'validation':'достижимость прямых переходов, полное покрытие трёх диапазонов кода, обратное сравнение извлечённых блоков, без сборки и исполнения игры'
}
(ROOT/'pres_layout.json').write_text(json.dumps(layout,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(ROOT/'pres_graphics_chunks.json').write_text(json.dumps(chunks,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'entries':[f'{a:04X}' for a in entries],'instructions':len(g['instructions']),'code_bytes':layout['code_bytes'],'zero_attrs':layout['screen_zero_attributes'],'chunks':len(chunks)},ensure_ascii=True))
