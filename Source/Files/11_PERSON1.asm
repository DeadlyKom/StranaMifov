; исходные данные с полями структур, размеры и размещение сохранены
                module Data
                module Person1
                org #8000

Template        ; FPerson, исходная запись
.Name           DB #8F, #E0, #A8, #AD, #E6, #A5, #E1, #E1                       ; FPerson.Name, смещение #00, имя выбранного героя, девять символов CP866
                DB #A0                                                          ; продолжение поля Name
                assert .Name - Template = FPerson.Name
.Terminator     DB #00                                                          ; FPerson.Terminator, смещение #09, нулевой терминатор имени
                assert .Terminator - Template = FPerson.Terminator
.Leadership     DW #0064                                                        ; FPerson.Leadership, смещение #0A, лидерство, задаёт предел количества отряда через деление на коэффициент типа
                assert .Leadership - Template = FPerson.Leadership
.Mana           DW #03E8                                                        ; FPerson.Mana, смещение #0C, текущая магическая сила героя
                assert .Mana - Template = FPerson.Mana
.ManaMax        DW #C350                                                        ; FPerson.ManaMax, смещение #0E, максимум магической силы
                assert .ManaMax - Template = FPerson.ManaMax
.ManaRegen      DW #000A                                                        ; FPerson.ManaRegen, смещение #10, пополнение магической силы при очередном восстановлении
                assert .ManaRegen - Template = FPerson.ManaRegen
.Spells         DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FPerson.Spells, смещение #12, 10 байтов состояния заклинаний, бит 0 — заклинание изучено, остальные биты отдельно не именуются
                DB #00, #00                                                     ; продолжение поля Spells
                assert .Spells - Template = FPerson.Spells
.Money          DB #00, #00, #98, #3A, #00                                      ; FPerson.Money, смещение #1C, наличные монеты в пятибайтном формате калькулятора ROM
                assert .Money - Template = FPerson.Money
.BaseIncome     DB #00, #00, #E8, #03, #00                                      ; FPerson.BaseIncome, смещение #21, постоянная часть недельного дохода в формате Float5, складывается с доходами замков
                assert .BaseIncome - Template = FPerson.BaseIncome
.Army           DB #01, #64, #00, #02, #14, #00, #03, #0A                       ; FPerson.Army, смещение #26, пять записей армии героя FTroop
                DB #00, #04, #06, #00, #05, #04, #00                            ; продолжение поля Army
                assert .Army - Template = FPerson.Army
.Continent      DB #01                                                          ; FPerson.Continent, смещение #35, текущий континент 1..4
                assert .Continent - Template = FPerson.Continent
.X              DB #07                                                          ; FPerson.X, смещение #36, столбец текущей клетки героя
                assert .X - Template = FPerson.X
.Y              DB #39                                                          ; FPerson.Y, смещение #37, строка текущей клетки героя
                assert .Y - Template = FPerson.Y
.ShipMap        DB #01                                                          ; FPerson.ShipMap, смещение #38, континент корабля, #FF означает отсутствие корабля
                assert .ShipMap - Template = FPerson.ShipMap
.ShipX          DB #FF                                                          ; FPerson.ShipX, смещение #39, столбец корабля, #FF является признаком отсутствия
                assert .ShipX - Template = FPerson.ShipX
.ShipY          DB #FF                                                          ; FPerson.ShipY, смещение #3A, строка корабля
                assert .ShipY - Template = FPerson.ShipY
.MoveFlags      DB #00                                                          ; FPerson.MoveFlags, смещение #3B, младшие 2 бита — режим 0 суша/1 корабль/2 полёт, бит 2 служебный режим вида, биты 3/4 ориентация героя/корабля, бит 5 наличие осадных орудий. Биты 6/7 здесь не установлены
                assert .MoveFlags - Template = FPerson.MoveFlags
.MapFlags       DB #00                                                          ; FPerson.MapFlags, смещение #3C, флаги доступных полных карт/континентов, биты выбираются по континенту
                assert .MapFlags - Template = FPerson.MapFlags
.DayFraction    DB #00                                                          ; FPerson.DayFraction, смещение #3D, дробная часть дня в единицах 1/256, переполнение увеличивает Days
                assert .DayFraction - Template = FPerson.DayFraction
.Days           DW #0000                                                        ; FPerson.Days, смещение #3E, счётчик прошедших дней
                assert .Days - Template = FPerson.Days
.Deadline       DW #02D8                                                        ; FPerson.Deadline, смещение #40, предел числа дней, поражение вызывается именно при Days == Deadline
                assert .Deadline - Template = FPerson.Deadline
.Contract       DB #00                                                          ; FPerson.Contract, смещение #42, номер замка текущего контракта с 1, 0 означает отсутствие
                assert .Contract - Template = FPerson.Contract
.Cult           DB #00                                                          ; FPerson.Cult, смещение #43, принадлежность героя к секте, 0 не состоит
                assert .Cult - Template = FPerson.Cult
.Unknown6A3C    DB #96, #00, #96, #00, #96, #00, #96, #00                       ; FPerson.Unknown6A3C, смещение #44, содержимое восьми байтов не получило подтверждённых игровых имён
                assert .Unknown6A3C - Template = FPerson.Unknown6A3C
.GoodX          DB #00                                                          ; FPerson.GoodX, смещение #4C, столбец соответствующего рассказчика
                assert .GoodX - Template = FPerson.GoodX
.GoodY          DB #00                                                          ; FPerson.GoodY, смещение #4D, строка соответствующего рассказчика
                assert .GoodY - Template = FPerson.GoodY
