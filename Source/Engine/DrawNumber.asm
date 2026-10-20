
; -----------------------------------------
; преобразовать число и вывести символы подряд
; #7227 формирует строку в #710C, ставится нулевой терминатор, затем #70C5 для каждого символа с
; INC C
; In:
;   BC позиция вывода, число на вершине калькулятора ROM
; Out:
;   десятичное число выведено, HL, DE, BC, AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, буфер #710C изменён, альтернативные HL', DE', BC', AF'
;   зависят от внутреннего соглашения ROM и отдельно не проверены
; -----------------------------------------
DrawNumber      PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH IX
                PUSH IY
                PUSH BC
                LD DE, Engine.DrawNumber.NumberBuffer                           ; строка десятичных цифр для вывода числа
                CALL NumberToDecimal                                            ; преобразовать число калькулятора в десятичные цифры
                XOR A
                LD (DE), A
                POP BC
                LD HL, Engine.DrawNumber.NumberBuffer                           ; строка десятичных цифр для вывода числа
.CharLoop       LD A, (HL)
                OR A
                JR Z, .RestoreRegs                                              ; переход, если достигнут конец подготовленной числовой строки

                CALL DrawGlyphEI                                                ; вывести символ с обычной процедурой переключения банка
                INC HL
                INC C
                JR .CharLoop

.RestoreRegs    POP IY
                POP IX
                POP AF
                POP BC
                POP DE
                POP HL
                RET

.NumberBuffer   EQU $                                                           ; строка десятичных цифр для вывода числа
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00
