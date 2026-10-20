
; -----------------------------------------
; вывести беззнаковое число из HL при обработке прерывания
; последовательные вычитания 10000,1000,100,10,1 из таблицы #82CB, ведущие нули подавляются
; самомодификацией условного JP #82B1, вывод символов #70D4
; In:
;   HL число 0..65535, BC позиция числа
; Out:
;   HL=0 после разбора, IX и IY сохранены, для ненулевого числа C+=5, при нуле C+=4 и 0 рисуется
;   в этой позиции
; Corrupt:
;   HL, DE, BC, AF, операнды #82B1..#82B3, F изменён, вывод #70D4 использует DI
; -----------------------------------------
DrawCountDI     LD A, L
                OR H
                JR NZ, .PrepareDigits                                           ; переход, если печатаемое число отлично от нуля

                LD A, C
                ADD A, #04
                LD C, A
                LD A, #30
                CALL DrawGlyphDI                                                ; вывести символ из прерывания с сохранением режима DI
                RET

                ; десятичный вывод с подавлением ведущих нулей через изменяемый переход
.PrepareDigits  PUSH IX
                LD A, #CA
                LD (Engine.DrawCountDI.SkipZeroOp), A
                LD DE, Engine.DrawCountDI.NextDigit                             ; адрес подавления ведущей нулевой цифры в SMC-переходе
                LD (Engine.DrawCountDI.SkipZeroLo), DE
                LD A, #05
                LD IX, Engine.DrawCountDI.Divisors                              ; пять десятичных делителей10000/1000/100/10/1

                ; выделение следующей десятичной цифры из оставшегося числа
.DigitLoop      PUSH AF
                LD E, (IX + #00)
                INC IX
                LD D, (IX + #00)
                INC IX
                LD A, #FF
.SubtractPlace  INC A
                OR A
                SBC HL, DE
                JR NC, .SubtractPlace                                           ; переход, если в остатке ещё содержится текущий десятичный разряд

                ADD HL, DE
                OR A
.SkipZeroOp     EQU $                                                           ; код изменяемого JP Z, заменяемого тремя NOP
.SkipZeroLo     EQU $+1                                                         ; младший байт адреса изменяемого JP Z
.SkipZeroHi     EQU $+2                                                         ; старший байт адреса изменяемого JP Z
                JP Z, .NextDigit                                                ; переход, если текущая ведущая цифра равна нулю

                ADD A, #30
                CALL DrawGlyphDI                                                ; вывести символ из прерывания с сохранением режима DI
                XOR A
                LD (Engine.DrawCountDI.SkipZeroOp), A
                LD (Engine.DrawCountDI.SkipZeroLo), A
                LD (Engine.DrawCountDI.SkipZeroHi), A
.NextDigit      INC C
                POP AF
                DEC A
                JR NZ, .DigitLoop                                               ; переход, если остались десятичные разряды для вывода

                POP IX
                RET

.Divisors       EQU $                                                           ; пять десятичных делителей10000/1000/100/10/1
                DB #10, #27, #E8, #03, #64, #00, #0A, #00
                DB #01, #00
