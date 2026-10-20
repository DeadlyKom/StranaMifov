
; -----------------------------------------
; составить список всех отрядов кроме действующего
; сначала добавляет до пяти отрядов FD47 со статусом 3, затем до пяти FCED со статусом 2, текущий
; IY исключается сравнением указателя, тройки записываются в EB8E, число в EB8B
; In:
;   IY действующий отряд
; Out:
;   EB8E список, EB8B число целей, IX за последней тройкой
; Corrupt:
;   HL, DE, BC, AF, IX, число и список целей EB8B..EBA8, IY не изменяется
; -----------------------------------------
ListOtherUnits  LD IX, Battle.ListOtherUnits.TargetList
                XOR A
                LD (Battle.ListOtherUnits.TargetCount), A
                LD HL, Battle.FinishField.EnemyArmy
                LD B, #05
                LD DE, #0012
.EnemyLoop      LD A, (HL)
                OR A
                JR Z, .HeroArmy                                                 ; переход, если список отрядов противника завершён

                LD (IX + #00), #03
                INC IX
                LD (IX + #00), L
                INC IX
                LD (IX + #00), H
                INC IX
                LD A, (Battle.ListOtherUnits.TargetCount)
                INC A
                LD (Battle.ListOtherUnits.TargetCount), A
                ADD HL, DE
                DJNZ .EnemyLoop

.HeroArmy       LD HL, Battle.FinishField.HeroArmy
                LD B, #05
.HeroLoop       LD A, (HL)
                OR A
                RET Z                                                           ; выход, если список отрядов героя завершён

                PUSH HL
                PUSH IY
                POP DE
                OR A
                SBC HL, DE
                POP HL
                JR Z, .NextHero                                                 ; переход, если запись соответствует самому действующему отряду

                LD (IX + #00), #02
                INC IX
                LD (IX + #00), L
                INC IX
                LD (IX + #00), H
                INC IX
                LD A, (Battle.ListOtherUnits.TargetCount)
                INC A
                LD (Battle.ListOtherUnits.TargetCount), A
.NextHero       LD DE, #0012
                ADD HL, DE
                DJNZ .HeroLoop

                RET

.TargetCount    DB #00                                                          ; количество трёхбайтовых целей случайной атаки
.TargetEnd      DW #0000                                                        ; указатель следующей свободной записи списка целей
.TargetList     DB #00, #00, #00, #00, #00                                      ; массив FBattleTarget, сторона и указатель отряда
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00
