
; -----------------------------------------
; сформировать три варианта шага вниз
; увеличивает IY+2,+5,+7,+8 и уменьшает+4
; In:
;   IY начало трёх записей [тип, C, B] по 3 байта
; Out:
;   координаты трёх кандидатов изменены согласно направлению процедуры, HL, DE, BC, A, IX, IY
;   сохранены
; Corrupt:
;   F кроме входного C, поскольку INC/DEC памяти carry не изменяют
; -----------------------------------------
StepsDown       INC (IY + FMoveStepA3.First.Y)
                DEC (IY + FMoveStepA3.Second.X)
                INC (IY + FMoveStepA3.Second.Y)
                INC (IY + FMoveStepA3.Third.X)
                INC (IY + FMoveStepA3.Third.Y)
                RET
