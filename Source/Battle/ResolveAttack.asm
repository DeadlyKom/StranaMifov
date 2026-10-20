
; -----------------------------------------
; рассчитать атаку и возможный ответный удар
; меняет IX/IY местами и сохраняет атакующего F421 и цель F423, F2A1 отмечает участие своих
; отрядов, эффект 80 цели обнуляет первый урон, иначе F38B рассчитывает урон по табличной
; совместимости, численности, разбросу и коэффициентам, F2F1 восстанавливает атакующего по
; специальному признаку, режим 1 разрешает ответ, прочие обнуляют его, эффект 80 атакующего
; запрещает ответ, количество F421 уменьшается на ответ F426, количество F423 на основной урон
; F42B, F337 ограничивает восстановление исходной численностью
; In:
;   IY атакующий, IX цель, A=1 рукопашная с ответом, A=2 дальняя без ответа
; Out:
;   изменены пятибайтные количества обоих отрядов
; Corrupt:
;   HL, DE, BC, AF, IX, IY, параметры и результаты F414..F43A, операнд калькулятора F3F2,
;   количества участников, постоянные отметки типов и состояние калькулятора
; -----------------------------------------
ResolveAttack   PUSH IX
                PUSH IY
                POP IX
                POP IY
                LD (Battle.MeleeMatchup.Attacker), IX
                LD (Battle.MeleeMatchup.Defender), IY
                LD (Battle.MeleeMatchup.AttackKind), A
                CALL RecordFighters                                             ; отметить участие отрядов героя в столкновении
                LD A, (IY + FBattleUnit.Effect)                                 ; +#0D, старшая тетрада вид эффекта, младшая оставшаяся длительность
                AND #F0
                CP #80
                JR NZ, .BeginAttack                                             ; переход, если цель не находится под невидимостью

                XOR A
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD HL, Battle.MeleeMatchup.MainLoss
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                JP .TestCounter

.BeginAttack    CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                PUSH BC
                CALL DrawAttack                                                 ; вывести маскированное изображение атаки в клетке
                POP BC
                CALL WaitAttack                                                 ; выдержать десять кадров между фазами атаки
                CALL GetCellObject                                              ; получить экранный объект боевой клетки
                LD A, (IX + FScreenObject20.Flags)
                AND #E0
                OR #03
                LD (IX + FScreenObject20.Flags), A
                CALL Engine.StartView                                           ; включить обработку объектов в прерывании
                HALT
                LD IX, (Battle.MeleeMatchup.Attacker)
                LD A, (IX + FBattleUnit.UnitID)
                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                BIT HALF_HIT_BIT, D                                             ; флаг, тип атакующего допускает вероятностный удар с делением численности цели на два
                JR Z, .EffectFactors                                            ; переход, если тип атакующего не имеет особой вероятностной атаки

                LD DE, #0063
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD A, E
                CP #59
                JR C, .EffectFactors                                            ; переход, если случайный отсчёт меньше 89, особая атака не сработала

                LD HL, (Battle.MeleeMatchup.Defender)
                INC HL
                INC HL
                PUSH HL
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD A, #02
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05                                                          ; division, деление, F116
                DB #38                                                          ; end-calc, возврат в Z80, F117
                POP HL
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL

                ; получение поправок временных эффектов атакующего и цели
