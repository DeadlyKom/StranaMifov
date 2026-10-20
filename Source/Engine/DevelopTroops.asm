
; -----------------------------------------
; повышать либо понижать типы отрядов по счётчикам
; при бите 7 #6565 выходит, иначе увеличивает счётчики #6A72+ID, для пяти записей армии сравнивает
; второй счётчик+25 с полем 40 описателя и основной счётчик с полем 41, поля 19/20 задают новый
; ID, исходная запись обнуляется, количество переносится #A056, показываются разные сообщения о
; долгих странствиях/битвах либо отсутствии сражений
; In:
;   флаг бит 7#6565, армия #6A1E, счётчики #6A72/#6A8B, описатели типов
; Out:
;   если бит 7 сброшен, счётчики возрастают и достигшие порогов отряды заменяют ID с переносом
;   количества, показываются сообщения развития/деградации
; Corrupt:
;   HL, DE, BC, AF, IX, IY, счётчики, состав армии и экран, альтернативные HL', DE', BC', AF'
;   могут изменяться вызываемым калькулятором ROM и здесь не сохраняются
; -----------------------------------------
DevelopTroops   LD A, (State.EventFlags)
                BIT EVENT_LOCK_BIT, A                                           ; временно запрещает развитие отрядов, нападения на замок и магическое вмешательство
                RET NZ                                                          ; выход, если развитие отрядов временно запрещено режимом события

                LD HL, State.Army
                LD B, #05

                ; накопление отметок участия по типам отрядов
