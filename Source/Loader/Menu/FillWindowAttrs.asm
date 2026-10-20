
; -----------------------------------------
; заполнение прямоугольника атрибутов окна
; По размерам IX+2/IX+3 проходит строки и столбцы, записывая A в вычисленные адреса атрибутов.
; In:
;   A — атрибут, B — столбец, C — строка, IX — окно
; Out:
;   прямоугольник заполнен
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   атрибуты экрана
; -----------------------------------------
FillWindowAttrs LD D, (IX + FMenuWindow.Width)
                LD E, (IX + FMenuWindow.Height)
.AttrRow        PUSH BC
.AttrCell       CALL AttrAddress                                                ; адрес атрибута по символьным координатам
                LD (HL), A
                INC B
                DEC D
                JR NZ, .AttrCell                                                ; переход, если остаются ячейки текущей строки окна

                LD L, C
                POP BC
                LD C, L
                LD D, (IX + FMenuWindow.Width)
                INC C
                DEC E
                JR NZ, .AttrRow                                                 ; переход, если остаются строки атрибутов окна

                RET
