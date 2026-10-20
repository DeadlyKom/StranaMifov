
; -----------------------------------------
; показать приглашение вставить диск с игрой и дождаться клавиши
; задаёт DE=6D91, далее общая часть 65B1 восстанавливает экран из банка 4, выводит приглашение в
; нижней строке, ждёт полного отпускания клавиатуры и следующего нажатия, матрица опрашивается как
; NOT IN(00FE) AND1F
; In:
;   регистровых аргументов нет, в логическом банке 4 сохранён экран, установлены RAMDRIVE5FA1 и
;   клавиатурный порт FE
; Out:
;   возврат после нового нажатия клавиши
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
PromptGameDisk  LD DE, Startup.PromptGameDisk.GameDiskText                      ; приглашение вставить диск с игрой
.PromptDisk     PUSH DE
                CALL RestoreScreen                                              ; восстановление полного экрана из сохранённого фона в банк 4
                LD HL, Screen.Attributes + 23 * Screen.RowBytes                 ; первый атрибут нижней строки приглашения диска
                LD DE, Screen.Attributes + 23 * Screen.RowBytes + 1             ; второй атрибут нижней строки для LDIR
                LD BC, #001F
                LD (HL), #42
                LDIR
                POP DE
                LD BC, #1705
                CALL DrawText                                                   ; вывести строку с нулевым терминатором и переходами строк
                LD C, #1F
