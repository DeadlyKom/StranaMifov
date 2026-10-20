; оверлей 07 из OVR1
; исходный файл каталога 48, смещение #21C9
                module Overlay
                module Bandits
                org #B200

; -----------------------------------------
; бой с разбойниками либо пиратами
; Разновидность «разбойники/пираты» выбирает по bit5 первого байта записи объекта (IX-3 после
; сдвига к данным), а не по режиму перемещения героя. Выводит до пяти отрядов противника,
; предлагает бой и вызывает банк 3,#D255. При A=0 выполняет ветвь денежной награды, добавляет
; сумму к #6A14, вызывает увеличение поля героя #8A08, помечает объект использованным и снимает
; bit7 карты. При A!=0 вызывает #89E0 для уменьшения поля #6A02, ставит bit3 в объекте и пытается
; перенести героя в соседнюю незанятую клетку с совместимым классом суша/вода, затем возвращается.
; Явного перехода к общей обработке гибели в этой ветви оверлея нет.
; In:
;   текущее состояние героя, армии и объекта в ядре
; Out:
;   состояние обновлено выбранной ветвью либо сохранено при отказе
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; -----------------------------------------
Entry           INC IX
                INC IX
                INC IX
                LD (Entry.ArmyPtr), IX
                LD A, (State.MoveFlags)
                SET HERO_HIDE_BIT, A                                            ; флаг, пропустить подготовку изображения героя в локальном окне
                LD (State.MoveFlags), A
                CALL Engine.UpdateLocalView                                     ; отметить открытые клетки вокруг героя и подготовить экранные объекты
                HALT
                LD A, (State.MoveFlags)
                RES HERO_HIDE_BIT, A                                            ; флаг, пропустить подготовку изображения героя в локальном окне
                LD (State.MoveFlags), A
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                LD A, #01
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (Entry.ArmyPtr)
                BIT ARMY_WATER_BIT, (IX + FMapArmy.Flags - 3)                   ; -#03, состояние внешней армии
                LD DE, Overlay.Bandits.Entry.PiratesName                        ; название нападающих пираты
                JR NZ, .DrawEnemyArmy                                           ; переход, если внешняя армия отмечена как пиратская

                LD DE, Overlay.Bandits.Entry.BanditsName                        ; название нападающих разбойники
.DrawEnemyArmy  LD (Entry.EnemyName), DE
                LD BC, #1000
                LD DE, #061E
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #1519
                LD DE, #0106
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #1619
                LD DE, #0106
                LD A, #41
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD B, #11
                LD DE, Overlay.Bandits.Entry.AttackText                         ; формат сообщения о нападающем отряде
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IY, (Entry.ArmyPtr)
                LD DE, #0004
                ADD IY, DE
                LD BC, #1202
                LD A, #05
                CALL Engine.PrintArmyBrief                                      ; вывести краткий список состава армии
                LD B, #15
                LD DE, Engine.NeedMoreMoney.AttackText                          ; общие надписи Атакую и Отхожу перед сражением
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IX, Engine.NeedMoreMoney.AttackMenu                          ; общий описатель выбора Атакую или Отхожу
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #02
                JP Z, .FinishMove                                               ; переход, если игрок отказался от боя

                LD IX, (Entry.ArmyPtr)
                LD C, (IX + FMapArmy.X - 3)                                     ; -#02, столбец стратегической карты
                LD B, (IX + FMapArmy.Y - 3)                                     ; -#01, строка стратегической карты
                CALL Engine.ReadMapCell                                         ; прочитать байт клетки текущей карты
                AND #3F
                CALL Engine.TerrainBattle                                       ; преобразовать местность по второй таблице порогов
                LD E, (IX + FMapArmy.Mana.Low - 3)                              ; +#00, младший байт, текущий запас магической силы внешней армии. Восстанавливается с пределом 15000 и передаётся словом DE в бой
                LD D, (IX + FMapArmy.Mana.High - 3)                             ; +#01, старший байт, текущий запас магической силы внешней армии. Восстанавливается с пределом 15000 и передаётся словом DE в бой
                INC IX
                INC IX
                INC IX
                INC IX
                LD BC, #0501
                PUSH AF
                LD A, #03
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                POP AF
                CALL Battle.Battle                                              ; выполнить бой на поле 8 на 5 клеток
                PUSH AF
                LD A, #01
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (Entry.ArmyPtr)
                LD (IX + FMapArmy.Mana.Low - FMapArmy.Mana), E
                LD (IX + FMapArmy.Mana.High - FMapArmy.Mana), D
                POP AF
                OR A
                JR Z, .VictoryGold                                              ; переход, если бой завершился победой героя

                CALL Engine.LoseLeadership                                      ; уменьшить 16 битное поле героя #6A02 с насыщением 0
                LD A, #08
                OR (IX + FMapArmy.Flags - FMapArmy.Mana)
                LD (IX + FMapArmy.Flags - FMapArmy.Mana), A
                LD BC, (State.Position)
                CALL Engine.ReadMapCell                                         ; прочитать байт клетки текущей карты
                CALL Engine.TerrainBattle                                       ; преобразовать местность по второй таблице порогов
                LD (Entry.RetreatTerrain), A

                ; после поражения подбирается соседняя клетка с подходящим классом суши или воды
