
; -----------------------------------------
; создание четырёх континентальных групп случайных шестибайтовых отрядов
; В четырёх 4-байтовых дескрипторах берёт число записей избайта+2. Для каждой через #78B9 выбирает
; внутренние координаты, #78A4 требует клетку с бит 7=0 и младшими 6 бит=0 и помечает её бит 7. В
; банк 0 пишет флаги 0 и координаты. В банк 3 по 50-байтовой таблице #CD3E+50*континент выбирает
; ID по порогу случайного байта. В описателе SOLDIERS по #C6D6+42*ID проверяет +#12 на совпадение
; с входным A, неподходящий ID перевыбирает. ID и слово+#20/+#21 копирует в поля+3 и+4/+5 записи.
; Размер шага приёмника задаёт исходный DE, реальные вызовы передают 6.
; In:
;   A — категория 1..4, HL — четыре дескриптора, IX — приёмник банк 0, DE — шаг
; Out:
;   созданы все записи четырёх групп, IX после последней
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; Note:
;   карты, банк 0 записи, счётчик #6CD7, операнды #787D/#7895
; -----------------------------------------
CreateWanderers LD (Startup.CreateWanderers.SpawnClass), A
                LD (Startup.CreateWanderers.RecordSize), DE
                XOR A
                LD (Startup.PromptGameDisk.WorkContinent), A
                LD B, #04
.ContinentLoop  PUSH BC
                LD A, (Startup.PromptGameDisk.WorkContinent)
                INC A
                LD (Startup.PromptGameDisk.WorkContinent), A
                INC HL
                INC HL
                LD B, (HL)
                INC HL
                INC HL
                PUSH HL
.UnitLoop       PUSH BC

                ; выбор внутренней свободной клетки континента, занятые и непустые клетки отклоняются
.FindFreeCell   CALL RandomMapPos                                               ; выбор случайных внутренних координат стратегической карты
                LD A, (Startup.PromptGameDisk.WorkContinent)
                CALL MapCellAddress                                             ; адрес клетки карты выбранного континента при создании игры
                BIT MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты уже занята объектом при генерации
                JR NZ, .FindFreeCell                                            ; переход, если клетка уже занята объектом

                LD A, (HL)
                AND #3F
                JR NZ, .FindFreeCell                                            ; переход, если клетка содержит неподходящий тип местности

                SET MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты уже занята объектом при генерации
                XOR A
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                LD (IX + FMapTroop.Flags), #00
                LD (IX + FMapTroop.X), C
                LD (IX + FMapTroop.Y), B
                LD A, #03
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
.PickUnitType   LD DE, #00FE
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                LD IY, StartupTables.RoamWeights - 26 * FWeightedType           ; смещённая база типов, до первого континента и первой записи пары
                LD A, (Startup.PromptGameDisk.WorkContinent)
                LD BC, #0032
.TypeTable      ADD IY, BC
                DEC A
                JR NZ, .TypeTable                                               ; переход, если ещё не достигнута таблица выбранного континента

                LD A, E

                ; выбор типа отряда по накопленным границам весовой таблицы
.WeightedType   INC IY
                INC IY
                CP (IY + FWeightedType.Threshold)
                JR NC, .WeightedType                                            ; переход, если случайный отсчёт вышел за накопленный вес варианта

                LD B, (IY + FWeightedType.UnitID)
                LD L, B
                LD IY, UnitTypes.Peasants - FSoldier                            ; база описателей SOLDIERS до ID1, после выбора каждый ID добавляет42байта
                LD DE, #002A
.UnitDescriptor ADD IY, DE
                DJNZ .UnitDescriptor

                LD A, (IY + FSoldier.SpawnClass)
.SpawnClass     EQU $+1                                                         ; операнд CP требуемого класса появления FSoldier.SpawnClass
                CP #01
                JR NZ, .PickUnitType                                            ; переход, если тип отряда не допускает появления в этой группе

                LD C, (IY + FSoldier.SpawnCount.Low)
                LD B, (IY + FSoldier.SpawnCount.High)
                XOR A
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                LD (IX + FMapTroop.ID), L
                LD (IX + FMapTroop.Count.Low), C
                LD (IX + FMapTroop.Count.High), B
                POP BC
.RecordSize     EQU $+1                                                         ; операнд DE шага дескриптора группы
                LD DE, #0006
                ADD IX, DE
                DEC B
                JP NZ, .UnitLoop                                                ; переход, если ещё не созданы все отряды континента

                POP HL
                POP BC
                DEC B
                JP NZ, .ContinentLoop                                           ; переход, если ещё не обработаны все континенты

                RET
