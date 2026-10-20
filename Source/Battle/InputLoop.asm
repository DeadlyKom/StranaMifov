
; -----------------------------------------
; ожидать и выполнять команды выбранного отряда героя
; F912 выбирает оформление по коду 24, HALT синхронизирует ожидание, 6BF1 опрашивается до CF=1,
; затем BC берётся из +10 и +11 отряда, восемь кодов 13,1B,23,12,22,11,19,21 задают соседнюю
; клетку через E013, E018, E01E, E023, F67C отбрасывает недопустимую клетку, F65E ищет занятость,
; свободная клетка очищается F648 и записывается в +10,+11 с уменьшением +12, занятый вражеский
; либо бунтующий дружественный отряд вызывает рукопашную F0A0 с A=1, код 1D откладывает ход, 20
; обнуляет +12, 1E запускает ветвь стрельбы, 0A ветвь заклинаний, остальные распознаваемые команды
; переходят в обработчики D9D3 и далее, после действия управление возвращается к D2B5 или D2F8,
; F6B8 может завершить весь бой
; In:
;   IY запись выбранного отряда героя длиной 18, её +10,+11 текущая клетка, +12 остаток
;   действий, DD56 имя типа, армии FCED и FD47 и рабочее поле боя инициализированы, SP входа в
;   бой сохранён в E0BD, прерывания разрешены для HALT
; Out:
;   обычного RET нет, недопустимый ввод повторяет D420, выполненное действие переходит в D2B5
;   либо D2F8, перемещение обновляет +10,+11 и уменьшает +12, пропуск обнуляет +12, завершение
;   боя возвращает результат внешнему вызову D255 через восстановленный SP
; Corrupt:
;   HL, DE, BC, AF, IX, IY, координаты, действия и прочие боевые поля обеих армий, экран,
;   текстовые и боевые рабочие переменные, состояние генератора и калькулятора, SP на
;   завершающем пути восстанавливается из E0BD, сохранение входных основных регистров не
;   предусмотрено
; -----------------------------------------
InputLoop       LD A, #24
                CALL MakeActingUnit                                             ; сформировать четырёхкадровый объект действующего отряда
                HALT
.ReadCommand    CALL Engine.ReadInput                                           ; прочитать клавиатуру или Kempston
                JR NC, .ReadCommand                                             ; переход, если новый ввод ещё не распознан

                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CP #13
                JP NZ, .TestMoveUp                                              ; переход, если не выбрано движение влево вверх

                CALL CellUp                                                     ; уменьшить строку клетки без выхода за верхний край
                CALL CellLeft                                                   ; уменьшить столбец клетки без выхода за левый край

                ; проверка доступности соседней клетки, свободная клетка означает движение, занятая допускает атаку
.TryMove        CALL TestObstacle                                               ; проверить препятствие выбранной клетки
                JR NZ, .ReadCommand                                             ; переход, если клетка закрыта препятствием

                LD IX, Battle.FinishField.HeroArmy
                CALL FindUnitAtCell                                             ; найти отряд с заданными координатами в одной армии
                JR NZ, .CheckEnemyCell                                          ; переход, если в клетке отсутствует отряд героя

                BIT UNIT_UNRULE_BIT, (IX + FBattleUnit.Flags)                   ; флаг, численность отряда превышает предел управления героя
                JP Z, .ReadCommand                                              ; переход, если отряд героя подчиняется игроку, атаковать его нельзя

                LD (IX + FBattleUnit.Affinity), #01
                JP .MeleeAttack

.CheckEnemyCell LD IX, Battle.FinishField.EnemyArmy
                CALL FindUnitAtCell                                             ; найти отряд с заданными координатами в одной армии
                JR Z, .EnemyMood                                                ; переход, если в клетке найден отряд противника

                PUSH BC
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL DirtyCell                                                  ; пометить экранный объект клетки как пустой для перерисовки
                POP BC
                LD (IY + FBattleUnit.X), C                                      ; +#0A, колонка 0..7
                LD (IY + FBattleUnit.Y), B                                      ; +#0B, строка 0..4
                DEC (IY + FBattleUnit.ActionsLeft)                              ; +#0C, оставшиеся действия текущего раунда
                JP NZ, SelectActor.ActivateUnit                                 ; переход, если у действующего отряда остались шаги

                LD A, #23
                CALL MakeStaticUnit                                             ; сформировать неподвижный объект отряда и его отображаемое количество
                JP SelectActor

.EnemyMood      LD B, (IX + FBattleUnit.UnitID)
                LD C, #00
                LD HL, Battle.FinishField.EnemyArmy
                LD DE, #0012
                CALL Engine.ArmyMood                                            ; оценить совместимость типа отряда с составом армии
                LD (IX + FBattleUnit.Affinity), A
