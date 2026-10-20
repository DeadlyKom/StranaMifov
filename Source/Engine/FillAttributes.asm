
; -----------------------------------------
; заполнить прямоугольник атрибутов цветом A
; B строка, C столбец в знакоместах, D высота, E ширина, адрес #5800+32*B+C, строки с шагом 32
; In:
;   DE, D высота и E ширина в знакоместах, BC, B строка и C столбец, AF атрибут A
; Out:
;   атрибутный прямоугольник заполнен, HL, DE, A, IX, IY сохранены
; Corrupt:
;   BC и F изменяются. Нулевые размеры не обрабатываются как пустой прямоугольник из-за DJNZ
; -----------------------------------------
FillAttributes  PUSH HL
                LD H, #00
                LD L, B
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD B, #00
                ADD HL, BC
                LD BC, Screen.Attributes                                        ; основная область атрибутов экрана
                ADD HL, BC
                LD B, D
.RowLoop        PUSH BC
                PUSH HL
                LD B, E
.ColumnLoop     LD (HL), A
                INC HL
                DJNZ .ColumnLoop

                POP HL
                LD BC, #0020
                ADD HL, BC
                POP BC
                DJNZ .RowLoop

                POP HL
                RET
