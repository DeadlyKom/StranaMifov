
; -----------------------------------------
; удалить погибших, обработать бунт и проверить исход боя
; F529 обновляет контроль, F84D проверяет количества обоих участников, погибшие ID обнуляются и
; клетки инвалидируются, F864 уплотняет армии, оставшиеся бунтующие отряды героя передаются
; противнику, при пустой FD47 победа, при пустой FCED поражение, 88FA записывает армии обратно,
; победа увеличивает 6AA6, поражение 6AA8, поражение сбрасывает бит 5 в 6A33, вызывает F893 и
; обнуляет деньги 6A14, завершение восстанавливает SP из E0BD
; In:
;   IX и IY участники обновления
; Out:
;   при продолжении IX/IY восстановлены, при завершении A=0 победа либо FF поражение, DE=FCB9,
;   выход из внешнего Battle
; Corrupt:
;   HL, DE, BC, AF, IX и IY, параметры F849..F84C, записи обеих армий и их исходные списки,
;   счётчики исходов, экран и объекты, на завершающем пути SP заменяется E0BD и возврат
;   производится из внешнего вызова боя
; -----------------------------------------
ResolveLosses   LD (Battle.ResolveLosses.FirstUnit), IX
                LD (Battle.ResolveLosses.SecondUnit), IY
                CALL MarkUnruled                                                ; обновить признак превышения контроля у отрядов героя
                CALL TestDeadStack                                              ; проверить неположительное пятибайтное количество отряда
                JR NC, .RedrawAttacker                                          ; переход, если первый участник сохранил положительную численность

                LD (IX + FBattleUnit.UnitID), #00
                LD HL, (Battle.ResolveLosses.FirstUnit)
                LD DE, #0012
                OR A
                SBC HL, DE
                LD (Battle.ResolveLosses.FirstUnit), HL
                LD C, (IX + FBattleUnit.X)
                LD B, (IX + FBattleUnit.Y)
                CALL DirtyCell                                                  ; пометить экранный объект клетки как пустой для перерисовки
                JR .TestDefender

.RedrawAttacker LD IY, (Battle.ResolveLosses.FirstUnit)
                LD C, (IY + FBattleUnit.X)
                LD B, (IY + FBattleUnit.Y)
                CALL GetCellObject                                              ; получить экранный объект боевой клетки
                LD A, (IX + FScreenObject20.Flags)
                AND #E0
                OR #03
                CALL MakeStaticUnit                                             ; сформировать неподвижный объект отряда и его отображаемое количество
.TestDefender   LD IX, (Battle.ResolveLosses.SecondUnit)
                CALL TestDeadStack                                              ; проверить неположительное пятибайтное количество отряда
                JR NC, .RedrawDefender                                          ; переход, если второй участник сохранил положительную численность

                LD (IX + FBattleUnit.UnitID), #00
                LD C, (IX + FBattleUnit.X)
                LD B, (IX + FBattleUnit.Y)
                CALL DirtyCell                                                  ; пометить экранный объект клетки как пустой для перерисовки
                JR .TestEnemyArmy

.RedrawDefender LD IY, (Battle.ResolveLosses.SecondUnit)
                LD C, (IY + FBattleUnit.X)
                LD B, (IY + FBattleUnit.Y)
                CALL GetCellObject                                              ; получить экранный объект боевой клетки
                LD A, (IX + FScreenObject20.Flags)
                AND #E0
                OR #03
                CALL MakeStaticUnit                                             ; сформировать неподвижный объект отряда и его отображаемое количество

                ; после удаления погибших проверяется, сохранились ли отряды вражеской армии
.TestEnemyArmy  LD HL, Battle.FinishField.EnemyArmy
                CALL CompactArmy                                                ; уплотнить пять записей армии и очистить освободившийся хвост
                LD A, (Battle.FinishField.EnemyArmy)
                OR A
                JP NZ, .TestHeroArmy                                            ; переход, если в армии противника ещё есть отряды

                LD IY, Battle.FinishField.HeroArmy
                LD DE, #0012
                LD B, #05

                ; поиск хотя бы одного управляемого отряда героя после исчезновения армии противника
.FindLoyal      LD A, (IY + FBattleUnit.UnitID)
                OR A
                JR Z, .AllUnruled                                               ; переход, если список героя завершён без подконтрольного отряда

                BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)                   ; флаг, численность отряда превышает предел управления героя
                JR Z, .CheckRebels                                              ; переход, если найден подконтрольный герою отряд

                ADD IY, DE
                DJNZ .FindLoyal

