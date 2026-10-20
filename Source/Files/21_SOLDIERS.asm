; исходные данные с полями структур, размеры и размещение сохранены
                module UnitTypes
                org #C700

Peasants        ; FSoldier, исходная запись
.Name           DB #8F, #E0, #AE, #E1, #E2, #AE, #AB, #EE                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #A4, #A8, #AD, #EB                                           ; продолжение поля Name
                assert .Name - Peasants = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Peasants = FSoldier.NameEnd
.MoveFlags      DB #58                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Peasants = FSoldier.MoveFlags
.ExtraFlags     DB #00                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Peasants = FSoldier.ExtraFlags
.Actions        DB #01                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Peasants = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Peasants = FSoldier.ActionStock
.SectID         DB #00                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Peasants = FSoldier.SectID
.SpawnClass     DB #00                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Peasants = FSoldier.SpawnClass
.UpgradeID      DB UnitID.Soldiers                                              ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Peasants = FSoldier.UpgradeID
.DegradeID      DB UnitID.None                                                  ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Peasants = FSoldier.DegradeID
.SpecialFlags   DB #00                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Peasants = FSoldier.SpecialFlags
.UnitValue      DW #001E                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Peasants = FSoldier.UnitValue
.Upkeep         DW #0001                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Peasants = FSoldier.Upkeep
.BattleValue    DW #000F                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Peasants = FSoldier.BattleValue
.Unknown1C      DB #0A, #00, #14, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Peasants = FSoldier.Unknown1C
.SpawnCount     DW #0000                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Peasants = FSoldier.SpawnCount
.DamageSpread   DW #000F                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Peasants = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Peasants = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #00                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Peasants = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #00                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Peasants = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #03                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Peasants = FSoldier.UpgradeLimit
.DegradeDays    DB #00                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Peasants = FSoldier.DegradeDays
                assert $ - Peasants = FSoldier

Soldiers        ; FSoldier, исходная запись
.Name           DB #91, #AE, #AB, #A4, #A0, #E2, #EB, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Soldiers = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Soldiers = FSoldier.NameEnd
.MoveFlags      DB #58                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Soldiers = FSoldier.MoveFlags
.ExtraFlags     DB #00                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Soldiers = FSoldier.ExtraFlags
.Actions        DB #02                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Soldiers = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Soldiers = FSoldier.ActionStock
.SectID         DB #00                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Soldiers = FSoldier.SectID
.SpawnClass     DB #00                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Soldiers = FSoldier.SpawnClass
.UpgradeID      DB UnitID.Spearmen                                              ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Soldiers = FSoldier.UpgradeID
.DegradeID      DB UnitID.Peasants                                              ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Soldiers = FSoldier.DegradeID
.SpecialFlags   DB #00                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Soldiers = FSoldier.SpecialFlags
.UnitValue      DW #0032                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Soldiers = FSoldier.UnitValue
.Upkeep         DW #0005                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Soldiers = FSoldier.Upkeep
.BattleValue    DW #0014                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Soldiers = FSoldier.BattleValue
.Unknown1C      DB #0A, #00, #14, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Soldiers = FSoldier.Unknown1C
.SpawnCount     DW #0000                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Soldiers = FSoldier.SpawnCount
.DamageSpread   DW #000A                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Soldiers = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Soldiers = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #00                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Soldiers = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #00                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Soldiers = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #07                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Soldiers = FSoldier.UpgradeLimit
.DegradeDays    DB #0E                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Soldiers = FSoldier.DegradeDays
                assert $ - Soldiers = FSoldier

Archers         ; FSoldier, исходная запись
.Name           DB #8B, #E3, #E7, #AD, #A8, #AA, #A8, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Archers = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Archers = FSoldier.NameEnd
.MoveFlags      DB #5A                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Archers = FSoldier.MoveFlags
.ExtraFlags     DB #00                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Archers = FSoldier.ExtraFlags
.Actions        DB #02                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Archers = FSoldier.Actions
.ActionStock    DB #0C                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Archers = FSoldier.ActionStock
.SectID         DB #00                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Archers = FSoldier.SectID
.SpawnClass     DB #00                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Archers = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Archers = FSoldier.UpgradeID
.DegradeID      DB UnitID.Soldiers                                              ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Archers = FSoldier.DegradeID
.SpecialFlags   DB #00                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Archers = FSoldier.SpecialFlags
.UnitValue      DW #012C                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Archers = FSoldier.UnitValue
.Upkeep         DW #0028                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Archers = FSoldier.Upkeep
.BattleValue    DW #001E                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Archers = FSoldier.BattleValue
.Unknown1C      DB #09, #00, #14, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Archers = FSoldier.Unknown1C
.SpawnCount     DW #0000                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Archers = FSoldier.SpawnCount
.DamageSpread   DW #000A                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Archers = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Archers = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #00                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Archers = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #00                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Archers = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Archers = FSoldier.UpgradeLimit
.DegradeDays    DB #0E                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Archers = FSoldier.DegradeDays
                assert $ - Archers = FSoldier

Spearmen        ; FSoldier, исходная запись
.Name           DB #8A, #AE, #AF, #EC, #A5, #AD, #AE, #E1                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #E6, #EB, #20, #20                                           ; продолжение поля Name
                assert .Name - Spearmen = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Spearmen = FSoldier.NameEnd
