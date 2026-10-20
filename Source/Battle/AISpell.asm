
; -----------------------------------------
; выбрать и применить доступное заклинание противника
; обнуляет десять флагов F081..F08A, проверяет цену заклинаний по 8066 против FCB9, наличие зомби
; ID19 для подчинения, типы целей и щиты FCE7, случайно выбирает допустимый номер 1..10,
; непригодный помечается и выбор повторяется, F028 списывает силу, ветки выполняют перемещение,
; подчинение с добавлением количества к зомби, магический щит, невидимость 82, клонирование 62 или
; воздействие F598, коды эффектов берутся из DC01, завершение после одного применения либо
; исчерпания вариантов
; In:
;   FCB9 магическая сила противника, FCED/FD47 армии
; Out:
;   сила и армии изменены, возможно завершение боя
; Corrupt:
;   HL, DE, BC, AF, IX, IY, флаги F081..F08A, FCB9, обе армии, рабочие поля заклинаний, экран и
;   состояния калькулятора и генератора
; -----------------------------------------
AISpell         LD HL, Battle.SpendAIMagic.NoFreeze
                LD DE, Battle.SpendAIMagic.NoBlind
                LD BC, #0009
                LD (HL), #00
                LDIR
                LD IY, Battle.FinishField.EnemyArmy
                CALL ResetTurnFlags                                             ; очистить временные флаги одной армии
                CALL RestoreMovement                                            ; восстановить очки движения армии на новый раунд
                LD IY, Battle.FinishField.HeroArmy
                CALL ResetTurnFlags                                             ; очистить временные флаги одной армии
                LD IY, Battle.SpendAIMagic.NoSubjugate
                LD B, #0A

                ; отметка заклинаний, стоимость которых превышает оставшуюся магическую силу противника
.CheckCost      LD A, B
                CALL Engine.SpellDesc                                           ; получить описатель одного из десяти заклинаний
                LD HL, (Battle.FinishField.EnemyMana)
                LD E, (IX + FSpell.ManaCost.Low)
                LD D, (IX + FSpell.ManaCost.High)
                OR A
                SBC HL, DE
                JR NC, .NextSpellCost                                           ; переход, если маны хватает на очередное заклинание

                SET SPELL_BLOCK_BIT, (IY + #00)                                 ; флаг, это заклинание исключено из выбора ИИ в текущей попытке
.NextSpellCost  DEC IY
                DJNZ .CheckCost

                LD HL, Battle.FinishField.EnemyArmy
                LD DE, #0012
                LD B, #05

                ; проверка наличия зомби, необходимых для ветви подчинения
.FindZombie     LD A, (HL)
                OR A
                JR Z, .NoZombie                                                 ; переход, если армия героя закончилась без зомби

                CP #13
                JR Z, .CheckArmy                                                ; переход, если в армии героя найдены зомби

                ADD HL, DE
                DJNZ .FindZombie

.NoZombie       LD A, #01
                LD (Battle.SpendAIMagic.NoSubjugate), A
.CheckArmy      LD IX, Battle.FinishField.EnemyArmy
                LD B, #05
.FindWalker     LD A, (IX + FBattleUnit.UnitID)
                OR A
                JR Z, .NoWalker                                                 ; переход, если армия противника закончилась без обычного бойца

                LD A, (IX + FBattleUnit.Flags)
                AND #07
                JR Z, .CheckShields                                             ; переход, если найден боец без стрельбы и полёта

                ADD IX, DE
                DJNZ .FindWalker

.NoWalker       LD A, #01
                LD (Battle.SpendAIMagic.NoTeleport), A

                ; исключение заклинаний, которым мешает действующая магическая защита сторон
.CheckShields   LD A, (Battle.FinishField.Flags)
                BIT HERO_WARD_BIT, A                                            ; флаг, армия героя защищена магическим щитом
                JR Z, .CheckEnemyWard                                           ; переход, если армия героя не защищена щитом

                LD A, #01
                LD (Battle.SpendAIMagic.NoFreeze), A
                LD (Battle.SpendAIMagic.NoBlind), A
                LD (Battle.SpendAIMagic.NoBallBolt), A
                LD (Battle.SpendAIMagic.NoBanish), A
                LD (Battle.SpendAIMagic.NoSubjugate), A
                ; исходная ветвь щита героя оставляет A=1, поэтому при обоих щитах здесь щит противника не обнаруживается
.CheckEnemyWard BIT ENEMY_WARD_BIT, A                                           ; флаг, армия противника защищена магическим щитом
                JR Z, .HeroArmy                                                 ; переход, если щит противника отсутствует либо перед этим уже учтён щит героя

                LD A, #01
                LD (Battle.SpendAIMagic.NoWard), A
.HeroArmy       LD IX, Battle.FinishField.HeroArmy
                LD B, #05

                ; отметка невосприимчивых к выбранному воздействию отрядов героя
.HeroFlags      LD A, (IX + FBattleUnit.UnitID)
                OR A
                JR Z, .EnemyArmy                                                ; переход, если список отрядов героя завершён

                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                BIT MAGIC_IMM_BIT, D                                            ; флаг, тип цели невосприимчив к целевому магическому действию
                JR Z, .NextHeroFlag                                             ; переход, если тип отряда допускает действие заклинания

                SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)                     ; флаг, временно исключить отряд из повторного выбора цели
