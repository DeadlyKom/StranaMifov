
; -----------------------------------------
; сформировать три варианта шага вверх-влево
; уменьшает IY+1,+2,+5,+7
; In:
;   IY начало трёх записей [тип, C, B] по 3 байта
; Out:
;   координаты трёх кандидатов изменены согласно направлению процедуры, HL, DE, BC, A, IX, IY
;   сохранены
; Corrupt:
;   F кроме входного C, поскольку INC/DEC памяти carry не изменяют
; -----------------------------------------
StepsUpLeft     DEC (IY + FMoveStepA3.First.X)
                DEC (IY + FMoveStepA3.First.Y)
                DEC (IY + FMoveStepA3.Second.Y)
                DEC (IY + FMoveStepA3.Third.X)
                RET
