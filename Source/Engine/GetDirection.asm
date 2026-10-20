
; -----------------------------------------
; определить одно из восьми направлений от BC к DE
; разности E-C и D-B сохраняются #7D1A/#7D1B, знак и отношение абсолютных разностей обрабатываются
; с ROM калькулятором, A возвращает код направления, DE адрес соответствующего названия в списке
; после #7D1B, HL, BC, IX, IY сохранены
; In:
;   DE координаты цели, BC исходные координаты
; Out:
;   DE адрес названия направления, AF, A код 1..8, HL, BC, IX, IY сохранены
; Corrupt:
;   DE, AF, рабочие разности #7D1A/#7D1B, альтернативные HL', DE', BC', AF' могут изменяться
;   вызываемым калькулятором ROM и здесь не сохраняются
; -----------------------------------------
GetDirection    PUSH HL
                PUSH BC
                PUSH IX
                PUSH IY
                LD A, E
                SUB C
                LD (Engine.GetDirection.DeltaX), A
                LD A, D
                SUB B
                LD (Engine.GetDirection.DeltaY), A
                LD IX, Engine.GetDirection.DeltaX
                LD A, (Engine.GetDirection.DeltaX)
                OR A
                JR Z, .VerticalAxis                                             ; переход, если цель находится в той же колонке

                LD A, (Engine.GetDirection.DeltaY)
                OR A
                JR Z, .HorizontalAxis                                           ; переход, если цель находится в той же строке

                LD A, (Engine.GetDirection.DeltaY)
                BIT DELTA_NEG_BIT, A                                            ; знак отрицательной однобайтовой разности координат
                JR Z, .StackDeltaY                                              ; переход, если вертикальная разность уже неотрицательна

                NEG

                ; абсолютные разности координат передаются калькулятору для оценки угла
.StackDeltaY    LD C, A
                LD B, #00
                CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
                LD A, (Engine.GetDirection.DeltaX)
                BIT DELTA_NEG_BIT, A                                            ; знак отрицательной однобайтовой разности координат
                JR Z, .StackDeltaX                                              ; переход, если горизонтальная разность уже неотрицательна

                NEG
.StackDeltaX    LD C, A
                LD B, #00
                CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05                                                          ; division, деление, 7CB0
                DB #24                                                          ; atn, арктангенс, 7CB1
                DB #38                                                          ; end-calc, возврат в Z80, 7CB2
                LD BC, #005A
                CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #A3                                                          ; stk-pi/2, константа pi/2, 7CBA
                DB #05                                                          ; division, деление, 7CBB
                DB #04                                                          ; multiply, умножение, 7CBC
                DB #27                                                          ; int, округление вниз, 7CBD
                DB #38                                                          ; end-calc, возврат в Z80, 7CBE
                CALL PopBC                                                      ; извлечь результат калькулятора ROM в BC
                LD IX, Engine.GetDirection.DeltaX
                LD A, C
                CP #17
                JR NC, .CheckDiagonal                                           ; переход, если угол отклонения достиг диагонального сектора

.HorizontalAxis LD A, #03
                BIT DELTA_NEG_BIT, (IX + FPosition.X)                           ; знак отрицательной однобайтовой разности координат
                JR Z, .SelectName                                               ; переход, если цель находится справа

                LD A, #07
                JR .SelectName

                ; по углу и знакам разностей выбирается диагональное направление
.CheckDiagonal  CP #44
                JR NC, .VerticalAxis                                            ; переход, если угол отклонения достиг вертикального сектора

                LD A, #02
                BIT DELTA_NEG_BIT, (IX + FPosition.X)                           ; знак отрицательной однобайтовой разности координат
                JR NZ, .WestDiagonal                                            ; переход, если цель находится слева

                BIT DELTA_NEG_BIT, (IX + FPosition.Y)                           ; знак отрицательной однобайтовой разности координат
                JR NZ, .SelectName                                              ; переход, если цель находится сверху

                LD A, #04
                JR .SelectName

.WestDiagonal   BIT DELTA_NEG_BIT, (IX + FPosition.Y)                           ; знак отрицательной однобайтовой разности координат
                JR NZ, .NorthWest                                               ; переход, если цель находится сверху и слева

                LD A, #06
                JR .SelectName

.NorthWest      LD A, #08
                JR .SelectName

.VerticalAxis   LD A, #01
                BIT DELTA_NEG_BIT, (IX + FPosition.Y)                           ; знак отрицательной однобайтовой разности координат
                JR NZ, .SelectName                                              ; переход, если цель находится сверху

                LD A, #05

                ; получение строки названия для вычисленного кода направления
.SelectName     PUSH AF
                LD B, A
                LD DE, .DirectionNames - 1
.SkipName       INC DE
                LD A, (DE)
                OR A
                JR NZ, .SkipName                                                ; переход, если не достигнут конец пропускаемого названия направления

                DJNZ .SkipName

                POP AF
                INC DE
                POP IY
                POP IX
                POP BC
                POP HL
                RET

.DeltaX         EQU $                                                           ; знаковая горизонтальная разность координат
.DeltaY         EQU $+1                                                         ; знаковая вертикальная разность координат
.DirectionNames EQU $+2                                                         ; нулевая строка перед восемью названиями направлений
                DB #00, #00, #00, #E1, #A5, #A2, #A5, #E0
                DB #A5, #00, #E1, #A5, #A2, #A5, #E0, #AE
                DB #2D, #A2, #AE, #E1, #E2, #AE, #AA, #A5
                DB #00, #A2, #AE, #E1, #E2, #AE, #AA, #A5
                DB #00, #EE, #A3, #AE, #2D, #A2, #AE, #E1
                DB #E2, #AE, #AA, #A5, #00, #EE, #A3, #A5
                DB #00, #EE, #A3, #AE, #2D, #A7, #A0, #AF
                DB #A0, #A4, #A5, #00, #A7, #A0, #AF, #A0
                DB #A4, #A5, #00, #E1, #A5, #A2, #A5, #E0
                DB #AE, #2D, #A7, #A0, #AF, #A0, #A4, #A5
                DB #00