.RetreatCell    LD BC, (State.Position)
                LD DE, #0002
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD A, B
                DEC A
                ADD A, E
                LD B, A
                LD DE, #0002
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD A, C
                DEC A
                ADD A, E
                LD C, A
                CALL Engine.ReadMapCell                                         ; прочитать байт клетки текущей карты
                BIT MAP_BUSY_BIT, A                                             ; флаг, клетка стратегической карты занята объектом
                JR NZ, .RetreatCell                                             ; переход, если случайная клетка отступления занята объектом

                LD A, #00
.RetreatTerrain EQU $ - 1                                                       ; операнд класса местности исходной клетки боя
                CP #06
                JR NZ, .CheckRetreat                                            ; переход, если исходное поле боя относится к суше, а не к воде

                CALL Engine.ReadMapCell                                         ; прочитать байт клетки текущей карты
                CALL Engine.TerrainBattle                                       ; преобразовать местность по второй таблице порогов
                CP #06
                JR NZ, .RetreatCell                                             ; переход, если отступающий с воды герой выбрал клетку суши

                JR .StoreRetreat

.CheckRetreat   CALL Engine.ReadMapCell                                         ; прочитать байт клетки текущей карты
                CALL Engine.TerrainBattle                                       ; преобразовать местность по второй таблице порогов
                CP #06
                JR Z, .RetreatCell                                              ; переход, если отступающий по суше герой выбрал клетку воды

.StoreRetreat   LD (State.Position), BC
                RET

                ; денежная награда и отметка использованного объекта выполняются только после победы
.VictoryGold    LD HL, State.FloatA
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, (State.Position)
                CALL Engine.ReadMapCell                                         ; прочитать байт клетки текущей карты
                CALL Engine.TerrainBattle                                       ; преобразовать местность по второй таблице порогов
                CP #06
                JR NZ, .StoreReward                                             ; переход, если победа одержана на суше и водная надбавка к награде не нужна

                LD A, #03
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD A, #02
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05, #04, #27, #38                                           ; division, деление, B340
.StoreReward    LD HL, Overlay.Bandits.Entry.RewardMoney                        ; пятибайтная вычисленная награда за разгром нападающих
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD IX, (Entry.ArmyPtr)
                LD HL, Overlay.Bandits.Entry.BanditsReward                      ; родительный падеж разбойников в сообщении о награде
                BIT ARMY_WATER_BIT, (IX + FMapArmy.Flags - FMapArmy.Mana)       ; флаг, подвижная внешняя армия относится к водному классу пиратов
                JR Z, .RewardMessage                                            ; переход, если побеждённая армия не отмечена как пиратская

                LD HL, Overlay.Bandits.Entry.PiratesReward                      ; родительный падеж пиратов в сообщении о награде
