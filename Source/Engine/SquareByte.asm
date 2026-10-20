
; -----------------------------------------
; возвести беззнаковый байт A в квадрат
; 8 шаговое умножение shift-add, HL=A*A, DE и BC сохранены
; In:
;   AF, A беззнаковый множитель
; Out:
;   HL=A*A, DE, BC, A, IX, IY сохранены
; Corrupt:
;   HL и F, A после восьми RRCA возвращается к исходному значению
; -----------------------------------------
SquareByte      PUSH DE
                PUSH BC
                LD HL, #0000
                LD E, A
                LD D, #00
                LD B, #08
.MultiplyBit    RRCA
                JR NC, .ShiftTerm                                               ; переход, если очередной бит множителя не требует прибавления слагаемого

                ADD HL, DE
.ShiftTerm      SLA E
                RL D
                DJNZ .MultiplyBit

                POP BC
                POP DE
                RET
