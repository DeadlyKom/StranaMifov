; оверлей 05 из OVR1
; исходный файл каталога 48, смещение #1A79
                module Overlay
                module Treasure
                org #B200

; -----------------------------------------
; получение находки и изменение параметров героя
; Сразу помечает объект находки использованным и снимает bit7 его клетки карты. Уменьшает
; континентальный счётчик находок, затем выбирает награду генератором, а не читает тип приза из
; объекта. Редкие ветви устанавливают в #6A34 флаг полной карты текущего континента либо
; разрешение пути на следующий. Остальные ветви случайно выдают заклинание, увеличивают текущую
; магическую силу, её восстановление или предел, недельный доход, деньги либо 16-битное поле героя
; #6A02 при раздаче находки солдатам. Маску фрагментов карты цели #6A55..#6A59 этот оверлей не
; изменяет.
; In:
;   текущее состояние героя, армии и объекта в ядре
; Out:
;   состояние обновлено выбранной ветвью либо сохранено при отказе
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; -----------------------------------------
Entry           PUSH IX
                CALL Engine.CheckCalls                                          ; проверить неизменность трёх инструкций CALL #6B8D
                CALL Engine.UpdateLocalView                                     ; отметить открытые клетки вокруг героя и подготовить экранные объекты
                EI
                HALT
                POP IX
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                SET ITEM_USED_BIT, (IX + FMapItem.Flags)                        ; флаг, находка использована или выключена из общего обхода
                LD C, (IX + FMapItem.X)
                LD B, (IX + FMapItem.Y)
                CALL Engine.SelectMapBank                                       ; выбрать логический банк 10 с текущей картой
                CALL Engine.MapCellAddress                                      ; вычислить адрес клетки карты
                RES MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты занята объектом
                LD HL, State.ViewObjects + 32 * FScreenObject20                 ; флаги двух групп по пять экранных записей начиная с элемента 32
                LD B, #02
.ResetArmyMarks PUSH BC
                LD B, #05
.ClearArmyMark  LD A, (HL)
                AND #C0
                LD (HL), A
                LD DE, #0014
                ADD HL, DE
                DJNZ .ClearArmyMark

                LD DE, #003C
                ADD HL, DE
                POP BC
                DJNZ .ResetArmyMarks

                LD A, #47
                LD BC, #1000
                LD DE, #061E
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD IY, State.Contract
                LD A, (State.Continent)
                LD C, A
                LD B, #00
                SLA C
                ADD IY, BC
                LD E, (IY + FWord.Low)
                LD D, (IY + FWord.High)
                DEC DE
                LD (IY + FWord.Low), E
                LD (IY + FWord.High), D
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                EX DE, HL
                LD DE, #0005
                OR A
                SBC HL, DE
                JP NC, .RewardTable                                             ; переход, если имеющихся карт достаточно и специальная награда картой не выбирается

                LD DE, #0001
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                BIT GIFT_MAP_BIT, E                                             ; младший разряд случайного результата 0..1, 1 выбирает предложение награды картой текущего континента
                JR Z, .CheckNextLand                                            ; переход, если случайный выбор не предлагает карту текущего континента

                LD A, (State.Continent)
                ADD A, #03
                RLCA
                RLCA
                RLCA
                OR #46
                LD (Entry.TestMapOp), A
                LD HL, State.MapFlags
                BIT MAP_INDEX_BIT, (HL)                                         ; начальный номер бита шаблонов проверки и открытия карт континентов, фактический номер вычисляется из номера континента и переписывается в opcode
.TestMapOp      EQU $ - 1                                                       ; код проверки доступности полной карты текущего континента
                JR NZ, .CheckNextLand                                           ; переход, если карта текущего континента у героя уже есть

                OR #C0
                LD (Entry.OpenMapOp), A
                SET MAP_INDEX_BIT, (HL)                                         ; начальный номер бита шаблонов проверки и открытия карт континентов, фактический номер вычисляется из номера континента и переписывается в opcode
.OpenMapOp      EQU $ - 1                                                       ; код установки доступности полной карты текущего континента
                LD A, (State.Continent)
                LD B, A
                LD HL, Engine.MainLoop.LandNameIndex                            ; смещённая база перед списком имён континентов, поиск начинает с INC HL, первое имя находится по #6992
                XOR A
.FindMapText    INC HL
                CP (HL)
                JR NZ, .FindMapText                                             ; переход, если ещё не найден конец очередного названия континента

                DJNZ .FindMapText

                INC HL
                LD (Entry.MapName), HL
                LD DE, Overlay.Treasure.Entry.FullMapText                       ; сообщение о найденной полной карте континента
                LD B, #12
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                RET

