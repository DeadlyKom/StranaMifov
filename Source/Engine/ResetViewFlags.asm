
; -----------------------------------------
; сбросить младшие шесть флагов 48 записей объектов
; первая запись #6571, шаг 20, каждая маскируется #C0, HL, DE, BC, AF сохранены
; In:
;   состояние рабочих таблиц и текущий логический банк
; Out:
;   HL, DE, BC, AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, альтернативные регистры не используются в собственном
;   коде, возможные прерывания работают независимо
; -----------------------------------------
ResetViewFlags  PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                LD HL, State.ViewObjects
                LD DE, #0014
                LD B, #30
.ObjectLoop     LD A, (HL)
                AND #C0
                LD (HL), A
                ADD HL, DE
                DJNZ .ObjectLoop

                POP AF
                POP BC
                POP DE
                POP HL
                RET
