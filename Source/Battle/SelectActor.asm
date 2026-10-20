
; -----------------------------------------
; выбрать следующий отряд героя либо передать ход противнику
; пять записей с FCED обходятся с шагом 18, выбирается первая с ненулевым запасом действий +12 и
; сброшенным битом 3 Flags, при новом проходе оригинал сбрасывает бит в пяти разных полях, см. ниже
; повторяется только по +12, при полном исчерпании действий E0BF выполняет ход противника и
; переход D25C начинает следующий раунд, выбранной записи ставится бит 3, F529 обновляет контроль,
; 8036 получает имя типа и сохраняет IX в DD56, для бита 7 поля +9 выполняется проверка перехода
; на сторону противника, свободная либо однотипная запись ищется в FD47, нулевой результат #7C0D
; при DE=5 разрешает перенос или объединение, ненулевой результат оставляет отряд в первой армии,
; обычный управляемый отряд через D3A9 передаётся циклу D41A
; In:
;   инициализированные армии FCED и FD47 по пять записей длиной 18, в записях +12 остаток
;   действий, +9 биты 3 и 7, сохранённый SP входа в бой по E0BD, разрешённые прерывания для
;   дальнейшего HALT
; Out:
;   обычного RET нет, IY выбранный отряд при переходе в D41A, DD56 указатель имени типа, при
;   исчерпании действий управление через E0BF и D25C возвращается к выбору, при уходе последнего
;   отряда возможен выход всего боя через DA9E
; Corrupt:
;   HL, DE, BC, AF, IX, IY, записи обеих армий, DD56, DD60 и поля текстовых шаблонов, экран,
;   состояние генератора и калькулятора, SP при выходе из всего боя восстанавливается из E0BD,
;   сохранение входных основных регистров не предусмотрено
; -----------------------------------------
SelectActor     LD IY, Battle.FinishField.HeroArmy
                LD DE, #0012
                LD B, #05

                ; поиск отряда с оставшимися действиями, ещё не выбранного в текущем круге
.FindFreshUnit  LD A, (IY + FBattleUnit.ActionsLeft)                            ; +#0C, оставшиеся действия текущего раунда
                OR A
                JR Z, .ClearPassFlags                                           ; переход, если у очередного отряда нет оставшихся шагов

                BIT HERO_ACTED_BIT, (IY + FBattleUnit.Flags)                    ; +#09, флаг, отряд героя уже выбирался в текущем круге выбора действующего отряда
                JR Z, .ActivateUnit                                             ; переход, если отряд ещё не выбирался в текущем проходе

                ; оригинал снимает бит 3 Flags первой записи, следующие четыре смещения затрагивают другие поля
.ClearPassFlags ADD IY, DE
                DJNZ .FindFreshUnit

                LD IY, Battle.FinishField.HeroArmy
                RES HERO_ACTED_BIT, (IY + FBattleUnit.Flags)                    ; +#09, флаг, отряд героя уже выбирался в текущем круге выбора действующего отряда
                RES PASS_CLEAR_BIT, (IY + FBattleArmy.Second.Quantity + 3)      ; оригинал сбрасывает бит 3 байта численности второго отряда
                RES PASS_CLEAR_BIT, (IY + FBattleArmy.Third.Affinity)           ; оригинал сбрасывает бит 3 совместимости третьего отряда
                RES PASS_CLEAR_BIT, (IY + FBattleArmy.Third.InitialCount.High)  ; оригинал сбрасывает бит 3 старшего байта исходной численности третьего отряда
                RES PASS_CLEAR_BIT, (IY + FBattleArmy.Fourth.Y)                 ; оригинал сбрасывает бит 3 строки четвёртого отряда
                LD B, #05
.FindAnyUnit    LD A, (IY + FBattleUnit.ActionsLeft)                            ; +#0C, оставшиеся действия текущего раунда
                OR A
                JR NZ, .ActivateUnit                                            ; переход, если у отряда остались шаги

                ADD IY, DE
                DJNZ .FindAnyUnit

                CALL AITurn                                                     ; выполнить ход противника и сбросить отметки раунда
                JP Battle.NewRound

                ; активация выбранного отряда, проверка предела управления и подготовка информационной строки
.ActivateUnit   SET HERO_ACTED_BIT, (IY + FBattleUnit.Flags)                    ; +#09, флаг, отряд героя уже выбирался в текущем круге выбора действующего отряда
                CALL MarkUnruled                                                ; обновить признак превышения контроля у отрядов героя
                LD A, #47
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD A, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD (Battle.PickOccupied.UnitName), IX
                BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)                   ; +#09, флаг, численность отряда превышает предел управления героя
                JP Z, .ShowActions                                              ; переход, если отряд остаётся под контролем героя

                LD HL, Battle.FinishField.EnemyArmy
                LD B, #05
                LD DE, #0012
.FindSameEnemy  LD A, (HL)
                OR A
                JR Z, .CheckRebelJoin                                           ; переход, если список противника завершён

                CP (IY + FBattleUnit.UnitID)                                    ; +#00, ID типа, 0 завершает плотный список
                JR Z, .CheckRebelJoin                                           ; переход, если у противника найден отряд такого же типа

                ADD HL, DE
                DJNZ .FindSameEnemy

