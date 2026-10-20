
; -----------------------------------------
; обмен цветов INK и PAPER в полосе атрибутов
; Сохраняет BC, получает адрес по столбцу E и строке D. Для A последовательных ячеек меняет цвета
; через SwapAttrColors.
; In:
;   D — строка, E — столбец, A — длина
; Out:
;   BC сохранён, HL после полосы
; Corrupt:
;   HL, DE, AF
; Note:
;   атрибуты экрана
; -----------------------------------------
SwapAttrStrip   PUSH BC
                PUSH AF
                LD B, E
                LD C, D
                CALL AttrAddress                                                ; адрес атрибута по символьным координатам
                POP BC
.SwapCell       LD A, (HL)
                CALL SwapAttrColors                                             ; обмен INK и PAPER одного атрибута
                LD (HL), A
                INC HL
                DJNZ .SwapCell

                POP BC
                RET