.NextHeroFlag   LD DE, #0012
                ADD IX, DE
                DJNZ .HeroFlags

.EnemyArmy      LD IX, Battle.FinishField.EnemyArmy
                LD B, #05

                ; аналогичная фильтрация целей среди отрядов противника
.EnemyFlags     LD A, (IX + FBattleUnit.UnitID)
                OR A
                JR Z, .ChooseSpell                                              ; переход, если список отрядов противника завершён

                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                BIT MAGIC_IMM_BIT, D                                            ; флаг, тип цели невосприимчив к целевому магическому действию
                JR Z, .NextEnemyFlag                                            ; переход, если тип отряда допускает действие заклинания

                SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)                     ; флаг, временно исключить отряд из повторного выбора цели
.NextEnemyFlag  LD DE, #0012
                ADD IX, DE
                DJNZ .EnemyFlags

                ; проверка наличия допустимого заклинания перед повторным случайным выбором
.ChooseSpell    LD HL, Battle.SpendAIMagic.NoFreeze
                LD B, #0A
                LD A, #01
.AllBlocked     AND (HL)
                INC HL
                DJNZ .AllBlocked

                BIT SPELL_BLOCK_BIT, A                                          ; флаг, это заклинание исключено из выбора ИИ в текущей попытке
                RET NZ                                                          ; выход, если все десять заклинаний исключены

                ; случайные попытки продолжаются, пока выбранный номер не имеет запрета
.PickAvailable  LD DE, #0009
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD HL, Battle.SpendAIMagic.NoFreeze
                ADD HL, DE
                BIT SPELL_BLOCK_BIT, (HL)                                       ; флаг, это заклинание исключено из выбора ИИ в текущей попытке
                JR NZ, .PickAvailable                                           ; переход, если выбранное заклинание исключено

                INC E
                LD A, E
                CP #07
                JR NZ, .TryTeleport                                             ; переход, если выбрана не волшебная стена

                LD A, (Battle.SpendAIMagic.NoWall)
                SET SPELL_BLOCK_BIT, A                                          ; флаг, это заклинание исключено из выбора ИИ в текущей попытке
                LD (Battle.SpendAIMagic.NoWall), A
                JP .ChooseSpell

.TryTeleport    CP #04
                JP NZ, .TrySubjugate                                            ; переход, если выбрана не телепортация

.FindMover      XOR A
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD HL, Battle.SpendAIMagic.BestScore
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD HL, #0000
                LD (Battle.SpendAIMagic.MovingUnit), HL
                LD IX, Battle.FinishField.EnemyArmy
                LD B, #05

                ; выбирается максимальная оценка переносимого отряда, при равенстве остаётся последний кандидат
                ; поиск наиболее весомого отряда противника, пригодного для переноса
