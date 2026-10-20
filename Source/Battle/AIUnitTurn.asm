
; -----------------------------------------
; выбрать движение или атаку одного отряда компьютера
; сохраняет режим в E922, E7A5 отмечает достижимые цели, обычному бойцу E7E0 выбирает цель и E5B0
; предлагает соседей в предпочтительном порядке, свободная клетка перемещает отряд и уменьшает
; +12, выбранная соседняя цель запускает F0A0, стрелки типа 1/2 стреляют вне соседства и расходуют
; +8, при необходимости ищут выход из ближнего боя в один или два шага, летун типа 4 находит
; свободную клетку возле цели, эффект 20 запрещает полёт, остальные специальные типы перебирают
; всё поле, отсутствие действий ставит бит 4, отложенная стыковка со своим отрядом ставит бит 3
; In:
;   IY запись противника, A режим прохода
; Out:
;   координаты, движения, боеприпасы и флаги IY обновлены, возможно завершение боя
; Corrupt:
;   HL, DE, BC, AF, IX, IY, поля ИИ E639..E66C/E8D7..E949, записи армий, боевые объекты, экран,
;   состояние калькулятора и генератора
; -----------------------------------------
AIUnitTurn      LD (Battle.AnimatePath.TurnMode), A
                BIT AI_REPEAT_BIT, A                                            ; флаг, режим отложенного прохода ИИ требует отметки AI_DEFERRED_BIT
                JR Z, .ClearReachable                                           ; переход, если выполняется обычный проход армии

                BIT AI_DEFERRED_BIT, (IY + FBattleUnit.Flags)                   ; +#09, флаг, действие отряда ИИ отложено до повторного прохода армии с режимом 3
                RET Z                                                           ; выход, если отряд не откладывал действие до повторного прохода

                ; очистка отметок достижимости у армии героя перед поиском целей
.ClearReachable LD HL, Battle.FinishField.HeroArmy + FBattleUnit.Flags          ; поле Flags первого отряда героя, далее шаг FBattleUnit
                LD DE, #0012
                LD B, #05
.ClearHeroFlag  RES HERO_REACH_BIT, (HL)                                        ; флаг, отряд героя достижим для проверяемого отряда ИИ
                ADD HL, DE
                DJNZ .ClearHeroFlag

                CALL MarkInRange                                                ; отметить цели героя в пределах подвижности отряда компьютера
                LD A, (IY + FBattleUnit.Flags)                                  ; +#09, способности и временные отметки раунда, цели и контроля
                AND #07
                JP NZ, .CheckRangeKind                                          ; переход, если отряд обладает стрельбой или полётом

                ; выбор цели движения по таблице приоритетов
.PickMoveGoal   PUSH IY
                LD IY, Battle.AnimatePath.MoveRules
                LD HL, Battle.FinishField.HeroArmy
                CALL ChooseTarget                                               ; выбрать отряд по таблице приоритетов и минимальной весовой оценке
                POP IY
                JP Z, .EndUnitTurn                                              ; переход, если подходящая цель движения отсутствует

                LD (Battle.ClassifyCells.MoveTarget), IX
                LD (Battle.ClassifyCells.MovingUnit), IY

                ; построение соседей с приоритетом приближения к выбранной цели
.MoveTowards    LD IX, (Battle.ClassifyCells.MoveTarget)
                LD IY, (Battle.ClassifyCells.MovingUnit)
                LD E, (IX + FBattleUnit.X)
                LD D, (IX + FBattleUnit.Y)
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL BuildNeighbours                                            ; построить восемь соседних клеток в порядке приближения к цели
                LD IX, Battle.ClassifyCells.Candidates
                LD A, #03
                LD (Battle.AIUnitTurn.StepCount), A
.CheckStep      LD A, (IX + FBattleCell.Status)
                OR A
                JR NZ, .TestHeroStep                                            ; переход, если проверяемая клетка занята или недоступна

                ; перенос отряда в свободную клетку с обновлением его экранного объекта
.MoveUnit       LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL DirtyCell                                                  ; пометить экранный объект клетки как пустой для перерисовки
                LD C, (IX + FBattleCell.X)
                LD B, (IX + FBattleCell.Y)
                LD (IY + FBattleUnit.X), C                                      ; +#0A, колонка 0..7
                LD (IY + FBattleUnit.Y), B                                      ; +#0B, строка 0..4
                LD A, #64
                CALL MakeActingUnit                                             ; сформировать четырёхкадровый объект действующего отряда
                CALL WaitMoveFrames                                             ; выдержать сорок кадров анимации перемещения
                LD A, #63
                CALL MakeStaticUnit                                             ; сформировать неподвижный объект отряда и его отображаемое количество
                JP .SpendMove

