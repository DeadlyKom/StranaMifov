
; -----------------------------------------
; проверить препятствие выбранной клетки
; адрес строки HL=FCE8+B, инструкция BIT (7-C),(HL) меняется через операнд F694, единица означает
; непроходимую клетку, HL и DE сохраняются
; In:
;   BC клетка
; Out:
;   Z=1 свободно, Z=0 препятствие, A изменён
; Corrupt:
;   AF и байт инструкции F694, HL, DE, BC, IX, IY сохранены
; -----------------------------------------
TestObstacle    PUSH HL
                PUSH DE
                LD HL, Battle.FinishField.ObstacleRows
                LD E, B
                LD D, #00
                ADD HL, DE
                LD A, #07
                SUB C
                SLA A
                SLA A
                SLA A
                OR #46
                LD (Battle.TestObstacle.ColumnTest), A
.ColumnTest     EQU $+1                                                         ; изменяемый байт кода BIT выбранного столбца маски препятствий
                BIT FIELD_COL_BIT, (HL)                                         ; исходная позиция бита в шаблоне самоменяемой проверки либо установки столбца поля
                POP DE
                POP HL
                RET
