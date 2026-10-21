# СТРАНА МИФОВ / `MYTHLAND.TRD`

Оглавление документации — [Docs/README.md](Docs/README.md). Для чтения доступны [индекс функций](Docs/Functions.md), [индекс символов](Docs/Symbols.md) и [таблица сопоставления существ](Docs/UnitMatchups.md).

Восстановленные исходники дисковой версии

## Семантический проект

- Начните с [`Assets/Index.html`](Assets/Index.html), [`Docs/Structures.md`](Docs/Structures.md), [`Docs/Graphics.md`](Docs/Graphics.md) и [`Tools/Disasm/Reports/Symbols.tsv`](Tools/Disasm/Reports/Symbols.tsv)

| Путь / представление | Назначение |
| --- | --- |
| [`Source/Engine`](Source/Engine) | отдельные процедуры основного движка и `Include.inc` |
| [`Source/Battle`](Source/Battle) | отдельные процедуры боя и `Include.inc` |
| [`Source/Startup`](Source/Startup) | загрузка и начальные меню, процедуры и `Include.inc` |
| [`Source/Loader/Menu`](Source/Loader/Menu) | процедуры скрытого меню и редактора |
| [`Source/Overlays`](Source/Overlays) | тематические module для загружаемых оверлеев |
| [`Includes/Structs`](Includes/Structs) | struct/ends, именованные поля и размеры исходных записей |
| [`Includes/Address.inc`](Includes/Address.inc) | `EQU` существующих адресов, без нового размещения памяти |
| [`Assets`](Assets) | исходные raw-ресурсы и `PNG`-предпросмотр, индекс `Index.html` |
| [`Assets/Gfx`](Assets/Gfx) | спрайты, плоскости, шрифты, карты и материалы `PRES` |
| [`Assets/Screens`](Assets/Screens) | сцены, `SCR` и исходные `RLE`-потоки |
| [`Assets/Portraits`](Assets/Portraits) | портреты, их пиксели и атрибуты |

- В [`Structures.json`](Tools/Disasm/Reports/Structures.json) 59 типов структур и 311 полей, в [`Symbols.json`](Tools/Disasm/Reports/Symbols.json) 486 установленных входов
- Все 486 входов имеют смысловые имена, внутренние метки оформлены по областям процедур, правила — [Docs/Naming.md](Docs/Naming.md)
- [`GraphicsFormats.json`](Tools/Disasm/Reports/GraphicsFormats.json) описывает 246 элементов, [`ScreenAssets.json`](Tools/Disasm/Reports/ScreenAssets.json) — 27 экранов/портретов
- Сборка читает raw `.ink`/`.mask`/`.attr`/`.bin`/`.rle`/`.scr` по `INCBIN` в исходниках
- `PNG` и атласы предназначены для просмотра, их редактирование само по себе не меняет игру
- Синтаксис и образцы HoMM — [`Docs/HoMMConventions.md`](Docs/HoMMConventions.md), заставка — [`Tools/Disasm/Reports/PRESLayout.json`](Tools/Disasm/Reports/PRESLayout.json)

## Папка пользователя

- [корень проекта](.)

Начните с [`Docs/Architecture.md`](Docs/Architecture.md) и [`Docs/DataFormats.md`](Docs/DataFormats.md)
Рабочие данные и самомодификация — [Docs/Runtime.md](Docs/Runtime.md)
Таблицы генерации — [Docs/GenerationTables.md](Docs/GenerationTables.md)
Индекс процедур — [`Tools/Disasm/Reports/Functions.tsv`](Tools/Disasm/Reports/Functions.tsv)
Полные комментарии находятся непосредственно в `Source/**/*.asm`

## Состав

| Путь / представление | Назначение |
| --- | --- |
| [`Builder/Main.asm`](Builder/Main.asm) | единая точка сборки sjasmplus |
| [`.vscode/tasks.json`](.vscode/tasks.json) | прямой запуск sjasmplus по Ctrl+B |
| [`Source/Files`](Source/Files) | файлы каталога, код и исходные данные |
| [`Source/Loader`](Source/Loader) | открытые слои KB и скрытого меню CTPAHA |
| [`Source/Overlays`](Source/Overlays) | 22 отдельных оверлея с адресом исполнения `#B200` |
| [`Tools/Disasm`](Tools/Disasm) | помощники дизассемблирования и архив исследования |
| [`Tools/Disasm/Disk`](Tools/Disasm/Disk) | оригинал, каталог, хвосты секторов, каркас и ключи |
| [`Tools/Disasm/Extracted/Active`](Tools/Disasm/Extracted/Active) | 54 действующих файлов |
| [`Tools/Disasm/Extracted/Deleted`](Tools/Disasm/Extracted/Deleted) | 6 удалённых записей, имя первого символа не угадывается |
| [`Tools/Disasm/Reports`](Tools/Disasm/Reports) | машинные JSON/TSV-реестры и отчёты для инструментов |
| [`Tmp`](Tmp) | сохранённые листинг и символы проверочной сборки |
| [`Tools/Disasm/PROJECT_FILES.sha256`](Tools/Disasm/PROJECT_FILES.sha256) | реестр контрольных сумм файлов проекта |
| [`Docs`](Docs) | читаемые руководства, индексы и исторические материалы Markdown |
| [`Docs/Build.md`](Docs/Build.md) | описание сохранённой проверочной сборки |
| [`Tools/pack.lua`](Tools/pack.lua) | упаковка во встроенном Lua sjasmplus |
| [`Tools/Disasm/verify_static.py`](Tools/Disasm/verify_static.py) | проверка переписи байтов без ассемблера |
| [`MYTHLAND.trd`](MYTHLAND.trd) | готовый образ игры в корне проекта |

