"""Разнести четыре уже переименованных модуля по файлам процедур.

Запускать после semantic_transform.py. Скрипт не ассемблирует проект.
Границы берутся только из Docs/functions.json и исходных заголовков функций.
Данные между двумя точками входа остаются в предшествующем файле процедуры.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re


WORK = Path(__file__).resolve().parent
DEFAULT_ROOT = WORK.parent / 'outputs/MYTHLAND'
TARGETS = {
    'S10': 'Source/Engine',
    'S47': 'Source/Battle',
    'S04': 'Source/Startup',
    'CTPM': 'Source/Loader/Menu',
}
SEPARATOR = re.compile(r'^;\s*-{3,}\s*$')
NAME = re.compile(r'[A-Za-z_][A-Za-z0-9_]{0,14}\Z')
INCLUDE = re.compile(r'^\s*include\s+"([^"]+)"\s*(?:;.*)?$', re.IGNORECASE)
WINDOWS_RESERVED = {'CON', 'PRN', 'AUX', 'NUL',
                    *(f'COM{i}' for i in range(1, 10)),
                    *(f'LPT{i}' for i in range(1, 10))}


def read_text(path: Path) -> str:
    # Чтение без преобразования CRLF сохраняет исходный текст процедур точно.
    return path.read_bytes().decode('utf-8')


def command(line: str) -> str:
    return line.partition(';')[0].strip()


def label(line: str) -> str | None:
    if not line or line[0].isspace() or line.startswith(';'):
        return None
    return line[:16].strip()


def function_name(fn: dict) -> str:
    symbol = fn.get('symbol')
    if not isinstance(symbol, str) or '.' not in symbol:
        raise ValueError(f"{fn['block']}:{fn['address']:04X}: нет нового fn.symbol, сначала semantic_transform.py")
    name = symbol.rsplit('.', 1)[1]
    if not NAME.fullmatch(name) or name.upper() in WINDOWS_RESERVED:
        raise ValueError(f'недопустимое имя файла процедуры {symbol!r}, нужно имя не длиннее15символов')
    return name


def header_start(lines: list[str], entry_line: int, minimum: int) -> int:
    """Найти заголовок перед меткой и комментариями к первой операции."""
    closing = entry_line - 1
    while closing >= minimum:
        text = lines[closing].strip()
        if SEPARATOR.fullmatch(text):
            break
        if text and not text.startswith(';'):
            raise ValueError(f'у строки{entry_line + 1} отсутствует закрывающий разделитель заголовка')
        closing -= 1
    if closing < minimum or not SEPARATOR.fullmatch(lines[closing].strip()):
        raise ValueError(f'у строки{entry_line + 1} отсутствует закрывающий разделитель заголовка')
    opening = closing - 1
    while opening >= minimum:
        text = lines[opening].strip()
        if SEPARATOR.fullmatch(text):
            while opening > minimum and not lines[opening - 1].strip():
                opening -= 1
            return opening
        if text and not text.startswith(';'):
            break
        opening -= 1
    raise ValueError(f'у строки{entry_line + 1} отсутствует открывающий разделитель заголовка')


def include_line(path: str, newline: str) -> str:
    return ' ' * 16 + f'include "{path}"' + newline


def plan_module(block: dict, functions: list[dict], text: str,
                folder: str) -> tuple[dict[str, str], list[dict], dict]:
    """Подготовить точную текстовую перестановку, не записывая файлов."""
    ident, umbrella = block['block'], block['source']
    lines = text.splitlines(keepends=True)
    newline = '\r\n' if '\r\n' in text else '\n'
    module_lines = [index for index, line in enumerate(lines)
                    if re.match(r'^module\s+', command(line), re.IGNORECASE)]
    endmodule_lines = [index for index, line in enumerate(lines)
                       if command(line).lower() == 'endmodule']
    if not module_lines or len(module_lines) != len(endmodule_lines):
        raise ValueError(f'{umbrella}: число вложенных module и endmodule не совпадает')
    module_index = module_lines[0]
    first_endmodule_index, endmodule_index = endmodule_lines[0], endmodule_lines[-1]
    module_parts = [command(lines[index]).split(None, 1)[1] for index in module_lines]
    if any(not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*', part) for part in module_parts):
        raise ValueError(f'{umbrella}: каждая директива module должна содержать одно имя без точек')
    module_name = '.'.join(module_parts)
    org_lines = [index for index, line in enumerate(lines)
                if re.match(r'^org\s+', command(line), re.IGNORECASE)]
    if len(org_lines) != 1 or not module_lines[-1] < org_lines[0] < first_endmodule_index:
        raise ValueError(f'{umbrella}: ожидается один исходный org после вложенных module и до endmodule')
    if any(command(line).lower() != 'endmodule' and command(line)
           for line in lines[first_endmodule_index:endmodule_index + 1]):
        raise ValueError(f'{umbrella}: закрывающие endmodule должны находиться в общем хвосте')
    final_asserts = [index for index, line in enumerate(lines[:first_endmodule_index])
                    if re.match(r'^assert\s+\$\s*=', command(line), re.IGNORECASE)]
    if not final_asserts:
        raise ValueError(f'{umbrella}: не найден заключительный assert $')
    footer_start = final_asserts[-1]
    while footer_start > org_lines[0] and not lines[footer_start - 1].strip():
        footer_start -= 1
    for line in lines[footer_start:first_endmodule_index]:
        code = command(line)
        if code and not re.match(r'^assert\b', code, re.IGNORECASE):
            raise ValueError(f'{umbrella}: код между заключительным assert и endmodule')
    if any(command(line) for line in lines[endmodule_index + 1:]):
        raise ValueError(f'{umbrella}: код после endmodule')

    # Проверка явных точек входа исключает выбор границ по эвристике RET или адресу.
    positioned = []
    names = set()
    for fn in functions:
        name = function_name(fn)
        if fn['symbol'].rsplit('.', 1)[0] != module_name:
            raise ValueError(f"{fn['symbol']}: namespace не совпадает с module {module_name}")
        if name.casefold() in names:
            raise ValueError(f'{umbrella}: имена процедур совпадают без учёта регистра, {name}')
        names.add(name.casefold())
        candidates = [index for index, line in enumerate(lines) if label(line) == name]
        if len(candidates) != 1:
            raise ValueError(f'{umbrella}: метка {name} встречается{len(candidates)}раз')
        entry_index = candidates[0]
        if fn.get('line') != entry_index + 1:
            raise ValueError(f'{umbrella}: устаревший номер строки для {name}, сначала semantic_transform.py')
        if fn['source'] != umbrella:
            raise ValueError(f"{fn['symbol']}: исходный путь уже изменён, {fn['source']}")
        if not org_lines[0] < entry_index < footer_start:
            raise ValueError(f'{umbrella}: точка входа {name} вне тела модуля')
        start = header_start(lines, entry_index, org_lines[0] + 1)
        positioned.append((start, entry_index, fn, name))
    positioned.sort(key=lambda item: item[0])
    if not positioned:
        raise ValueError(f'{umbrella}: в functions.json нет точек входа')
    for current, following in zip(positioned, positioned[1:]):
        if following[0] <= current[1]:
            raise ValueError(f'{umbrella}: пересечение заголовков соседних процедур')

    # Создание Include.inc сохраняет исходные module/org, начало и хвост модуля.
    generated = {}
    updates = []
    include_parts = [''.join(lines[module_index:positioned[0][0]])]
    for index, (start, entry_index, fn, name) in enumerate(positioned):
        end = positioned[index + 1][0] if index + 1 < len(positioned) else footer_start
        path = f'{folder}/{name}.asm'
        part = lines[start:end]
        if not part:
            raise ValueError(f'{umbrella}: пустой файл процедуры {name}')
        generated[path] = ''.join(part)
        include_parts.append(include_line(path, newline))
        updates.append(dict(block=ident, address=fn['address'], symbol=fn['symbol'],
                            source=path, line=entry_index - start + 1))
    include_parts.append(''.join(lines[footer_start:]))
    include_path = folder + '/Include.inc'
    generated[include_path] = ''.join(include_parts)
    generated[umbrella] = ''.join(lines[:module_index]) + include_line(include_path, newline)

    # Проверка неизменности всего исходного текста при раскрытии новых include.
    def expand_generated(path: str, stack: tuple[str, ...] = ()) -> str:
        if path in stack:
            raise ValueError(f'{umbrella}: циклический include, {path}')
        expanded = []
        for line in generated[path].splitlines(keepends=True):
            match = INCLUDE.fullmatch(line.rstrip('\r\n'))
            target = match[1] if match else None
            expanded.append(expand_generated(target, stack + (path,))
                            if target in generated else line)
        return ''.join(expanded)

    flattened = expand_generated(umbrella)
    if flattened != text:
        raise AssertionError(f'{umbrella}: потерян или переставлен исходный текст')
    for update in updates:
        if label(generated[update['source']].splitlines()[update['line'] - 1]) != function_name(update):
            raise AssertionError(f"{update['symbol']}: неверный новый номер строки")
    return generated, updates, dict(block=ident, umbrella=umbrella, include=include_path,
                                    module=module_name, functions=len(updates),
                                    source_text_sha256=hashlib.sha256(text.encode('utf-8')).hexdigest(),
                                    expanded_text_identical=True)


def json_text(data: object) -> str:
    return json.dumps(data, ensure_ascii=False, indent=2) + '\n'


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, default=DEFAULT_ROOT)
    parser.add_argument('--check', action='store_true', help='подготовить и проверить план без записи файлов')
    parser.add_argument('--overwrite', action='store_true', help='заменять отличающиеся файлы ранее созданных процедур')
    args = parser.parse_args()
    root = args.root.resolve()
    coverage = json.loads(read_text(root / 'Docs/coverage.json'))
    functions = json.loads(read_text(root / 'Docs/functions.json'))
    symbols = json.loads(read_text(root / 'Docs/Symbols.json'))
    blocks = {block['block']: block for block in coverage}
    changes, updates, reports = {}, {}, []
    coverage_before = (root / 'Docs/coverage.json').read_bytes()
    for ident, folder in TARGETS.items():
        if ident not in blocks:
            raise ValueError(f'coverage.json не содержит {ident}')
        block = blocks[ident]
        selected = [fn for fn in functions if fn['block'] == ident]
        generated, moved, report = plan_module(block, selected, read_text(root / block['source']), folder)
        if set(changes).intersection(generated):
            raise ValueError(f'{ident}: пересечение путей выходных файлов')
        changes.update(generated)
        for item in moved:
            key = item['block'], item['address']
            if key in updates:
                raise ValueError(f'повторная точка входа {key}')
            updates[key] = item
        reports.append(report)

    # Обновление только путей и строк функций, остальные метаданные сохраняются.
    for fn in functions:
        item = updates.get((fn['block'], fn['address']))
        if item:
            fn['source'], fn['line'] = item['source'], item['line']
    symbol_keys = set()
    for fn in symbols['functions']:
        key = fn['block'], fn['address']
        item = updates.get(key)
        if item:
            if fn['symbol'] != item['symbol']:
                raise ValueError(f'{key}: functions.json и Symbols.json расходятся по symbol')
            if key in symbol_keys:
                raise ValueError(f'{key}: повтор в Symbols.json')
            symbol_keys.add(key)
            fn['source'], fn['line'] = item['source'], item['line']
    if symbol_keys != set(updates):
        raise ValueError('не все перемещённые функции представлены в Symbols.json')
    changes['Docs/functions.json'] = json_text(functions)
    changes['Docs/Symbols.json'] = json_text(symbols)

    # Проверка всех назначений до первой записи исключает частичное выполнение плана.
    umbrellas = {blocks[ident]['source'] for ident in TARGETS}
    existing_replaced = umbrellas | {'Docs/functions.json', 'Docs/Symbols.json'}
    for relative, content in changes.items():
        path = root / relative
        if not path.resolve().is_relative_to(root):
            raise ValueError(f'путь выходит за пределы проекта, {relative}')
        if path.exists() and relative not in existing_replaced and read_text(path) != content and not args.overwrite:
            raise FileExistsError(f'{relative} уже существует и отличается, для сознательной регенерации нужен --overwrite')
    if not args.check:
        for relative, content in changes.items():
            path = root / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(content.encode('utf-8'))
    assert (root / 'Docs/coverage.json').read_bytes() == coverage_before
    print(json.dumps(dict(check_only=args.check, modules=reports, functions=len(updates),
                          changed_files=0 if args.check else len(changes),
                          coverage_source_unchanged=True), ensure_ascii=False))


if __name__ == '__main__':
    main()