.MoveFlags      DB #58                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Spearmen = FSoldier.MoveFlags
.ExtraFlags     DB #00                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Spearmen = FSoldier.ExtraFlags
.Actions        DB #02                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Spearmen = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Spearmen = FSoldier.ActionStock
.SectID         DB #00                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Spearmen = FSoldier.SectID
.SpawnClass     DB #00                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Spearmen = FSoldier.SpawnClass
.UpgradeID      DB UnitID.Knights                                               ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Spearmen = FSoldier.UpgradeID
.DegradeID      DB UnitID.Soldiers                                              ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Spearmen = FSoldier.DegradeID
.SpecialFlags   DB #00                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Spearmen = FSoldier.SpecialFlags
.UnitValue      DW #017C                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Spearmen = FSoldier.UnitValue
.Upkeep         DW #0028                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Spearmen = FSoldier.Upkeep
.BattleValue    DW #0096                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Spearmen = FSoldier.BattleValue
.Unknown1C      DB #06, #00, #0C, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Spearmen = FSoldier.Unknown1C
.SpawnCount     DW #0000                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Spearmen = FSoldier.SpawnCount
.DamageSpread   DW #0005                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Spearmen = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Spearmen = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #00                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Spearmen = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #00                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Spearmen = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #1E                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Spearmen = FSoldier.UpgradeLimit
.DegradeDays    DB #0E                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Spearmen = FSoldier.DegradeDays
                assert $ - Spearmen = FSoldier

Cavalry         ; FSoldier, исходная запись
.Name           DB #8A, #A0, #A2, #A0, #AB, #A5, #E0, #A8                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #E1, #E2, #EB, #20                                           ; продолжение поля Name
                assert .Name - Cavalry = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Cavalry = FSoldier.NameEnd
.MoveFlags      DB #48                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Cavalry = FSoldier.MoveFlags
.ExtraFlags     DB #20                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Cavalry = FSoldier.ExtraFlags
.Actions        DB #04                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Cavalry = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Cavalry = FSoldier.ActionStock
.SectID         DB #00                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Cavalry = FSoldier.SectID
.SpawnClass     DB #00                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Cavalry = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Cavalry = FSoldier.UpgradeID
.DegradeID      DB UnitID.Nomads                                                ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Cavalry = FSoldier.DegradeID
.SpecialFlags   DB #00                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Cavalry = FSoldier.SpecialFlags
.UnitValue      DW #0320                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Cavalry = FSoldier.UnitValue
.Upkeep         DW #00C8                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Cavalry = FSoldier.Upkeep
.BattleValue    DW #012C                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Cavalry = FSoldier.BattleValue
.Unknown1C      DB #06, #00, #0A, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Cavalry = FSoldier.Unknown1C
.SpawnCount     DW #0000                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Cavalry = FSoldier.SpawnCount
.DamageSpread   DW #0005                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Cavalry = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Cavalry = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #00                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Cavalry = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #00                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Cavalry = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Cavalry = FSoldier.UpgradeLimit
.DegradeDays    DB #0E                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Cavalry = FSoldier.DegradeDays
                assert $ - Cavalry = FSoldier

Knights         ; FSoldier, исходная запись
.Name           DB #90, #EB, #E6, #A0, #E0, #A8, #20, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Knights = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Knights = FSoldier.NameEnd
.MoveFlags      DB #18                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Knights = FSoldier.MoveFlags
.ExtraFlags     DB #60                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Knights = FSoldier.ExtraFlags
.Actions        DB #01                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Knights = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Knights = FSoldier.ActionStock
.SectID         DB #00                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Knights = FSoldier.SectID
.SpawnClass     DB #00                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Knights = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Knights = FSoldier.UpgradeID
.DegradeID      DB UnitID.Soldiers                                              ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Knights = FSoldier.DegradeID
.SpecialFlags   DB #00                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Knights = FSoldier.SpecialFlags
.UnitValue      DW #03E8                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Knights = FSoldier.UnitValue
.Upkeep         DW #00E6                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Knights = FSoldier.Upkeep
.BattleValue    DW #015E                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Knights = FSoldier.BattleValue
.Unknown1C      DB #06, #00, #08, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Knights = FSoldier.Unknown1C
.SpawnCount     DW #0000                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Knights = FSoldier.SpawnCount
.DamageSpread   DW #0005                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Knights = FSoldier.DamageSpread
.DamageDivisor  DW #03E8                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Knights = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #00                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Knights = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #00                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Knights = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Knights = FSoldier.UpgradeLimit
.DegradeDays    DB #07                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Knights = FSoldier.DegradeDays
                assert $ - Knights = FSoldier

Nomads          ; FSoldier, исходная запись
.Name           DB #8A, #AE, #E7, #A5, #A2, #AD, #A8, #AA                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #A8, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Nomads = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Nomads = FSoldier.NameEnd
.MoveFlags      DB #48                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Nomads = FSoldier.MoveFlags
.ExtraFlags     DB #21                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Nomads = FSoldier.ExtraFlags
.Actions        DB #02                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Nomads = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Nomads = FSoldier.ActionStock
.SectID         DB #00                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Nomads = FSoldier.SectID
.SpawnClass     DB #03                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Nomads = FSoldier.SpawnClass
.UpgradeID      DB UnitID.Cavalry                                               ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Nomads = FSoldier.UpgradeID
.DegradeID      DB UnitID.Peasants                                              ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Nomads = FSoldier.DegradeID
.SpecialFlags   DB #08                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Nomads = FSoldier.SpecialFlags
.UnitValue      DW #00FA                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Nomads = FSoldier.UnitValue
.Upkeep         DW #001E                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Nomads = FSoldier.Upkeep
.BattleValue    DW #0082                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Nomads = FSoldier.BattleValue
.Unknown1C      DB #0A, #00, #0F, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Nomads = FSoldier.Unknown1C
.SpawnCount     DW #0096                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Nomads = FSoldier.SpawnCount
.DamageSpread   DW #0014                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Nomads = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Nomads = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #05                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Nomads = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #06                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Nomads = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #1E                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Nomads = FSoldier.UpgradeLimit
.DegradeDays    DB #07                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Nomads = FSoldier.DegradeDays
                assert $ - Nomads = FSoldier