.RunRebelTurn   LD A, #41
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD DE, Battle.PickOccupied.UnruledText                          ; сообщение об отказе отряда подчиняться герою
                LD B, #01
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                CALL RunUncontrolled                                            ; выполнить случайный ход или атаку вышедшего из подчинения отряда
                JP SelectActor

                ; случайная проверка перехода вышедшего из подчинения отряда на сторону противника
.CheckRebelJoin LD DE, #0005
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD A, E
                OR A
                JR NZ, .RunRebelTurn                                            ; переход, если случайный отсчёт не разрешил присоединение к противнику

                LD A, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                LD (HL), A
                INC HL
                INC HL
                PUSH HL
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                PUSH IY
                POP HL
                INC HL
                INC HL
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F                                                          ; addition, сложение, D359
                DB #38                                                          ; end-calc, возврат в Z80, D35A
                POP HL
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                PUSH HL
                PUSH IY
                POP HL
                LD DE, #0007
                ADD HL, DE
                POP DE
                LD BC, #0007
                LDIR
                LD (IY + FBattleUnit.UnitID), #00                               ; +#00, ID типа, 0 завершает плотный список
                LD HL, Battle.FinishField.HeroArmy
                CALL CompactArmy                                                ; уплотнить пять записей армии и очистить освободившийся хвост
                PUSH IY
                PUSH IX
                CALL RefreshObjects                                             ; сбросить флаги сорока объектов поля и заново отобразить армии
                CALL DrawBothArmies                                             ; обновить экранные объекты обеих армий
                POP IX
                POP IY
                LD A, #42
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD DE, (Battle.PickOccupied.UnitName)
                LD (Battle.PickOccupied.RebelName), DE
                LD B, #01
                LD DE, Battle.PickOccupied.JoinedText                           ; сообщение о переходе вышедшего из-под контроля отряда к противнику
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD A, (Battle.FinishField.HeroArmy)
                OR A
                JP Z, InputLoop.EndWithRansom                                   ; переход, если после ухода бунтовщика армия героя опустела

                JP SelectActor

.ShowActions    LD B, #00
                LD C, (IY + FBattleUnit.ActionsLeft)                            ; +#0C, оставшиеся действия текущего раунда
                LD (Battle.PickOccupied.MovesLeft), BC
                LD B, #01
                LD DE, Battle.PickOccupied.UnitMovesText                        ; имя действующего отряда и запас шагов
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (IY + FBattleUnit.Flags)                                  ; +#09, способности и временные отметки раунда, цели и контроля
                AND #07
                JR Z, InputLoop                                                 ; переход, если отряд не имеет стрельбы или полёта

                CP #01
                JR NZ, .TestRangedKind                                          ; переход, если тип возможностей отличается от магического дальнего действия

                LD A, (IY + FBattleUnit.ActionStock)                            ; +#08, остаток расходуемого дальнего действия
                OR A
                JR Z, InputLoop                                                 ; переход, если магические заряды исчерпаны

                LD DE, Battle.PickOccupied.MagicInfoText                        ; сообщение о запасе магического дальнего действия
                JR .ShowAmmo

.TestRangedKind CP #02
                JR NZ, .TestFlyKind                                             ; переход, если тип возможностей отличается от обычной стрельбы

                LD A, (IY + FBattleUnit.ActionStock)                            ; +#08, остаток расходуемого дальнего действия
                OR A
                JR Z, InputLoop                                                 ; переход, если стрелы исчерпаны

                LD DE, Battle.PickOccupied.ArrowInfoText                        ; сообщение о запасе обычной стрельбы
                JR .ShowAmmo

.TestFlyKind    CP #04
                JR NZ, .TestHybridKind                                          ; переход, если отряд не является чистым летуном

.FlyDescription LD DE, Battle.PickOccupied.FlightText                           ; сообщение о способности летать
                JR .ShowAmmo

.TestHybridKind CP #05
                JR NZ, .TestOtherAmmo                                           ; переход, если отряд не совмещает магическое дальнее действие и полёт

                LD A, (IY + FBattleUnit.ActionStock)                            ; +#08, остаток расходуемого дальнего действия
                OR A
                JR Z, .FlyDescription                                           ; переход, если у летающего отряда исчерпаны магические заряды

                LD DE, Battle.PickOccupied.MagicFlyText                         ; сообщение о запасе магического дальнего действия и полёте
                JR .ShowAmmo

.TestOtherAmmo  LD A, (IY + FBattleUnit.ActionStock)                            ; +#08, остаток расходуемого дальнего действия
                OR A
                JR Z, .FlyDescription                                           ; переход, если запас дальнего действия исчерпан

                LD DE, Battle.PickOccupied.ArrowFlyText                         ; сообщение о запасе обычной стрельбы и полёте
.ShowAmmo       LD C, (IY + FBattleUnit.ActionStock)                            ; +#08, остаток расходуемого дальнего действия
                LD B, #00
                LD (Battle.PickOccupied.ArrowAmmo), BC
                LD (Battle.PickOccupied.ArrowFlyAmmo), BC
                LD (Battle.PickOccupied.MagicAmmo), BC
                LD (Battle.PickOccupied.MagicFlyAmmo), BC
                LD B, #02
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
