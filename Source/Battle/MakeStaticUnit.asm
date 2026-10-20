
; -----------------------------------------
; сформировать неподвижный объект отряда и его отображаемое количество
; 6D34 выключает обработку объектов, F626 находит объект клетки, 80DB даёт банк C и адрес HL
; ресурса, поля +8,+9,+10 получают ресурс, поле 0 сохраняет бит 7 и объединяет его с входным A,
; количество передаётся на стек ROM, при первом байте !=0 выполняется INT(x)+1, 6D76 переводит его
; в BC и записывает связанное слово численности, 6D57 снова разрешает обработку объектов, эта пара
; процедур меняет бит 2 поля 6566, все сохранённые регистры восстанавливаются
; In:
;   IY отряд, A флаг объекта
; Out:
;   объект и численность обновлены, основные и индексные регистры сохранены
; Corrupt:
;   экранный объект клетки, связанное слово численности, бит 2 поля 6566 и состояние
;   калькулятора, HL, DE, BC, AF, IX, IY восстанавливаются
; -----------------------------------------
MakeStaticUnit  PUSH IX
                PUSH IY
                PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD (Battle.MakeStaticUnit.ObjectFlags), A
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL GetCellObject                                              ; получить экранный объект боевой клетки
                PUSH HL
                LD A, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                CALL Engine.UnitSpriteAddr                                      ; выбрать банк и начало четырёхкадрового графического ресурса
                LD (IX + FScreenObject20.Frame1Bank), C
                LD (IX + FScreenObject20.Frame1Address.Low), L
                LD (IX + FScreenObject20.Frame1Address.High), H
                LD A, (IX + FScreenObject20.Flags)
                AND #80
.ObjectFlags    EQU $+1                                                         ; операнд A флагов неподвижного экранного объекта отряда
                OR #43
                LD (IX + FScreenObject20.Flags), A
                PUSH IY
                POP HL
                INC HL
                INC HL
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD A, (IY + FBattleUnit.Quantity)                               ; +#02, пятибайтовое число ROM, сохраняет дробные потери
                OR A
                JR Z, .StoreCount                                               ; переход, если численность хранится в короткой целочисленной форме

                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #27                                                          ; int, округление вниз, F8FB
                DB #A1                                                          ; stk-one, константа 1, F8FC
                DB #0F                                                          ; addition, сложение, F8FD
                DB #38                                                          ; end-calc, возврат в Z80, F8FE
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
