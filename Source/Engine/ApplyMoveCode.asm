
; -----------------------------------------
; применить уже полученный код движения к позиции героя
; вход A, BC загружается #6A2E, восемь кодов направлений вызывают ограничивающие процедуры
; #8BDD/#8BF2/#8BF9/#8C15, затем общая проверка #8AA5, используется и автодвижением #7F40
; In:
;   AF, A уже полученный код направления/команды, остальные данные как у #8A2C
; Out:
;   теже результаты движения, что у #8A2C, нереализованный/запрещённый шаг может перейти
;   непосредственно к ожиданию клавиши
; Corrupt:
;   HL, DE, BC, AF, IX, IY, состояние движения и стек при выходах через #8BE4/#8C39
; -----------------------------------------
ApplyMoveCode   LD BC, (State.Position)
                CP #13
                JR NZ, .CheckNorth                                              ; переход, если команда не задаёт шаг вверх-влево

                CALL MapMoveUp                                                  ; уменьшить строку героя в пределах рабочей части карты
                CALL MapMoveLeft                                                ; уменьшить столбец героя и повернуть его влево
                JP .CheckMoveMode

.CheckNorth     CP #1B
                JR NZ, .CheckNorthEast                                          ; переход, если команда не задаёт шаг вверх

                CALL MapMoveUp                                                  ; уменьшить строку героя в пределах рабочей части карты
                JP .CheckMoveMode

.CheckNorthEast CP #23
                JR NZ, .CheckWest                                               ; переход, если команда не задаёт шаг вверх-вправо

                CALL MapMoveUp                                                  ; уменьшить строку героя в пределах рабочей части карты
                CALL MapMoveRight                                               ; увеличить столбец героя и повернуть его вправо
                JP .CheckMoveMode

.CheckWest      CP #12
                JR NZ, .CheckEast                                               ; переход, если команда не задаёт шаг влево

                CALL MapMoveLeft                                                ; уменьшить столбец героя и повернуть его влево
                JP .CheckMoveMode

.CheckEast      CP #22
                JR NZ, .CheckSouthWest                                          ; переход, если команда не задаёт шаг вправо

                CALL MapMoveRight                                               ; увеличить столбец героя и повернуть его вправо
                JP .CheckMoveMode

.CheckSouthWest CP #11
                JR NZ, .CheckSouth                                              ; переход, если команда не задаёт шаг вниз-влево

                CALL MapMoveDown                                                ; увеличить строку героя в пределах рабочей части карты
                CALL MapMoveLeft                                                ; уменьшить столбец героя и повернуть его влево
                JP .CheckMoveMode

.CheckSouth     CP #19
                JR NZ, .CheckSouthEast                                          ; переход, если команда не задаёт шаг вниз

                CALL MapMoveDown                                                ; увеличить строку героя в пределах рабочей части карты
                JP .CheckMoveMode

.CheckSouthEast CP #21
                JR NZ, .FindCommand                                             ; переход, если команда не задаёт шаг вниз-вправо

                CALL MapMoveDown                                                ; увеличить строку героя в пределах рабочей части карты
                CALL MapMoveRight                                               ; увеличить столбец героя и повернуть его вправо
                JP .CheckMoveMode

.FindCommand    LD IX, State.OverlayKeys
                LD B, A
.CommandLoop    LD A, (IX + FOverlayKey.Code)
                OR A
                JP Z, HandleMapInput                                            ; переход, если достигнут конец таблицы команд

                CP B
                RET Z                                                           ; выход, если код совпал с командой оверлея

                INC IX
                INC IX
                JR .CommandLoop

                ; проверка режима перемещения перед обработкой новой клетки
.CheckMoveMode  LD A, (State.MoveFlags)
                AND #03
                CP #02
                JP NZ, .CheckTarget                                             ; переход, если герой находится не в режиме полёта

                LD (State.Position), BC
                LD A, #05
                LD (State.StepCost), A
                XOR A
                RET

                ; проверка занятой клетки и входа в область замка
.CheckTarget    LD (Engine.ApplyMoveCode.TargetPos), BC
                CALL ReadMapCell                                                ; прочитать байт клетки текущей карты
                BIT MAP_BUSY_BIT, A                                             ; клетка стратегической карты занята объектом
                JP Z, .TargetTerrain                                            ; переход, если целевая клетка не помечена занятой

                XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD IX, State.CastlesIndex
                LD A, (State.Continent)
                CALL IndexFourBytes                                             ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                LD B, (IX + FMapList.Count.Low)
                PUSH HL
                POP IX
                LD IY, Engine.ApplyMoveCode.TargetPos
.CastleLoop     BIT CASTLE_OFF_BIT, (IX + FCastle.Flags)                        ; замок выключен из обходов стратегических объектов и подсчёта владений
                JR NZ, .NextCastle                                              ; переход, если замок исключён из обработки

                PUSH BC
                LD C, (IX + FCastle.X)
                LD B, (IX + FCastle.Y)
                LD L, #01
                LD D, #02
