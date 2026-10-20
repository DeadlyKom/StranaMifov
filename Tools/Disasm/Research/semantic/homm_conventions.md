# HoMM — проверенные соглашения для семантического слоя Strana

Дата проверки: 2026-10-20
Область: только чтение HoMM, разбор существующих форматов Strana и предложение оформления

## 1. Исходники примеров HoMM


Все пути ниже существуют и прочитаны в текущей проверке:
- [../../../../../HoMM/Includes/Structs/SpriteClipping.inc](../../../../../HoMM/Includes/Structs/SpriteClipping.inc) — FSpriteInfo, FSpriteData, FSprite, FSpritesRef и FGraphicHeader
- [../../../../../HoMM/Includes/Structs/SpriteNotClipping.inc](../../../../../HoMM/Includes/Structs/SpriteNotClipping.inc) — FSpriteBlock и побитная диаграмма флагов
- [../../../../../HoMM/Includes/Structs/Assets.inc](../../../../../HoMM/Includes/Structs/Assets.inc) — FAssets, вложенные структуры адреса и дискового расположения
- [../../../../../HoMM/Includes/Structs/Address.inc](../../../../../HoMM/Includes/Structs/Address.inc) — FAddress/FLinearAddress и вложенный доступ Adr.Low/Adr.High
- [../../../../../HoMM/Includes/Structs/Value.inc](../../../../../HoMM/Includes/Structs/Value.inc) — FValue с полями Low/High
- [../../../../../HoMM/Includes/Structs/Vector8.inc](../../../../../HoMM/Includes/Structs/Vector8.inc) — FVector8 и FVector8_YX
- [../../../../../HoMM/Includes/Structs/Map/Object.inc](../../../../../HoMM/Includes/Structs/Map/Object.inc) — FMapObject и битовые диаграммы полей
- [../../../../../HoMM/Includes/Structs/Character/Character.inc](../../../../../HoMM/Includes/Structs/Character/Character.inc) — вложенные структуры FCharacterSkills/FCharacterSettings/FCharacter
- [../../../../../HoMM/Includes/Const/SpriteNotClipping.inc](../../../../../HoMM/Includes/Const/SpriteNotClipping.inc) — пары *_BIT и маска 1 << *_BIT
- [../../../../../HoMM/Includes/Const/Assets/Assets_Register.inc](../../../../../HoMM/Includes/Const/Assets/Assets_Register.inc) — последовательные ID через macro REG_ASSETS_ID и счётчик defl
- [../../../../../HoMM/Includes/Variables/Game_State.inc](../../../../../HoMM/Includes/Variables/Game_State.inc) — смысловые EQU-псевдонимы и вложенные смещения FGameState
- [../../../../../HoMM/Source/WorldTime/Include.inc](../../../../../HoMM/Source/WorldTime/Include.inc) — namespace module и сборка через Include.inc
- [../../../../../HoMM/Source/WorldTime/Tick.asm](../../../../../HoMM/Source/WorldTime/Tick.asm) — In/Out/Corrupt/Note, поля (IX + FWorldTime.X), смысловые .NextHour/.DayTable
- [../../../../../HoMM/Source/Modules/Inventory/Graphics/Include.inc](../../../../../HoMM/Source/Modules/Inventory/Graphics/Include.inc) — module Display и отдельные файлы рисования
- [../../../../../HoMM/Source/Modules/Inventory/Graphics/DrawNotClippingComposite.asm](../../../../../HoMM/Source/Modules/Inventory/Graphics/DrawNotClippingComposite.asm) — функциональное имя Draw.NotClipping.Composite, локальная .Loop и контракты
- [../../../../../HoMM/Builder/Assets/Graphics/Packing.inc](../../../../../HoMM/Builder/Assets/Graphics/Packing.inc) — иерархия Graphics и тематические Include.inc
- [../../../../../HoMM/Builder/Assets/Graphics/Original/Cursor/Include.inc](../../../../../HoMM/Builder/Assets/Graphics/Original/Cursor/Include.inc) — Begin, Size, отдельный Pack.inc и упаковка ресурса
- [../../../../../HoMM/Builder/Assets/Graphics/Original/Cursor/Pack.inc](../../../../../HoMM/Builder/Assets/Graphics/Original/Cursor/Pack.inc) — Graph/Graph.Num, Idle/Click, Sprite._0, incbin отдельных кадров
- [../../../../../HoMM/Builder/Assets/Graphics/Original/UI/Slots/Pack.inc](../../../../../HoMM/Builder/Assets/Graphics/Original/UI/Slots/Pack.inc) — именованные части графики и вычисление числа элементов ($-.Parts)/FSprite

