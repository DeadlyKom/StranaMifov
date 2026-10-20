from pathlib import Path
import sys,json
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import decoder,listing
BASE=Path(__file__).resolve().parents[2]
ROOT=Path(__file__).resolve().parent
source=BASE/'outputs/MYTHLAND/Extracted/Active'
head=(source/'10_head.co.C.bin').read_bytes()
for addr in range(0x62A7,0x631C,9):
    data=head[addr-0x615E:addr-0x615E+9]
    print(f'{addr:04X}',data.hex(),data.decode('cp866'))
for slot in (33,34):
    path=next(source.glob(f'{slot:02d}_*.C.bin'))
    raw=path.read_bytes()
    mem=[0]*65536
    mem[0xC000:0xC000+len(raw)]=raw
    print(path.name,len(raw),raw[:64].hex(' '))
    (ROOT/f'animation{slot}_start.txt').write_text(listing(mem,0xC000,0xC180),encoding='utf-8')

functions=json.loads((BASE/'outputs/MYTHLAND/Docs/functions.json').read_text(encoding='utf-8'))
for slot in (6,8,33,34):
    fs=[f for f in functions if f.get('slot')==slot]
    print('FUNCTIONS',slot,[(f.get('block'),f'{f["address"]:04X}',f.get('purpose')) for f in fs])
    data=next(source.glob(f'{slot:02d}_*.C.bin')).read_bytes()
    print('PREFIX',slot,data[:0x140].hex())
(ROOT/'animation_existing_functions.json').write_text(json.dumps([f for f in functions if f.get('slot') in (8,33,34)],ensure_ascii=False,indent=2),encoding='utf-8')
data33=(source/'33_BL1.C.bin').read_bytes()
data34=(source/'34_BL2.C.bin').read_bytes()
data8=(source/'08_HERIMG.C.bin').read_bytes()
print('CODE_EQ33_34',data33[:0x113]==data34[:0x113])
print('CODE_EQ8_33',data8[6:0x113]==data33[6:0x113])
print('PREFIX_EQ8_33',[i for i,(a,b) in enumerate(zip(data8[:0x12c],data33[:0x12c])) if a!=b])
for slot,raw in ((33,data33),(34,data34)):
    pic_offset=0x12c
    records=[]
    n=1
    while pic_offset+5<=len(raw):
        jump=int.from_bytes(raw[pic_offset:pic_offset+2],'little')
        row,height,flags=raw[pic_offset+2:pic_offset+5]
        records.append(dict(index=n,fileOffset=pic_offset,fileOffsetHex=f'{pic_offset:04X}',runtime=f'{0xc000+pic_offset:04X}',nextDelta=jump,header=[row,height,flags],payloadOffset=pic_offset+5,payloadLength=jump-4))
        pic_offset+=jump+1
        n+=1
        if jump==0:break
    print('TABLE',slot,'count',len(records),'end',hex(pic_offset),'len',hex(len(raw)),[(r['index'],r['fileOffsetHex'],r['nextDelta'],r['header']) for r in records])
    (ROOT/f'animation{slot}_pictures.json').write_text(json.dumps(records,ensure_ascii=False,indent=2),encoding='utf-8')