.EffectFactors  LD IX, (Battle.MeleeMatchup.Attacker)
                LD IY, (Battle.MeleeMatchup.Defender)
                LD A, (IX + FBattleUnit.Effect)
                CALL EffectFactor                                               ; получить коэффициент воздействия временного эффекта
                LD (Battle.MeleeMatchup.AttackerEffect), A
                LD A, (IY + FBattleUnit.Effect)                                 ; +#0D, старшая тетрада вид эффекта, младшая оставшаяся длительность
                CALL EffectFactor                                               ; получить коэффициент воздействия временного эффекта
                LD (Battle.MeleeMatchup.DefenderEffect), A
                LD A, (Battle.MeleeMatchup.AttackKind)
                CP #02
                JR NZ, .MeleeFactor                                             ; переход, если атака не относится к дальнему типу

                LD HL, Battle.MeleeMatchup.RangedRules                          ; семь троек ID атакующего и смещение строки матрицы дальнего действия
                LD A, (IX + FBattleUnit.UnitID)
                CALL RangedMatchup                                              ; получить коэффициент дальнего воздействия для пары типов
                JR .PrepareDamage

                ; выбор совместимости типов для рукопашной атаки
.MeleeFactor    LD B, (IX + FBattleUnit.UnitID)
                LD C, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                CALL MeleeMatchup                                               ; получить слово коэффициента совместимости двух типов в рукопашном бою
                LD (Battle.MeleeMatchup.MatchFactor), DE

                ; подготовка разброса, делителя, численности и совместимости для расчёта урона
.PrepareDamage  LD HL, (Battle.MeleeMatchup.Attacker)
                LD A, (HL)
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD E, (IX + FSoldier.DamageSpread.Low)                          ; +#22, младший байт, слово разброса урона, удваивается только младший байт E без переноса в D
                LD D, (IX + FSoldier.DamageSpread.High)                         ; +#23, старший байт, слово разброса урона, удваивается только младший байт E без переноса в D
                LD (Battle.MeleeMatchup.DamageSpread), DE
                LD E, (IX + FSoldier.DamageDivisor.Low)                         ; +#24, младший байт, делитель базовой формулы урона
                LD D, (IX + FSoldier.DamageDivisor.High)                        ; +#25, старший байт, делитель базовой формулы урона
                LD (Battle.MeleeMatchup.DamageDivisor), DE
                LD IX, (Battle.MeleeMatchup.Attacker)
                INC IX
                INC IX
                LD (Battle.MeleeMatchup.QuantityPtr), IX
                LD B, (IX + FBattleUnit.Affinity - FBattleUnit.Quantity)
                INC B
                INC B
                INC B
                LD IX, Battle.MeleeMatchup.MoodRatios - FWord                   ; смещённая база пяти пар числитель/знаменатель, индекс Affinity+3 начинается с1
.AttackTableRow INC IX
                INC IX
                DJNZ .AttackTableRow

                LD E, (IX + FWord.Low)
                LD D, (IX + FWord.High)
                LD (Battle.MeleeMatchup.MoodNumerator), DE
                LD A, #05
                LD (Battle.CalcDamage.EffectOp), A
                CALL CalcDamage                                                 ; рассчитать пятибайтный урон по подготовленным коэффициентам
                LD HL, Battle.MeleeMatchup.MainLoss
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD IX, (Battle.MeleeMatchup.Attacker)
                LD IY, (Battle.MeleeMatchup.Defender)
                LD HL, Battle.MeleeMatchup.MainLoss
                CALL ApplyDrainTrait                                            ; увеличить количество атакующего за счёт нанесённого воздействия

                ; проверка возможности ответного удара после первого воздействия
.TestCounter    LD A, (Battle.MeleeMatchup.AttackKind)
                CP #01
                JR Z, .CounterAttack                                            ; переход, если атака относится к ближнему типу с ответным ударом

                ; нулевой ответный урон при невозможности контратаки
.NoCounter      XOR A
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD HL, Battle.MeleeMatchup.CounterLoss
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                JP .ApplyLosses

                ; перестановка участников и подготовка ответного удара
