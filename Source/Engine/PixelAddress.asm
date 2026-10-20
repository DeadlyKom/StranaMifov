
; -----------------------------------------
; вычислить адрес байта экрана по пиксельным координатам
; B строка пикселей, C X, HL=#4000+((B AND#C0)*32)+((B AND7)*256)+((B AND#38)*4)+(C>>3), BC
; сохранён
; In:
;   BC, B пиксельная строка и C пиксельный X
; Out:
;   HL адрес байта экрана, BC сохранён, DE, IX, IY не меняются
; Corrupt:
;   HL, AF
; -----------------------------------------
PixelAddress    PUSH BC
                LD HL, #0200
                LD A, B
                RLCA
                RL H
                RLCA
                RL H
                SLA H
                SLA H
                SLA H
                LD A, B
                AND #07
                OR H
                LD H, A
                LD A, B
                RLCA
                RLCA
                AND #E0
                LD L, A
                SRL C
                SRL C
                SRL C
                LD B, #00
                ADD HL, BC
                POP BC
                RET
