
; -----------------------------------------
; адрес экранного пиксельного байта по координатам курсора
; Вычисляет стандартную нелинейную адресацию ZX Spectrum, #4000+((y AND #C0)<<5)+((y AND7)<<8)+((y
; AND #38)<<2)+(x>>3). Пару BC сохраняет.
; In:
;   B — y, C — x
; Out:
;   HL — адрес байта экрана, BC сохранён
; Corrupt:
;   HL, AF
; -----------------------------------------
CursorByteAddr  PUSH BC
                LD HL, #0200
                LD A, B
                RLCA
                RL H
                RLCA
                RL H
                SLA H
                SLA H
                SLA H
                LD A, B
                AND #07
                OR H
                LD H, A
                LD A, B
                RLCA
                RLCA
                AND #E0
                LD L, A
                SRL C
                SRL C
                SRL C
                LD B, #00
                ADD HL, BC
                POP BC
                RET
