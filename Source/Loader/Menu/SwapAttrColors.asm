
; -----------------------------------------
; обмен INK и PAPER одного атрибута
; Меняет местами биты 0..2 и 3..5, сохраняет BRIGHT bit 6. FLASH bit 7 сбрасывается.
; In:
;   A — исходный атрибут
; Out:
;   A — преобразованный атрибут, BC сохранён
; Corrupt:
;   DE, AF
; -----------------------------------------
SwapAttrColors  PUSH BC
                LD C, A
                AND #40
                LD B, A
                LD A, C
                AND #38
                SRL A
                SRL A
                SRL A
                LD D, A
                LD A, C
                AND #07
                SLA A
                SLA A
                SLA A
                OR D
                OR B
                POP BC
                RET
