
; -----------------------------------------
; сохранить прямоугольник экрана 4 на 4 знакоместа в буфер DE
; BC экранная позиция, копирует 128 байт пикселей в порядке 8 строк каждого ряда знакомест, затем
; 16 байт атрибутов, общий размер 144 байта
; In:
;   DE буфер 144 байта, BC экранная позиция 4 на 4 знакоместа
; Out:
;   128 байт пикселей и 16 байт атрибутов записаны в буфер, HL, DE, BC, AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, экран читается, границы прямоугольника не проверяются
; -----------------------------------------
GrabTile4x4     PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH BC
                CALL CellAddress                                                ; вычислить ZX-адрес верхней пиксельной строки знакоместа
                LD B, #04

                ; сохранение пиксельных строк четырёх знакомест
.CellRow        PUSH BC
                PUSH HL
                LD B, #08
.PixelRow       PUSH HL
                PUSH BC
                LD BC, #0004
                LDIR
                POP BC
                POP HL
                INC H
                DJNZ .PixelRow

                POP HL
                POP BC
                LD A, L
                ADD A, #20
                LD L, A
                JR NC, .NextCellRow                                             ; переход, если следующая строка знакомест не пересекла границу экранной трети

                LD A, H
                ADD A, #08
                LD H, A
.NextCellRow    DJNZ .CellRow

                POP BC
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
                LD B, #04

                ; атрибуты сохраняются после пиксельной части буфера
.AttrRow        PUSH BC
                PUSH HL
                LD BC, #0004
                LDIR
                LD BC, #0020
                POP HL
                ADD HL, BC
                POP BC
                DJNZ .AttrRow

                POP AF
                POP BC
                POP DE
                POP HL
                RET