Celts           ; FSoldier, исходная запись
.Name           DB #8A, #A5, #AB, #EC, #E2, #EB, #20, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Celts = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Celts = FSoldier.NameEnd
.MoveFlags      DB #78                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Celts = FSoldier.MoveFlags
.ExtraFlags     DB #41                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Celts = FSoldier.ExtraFlags
.Actions        DB #03                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Celts = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Celts = FSoldier.ActionStock
.SectID         DB #04                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Celts = FSoldier.SectID
.SpawnClass     DB #03                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Celts = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Celts = FSoldier.UpgradeID
.DegradeID      DB UnitID.Peasants                                              ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Celts = FSoldier.DegradeID
.SpecialFlags   DB #08                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Celts = FSoldier.SpecialFlags
.UnitValue      DW #02BC                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Celts = FSoldier.UnitValue
.Upkeep         DW #0028                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Celts = FSoldier.Upkeep
.BattleValue    DW #00C8                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Celts = FSoldier.BattleValue
.Unknown1C      DB #0A, #00, #0F, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Celts = FSoldier.Unknown1C
.SpawnCount     DW #0046                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Celts = FSoldier.SpawnCount
.DamageSpread   DW #0014                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Celts = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Celts = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #05                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Celts = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #06                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Celts = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Celts = FSoldier.UpgradeLimit
.DegradeDays    DB #06                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Celts = FSoldier.DegradeDays
                assert $ - Celts = FSoldier

Vikings         ; FSoldier, исходная запись
.Name           DB #82, #A8, #AA, #A8, #AD, #A3, #A8, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Vikings = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Vikings = FSoldier.NameEnd
.MoveFlags      DB #78                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Vikings = FSoldier.MoveFlags
.ExtraFlags     DB #60                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Vikings = FSoldier.ExtraFlags
.Actions        DB #01                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Vikings = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Vikings = FSoldier.ActionStock
.SectID         DB #01                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Vikings = FSoldier.SectID
.SpawnClass     DB #01                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Vikings = FSoldier.SpawnClass
.UpgradeID      DB UnitID.Knights                                               ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Vikings = FSoldier.UpgradeID
.DegradeID      DB UnitID.Peasants                                              ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Vikings = FSoldier.DegradeID
.SpecialFlags   DB #00                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Vikings = FSoldier.SpecialFlags
.UnitValue      DW #0190                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Vikings = FSoldier.UnitValue
.Upkeep         DW #003C                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Vikings = FSoldier.Upkeep
.BattleValue    DW #00C8                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Vikings = FSoldier.BattleValue
.Unknown1C      DB #0A, #00, #0F, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Vikings = FSoldier.Unknown1C
.SpawnCount     DW #0032                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Vikings = FSoldier.SpawnCount
.DamageSpread   DW #000A                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Vikings = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Vikings = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #07                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Vikings = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #07                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Vikings = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #0F                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Vikings = FSoldier.UpgradeLimit
.DegradeDays    DB #0A                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Vikings = FSoldier.DegradeDays
                assert $ - Vikings = FSoldier

Wolves          ; FSoldier, исходная запись
.Name           DB #82, #AE, #AB, #AA, #A8, #20, #20, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Wolves = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Wolves = FSoldier.NameEnd
.MoveFlags      DB #48                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Wolves = FSoldier.MoveFlags
.ExtraFlags     DB #11                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Wolves = FSoldier.ExtraFlags
.Actions        DB #03                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Wolves = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Wolves = FSoldier.ActionStock
.SectID         DB #00                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Wolves = FSoldier.SectID
.SpawnClass     DB #03                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Wolves = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Wolves = FSoldier.UpgradeID
.DegradeID      DB UnitID.None                                                  ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Wolves = FSoldier.DegradeID
.SpecialFlags   DB #08                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Wolves = FSoldier.SpecialFlags
.UnitValue      DW #0014                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Wolves = FSoldier.UnitValue
.Upkeep         DW #0001                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Wolves = FSoldier.Upkeep
.BattleValue    DW #000F                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Wolves = FSoldier.BattleValue
.Unknown1C      DB #0F, #00, #19, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Wolves = FSoldier.Unknown1C
.SpawnCount     DW #00C8                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Wolves = FSoldier.SpawnCount
.DamageSpread   DW #001E                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Wolves = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Wolves = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #03                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Wolves = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #03                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Wolves = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Wolves = FSoldier.UpgradeLimit
.DegradeDays    DB #00                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Wolves = FSoldier.DegradeDays
                assert $ - Wolves = FSoldier

