
; -----------------------------------------
; восстановить фон под старой позицией указателя
; позиция #79CA, восемь пиксельных строк по 3 байта берутся из #79FE
; In:
;   #79CA старая позиция, 24 байта сохранённого фона #79FE
; Out:
;   фон под старой позицией восстановлен, DE=#7A16, BC, B увеличен на 8 и C сохранён, IX и IY
;   сохранены
; Corrupt:
;   HL, DE, BC, AF, 24 экранных байта
; -----------------------------------------
RestoreCursor   LD BC, (Engine.ShiftCursorL.OldCursor)
                LD DE, Engine.head_cursorMask.CursorBack                        ; 24-байтный буфер фона под трёхбайтным курсором
                LD A, #08
.PixelRow       PUSH BC
                PUSH AF
                CALL PixelAddress                                               ; вычислить адрес байта экрана по пиксельным координатам
                EX DE, HL
                LDI
                LDI
                LDI
                EX DE, HL
                POP AF
                POP BC
                INC B
                DEC A
                JR NZ, .PixelRow                                                ; переход, если остались пиксельные строки фона курсора

                RET