.MeleeAttack    LD A, (State.Cult)
                LD C, A
                LD B, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                LD HL, Battle.FinishField.HeroArmy
                LD DE, #0012
                CALL Engine.ArmyMood                                            ; оценить совместимость типа отряда с составом армии
                LD (IY + FBattleUnit.Affinity), A                               ; +#01, знаковая совместимость состава от -2 до 2, для выбора поправки прибавляется 3
                LD (IY + FBattleUnit.ActionsLeft), #00                          ; +#0C, оставшиеся действия текущего раунда
                PUSH IY
                PUSH IX
                LD A, #01
                CALL ResolveAttack                                              ; рассчитать атаку и возможный ответный удар
                POP IX
                POP IY
                CALL ResolveLosses                                              ; удалить погибших, обработать бунт и проверить исход боя
                JP SelectActor

.TestMoveUp     CP #1B
                JR NZ, .TestMoveNE                                              ; переход, если не выбрано движение вверх

                CALL CellUp                                                     ; уменьшить строку клетки без выхода за верхний край
                JP .TryMove

.TestMoveNE     CP #23
                JR NZ, .TestMoveLeft                                            ; переход, если не выбрано движение вправо вверх

                CALL CellUp                                                     ; уменьшить строку клетки без выхода за верхний край
                CALL CellRight                                                  ; увеличить столбец клетки без выхода за правый край
                JP .TryMove

.TestMoveLeft   CP #12
                JR NZ, .TestMoveRight                                           ; переход, если не выбрано движение влево

                CALL CellLeft                                                   ; уменьшить столбец клетки без выхода за левый край
                JP .TryMove

.TestMoveRight  CP #22
                JR NZ, .TestMoveSW                                              ; переход, если не выбрано движение вправо

                CALL CellRight                                                  ; увеличить столбец клетки без выхода за правый край
                JP .TryMove

.TestMoveSW     CP #11
                JR NZ, .TestMoveDown                                            ; переход, если не выбрано движение влево вниз

                CALL CellDown                                                   ; увеличить строку клетки без выхода за нижний край
                CALL CellLeft                                                   ; уменьшить столбец клетки без выхода за левый край
                JP .TryMove

.TestMoveDown   CP #19
                JR NZ, .TestMoveSE                                              ; переход, если не выбрано движение вниз

                CALL CellDown                                                   ; увеличить строку клетки без выхода за нижний край
                JP .TryMove

.TestMoveSE     CP #21
                JR NZ, .TestEndTurn                                             ; переход, если не выбрано движение вправо вниз

                CALL CellDown                                                   ; увеличить строку клетки без выхода за нижний край
                CALL CellRight                                                  ; увеличить столбец клетки без выхода за правый край
                JP .TryMove

.TestEndTurn    CP #1D
                JR Z, .EndTurn                                                  ; переход, если нажата команда завершения хода

                CP #20
                JR NZ, .TestShot                                                ; переход, если не нажата отмена действия

                LD (IY + FBattleUnit.ActionsLeft), #00                          ; +#0C, оставшиеся действия текущего раунда
.EndTurn        LD A, #23
                CALL MakeStaticUnit                                             ; сформировать неподвижный объект отряда и его отображаемое количество
                JP SelectActor

.TestShot       CP #1E
                JP NZ, .TestSpellKey                                            ; переход, если не выбрана стрельба

                LD A, (IY + FBattleUnit.Flags)                                  ; +#09, способности и временные отметки раунда, цели и контроля
                AND #03
                OR A
                JR NZ, .TestAmmo                                                ; переход, если отряд имеет дальнее действие

                LD A, #47
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD DE, Battle.PickOccupied.NoRangeText                          ; сообщение об отсутствии стрельбы и магического дальнего действия
                JR .ShowMessage

.TestAmmo       LD A, (IY + FBattleUnit.ActionStock)                            ; +#08, остаток расходуемого дальнего действия
                OR A
                JP NZ, .CheckNearUnits                                          ; переход, если у отряда остались боеприпасы

                LD A, #47
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD DE, Battle.PickOccupied.NoMagicText                          ; сообщение об исчерпании магических зарядов
                BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)                    ; +#09, флаг, тип отряда использует магическое дальнее действие
                JR NZ, .ShowMessage                                             ; переход, если у отряда магическое дальнее действие, требуется сообщение об исчерпании зарядов

                LD DE, Battle.PickOccupied.NoArrowsText                         ; сообщение об исчерпании стрел
.ShowMessage    LD B, #01
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #05
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP SelectActor.ActivateUnit

                ; дальнее действие запрещается при непосредственном соседстве с отрядом противника
.CheckNearUnits LD IX, Battle.FinishField.EnemyArmy
                LD B, #05
.EnemyLoop      LD A, (IX + FBattleUnit.UnitID)
                OR A
                JR Z, .ShowShotPrompt                                           ; переход, если список отрядов противника завершён

                LD A, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                SUB (IX + FBattleUnit.X)
                JR Z, .CheckDeltaY                                              ; переход, если цель находится в том же столбце

                JR NC, .CheckDeltaX                                             ; переход, если разность столбцов неотрицательна

                NEG
.CheckDeltaX    DEC A
                JR NZ, .NextEnemy                                               ; переход, если расстояние по горизонтали отличается от единицы

.CheckDeltaY    LD A, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                SUB (IX + FBattleUnit.Y)
                JP Z, SelectActor.ActivateUnit                                  ; переход, если противник стоит в соседней клетке той же строки

                JR NC, .LimitDeltaY                                             ; переход, если разность строк неотрицательна

                NEG
