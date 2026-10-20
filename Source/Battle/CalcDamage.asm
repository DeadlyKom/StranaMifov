
; -----------------------------------------
; рассчитать пятибайтный урон по подготовленным коэффициентам
; основа на стеке ROM=(F416/F41F)*float(F41B), r выбирается 0..2*low(F418)-1, p=floor(r/2)/100,
; при r<=low(F418) основа умножается на 1-p, иначе на 1+p, затем на low(F41D)/high(F41D),
; последняя поправка F414/F415 комбинируется токеном по F3F2, F0A0 ставит 05 для деления при
; первой атаке или 04 для умножения при ответе
; In:
;   F416 совместимость, F41F делитель, F41B количество, F418 разброс, F41D поправка, F414/F415
;   эффекты
; Out:
;   float5 результата на стеке ROM
; Corrupt:
;   HL, DE, BC, AF, состояние калькулятора и генератора 7C69..7C70, IX и IY не используются
;   собственным кодом
; -----------------------------------------

                ; основа урона, совместимость типов делится на делитель описателя и умножается на численность атакующего
CalcDamage      LD BC, (Battle.MeleeMatchup.MatchFactor)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                LD BC, (Battle.MeleeMatchup.DamageDivisor)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05                                                          ; division, деление, F39A
                DB #38                                                          ; end-calc, возврат в Z80, F39B
                LD HL, (Battle.MeleeMatchup.QuantityPtr)
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #04                                                          ; multiply, умножение, F3A3
                DB #38                                                          ; end-calc, возврат в Z80, F3A4
                LD A, #01
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM

                ; получение случайного отклонения с диапазоном, заданным младшим байтом разброса
                LD DE, (Battle.MeleeMatchup.DamageSpread)
                SLA E
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD A, E
                PUSH AF

                ; перевод половины случайного отклонения в процентную дробь
                SRL A
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD A, #64
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05                                                          ; division, деление, F3C0
                DB #38                                                          ; end-calc, возврат в Z80, F3C1
                POP AF
                LD E, A
                LD A, (Battle.MeleeMatchup.DamageSpread)
                CP E
                JR NC, .ApplyRatio                                              ; переход, если случайное отклонение не превышает базовый разброс, урон уменьшается

                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F                                                          ; addition, сложение, F3CB
                DB #04                                                          ; multiply, умножение, F3CC
                DB #38                                                          ; end-calc, возврат в Z80, F3CD
                JR .ApplyDamage

.ApplyRatio     RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #03                                                          ; subtract, вычитание, F3D1
                DB #04                                                          ; multiply, умножение, F3D2
                DB #38                                                          ; end-calc, возврат в Z80, F3D3

                ; применение табличной поправки, затем поправок временных эффектов участников
.ApplyDamage    LD A, (Battle.MeleeMatchup.MoodNumerator)
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD A, (Battle.MeleeMatchup.MoodDenom)
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05                                                          ; division, деление, F3E1
                DB #04                                                          ; multiply, умножение, F3E2
                DB #38                                                          ; end-calc, возврат в Z80, F3E3
                LD A, (Battle.MeleeMatchup.AttackerEffect)
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD A, (Battle.MeleeMatchup.DefenderEffect)
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05                                                          ; division, деление, F3F1
.EffectOp       DB #04                                                          ; токен калькулятора, деление при первой атаке либо умножение при ответе
                DB #38                                                          ; end-calc, возврат в Z80, F3F3
                RET
