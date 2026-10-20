# HoMM — проверенные соглашения для семантического слоя Strana

Дата проверки: 2026-10-20
Область: справка по прочитанным примерам HoMM и применённому семантическому оформлению Strana

## 1. Исходники примеров HoMM

Все пути ниже существуют и прочитаны в текущей проверке:

- [`../../HoMM/Includes/Structs/SpriteClipping.inc`](../../HoMM/Includes/Structs/SpriteClipping.inc) — `FSpriteInfo`, `FSpriteData`, `FSprite`, `FSpritesRef` и `FGraphicHeader`
- [`../../HoMM/Includes/Structs/SpriteNotClipping.inc`](../../HoMM/Includes/Structs/SpriteNotClipping.inc) — `FSpriteBlock` и побитная диаграмма флагов
- [`../../HoMM/Includes/Structs/Assets.inc`](../../HoMM/Includes/Structs/Assets.inc) — `FAssets`, вложенные структуры адреса и дискового расположения
- [`../../HoMM/Includes/Structs/Address.inc`](../../HoMM/Includes/Structs/Address.inc) — `FAddress`/`FLinearAddress` и вложенный доступ `Adr.Low`/`Adr.High`
- [`../../HoMM/Includes/Structs/Value.inc`](../../HoMM/Includes/Structs/Value.inc) — `FValue` с полями Low/High
- [`../../HoMM/Includes/Structs/Vector8.inc`](../../HoMM/Includes/Structs/Vector8.inc) — `FVector8` и `FVector8_YX`
- [`../../HoMM/Includes/Structs/Map/Object.inc`](../../HoMM/Includes/Structs/Map/Object.inc) — `FMapObject` и битовые диаграммы полей
- [`../../HoMM/Includes/Structs/Character/Character.inc`](../../HoMM/Includes/Structs/Character/Character.inc) — вложенные структуры `FCharacterSkills`/`FCharacterSettings`/`FCharacter`
- [`../../HoMM/Includes/Const/SpriteNotClipping.inc`](../../HoMM/Includes/Const/SpriteNotClipping.inc) — пары *_BIT и маска 1 << *_BIT
- [`../../HoMM/Includes/Const/Assets/Assets_Register.inc`](../../HoMM/Includes/Const/Assets/Assets_Register.inc) — последовательные ID через macro REG_ASSETS_ID и счётчик defl
- [`../../HoMM/Includes/Variables/Game_State.inc`](../../HoMM/Includes/Variables/Game_State.inc) — смысловые `EQU`-псевдонимы и вложенные смещения `FGameState`
- [`../../HoMM/Source/WorldTime/Include.inc`](../../HoMM/Source/WorldTime/Include.inc) — namespace module и сборка через `Include.inc`
- [`../../HoMM/Source/WorldTime/Tick.asm`](../../HoMM/Source/WorldTime/Tick.asm) — `In`/`Out`/`Corrupt`/`Note`, поля (`IX` + `FWorldTime.X`), смысловые .NextHour/.DayTable
- [`../../HoMM/Source/Modules/Inventory/Graphics/Include.inc`](../../HoMM/Source/Modules/Inventory/Graphics/Include.inc) — module Display и отдельные файлы рисования
- [`../../HoMM/Source/Modules/Inventory/Graphics/DrawNotClippingComposite.asm`](../../HoMM/Source/Modules/Inventory/Graphics/DrawNotClippingComposite.asm) — функциональное имя `Draw.NotClipping.Composite`, локальная .Loop и контракты
- [`../../HoMM/Builder/Assets/Graphics/Packing.inc`](../../HoMM/Builder/Assets/Graphics/Packing.inc) — иерархия Graphics и тематические `Include.inc`
- [`../../HoMM/Builder/Assets/Graphics/Original/Cursor/Include.inc`](../../HoMM/Builder/Assets/Graphics/Original/Cursor/Include.inc) — Begin, Size, отдельный `Pack.inc` и упаковка ресурса
- [`../../HoMM/Builder/Assets/Graphics/Original/Cursor/Pack.inc`](../../HoMM/Builder/Assets/Graphics/Original/Cursor/Pack.inc) — Graph/`Graph.Num`, Idle/Click, `Sprite._0`, incbin отдельных кадров
- [`../../HoMM/Builder/Assets/Graphics/Original/UI/Slots/Pack.inc`](../../HoMM/Builder/Assets/Graphics/Original/UI/Slots/Pack.inc) — именованные части графики и вычисление числа элементов ($-.Parts)/`FSprite`