.ReleaseKey     XOR A
                IN A, (#FE)
                CPL
                AND C
                JR NZ, .ReleaseKey                                              ; переход, если проверяемые клавиши ещё удерживаются

.WaitKey        XOR A
                IN A, (#FE)
                CPL
                AND C
                JR Z, .WaitKey                                                  ; переход, если ни одна проверяемая клавиша ещё не нажата

                RET

                DB #00, #C3, #5E, #61, #00

                ; выбор героя для новой игры и вывод его описания
.NewGame        XOR A
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                CALL ClearScreen                                                ; обнулить все пиксели и атрибуты ZX-экрана
                LD A, #01
                LD (Graphics.Heroes.Draw.Picture), A
                CALL Graphics.Heroes.Draw
                LD BC, #0E00
                LD DE, #061E
                LD A, #46
                CALL DrawFrame                                                  ; рисование рамки из восьми одноклеточных образцов с атрибутами
                LD BC, #1003
                LD DE, Startup.GenerateArmy.ChooseHeroText                      ; приглашение выбрать героя и изображение
                CALL DrawText                                                   ; вывести строку с нулевым терминатором и переходами строк
                LD IX, Startup.GenerateArmy.HeroMenuHeader                      ; заголовок и прямоугольники меню выбора героя
                CALL ChooseMenuRect                                             ; выбор прямоугольной области меню пиксельным курсором
                CP #01
                JP Z, Init.MainMenu                                             ; переход, если выбран возврат в главное меню

                DI
                LD (Graphics.Heroes.Draw.Picture), A
                CALL ClearScreen                                                ; обнулить все пиксели и атрибуты ZX-экрана
                CALL Graphics.Heroes.Draw
                LD BC, #0010
                LD DE, #160E
                LD A, #06
                CALL DrawFrame                                                  ; рисование рамки из восьми одноклеточных образцов с атрибутами
                CALL DrawHeroStory                                              ; вывод текстового описания выбранного героя из HERTXT
                LD A, (Graphics.Heroes.Draw.Picture)
                CP #02
                JR Z, .LastHeroText                                             ; переход, если у выбранного героя используется окончание последнего типа

                CP #07
                JR Z, .LastHeroText                                             ; переход, если у выбранного героя используется окончание последнего типа

                LD DE, Startup.GenerateArmy.ChooseHimText                       ; кнопка выбора мужского героя
                JR .ConfirmHero

.LastHeroText   LD DE, Startup.GenerateArmy.ChooseHerText                       ; кнопка выбора женского героя
.ConfirmHero    LD BC, #1518
                CALL DrawText                                                   ; вывести строку с нулевым терминатором и переходами строк
                LD BC, #1618
                LD DE, Startup.GenerateArmy.RefuseText                          ; кнопка отказа от выбранного героя
                CALL DrawText                                                   ; вывести строку с нулевым терминатором и переходами строк
                LD IX, Startup.GenerateArmy.HeroConfirm                         ; заголовок и прямоугольники подтверждения выбранного героя
                CALL ChooseMenuRect                                             ; выбор прямоугольной области меню пиксельным курсором
                CP #02
                JP Z, .NewGame                                                  ; переход, если выбран повтор выбора героя

                LD A, (Graphics.Heroes.Draw.Picture)
                DEC A
                LD (Startup.GenerateArmy.HeroID), A
                CALL RestoreScreen                                              ; восстановление полного экрана из сохранённого фона в банк 4
                LD BC, #0C08
                LD DE, #0A0E
                LD A, #47
                CALL DrawFrame                                                  ; рисование рамки из восьми одноклеточных образцов с атрибутами
                LD BC, #0E0E
                LD DE, Startup.GenerateArmy.DifficultyText                      ; приглашение выбрать сложность новой игры
                CALL DrawText                                                   ; вывести строку с нулевым терминатором и переходами строк
                LD IX, Startup.GenerateArmy.LevelMenu                           ; заголовок и прямоугольники выбора сложности
                CALL ChooseMenuRect                                             ; выбор прямоугольной области меню пиксельным курсором
                CP #04
                JP Z, Init.MainMenu                                             ; переход, если выбран возврат в главное меню

                LD (Startup.GenerateArmy.Difficulty), A
.ChooseName     CALL RestoreScreen                                              ; восстановление полного экрана из сохранённого фона в банк 4
                LD BC, #1004
                LD DE, #0616
                LD A, #47
                CALL DrawFrame                                                  ; рисование рамки из восьми одноклеточных образцов с атрибутами
                LD A, (Startup.GenerateArmy.HeroID)
                CP #01
                JR Z, .NamePrompt                                               ; переход, если герой относится к типу с первым вариантом приглашения имени

                CP #06
                JR Z, .NamePrompt                                               ; переход, если герой относится к типу с первым вариантом приглашения имени

                LD DE, Startup.GenerateArmy.DearMaleText                        ; обращение Уважаемый к выбранному герою
                JR .EnterName

.NamePrompt     LD DE, Startup.GenerateArmy.DearFemaleText                      ; обращение Уважаемая к выбранному герою

                ; ввод имени выбранного героя в рабочую запись состояния
.EnterName      LD BC, #120A
                CALL DrawText                                                   ; вывести строку с нулевым терминатором и переходами строк
                LD BC, #1213
                LD DE, Startup.GenerateArmy.EnterNameText                       ; приглашение ввести имя и подсказка отмены
                CALL DrawText                                                   ; вывести строку с нулевым терминатором и переходами строк
                LD HL, Startup.GenerateArmy.HeroID + FGameState.SaveName        ; восьмибайтное имя файла сохранения внутри создаваемого заголовка состояния
                LD DE, Startup.GenerateArmy.HeroID + FGameState.SaveName + 1    ; второй байт буфера имени, для заполнения пробелами через LDIR
                LD BC, #0008
                LD (HL), #20
                LDIR
                LD (HL), #00
                LD BC, #1411
                LD IX, Startup.GenerateArmy.HeroID + FGameState.SaveName        ; восьмибайтное имя файла сохранения внутри создаваемого заголовка состояния
                LD A, #08
                CALL EditText                                                   ; ввести строку ограниченной длины с мигающим курсором
                CP #0E
                JP Z, Init.MainMenu                                             ; переход, если редактирование имени отменено

                LD HL, Startup.GenerateArmy.HeroID + FGameState.SaveName        ; восьмибайтное имя файла сохранения внутри создаваемого заголовка состояния
                LD DE, TrDos.Descriptor                                         ; рабочий дескриптор имени и параметров файла TR-DOS
                LD BC, #0008
                LDIR
                CALL SetStateExt                                                ; установить тип файла состояния M и запросить диск состояний
                NOP
                NOP
                LD C, #0A
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
                BIT FILE_MISS_BIT, C                                            ; позиция бита результата поиска TR-DOS, C=#FF означает отсутствие файла, при находке C содержит номер 0..127
                JR NZ, .LoadPerson                                              ; переход, если файл с таким именем не найден и подтверждение перезаписи не требуется

                CALL RestoreScreen                                              ; восстановление полного экрана из сохранённого фона в банк 4
                LD BC, #0800
                LD DE, #061E
                LD A, #42
                CALL DrawFrame                                                  ; рисование рамки из восьми одноклеточных образцов с атрибутами
                LD DE, Startup.GenerateArmy.ReplaceText                         ; предупреждение о совпадении имени сохранения с предложением удалить прежнее
                LD BC, #0B02
                CALL DrawText                                                   ; вывести строку с нулевым терминатором и переходами строк
                LD IX, Startup.GenerateArmy.ReplaceMenu                         ; заголовок и прямоугольники подтверждения перезаписи
                CALL ChooseMenuRect                                             ; выбор прямоугольной области меню пиксельным курсором
                CP #02
                JP Z, .ChooseName                                               ; переход, если выбран возврат к выбору имени

                LD C, #12
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
.LoadPerson     CALL RestoreScreen                                              ; восстановление полного экрана из сохранённого фона в банк 4
                CALL PromptGameDisk                                             ; показать приглашение вставить диск с игрой и дождаться клавиши
                LD A, (Startup.GenerateArmy.HeroID)
                ADD A, #30
                LD (Startup.Interrupt.PersonFileID), A
                LD HL, Startup.Interrupt.PersonFile                             ; шаблон имени PERSONn с расширением C
                LD DE, Startup.GenerateArmy.Person                              ; место загрузки выбранного PERSONn, персональная часть FGameState
                CALL LoadFile                                                   ; загрузить именованный файл в заданную область через TR-DOS
                LD A, (Startup.GenerateArmy.HeroID)
                CP #07
                JP NZ, .InitialMoney                                            ; переход, если выбранный герой не требует особой настройки управления

                LD IX, Startup.GenerateArmy.Person + FPerson.UnitControl        ; коэффициенты управления PERSON, у PERSON7 первоначально пары диапазонов
                LD HL, Startup.GenerateArmy.Person + FPerson.UnitControl        ; коэффициенты управления PERSON, у PERSON7 первоначально пары диапазонов
                LD B, #19

                ; получение индивидуальных коэффициентов управления из заданных диапазонов героя
.ControlLoop    LD A, (IX + FByteRange.Max)
                SUB (IX + FByteRange.Min)
                LD E, A
                LD D, #00
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                LD A, (IX + FByteRange.Min)
                ADD A, E
                LD C, A
                LD DE, #0014
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                LD A, E
                OR A
                JR NZ, .ControlSpecial                                          ; переход, если случайный вариант управления ненулевой

                SLA C
                JR .StoreControl

.ControlSpecial CP #14
                JR NZ, .StoreControl                                            ; переход, если вариант управления отличается от 20

                SRL C
                INC C
.StoreControl   LD (HL), C
                INC IX
                INC IX
                INC HL
                DJNZ .ControlLoop

                ; выбор исходных денег по уровню сложности
.InitialMoney   LD A, (Startup.GenerateArmy.Difficulty)
                LD DE, #1388
                CP #01
                JR Z, .StoreMoney                                               ; переход, если выбран первый уровень начальных денег

                LD DE, #0FA0
                CP #02
                JR Z, .StoreMoney                                               ; переход, если выбран второй уровень начальных денег

                LD DE, #0BB8
.StoreMoney     LD (Startup.GenerateArmy.MoneyWord), DE
                XOR A
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD A, (Startup.GenerateArmy.Difficulty)
                ADD A, #30
                LD (Startup.Interrupt.ArmyFileLevel), A
                LD (Startup.Interrupt.StateFileLevel), A
                LD HL, Data.WorldObjects.CastlesCont1                           ; первый байт очищаемой области объектов будущего мира
                LD DE, Data.WorldObjects.CastlesCont1 + 1                       ; второй байт общего буфера объектов для очистки LDIR
                LD BC, #6849
                LD (HL), #00
                LDIR
                LD HL, Startup.Interrupt.WorldFile                              ; девять байтов имени STROENIA и расширения C
                LD DE, Data.WorldObjects.CastlesCont1                           ; место загрузки STROENIA в банк0
                CALL LoadFile                                                   ; загрузить именованный файл в заданную область через TR-DOS
                LD A, #01
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD HL, Startup.Interrupt.NamesFile                              ; девять байтов имени NAZWANIE и расширения C
                LD DE, StartupTables.CastleNames                                ; место загрузки NAZWANIE в банк1
                CALL LoadFile                                                   ; загрузить именованный файл в заданную область через TR-DOS
                LD A, #03
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD HL, Startup.Interrupt.UnitsFile                              ; девять байтов имени SOLDIERS и расширения C
                LD DE, UnitTypes.Peasants                                       ; место загрузки SOLDIERS в банк3 после шрифта
                CALL LoadFile                                                   ; загрузить именованный файл в заданную область через TR-DOS
                LD HL, Startup.Interrupt.WeightsFile                            ; шаблон имени WERWOINn с расширением C
                LD DE, StartupTables.SiteWeights                                ; место загрузки всего блока WERWOINn в банк3
                CALL LoadFile                                                   ; загрузить именованный файл в заданную область через TR-DOS
                LD HL, Startup.Interrupt.ManaFile                               ; шаблон имени MGPOWERn с расширением C
                LD DE, StartupTables.ManaPools                                  ; место загрузки и начало расходуемых групп параметров MGPOWERn в банке3
                CALL LoadFile                                                   ; загрузить именованный файл в заданную область через TR-DOS
                LD A, #06
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD HL, Startup.Interrupt.VersionFile                            ; девять байтов имени TEXT и расширения C
                LD DE, Memory.BankWindow                                        ; начало окна выбранного банка, загрузка либо восстановление его содержимого
                CALL LoadFile                                                   ; загрузить именованный файл в заданную область через TR-DOS
                LD A, #01

                ; загрузка четырёх карт и резервирование клеток, уже занятых строениями
.LoadContinent  PUSH AF
                PUSH AF
                ADD A, #09
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                POP AF
                ADD A, #30
                LD (Startup.Interrupt.MapFileID), A
                LD HL, Memory.BankWindow                                        ; начало окна выбранного банка, загрузка либо восстановление его содержимого
                LD DE, Memory.BankWindow + 1                                    ; второй байт окна выбранного банка при очистке LDIR
                LD BC, #3FFF
                LD (HL), #00
                LDIR
                LD HL, Startup.Interrupt.MapFile                                ; шаблон имени KARTAn с расширением C
                LD DE, Memory.BankWindow                                        ; начало окна выбранного банка, загрузка либо восстановление его содержимого
                CALL LoadFile                                                   ; загрузить именованный файл в заданную область через TR-DOS
                POP AF
                CALL MarkStructures                                             ; отметка занимаемых строениями клеток стартовых карт
                INC A
                CP #05
                JR NZ, .LoadContinent                                           ; переход, если ещё не загружены все четыре континента

                LD BC, (Startup.GenerateArmy.HeroPosition)
                LD A, #01
                CALL MapCellAddress                                             ; адрес клетки карты выбранного континента при создании игры
                SET MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты уже занята объектом при генерации
                DI
                LD BC, #0400
                LD DE, #0E1E
                LD A, #45
                CALL DrawFrame                                                  ; рисование рамки из восьми одноклеточных образцов с атрибутами
                LD HL, Screen.Attributes + 5 * Screen.RowBytes + 1              ; левая граница верхней полосы атрибутов рамки
                LD DE, Screen.Attributes + 5 * Screen.RowBytes + 2              ; второй атрибут верхней полосы для LDIR
                LD BC, #001D
                LD (HL), #40
                LDIR
                LD HL, Screen.Attributes + 18 * Screen.RowBytes + 1             ; левая граница нижней полосы атрибутов рамки
                LD DE, Screen.Attributes + 18 * Screen.RowBytes + 2             ; второй атрибут нижней полосы для LDIR
                LD BC, #001D
                LD (HL), #40
                LDIR
                XOR A
                LD (Startup.TickIntroText.Stopped), A
                XOR A
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                LD (Startup.PromptGameDisk.WorkContinent), A
                LD IX, Data.WorldObjects.CastlesCont1 + FCastle.Name            ; имя первого замка, затем шаг FCastle
                LD HL, Startup.PromptGameDisk.CastleLists + FMapList.Count      ; число записей первого континента в таблице CastleLists
                LD B, #04

                ; создание групп замков по континентам и назначение уникальных имён
.CastleGroups   PUSH BC
                LD B, (HL)
                INC HL
                INC HL
                INC HL
                INC HL
                LD A, (Startup.PromptGameDisk.WorkContinent)
                INC A
                LD (Startup.PromptGameDisk.WorkContinent), A
                PUSH HL
.CastleLoop     PUSH BC
                LD IY, StartupTables.CastleNames - 16                           ; позиция перед первым16байтным названием замка банка1
                LD B, #50
                LD A, #10
                CALL PickUnusedName                                             ; случайный выбор ещё не использованного имени с копированием в рабочий банк
                PUSH IX
                POP IY
                LD DE, #0011
                ADD IY, DE
                LD HL, StartupTables.CastleWeights - 26 * FWeightedTroop        ; смещённая база континентальных весов армий замков
                LD A, (Startup.PromptGameDisk.WorkContinent)
                CALL GenerateArmy                                               ; генерация от двух до пяти трёхбайтовых отрядов по весовой таблице
                LD DE, #0023
                ADD IX, DE
                POP BC
                DJNZ .CastleLoop

                POP HL
                POP BC
                DJNZ .CastleGroups

                LD HL, Startup.PromptGameDisk.OwnerCounts                       ; пятнадцать количеств замков, которые назначаются каждому правителю
                LD A, #01
.OwnerGroup     LD B, (HL)
.OwnerLoop      PUSH BC
                PUSH AF

                ; выбор ещё не занятого замка для очередного владельца
.ChooseCastle   LD DE, #004F
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                LD B, E
                INC B
                LD IX, Data.WorldObjects.CastlesCont1 + FCastle.Name - FCastle  ; база имён замков перед первым, случайный поиск сначала добавляет размер FCastle
                LD DE, #0023
.CastleOffset   ADD IX, DE
                DJNZ .CastleOffset

                LD A, (IX + FCastle.Owner - FCastle.Name)
                OR A
                JR NZ, .ChooseCastle                                            ; переход, если замок уже имеет владельца

                POP AF
                POP BC
                LD (IX + FCastle.Owner - FCastle.Name), A
                DJNZ .OwnerLoop

                INC HL
                INC A
                CP #10
                JR NZ, .OwnerGroup                                              ; переход, если ещё не распределены все группы владельцев

                LD IX, Data.WorldObjects.CastlesCont1 + FCastle.Name            ; имя первого замка, затем шаг FCastle
                LD B, #50
.NeutralCastle  LD A, (IX + FCastle.Owner - FCastle.Name)
                OR A
                JR NZ, .NextCastle                                              ; переход, если у нейтрального кандидата уже есть владелец

                LD DE, #003C
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                LD A, E
                CP #0F
                JR C, .StoreOwner                                               ; переход, если случайный номер владельца меньше 15

                LD E, #FE
.StoreOwner     INC E
                LD (IX + FCastle.Owner - FCastle.Name), E
.NextCastle     LD DE, #0023
                ADD IX, DE
                DJNZ .NeutralCastle

                LD IX, Data.WorldObjects.TownsCont1 + FTown.Name                ; имя первого города, затем шаг FTown
                LD HL, Startup.PromptGameDisk.TownLists + FMapList.Count        ; число записей первого континента в таблице TownLists
                LD B, #04

                ; создание городов, их уникальных названий и наборов предлагаемых отрядов
.TownGroups     PUSH BC
                LD B, (HL)
                INC HL
                INC HL
                INC HL
                INC HL
                PUSH HL
.TownLoop       PUSH BC
                PUSH IX
                LD IY, StartupTables.TownNames - 12                             ; позиция перед первым12байтным названием города банка1
                LD B, #A0
                LD A, #0C
                CALL PickUnusedName                                             ; случайный выбор ещё не использованного имени с копированием в рабочий банк
                LD DE, #0003
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                LD B, E
                LD A, B
                OR A
                JP Z, .NextTown                                                 ; переход, если случайная численность гарнизона равна нулю

                LD (Startup.PromptGameDisk.OfferCount), A
                LD (Startup.PromptGameDisk.TownName), IX
.TownOfferLoop  PUSH BC
                PUSH BC
.ChooseTownUnit LD DE, #00FE
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                LD IY, Startup.PromptGameDisk.TownWeights - FTownWeight         ; смещённая база весовых пар до первой записи
                LD A, E

                ; выбор типа городского отряда по накопленной вероятности
.TownUnitWeight INC IY
                INC IY
                CP (IY + FTownWeight.Threshold)
                JR NC, .TownUnitWeight                                          ; переход, если случайный отсчёт вышел за накопленный вес типа

                LD E, (IY + FTownWeight.UnitID)
.TownName       EQU $+2                                                         ; операнд IY адреса имени текущего города при проверке повторных предложений
                LD IY, #0000
                POP BC
                PUSH BC
                LD A, (Startup.PromptGameDisk.OfferCount)
                SUB B
                LD B, A

                ; отклонение типа, который уже включён в список предложений текущего города
.TestDuplicate  LD A, B
                OR A
                JR Z, .StoreTownUnit                                            ; переход, если в гарнизоне больше нет записей для проверки

                LD A, (IY + FTown.Army.Item0.ID - FTown.Name)
                CP E
                JR Z, .ChooseTownUnit                                           ; переход, если выбранный тип уже есть в гарнизоне

                DEC B
                INC IY
                INC IY
                INC IY
                JR .TestDuplicate

.StoreTownUnit  POP BC
                LD (IX + FTown.Army.Item0.ID - FTown.Name), E
                LD DE, #0028
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                LD A, E
                ADD A, #0A
                LD (IX + FTown.Army.Item0.Count.Low - FTown.Name), A
                LD (IX + FTown.Army.Item0.Count.High - FTown.Name), #00
                POP BC
                INC IX
                INC IX
                INC IX
                DJNZ .TownOfferLoop

.NextTown       POP IX
                POP BC
                LD DE, #001A
                ADD IX, DE
                DJNZ .TownLoop

                POP HL
                POP BC
                DEC B
                JP NZ, .TownGroups                                              ; переход, если ещё не обработаны все группы городов

                LD IX, Data.WorldObjects.TemplesCont1 + FTemple.Cult            ; поле секты первого храма, затем шаг FTemple
                ; для 50 храмов задаются секта 1..4 и изучаемое заклинание 1..10, IX указывает на FTemple.Cult
                LD B, #32
.TempleSpells   PUSH BC
                LD DE, #0003
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                INC E
                LD (IX + #00), E
                LD DE, #0009
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                INC E
                LD (IX + FTemple.Spell - FTemple.Cult), E
                LD DE, #0005
                ADD IX, DE
                POP BC
                DJNZ .TempleSpells

                LD IX, StartupWorld.SitesA                                      ; первая запись создаваемой группы SitesA, дальнейшие континенты расположены последовательно
                LD HL, Startup.PromptGameDisk.SitesALists                       ; четыре дескриптора первой категории шестибайтовых отрядов
                LD DE, #0006
                LD A, #01
                CALL CreateWanderers                                            ; создание четырёх континентальных групп случайных шестибайтовых отрядов
                LD IX, StartupWorld.SitesB                                      ; первая запись создаваемой группы SitesB, дальнейшие континенты расположены последовательно
                LD HL, Startup.PromptGameDisk.SitesBLists                       ; четыре дескриптора второй категории шестибайтовых отрядов
                LD DE, #0006
                LD A, #02
                CALL CreateWanderers                                            ; создание четырёх континентальных групп случайных шестибайтовых отрядов
                LD IX, StartupWorld.SitesC                                      ; первая запись создаваемой группы SitesC, дальнейшие континенты расположены последовательно
                LD HL, Startup.PromptGameDisk.SitesCLists                       ; четыре дескриптора третьей категории шестибайтовых отрядов
                LD DE, #0006
                LD A, #03
                CALL CreateWanderers                                            ; создание четырёх континентальных групп случайных шестибайтовых отрядов
                LD IX, StartupWorld.SitesD                                      ; первая запись создаваемой группы SitesD, дальнейшие континенты расположены последовательно
                LD HL, Startup.PromptGameDisk.SitesDLists                       ; четыре дескриптора четвёртой категории шестибайтовых отрядов
                LD DE, #0006
                LD A, #04
                CALL CreateWanderers                                            ; создание четырёх континентальных групп случайных шестибайтовых отрядов
                LD DE, #0003
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                LD A, E
                INC A
                LD (Startup.GenerateArmy.PuzzleMap), A

                ; поиск места цели, вокруг которого свободен весь квадрат карты 5 на 5
.FindPuzzleSite CALL RandomMapPos                                               ; выбор случайных внутренних координат стратегической карты
                LD A, (Startup.GenerateArmy.PuzzleMap)
                CALL MapCellAddress                                             ; адрес клетки карты выбранного континента при создании игры
                LD A, (HL)
                AND #3F
                JR Z, .CheckPuzzleBox                                           ; переход, если нулевой класс местности допускает проверку свободной площадки

                CP #09
                JR C, .FindPuzzleSite                                           ; переход, если класс местности 1..8 не подходит для головоломки

.CheckPuzzleBox PUSH BC
                POP IX
                DEC B
                DEC B
                DEC C
                DEC C
                LD A, (Startup.GenerateArmy.PuzzleMap)
                CALL MapCellAddress                                             ; адрес клетки карты выбранного континента при создании игры
                LD DE, #009C
                LD B, #05
.PuzzleRow      LD C, #05
.PuzzleCell     BIT MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты уже занята объектом при генерации
                JR NZ, .FindPuzzleSite                                          ; переход, если площадка головоломки пересекается с занятым объектом

                INC HL
                DEC C
                JR NZ, .PuzzleCell                                              ; переход, если ещё не проверены все клетки текущей строки площадки

                ADD HL, DE
                DJNZ .PuzzleRow

                PUSH IX
                POP BC
                LD (Startup.GenerateArmy.PuzzlePos), BC
                DEC C
                DEC C
                DEC B
                DEC B
                LD A, (Startup.GenerateArmy.PuzzleMap)
                CALL MapCellAddress                                             ; адрес клетки карты выбранного континента при создании игры
                LD DE, Startup.GenerateArmy.Person + FPerson.PuzzleTiles        ; 25байт эталонного участка карты головоломки
                LD B, #05

                ; сохранение эталонного фрагмента 5 на 5 для карты цели
.CopyPuzzleRow  PUSH BC
                LDI
                LDI
                LDI
                LDI
                LDI
                LD BC, #009C
                ADD HL, BC
                POP BC
                DJNZ .CopyPuzzleRow

                XOR A
                LD (Startup.PromptGameDisk.WorkContinent), A
                LD IX, StartupWorld.Items                                       ; первая запись создаваемой группы Items, дальнейшие континенты расположены последовательно
                LD HL, Startup.PromptGameDisk.ItemLists + FMapList.Count        ; число записей первого континента в таблице ItemLists
                LD B, #04

                ; размещение пятибайтовых предметов на свободных клетках континентов
.ItemGroups     PUSH BC
                LD B, (HL)
                INC HL
                INC HL
                INC HL
                INC HL
                LD A, (Startup.PromptGameDisk.WorkContinent)
                INC A
                LD (Startup.PromptGameDisk.WorkContinent), A
                PUSH HL
.ItemLoop       PUSH BC
.FindItemCell   CALL RandomMapPos                                               ; выбор случайных внутренних координат стратегической карты
                LD A, (Startup.PromptGameDisk.WorkContinent)
                CALL MapCellAddress                                             ; адрес клетки карты выбранного континента при создании игры
                BIT MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты уже занята объектом при генерации
                JR NZ, .FindItemCell                                            ; переход, если клетка предмета уже занята объектом

                LD A, (HL)
                AND #3F
                JR NZ, .FindItemCell                                            ; переход, если тип местности не подходит предмету

                SET MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты уже занята объектом при генерации
                XOR A
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                LD (IX + FMapItem.Flags), #00
                LD (IX + FMapItem.X), C
                LD (IX + FMapItem.Y), B
                LD DE, #0003
                ADD IX, DE
                POP BC
                DJNZ .ItemLoop

                POP HL
                POP BC
                DJNZ .ItemGroups

                LD IX, StartupWorld.MapTroops                                   ; первая запись создаваемой группы MapTroops, дальнейшие континенты расположены последовательно
                LD HL, Startup.PromptGameDisk.TroopLists + FMapList.Count       ; число записей первого континента в таблице TroopLists
                XOR A
                LD (Startup.PromptGameDisk.WorkContinent), A
                LD B, #04

                ; создание шестибайтовых групп отрядов с выбором типа и количества по весовой таблице
.TroopGroups    PUSH BC
                LD A, (Startup.PromptGameDisk.WorkContinent)
                INC A
                LD (Startup.PromptGameDisk.WorkContinent), A
                LD B, (HL)
                INC HL
                INC HL
                INC HL
                INC HL
                PUSH HL
.TroopLoop      PUSH BC
.FindTroopCell  CALL RandomMapPos                                               ; выбор случайных внутренних координат стратегической карты
                LD A, (Startup.PromptGameDisk.WorkContinent)
                CALL MapCellAddress                                             ; адрес клетки карты выбранного континента при создании игры
                BIT MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты уже занята объектом при генерации
                JR NZ, .FindTroopCell                                           ; переход, если клетка отряда уже занята объектом

                LD A, (HL)
                AND #3F
                CP #09
                JR NC, .FindTroopCell                                           ; переход, если тип местности не допускает размещения отряда

                SET MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты уже занята объектом при генерации
                LD D, #20
                OR A
                JR NZ, .StoreTroopCell                                          ; переход, если выбран водный класс местности, режим группы остаётся водным

                LD D, #00
.StoreTroopCell XOR A
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                LD (IX + FMapTroop.Flags), D
                LD (IX + FMapTroop.X), C
                LD (IX + FMapTroop.Y), B
                LD A, #03
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                LD DE, #00FE
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                LD A, E
                LD IY, StartupTables.SiteWeights - 26 * FWeightedTroop          ; смещённая база весов гарнизонов до первого континента и первой записи
                LD BC, (Startup.PromptGameDisk.CastleIndex)
                LD DE, #0096
.TroopTable     ADD IY, DE
                DJNZ .TroopTable

                LD DE, #0006
.TroopWeight    ADD IY, DE
                CP (IY + FWeightedTroop.Threshold)
                JR NC, .TroopWeight                                             ; переход, если случайный отсчёт вышел за накопленный вес типа

                LD C, (IY + FWeightedTroop.UnitID)
                LD E, (IY + FWeightedTroop.CountRange.Low)
                LD D, (IY + FWeightedTroop.CountRange.High)
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                LD L, (IY + FWeightedTroop.BaseCount.Low)
                LD H, (IY + FWeightedTroop.BaseCount.High)
                ADD HL, DE
                XOR A
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                LD (IX + FMapTroop.ID), C
                LD (IX + FMapTroop.Count.Low), L
                LD (IX + FMapTroop.Count.High), H
                LD DE, #0006
                ADD IX, DE
                POP BC
                DEC B
                JP NZ, .TroopLoop                                               ; переход, если ещё не созданы все отряды группы

                POP HL
                POP BC
                DEC B
                JP NZ, .TroopGroups                                             ; переход, если ещё не обработаны все группы отрядов

                XOR A
                LD (Startup.PromptGameDisk.WorkContinent), A
                LD HL, StartupTables.ManaPools                                  ; место загрузки и начало расходуемых групп параметров MGPOWERn в банке3
                LD (Startup.PromptGameDisk.ArmyPreset), HL
                LD IX, StartupWorld.MapArmies                                   ; первая запись создаваемой группы MapArmies, дальнейшие континенты расположены последовательно
                LD HL, Startup.PromptGameDisk.ArmyLists + FMapList.Count        ; число записей первого континента в таблице ArmyLists
                LD B, #04

                ; создание подвижных армий с именами и собственным составом отрядов
.ArmyGroups     PUSH BC
                LD B, (HL)
                INC HL
                INC HL
                INC HL
                INC HL
                LD A, (Startup.PromptGameDisk.WorkContinent)
                INC A
                LD (Startup.PromptGameDisk.WorkContinent), A
                PUSH HL
.ArmyLoop       PUSH BC
.FindArmyCell   CALL RandomMapPos                                               ; выбор случайных внутренних координат стратегической карты
                LD A, (Startup.PromptGameDisk.WorkContinent)
                CALL MapCellAddress                                             ; адрес клетки карты выбранного континента при создании игры
                BIT MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты уже занята объектом при генерации
                JR NZ, .FindArmyCell                                            ; переход, если клетка армии уже занята объектом

                LD A, (HL)
                AND #3F
                CP #09
                JR NC, .FindArmyCell                                            ; переход, если тип местности не допускает размещения армии

                SET MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты уже занята объектом при генерации
                LD D, #20
                OR A
                JR NZ, .StoreArmyCell                                           ; переход, если выбран водный класс местности, режим группы остаётся водным

                LD D, #00
.StoreArmyCell  XOR A
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                LD (IX + FMapArmy.Flags), D
                LD (IX + FMapArmy.X), C
                LD (IX + FMapArmy.Y), B
                PUSH IX
                POP IY
                LD DE, #0007
                ADD IY, DE
                LD HL, StartupTables.ArmyWeights - 26 * FWeightedTroop          ; смещённая база континентальных весов подвижных армий
                LD A, (Startup.PromptGameDisk.WorkContinent)
                CALL GenerateArmy                                               ; генерация от двух до пяти трёхбайтовых отрядов по весовой таблице
                LD A, #03
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
.ArmyPreset     EQU $+2                                                         ; операнд IY текущей пятибайтовой группы параметров внешних армий
                LD IY, #0000
                LD B, (IY + FArmyManaPool.Mana.Low)
                LD C, (IY + FArmyManaPool.Mana.High)
                LD D, (IY + FArmyManaPool.ManaRegen.Low)
                LD E, (IY + FArmyManaPool.ManaRegen.High)
                XOR A
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                LD (IX + FMapArmy.Mana.Low), B
                LD (IX + FMapArmy.Mana.High), C
                LD (IX + FMapArmy.ManaRegen.Low), D
                LD (IX + FMapArmy.ManaRegen.High), E
                LD A, #03
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                DEC (IY + FArmyManaPool.Remaining)
                JR NZ, .NextMapArmy                                             ; переход, если в шаблоне армии остались отряды

                LD DE, #0005
                ADD IY, DE
                LD (Startup.PromptGameDisk.ArmyPreset), IY
.NextMapArmy    LD DE, #0016
                ADD IX, DE
                POP BC
                DEC B
                JP NZ, .ArmyLoop                                                ; переход, если ещё не созданы все армии группы

                POP HL
                POP BC
                DEC B
                JP NZ, .ArmyGroups                                              ; переход, если ещё не обработаны все группы армий

                ; размещение доброго рассказчика на свободной клетке первого континента
.PlaceGoodStory CALL RandomMapPos                                               ; выбор случайных внутренних координат стратегической карты
                LD A, #01
                CALL MapCellAddress                                             ; адрес клетки карты выбранного континента при создании игры
                LD A, (HL)
                BIT MAP_BUSY_BIT, A                                             ; флаг, клетка стратегической карты уже занята объектом при генерации
                JR NZ, .PlaceGoodStory                                          ; переход, если место положительной истории уже занято

                AND #3F
                JR NZ, .PlaceGoodStory                                          ; переход, если рассказчик не может быть размещён в ненулевом классе местности

                LD (Startup.GenerateArmy.GoodStoryPos), BC
                LD A, #01
                LD (Startup.GenerateArmy.GoodStoryMap), A
                SET MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты уже занята объектом при генерации
                LD DE, #0003
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                INC E
                LD A, E
                LD (Startup.GenerateArmy.BadStoryMap), A

                ; размещение враждебного рассказчика на свободной клетке выбранного континента
.PlaceBadStory  CALL RandomMapPos                                               ; выбор случайных внутренних координат стратегической карты
                LD A, E
                CALL MapCellAddress                                             ; адрес клетки карты выбранного континента при создании игры
                LD A, (HL)
                BIT MAP_BUSY_BIT, A                                             ; флаг, клетка стратегической карты уже занята объектом при генерации
                JR NZ, .PlaceBadStory                                           ; переход, если место отрицательной истории уже занято

                AND #3F
                JR NZ, .PlaceBadStory                                           ; переход, если рассказчик не может быть размещён в ненулевом классе местности

                LD (Startup.GenerateArmy.BadStoryPos), BC
                LD A, #FF
                LD (Startup.TickIntroText.Stopped), A
                CALL RestoreScreen                                              ; восстановление полного экрана из сохранённого фона в банк 4
                XOR A
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                LD HL, Startup.GenerateArmy.HeroID + FGameState.SaveName        ; восьмибайтное имя файла сохранения внутри создаваемого заголовка состояния
                LD DE, TrDos.Descriptor                                         ; рабочий дескриптор имени и параметров файла TR-DOS
                LD BC, #0008
                LDIR
                CALL SetStateExt                                                ; установить тип файла состояния M и запросить диск состояний
                NOP
                NOP
                LD HL, #0000
                LD DE, #8B00
                LD C, #0B
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
                LD HL, Startup.GenerateArmy.HeroID + FGameState.SaveName        ; восьмибайтное имя файла сохранения внутри создаваемого заголовка состояния
                LD DE, TrDos.Descriptor                                         ; рабочий дескриптор имени и параметров файла TR-DOS
                LD BC, #0008
                LDIR
                LD HL, Startup.GenerateArmy.HeroID
                LD DE, #00FF
                CALL InvertState                                                ; побайтовая инверсия блока данных состояния
                LD DE, (TrDos.FileSector)
                LD HL, Startup.GenerateArmy.HeroID
                LD BC, #0106
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
                LD HL, Data.WorldObjects.CastlesCont1                           ; первый блок сохраняемого состояния объектов мира
                LD DE, #2859
                CALL InvertState                                                ; побайтовая инверсия блока данных состояния
                LD DE, (TrDos.NextSector)
                LD A, #01
                NOP
                NOP
                NOP
                LD HL, Data.WorldObjects.CastlesCont1                           ; первый блок сохраняемого состояния объектов мира
                LD BC, #2906
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
                LD HL, StartupWorld.MapArmies                                   ; второй блок сохраняемого состояния, подвижные армии
                LD DE, #3FEF
                CALL InvertState                                                ; побайтовая инверсия блока данных состояния
                LD DE, (TrDos.NextSector)
                LD A, #2A
                NOP
                NOP
                NOP
                LD HL, StartupWorld.MapArmies                                   ; второй блок сохраняемого состояния, подвижные армии
                LD BC, #4006
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
                LD A, #01
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD HL, Memory.BankWindow                                        ; начало окна выбранного банка, загрузка либо восстановление его содержимого
                LD DE, Memory.BankWindow + 1                                    ; второй байт окна выбранного банка при очистке LDIR
                LD BC, #3FFF
                LD (HL), #00
                LDIR
                LD HL, Memory.BankWindow                                        ; начало окна выбранного банка, загрузка либо восстановление его содержимого
                LD DE, #20CF
                CALL InvertState                                                ; побайтовая инверсия блока данных состояния
                LD DE, (TrDos.NextSector)
                LD A, #6A
                NOP
                NOP
                NOP
                LD HL, Memory.BankWindow                                        ; начало окна выбранного банка, загрузка либо восстановление его содержимого
                LD BC, #2106
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
                LD HL, TrDos.Descriptor                                         ; рабочий дескриптор имени и параметров файла TR-DOS
                JP Init.LoadStateFile

.TownWeights    EQU $+1                                                         ; пары накопленного порога и типа предложений городского гарнизона
.OfferCount     DB #00, #7D, #01, #C8, #02, #E1, #03, #EB                       ; число предложений отрядов текущего города
                DB #04, #FA, #05, #FF, #06, #00, #00, #00
.OwnerCounts    EQU $+2                                                         ; пятнадцать количеств замков, которые назначаются каждому правителю
                DB #00, #00, #01, #01, #01, #02, #02, #02
                DB #03, #03, #04, #04, #05, #06, #07, #08
                DB #09
.NameBase       DB #00, #00, #00, #00, #00, #00, #00                            ; сохранённая база перед первой записью имён банка 1
                DB #00
.CastleIndex    DB #00                                                          ; смещённая база перед первым дескриптором замков, старший байт также служит счётчиком континента
.CastleLists    EQU $+3                                                         ; четыре дескриптора FMapList замков по континентам
.WorkContinent  DB #00, #00, #00, #31, #7A, #1A                                 ; номер текущего континента при генерации объектов
                DB #00, #BF, #7D, #14, #00, #7B, #80, #17
.TownLists      EQU $+5                                                         ; четыре дескриптора FMapList городов по континентам
                DB #00, #A0, #83, #0B, #00, #21, #85, #29
                DB #00, #4B, #89, #32, #00, #5F, #8E, #1E
.TempleLists    EQU $+5                                                         ; четыре дескриптора FMapList храмов по континентам
                DB #00, #6B, #91, #27, #00, #61, #95, #0A
                DB #00, #93, #95, #0F, #00, #DE, #95, #07
.SitesALists    EQU $+5                                                         ; четыре дескриптора первой категории шестибайтовых отрядов
                DB #00, #01, #96, #12, #00, #5B, #96, #08
                DB #00, #8B, #96, #09, #00, #C1, #96, #07
.SitesBLists    EQU $+5                                                         ; четыре дескриптора второй категории шестибайтовых отрядов
                DB #00, #EB, #96, #06, #00, #0F, #97, #05
                DB #00, #2D, #97, #0A, #00, #69, #97, #07
.SitesCLists    EQU $+5                                                         ; четыре дескриптора третьей категории шестибайтовых отрядов
                DB #00, #93, #97, #08, #00, #C3, #97, #0B
                DB #00, #05, #98, #06, #00, #29, #98, #06
.SitesDLists    EQU $+5                                                         ; четыре дескриптора четвёртой категории шестибайтовых отрядов
                DB #00, #4D, #98, #07, #00, #77, #98, #08
                DB #00, #A7, #98, #08, #00, #D7, #98, #07
.ItemLists      EQU $+5                                                         ; четыре дескриптора находок на карте
                DB #00, #01, #99, #07, #00, #2B, #99, #96
                DB #00, #ED, #9A, #96, #00, #AF, #9C, #96
.TroopLists     EQU $+5                                                         ; четыре дескриптора странствующих групп отрядов
                DB #00, #71, #9E, #96, #00, #33, #A0, #14
                DB #00, #AB, #A0, #1E, #00, #5F, #A1, #1E
.ArmyLists      EQU $+5                                                         ; четыре дескриптора подвижных внешних армий
                DB #00, #13, #A2, #14, #00, #8B, #A2, #A0
                DB #00, #4B, #B0, #B4, #00, #C3, #BF, #BE
                DB #00, #17, #D0, #D6, #00, #21, #E0, #5A
                DB #11, #E1, #5A, #01, #1F, #00, #36, #42
                DB #ED, #B0, #01, #00, #17, #11, #91, #6D
.GameDiskText   EQU $+4                                                         ; приглашение вставить диск с игрой
                DB #CD, #E4, #70, #C9, #82, #E1, #E2, #A0
                DB #A2, #EC, #E2, #A5, #20, #A4, #A8, #E1
                DB #AA, #A5, #E2, #E3, #20, #E1, #20, #A8
                DB #A3, #E0, #AE, #A9, #20, #2E, #2E, #2E
                DB #2E, #20, #20, #20, #20, #00, #20, #20
                DB #20, #20, #20, #20, #20, #20, #00
