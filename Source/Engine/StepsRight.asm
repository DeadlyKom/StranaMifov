
; -----------------------------------------
; сформировать три варианта шага вправо
; увеличивает IY+1,+4,+7,+8 и уменьшает+5
; In:
;   IY начало трёх записей [тип, C, B] по 3 байта
; Out:
;   координаты трёх кандидатов изменены согласно направлению процедуры, HL, DE, BC, A, IX, IY
;   сохранены
; Corrupt:
;   F кроме входного C, поскольку INC/DEC памяти carry не изменяют
; -----------------------------------------
StepsRight      INC (IY + FMoveStepA3.First.X)
                INC (IY + FMoveStepA3.Second.X)
                DEC (IY + FMoveStepA3.Second.Y)
                INC (IY + FMoveStepA3.Third.X)
                INC (IY + FMoveStepA3.Third.Y)
                RET
