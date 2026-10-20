
; -----------------------------------------
; сближение, отступление и разделение внешних армий около героя
; Для континентальной таблицы #6B79 в банке 1, шаг 22, вычисляет включительный прямоугольник ±3
; вокруг #6A2E с обрезкой x=0..160, y=0..99. Пропускает записи при (flags AND #11)!=0, уменьшает
; задержку (flags AND #0E) на 2 ещё до проверки радиуса. Требует совпадения бита 5 флагов с
; режимом героя 0/1. #9193 сравнивает R=S героя/S группы, суммы количества*слова +22/+23 описателя
; SOLDIERS, смещения десятичные. При R<2 выбирает три шага к герою, при R>=2 три противоположных
; шага. Кандидаты требуют x=3..157, y=3..96, совпадение суши/воды, отсутствие занятого объекта
; кроме находки типа 8. Находка сразу помечается использованной, ещё до проверки совместимости
; армии с местностью. Ненулевая маска местности требует совместимости с флагами отрядов. При
; сближении несовместимость может отделить совместимые максимум 4 отряда в свободную запись, если
; отношение сил к этой части также <2. Переносит 12 байтов временной армии, удаляет их из
; источника и продолжает остальные кандидаты. Поля новой записи +3..+6 не инициализирует. При
; отступлении деления нет, проходимость требуется для всей группы. Перенос снимает старый бит 7
; карты, обновляет координаты/ориентацию и ставит новый бит 7. Бит 4 блокирует повторную обработку
; новых/исходных записей внутри прохода, в конце очищается у всех. Боевой вызов и объединение
; существующих групп отсутствуют, встреча через оверлей 7 возникает позже в main #64E8..#6506.
; In:
;   #6A2D — текущий континент, #6A2E — координаты героя, #6A33 — режим, #6A1E — армия, #6B79 —
;   таблица четырёх континентов с указателями и количествами 22-байтовых записей, банк 1 —
;   состояния, банк 10 — текущая стратегическая карта
; Out:
;   позиции, составы и флаги групп обновлены, карта занятости актуальна, бит 4 снят у всех
;   записей, выбран банк 1
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF' зависят от калькулятора ROM, IX, IY
; Note:
;   таблица армий банка 1, карта занятости, находки с шагом 3 байта, #8D29, #9172, #928F..#92CA,
;   самомодификация операндов #8F61/#8F64/#8FC6/#8FE2/#9034/#903D/#9161/#9164
; -----------------------------------------
StepArmies      LD BC, (State.Position)
                LD A, B
                ADD A, #03
                CP #64
                JR C, .ClampMaxY                                                ; переход, если нижняя граница области близости ещё помещается в допустимую высоту карты

                LD A, #63
.ClampMaxY      LD B, A
                LD A, C
                ADD A, #03
                CP #A1
                JR C, .StoreMaxBounds                                           ; переход, если правая граница области близости ещё помещается в допустимую ширину карты

                LD A, #A0
.StoreMaxBounds LD C, A
                LD (State.NearbyMax), BC
                LD BC, (State.Position)
                LD A, B
                SUB #03
                JR NC, .ClampMinY                                               ; переход, если верхняя граница области близости ещё не вышла выше карты

                XOR A
.ClampMinY      LD B, A
                LD A, C
                SUB #03
                JR NC, .StoreMinBounds                                          ; переход, если вычитание отступа не вывело левую границу колонки за ноль

                XOR A

                ; подготовка прямоугольника близости и списка армий текущего континента
.StoreMinBounds LD C, A
                LD (State.NearbyMin), BC
                LD IX, State.MapArmiesIndex
                LD A, (State.Continent)
                CALL IndexFourBytes                                             ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)                                  ; +#00, младший байт, адрес первой записи в банке выбранной группы
                LD H, (IX + FMapList.Data.High)                                 ; +#01, старший байт, адрес первой записи в банке выбранной группы
                LD C, (IX + FMapList.Count.Low)                                 ; +#02, младший байт, число записей little-endian, не размер в байтах
                LD B, (IX + FMapList.Count.High)                                ; +#03, старший байт, число записей little-endian, не размер в байтах
                PUSH HL
                POP IX
                LD (Engine.StepArmies.FreeList), HL
                LD (Engine.StepArmies.FreeCount), BC
                LD (Engine.StepArmies.ResetList), HL
                LD (Engine.StepArmies.ResetCount), BC

                ; пропуск отключённых и уже обработанных армий
