from pathlib import Path
import html
import json

ROOT=Path(__file__).resolve().parent.parent/'outputs/MYTHLAND'
gfx=json.loads((ROOT/'Docs/GraphicsFormats.json').read_text(encoding='utf-8'))
screens=json.loads((ROOT/'Docs/ScreenAssets.json').read_text(encoding='utf-8'))
functions=json.loads((ROOT/'Docs/functions.json').read_text(encoding='utf-8'))
units=json.loads((ROOT/'Docs/SoldierRecords.json').read_text(encoding='utf-8'))
structures=json.loads((ROOT/'Docs/Structures.json').read_text(encoding='utf-8'))

def escape(value): return html.escape(str(value),quote=True)
def relative(path): return path.removeprefix('Assets/')
def link(path,label): return '<a href="'+escape(path)+'">'+escape(label)+'</a>'
def attribute_link(path):
    attr=Path(path).with_suffix('.attr')
    return ' · '+link(relative(attr.as_posix()),'атрибуты') if (ROOT/attr).is_file() else ''

cards=[]
for unit in units:
    number=unit['id']
    frames=[f'Gfx/raw/unit_{number:02d}_frame_{i}.png' for i in range(1,5)]
    raw=[f'Gfx/raw/unit_{number:02d}_frame_{i}' for i in range(1,5)]
    cards.append('<article class="unit searchable" data-search="'+escape(str(number)+' '+unit['name'])+'">'
        '<img class="sprite animate" width="96" height="96" src="'+frames[0]+'" data-frames="'+'|'.join(frames)+'">'
        '<h3>'+str(number)+'. '+escape(unit['name'])+'</h3><div>32×32, четыре кадра, маска</div>'
        '<p>'+link('../Source/Files/21_SOLDIERS.asm','параметры FSoldier')+'</p>'
        '<details><summary>Исходные данные кадров</summary>'+''.join('<p>'+link(path+'.ink',f'{i+1}: пиксели')+' · '+link(path+'.mask','маска')+'</p>' for i,path in enumerate(raw))+'</details></article>')

sections=['<h2>Существа</h2><div class="grid">'+''.join(cards)+'</div>']
atlas_names=['SPR1_tiles_00_56.png','SPR2_battle_tiles_00_47.png','SPR1_hero_mode_0.png','SPR1_hero_mode_1.png',
             'SPR1_hero_mode_2.png','head_frame_parts.png','DATA1_selection_4_frames.png','DATA2_font.png','CTPAHA_font.png','PRES/PRES_font.png']
sections.append('<h2>Тайлы, герой, интерфейс и шрифты</h2><div class="sheets">'+''.join(
    '<figure>'+link('Gfx/'+name,'<'+name+'>')+'<p><img loading="lazy" class="pixel" src="Gfx/'+name+'"></p></figure>'
    for name in atlas_names if (ROOT/'Assets/Gfx'/name).exists())+'</div>')
sections.append('<h2>Экраны и портреты</h2><div class="grid screens">'+''.join(
    '<article class="searchable" data-search="'+escape(item['id'])+'"><h3>'+escape(item['id'])+'</h3>'
    +'<a href="'+relative(item['png'])+'"><img loading="lazy" class="pixel" src="'+relative(item['png'])+'"></a>'
    +'<p>'+link('../'+item['raw'],'бинарные данные')+attribute_link(item['raw'])+' · слот '+str(item['slot'])+', смещение #'+format(item['offset'],'04X')+'</p></article>'
    for item in screens)+'</div>')
pres=ROOT/'Assets/Gfx/PRES/PRES_screen.png'
if pres.exists(): sections.append('<h2>Заставка PRES</h2><img class="pixel" width="512" src="Gfx/PRES/PRES_screen.png"><p>'+link('../Source/Files/06_PRES.asm','код и ресурсы заставки')+'</p>')
maps=[]
for number in range(1,5):
    overview=f'Gfx/KARTA{number}_terrain_overview.png'
    if not (ROOT/'Assets'/overview).exists():
        candidates=sorted((ROOT/'Assets/Gfx').glob(f'KARTA{number}*overview*.png'))
        if candidates: overview='Gfx/'+candidates[0].name
        else: overview=f'Gfx/KARTA{number}_terrain.png'
    maps.append('<article><h3>Континент '+str(number)+'</h3><a href="Gfx/KARTA'+str(number)+'_terrain.png">'
        '<img loading="lazy" class="map pixel" src="'+overview+'"></a><p>'+link(f'Maps/Continent{number}.map','161×100 байтов карты')+'</p></article>')