.AllUnruled     LD HL, Battle.FinishField.HeroArmy
                LD DE, Battle.FinishField.EnemyArmy
                LD BC, #005A
                LDIR
                LD HL, Battle.FinishField.HeroArmy
                LD DE, Battle.FinishField.HeroArmy + 1                          ; адрес второго байта армии героя при очистке LDIR
                LD BC, #0059
                LD (HL), #00
                LDIR
                JP .SaveDefeat

.CheckRebels    LD IY, Battle.FinishField.HeroArmy
                LD B, #05
                LD DE, #0012
.FindRebel      LD A, (IY + FBattleUnit.UnitID)
                OR A
                JR Z, .SaveVictory                                              ; переход, если список отрядов героя завершён

                BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)                   ; флаг, численность отряда превышает предел управления героя
                JR NZ, .CopyRebels                                              ; переход, если найден вышедший из-под контроля отряд

                ADD IY, DE
                DJNZ .FindRebel

                JR .SaveVictory

                ; перенос неуправляемых отрядов героя в армию противника
.CopyRebels     LD DE, Battle.FinishField.EnemyArmy
.RebelLoop      LD A, (IY + FBattleUnit.UnitID)
                OR A
                JR Z, .CompactHero                                              ; переход, если список отрядов героя завершён

                BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)                   ; флаг, численность отряда превышает предел управления героя
                JR Z, .NextRebel                                                ; переход, если отряд подчиняется герою и не переносится к противнику

                PUSH BC
                PUSH IY
                POP HL
                LD BC, #0012
                LDIR
                POP BC
                LD (IY + FBattleUnit.UnitID), #00
.NextRebel      PUSH DE
                LD DE, #0012
                ADD IY, DE
                POP DE
                DJNZ .RebelLoop

.CompactHero    LD HL, Battle.FinishField.HeroArmy
                CALL CompactArmy                                                ; уплотнить пять записей армии и очистить освободившийся хвост
                JP .RestoreUnits

                ; сохранение армий и завершение боя с победой героя
.SaveVictory    LD IX, Battle.FinishField.HeroArmy
                LD IY, State.Army
                LD BC, #0503
                CALL Engine.StoreArmy                                           ; преобразовать боевые записи обратно в исходный состав армии
                LD IX, Battle.FinishField.EnemyArmy
                LD IY, (Battle.FinishField.SourceArmy)
                LD A, (Battle.FinishField.SourceBank)
                LD C, A
                LD A, (Battle.FinishField.SourceCount)
                LD B, A
                CALL Engine.StoreArmy                                           ; преобразовать боевые записи обратно в исходный состав армии
                LD A, (State.Hero + FPerson.Wins)
                INC A
                LD (State.Hero + FPerson.Wins), A
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                XOR A
                LD DE, (Battle.FinishField.EnemyMana)
                LD HL, (Battle.ReadCursorInput.SavedStack)
                LD SP, HL
                RET

.TestHeroArmy   LD HL, Battle.FinishField.HeroArmy
                CALL CompactArmy                                                ; уплотнить пять записей армии и очистить освободившийся хвост
                LD A, (Battle.FinishField.HeroArmy)
                OR A
                JR NZ, .RestoreUnits                                            ; переход, если после уплотнения армия героя не пуста

                ; сохранение оставшихся армий и обработка поражения героя
.SaveDefeat     LD IX, Battle.FinishField.HeroArmy
                LD IY, State.Army
                LD BC, #0503
                CALL Engine.StoreArmy                                           ; преобразовать боевые записи обратно в исходный состав армии
                LD IX, Battle.FinishField.EnemyArmy
                LD IY, (Battle.FinishField.SourceArmy)
                LD A, (Battle.FinishField.SourceBank)
                LD C, A
                LD A, (Battle.FinishField.SourceCount)
                LD B, A
                CALL Engine.StoreArmy                                           ; преобразовать боевые записи обратно в исходный состав армии
                LD A, (State.Hero + FPerson.Losses)
                INC A
                LD (State.Hero + FPerson.Losses), A
                LD A, (State.MoveFlags)
                RES HERO_SIEGE_BIT, A                                           ; флаг, герой располагает осадным орудием
                LD (State.MoveFlags), A
                CALL DefeatStory                                                ; обработать сюжетные последствия поражения
                XOR A
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                LD A, #FF
                LD DE, (Battle.FinishField.EnemyMana)
                LD HL, (Battle.ReadCursorInput.SavedStack)
                LD SP, HL
                RET

.RestoreUnits   LD IY, (Battle.ResolveLosses.SecondUnit)
                LD IX, (Battle.ResolveLosses.FirstUnit)
                RET

.FirstUnit      DW #0000                                                        ; сохранённый указатель первого участника столкновения
.SecondUnit     DW #0000                                                        ; сохранённый указатель второго участника столкновения
