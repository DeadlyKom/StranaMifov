; оверлей 13 из OVR1
; исходный файл каталога 48, смещение #2F13
                module Overlay
                module Maps
                org #B200

; -----------------------------------------
; экран выбора трёх вариантов стратегической карты
; Очищает экран, печатает название текущего континента. Карта пройденного доступна всегда.
; Возможность полной карты вычисляет проверкой бита #6A34, номер бита зависит от #6A2D. Вид с
; высоты разрешает, если среди пяти отрядов есть описание с бит 2 E из #7AEF. В
; WaitMapKey.ViewModes сохраняет
; два бита доступности, в WaitMapKey.MenuCount число пунктов. Восстанавливает последний режим
; WaitMapKey.LastView при наличии
; соответствующей возможности. Пункты вызывают DrawExploredMap, DrawWorldMap или DrawAerialMap,
; выход восстанавливает
; основной экран.
; In:
;   #6A2D — континент, #6A2E/#6A2F — координаты, #6A34 — флаги карт, #6A1E — армия
; Out:
;   возврат после пункта выхода
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом меню #776D и восстановления основного
;   экрана #944A, сохранение входных регистров не предусмотрено
; Note:
;   экран, состояние меню WaitMapKey.TileCode..WaitMapKey.MenuCount, логические банки
; -----------------------------------------
Entry           CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                LD BC, #0000
                LD DE, #1820
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD BC, #0000
                LD DE, #061E
                LD A, #45
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #0101
                LD DE, #011E
                LD A, #46
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #0800
                LD DE, #0207
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD A, (State.Position)
                LD (WaitMapKey.HeroX), A
                LD A, (State.Position + FPosition.Y)
                LD (WaitMapKey.HeroY), A
                LD B, #09
                LD DE, Overlay.Maps.WaitMapKey.PositionText                     ; формат координат героя X и Y
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                XOR A
                LD (WaitMapKey.ViewModes), A
                LD HL, Engine.MainLoop.LandNameIndex                            ; смещённая база перед списком имён континентов, поиск начинает с INC HL, первое имя находится по #6992
                LD A, (State.Continent)
                LD B, A
.FindLandName   INC HL
                LD A, (HL)
                OR A
                JR NZ, .FindLandName                                            ; переход, если ещё не найден конец очередного названия континента

                DJNZ .FindLandName

                INC HL
                LD (WaitMapKey.ContinentText), HL
                LD DE, Overlay.Maps.WaitMapKey.LandNameText                     ; формат имени континента и пункта Возврат
                LD B, #01
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #0403
                LD DE, Overlay.Maps.WaitMapKey.ExploredText                     ; подпись Карта пройденного
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, #02
                LD (WaitMapKey.MenuCount), A
                LD A, (State.MapFlags)
                LD B, A
                LD A, (State.Continent)
                ADD A, #03
                SLA A
                SLA A
                SLA A
                OR #40
                LD (Entry.MapTestOp), A
                BIT MAP_INDEX_BIT, B                                            ; начальный номер бита шаблонов проверки и открытия карт континентов, фактический номер вычисляется из номера континента и переписывается в opcode
.MapTestOp      EQU $ - 1                                                       ; код проверки бита доступности полной карты континента
                JR Z, .CheckFlyers                                              ; переход, если полная карта текущего континента у героя отсутствует

                LD A, (WaitMapKey.MenuCount)
                INC A
                LD (WaitMapKey.MenuCount), A
                LD A, #01
                LD (WaitMapKey.ViewModes), A
                LD BC, #0503
                LD DE, Overlay.Maps.WaitMapKey.WorldMapText                     ; подпись Полная карта
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
.CheckFlyers    LD IX, State.Army
                LD B, #05

                ; вид с высоты разрешается при наличии в армии хотя бы одного типа с
                ; возможностью полёта
.ArmyUnit       LD A, (IX + FTroop.ID)
                OR A
                JR Z, .LastAerialMode                                           ; переход, если в заполненной части армии больше нет летающих типов

                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                BIT UNIT_FLY_BIT, E                                             ; флаг, тип существ способен летать
                JR NZ, .AddAerialMenu                                           ; переход, если найден летающий тип, открывающий вид с высоты

                INC IX
                INC IX
                INC IX
                DJNZ .ArmyUnit

                JR .LastAerialMode

.AddAerialMenu  LD A, (WaitMapKey.MenuCount)
                INC A
                LD (WaitMapKey.MenuCount), A
                ADD A, #02
                LD B, A
                LD C, #03
                LD DE, Overlay.Maps.WaitMapKey.AerialText                       ; подпись вида с высоты птичьего полёта
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (WaitMapKey.ViewModes)
                SET VIEW_AIR_BIT, A                                             ; флаг, в меню доступен вид с высоты, в армии найден летающий тип
                LD (WaitMapKey.ViewModes), A
.LastAerialMode LD A, (WaitMapKey.LastView)
                CP #03
                JR NZ, .LastWorldMode                                           ; переход, если сохранённый режим просмотра не является видом с высоты

                LD A, (WaitMapKey.ViewModes)
                BIT VIEW_AIR_BIT, A                                             ; флаг, в меню доступен вид с высоты, в армии найден летающий тип
                JR Z, .ExploredMode                                             ; переход, если сохранённый вид с высоты сейчас недоступен

                CALL DrawAerialMap
                JR .ChooseMap

.LastWorldMode  CP #02
                JR NZ, .ExploredMode                                            ; переход, если сохранённый режим просмотра не является полной картой

                LD A, (WaitMapKey.ViewModes)
                BIT VIEW_WORLD_BIT, A                                           ; флаг, в меню доступна полная карта текущего континента
                JR Z, .ExploredMode                                             ; переход, если сохранённый режим полной карты сейчас недоступен

                CALL DrawWorldMap
                JR .ChooseMap