.ArmyLoop       LD A, #01
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD A, (IX + FMapArmy.Flags)                                     ; +#00, состояние внешней армии
                AND #11
                JP NZ, .NextArmy                                                ; переход, если армия выключена или уже обработана в этом проходе

                LD A, (IX + FMapArmy.Flags)                                     ; +#00, состояние внешней армии
                AND #0E
                JR Z, .CheckNearby                                              ; переход, если для армии не задано ограничение периода движения

                SUB #02
                LD L, A
                LD A, (IX + FMapArmy.Flags)                                     ; +#00, состояние внешней армии
                AND #F1
                OR L
                LD (IX + FMapArmy.Flags), A                                     ; +#00, состояние внешней армии
                JP .NextArmy

.CheckNearby    LD E, (IX + FMapArmy.X)                                         ; +#01, столбец стратегической карты
                LD D, (IX + FMapArmy.Y)                                         ; +#02, строка стратегической карты
                CALL InNearbyRect                                               ; проверить координаты DE относительно ближайшей области героя
                JP NC, .NextArmy                                                ; переход, если армия находится вне области близости героя

                LD A, (State.MoveFlags)
                AND #03
                LD E, A
                LD A, (IX + FMapArmy.Flags)                                     ; +#00, состояние внешней армии
                AND #20
                RLCA
                RLCA
                RLCA
                CP E
                JP NZ, .NextArmy                                                ; переход, если режим местности армии не совпадает с режимом героя

                PUSH BC
                LD (State.MovingObject), IX
                LD HL, (State.MovingObject)
                LD DE, #0007
                ADD HL, DE
                LD B, #05
                CALL CompareArmies                                              ; сопоставить взвешенные величины двух составов армии
                PUSH AF
                JR NC, .MoveAway                                                ; переход, если сила героя не меньше удвоенной силы армии, выбирается отступление

                LD A, #FF
                LD IY, State.TowardSteps
                JR .SetApproach

                ; выбор отступления от героя вместо приближения
.MoveAway       XOR A
                LD IY, State.AwaySteps
.SetApproach    LD (State.Approaching), A
                LD C, (IX + FMapArmy.X)                                         ; +#01, столбец стратегической карты
                LD B, (IX + FMapArmy.Y)                                         ; +#02, строка стратегической карты
                LD DE, (State.Position)
                CALL GetDirection                                               ; определить одно из восьми направлений от BC к DE
                LD (State.MoveDirection), A
                CALL MakeSteps                                                  ; построить три возможных шага объекта и вызвать обработчик направления
                POP AF
                JP NC, .StartFallback                                           ; переход, если сила героя не меньше удвоенной силы армии, разделение для преследования не требуется

                LD HL, (State.Position)
                LD C, (IX + FMapArmy.X)
                LD B, (IX + FMapArmy.Y)
                OR A
                SBC HL, BC
                JP Z, .MarkMoved                                                ; переход, если армия уже находится в клетке героя

                LD IY, State.StepCandidates
                LD B, #03

                ; первая проверка трёх предпочтительных клеток перемещения
.CandidateLoop  PUSH BC
                LD A, (IY + FMoveStep.X)                                        ; +#01, столбец соседней клетки
                CP #03
                JP C, .NextCandidate                                            ; переход, если кандидат находится левее допустимой области карты

                CP #9E
                JP NC, .NextCandidate                                           ; переход, если кандидат находится правее допустимой области карты

                LD A, (IY + FMoveStep.Y)                                        ; +#02, строка соседней клетки
                CP #03
                JP C, .NextCandidate                                            ; переход, если кандидат находится выше допустимой области карты

                CP #61
                JP NC, .NextCandidate                                           ; переход, если кандидат находится ниже допустимой области карты

                LD A, #01
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD HL, (State.MovingObject)
                LD A, (IY + FMoveStep.TerrainMask)                              ; +#00, маска класса местности кандидата, #FF выделяет водный класс, 0 не требует проверки способностей
                BIT ARMY_WATER_BIT, (HL)                                        ; выбирает водный класс перемещения внешней армии либо шестибайтовой группы
                JR NZ, .CheckSeaCell                                            ; переход, если армия требует водный класс местности

                CP #FF
                JP Z, .NextCandidate                                            ; переход, если сухопутной армии предложена водная клетка

                JR .CheckObject