Orcs            ; FSoldier, исходная запись
.Name           DB #8E, #E0, #AA, #A8, #20, #20, #20, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Orcs = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Orcs = FSoldier.NameEnd
.MoveFlags      DB #7A                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Orcs = FSoldier.MoveFlags
.ExtraFlags     DB #00                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Orcs = FSoldier.ExtraFlags
.Actions        DB #02                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Orcs = FSoldier.Actions
.ActionStock    DB #06                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Orcs = FSoldier.ActionStock
.SectID         DB #02                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Orcs = FSoldier.SectID
.SpawnClass     DB #01                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Orcs = FSoldier.SpawnClass
.UpgradeID      DB UnitID.Archers                                               ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Orcs = FSoldier.UpgradeID
.DegradeID      DB UnitID.None                                                  ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Orcs = FSoldier.DegradeID
.SpecialFlags   DB #00                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Orcs = FSoldier.SpecialFlags
.UnitValue      DW #0064                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Orcs = FSoldier.UnitValue
.Upkeep         DW #000A                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Orcs = FSoldier.Upkeep
.BattleValue    DW #0019                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Orcs = FSoldier.BattleValue
.Unknown1C      DB #0A, #00, #0F, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Orcs = FSoldier.Unknown1C
.SpawnCount     DW #0064                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Orcs = FSoldier.SpawnCount
.DamageSpread   DW #000A                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Orcs = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Orcs = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #03                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Orcs = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #07                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Orcs = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #14                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Orcs = FSoldier.UpgradeLimit
.DegradeDays    DB #00                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Orcs = FSoldier.DegradeDays
                assert $ - Orcs = FSoldier

Elves           ; FSoldier, исходная запись
.Name           DB #9D, #AB, #EC, #E4, #EB, #20, #20, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Elves = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Elves = FSoldier.NameEnd
.MoveFlags      DB #7A                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Elves = FSoldier.MoveFlags
.ExtraFlags     DB #40                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Elves = FSoldier.ExtraFlags
.Actions        DB #03                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Elves = FSoldier.Actions
.ActionStock    DB #18                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Elves = FSoldier.ActionStock
.SectID         DB #03                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Elves = FSoldier.SectID
.SpawnClass     DB #02                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Elves = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Elves = FSoldier.UpgradeID
.DegradeID      DB UnitID.None                                                  ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Elves = FSoldier.DegradeID
.SpecialFlags   DB #00                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Elves = FSoldier.SpecialFlags
.UnitValue      DW #00FA                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Elves = FSoldier.UnitValue
.Upkeep         DW #0046                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Elves = FSoldier.Upkeep
.BattleValue    DW #00C8                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Elves = FSoldier.BattleValue
.Unknown1C      DB #02, #00, #04, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Elves = FSoldier.Unknown1C
.SpawnCount     DW #0046                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Elves = FSoldier.SpawnCount
.DamageSpread   DW #0005                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Elves = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Elves = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #04                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Elves = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #0A                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Elves = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Elves = FSoldier.UpgradeLimit
.DegradeDays    DB #00                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Elves = FSoldier.DegradeDays
                assert $ - Elves = FSoldier

Ogres           ; FSoldier, исходная запись
.Name           DB #8B, #EE, #A4, #AE, #A5, #A4, #EB, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Ogres = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Ogres = FSoldier.NameEnd
.MoveFlags      DB #58                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Ogres = FSoldier.MoveFlags
.ExtraFlags     DB #51                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Ogres = FSoldier.ExtraFlags
.Actions        DB #01                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Ogres = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Ogres = FSoldier.ActionStock
.SectID         DB #04                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Ogres = FSoldier.SectID
.SpawnClass     DB #01                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Ogres = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Ogres = FSoldier.UpgradeID
.DegradeID      DB UnitID.Trolls                                                ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Ogres = FSoldier.DegradeID
.SpecialFlags   DB #08                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Ogres = FSoldier.SpecialFlags
.UnitValue      DW #0384                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Ogres = FSoldier.UnitValue
.Upkeep         DW #012C                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Ogres = FSoldier.Upkeep
.BattleValue    DW #01F4                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Ogres = FSoldier.BattleValue
.Unknown1C      DB #08, #00, #0A, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Ogres = FSoldier.Unknown1C
.SpawnCount     DW #0028                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Ogres = FSoldier.SpawnCount
.DamageSpread   DW #0002                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Ogres = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Ogres = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #05                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Ogres = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #0A                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Ogres = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Ogres = FSoldier.UpgradeLimit
.DegradeDays    DB #14                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Ogres = FSoldier.DegradeDays
                assert $ - Ogres = FSoldier

Trolls          ; FSoldier, исходная запись
.Name           DB #92, #E0, #AE, #AB, #AB, #A8, #20, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Trolls = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Trolls = FSoldier.NameEnd
.MoveFlags      DB #48                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Trolls = FSoldier.MoveFlags
.ExtraFlags     DB #20                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Trolls = FSoldier.ExtraFlags
.Actions        DB #01                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Trolls = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Trolls = FSoldier.ActionStock
.SectID         DB #01                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Trolls = FSoldier.SectID
.SpawnClass     DB #02                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Trolls = FSoldier.SpawnClass
.UpgradeID      DB UnitID.Knights                                               ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Trolls = FSoldier.UpgradeID
.DegradeID      DB UnitID.None                                                  ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Trolls = FSoldier.DegradeID
.SpecialFlags   DB #00                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Trolls = FSoldier.SpecialFlags
.UnitValue      DW #044C                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Trolls = FSoldier.UnitValue
.Upkeep         DW #012C                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Trolls = FSoldier.Upkeep
.BattleValue    DW #01F4                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Trolls = FSoldier.BattleValue
.Unknown1C      DB #07, #00, #0A, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Trolls = FSoldier.Unknown1C
.SpawnCount     DW #0032                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Trolls = FSoldier.SpawnCount
.DamageSpread   DW #0002                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Trolls = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Trolls = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #05                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Trolls = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #0A                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Trolls = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #32                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Trolls = FSoldier.UpgradeLimit
.DegradeDays    DB #00                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Trolls = FSoldier.DegradeDays
                assert $ - Trolls = FSoldier

