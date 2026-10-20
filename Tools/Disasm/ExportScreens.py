from pathlib import Path
import hashlib
import json
import struct
import zlib

ROOT=Path(__file__).resolve().parents[2]
MANIFEST=json.loads((ROOT/'Tools/Disasm/Disk/manifest.json').read_text(encoding='utf-8'))

def source(slot):
    record=MANIFEST['entries'][slot]
    return (ROOT/(record['path']+'.bin')).read_bytes()

def png(path,width,height,rgba):
    def chunk(kind,data):
        return struct.pack('>I',len(data))+kind+data+struct.pack('>I',zlib.crc32(kind+data)&0xFFFFFFFF)
    assert len(rgba)==width*height*4
    rows=b''.join(b'\0'+rgba[y*width*4:(y+1)*width*4] for y in range(height))
    path.parent.mkdir(parents=True,exist_ok=True)
    path.write_bytes(b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',width,height,8,6,0,0,0))+chunk(b'IDAT',zlib.compress(rows,9))+chunk(b'IEND',b''))

def color(index,bright):
    level=255 if bright else 205
    return ((level if index&2 else 0),(level if index&4 else 0),(level if index&1 else 0))

def screen_rgba(raw,flash=False):
    assert len(raw)==6912
    rgba=bytearray()
    for y in range(192):
        for x in range(256):
            pixel=raw[((y&0xC0)<<5)|((y&7)<<8)|((y&0x38)<<2)|(x>>3)]&(0x80>>(x&7))
            attr=raw[6144+(y>>3)*32+(x>>3)]
            if flash and attr&128: pixel=not pixel
            rgb=color((attr&7) if pixel else ((attr>>3)&7),bool(attr&64))
            rgba.extend((*rgb,255))
    return bytes(rgba)

def rle(data,position,length):
    out=bytearray()
    while len(out)<length:
        value=data[position]; position+=1
        if value:
            out.append(value)
        else:
            count=data[position] or 256
            value=data[position+1];position+=2
            out.extend([value]*count)
    assert len(out)==length,('RLE series crosses output end',len(out),length)
    return bytes(out),position

def unpack_scene(data,offset):
    end=offset+1+int.from_bytes(data[offset:offset+2],'little')
    start,count,flags=data[offset+2:offset+5]
    assert 0<=start<3 and 1<=count<=3 and start+count<=3
    assert flags&4==0
    plain,consumed=rle(data,offset+5,count*2304)
    assert consumed<=end,(offset,consumed,end)
    screen=bytearray(6912)
    cursor=0
    # Порядок потока подтверждён вложенными циклами исходного распаковщика
    for outer in range(1 if flags&1 else 32):
        for third in range(start,start+count):
            for cellrow in range(8):
                for pixelrow in range(8):
                    for inner in range(32 if flags&1 else 1):
                        x=inner if flags&1 else outer
                        address=third*2048+pixelrow*256+cellrow*32+x
                        screen[address]=plain[cursor];cursor+=1
    screen[6144+start*256:6144+(start+count)*256]=plain[cursor:]
    return bytes(screen),end,dict(start_third=start,third_count=count,flags=flags,
        consumed_stream_bytes=consumed-offset-5,trailing_bytes=data[consumed:end].hex())

def portrait_rgba(raw):
    assert len(raw)==144
    out=bytearray()
    for y in range(32):
        for x in range(32):
            ink=raw[(y>>3)*32+(y&7)*4+(x>>3)]&(0x80>>(x&7))
            attr=raw[128+(y>>3)*4+(x>>3)]
            out.extend((*color((attr&7) if ink else ((attr>>3)&7),bool(attr&64)),255))
    return bytes(out)

def export():
    items=[]
    for slot,group in ((8,'Heroes'),(33,'Scenes1'),(34,'Scenes2')):
        data=source(slot); offset=0x12C; index=1
        prefix=Path('Assets/Screens')/group/'Decoder.bin'
        (ROOT/prefix).parent.mkdir(parents=True,exist_ok=True)
        (ROOT/prefix).write_bytes(data[:offset])
        while offset<len(data):
            screen,end,header=unpack_scene(data,offset)
            stem=Path('Assets/Screens')/group/f'{index:02d}'
            (ROOT/stem.with_suffix('.packed.bin')).write_bytes(data[offset:end])
            (ROOT/stem.with_suffix('.rle')).write_bytes(data[offset+5:end])
            (ROOT/stem.with_suffix('.scr')).write_bytes(screen)
            png(ROOT/stem.with_suffix('.png'),256,192,screen_rgba(screen))
            if any(value&128 for value in screen[6144:]):
                png(ROOT/Path(str(stem)+'_flash.png'),256,192,screen_rgba(screen,True))
            items.append(dict(id=f'{group}.{index:02d}',kind='screen',slot=slot,offset=offset,length=end-offset,
                packed=stem.with_suffix('.packed.bin').as_posix(),raw=stem.with_suffix('.scr').as_posix(),
                png=stem.with_suffix('.png').as_posix(),width=256,height=192,
                decode='Graphics.UnpackScene, relative-link header and RLE',**header,
                sha256=hashlib.sha256(screen).hexdigest()))
            offset=end;index+=1
        assert offset==len(data)
    for number,slot in enumerate(range(36,44),1):
        data=source(slot)
        stem=Path('Assets/Portraits')/f'Hero{number:02d}'
        (ROOT/stem).parent.mkdir(parents=True,exist_ok=True)
        (ROOT/stem.with_suffix('.bin')).write_bytes(data)
        (ROOT/stem.with_suffix('.ink')).write_bytes(data[:128])
        (ROOT/stem.with_suffix('.attr')).write_bytes(data[128:])
        png(ROOT/stem.with_suffix('.png'),32,32,portrait_rgba(data))
        items.append(dict(id=f'HeroPortrait.{number:02d}',kind='portrait',slot=slot,offset=0,length=144,
            raw=stem.with_suffix('.bin').as_posix(),png=stem.with_suffix('.png').as_posix(),width=32,height=32,
            decode='Engine.DrawBlock, 128 bitmap bytes and 16 attributes'))
    data=source(50);stem=Path('Assets/Screens/Defeat')
    (ROOT/stem.with_suffix('.scr')).write_bytes(data)
    png(ROOT/stem.with_suffix('.png'),256,192,screen_rgba(data))
    items.append(dict(id='Defeat',kind='screen',slot=50,offset=0,length=len(data),raw=stem.with_suffix('.scr').as_posix(),
        png=stem.with_suffix('.png').as_posix(),width=256,height=192,decode='native ZX Spectrum screen'))
    (ROOT/'Tools/Disasm/Reports/ScreenAssets.json').write_text(json.dumps(items,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(dict(items=len(items),by_slot={slot:sum(item['slot']==slot for item in items) for slot in [8,33,34,50,*range(36,44)]}),ensure_ascii=False))
    return items

if __name__=='__main__': export()