AGENTS.md в [../../../../../../..](../../../../../../..), [../../../../../..](../../../../../..), [../../../../..](../../../../..) и корне HoMM не найден, поиск AGENTS.md внутри HoMM также не дал файлов. Для данного аудита действуют правила, которые пользователь передал в чате. Наличие старых отклонений в примерах HoMM не отменяет их: некоторые длинные метки там стоят отдельно, а некоторые условные переходы не имеют правого комментария. В новых исходниках Strana такие места должны соответствовать прямым требованиям пользователя.

## 2. Что переносится в Strana


Типы называются FArmyStack/FCastle/FSoldierType и определяются через struct/ends. Поля именуются по доказанному назначению и используются как смещения, например (IX + FArmyStack.Count.Low). DB/DW/DS внутри определения структуры задают размер и значения по умолчанию, сама декларация не размещает новый объект в памяти. Существующие адреса игры не меняются.

Функции получают английские смысловые имена в тематических module, комментарии остаются русскими. Для коротких меток удобно Army.TypeRecord, World.Map.Read, Scene.Show, Memory.SelectBank. В файле внутри module достаточно короткой метки TypeRecord с комментарием от позиции 16. Адрес #8036 сохраняется как происхождение в комментарии/карте символов, а не заменяет смысл имени. Локальные метки называются .Loop/.Next/.Done/.NoRecord по конкретной роли. Технические F8036/LC01E могут остаться как совместимые псевдонимы, но вызовы и основная навигация должны использовать смысловые символы.

Структуры описывают именно формат Strana. Восьмибайтовый FSprite HoMM и его макрос SPRITE нельзя вставлять перед исходными спрайтами Strana, у потребителей другой двоичный контракт. Переносится способ описания и имён, а не чужая структура данных.

В исходниках HoMM не найдено ни enum/endenum, ни собственного макроса с таким именем. Перечисления там представлены EQU и, для последовательной регистрации ресурсов, макросом со счётчиком defl. Ниже предлагается этот же проверенный синтаксис SjASMPlus. Дополнительный диалект enum не нужен.

## 3. Точные примеры деклараций, без размещения новых данных


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

## 5. Предлагаемая файловая раскладка