Giants          ; FSoldier, исходная запись
.Name           DB #83, #A8, #A3, #A0, #AD, #E2, #EB, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Giants = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Giants = FSoldier.NameEnd
.MoveFlags      DB #1A                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Giants = FSoldier.MoveFlags
.ExtraFlags     DB #70                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Giants = FSoldier.ExtraFlags
.Actions        DB #03                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Giants = FSoldier.Actions
.ActionStock    DB #06                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Giants = FSoldier.ActionStock
.SectID         DB #02                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Giants = FSoldier.SectID
.SpawnClass     DB #01                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Giants = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Giants = FSoldier.UpgradeID
.DegradeID      DB UnitID.Trolls                                                ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Giants = FSoldier.DegradeID
.SpecialFlags   DB #00                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Giants = FSoldier.SpecialFlags
.UnitValue      DW #0898                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Giants = FSoldier.UnitValue
.Upkeep         DW #01F4                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Giants = FSoldier.Upkeep
.BattleValue    DW #03E8                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Giants = FSoldier.BattleValue
.Unknown1C      DB #02, #00, #02, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Giants = FSoldier.Unknown1C
.SpawnCount     DW #001E                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Giants = FSoldier.SpawnCount
.DamageSpread   DW #0002                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Giants = FSoldier.DamageSpread
.DamageDivisor  DW #03E8                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Giants = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #03                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Giants = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #0A                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Giants = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Giants = FSoldier.UpgradeLimit
.DegradeDays    DB #07                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Giants = FSoldier.DegradeDays
                assert $ - Giants = FSoldier

Dragons         ; FSoldier, исходная запись
.Name           DB #84, #E0, #A0, #AA, #AE, #AD, #EB, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Dragons = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Dragons = FSoldier.NameEnd
.MoveFlags      DB #04                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Dragons = FSoldier.MoveFlags
.ExtraFlags     DB #73                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Dragons = FSoldier.ExtraFlags
.Actions        DB #01                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Dragons = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Dragons = FSoldier.ActionStock
.SectID         DB #00                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Dragons = FSoldier.SectID
.SpawnClass     DB #01                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Dragons = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Dragons = FSoldier.UpgradeID
.DegradeID      DB UnitID.None                                                  ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Dragons = FSoldier.DegradeID
.SpecialFlags   DB #0C                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Dragons = FSoldier.SpecialFlags
.UnitValue      DW #1388                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Dragons = FSoldier.UnitValue
.Upkeep         DW #0320                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Dragons = FSoldier.Upkeep
.BattleValue    DW #05DC                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Dragons = FSoldier.BattleValue
.Unknown1C      DB #00, #00, #00, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Dragons = FSoldier.Unknown1C
.SpawnCount     DW #0019                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Dragons = FSoldier.SpawnCount
.DamageSpread   DW #0000                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Dragons = FSoldier.DamageSpread
.DamageDivisor  DW #03E8                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Dragons = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #02                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Dragons = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #0A                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Dragons = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Dragons = FSoldier.UpgradeLimit
.DegradeDays    DB #00                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Dragons = FSoldier.DegradeDays
                assert $ - Dragons = FSoldier

Ghosts          ; FSoldier, исходная запись
.Name           DB #8F, #E0, #A8, #A7, #E0, #A0, #AA, #A8                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Ghosts = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Ghosts = FSoldier.NameEnd
.MoveFlags      DB #7C                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Ghosts = FSoldier.MoveFlags
.ExtraFlags     DB #08                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Ghosts = FSoldier.ExtraFlags
.Actions        DB #01                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Ghosts = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Ghosts = FSoldier.ActionStock
.SectID         DB #03                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Ghosts = FSoldier.SectID
.SpawnClass     DB #02                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Ghosts = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Ghosts = FSoldier.UpgradeID
.DegradeID      DB UnitID.None                                                  ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Ghosts = FSoldier.DegradeID
.SpecialFlags   DB #02                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Ghosts = FSoldier.SpecialFlags
.UnitValue      DW #000F                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Ghosts = FSoldier.UnitValue
.Upkeep         DW #0001                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Ghosts = FSoldier.Upkeep
.BattleValue    DW #000A                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Ghosts = FSoldier.BattleValue
.Unknown1C      DB #00, #00, #00, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Ghosts = FSoldier.Unknown1C
.SpawnCount     DW #00FA                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Ghosts = FSoldier.SpawnCount
.DamageSpread   DW #000A                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Ghosts = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Ghosts = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #0A                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Ghosts = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #FF                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Ghosts = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Ghosts = FSoldier.UpgradeLimit
.DegradeDays    DB #00                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Ghosts = FSoldier.DegradeDays
                assert $ - Ghosts = FSoldier