.RewardMessage  LD (Entry.RewardName), HL
                LD BC, #0603
                LD DE, #0818
                LD A, #46
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #0804
                LD DE, #0118
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD B, #08
                LD DE, Overlay.Bandits.Entry.VictoryText                        ; сообщение о победе над нападающими и награде
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #3C
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Overlay.Bandits.Entry.RewardMoney                        ; пятибайтная вычисленная награда за разгром нападающих
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F, #38                                                     ; addition, сложение, B38D
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                CALL Engine.GainLeadership                                      ; увеличить 16 битное поле героя #6A02 с насыщением #FFFF
                LD IX, (Entry.ArmyPtr)
                SET ARMY_FREE_BIT, (IX + FMapArmy.Flags - FMapArmy.Mana)        ; флаг, запись внешней армии свободна или выключена из обработки
                LD C, (IX + FMapArmy.X - FMapArmy.Mana)
                LD B, (IX + FMapArmy.Y - FMapArmy.Mana)
                CALL Engine.SelectMapBank                                       ; выбрать логический банк 10 с текущей картой
                CALL Engine.MapCellAddress                                      ; вычислить адрес клетки карты
                RES MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты занята объектом
                RET

.FinishMove     CALL Engine.MoveToTarget                                        ; преобразовать направление к цели в команду движения героя
                RET

.ArmyPtr        DW #0000                                                        ; адрес поля Mana встреченной внешней армии
.AttackText     EQU $                                                           ; формат сообщения о нападающем отряде
                DB #8D, #A0, #20, #A2, #A0, #E1, #20, #AD
                DB #A0, #AF, #A0, #AB, #A8, #20, #0E
.EnemyName      DW #0000                                                        ; адрес подписи бандитов либо пиратов
.BanditsName    EQU $+3                                                         ; название нападающих разбойники
                DB #0D, #2A, #00, #E0, #A0, #A7, #A1, #AE
.PiratesName    EQU $+6                                                         ; название нападающих пираты
                DB #A9, #AD, #A8, #AA, #A8, #00, #AF, #A8
.VictoryText    EQU $+5                                                         ; сообщение о победе над нападающими и награде
                DB #E0, #A0, #E2, #EB, #00, #8F, #AE, #A1
                DB #A5, #A4, #A0, #20, #21, #0D, #2A, #0D
                DB #00, #87, #A0, #20, #E2, #AE, #2C, #20
                DB #E7, #E2, #AE, #20, #A2, #EB, #20, #E0
                DB #A0, #A7, #A3, #E0, #AE, #AC, #A8, #AB
                DB #A8, #0D, #2A, #ED, #E2, #A8, #E5, #20
                DB #0E
.RewardName     DW #0000                                                        ; адрес названия побеждённой армии для сообщения о награде
                DB #20, #A2, #EB, #20, #AF, #AE, #AB, #E3
                DB #E7, #A0, #A5, #E2, #A5, #0D, #2A, #AF
                DB #E0, #A5, #AC, #A8, #EE, #20, #A2, #20
                DB #E0, #A0, #A7, #AC, #A5, #E0, #A5, #0D
.RewardMoney    EQU $+2                                                         ; пятибайтная вычисленная награда за разгром нападающих
                DB #2A, #10, #00, #00, #00, #00, #00, #00
                DB #20, #AC, #AE, #AD, #A5, #E2, #2E, #0D
.BanditsReward  EQU $+2                                                         ; родительный падеж разбойников в сообщении о награде
                DB #2A, #00, #E0, #A0, #A7, #A1, #AE, #A9
.PiratesReward  EQU $+6                                                         ; родительный падеж пиратов в сообщении о награде
                DB #AD, #A8, #AA, #AE, #A2, #00, #AF, #A8
                DB #E0, #A0, #E2, #AE, #A2, #00, #6F, #76
                DB #65, #72, #6C, #61, #79

                assert $ = #B456
                endmodule
                endmodule