## Численные результаты текущей разметки

- Исходных блоков — 81, декодированных команд — 22242
- Процедур и дополнительных точек входа — 486
- Точек с предметными аннотациями алгоритма — 486
- Байтов исходных блоков по [`coverage.json`](Tools/Disasm/Reports/coverage.json) — 348741
- Размер исходного диска по [`manifest.json`](Tools/Disasm/Disk/manifest.json) — 655360 байтов

## Проверки и их область

- Итоговая сборка текущих исходников выполнена `2026-10-21T04:58:23.248096+00:00`, ошибок 0, предупреждений 0
- Все 7917 значений реестра совпали с символами sjasmplus
- `MYTHLAND.trd`, 655360 байт, побайтово совпал с исходным образом
- Отпечатки ASM/INC/Lua и исходных ресурсов соответствуют проверенному снимку
- Проверены именованные биты, явные нулевые смещения IX/IY, выравнивание комментариев и пустые строки после переходов
- Команда, журнал и контрольные суммы — [Docs/Build.md](Docs/Build.md) и [BuildVerification.json](Tools/Disasm/Reports/BuildVerification.json)
- Оригинал и сборка загрузились до меню в полном эмуляторе, экраны совпали побайтово, см. [проверку запуска](Docs/RuntimeVerification.md)
- Границы статического и игрового подтверждения — [Docs/VerificationLimits.md](Docs/VerificationLimits.md)

## Как собрать

В VS Code откройте корень проекта и нажмите `Ctrl+B`. Задача `Build` из [`.vscode/tasks.json`](.vscode/tasks.json) назначена задачей сборки по умолчанию и напрямую запускает локальный sjasmplus.

Из PowerShell в корне проекта:

```powershell
.\Tools\Sjasmplus\sjasmplus.exe --fullpath=rel --lst=Tmp/MYTHLAND.lst --sym=Tmp/MYTHLAND.sym Builder/Main.asm
```

- Ассемблер с Lua — [`Tools/Sjasmplus/sjasmplus.exe`](Tools/Sjasmplus/sjasmplus.exe)
- Результат — [`MYTHLAND.trd`](MYTHLAND.trd) в корне проекта
- Временные результаты сборки — [`Tmp/MYTHLAND.lst`](Tmp/MYTHLAND.lst) и [`Tmp/MYTHLAND.sym`](Tmp/MYTHLAND.sym)
- [`Builder/Main.asm`](Builder/Main.asm) вызывает `EMPTYTRD`, затем встроенный Lua пишет скомпилированные блоки по точным исходным смещениям и сравнивает весь результат с [`Tools/Disasm/Disk/original.trd`](Tools/Disasm/Disk/original.trd)
- При исходном неизменённом проекте сравнение обязано дать полное совпадение

## Редактирование

- Текущая упаковка намеренно фиксирует исходные длины, адреса и размещение
- `ASSERT` в каждом блоке останавливает сборку при изменении его длины
- CTPAHA должна оставаться третьей записью каталога, индекс 2 при отсчёте с 0
- Это положение и физическое размещение HELPG входят в защиту
- Ключи `XOR` рассчитаны для неизменённых команд дешифраторов и стандартного ПЗУ48
- Изменение самих дешифраторов требует нового анализа ключей
- Для осознанной модификации игры после проверенного восстановления можно изменить VerifyOriginal `EQU` 1 в [`Builder/Main.asm`](Builder/Main.asm) на0, отключив сравнение с оригиналом
- Контроль длин и защита от пересечений при этом продолжают действовать

## Лицензирование инструментов

- Для исследования использован `SkoolKit10.0` Richard Dymond, GPLv3
- [https://github.com/skoolkid/skoolkit/tree/10.0](https://github.com/skoolkid/skoolkit/tree/10.0)
- SkoolKit не требуется при сборке проекта и не встроен в игровой код
- Требования Lua и устройств сверены с документацией sjasmplus
- [https://z00m128.github.io/sjasmplus/documentation.html](https://z00m128.github.io/sjasmplus/documentation.html)

## Инструменты дизассемблирования

[`Tools/Disasm`](Tools/Disasm/README.md) содержит текущие помощники и архив исследования. Готовый образ записывается в [`MYTHLAND.trd`](MYTHLAND.trd) в корне проекта.
