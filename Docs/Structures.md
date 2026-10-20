# Структуры и именованные смещения

Реестр содержит **59 типов** и **311 непосредственных полей** из актуальных объявлений [`Includes/Structs`](../Includes/Structs). Вложенные поля доступны по составным именам, например `FTown.DockPos.Low`.

Размеры и смещения выражены в байтах, слова хранят младший байт первым. `struct` описывает формат, `EQU` именует уже существующий адрес или смещение. Эти объявления сами по себе не выделяют память.

Подтверждение компоновки и понимание назначения — разные результаты. В таблицах сохранены исходные свидетельства по потребителям. Неустановленные поля остаются `Unknown` или `Reserved`, такие байты нельзя считать свободными. Указатель IX/IY может быть смещён относительно начала записи, это должно учитываться по контракту процедуры.

См. [runtime-копии и рабочие области](Runtime.md), [таблицы генерации](GenerationTables.md), [диаграммы флагов](Flags.md), [машинный реестр](../Tools/Disasm/Reports/Structures.json).

## Реестр типов

| тип | размер | назначение | объявление |
| --- | ---: | --- | --- |
| [`FWord`](#fword) | 2 | 16-битное слово little-endian | [Includes/Structs/Word.inc](../Includes/Structs/Word.inc#L4) |
| [`FFloat5`](#ffloat5) | 5 | пять исходных байтов числа калькулятора ROM | [Includes/Structs/Float5.inc](../Includes/Structs/Float5.inc#L3) |
| [`FTroop`](#ftroop) | 3 | исходная стратегическая запись отряда | [Includes/Structs/Troop.inc](../Includes/Structs/Troop.inc#L24) |
| [`FMapList`](#fmaplist) | 4 | дескриптор списка объектов одного континента | [Includes/Structs/MapList.inc](../Includes/Structs/MapList.inc#L5) |
| [`FMoveStep`](#fmovestep) | 3 | рабочий кандидат перемещения внешнего объекта | [Includes/Structs/MoveStep.inc](../Includes/Structs/MoveStep.inc#L6) |
| [`FTroopA5`](#ftroopa5) | 15 | пять последовательных записей FTroop | [Includes/Structs/TroopA5.inc](../Includes/Structs/TroopA5.inc#L7) |
| [`FMapArmy`](#fmaparmy) | 22 | подвижная армия разбойников либо пиратов | [Includes/Structs/MapArmy.inc](../Includes/Structs/MapArmy.inc#L33) |
| [`FMapTroop`](#fmaptroop) | 6 | шестибайтовая группа существ на стратегической карте | [Includes/Structs/MapTroop.inc](../Includes/Structs/MapTroop.inc#L26) |
| [`FCastle`](#fcastle) | 35 | 35-байтная запись замка | [Includes/Structs/Castle.inc](../Includes/Structs/Castle.inc#L24) |
| [`FMapItem`](#fmapitem) | 3 | трёхбайтовая находка, не FTroop несмотря на одинаковую длину | [Includes/Structs/MapItem.inc](../Includes/Structs/MapItem.inc#L22) |
| [`FTemple`](#ftemple) | 5 | запись храма духов | [Includes/Structs/Temple.inc](../Includes/Structs/Temple.inc#L24) |
| [`FTroopA3`](#ftroopa3) | 9 | три последовательные записи FTroop | [Includes/Structs/TroopA3.inc](../Includes/Structs/TroopA3.inc#L5) |
| [`FTown`](#ftown) | 26 | 26-байтная запись города | [Includes/Structs/Town.inc](../Includes/Structs/Town.inc#L30) |
| [`FRuler`](#fruler) | 28 | описатель правителя в DATA1 | [Includes/Structs/Ruler.inc](../Includes/Structs/Ruler.inc#L8) |
| [`FSpell`](#fspell) | 23 | описатель заклинания в DATA1 | [Includes/Structs/Spell.inc](../Includes/Structs/Spell.inc#L6) |
| [`FPerson`](#fperson) | 245 | персональная часть состояния, имя и игровые поля. Совпадает с245байтными PERSON1..6/8 после загрузки | [Includes/Structs/Person.inc](../Includes/Structs/Person.inc#L141) |
| [`FGameState`](#fgamestate) | 256 | полный256байтный заголовок состояния, включает героя и глобальные события | [Includes/Structs/GameState.inc](../Includes/Structs/GameState.inc#L8) |
| [`FByteRange`](#fbyterange) | 2 | пара диапазона коэффициента PERSON7 | [Includes/Structs/ByteRange.inc](../Includes/Structs/ByteRange.inc#L5) |
| [`FByteRangeA25`](#fbyterangea25) | 50 | 25 последовательных пар FByteRange | [Includes/Structs/ByteRangeA25.inc](../Includes/Structs/ByteRangeA25.inc#L27) |
| [`FPerson7`](#fperson7) | 270 | дисковый вариант PERSON7 до нормализации,270байт. Нельзя усекать как обычный PERSON без выполнения алгоритма | [Includes/Structs/Person7.inc](../Includes/Structs/Person7.inc#L5) |
| [`FSoldier`](#fsoldier) | 42 | описатель типа существа, SOLDIERS, 25 записей | [Includes/Structs/Soldier.inc](../Includes/Structs/Soldier.inc#L105) |
| [`FBattleUnit`](#fbattleunit) | 18 | рабочий отряд боя, две армии по 5 записей | [Includes/Structs/BattleUnit.inc](../Includes/Structs/BattleUnit.inc#L69) |
| [`FMenuRect`](#fmenurect) | 4 | прямоугольник пункта меню в знакоместах | [Includes/Structs/MenuRect.inc](../Includes/Structs/MenuRect.inc#L7) |
| [`FMenuHeader`](#fmenuheader) | 7 | фиксированная часть меню, далее N записей FMenuRect | [Includes/Structs/MenuHeader.inc](../Includes/Structs/MenuHeader.inc#L10) |
| [`FTile32`](#ftile32) | 144 | непрозрачный тайл или портрет 32 на 32 пикселя | [Includes/Structs/Tile32.inc](../Includes/Structs/Tile32.inc#L5) |
| [`FMasked32`](#fmasked32) | 256 | маскированный кадр 32 на 32 пикселя | [Includes/Structs/Masked32.inc](../Includes/Structs/Masked32.inc#L5) |
| [`FPictureHeader`](#fpictureheader) | 5 | заголовок RLE-изображения HERIMG, BL1 и BL2 | [Includes/Structs/PictureHeader.inc](../Includes/Structs/PictureHeader.inc#L29) |
| [`FFrameRef`](#fframeref) | 3 | ссылка на кадр в расширенной памяти | [Includes/Structs/FrameRef.inc](../Includes/Structs/FrameRef.inc#L5) |
| [`FScreenObject20`](#fscreenobject20) | 20 | экранная запись объекта, используется массивом State.ViewObjects | [Includes/Structs/ScreenObject20.inc](../Includes/Structs/ScreenObject20.inc#L37) |
| [`FMenuWindow`](#fmenuwindow) | 7 | описатель окна скрытого меню | [Includes/Structs/MenuWindow.inc](../Includes/Structs/MenuWindow.inc#L11) |
| [`FMenuArea`](#fmenuarea) | 3 | область выбора скрытого меню | [Includes/Structs/MenuArea.inc](../Includes/Structs/MenuArea.inc#L23) |
| [`FMenuCursor`](#fmenucursor) | 32 | рисунок и маска пиксельного курсора скрытого меню | [Includes/Structs/MenuCursor.inc](../Includes/Structs/MenuCursor.inc#L6) |
| [`FMusicChannel`](#fmusicchannel) | 10 | состояние канала AY плеера меню | [Includes/Structs/MusicChannel.inc](../Includes/Structs/MusicChannel.inc#L12) |
| [`FSampleStep`](#fsamplestep) | 3 | трёхбайтовый шаг музыкального семпла | [Includes/Structs/SampleStep.inc](../Includes/Structs/SampleStep.inc#L39) |
| [`FRleState`](#frlestate) | 4 | рабочие настройки самоперемещаемого распаковщика изображений | [Includes/Structs/RleState.inc](../Includes/Structs/RleState.inc#L28) |
| [`FStar`](#fstar) | 2 | координаты звезды заставки | [Includes/Structs/Star.inc](../Includes/Structs/Star.inc#L6) |
| [`FCreditLine`](#fcreditline) | 3 | фиксированная часть строки титров, далее текст с нулём | [Includes/Structs/CreditLine.inc](../Includes/Structs/CreditLine.inc#L7) |
| [`FCityMessage`](#fcitymessage) | 5 | параметры сообщения об отношении города | [Includes/Structs/CityMessage.inc](../Includes/Structs/CityMessage.inc#L7) |
| [`FRewardBand`](#frewardband) | 2 | порог и сотни базовой стоимости случайной награды | [Includes/Structs/RewardBand.inc](../Includes/Structs/RewardBand.inc#L6) |
| [`FMapSite`](#fmapsite) | 3 | общая координатная часть разных объектов карты | [Includes/Structs/MapSite.inc](../Includes/Structs/MapSite.inc#L22) |
| [`FTrdosEntry`](#ftrdosentry) | 16 | запись каталога TRDOS | [Includes/Structs/TrdosEntry.inc](../Includes/Structs/TrdosEntry.inc#L11) |
| [`FWeightedTroop`](#fweightedtroop) | 6 | весовая запись выбора типа и численности случайного отряда | [Includes/Structs/WeightedTroop.inc](../Includes/Structs/WeightedTroop.inc#L8) |
| [`FWeightedType`](#fweightedtype) | 2 | весовая запись выбора типа странствующей группы | [Includes/Structs/WeightedType.inc](../Includes/Structs/WeightedType.inc#L6) |
| [`FArmyManaPool`](#farmymanapool) | 5 | последовательно расходуемая группа начальных магических параметров внешних армий | [Includes/Structs/ArmyManaPool.inc](../Includes/Structs/ArmyManaPool.inc#L7) |
| [`FMoveStepA3`](#fmovestepa3) | 9 | три кандидата движения, изменяемые процедурами Steps* | [Includes/Structs/MoveStepA3.inc](../Includes/Structs/MoveStepA3.inc#L7) |
| [`FPosition`](#fposition) | 2 | упакованная пара координат или знаковых разностей X/Y | [Includes/Structs/Position.inc](../Includes/Structs/Position.inc#L6) |
| [`FMapGroup`](#fmapgroup) | 5 | описатель группы при поиске занятой клетки | [Includes/Structs/MapGroup.inc](../Includes/Structs/MapGroup.inc#L8) |
| [`FOverlayKey`](#foverlaykey) | 2 | соответствие кода клавиши номеру оверлея | [Includes/Structs/OverlayKey.inc](../Includes/Structs/OverlayKey.inc#L6) |
| [`FKeyMap`](#fkeymap) | 2 | пара преобразования кода клавиатуры | [Includes/Structs/KeyMap.inc](../Includes/Structs/KeyMap.inc#L6) |
| [`FExpense`](#fexpense) | 6 | статья недельного расхода | [Includes/Structs/Expense.inc](../Includes/Structs/Expense.inc#L24) |
| [`FTroopRange`](#ftrooprange) | 4 | база и случайная добавка количества нападающего отряда | [Includes/Structs/TroopRange.inc](../Includes/Structs/TroopRange.inc#L6) |
| [`FLossRange`](#flossrange) | 2 | пределы потерь гарнизона по сложности | [Includes/Structs/LossRange.inc](../Includes/Structs/LossRange.inc#L6) |
| [`FBattleCell`](#fbattlecell) | 3 | кандидат соседней клетки, статус 0 свободно, 1 край/препятствие, 2 герой, 3 противник | [Includes/Structs/BattleCell.inc](../Includes/Structs/BattleCell.inc#L7) |
| [`FBattleCells`](#fbattlecells) | 24 | восемь кандидатов в порядке выбранного направления, First..Eighth не фиксированные стороны света | [Includes/Structs/BattleCells.inc](../Includes/Structs/BattleCells.inc#L12) |
| [`FBattleTarget`](#fbattletarget) | 3 | цель случайного действия, 2 герой, 3 противник, бит 7 исключает уже проверенную цель полёта | [Includes/Structs/BattleTarget.inc](../Includes/Structs/BattleTarget.inc#L23) |
| [`FBattleArmy`](#fbattlearmy) | 90 | пять плотных записей армии боя | [Includes/Structs/BattleArmy.inc](../Includes/Structs/BattleArmy.inc#L9) |
| [`FObstacleRows`](#fobstaclerows) | 3 | скользящее окно трёх соседних масок строк для проверки общего препятствия | [Includes/Structs/ObstacleRows.inc](../Includes/Structs/ObstacleRows.inc#L7) |
| [`FIntroTimers`](#fintrotimers) | 2 | интервал пиксельного сдвига и число сдвигов до следующей строки текста | [Includes/Structs/IntroTimers.inc](../Includes/Structs/IntroTimers.inc#L6) |
| [`FTownWeight`](#ftownweight) | 2 | весовая запись выбора типа отряда в городе | [Includes/Structs/TownWeight.inc](../Includes/Structs/TownWeight.inc#L6) |

## FWord

16-битное слово little-endian

Размер: **2** байт. Объявление: [Includes/Structs/Word.inc](../Includes/Structs/Word.inc#L4).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Low` | `DB` | младший байт |
| +#01 | 1 | `High` | `DB` | старший байт |

## FFloat5

пять исходных байтов числа калькулятора ROM

Размер: **5** байт. Объявление: [Includes/Structs/Float5.inc](../Includes/Structs/Float5.inc#L3).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 5 | `Data` | `DS` | формат ROM, включая особое представление целого |

## FTroop

исходная стратегическая запись отряда

Размер: **3** байт. Объявление: [Includes/Structs/Troop.inc](../Includes/Structs/Troop.inc#L24).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `ID` | `DB` | ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID |
| +#01 | 2 | `Count` | `FWord` | беззнаковая численность little-endian |

Свидетельства для отдельных полей:

- `ID`: `Engine.BuildArmy` — [Source/Engine/BuildArmy.asm](../Source/Engine/BuildArmy.asm#L56) — C=(IX+1), B=(IX+2), ID=(IX+0), затем IX+=3 по #88DB<br>`Engine.GrowTroop` — [Source/Engine/GrowTroop.asm](../Source/Engine/GrowTroop.asm#L16) — сравнение ID и обновление количества +1/+2, IX+=3<br>`Engine.TickTime` — [Source/Engine/TickTime.asm](../Source/Engine/TickTime.asm#L469) — AND #1F перед #7AEF, затем SET 7/6,(HL)
- `Count`: `Engine.BuildArmy` — [Source/Engine/BuildArmy.asm](../Source/Engine/BuildArmy.asm#L56) — C=(IX+1), B=(IX+2), ID=(IX+0), затем IX+=3 по #88DB<br>`Engine.GrowTroop` — [Source/Engine/GrowTroop.asm](../Source/Engine/GrowTroop.asm#L16) — сравнение ID и обновление количества +1/+2, IX+=3

Дополнительные свойства исходного реестра:

- `count_examples`: [5, 3]
- `termination`: ID=0

## FMapList

дескриптор списка объектов одного континента

Размер: **4** байт. Объявление: [Includes/Structs/MapList.inc](../Includes/Structs/MapList.inc#L5).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 2 | `Data` | `FWord` | адрес первой записи в банке выбранной группы |
| +#02 | 2 | `Count` | `FWord` | число записей little-endian, не размер в байтах |

Свидетельства для отдельных полей:

- `Data`: `Engine.StepArmies` — [Source/Engine/StepArmies.asm](../Source/Engine/StepArmies.asm#L63) — L=(IX+0), H=(IX+1), затем IX=HL<br>`Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L60) — L=(IX+0), H=(IX+1), затем IX=HL
- `Count`: `Engine.StepArmies` — [Source/Engine/StepArmies.asm](../Source/Engine/StepArmies.asm#L65) — C=(IX+2), B=(IX+3), DEC BC на каждой записи<br>`Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L62) — C=(IX+2), B=(IX+3), DEC BC на каждой записи

Дополнительные свойства исходного реестра:

- `indexing`: #7A74 прибавляет 4*A. У публичных баз #6AE9/#6AF9/... индекс начинается с 1, первая реальная запись находится база+4

## FMoveStep

рабочий кандидат перемещения внешнего объекта

Размер: **3** байт. Объявление: [Includes/Structs/MoveStep.inc](../Includes/Structs/MoveStep.inc#L6).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `TerrainMask` | `DB` | маска класса местности кандидата, #FF выделяет водный класс, 0 не требует проверки способностей |
| +#01 | 1 | `X` | `DB` | столбец соседней клетки |
| +#02 | 1 | `Y` | `DB` | строка соседней клетки |

Свидетельства для отдельных полей:

- `TerrainMask`: `Engine.ClassifySteps` — [Source/Engine/ClassifySteps.asm](../Source/Engine/ClassifySteps.asm#L15) — для трёх координат вызываются #80C4/#867D и результат пишется в+0<br>`Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L150) — ненулевой класс проверяется через способности отряда
- `X`: `Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L106) — кандидат x=(IY+1), допустимо3..157
- `Y`: `Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L111) — кандидат y=(IY+2), допустимо3..96

Дополнительные свойства исходного реестра:

- `base`: 37558
- `array_count`: 3

## FTroopA5

пять последовательных записей FTroop

Размер: **15** байт. Объявление: [Includes/Structs/TroopA5.inc](../Includes/Structs/TroopA5.inc#L7).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 3 | `Item0` | `FTroop` | элемент 0 |
| +#03 | 3 | `Item1` | `FTroop` | элемент 1 |
| +#06 | 3 | `Item2` | `FTroop` | элемент 2 |
| +#09 | 3 | `Item3` | `FTroop` | элемент 3 |
| +#0C | 3 | `Item4` | `FTroop` | элемент 4 |

## FMapArmy

подвижная армия разбойников либо пиратов

Размер: **22** байт. Объявление: [Includes/Structs/MapArmy.inc](../Includes/Structs/MapArmy.inc#L33).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Flags` | `DB` | состояние внешней армии |
| +#01 | 1 | `X` | `DB` | столбец стратегической карты |
| +#02 | 1 | `Y` | `DB` | строка стратегической карты |
| +#03 | 2 | `Mana` | `FWord` | текущий запас магической силы внешней армии. Восстанавливается с пределом 15000 и передаётся словом DE в бой |
| +#05 | 2 | `ManaRegen` | `FWord` | прибавляемое при регенерации количество магической силы |
| +#07 | 15 | `Army` | `FTroopA5` | пять стратегических отрядов FTroop |

Свидетельства для отдельных полей:

- `Flags`: `Engine.StepArmies` — [Source/Engine/StepArmies.asm](../Source/Engine/StepArmies.asm#L77) — чтение флагов записи с шагом #16
- `X`: `Engine.StepArmies` — [Source/Engine/StepArmies.asm](../Source/Engine/StepArmies.asm#L121) — C=(IX+1) перед определением направления<br>`Engine.StepArmies` — [Source/Engine/StepArmies.asm](../Source/Engine/StepArmies.asm#L412) — (IX+1)=C
- `Y`: `Engine.StepArmies` — [Source/Engine/StepArmies.asm](../Source/Engine/StepArmies.asm#L122) — B=(IX+2)<br>`Engine.StepArmies` — [Source/Engine/StepArmies.asm](../Source/Engine/StepArmies.asm#L413) — (IX+2)=B
- `Mana`: `Engine.RegenMana` — [Source/Engine/RegenMana.asm](../Source/Engine/RegenMana.asm#L29) — HL=word(IX+3), DE=15000, вызов #A0FC, запись обратно +3/+4<br>`Overlay.Bandits.Entry` — [Source/Overlays/Bandits.asm](../Source/Overlays/Bandits.asm#L78) — IX уже смещён на +3, DE=word(IX+0), затем IX+=4, бой #D255
- `ManaRegen`: `Engine.RegenMana` — [Source/Engine/RegenMana.asm](../Source/Engine/RegenMana.asm#L32) — BC=word(IX+5), прибавление к word(IX+3) с насыщением 15000
- `Army`: `Engine.StepArmies` — [Source/Engine/StepArmies.asm](../Source/Engine/StepArmies.asm#L106) — HL=указатель записи+7, B=5, #9193<br>`Overlay.Bandits.Entry` — [Source/Overlays/Bandits.asm](../Source/Overlays/Bandits.asm#L59) — IY=указатель записи+3, IY+=4, A=5 перед #7E55

Дополнительные свойства исходного реестра:

- `bank`: 1
- `notes`: ["Разделение #8FC5..#9001 создаёт новую запись, но не инициализирует Mana и ManaRegen. Семантическое описание сохраняет эту особенность оригинала."]

## FMapTroop

шестибайтовая группа существ на стратегической карте

Размер: **6** байт. Объявление: [Includes/Structs/MapTroop.inc](../Includes/Structs/MapTroop.inc#L26).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Flags` | `DB` | состояние шестибайтовой группы, бит 0 свободна/использована, бит 5 вода, бит 6 ориентация, другие биты отдельно не именуются |
| +#01 | 1 | `X` | `DB` | столбец карты |
| +#02 | 1 | `Y` | `DB` | строка карты |
| +#03 | 1 | `ID` | `DB` | тип отряда, описатель SOLDIERS |
| +#04 | 2 | `Count` | `FWord` | беззнаковая численность little-endian |

Свидетельства для отдельных полей:

- `Flags`: `Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L70) — BIT 0,(IX+0)<br>`Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L79) — AND #20<br>`Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L179) — #91BF изменяет бит 6<br>`Overlay.Castle.PlaceAuxTroops` — [Source/Overlays/Castle.asm](../Source/Overlays/Castle.asm#L679) — поиск свободной шестибайтовой записи и заполнение полей
- `X`: `Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L176) — (IX+1)=C
- `Y`: `Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L177) — (IX+2)=B
- `ID`: `Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L156) — A=(IX+3), CALL #7AEF<br>`Engine.RepopulateSites` — [Source/Engine/RepopulateSites.asm](../Source/Engine/RepopulateSites.asm#L70) — тип соседней записи переносится в +3
- `Count`: `Engine.RepopulateSites` — [Source/Engine/RepopulateSites.asm](../Source/Engine/RepopulateSites.asm#L67) — проверка пары IY+4/+5<br>`Engine.RepopulateSites` — [Source/Engine/RepopulateSites.asm](../Source/Engine/RepopulateSites.asm#L79) — (IX+4)=C, (IX+5)=B после чтения начальной численности SOLDIERS

Дополнительные свойства исходного реестра:

- `bank`: 
- `notes`: ["Структура встречается в списке #6B69 и родственных списках #6B19/#6B29/#6B39/#6B49. Роль списка и формат весовых записей WERWOIN различаются.", "Обход #92CB после отказа C!=0,8 от #8CD1 может продолжить с изменённым IX, восстановление #928F отсутствует на этом пути."]

## FCastle

35-байтная запись замка

Размер: **35** байт. Объявление: [Includes/Structs/Castle.inc](../Includes/Structs/Castle.inc#L24).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Flags` | `DB` | бит 0 выключает запись, значения остальных битов отдельно не установлены |
| +#01 | 1 | `X` | `DB` | столбец карты |
| +#02 | 1 | `Y` | `DB` | строка карты |
| +#03 | 15 | `Name` | `DS` | 15 символов имени CP866, допускается редактирование всех 15 |
| +#12 | 1 | `Terminator` | `DB` | нулевой терминатор после имени |
| +#13 | 1 | `Owner` | `DB` | 0 собственный замок, 1..15 правитель FRuler, #FF особое отсутствие правителя/банды |
| +#14 | 15 | `Army` | `FTroopA5` | пять записей гарнизона FTroop |

Свидетельства для отдельных полей:

- `Flags`: `Engine.CountOwnCastles` — [Source/Engine/CountOwnCastles.asm](../Source/Engine/CountOwnCastles.asm#L23) — BIT 0,(IX+0), шаг35
- `X`: `Engine.TickCastle` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L82) — координаты атакуемого замка из +1/+2
- `Y`: `Engine.TickCastle` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L82) — координаты атакуемого замка из +1/+2
- `Name`: `Overlay.Castle.Entry` — [Source/Overlays/Castle.asm](../Source/Overlays/Castle.asm#L32) — интерфейс получает #867B, указатель на имя физической записи+3<br>`Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L310) — #77A3 выбирает имя шаг16 и копирует15символов
- `Terminator`: `Startup.PickUnusedName` — [Source/Startup/PickUnusedName.asm](../Source/Startup/PickUnusedName.asm#L19) — после копирования15символов дописывается ноль
- `Owner`: `Engine.CountOwnCastles` — [Source/Engine/CountOwnCastles.asm](../Source/Engine/CountOwnCastles.asm#L25) — владелец0 учитывается как собственный<br>`Engine.HasOwnerCastle` — [Source/Engine/HasOwnerCastle.asm](../Source/Engine/HasOwnerCastle.asm#L28) — поиск по заданному владельцу<br>`Engine.TickCastle` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L89) — владелец ближайшего замка определяет нападающего
- `Army`: `Engine.TickCastle` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L354) — 15 байтов атакующей армии копируются в гарнизон<br>`Overlay.Castle.Entry` — [Source/Overlays/Castle.asm](../Source/Overlays/Castle.asm#L32) — гарнизон вычисляется имя+17, то есть запись+20

Дополнительные свойства исходного реестра:

- `bank`: 
- `array_base`: 49152
- `array_count`: 80
- `pointer_views`: [{"name": "NameView", "base_offset": 3, "evidence": [{"module": "S10", "address": 34418, "hex": "#8672", "operation": "IX передаётся через #867B как указатель имени замка"}], "warning": "IX+16 от имени соответствует Owner+19 физической записи, IX+17 соответствует Army+20"}]

## FMapItem

трёхбайтовая находка, не FTroop несмотря на одинаковую длину

Размер: **3** байт. Объявление: [Includes/Structs/MapItem.inc](../Includes/Structs/MapItem.inc#L22).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Flags` | `DB` | бит 0 означает использованную/выключенную находку |
| +#01 | 1 | `X` | `DB` | столбец карты |
| +#02 | 1 | `Y` | `DB` | строка карты |

Свидетельства для отдельных полей:

- `Flags`: `Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L138) — SET 0,(IX+0) для типа8 от #8CD1
- `X`: `Engine.FindMapObject` — [Source/Engine/FindMapObject.asm](../Source/Engine/FindMapObject.asm#L46) — тип8 выбирает группу #6B59, общий поиск координат +1/+2
- `Y`: `Engine.FindMapObject` — [Source/Engine/FindMapObject.asm](../Source/Engine/FindMapObject.asm#L46) — тип8 выбирает группу #6B59, общий поиск координат +1/+2

Дополнительные свойства исходного реестра:

- `bank`: 

## FTemple

запись храма духов

Размер: **5** байт. Объявление: [Includes/Structs/Temple.inc](../Includes/Structs/Temple.inc#L24).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Flags` | `DB` | бит 0 выключает запись |
| +#01 | 1 | `X` | `DB` | столбец карты |
| +#02 | 1 | `Y` | `DB` | строка карты |
| +#03 | 1 | `Cult` | `DB` | тип храма/секты |
| +#04 | 1 | `Spell` | `DB` | ID доступного для изучения заклинания |

Свидетельства для отдельных полей:

- `Flags`: `Engine.FindMapObject` — [Source/Engine/FindMapObject.asm](../Source/Engine/FindMapObject.asm#L75) — дескриптор типа3 задаёт шаг5 и общий поиск
- `X`: `Engine.FindRecord` — [Source/Engine/FindRecord.asm](../Source/Engine/FindRecord.asm#L16) — общий поиск читает +1/+2
- `Y`: `Engine.FindRecord` — [Source/Engine/FindRecord.asm](../Source/Engine/FindRecord.asm#L16) — общий поиск читает +1/+2
- `Cult`: `Overlay.Temple.Entry` — [Source/Overlays/Temple.asm](../Source/Overlays/Temple.asm#L27) — поле+3 выбирает строку секты и коэффициенты услуг
- `Spell`: `Overlay.Temple.Entry` — [Source/Overlays/Temple.asm](../Source/Overlays/Temple.asm#L49) — A=(IX+4), CALL #8066

Дополнительные свойства исходного реестра:

- `bank`: 

## FTroopA3

три последовательные записи FTroop

Размер: **9** байт. Объявление: [Includes/Structs/TroopA3.inc](../Includes/Structs/TroopA3.inc#L5).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 3 | `Item0` | `FTroop` | элемент 0 |
| +#03 | 3 | `Item1` | `FTroop` | элемент 1 |
| +#06 | 3 | `Item2` | `FTroop` | элемент 2 |

## FTown

26-байтная запись города

Размер: **26** байт. Объявление: [Includes/Structs/Town.inc](../Includes/Structs/Town.inc#L30).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Flags` | `DB` | бит 0 выключает запись, бит 1 проверяется при доступности контракта |
| +#01 | 1 | `X` | `DB` | столбец карты |
| +#02 | 1 | `Y` | `DB` | строка карты |
| +#03 | 11 | `Name` | `DS` | 11 символов имени CP866 |
| +#0E | 1 | `Terminator` | `DB` | нулевой терминатор имени |
| +#0F | 2 | `DockPos` | `FWord` | координаты причала, Low столбец и High строка, нулевое слово означает отсутствие причала |
| +#11 | 9 | `Army` | `FTroopA3` | до трёх отрядов FTroop |

Свидетельства для отдельных полей:

- `Flags`: `Engine.RefreshTowns` — [Source/Engine/RefreshTowns.asm](../Source/Engine/RefreshTowns.asm#L17) — таблица #6AF9 и шаг26<br>`Overlay.City.Entry` — [Source/Overlays/City.asm](../Source/Overlays/City.asm#L317) — BIT 1,(IX-3), IX указывает на имя
- `X`: `Engine.CastleIncome` — [Source/Engine/CastleIncome.asm](../Source/Engine/CastleIncome.asm#L15) — координаты города используются для дохода замка
- `Y`: `Engine.CastleIncome` — [Source/Engine/CastleIncome.asm](../Source/Engine/CastleIncome.asm#L15) — координаты города используются для дохода замка
- `Name`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L384) — выбор уникального имени с шагом12, копирование11символов
- `Terminator`: `Startup.PickUnusedName` — [Source/Startup/PickUnusedName.asm](../Source/Startup/PickUnusedName.asm#L19) — после копирования имени записывается0
- `DockPos`: `Engine.CastleIncome` — [Source/Engine/CastleIncome.asm](../Source/Engine/CastleIncome.asm#L15) — проверки полей15/16 влияют на доход<br>`Overlay.City.Entry` — [Source/Overlays/City.asm](../Source/Overlays/City.asm#L23)
- `Army`: `Engine.RefreshTowns` — [Source/Engine/RefreshTowns.asm](../Source/Engine/RefreshTowns.asm#L17) — обнуляет9байт с+17, формирует0..3отряда

Дополнительные свойства исходного реестра:

- `bank`: 

## FRuler

описатель правителя в DATA1

Размер: **28** байт. Объявление: [Includes/Structs/Ruler.inc](../Includes/Structs/Ruler.inc#L8).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 21 | `Name` | `DS` | 21 символ имени вражеского правителя, дополнение пробелами |
| +#15 | 1 | `Terminator` | `DB` | ноль после имени |
| +#16 | 2 | `Mana` | `FWord` | текущая магическая сила |
| +#18 | 2 | `ManaMax` | `FWord` | максимум магической силы |
| +#1A | 2 | `ManaRegen` | `FWord` | пополнение магической силы за вызов восстановления |

Свидетельства для отдельных полей:

- `Name`: `Engine.RulerDesc` — [Source/Engine/RulerDesc.asm](../Source/Engine/RulerDesc.asm#L14) — IX=#CCAF+28*ID, ID1 даёт#CCCB<br>`Overlay.Info.ListRulers` — [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L579) — печать имён побеждённых правителей ID1..15<br>`Data.Battle.Ruler01` — [Source/Files/46_DATA1.asm](../Source/Files/46_DATA1.asm#L232) — первые21байт записи являются CP866-именем
- `Terminator`: `Data.Battle.Ruler01` — [Source/Files/46_DATA1.asm](../Source/Files/46_DATA1.asm#L237) — нулевой байт записи0+21
- `Mana`: `Engine.RegenMana` — [Source/Engine/RegenMana.asm](../Source/Engine/RegenMana.asm#L49) — чтение word(IX+22) и восстановление к максимуму+24<br>`Overlay.Capture.Entry` — [Source/Overlays/Capture.asm](../Source/Overlays/Capture.asm#L212) — DE=word(IX+22) перед #D255<br>`Overlay.Capture.Entry` — [Source/Overlays/Capture.asm](../Source/Overlays/Capture.asm#L227) — остаток магии из DE записывается в+22/+23
- `ManaMax`: `Engine.RegenMana` — [Source/Engine/RegenMana.asm](../Source/Engine/RegenMana.asm#L51) — DE=word(IX+24), общий ограничитель#A0FC
- `ManaRegen`: `Engine.RegenMana` — [Source/Engine/RegenMana.asm](../Source/Engine/RegenMana.asm#L53) — BC=word(IX+26), прибавление к word(IX+22)

Дополнительные свойства исходного реестра:

- `bank`: 3
- `array_base`: 52427
- `array_count`: 15

## FSpell

описатель заклинания в DATA1

Размер: **23** байт. Объявление: [Includes/Structs/Spell.inc](../Includes/Structs/Spell.inc#L6).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 20 | `Name` | `DS` | 20 символов названия заклинания, дополнение пробелами |
| +#14 | 1 | `Terminator` | `DB` | ноль после имени |
| +#15 | 2 | `ManaCost` | `FWord` | магическая стоимость, также служит основанием цены изучения с множителем 100 и модификатором секты |

Свидетельства для отдельных полей:

- `Name`: `Engine.SpellDesc` — [Source/Engine/SpellDesc.asm](../Source/Engine/SpellDesc.asm#L14) — IX=#CE58+23*ID, ID1 даёт#CE6F<br>`Overlay.Info.ListSpells` — [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L809) — печать имён изученных заклинаний ID1..10<br>`Data.Battle.Freeze` — [Source/Files/46_DATA1.asm](../Source/Files/46_DATA1.asm#L457) — первые20байт записи являются CP866-именем
- `Terminator`: `Data.Battle.Freeze` — [Source/Files/46_DATA1.asm](../Source/Files/46_DATA1.asm#L462) — нулевой байт записи0+20
- `ManaCost`: `Battle.InputLoop` — [Source/Battle/InputLoop.asm](../Source/Battle/InputLoop.asm#L600) — BC=word(IX+21) после #8066, далее проверка/списание магии<br>`Overlay.Temple.Entry` — [Source/Overlays/Temple.asm](../Source/Overlays/Temple.asm#L52) — BC=word(IX+21), умножение на100

Дополнительные свойства исходного реестра:

- `bank`: 3
- `array_base`: 52847
- `array_count`: 10

## FPerson

персональная часть состояния, имя и игровые поля. Совпадает с245байтными PERSON1..6/8 после загрузки

Размер: **245** байт. Объявление: [Includes/Structs/Person.inc](../Includes/Structs/Person.inc#L141).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 9 | `Name` | `DS` | имя выбранного героя, девять символов CP866 |
| +#09 | 1 | `Terminator` | `DB` | нулевой терминатор имени |
| +#0A | 2 | `Leadership` | `FWord` | лидерство, задаёт предел количества отряда через деление на коэффициент типа |
| +#0C | 2 | `Mana` | `FWord` | текущая магическая сила героя |
| +#0E | 2 | `ManaMax` | `FWord` | максимум магической силы |
| +#10 | 2 | `ManaRegen` | `FWord` | пополнение магической силы при очередном восстановлении |
| +#12 | 10 | `Spells` | `DS` | 10 байтов состояния заклинаний, бит 0 — заклинание изучено, остальные биты отдельно не именуются |
| +#1C | 5 | `Money` | `FFloat5` | наличные монеты в пятибайтном формате калькулятора ROM |
| +#21 | 5 | `BaseIncome` | `FFloat5` | постоянная часть недельного дохода в формате Float5, складывается с доходами замков |
| +#26 | 15 | `Army` | `FTroopA5` | пять записей армии героя FTroop |
| +#35 | 1 | `Continent` | `DB` | текущий континент 1..4 |
| +#36 | 1 | `X` | `DB` | столбец текущей клетки героя |
| +#37 | 1 | `Y` | `DB` | строка текущей клетки героя |
| +#38 | 1 | `ShipMap` | `DB` | континент корабля, #FF означает отсутствие корабля |
| +#39 | 1 | `ShipX` | `DB` | столбец корабля, #FF является признаком отсутствия |
| +#3A | 1 | `ShipY` | `DB` | строка корабля |
| +#3B | 1 | `MoveFlags` | `DB` | младшие 2 бита — режим 0 суша/1 корабль/2 полёт, бит 2 служебный режим вида, биты 3/4 ориентация героя/корабля, бит 5 наличие осадных орудий. Биты 6/7 здесь не установлены |
| +#3C | 1 | `MapFlags` | `DB` | флаги доступных полных карт/континентов, биты выбираются по континенту |
| +#3D | 1 | `DayFraction` | `DB` | дробная часть дня в единицах 1/256, переполнение увеличивает Days |
| +#3E | 2 | `Days` | `FWord` | счётчик прошедших дней |
| +#40 | 2 | `Deadline` | `FWord` | предел числа дней, поражение вызывается именно при Days == Deadline |
| +#42 | 1 | `Contract` | `DB` | номер замка текущего контракта с 1, 0 означает отсутствие |
| +#43 | 1 | `Cult` | `DB` | принадлежность героя к секте, 0 не состоит |
| +#44 | 8 | `Unknown6A3C` | `DS` | содержимое восьми байтов не получило подтверждённых игровых имён |
| +#4C | 1 | `GoodX` | `DB` | столбец соответствующего рассказчика |
| +#4D | 1 | `GoodY` | `DB` | строка соответствующего рассказчика |
| +#4E | 1 | `GoodMap` | `DB` | континент соответствующего рассказчика |
| +#4F | 2 | `Unknown6A47` | `FWord` | два байта между континентом и счётчиком встреч, назначение не установлено |
| +#51 | 2 | `GoodVisits` | `FWord` | число встреч с соответствующим рассказчиком |
| +#53 | 1 | `BadX` | `DB` | столбец соответствующего рассказчика |
| +#54 | 1 | `BadY` | `DB` | строка соответствующего рассказчика |
| +#55 | 1 | `BadMap` | `DB` | континент соответствующего рассказчика |
| +#56 | 2 | `Unknown6A4E` | `FWord` | два байта между континентом и счётчиком встреч, назначение не установлено |
| +#58 | 2 | `BadVisits` | `FWord` | число встреч с соответствующим рассказчиком |
| +#5A | 3 | `Unknown6A52` | `DS` | назначение трёх байтов не установлено |
| +#5D | 5 | `PuzzleOpen` | `DS` | пять строк по 5 бит открытых частей карты цели |
| +#62 | 25 | `PuzzleTiles` | `DS` | образец квадратного участка 5x5 для поиска посоха, сравнение младших 6 бит |
| +#7B | 25 | `IdleDays` | `DS` | 25 счётчиков дней по ID1..25, сброс при добавлении нового ID, используется порогом деградации |
| +#94 | 25 | `UpgradeCount` | `DS` | 25 счётчиков развития по ID1..25, сравниваются с SOLDIERS+40, точная единица накопления в данном файле не устанавливается |
| +#AD | 1 | `Unknown6AA5` | `DB` | назначение байта не установлено |
| +#AE | 2 | `Wins` | `FWord` | счётчик побед, ResolveLosses увеличивает только младший байт, город читает слово |
| +#B0 | 2 | `Losses` | `FWord` | счётчик поражений, ResolveLosses увеличивает только младший байт, город читает слово |
| +#B2 | 1 | `Attacker` | `DB` | 0 нет угрозы замку, 1..15 правитель, #FF банды |
| +#B3 | 1 | `AttackDays` | `DB` | дни до разрешения угрозы, исходно 20+R(15) |
| +#B4 | 2 | `AttackCastle` | `FWord` | адрес физической 35 байтной записи атакуемого замка в банке 0 |
| +#B6 | 15 | `AttackArmy` | `FTroopA5` | пять записей FTroop атакующей армии, построение создаёт 2..4 отряда |
| +#C5 | 23 | `Unknown6ABD` | `DS` | 23 сохраняемых байта до массива коэффициентов контроля, назначение не установлено |
| +#DC | 25 | `UnitControl` | `DS` | 25 коэффициентов предела контроля армии по ID1..25, предел=floor(Leadership/коэффициент) |

Свидетельства для отдельных полей:

- `Name`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L163) — PERSONn загружается в #793C<br>`Engine.Initialize` — [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L30) — соответствие #7931→#69ED через сектор состояния, PERSON+0 соответствует #69F8<br>`Engine.RefreshHero` — [Source/Engine/RefreshHero.asm](../Source/Engine/RefreshHero.asm#L138) — строка панели содержит указатель#69F8
- `Terminator`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L163) — PERSONn загружается в #793C<br>`Engine.Initialize` — [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L30) — соответствие #7931→#69ED через сектор состояния, PERSON+0 соответствует #69F8
- `Leadership`: `Engine.ControlLimit` — [Source/Engine/ControlLimit.asm](../Source/Engine/ControlLimit.asm#L18) — BC=word(#6A02), деление на byte(#6AD3+ID) и floor<br>`Engine.LoseLeadership` — [Source/Engine/LoseLeadership.asm](../Source/Engine/LoseLeadership.asm#L26) — насыщенное уменьшение<br>`Engine.GainLeadership` — [Source/Engine/GainLeadership.asm](../Source/Engine/GainLeadership.asm#L26) — насыщенное увеличение
- `Mana`: `Engine.RegenMana` — [Source/Engine/RegenMana.asm](../Source/Engine/RegenMana.asm#L16) — текущее значение, прибавление#6A08 с максимумом#6A06<br>`Battle.SpendHeroMagic` — [Source/Battle/SpendHeroMagic.asm](../Source/Battle/SpendHeroMagic.asm#L13) — вычитает стоимость заклинания из#6A04 с насыщением0
- `ManaMax`: `Engine.RegenMana` — [Source/Engine/RegenMana.asm](../Source/Engine/RegenMana.asm#L17) — верхняя граница DE для#6A04
- `ManaRegen`: `Engine.RegenMana` — [Source/Engine/RegenMana.asm](../Source/Engine/RegenMana.asm#L18) — BC=word(#6A08), прибавляется к#6A04
- `Spells`: `Overlay.Info.ListSpells` — [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L809) — ID1..10 проверяют бит0 по #6A09+ID
- `Money`: `Engine.RefreshHero` — [Source/Engine/RefreshHero.asm](../Source/Engine/RefreshHero.asm#L128) — панель печатает поле под подписью Наличные<br>`Engine.CheckRevolt` — [Source/Engine/CheckRevolt.asm](../Source/Engine/CheckRevolt.asm#L105) — оплата неподконтрольного отряда вычитает из#6A14
- `BaseIncome`: `Engine.TickTime` — [Source/Engine/TickTime.asm](../Source/Engine/TickTime.asm#L63) — сумма доходов замков, затем#6A19+#6A14 складываются и пишутся в#6A14<br>`Overlay.Treasure.Entry` — [Source/Overlays/Treasure.asm](../Source/Overlays/Treasure.asm#L278) — награда увеличивает#6A19
- `Army`: `Engine.BuildArmy` — [Source/Engine/BuildArmy.asm](../Source/Engine/BuildArmy.asm#L56) — C=(IX+1), B=(IX+2), ID=(IX+0), затем IX+=3 по #88DB<br>`Engine.GrowTroop` — [Source/Engine/GrowTroop.asm](../Source/Engine/GrowTroop.asm#L16) — сравнение ID и обновление количества +1/+2, IX+=3
- `Continent`: #63D9 — индекс выбирает KARTA?<br>`Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L58) — выбор континентального списка
- `X`: `Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L31) — BC=word(#6A2E), C=x,B=y
- `Y`: `Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L31) — BC=word(#6A2E), C=x,B=y
- `ShipMap`: `Overlay.City.Entry` — [Source/Overlays/City.asm](../Source/Overlays/City.asm#L308) — при отказе от корабля #6A30=#FF<br>`Engine.UpdateLocalView` — [Source/Engine/UpdateLocalView.asm](../Source/Engine/UpdateLocalView.asm#L222) — континент при размещении корабля
- `ShipX`: `Engine.MainLoop` — [Source/Engine/MainLoop.asm](../Source/Engine/MainLoop.asm#L45) — проверка #FF<br>`Overlay.City.Entry` — [Source/Overlays/City.asm](../Source/Overlays/City.asm#L306) — word(#6A31)=#FFFF при отказе от корабля
- `ShipY`: `Engine.UpdateLocalView` — [Source/Engine/UpdateLocalView.asm](../Source/Engine/UpdateLocalView.asm#L221) — координаты корабля BC=word(#6A31)
- `MoveFlags`: `Engine.StepMapTroops` — [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L77) — AND3 сверяется с водным битом группы<br>`Engine.MapMoveLeft` — [Source/Engine/MapMoveLeft.asm](../Source/Engine/MapMoveLeft.asm#L21) — запись горизонтальной ориентации<br>`Overlay.Info.Entry` — [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L143) — бит5 определяет сообщение об осадных орудиях<br>`Overlay.TakeOff.Entry` — [Source/Overlays/TakeOff.asm](../Source/Overlays/TakeOff.asm#L23) — переход к режиму полёта<br>`Overlay.Land.Entry` — [Source/Overlays/Land.asm](../Source/Overlays/Land.asm#L19) — выход из режима полёта
- `MapFlags`: `Overlay.Maps.Entry` — [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L28) — по биту текущего континента доступна полная карта<br>`Overlay.Sail.Entry` — [Source/Overlays/Sail.asm](../Source/Overlays/Sail.asm#L26) — из флагов строится список континентов
- `DayFraction`: `Engine.TickTime` — [Source/Engine/TickTime.asm](../Source/Engine/TickTime.asm#L20) — прибавляется стоимость шага#69D7, перенос увеличиваетword#6A36
- `Days`: `Engine.TickTime` — [Source/Engine/TickTime.asm](../Source/Engine/TickTime.asm#L24) — при переносе дробной части увеличивается на1<br>`Engine.PrintDate` — [Source/Engine/PrintDate.asm](../Source/Engine/PrintDate.asm#L22) — печать календаря
- `Deadline`: `Engine.TickTime` — [Source/Engine/TickTime.asm](../Source/Engine/TickTime.asm#L33) — DE=word#6A38, SBC HL,DE, только равенство вызывает #8799
- `Contract`: `Overlay.Info.Entry` — [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L129) — 35*номер от#BFE0 даёт имя замка<br>`Overlay.City.Entry` — [Source/Overlays/City.asm](../Source/Overlays/City.asm#L321) — ненулевой контракт запрещает новый
- `Cult`: `Overlay.Temple.Entry` — [Source/Overlays/Temple.asm](../Source/Overlays/Temple.asm#L42) — сравнение с типом храма<br>`Engine.RefreshHero` — [Source/Engine/RefreshHero.asm](../Source/Engine/RefreshHero.asm#L46) — наличие секты добавляет15000 к расходам
- `Unknown6A3C`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L163) — PERSONn загружается в #793C<br>`Engine.Initialize` — [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L30) — соответствие #7931→#69ED через сектор состояния, PERSON+0 соответствует #69F8
- `GoodX`: `Overlay.Friendly.Entry` — [Source/Overlays/Friendly.asm](../Source/Overlays/Friendly.asm#L24) — встреча переносит отметку рассказчика и обновляет координаты
- `GoodY`: `Overlay.Friendly.Entry` — [Source/Overlays/Friendly.asm](../Source/Overlays/Friendly.asm#L24) — координаты рассказчика
- `GoodMap`: `Engine.FindMapObject` — [Source/Engine/FindMapObject.asm](../Source/Engine/FindMapObject.asm#L15) — континент сверяется с текущим перед поиском специальной клетки
- `Unknown6A47`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L163) — PERSONn загружается в #793C<br>`Engine.Initialize` — [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L30) — соответствие #7931→#69ED через сектор состояния, PERSON+0 соответствует #69F8
- `GoodVisits`: `Overlay.Friendly.Entry` — [Source/Overlays/Friendly.asm](../Source/Overlays/Friendly.asm#L36) — счётчик встречи увеличивается и используется при выборе рассказа
- `BadX`: `Overlay.Hostile.Entry` — [Source/Overlays/Hostile.asm](../Source/Overlays/Hostile.asm#L24) — встреча переносит отметку рассказчика и обновляет координаты
- `BadY`: `Overlay.Hostile.Entry` — [Source/Overlays/Hostile.asm](../Source/Overlays/Hostile.asm#L24) — координаты рассказчика
- `BadMap`: `Engine.FindMapObject` — [Source/Engine/FindMapObject.asm](../Source/Engine/FindMapObject.asm#L15) — континент сверяется с текущим перед поиском специальной клетки
- `Unknown6A4E`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L163) — PERSONn загружается в #793C<br>`Engine.Initialize` — [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L30) — соответствие #7931→#69ED через сектор состояния, PERSON+0 соответствует #69F8
- `BadVisits`: `Overlay.Hostile.Entry` — [Source/Overlays/Hostile.asm](../Source/Overlays/Hostile.asm#L36) — счётчик встречи увеличивается и используется при выборе рассказа
- `Unknown6A52`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L163) — PERSONn загружается в #793C<br>`Engine.Initialize` — [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L30) — соответствие #7931→#69ED через сектор состояния, PERSON+0 соответствует #69F8
- `PuzzleOpen`: `Overlay.TargetMap.Entry` — [Source/Overlays/TargetMap.asm](../Source/Overlays/TargetMap.asm#L24) — подсчёт25открытых частей по пяти байтам
- `PuzzleTiles`: `Overlay.Victory.Entry` — [Source/Overlays/Victory.asm](../Source/Overlays/Victory.asm#L27) — сравнение массива с5x5стратегической карты
- `IdleDays`: `Engine.IndexFlagArray` — [Source/Engine/IndexFlagArray.asm](../Source/Engine/IndexFlagArray.asm#L12) — IX=#6A72+ID<br>`Engine.DevelopTroops` — [Source/Engine/DevelopTroops.asm](../Source/Engine/DevelopTroops.asm#L28) — увеличение счётчиков<br>`Engine.DevelopTroops` — [Source/Engine/DevelopTroops.asm](../Source/Engine/DevelopTroops.asm#L93) — чтение счётчика для сравнения с SOLDIERS+41
- `UpgradeCount`: `Engine.DevelopTroops` — [Source/Engine/DevelopTroops.asm](../Source/Engine/DevelopTroops.asm#L49) — чтение IX+25 при IX=#6A72+ID<br>`Engine.ClearTwoFlags` — [Source/Engine/ClearTwoFlags.asm](../Source/Engine/ClearTwoFlags.asm#L12) — оба массива сбрасываются для нового ID
- `Unknown6AA5`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L163) — PERSONn загружается в #793C<br>`Engine.Initialize` — [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L30) — соответствие #7931→#69ED через сектор состояния, PERSON+0 соответствует #69F8
- `Wins`: `Overlay.City.Entry` — [Source/Overlays/City.asm](../Source/Overlays/City.asm#L337) — word#6AA6 сравнивается с30<br>`Overlay.City.Entry` — [Source/Overlays/City.asm](../Source/Overlays/City.asm#L347) — участвует в проверке отношения кword#6AA8<br>`Battle.ResolveLosses` — [Source/Battle/ResolveLosses.asm](../Source/Battle/ResolveLosses.asm#L19)<br>`Overlay.City.Entry` — [Source/Overlays/City.asm](../Source/Overlays/City.asm#L23)
- `Losses`: `Overlay.City.Entry` — [Source/Overlays/City.asm](../Source/Overlays/City.asm#L341) — нулевое значение разрешает дальнейшую ветвь<br>`Overlay.City.Entry` — [Source/Overlays/City.asm](../Source/Overlays/City.asm#L349) — делитель отношенияword#6AA6/word#6AA8<br>`Battle.ResolveLosses` — [Source/Battle/ResolveLosses.asm](../Source/Battle/ResolveLosses.asm#L19)<br>`Overlay.City.Entry` — [Source/Overlays/City.asm](../Source/Overlays/City.asm#L23)
- `Attacker`: `Engine.TickCastle` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L45) — выбор новой/существующей угрозы<br>`Engine.TickCastle` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L92) — записывается владелец ближайшего другого замка
- `AttackDays`: `Engine.TickCastle` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L119) — запись20+R(15)<br>`Engine.TickCastle` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L200) — вычитание входного0/1 по факту дня
- `AttackCastle`: `Engine.TickCastle` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L75) — сохранение IX выбранного замка<br>`Overlay.Castle.Entry` — [Source/Overlays/Castle.asm](../Source/Overlays/Castle.asm#L45) — сравнение с текущим замком с поправкой на указатель имени
- `AttackArmy`: `Engine.TickCastle` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L122) — обнуление15байт<br>`Engine.TickCastle` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L149) — формирование FTroop<br>`Overlay.Castle.Entry` — [Source/Overlays/Castle.asm](../Source/Overlays/Castle.asm#L475) — IX=#6AAE перед боем
- `Unknown6ABD`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L163) — PERSONn загружается в #793C<br>`Engine.Initialize` — [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L30) — соответствие #7931→#69ED через сектор состояния, PERSON+0 соответствует #69F8
- `UnitControl`: `Engine.ControlLimit` — [Source/Engine/ControlLimit.asm](../Source/Engine/ControlLimit.asm#L20) — HL=#6AD3, затем прибавляется ID и читается байт-делитель<br>`Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L169) — PERSON7 сворачивает25пар диапазонов в25коэффициентов

Дополнительные свойства исходного реестра:

- `base`: 27128
- `source_files`: ["PERSON1", "PERSON2", "PERSON3", "PERSON4", "PERSON5", "PERSON6", "PERSON8"]
- `mapping_evidence`: [{"module": "S04", "address": 26400, "hex": "#6720", "operation": "PERSONn загружается в #793C"}, {"module": "S10", "address": 25432, "hex": "#6358", "operation": "соответствие #7931→#69ED через сектор состояния, PERSON+0 соответствует #69F8"}]

## FGameState

полный256байтный заголовок состояния, включает героя и глобальные события

Размер: **256** байт. Объявление: [Includes/Structs/GameState.inc](../Includes/Structs/GameState.inc#L8).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Hero` | `DB` | номер выбранного героя 1..8 |
| +#01 | 1 | `Difficulty` | `DB` | сложность 1..3 |
| +#02 | 8 | `SaveName` | `DS` | 8 символьное имя файла сохранения |
| +#0A | 1 | `Terminator` | `DB` | терминатор после имени файла |
| +#0B | 245 | `Person` | `FPerson` | FPerson, шаблон персонажа после нормализации PERSON7 |

Свидетельства для отдельных полей:

- `Hero`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L87) — результат выбора героя записывается#7931<br>`Engine.Initialize` — [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L57) — #69ED выбирает IP? для портрета
- `Difficulty`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L200) — #7932 определяет начальный предел дней5000/4000/3000<br>`Engine.TickCastle` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L127) — #69EE выбирает таблицу сложности NAEMARMY
- `SaveName`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L121) — ввод имени по#7933<br>`Engine.RefreshHero` — [Source/Engine/RefreshHero.asm](../Source/Engine/RefreshHero.asm#L140) — панель содержит указатель#69EF
- `Terminator`: `Engine.Initialize` — [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L29) — 256байт из банк3:#C700 копируются в #69ED<br>`Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L777) — первый блок сохранения начинается #7931, инверсия255байт и запись одного сектора
- `Person`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L163) — PERSONn загружается в #793C<br>`Engine.Initialize` — [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L30) — соответствие #7931→#69ED через сектор состояния, PERSON+0 соответствует #69F8

Дополнительные свойства исходного реестра:

- `base`: 27117
- `save_format`: первый сектор .M, первые255байт инвертируются #770B
- `mapping_evidence`: [{"module": "S10", "address": 25429, "hex": "#6355", "operation": "256байт из банк3:#C700 копируются в #69ED"}, {"module": "S04", "address": 27694, "hex": "#6C2E", "operation": "первый блок сохранения начинается #7931, инверсия255байт и запись одного сектора"}]

## FByteRange

пара диапазона коэффициента PERSON7

Размер: **2** байт. Объявление: [Includes/Structs/ByteRange.inc](../Includes/Structs/ByteRange.inc#L5).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Min` | `DB` | нижняя граница исходного диапазона |
| +#01 | 1 | `Max` | `DB` | верхняя граница исходного диапазона |

Свидетельства для отдельных полей:

- `Min`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L175) — из max вычитается min
- `Max`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L174) — A=(IX+1)

## FByteRangeA25

25 последовательных пар FByteRange

Размер: **50** байт. Объявление: [Includes/Structs/ByteRangeA25.inc](../Includes/Structs/ByteRangeA25.inc#L27).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 2 | `Item0` | `FByteRange` | элемент 0 |
| +#02 | 2 | `Item1` | `FByteRange` | элемент 1 |
| +#04 | 2 | `Item2` | `FByteRange` | элемент 2 |
| +#06 | 2 | `Item3` | `FByteRange` | элемент 3 |
| +#08 | 2 | `Item4` | `FByteRange` | элемент 4 |
| +#0A | 2 | `Item5` | `FByteRange` | элемент 5 |
| +#0C | 2 | `Item6` | `FByteRange` | элемент 6 |
| +#0E | 2 | `Item7` | `FByteRange` | элемент 7 |
| +#10 | 2 | `Item8` | `FByteRange` | элемент 8 |
| +#12 | 2 | `Item9` | `FByteRange` | элемент 9 |
| +#14 | 2 | `Item10` | `FByteRange` | элемент 10 |
| +#16 | 2 | `Item11` | `FByteRange` | элемент 11 |
| +#18 | 2 | `Item12` | `FByteRange` | элемент 12 |
| +#1A | 2 | `Item13` | `FByteRange` | элемент 13 |
| +#1C | 2 | `Item14` | `FByteRange` | элемент 14 |
| +#1E | 2 | `Item15` | `FByteRange` | элемент 15 |
| +#20 | 2 | `Item16` | `FByteRange` | элемент 16 |
| +#22 | 2 | `Item17` | `FByteRange` | элемент 17 |
| +#24 | 2 | `Item18` | `FByteRange` | элемент 18 |
| +#26 | 2 | `Item19` | `FByteRange` | элемент 19 |
| +#28 | 2 | `Item20` | `FByteRange` | элемент 20 |
| +#2A | 2 | `Item21` | `FByteRange` | элемент 21 |
| +#2C | 2 | `Item22` | `FByteRange` | элемент 22 |
| +#2E | 2 | `Item23` | `FByteRange` | элемент 23 |
| +#30 | 2 | `Item24` | `FByteRange` | элемент 24 |

## FPerson7

дисковый вариант PERSON7 до нормализации,270байт. Нельзя усекать как обычный PERSON без выполнения алгоритма

Размер: **270** байт. Объявление: [Includes/Structs/Person7.inc](../Includes/Structs/Person7.inc#L5).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 220 | `Prefix` | `DS` | первые 220 байт совпадают по расположению с FPerson до UnitControl |
| +#DC | 50 | `ControlRanges` | `FByteRangeA25` | 25 пар FByteRange, загрузчик заменяет каждую пару одним коэффициентом на месте и оставляет первые 245 байт как FPerson |

Свидетельства для отдельных полей:

- `Prefix`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L163) — PERSONn загружается в #793C<br>`Engine.Initialize` — [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L30) — соответствие #7931→#69ED через сектор состояния, PERSON+0 соответствует #69F8
- `ControlRanges`: `Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L169) — IX=HL=#7A18, B=25, IXшагает2, HLшагает1<br>`Startup.PromptGameDisk` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L178) — min+RandomScaled(max-min), дополнительно возможны удвоение или floor(значение/2)+1

## FSoldier

описатель типа существа, SOLDIERS, 25 записей

Размер: **42** байт. Объявление: [Includes/Structs/Soldier.inc](../Includes/Structs/Soldier.inc#L105).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 12 | `Name` | `DS` | имя CP866, дополненное пробелами |
| +#0C | 1 | `NameEnd` | `DB` | нулевой терминатор имени |
| +#0D | 1 | `MoveFlags` | `DB` | первый байт способностей, младшие 3 бита копируются в боевые флаги |
| +#0E | 1 | `ExtraFlags` | `DB` | второй байт флагов, возвращаемый в D без назначения всех битов |
| +#0F | 1 | `Actions` | `DB` | исходное число действий на раунд |
| +#10 | 1 | `ActionStock` | `DB` | запас расходуемого дальнего действия |
| +#11 | 1 | `SectID` | `DB` | секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость |
| +#12 | 1 | `SpawnClass` | `DB` | категория 1..4 при выборе начального типа |
| +#13 | 1 | `UpgradeID` | `DB` | ID замены по служебному порогу участия |
| +#14 | 1 | `DegradeID` | `DB` | ID замены при утрате квалификации, 0 запрещает замену |
| +#15 | 1 | `SpecialFlags` | `DB` | особые способности, ограничение восстановления и участие в перевозке |
| +#16 | 2 | `UnitValue` | `FWord` | вес одного воина в оценке армии и цене найма корабля |
| +#18 | 2 | `Upkeep` | `FWord` | расходы на содержание одного воина |
| +#1A | 2 | `BattleValue` | `FWord` | вес одного воина в общей оценке армии при начале и завершении боя |
| +#1C | 4 | `Unknown1C` | `DS` | четыре сохраняемых байта |
| +#20 | 2 | `SpawnCount` | `FWord` | начальная численность создаваемой шестибайтовой группы |
| +#22 | 2 | `DamageSpread` | `FWord` | слово разброса урона, удваивается только младший байт E без переноса в D |
| +#24 | 2 | `DamageDivisor` | `FWord` | делитель базовой формулы урона |
| +#26 | 1 | `SiteGrowthDiv` | `DB` | делитель недельного прироста в строениях и гарнизонах |
| +#27 | 1 | `ArmyGrowthDiv` | `DB` | делитель недельного прироста внешней армии и армии героя |
| +#28 | 1 | `UpgradeLimit` | `DB` | порог служебного счётчика для первой замены |
| +#29 | 1 | `DegradeDays` | `DB` | порог дней без боя, исходная ветвь требует также ненулевой DegradeID |

Свидетельства для отдельных полей:

- `Name`: SOLDIERS, меню #62D8
- `NameEnd`: SOLDIERS, #7117
- `MoveFlags`: head #7AEF, #883A
- `ExtraFlags`: head #7AEF
- `Actions`: head #883A, battle #F578
- `ActionStock`: head #883A, battle #D5BB
- `SectID`: head #896D/#89C7..#89D7, O03
- `SpawnClass`: BL3 #7808
- `UpgradeID`: head #9EF8..#9F18
- `DegradeID`: head #9F5B..#9F75
- `SpecialFlags`: battle #F2F1/#F337, O11:B200
- `UnitValue`: battle #E8AD, O02:B7EB
- `Upkeep`: head #9E86, включение в расходы #95F7
- `BattleValue`: battle #F4A3, #FAAF, head #89E0
- `Unknown1C`: исходная запись +#1C..+#1F
- `SpawnCount`: BL3 #7808 и потребитель генерации
- `DamageSpread`: battle #F15C..#F162, #F210..#F216, #F3AA..#F3B0
- `DamageDivisor`: battle #F166..#F16C, #F21A..#F220, #F38B
- `SiteGrowthDiv`: head #A136 -> #A204
- `ArmyGrowthDiv`: head #A190 -> #A204
- `UpgradeLimit`: head #9F01
- `DegradeDays`: head #9F64, скрытый редактор SOLDIERS

## FBattleUnit

рабочий отряд боя, две армии по 5 записей

Размер: **18** байт. Объявление: [Includes/Structs/BattleUnit.inc](../Includes/Structs/BattleUnit.inc#L69).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `UnitID` | `DB` | ID типа, 0 завершает плотный список |
| +#01 | 1 | `Affinity` | `DB` | знаковая совместимость состава от -2 до 2, для выбора поправки прибавляется 3 |
| +#02 | 5 | `Quantity` | `DS` | пятибайтовое число ROM, сохраняет дробные потери |
| +#07 | 1 | `BaseActions` | `DB` | число действий в начале раунда |
| +#08 | 1 | `ActionStock` | `DB` | остаток расходуемого дальнего действия |
| +#09 | 1 | `Flags` | `DB` | способности и временные отметки раунда, цели и контроля |
| +#0A | 1 | `X` | `DB` | колонка 0..7 |
| +#0B | 1 | `Y` | `DB` | строка 0..4 |
| +#0C | 1 | `ActionsLeft` | `DB` | оставшиеся действия текущего раунда |
| +#0D | 1 | `Effect` | `DB` | старшая тетрада вид эффекта, младшая оставшаяся длительность |
| +#0E | 2 | `InitialCount` | `FWord` | исходное целое количество, ограничивает восстановление |
| +#10 | 2 | `Unknown10` | `FWord` | два сохраняемых служебных байта |

Свидетельства для отдельных полей:

- `UnitID`: head #883A, battle #F864
- `Affinity`: head #896D, battle #D485..#D49B, #F17C..#F192
- `Quantity`: head #883A, battle #F0A0
- `BaseActions`: head #883A, battle #F578
- `ActionStock`: battle #D5BB, #E117
- `Flags`: battle #F556, #E0E8, #E7A5, #F62D
- `X`: battle #F65E
- `Y`: battle #F65E
- `ActionsLeft`: battle #D2B5, #F578
- `Effect`: battle #F5FF
- `InitialCount`: head #883A, battle #F337
- `Unknown10`: обнуление #883A и копирование записей #F864

## FMenuRect

прямоугольник пункта меню в знакоместах

Размер: **4** байт. Объявление: [Includes/Structs/MenuRect.inc](../Includes/Structs/MenuRect.inc#L7).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Left` | `DB` | левая включённая граница |
| +#01 | 1 | `Top` | `DB` | верхняя включённая граница |
| +#02 | 1 | `Right` | `DB` | правая исключённая граница |
| +#03 | 1 | `Bottom` | `DB` | нижняя исключённая граница |

Свидетельства для отдельных полей:

- `Left`: head #787E
- `Top`: head #787E
- `Right`: head #787E
- `Bottom`: head #787E

## FMenuHeader

фиксированная часть меню, далее N записей FMenuRect

Размер: **7** байт. Объявление: [Includes/Structs/MenuHeader.inc](../Includes/Structs/MenuHeader.inc#L10).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Count` | `DB` | число пунктов меню |
| +#01 | 1 | `MinX` | `DB` | минимальная X указателя |
| +#02 | 1 | `MinY` | `DB` | минимальная Y указателя |
| +#03 | 1 | `MaxX` | `DB` | максимальная X указателя |
| +#04 | 1 | `MaxY` | `DB` | максимальная Y указателя |
| +#05 | 1 | `CursorX` | `DB` | сохраняемая пиксельная X указателя |
| +#06 | 1 | `CursorY` | `DB` | сохраняемая пиксельная Y указателя |

Свидетельства для отдельных полей:

- `Count`: head #77A1/#787E
- `MinX`: head #77A1
- `MinY`: head #77A1
- `MaxX`: head #77A1
- `MaxY`: head #77A1
- `CursorX`: head #77A1/#791E
- `CursorY`: head #77A1/#791E

## FTile32

непрозрачный тайл или портрет 32 на 32 пикселя

Размер: **144** байт. Объявление: [Includes/Structs/Tile32.inc](../Includes/Structs/Tile32.inc#L5).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 128 | `Pixels` | `DS` | 32 строки по 4 байта пикселей, бит 7 слева |
| +#80 | 16 | `Attributes` | `DS` | 4 строки по 4 атрибута знакомест |

Свидетельства для отдельных полей:

- `Pixels`: head #7545/#75E1
- `Attributes`: head #7545/#75E1

## FMasked32

маскированный кадр 32 на 32 пикселя

Размер: **256** байт. Объявление: [Includes/Structs/Masked32.inc](../Includes/Structs/Masked32.inc#L5).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 128 | `Pixels` | `DS` | передний слой INK, 32 строки по 4 байта |
| +#80 | 128 | `Mask` | `DS` | маска, единица сохраняет соответствующий бит фона |

Свидетельства для отдельных полей:

- `Pixels`: head #75A2/#7649
- `Mask`: head #75A2/#7649

## FPictureHeader

заголовок RLE-изображения HERIMG, BL1 и BL2

Размер: **5** байт. Объявление: [Includes/Structs/PictureHeader.inc](../Includes/Structs/PictureHeader.inc#L29).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 2 | `NextOffset` | `FWord` | следующий заголовок равен текущий адрес +1+NextOffset |
| +#02 | 1 | `FirstThird` | `DB` | начальная треть экрана 0..2 |
| +#03 | 1 | `ThirdCount` | `DB` | число третей 1..3 |
| +#04 | 1 | `Flags` | `DB` | бит 0 задаёт порядок обхода пикселей, биты 2/3 рабочие |

Свидетельства для отдельных полей:

- `NextOffset`: распаковщик +#21..+#25
- `FirstThird`: распаковщик +#32
- `ThirdCount`: распаковщик +#3D
- `Flags`: распаковщик +#42, +#80, +#E4

## FFrameRef

ссылка на кадр в расширенной памяти

Размер: **3** байт. Объявление: [Includes/Structs/FrameRef.inc](../Includes/Structs/FrameRef.inc#L5).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Bank` | `DB` | логический банк графического ресурса |
| +#01 | 2 | `Address` | `FWord` | адрес кадра в окне памяти |

Свидетельства для отдельных полей:

- `Bank`: head #7366/#8104
- `Address`: head #7366/#8104

## FScreenObject20

экранная запись объекта, используется массивом State.ViewObjects

Размер: **20** байт. Объявление: [Includes/Structs/ScreenObject20.inc](../Includes/Structs/ScreenObject20.inc#L37).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Flags` | `DB` | младшие 5 бит режим 0..4, бит 5 численная подпись, биты 6/7 отражение |
| +#01 | 1 | `AnimationTimer` | `DB` | счётчик до следующего кадра, DEC, при 0 перезагрузка из+3 |
| +#02 | 1 | `AnimationFrame` | `DB` | текущий номер кадра 1..FrameCount, увеличивается перед выводом |
| +#03 | 1 | `AnimationPeriod` | `DB` | значение перезагрузки счётчика |
| +#04 | 1 | `FrameCount` | `DB` | число кадров, #7366 задаёт 4 |
| +#05 | 1 | `BaseBank` | `DB` | банк основного изображения |
| +#06 | 2 | `BaseAddress` | `FWord` | младший байт адреса первым |
| +#08 | 1 | `Frame1Bank` | `DB` | банк переднего слоя либо первого кадра |
| +#09 | 2 | `Frame1Address` | `FWord` | адрес переднего слоя либо первого кадра |
| +#0B | 1 | `Frame2Bank` | `DB` | банк второго кадра |
| +#0C | 2 | `Frame2Address` | `FWord` | адрес второго кадра |
| +#0E | 1 | `Frame3Bank` | `DB` | банк третьего кадра |
| +#0F | 2 | `Frame3Address` | `FWord` | адрес третьего кадра |
| +#11 | 1 | `Frame4Bank` | `DB` | банк четвёртого кадра |
| +#12 | 2 | `Frame4Address` | `FWord` | адрес четвёртого кадра |

Свидетельства для отдельных полей:

- `Flags`: head:#7366<br>head:#8104..#8242
- `AnimationTimer`: head:#7366<br>head:#8104..#8242
- `AnimationFrame`: head:#7366<br>head:#8104..#8242
- `AnimationPeriod`: head:#7366<br>head:#8104..#8242
- `FrameCount`: head:#7366<br>head:#8104..#8242
- `BaseBank`: head:#7366<br>head:#8104..#8242
- `BaseAddress`: head:#7366<br>head:#8104..#8242
- `Frame1Bank`: head:#7366<br>head:#8104..#8242
- `Frame1Address`: head:#7366<br>head:#8104..#8242
- `Frame2Bank`: head:#7366<br>head:#8104..#8242
- `Frame2Address`: head:#7366<br>head:#8104..#8242
- `Frame3Bank`: head:#7366<br>head:#8104..#8242
- `Frame3Address`: head:#7366<br>head:#8104..#8242
- `Frame4Bank`: head:#7366<br>head:#8104..#8242
- `Frame4Address`: head:#7366<br>head:#8104..#8242

Дополнительные свойства исходного реестра:

- `address`: 25969
- `count`: 48
- `grid`: {"columns": 8, "rows": 6, "cell_width": 32, "cell_height": 32, "formula": "6571+20*(row*8+column)", "battle_first_address": 26129}
- `modes`: {"0": "не выводить", "1": "основное изображение с атрибутами по+5/+6", "2": "основной маскированный слой по+5/+6, отражение задаёт бит7", "3": "непрозрачный фон по+5/+6 и маскированный слой по+8/+9", "4": "непрозрачный фон и текущий кадр из четырёх трёхбайтных описателей"}
- `flags`: {"bit5": "после выполненного вывода подписать число из6931+2*index", "bit6": "отражать передний маскированный слой в режимах3/4", "bit7": "отражать основной слой в режимах1/2/3/4"}
- `lifecycle`: после режимов1..3 младшие5бит сбрасываются, режим4 сохраняется
- `first_frame_note`: инициализация frame=1 и timer=1 в7366 даёт кадр2 при первом тике8104

## FMenuWindow

описатель окна скрытого меню

Размер: **7** байт. Объявление: [Includes/Structs/MenuWindow.inc](../Includes/Structs/MenuWindow.inc#L11).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `X` | `DB` | столбец окна в знакоместах |
| +#01 | 1 | `Y` | `DB` | строка окна в знакоместах |
| +#02 | 1 | `Width` | `DB` | ширина окна в знакоместах |
| +#03 | 1 | `Height` | `DB` | высота окна в знакоместах |
| +#04 | 1 | `ShadowAttr` | `DB` | атрибут смещённой тени |
| +#05 | 1 | `WindowAttr` | `DB` | атрибут основного прямоугольника |
| +#06 | 1 | `TextIndent` | `DB` | горизонтальный отступ текста в пикселях |

Основания и потребители: Loader.Menu.DrawWindow, FillWindowAttrs, DrawHBorder и PollMenu<br>`Loader.Menu.DrawWindow` — [Source/Loader/Menu/DrawWindow.asm](../Source/Loader/Menu/DrawWindow.asm#L19)<br>`Loader.Menu.FillWindowAttrs` — [Source/Loader/Menu/FillWindowAttrs.asm](../Source/Loader/Menu/FillWindowAttrs.asm#L14)<br>`Loader.Menu.DrawHBorder` — [Source/Loader/Menu/DrawHBorder.asm](../Source/Loader/Menu/DrawHBorder.asm#L15)<br>`Loader.Menu.PollMenu` — [Source/Loader/Menu/PollMenu.asm](../Source/Loader/Menu/PollMenu.asm#L17)

## FMenuArea

область выбора скрытого меню

Размер: **3** байт. Объявление: [Includes/Structs/MenuArea.inc](../Includes/Structs/MenuArea.inc#L23).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `XAndActive` | `DB` | столбец в битах 0..6, бит 7 хранит текущую подсветку, #FF завершает таблицу |
| +#01 | 1 | `Y` | `DB` | строка области |
| +#02 | 1 | `Width` | `DB` | ширина полосы атрибутов |

Основания и потребители: Loader.Menu.HighlightAreas и PollMenu<br>`Loader.Menu.HighlightAreas` — [Source/Loader/Menu/HighlightAreas.asm](../Source/Loader/Menu/HighlightAreas.asm#L17)<br>`Loader.Menu.PollMenu` — [Source/Loader/Menu/PollMenu.asm](../Source/Loader/Menu/PollMenu.asm#L17)

## FMenuCursor

рисунок и маска пиксельного курсора скрытого меню

Размер: **32** байт. Объявление: [Includes/Structs/MenuCursor.inc](../Includes/Structs/MenuCursor.inc#L6).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 16 | `Pixels` | `DS` | восемь двухбайтовых строк рисунка |
| +#10 | 16 | `Mask` | `DS` | восемь двухбайтовых строк маски, единица сохраняет фон |

Основания и потребители: Loader.Menu.DrawCursor, IX указывает в Pixels на очередную двухбайтовую строку и продвигается на2<br>`Loader.Menu.DrawCursor` — [Source/Loader/Menu/DrawCursor.asm](../Source/Loader/Menu/DrawCursor.asm#L17)

## FMusicChannel

состояние канала AY плеера меню

Размер: **10** байт. Объявление: [Includes/Structs/MusicChannel.inc](../Includes/Structs/MusicChannel.inc#L12).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `EnvelopeMode` | `DB` | 0 без огибающей, 1 включить её форму, 2 сохранять текущую форму |
| +#01 | 1 | `Duration` | `DB` | перезагрузка задержки чтения команд |
| +#02 | 1 | `Step` | `DB` | текущая позиция семпла, по модулю32 |
| +#03 | 1 | `Note` | `DB` | номер ноты |
| +#04 | 1 | `Wait` | `DB` | оставшаяся задержка чтения команд |
| +#05 | 2 | `Sample` | `FWord` | адрес данных выбранного семпла |
| +#07 | 2 | `Ornament` | `FWord` | адрес выбранного орнамента |
| +#09 | 1 | `Remaining` | `DB` | оставшиеся шаги семпла, #FF выключает канал |

Основания и потребители: Music.Menu.InitPlayer, StepDuration, DecodeChannel, StepSample, ApplyEnvelope, IX направлен на поле Step, то есть base+2<br>`Music.Menu.InitPlayer` — [Source/Loader/Music.asm](../Source/Loader/Music.asm#L56)<br>`Music.Menu.StepDuration` — [Source/Loader/Music.asm](../Source/Loader/Music.asm#L307)<br>`Music.Menu.DecodeChannel` — [Source/Loader/Music.asm](../Source/Loader/Music.asm#L376)<br>`Music.Menu.StepSample` — [Source/Loader/Music.asm](../Source/Loader/Music.asm#L475)<br>`Music.Menu.ApplyEnvelope` — [Source/Loader/Music.asm](../Source/Loader/Music.asm#L541)<br>`FMusicChannel.Step` — [Includes/Structs/MusicChannel.inc](../Includes/Structs/MusicChannel.inc#L6)

## FSampleStep

трёхбайтовый шаг музыкального семпла

Размер: **3** байт. Объявление: [Includes/Structs/SampleStep.inc](../Includes/Structs/SampleStep.inc#L39).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `ToneAndVolume` | `DB` | старшие четыре бита величины смещения тона и младшие четыре бита громкости |
| +#01 | 1 | `NoiseAndFlags` | `DB` | период шума0..31, бит5 знак смещения, бит6 запрет тона, бит7 запрет шума |
| +#02 | 1 | `ToneLow` | `DB` | младший байт смещения периода тона |

Основания и потребители: Music.Menu.ReadSampleStep<br>`Music.Menu.ReadSampleStep` — [Source/Loader/Music.asm](../Source/Loader/Music.asm#L207)

## FRleState

рабочие настройки самоперемещаемого распаковщика изображений

Размер: **4** байт. Объявление: [Includes/Structs/RleState.inc](../Includes/Structs/RleState.inc#L28).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Picture` | `DB` | номер изображения от1 |
| +#01 | 1 | `FirstThird` | `DB` | начальная треть экрана0..2, #FF брать значение из заголовка |
| +#02 | 1 | `ThirdCount` | `DB` | число третей экрана1..3, #FF брать значение из заголовка |
| +#03 | 1 | `Flags` | `DB` | бит0 порядок потока, бит2 активная RLE серия, бит3 вывод линейных атрибутов |

Основания и потребители: Graphics.Heroes/Graphics.BL1/Graphics.BL2 Draw и Unpack

## FStar

координаты звезды заставки

Размер: **2** байт. Объявление: [Includes/Structs/Star.inc](../Includes/Structs/Star.inc#L6).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Y` | `DB` | вертикальная пиксельная координата |
| +#01 | 1 | `X` | `DB` | горизонтальная пиксельная координата |

Основания и потребители: Presentation.Present.CheckDuplicate, InitStars и MoveStars<br>`Presentation.Present.CheckDuplicate` — [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L53)<br>`Presentation.InitStars` — [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L647)<br>`Presentation.MoveStars` — [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L689)

## FCreditLine

фиксированная часть строки титров, далее текст с нулём

Размер: **3** байт. Объявление: [Includes/Structs/CreditLine.inc](../Includes/Structs/CreditLine.inc#L7).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Attribute` | `DB` | цвет строки титров |
| +#01 | 1 | `X` | `DB` | столбец строки |
| +#02 | 1 | `Y` | `DB` | строка экрана |

Основания и потребители: Presentation.CreditLine и EraseCredit, IX+3 начинает текст переменной длины<br>`Presentation.CreditLine` — [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L434)<br>`Presentation.EraseCredit` — [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L475)

## FCityMessage

параметры сообщения об отношении города

Размер: **5** байт. Объявление: [Includes/Structs/CityMessage.inc](../Includes/Structs/CityMessage.inc#L7).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Attribute` | `DB` | атрибут нижнего окна |
| +#01 | 2 | `Position` | `FWord` | координаты BC печати сообщения |
| +#03 | 2 | `Text` | `FWord` | адрес текста сообщения |

Основания и потребители: Overlay.City.Entry.FindCityDesc, далее BottomFrame и PrintMessage<br>`Overlay.City.Entry.FindCityDesc` — [Source/Overlays/City.asm](../Source/Overlays/City.asm#L99)<br>`Engine.BottomFrame` — [Source/Engine/BottomFrame.asm](../Source/Engine/BottomFrame.asm#L12)<br>`Engine.PrintMessage` — [Source/Engine/PrintMessage.asm](../Source/Engine/PrintMessage.asm#L23)

## FRewardBand

порог и сотни базовой стоимости случайной награды

Размер: **2** байт. Объявление: [Includes/Structs/RewardBand.inc](../Includes/Structs/RewardBand.inc#L6).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Threshold` | `DB` | верхний порог случайного выбора |
| +#01 | 1 | `Hundreds` | `DB` | базовая стоимость награды в сотнях |

Основания и потребители: Overlay.Treasure.Entry.ChooseReward сравнивает случайный байт с Threshold, затем передаёт Hundreds в калькулятор и умножает на100<br>`Overlay.Treasure.Entry.ChooseReward` — [Source/Overlays/Treasure.asm](../Source/Overlays/Treasure.asm#L163)<br>`FRewardBand.Hundreds` — [Includes/Structs/RewardBand.inc](../Includes/Structs/RewardBand.inc#L5)

## FMapSite

общая координатная часть разных объектов карты

Размер: **3** байт. Объявление: [Includes/Structs/MapSite.inc](../Includes/Structs/MapSite.inc#L22).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Flags` | `DB` | бит0 выключает запись |
| +#01 | 1 | `X` | `DB` | столбец стратегической карты |
| +#02 | 1 | `Y` | `DB` | строка стратегической карты |

Основания и потребители: Overlay.Maps.MarkSiteList получает шаг записи от вызывающего кода, читает лишь первые3поля<br>`Overlay.Maps.MarkSiteList` — [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L795)

## FTrdosEntry

запись каталога TRDOS

Размер: **16** байт. Объявление: [Includes/Structs/TrdosEntry.inc](../Includes/Structs/TrdosEntry.inc#L11).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 8 | `Name` | `DS` | имя файла, первый байт0 конец каталога и1 удалённая запись |
| +#08 | 1 | `Type` | `DB` | тип файла |
| +#09 | 2 | `Start` | `FWord` | адрес загрузки |
| +#0B | 2 | `Length` | `FWord` | длина файла в байтах |
| +#0D | 1 | `Sectors` | `DB` | число секторов файла |
| +#0E | 1 | `Sector` | `DB` | начальный сектор |
| +#0F | 1 | `Track` | `DB` | начальная дорожка |

Основания и потребители: Loader.Menu.FindFile сверяет первые9байтов и копирует16байтов в #5CDD<br>`Loader.Menu.FindFile` — [Source/Loader/Menu/FindFile.asm](../Source/Loader/Menu/FindFile.asm#L16)

## FWeightedTroop

весовая запись выбора типа и численности случайного отряда

Размер: **6** байт. Объявление: [Includes/Structs/WeightedTroop.inc](../Includes/Structs/WeightedTroop.inc#L8).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `UnitID` | `DB` | идентификатор типа существа |
| +#01 | 1 | `Threshold` | `DB` | верхняя исключённая граница случайного выбора, равный порогу результат пропускает запись |
| +#02 | 2 | `BaseCount` | `FWord` | исходное количество существ |
| +#04 | 2 | `CountRange` | `FWord` | предел добавки, передаваемый RandomRange с округлением результата |

Основания и потребители: Startup.GenerateArmy и PromptGameDisk.TroopWeight сравнивают случайное A с порогом и складывают BaseCount с RandomRange(CountRange)<br>`Startup.GenerateArmy` — [Source/Startup/GenerateArmy.asm](../Source/Startup/GenerateArmy.asm#L20)<br>`Startup.PromptGameDisk.TroopWeight` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L627)

## FWeightedType

весовая запись выбора типа странствующей группы

Размер: **2** байт. Объявление: [Includes/Structs/WeightedType.inc](../Includes/Structs/WeightedType.inc#L6).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `UnitID` | `DB` | идентификатор типа существа |
| +#01 | 1 | `Threshold` | `DB` | верхняя исключённая граница случайного выбора |

Основания и потребители: Startup.CreateWanderers.WeightedType и UnitDescriptor, после выбора тип дополнительно проверяется по категории FSoldier<br>`Startup.CreateWanderers.WeightedType` — [Source/Startup/CreateWanderers.asm](../Source/Startup/CreateWanderers.asm#L64)<br>`Startup.CreateWanderers.UnitDescriptor` — [Source/Startup/CreateWanderers.asm](../Source/Startup/CreateWanderers.asm#L72)<br>`FSoldier` — [Includes/Structs/Soldier.inc](../Includes/Structs/Soldier.inc#L105)

## FArmyManaPool

последовательно расходуемая группа начальных магических параметров внешних армий

Размер: **5** байт. Объявление: [Includes/Structs/ArmyManaPool.inc](../Includes/Structs/ArmyManaPool.inc#L7).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Remaining` | `DB` | сколько создаваемых армий получают эту пару параметров, уменьшается при генерации |
| +#01 | 2 | `Mana` | `FWord` | начальная магическая сила внешней армии |
| +#03 | 2 | `ManaRegen` | `FWord` | пополнение магической силы внешней армии |

Основания и потребители: Startup.PromptGameDisk.ArmyLoop копирует байты 1..4 в FMapArmy.Mana/ManaRegen, уменьшает байт 0 и при нуле сдвигает указатель на 5<br>`Startup.PromptGameDisk.ArmyLoop` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L670)<br>`FMapArmy.Mana` — [Includes/Structs/MapArmy.inc](../Includes/Structs/MapArmy.inc#L30)<br>PromptGameDisk.ArmyGroups<br>PromptGameDisk.NextMapArmy<br>`Startup.PromptGameDisk.ArmyGroups` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L660)<br>`Startup.PromptGameDisk.NextMapArmy` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L718)

## FMoveStepA3

три кандидата движения, изменяемые процедурами Steps*

Размер: **9** байт. Объявление: [Includes/Structs/MoveStepA3.inc](../Includes/Structs/MoveStepA3.inc#L7).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 3 | `First` | `FMoveStep` | кандидат 1 |
| +#03 | 3 | `Second` | `FMoveStep` | кандидат 2 |
| +#06 | 3 | `Third` | `FMoveStep` | кандидат 3 |

Основания и потребители: MakeSteps создаёт подряд три FMoveStep, Steps* меняют их X/Y<br>`Engine.MakeSteps` — [Source/Engine/MakeSteps.asm](../Source/Engine/MakeSteps.asm#L16)<br>`FMoveStep` — [Includes/Structs/MoveStep.inc](../Includes/Structs/MoveStep.inc#L6)

## FPosition

упакованная пара координат или знаковых разностей X/Y

Размер: **2** байт. Объявление: [Includes/Structs/Position.inc](../Includes/Structs/Position.inc#L6).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `X` | `DB` | столбец либо горизонтальная разность |
| +#01 | 1 | `Y` | `DB` | строка либо вертикальная разность |

Основания и потребители: GetDirection сохраняет разности E-C/D-B, ApplyMoveCode сравнивает целевую пару с координатами замка<br>`Engine.GetDirection` — [Source/Engine/GetDirection.asm](../Source/Engine/GetDirection.asm#L15)<br>`Engine.ApplyMoveCode` — [Source/Engine/ApplyMoveCode.asm](../Source/Engine/ApplyMoveCode.asm#L14)

## FMapGroup

описатель группы при поиске занятой клетки

Размер: **5** байт. Объявление: [Includes/Structs/MapGroup.inc](../Includes/Structs/MapGroup.inc#L8).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 2 | `Lists` | `FWord` | адрес таблицы FMapList по континентам |
| +#02 | 1 | `Stride` | `DB` | размер записи объекта |
| +#03 | 1 | `Rows` | `DB` | число занимаемых строк карты |
| +#04 | 1 | `Columns` | `DB` | число занимаемых столбцов карты |

Основания и потребители: FindMapObject загружает IX из слова+0, DE из+2, B/C из+3/+4 для FindRecord<br>`Engine.FindMapObject` — [Source/Engine/FindMapObject.asm](../Source/Engine/FindMapObject.asm#L15)<br>`Engine.FindRecord` — [Source/Engine/FindRecord.asm](../Source/Engine/FindRecord.asm#L16)

## FOverlayKey

соответствие кода клавиши номеру оверлея

Размер: **2** байт. Объявление: [Includes/Structs/OverlayKey.inc](../Includes/Structs/OverlayKey.inc#L6).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Code` | `DB` | код команды, ноль завершает список |
| +#01 | 1 | `Overlay` | `DB` | номер загружаемого оверлея |

Основания и потребители: MainLoop.CommandLoop и ApplyMoveCode.CommandLoop обходят пары из State.OverlayKeys<br>`Engine.MainLoop.CommandLoop` — [Source/Engine/MainLoop.asm](../Source/Engine/MainLoop.asm#L23)<br>`Engine.ApplyMoveCode.CommandLoop` — [Source/Engine/ApplyMoveCode.asm](../Source/Engine/ApplyMoveCode.asm#L53)<br>`State.OverlayKeys` — [Includes/Address.inc](../Includes/Address.inc#L15)

## FKeyMap

пара преобразования кода клавиатуры

Размер: **2** байт. Объявление: [Includes/Structs/KeyMap.inc](../Includes/Structs/KeyMap.inc#L6).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Input` | `DB` | входной код клавиши |
| +#01 | 1 | `Output` | `DB` | код после преобразования |

Основания и потребители: RemapKey сравнивает вход с+0, возвращает+1<br>`Engine.RemapKey` — [Source/Engine/RemapKey.asm](../Source/Engine/RemapKey.asm#L12)

## FExpense

статья недельного расхода

Размер: **6** байт. Объявление: [Includes/Structs/Expense.inc](../Includes/Structs/Expense.inc#L24).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Flags` | `DB` | номер строки в битах 0..4, бит 6 активная статья, бит 7 статья выбрана для оплаты |
| +#01 | 5 | `Amount` | `FFloat5` | стоимость статьи в формате калькулятора |

Основания и потребители: TickTime/SumExpenses обходят запись с шагом6, бит6 активен, бит7 выбран для оплаты, биты0..4 строка экрана, Float5 начинается+1<br>`Engine.TickTime` — [Source/Engine/TickTime.asm](../Source/Engine/TickTime.asm#L18)

## FTroopRange

база и случайная добавка количества нападающего отряда

Размер: **4** байт. Объявление: [Includes/Structs/TroopRange.inc](../Includes/Structs/TroopRange.inc#L6).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 2 | `BaseCount` | `FWord` | исходное количество |
| +#02 | 2 | `CountRange` | `FWord` | предел случайной добавки |

Основания и потребители: TickCastle.BuildAttackers читает HL из+0/+1, DE из+2/+3, вызывает RandomScaled и складывает HL+DE<br>`Engine.TickCastle.BuildAttackers` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L152)<br>`Engine.RandomScaled` — [Source/Engine/RandomScaled.asm](../Source/Engine/RandomScaled.asm#L16)

## FLossRange

пределы потерь гарнизона по сложности

Размер: **2** байт. Объявление: [Includes/Structs/LossRange.inc](../Includes/Structs/LossRange.inc#L6).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Base` | `DB` | исходный процент потерь |
| +#01 | 1 | `Range` | `DB` | предел случайной добавки к проценту |

Основания и потребители: TickCastle после выбора Difficulty*2 передаёт+1 в RandomScaled и прибавляет+0<br>`Engine.TickCastle` — [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L42)<br>`Engine.RandomScaled` — [Source/Engine/RandomScaled.asm](../Source/Engine/RandomScaled.asm#L16)

## FBattleCell

кандидат соседней клетки, статус 0 свободно, 1 край/препятствие, 2 герой, 3 противник

Размер: **3** байт. Объявление: [Includes/Structs/BattleCell.inc](../Includes/Structs/BattleCell.inc#L7).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Status` | `DB` | 0 свободно, 1 край или препятствие, 2 армия героя, 3 армия противника |
| +#01 | 1 | `X` | `DB` | столбец клетки |
| +#02 | 1 | `Y` | `DB` | строка клетки |

Основания и потребители: BuildNeighbours, ClassifyCells<br>`Battle.BuildNeighbours` — [Source/Battle/BuildNeighbours.asm](../Source/Battle/BuildNeighbours.asm#L15)<br>`Battle.ClassifyCells` — [Source/Battle/ClassifyCells.asm](../Source/Battle/ClassifyCells.asm#L15)<br>BuildNeighbours<br>ClassifyCells

## FBattleCells

восемь кандидатов в порядке выбранного направления, First..Eighth не фиксированные стороны света

Размер: **24** байт. Объявление: [Includes/Structs/BattleCells.inc](../Includes/Structs/BattleCells.inc#L12).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 3 | `First` | `FBattleCell` | кандидат First |
| +#03 | 3 | `Second` | `FBattleCell` | кандидат Second |
| +#06 | 3 | `Third` | `FBattleCell` | кандидат Third |
| +#09 | 3 | `Fourth` | `FBattleCell` | кандидат Fourth |
| +#0C | 3 | `Fifth` | `FBattleCell` | кандидат Fifth |
| +#0F | 3 | `Sixth` | `FBattleCell` | кандидат Sixth |
| +#12 | 3 | `Seventh` | `FBattleCell` | кандидат Seventh |
| +#15 | 3 | `Eighth` | `FBattleCell` | кандидат Eighth |

Основания и потребители: NeighboursN, NeighboursNE, NeighboursE, NeighboursSE, NeighboursS, NeighboursSW, NeighboursW, NeighboursNW<br>`Battle.NeighboursN` — [Source/Battle/NeighboursN.asm](../Source/Battle/NeighboursN.asm#L16)<br>`Battle.NeighboursNE` — [Source/Battle/NeighboursNE.asm](../Source/Battle/NeighboursNE.asm#L16)<br>`Battle.NeighboursE` — [Source/Battle/NeighboursE.asm](../Source/Battle/NeighboursE.asm#L17)<br>`Battle.NeighboursSE` — [Source/Battle/NeighboursSE.asm](../Source/Battle/NeighboursSE.asm#L16)<br>`Battle.NeighboursS` — [Source/Battle/NeighboursS.asm](../Source/Battle/NeighboursS.asm#L16)<br>`Battle.NeighboursSW` — [Source/Battle/NeighboursSW.asm](../Source/Battle/NeighboursSW.asm#L16)<br>`Battle.NeighboursW` — [Source/Battle/NeighboursW.asm](../Source/Battle/NeighboursW.asm#L16)<br>`Battle.NeighboursNW` — [Source/Battle/NeighboursNW.asm](../Source/Battle/NeighboursNW.asm#L16)<br>NeighboursN<br>NeighboursNE<br>NeighboursE<br>NeighboursSE<br>NeighboursS<br>NeighboursSW<br>NeighboursW<br>NeighboursNW

## FBattleTarget

цель случайного действия, 2 герой, 3 противник, бит 7 исключает уже проверенную цель полёта

Размер: **3** байт. Объявление: [Includes/Structs/BattleTarget.inc](../Includes/Structs/BattleTarget.inc#L23).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Side` | `DB` | 2 армия героя, 3 армия противника, бит 7 исключает уже проверенную цель полёта |
| +#01 | 2 | `Unit` | `FWord` | указатель боевого отряда |

Основания и потребители: ListOtherUnits, RandomTarget, RunUncontrolled<br>`Battle.ListOtherUnits` — [Source/Battle/ListOtherUnits.asm](../Source/Battle/ListOtherUnits.asm#L13)<br>`Battle.RandomTarget` — [Source/Battle/RandomTarget.asm](../Source/Battle/RandomTarget.asm#L12)<br>`Battle.RunUncontrolled` — [Source/Battle/RunUncontrolled.asm](../Source/Battle/RunUncontrolled.asm#L16)<br>ListOtherUnits<br>RandomTarget<br>RunUncontrolled

## FBattleArmy

пять плотных записей армии боя

Размер: **90** байт. Объявление: [Includes/Structs/BattleArmy.inc](../Includes/Structs/BattleArmy.inc#L9).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 18 | `First` | `FBattleUnit` | боевой отряд First в массиве армии |
| +#12 | 18 | `Second` | `FBattleUnit` | боевой отряд Second в массиве армии |
| +#24 | 18 | `Third` | `FBattleUnit` | боевой отряд Third в массиве армии |
| +#36 | 18 | `Fourth` | `FBattleUnit` | боевой отряд Fourth в массиве армии |
| +#48 | 18 | `Fifth` | `FBattleUnit` | боевой отряд Fifth в массиве армии |

Основания и потребители: SelectActor<br>`Battle.SelectActor` — [Source/Battle/SelectActor.asm](../Source/Battle/SelectActor.asm#L25)

## FObstacleRows

скользящее окно трёх соседних масок строк для проверки общего препятствия

Размер: **3** байт. Объявление: [Includes/Structs/ObstacleRows.inc](../Includes/Structs/ObstacleRows.inc#L7).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `First` | `DB` | маска First строки в скользящем окне препятствий |
| +#01 | 1 | `Second` | `DB` | маска Second строки в скользящем окне препятствий |
| +#02 | 1 | `Third` | `DB` | маска Third строки в скользящем окне препятствий |

Основания и потребители: BuildField.TestMask<br>`Battle.BuildField.TestMask` — [Source/Battle/BuildField.asm](../Source/Battle/BuildField.asm#L51)

## FIntroTimers

интервал пиксельного сдвига и число сдвигов до следующей строки текста

Размер: **2** байт. Объявление: [Includes/Structs/IntroTimers.inc](../Includes/Structs/IntroTimers.inc#L6).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Scroll` | `DB` | счётчик до очередного пиксельного сдвига вводного текста |
| +#01 | 1 | `Line` | `DB` | число сдвигов до выбора следующей строки вводного текста |

Основания и потребители: TickIntroText

## FTownWeight

весовая запись выбора типа отряда в городе

Размер: **2** байт. Объявление: [Includes/Structs/TownWeight.inc](../Includes/Structs/TownWeight.inc#L6).

| смещение | размер | поле | тип | назначение |
| ---: | ---: | --- | --- | --- |
| +#00 | 1 | `Threshold` | `DB` | верхняя исключённая граница случайного выбора |
| +#01 | 1 | `UnitID` | `DB` | идентификатор предлагаемого городу типа существа |

Основания и потребители: Startup.PromptGameDisk.TownUnitWeight сравнивает A с первым байтом и получает UnitID из второго, порядок обратен FWeightedType<br>`Startup.PromptGameDisk.TownUnitWeight` — [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L401)<br>`FWeightedType` — [Includes/Structs/WeightedType.inc](../Includes/Structs/WeightedType.inc#L6)

[Оглавление документации](README.md)