sections.append('<h2>Карты</h2><p>Щелчок открывает изображение 5152×3200. Бит 6 задаёт отражение тайла, бит 7 не меняет картинку местности.</p><div class="maps">'+''.join(maps)+'</div>')
rows=[]
for item in gfx['assets']:
    rows.append('<tr class="searchable" data-search="'+escape(item['id']+' '+item['format'])+'"><td>'+escape(item['id'])+'</td>'
        '<td><img loading="lazy" class="small pixel" src="Gfx/'+item['png_path']+'"></td><td>'+escape(item['format'])+'</td>'
        '<td>'+str(item['width'])+'×'+str(item['height'])+'</td><td>'+str(item['original_slot'])+':#'+format(item['original_offset'],'04X')+'</td>'
        '<td>'+link('Gfx/'+item['raw_path'],'исходный блок')+attribute_link('Assets/Gfx/'+item['raw_path'])+'</td></tr>')
sections.append('<h2>Полный каталог графических блоков</h2><table><thead><tr><th>ID</th><th>Изображение</th><th>Формат</th><th>Размер</th><th>Слот:смещение</th><th>Данные</th></tr></thead><tbody>'+''.join(rows)+'</tbody></table>')
rows=[]
for fn in functions:
    rows.append('<tr class="searchable" data-search="'+escape(fn.get('symbol','')+' '+fn['description'])+'"><td>'
        +link('../'+fn['source'],fn.get('symbol',fn['block']))+'</td><td>#'+format(fn['address'],'04X')+'</td><td>'+escape(fn['description'])+'</td></tr>')
sections.append('<h2>Процедуры и точки входа</h2><table><thead><tr><th>Исходник</th><th>Адрес</th><th>Назначение</th></tr></thead><tbody>'+''.join(rows)+'</tbody></table>')
style='''body{margin:0;background:#181d25;color:#e0e7ed;font:16px/1.5 system-ui,sans-serif}main{max-width:1440px;margin:auto;padding:28px}h1,h2,h3{line-height:1.2}h2{margin-top:48px}a{color:#78ccff}header{position:sticky;top:0;background:#181d25ed;padding:12px 0;z-index:2}input[type=search]{padding:10px;width:min(500px,80vw);background:#29323f;border:1px solid #607181;color:white;border-radius:5px}.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(230px,1fr));gap:12px}article,figure{background:#242d39;padding:16px;border-radius:8px;margin:0}.unit{text-align:center}.unit p{margin:6px}.sprite{image-rendering:pixelated;background:repeating-conic-gradient(#596371 0% 25%,#85909f 0% 50%) 0/12px 12px}.pixel{image-rendering:pixelated;max-width:100%;height:auto}.screens img{width:256px}.screens{grid-template-columns:repeat(auto-fill,minmax(285px,1fr))}.sheets{display:flex;flex-wrap:wrap;gap:16px}.sheets figure{max-width:760px}.maps{display:grid;grid-template-columns:repeat(auto-fit,minmax(500px,1fr));gap:18px}.map{width:100%}table{border-collapse:collapse;width:100%;font-size:14px}td,th{padding:8px;border-bottom:1px solid #465362;text-align:left}.small{max-width:96px;max-height:64px}.hidden{display:none!important}code{background:#29323f;padding:2px 5px}details{text-align:left}'''
page='<!doctype html><html lang="ru"><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>Страна мифов — ресурсы и исходники</title><style>'+style+'</style><main>'
page+='<h1>Страна мифов — ресурсы и исходники</h1><p>Графика извлечена из оригинальных форматов. Сборка читает бинарные <code>.ink</code>, <code>.mask</code>, <code>.attr</code>, <code>.rle</code> и карты. PNG служат для просмотра.</p>'
page+='<p>'+link('../Docs/Structures.txt','структуры')+' · '+link('../Docs/Graphics.txt','форматы графики')+' · '+link('../Docs/UnitMatchups.tsv','матрица урона')+' · '+link('../README.txt','сборка')+'</p>'
page+='<header><input id="search" type="search" placeholder="Поиск по имени, номеру, формату или процедуре"> <label><input id="play" type="checkbox" checked> Анимация</label></header>'
page+=''.join(sections)
page+='''<script>let frame=0;setInterval(()=>{if(!document.querySelector('#play').checked)return;frame=(frame+1)%4;document.querySelectorAll('.animate').forEach(img=>img.src=img.dataset.frames.split('|')[frame]);},180);document.querySelector('#search').addEventListener('input',event=>{const query=event.target.value.toLocaleLowerCase();document.querySelectorAll('.searchable').forEach(item=>item.classList.toggle('hidden',!item.dataset.search.toLocaleLowerCase().includes(query)));});</script></main></html>'''
(ROOT/'Assets/Index.html').write_text(page,encoding='utf-8')
stats=dict(png_files=len(list((ROOT/'Assets').rglob('*.png'))),unit_animations=25,unit_frames=100,hero_animations=3,hero_frames=12,
    portrait_images=8,packed_scene_images=18,world_maps=4,font_glyphs=672,
    structures=len(structures),procedures=len(functions),gallery='Assets/Index.html')
(ROOT/'Docs/AssetCatalog.json').write_text(json.dumps(stats,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(stats,ensure_ascii=False))