.LimitDeltaY    DEC A
                JP Z, SelectActor.ActivateUnit                                  ; переход, если противник стоит в соседней строке

.NextEnemy      LD DE, #0012
                ADD IX, DE
                DJNZ .EnemyLoop

.ShowShotPrompt LD A, #47
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD DE, Battle.PickOccupied.CastVerbText                         ; подставляемый глагол колдуют для приглашения дальнего действия
                BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)                    ; +#09, флаг, тип отряда использует магическое дальнее действие
                JR NZ, .SelectShotCell                                          ; переход, если у отряда магическое дальнее действие

                LD DE, Battle.PickOccupied.ShootVerbText                        ; подставляемый глагол стреляют для приглашения дальнего действия

                ; выбор занятой клетки для дальнего действия и подстановка имени типа в приглашение
.SelectShotCell LD (Battle.PickOccupied.ShotPrompt), DE
                LD DE, (Battle.PickOccupied.UnitName)
                LD (Battle.PickOccupied.ShotName), DE
                LD B, #01
                LD DE, Battle.PickOccupied.ShotPromptText                       ; приглашение выбрать цель дальнего действия, имя и глагол подставляются
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL PickOccupied                                               ; выбрать клетку, занятую любым отрядом
                JP NZ, SelectActor.ActivateUnit                                 ; переход, если выбор занятой клетки отменён

                DEC (IY + FBattleUnit.ActionStock)                              ; +#08, остаток расходуемого дальнего действия
                LD (IY + FBattleUnit.ActionsLeft), #00                          ; +#0C, оставшиеся действия текущего раунда
                BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)                    ; +#09, флаг, тип отряда использует магическое дальнее действие
                JR Z, .ShootTarget                                              ; переход, если у отряда обычная стрельба

                LD A, (IX + FBattleUnit.UnitID)
                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                BIT MAGIC_IMM_BIT, D                                            ; флаг, тип цели невосприимчив к целевому магическому действию
                JR Z, .CheckShotWard                                            ; переход, если тип цели не имеет иммунитета к магическому действию

                LD A, #42
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD A, (IX + FBattleUnit.UnitID)
                PUSH IX
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD (Battle.PickOccupied.ImmuneName), IX
                POP IX
                LD DE, Battle.PickOccupied.ImmuneText                           ; сообщение о невосприимчивости типа отряда к магии
                LD B, #01
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #05
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP SelectActor

.CheckShotWard  CALL HasMagicShield                                             ; проверить магический щит стороны выбранной цели
                JP NC, SelectActor                                              ; переход, если цель защищена магическим щитом

.ShootTarget    LD A, (State.Cult)
                LD C, A
                LD B, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                LD HL, Battle.FinishField.HeroArmy
                LD DE, #0012
                CALL Engine.ArmyMood                                            ; оценить совместимость типа отряда с составом армии
                LD (IY + FBattleUnit.Affinity), A                               ; +#01, знаковая совместимость состава от -2 до 2, для выбора поправки прибавляется 3
                PUSH IY
                PUSH IX
                LD A, #02
                CALL ResolveAttack                                              ; рассчитать атаку и возможный ответный удар
                POP IX
                POP IY
                CALL ResolveLosses                                              ; удалить погибших, обработать бунт и проверить исход боя
                JP SelectActor

                ; проверка доступности магии и построение меню только изученных заклинаний
.TestSpellKey   CP #0A
                JP NZ, .TestSurrender                                           ; переход, если не выбрано меню магии

                LD A, (Battle.FinishField.Flags)
                BIT SPELL_USED_BIT, A                                           ; флаг, попытка магии героя уже использована в текущем раунде
                JP NZ, InputLoop                                                ; переход, если попытка магии героя в текущем раунде уже использована

                LD HL, State.Spells
                LD B, #0A
                XOR A
.CountSpells    BIT SPELL_KNOWN_BIT, (HL)                                       ; флаг, заклинание изучено героем и включается в список доступной магии
                JR Z, .NextSpellCount                                           ; переход, если заклинание не изучено

                INC A
.NextSpellCount INC HL
                DJNZ .CountSpells

                OR A
                JR NZ, .CheckMana                                               ; переход, если изучено хотя бы одно заклинание

                LD A, #42
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD DE, Battle.PickOccupied.NoSpellsText                         ; сообщение об отсутствии изученных заклинаний
                JP .ShowMessage

.CheckMana      INC A
                LD (Battle.PickOccupied.SpellCount), A
                ADD A, #03
                LD (Battle.InputLoop.SpellCount), A
                LD HL, (State.Mana)
                LD A, H
                OR L
                JR NZ, .CheckWard                                               ; переход, если у героя есть мана

                LD A, #42
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD DE, Battle.PickOccupied.NoManaText                           ; сообщение об отсутствии магической силы героя
                JP .ShowMessage

