
; -----------------------------------------
; вывести непрозрачный спрайт с атрибутами
; IX источник, BC позиция в знакоместах, D высота, E ширина, сначала 8*D*E пиксельных байтов,
; затем D*E атрибутов, ограничение экраном отсутствует
; In:
;   DE, D высота и E ширина в знакоместах, BC экранная позиция, IX пиксели, за ними атрибуты
; Out:
;   изображение выведено, HL, DE, BC, AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, экран и атрибуты изменены, нулевые размеры небезопасны,
;   границы экрана не проверяются
; -----------------------------------------
DrawRawSprite   PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH IX
                PUSH DE
                PUSH BC
                CALL CellAddress                                                ; вычислить ZX-адрес верхней пиксельной строки знакоместа
                LD C, E
                LD B, D
                EX DE, HL
                PUSH IX
                POP HL

                ; копирование пиксельных строк с переходами между знакоместами ZX
.CellRow        PUSH BC
                PUSH DE
                LD B, #08
.PixelRow       PUSH BC
                PUSH DE
                LD B, #00
                LDIR
                POP DE
                POP BC
                INC D
                DJNZ .PixelRow

                POP DE
                POP BC
                LD A, E
                ADD A, #20
                LD E, A
                JR NC, .NextCellRow                                             ; переход, если следующая строка знакомест не пересекла границу экранной трети

                LD A, D
                ADD A, #08
                LD D, A
.NextCellRow    DJNZ .CellRow

                PUSH HL
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
                EX DE, HL
                PUSH IX
                POP HL

                ; следом за пикселями копируются строки атрибутов
.AttrRow        PUSH BC
                PUSH DE
                LD B, #00
                LDIR
                POP DE
                EX DE, HL
                LD BC, #0020
                ADD HL, BC
                EX DE, HL
                POP BC
                DJNZ .AttrRow

                POP IX
                POP AF
                POP BC
                POP DE
                POP HL
                RET
