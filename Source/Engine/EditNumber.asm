
; -----------------------------------------
; ввести число из не более пяти цифр
; ставит бит 4 #6566, пять пробелов в #7025, вызывает #6E0E с длиной 5, #0E либо пустое поле
; означают отмену, цифры разбираются через ROM калькулятор с десятичным масштабированием, при
; успешном вводе A=#0D
; In:
;   BC позиция поля ввода
; Out:
;   AF, A=#0D при числе на вершине калькулятора либо #0E при отмене, строка до 5 цифр в #7025,
;   IX=#6565 после редактора, численный результат возвращается через калькулятор, не через BC
; Corrupt:
;   HL, DE, BC, AF, IX, поля #6566/#7025, IY зависит от соглашения ROM, альтернативные HL', DE',
;   BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются
; -----------------------------------------
EditNumber      LD A, (State.ViewFlags)
                SET TEXT_DIGIT_BIT, A                                           ; ограничивает обычный текстовый ввод десятичными цифрами
                LD (State.ViewFlags), A
                PUSH BC
                LD HL, Engine.EditNumber.DigitBuffer
                LD DE, .DigitBuffer + 1
                LD BC, #0005
                LD (HL), #20
                LDIR
                POP BC
                LD IX, Engine.EditNumber.DigitBuffer
                LD A, #05
                CALL EditText                                                   ; редактировать строку с анимированным курсором
                CP #0E
                RET Z                                                           ; выход, если числовой ввод отменён

                LD A, (Engine.EditNumber.DigitBuffer)
                CP #20
                JR NZ, .FindNumber                                              ; переход, если первый символ буфера уже не пробел

                LD A, #0E
                RET

                ; поиск начала числового текста после завершения редактирования
.FindNumber     LD HL, .DigitBuffer - 1
                LD D, #FF
                LD A, #20
.SkipSpaces     INC D
                INC HL
                CP (HL)
                JR NZ, .SkipSpaces                                              ; переход, если очередной символ ещё не является разделяющим пробелом

                DEC HL
                LD BC, #0000
                CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
                LD BC, #0001

                ; накопление десятичного значения средствами калькулятора ROM
.ParseDigit     CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
                LD A, (HL)
                SUB #30
                CALL StackA                                                     ; передать байт A на стек калькулятора ROM
                PUSH HL
                PUSH DE
                PUSH BC
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #04                                                          ; multiply, умножение, 7010
                DB #0F                                                          ; addition, сложение, 7011
                DB #38                                                          ; end-calc, возврат в Z80, 7012
                POP HL
                ADD HL, HL
                PUSH HL
                POP BC
                ADD HL, HL
                ADD HL, HL
                ADD HL, BC
                PUSH HL
                POP BC
                POP DE
                POP HL
                DEC HL
                DEC D
                JR NZ, .ParseDigit                                              ; переход, если остались десятичные цифры для разбора

                LD A, #0D
                RET

.DigitBuffer    EQU $                                                           ; буфер пяти десятичных цифр и терминатора
                DB #00, #00, #00, #00, #00, #00
