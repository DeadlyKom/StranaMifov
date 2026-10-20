
; -----------------------------------------
; вычислить адрес клетки карты
; HL=#C000+161*B+C, строки хранятся с шагом 161, DE и BC сохранены
; In:
;   BC, B строка карты и C столбец, нужный банк уже выбран
; Out:
;   HL=#C000+161*B+C, DE и BC сохранены
; Corrupt:
;   HL, AF, IX/IY не меняются, координаты не ограничиваются
; -----------------------------------------
MapCellAddress  PUSH DE
                PUSH BC
                LD HL, MapConst.RowIndex                                        ; база перед первой строкой карты текущего банка10
                LD DE, #00A1
                INC B
.MapRowLoop     ADD HL, DE
                DJNZ .MapRowLoop

                ADD HL, BC
                POP BC
                POP DE
                RET
