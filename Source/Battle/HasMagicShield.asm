
; -----------------------------------------
; проверить магический щит стороны выбранной цели
; IX<FD47 означает сторону героя и проверку бита 0 в FCE7, иначе проверяется бит 1, активный щит
; выводит сообщение F482 и выдерживает пять кадров
; In:
;   IX цель
; Out:
;   CF=1 щита нет, CF=0 щит активен, HL, DE, BC сохранены
; Corrupt:
;   AF, экран заголовка и рабочие поля рамки на пути активного щита, HL, DE, BC, IX, IY
;   сохранены
; -----------------------------------------
HasMagicShield  PUSH HL
                PUSH DE
                PUSH BC
                PUSH IX
                POP HL
                LD A, (Battle.FinishField.Flags)
                LD DE, Battle.FinishField.EnemyArmy
                OR A
                SBC HL, DE
                JR C, .HeroWard                                                 ; переход, если проверяемый отряд находится в армии героя

                BIT ENEMY_WARD_BIT, A                                           ; флаг, армия противника защищена магическим щитом
                JR .TestWard

.HeroWard       BIT HERO_WARD_BIT, A                                            ; флаг, армия героя защищена магическим щитом
.TestWard       JR Z, .WardAbsent                                               ; переход, если щит соответствующей армии отключён

                LD A, #42
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD B, #01
                LD DE, Battle.HasMagicShield.WardBlockText                      ; сообщение о магическом щите, препятствующем действию на цель
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #05
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                OR A
                JR .RestoreRegs

.WardAbsent     SCF
.RestoreRegs    POP BC
                POP DE
                POP HL
                RET

.WardBlockText  EQU $                                                           ; сообщение о магическом щите, препятствующем действию на цель
                DB #82, #EB, #20, #A7, #A0, #A1, #EB, #AB
                DB #A8, #20, #AF, #E0, #AE, #0D, #2A, #AC
                DB #A0, #A3, #A8, #E7, #A5, #E1, #AA, #A8
                DB #A9, #20, #E9, #A8, #E2, #2E, #0D, #2A
                DB #00
