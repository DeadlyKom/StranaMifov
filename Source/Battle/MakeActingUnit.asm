
; -----------------------------------------
; сформировать четырёхкадровый объект действующего отряда
; F626 находит объект, 80DB даёт ресурс, поле 0 сохраняет бит 7 и объединяет его с A, поля 1..4
; равны 1,1,9,4, четыре кадра по три байта содержат банк C и адреса HL с шагом 256, численность
; обрабатывается как в F8BB
; In:
;   IY отряд, A флаг объекта
; Out:
;   анимационный объект и численность обновлены, регистры сохранены
; Corrupt:
;   экранный объект с четырьмя кадрами, связанное слово численности, бит 2 поля 6566 и состояние
;   калькулятора, HL, DE, BC, AF, IX, IY восстанавливаются
; -----------------------------------------
MakeActingUnit  PUSH IX
                PUSH IY
                PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD (Battle.MakeActingUnit.ObjectFlags), A
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL GetCellObject                                              ; получить экранный объект боевой клетки
                PUSH HL
                LD A, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                CALL Engine.UnitSpriteAddr                                      ; выбрать банк и начало четырёхкадрового графического ресурса
                LD A, (IX + FScreenObject20.Flags)
                AND #80
.ObjectFlags    EQU $+1                                                         ; операнд A флагов анимируемого экранного объекта отряда
                OR #64
                LD (IX + FScreenObject20.Flags), A
                LD (IX + FScreenObject20.AnimationTimer), #01
                LD (IX + FScreenObject20.AnimationFrame), #01
                LD (IX + FScreenObject20.AnimationPeriod), #09
                LD (IX + FScreenObject20.FrameCount), #04
                LD B, #04
.FramePointers  LD (IX + FScreenObject20.Frame1Bank), C
                LD (IX + FScreenObject20.Frame1Address.Low), L
                LD (IX + FScreenObject20.Frame1Address.High), H
                INC H
                INC IX
                INC IX
                INC IX
                DJNZ .FramePointers

                PUSH IY
                POP HL
                INC HL
                INC HL
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD A, (IY + FBattleUnit.Quantity)                               ; +#02, пятибайтовое число ROM, сохраняет дробные потери
                OR A
                JR Z, .StoreCount                                               ; переход, если численность хранится в короткой целочисленной форме

                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #27                                                          ; int, округление вниз, F96D
                DB #A1                                                          ; stk-one, константа 1, F96E
                DB #0F                                                          ; addition, сложение, F96F
                DB #38                                                          ; end-calc, возврат в Z80, F970
.StoreCount     CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                POP HL
                LD (HL), C
                INC HL
                LD (HL), B
                CALL Engine.StartView                                           ; включить обработку объектов в прерывании
                POP AF
                POP BC
                POP DE
                POP HL
                POP IY
                POP IX
                RET
