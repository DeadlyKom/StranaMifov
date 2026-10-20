
; -----------------------------------------
; обнулить пиксели прямоугольника и заполнить его атрибуты
; BC начало в знакоместах, D высота, E ширина, восемь пиксельных строк на знакоместо, после
; очистки #73AD пишет атрибут A
; In:
;   DE, D высота и E ширина в знакоместах, BC начало, AF атрибут A
; Out:
;   пиксели обнулены и атрибуты заполнены, HL, DE, A, IX, IY сохранены
; Corrupt:
;   BC и F изменяются в завершающем вызове #73AD после восстановления AF. Нулевые размеры
;   приводят к 256 итерациям DJNZ, область не ограничивается экраном
; -----------------------------------------
ClearRectangle  PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                CALL CellAddress                                                ; вычислить ZX-адрес верхней пиксельной строки знакоместа
                LD B, D

                ; очистка пикселей по строкам знакомест с учётом экранной развёртки ZX
.CellRow        PUSH HL
                PUSH BC
                LD B, #08
.PixelRow       PUSH HL
                PUSH BC
                LD B, E
.ClearBytes     LD (HL), #00
                INC HL
                DJNZ .ClearBytes

                POP BC
                POP HL
                INC H
                DJNZ .PixelRow

                POP BC
                POP HL
                LD A, L
                ADD A, #20
                LD L, A
                JR NC, .NextCellRow                                             ; переход, если следующая строка знакомест не пересекла границу экранной трети

                LD A, H
                ADD A, #08
                LD H, A

                ; переход к следующей строке знакомест, затем заполнение атрибутов
.NextCellRow    DJNZ .CellRow

                POP AF
                POP BC
                POP DE
                CALL FillAttributes                                             ; заполнить прямоугольник атрибутов цветом A
                POP HL
                RET
