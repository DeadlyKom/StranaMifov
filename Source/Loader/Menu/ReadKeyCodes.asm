
; -----------------------------------------
; опрос последовательности упакованных кодов кнопок
; Из каждого кода получает индекс пары порта в #6C4D и номер бита. Читает порт, инвертирует
; клавиатурные строки, извлекает нужный бит и сдвигает результат в C.
; In:
;   HL — коды кнопок, B — число кодов, C — аккумулятор битов
; Out:
;   C — собранные биты, HL — следующий код, B=0
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------

                ; код кнопки содержит индекс пары байтов порта и номер проверяемого бита
ReadKeyCodes    LD A, (HL)
                RRA
                RRA
                AND #1E
                LD E, A
                LD D, #00
                LD A, (HL)
                INC HL
                PUSH HL
                LD HL, Loader.Menu.MenuState.InputPorts                         ; девять слов портов восьми полурядов клавиатуры и Kempston
                ADD HL, DE
                LD D, A
                PUSH BC
                LD C, (HL)
                INC HL
                LD B, (HL)
                IN A, (C)
                INC B
                DEC B
                JR Z, .ReadPortValue                                            ; переход, если старший байт порта равен нулю и клавиатурная инверсия не нужна

                CPL
.ReadPortValue  LD E, A
                POP BC
                POP HL
                LD A, D
                AND #07
                JR Z, .AppendKeyBit                                             ; переход, если проверяется младший бит прочитанного порта

.ShiftKeyBit    RR E
                DEC A
                JR NZ, .ShiftKeyBit                                             ; переход, если нужный бит ещё не сдвинут в перенос

.AppendKeyBit   RR E
                RL C
                DJNZ ReadKeyCodes

                RET
