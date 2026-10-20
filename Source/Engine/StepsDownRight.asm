
; -----------------------------------------
; сформировать три варианта шага вниз-вправо
; увеличивает IY+1,+2,+4,+8
; In:
;   IY начало трёх записей [тип, C, B] по 3 байта
; Out:
;   координаты трёх кандидатов изменены согласно направлению процедуры, HL, DE, BC, A, IX, IY
;   сохранены
; Corrupt:
;   F кроме входного C, поскольку INC/DEC памяти carry не изменяют
; -----------------------------------------
StepsDownRight  INC (IY + FMoveStepA3.First.X)
                INC (IY + FMoveStepA3.First.Y)
                INC (IY + FMoveStepA3.Second.X)
                INC (IY + FMoveStepA3.Third.Y)
                RET
