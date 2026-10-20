
; -----------------------------------------
; вывести маскированный спрайт с горизонтальным отражением
; вариант #75A2, байты маски и пикселей отражаются через #76AE и строки пишутся справа налево,
; атрибуты не изменяются
; In:
;   DE, D высота и E ширина в знакоместах, BC экранная позиция, IX пиксели, IY маска
; Out:
;   пиксели наложены по маске, HL, DE, BC, AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, атрибуты не меняются, границы экрана не проверяются
; -----------------------------------------
DrawMaskFlip    PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH IX
                PUSH IY
                CALL CellAddress                                                ; вычислить ZX-адрес верхней пиксельной строки знакоместа
                LD C, E
                LD B, D

                ; обход зеркального спрайта по строкам знакомест
.CellRow        PUSH BC
                PUSH HL
                LD B, #08
.PixelRow       PUSH HL
                PUSH BC
                LD B, #00
                ADD HL, BC
                LD B, C

                ; маска и изображение отражаются перед записью справа налево
.ByteLoop       DEC HL
                LD A, (IY + #00)
                CALL ReverseBits                                                ; отразить восемь бит байта A
                AND (HL)
                LD E, A
                LD A, (IX + #00)
                CALL ReverseBits                                                ; отразить восемь бит байта A
                OR E
                LD (HL), A
                INC IY
                INC IX
                DJNZ .ByteLoop

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