.CastleRow      LD E, #03
.CastleColumn   LD A, C
                CP (IY + FPosition.X)
                JR NZ, .NextColumn                                              ; переход, если столбец проверяемой клетки не совпал с целью

                LD A, B
                CP (IY + FPosition.Y)
                JR NZ, .NextColumn                                              ; переход, если строка проверяемой клетки не совпала с целью

                POP BC
                LD A, L
                CP #05
                JR Z, .TargetTerrain                                            ; переход, если цель совпала с центральной клеткой замка

                JP HandleMapInput

.NextColumn     INC L
                INC C
                DEC E
                JR NZ, .CastleColumn                                            ; переход, если в строке области замка остались клетки

                LD C, (IX + FCastle.X)
                INC B
                DEC D
                JR NZ, .CastleRow                                               ; переход, если в области замка остались строки

                POP BC
.NextCastle     LD DE, #0023
                ADD IX, DE
                DJNZ .CastleLoop

                ; сравнение местности исходной и целевой клеток перед сменой способа движения
.TargetTerrain  LD BC, (Engine.ApplyMoveCode.TargetPos)
                CALL ReadMapCell                                                ; прочитать байт клетки текущей карты
                AND #3F
                LD (Engine.ApplyMoveCode.TargetTile), A
                CP #01
                JR C, .SetTargetFlag                                            ; переход, если тип целевой местности ниже диапазона суши

                CP #09
                JR NC, .SetTargetFlag                                           ; переход, если тип целевой местности выше диапазона суши

                XOR A
                JR .SaveTargetFlag

.SetTargetFlag  LD A, #01
.SaveTargetFlag LD (Engine.ApplyMoveCode.TargetWater), A
                LD BC, (State.Position)
                CALL ReadMapCell                                                ; прочитать байт клетки текущей карты
                AND #3F
                LD (Engine.ApplyMoveCode.SourceTerrain), A
                CP #01
                JR C, .SetSourceFlag                                            ; переход, если тип исходной местности ниже диапазона суши

                CP #09
                JR NC, .SetSourceFlag                                           ; переход, если тип исходной местности выше диапазона суши

                XOR A
                JR .SaveSourceFlag

.SetSourceFlag  LD A, #01
.SaveSourceFlag LD (Engine.ApplyMoveCode.SourceWater), A
                LD A, (Engine.ApplyMoveCode.TargetWater)
                OR A
                JR Z, .CheckShipMove                                            ; переход, если целевая клетка относится к суше

                LD A, (Engine.ApplyMoveCode.SourceWater)
                OR A
                JR Z, .FilterTroops                                             ; переход, если исходная клетка относится к суше

                CALL MoveMask                                                   ; получить маску по текущему байту местности
                CALL FilterArmy                                                 ; отфильтровать армию по маске местности и обновить записи
                JR .CommitPosition

                ; проверка состава армии при переходе между сушей и водой
.FilterTroops   CALL MoveMask                                                   ; получить маску по текущему байту местности
                CALL FilterArmy                                                 ; отфильтровать армию по маске местности и обновить записи
                LD A, (State.MoveFlags)
                AND #FC
                LD (State.MoveFlags), A
                JR .CommitPosition

.CheckShipMove  LD A, (Engine.ApplyMoveCode.SourceWater)
                OR A
                JR NZ, .ShipContinent                                           ; переход, если исходная клетка относится к воде

                LD BC, (Engine.ApplyMoveCode.TargetPos)
                LD (State.ShipPos), BC
                JR .CommitPosition

                ; обновление положения корабля только на его континенте
.ShipContinent  LD A, (State.Continent)
                LD HL, State.ShipMap
                CP (HL)
                JP NZ, HandleMapInput                                           ; переход, если корабль находится на другом континенте

                LD HL, (Engine.ApplyMoveCode.TargetPos)
                LD BC, (State.ShipPos)
                OR A
                SBC HL, BC
                JP NZ, HandleMapInput                                           ; переход, если корабль находится не в целевой клетке

                LD A, (State.MoveFlags)
                AND #FC
                OR #01
                LD (State.MoveFlags), A

                ; сохранение прежней позиции как цели возврата и применение нового положения героя
.CommitPosition LD BC, (State.Position)
                LD (State.MoveTarget), BC
                LD BC, (Engine.ApplyMoveCode.TargetPos)
                LD (State.Position), BC
                LD A, (Engine.ApplyMoveCode.TargetTile)
                CALL TerrainBattle                                              ; преобразовать местность по второй таблице порогов
                LD D, #00
                LD E, A
                LD HL, Engine.ApplyMoveCode.StepCosts - 1                       ; стоимость шага по классу местности с нумерацией1..6
                ADD HL, DE
                LD A, (HL)
                LD (State.StepCost), A
                XOR A
                RET

.TargetPos      EQU $+6                                                         ; проверяемая целевая позиция героя
.StepCosts      EQU $                                                           ; стоимость шага по классу местности с нумерацией1..6
                DB #0A, #FF, #4B, #96, #FF, #17, #00, #00
.TargetTile     EQU $+1                                                         ; индекс местности целевой клетки
.SourceTerrain  EQU $+2                                                         ; индекс местности исходной клетки
.TargetWater    EQU $+3                                                         ; единица для целевой местности вне диапазона 1..8
.SourceWater    EQU $+4                                                         ; единица для исходной местности вне диапазона 1..8
                DB #00, #00, #00, #00, #00
