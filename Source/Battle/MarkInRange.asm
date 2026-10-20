
; -----------------------------------------
; отметить цели героя в пределах подвижности отряда компьютера
; до пяти записей FCED получают бит 4 поля +9, если по обеим осям abs(delta)-1 меньше (IY+7),
; совпадение координаты сразу допустимо, дальность учитывает восемь направлений
; In:
;   IY отряд противника
; Out:
;   бит 4 установлен у достижимых целей FCED
; Corrupt:
;   DE, BC, AF, IX, бит 4 поля +9 в FCED, HL и IY не изменяются
; -----------------------------------------
MarkInRange     LD IX, Battle.FinishField.HeroArmy
                LD DE, #0012
                LD B, #05
.HeroLoop       LD A, (IX + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                OR A
                RET Z                                                           ; выход, если список отрядов героя завершён

                LD A, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                SUB (IX + FBattleUnit.X)                                        ; +#0A, колонка 0..7
                JR Z, .CheckDeltaY                                              ; переход, если отряды находятся в одном столбце

                JR NC, .CheckDeltaX                                             ; переход, если разность столбцов неотрицательна

                NEG
.CheckDeltaX    DEC A
                CP (IY + FBattleUnit.BaseActions)                               ; +#07, число действий в начале раунда
                JR NC, .NextHero                                                ; переход, если горизонтальное расстояние превышает подвижность

.CheckDeltaY    LD A, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                SUB (IX + FBattleUnit.Y)                                        ; +#0B, строка 0..4
                JR Z, .MarkReachable                                            ; переход, если отряды находятся в одной строке

                JR NC, .LimitDeltaY                                             ; переход, если разность строк неотрицательна

                NEG
.LimitDeltaY    DEC A
                CP (IY + FBattleUnit.BaseActions)                               ; +#07, число действий в начале раунда
                JR NC, .NextHero                                                ; переход, если вертикальное расстояние превышает подвижность

.MarkReachable  SET HERO_REACH_BIT, (IX + FBattleUnit.Flags)                    ; +#09, флаг, отряд героя достижим для проверяемого отряда ИИ
.NextHero       ADD IX, DE
                DJNZ .HeroLoop

                RET