.CheckWard      LD A, (Battle.FinishField.Flags)
                BIT ENEMY_WARD_BIT, A                                           ; флаг, армия противника защищена магическим щитом
                JR Z, .DrawSpellMenu                                            ; переход, если противник не защищён магическим щитом

                LD A, #42
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD B, #01
                LD DE, Battle.PickOccupied.EnemyWardText                        ; предупреждение о магическом щите противника
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
.DrawSpellMenu  CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD BC, #0500
                LD E, #1E
.SpellCount     EQU $+1                                                         ; операнд числа строк меню изученных заклинаний
                LD D, #00
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #06
                LD DE, Battle.PickOccupied.ManaHeaderText                       ; заголовок шкалы магической силы
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD DE, Screen.Pixels + 737                                      ; пиксели шкалы магической силы, x8 и y58
                LD HL, (State.Mana)

                ; отображение целых делений запаса магической силы
.DrawManaUnits  OR A
                LD BC, #0890
                SBC HL, BC
                JR C, .PartialMana                                              ; переход, если оставшейся маны меньше стоимости полного деления шкалы

                LD B, #04
                LD A, #FF
                PUSH DE
.ManaUnitRows   LD (DE), A
                INC D
                DJNZ .ManaUnitRows

                POP DE
                INC DE
                JR .DrawManaUnits

                ; построение частично заполненного деления шкалы магической силы
.PartialMana    XOR A
                ADD HL, BC
                LD BC, #0112
.PartialBits    SBC HL, BC
                JR C, .DrawPartial                                              ; переход, если остаток меньше стоимости следующей части деления

                SRL A
                SET BAR_FILL_BIT, A                                             ; позиция левого пикселя, заполняемого при построении частичного деления шкалы маны
                JR .PartialBits

.DrawPartial    LD B, #04
.PartialRows    LD (DE), A
                INC D
                DJNZ .PartialRows

                LD HL, State.Spells
                LD BC, #0A02
                LD (Battle.InputLoop.SpellPosition), BC
                LD A, #01

                ; печать названий изученных заклинаний и запоминание числа строк меню
.SpellNameLoop  BIT SPELL_KNOWN_BIT, (HL)                                       ; флаг, заклинание изучено героем и включается в список доступной магии
                JR Z, .NextSpellName                                            ; переход, если заклинание не изучено

                PUSH AF
                PUSH HL
                CALL Engine.SpellDesc                                           ; получить описатель одного из десяти заклинаний
                PUSH IX
                POP DE
.SpellPosition  EQU $+1                                                         ; операнд BC позиции очередного названия заклинания
.SpellRow       EQU $+2                                                         ; старший байт BC строки очередного названия заклинания
                LD BC, #0000
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (Battle.InputLoop.SpellRow)
                INC A
                LD (Battle.InputLoop.SpellRow), A
                POP HL
                POP AF
.NextSpellName  INC A
                INC HL
                CP #0B
                JR NZ, .SpellNameLoop                                           ; переход, если ещё не перебраны все десять заклинаний

                PUSH IY
                LD IX, Battle.PickOccupied.SpellCount
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                POP IY
                PUSH AF
                CALL RefreshObjects                                             ; сбросить флаги сорока объектов поля и заново отобразить армии
                POP AF
                HALT
                CP #01
                JP Z, SelectActor.ActivateUnit                                  ; переход, если выбран выход из меню магии

                LD HL, State.Spells - 1                                         ; смещённая база списка заклинаний, цикл сначала увеличивает HL
                LD B, A
                DEC B
                XOR A

                ; перевод номера выбранной строки меню в исходный номер изученного заклинания
.FindSpellId    INC HL
                INC A
                BIT SPELL_KNOWN_BIT, (HL)                                       ; флаг, заклинание изучено героем и включается в список доступной магии
                JR Z, .FindSpellId                                              ; переход, если текущая запись не соответствует изученному заклинанию

                DJNZ .FindSpellId

                CP #08
                JP NZ, .TestWardSpell                                           ; переход, если выбрана не невидимость

                CALL ShowSpell                                                  ; показать название и параметры выбранного заклинания
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL PickOccupied                                               ; выбрать клетку, занятую любым отрядом
                JP NZ, SelectActor.ActivateUnit                                 ; переход, если выбор цели невидимости отменён

                LD BC, (Data.Battle.Invisible.ManaCost)
                CALL SpendHeroMagic                                             ; списать магическую силу героя с насыщением нулём
                JP C, SelectActor.ActivateUnit                                  ; переход, если маны на невидимость не хватает

                LD A, (IX + FBattleUnit.UnitID)
                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                BIT MAGIC_IMM_BIT, D                                            ; флаг, тип цели невосприимчив к целевому магическому действию
                JR Z, .CastInvisible                                            ; переход, если тип цели допускает невидимость

.ShowWrongUnit  PUSH IX
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD (Battle.PickOccupied.ImmuneName), IX
                POP IX
                LD A, #42
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD DE, Battle.PickOccupied.ImmuneText                           ; сообщение о невосприимчивости типа отряда к магии
                JP .ShowMessage

.CastInvisible  CALL HasMagicShield                                             ; проверить магический щит стороны выбранной цели
                JP NC, SelectActor.ActivateUnit                                 ; переход, если цель защищена магическим щитом

                LD (IX + FBattleUnit.Effect), #82
                JP SelectActor.ActivateUnit

