
; -----------------------------------------
; обновить признак превышения контроля у отрядов героя
; у FCED очищает бит 7 поля +9 и вызывает F62D, при carry снова ставит бит, ID0 завершает список,
; основные регистры и IY сохраняются
; In:
;   FCED, параметры контроля 6A02/6AD3
; Out:
;   бит 7 означает численность выше предела контроля
; Corrupt:
;   бит 7 поля +9 в FCED, пятибайтное рабочее поле 6E09..6E0D и состояние калькулятора, HL, DE,
;   BC, AF, IY восстановлены, IX сохраняется вызываемыми обёртками
; -----------------------------------------
MarkUnruled     PUSH IY
                PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                LD IY, Battle.FinishField.HeroArmy
                LD B, #05
.UnitLoop       LD A, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                OR A
                JR Z, .RestoreRegs                                              ; переход, если список отрядов героя завершён

                RES UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)                   ; +#09, флаг, численность отряда превышает предел управления героя
                CALL TestControl                                                ; сравнить численность отряда с пределом управления
                JR NC, .NextUnit                                                ; переход, если отряд остаётся под контролем героя

                SET UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)                   ; +#09, флаг, численность отряда превышает предел управления героя
.NextUnit       LD DE, #0012
                ADD IY, DE
                DJNZ .UnitLoop

.RestoreRegs    POP AF
                POP BC
                POP DE
                POP HL
                POP IY
                RET
