
; -----------------------------------------
; вывести пиксельный спрайт по маске
; IX пиксели, IY маска, BC позиция в знакоместах, D высота, E ширина, формула экран=(экран AND
; маска) OR пиксели, атрибуты не изменяются
; In:
;   DE, D высота и E ширина в знакоместах, BC экранная позиция, IX пиксели, IY маска
; Out:
;   пиксели наложены по маске, HL, DE, BC, AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, атрибуты не меняются, границы экрана не проверяются
; -----------------------------------------
DrawMask        PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH IX
                PUSH IY
                CALL CellAddress                                                ; вычислить ZX-адрес верхней пиксельной строки знакоместа
                LD C, E
                LD B, D

                ; обход спрайта по строкам знакомест
.CellRow        PUSH BC
                PUSH HL
                LD B, #08
.PixelRow       PUSH HL
                PUSH BC

                ; сохранение фона по маске и наложение пикселей спрайта
.ByteLoop       LD A, (HL)
                AND (IY + #00)
                OR (IX + #00)
                LD (HL), A
                INC HL
                INC IY
                INC IX
                DEC C
                JR NZ, .ByteLoop                                                ; переход, если в строке маски остались байты

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

                POP IY
                POP IX
                POP AF
                POP BC
                POP DE
                POP HL
                RET
