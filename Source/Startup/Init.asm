
; -----------------------------------------
; настройка памяти, начальное меню и подготовка нового либо сохранённого мира
; Загружает RAMDRIVE по каталожному адресу #7D34 и вызывает его для проверки 256 К и установки
; #5FA1. Устанавливает стек #629C, вектор IM 2 на #6161, очищает банк 8. Загружает шрифт,
; изображения и тексты. Главное меню #63AC предлагает новую игру, чтение сохранения и заставку.
; Ветка #63F4 читает каталог TR-DOS, считает действующие .M, строит страницы по 15 имён, затем
; читает состояние героя и три блока сохранения, восстанавливая их инверсией. Ветка #65DF выбирает
; героя, сложность, имя файла и проверяет его совпадение с существующим. Для нового мира загружает
; PERSONn, формирует начальные армии, объекты и карты. В конце подготавливает банки состояния,
; загружает head.co и передаёт ему управление. Загрузка HERIMG перекрывает последний байт
; исходного BL3 по #7D33, поэтому CALL #7D33 относится к графическому распаковщику другого файла.
; In:
;   IY=#5C3A, доступный TR-DOS и 256 К по одной из поддерживаемых схем
; Out:
;   инициализированное состояние для head.co либо повтор начального меню
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY
; -----------------------------------------
Init            LD HL, Startup.Interrupt.DriverFile                             ; девять байтов имени RAMDRIVE и расширения C
                LD DE, TrDos.Descriptor                                         ; рабочий дескриптор имени и параметров файла TR-DOS
                LD BC, #0009
                LDIR
                XOR A
                LD (TrDos.Error), A
                LD C, #0E
                CALL TrDos.Service                                              ; вызов сервиса TR-DOS, номер операции находится в C
                CALL MemoryDriver.Detect                                        ; точка RAMDRIVE после загрузки, определяет память и устанавливает драйвер
                NOP
                NOP
                DI
                LD HL, Startup.Interrupt.StackTop                               ; исходный верх стека BL3 перед таблицей имён загружаемых файлов
                LD SP, HL
                LD HL, Startup.IM2Vectors                                       ; первый байт таблицы векторов IM2
                LD DE, Startup.IM2Vectors + 1                                   ; второй байт таблицы векторов, источник LDIR отстаёт на1
                LD (HL), #61
                LD BC, #0100
                LDIR
                LD A, #60
                LD I, A
                IM 2
                LD A, #08
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD HL, Memory.BankWindow                                        ; начало окна выбранного банка, загрузка либо восстановление его содержимого
                LD DE, Memory.BankWindow + 1                                    ; второй байт окна выбранного банка при очистке LDIR
                LD BC, #3FFF
                LD (HL), #00
                LDIR
                LD HL, (System.Frames)
                LD (Startup.RandomRange.SeedX), HL
                LD HL, (System.Frames+FWord.High)
                LD (Startup.RandomRange.SeedY), HL
                LD A, R
                LD L, A
                LD H, A
                LD (Startup.RandomRange.SeedZ), HL
                LD A, #04
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD HL, Startup.Interrupt.IntroFile                              ; девять байтов имени PRES и расширения C
                LD DE, Presentation.screen                                      ; место загрузки PRES, начальный экран, логический банк4
                CALL LoadFile                                                   ; загрузить именованный файл в заданную область через TR-DOS
                LD A, #03
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD HL, Startup.Interrupt.FontFile                               ; девять байтов имени DATA2 и расширения C
                LD DE, StartupTables.FontGlyphs                                 ; место загрузки шрифта DATA2, логический банк3
                CALL LoadFile                                                   ; загрузить именованный файл в заданную область через TR-DOS
                XOR A
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD HL, Startup.Interrupt.PortraitFile                           ; девять байтов имени HERIMG и расширения C
                LD DE, Graphics.Heroes.Draw                                     ; точка распаковщика HERIMG после загрузки поверх хвоста BL3
                CALL LoadFile                                                   ; загрузить именованный файл в заданную область через TR-DOS
                LD HL, Startup.Interrupt.HeroTextFile                           ; девять байтов имени HERTXT и расширения C
                LD DE, StartupTables.HeroStories                                ; место загрузки HERTXT в банк0
                CALL LoadFile                                                   ; загрузить именованный файл в заданную область через TR-DOS
                LD A, #04
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                CALL Presentation.Present
.MainMenu       XOR A
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                CALL RestoreScreen                                              ; восстановление полного экрана из сохранённого фона в банк 4
                LD BC, #1004
                LD DE, #0616
                LD A, #45
                CALL DrawFrame                                                  ; рисование рамки из восьми одноклеточных образцов с атрибутами
                LD BC, #120C
                LD DE, Startup.GenerateArmy.NewGameText                         ; кнопка начала новой игры
                CALL DrawText                                                   ; вывести строку с нулевым терминатором и переходами строк
                LD BC, #1408
                LD DE, Startup.GenerateArmy.LoadGameText                        ; кнопка продолжения отложенной игры
                CALL DrawText                                                   ; вывести строку с нулевым терминатором и переходами строк
                LD BC, #160D
                LD DE, Startup.GenerateArmy.ReplayIntroTxt                      ; кнопка повторного показа вступления
                CALL DrawText                                                   ; вывести строку с нулевым терминатором и переходами строк
                LD IX, Startup.GenerateArmy.MainMenuHeader                      ; заголовок и прямоугольники главного меню
                CALL ChooseMenuRect                                             ; выбор прямоугольной области меню пиксельным курсором
                CP #03
                JR NZ, .LoadGame                                                ; переход, если выбрано не вступление

                LD A, #04
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                CALL Presentation.Present
                JP .MainMenu

                ; чтение каталога диска состояний и подсчёт неудалённых файлов типа M