.ExploredMode   CALL DrawExploredMap
.ChooseMap      LD IX, WaitMapKey.MenuCount
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #01
                JR NZ, .ExploredChoice                                          ; переход, если выбран не выход из просмотра карт

                LD BC, #0000
                LD DE, #1820
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                CALL Engine.RefreshPanels                                       ; перерисовать верхнюю строку и боковую панель игры
                CALL Engine.SaveOverlay                                         ; сохранить изменённую рабочую копию оверлея в банк хранения
                RET

.ExploredChoice CP #02
                JR NZ, .WorldChoice                                             ; переход, если выбран не просмотр разведанной области

                CALL DrawExploredMap
                JR .ChooseMap

.WorldChoice    CP #03
                JR NZ, .AerialChoice                                            ; переход, если выбран не просмотр полной карты

                LD A, (WaitMapKey.ViewModes)
                BIT VIEW_WORLD_BIT, A                                           ; флаг, в меню доступна полная карта текущего континента
                JR Z, .AerialChoice                                             ; переход, если полная карта континента ещё не открыта

                CALL DrawWorldMap
                JR .ChooseMap

.AerialChoice   CALL DrawAerialMap
                JR .ChooseMap

; -----------------------------------------
; рисование увеличенного участка карты пройденного
; Задаёт режим 1. От текущей позиции вычитает 12 по строке и 20 по столбцу, ограничивая начало
; диапазона строкой 0..73 и столбцом 0..118. Проходит участок 26x42 клетки. IsCellExplored
; проверяет бит
; открытия клетки. Неоткрытые клетки рисует специальным четырёхбайтовым образцом #B475. Для
; открытых проверяет три таблицы объектов через #8D6E, применяет специальный образец объекта #B479
; или определяет образец ландшафта через MapCellPattern. XorMiniTile выводит клетку 4x4 пикселя.
; Затем мигает
; клеткой героя с XOR и ждёт действия.
; In:
;   координаты героя, стратегическая карта и отдельная маска открытия
; Out:
;   на экране фрагмент 42x26, затем возврат
; Corrupt:
;   HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены
; Note:
; DrawExploredMap.ViewCellPos..DrawExploredMap.MiniRow — рабочая и относительная позиция, экран,
; банк 11
; -----------------------------------------
DrawExploredMap LD A, #01
                LD (WaitMapKey.LastView), A
                LD BC, #0809
                LD DE, #0E15
                LD A, #46
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #090A
                LD DE, #0115
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #0913
                LD DE, Overlay.Maps.WaitMapKey.ExploredText                     ; подпись Карта пройденного
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #0A0A
                LD DE, #0D15
                XOR A
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, (State.Position)
                LD A, B
                SUB #0C
                JR NC, .ClampRow                                                ; переход, если верхняя граница обзорного окна не вышла за начало карты

                XOR A
.ClampRow       CP #4A
                JR C, .ClampedRow                                               ; переход, если верхняя граница обзорного окна ещё допускает его полную высоту

                LD A, #49
.ClampedRow     LD B, A
                LD A, C
                SUB #14
                JR NC, .ClampColumn                                             ; переход, если левая граница обзорного окна не вышла за начало карты

                XOR A
.ClampColumn    CP #77
                JR C, .ClampedColumn                                            ; переход, если левая граница обзорного окна ещё допускает его полную ширину

                LD A, #76
.ClampedColumn  LD C, A
                LD (WaitMapKey.ViewOrigin), BC
                LD HL, #0000
                LD (DrawExploredMap.ViewCellPos), BC
                LD (DrawExploredMap.MiniCell), HL
                LD D, #1A
.MapRow         LD E, #2A
                LD BC, (DrawExploredMap.ViewCellPos)
                PUSH BC

                ; миниатюра исследованного мира скрывает клетки, отсутствующие в маске разведки
.MapCell        PUSH DE
                LD BC, (DrawExploredMap.ViewCellPos)
                CALL Engine.ReadMapCell                                         ; прочитать байт клетки текущей карты
                LD (WaitMapKey.TileCode), A
                CALL IsCellExplored
                JR NZ, .CastleMark                                              ; переход, если клетка разведана и можно проверить её объекты

                LD DE, Overlay.Maps.DrawExploredMap.CastlePattern               ; четырёхбайтный узор замка на миникарте
                JR .DrawCell

.CastleMark     XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD HL, (DrawExploredMap.ViewCellPos)
                LD IX, State.CastlesIndex
                LD DE, #0023
                LD BC, #0203
                CALL Engine.FindRecord                                          ; найти активную запись группы, покрывающую координату HL
                OR A
                JR NZ, .UnknownCell                                             ; переход, если на клетке обнаружен замок

                LD HL, (DrawExploredMap.ViewCellPos)
                LD IX, State.TemplesIndex
                LD DE, #0005
                LD BC, #0202
                CALL Engine.FindRecord                                          ; найти активную запись группы, покрывающую координату HL
                OR A
                JR NZ, .UnknownCell                                             ; переход, если на клетке обнаружен храм

                LD HL, (DrawExploredMap.ViewCellPos)
                LD IX, State.TownsIndex
                LD DE, #001A
                LD BC, #0101
                CALL Engine.FindRecord                                          ; найти активную запись группы, покрывающую координату HL
                OR A
                JR Z, .TerrainCell                                              ; переход, если на клетке нет города и достаточно узора местности

.UnknownCell    LD DE, Overlay.Maps.DrawExploredMap.UnknownPattern              ; четырёхбайтный узор неоткрытой клетки миникарты
                JR .DrawCell

.TerrainCell    LD A, (WaitMapKey.TileCode)
                CALL MapCellPattern