.TestHeroStep   CP #02
                JP NZ, .TestEnemyStep                                           ; переход, если в клетке нет отряда героя

                LD C, (IX + FBattleCell.X)
                LD B, (IX + FBattleCell.Y)
                PUSH IX
                LD IX, (Battle.ClassifyCells.MoveTarget)
                LD L, (IX + FBattleUnit.X)
                LD H, (IX + FBattleUnit.Y)
                POP IX
                OR A
                SBC HL, BC
                JP NZ, .NextStep                                                ; переход, если клетка не совпадает с выбранной целью атаки

                LD IX, (Battle.ClassifyCells.MoveTarget)

                ; подготовка совместимости двух армий перед рукопашной атакой
.AttackTarget   LD C, #00
                LD B, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                LD HL, Battle.FinishField.EnemyArmy
                LD DE, #0012
                CALL Engine.ArmyMood                                            ; оценить совместимость типа отряда с составом армии
                LD (IY + FBattleUnit.Affinity), A                               ; +#01, знаковая совместимость состава от -2 до 2, для выбора поправки прибавляется 3
                LD A, (State.Cult)
                LD C, A
                LD B, (IX + FBattleUnit.UnitID)
                LD HL, Battle.FinishField.HeroArmy
                LD DE, #0012
                CALL Engine.ArmyMood                                            ; оценить совместимость типа отряда с составом армии
                LD (IX + FBattleUnit.Affinity), A
                SET AI_DONE_BIT, (IY + FBattleUnit.Flags)                       ; +#09, флаг, обработка отряда ИИ в текущем раунде завершена
                PUSH IY
                PUSH IX
                LD A, #01
                CALL ResolveAttack                                              ; рассчитать атаку и возможный ответный удар
                POP IY
                POP IX
                CALL ResolveLosses                                              ; удалить погибших, обработать бунт и проверить исход боя
                RET

.TestEnemyStep  CP #03
                JR NZ, .NextStep                                                ; переход, если в клетке нет своего отряда

                LD A, (Battle.AnimatePath.TurnMode)
                BIT AI_NO_WAIT_BIT, A                                           ; флаг, повторный проход ИИ запрещает снова откладывать отряд за своим соседом
                JP NZ, .NextStep                                                ; переход, если повторный проход запрещает ожидание своего отряда

                PUSH IX
                LD C, (IX + FBattleCell.X)
                LD B, (IX + FBattleCell.Y)
                LD IX, Battle.FinishField.EnemyArmy
                CALL FindUnitAtCell                                             ; найти отряд с заданными координатами в одной армии
                PUSH IX
                POP HL
                POP IX
                BIT UNIT_ID_HI_BIT, (HL)                                        ; позиция старшего значащего бита ID, при допустимых ID 1..25 единица означает диапазон 16..25
                JR NZ, .NextStep                                                ; переход, если ID соседнего своего отряда находится в диапазоне 16..25

                SET AI_DEFERRED_BIT, (IY + FBattleUnit.Flags)                   ; +#09, флаг, действие отряда ИИ отложено до повторного прохода армии с режимом 3
                RET

                ; перебор следующего кандидата движения при непригодной предыдущей клетке
.StepCount      EQU $+1                                                         ; операнд счётчика первых трёх направлений движения
.NextStep       LD A, #00
                DEC A
                LD (Battle.AIUnitTurn.StepCount), A
                INC IX
                INC IX
                INC IX
                JP NZ, .CheckStep                                               ; переход, если ещё не проверены первые три направления

                LD L, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD H, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL MarkAdjacent                                               ; пометить отряды героя, стоящие не далее одной клетки от заданной
                JP NZ, .PickAdjacent                                            ; переход, если рядом есть отряд героя

                LD IX, Battle.ClassifyCells.Candidates + FBattleCells.Fourth    ; четвёртый кандидат соседней клетки, начало резервной пары направлений
                LD B, #02
.FindFreeStep   LD A, (IX + FBattleCell.Status)
                OR A
                JP Z, .MoveUnit                                                 ; переход, если среди запасных направлений найдена свободная клетка

                INC IX
                INC IX
                INC IX
                DJNZ .FindFreeStep

                SET AI_DONE_BIT, (IY + FBattleUnit.Flags)                       ; +#09, флаг, обработка отряда ИИ в текущем раунде завершена
                RET

                ; списание одного действия, дальнейшее движение допустимо лишь при ненулевом остатке