`AGENTS.md` в ../../../.., [`../../..`](../../..), [`../..`](../..) и корне HoMM не найден, поиск `AGENTS.md` внутри HoMM также не дал файлов. Для данного аудита действуют правила, которые пользователь передал в чате. Наличие старых отклонений в примерах HoMM не отменяет их: некоторые длинные метки там стоят отдельно, а некоторые условные переходы не имеют правого комментария. В новых исходниках Strana такие места должны соответствовать прямым требованиям пользователя.

## 2. Что переносится в Strana

В текущем проекте типы называются `FTroop`/`FMapArmy`/`FCastle`/`FSoldier`/`FBattleUnit` и определяются через struct/ends. Поля именуются по доказанному назначению и используются как смещения, например (`IX` + `FTroop.Count.Low`). `DB`/`DW`/`DS` внутри определения структуры задают размер и значения по умолчанию, сама декларация не размещает новый объект в памяти. Существующие адреса игры не меняются.

Функции получают английские смысловые имена в тематических module, комментарии остаются русскими. Для коротких меток удобно `Army.TypeRecord`, `World.Map.Read`, `Scene.Show`, `Memory.SelectBank`. В файле внутри module достаточно короткой метки TypeRecord с комментарием от позиции 16. Адрес `#8036` сохраняется как происхождение в комментарии/карте символов, а не заменяет смысл имени. Локальные метки называются .Loop/.Next/.Done/.NoRecord по конкретной роли. Технические `F8036`/LC01E могут остаться как совместимые псевдонимы, но вызовы и основная навигация должны использовать смысловые символы.

Структуры описывают именно формат Strana. Восьмибайтовый `FSprite` HoMM и его макрос SPRITE нельзя вставлять перед исходными спрайтами Strana, у потребителей другой двоичный контракт. Переносится способ описания и имён, а не чужая структура данных.

В исходниках HoMM не найдено ни enum/endenum, ни собственного макроса с таким именем. Перечисления там представлены `EQU` и, для последовательной регистрации ресурсов, макросом со счётчиком defl. Ниже предлагается этот же проверенный синтаксис SjASMPlus. Дополнительный диалект enum не нужен.

## 3. Справочные примеры деклараций, без размещения новых данных

Ниже сохранены первоначальные примеры синтаксиса и соглашений. Имена `FValue`/`FArmyStack`/`FWorldArmy` в этих примерах учебные, фактические имена/поля проекта берите из [`Includes/Structs`](../Includes/Structs) и [`Docs/Structures.md`](Structures.md).

```asm
                ifndef _STRANA_STRUCTS_ARMY_
                define _STRANA_STRUCTS_ARMY_

                struct FValue                                                   ; беззнаковое слово little-endian
Low             DB #00                                                          ; младший байт значения
High            DB #00                                                          ; старший байт значения
                ends

                struct FVector8                                                 ; координаты клетки карты
X               DB #00                                                          ; столбец
Y               DB #00                                                          ; строка
                ends

                struct FArmyStack                                               ; запись исходной армии, три байта
Type            DB #00                                                          ; идентификатор типа, ноль завершает массив
Count           FValue                                                          ; численность отряда
                ends

                struct FWorldArmy                                               ; внешняя армия, 22 байта
Flags           DB #00                                                          ; занятость, задержка, проход и режим движения
Position        FVector8                                                        ; положение на стратегической карте
Reserve         FValue                                                          ; пополняемый запас, потребитель #A082
Recovery        FValue                                                          ; величина пополнения запаса
Stack0          FArmyStack                                                      ; первая запись состава
Stack1          FArmyStack                                                      ; вторая запись состава
Stack2          FArmyStack                                                      ; третья запись состава
Stack3          FArmyStack                                                      ; четвёртая запись состава
Stack4          FArmyStack                                                      ; пятая запись состава
                ends

                struct FTile32                                                  ; исходный тайл 32 на 32 с атрибутами
Pixels          DS 128, #00                                                     ; четыре группы по восемь строк, по четыре байта
Attrs           DS 16, #00                                                      ; четыре строки атрибутов по четыре байта
                ends

                struct FMasked32                                                ; маскированный кадр 32 на 32 без атрибутов
Pixels          DS 128, #00                                                     ; пиксельная плоскость кадра
Mask            DS 128, #00                                                     ; маска, точный порядок подтверждён потребителем
                ends

                struct FPicHeader                                               ; заголовок RLE-изображения BL1/BL2/HERIMG
NextOffset      DW #0000                                                        ; смещение следующей записи от второго байта ссылки
StartThird      DB #00                                                          ; первая треть экрана
Thirds          DB #03                                                          ; количество третей
Flags           DB #00                                                          ; порядок вывода и служебные биты распаковщика
                ends

                assert FArmyStack = 3
                assert FWorldArmy = 22
                assert FTile32 = 144
                assert FMasked32 = 256
                assert FPicHeader = 5
                endif

Пример FMasked32 описывает две плоскости после подтверждения их потребителем, он не разрешает применять этот формат ко всем файлам с именем SPR. Для конкретных ресурсов нужен отдельный диапазон/кадр в манифесте.
```

