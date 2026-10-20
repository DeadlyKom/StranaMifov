
; -----------------------------------------
; выполнить бой на поле 8 на 5 клеток
; сохраняет SP в E0BD и вызывает FAAF, на каждом раунде восстанавливает движения из +7 в +12,
; уменьшает длительность эффектов +13, выбирает ещё не ходивший отряд по биту 3 поля +9, бунтующий
; отряд с битом 7 может перейти к противнику или объединиться с таким же типом, восемь направлений
; разрешают движение в свободную клетку либо рукопашную атаку, S запускает стрельбу, F полёт, U
; меню заклинаний, G откуп, W откладывает ход, Space обнуляет остаток действий, E0BF выполняет ход
; компьютера, F6B8 может выйти из боя непосредственно через сохранённый SP, ветка откупа DA9E
; записывает армии обратно и возвращает FF
; In:
;   DE сила противника, BC число исходных отрядов и банк, A тип боя, IX исходная армия
;   противника
; Out:
;   DE остаток FCB9, A=0 победа, A=FF поражение или откуп, армии записаны через 88FA
; Corrupt:
;   HL, DE, BC, AF, IX, IY, SP на путях завершения боя, обе армии, боевые переменные, объекты и
;   экран, состояние калькулятора и генератора случайных чисел
; -----------------------------------------
Battle          LD (Battle.ReadCursorInput.SavedStack), SP
                CALL InitBattle                                                 ; инициализировать армии, препятствия, фон и начальные объекты боя
.NewRound       LD IY, Battle.FinishField.HeroArmy
                CALL ResetTurnFlags                                             ; очистить временные флаги одной армии
                CALL RestoreMovement                                            ; восстановить очки движения армии на новый раунд
                LD A, (Battle.FinishField.Flags)
                RES SPELL_USED_BIT, A                                           ; флаг, попытка магии героя уже использована в текущем раунде
                LD (Battle.FinishField.Flags), A
                LD IY, Battle.FinishField.HeroArmy
                CALL TickEffects                                                ; уменьшить длительность временных эффектов одной армии
                LD IY, Battle.FinishField.EnemyArmy
                CALL TickEffects                                                ; уменьшить длительность временных эффектов одной армии
                LD BC, (Data.Battle.MagicWard.ManaCost)
                LD HL, (State.Mana)
                LD A, (Battle.FinishField.Flags)
                BIT HERO_WARD_BIT, A                                            ; флаг, армия героя защищена магическим щитом
                JR Z, .EnemyWardCost                                            ; переход, если щит героя отключён

                SBC HL, BC
                LD (State.Mana), HL
                JR NC, .EnemyWardCost                                           ; переход, если маны героя хватает на очередную оплату щита

                LD HL, #0000
                LD (State.Mana), HL
                RES HERO_WARD_BIT, A                                            ; флаг, армия героя защищена магическим щитом
                LD (Battle.FinishField.Flags), A
.EnemyWardCost  LD HL, (Battle.FinishField.EnemyMana)
                BIT ENEMY_WARD_BIT, A                                           ; флаг, армия противника защищена магическим щитом
                JR Z, SelectActor                                               ; переход, если щит противника отключён

                SBC HL, BC
                LD (Battle.FinishField.EnemyMana), HL
                JR NC, SelectActor                                              ; переход, если маны противника хватает на очередную оплату щита

                LD HL, #0000
                LD (Battle.FinishField.EnemyMana), HL
                RES ENEMY_WARD_BIT, A                                           ; флаг, армия противника защищена магическим щитом
                LD (Battle.FinishField.Flags), A