.MoverLoop      LD A, (IX + FBattleUnit.UnitID)
                OR A
                JR Z, .MoverReady                                               ; переход, если перебраны все отряды для телепортации

                LD A, (IX + FBattleUnit.Flags)
                AND #27
                JR NZ, .NextMover                                               ; переход, если отряд умеет стрелять, летать или уже отмечен

                LD HL, Battle.SpendAIMagic.TrialScore
                CALL StackStrength                                              ; вычислить весовую оценку боевого отряда
                LD HL, Battle.SpendAIMagic.TrialScore
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Battle.SpendAIMagic.BestScore
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                JR C, .NextMover                                                ; переход, если оценка отряда меньше сохранённой

                PUSH BC
                LD HL, Battle.SpendAIMagic.TrialScore
                LD DE, Battle.SpendAIMagic.BestScore
                LD BC, #0005
                LDIR
                POP BC
                LD (Battle.SpendAIMagic.MovingUnit), IX
.NextMover      LD DE, #0012
                ADD IX, DE
                DJNZ .MoverLoop

.MoverReady     LD HL, (Battle.SpendAIMagic.MovingUnit)
                LD A, H
                OR L
                JR NZ, .PickMoveTarget                                          ; переход, если отряд для телепортации найден

                LD A, (Battle.SpendAIMagic.NoTeleport)
                SET SPELL_BLOCK_BIT, A                                          ; флаг, это заклинание исключено из выбора ИИ в текущей попытке
                LD (Battle.SpendAIMagic.NoTeleport), A
                JP .ChooseSpell

                ; выбор цели переноса и проверка возможности разместить отряд рядом
.PickMoveTarget LD IY, Battle.SpendAIMagic.SpellRules
                LD HL, Battle.FinishField.HeroArmy
                CALL ChooseTarget                                               ; выбрать отряд по таблице приоритетов и минимальной весовой оценке
                LD IY, (Battle.SpendAIMagic.MovingUnit)
                JR NZ, .MarkNearTarget                                          ; переход, если цель для телепортации найдена

.SkipMover      SET UNIT_MARK_BIT, (IY + FBattleUnit.Flags)                     ; флаг, временная отметка соседства или кандидата в текущем проходе выбора цели
                JP .FindMover

.MarkNearTarget LD (Battle.SpendAIMagic.MoveTarget), IX
                LD L, (IY + FBattleUnit.X)
                LD H, (IY + FBattleUnit.Y)
                CALL MarkAdjacent                                               ; пометить отряды героя, стоящие не далее одной клетки от заданной
                LD IX, Battle.FinishField.HeroArmy
                LD B, #05
.NearHeroLoop   LD A, (IX + FBattleUnit.UnitID)
                OR A
                JR Z, .FindLanding                                              ; переход, если список отрядов героя завершён

                BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)                     ; флаг, временная отметка соседства или кандидата в текущем проходе выбора цели
                JR Z, .NextNearHero                                             ; переход, если отряд не соседствует с переносимым бойцом

                PUSH IX
                POP HL
                LD DE, (Battle.SpendAIMagic.MoveTarget)
                OR A
                SBC HL, DE
                JP Z, .SkipMover                                                ; переход, если переносимый отряд уже соседствует с выбранной целью

.NextNearHero   LD DE, #0012
                ADD IX, DE
                DJNZ .NearHeroLoop

                ; поиск свободной клетки вокруг цели, при неудаче выбирается другая цель
.FindLanding    LD IX, (Battle.SpendAIMagic.MoveTarget)
                LD C, (IX + FBattleUnit.X)
                LD B, (IX + FBattleUnit.Y)
                LD DE, #0000
                CALL BuildNeighbours                                            ; построить восемь соседних клеток в порядке приближения к цели
                LD HL, Battle.ClassifyCells.Candidates
                LD B, #08
