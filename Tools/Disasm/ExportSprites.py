"""Извлечение доказанных графических форматов MYTHLAND, без сборки проекта.

Зависимость только для PNG: Pillow. Исходные байты читаются из Tools/Disasm/Disk/manifest.json
и Tools/Disasm/Extracted. Образы TRD и исходники ASM этот инструмент не изменяет.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

from PIL import Image, ImageDraw


PALETTE = [(0, 0, 0), (0, 0, 205), (205, 0, 0), (205, 0, 205),
           (0, 205, 0), (0, 205, 205), (205, 205, 0), (205, 205, 205),
           (0, 0, 0), (0, 0, 255), (255, 0, 0), (255, 0, 255),
           (0, 255, 0), (0, 255, 255), (255, 255, 0), (255, 255, 255)]


def opaque(data: bytes, width_bytes: int, height_cells: int,
           attribute_override: int | None = None, flash_phase: int = 0) -> Image.Image:
    """Пиксели по строкам, затем линейная прямоугольная матрица атрибутов."""
    height = height_cells * 8
    pixels_length = width_bytes * height
    assert len(data) == pixels_length + width_bytes * height_cells
    image = Image.new('RGBA', (width_bytes * 8, height))
    result = image.load()
    for y in range(height):
        for x in range(width_bytes * 8):
            value = data[y * width_bytes + x // 8]
            attr = (data[pixels_length + y // 8 * width_bytes + x // 8]
                    if attribute_override is None else attribute_override)
            bit = bool(value & (128 >> (x & 7)))
            if attr & 128 and flash_phase:
                bit = not bit
            colour = ((attr & 7) if bit else (attr >> 3 & 7)) + (8 if attr & 64 else 0)
            result[x, y] = (*PALETTE[colour], 255)
    return image


def monochrome(data: bytes, width_bytes: int, height: int,
               mask: bytes | None = None, or_layer: bool = False) -> Image.Image:
    """Маска 1 сохраняет фон, пиксель 1 устанавливает INK независимо от маски."""
    assert len(data) == width_bytes * height
    assert mask is None or len(mask) == len(data)
    image = Image.new('RGBA', (width_bytes * 8, height))
    result = image.load()
    for y in range(height):
        for x in range(width_bytes * 8):
            bit = 128 >> (x & 7)
            offset = y * width_bytes + x // 8
            pixel = bool(data[offset] & bit)
            preserved = bool(mask[offset] & bit) if mask is not None else or_layer
            alpha = 255 if pixel or not preserved else 0
            value = 255 if pixel else 0
            result[x, y] = (value, value, value, alpha)
    return image


def atlas(images: list[Image.Image], columns: int, cell: tuple[int, int],
          labels: list[str] | None = None) -> Image.Image:
    """Контактный лист, клетчатый фон служит только для показа прозрачности."""
    label_height = 12 if labels else 0
    width, height = cell
    rows = (len(images) + columns - 1) // columns
    image = Image.new('RGB', (columns * width, rows * (height + label_height)), (80, 80, 80))
    draw = ImageDraw.Draw(image)
    for index, source in enumerate(images):
        left = index % columns * width
        top = index // columns * (height + label_height)
        for y in range(0, height, 4):
            for x in range(0, width, 4):
                shade = 90 if (x // 4 + y // 4) & 1 else 125
                draw.rectangle((left + x, top + y, left + x + 3, top + y + 3), fill=(shade,) * 3)
        image.paste(source, (left, top), source)
        if labels:
            draw.text((left, top + height), labels[index], fill='white')
    return image


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--project', type=Path, required=True, help='корень извлечённого проекта')
    parser.add_argument('--out', type=Path, required=True, help='папка PNG и исходных блоков')
    parser.add_argument('--report', type=Path, help='путь к graphics_formats.json')
    args = parser.parse_args()
    project, output = args.project.resolve(), args.out.resolve()
    output.mkdir(parents=True, exist_ok=True)
    manifest = json.loads((project / 'Tools/Disasm/Disk/manifest.json').read_text(encoding='utf-8'))
    entries = {entry['slot']: entry for entry in manifest['entries']}
    assets, chunks, atlases, layouts = [], [], [], []
    tile_images, unit_frames = {}, {}

    def original(slot: int, sectors: bool = False) -> bytes:
        suffix = '.sectors.bin' if sectors else '.bin'
        return (project / (entries[slot]['path'] + suffix)).read_bytes()

    def write(relative: str, data: bytes) -> str:
        path = output / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
        return relative

    def chunk(name: str, slot: int, offset: int, data: bytes, kind: str,
              representation: str = 'original') -> dict:
        item = dict(id=name, original_slot=slot, original_offset=offset, length=len(data),
                    trd_offset=entries[slot]['offset'] + offset, kind=kind,
                    representation=representation, raw_path=write(f'raw/{name}.bin', data),
                    sha256=hashlib.sha256(data).hexdigest())
        if representation == 'original':
            assert original(slot)[offset:offset + len(data)] == data
        chunks.append(item)
        return item

    def sprite(name: str, slot: int, offset: int, data: bytes, fmt: str,
               width_bytes: int = 4, height_cells: int = 4,
               evidence: list[str] | None = None, representation: str = 'original',
               attribute_override: int | None = None) -> Image.Image:
        raw = chunk(name, slot, offset, data, fmt, representation)
        height = height_cells * 8
        pixel_size = width_bytes * height
        if fmt == 'opaque_attributes':
            image = opaque(data, width_bytes, height_cells, attribute_override)
        elif fmt == 'masked':
            assert len(data) == pixel_size * 2
            image = monochrome(data[:pixel_size], width_bytes, height, data[pixel_size:])
            monochrome(data[pixel_size:], width_bytes, height).save(output / f'raw/{name}.mask.png')
        elif fmt == 'or_pixels':
            image = monochrome(data, width_bytes, height, or_layer=True)
        else:
            raise ValueError(fmt)
        png_path = f'raw/{name}.png'
        image.save(output / png_path)
        item = dict(id=name, format=fmt, width=width_bytes * 8, height=height,
                    original_slot=slot, original_offset=offset, length=len(data),
                    raw_path=raw['raw_path'], png_path=png_path, evidence=evidence or [])
        if fmt == 'opaque_attributes':
            item['attribute_offset'] = pixel_size
            if attribute_override is not None:
                item['preview_attribute_override'] = attribute_override
            elif any(value & 128 for value in data[pixel_size:]):
                item['flash_phase_1_png'] = f'raw/{name}.flash.png'
                opaque(data, width_bytes, height_cells, flash_phase=1).save(output / item['flash_phase_1_png'])
        else:
            item['attributes'] = None
            item['preview_colour'] = 'монохромный INK белый, PAPER чёрный, атрибуты берутся с фона'
            if fmt == 'masked':
                item['mask_offset'] = pixel_size
                item['mask_png'] = f'raw/{name}.mask.png'
        assets.append(item)
        return image

    def save_atlas(name: str, images: list[Image.Image], columns: int,
                   labels: list[str] | None = None) -> None:
        image = atlas(images, columns, (32, 32), labels)
        path = f'{name}.png'
        image.resize((image.width * 2, image.height * 2), Image.Resampling.NEAREST).save(output / path)
        atlases.append(dict(id=name, path=path, scale=2))

    # SPR1 содержит непрозрачные клетки, изображения героя и два маскированных объекта.
    data = original(35)
    images = []
    for index in range(57):
        name = f'SPR1_tile_{index:02d}'
        image = sprite(name, 35, index * 144, data[index * 144:(index + 1) * 144],
                       'opaque_attributes', evidence=['head:#8359..#8378', 'head:#8396..#8413'])
        images.append(image)
        tile_images[index] = image
    save_atlas('SPR1_tiles_00_56', images, 8, [str(i) for i in range(57)])
    for name, first, columns, rows in [('SPR1_castle_3x2_tiles', 41, 3, 2),
                                       ('SPR1_object_6B09_2x2_tiles', 48, 2, 2)]:
        composite = Image.new('RGBA', (columns * 32, rows * 32))
        for index in range(columns * rows):
            composite.paste(images[first + index], (index % columns * 32, index // columns * 32))
        composite.save(output / f'{name}.png')
        atlases.append(dict(id=name, path=f'{name}.png', scale=1, evidence=['head:#8396..#83C3', 'head:#8543']))
    for group in range(3):
        frames = []
        for frame in range(4):
            offset = 0x2010 + group * 1024 + frame * 256
            frames.append(sprite(f'SPR1_hero_mode_{group}_frame_{frame + 1}', 35, offset,
                                 data[offset:offset + 256], 'masked', evidence=['head:#846B..#8496']))
        save_atlas(f'SPR1_hero_mode_{group}', frames, 4)
    for index, address in enumerate((0xEC10, 0xED10)):
        offset = address - 0xC000
        sprite(f'SPR1_overlay_{index}', 35, offset, data[offset:offset + 256],
               'masked', evidence=['head:#8416..#8438', 'head:#85D0'])
    for name, address, evidence in (
            ('SPR1_end_tile_EE10', 0xEE10, ['контекст соседней таблицы, явный потребитель ещё не найден']),
            ('SPR1_missing_map_piece', 0xEEA0, ['overlay15:#B26D..#B274'])):
        offset = address - 0xC000
        sprite(name, 35, offset, data[offset:offset + 144], 'opaque_attributes', evidence=evidence)
    layouts.append(dict(slot=35, length=len(data), partition='57*144 + 3*4*256 + 2*256 + 2*144',
                        runtime_bank=4, runtime_origin=0xC000,
                        terrain_ids=list(range(41)), tile_group_evidence='head:#8359..#8378',
                        groups=[dict(first_tile=41, tile_count=6, columns=3, rows=2,
                                     world_group=0x6AE9, runtime_address=0xD710, evidence='head:#8396..#83A3'),
                                dict(first_tile=47, tile_count=1, columns=1, rows=1,
                                     world_group=0x6AF9, runtime_address=0xDA70, evidence='head:#83A6..#83B3'),
                                dict(first_tile=48, tile_count=4, columns=2, rows=2,
                                     world_group=0x6B09, runtime_address=0xDB00, evidence='head:#83B6..#83C3'),
                                *[dict(first_tile=52 + i, tile_count=1, columns=1, rows=1,
                                       world_group=0x6B19 + 16 * i, runtime_address=0xDD40 + 144 * i,
                                       evidence='head:#83C6..#8413') for i in range(5)]]))

    # SPR2 и SPR3 хранят по четыре маскированных кадра каждого ID существа.
    battle_tiles = []
    data = original(44)
    for index in range(48):
        battle_tiles.append(sprite(f'SPR2_battle_tile_{index:02d}', 44, index * 144,
                                   data[index * 144:(index + 1) * 144], 'opaque_attributes',
                                   evidence=['battle:#FC07..#FC5F', 'battle:#FC92..#FCA3']))
        if index >= 46:
            assert not any(data[index * 144:(index + 1) * 144])
            assets[-1]['semantic_status'] = 'нулевое заполнение до начала анимаций, найденные карты его не используют'
    save_atlas('SPR2_battle_tiles_00_47', battle_tiles, 8, [str(i) for i in range(48)])
    for unit_id in range(1, 26):
        slot = 44 if unit_id <= 9 else 45
        base = 0x1B00 + (unit_id - 1) * 1024 if slot == 44 else (unit_id - 10) * 1024
        data = original(slot)
        frames = []
        for frame in range(4):
            offset = base + frame * 256
            frames.append(sprite(f'unit_{unit_id:02d}_frame_{frame + 1}', slot, offset,
                                 data[offset:offset + 256], 'masked',
                                 evidence=['head:#80DB..#8103', 'head:#7366..#73A4',
                                           'head:#825B', 'battle:#F8D3..#F8DF', 'battle:#F92A..#F95C']))
            assets[-1]['unit_id'] = unit_id
            assets[-1]['frame_number'] = frame + 1
        unit_frames[unit_id] = frames
        save_atlas(f'unit_{unit_id:02d}', frames, 4)
    save_atlas('all_25_units_4_frames', [frame for row in unit_frames.values() for frame in row],
               4, [f'{unit}:{frame}' for unit in range(1, 26) for frame in range(1, 5)])
    layouts.extend([dict(slot=44, length=16128, runtime_origin=0xC000, runtime_bank=6,
                         partition='46*144 используемых тайлов + 2*144 нулевого заполнения + 9*4*256',
                         normal_terrain_sets=dict(count=5, tile_count=5,
                             free_tile_index='5*(terrain-1)', obstacle_tile_index='5*(terrain-1)+1+E',
                             random='7C0D с DE=3 возвращает E=0..3 включительно'),
                         fixed_map_tiles=dict(first_tile=25, last_tile=45)),
                    dict(slot=45, length=16384, runtime_origin=0xC000, runtime_bank=7,
                         partition='16*4*256')])

    # Последние 768 байтов DATA1 содержат изображение атаки и четыре OR-кадра выбора.
    data = original(46)
    attack_offset = 0xCF55 - 0xC41A
    chunk('DATA1_before_graphics', 46, 0, data[:attack_offset], 'other_data')
    sprite('DATA1_attack', 46, attack_offset, data[attack_offset:attack_offset + 256],
           'masked', evidence=['battle:#F6A5..#F6B0'])
    frames = []
    for frame in range(4):
        offset = 0xD055 - 0xC41A + frame * 128
        frames.append(sprite(f'DATA1_select_frame_{frame + 1}', 46, offset,
                             data[offset:offset + 128], 'or_pixels',
                             evidence=['battle:#F9B1..#F9E3']))
    save_atlas('DATA1_selection_4_frames', frames, 4)
    layouts.append(dict(slot=46, runtime_bank=3, runtime_origin=0xC41A, length=len(data),
                        partition='2875 данных + 256 атака + 4*128 OR-кадры'))

    # Встроенные образцы рамки и курсора основного ядра.
    head = original(10)
    frames = []
    for index in range(8):
        offset = 0x74AF - 0x615E + index * 9
        frames.append(sprite(f'head_frame_part_{index}', 10, offset, head[offset:offset + 9],
                             'opaque_attributes', 1, 1, ['head:#73FE..#74A3'], attribute_override=0x47))
    save_atlas('head_frame_parts', frames, 8)
    offset = 0x79CE - 0x615E
    sprite('head_cursor', 10, offset, head[offset:offset + 48], 'masked', 3, 1,
           ['head:#76DA..#76F8', 'head:#7980', 'head:#79A5'])

    # Расшифрованные ресурсы BL3 читаются тем же ключом, что использует упаковщик.
    bl3_raw = original(4)
    bl3_key = (project / 'Tools/Disasm/Disk/Keys/S04.xor').read_bytes()
    assert len(bl3_raw) == len(bl3_key)
    bl3 = bytes(left ^ right for left, right in zip(bl3_raw, bl3_key))
    frames = []
    for index in range(8):
        offset = 0x72C9 - 0x6149 + index * 9
        frames.append(sprite(f'BL3_frame_part_{index}', 4, offset, bl3[offset:offset + 9],
                             'opaque_attributes', 1, 1, ['BL3:#7220..#72BD'],
                             representation='plaintext', attribute_override=0x47))
    save_atlas('BL3_frame_parts', frames, 8)
    offset = 0x76C2 - 0x6149
    sprite('BL3_cursor', 4, offset, bl3[offset:offset + 48], 'masked', 3, 1,
           ['BL3:#73CE..#73EB', 'BL3:#7674', 'BL3:#7699'], representation='plaintext')
    offset = 0x7CFD - 0x6149
    sprite('BL3_save_list_bar', 4, offset, bl3[offset:offset + 54], 'opaque_attributes', 6, 1,
           ['BL3:#645E..#646F'], representation='plaintext')

    # Шрифт DATA2 используется как BL3, так и ядром, адресное смещение при загрузке различно.
    data2 = original(7)
    chunk('DATA2_font_codes_032_255', 7, 0, data2[:1792], 'font_8x8')
    chunk('DATA2_after_font', 7, 1792, data2[1792:], 'text_and_data')
    sector_data = original(2, True)
    menu_key = (project / 'Tools/Disasm/Disk/Keys/CTPM.xor').read_bytes()
    menu = bytes(left ^ right for left, right in zip(sector_data[512:512 + 5632], menu_key))
    font_offset = 0x6F24 - 0x6171
    menu_font = menu[font_offset:font_offset + 1792]
    chunk('CTPAHA_font_codes_032_255', 2, 512 + font_offset, menu_font, 'font_8x8', 'plaintext')
    offset = 0x6C11 - 0x6171
    sprite('CTPAHA_cursor', 2, 512 + offset, menu[offset:offset + 32], 'masked', 2, 1,
           ['CTPAHA:#69D8', 'CTPAHA:#6C11/#6C21'], representation='plaintext')
    for name, font in [('DATA2_font', data2[:1792]), ('CTPAHA_font', menu_font)]:
        glyphs = [monochrome(font[index * 8:(index + 1) * 8], 1, 8) for index in range(224)]
        sheet = atlas(glyphs, 16, (8, 8))
        sheet.resize((sheet.width * 4, sheet.height * 4), Image.Resampling.NEAREST).save(output / f'{name}.png')
        for index, glyph in enumerate(glyphs):
            code = index + 32
            write(f'font/{name}_{code:03d}.bin', font[index * 8:(index + 1) * 8])
            glyph.save(output / f'font/{name}_{code:03d}.png')
        atlases.append(dict(id=name, path=f'{name}.png', scale=4, glyph_codes=[32, 255],
                            glyph_storage_width=8, glyph_height=8, advance=6))

    # Четыре готовых поля используют таблицы индексов внутри bitwa.co.
    battle = original(47)
    for name, address in [('mode_6', 0xFDFA), ('mode_7', 0xFE22),
                          ('mode_8', 0xFE4A), ('special_bit7', 0xFE72)]:
        offset = address - 0xD255
        values = battle[offset:offset + 40]
        chunk(f'battlefield_{name}_tilemap', 47, offset, values, 'battle_tilemap')
        image = Image.new('RGBA', (256, 160))
        for index, value in enumerate(values):
            tile_index = 24 + (value & 127)
            assert 0 < value & 127 < 24
            tile = battle_tiles[tile_index]
            if value & 128:
                tile = tile.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
            image.paste(tile, (index % 8 * 32, index // 8 * 32))
        image.save(output / f'battlefield_{name}.png')
        atlases.append(dict(id=f'battlefield_{name}', path=f'battlefield_{name}.png',
                            evidence=['battle:#FC6F..#FCAE'], scale=1))

    # Полный неподвижный ландшафт карт, динамические объекты принадлежат отдельным слоям.
    mirrored_tiles = {index: image.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
                      for index, image in tile_images.items()}
    for slot in range(28, 32):
        values = original(slot)
        assert len(values) == 161 * 100
        chunk(f'KARTA{slot - 27}_cells', slot, 0, values, 'strategic_map')
        image = Image.new('RGBA', (161 * 32, 100 * 32))
        observed = sorted({value & 63 for value in values})
        assert max(observed) <= 40
        for index, value in enumerate(values):
            source = mirrored_tiles[value & 63] if value & 64 else tile_images[value & 63]
            image.paste(source, (index % 161 * 32, index // 161 * 32))
        name = f'KARTA{slot - 27}_terrain'
        image.save(output / f'{name}.png')
        image.resize((644, 400), Image.Resampling.NEAREST).save(output / f'{name}.overview.png')
        atlases.append(dict(id=name, path=f'{name}.png', overview=f'{name}.overview.png',
                            width=5152, height=3200, static_terrain_only=True,
                            original_slot=slot, observed_tile_ids=observed,
                            evidence=['head:#8359..#8378', 'head:#75E1']))

    # Проверка полного непересекающегося покрытия трёх файлов спрайтов и DATA1/DATA2.
    coverage = []
    for slot in (35, 44, 45, 46, 7, 28, 29, 30, 31):
        selected = sorted((item for item in chunks if item['original_slot'] == slot),
                          key=lambda item: item['original_offset'])
        cursor = 0
        for item in selected:
            assert item['representation'] == 'original'
            assert item['original_offset'] == cursor
            cursor += item['length']
        assert cursor == entries[slot]['length']
        reconstructed = b''.join((output / item['raw_path']).read_bytes() for item in selected)
        assert reconstructed == original(slot)
        coverage.append(dict(original_slot=slot, bytes=cursor, chunk_count=len(selected),
                             byte_identical=True))

    formats = {
        'opaque_attributes': dict(width_variable=True, pixels='W*8*H байтов по строкам',
            attributes='W*H байтов после пикселей, порядок строк и столбцов',
            byte_offset='y*W + floor(x/8)', attribute_offset='8*W*H + floor(y/8)*W + floor(x/8)',
            bit_order='бит7 слева', evidence=['head:#7545', 'head:#75E1', 'BL3:#6EA6']),
        'masked': dict(pixels='W*8*H байтов по строкам', mask='следующие W*8*H байтов',
            screen_formula='экран = (экран AND маска) OR пиксели', attributes=None,
            transparency='маска1 и пиксель0 сохраняют фон, пиксель1 устанавливает INK',
            preview='PNG показывает INK белым, PAPER чёрным, сохранённый фон прозрачен',
            evidence=['head:#75A2', 'head:#7649', 'head:#825B']),
        'or_pixels': dict(pixels='W*8*H байтов по строкам', mask=None, attributes=None,
            screen_formula='экран = экран OR пиксели', evidence=['battle:#F9C9..#F9CC']),
        'font_8x8': dict(first_code=32, last_code=255, glyph_bytes=8, bit_order='бит7 слева',
            advance_pixels=6, note='PNG сохраняет все8бит строки, часть глифов шире6бит',
            locations=[dict(slot=7, offset=0, length=1792, head_bank=11,
                            head_address=0xE0D0, head_formula='DFD0+8*A',
                            bl3_bank=3, bl3_address=0xC000, bl3_formula='BF00+8*A'),
                       dict(slot=2, offset=512 + font_offset, length=1792,
                            address=0x6F24, representation='plaintext', formula='6F24+8*(A-32)')],
            evidence=['head:#7052..#7064', 'BL3:#6E15..#6E24', 'CTPAHA:#6DBD']),
        'strategic_map': dict(columns=161, rows=100, cell_bytes=1,
            file_offset='row*161+column', graphic_id='cell AND#3F',
            tile_address='банк4:C000+144*(cell AND#3F)',
            bit6='горизонтальное отражение тайла', bit7='не участвует в выборе картинки',
            observed_ids=list(range(41)), evidence=['head:#80B4', 'head:#8359..#8378']),
        'battle_tilemap': dict(columns=8, rows=5, length=40,
            index='низшие7бит, должен быть ненулевым', mirror='бит7',
            address='банк6:CD80+144*(value AND#7F)', spr2_tile_index='24+(value AND#7F)',
            evidence=['battle:#FC7D..#FCAE']),
    }
    fields = [
        (0, 1, 'Flags', 'младшие5бит режим0..4, бит5 численная подпись, биты6/7 отражение'),
        (1, 1, 'AnimationTimer', 'счётчик до следующего кадра, DEC, при0 перезагрузка из+3'),
        (2, 1, 'AnimationFrame', 'текущий номер кадра1..FrameCount, увеличивается перед выводом'),
        (3, 1, 'AnimationPeriod', 'значение перезагрузки счётчика'),
        (4, 1, 'FrameCount', 'число кадров, #7366 задаёт4'),
        (5, 1, 'BaseBank', 'банк основного изображения'),
        (6, 2, 'BaseAddress', 'младший байт адреса первым'),
        (8, 1, 'Frame1Bank', 'банк переднего слоя либо первого кадра'),
        (9, 2, 'Frame1Address', 'адрес переднего слоя либо первого кадра'),
        (11, 1, 'Frame2Bank', 'банк второго кадра'),
        (12, 2, 'Frame2Address', 'адрес второго кадра'),
        (14, 1, 'Frame3Bank', 'банк третьего кадра'),
        (15, 2, 'Frame3Address', 'адрес третьего кадра'),
        (17, 1, 'Frame4Bank', 'банк четвёртого кадра'),
        (18, 2, 'Frame4Address', 'адрес четвёртого кадра'),
    ]
    structure = dict(name='FScreenObject20', size=20, address=0x6571, count=48,
        grid=dict(columns=8, rows=6, cell_width=32, cell_height=32,
                  formula='6571+20*(row*8+column)', battle_first_address=0x6611),
        fields=[dict(offset=offset, size=size, name=name, meaning=meaning,
                     evidence=['head:#7366', 'head:#8104..#8242'])
                for offset, size, name, meaning in fields],
        modes={'0': 'не выводить', '1': 'основное изображение с атрибутами по+5/+6',
               '2': 'основной маскированный слой по+5/+6, отражение задаёт бит7',
               '3': 'непрозрачный фон по+5/+6 и маскированный слой по+8/+9',
               '4': 'непрозрачный фон и текущий кадр из четырёх трёхбайтных описателей'},
        flags={'bit5': 'после выполненного вывода подписать число из6931+2*index',
               'bit6': 'отражать передний маскированный слой в режимах3/4',
               'bit7': 'отражать основной слой в режимах1/2/3/4'},
        lifecycle='после режимов1..3 младшие5бит сбрасываются, режим4 сохраняется',
        first_frame_note='инициализация frame=1 и timer=1 в7366 даёт кадр2 при первом тике8104')
    report = dict(schema=1, source_sha256=manifest['sha256'],
                  validation='статический разбор потребителей и побайтовая проверка извлечённых raw, без сборки',
                  formats=formats, structures=[structure], file_layouts=layouts,
                  assets=assets, chunks=chunks, atlases=atlases, coverage=coverage,
                  notes=[
                    'STROENIA слот19 не графика, BL3#679C..#67A2 грузит начальные записи мира в7A31',
                    'SPR1 тайл поEE10 имеет подходящую144байтную структуру, но явный потребитель пока не найден',
                    'PNG маскированных существ монохромные, реальные цвета наследуются от фоновых атрибутов',
                    'Chunks с representation plaintext заменяют расшифрованные DB до обратного XOR упаковщика',
                    'Координаты и порядок глифов не нормализованы, все исходные байты сохранены',
                  ])
    report_path = args.report.resolve() if args.report else output / 'graphics_formats.json'
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(dict(assets=len(assets), chunks=len(chunks), atlases=len(atlases),
                          complete_files=coverage, output=str(output), report=str(report_path)),
                     ensure_ascii=True))


if __name__ == '__main__':
    main()