## 4. Идентификаторы, биты и псевдонимы

```asm
UNIT_NONE       EQU 0                                                           ; пустая запись отряда
UNIT_PEASANTS   EQU 1                                                           ; простолюдины
UNIT_SOLDIERS   EQU 2                                                           ; солдаты
UNIT_ARCHERS    EQU 3                                                           ; лучники
UNIT_DEMONS     EQU 25                                                          ; демоны

ARMY_FREE_BIT   EQU 0                                                           ; флаг, свободной записи армии
ARMY_DONE_BIT   EQU 4                                                           ; флаг, обработки записи в текущем проходе
ARMY_WATER_BIT  EQU 5                                                           ; флаг, водного режима группы
ARMY_FACING_BIT EQU 6                                                           ; флаг, горизонтальной ориентации группы
ARMY_FREE       EQU 1 << ARMY_FREE_BIT
ARMY_DONE       EQU 1 << ARMY_DONE_BIT
ARMY_DELAY      EQU #0E                                                         ; три бита задержки внешней армии

                module SceneID
Castle          EQU 1                                                           ; сцена собственного замка
Shipyard        EQU 2                                                           ; сцена покупки корабля
Friendly        EQU 4                                                           ; доброжелательная встреча
Hostile         EQU 5                                                           ; враждебная встреча
                endmodule

                module Army
TypeRecord      EQU #8036                                                       ; получить IX описателя SOLDIERS по A
Compact         EQU #807E                                                       ; уплотнить массив трёхбайтовых записей
                endmodule

                module World
                module Map
SelectBank      EQU #80AE                                                       ; выбрать логический банк текущей карты
Address         EQU #80B4                                                       ; вычислить адрес клетки по BC
Read            EQU #80C4                                                       ; прочитать клетку с восстановлением банка
                endmodule
                endmodule

                module Scene
Show            EQU #8801                                                       ; вывести одну из девяти упакованных сцен
                endmodule

HeroArmy        EQU #6A1E                                                       ; исходные пять троек армии героя
CurrentMap      EQU #6A2D                                                       ; текущий континент

Показанные EQU связывают имена с уже существующими адресами, они не выбирают новое размещение. При внедрении в исходники процедуры могут получить такие имена непосредственно вместо F8036. Имена и байты с неустановленной семантикой сохраняют нейтральное UnknownXX или RawXX с точным смещением, не получают догадочное игровое имя.
```

## 5. Фактическая файловая раскладка

- [`Source/Engine/Include.inc`](../Source/Engine/Include.inc) и отдельные файлы процедур ядра
- [`Source/Battle/Include.inc`](../Source/Battle/Include.inc) и отдельные файлы боевых процедур
- [`Source/Startup/Include.inc`](../Source/Startup/Include.inc) и отдельные файлы начального интерфейса
- [`Source/Loader/Menu/Include.inc`](../Source/Loader/Menu/Include.inc) и отдельные файлы скрытого меню/редактора
- `Source/Overlays/Capture.asm..22.asm`, тематические module с общим runtime `#B200`
- `Source/Files/*.asm`, точки подключения исходных файлов каталога и смешанных код/данные
- [`Includes/Structs/Include.inc`](../Includes/Structs/Include.inc), `Includes/Structs/*.inc`, [`Includes/Address.inc`](../Includes/Address.inc)
- [`Assets/Gfx`](../Assets/Gfx), [`Assets/Screens`](../Assets/Screens), [`Assets/Portraits`](../Assets/Portraits), raw-плоскости и потоки по конкретным `INCBIN`
- [`Assets/Gfx/PRES`](../Assets/Gfx/PRES), исходный `SCR`, собственный шрифт и сценарии заставки
- [`Assets/Index.html`](../Assets/Index.html), `PNG`/атласы/карты для просмотра
- [`Tools/Disasm/Reports/Symbols.tsv`](../Tools/Disasm/Reports/Symbols.tsv), старый адрес, смысловой либо технический символ, фактический файл и строка
- [`Tools/Disasm/Reports/GraphicsFormats.json`](../Tools/Disasm/Reports/GraphicsFormats.json) и [`ScreenAssets.json`](../Tools/Disasm/Reports/ScreenAssets.json), слот, диапазон, формат и пути графики
- [`Tools/Disasm/Reports/Structures.json`](../Tools/Disasm/Reports/Structures.json) и [`Structures.md`](Structures.md), поля, размеры, смещения, значения битов и потребители

