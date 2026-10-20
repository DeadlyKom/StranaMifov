
; -----------------------------------------
; вычислить экранный адрес и битовый сдвиг шестипиксельного символа
; первый адрес строки знакоместа B формируется через биты нелинейной ZX-развёртки, X=6*C+2,
; IX=4000+((B AND18)<<8)+((B AND7)<<5)+(X>>3), L=X AND7, это отдельная адресная процедура, сама
; экран не изменяет
; In:
;   BC позиция, B строка 0..23, C столбец шестипиксельного шрифта
; Out:
;   IX адрес первого экранного байта, L сдвиг 0..7, DE=X>>3
; Corrupt:
;   HL, DE, AF, IX
; -----------------------------------------
GlyphAddress    LD HL, #0800
                LD A, B
                SRL A
                RR L
                SRL A
                RR L
                SRL A
                RR L
                OR H
                RLCA
                RLCA
                RLCA
                LD H, A
                LD A, C
                ADD A, A
                ADD A, A
                ADD A, C
                ADD A, C
                INC A
                INC A
                LD E, A
                SRL E
                SRL E
                SRL E
                LD D, #00
                ADD HL, DE
                PUSH HL
                POP IX
                AND #07
                LD L, A
                RET