.DrawCell       CALL XorMiniTile
                LD BC, (DrawExploredMap.ViewCellPos)
                INC C
                LD (DrawExploredMap.ViewCellPos), BC
                LD BC, (DrawExploredMap.MiniCell)
                INC C
                LD (DrawExploredMap.MiniCell), BC
                POP DE
                DEC E
                JR NZ, .MapCell                                                 ; переход, если в текущей строке миникарты остаются клетки

                LD BC, (DrawExploredMap.MiniCell)
                INC B
                LD C, #00
                LD (DrawExploredMap.MiniCell), BC
                POP BC
                INC B
                LD (DrawExploredMap.ViewCellPos), BC
                DEC D
                JP NZ, .MapRow                                                  ; переход, если в миникарте остаются строки

                LD BC, #0A0A
                LD DE, #0D15
                LD A, #46
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD HL, (WaitMapKey.ViewOrigin)
                LD BC, (State.Position)
                LD A, B
                SUB H
                LD B, A
                LD A, C
                SUB L
                LD C, A
                LD (DrawExploredMap.MiniCell), BC
                LD BC, (State.Position)
                CALL Engine.ReadMapCell                                         ; прочитать байт клетки текущей карты
                CALL MapCellPattern

                ; маркер текущей позиции мигает до ввода пользователя
.WaitBlink      PUSH DE
                CALL XorMiniTile
                HALT
                HALT
                CALL Engine.ReadInput                                           ; прочитать клавиатуру или Kempston
                POP DE
                JR NC, .WaitBlink                                               ; переход, если пользователь ещё не завершил просмотр карты

                CALL WaitMapKey
                RET

.ViewCellPos    DW #0000                                                        ; координаты исходной клетки обзорного окна
.MiniCell       DB #00                                                          ; координаты текущей клетки миникарты
.MiniRow        DB #00                                                          ; строка текущей клетки миникарты
                DB #50, #A0, #50, #A0, #F0, #70, #A0, #D0
                DB #00, #50, #00, #A0, #50, #D0, #A0, #B0
                DB #F0, #D0, #B0, #F0, #F0, #F0, #F0, #F0
.CastlePattern  EQU $                                                           ; четырёхбайтный узор замка на миникарте
.UnknownPattern EQU $+4                                                         ; четырёхбайтный узор неоткрытой клетки миникарты
                DB #00, #00, #00, #00, #00, #60, #60, #00

; -----------------------------------------
; выбор четырёхбайтового образца ландшафта малой карты
; Оставляет в A младшие шесть битов клетки, классифицирует их через #8697. От
; DrawExploredMap.ViewCellPos делает A шагов
; по 4 байта и возвращает адрес образца в DE. Классификатор должен вернуть допустимый ненулевой
; индекс, иначе счётчик DEC A оборачивается.
; In:
;   A — байт стратегической клетки
; Out:
;   DE — адрес четырёх строк образца
; Corrupt:
;   HL, DE, AF. BC, HL', DE', BC', AF', IX, IY сохранены
; Note:
;   HL, DE, AF
; -----------------------------------------
MapCellPattern  AND #3F
                CALL Engine.TerrainBattle                                       ; преобразовать местность по второй таблице порогов
                LD HL, DrawExploredMap.ViewCellPos
                LD DE, #0004
.FindPattern    ADD HL, DE
                DEC A
                JR NZ, .FindPattern                                             ; переход, если адрес нужного рисунка местности ещё не достигнут

                EX DE, HL
                RET

; -----------------------------------------
; проверка отдельного бита открытия стратегической клетки
; Выбирает банк 11. Расчёт #B7B7+map*#0834+21*(row+1)+floor(column/8) равен
; #C000+(map-1)*2100+row*21+floor(column/8). Самомодифицирует номер бита команды BIT как 7-(column
; mod8). На один континент приходится 100 строк по 21 байту, четыре континента занимают 8400
; байтов.
; In:
;   DrawExploredMap.ViewCellPos — column, #B45A — row, #6A2D — map 1..4
; Out:
;   Z=1 клетка не открыта, Z=0 открыта, HL адрес байта маски
; Corrupt:
;   HL, DE, BC, AF. HL', DE', BC', AF', IX, IY сохранены
; Note:
;   логический банк 11, операнд BIT по IsCellExplored.ExploreTestOp, HL, DE, BC, AF
; -----------------------------------------
IsCellExplored  LD A, #0B
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD HL, Runtime.ExploreIndex                                     ; смещённая база четырёх битовых карт открытия
                LD DE, #0834
                LD A, (State.Continent)
                LD B, A
.ContinentMask  ADD HL, DE
                DJNZ .ContinentMask

                LD BC, (DrawExploredMap.ViewCellPos)
                LD DE, #0015
                INC B
.MaskRow        ADD HL, DE
                DJNZ .MaskRow

                LD E, C
                SRL E
                SRL E
                SRL E
                ADD HL, DE
                LD A, C
                AND #07
                XOR #07
                SLA A
                SLA A
                SLA A
                OR #46
                LD (IsCellExplored.ExploreTestOp), A
                BIT FOG_INDEX_BIT, (HL)                                         ; начальный номер бита шаблона проверки разведки, фактический номер 7-(X AND 7) переписывается в opcode
.ExploreTestOp  EQU $ - 1                                                       ; операнд инструкции проверки бита разведки
                RET

; -----------------------------------------
; XOR-вывод одной клетки малой карты размером 4x4
; Из относительных координат DrawExploredMap.MiniCell/DrawExploredMap.MiniRow вычисляет экранный
; адрес с началом #484A. Чётная и
; нечётная строка клетки разделяют знакоместо по вертикали, нечётный столбец поворачивает образец
; на четыре бита для другой половины байта. Четыре байта DE объединяет с экраном через XOR,
; переходя к следующей пиксельной строке INC H. Повторный вызов с тем же образцом убирает
; изображение.
; In:
;   DE — четыре байта образца, DrawExploredMap.MiniCell=column, DrawExploredMap.MiniRow=row
; Out:
;   DE после образца, четыре строки экрана изменены
; Corrupt:
;   HL, DE, BC, AF. HL', DE', BC', AF', IX, IY сохранены
; Note:
;   экран, HL, DE, BC, AF, при нулевом B после SRL цикл DJNZ делает 256 итераций с модульным
;   итоговым адресом
; -----------------------------------------
XorMiniTile     PUSH DE
                LD HL, Screen.Pixels + #084A                                    ; пиксельное начало окна миникарты и вида с высоты, строка 80, байтовый столбец 10
                LD DE, #0020
                LD BC, (DrawExploredMap.MiniCell)
                SRL B
                SRL C
