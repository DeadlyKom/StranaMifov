
; -----------------------------------------
; вычислить экранный адрес и сдвиг символа
; B участвует в нелинейном вычислении экранной строки, C задаёт X=6*C+2, IX получает адрес
; экранного байта, L=X AND7
; In:
;   BC, B строка знакомест и C горизонтальный индекс
; Out:
;   HL, H старший байт адреса и L сдвиг 0..7, AF, A тотже сдвиг, IX адрес экранного байта для
;   X=6*C+2, BC и IY сохранены
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