.LoadGame       CP #02
                JP NZ, PromptGameDisk.NewGame                                   ; переход, если выбрана не загрузка сохранения

                CALL SelectStateBank                                            ; запросить диск с состояниями и выбрать банк 1
                NOP
                NOP
                LD HL, StartupTables.Directory                                  ; буфер чтения8секторов каталога TR-DOS, логический банк3
                LD DE, #0000
                LD BC, #0805
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
                LD IX, StartupTables.Directory                                  ; первая16байтная запись каталога сохранений в банке3
                LD B, #00
.CountSaves     LD A, (IX + FTrdosEntry.Name)
                OR A
                JR Z, .ChooseSave                                               ; переход, если достигнут конец каталога диска

                CP #01
                JR Z, .NextSaveRecord                                           ; переход, если запись каталога удалена

                LD A, (IX + FTrdosEntry.Type)
                CP #4D
                JR NZ, .NextSaveRecord                                          ; переход, если запись не имеет сигнатуры сохранения M

                INC B
.NextSaveRecord LD DE, #0010
                ADD IX, DE
                JR .CountSaves

.ChooseSave     LD A, B
                OR A
                JP Z, .MainMenu                                                 ; переход, если на диске нет сохранений

                CP #01
                JP Z, .LoadSave                                                 ; переход, если на диске имеется ровно одно сохранение

                LD (Startup.ListSaveNames.SaveCount), A
                LD A, #01
                LD (Startup.ListSaveNames.FirstSave), A
                CALL RestoreScreen                                              ; восстановление полного экрана из сохранённого фона в банк 4
                LD BC, #040C
                LD DE, #0A12
                LD A, #06
                CALL DrawFrame                                                  ; рисование рамки из восьми одноклеточных образцов с атрибутами
                LD BC, #0815
                LD DE, Startup.GenerateArmy.SaveListText                        ; заголовок списка отложенных игр
                CALL DrawText                                                   ; вывести строку с нулевым терминатором и переходами строк

                ; вывод страницы имён сохранений с отдельными кнопками перелистывания
.DrawSaveMenu   LD BC, #0000
                LD DE, #160A
                LD A, #06
                CALL DrawFrame                                                  ; рисование рамки из восьми одноклеточных образцов с атрибутами
                LD BC, #0203
                LD DE, #0106
                LD IX, Startup.SaveBarPixels                                    ; пиксели полосы списка сохранений
                CALL DrawRawSprite                                              ; вывести непрозрачный прямоугольный спрайт с атрибутами
                LD BC, #1403
                LD DE, #0106
                LD IX, Startup.SaveBarPixels                                    ; пиксели полосы списка сохранений
                CALL DrawRawSprite                                              ; вывести непрозрачный прямоугольный спрайт с атрибутами
                LD BC, #1505
                LD DE, Startup.GenerateArmy.BackText                            ; надпись Назад для меню сохранений, резидентный BL3 до загрузки STROENIA
                CALL DrawText                                                   ; вывести строку с нулевым терминатором и переходами строк
                CALL ListSaveNames                                              ; вывод страницы до пятнадцати имён сохранений
.ReadSaveMenu   LD IX, Startup.GenerateArmy.SaveMenu
                CALL ChooseMenuRect                                             ; выбор прямоугольной области меню пиксельным курсором
                CP #05
                JP Z, .MainMenu                                                 ; переход, если выбран возврат в главное меню

                CP #01
                JR NZ, .TestNextPage                                            ; переход, если не выбрана предыдущая страница сохранений

.PreviousPage   LD A, (Startup.ListSaveNames.FirstSave)
                CP #01
                JR Z, .ReadSaveMenu                                             ; переход, если уже открыта первая страница сохранений

                CP #10
                JR C, .FirstSavePage                                            ; переход, если до первой страницы осталось меньше 15 записей

                SUB #0F
                LD (Startup.ListSaveNames.FirstSave), A
                JR .DrawSaveMenu