- Сборка читает raw `INCBIN`. `PNG` не преобразуются обратно автоматически. Размеры, адреса и порядок исходных файлов сохраняются.

## 6. Актуальные реестры форматов

Все 486 установленных входов имеют смысловые имена, правила локальных областей и комментариев описаны в [Naming.md](Naming.md).
Графика, 246 элементов [`GraphicsFormats.json`](../Tools/Disasm/Reports/GraphicsFormats.json), 27 записей [`ScreenAssets.json`](../Tools/Disasm/Reports/ScreenAssets.json) с пересечением диапазонов.
`PRES`, runtime `#C000`, 18 функций, 1182 байтов кода, точные диапазоны в [`PRESLayout.json`](../Tools/Disasm/Reports/PRESLayout.json).
[`PRESAnnotations.json`](../Tools/Disasm/Reports/PRESAnnotations.json) описывает алгоритмы заставки, [`Graphics.md`](Graphics.md) указывает raw/`PNG` и плоскости.
`STROENIA` содержит начальные записи мира, их схемы `FMapList`/`FMapArmy`/`FMapTroop`/`FCastle`/`FMapItem`/`FTemple`/`FTown` описаны в [`Structures.md`](Structures.md).
`SOLDIERS` описывает `FSoldier`, бой — `FBattleUnit`. Поле `FBattleUnit.Affinity` установлено потребителями и не является Unknown01.
`PERSON`/PERSON7 и их фазовое преобразование описаны в `FPerson`/`FPerson7`/`FGameState`, прежние предварительные оговорки заменены реестром полей.
Полная актуальная схема

| тип | байтов | назначение |
| --- | --- | --- |
| `FTroop` | 3 | исходная стратегическая запись отряда |
| `FMapList` | 4 | дескриптор списка объектов одного континента |
| `FMoveStep` | 3 | рабочий кандидат перемещения внешнего объекта |
| `FMapArmy` | 22 | подвижная армия разбойников либо пиратов |
| `FMapTroop` | 6 | шестибайтовая группа существ на стратегической карте |
| `FCastle` | 35 | 35-байтная запись замка |
| `FMapItem` | 3 | трёхбайтовая находка, не `FTroop` несмотря на одинаковую длину |
| `FTemple` | 5 | запись храма духов |
| `FTown` | 26 | 26-байтная запись города |
| `FRuler` | 28 | описатель правителя в `DATA1` |
| `FSpell` | 23 | описатель заклинания в `DATA1` |
| `FPerson` | 245 | персональная часть состояния, имя и игровые поля. Совпадает с245байтными PERSON1..6/8 после загрузки |
| `FGameState` | 256 | полный256байтный заголовок состояния, включает героя и глобальные события |
| `FByteRange` | 2 | пара диапазона коэффициента PERSON7 |
| `FPerson7` | 270 | дисковый вариант PERSON7 до нормализации,270байт. Нельзя усекать как обычный `PERSON` без выполнения алгоритма |
| `FSoldier` | 42 | описатель типа существа, `SOLDIERS`, 25 записей |
| `FBattleUnit` | 18 | рабочий отряд боя, две армии по 5 записей |
| `FMenuRect` | 4 | прямоугольник пункта меню в знакоместах |
| `FMenuHeader` | 7 | фиксированная часть меню, далее N записей `FMenuRect` |
| `FTile32` | 144 | непрозрачный тайл или портрет 32 на 32 пикселя |
| `FMasked32` | 256 | маскированный кадр 32 на 32 пикселя |
| `FPictureHeader` | 5 | заголовок `RLE`-изображения HERIMG, `BL1` и `BL2` |
| `FFrameRef` | 3 | ссылка на кадр в расширенной памяти |
| `FScreenObject20` | 20 |  |

## 7. Связь формы с исходными байтами

Ресурс имеет raw/маску/атрибуты согласно формату и `PNG`-просмотр с размерами, кадрами и исходным диапазоном.
Структура содержит размер, смещение, назначение либо `Unknown` и доказанного потребителя для каждого поля.
Смысловые имена используются в операндах исходников, адресное происхождение сохраняется в [`Symbols.tsv`](../Tools/Disasm/Reports/Symbols.tsv).
Имена и разбиение не меняют исходные адреса, длины, фазовые наложения памяти и порядок сборки TRD.
Файлы HoMM использованы как справочные образцы. Результат сборки Strana и границы проверки находятся в [`BuildVerification.json`](../Tools/Disasm/Reports/BuildVerification.json) и [`VerificationLimits.md`](VerificationLimits.md).