.LandingLoop    LD A, (HL)
                OR A
                JR Z, .CastTeleport                                             ; переход, если клетка возле цели свободна

                INC HL
                INC HL
                INC HL
                DJNZ .LandingLoop

                SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)                     ; флаг, временно исключить отряд из повторного выбора цели
                JR .PickMoveTarget

                ; списание силы и анимация переноса выбранного отряда
.CastTeleport   LD A, #04
                CALL SpendAIMagic                                               ; списать цену и показать применяемое противником заклинание
                LD C, (IY + FBattleUnit.X)
                LD B, (IY + FBattleUnit.Y)
                CALL DirtyCell                                                  ; пометить экранный объект клетки как пустой для перерисовки
                INC HL
                LD E, (HL)
                INC HL
                LD D, (HL)
                PUSH DE
                CALL AnimatePath                                                ; провести мигающую анимацию от исходной клетки к целевой
                POP DE
                LD (IY + FBattleUnit.X), E
                LD (IY + FBattleUnit.Y), D
                LD A, #64
                CALL MakeActingUnit                                             ; сформировать четырёхкадровый объект действующего отряда
                CALL WaitMoveFrames                                             ; выдержать сорок кадров анимации перемещения
                LD A, #63
                CALL MakeStaticUnit                                             ; сформировать неподвижный объект отряда и его отображаемое количество
                RET

.TrySubjugate   CP #0A
                JP NZ, .TryWard                                                 ; переход, если выбрано не подчинение

                LD IY, Battle.SpendAIMagic.SpellRules
                LD HL, Battle.FinishField.HeroArmy
                CALL ChooseTarget                                               ; выбрать отряд по таблице приоритетов и минимальной весовой оценке
                JR NZ, .CastSubjugate                                           ; переход, если найдена цель подчинения

                LD A, (Battle.SpendAIMagic.NoSubjugate)
                SET SPELL_BLOCK_BIT, A                                          ; флаг, это заклинание исключено из выбора ИИ в текущей попытке
                LD (Battle.SpendAIMagic.NoSubjugate), A
                JP .ChooseSpell

                ; подчинённая численность добавляется к имеющемуся отряду зомби
.CastSubjugate  LD A, #0A
                CALL SpendAIMagic                                               ; списать цену и показать применяемое противником заклинание
                LD IY, Battle.FinishField.EnemyArmy - FBattleUnit               ; база поиска зомби до первого отряда, цикл сначала прибавляет18байтов
                LD DE, #0012
.FindZombieUnit ADD IY, DE
                LD A, (IY + FBattleUnit.UnitID)
                CP #13
                JR NZ, .FindZombieUnit                                          ; переход, если пока не найден отряд зомби

                LD BC, #0007
                LD D, (IX + FBattleUnit.Y)
                LD E, (IX + FBattleUnit.X)
                CALL AnimatePath                                                ; провести мигающую анимацию от исходной клетки к целевой
                PUSH IY
                POP HL
                INC HL
                INC HL
                PUSH HL
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                PUSH IX
                POP HL
                INC HL
                INC HL
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F                                                          ; addition, сложение, EDF6
                DB #38                                                          ; end-calc, возврат в Z80, EDF7
                POP HL
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD (IX + FBattleUnit.Quantity), #00
                LD (IX + FBattleUnit.Quantity + 1), #00
                LD (IX + FBattleUnit.Quantity + 2), #00
                LD (IX + FBattleUnit.Quantity + 3), #00
                LD (IX + FBattleUnit.Quantity + 4), #00
                PUSH IX
                PUSH IY
                POP IX
                POP IY
                CALL ResolveLosses                                              ; удалить погибших, обработать бунт и проверить исход боя
                CALL DrawBothArmies                                             ; обновить экранные объекты обеих армий
                HALT
                RET

