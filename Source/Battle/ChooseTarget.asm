
; -----------------------------------------
; выбрать отряд по таблице приоритетов и минимальной весовой оценке
; HL патчит два операнда LD IX началом армии, IY задаёт цепочку групп count, значения с
; терминатором FF, бит 6 поля +9 и эффект 80 исключают отряд, стрелковые флаги без боеприпасов +8
; нормализуются, маска 17 выделяет дальность и тип, на первом подходящем приоритете ставит бит 5
; кандидатов, E8AD оставляет минимальную пятибайтную весовую оценку, смещение CP (IY+d)
; изменяется по числу условий группы
; In:
;   HL массив FCED либо FD47, IY правила
; Out:
;   IX выбранный отряд, A=FF и Z=0 успех, Z=1 подходящего нет
; Corrupt:
;   HL, DE, BC, AF, IX, IY, операнды E7F0/E821/E83D, бит 5 кандидатов, оценки E8D7..E8E0,
;   указатель E8E1 и состояние калькулятора
; -----------------------------------------
ChooseTarget    LD (Battle.ChooseTarget.ArmyStart), HL
                LD (Battle.ChooseTarget.ArmyScan), HL

                ; переход к следующему правилу допустимого типа цели
.NextRule       INC IY
                XOR A
                LD (Battle.ChooseTarget.RuleOffset), A
.RuleArmy       LD B, #05
.ArmyStart      EQU $+2                                                         ; операнд начала армии при фильтрации кандидатов
                LD IX, Battle.FinishField.HeroArmy

                ; фильтрация армии по временному исключению, эффекту и маске выбранного правила
.RuleUnit       LD A, (IX + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                OR A
                JR Z, .NextRulePass                                             ; переход, если список отрядов завершён

                BIT UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)                     ; +#09, флаг, временно исключить отряд из повторного выбора цели
                JR NZ, .NextRuleUnit                                            ; переход, если отряд временно исключён из выбора

                LD A, (IX + FBattleUnit.Effect)                                 ; +#0D, старшая тетрада вид эффекта, младшая оставшаяся длительность
                AND #F0
                CP #80
                JR Z, .NextRuleUnit                                             ; переход, если невидимость исключает отряд из выбора цели

                LD A, (IX + FBattleUnit.Flags)                                  ; +#09, способности и временные отметки раунда, цели и контроля
                AND #03
                JR Z, .MatchRule                                                ; переход, если отряд не имеет дальнего действия

                LD A, (IX + FBattleUnit.ActionStock)                            ; +#08, остаток расходуемого дальнего действия
                OR A
                JR Z, .MatchRule                                                ; переход, если запас дальнего действия исчерпан

                LD A, #03
.MatchRule      LD C, A
                LD A, (IX + FBattleUnit.Flags)                                  ; +#09, способности и временные отметки раунда, цели и контроля
                AND #FC
                OR C
                AND #17
.RuleOffset     EQU $+2                                                         ; изменяемое смещение CP (IY+d), номер условия текущей группы правил
                CP (IY + FTargetRule.Value)
                JR NZ, .NextRuleUnit                                            ; переход, если тип возможностей не совпал с текущим условием правила

                SET UNIT_MARK_BIT, (IX + FBattleUnit.Flags)                     ; +#09, флаг, временная отметка соседства или кандидата в текущем проходе выбора цели
.NextRuleUnit   LD DE, #0012
                ADD IX, DE
                DJNZ .RuleUnit

.NextRulePass   LD A, (Battle.ChooseTarget.RuleOffset)
                INC A
                LD (Battle.ChooseTarget.RuleOffset), A
                CP (IY + FTargetRule.Count)
                JR C, .RuleArmy                                                 ; переход, если в группе остались непроверенные условия

.ArmyScan       EQU $+2                                                         ; операнд начала армии при поиске первого кандидата
                LD IX, Battle.FinishField.HeroArmy
                LD B, #05

                ; поиск первого отмеченного кандидата для начальной весовой оценки
.FindCandidate  BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)                     ; +#09, флаг, временная отметка соседства или кандидата в текущем проходе выбора цели
                JR NZ, .KeepBest                                                ; переход, если найден отмеченный кандидат

                LD DE, #0012
                ADD IX, DE
                DJNZ .FindCandidate

                LD C, (IY + FTargetRule.Count)
                LD B, #00
                ADD IY, BC
                LD A, (IY + FTargetRule.Value)
                CP #FF
                JR NZ, .NextRule                                                ; переход, если цепочка правил ещё не закончилась

                RET

                ; сохранение лучшего кандидата и его пятибайтовой весовой оценки
.KeepBest       LD (Battle.StackStrength.BestUnit), IX
                LD HL, Battle.StackStrength.BestScore
                CALL StackStrength                                              ; вычислить весовую оценку боевого отряда

                ; сравнение оставшихся отмеченных кандидатов с уже выбранным отрядом
.NextCandidate  DEC B
                JR Z, .ReturnBest                                               ; переход, если проверены все пять записей армии

                LD DE, #0012
                ADD IX, DE
                LD A, (IX + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                OR A
                JR Z, .ReturnBest                                               ; переход, если список отрядов завершён

                BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)                     ; +#09, флаг, временная отметка соседства или кандидата в текущем проходе выбора цели
                JR Z, .NextCandidate                                            ; переход, если отряд не отмечен как кандидат

                LD HL, Battle.StackStrength.TrialScore
                CALL StackStrength                                              ; вычислить весовую оценку боевого отряда
                LD HL, Battle.StackStrength.TrialScore
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Battle.StackStrength.BestScore
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                ; выбирается минимальная оценка, равенство оставляет первый найденный отряд
                JR NC, .NextCandidate                                           ; переход, если оценка кандидата не меньше сохранённой, предпочтительнее меньшая

                PUSH BC
                LD HL, Battle.StackStrength.TrialScore
                LD DE, Battle.StackStrength.BestScore
                LD BC, #0005
                LDIR
                LD (Battle.StackStrength.BestUnit), IX
                POP BC
                JR .NextCandidate

.ReturnBest     LD IX, (Battle.StackStrength.BestUnit)
                LD A, #FF
                OR A
                RET