.CheckSeaCell   CP #FF
                JP NZ, .NextCandidate                                           ; переход, если водной армии предложена неводная клетка

.CheckObject    PUSH IY
                LD C, (IY + FMoveStep.X)                                        ; +#01, столбец соседней клетки
                LD B, (IY + FMoveStep.Y)                                        ; +#02, строка соседней клетки
                LD (State.ObjectCell), BC
                CALL FindMapObject                                              ; определить тип объекта в координатах #8D29
                POP IY
                LD A, C
                OR A
                JR Z, .CheckMapCell                                             ; переход, если в клетке кандидата нет стратегического объекта

                CP #08
                JP NZ, .NextCandidate                                           ; переход, если тип объекта в клетке не разрешает перемещение армии

                SET ITEM_USED_BIT, (IX + FMapItem.Flags)                        ; находка использована и исключена из обработки
                CALL SelectMapBank                                              ; выбрать логический банк 10 с текущей картой
                LD C, (IY + FMoveStep.X)                                        ; +#01, столбец соседней клетки
                LD B, (IY + FMoveStep.Y)                                        ; +#02, строка соседней клетки
                CALL MapCellAddress                                             ; вычислить адрес клетки карты
                RES MAP_BUSY_BIT, (HL)                                          ; клетка стратегической карты занята объектом
                JR .CheckTerrain

.CheckMapCell   LD C, (IY + FMoveStep.X)                                        ; +#01, столбец соседней клетки
                LD B, (IY + FMoveStep.Y)                                        ; +#02, строка соседней клетки
                CALL ReadMapCell                                                ; прочитать байт клетки текущей карты
                BIT MAP_BUSY_BIT, A                                             ; клетка стратегической карты занята объектом
                JP NZ, .NextCandidate                                           ; переход, если клетка кандидата занята

.CheckTerrain   LD A, (IY + FMoveStep.TerrainMask)                              ; +#00, маска класса местности кандидата, #FF выделяет водный класс, 0 не требует проверки способностей
                OR A
                JP Z, .CommitMove                                               ; переход, если кандидат не требует проверки маски способностей

                LD A, #01
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD A, #05
                LD (Engine.StepArmies.SourceCount), A
                LD HL, (State.MovingObject)
                LD DE, #0007
                ADD HL, DE
                LD (Engine.StepArmies.SourceTroops), HL
.FindSplitUnit  LD A, (HL)
                OR A
                JP Z, .CommitMove                                               ; переход, если достигнут конец армии при поиске совместимого отряда

                CALL UnitFlags                                                  ; прочитать пару флагов описателя отряда
                LD A, E
                AND (IY + FMoveStep.TerrainMask)                                ; +#00, маска класса местности кандидата, #FF выделяет водный класс, 0 не требует проверки способностей
                JP NZ, .AdvanceSource                                           ; переход, если текущий отряд совместим с местностью кандидата

.FreeList       EQU $+1                                                         ; адрес начала списка для поиска свободной армии
                LD HL, #0000
.FreeCount      EQU $+1                                                         ; число записей для поиска свободной армии
                LD BC, #0000
                LD DE, #0016
.FindFreeSlot   BIT ARMY_FREE_BIT, (HL)                                         ; свободная либо выключенная запись внешней армии
                JR NZ, .PrepareSplit                                            ; переход, если найдена свободная стратегическая запись армии

                ADD HL, DE
                DEC BC
                LD A, B
                OR C
                JR NZ, .FindFreeSlot                                            ; переход, если остались записи для поиска свободного места

                JP .NextCandidate

                ; подготовка новой стратегической записи для выделяемой части армии