.SpendMove      DEC (IY + FBattleUnit.ActionsLeft)                              ; +#0C, оставшиеся действия текущего раунда
                JP NZ, .MoveTowards                                             ; переход, если у отряда остались шаги

                SET AI_DONE_BIT, (IY + FBattleUnit.Flags)                       ; +#09, флаг, обработка отряда ИИ в текущем раунде завершена
                RET

.CheckRangeKind CP #01
                JR NZ, .CheckRangeTwo                                           ; переход, если тип возможностей отличается от магического дальнего действия

                LD A, (Battle.FinishField.Flags)
                BIT HERO_WARD_BIT, A                                            ; флаг, армия героя защищена магическим щитом
                JP NZ, .PickMoveGoal                                            ; переход, если армия героя защищена магическим щитом

                JR .CheckAdjacent

.CheckRangeTwo  CP #02
                JP NZ, .CheckFlight                                             ; переход, если тип возможностей отличается от обычной стрельбы

                ; проверка соседства с врагом перед дальним действием
.CheckAdjacent  LD L, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD H, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL MarkAdjacent                                               ; пометить отряды героя, стоящие не далее одной клетки от заданной
                JR NZ, .FindSafeStep                                            ; переход, если рядом есть отряд героя

.ShowActiveUnit LD A, #64
                CALL MakeActingUnit                                             ; сформировать четырёхкадровый объект действующего отряда

                ; выбор цели дальнего действия по отдельной таблице приоритетов
.PickShotTarget PUSH IY
                LD IY, Battle.AnimatePath.ShotRules
                LD HL, Battle.FinishField.HeroArmy
                CALL ChooseTarget                                               ; выбрать отряд по таблице приоритетов и минимальной весовой оценке
                POP IY
                JP Z, .EndUnitTurn                                              ; переход, если цель дальнего удара отсутствует

                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                LD E, (IX + FBattleUnit.X)
                LD D, (IX + FBattleUnit.Y)
                CALL AnimatePath                                                ; провести мигающую анимацию от исходной клетки к целевой
                LD C, #00
                LD B, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                LD HL, Battle.FinishField.EnemyArmy
                LD DE, #0012
                CALL Engine.ArmyMood                                            ; оценить совместимость типа отряда с составом армии
                LD (IY + FBattleUnit.Affinity), A                               ; +#01, знаковая совместимость состава от -2 до 2, для выбора поправки прибавляется 3
                SET AI_DONE_BIT, (IY + FBattleUnit.Flags)                       ; +#09, флаг, обработка отряда ИИ в текущем раунде завершена
                DEC (IY + FBattleUnit.ActionStock)                              ; +#08, остаток расходуемого дальнего действия
                JR NZ, .ShootTarget                                             ; переход, если после выстрела остались боеприпасы

                RES UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)                    ; +#09, флаг, тип отряда использует магическое дальнее действие
                RES UNIT_SHOT_BIT, (IY + FBattleUnit.Flags)                     ; +#09, флаг, тип отряда использует обычную дальнюю атаку
.ShootTarget    PUSH IY
                PUSH IX
                LD A, #02
                CALL ResolveAttack                                              ; рассчитать атаку и возможный ответный удар
                POP IY
                POP IX
                CALL ResolveLosses                                              ; удалить погибших, обработать бунт и проверить исход боя
                RET

                ; поиск свободной соседней клетки вне непосредственной близости к отрядам героя
.FindSafeStep   LD A, (IY + FBattleUnit.BaseActions)                            ; +#07, число действий в начале раунда
                CP #01
                JP Z, .PickAdjacent                                             ; переход, если подвижность равна одному, отход невозможен

                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                LD DE, #0000
                CALL BuildNeighbours                                            ; построить восемь соседних клеток в порядке приближения к цели
                LD IX, Battle.ClassifyCells.Candidates
                LD B, #08