.CheckNextLand  LD A, (State.Continent)
                CP #04
                JR Z, .RewardTable                                              ; переход, если герой на четвёртом континенте и следующего континента нет

                DEC A
                RLCA
                RLCA
                RLCA
                OR #46
                LD (Entry.TestNextOp), A
                LD HL, State.MapFlags
                BIT MAP_INDEX_BIT, (HL)                                         ; начальный номер бита шаблонов проверки и открытия карт континентов, фактический номер вычисляется из номера континента и переписывается в opcode
.TestNextOp     EQU $ - 1                                                       ; код проверки доступности следующего континента
                JR NZ, .RewardTable                                             ; переход, если карта следующего континента у героя уже есть

                OR #C0
                LD (Entry.OpenNextOp), A
                SET MAP_INDEX_BIT, (HL)                                         ; начальный номер бита шаблонов проверки и открытия карт континентов, фактический номер вычисляется из номера континента и переписывается в opcode
.OpenNextOp     EQU $ - 1                                                       ; код открытия следующего континента
                LD A, (State.Continent)
                INC A
                LD B, A
                LD HL, Engine.MainLoop.LandNameIndex                            ; смещённая база перед списком имён континентов, поиск начинает с INC HL, первое имя находится по #6992
                XOR A
.FindLandText   INC HL
                CP (HL)
                JR NZ, .FindLandText                                            ; переход, если ещё не найден конец очередного названия континента

                DJNZ .FindLandText

                INC HL
                LD (Entry.NextLandName), HL
                LD BC, #1501
                LD DE, #011E
                LD A, #46
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #1201
                LD DE, #011E
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD B, #12
                LD DE, Overlay.Treasure.Entry.NextLandText                      ; сообщение о найденном пути к следующему континенту
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                RET

                ; таблица текущего континента задаёт пороги случайного выбора вида награды
.RewardTable    LD IX, Overlay.Treasure.Entry.RewardBands - 12                  ; смещённая база перед наградами, поиск сначала добавляет continent*10 и затем два байта до первого порога
                LD DE, #000A
                LD A, (State.Continent)
                LD B, A
.FindRewards    ADD IX, DE
                DJNZ .FindRewards

                LD DE, #00FE
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD A, E

                ; следующий порог сравнивается со случайным байтом, награда не хранится в
                ; исходной записи находки
.ChooseReward   INC IX
                INC IX
                CP (IX + FRewardBand.Threshold)
                JR NC, .ChooseReward                                            ; переход, если случайный результат достиг следующего порога таблицы наград

                LD A, (IX + FRewardBand.Hundreds)
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD BC, #0064
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #04, #38                                                     ; multiply, умножение, B334
                LD DE, #0004
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD A, E
                OR A
                JP NZ, .ChooseGoldGift                                          ; переход, если случайный выбор направляет к денежной или военной награде

                LD DE, #0046
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD A, E
                OR A
                JR NZ, .CheckManaPrize                                          ; переход, если специальная награда не является заклинанием

                LD DE, #0009
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD HL, State.Spells
                ADD HL, DE
                BIT SPELL_KNOWN_BIT, (HL)                                       ; флаг, заклинание изучено героем
                JP NZ, .ChooseGoldGift                                          ; переход, если случайно выбранное заклинание уже изучено

                PUSH HL
                PUSH DE
                CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD BC, #1201
                LD DE, #011E
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                POP DE
                POP HL
                SET SPELL_KNOWN_BIT, (HL)                                       ; флаг, заклинание изучено героем
                LD A, E
                INC A
                CALL Engine.SpellDesc                                           ; получить описатель одного из десяти заклинаний
                LD (Entry.SpellName), IX
                LD DE, Overlay.Treasure.Entry.SpellText                         ; сообщение об изучении тайны заклинания
.RewardMessage  LD B, #12
.PrintReward    CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                RET

.CheckManaPrize CP #28
                JR NC, .ManaRegenPrize                                          ; переход, если результат выбора относится к восстановлению магии за ход или более высокой награде

                LD A, #0A
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05, #27, #38                                                ; division, деление, B38F
                CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD HL, (State.Mana)
                LD DE, (State.ManaMax)
                ADD HL, BC
                JR C, .ClampMana                                                ; переход, если прибавление магии переполнило 16-битное поле

                PUSH HL
                SBC HL, DE
                POP HL
                JR Z, .StoreMana                                                ; переход, если новая магия точно равна максимальному запасу

                JR C, .StoreMana                                                ; переход, если новая магия меньше максимального запаса