.TryWard        CP #09
                JP NZ, .TryInvisible                                            ; переход, если выбран не магический щит

                LD HL, (Battle.FinishField.EnemyMana)
                LD DE, #4E20
                OR A
                SBC HL, DE
                JR NC, .CastWard                                                ; переход, если у противника осталось не менее 20000 маны

                LD A, (Battle.SpendAIMagic.NoWard)
                SET SPELL_BLOCK_BIT, A                                          ; флаг, это заклинание исключено из выбора ИИ в текущей попытке
                LD (Battle.SpendAIMagic.NoWard), A
                JP .ChooseSpell

                ; списание силы и включение защиты стороны противника
.CastWard       LD A, #09
                CALL SpendAIMagic                                               ; списать цену и показать применяемое противником заклинание
                CALL WaitMoveFrames                                             ; выдержать сорок кадров анимации перемещения
                LD A, (Battle.FinishField.Flags)
                SET ENEMY_WARD_BIT, A                                           ; флаг, армия противника защищена магическим щитом
                LD (Battle.FinishField.Flags), A
                RET

.TryInvisible   CP #08
                JP NZ, .TryClone                                                ; переход, если выбрана не невидимость

                LD IY, Battle.FinishField.EnemyArmy
                LD B, #05

                ; проверка источников и достижимых целей для временного эффекта
.EffectSource   LD A, (IY + FBattleUnit.UnitID)
                OR A
                JR Z, .PickEffectUnit                                           ; переход, если список возможных источников эффекта завершён

                PUSH BC
                PUSH IY
                LD IY, Battle.FinishField.HeroArmy
                CALL ResetTurnFlags                                             ; очистить временные флаги одной армии
                POP IY
                CALL MarkInRange                                                ; отметить цели героя в пределах подвижности отряда компьютера
                LD IX, Battle.FinishField.HeroArmy
                LD DE, #0012
                LD B, #05
.ReachableHero  LD A, (IX + FBattleUnit.UnitID)
                OR A
                JR Z, .RejectSource                                             ; переход, если перебор армии героя завершён без достижимой цели

                BIT HERO_REACH_BIT, (IX + FBattleUnit.Flags)                    ; флаг, отряд героя достижим для проверяемого отряда ИИ
                JR NZ, .NextSource                                              ; переход, если найдена достижимая цель для этого отряда

                ADD IX, DE
                DJNZ .ReachableHero

.RejectSource   SET UNIT_SKIP_BIT, (IY + FBattleUnit.Flags)                     ; флаг, временно исключить отряд из повторного выбора цели
.NextSource     POP BC
                ADD IY, DE
                DJNZ .EffectSource

.PickEffectUnit LD HL, Battle.FinishField.EnemyArmy
                LD IY, Battle.SpendAIMagic.SpellRules
                CALL ChooseTarget                                               ; выбрать отряд по таблице приоритетов и минимальной весовой оценке
                JR NZ, .CastInvisible                                           ; переход, если найдена цель невидимости

                LD A, (Battle.SpendAIMagic.NoInvisible)
                SET SPELL_BLOCK_BIT, A                                          ; флаг, это заклинание исключено из выбора ИИ в текущей попытке
                LD (Battle.SpendAIMagic.NoInvisible), A
                JP .ChooseSpell

                ; применение невидимости, номер эффекта 8 и длительность два раунда
.CastInvisible  LD A, #08
                CALL SpendAIMagic                                               ; списать цену и показать применяемое противником заклинание
                LD BC, #0007
                LD D, (IX + FBattleUnit.Y)
                LD E, (IX + FBattleUnit.X)
                CALL AnimatePath                                                ; провести мигающую анимацию от исходной клетки к целевой
                LD (IX + FBattleUnit.Effect), #82
                RET