.SafeStepLoop   LD A, (IX + FBattleCell.Status)
                OR A
                JR NZ, .NextSafeStep                                            ; переход, если клетка отхода занята или недоступна

                LD L, (IX + FBattleCell.X)
                LD H, (IX + FBattleCell.Y)
                CALL MarkAdjacent                                               ; пометить отряды героя, стоящие не далее одной клетки от заданной
                JR NZ, .NextSafeStep                                            ; переход, если клетка отхода соседствует с отрядом героя

                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL DirtyCell                                                  ; пометить экранный объект клетки как пустой для перерисовки
                LD (IY + FBattleUnit.X), L                                      ; +#0A, колонка 0..7
                LD (IY + FBattleUnit.Y), H                                      ; +#0B, строка 0..4
                LD A, #64
                CALL MakeActingUnit                                             ; сформировать четырёхкадровый объект действующего отряда
                CALL WaitMoveFrames                                             ; выдержать сорок кадров анимации перемещения
                JP .PickShotTarget

.NextSafeStep   INC IX
                INC IX
                INC IX
                DJNZ .SafeStepLoop

                LD A, (IY + FBattleUnit.BaseActions)                            ; +#07, число действий в начале раунда
                CP #02
                JR NZ, .CopyNeighbours                                          ; переход, если подвижность отличается от двух

                ; выбор наименее весомой цели среди отмеченных соседей, при равенстве остаётся первая
.PickAdjacent   LD L, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD H, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL MarkAdjacent                                               ; пометить отряды героя, стоящие не далее одной клетки от заданной
                LD IX, Battle.FinishField.HeroArmy
                LD DE, #0012
                LD B, #05
.FindMarked     BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)                     ; флаг, временная отметка соседства или кандидата в текущем проходе выбора цели
                JR NZ, .KeepBestUnit                                            ; переход, если найден соседний отряд героя

                ADD IX, DE
                JR .FindMarked

.KeepBestUnit   LD (Battle.StackStrength.BestUnit), IX
                LD HL, Battle.StackStrength.BestScore
                CALL StackStrength                                              ; вычислить весовую оценку боевого отряда
.NextBestUnit   DEC B
                JR Z, .AttackBest                                               ; переход, если проверены все пять записей армии

                LD DE, #0012
                ADD IX, DE
                LD A, (IX + FBattleUnit.UnitID)
                OR A
                JR Z, .AttackBest                                               ; переход, если список отрядов героя завершён

                BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)                     ; флаг, временная отметка соседства или кандидата в текущем проходе выбора цели
                JR Z, .NextBestUnit                                             ; переход, если отряд не отмечен как соседний

                LD HL, Battle.StackStrength.TrialScore
                CALL StackStrength                                              ; вычислить весовую оценку боевого отряда
                LD HL, Battle.StackStrength.TrialScore
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Battle.StackStrength.BestScore
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                JR NC, .NextBestUnit                                            ; переход, если оценка кандидата не меньше сохранённой

                PUSH BC
                LD HL, Battle.StackStrength.TrialScore
                LD DE, Battle.StackStrength.BestScore
                LD BC, #0005
                LDIR
                LD (Battle.StackStrength.BestUnit), IX
                POP BC
                JR .NextBestUnit

.AttackBest     LD IX, (Battle.StackStrength.BestUnit)
                JP .AttackTarget

                ; поиск безопасного маршрута через свободного соседа, отдельно сохраняется исходный список клеток
.CopyNeighbours LD HL, Battle.ClassifyCells.Candidates
                LD DE, Battle.ClassifyCells.BackupCells                         ; сохранённая копия восьми кандидатов для двухшагового поиска отхода ИИ
                LD BC, #0018
                LDIR
                LD IX, Battle.ClassifyCells.BackupCells                         ; сохранённая копия восьми кандидатов для двухшагового поиска отхода ИИ
                LD (Battle.AIUnitTurn.SearchCell), IX
                LD A, #08
                LD (Battle.AIUnitTurn.SearchCount), A
.SearchStep     LD A, (IX + FBattleCell.Status)
                OR A
                JR NZ, .NextSearchStep                                          ; переход, если первый шаг занят или недоступен

                LD C, (IX + FBattleCell.X)
                LD B, (IX + FBattleCell.Y)
                LD DE, #0000
                CALL BuildNeighbours                                            ; построить восемь соседних клеток в порядке приближения к цели
                LD IX, Battle.ClassifyCells.Candidates
                LD A, #08
                LD (Battle.AIUnitTurn.ExitCount), A