.PrepareSplit   LD (Engine.StepArmies.SplitAddress), HL
                LD (Engine.StepArmies.SplitRecord), HL
                LD HL, State.SplitArmy
                LD DE, State.SplitArmy + 1                                      ; следующий байт при очистке временной выделяемой армии
                LD BC, #000B
                LD (HL), #00
                LDIR
                LD HL, (State.MovingObject)
                LD DE, #0007
                ADD HL, DE
                LD DE, State.SplitArmy
                LD B, #05

                ; распределение отрядов по совместимости с выбранной местностью
.CopySplitUnit  LD A, (HL)
                OR A
                JR Z, .CheckSplitArmy                                           ; переход, если достигнут конец исходного списка отрядов

                PUSH BC
                PUSH DE
                CALL UnitFlags                                                  ; прочитать пару флагов описателя отряда
                LD A, E
                AND (IY + FMoveStep.TerrainMask)                                ; +#00, маска класса местности кандидата, #FF выделяет водный класс, 0 не требует проверки способностей
                POP DE
                JR Z, .NextSplitUnit                                            ; переход, если текущий отряд не допускает местность кандидата

                LDI
                LDI
                LDI
                JR .RestoreSplit

.NextSplitUnit  INC HL
                INC HL
                INC HL
.RestoreSplit   POP BC
                DJNZ .CopySplitUnit

.CheckSplitArmy LD A, (State.SplitArmy)
                OR A
                JP Z, .NextCandidate                                            ; переход, если в новую армию не попал ни один отряд

                LD HL, State.SplitArmy
                LD B, #04
                CALL CompareArmies                                              ; сопоставить взвешенные величины двух составов армии
                JP NC, .NextCandidate                                           ; переход, если сила героя не меньше удвоенной силы выделенной армии

.SplitAddress   EQU $+1                                                         ; адрес создаваемой стратегической армии при записи отрядов
                LD HL, #0000
                LD DE, #0007
                ADD HL, DE
                PUSH HL
                PUSH HL
                POP DE
                INC DE
                LD (HL), #00
                LD BC, #000E
                LDIR
                POP DE
                LD HL, State.SplitArmy
                LD BC, #000C
                LDIR
.SplitRecord    EQU $+2                                                         ; адрес создаваемой стратегической армии при записи координат
                LD IX, #0000
                LD C, (IY + FMoveStep.X)                                        ; +#01, столбец соседней клетки
                LD B, (IY + FMoveStep.Y)                                        ; +#02, строка соседней клетки
                LD (IX + FMapArmy.X), C
                LD (IX + FMapArmy.Y), B
                LD HL, (State.MovingObject)
                LD A, (HL)
                LD (IX + FMapArmy.Flags), A
                SET ARMY_MOVED_BIT, (IX + FMapArmy.Flags)                       ; внешняя армия уже обработана в текущем проходе движения
                CALL SelectMapBank                                              ; выбрать логический банк 10 с текущей картой
                CALL MapCellAddress                                             ; вычислить адрес клетки карты
                SET MAP_BUSY_BIT, (HL)                                          ; клетка стратегической карты занята объектом
                LD A, #01
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD HL, (State.MovingObject)
                LD DE, #0007
                ADD HL, DE
                LD B, #05
.RemainUnitLoop LD A, (HL)
                OR A
                JR Z, .CompactSource                                            ; переход, если достигнут конец оставшихся отрядов исходной армии

                CALL UnitFlags                                                  ; прочитать пару флагов описателя отряда
                LD A, E
                AND (IY + FMoveStep.TerrainMask)                                ; +#00, маска класса местности кандидата, #FF выделяет водный класс, 0 не требует проверки способностей
                JR Z, .NextRemainUnit                                           ; переход, если отряд не допускает местность кандидата и остаётся в исходной армии

                LD (HL), #00
.NextRemainUnit INC HL
                INC HL
                INC HL
                DJNZ .RemainUnitLoop

