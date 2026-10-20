
; -----------------------------------------
; определить знак и нулевое значение результата калькулятора
; начинается RST #28 с токеном 03 и END38, результат сохраняется в #6E09, бит 7 #6E0A задаёт
; carry, OR пяти байт задаёт zero, название отражает только проверенные тесты
; In:
;   два верхних числа на стеке калькулятора ROM
; Out:
;   AF, C установлен при отрицательном пятибайтном результате вычитания, Z установлен при всех
;   пяти нулевых байтах, HL, DE, BC, IX, IY сохранены
; Corrupt:
;   AF, альтернативные HL', DE', BC', AF' зависят от внутреннего соглашения ROM и отдельно не
;   проверены, сравнение исследовано по байтам #6E09..#6E0D
; -----------------------------------------
FloatSignZero   PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH IX
                PUSH IY
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #03                                                          ; subtract, вычитание, 6DE3
                DB #38                                                          ; end-calc, возврат в Z80, 6DE4
                LD HL, Engine.FloatSignZero.Difference
                CALL StoreFloat5                                                ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD A, (Engine.FloatSignZero.DifferenceSign)
                BIT FLOAT_SIGN_BIT, A                                           ; знаковый бит второго байта пятибайтного результата калькулятора
                JR Z, .CheckZero                                                ; переход, если разность двух чисел калькулятора неотрицательна

                SCF
                JR .RestoreRegs

                ; проверка всех пяти байтов, чтобы отличить ноль от положительного значения
.CheckZero      LD HL, Engine.FloatSignZero.Difference
                LD B, #05
                XOR A
.ByteLoop       OR (HL)
                INC HL
                DJNZ .ByteLoop

.RestoreRegs    POP IY
                POP IX
                POP BC
                LD A, B
                POP BC
                POP DE
                POP HL
                RET

.DifferenceSign EQU $+1                                                         ; знаковый байт результата вычитания Float5
.Difference     EQU $                                                           ; пять байтов результата сравнения калькулятора
                DB #00, #00, #00, #00, #00
