
; -----------------------------------------
; рисование горизонтальной границы окна
; Вычисляет пиксельную строку 8*A+E и x=8*B, заполняет #FF число экранных байтов, равное ширине
; окна.
; In:
;   A — символьная строка, B — символьный столбец, E — поправка, IX — окно
; Out:
;   линия выведена
; Corrupt:
;   HL, BC, AF
; Note:
;   экран
; -----------------------------------------
DrawHBorder     ADD A, A
                ADD A, A
                ADD A, A
                ADD A, E
                LD C, A
                LD A, B
                ADD A, A
                ADD A, A
                ADD A, A
                LD B, A
                CALL PixelAddress                                               ; адрес пиксельного байта и положение бита на экране ZX Spectrum
                LD B, (IX + FMenuWindow.Width)
.BorderByte     LD (HL), #FF
                INC HL
                DJNZ .BorderByte

                RET