.CompactSource  LD HL, (State.MovingObject)
                LD DE, #0007
                ADD HL, DE
                LD B, #05
                CALL CompactArmy                                                ; сжать список трёхбайтных записей армии
                JR .NextCandidate

.SourceTroops   EQU $+1                                                         ; адрес оставшихся отрядов исходной армии
.AdvanceSource  LD HL, #0000
                INC HL
                INC HL
                INC HL
                LD (Engine.StepArmies.SourceTroops), HL
.SourceCount    EQU $+1                                                         ; число оставшихся отрядов исходной армии
                LD A, #00
                DEC A
                LD (Engine.StepArmies.SourceCount), A
                JP NZ, .FindSplitUnit                                           ; переход, если остались исходные отряды для проверки выделения

                JP .CommitMove

.NextCandidate  POP BC
                INC IY
                INC IY
                INC IY
                DEC B
                JP NZ, .CandidateLoop                                           ; переход, если остались предпочтительные кандидаты перемещения

                JP .MarkMoved

                ; повторный проход кандидатов без выделения новой армии
.StartFallback  LD IY, State.StepCandidates
                LD B, #03
.FallbackLoop   PUSH BC
                LD A, (IY + FMoveStep.X)                                        ; +#01, столбец соседней клетки
                CP #03
                JP C, .NextFallback                                             ; переход, если резервный кандидат находится левее допустимой области карты

                CP #9E
                JP NC, .NextFallback                                            ; переход, если резервный кандидат находится правее допустимой области карты

                LD A, (IY + FMoveStep.Y)                                        ; +#02, строка соседней клетки
                CP #03
                JP C, .NextFallback                                             ; переход, если резервный кандидат находится выше допустимой области карты

                CP #61
                JP NC, .NextFallback                                            ; переход, если резервный кандидат находится ниже допустимой области карты

                LD A, #01
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD HL, (State.MovingObject)
                LD A, (IY + FMoveStep.TerrainMask)                              ; +#00, маска класса местности кандидата, #FF выделяет водный класс, 0 не требует проверки способностей
                BIT ARMY_WATER_BIT, (HL)                                        ; выбирает водный класс перемещения внешней армии либо шестибайтовой группы
                JR NZ, .CheckFallback                                           ; переход, если армия требует водный класс местности

                CP #FF
                JP Z, .NextFallback                                             ; переход, если сухопутной армии предложена водная клетка

                JR .FallbackObject

.CheckFallback  CP #FF
                JP NZ, .NextFallback                                            ; переход, если водной армии предложена неводная клетка

.FallbackObject PUSH IY
                LD C, (IY + FMoveStep.X)                                        ; +#01, столбец соседней клетки
                LD B, (IY + FMoveStep.Y)                                        ; +#02, строка соседней клетки
                LD (State.ObjectCell), BC
                CALL FindMapObject                                              ; определить тип объекта в координатах #8D29
                POP IY
                LD A, C
                OR A
                JR Z, .FallbackCell                                             ; переход, если в резервной клетке нет стратегического объекта

                CP #08
                JP NZ, .NextFallback                                            ; переход, если тип объекта резервной клетки не разрешает перемещение

                SET ITEM_USED_BIT, (IX + FMapItem.Flags)                        ; находка использована и исключена из обработки
                CALL SelectMapBank                                              ; выбрать логический банк 10 с текущей картой
                LD C, (IY + FMoveStep.X)                                        ; +#01, столбец соседней клетки
                LD B, (IY + FMoveStep.Y)                                        ; +#02, строка соседней клетки
                CALL MapCellAddress                                             ; вычислить адрес клетки карты
                RES MAP_BUSY_BIT, (HL)                                          ; клетка стратегической карты занята объектом
                JR .FallbackMask

.FallbackCell   LD C, (IY + FMoveStep.X)                                        ; +#01, столбец соседней клетки
                LD B, (IY + FMoveStep.Y)                                        ; +#02, строка соседней клетки
                CALL ReadMapCell                                                ; прочитать байт клетки текущей карты
                BIT MAP_BUSY_BIT, A                                             ; клетка стратегической карты занята объектом
                JP NZ, .NextFallback                                            ; переход, если резервная клетка занята