.TestWardSpell  CP #09
                JR NZ, .TestSubjugate                                           ; переход, если выбран не магический щит

                LD BC, (Data.Battle.MagicWard.ManaCost)
                CALL SpendHeroMagic                                             ; списать магическую силу героя с насыщением нулём
                JP C, SelectActor.ActivateUnit                                  ; переход, если маны на щит не хватает

                LD A, #47
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD A, (Battle.FinishField.Flags)
                XOR #01
                LD (Battle.FinishField.Flags), A
                LD DE, Battle.PickOccupied.WardOffText                          ; подставляемый текст снятого щита
                BIT HERO_WARD_BIT, A                                            ; флаг, армия героя защищена магическим щитом
                JR Z, .ShowWardState                                            ; переход, если щит героя после переключения отключён

                LD DE, Battle.PickOccupied.WardOnText                           ; подставляемый текст установленного щита
.ShowWardState  LD (Battle.PickOccupied.WardState), DE
                LD DE, Battle.PickOccupied.WardStateText                        ; сообщение о включении либо снятии магического щита
                JP .ShowMessage

.TestSubjugate  CP #0A
                JP NZ, .TestWallSpell                                           ; переход, если выбрано не подчинение

                LD A, #0A
                CALL ShowSpell                                                  ; показать название и параметры выбранного заклинания
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL PickOccupied                                               ; выбрать клетку, занятую любым отрядом
                JP NZ, SelectActor.ActivateUnit                                 ; переход, если выбор цели подчинения отменён

                LD BC, (Data.Battle.Subjugate.ManaCost)
                CALL SpendHeroMagic                                             ; списать магическую силу героя с насыщением нулём
                JP C, SelectActor.ActivateUnit                                  ; переход, если маны на подчинение не хватает

                CALL HasMagicShield                                             ; проверить магический щит стороны выбранной цели
                JP NC, SelectActor.ActivateUnit                                 ; переход, если цель защищена магическим щитом

                LD A, (IX + FBattleUnit.UnitID)
                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                BIT MAGIC_IMM_BIT, D                                            ; флаг, тип цели невосприимчив к целевому магическому действию
                JP NZ, .ShowWrongUnit                                           ; переход, если тип цели невосприимчив к заклинанию

                CP #13
                JP Z, SelectActor.ActivateUnit                                  ; переход, если цель уже является зомби

                LD HL, Battle.FinishField.HeroArmy
                LD DE, #0012
                LD B, #05
.FindZombie     LD A, (HL)
                OR A
                JP Z, SelectActor.ActivateUnit                                  ; переход, если в армии героя нет зомби для приёма численности

                CP #13
                JR Z, .AddZombieCount                                           ; переход, если найден отряд зомби

                ADD HL, DE
                DJNZ .FindZombie

                JP SelectActor.ActivateUnit

.AddZombieCount INC HL
                INC HL
                PUSH HL
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                PUSH IX
                POP HL
                INC HL
                INC HL
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                PUSH IX
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F                                                          ; addition, сложение, D7EE
                DB #38                                                          ; end-calc, возврат в Z80, D7EF
                POP IX
                POP HL
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD (IX + FBattleUnit.Quantity), #00
                LD (IX + FBattleUnit.Quantity + 1), #00
                LD (IX + FBattleUnit.Quantity + 2), #00
                LD (IX + FBattleUnit.Quantity + 3), #00
                LD (IX + FBattleUnit.Quantity + 4), #00
                CALL ResolveLosses                                              ; удалить погибших, обработать бунт и проверить исход боя
                CALL DrawBothArmies                                             ; обновить экранные объекты обеих армий
                HALT
                JP SelectActor.ActivateUnit

.TestWallSpell  CP #07
                JP NZ, .TestClone                                               ; переход, если выбрана не волшебная стена

                LD BC, (Data.Battle.Wall.ManaCost)
                CALL SpendHeroMagic                                             ; списать магическую силу героя с насыщением нулём
                JP C, SelectActor.ActivateUnit                                  ; переход, если маны на стену не хватает

                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD A, #42
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                LD B, #01
                LD DE, Battle.PickOccupied.WallCellText                         ; приглашение поставить волшебную стену в выбранную клетку
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4

                ; выбор свободной клетки для магической стены, занятые отрядами клетки отклоняются
.PickWallCell   CALL SelectCell                                                 ; перемещать курсор по боевому полю до подтверждения либо отмены
                JP NZ, SelectActor.ActivateUnit                                 ; переход, если выбор клетки стены отменён

                LD IX, Battle.FinishField.EnemyArmy
                CALL FindUnitAtCell                                             ; найти отряд с заданными координатами в одной армии
                JR Z, .PickWallCell                                             ; переход, если клетка стены занята противником

                LD IX, Battle.FinishField.HeroArmy
                CALL FindUnitAtCell                                             ; найти отряд с заданными координатами в одной армии
                JR Z, .PickWallCell                                             ; переход, если клетка стены занята отрядом героя

                LD HL, Battle.FinishField.ObstacleRows
                LD E, B
                LD D, #00
                ADD HL, DE
                LD A, #07
                SUB C
                SLA A
                SLA A
                SLA A
                OR #C6
                LD (Battle.InputLoop.WallBit), A