.FlagUnits      LD A, (HL)
                OR A
                JR Z, .StartArmy                                                ; переход, если достигнут конец армии при подсчёте участвующих типов

                CALL IndexFlagArray                                             ; получить указатель IX=#6A72+A
                INC (IX + #00)
                INC HL
                INC HL
                INC HL
                DJNZ .FlagUnits

.StartArmy      LD HL, State.Army
                LD B, #05

                ; проверка замены каждого отряда после изменения квалификации
.UnitLoop       LD A, (HL)
                OR A
                RET Z                                                           ; выход, если достигнут конец армии при проверке развития

                PUSH HL
                PUSH BC
                CALL IndexFlagArray                                             ; получить указатель IX=#6A72+A
                PUSH IX
                POP IY
                CALL UnitDesc                                                   ; получить описатель типа отряда
                LD A, (IX + FSoldier.UpgradeID)
                OR A
                JR Z, .CheckDegrade                                             ; переход, если для типа не задано повышение

                LD A, (IY + State.UpgradeIndex - State.IdleIndex)
                CP (IX + FSoldier.UpgradeLimit)
                JR C, .CheckDegrade                                             ; переход, если накопленная квалификация ещё ниже порога повышения

                LD A, (HL)
                PUSH AF
                LD (HL), #00
                INC HL
                LD C, (HL)
                LD (HL), #00
                INC HL
                LD B, (HL)
                LD (HL), #00
                LD A, (IX + FSoldier.UpgradeID)
                CALL AddTroops                                                  ; добавить количество BC к типу отряда A в армии героя
                LD A, (IX + FSoldier.UpgradeID)
                CALL FormatUnitName                                             ; сформировать имя типа отряда со специальным окончанием
                LD HL, Engine.FormatUnitName.NameBuffer                         ; буфер имени типа существа с выбранным окончанием
                LD DE, Engine.DevelopTroops.NewTypeName                         ; буфер имени типа после замены при развитии
                LD BC, #000F
                LDIR
                POP AF
                CALL FormatUnitName                                             ; сформировать имя типа отряда со специальным окончанием
                CALL StopView                                                   ; выключить обработку объектов в прерывании
                LD BC, #0501
                LD DE, #0910
                LD A, #47
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #0B02
                LD DE, #0110
                LD A, #44
                CALL FillAttributes                                             ; заполнить прямоугольник атрибутов цветом A
                LD BC, #0D02
                LD DE, #0110
                LD A, #44
                CALL FillAttributes                                             ; заполнить прямоугольник атрибутов цветом A
                LD B, #07
                LD DE, Engine.DevelopTroops.UpgradeText                         ; сообщение о повышении типа за странствия и битвы
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                JR .RefreshView

                ; проверка понижения типа при отсутствии достаточной квалификации
.CheckDegrade   LD A, (IX + FSoldier.DegradeID)
                OR A
                JR Z, .NextUnit                                                 ; переход, если для типа не задано понижение

                LD A, (IY + #00)
                CP (IX + FSoldier.DegradeDays)
                JR C, .NextUnit                                                 ; переход, если число дней без сражений ещё меньше порога понижения

                LD A, (HL)
                PUSH AF
                LD (HL), #00
                INC HL
                LD C, (HL)
                LD (HL), #00
                INC HL
                LD B, (HL)
                LD (HL), #00
                LD A, (IX + FSoldier.DegradeID)
                CALL AddTroops                                                  ; добавить количество BC к типу отряда A в армии героя
                LD A, (IX + FSoldier.DegradeID)
                CALL FormatUnitName                                             ; сформировать имя типа отряда со специальным окончанием
                LD HL, Engine.FormatUnitName.NameBuffer                         ; буфер имени типа существа с выбранным окончанием
                LD DE, Engine.DevelopTroops.NewTypeName                         ; буфер имени типа после замены при развитии
                LD BC, #000F
                LDIR
                POP AF
                CALL FormatUnitName                                             ; сформировать имя типа отряда со специальным окончанием
                CALL StopView                                                   ; выключить обработку объектов в прерывании
                LD BC, #0501
                LD DE, #0810
                LD A, #42
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #0A02
                LD DE, #0110
                LD A, #41
                CALL FillAttributes                                             ; заполнить прямоугольник атрибутов цветом A
                LD BC, #0C02
                LD DE, #0110
                LD A, #41
                CALL FillAttributes                                             ; заполнить прямоугольник атрибутов цветом A
                LD B, #07
                LD DE, Engine.DevelopTroops.DegradeText                         ; сообщение о понижении типа из-за отсутствия сражений
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
.RefreshView    LD B, #14
                CALL WaitOrInput                                                ; выдержать паузу с досрочным выходом по вводу
                CALL RefreshHero                                                ; обновить боковую панель героя, расходы и рейтинг
                CALL UpdateLocalView                                            ; отметить открытые клетки вокруг героя и подготовить экранные объекты
                HALT
.NextUnit       POP BC
                POP HL
                INC HL
                INC HL
                INC HL
                DEC B
                JP NZ, .UnitLoop                                                ; переход, если остались отряды для проверки развития

                RET

.UpgradeText    EQU $                                                           ; сообщение о повышении типа за странствия и битвы
                DB #11, #02, #16, #84, #AE, #AB, #A3, #A8
                DB #A5, #20, #E1, #E2, #E0, #A0, #AD, #E1
                DB #E2, #A2, #A8, #EF, #0D, #2A, #A8, #0D
                DB #2A, #E7, #A0, #E1, #E2, #EB, #A5, #20
                DB #A1, #A8, #E2, #A2, #EB, #0D, #2A, #AF
                DB #E0, #A5, #A2, #E0, #A0, #E2, #A8, #AB
                DB #A8, #0D, #2A, #0E, #E9, #7E, #0D, #2A
                DB #A2, #0D, #2A, #0E, #47, #A0, #0D, #2A
.DegradeText    EQU $+1                                                         ; сообщение о понижении типа из-за отсутствия сражений
                DB #00, #11, #02, #16, #8E, #E2, #E1, #E3
                DB #E2, #E1, #E2, #A2, #A8, #A5, #0D, #2A
                DB #E1, #E0, #A0, #A6, #A5, #AD, #A8, #A9
                DB #20, #AF, #E0, #A5, #A2, #E0, #A0, #E2
                DB #A8, #AB, #AE, #0D, #2A, #0D, #00, #0E
                DB #E9, #7E, #0D, #2A, #A2, #0D, #2A, #0E
.NewTypeName    EQU $+5                                                         ; буфер имени типа после замены при развитии
                DB #47, #A0, #0D, #2A, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00