Skeletons       ; FSoldier, исходная запись
.Name           DB #91, #AA, #A5, #AB, #A5, #E2, #EB, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Skeletons = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Skeletons = FSoldier.NameEnd
.MoveFlags      DB #78                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Skeletons = FSoldier.MoveFlags
.ExtraFlags     DB #38                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Skeletons = FSoldier.ExtraFlags
.Actions        DB #02                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Skeletons = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Skeletons = FSoldier.ActionStock
.SectID         DB #02                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Skeletons = FSoldier.SectID
.SpawnClass     DB #04                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Skeletons = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Skeletons = FSoldier.UpgradeID
.DegradeID      DB UnitID.None                                                  ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Skeletons = FSoldier.DegradeID
.SpecialFlags   DB #02                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Skeletons = FSoldier.SpecialFlags
.UnitValue      DW #0050                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Skeletons = FSoldier.UnitValue
.Upkeep         DW #0014                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Skeletons = FSoldier.Upkeep
.BattleValue    DW #0014                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Skeletons = FSoldier.BattleValue
.Unknown1C      DB #00, #00, #00, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Skeletons = FSoldier.Unknown1C
.SpawnCount     DW #0078                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Skeletons = FSoldier.SpawnCount
.DamageSpread   DW #0000                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Skeletons = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Skeletons = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #0A                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Skeletons = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #FF                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Skeletons = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Skeletons = FSoldier.UpgradeLimit
.DegradeDays    DB #00                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Skeletons = FSoldier.DegradeDays
                assert $ - Skeletons = FSoldier

Zombies         ; FSoldier, исходная запись
.Name           DB #87, #AE, #AC, #A1, #A8, #20, #20, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Zombies = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Zombies = FSoldier.NameEnd
.MoveFlags      DB #78                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Zombies = FSoldier.MoveFlags
.ExtraFlags     DB #18                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Zombies = FSoldier.ExtraFlags
.Actions        DB #02                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Zombies = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Zombies = FSoldier.ActionStock
.SectID         DB #00                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Zombies = FSoldier.SectID
.SpawnClass     DB #04                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Zombies = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Zombies = FSoldier.UpgradeID
.DegradeID      DB UnitID.None                                                  ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Zombies = FSoldier.DegradeID
.SpecialFlags   DB #00                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Zombies = FSoldier.SpecialFlags
.UnitValue      DW #003C                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Zombies = FSoldier.UnitValue
.Upkeep         DW #001E                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Zombies = FSoldier.Upkeep
.BattleValue    DW #0019                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Zombies = FSoldier.BattleValue
.Unknown1C      DB #00, #00, #00, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Zombies = FSoldier.Unknown1C
.SpawnCount     DW #006E                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Zombies = FSoldier.SpawnCount
.DamageSpread   DW #0000                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Zombies = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Zombies = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #0A                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Zombies = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #FF                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Zombies = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Zombies = FSoldier.UpgradeLimit
.DegradeDays    DB #00                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Zombies = FSoldier.DegradeDays
                assert $ - Zombies = FSoldier

Spectres        ; FSoldier, исходная запись
.Name           DB #8F, #E0, #A8, #A2, #A8, #A4, #A5, #AD                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #A8, #EF, #20, #20                                           ; продолжение поля Name
                assert .Name - Spectres = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Spectres = FSoldier.NameEnd
.MoveFlags      DB #FC                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Spectres = FSoldier.MoveFlags
.ExtraFlags     DB #31                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Spectres = FSoldier.ExtraFlags
.Actions        DB #03                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Spectres = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Spectres = FSoldier.ActionStock
.SectID         DB #05                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Spectres = FSoldier.SectID
.SpawnClass     DB #04                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Spectres = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Spectres = FSoldier.UpgradeID
.DegradeID      DB UnitID.Peasants                                              ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Spectres = FSoldier.DegradeID
.SpecialFlags   DB #08                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Spectres = FSoldier.SpecialFlags
.UnitValue      DW #0190                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Spectres = FSoldier.UnitValue
.Upkeep         DW #00C8                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Spectres = FSoldier.Upkeep
.BattleValue    DW #0140                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Spectres = FSoldier.BattleValue
.Unknown1C      DB #02, #00, #05, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Spectres = FSoldier.Unknown1C
.SpawnCount     DW #0028                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Spectres = FSoldier.SpawnCount
.DamageSpread   DW #000A                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Spectres = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Spectres = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #02                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Spectres = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #14                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Spectres = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Spectres = FSoldier.UpgradeLimit
.DegradeDays    DB #06                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Spectres = FSoldier.DegradeDays
                assert $ - Spectres = FSoldier