.SearchExit     LD A, (IX + FBattleCell.Status)
                OR A
                JR NZ, .NextExit                                                ; переход, если второй шаг занят или недоступен

                LD L, (IX + FBattleCell.X)
                LD H, (IX + FBattleCell.Y)
                CALL MarkAdjacent                                               ; пометить отряды героя, стоящие не далее одной клетки от заданной
                JR NZ, .NextExit                                                ; переход, если после второго шага отряд остаётся возле героя

                PUSH IX
                LD IX, (Battle.AIUnitTurn.SearchCell)
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL DirtyCell                                                  ; пометить экранный объект клетки как пустой для перерисовки
                LD C, (IX + FBattleCell.X)
                LD B, (IX + FBattleCell.Y)
                LD (IY + FBattleUnit.X), C                                      ; +#0A, колонка 0..7
                LD (IY + FBattleUnit.Y), B                                      ; +#0B, строка 0..4
                LD A, #64
                CALL MakeActingUnit                                             ; сформировать четырёхкадровый объект действующего отряда
                CALL WaitMoveFrames                                             ; выдержать сорок кадров анимации перемещения
                POP IX
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL DirtyCell                                                  ; пометить экранный объект клетки как пустой для перерисовки
                LD C, (IX + FBattleCell.X)
                LD B, (IX + FBattleCell.Y)
                LD (IY + FBattleUnit.X), C                                      ; +#0A, колонка 0..7
                LD (IY + FBattleUnit.Y), B                                      ; +#0B, строка 0..4
                LD A, #64
                CALL MakeActingUnit                                             ; сформировать четырёхкадровый объект действующего отряда
                JP .PickShotTarget

.ExitCount      EQU $+1                                                         ; операнд счётчика восьми вторых шагов отхода
.NextExit       LD A, #00
                DEC A
                LD (Battle.AIUnitTurn.ExitCount), A
                INC IX
                INC IX
                INC IX
                JR NZ, .SearchExit                                              ; переход, если ещё не проверены все восемь вторых шагов

.SearchCount    EQU $+1                                                         ; операнд счётчика восьми первых шагов отхода
.NextSearchStep LD A, #00
                DEC A
                LD (Battle.AIUnitTurn.SearchCount), A
.SearchCell     EQU $+2                                                         ; операнд IX текущего первого шага при поиске пути отхода
                LD IX, #0000
                INC IX
                INC IX
                INC IX
                LD (Battle.AIUnitTurn.SearchCell), IX
                JP NZ, .SearchStep                                              ; переход, если ещё не проверены все восемь первых шагов

                JP .PickAdjacent

.CheckFlight    CP #04
                JP NZ, .CheckWalk                                               ; переход, если отряд не является чистым летуном

                ; выбор цели полёта с учётом запрещающего временного эффекта
.PickFlyTarget  LD A, (IY + FBattleUnit.Effect)                                 ; +#0D, старшая тетрада вид эффекта, младшая оставшаяся длительность
                AND #F0
                CP #20
                JP Z, .PickMoveGoal                                             ; переход, если ослепление запрещает полёт

                PUSH IY
                LD IY, Battle.AnimatePath.FlightRules
                LD HL, Battle.FinishField.HeroArmy
                CALL ChooseTarget                                               ; выбрать отряд по таблице приоритетов и минимальной весовой оценке
                POP IY
                JR NZ, .MarkFlyGoal                                             ; переход, если цель полёта найдена

                ; завершение обработки отряда без дальнейшего действия
.EndUnitTurn    SET AI_DONE_BIT, (IY + FBattleUnit.Flags)                       ; +#09, флаг, обработка отряда ИИ в текущем раунде завершена
                LD A, #63
                CALL MakeStaticUnit                                             ; сформировать неподвижный объект отряда и его отображаемое количество
                RET

.MarkFlyGoal    LD (Battle.ClassifyCells.MoveTarget), IX
                LD L, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD H, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL MarkAdjacent                                               ; пометить отряды героя, стоящие не далее одной клетки от заданной
                LD IX, Battle.FinishField.HeroArmy
                LD B, #05
.FlyHeroLoop    LD A, (IX + FBattleUnit.UnitID)
                OR A
                JR Z, .FindFlyLanding                                           ; переход, если список отрядов героя завершён

                BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)                     ; флаг, временная отметка соседства или кандидата в текущем проходе выбора цели
                JR Z, .NextFlyHero                                              ; переход, если отряд не отмечен как соседний

                PUSH IX
                POP HL
                LD DE, (Battle.ClassifyCells.MoveTarget)
                OR A
                SBC HL, DE
                JP Z, .ClearFlyFlags                                            ; переход, если выбранная цель уже соседствует с летуном

.NextFlyHero    LD DE, #0012
                ADD IX, DE
                DJNZ .FlyHeroLoop

                ; поиск свободной клетки для посадки возле выбранной цели