.ClampMana      LD HL, (State.ManaMax)
.StoreMana      LD (State.Mana), HL
                LD DE, Overlay.Treasure.Entry.ManaText                          ; сообщение о восстановлении магических сил
                JR .RewardMessage

.ManaRegenPrize CP #3C
                JR NC, .ManaLimitPrize                                          ; переход, если результат выбора относится к увеличению максимального запаса магии

                LD BC, #1101
                LD DE, #061E
                LD A, #46
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD A, #32
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05, #27, #38                                                ; division, деление, B3C7
                CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD HL, (State.ManaRegen)
                ADD HL, BC
                LD (State.ManaRegen), HL
                LD DE, Overlay.Treasure.Entry.ManaRegenText                     ; сообщение об увеличении скорости восстановления магии
                JR .RewardMessage

.ManaLimitPrize LD BC, #1101
                LD DE, #061E
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD A, #32
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05, #27, #38                                                ; division, деление, B3EA
                CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD HL, (State.ManaMax)
                ADD HL, BC
                JR NC, .StoreManaLimit                                          ; переход, если увеличение максимума магии не вызвало переполнения

                LD HL, #FFFF
.StoreManaLimit LD (State.ManaMax), HL
                LD DE, Overlay.Treasure.Entry.ManaLimitText                     ; сообщение об увеличении предела магических сил
                LD B, #13
                JP .PrintReward

.ChooseGoldGift LD DE, #0006
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD A, E
                CP #02
                JR NC, .ArmyGiftChoice                                          ; переход, если случайный выбор даёт военную награду вместо денег

                LD BC, #000A
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05, #27, #38                                                ; division, деление, B416
                CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD (Entry.IncomeGift), BC
                LD B, #12
                LD DE, Overlay.Treasure.Entry.IncomeText                        ; сообщение об увеличении недельного дохода
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD HL, State.BaseIncome
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, (Entry.IncomeGift)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F, #38                                                     ; addition, сложение, B43B
                LD HL, State.BaseIncome
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                RET

                ; золото можно оставить герою либо передать армии ради увеличения лидерства
.ArmyGiftChoice LD A, (State.Army)
                OR A
                JR Z, .NoArmyGold                                               ; переход, если армия пуста и военную награду применять не к кому

                CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD (Entry.GoldGift), BC
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                LD A, #46
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05, #27, #38                                                ; division, деление, B45A
                CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD (Entry.LeadershipGift), BC
                LD B, #11
                LD DE, Overlay.Treasure.Entry.GoldArmyText                      ; сообщение о выборе между золотом и лидерством армии
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IX, Overlay.Treasure.Entry.GoldArmyMenu                      ; меню выбора денег или увеличения лидерства
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #01
                JR NZ, .AddLeadership                                           ; переход, если игрок предпочёл увеличение лидерства

.TakeGold       LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, (Entry.GoldGift)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F, #38                                                     ; addition, сложение, B485
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                RET

.AddLeadership  LD BC, (Entry.LeadershipGift)
                LD HL, (State.Leadership)
                ADD HL, BC
                JR NC, .SetLeadership                                           ; переход, если прибавление лидерства не вызвало переполнения

                LD HL, #FFFF
.SetLeadership  LD (State.Leadership), HL
                RET

.NoArmyGold     CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD (Entry.NoArmyGift), BC
                LD (Entry.GoldGift), BC
                LD B, #12
                LD DE, Overlay.Treasure.Entry.GoldOnlyText                      ; сообщение о денежной находке при отсутствии армии
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JR .TakeGold

.SpellText      EQU $                                                           ; сообщение об изучении тайны заклинания
                DB #0E
.SpellName      DW #0000                                                        ; адрес имени найденного заклинания
                DB #0D, #2A, #0D, #00, #82, #EB, #20, #AF
                DB #AE, #A7, #AD, #A0, #AB, #A8, #20, #E2
                DB #A0, #A9, #AD, #E3, #0D, #2A, #ED, #E2
                DB #AE, #A3, #AE, #20, #AC, #A0, #A3, #A8
                DB #E7, #A5, #E1, #AA, #AE, #A3, #AE, #20
                DB #A7, #A0, #AA, #AB, #A8, #AD, #A0, #AD
