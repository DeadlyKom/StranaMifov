
; -----------------------------------------
; вывести непрозрачный спрайт с горизонтальным отражением
; вариант #7545, байты каждой строки идут справа налево, каждый пиксельный байт отражается через
; #76AE, атрибуты также пишутся справа налево
; In:
;   DE, D высота и E ширина в знакоместах, BC экранная позиция, IX пиксели, за ними атрибуты
; Out:
;   изображение выведено, HL, DE, BC, AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, экран и атрибуты изменены, нулевые размеры небезопасны,
;   границы экрана не проверяются
; -----------------------------------------
DrawRawMirrored PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH IX
                PUSH DE
                PUSH BC
                CALL CellAddress                                                ; вычислить ZX-адрес верхней пиксельной строки знакоместа
                LD C, E
                LD B, D
                PUSH IX
                POP DE
.CellRow        PUSH BC
                PUSH HL
                LD B, #08
.PixelRow       PUSH BC
                PUSH HL
                LD B, #00
                ADD HL, BC
                LD B, C

                ; отражение пиксельного байта перед записью справа налево
.MirrorBytes    DEC HL
                LD A, (DE)
                CALL ReverseBits                                                ; отразить восемь бит байта A
                LD (HL), A
                INC DE
                DJNZ .MirrorBytes

                POP HL
                POP BC
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

                PUSH DE
                POP IX
                POP BC
                LD L, B
                LD H, #00
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD DE, Screen.Attributes                                        ; основная область атрибутов экрана
                ADD HL, DE
                LD B, #00
                ADD HL, BC
                POP BC
                PUSH IX
                POP DE

                ; атрибуты отражаются перестановкой столбцов без изменения битов
.AttrRow        PUSH BC
                PUSH HL
                LD B, #00
                ADD HL, BC
                LD B, C
.AttrBytes      DEC HL
                LD A, (DE)
                LD (HL), A
                INC DE
                DJNZ .AttrBytes

                POP HL
                LD BC, #0020
                ADD HL, BC
                POP BC
                DJNZ .AttrRow

                POP IX
                POP AF
                POP BC
                POP DE
                POP HL
                RET
