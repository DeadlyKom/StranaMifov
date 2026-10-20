
; -----------------------------------------
; выполнить случайный ход или атаку вышедшего из подчинения отряда
; по E5B0 собирает соседние занятые клетки в EB8E, EB08 случайно выбирает цель из любой армии для
; рукопашной F0A0, при отсутствии соседей стрелок с запасом +8 использует EB2D для списка
; остальных отрядов и стреляет, летун выбирает свободную клетку возле случайной цели, прочие
; выбирают случайного свободного соседа, движение уменьшает +12 и повторяется до исчерпания
; In:
;   IY вышедший из подчинения отряд героя
; Out:
;   изменены координаты, действия и количества участников, возможно завершение боя
; Corrupt:
;   HL, DE, BC, AF, IX, IY, список и число целей EB8B..EBA8, армии, боевые объекты, экран и
;   состояние генератора
; -----------------------------------------
RunUncontrolled LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                LD DE, #0000
                CALL BuildNeighbours                                            ; построить восемь соседних клеток в порядке приближения к цели
                XOR A
                LD (Battle.ListOtherUnits.TargetCount), A
                LD HL, Battle.ListOtherUnits.TargetList
                LD (Battle.ListOtherUnits.TargetEnd), HL
                LD IX, Battle.ClassifyCells.Candidates
                LD B, #08

                ; составление списка занятых соседних клеток обеих армий для случайной рукопашной атаки
.NeighbourLoop  PUSH BC
                LD A, (IX + FBattleCell.Status)
                CP #02
                JR NZ, .CheckEnemyCell                                          ; переход, если клетка не занята отрядом героя

                PUSH IX
                LD B, (IX + FBattleCell.Y)
                LD C, (IX + FBattleCell.X)
                LD IX, Battle.FinishField.HeroArmy