.FirstSavePage  LD A, #01
                LD (Startup.ListSaveNames.FirstSave), A
                JR .DrawSaveMenu

.TestNextPage   CP #04
                JR Z, .PreviousPage                                             ; переход, если выбрана верхняя кнопка предыдущей страницы

                CP #02
                JR NZ, .ChooseSaveRow                                           ; переход, если не выбрана следующая страница сохранений

.NextSavePage   LD A, (Startup.ListSaveNames.FirstSave)
                LD HL, Startup.ListSaveNames.SaveCount
                ADD A, #0E
                CP (HL)
                JR NC, .ReadSaveMenu                                            ; переход, если следующая страница выходит за количество сохранений

                INC A
                LD (Startup.ListSaveNames.FirstSave), A
                JP .DrawSaveMenu

.ChooseSaveRow  CP #03
                JR Z, .NextSavePage                                             ; переход, если выбрана нижняя кнопка следующей страницы

                SUB #06
                LD HL, Startup.ListSaveNames.FirstSave
                ADD A, (HL)

                ; перенос имени выбранного сохранения в служебные поля TR-DOS
.LoadSave       CALL FindSaveRecord                                             ; поиск N-й неудалённой записи типа M в буфере каталога
                PUSH IX
                NOP
                NOP
                NOP
                POP HL
.LoadStateFile  PUSH HL
                NOP
                NOP
                NOP
                POP HL
                LD DE, TrDos.Descriptor                                         ; рабочий дескриптор имени и параметров файла TR-DOS
                LD BC, #0008
                LDIR
                LD A, #4D
                LD (TrDos.Descriptor+FTrdosEntry.Type), A
                LD C, #0A
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
                LD A, C
                LD C, #08
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
                LD A, #03
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD DE, (TrDos.FileSector)
                LD BC, #0105
                LD HL, StartupTables.SaveHeader                                 ; буфер заголовка загружаемого сохранения, банк3
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
                LD HL, StartupTables.SaveHeader                                 ; буфер заголовка загружаемого сохранения, банк3
                LD DE, #00FF
                CALL InvertState                                                ; побайтовая инверсия блока данных состояния
                XOR A
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD DE, (TrDos.NextSector)
                LD A, #01
                NOP
                NOP
                NOP
                LD BC, #2905
                LD HL, Memory.BankWindow                                        ; начало окна выбранного банка, загрузка либо восстановление его содержимого
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
                LD HL, Memory.BankWindow                                        ; начало окна выбранного банка, загрузка либо восстановление его содержимого
                LD DE, #2859
                CALL InvertState                                                ; побайтовая инверсия блока данных состояния
                LD A, #01
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD DE, (TrDos.NextSector)
                LD A, #2A
                NOP
                NOP
                NOP
                LD BC, #4005
                LD HL, Memory.BankWindow                                        ; начало окна выбранного банка, загрузка либо восстановление его содержимого
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
                LD HL, Memory.BankWindow                                        ; начало окна выбранного банка, загрузка либо восстановление его содержимого
                LD DE, #3FEF
                CALL InvertState                                                ; побайтовая инверсия блока данных состояния
                LD A, #0B
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD DE, (TrDos.NextSector)
                LD A, #6A
                NOP
                NOP
                NOP
                LD BC, #2105
                LD HL, Memory.BankWindow                                        ; начало окна выбранного банка, загрузка либо восстановление его содержимого
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным переходом в IM 1
                LD HL, Memory.BankWindow                                        ; начало окна выбранного банка, загрузка либо восстановление его содержимого
                LD DE, #20CF
                CALL InvertState                                                ; побайтовая инверсия блока данных состояния
                XOR A
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD HL, Startup.Init.ResumeStub                                  ; исходные97байтов загрузчика, копируемые Init в FF00
                LD DE, Startup.ResumeEntry                                      ; перемещённый окончательный загрузчик head.co
                LD BC, #0061
                LDIR
                JP Startup.ResumeEntry                                          ; перемещённый окончательный загрузчик head.co

.ResumeStub     EQU $                                                           ; исходные97байтов загрузчика, копируемые Init в FF00
                DB #CD, #DE, #6D, #00, #F9, #21, #F8, #62
                DB #11, #DD, #5C, #01, #09, #00, #ED, #B0
                DB #AF, #32, #10, #5D, #21, #5E, #61, #0E
                DB #0E, #3E, #3F, #ED, #47, #FD, #21, #3A
                DB #5C, #3E, #03, #ED, #56, #FB, #CD, #13
                DB #3D, #C3, #5E, #61
