
; -----------------------------------------
; вывести 16 битное число HL без ведущих нулей
; при HL=0 выводит 0, иначе последовательные вычитания 10000,1000,100,10,1 из #951B,
; самомодифицируемый JP #9503 подавляет первые нули, символы через #70C5, C сдвигается по каждому
; разряду
; In:
;   HL число 0..65535, BC позиция
; Out:
;   HL=0, для ненулевого числа C+=5 и IX=#9525, для 0 символ 0 рисуется без изменения C и IX, IY
;   сохранён
; Corrupt:
;   HL, DE, BC, AF, IX в ненулевой ветви, операнды #9503..#9505
; -----------------------------------------
PrintU16        LD A, L
                OR H
                JR NZ, .PrepareDigits                                           ; переход, если печатаемое число отлично от нуля

                LD A, #30
                CALL DrawGlyphEI                                                ; вывести символ с обычной процедурой переключения банка
                RET

.PrepareDigits  LD A, #CA
                LD (Engine.PrintU16.SkipZeroOp), A
                LD DE, Engine.PrintU16.NextDigit                                ; адрес подавления ведущей нулевой цифры в SMC-переходе
                LD (Engine.PrintU16.SkipZeroLo), DE
                LD A, #05
                LD IX, Engine.PrintU16.Divisors                                 ; пять десятичных делителей10000/1000/100/10/1
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
.SkipZeroOp     EQU $                                                           ; код изменяемого JP Z для ведущих нулей
.SkipZeroLo     EQU $+1                                                         ; младший байт адреса изменяемого JP Z
.SkipZeroHi     EQU $+2                                                         ; старший байт адреса изменяемого JP Z
                JP Z, .NextDigit                                                ; переход, если текущая ведущая цифра равна нулю

                ADD A, #30
                CALL DrawGlyphEI                                                ; вывести символ с обычной процедурой переключения банка
                XOR A
                LD (Engine.PrintU16.SkipZeroOp), A
                LD (Engine.PrintU16.SkipZeroLo), A
                LD (Engine.PrintU16.SkipZeroHi), A
.NextDigit      INC C
                POP AF
                DEC A
                JR NZ, .DigitLoop                                               ; переход, если остались десятичные разряды для вывода

                RET

.Divisors       EQU $                                                           ; пять десятичных делителей10000/1000/100/10/1
                DB #10, #27, #E8, #03, #64, #00, #0A, #00
.DayText        EQU $+2                                                         ; слово день для подписи календаря
.MonthNames     EQU $+7                                                         ; нулевая строка перед названиями календарных месяцев
                DB #01, #00, #A4, #A5, #AD, #EC, #00, #00
                DB #84, #A6, #A8, #A2, #EB, #00, #8C, #A0
                DB #AD, #A0, #E1, #A0, #00, #8B, #A8, #AD
                DB #A3, #A0, #00, #98, #A0, #E0, #A8, #E0
                DB #A0, #00, #90, #E3, #AA, #E0, #A0, #00
                DB #8A, #A5, #E2, #A5, #E0, #A0, #00, #95
                DB #A5, #E1, #A5, #A4, #A0, #00, #88, #A5
                DB #E1, #AE, #A4, #A0, #00, #95, #A0, #A8
                DB #AE, #E2, #A0, #00, #8C, #A0, #A4, #A8
                DB #AC, #A0, #00, #84, #A6, #E3, #A3, #E0
                DB #A0, #00, #98, #A0, #AB, #AE, #AC, #A0
                DB #00