.TryClone       CP #06
                JP NZ, .TryBanish                                               ; переход, если выбрано не клонирование

                LD IY, Battle.SpendAIMagic.SpellRules
                LD HL, Battle.FinishField.EnemyArmy
                CALL ChooseTarget                                               ; выбрать отряд по таблице приоритетов и минимальной весовой оценке
                JR NZ, .CastClone                                               ; переход, если найдена цель клонирования

                LD A, (Battle.SpendAIMagic.NoClone)
                SET SPELL_BLOCK_BIT, A                                          ; флаг, это заклинание исключено из выбора ИИ в текущей попытке
                LD (Battle.SpendAIMagic.NoClone), A
                JP .ChooseSpell

                ; клонирование увеличивает численность выбранного отряда и устанавливает эффект #62 на два раунда
.CastClone      LD A, #06
                CALL SpendAIMagic                                               ; списать цену и показать применяемое противником заклинание
                LD BC, #0007
                LD D, (IX + FBattleUnit.Y)
                LD E, (IX + FBattleUnit.X)
                CALL AnimatePath                                                ; провести мигающую анимацию от исходной клетки к целевой
                LD BC, #060F
                LD DE, (Battle.FinishField.EnemyMana)
                CALL ApplySpell                                                 ; изменить количество цели по силе заклинания
                LD (IX + FBattleUnit.Effect), #62
                PUSH IX
                POP IY
                LD A, #63
                CALL MakeStaticUnit                                             ; сформировать неподвижный объект отряда и его отображаемое количество
                RET

.TryBanish      CP #05
                JP NZ, .TryBallBolt                                             ; переход, если выбрано не возвращение в могилу

                LD IX, Battle.FinishField.HeroArmy
                LD B, #05

                ; исключение типов без разрешающего признака для заклинания «Вернуть в могилу»
.SpellUnitFlags LD A, (IX + FBattleUnit.UnitID)
                OR A
                JR Z, .PickDamageUnit                                           ; переход, если список отрядов героя завершён

                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                BIT BANISH_OK_BIT, D                                            ; флаг, тип цели допускает выбор ИИ для заклинания возвращения в могилу
                JR NZ, .NextSpellUnit                                           ; переход, если тип допускает возвращение в могилу и его не нужно исключать

                SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)                     ; флаг, временно исключить отряд из повторного выбора цели
.NextSpellUnit  LD DE, #0012
                ADD IX, DE
                DJNZ .SpellUnitFlags

.PickDamageUnit LD HL, Battle.FinishField.HeroArmy
                LD IY, Battle.SpendAIMagic.SpellRules
                CALL ChooseTarget                                               ; выбрать отряд по таблице приоритетов и минимальной весовой оценке
                JR NZ, .CastBanish                                              ; переход, если найдена цель возвращения в могилу

                LD A, (Battle.SpendAIMagic.NoBanish)
                SET SPELL_BLOCK_BIT, A                                          ; флаг, это заклинание исключено из выбора ИИ в текущей попытке
                LD (Battle.SpendAIMagic.NoBanish), A
                JP .ChooseSpell

.CastBanish     LD A, #05
                CALL SpendAIMagic                                               ; списать цену и показать применяемое противником заклинание
                LD BC, #0007
                LD D, (IX + FBattleUnit.Y)
                LD E, (IX + FBattleUnit.X)
                CALL AnimatePath                                                ; провести мигающую анимацию от исходной клетки к целевой
                LD BC, #0503
                LD DE, (Battle.FinishField.EnemyMana)
                CALL ApplySpell                                                 ; изменить количество цели по силе заклинания
                PUSH IX
                POP IY
                LD IX, Battle.FinishField.EnemyArmy
                CALL ResolveLosses                                              ; удалить погибших, обработать бунт и проверить исход боя
                RET

.TryBallBolt    CP #03
                JP NZ, .TryAttackSpell                                          ; переход, если выбрана не шаровая молния

                LD HL, Battle.FinishField.HeroArmy
                LD IY, Battle.SpendAIMagic.SpellRules
                CALL ChooseTarget                                               ; выбрать отряд по таблице приоритетов и минимальной весовой оценке
                JR NZ, .CastBallBolt                                            ; переход, если найдена цель шаровой молнии

                LD A, (Battle.SpendAIMagic.NoBallBolt)
                SET SPELL_BLOCK_BIT, A                                          ; флаг, это заклинание исключено из выбора ИИ в текущей попытке
                LD (Battle.SpendAIMagic.NoBallBolt), A
                JP .ChooseSpell