Includes/Structs/Include.inc, Army.inc, Soldier.inc, Castle.inc, Battle.inc, Graphics.inc, Disk.inc
Includes/Const/Include.inc, Unit.inc, Scene.inc, Map.inc, Object.inc, Battle.inc
Includes/Variables/Include.inc, Hero.inc, World.inc, Graphics.inc, Battle.inc
Source/Engine/Army/TypeRecord.asm, Compact.asm, Include.inc
Source/Engine/World/Map/Address.asm, Read.asm, Include.inc
Source/Engine/Graphics/Tile.asm, Masked.asm, Scene.asm, Include.inc
Source/Battle/Include.inc и отдельные файлы боевых процедур
Source/Startup/Include.inc и отдельные файлы загрузки и начального меню
Source/Overlays/Map/Include.inc и отдельные файлы процедур по назначению
Assets/Gfx/Tiles/SPR1/*.bin + *.png + Atlas.png
Assets/Gfx/Units/<UnitName>/Frame0.bin..Frame3.bin + Frame0.png..Frame3.png
Assets/Gfx/Portraits/Person1.bin..Person8.bin + PNG
Assets/Gfx/Scenes/BL1/Scene01.raw/.scr/.png и BL2, HERIMG
Assets/Gfx/Font/GlyphXX.bin/.png + Atlas.png
Assets/Maps/KARTA1.raw/.png..KARTA4.raw/.png
Assets/Tables/Soldiers.inc, Persons.inc, Castles.inc и исходные двоичные части
Docs/Symbols.tsv — старое имя, адрес, файл, новое смысловое имя, доказательство
Docs/Graphics.json — слот TRD, смещение, длина, формат, размеры, маска, атрибуты, кадры, потребитель, PNG/raw-файл
Docs/Structures.json — поля, размеры, смещения, значения битов, читатели и писатели

Это схема семантического слоя, не команда сейчас перемещать файлы или менять адреса. Байтовый порядок сборки остаётся исходным. Source/Files/*.asm может оставаться точкой сборки исходного TRD-файла и включать логические части в прежнем порядке. Извлечённый PNG — видимое представление, raw и маска нужны для точного восстановления. Секторные хвосты, данные распаковщиков и неприменённые метаданные сохраняются отдельно. Для каждого кадра в манифесте должна быть обратная связь с точными исходными байтами.

## 6. Подтверждённая ресурсная матрица Strana


Сверено по текущим Docs/DataFormats.txt, GlobalState.json, BattleRecord.json, EngineAnnotations.json и реальным потребителям. Старые вводные абзацы DataFormats.txt местами осторожнее поздних дополнений, поэтому приоритет имеют конкретные потребители и более поздние доказанные поля.

- IP1..IP8, слоты 36..43 — по 144 байта, портрет 32x32, 128 пиксельных байтов и 16 атрибутов. Потребители head #63A1..#63AF и #957C..#9599 -> #7545. Пиксельный адрес y*4+floor(x/8), атрибут 128+floor(y/8)*4+floor(x/8)
- SPR1, слот 35 — первые 57 тайлов по 144 байта. Индексы 0..40 используются картами KARTA через #8359..#8378, база банк 4:#C000+144*(cell AND #3F), бит 6 карты задаёт горизонтальное отражение. Затем +#2010..+#2C0F три анимации героя по 1024 байта, +#2C10/+#2D10 два кадра по 256, +#2E10/+#2EA0 два тайла по 144. Последний тайл закрывает фрагмент карты, у предпоследнего пока нет явного потребителя
- SPR2, слот 44 — сначала 25 обычных и 21 специальный тайл по 144 байта, затем 288 нулевых байтов до +#1B00. От +#1B00 находятся ID 1..9 существ, по 1024 байта, четыре 256-байтовых кадра 32x32 без атрибутов, 128 пикселей+128 маски. SPR3, слот 45 — ID 10..25 с начала файла, по 1024 байта. Потребители #80DB, #7366, #825B. Полная разбивка и raw/PNG уже находятся в work/semantic/graphics_formats.json и graphics/
- HERIMG, слот 8, BL1/BL2, слоты 33/34 — общий самоперемещаемый распаковщик с RLE-данными. Код +0..1 и +6..#112, параметры +2..5, данные с +#113, первая запись картинки с +#12C. Заголовок 5 байтов, следующая запись offset+1+word(offset), ненулевой байт литерал, ноль открывает длину/значение RLE. Выход — экран #4000..#5AFF. BL1 содержит пять картинок в банке 14, BL2 четыре в банке 15, head #8801 выбирает входы 1..9
- STROENIA, слот 19 — исходные записи объектов мира. Это не подтверждённый графический пакет, полную схему оформляет main_code
- DATA1, слот 46 — 3643 байта, банк 3:#C41A. Враги ID 1..15 с #CCCB, шаг 28, потребитель #804E. Заклинания ID 1..10 с #CE6F, шаг 23, потребитель #8066. Хвост #CF55..#D254 содержит маскированную атаку 256 байтов и четыре OR-кадра по 128, подтверждён модулем bitwa
- DATA2, слот 7 — первые 1792 байта содержат 224 глифа с кодами 32..255, по 8 байтов на глиф. Бит 7 слева, шаг текста 6 пикселей, все 8 бит строки в графике сохраняются. Остальные рамки и курсоры также экспортированы по манифесту graphics_formats.json
- PRES, слот 6, 11295 байтов — подтверждён смешанный файл с runtime-базой #C000. +0..#1AFF исходный SCR 6912 байта, +#1B00..#21FF шрифт 224 глифа 8x8, код с +#2200 по runtime #E200. Полностью разобраны 18 функций, 689 инструкций, 1182 байта кода в трёх диапазонах. Другие части содержат титры, страницы предыстории, состояние RNG и сто пар координат звёзд. Экспорт SCR/PNG, font BIN/PNG и 224 глифа готов в work/semantic/graphics/PRES, сведения — pres_layout.json и pres_annotations.json
- BAD, слот 50, 6912 байтов — размер экранного образа Spectrum, окончательную привязку и экспорт делает root
- KARTA1..4, слоты 28..31 — каждый 16100 байтов, 161 столбец*100 строк. Биты 0..5 индекс ландшафта, бит 6 отражение, бит 7 занятость. Отдельная маска открытия в банке 11 — четыре поля по 2100 байтов, 100 строк по 21 байту, бит 7-(x AND 7). Потребители #80B4 и #B48E оверлея 13. Terrain PNG 5152x3200 и уменьшенные обзоры извлечены trd_sjasm
- SOLDIERS, слот 21 — 25 описателей по 42 байта, рабочая база банк 3:#C000, #8036 даёт IX=#BFD6+42*ID. Десятичные смещения: имя +0..11, терминатор +12, флаги +13/+14, запас действий +15, расходуемый счётчик +16, поле цены/взвешенной силы +22/+23, порог развития +40, дни деградации +41. Остальные поля требуют индивидуальных потребителей

```asm
- FArmyStack — ID+16-битное количество, 3 байта, пять слотов от #6A1E. FWorldArmy — flags +0, x +1, y +2, пополняемый запас +3/+4, пополнение +5/+6, пять троек с +7, всего 22 байта. Потребители #8DDA и #A082
- FCastle — 35 байтов, flags +0, x +1, y +2, имя 15 байтов +3..17, терминатор +18, владелец +19, пять троек гарнизона +20..34. Таблица 80 записей, банк 0:#C000. #867B указывает на имя, то есть запись+3. Потребители #87D1 и O17/O21
- FBattleStack — 18 байтов, ID +0, Unknown01, ROMFloat5 +2..6, базовые действия +7, расходуемый счётчик +8, flags +9, x +10/y +11, действия раунда +12, эффект +13, исходное число +14/+15, Unknown16/17. Неизвестные поля не получают имён HP или Damage без потребителя
```

- PERSON1..8 — исходные длины 245, PERSON7 имеет длину 270. BL3 загружает по #793C, состояние переносится в head как 256 байтов #7931..#7A30 -> #69ED..#6AEC. Поэтому PERSON offset 0 = #69F8, имя 10 байтов, +#0A лидерство, +#0C магический запас, +#0E максимум, +#12 десять флагов заклинаний. PERSON7 проходит преобразование 25 пар в 25 значений через BL3 #6731..#6766. Полную структуру оформляет main_code
- NAZWANIE, слот 20 — 80 записей по 16 и 160 записей по 12, поле имени 15/11 байтов плюс байт использования, банк 1:#C000/#C500. Потребитель BL3 #77A3
- WERWOIN1..3 — по 2000 байтов, доказанные весовые подтаблицы записей по 6: ID, порог выбора, слово базового числа, слово случайной добавки. Потребитель BL3 #78D0, загрузка по #CB1A. Нельзя объявлять весь 2000-байтовый файл массивом этого типа
- MGPOWER1..3 — 110/115/110 байтов. Подробная семантика полей пока не установлена, одной делимости на 5 недостаточно
- HERTXT/TEXT/HELP — CP866 с нулевыми терминаторами, CR и управляющими байтами. HELP в исходнике имеет R-зависимую шифровку. Текст для чтения не подменяет исходный поток байтов
- Сохранения .M — 35584 байта, включают инверсию байтов и состояния банков. Их нельзя представлять как FPerson по одному совпадению имён

## 7. Проверяемое завершение семантического слоя


Графический ресурс считается извлечённым, когда есть конкретные raw/маска/атрибуты и PNG-просмотр с размерами, кадрами и исходным смещением. Структура считается описанной, когда у каждого поля есть размер, смещение, смысл либо честное Unknown и доказанный потребитель. Смысловое имя считается внедрённым, когда оно используется в CALL/JP/операндах, а не только присутствует рядом с Fxxxx как комментарий. Имена и разбиение не меняют исходные адреса, байтовую длину, фазовые наложения памяти и порядок сборки TRD.

Сборка в этом аудите не запускалась, файлы HoMM и итоговый outputs не изменялись. Графика PRES и аннотации нового кода подготовлены отдельно в work/semantic, графику SPR и шрифт DATA2 извлёк параллельный агент.