.WallBit        EQU $+1                                                         ; изменяемый байт SET выбранного столбца стены
                SET FIELD_COL_BIT, (HL)                                         ; исходная позиция бита в шаблоне самоменяемой проверки либо установки столбца поля
                CALL GetCellObject                                              ; получить экранный объект боевой клетки
                LD (IX + FScreenObject20.Flags), #01
                LD (IX + FScreenObject20.BaseBank), #04
                LD (IX + FScreenObject20.BaseAddress.Low), #10
                LD (IX + FScreenObject20.BaseAddress.High), #EE
                CALL Engine.StartView                                           ; включить обработку объектов в прерывании
                HALT
                JP SelectActor.ActivateUnit

.TestClone      CP #06
                JP NZ, .TestTeleport                                            ; переход, если выбрано не клонирование

                CALL ShowSpell                                                  ; показать название и параметры выбранного заклинания
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL PickOccupied                                               ; выбрать клетку, занятую любым отрядом
                JP NZ, SelectActor.ActivateUnit                                 ; переход, если выбор цели клонирования отменён

                LD BC, (Data.Battle.Clone.ManaCost)
                CALL SpendHeroMagic                                             ; списать магическую силу героя с насыщением нулём
                JP C, SelectActor.ActivateUnit                                  ; переход, если маны на клонирование не хватает

                LD A, (IX + FBattleUnit.UnitID)
                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                BIT MAGIC_IMM_BIT, D                                            ; флаг, тип цели невосприимчив к целевому магическому действию
                JP NZ, .ShowWrongUnit                                           ; переход, если тип цели невосприимчив к заклинанию

                CALL HasMagicShield                                             ; проверить магический щит стороны выбранной цели
                JP NC, SelectActor.ActivateUnit                                 ; переход, если цель защищена магическим щитом

                LD DE, (State.Mana)
                LD BC, #060F
                CALL ApplySpell                                                 ; изменить количество цели по силе заклинания
                LD (IX + FBattleUnit.Effect), #62
                CALL RefreshObjects                                             ; сбросить флаги сорока объектов поля и заново отобразить армии
                HALT
                JP SelectActor.ActivateUnit

.TestTeleport   CP #04
                JP NZ, .TestBanish                                              ; переход, если выбрана не телепортация

                CALL ShowSpell                                                  ; показать название и параметры выбранного заклинания
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL PickOccupied                                               ; выбрать клетку, занятую любым отрядом
                JP NZ, SelectActor.ActivateUnit                                 ; переход, если выбор переносимого отряда отменён

                LD BC, #0201
                LD DE, #011E
                LD A, #47
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD B, #02
                LD DE, Battle.PickOccupied.TeleportText                         ; приглашение выбрать новое положение переносимого отряда
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD (Battle.InputLoop.TeleportUnit), IX
                LD C, (IX + FBattleUnit.X)
                LD B, (IX + FBattleUnit.Y)

                ; выбор свободной клетки назначения при переносе выбранного отряда
.PickTeleport   CALL SelectCell                                                 ; перемещать курсор по боевому полю до подтверждения либо отмены
                JP NZ, SelectActor.ActivateUnit                                 ; переход, если выбор клетки переноса отменён

                LD IX, Battle.FinishField.EnemyArmy
                CALL FindUnitAtCell                                             ; найти отряд с заданными координатами в одной армии
                JR Z, .PickTeleport                                             ; переход, если клетка переноса занята противником

                LD IX, Battle.FinishField.HeroArmy
                CALL FindUnitAtCell                                             ; найти отряд с заданными координатами в одной армии
                JR Z, .PickTeleport                                             ; переход, если клетка переноса занята отрядом героя

                PUSH BC
                LD BC, (Data.Battle.Teleport.ManaCost)
                CALL SpendHeroMagic                                             ; списать магическую силу героя с насыщением нулём
                POP BC
                JP C, SelectActor.ActivateUnit                                  ; переход, если маны на телепортацию не хватает

.TeleportUnit   EQU $+2                                                         ; операнд IX переносимого отряда
                LD IX, #0000
                LD A, (IX + FBattleUnit.UnitID)
                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                BIT MAGIC_IMM_BIT, D                                            ; флаг, тип цели невосприимчив к целевому магическому действию
                JP NZ, .ShowWrongUnit                                           ; переход, если тип цели невосприимчив к заклинанию

                CALL HasMagicShield                                             ; проверить магический щит стороны выбранной цели
                JP NC, SelectActor.ActivateUnit                                 ; переход, если цель защищена магическим щитом

                LD (IX + FBattleUnit.X), C
                LD (IX + FBattleUnit.Y), B
                CALL RefreshObjects                                             ; сбросить флаги сорока объектов поля и заново отобразить армии
                HALT
                JP SelectActor.ActivateUnit