.AddTarget      PUSH AF
                CALL FindUnitAtCell                                             ; найти отряд с заданными координатами в одной армии
                POP AF
                PUSH IX
                POP HL
                LD IX, (Battle.ListOtherUnits.TargetEnd)
                LD (IX + #00), A
                INC IX
                LD (IX + #00), L
                INC IX
                LD (IX + #00), H
                INC IX
                LD (Battle.ListOtherUnits.TargetEnd), IX
                POP IX
                LD A, (Battle.ListOtherUnits.TargetCount)
                INC A
                LD (Battle.ListOtherUnits.TargetCount), A
                JR .NextNeighbour

.CheckEnemyCell CP #03
                JR NZ, .NextNeighbour                                           ; переход, если клетка не занята отрядом противника

                PUSH IX
                LD B, (IX + FBattleCell.Y)
                LD C, (IX + FBattleCell.X)
                LD IX, Battle.FinishField.EnemyArmy
                JR .AddTarget

.NextNeighbour  LD DE, #0003
                ADD IX, DE
                POP BC
                DJNZ .NeighbourLoop

                LD A, (Battle.ListOtherUnits.TargetCount)
                OR A
                JR Z, .TryShot                                                  ; переход, если соседних целей ближней атаки нет

                LD A, #01
                LD (Battle.RunUncontrolled.AttackKind), A
                CALL RandomTarget                                               ; случайно выбрать запись из списка целей
.TargetSide     CP #03
                JR Z, .HeroTarget                                               ; переход, если выбранная цель относится к армии противника

                LD C, #00
                LD HL, Battle.FinishField.EnemyArmy
                JR .ResolveMelee

.HeroTarget     LD A, (State.Cult)
                LD C, A
                LD HL, Battle.FinishField.HeroArmy

                ; подготовка совместимости выбранной стороны и проведение неуправляемой атаки
.ResolveMelee   LD B, (IX + FBattleUnit.UnitID)
                LD DE, #0012
                CALL Engine.ArmyMood                                            ; оценить совместимость типа отряда с составом армии
                LD (IX + FBattleUnit.Affinity), A
                LD (IY + FBattleUnit.Affinity), #01                             ; +#01, знаковая совместимость состава от -2 до 2, для выбора поправки прибавляется 3
                LD (IY + FBattleUnit.ActionsLeft), #00                          ; +#0C, оставшиеся действия текущего раунда
                PUSH IY
                PUSH IX
.AttackKind     EQU $+1                                                         ; операнд A вида случайной атаки, 1 ближняя или 2 дальняя
                LD A, #01
                CALL ResolveAttack                                              ; рассчитать атаку и возможный ответный удар
                POP IX
                POP IY
                CALL ResolveLosses                                              ; удалить погибших, обработать бунт и проверить исход боя
                RET

                ; при отсутствии соседей проверяется возможность дальнего действия и запас его применений
.TryShot        LD A, (IY + FBattleUnit.Flags)                                  ; +#09, способности и временные отметки раунда, цели и контроля
                AND #03
                JP Z, .TryFlight                                                ; переход, если отряд не имеет дальнего действия

                LD A, (IY + FBattleUnit.ActionStock)                            ; +#08, остаток расходуемого дальнего действия
                OR A
                JP Z, .RandomStep                                               ; переход, если запас дальнего действия исчерпан

                DEC (IY + FBattleUnit.ActionStock)                              ; +#08, остаток расходуемого дальнего действия
                LD A, #02
                LD (Battle.RunUncontrolled.AttackKind), A
                CALL ListOtherUnits                                             ; составить список всех отрядов кроме действующего
                CALL RandomTarget                                               ; случайно выбрать запись из списка целей
                PUSH AF
                LD A, #24
                CALL MakeActingUnit                                             ; сформировать четырёхкадровый объект действующего отряда
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                LD E, (IX + FBattleUnit.X)
                LD D, (IX + FBattleUnit.Y)
                CALL AnimatePath                                                ; провести мигающую анимацию от исходной клетки к целевой
                POP AF
                JP .TargetSide

                ; для летуна составляется список остальных отрядов, служащих ориентирами полёта
.TryFlight      LD A, (IY + FBattleUnit.Flags)                                  ; +#09, способности и временные отметки раунда, цели и контроля
                AND #07
                CP #04
                JP NZ, .RandomStep                                              ; переход, если отряд не является чистым летуном

                LD A, (IY + FBattleUnit.Effect)                                 ; +#0D, старшая тетрада вид эффекта, младшая оставшаяся длительность
                AND #F0
                CP #20
                JP Z, .RandomStep                                               ; переход, если ослепление запрещает полёт

                CALL ListOtherUnits                                             ; составить список всех отрядов кроме действующего

                ; поиск ещё не исключённой цели, предыдущая могла не иметь свободной клетки рядом
.CheckTargets   LD IX, Battle.ListOtherUnits.TargetList
                LD DE, #0003
                LD A, (Battle.ListOtherUnits.TargetCount)
.FindUsable     BIT TARGET_SKIP_BIT, (IX + FBattleTarget.Side)                  ; флаг, цель полёта уже проверена и исключена из следующих попыток
                JR Z, .ChooseFlight                                             ; переход, если цель ещё не исключена из попыток полёта

                ADD IX, DE
                DEC A
                JR NZ, .FindUsable                                              ; переход, если остались непроверенные цели

                LD (IY + FBattleUnit.ActionsLeft), #00                          ; +#0C, оставшиеся действия текущего раунда
                RET

                ; случайный выбор цели полёта и построение её соседних клеток
.ChooseFlight   CALL RandomTarget                                               ; случайно выбрать запись из списка целей
                BIT TARGET_SKIP_BIT, A                                          ; флаг, цель полёта уже проверена и исключена из следующих попыток
                JR NZ, .CheckTargets                                            ; переход, если выбранная цель уже исключена из попыток полёта

                LD (Battle.ListOtherUnits.TargetEnd), HL
                LD C, (IX + FBattleUnit.X)
                LD B, (IX + FBattleUnit.Y)
                LD DE, #0000
                CALL BuildNeighbours                                            ; построить восемь соседних клеток в порядке приближения к цели
                LD HL, Battle.ClassifyCells.Candidates
                LD B, #08
.LandingLoop    LD A, (HL)
                OR A
                JR Z, .MoveToLanding                                            ; переход, если найдена свободная клетка посадки

                INC HL
                INC HL
                INC HL
                DJNZ .LandingLoop

                LD HL, (Battle.ListOtherUnits.TargetEnd)
                SET TARGET_SKIP_BIT, (HL)                                       ; флаг, цель полёта уже проверена и исключена из следующих попыток
                JR .CheckTargets

                ; перенос неуправляемого отряда в найденную свободную клетку
.MoveToLanding  LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL DirtyCell                                                  ; пометить экранный объект клетки как пустой для перерисовки
                HALT
                INC HL
                LD E, (HL)
                INC HL
                LD D, (HL)
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                LD (IY + FBattleUnit.X), E                                      ; +#0A, колонка 0..7
                LD (IY + FBattleUnit.Y), D                                      ; +#0B, строка 0..4
                CALL AnimatePath                                                ; провести мигающую анимацию от исходной клетки к целевой
                LD A, #24
                CALL MakeActingUnit                                             ; сформировать четырёхкадровый объект действующего отряда
                CALL WaitMoveFrames                                             ; выдержать сорок кадров анимации перемещения
                LD A, #23
                CALL MakeStaticUnit                                             ; сформировать неподвижный объект отряда и его отображаемое количество
                LD HL, (Battle.ListOtherUnits.TargetEnd)
                LD A, (HL)
                AND #7F
                JP .TargetSide

                ; случайный выбор свободного соседа для обычного наземного шага
.RandomStep     LD DE, #0007
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD A, E
                SLA A
                ADD A, E
                LD E, A
                LD IX, Battle.ClassifyCells.Candidates
                ADD IX, DE
                LD A, (IX + FBattleCell.Status)
                OR A
                JR NZ, .RandomStep                                              ; переход, если случайная соседняя клетка занята или недоступна

                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL DirtyCell                                                  ; пометить экранный объект клетки как пустой для перерисовки
                LD C, (IX + FBattleCell.X)
                LD B, (IX + FBattleCell.Y)
                LD (IY + FBattleUnit.X), C                                      ; +#0A, колонка 0..7
                LD (IY + FBattleUnit.Y), B                                      ; +#0B, строка 0..4
                LD A, #24
                CALL MakeActingUnit                                             ; сформировать четырёхкадровый объект действующего отряда
                CALL WaitMoveFrames                                             ; выдержать сорок кадров анимации перемещения
                LD A, #23
                CALL MakeStaticUnit                                             ; сформировать неподвижный объект отряда и его отображаемое количество
                DEC (IY + FBattleUnit.ActionsLeft)                              ; +#0C, оставшиеся действия текущего раунда
                JP NZ, RunUncontrolled                                          ; переход, если у отряда остались шаги

                RET