Vampires        ; FSoldier, исходная запись
.Name           DB #82, #A0, #AC, #AF, #A8, #E0, #EB, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Vampires = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Vampires = FSoldier.NameEnd
.MoveFlags      DB #FC                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Vampires = FSoldier.MoveFlags
.ExtraFlags     DB #59                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Vampires = FSoldier.ExtraFlags
.Actions        DB #01                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Vampires = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Vampires = FSoldier.ActionStock
.SectID         DB #02                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Vampires = FSoldier.SectID
.SpawnClass     DB #04                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Vampires = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Vampires = FSoldier.UpgradeID
.DegradeID      DB UnitID.Ghosts                                                ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Vampires = FSoldier.DegradeID
.SpecialFlags   DB #09                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Vampires = FSoldier.SpecialFlags
.UnitValue      DW #05DC                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Vampires = FSoldier.UnitValue
.Upkeep         DW #0190                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Vampires = FSoldier.Upkeep
.BattleValue    DW #01C2                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Vampires = FSoldier.BattleValue
.Unknown1C      DB #00, #00, #00, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Vampires = FSoldier.Unknown1C
.SpawnCount     DW #0023                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Vampires = FSoldier.SpawnCount
.DamageSpread   DW #000A                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Vampires = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Vampires = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #02                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Vampires = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #0A                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Vampires = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Vampires = FSoldier.UpgradeLimit
.DegradeDays    DB #0B                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Vampires = FSoldier.DegradeDays
                assert $ - Vampires = FSoldier

Dwarves         ; FSoldier, исходная запись
.Name           DB #83, #AD, #AE, #AC, #EB, #20, #20, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Dwarves = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Dwarves = FSoldier.NameEnd
.MoveFlags      DB #79                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Dwarves = FSoldier.MoveFlags
.ExtraFlags     DB #21                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Dwarves = FSoldier.ExtraFlags
.Actions        DB #02                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Dwarves = FSoldier.Actions
.ActionStock    DB #01                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Dwarves = FSoldier.ActionStock
.SectID         DB #01                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Dwarves = FSoldier.SectID
.SpawnClass     DB #02                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Dwarves = FSoldier.SpawnClass
.UpgradeID      DB UnitID.Druids                                                ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Dwarves = FSoldier.UpgradeID
.DegradeID      DB UnitID.None                                                  ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Dwarves = FSoldier.DegradeID
.SpecialFlags   DB #00                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Dwarves = FSoldier.SpecialFlags
.UnitValue      DW #0096                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Dwarves = FSoldier.UnitValue
.Upkeep         DW #0046                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Dwarves = FSoldier.Upkeep
.BattleValue    DW #005A                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Dwarves = FSoldier.BattleValue
.Unknown1C      DB #02, #00, #03, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Dwarves = FSoldier.Unknown1C
.SpawnCount     DW #003C                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Dwarves = FSoldier.SpawnCount
.DamageSpread   DW #000A                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Dwarves = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Dwarves = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #02                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Dwarves = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #09                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Dwarves = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #32                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Dwarves = FSoldier.UpgradeLimit
.DegradeDays    DB #00                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Dwarves = FSoldier.DegradeDays
                assert $ - Dwarves = FSoldier

Druids          ; FSoldier, исходная запись
.Name           DB #84, #E0, #E3, #A8, #A4, #EB, #20, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Druids = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Druids = FSoldier.NameEnd
.MoveFlags      DB #79                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Druids = FSoldier.MoveFlags
.ExtraFlags     DB #40                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Druids = FSoldier.ExtraFlags
.Actions        DB #02                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Druids = FSoldier.Actions
.ActionStock    DB #04                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Druids = FSoldier.ActionStock
.SectID         DB #05                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Druids = FSoldier.SectID
.SpawnClass     DB #02                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Druids = FSoldier.SpawnClass
.UpgradeID      DB UnitID.Warlocks                                              ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Druids = FSoldier.UpgradeID
.DegradeID      DB UnitID.Dwarves                                               ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Druids = FSoldier.DegradeID
.SpecialFlags   DB #08                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Druids = FSoldier.SpecialFlags
.UnitValue      DW #0320                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Druids = FSoldier.UnitValue
.Upkeep         DW #00E6                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Druids = FSoldier.Upkeep
.BattleValue    DW #01F4                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Druids = FSoldier.BattleValue
.Unknown1C      DB #00, #00, #00, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Druids = FSoldier.Unknown1C
.SpawnCount     DW #0019                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Druids = FSoldier.SpawnCount
.DamageSpread   DW #000F                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Druids = FSoldier.DamageSpread
.DamageDivisor  DW #03E8                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Druids = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #02                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Druids = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #07                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Druids = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #50                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Druids = FSoldier.UpgradeLimit
.DegradeDays    DB #14                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Druids = FSoldier.DegradeDays
                assert $ - Druids = FSoldier

Warlocks        ; FSoldier, исходная запись
.Name           DB #8A, #AE, #AB, #A4, #E3, #AD, #EB, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Warlocks = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Warlocks = FSoldier.NameEnd
.MoveFlags      DB #7D                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Warlocks = FSoldier.MoveFlags
.ExtraFlags     DB #41                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Warlocks = FSoldier.ExtraFlags
.Actions        DB #01                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Warlocks = FSoldier.Actions
.ActionStock    DB #04                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Warlocks = FSoldier.ActionStock
.SectID         DB #05                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Warlocks = FSoldier.SectID
.SpawnClass     DB #03                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Warlocks = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Warlocks = FSoldier.UpgradeID
.DegradeID      DB UnitID.None                                                  ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Warlocks = FSoldier.DegradeID
.SpecialFlags   DB #08                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Warlocks = FSoldier.SpecialFlags
.UnitValue      DW #0BB8                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Warlocks = FSoldier.UnitValue
.Upkeep         DW #02BC                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Warlocks = FSoldier.Upkeep
.BattleValue    DW #0384                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Warlocks = FSoldier.BattleValue
.Unknown1C      DB #00, #00, #00, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Warlocks = FSoldier.Unknown1C
.SpawnCount     DW #0014                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Warlocks = FSoldier.SpawnCount
.DamageSpread   DW #000A                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Warlocks = FSoldier.DamageSpread
.DamageDivisor  DW #03E8                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Warlocks = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #02                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Warlocks = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #0A                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Warlocks = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Warlocks = FSoldier.UpgradeLimit
.DegradeDays    DB #00                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Warlocks = FSoldier.DegradeDays
                assert $ - Warlocks = FSoldier