.FallbackMask   LD A, (IY + FMoveStep.TerrainMask)                              ; +#00, маска класса местности кандидата, #FF выделяет водный класс, 0 не требует проверки способностей
                OR A
                JR Z, .CommitMove                                               ; переход, если резервный кандидат не требует проверки маски способностей

                LD A, #01
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD HL, (State.MovingObject)
                LD DE, #0007
                ADD HL, DE
                LD B, #05
.CheckArmyMask  LD A, (HL)
                OR A
                JP Z, .CommitMove                                               ; переход, если достигнут конец армии без несовместимых отрядов

                CALL UnitFlags                                                  ; прочитать пару флагов описателя отряда
                LD A, E
                AND (IY + FMoveStep.TerrainMask)                                ; +#00, маска класса местности кандидата, #FF выделяет водный класс, 0 не требует проверки способностей
                JR Z, .NextFallback                                             ; переход, если отряд не допускает местность резервного кандидата

                INC HL
                INC HL
                INC HL
                DJNZ .CheckArmyMask

                ; перенос отметки занятой клетки и координат выбранной армии
.CommitMove     POP BC
                LD A, #01
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD IX, (State.MovingObject)
                LD C, (IX + FMapArmy.X)                                         ; +#01, столбец стратегической карты
                LD B, (IX + FMapArmy.Y)                                         ; +#02, строка стратегической карты
                CALL SelectMapBank                                              ; выбрать логический банк 10 с текущей картой
                CALL MapCellAddress                                             ; вычислить адрес клетки карты
                RES MAP_BUSY_BIT, (HL)                                          ; клетка стратегической карты занята объектом
                LD A, #01
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD C, (IY + FMoveStep.X)                                        ; +#01, столбец соседней клетки
                LD B, (IY + FMoveStep.Y)                                        ; +#02, строка соседней клетки
                LD (IX + FMapArmy.X), C                                         ; +#01, столбец стратегической карты
                LD (IX + FMapArmy.Y), B                                         ; +#02, строка стратегической карты
                LD A, (State.MoveDirection)
                CALL SetFacing                                                  ; изменить бит 6 флагов объекта по коду направления
                LD A, (State.Approaching)
                OR A
                JR NZ, .MarkNewCell                                             ; переход, если армия движется к герою и занимает новую клетку

                LD A, (IX + FMapArmy.Flags)                                     ; +#00, состояние внешней армии
                XOR #40
                LD (IX + FMapArmy.Flags), A                                     ; +#00, состояние внешней армии
.MarkNewCell    CALL SelectMapBank                                              ; выбрать логический банк 10 с текущей картой
                CALL MapCellAddress                                             ; вычислить адрес клетки карты
                SET MAP_BUSY_BIT, (HL)                                          ; клетка стратегической карты занята объектом
                JR .MarkMoved

.NextFallback   POP BC
                INC IY
                INC IY
                INC IY
                DEC B
                JP NZ, .FallbackLoop                                            ; переход, если остались резервные кандидаты перемещения

.MarkMoved      LD A, #01
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD IX, (State.MovingObject)
                SET ARMY_MOVED_BIT, (IX + FMapArmy.Flags)                       ; внешняя армия уже обработана в текущем проходе движения
                POP BC
.NextArmy       LD DE, #0016
                ADD IX, DE
                DEC BC
                LD A, B
                OR C
                JP NZ, .ArmyLoop                                                ; переход, если остались стратегические армии для обработки

.ResetList      EQU $+1                                                         ; начало списка армий при очистке отметок движения
                LD HL, #0000
.ResetCount     EQU $+1                                                         ; число армий при очистке отметок движения
                LD BC, #0000
                LD DE, #0016

                ; очистка временной отметки обработки после общего прохода
.ResetMoved     RES ARMY_MOVED_BIT, (HL)                                        ; внешняя армия уже обработана в текущем проходе движения
                ADD HL, DE
                DEC BC
                LD A, B
                OR C
                JR NZ, .ResetMoved                                              ; переход, если остались записи для снятия временной отметки движения

                RET

                DB #00