.ManaText       EQU $+7                                                         ; сообщение о восстановлении магических сил
                DB #A8, #EF, #20, #21, #0D, #2A, #00, #82
                DB #EB, #20, #AD, #A0, #E8, #AB, #A8, #20
                DB #A2, #AE, #AB, #E8, #A5, #A1, #AD, #AE
                DB #A5, #20, #E1, #AD, #A0, #A4, #AE, #A1
                DB #EC, #A5, #2C, #0D, #2A, #A1, #AB, #A0
                DB #A3, #AE, #A4, #A0, #E0, #EF, #20, #AA
                DB #AE, #E2, #AE, #E0, #AE, #AC, #E3, #0D
                DB #2A, #A2, #A0, #E8, #A8, #20, #AC, #A0
                DB #A3, #A8, #E7, #A5, #E1, #AA, #A8, #A5
                DB #20, #E1, #A8, #AB, #EB, #20, #A2, #AE
                DB #A7, #E0, #AE, #E1, #AB, #A8, #2E, #0D
.ManaRegenText  EQU $+2                                                         ; сообщение об увеличении скорости восстановления магии
                DB #2A, #00, #82, #EB, #20, #AD, #A0, #E8
                DB #AB, #A8, #20, #A2, #AE, #AB, #E8, #A5
                DB #A1, #AD, #E3, #EE, #20, #AA, #AD, #A8
                DB #A3, #E3, #0D, #2A, #A1, #AB, #A0, #A3
                DB #AE, #A4, #A0, #E0, #EF, #20, #AA, #AE
                DB #E2, #AE, #E0, #AE, #A9, #20, #A2, #AE
                DB #A7, #E0, #AE, #E1, #AB, #A0, #0D, #2A
                DB #E1, #AA, #AE, #E0, #AE, #E1, #E2, #EC
                DB #20, #A2, #AE, #E1, #E1, #E2, #A0, #AD
                DB #AE, #A2, #AB, #A5, #AD, #A8, #EF, #20
                DB #A2, #A0, #E8, #A8, #E5, #0D, #2A, #AC
                DB #A0, #A3, #A8, #E7, #A5, #E1, #AA, #A8
                DB #E5, #20, #E1, #A8, #AB, #2E, #0D, #2A
.ManaLimitText  EQU $+1                                                         ; сообщение об увеличении предела магических сил
                DB #00, #8F, #E0, #A5, #A4, #A5, #AB, #EB
                DB #20, #A2, #A0, #E8, #A5, #A9, #20, #AC
                DB #A0, #A3, #A8, #E7, #A5, #E1, #AA, #AE
                DB #A9, #0D, #2A, #AC, #AE, #E9, #A8, #20
                DB #E3, #A2, #A5, #AB, #A8, #E7, #A8, #AB
.NextLandText   EQU $+7                                                         ; сообщение о найденном пути к следующему континенту
                DB #A8, #E1, #EC, #2E, #0D, #2A, #00, #82
                DB #A0, #AC, #20, #E1, #AA, #A0, #A7, #AE
                DB #E7, #AD, #AE, #20, #AF, #AE, #A2, #A5
                DB #A7, #AB, #AE, #20, #21, #0D, #2A, #82
                DB #EB, #20, #AD, #A0, #E8, #AB, #A8, #20
                DB #AA, #A0, #E0, #E2, #E3, #2C, #20, #AA
                DB #AE, #E2, #AE, #E0, #A0, #EF, #20, #AF
                DB #AE, #AC, #AE, #A6, #A5, #E2, #20, #A2
                DB #A0, #AC, #0D, #2A, #AD, #A0, #A9, #E2
                DB #A8, #20, #AF, #E3, #E2, #EC, #20, #AD
                DB #A0, #20, #AA, #AE, #AD, #E2, #A8, #AD
                DB #A5, #AD, #E2, #20, #A8, #AC, #A5, #AD
                DB #E3, #A5, #AC, #EB, #A9, #0D, #2A, #0E
.NextLandName   DW #0000                                                        ; адрес названия открываемого континента
.FullMapText    EQU $+3                                                         ; сообщение о найденной полной карте континента
                DB #0D, #2A, #00, #94, #AE, #E0, #E2, #E3
                DB #AD, #A0, #20, #A2, #AD, #AE, #A2, #EC
                DB #20, #E3, #AB, #EB, #A1, #AD, #E3, #AB
                DB #A0, #E1, #EC, #20, #A2, #A0, #AC, #20
                DB #21, #0D, #2A, #92, #A5, #AF, #A5, #E0
                DB #EC, #20, #E3, #20, #A2, #A0, #E1, #20
                DB #A5, #E1, #E2, #EC, #20, #AF, #AE, #AB
                DB #AD, #A0, #EF, #20, #AA, #A0, #E0, #E2
                DB #A0, #0D, #2A, #AA, #AE, #AD, #E2, #A8
                DB #AD, #A5, #AD, #E2, #A0, #20, #0E