.TestBanish     CP #05
                JP NZ, .CastUnitSpell                                           ; переход, если выбрано не возвращение в могилу

                CALL ShowSpell                                                  ; показать название и параметры выбранного заклинания
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL PickOccupied                                               ; выбрать клетку, занятую любым отрядом
                JP NZ, SelectActor.ActivateUnit                                 ; переход, если выбор цели возвращения в могилу отменён

                LD BC, (Data.Battle.Banish.ManaCost)
                CALL SpendHeroMagic                                             ; списать магическую силу героя с насыщением нулём
                JP C, SelectActor.ActivateUnit                                  ; переход, если маны на возвращение в могилу не хватает

                CALL HasMagicShield                                             ; проверить магический щит стороны выбранной цели
                JP NC, SelectActor.ActivateUnit                                 ; переход, если цель защищена магическим щитом

                LD A, (IX + FBattleUnit.UnitID)
                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                BIT MAGIC_IMM_BIT, D                                            ; флаг, тип цели невосприимчив к целевому магическому действию
                JP NZ, .ShowWrongUnit                                           ; переход, если тип цели невосприимчив к заклинанию

                LD DE, (State.Mana)
                LD BC, #0503
                CALL ApplySpell                                                 ; изменить количество цели по силе заклинания
                CALL ResolveLosses                                              ; удалить погибших, обработать бунт и проверить исход боя
                JP SelectActor.ActivateUnit

.CastUnitSpell  LD (Battle.InputLoop.SpellID), A
                CALL ShowSpell                                                  ; показать название и параметры выбранного заклинания
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL PickOccupied                                               ; выбрать клетку, занятую любым отрядом
                JP NZ, SelectActor.ActivateUnit                                 ; переход, если выбор цели заклинания отменён

                PUSH IX
                LD A, (Battle.InputLoop.SpellID)
                CALL Engine.SpellDesc                                           ; получить описатель одного из десяти заклинаний
                LD C, (IX + FSpell.ManaCost.Low)
                LD B, (IX + FSpell.ManaCost.High)
                POP IX
                CALL SpendHeroMagic                                             ; списать магическую силу героя с насыщением нулём
                JP C, SelectActor.ActivateUnit                                  ; переход, если маны на выбранное заклинание не хватает

                LD A, (IX + FBattleUnit.UnitID)
                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                BIT MAGIC_IMM_BIT, D                                            ; флаг, тип цели невосприимчив к целевому магическому действию
                JP NZ, .ShowWrongUnit                                           ; переход, если тип цели невосприимчив к заклинанию

                CALL HasMagicShield                                             ; проверить магический щит стороны выбранной цели
                JP NC, SelectActor.ActivateUnit                                 ; переход, если цель защищена магическим щитом

                LD DE, (State.Mana)
.SpellID        EQU $+2                                                         ; операнд A выбранного заклинания воздействия на отряд
                LD BC, #0003
                CALL ApplySpell                                                 ; изменить количество цели по силе заклинания
                LD HL, Battle.PickOccupied.EffectCodes                          ; четыре начальных кода эффекта для индексов заклинаний0..3
                LD A, (Battle.InputLoop.SpellID)
                LD C, A
                LD B, #00
                ADD HL, BC
                LD A, (HL)
                LD (IX + FBattleUnit.Effect), A
                CALL ResolveLosses                                              ; удалить погибших, обработать бунт и проверить исход боя
                JP SelectActor.ActivateUnit

                ; проверка команды капитуляции и возможности оплатить требуемый выкуп
.TestSurrender  CP #06
                JP NZ, .TestFlyKey                                              ; переход, если не выбрана сдача

                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, State.FloatB
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                JR NC, .DrawRansomMenu                                          ; переход, если денег героя хватает на рассчитанный выкуп

                LD BC, #0602
                LD DE, #051A
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD DE, Battle.PickOccupied.NoRansomText                         ; отказ из-за недостатка денег для выкупа
                LD B, #08
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                CALL RefreshObjects                                             ; сбросить флаги сорока объектов поля и заново отобразить армии
                CALL Engine.StartView                                           ; включить обработку объектов в прерывании
                JP InputLoop

                ; сравнение стоимостей армий и вывод меню с рассчитанным выкупом
.DrawRansomMenu CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD BC, #0603
                LD DE, #0818
                LD A, #46
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                PUSH IX
                PUSH IY
                LD IY, Battle.FinishField.EnemyArmy
                CALL ArmyValue                                                  ; сложить стоимостные оценки отрядов армии
                LD IY, Battle.FinishField.HeroArmy
                CALL ArmyValue                                                  ; сложить стоимостные оценки отрядов армии
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05                                                          ; division, деление, DA2E
                DB #38                                                          ; end-calc, возврат в Z80, DA2F
                POP IY
                POP IX
                LD A, #04
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                JR C, .UseHeroValue                                             ; переход, если отношение стоимости армии противника к армии героя меньше четырёх

                LD DE, Battle.PickOccupied.AllMoneyText                         ; требование отдать все деньги при сдаче
                XOR A
                JR .ChooseRansom

.UseHeroValue   LD HL, State.FloatB
                LD DE, Battle.PickOccupied.RansomAmount                         ; пятибайтная сумма выкупа внутри шаблона сообщения
                LD BC, #0005
                LDIR
                LD DE, Battle.PickOccupied.RansomText                           ; предложение заплатить рассчитанную сумму выкупа
                LD A, #FF