Demons          ; FSoldier, исходная запись
.Name           DB #84, #A5, #AC, #AE, #AD, #EB, #20, #20                       ; FSoldier.Name, смещение #00, имя CP866, дополненное пробелами
                DB #20, #20, #20, #20                                           ; продолжение поля Name
                assert .Name - Demons = FSoldier.Name
.NameEnd        DB #00                                                          ; FSoldier.NameEnd, смещение #0C, нулевой терминатор имени
                assert .NameEnd - Demons = FSoldier.NameEnd
.MoveFlags      DB #7C                                                          ; FSoldier.MoveFlags, смещение #0D, первый байт способностей, младшие 3 бита копируются в боевые флаги
                assert .MoveFlags - Demons = FSoldier.MoveFlags
.ExtraFlags     DB #55                                                          ; FSoldier.ExtraFlags, смещение #0E, второй байт флагов, возвращаемый в D без назначения всех битов
                assert .ExtraFlags - Demons = FSoldier.ExtraFlags
.Actions        DB #01                                                          ; FSoldier.Actions, смещение #0F, исходное число действий на раунд
                assert .Actions - Demons = FSoldier.Actions
.ActionStock    DB #00                                                          ; FSoldier.ActionStock, смещение #10, запас расходуемого дальнего действия
                assert .ActionStock - Demons = FSoldier.ActionStock
.SectID         DB #04                                                          ; FSoldier.SectID, смещение #11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                assert .SectID - Demons = FSoldier.SectID
.SpawnClass     DB #01                                                          ; FSoldier.SpawnClass, смещение #12, категория 1..4 при выборе начального типа
                assert .SpawnClass - Demons = FSoldier.SpawnClass
.UpgradeID      DB UnitID.None                                                  ; FSoldier.UpgradeID, смещение #13, ID замены по служебному порогу участия
                assert .UpgradeID - Demons = FSoldier.UpgradeID
.DegradeID      DB UnitID.None                                                  ; FSoldier.DegradeID, смещение #14, ID замены при утрате квалификации, 0 запрещает замену
                assert .DegradeID - Demons = FSoldier.DegradeID
.SpecialFlags   DB #0C                                                          ; FSoldier.SpecialFlags, смещение #15, особые способности, ограничение восстановления и участие в перевозке
                assert .SpecialFlags - Demons = FSoldier.SpecialFlags
.UnitValue      DW #0E74                                                        ; FSoldier.UnitValue, смещение #16, вес одного воина в оценке армии и цене найма корабля
                assert .UnitValue - Demons = FSoldier.UnitValue
.Upkeep         DW #02EE                                                        ; FSoldier.Upkeep, смещение #18, расходы на содержание одного воина
                assert .Upkeep - Demons = FSoldier.Upkeep
.BattleValue    DW #04B0                                                        ; FSoldier.BattleValue, смещение #1A, вес одного воина в общей оценке армии при начале и завершении боя
                assert .BattleValue - Demons = FSoldier.BattleValue
.Unknown1C      DB #00, #00, #00, #00                                           ; FSoldier.Unknown1C, смещение #1C, четыре сохраняемых байта
                assert .Unknown1C - Demons = FSoldier.Unknown1C
.SpawnCount     DW #000F                                                        ; FSoldier.SpawnCount, смещение #20, начальная численность создаваемой шестибайтовой группы
                assert .SpawnCount - Demons = FSoldier.SpawnCount
.DamageSpread   DW #0014                                                        ; FSoldier.DamageSpread, смещение #22, слово разброса урона, удваивается только младший байт E без переноса в D
                assert .DamageSpread - Demons = FSoldier.DamageSpread
.DamageDivisor  DW #2710                                                        ; FSoldier.DamageDivisor, смещение #24, делитель базовой формулы урона
                assert .DamageDivisor - Demons = FSoldier.DamageDivisor
.SiteGrowthDiv  DB #02                                                          ; FSoldier.SiteGrowthDiv, смещение #26, делитель недельного прироста в строениях и гарнизонах
                assert .SiteGrowthDiv - Demons = FSoldier.SiteGrowthDiv
.ArmyGrowthDiv  DB #FF                                                          ; FSoldier.ArmyGrowthDiv, смещение #27, делитель недельного прироста внешней армии и армии героя
                assert .ArmyGrowthDiv - Demons = FSoldier.ArmyGrowthDiv
.UpgradeLimit   DB #00                                                          ; FSoldier.UpgradeLimit, смещение #28, порог служебного счётчика для первой замены
                assert .UpgradeLimit - Demons = FSoldier.UpgradeLimit
.DegradeDays    DB #00                                                          ; FSoldier.DegradeDays, смещение #29, порог дней без боя, исходная ветвь требует также ненулевой DegradeID
                assert .DegradeDays - Demons = FSoldier.DegradeDays
                assert $ - Demons = FSoldier

                assert $ = #CB1A
                endmodule