.FindScreenRow  LD A, L
                ADD A, #20
                LD L, A
                JR NC, .ColumnOffset                                            ; переход, если адрес строки миникарты остаётся в текущей трети экрана

                LD A, H
                ADD A, #08
                LD H, A
.ColumnOffset   DJNZ .FindScreenRow

                ADD HL, BC
                LD A, (DrawExploredMap.MiniRow)
                BIT ROW_ODD_BIT, A                                              ; младший разряд номера строки миникарты, нечётная строка выбирает вторую половину знакоместа
                JR Z, .TilePattern                                              ; переход, если клетки не требуют чередования половин четырёхбитного узора

                LD A, H
                ADD A, #04
                LD H, A
.TilePattern    LD A, (DrawExploredMap.MiniCell)
                LD C, A
                POP DE
                LD B, #04
.PatternRow     LD A, (DE)
                BIT COL_ODD_BIT, C                                              ; младший разряд столбца миникарты, нечётный столбец требует перестановки полубайтов узора
                JR Z, .MergePixels                                              ; переход, если узор клетки не требует зеркального обмена полубайтов

                RRCA
                RRCA
                RRCA
                RRCA
.MergePixels    XOR (HL)
                LD (HL), A
                INC H
                INC DE
                DJNZ .PatternRow

                RET

