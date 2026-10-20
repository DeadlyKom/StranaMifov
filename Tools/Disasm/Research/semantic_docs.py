"""Сформировать пользовательскую документацию после semantic_transform/split/make_docs.

Скрипт читает готовые JSON и Includes/Structs, обновляет только Docs и README.txt.
Ассемблер, графические конвертеры и сборочные сценарии не запускаются.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import io
import json
from pathlib import Path
import re


WORK = Path(__file__).resolve().parent
SEM = WORK / 'semantic'
DEFAULT_PROJECT = WORK.parent / 'outputs/MYTHLAND'


def read_json(path: Path, default=None):
    if not path.exists():
        if default is not None:
            return default
        raise FileNotFoundError(f'не найден обязательный источник документации: {path}')
    return json.loads(path.read_text(encoding='utf-8-sig'))


def records(value, key: str) -> list[dict]:
    return value.get(key, []) if isinstance(value, dict) else value


def plain(value) -> str:
    if value is None:
        return ''
    if isinstance(value, list):
        return ', '.join(plain(part) for part in value)
    if isinstance(value, dict):
        return ', '.join(f'{key}={plain(part)}' for key, part in value.items())
    return re.sub(r'\s+', ' ', str(value)).strip()


def evidence(value, detailed=False) -> str:
    if isinstance(value, list):
        return ' / '.join(dict.fromkeys(evidence(part, detailed) for part in value if part))
    if isinstance(value, dict):
        location = value.get('module', '')
        address = value.get('hex')
        if not address and isinstance(value.get('address'), int):
            address = f"#{value['address']:04X}"
        location += (':' if location and address else '') + (address or '')
        operation = value.get('operation', value.get('meaning', ''))
        return location + ((' ' + plain(operation)) if detailed and operation else '') or plain(value)
    return plain(value)


def hx(number: int, width=4) -> str:
    return f'#{number:0{width}X}'


def semantic_names(symbols: dict) -> int:
    return sum(not re.fullmatch(r'F[0-9A-F]{4}', item['symbol'].rsplit('.', 1)[-1])
               for item in symbols.get('functions', []))


def function_symbol(symbols: dict, block: str, address: int) -> str:
    matches = [item['symbol'] for item in symbols.get('functions', [])
               if item['block'] == block and item['address'] == address]
    if len(matches) != 1:
        raise ValueError(f'не найден единственный символ {block}:{address:04X}')
    return matches[0]


def current_screen_assets(screens: list[dict], symbols: dict) -> list[dict]:
    """Разрешить старые названия потребителей по исходному модулю и адресу."""
    result = []
    for original in screens:
        item = dict(original)
        decoder = item.get('decode', '')
        if 'Graphics.UnpackScene' in decoder:
            block, address = {8: ('S08', 0x7D39), 33: ('S33', 0xC006),
                              34: ('S34', 0xC006)}[item['slot']]
            decoder = decoder.replace('Graphics.UnpackScene', function_symbol(symbols, block, address))
        if 'Engine.DrawBlock' in decoder:
            decoder = decoder.replace('Engine.DrawBlock', function_symbol(symbols, 'S10', 0x7545))
        item['decode'] = decoder
        result.append(item)
    return result


def portable_pres(value):
    """Ссылки доставляемого реестра ведут внутрь проекта, а не в рабочий черновик."""
    if isinstance(value, list):
        return [portable_pres(item) for item in value]
    if not isinstance(value, dict):
        return value
    item = {key: portable_pres(part) for key, part in value.items()}
    if isinstance(item.get('source'), str):
        source = item['source'].replace('\\', '/')
        if '/Extracted/' in source:
            item['source'] = 'Extracted/' + source.split('/Extracted/', 1)[1]
        elif source.startswith('work/semantic/graphics/') and item.get('path'):
            item['source'] = item['path']
    return item


def table(headers: list[str], rows: list[list]) -> str:
    def cell(value):
        return plain(value).replace('|', '\\|')
    return '\n'.join(['| ' + ' | '.join(map(cell, headers)) + ' |',
                       '| ' + ' | '.join('---' for _ in headers) + ' |'] +
                      ['| ' + ' | '.join(map(cell, row)) + ' |' for row in rows])


def numeric(token: str) -> int:
    token = token.strip()
    return int(token[1:], 16) if token.startswith('#') else int(token, 0)


def include_structures(project: Path) -> dict[str, dict]:
    """Прочитать декларации, не вызывая ассемблер и не исполняя выражения."""
    declarations = {}
    for path in sorted((project / 'Includes/Structs').glob('*.inc')):
        current = None
        for line in path.read_text(encoding='utf-8-sig').splitlines():
            body, _, comment = line.partition(';')
            body = body.strip()
            start = re.fullmatch(r'struct\s+(\w+)', body, re.I)
            if start:
                current = dict(name=start[1], source=path.relative_to(project).as_posix(),
                               meaning=comment.strip(), declarations=[])
                declarations[start[1]] = current
            elif current is not None and body.lower() == 'ends':
                current = None
            elif current is not None and body:
                part = re.fullmatch(r'(\w+)\s+([\w]+)(?:\s+(.*))?', body)
                if not part:
                    raise ValueError(f'{path}: неподдержанная декларация поля {body!r}')
                current['declarations'].append((part[1], part[2], part[3] or '', comment.strip()))
    result = {}
    pending = dict(declarations)
    while pending:
        progressed = False
        for name, declaration in list(pending.items()):
            offset, fields = 0, []
            for field_name, directive, arguments, meaning in declaration['declarations']:
                opcode = directive.upper()
                if opcode in ('DB', 'BYTE'):
                    size = len(arguments.split(','))
                elif opcode in ('DW', 'WORD'):
                    size = 2 * len(arguments.split(','))
                elif opcode in ('DS', 'BLOCK'):
                    size = numeric(arguments.split(',', 1)[0])
                elif directive in result:
                    size = result[directive]['size']
                else:
                    break
                fields.append(dict(name=field_name, offset=offset, size=size,
                                   type=directive, meaning=meaning))
                offset += size
            else:
                result[name] = {**declaration, 'fields': fields, 'size': offset}
                del pending[name]
                progressed = True
        if not progressed:
            raise ValueError('не разрешены типы Includes/Structs: ' + ', '.join(pending))
    return result


def structure_document(project: Path, schemas: list[dict], compiled: dict) -> str:
    by_name = {item['name']: item for item in schemas}
    total_fields = sum(len(item['fields']) for item in schemas)
    lines = ['СТРУКТУРЫ И ИМЕНОВАННЫЕ СМЕЩЕНИЯ', '',
             f'Основной реестр Docs/Structures.json: {len(schemas)} структур, {total_fields} полей.',
             f'В Includes/Structs найдено {len(compiled)} деклараций, включая слова и вложенные массивы.',
             'Смещения и размеры ниже выражены в байтах. Слова хранят младший байт первым.',
             'Декларация struct задаёт размер и именованные смещения, сама по себе новую память не выделяет.',
             'EQU в Includes/Address.inc даёт существующему адресу смысловое имя и также не выделяет память.',
             'В Includes/Structs/Include.inc указан порядок подключения зависимых типов.', '',
             'Как читать исходники',
             '  (IX + FType.Field) обращается к полю записи, на начало которой указывает IX.',
             '  FWord.Low/High задают байты слова, FFloat5 хранит исходное число калькулятора ПЗУ.',
             '  Указатель может указывать внутрь записи, это оговаривается в In конкретной процедуры.',
             '  Поля Unknown/Reserved сохраняют исходные байты, их название не разрешает использовать их как свободную память.', '',
             'Реестр типов',
             table(['тип', 'размер', 'назначение', 'исходник'],
                   [[name, item['size'], by_name.get(name, {}).get('meaning', by_name.get(name, {}).get('purpose', item['meaning'])), item['source']]
                    for name, item in compiled.items()]), '']
    for name, actual in compiled.items():
        schema = by_name.get(name, {})
        declared = {field['name']: field for field in schema.get('fields', [])}
        if schema and schema['size'] != actual['size']:
            raise ValueError(f'{name}: Structures.json и Include расходятся по размеру')
        lines += [f"{name}, {actual['size']} байт", 'Исходник: ' + actual['source'],
                  schema.get('meaning', schema.get('purpose', actual.get('meaning', '')))]
        rows = []
        for field in actual['fields']:
            semantic = declared.get(field['name'], {})
            if semantic and any(semantic[key] != field[key] for key in ('offset', 'size')):
                raise ValueError(f'{name}.{field["name"]}: Structures.json и Include расходятся')
            rows.append([field['name'], f"{hx(field['offset'], 2)} / {field['offset']}", field['size'],
                         field['type'], semantic.get('meaning', semantic.get('description', field['meaning'])),
                         evidence(semantic.get('evidence')) or 'объявление struct, без отдельного игрового утверждения',
                         semantic.get('confidence', '')])
        lines += [table(['поле', 'offset hex/dec', 'size', 'тип', 'назначение', 'потребитель', 'статус'], rows)]
        for field in schema.get('fields', []):
            proof = evidence(field.get('evidence'), True)
            if proof:
                lines.append('  ' + field['name'] + ': ' + proof)
            for key, value in field.items():
                if key not in ('name', 'offset', 'size', 'type', 'meaning', 'description', 'evidence', 'confidence'):
                    lines.append('  ' + field['name'] + '.' + key + ': ' + plain(value))
        for key, value in schema.items():
            if key not in ('name', 'size', 'fields', 'meaning', 'purpose'):
                lines.append(key + ': ' + plain(value))
        lines.append('')
    return '\n'.join(lines).rstrip() + '\n'


def asset_path(path, base='Assets/Gfx') -> str:
    if not path:
        return ''
    value = str(path).replace('\\', '/')
    return value if value.startswith('Assets/') else base.rstrip('/') + '/' + value


def graphics_document(project: Path, gfx: dict, screens: list[dict], pres: dict) -> str:
    assets = gfx.get('assets', [])
    chunks = gfx.get('chunks', [])
    incbins = set()
    for base in ('Source', 'Includes'):
        for path in (project / base).rglob('*'):
            if path.suffix.lower() in ('.asm', '.inc'):
                for line in path.read_text(encoding='utf-8-sig').splitlines():
                    incbins.update(re.findall(r'\bINCBIN\s+"([^"]+)"', line.partition(';')[0], re.I))

    def compiled_parts(item, base='Assets/Gfx'):
        candidates = set()
        for key in ('raw_path', 'raw', 'packed', 'ink_path', 'mask_path', 'attr_path'):
            if item.get(key):
                path = asset_path(item[key], base)
                candidates.add(path)
                if path.endswith('.packed.bin'):
                    candidates.add(path.replace('.packed.bin', '.rle'))
                else:
                    candidates.update(Path(path).with_suffix(extension).as_posix() for extension in ('.ink', '.mask', '.attr'))
        return ', '.join(sorted(candidates & incbins)) or 'см. INCBIN потребителя/общего блока'
    lines = ['ГРАФИКА, ШРИФТЫ И КАРТЫ', '',
             'Откройте Assets/Index.html в браузере для визуального просмотра ресурсов.',
             f'GraphicsFormats.json описывает {len(assets)} графических элементов, {len(chunks)} исходных частей и {len(gfx.get("atlases", []))} атласов.',
             f'ScreenAssets.json содержит {len(screens)} экранов и портретов. Разные реестры могут описывать один исходный диапазон, складывать эти числа как число уникальных картинок нельзя.', '',
             'Что редактируется и что читается при сборке',
             '  Источники INCBIN в ASM являются точными входами сборки. Это .bin, .ink, .mask, .attr, .scr, .rle и .packed.bin по конкретному ресурсу.',
             '  .ink хранит пиксели, .mask маску сохранения фона, .attr атрибуты знакомест. Если плоскости лежат вместе в .bin, их разделение определяется offset/форматом JSON.',
             '  PNG, mask.png, увеличенный атлас и обзор карты являются предпросмотром. Изменение PNG само по себе не изменяет игру и не запускает обратный конвертер.',
             '  У маскированного спрайта экран=(экран AND маска) OR пиксели. Атрибуты могут наследоваться с фона, поэтому монохромный прозрачный PNG не задаёт окончательный цвет в игре.',
             '  Упакованная сцена собирается из исходного заголовка и RLE-потока. Распакованный SCR и его PNG показывают результат, но не заменяют .rle автоматически.',
             '  Для каждого элемента проверяйте original_slot/slot, original_offset/offset, length, формат и evidence. Правильное изображение без этой связи не является обратимым извлечением.', '',
             'Форматы и реальные потребители']
    for name, specification in gfx.get('formats', {}).items():
        lines += ['', name]
        lines += ['  ' + key + ': ' + (evidence(value, True) if key == 'evidence' else plain(value))
                  for key, value in specification.items()]
    lines += ['', 'Состав исходных графических файлов']
    for layout in gfx.get('file_layouts', []):
        lines += [table(['слот', 'длина', 'банк', 'runtime', 'разбиение'], [[
            layout.get('slot', ''), layout.get('length', ''), layout.get('runtime_bank', ''),
            hx(layout['runtime_origin']) if isinstance(layout.get('runtime_origin'), int) else '', layout.get('partition', '')]])]
        for key, value in layout.items():
            if key not in ('slot', 'length', 'runtime_bank', 'runtime_origin', 'partition'):
                lines.append('  ' + key + ': ' + plain(value))
    lines += ['', 'Элементы спрайтов и тайлов', table(
        ['ID', 'слот', 'offset', 'bytes', 'размер', 'формат', 'полный raw', 'реальные INCBIN', 'PNG', 'потребитель'],
        [[item.get('id', ''), item.get('original_slot', item.get('slot', '')),
          hx(item.get('original_offset', item.get('offset', 0))), item.get('length', ''),
          f"{item.get('width', '?')}x{item.get('height', '?')}", item.get('format', item.get('kind', '')),
          asset_path(item.get('raw_path', item.get('raw', ''))), compiled_parts(item), asset_path(item.get('png_path', item.get('png', ''))),
          evidence(item.get('evidence'))] for item in assets])]
    for item in assets:
        auxiliary = {key: asset_path(item[key]) for key in
                     ('mask_png', 'flash_phase_1_png', 'ink_path', 'mask_path', 'attr_path') if item.get(key)}
        raw_path = asset_path(item.get('raw_path', ''))
        if raw_path:
            for extension in ('.ink', '.mask', '.attr'):
                relative = Path(raw_path).with_suffix(extension)
                if (project / relative).is_file():
                    auxiliary[extension] = relative.as_posix()
        if auxiliary:
            lines.append('  ' + item.get('id', '') + ': ' + plain(auxiliary))
    lines += ['', 'Экраны и портреты', table(
        ['ID', 'слот', 'offset', 'bytes', 'размер', 'исходный пакет', 'реальные INCBIN', 'SCR/raw', 'PNG', 'формат'],
        [[item.get('id', ''), item.get('slot', ''), hx(item.get('offset', 0)), item.get('length', ''),
          f"{item.get('width', '?')}x{item.get('height', '?')}", item.get('packed', ''), compiled_parts(item, ''), item.get('raw', ''),
          item.get('png', ''), item.get('decode', '')] for item in screens])]
    lines += ['', 'PRES: экран, собственный шрифт и исполняемая заставка',
              f"Слот {pres['slot']}, длина {pres['length']}, каталоговый адрес {hx(pres['catalog_origin'])}, runtime {hx(pres['runtime_origin'])}.",
              f"Разобрано {len(pres['entry_points'])} входов, {pres['instruction_count']} инструкций, {pres['code_bytes']} байтов кода.",
              'PRES не является одним непрерывным спрайтом или только данными. Точное разделение хранит Docs/PRESLayout.json, алгоритмы — Docs/PRESAnnotations.json.',
              table(['runtime start', 'end exclusive', 'назначение', 'формат'],
                    [[hx(item['start']), hx(item['endExclusive']), item['kind'], item['format']]
                     for item in pres.get('data_parts', [])]),
              'Части для INCBIN: ' + plain([item['path'] for item in pres.get('chunks', [])]),
              'Предпросмотр: ' + plain(pres.get('pngs', [])), '', 'Атласы и обзоры']
    lines += ['  ' + item.get('id', '') + ': ' + asset_path(item.get('path', '')) for item in gfx.get('atlases', [])]
    lines += ['', 'Примечания конкретных ресурсов'] + ['  ' + str(note) for note in gfx.get('notes', [])]
    return '\n'.join(lines).rstrip() + '\n'


def symbols_document(symbols: dict, functions: list[dict], structures: dict) -> str:
    descriptions = {(item['block'], item['address']): item for item in functions}
    output = io.StringIO(newline='')
    writer = csv.writer(output, delimiter='\t', lineterminator='\n')
    writer.writerow(['kind', 'module', 'original_key', 'value_hex', 'value_dec', 'symbol', 'source', 'line', 'meaning', 'evidence'])
    function_names = set()
    for item in symbols.get('functions', []):
        function_names.add(item['symbol'])
        fn = descriptions.get((item['block'], item['address']), {})
        analysis = fn.get('analysis', {})
        writer.writerow(['function', item['symbol'].rsplit('.', 1)[0],
                         f"{item['block']}:{item['address']:04X}", hx(item['address']), item['address'],
                         item['symbol'], fn.get('source', item.get('source', '')), fn.get('line', item.get('line', '')),
                         plain(analysis.get('purpose', fn.get('description', ''))),
                         evidence(analysis.get('evidence'), True)])
    for name, value in sorted(symbols.get('values', {}).items()):
        if name in function_names:
            continue
        base = name.split('.', 1)[0]
        struct = structures.get(base)
        kind = ('struct_size' if name == base else 'field_offset') if struct else 'equ'
        source = struct['source'] if struct else 'Includes/Address.inc'
        writer.writerow([kind, base if struct else name.rsplit('.', 1)[0], '', hx(value), value,
                         name, source, '', 'размер/смещение struct' if struct else 'исходное значение EQU', 'Docs/Symbols.json'])
    return output.getvalue()


def old_section(text: str, begin: str, end: str) -> str:
    if begin not in text or end not in text:
        raise ValueError('не найден проверенный раздел прежнего DataFormats: ' + begin)
    return text.split(begin, 1)[1].split(end, 1)[0].strip()


def save_layout(project: Path, manifest: dict) -> tuple[list, dict]:
    source = read_json(project / 'Docs/BootstrapAndOverlayAnnotations.json')
    details = source['O09:B200']['details']
    part = details.split('Записывает', 1)[1].split('Перед записью', 1)[0]
    sectors = [int(value) for value in re.findall(r'(\d+)\s*сектор', part)]
    banks = [int(value) for value in re.findall(r'банка\s*(\d+)', part)]
    addresses = re.findall(r'из\s*(#[0-9A-Fa-f]+)', part)
    invert = details.split('инвертирует', 1)[1].split('полезных', 1)[0]
    lengths = [int(value, 16) for value in re.findall(r'#([0-9A-Fa-f]+)', invert)]
    if len(sectors) != len(lengths) or len(sectors) != len(banks) + 1 or len(addresses) < 2:
        raise ValueError('JSON-аннотация O09:B200 не содержит ожидаемую схему записи .M')
    entries = manifest['entries']
    unit = next(item['allocated'] // item['sectors'] for item in entries if item.get('sectors'))
    files = [item for item in entries if item.get('type') == 'M']
    offset, rows = 0, []
    for index, (count, inverted) in enumerate(zip(sectors, lengths)):
        source_name = 'основное состояние из ' + addresses[0] if index == 0 else f'банк {banks[index - 1]} от {addresses[1]}'
        stored = count * unit
        rows.append([hx(offset), source_name, count, stored, inverted, stored - inverted])
        offset += stored
    if any(item['length'] != offset for item in files):
        raise ValueError('длины файлов .M в каталоге не соответствуют подтверждённой схеме O09')
    return rows, dict(length=offset, sectors=sum(sectors), sector_size=unit, files=len(files))


def data_document(project: Path, schemas: list[dict], gfx: dict, pres: dict, manifest: dict) -> str:
    old = (WORK / 'loader/data_formats.txt').read_text(encoding='utf-8')
    rows, saved = save_layout(project, manifest)
    banks = read_json(project / 'Docs/BankLoads.json')
    lines = ['ФОРМАТЫ ДАННЫХ И РЕСУРСОВ СЕМАНТИЧЕСКОГО ПРОЕКТА', '',
             'Практические реестры',
             '  Docs/Structures.txt и Structures.json — текущие типы, все поля, offsets/sizes и конкретные читатели/писатели.',
             '  Docs/Graphics.txt, GraphicsFormats.json, ScreenAssets.json и Assets/Index.html — графика, плоскости, кадры и исходные диапазоны.',
             '  Docs/Symbols.tsv и Symbols.json — смысловые имена функций, EQU, размеров и смещений.',
             '  Docs/HoMMConventions.txt — образцы оформления из HoMM и правила их применения к исходным форматам этой игры.',
             f'Текущий реестр содержит {len(schemas)} структур. Статус конкретного поля хранится в confidence/evidence, нейтральные Unknown относятся только к нему.',
             'Этот обзор заменяет предварительную версию, где ещё не были установлены форматы спрайтов, PERSON и структур мира.', '',
             'Исходное расположение и runtime',
             'Каталожный адрес TR-DOS не всегда является рабочим адресом. Формат файла и логический банк нужно брать у фактического загрузчика.',
             table(['файл', 'банк', 'runtime', 'вызов загрузки', 'выбор'],
                   [[item['file'], item['logical_bank'], hx(item['destination']), hx(item['call']), item.get('selection', '')] for item in banks]),
             f"В фазе Startup PRES имеет каталоговый адрес {hx(pres['catalog_origin'])}, но грузится по {hx(pres['runtime_origin'])}. Её банк и вызовы указаны в PRESLayout.json.",
             'SOLDIERS в основном движке читается по #C000 банка 3, хотя каталог содержит #C700. Начальное состояние ранее переносится из #C700 того же банка, это другая фаза.',
             'Карта открытия и текущая карта относятся к разным буферам. Бит занятости основной карты не является маской открытия.', '',
             'Записи мира, героя и боя',
             table(['тип', 'байтов', 'назначение'], [[item['name'], item['size'], item.get('meaning', item.get('purpose', ''))] for item in schemas]),
             'Имена и флаги PLAYER/PERSON/гарнизона читаются через соответствующую структуру. Не переносите смещения между физической записью и указателем на её имя.',
             'Исходный PERSON7 длиннее других файлов и проходит преобразование пар в стартовом коде. Файлы сохраняются в исходных длинах, схема преобразования описана в Structures.txt.', '',
             'Графические форматы',
             'Извлечены непрозрачные тайлы с атрибутами, пиксельные и маскированные кадры, OR-слои, шрифты, упакованные сцены, полный титульный SCR и карты.',
             f'В GraphicsFormats.json {len(gfx.get("assets", []))} элементов. Точный формат каждого — в его строке реестра, одинаковое имя SPR не означает одинаковый формат всего файла.',
             'PRES содержит собственный код и сценарии. HERIMG/BL1/BL2 содержат общий распаковщик и RLE-записи. STROENIA содержит исходные записи мира.',
             'При сборке читаются исходные raw-файлы и потоки из INCBIN. PNG/атласы нужны для просмотра и не являются автоматическим источником перекодирования.', '',
             'Формат сохранения .M',
             f"По каталогу {saved['files']} активных/удалённых записей .M, длина каждой {saved['length']} байтов, {saved['sectors']} секторов по {saved['sector_size']} байтов.",
             'Сектора идут подряд от начала файла. Для каждого блока инвертируется только полезный префикс, остаток секторной длины сохраняется в исходном формате.',
             table(['смещение файла', 'источник', 'секторов', 'записано байтов', 'инвертировано', 'хвост без инверсии'], rows),
             'Запись выполняет Overlay.Save, исходные адреса O09:B200/B2D8/B2E2. После записи повторная побитовая инверсия восстанавливает память. Чтение Startup выполняет обратное преобразование.',
             'ID типа M, имя файла, удалённый первый байт каталога и секторный хвост хранятся отдельно от логических областей состояния. Удалённые записи не превращаются в новые игровые файлы.', '',
             'Деградация и два независимых счётчика типа']
    for paragraph in old.split('\n\n'):
        if paragraph.startswith(('Смысл +#29 дополнительно', 'Отдельное расхождение документации и кода:')):
            lines += [paragraph.strip(), '']
    lines += ['Переключатель деградации в head.co/C',
              old_section(old, 'Переключатель деградации в head.co/C', 'Служебные счётчики по ID отряда'), '',
              'Служебные счётчики по ID отряда',
              old_section(old, 'Служебные счётчики по ID отряда', 'Состояние армии игрока'), '',
              'Калькулятор ПЗУ и численные представления',
              'FFloat5 сохраняет пять исходных байтов формата калькулятора ROM Spectrum, включая его особую запись целого. Это не IEEE float и не обычное little-endian слово.',
              'FTroop.Count — исходное целое, FBattleUnit.Quantity — рабочее число калькулятора с дробными потерями. Подмена одного представления другим меняет расчёт боя.',
              'Потребители передают и извлекают значения через шлюзы ПЗУ. Токены после RST #28 являются данными калькулятора, их нельзя разбирать как последовательные Z80-команды.',
              'Точные арифметические формулы и контракты регистров находятся в комментариях процедур Engine/Battle и Docs/functions.json.', '',
              'Тексты и защита',
              'Русские строки используют CP866, нули, CR и управляющие коды сохраняются в собираемом ресурсе. OriginalHelp.txt является текстом для чтения, а не заменой зашифрованного HELPG.tx.',
              'Физическое положение CTPAHA и HELPG участвует в защите. Адреса фаз и XOR-слои описаны в Architecture.txt, ProtectionLayers.json, ProtectionContracts.json и HelpDecryption.json.',
              'Секторные хвосты и удалённые записи остаются исходными, формат и порядок TRD не нормализуются по внешнему виду данных.', '']
    return '\n'.join(lines).rstrip() + '\n'


def architecture_document(project: Path, schemas: list[dict], symbols: dict, gfx: dict,
                          screens: list[dict], pres: dict, manifest: dict) -> str:
    text = (project / 'Docs/Architecture.txt').read_text(encoding='utf-8-sig')
    coverage = read_json(project / 'Docs/coverage.json')
    text = re.sub(r'Main\.asm последовательно ассемблирует\s*\d+ исходный блок',
                  f'Main.asm последовательно ассемблирует {len(coverage)} исходный блок', text)
    text = text.replace('Каждый блок имеет исходный адрес исполнения либо адрес табличного файла',
                        'Каждый блок имеет исходный runtime-адрес исполнения либо адрес табличного файла')
    text = text.replace('  #631C загружает RAMDRIVE и выбирает поддерживаемую схему256К',
                        '  #631C загружает RAMDRIVE и выбирает поддерживаемую схему256К\n'
                        '  PRES загружается в банк4 по #C000, вызовы #E200 показывают заставку')
    text = text.replace('  PRES загружается в банк4 по #C000, вызовы #E200 показывают заставку\n'
                        '  PRES загружается в банк4 по #C000, вызовы #E200 показывают заставку',
                        '  PRES загружается в банк4 по #C000, вызовы #E200 показывают заставку')
    presentation = '\n'.join(['PRES',
        f"  Каталоговый адрес {hx(pres['catalog_origin'])} не является адресом исполнения, runtime {hx(pres['runtime_origin'])}",
        f"  {function_symbol(symbols, 'S06', 0xE200)} показывает предысторию, звёзды, титры и проявляет экран",
        f"  {len(pres['entry_points'])} входов, {pres['instruction_count']} команд и {pres['code_bytes']} байтов кода",
        '  Собственный SCR, шрифт и сценарии отделены от кода, см. PRESLayout.json и Graphics.txt', ''])
    if '\nPRES\n' in text:
        text = re.sub(r'(?m)^PRES\n.*?(?=^head\.co\n)', presentation, text, flags=re.S)
    else:
        text = text.replace('\nhead.co\n', '\n' + presentation + 'head.co\n')
    if 'Начальная фаза BL3 имеет отдельные загрузки' not in text:
        text = text.replace('в BankLoads.json, адреса каталога ресурсов могут отличаться от runtime-адресов',
                            'в BankLoads.json, адреса каталога ресурсов могут отличаться от runtime-адресов\n'
                            'Начальная фаза BL3 имеет отдельные загрузки, PRESLayout.json показывает банк4\n'
                            'для PRES, позднее то же окно банка используется другими ресурсами ядра')
    text = text.replace('Проверочная сборка sjasmplus 1.23.1 завершилась без ошибок\n'
                        'Lua и независимое сравнение файлов подтвердили побайтовое совпадение TRD',
                        'Результат последней сборки и её отпечатки хранятся в BuildVerification.json\n'
                        'README.txt сопоставляет отпечатки отчёта с текущими ASM/INC/Lua и raw-файлами\n'
                        'Границы подтверждения исполнения перечислены в VerificationLimits.txt')
    marker = '\n8. Семантическая навигация по исходникам\n'
    text = text.split(marker, 1)[0].rstrip()
    lines = [text, '', '8. Семантическая навигация по исходникам', '',
        'Source/Files хранит точки подключения исходных файлов каталога, порядок байтов задаёт Main.asm',
        'Source/Engine/Include.inc подключает отдельные процедуры ядра в исходном порядке',
        'Source/Battle/Include.inc подключает боевой код, Source/Startup/Include.inc начальные меню',
        'Source/Loader/Menu/Include.inc подключает скрытое меню и редактор SOLDIERS',
        'Исполняемый код PRES находится в Source/Files/06_PRES.asm, module Presentation',
        'Source/Overlays содержит 22 независимых тематических модуля, каждый со своим #B200',
        'Актуальный файл и строку каждой процедуры берите из Functions.tsv или Symbols.tsv', '',
        f"Symbols.json содержит {len(symbols.get('functions', []))} входов, из них {semantic_names(symbols)} со смысловыми именами",
        'Остальные адресные Fxxxx являются техническими именами установленных точек входа',
        f'В Structures.json {len(schemas)} предметных структур, размеры и поля объявлены в Includes/Structs',
        'Includes/Address.inc даёт существующим адресам EQU-имена, нового размещения эти объявления не создают',
        f"GraphicsFormats.json описывает {len(gfx.get('assets', []))} элементов, ScreenAssets.json ещё {len(screens)} экранов/портретов",
        'Реестры частично описывают одни диапазоны и не суммируются в число уникальных изображений',
        'Assets/Index.html открывает PNG-просмотр, сборка читает указанные INCBIN raw-плоскости и потоки',
        'Форматы .ink/.mask/.attr, RLE и границы смешанных файлов описаны в Graphics.txt',
        'STROENIA содержит записи мира, его трактовка как набора спрайтов не используется', '']
    return '\n'.join(lines)


def limits_document(project: Path, schemas: list[dict], symbols: dict, gfx: dict,
                    screens: list[dict], pres: dict, manifest: dict) -> str:
    old = (project / 'Docs/VerificationLimits.txt').read_text(encoding='utf-8-sig')
    coverage = read_json(project / 'Docs/coverage.json')
    verification = read_json(project / 'Docs/BuildVerification.json', {})
    graphics_check = read_json(project / 'Docs/GraphicsConsumerVerification.json', {})
    screen_check = read_json(project / 'Docs/ScreenDecodeVerification.json', {})
    audit = read_json(project / 'Docs/SourceAudit.json', {})
    original_features = old.split('Отдельные исходные особенности не исправлялись', 1)[-1].strip()
    lines = ['ГРАНИЦЫ ПРОВЕРКИ', '', 'Установлено разбором и сохранёнными отчётами',
        f"  исходный SHA-256, извлечение {len(manifest['entries'])} записей каталога и сохранение хвостов/удалённых данных",
        f"  непересекающееся покрытие {sum(item['length'] for item in coverage)} байтов активного содержимого в {len(coverage)} блоках",
        f"  {sum(item['instructions'] for item in coverage)} декодированных команд и {len(symbols.get('functions', []))} установленных входов",
        '  выполнение отдельных дешифраторов в Python Simulator SkoolKit и обратные преобразования KB/CTPAHA/BL3/HELPG',
        '  статическое восстановление образа по исходным байтам, INCBIN, каталогу и ключам, см. StaticVerification.json',
        f"  {len(schemas)} предметных структур с размерами, полями и доказательствами в Structures.json",
        f"  {semantic_names(symbols)} смысловых имён функций, остальные установленные входы имеют технические Fxxxx",
        f"  {len(gfx.get('assets', []))} элементов GraphicsFormats.json и {len(screens)} записей ScreenAssets.json, реестры пересекаются",
        f"  PRES, {len(pres['entry_points'])} входов, {pres['code_bytes']} байтов кода, отдельные SCR/шрифт/сценарии, см. PRESLayout.json",
        f"  графические потребители проверены на {graphics_check.get('passed', 'не указанном числе')} отдельных фикстурах, см. GraphicsConsumerVerification.json",
        f"  RLE сравнен с исходным Z80-декодером для {len(screen_check.get('results', []))} картинок, см. ScreenDecodeVerification.json", '',
        'Последняя сборка',
        '  первичный отчёт, дата, версия ассемблера, предупреждение и SHA-256 — BuildVerification.json',
        '  результат сохранённого отчёта: errors=' + plain(verification.get('errors')) +
        ', warnings=' + plain(verification.get('warnings')) + ', byte_identical=' + plain(verification.get('byte_identical')),
        '  README.txt сопоставляет его отпечатки с текущими ASM/INC/pack.lua и raw/Disk',
        '  отчёт относится к указанному снимку, выпуск документации сам по себе не является новой сборкой',
        '  упаковку TRD выполняет встроенный Lua sjasmplus, внешнего упаковщика нет', '',
        'Не подтверждено',
        '  успешная загрузка пересобранного TRD в полном эмуляторе',
        '  работа всех режимов, схем памяти, чтения и записи сохранений в полной машине',
        '  исчерпывающее исполнение всех непрямых переходов и игровых ветвей', '',
        'Семантическая полнота',
        f"  SourceAudit.json сообщает {audit.get('complete_contract_headers', 'не указанное число')} заполненных заголовков In/Out/Corrupt",
        '  наличие заголовка и предметной аннотации не означает доказательства всех регистров/флагов для каждого пути',
        '  конкретные установленные входы, результаты, изменения и сохранённые регистры указаны в самой процедуре',
        '  Unknown/Reserved остаются нейтральными полями только там, где назначение не доказано',
        '  DB включает известные таблицы, тексты, токены калькулятора и сохранённые неразмеченные байты',
        '  INCBIN включает уже классифицированные raw-ресурсы, их формат и потребители указаны в Graphics/Structures',
        '  data_or_unclassified_bytes в coverage.json является суммарной категорией, а не числом неизвестных данных',
        '  статический поиск не доказывает отсутствие иных точек входа во всех состояниях',
        '  побайтовая тождественность подтверждает воспроизведение программы, но не прохождение всех игровых правил', '',
        'Ограничения модели дешифрования',
        '  использовано стандартное ПЗУ48 и точное число M1-выборок в Simulator',
        '  прерывания во время защищённых проходов отключены',
        '  два успешных обращения TR-DOS в KB заменены документированной моделью',
        '  полный контроллер диска и вся игра при этом не исполнялись',
        '  подробности в ProtectionLayers.json, ProtectionContracts.json и ProtectionSimulation.json', '',
        'Проверка Tools/verify_static.py',
        '  раскрывает INCLUDE, читает DB/DW/INCBIN и исходные байты команд из комментариев листинга',
        '  сопоставляет мнемоники с сохранённым эталоном, разрешая значения Symbols.json и арифметику смещений',
        '  проверяет длины, колонки комментариев, байты переходов и обратное преобразование диска',
        '  не использует ассемблер и не создаёт TRD, не заменяет проверку принятия исходников sjasmplus', '',
        'Предупреждение sjasmplus',
        '  out0, исходная команда OUT (C),0, код ED 71 в скрытом меню',
        '  для CMOS Z80 поведение отличается, команда сохранена как в оригинале',
        '  актуальный файл и строка предупреждения приведены в BuildVerification.json', '',
        'Отдельные исходные особенности не исправлялись', original_features, '']
    return '\n'.join(lines)


def conventions_document(schemas: list[dict], symbols: dict, gfx: dict, screens: list[dict], pres: dict) -> str:
    text = (SEM / 'homm_conventions.md').read_text(encoding='utf-8')
    text = text.split('5. Предлагаемая файловая раскладка', 1)[0].rstrip()
    text = text.replace('Область: только чтение HoMM, разбор существующих форматов Strana и предложение оформления',
                        'Область: справка по прочитанным примерам HoMM и применённому семантическому оформлению Strana')
    text = text.replace('Типы называются FArmyStack/FCastle/FSoldierType и определяются через struct/ends. '
                        'Поля именуются по доказанному назначению и используются как смещения, например (IX + FArmyStack.Count.Low).',
                        'В текущем проекте типы называются FTroop/FMapArmy/FCastle/FSoldier/FBattleUnit и определяются через struct/ends. '
                        'Поля именуются по доказанному назначению и используются как смещения, например (IX + FTroop.Count.Low).')
    text = text.replace('3. Точные примеры деклараций, без размещения новых данных',
                        '3. Справочные примеры деклараций, без размещения новых данных\n\n'
                        'Ниже сохранены первоначальные примеры синтаксиса и соглашений. Имена FValue/FArmyStack/FWorldArmy '
                        'в этих примерах учебные, фактические имена/поля проекта берите из Includes/Structs и Docs/Structures.txt.')
    text += '\n\n' + '\n'.join(['5. Фактическая файловая раскладка', '',
        'Source/Engine/Include.inc и отдельные файлы процедур ядра',
        'Source/Battle/Include.inc и отдельные файлы боевых процедур',
        'Source/Startup/Include.inc и отдельные файлы начального интерфейса',
        'Source/Loader/Menu/Include.inc и отдельные файлы скрытого меню/редактора',
        'Source/Overlays/01.asm..22.asm, тематические module с общим runtime #B200',
        'Source/Files/*.asm, точки подключения исходных файлов каталога и смешанных код/данные',
        'Includes/Structs/Include.inc, Includes/Structs/*.inc, Includes/Address.inc',
        'Assets/Gfx, Assets/Screens, Assets/Portraits, raw-плоскости и потоки по конкретным INCBIN',
        'Assets/Gfx/PRES, исходный SCR, собственный шрифт и сценарии заставки',
        'Assets/Index.html, PNG/атласы/карты для просмотра',
        'Docs/Symbols.tsv, старый адрес, смысловой либо технический символ, фактический файл и строка',
        'Docs/GraphicsFormats.json и ScreenAssets.json, слот, диапазон, формат и пути графики',
        'Docs/Structures.json и Structures.txt, поля, размеры, смещения, значения битов и потребители', '',
        'Сборка читает raw INCBIN. PNG не преобразуются обратно автоматически. Размеры, адреса и порядок исходных файлов сохраняются.', '',
        '6. Актуальные реестры форматов', '',
        f"Внедрено {semantic_names(symbols)} смысловых имён из {len(symbols.get('functions', []))} установленных входов.",
        f"Графика, {len(gfx.get('assets', []))} элементов GraphicsFormats.json, {len(screens)} записей ScreenAssets.json с пересечением диапазонов.",
        f"PRES, runtime {hx(pres['runtime_origin'])}, {len(pres['entry_points'])} функций, {pres['code_bytes']} байтов кода, точные диапазоны в PRESLayout.json.",
        'PRESAnnotations.json описывает алгоритмы заставки, Graphics.txt указывает raw/PNG и плоскости.',
        'STROENIA содержит начальные записи мира, их схемы FMapList/FMapArmy/FMapTroop/FCastle/FMapItem/FTemple/FTown описаны в Structures.txt.',
        'SOLDIERS описывает FSoldier, бой — FBattleUnit. Поле FBattleUnit.Affinity установлено потребителями и не является Unknown01.',
        'PERSON/PERSON7 и их фазовое преобразование описаны в FPerson/FPerson7/FGameState, прежние предварительные оговорки заменены реестром полей.',
        'Полная актуальная схема',
        table(['тип', 'байтов', 'назначение'],
              [[item['name'], item['size'], item.get('meaning', item.get('purpose', ''))] for item in schemas]), '',
        '7. Связь формы с исходными байтами', '',
        'Ресурс имеет raw/маску/атрибуты согласно формату и PNG-просмотр с размерами, кадрами и исходным диапазоном.',
        'Структура содержит размер, смещение, назначение либо Unknown и доказанного потребителя для каждого поля.',
        'Смысловые имена используются в операндах исходников, адресное происхождение сохраняется в Symbols.tsv.',
        'Имена и разбиение не меняют исходные адреса, длины, фазовые наложения памяти и порядок сборки TRD.',
        'Файлы HoMM использованы как справочные образцы. Результат сборки Strana и границы проверки находятся в BuildVerification.json и VerificationLimits.txt.', ''])
    return text


def code_hash(project: Path) -> str:
    lines = []
    files = sorted(file for base in ('Source', 'Includes') for file in (project / base).rglob('*')
                   if file.suffix in ('.asm', '.inc'))
    for file in files + [project / 'Main.asm']:
        lines.append(file.relative_to(project).as_posix())
        lines.extend(line.partition(';')[0].rstrip() for line in file.read_text(encoding='utf-8').splitlines()
                     if line.partition(';')[0].strip())
    lines.append((project / 'Tools/pack.lua').read_text(encoding='utf-8'))
    return hashlib.sha256('\n'.join(lines).encode('utf-8')).hexdigest()


def binary_hash(project: Path) -> str:
    files = sorted(file for file in (project / 'Assets').rglob('*') if file.is_file() and
                   file.suffix.lower() in ('.bin', '.ink', '.mask', '.attr', '.rle', '.scr', '.map'))
    files += sorted((project / 'Disk/Keys').glob('*')) + [project / 'Disk/layout.bin']
    payload = [file.relative_to(project).as_posix() + ':' + hashlib.sha256(file.read_bytes()).hexdigest() for file in files]
    return hashlib.sha256('\n'.join(payload).encode('utf-8')).hexdigest()


def readme_document(project: Path, schemas: list[dict], symbols: dict, gfx: dict, screens: list[dict]) -> str:
    text = (project / 'README.txt').read_text(encoding='utf-8-sig')
    title = 'Семантический проект'
    if title in text and 'Папка пользователя' in text:
        before, tail = text.split(title, 1)
        text = before + 'Папка пользователя' + tail.split('Папка пользователя', 1)[1]
    intro = f'''Семантический проект
  Начните с Assets/Index.html, Docs/Structures.txt, Docs/Graphics.txt и Docs/Symbols.tsv
  Source/Engine              отдельные процедуры основного движка и Include.inc
  Source/Battle              отдельные процедуры боя и Include.inc
  Source/Startup             загрузка и начальные меню, процедуры и Include.inc
  Source/Loader/Menu         процедуры скрытого меню и редактора
  Source/Overlays            тематические module для загружаемых оверлеев
  Includes/Structs           struct/ends, именованные поля и размеры исходных записей
  Includes/Address.inc       EQU существующих адресов, без нового размещения памяти
  Assets                    исходные raw-ресурсы и PNG-предпросмотр, индекс Index.html
  Assets/Gfx                спрайты, плоскости, шрифты, карты и материалы PRES
  Assets/Screens            сцены, SCR и исходные RLE-потоки
  Assets/Portraits          портреты, их пиксели и атрибуты

  В Structures.json {len(schemas)} структур, в Symbols.json {len(symbols.get('functions', []))} установленных входов
  Смысловые имена имеют {semantic_names(symbols)} входов, остальные сохраняют технические Fxxxx
  GraphicsFormats.json описывает {len(gfx.get('assets', []))} элементов, ScreenAssets.json — {len(screens)} экранов/портретов
  Сборка читает raw .ink/.mask/.attr/.bin/.rle/.scr по INCBIN в исходниках
  PNG и атласы предназначены для просмотра, их редактирование само по себе не меняет игру
  Синтаксис и образцы HoMM — Docs/HoMMConventions.txt, заставка — Docs/PRESLayout.json

'''
    position = text.find('Папка пользователя')
    if position < 0:
        position = text.find('\n\n') + 2
    text = text[:position] + intro + text[position:]
    coverage = read_json(project / 'Docs/coverage.json')
    functions = read_json(project / 'Docs/functions.json')
    manifest = read_json(project / 'Disk/manifest.json')
    summary = '\n'.join(['Численные результаты текущей разметки',
        f"  Исходных блоков — {len(coverage)}, декодированных команд — {sum(item['instructions'] for item in coverage)}",
        f"  Процедур и дополнительных точек входа — {len(functions)}",
        f"  Точек с предметными аннотациями алгоритма — {sum(bool(item.get('annotated')) for item in functions)}",
        f"  Байтов исходных блоков по coverage.json — {sum(item['length'] for item in coverage)}",
        f"  Размер исходного диска по manifest.json — {manifest['size']} байтов", ''])
    text = re.sub(r'(?m)^Численные результаты текущей разметки\n.*?(?=^Проверки)', summary + '\n', text, flags=re.S)
    active = sum(not item.get('deleted', False) for item in manifest['entries'])
    deleted = sum(bool(item.get('deleted', False)) for item in manifest['entries'])
    text = re.sub(r'(?m)^(  Extracted/Active\s+)\d+ действующих файла', rf'\g<1>{active} действующих файлов', text)
    text = re.sub(r'(?m)^(  Extracted/Deleted\s+)\d+ удалённых записей', rf'\g<1>{deleted} удалённых записей', text)
    text = text.replace('  Build                     проверенный TRD, листинг и символы sjasmplus',
                        '  Build                     результаты снимка из BuildVerification.json')
    verification = read_json(project / 'Docs/BuildVerification.json', {})
    code_current = verification.get('source_code_sha256') == code_hash(project)
    raw_recorded = bool(verification.get('binary_source_sha256'))
    raw_current = raw_recorded and verification['binary_source_sha256'] == binary_hash(project)
    check = ['Проверки и их область',
             '  Выпуск документации сам по себе не запускает сборку и полную машину.',
             '  Последняя запись проверки сборки — Docs/BuildVerification.json.',
             '  Дата записи: ' + plain(verification.get('verified_utc', 'не указана')),
             '  Отпечаток ASM/INC/pack.lua: ' + ('совпадает с текущими файлами' if code_current else 'не подтверждает текущие файлы'),
             '  Отпечаток raw и Disk: ' + ('совпадает с текущими файлами' if raw_current else 'не подтверждает текущие файлы'),
             '  Данные отчёта относятся к зафиксированному им снимку, это не новая сборка при выпуске документации.']
    if verification:
        check += ['  Результат сохранённого отчёта: exit_code=' + plain(verification.get('exit_code')) +
                  ', errors=' + plain(verification.get('errors')) + ', warnings=' + plain(verification.get('warnings')),
                  '  byte_identical=' + plain(verification.get('byte_identical')) +
                  ', full_machine_executed=' + plain(verification.get('full_machine_executed'))]
        if verification.get('warning'):
            check.append('  Предупреждение сохранённого отчёта: ' + plain(verification['warning']))
    check += ['  Границы статического и игрового подтверждения — Docs/VerificationLimits.txt.', '']
    text = re.sub(r'(?m)^Проверки(?: и их область)?\n.*?(?=^Как собрать\n)', '\n'.join(check) + '\n', text, flags=re.S)
    return text


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--project', type=Path, default=DEFAULT_PROJECT)
    args = parser.parse_args()
    project = args.project.resolve()
    docs = project / 'Docs'
    schemas = records(read_json(docs / 'Structures.json'), 'structures')
    compiled = include_structures(project)
    symbols = read_json(docs / 'Symbols.json')
    functions = read_json(docs / 'functions.json')
    gfx = read_json(docs / 'GraphicsFormats.json')
    screen_registry = read_json(docs / 'ScreenAssets.json')
    screens = current_screen_assets(records(screen_registry, 'assets'), symbols)
    pres = portable_pres(read_json(SEM / 'pres_layout.json'))
    manifest = read_json(project / 'Disk/manifest.json')
    # Все тексты готовятся до первой записи, ошибки JSON/структур не оставляют половину документации.
    changes = {
        docs / 'Structures.txt': structure_document(project, schemas, compiled),
        docs / 'Graphics.txt': graphics_document(project, gfx, screens, pres),
        docs / 'Symbols.tsv': symbols_document(symbols, functions, compiled),
        docs / 'DataFormats.txt': data_document(project, schemas, gfx, pres, manifest),
        docs / 'Architecture.txt': architecture_document(project, schemas, symbols, gfx, screens, pres, manifest),
        docs / 'VerificationLimits.txt': limits_document(project, schemas, symbols, gfx, screens, pres, manifest),
        project / 'README.txt': readme_document(project, schemas, symbols, gfx, screens),
        docs / 'HoMMConventions.txt': conventions_document(schemas, symbols, gfx, screens, pres),
        docs / 'ScreenAssets.json': json.dumps({**screen_registry, 'assets': screens} if isinstance(screen_registry, dict)
                                              else screens, ensure_ascii=False, indent=2),
    }
    for source in SEM.glob('pres*.json'):
        suffix = ''.join(word[:1].upper() + word[1:] for word in source.stem.split('_')[1:])
        changes[docs / ('PRES' + suffix + '.json')] = json.dumps(portable_pres(read_json(source)), ensure_ascii=False, indent=2)
    for path, content in changes.items():
        path.write_text(content.rstrip() + '\n', encoding='utf-8')
    print(json.dumps(dict(project=str(project), written=[path.relative_to(project).as_posix() for path in changes],
                         structures=len(schemas), functions=len(symbols.get('functions', [])), semantic_names=semantic_names(symbols),
                         graphics=len(gfx.get('assets', [])), screens=len(screens), assembly_executed=False), ensure_ascii=False))


if __name__ == '__main__':
    main()
