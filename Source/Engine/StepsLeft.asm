
; -----------------------------------------
; сформировать три варианта шага влево
; уменьшает IY+1,+4,+5,+7 и увеличивает+8
; In:
;   IY начало трёх записей [тип, C, B] по 3 байта
; Out:
;   координаты трёх кандидатов изменены согласно направлению процедуры, HL, DE, BC, A, IX, IY
;   сохранены
; Corrupt:
;   F кроме входного C, поскольку INC/DEC памяти carry не изменяют
; -----------------------------------------
StepsLeft       DEC (IY + FMoveStepA3.First.X)
                DEC (IY + FMoveStepA3.Second.X)
                DEC (IY + FMoveStepA3.Second.Y)
                DEC (IY + FMoveStepA3.Third.X)
                INC (IY + FMoveStepA3.Third.Y)
                RET
