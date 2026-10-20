from pathlib import Path
import json
import shutil

WORK=Path(__file__).resolve().parent
ROOT=WORK.parent/'outputs/MYTHLAND'
SEM=WORK/'semantic'
data=json.loads((SEM/'graphics_formats.json').read_text(encoding='utf-8'))
source=SEM/'graphics'
destination=ROOT/'Assets/Gfx'
for file in source.rglob('*'):
    if file.is_file():
        target=destination/file.relative_to(source)
        target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(file,target)
chunks=[]
assets={item['id']:item for item in data['assets']}
for item in data['chunks']:
    if item['original_slot'] in range(28,32): continue
    label=item['id']
    label=label.replace('SPR1_tile_','Tile').replace('SPR2_tile_','Tile').replace('_frame_','F')
    label=label.replace('SPR1_hero_mode_','HeroMode').replace('SPR2_unit_','Unit').replace('SPR3_unit_','Unit')
    if len(label)>15: label='Data%04X'%item['original_offset']
    common=dict(slot=item['original_slot'],representation=item.get('representation','original'))
    graphic=assets.get(item['id'])
    if graphic and graphic['format'] in ('masked','opaque_attributes'):
        raw=(destination/item['raw_path']).read_bytes()
        pixel_length=graphic['width']//8*graphic['height']
        stem=Path('Assets/Gfx')/Path(item['raw_path']).with_suffix('')
        parts=[('.ink',0,pixel_length,label)]
        suffix='.mask' if graphic['format']=='masked' else '.attr'
        parts.append((suffix,pixel_length,len(raw)-pixel_length,(label+('Mask' if suffix=='.mask' else 'Attr'))[:15]))
        for extension,offset,length,part_label in parts:
            target=stem.with_suffix(extension)
            (ROOT/target).write_bytes(raw[offset:offset+length])
            chunks.append(dict(**common,offset=item['original_offset']+offset,length=length,path=target.as_posix(),label=part_label))
    else:
        chunks.append(dict(**common,offset=item['original_offset'],length=item['length'],path='Assets/Gfx/'+item['raw_path'],label=label))
pres=SEM/'pres_graphics_chunks.json'
if pres.exists():
    for item in json.loads(pres.read_text(encoding='utf-8')):
        item['label']=item['label'].replace('PRES_','')
        item['label']=item['label'].replace('cell_position','CellPos')
        chunks.append(item)
for slot in range(28,32):
    manifest=json.loads((ROOT/'Disk/manifest.json').read_text(encoding='utf-8'))['entries'][slot]
    relative='Assets/Maps/Continent%d.map'%(slot-27)
    target=ROOT/relative;target.parent.mkdir(parents=True,exist_ok=True)
    target.write_bytes((ROOT/(manifest['path']+'.bin')).read_bytes())
    chunks.append(dict(slot=slot,offset=0,length=16100,path=relative,label='Cells'))
(SEM/'graphics_chunks.json').write_text(json.dumps(chunks,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(ROOT/'Docs/GraphicsFormats.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
verification=SEM/'graphics_consumer_verification.json'
if verification.exists(): shutil.copyfile(verification,ROOT/'Docs/GraphicsConsumerVerification.json')
shutil.copyfile(SEM/'decode_graphics.py',ROOT/'Tools/ExportSprites.py')
screens=(WORK/'semantic_screens.py').read_text(encoding='utf-8')
screens=screens.replace("ROOT=Path(__file__).resolve().parent.parent/'outputs/MYTHLAND'","ROOT=Path(__file__).resolve().parents[1]")
(ROOT/'Tools/ExportScreens.py').write_text(screens,encoding='utf-8')
print('Imported graphic chunks:',len(chunks))