.MapName        DW #0000                                                        ; адрес названия континента полученной полной карты
.RewardBands    EQU $+3                                                         ; четыре группы по пять FRewardBand, для каждого континента один набор порогов и сотен награды
                DB #0D, #2A, #00, #50, #02, #96, #03, #C8
                DB #04, #E6, #05, #FF, #07, #3C, #02, #78
                DB #03, #AA, #04, #E6, #05, #FF, #07, #28
                DB #02, #5A, #03, #8C, #04, #BE, #05, #FF
                DB #07, #32, #04, #5A, #05, #BE, #06, #DC
.IncomeText     EQU $+3                                                         ; сообщение об увеличении недельного дохода
                DB #09, #FF, #0A, #8A, #AE, #AC, #A8, #E1
                DB #E1, #A8, #AE, #AD, #AD, #EB, #A5, #2C
                DB #20, #AA, #AE, #E2, #AE, #E0, #EB, #A5
                DB #20, #A2, #EB, #0D, #2A, #AF, #AE, #AB
                DB #E3, #E7, #A0, #A5, #E2, #A5, #20, #A7
                DB #A0, #20, #AD, #A5, #A4, #A5, #AB, #EE
                DB #0D, #2A, #E3, #A2, #A5, #AB, #A8, #E7
                DB #A8, #A2, #A0, #A5, #E2, #E1, #EF, #20
                DB #AD, #A0, #20, #0F
.IncomeGift     DW #0000                                                        ; прибавка недельного дохода
                DB #00, #AC, #AE, #AD, #A5, #E2, #2E, #0D
.GoldArmyText   EQU $+2                                                         ; сообщение о выборе между золотом и лидерством армии
                DB #2A, #00, #82, #EB, #20, #AD, #A0, #E8
                DB #AB, #A8, #20, #A7, #AE, #AB, #AE, #E2
                DB #A8, #E8, #AA, #AE, #20, #A8, #20, #E0
                DB #A0, #A7, #AD, #EB, #A5, #0D, #2A, #AF
                DB #AE, #A1, #E0, #EF, #AA, #E3, #E8, #AA
                DB #A8, #2E, #0D, #2A, #8E, #AD, #A8, #20
                DB #AE, #E6, #A5, #AD, #A8, #A2, #A0, #EE
                DB #E2, #E1, #EF, #20, #A2, #20, #0F
.GoldGift       DW #0000                                                        ; денежная награда за находку
                DB #00, #AC, #AE, #AD, #A5, #E2, #2E, #0D
                DB #2A, #0D, #00, #87, #A0, #A1, #E0, #A0
                DB #E2, #EC, #20, #A1, #A0, #E0, #A0, #E5
                DB #AB, #A8, #E8, #AA, #AE, #20, #E1, #A5
                DB #A1, #A5, #2E, #0D, #02, #90, #A0, #A7
                DB #A4, #A0, #E2, #EC, #20, #A5, #A3, #AE
                DB #20, #E1, #AE, #AB, #A4, #A0, #E2, #A0
                DB #AC, #2E, #0D, #02, #00
.LeadershipGift DW #0000                                                        ; прибавка лидерства при раздаче находки армии
.GoldOnlyText   EQU $                                                           ; сообщение о денежной находке при отсутствии армии
                DB #82, #A0, #AC, #20, #AF, #AE, #A2, #A5
                DB #A7, #AB, #AE, #2C, #20, #A2, #EB, #20
                DB #AD, #A0, #E8, #AB, #A8, #20, #AD, #A5
                DB #AC, #AD, #AE, #A3, #AE, #0D, #2A, #A7
                DB #AE, #AB, #AE, #E2, #A8, #E8, #AA, #A0
                DB #20, #A8, #20, #E0, #A0, #A7, #AD, #EB
                DB #E5, #20, #AF, #AE, #A1, #E0, #EF, #AA
                DB #E3, #E8, #A5, #AA, #2E, #0D, #2A, #8E
                DB #AD, #A8, #20, #AE, #E6, #A5, #AD, #A8
                DB #A2, #A0, #EE, #E2, #E1, #EF, #20, #A2
                DB #0D, #2A, #0F
.NoArmyGift     DW #0000                                                        ; денежная награда для сообщения при пустой армии
                DB #00, #AC, #AE, #AD, #A5, #E2, #2E, #0D
.GoldArmyMenu   EQU $+2                                                         ; меню выбора денег или увеличения лидерства
                DB #2A, #00, #02, #00, #80, #ED, #BF, #14
                DB #B4, #01, #15, #1F, #16, #01, #16, #1F
                DB #17, #6F, #76, #65, #72, #6C, #61, #79

                assert $ = #B7FA
                endmodule
                endmodule
