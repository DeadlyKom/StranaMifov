
; -----------------------------------------
; печать одного знака шестипиксельного шрифта
; Для CR=#0D возвращает x к началу и увеличивает y на 8. Для остальных кодов берёт 8 байтов по
; FontGlyphs+8*(A-#20), выводит их со сдвигом, задаёт атрибут символьной ячейки и увеличивает x на 6.
; In:
;   A — код знака, параметры PixelAddress.TextAttr..PixelAddress.TextX
; Out:
;   следующая позиция печати
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   экран, PixelAddress.TextX
; -----------------------------------------
PrintChar       CP #0D
                JR NZ, .GlyphAddress                                            ; переход, если требуется вывести обычный знак вместо перевода строки

                LD A, (PixelAddress.TextBaseX)
                LD (PixelAddress.TextX), A
                LD A, (PixelAddress.TextY)
                ADD A, #08
                LD (PixelAddress.TextY), A
                RET

                ; номер знака преобразуется в адрес восьми строк шестипиксельного шрифта
.GlyphAddress   SUB #20
                LD L, A
                LD H, #00
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD DE, FontGlyphs
                ADD HL, DE
                EX DE, HL
                LD HL, (PixelAddress.TextY)
                PUSH HL
                LD BC, #0108
                CALL DrawByteRect                                               ; вывод прямоугольника байтов в пиксельных координатах
                POP BC
                SRL B
                SRL B
                SRL B
                SRL C
                SRL C
                SRL C
                CALL AttrAddress                                                ; адрес атрибута по символьным координатам
                LD A, (PixelAddress.TextAttr)
                LD (HL), A
                LD A, (PixelAddress.TextX)
                ADD A, #06
                LD (PixelAddress.TextX), A
                RET

.LeftMask       DB #00                                                          ; маска сохранения фона в левом экранном байте
.RightMask      DB #00                                                          ; маска сохранения фона в правом экранном байте
.BitPosition    DB #00                                                          ; обратная позиция пиксельного бита для вывода строки
