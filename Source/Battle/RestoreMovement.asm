
; -----------------------------------------
; восстановить очки движения армии на новый раунд
; до пяти плотных записей копирует базовую подвижность +7 в остаток +12, шаг 18, DE, BC, AF, IY
; сохраняются
; In:
;   IY начало армии
; Out:
;   движения отрядов восстановлены
; Corrupt:
;   поля +12 непустых записей армии, HL, DE, BC, AF, IX, IY сохранены
; -----------------------------------------
RestoreMovement PUSH DE
                PUSH BC
                PUSH AF
                PUSH IY
                LD DE, #0012
                LD B, #05
.UnitLoop       LD A, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                OR A
                JR Z, .RestoreRegs                                              ; переход, если список отрядов завершён

                LD A, (IY + FBattleUnit.BaseActions)                            ; +#07, число действий в начале раунда
                LD (IY + FBattleUnit.ActionsLeft), A                            ; +#0C, оставшиеся действия текущего раунда
                ADD IY, DE
                DJNZ .UnitLoop

.RestoreRegs    POP IY
                POP AF
                POP BC
                POP DE
                RET