.GoodMap        DB #00                                                          ; FPerson.GoodMap, смещение #4E, континент соответствующего рассказчика
                assert .GoodMap - Template = FPerson.GoodMap
.Unknown6A47    DW #0000                                                        ; FPerson.Unknown6A47, смещение #4F, два байта между континентом и счётчиком встреч, назначение не установлено
                assert .Unknown6A47 - Template = FPerson.Unknown6A47
.GoodVisits     DW #0000                                                        ; FPerson.GoodVisits, смещение #51, число встреч с соответствующим рассказчиком
                assert .GoodVisits - Template = FPerson.GoodVisits
.BadX           DB #00                                                          ; FPerson.BadX, смещение #53, столбец соответствующего рассказчика
                assert .BadX - Template = FPerson.BadX
.BadY           DB #00                                                          ; FPerson.BadY, смещение #54, строка соответствующего рассказчика
                assert .BadY - Template = FPerson.BadY
.BadMap         DB #00                                                          ; FPerson.BadMap, смещение #55, континент соответствующего рассказчика
                assert .BadMap - Template = FPerson.BadMap
.Unknown6A4E    DW #0000                                                        ; FPerson.Unknown6A4E, смещение #56, два байта между континентом и счётчиком встреч, назначение не установлено
                assert .Unknown6A4E - Template = FPerson.Unknown6A4E
.BadVisits      DW #0000                                                        ; FPerson.BadVisits, смещение #58, число встреч с соответствующим рассказчиком
                assert .BadVisits - Template = FPerson.BadVisits
.Unknown6A52    DB #00, #00, #00                                                ; FPerson.Unknown6A52, смещение #5A, назначение трёх байтов не установлено
                assert .Unknown6A52 - Template = FPerson.Unknown6A52
.PuzzleOpen     DB #00, #00, #00, #00, #00                                      ; FPerson.PuzzleOpen, смещение #5D, пять строк по 5 бит открытых частей карты цели
                assert .PuzzleOpen - Template = FPerson.PuzzleOpen
.PuzzleTiles    DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FPerson.PuzzleTiles, смещение #62, образец квадратного участка 5x5 для поиска посоха, сравнение младших 6 бит
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; продолжение поля PuzzleTiles
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; продолжение поля PuzzleTiles
                DB #00                                                          ; продолжение поля PuzzleTiles
                assert .PuzzleTiles - Template = FPerson.PuzzleTiles
.IdleDays       DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FPerson.IdleDays, смещение #7B, 25 счётчиков дней по ID1..25, сброс при добавлении нового ID, используется порогом деградации
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; продолжение поля IdleDays
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; продолжение поля IdleDays
                DB #00                                                          ; продолжение поля IdleDays
                assert .IdleDays - Template = FPerson.IdleDays
.UpgradeCount   DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FPerson.UpgradeCount, смещение #94, 25 счётчиков развития по ID1..25, сравниваются с SOLDIERS+40, точная единица накопления в данном файле не устанавливается
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; продолжение поля UpgradeCount
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; продолжение поля UpgradeCount
                DB #00                                                          ; продолжение поля UpgradeCount
                assert .UpgradeCount - Template = FPerson.UpgradeCount
.Unknown6AA5    DB #00                                                          ; FPerson.Unknown6AA5, смещение #AD, назначение байта не установлено
                assert .Unknown6AA5 - Template = FPerson.Unknown6AA5
.Wins           DW #0000                                                        ; FPerson.Wins, число побед, боевой код увеличивает только младший байт
                assert .Wins - Template = FPerson.Wins
.Losses         DW #0000                                                        ; FPerson.Losses, число поражений, боевой код увеличивает только младший байт
                assert .Losses - Template = FPerson.Losses
.Attacker       DB #00                                                          ; FPerson.Attacker, смещение #B2, 0 нет угрозы замку, 1..15 правитель, #FF банды
                assert .Attacker - Template = FPerson.Attacker
.AttackDays     DB #00                                                          ; FPerson.AttackDays, смещение #B3, дни до разрешения угрозы, исходно 20+R(15)
                assert .AttackDays - Template = FPerson.AttackDays
.AttackCastle   DW #0000                                                        ; FPerson.AttackCastle, смещение #B4, адрес физической 35 байтной записи атакуемого замка в банке 0
                assert .AttackCastle - Template = FPerson.AttackCastle
.AttackArmy     DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FPerson.AttackArmy, смещение #B6, пять записей FTroop атакующей армии, построение создаёт 2..4 отряда
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение поля AttackArmy
                assert .AttackArmy - Template = FPerson.AttackArmy
.Unknown6ABD    DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FPerson.Unknown6ABD, смещение #C5, 23 сохраняемых байта до массива коэффициентов контроля, назначение не установлено
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; продолжение поля Unknown6ABD
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение поля Unknown6ABD
                assert .Unknown6ABD - Template = FPerson.Unknown6ABD
.UnitControl    DB #01, #03, #08, #0B, #12, #1C, #11, #18                       ; FPerson.UnitControl, смещение #DC, 25 коэффициентов предела контроля армии по ID1..25, предел=floor(Leadership/коэффициент)
                DB #16, #06, #0C, #10, #46, #2D, #3C, #96                       ; продолжение поля UnitControl
                DB #01, #0A, #0A, #14, #3C, #08, #19, #46                       ; продолжение поля UnitControl
                DB #73                                                          ; продолжение поля UnitControl
                assert .UnitControl - Template = FPerson.UnitControl
                assert $ - Template = FPerson

                assert $ = #80F5
                endmodule
                endmodule