.CastBallBolt   LD A, #03
                CALL SpendAIMagic                                               ; списать цену и показать применяемое противником заклинание
                LD BC, #0007
                LD D, (IX + FBattleUnit.Y)
                LD E, (IX + FBattleUnit.X)
                CALL AnimatePath                                                ; провести мигающую анимацию от исходной клетки к целевой
                LD BC, #0303
                LD DE, (Battle.FinishField.EnemyMana)
                CALL ApplySpell                                                 ; изменить количество цели по силе заклинания
                PUSH IX
                POP IY
                LD IX, Battle.FinishField.EnemyArmy
                CALL ResolveLosses                                              ; удалить погибших, обработать бунт и проверить исход боя
                RET

.TryAttackSpell LD (Battle.AISpell.AttackSpell), A
                LD IX, Battle.FinishField.HeroArmy
                LD DE, #0012
                LD B, #05
.SkipSkeletons  LD A, (IX + FBattleUnit.UnitID)
                CP #12
                JR NZ, .NextHeroUnit                                            ; переход, если отряд не является скелетами

                SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)                     ; флаг, временно исключить отряд из повторного выбора цели
.NextHeroUnit   ADD IX, DE
                DJNZ .SkipSkeletons

                LD IY, Battle.FinishField.EnemyArmy
                LD B, #05
.ReachableArmy  LD A, (IY + FBattleUnit.UnitID)
                OR A
                JR Z, .PickAttackUnit                                           ; переход, если список отрядов противника завершён

                PUSH BC
                CALL MarkInRange                                                ; отметить цели героя в пределах подвижности отряда компьютера
                POP BC
                LD DE, #0012
                ADD IY, DE
                DJNZ .ReachableArmy

                ; выбор цели из отрядов, отмеченных достижимыми предыдущим проходом
.PickAttackUnit LD HL, Battle.FinishField.HeroArmy
                LD IY, Battle.SpendAIMagic.AttackRules
                CALL ChooseTarget                                               ; выбрать отряд по таблице приоритетов и минимальной весовой оценке
                JR NZ, .CastAttack                                              ; переход, если найдена цель атакующего заклинания

.AttackSpell    EQU $+1                                                         ; операнд ID выбранного атакующего заклинания
                LD BC, #0000
                LD HL, Battle.SpendAIMagic.NoFreeze - 1                         ; смещённая база десяти запретов заклинаний, ID начинается с1
                ADD HL, BC
                SET SPELL_BLOCK_BIT, (HL)                                       ; флаг, это заклинание исключено из выбора ИИ в текущей попытке
                JP .ChooseSpell

.CastAttack     LD A, (Battle.AISpell.AttackSpell)
                CALL SpendAIMagic                                               ; списать цену и показать применяемое противником заклинание
                LD BC, #0007
                LD D, (IX + FBattleUnit.Y)
                LD E, (IX + FBattleUnit.X)
                CALL AnimatePath                                                ; провести мигающую анимацию от исходной клетки к целевой
                LD DE, (Battle.FinishField.EnemyMana)
                LD A, (Battle.AISpell.AttackSpell)
                LD B, A
                LD C, #03
                CALL ApplySpell                                                 ; изменить количество цели по силе заклинания
                LD HL, Battle.PickOccupied.EffectCodes                          ; четыре начальных кода эффекта для индексов заклинаний0..3
                LD A, (Battle.AISpell.AttackSpell)
                LD C, A
                LD B, #00
                ADD HL, BC
                LD A, (HL)
                LD (IX + FBattleUnit.Effect), A
                PUSH IX
                POP IY
                LD IX, Battle.FinishField.EnemyArmy
                CALL ResolveLosses                                              ; удалить погибших, обработать бунт и проверить исход боя
                RET