.ChooseRansom   LD (Battle.InputLoop.RansomMode), A
                LD B, #08
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                PUSH IY
                LD IX, Battle.PickOccupied.RansomMenu                           ; меню подтверждения либо отмены сдачи с выкупом
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                PUSH AF
                CALL RefreshObjects                                             ; сбросить флаги сорока объектов поля и заново отобразить армии
                POP AF
                POP IY
                CP #02
                JP Z, SelectActor.ActivateUnit                                  ; переход, если игрок отказался от сдачи

.RansomMode     EQU $+1                                                         ; операнд A, ненулевой выбирает оплату выкупа вместо обнуления денег
                LD A, #00
                OR A
                JR NZ, .PayRansom                                               ; переход, если сдача требует оплаты выкупа

                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                JR .EndWithRansom

.PayRansom      LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, State.FloatB
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                PUSH IY
                PUSH IX
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #03                                                          ; subtract, вычитание, DA92
                DB #38                                                          ; end-calc, возврат в Z80, DA93
                POP IX
                POP IY
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
.EndWithRansom  LD A, (State.MoveFlags)
                RES HERO_SIEGE_BIT, A                                           ; флаг, герой располагает осадным орудием
                LD (State.MoveFlags), A
                LD IY, Battle.FinishField.HeroArmy
                LD DE, #0012
                LD B, #05

                ; удаление неуправляемых отрядов перед сохранением результата капитуляции
.RemoveRebels   LD A, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                OR A
                JR Z, .SaveArmies                                               ; переход, если список отрядов героя завершён

                BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)                   ; +#09, флаг, численность отряда превышает предел управления героя
                JR Z, .NextRebel                                                ; переход, если отряд остаётся под контролем героя

                LD (IY + FBattleUnit.UnitID), #00                               ; +#00, ID типа, 0 завершает плотный список
.NextRebel      ADD IY, DE
                DJNZ .RemoveRebels

.SaveArmies     LD HL, Battle.FinishField.HeroArmy
                CALL CompactArmy                                                ; уплотнить пять записей армии и очистить освободившийся хвост
                LD IX, Battle.FinishField.HeroArmy
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
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                LD A, #FF
                LD DE, (Battle.FinishField.EnemyMana)
                RET

.TestFlyKey     CP #0E
                JP NZ, .ReadCommand                                             ; переход, если не выбрана команда полёта

                LD A, #47
                CALL DrawHeader                                                 ; оформить рамку заголовка боя цветом A
                BIT UNIT_FLY_BIT, (IY + FBattleUnit.Flags)                      ; +#09, флаг, способность к полёту, доступность действия дополнительно зависит от эффекта
                JR NZ, .TestFlyEffect                                           ; переход, если отряд обладает полётом

                LD DE, Battle.PickOccupied.CannotFlyText                        ; сообщение об отсутствии способности полёта
                JP .ShowMessage

.TestFlyEffect  LD A, (IY + FBattleUnit.Effect)                                 ; +#0D, старшая тетрада вид эффекта, младшая оставшаяся длительность
                AND #F0
                CP #20
                JR NZ, .ShowFlyPrompt                                           ; переход, если ослепление не запрещает полёт

                LD DE, Battle.PickOccupied.BlindedFlyText                       ; сообщение об ослеплении, запрещающем полёт
                JP .ShowMessage

.ShowFlyPrompt  LD DE, (Battle.PickOccupied.UnitName)
                LD (Battle.PickOccupied.FlyName), DE
                LD B, #01
                LD DE, Battle.PickOccupied.FlyPromptText                        ; приглашение выбрать новую клетку летающего отряда
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, #13
                CALL MakeStaticUnit                                             ; сформировать неподвижный объект отряда и его отображаемое количество
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4

                ; выбор свободной клетки назначения для полёта действующего отряда
.PickFlyCell    CALL SelectCell                                                 ; перемещать курсор по боевому полю до подтверждения либо отмены
                JP NZ, SelectActor.ActivateUnit                                 ; переход, если выбор клетки полёта отменён

                LD IX, Battle.FinishField.HeroArmy
                CALL FindUnitAtCell                                             ; найти отряд с заданными координатами в одной армии
                JR Z, .PickFlyCell                                              ; переход, если клетка полёта занята отрядом героя

                LD IX, Battle.FinishField.EnemyArmy
                CALL FindUnitAtCell                                             ; найти отряд с заданными координатами в одной армии
                JR Z, .PickFlyCell                                              ; переход, если клетка полёта занята противником

                PUSH BC
                LD C, (IY + FBattleUnit.X)                                      ; +#0A, колонка 0..7
                LD B, (IY + FBattleUnit.Y)                                      ; +#0B, строка 0..4
                CALL DirtyCell                                                  ; пометить экранный объект клетки как пустой для перерисовки
                POP BC
                LD (IY + FBattleUnit.X), C                                      ; +#0A, колонка 0..7
                LD (IY + FBattleUnit.Y), B                                      ; +#0B, строка 0..4
                JP SelectActor.ActivateUnit