.FindFlyLanding LD IX, (Battle.ClassifyCells.MoveTarget)
                LD C, (IX + FBattleUnit.X)
                LD B, (IX + FBattleUnit.Y)
                LD DE, #0000
                CALL BuildNeighbours                                            ; построить восемь соседних клеток в порядке приближения к цели
                LD HL, Battle.ClassifyCells.Candidates
                LD B, #08
.FlyLandingLoop LD A, (HL)
                OR A
                JR Z, .FlyToCell                                                ; переход, если найдена свободная клетка посадки

                INC HL
                INC HL
                INC HL
                DJNZ .FlyLandingLoop

                SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)                     ; флаг, временно исключить отряд из повторного выбора цели
                JR .PickFlyTarget

                ; анимация полёта и перенос координат отряда в клетку посадки
.FlyToCell      LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL DirtyCell                                                  ; пометить экранный объект клетки как пустой для перерисовки
                HALT
                INC HL
                LD E, (HL)
                INC HL
                LD D, (HL)
                PUSH DE
                CALL AnimatePath                                                ; провести мигающую анимацию от исходной клетки к целевой
                POP DE
                LD (IY + FBattleUnit.X), E                                      ; +#0A, колонка 0..7
                LD (IY + FBattleUnit.Y), D                                      ; +#0B, строка 0..4
                LD A, #64
                CALL MakeActingUnit                                             ; сформировать четырёхкадровый объект действующего отряда
                CALL WaitMoveFrames                                             ; выдержать сорок кадров анимации перемещения
.ClearFlyFlags  LD HL, Battle.FinishField.HeroArmy + FBattleUnit.Flags          ; поле Flags первого отряда героя, далее шаг FBattleUnit
                LD DE, #0012
                LD B, #05
.ClearFlyLoop   RES UNIT_SKIP_BIT, (HL)                                         ; флаг, временно исключить отряд из повторного выбора цели
                ADD HL, DE
                DJNZ .ClearFlyLoop

                LD IX, (Battle.ClassifyCells.MoveTarget)
                JP .AttackTarget

.CheckWalk      LD A, (IY + FBattleUnit.Effect)                                 ; +#0D, старшая тетрада вид эффекта, младшая оставшаяся длительность
                AND #F0
                CP #20
                JR NZ, .ScanField                                               ; переход, если ослепление не ограничивает возможности отряда

                LD A, (IY + FBattleUnit.Flags)                                  ; +#09, способности и временные отметки раунда, цели и контроля
                AND #03
                JP .CheckRangeKind

                ; полный просмотр поля при отсутствии подходящего непосредственного соседа
.ScanField      LD L, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD H, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL MarkAdjacent                                               ; пометить отряды героя, стоящие не далее одной клетки от заданной
                JP Z, .ShowActiveUnit                                           ; переход, если рядом нет отряда героя

                LD HL, #0100
                LD B, #05
.FieldRow       PUSH BC
                LD B, #08
.FieldColumn    PUSH BC
                PUSH HL
                POP BC
                PUSH HL
                CALL TestObstacle                                               ; проверить препятствие выбранной клетки
                POP HL
                POP BC
                JR NZ, .NextFieldCell                                           ; переход, если клетка закрыта препятствием

                LD IX, Battle.FinishField.EnemyArmy
                PUSH HL
                PUSH BC
                CALL FindUnitAtCell                                             ; найти отряд с заданными координатами в одной армии
                POP BC
                POP HL
                JR Z, .NextFieldCell                                            ; переход, если клетка занята отрядом противника

                CALL MarkAdjacent                                               ; пометить отряды героя, стоящие не далее одной клетки от заданной
                JR NZ, .NextFieldCell                                           ; переход, если клетка соседствует с отрядом героя

                POP BC
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL DirtyCell                                                  ; пометить экранный объект клетки как пустой для перерисовки
                LD (IY + FBattleUnit.X), L                                      ; +#0A, колонка 0..7
                LD (IY + FBattleUnit.Y), H                                      ; +#0B, строка 0..4
                EX DE, HL
                CALL AnimatePath                                                ; провести мигающую анимацию от исходной клетки к целевой
                LD A, #64
                CALL MakeActingUnit                                             ; сформировать четырёхкадровый объект действующего отряда
                CALL WaitMoveFrames                                             ; выдержать сорок кадров анимации перемещения
                JP .PickShotTarget

.NextFieldCell  INC L
                DJNZ .FieldColumn

                LD L, #00
                INC H
                POP BC
                DJNZ .FieldRow

                JP .PickAdjacent
