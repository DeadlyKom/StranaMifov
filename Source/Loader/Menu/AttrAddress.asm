
; -----------------------------------------
; адрес атрибута по символьным координатам
; Вычисляет #5800+(C AND #1F)*32+(B AND #1F) побитовым разложением строки. AF сохраняется.
; In:
;   B — столбец, C — строка
; Out:
;   HL — адрес атрибута, AF сохранён
; Corrupt:
;   HL
; -----------------------------------------
AttrAddress     LD HL, Screen.Attributes                                        ; начало видимой области атрибутов Spectrum
                PUSH AF
                LD A, B
                AND #1F
                LD L, A
                LD A, C
                AND #18
                SRL A
                SRL A
                SRL A
                ADD A, H
                LD H, A
                LD A, C
                AND #07
                SRL A
                RRA
                RRA
                RRA
                ADD A, L
                LD L, A
                POP AF
                RET