.CounterAttack  LD IX, (Battle.MeleeMatchup.Attacker)
                LD A, (IX + FBattleUnit.Effect)
                AND #F0
                CP #80
                JR Z, .NoCounter                                                ; переход, если первый атакующий невидим и ответ по нему невозможен

                LD IY, (Battle.MeleeMatchup.Defender)
                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD C, (IX + FBattleUnit.X)
                LD B, (IX + FBattleUnit.Y)
                PUSH BC
                CALL DrawAttack                                                 ; вывести маскированное изображение атаки в клетке
                POP BC
                CALL WaitAttack                                                 ; выдержать десять кадров между фазами атаки
                CALL GetCellObject                                              ; получить экранный объект боевой клетки
                LD A, (IX + FScreenObject20.Flags)
                AND #E0
                OR #03
                LD (IX + FScreenObject20.Flags), A
                CALL Engine.StartView                                           ; включить обработку объектов в прерывании
                HALT
                LD IX, (Battle.MeleeMatchup.Attacker)
                LD C, (IX + FBattleUnit.UnitID)
                LD B, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                CALL MeleeMatchup                                               ; получить слово коэффициента совместимости двух типов в рукопашном бою
                LD (Battle.MeleeMatchup.MatchFactor), DE
                LD A, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD E, (IX + FSoldier.DamageSpread.Low)                          ; +#22, младший байт, слово разброса урона, удваивается только младший байт E без переноса в D
                LD D, (IX + FSoldier.DamageSpread.High)                         ; +#23, старший байт, слово разброса урона, удваивается только младший байт E без переноса в D
                LD (Battle.MeleeMatchup.DamageSpread), DE
                LD E, (IX + FSoldier.DamageDivisor.Low)                         ; +#24, младший байт, делитель базовой формулы урона
                LD D, (IX + FSoldier.DamageDivisor.High)                        ; +#25, старший байт, делитель базовой формулы урона
                LD (Battle.MeleeMatchup.DamageDivisor), DE
                LD IX, (Battle.MeleeMatchup.Defender)
                INC IX
                INC IX
                LD (Battle.MeleeMatchup.QuantityPtr), IX
                LD B, (IX + FBattleUnit.Affinity - FBattleUnit.Quantity)
                INC B
                INC B
                INC B
                LD IX, Battle.MeleeMatchup.MoodRatios - FWord                   ; смещённая база пяти пар числитель/знаменатель, индекс Affinity+3 начинается с1
.CounterTable   INC IX
                INC IX
                DJNZ .CounterTable

                LD E, (IX + FWord.Low)
                LD D, (IX + FWord.High)
                LD (Battle.MeleeMatchup.MoodNumerator), DE
                LD A, #04
                LD (Battle.CalcDamage.EffectOp), A
                CALL CalcDamage                                                 ; рассчитать пятибайтный урон по подготовленным коэффициентам
                LD HL, Battle.MeleeMatchup.CounterLoss
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD IX, (Battle.MeleeMatchup.Defender)
                LD IY, (Battle.MeleeMatchup.Attacker)
                LD HL, Battle.MeleeMatchup.CounterLoss
                CALL ApplyDrainTrait                                            ; увеличить количество атакующего за счёт нанесённого воздействия

                ; вычитание рассчитанных потерь из пятибайтовой численности участников
.ApplyLosses    LD HL, (Battle.MeleeMatchup.Attacker)
                INC HL
                INC HL
                PUSH HL
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Battle.MeleeMatchup.CounterLoss
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #03                                                          ; subtract, вычитание, F276
                DB #38                                                          ; end-calc, возврат в Z80, F277
                POP HL
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD IX, (Battle.MeleeMatchup.Attacker)
                CALL ClampRegen                                                 ; ограничить количество специального отряда исходной численностью
                LD HL, (Battle.MeleeMatchup.Defender)
                INC HL
                INC HL
                PUSH HL
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Battle.MeleeMatchup.MainLoss
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #03                                                          ; subtract, вычитание, F293
                DB #38                                                          ; end-calc, возврат в Z80, F294
                POP HL
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD IX, (Battle.MeleeMatchup.Defender)
                CALL ClampRegen                                                 ; ограничить количество специального отряда исходной численностью
                RET