; -----------------------------------------
; полная карта континента с просмотром замков
; Задаёт режим 2, очищает окно. Проходит 100x161 клетку банк 10, #C000, переключая один экранный
; пиксель только при (клетка AND #3F)=0 либо >=9. Рисует перекрестие героя и три группы объектов
; через MarkKnownSites. По таблице замков континента получает число замков, выводит название
; выбранного и
; мигающую рамку. Клавиши с кодами #12/#22 листают замки по кругу, #20 завершает просмотр и
; восстанавливает заголовки основного меню карт.
; In:
;   карта континента, таблицы объектов, координаты героя
; Out:
;   выбранный индекс замка DrawWorldMap.CastleIndex сохранён
; Corrupt:
;   HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены
; Note:
; экран, DrawWorldMap.CastleIndex..DrawWorldMap.BlinkState, WaitMapKey.LastView, рабочие
; самомодифицируемые операнды
; -----------------------------------------
DrawWorldMap    LD A, #02
                LD (WaitMapKey.LastView), A
                LD BC, #0809
                LD DE, #0E15
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #0915
                LD DE, Overlay.Maps.WaitMapKey.WorldMapText                     ; подпись Полная карта
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #0A0A
                LD DE, #0D15
                XOR A
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                CALL Engine.SelectMapBank                                       ; выбрать логический банк 10 с текущей картой
                LD HL, Runtime.CurrentMap                                       ; карта выбранного континента в логическом банке 10
                LD D, #52
                LD B, #64
.TerrainRow     LD E, #54
                LD C, #A1

                ; младшие шесть бит клетки выбирают, нужно ли отмечать её пикселем на общей карте
.TerrainCell    LD A, (HL)
                AND #3F
                JR Z, .MaybePlotCell                                            ; переход, если код местности равен нулю и пиксель карты нужно показать

                CP #09
.MaybePlotCell  CALL NC, XorMapPixel                                            ; вызов, если код местности равен 0 либо находится вне водного диапазона 1..8
                INC E
                INC HL
                DEC C
                JR NZ, .TerrainCell                                             ; переход, если в строке полной карты остаются клетки

                INC D
                DJNZ .TerrainRow

                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD BC, #0A0A
                LD DE, #0D15
                LD A, #4C
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD A, (State.Position)
                ADD A, #54
                LD E, A
                LD D, #50
                LD B, #68
.SideBorder     CALL XorMapPixel
                INC D
                DJNZ .SideBorder

                LD A, (State.Position + FPosition.Y)
                ADD A, #52
                LD D, A
                LD E, #50
                LD B, #A8
.TopBorder      CALL XorMapPixel
                INC E
                DJNZ .TopBorder

                LD IX, State.CastlesIndex
                LD A, (State.Continent)
                CALL Engine.IndexFourBytes                                      ; сместить IX к четырёхбайтной записи с индексом A
                LD A, (IX + FMapList.Count.Low)
                LD (DrawWorldMap.CastleCount), A
                LD BC, #0000
                LD DE, #061E
                LD A, #45
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #02
                LD DE, Overlay.Maps.DrawWorldMap.CastleHelp                     ; подсказки выбора предыдущего и следующего замка
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                CALL ShowCastleName
.BeginBlink     CALL MarkKnownSites
                LD B, #0E
                XOR A
                LD (DrawWorldMap.BlinkState), A
.BlinkWait      HALT
                PUSH BC
                CALL BlinkCastle
                POP BC
                CALL Engine.ReadInput                                           ; прочитать клавиатуру или Kempston
                JR C, .KeyPause                                                 ; переход, если во время мигания замка поступил ввод пользователя

                DJNZ .BlinkWait

                JR .BeginBlink

.KeyPause       LD B, #06
.PauseFrame     HALT
                DJNZ .PauseFrame

                PUSH AF
                LD A, (DrawWorldMap.BlinkState)
                OR A
                CALL NZ, BlinkCastle                                            ; вызов, если отметка замка сейчас включена и её нужно погасить перед обработкой ввода
                POP AF
                LD BC, (DrawWorldMap.CastleIndex)
                CP #22
                JR NZ, .CheckPrevFort                                           ; переход, если нажата не команда выбора следующего замка #22

                LD A, (DrawWorldMap.CastleIndex)
                INC A
                LD B, A
                LD A, (DrawWorldMap.CastleCount)
                CP B
                JR NC, .NextCastle                                              ; переход, если следующий номер не превышает число отображаемых замков

                LD B, #01
.NextCastle     LD A, B
                LD (DrawWorldMap.CastleIndex), A
                CALL ShowCastleName
                JR .BeginBlink

.CheckPrevFort  CP #12
                JR NZ, .CheckLegend                                             ; переход, если нажата не команда выбора предыдущего замка #12

                LD A, (DrawWorldMap.CastleIndex)
                DEC A
                JR NZ, .PrevCastle                                              ; переход, если предыдущий номер замка не вышел ниже единицы

                LD A, (DrawWorldMap.CastleCount)
.PrevCastle     LD (DrawWorldMap.CastleIndex), A
                CALL ShowCastleName
                JR .BeginBlink

.CheckLegend    CP #20
                JR NZ, .BeginBlink                                              ; переход, если нажата не команда возвращения к легенде #20

                LD BC, #0000
                LD DE, #061E
                LD A, #45
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #0101
                LD DE, #011E
                LD A, #46
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD A, #05
                LD (DrawWorldMap.LegendRow), A
                LD DE, Overlay.Maps.WaitMapKey.LandNameText                     ; формат имени континента и пункта Возврат
                LD B, #01
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #0403
                LD DE, Overlay.Maps.WaitMapKey.ExploredText                     ; подпись Карта пройденного
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (WaitMapKey.ViewModes)
                BIT VIEW_WORLD_BIT, A                                           ; флаг, в меню доступна полная карта текущего континента
                JR Z, .AerialLegend                                             ; переход, если полная карта недоступна и её строка легенды не нужна

                LD BC, #0503
                LD DE, Overlay.Maps.WaitMapKey.WorldMapText                     ; подпись Полная карта
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, #06
                LD (DrawWorldMap.LegendRow), A
.AerialLegend   LD A, (WaitMapKey.ViewModes)
                BIT VIEW_AIR_BIT, A                                             ; флаг, в меню доступен вид с высоты, в армии найден летающий тип
                RET Z                                                           ; выход, если вид с высоты недоступен и его строка легенды не нужна

                LD BC, #0503
.LegendRow      EQU $ - 1                                                       ; операнд номера нижней строки легенды
                LD DE, Overlay.Maps.WaitMapKey.AerialText                       ; подпись вида с высоты птичьего полёта
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                RET

.CastleHelp     EQU $                                                           ; подсказки выбора предыдущего и следующего замка
                DB #5B, #49, #5D, #20, #2D, #20, #AF, #E0
                DB #A5, #A4, #EB, #A4, #E3, #E9, #A8, #A9
                DB #20, #A7, #A0, #AC, #AE, #AA, #0D, #03
                DB #5B, #50, #5D, #20, #2D, #20, #E1, #AB
                DB #A5, #A4, #E3, #EE, #E9, #A8, #A9, #20
                DB #A7, #A0, #AC, #AE, #AA, #0D, #03, #5B
                DB #53, #70, #61, #63, #65, #5D, #20, #2D
                DB #20, #A2, #EB, #E5, #AE, #A4, #0D, #03
.OwnCastleText  EQU $+1                                                         ; формат имени собственного замка
                DB #00, #82, #A0, #E8, #20, #A7, #A0, #AC
                DB #AE, #AA, #3A, #20, #0E
.OwnCastleName  DW #0000                                                        ; адрес подписи собственного замка
.OtherCastle    EQU $+3                                                         ; формат имени чужого замка
                DB #0D, #2A, #00, #97, #E3, #A6, #AE, #A9
                DB #20, #A7, #A0, #AC, #AE, #AA, #3A, #20
                DB #0E
.OtherFortName  DW #0000                                                        ; адрес подписи чужого замка
                DB #0D, #2A, #00
.CastleIndex    DB #01                                                          ; индекс выбранного на полной карте замка
.CastleCount    DB #00                                                          ; число отображаемых замков
.BlinkState     DB #00                                                          ; ненулевое значение означает показанную мигающую рамку замка

; -----------------------------------------
; получение записи выбранного замка континента
; Через таблицу #6AE9 и текущий континент получает указатель массива замков. К нему прибавляет
; (DrawWorldMap.CastleIndex-1)*35. Индекс должен быть 1..число замков.
; In:
;   #6A2D — континент, DrawWorldMap.CastleIndex — выбранный замок 1..N
; Out:
;   IX — начало 35-байтовой записи замка
; Corrupt:
;   HL, DE, AF, IX. BC, HL', DE', BC', AF', IY сохранены
; Note:
;   HL, DE, AF, IX
; -----------------------------------------
GetCastleRecord LD IX, State.CastlesIndex
                LD A, (State.Continent)
                CALL Engine.IndexFourBytes                                      ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                PUSH HL
                POP IX
                LD DE, #0023
                LD A, (DrawWorldMap.CastleIndex)
.CastleLoop     DEC A
                RET Z                                                           ; выход, если указатель дошёл до выбранной записи замка

                ADD IX, DE
                JR .CastleLoop

; -----------------------------------------
; вывод имени и принадлежности выбранного замка на полной карте
; Получает запись GetCastleRecord, подставляет адрес имени IX+3 в строки. Владелец IX+19=0
; выбирает подпись
; «Ваш замок» и зелёный атрибут, иначе «Чужой замок» и другой атрибут. Очищает строку и печатает
; результат.
; In:
;   состояние выбора замка
; Out:
;   строка имени обновлена
; Corrupt:
;   HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены
; Note:
;   экран, указатели строк DrawWorldMap.OwnCastleName/DrawWorldMap.OtherFortName
; -----------------------------------------
ShowCastleName  CALL GetCastleRecord
                PUSH IX
                POP DE
                INC DE
                INC DE
                INC DE
                LD (DrawWorldMap.OwnCastleName), DE
                LD (DrawWorldMap.OtherFortName), DE
                LD A, (IX + FCastle.Owner)
                OR A
                LD DE, Overlay.Maps.DrawWorldMap.OwnCastleText                  ; формат имени собственного замка
                LD A, #44
                JR Z, .PrintFortName                                            ; переход, если выбранный замок принадлежит герою

                LD DE, Overlay.Maps.DrawWorldMap.OtherCastle                    ; формат имени чужого замка
                LD A, #42
.PrintFortName  PUSH DE
                LD BC, #0601
                LD DE, #011E
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                POP DE
                LD B, #06
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                RET

; -----------------------------------------
; переключение мигающей рамки выбранного замка
; Получает координаты IX+1/IX+2 выбранного замка. С экранными смещениями x+83, y+81 четырнадцатью
; вызовами XorMapPixel обводит прямоугольник 5x4 пикселя. Инвертирует байт
; DrawWorldMap.BlinkState, позволяя снять рамку
; при завершении ожидания.
; In:
;   выбранный замок
; Out:
;   DrawWorldMap.BlinkState инвертирован
; Corrupt:
;   HL, DE, AF, IX. BC, HL', DE', BC', AF', IY сохранены, XorMapPixel восстанавливает рабочие регистры
;   после каждого пикселя
; Note:
;   экран, HL, DE, AF, IX
; -----------------------------------------
BlinkCastle     CALL GetCastleRecord
                LD A, (IX + FCastle.X)
                ADD A, #53
                LD E, A
                LD A, (IX + FCastle.Y)
                ADD A, #51
                LD D, A
                CALL XorMapPixel
                INC E
                CALL XorMapPixel
                INC E
                CALL XorMapPixel
                INC E
                CALL XorMapPixel
                INC E
                CALL XorMapPixel
                INC D
                CALL XorMapPixel
                INC D
                CALL XorMapPixel
                INC D
                CALL XorMapPixel
                DEC E
                CALL XorMapPixel
                DEC E
                CALL XorMapPixel
                DEC E
                CALL XorMapPixel
                DEC E
                CALL XorMapPixel
                DEC D
                CALL XorMapPixel
                DEC D
                CALL XorMapPixel
                LD A, (DrawWorldMap.BlinkState)
                CPL
                LD (DrawWorldMap.BlinkState), A
                RET

; -----------------------------------------
; нанесение трёх групп строений на полную карту
; По очереди передаёт MarkSiteList таблицы #6AE9, #6B09, #6AF9 с шагами записей 35, 5, 26 и
; размерами
; отметок 3x2, 2x2, 1x1. Тем самым каждый объект использует отдельный размер отметки при общем
; алгоритме.
; In:
;   текущий континент и таблицы объектов
; Out:
;   отметки нанесены
; Corrupt:
;   HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены
; Note:
;   экран, HL, DE, BC, AF, IX
; -----------------------------------------
MarkKnownSites  LD IX, State.CastlesIndex
                LD DE, #0023
                LD BC, #0203
                CALL MarkSiteList
                LD IX, State.TemplesIndex
                LD DE, #0005
                LD BC, #0202
                CALL MarkSiteList
                LD IX, State.TownsIndex
                LD DE, #001A
                LD BC, #0101
                CALL MarkSiteList
                RET

; -----------------------------------------
; нанесение активных записей одной таблицы объектов на полную карту
; Самомодифицирует шаг и размеры отметки. По континенту получает указатель массива и число
; записей. Пропускает запись при бит 0 её первого байта. Для остальных по координатам +1/+2 и
; смещениям 84/82 выводит прямоугольник одиночных XOR-пикселей.
; In:
;   IX — четырёхбайтовый дескриптор континентов, DE — шаг записи, B — высота, C — ширина отметки
; Out:
;   все доступные записи пройдены
; Corrupt:
;   HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены
; Note:
; операнды MarkSiteList.SiteRows/MarkSiteList.SiteColumns/MarkSiteList.SiteStride, экран, HL,
; DE, BC, AF, IX
; -----------------------------------------
MarkSiteList    LD (MarkSiteList.SiteStride), DE
                LD A, B
                LD (MarkSiteList.SiteRows), A
                LD A, C
                LD (MarkSiteList.SiteColumns), A
                LD A, (State.Continent)
                CALL Engine.IndexFourBytes                                      ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                LD B, (IX + FMapList.Count.Low)
                PUSH HL
                POP IX

                ; неактивные записи объектов пропускаются, действующие показываются небольшими
                ; отметками
.SiteRecord     BIT SITE_OFF_BIT, (IX + FMapSite.Flags)                         ; флаг, запись объекта карты выключена из общего обхода
                JR NZ, .NextSite                                                ; переход, если очередная запись объекта помечена неактивной

                PUSH BC
                LD A, (IX + FMapSite.X)
                ADD A, #54
                LD E, A
                LD A, (IX + FMapSite.Y)
                ADD A, #52
                LD D, A
                LD B, #00
.SiteRows       EQU $ - 1                                                       ; операнд высоты отметки объекта на полной карте
.SiteRow        LD C, #00
.SiteColumns    EQU $ - 1                                                       ; операнд ширины отметки объекта на полной карте
                PUSH DE
.SitePixel      CALL XorMapPixel
                INC E
                DEC C
                JR NZ, .SitePixel                                               ; переход, если отметка объекта содержит ещё пиксели для инвертирования

                POP DE
                INC D
                DJNZ .SiteRow

                POP BC
.NextSite       LD DE, #0000
.SiteStride     EQU $ - 2                                                       ; операнд размера записи отображаемой группы объектов
                ADD IX, DE
                DJNZ .SiteRecord

                RET

; -----------------------------------------
; инверсия одного экранного пикселя полной карты
; Из D=y, E=x вычисляет стандартный нелинейный адрес ZX Spectrum и маску #80>>(x mod8). XOR меняет
; ровно один пиксель. HL, BC, AF сохраняет на стеке, DE непосредственно не меняет.
; In:
;   D — y, E — x
; Out:
;   HL, DE, BC, AF сохранены
; Corrupt:
;   Нет, HL, DE, BC, AF, HL', DE', BC', AF', IX, IY сохранены, DE используется только как
;   источник координат и не изменяется
; Note:
;   один пиксель экрана
; -----------------------------------------
XorMapPixel     PUSH HL
                PUSH BC
                PUSH AF
                PUSH DE
                POP BC
                LD HL, #0200
                SLA B
                RL H
                SLA B
                RL H
                LD A, B
                AND #E0
                LD L, A
                LD A, B
                RRCA
                RRCA
                AND #07
                SLA H
                SLA H
                SLA H
                OR H
                LD H, A
                LD A, C
                AND #07
                SRL C
                SRL C
                SRL C
                LD B, #00
                ADD HL, BC
                INC A
                LD B, A
                XOR A
                SCF
.RotatePixel    RRA
                DJNZ .RotatePixel

                XOR (HL)
                LD (HL), A
                POP AF
                POP BC
                POP HL
                RET

; -----------------------------------------
; вид с высоты птичьего полёта
; Задаёт режим 3. Выбирает область 13x21 клетка вокруг героя, начало ограничено row0..86,
; column0..139. Для каждой клетки берёт восьмибайтовую текстуру по младшим шести битам. При бит 6
; клетки поворачивает строки текстуры на два бита. Атрибут для бит 7 равен #52, иначе берётся из
; таблицы по классификации ландшафта. У клетки героя устанавливает FLASH в атрибутах, ждёт
; действия.
; In:
;   текущая стратегическая карта, координаты героя
; Out:
;   на экране 21x13 знакомест
; Corrupt:
;   HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены
; Note:
; экран и атрибуты, WaitMapKey.TilePosition/WaitMapKey.ViewOrigin, WaitMapKey.LastView,
; логические банки
; -----------------------------------------
DrawAerialMap   LD A, #03
                LD (WaitMapKey.LastView), A
                LD BC, #0809
                LD DE, #0E15
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #090D
                LD DE, Overlay.Maps.WaitMapKey.AerialText                       ; подпись вида с высоты птичьего полёта
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, (State.Position)
                LD A, B
                SUB #06
                JR NC, .ClampRow                                                ; переход, если верхняя граница вида с высоты не вышла за начало карты

                XOR A
.ClampRow       CP #57
                JR C, .ClampedRow                                               ; переход, если верхняя граница вида с высоты допускает его полную высоту

                LD A, #56
.ClampedRow     LD B, A
                LD A, C
                SUB #0A
                JR NC, .ClampColumn                                             ; переход, если левая граница вида с высоты не вышла за начало карты

                XOR A
.ClampColumn    CP #8C
                JR C, .ClampedColumn                                            ; переход, если левая граница вида с высоты допускает его полную ширину

                LD A, #8B
.ClampedColumn  LD C, A
                LD (WaitMapKey.ViewOrigin), BC
                LD A, #0B
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD HL, Screen.Pixels + #084A                                    ; пиксельное начало окна миникарты и вида с высоты, строка 80, байтовый столбец 10
                LD IX, Screen.Attributes + #014A                                ; атрибуты окна вида с высоты, строка 10, столбец 10
                LD D, #0D
.TileRow        LD E, #15
                PUSH HL
                PUSH BC
.TileCell       PUSH DE
                PUSH HL
                PUSH HL
                LD (WaitMapKey.TilePosition), BC
                CALL Engine.ReadMapCell                                         ; прочитать байт клетки текущей карты
                LD (WaitMapKey.TileCode), A
                AND #3F
                JR NZ, .PatternIndex                                            ; переход, если клетка имеет ненулевой код местности и может прямо выбрать рисунок

                LD HL, Overlay.Maps.WaitMapKey.TilePatterns                     ; восемь восьмибайтных узоров местности для вида с высоты
                JR .CopyTile

.PatternIndex   DEC A
                AND #07
                SLA A
                SLA A
                SLA A
                LD HL, Overlay.Maps.WaitMapKey.TilePatterns                     ; восемь восьмибайтных узоров местности для вида с высоты
                LD D, #00
                LD E, A
                ADD HL, DE
.CopyTile       EX DE, HL
                POP HL
                LD B, #08
                LD A, (WaitMapKey.TileCode)
                LD C, A

                ; бит 6 клетки меняет ориентацию исходного рисунка при выводе вида с высоты
.TileScanline   LD A, (DE)
                BIT MAP_MIRROR_BIT, C                                           ; флаг, тайл клетки стратегической карты выводится с горизонтальным отражением
                JR Z, .WriteScanline                                            ; переход, если клетка не требует зеркального разворота строки тайла

                RLCA
                RLCA
.WriteScanline  LD (HL), A
                INC H
                INC DE
                DJNZ .TileScanline

                LD A, (WaitMapKey.TileCode)
                BIT MAP_BUSY_BIT, A                                             ; флаг, клетка стратегической карты занята объектом
                JR Z, .TileAttribute                                            ; переход, если клетка не содержит объект и специальный атрибут не нужен

                LD A, #52
                JR .StoreAttribute

.TileAttribute  AND #3F
                CALL Engine.TerrainBattle                                       ; преобразовать местность по второй таблице порогов
                LD HL, Overlay.Maps.WaitMapKey.TileAttrs                        ; атрибуты классов местности для вида с высоты
                LD D, #00
                LD E, A
                ADD HL, DE
                LD A, (HL)
.StoreAttribute LD (IX + #00), A
                POP HL
                POP DE
                LD BC, (WaitMapKey.TilePosition)
                INC C
                INC HL
                INC IX
                DEC E
                JP NZ, .TileCell                                                ; переход, если в текущей строке вида с высоты остаются клетки

                LD BC, #000B
                ADD IX, BC
                POP BC
                INC B
                POP HL
                LD A, L
                ADD A, #20
                LD L, A
                JR NC, .NextTileRow                                             ; переход, если следующая строка тайлов остаётся в текущей трети экрана

                LD A, H
                ADD A, #08
                LD H, A
.NextTileRow    DEC D
                JP NZ, .TileRow                                                 ; переход, если в виде с высоты остаются строки тайлов

                LD HL, (WaitMapKey.ViewOrigin)
                LD BC, (State.Position)
                LD A, B
                SUB H
                LD B, A
                LD A, C
                SUB L
                LD C, A
                LD HL, Screen.Attributes + #012A                                ; смещённая на строку вверх база отметки героя в окне вида с высоты
                LD DE, #0020
                INC B
.FindHeroRow    ADD HL, DE
                DJNZ .FindHeroRow

                ADD HL, BC
                SET ATTR_FLASH_BIT, (HL)                                        ; флаг, атрибут знакоместа мигает, используется для отметки героя в виде с высоты
                CALL WaitMapKey
                RET

; -----------------------------------------
; ожидание действия с десятикадровой задержкой после ввода
; Повторяет #6BF1 до CF=1. Затем выполняет десять HALT и возвращается, снижая вероятность
; повторного использования одного нажатия.
; In:
;   разрешённые прерывания
; Out:
;   получен ввод и прошли 10 прерываний
; Corrupt:
;   BC, AF. HL, DE, HL', DE', BC', AF', IX, IY сохранены, B используется как счётчик десяти HALT
; Note:
;   BC, AF
; -----------------------------------------
WaitMapKey      CALL Engine.ReadInput                                           ; прочитать клавиатуру или Kempston
                JR NC, WaitMapKey                                               ; переход, если пользователь ещё не нажал клавишу закрытия карты

                LD B, #0A
.KeyDelay       HALT
                DJNZ .KeyDelay

                RET

.TileCode       DB #00                                                          ; полный код текущей клетки местности
.TilePosition   DW #0000                                                        ; координаты текущей клетки вида с высоты
; -----------------------------------------
; Overlay.Maps.WaitMapKey.ViewModes
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | AV | WM |
;   +----+----+----+----+----+----+----+----+
;
;   флаги:
;   AV       [1] - флаг, в меню доступен вид с высоты, в армии найден летающий тип
;     VIEW_AIR_BIT
;   WM       [0] - флаг, в меню доступна полная карта текущего континента
;     VIEW_WORLD_BIT
; -----------------------------------------
.ViewModes      DB #00                                                          ; бит0 доступна полная карта, бит1 доступен вид с высоты
                DB #00
.ViewOrigin     DW #0000                                                        ; координаты начала обзорного окна
.LastView       DB #01                                                          ; последний режим просмотра карты
.MenuCount      DB #02                                                          ; число доступных режимов в меню карты
                DB #0A, #18, #ED, #38, #32, #18, #01, #03
                DB #1F, #04, #01, #04, #1F, #05, #01, #05
.LandNameText   EQU $+6                                                         ; формат имени континента и пункта Возврат
                DB #1F, #06, #01, #06, #1F, #07, #0E
.ContinentText  DW #0000                                                        ; адрес названия текущего континента
                DB #0D, #2A, #0D, #00, #82, #AE, #A7, #A2
.WorldMapText   EQU $+6                                                         ; подпись Полная карта
                DB #E0, #A0, #E2, #0D, #03, #00, #8F, #AE
                DB #AB, #AD, #A0, #EF, #20, #AA, #A0, #E0
.AerialText     EQU $+3                                                         ; подпись вида с высоты птичьего полёта
                DB #E2, #A0, #00, #82, #A8, #A4, #20, #E1
                DB #20, #A2, #EB, #E1, #AE, #E2, #EB, #20
                DB #AF, #E2, #A8, #E7, #EC, #A5, #A3, #AE
                DB #20, #AF, #AE, #AB, #A5, #E2, #A0, #00
.ExploredText   EQU $                                                           ; подпись Карта пройденного
                DB #8A, #A0, #E0, #E2, #A0, #20, #AF, #E0
                DB #AE, #A9, #A4, #A5, #AD, #AD, #AE, #A3
.PositionText   EQU $+2                                                         ; формат координат героя X и Y
                DB #AE, #00, #58, #3D, #0F
.HeroX          DB #00                                                          ; координата героя для текста
                DB #00, #00, #0D, #03, #59, #3D, #0F
.HeroY          DB #00                                                          ; координата героя для текста
.TilePatterns   EQU $+5                                                         ; восемь восьмибайтных узоров местности для вида с высоты
                DB #00, #00, #0D, #03, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #C0, #C0, #C0
                DB #C0, #C0, #C0, #C0, #C0, #FF, #FF, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #FF, #FF, #C0, #C0, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #C0, #C0, #C0, #C0, #C0
                DB #C0, #C0, #C0, #FF, #FF, #FF, #FF, #C0
.TileAttrs      EQU $+4                                                         ; атрибуты классов местности для вида с высоты
                DB #C0, #C0, #C0, #C0, #C0, #30, #3E, #26
                DB #1E, #2E, #0E, #6F, #76, #65, #72, #6C
                DB #61, #79

                assert $ = #B9B6
                endmodule
                endmodule
