
; -----------------------------------------
; инициализировать стек, IM 2, ресурсы и главный цикл
; SP=#62A5, #6000..#6100 заполнены #61, I=#60, IM 2, загружаются ресурсы по именам из таблицы
; #62A7..#631B, в конце #6470 начинается цикл игры
; In:
;   таблицы состояния, подготовленные BL3, переключатель #5FA1, диск с ресурсами
; Out:
;   SP=#62A5, I=#60, IM2, векторная область #6000..#6100 заполнена #61, ресурсы загружены, далее
;   бесконечный главный цикл #6470
; Corrupt:
;   HL, DE, BC, AF, IX, IY, SP, I, IM, IFF и память инициализируемых ресурсов, возврата по
;   исходному стеку нет
; -----------------------------------------
Initialize      DI
                LD HL, Engine.Interrupt.StackTop                                ; верх существующего стека перед таблицей имён загружаемых файлов
                LD SP, HL
                LD HL, System.IM2Vectors                                        ; первый байт таблицы векторов IM2
                LD DE, System.IM2Vectors + 1                                    ; следующий байт при заполнении таблицы IM2
                LD (HL), #61
                LD BC, #0100
                LDIR
                LD A, #60
                LD I, A
                IM 2
                CALL ClearBank8                                                 ; очистить рабочую область логического банка 8
                LD A, #03
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD HL, State.LoadedGame                                         ; временный снимок выбранной игры до загрузки рабочих таблиц
                LD DE, State.Game
                LD BC, #0100
                LDIR
                XOR A
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD HL, Engine.Interrupt.ArmyRangeFile                           ; имя NAEMARMYC с диапазонами численности нападающих
                LD DE, Data.Recruits.SpawnRanges                                ; начало загружаемой таблицы NAEMARMY с базой и диапазоном количества
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                LD A, #0E
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD A, #31
                LD (Engine.Interrupt.SceneFileDigit), A
                LD HL, Engine.Interrupt.ScenesFile                              ; изменяемое имя BL?C с упакованными сценами
                LD DE, Memory.Window                                            ; начало выбранного окна расширенной RAM
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                LD A, #0F
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD A, #32
                LD (Engine.Interrupt.SceneFileDigit), A
                LD HL, Engine.Interrupt.ScenesFile                              ; изменяемое имя BL?C с упакованными сценами
                LD DE, Memory.Window                                            ; начало выбранного окна расширенной RAM
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                LD A, #04
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD HL, Engine.Interrupt.WorldFile                               ; имя SPR1C с графикой стратегической карты
                LD DE, Memory.Window                                            ; начало выбранного окна расширенной RAM
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                LD A, (State.Game)
                ADD A, #30
                LD (Engine.Interrupt.HeroFileDigit), A
                LD HL, Engine.Interrupt.PortraitFile                            ; изменяемое имя IP?C текущего героя
                LD DE, Graphics.HeroPortrait                                    ; адрес загрузки выбранного IP? в банк4
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                LD A, #06
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD HL, Engine.Interrupt.BattleGfxFile                           ; имя SPR2C с боевой графикой и младшей группой существ
                LD DE, Memory.Window                                            ; начало выбранного окна расширенной RAM
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                LD A, #07
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD HL, Engine.Interrupt.UnitsGfxFile                            ; имя SPR3C со старшей группой графики существ
                LD DE, Memory.Window                                            ; начало выбранного окна расширенной RAM
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                LD A, #0A
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD A, (State.Continent)
                ADD A, #30
                LD (Engine.Interrupt.MapFileDigit), A
                LD DE, Memory.Window                                            ; начало выбранного окна расширенной RAM
                LD HL, Engine.Interrupt.MapFile                                 ; изменяемое имя KARTA?C текущего континента
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                CALL MarkMapObjects                                             ; пометить занятые клетки карты для групп объектов
                CALL SelectMapBank                                              ; выбрать логический банк 10 с текущей картой
                LD BC, (State.GoodStoryPos)
                CALL MapCellAddress                                             ; вычислить адрес клетки карты
                SET MAP_BUSY_BIT, (HL)                                          ; клетка стратегической карты занята объектом
                LD A, (State.BadStoryMap)
                LD E, A
                LD A, (State.Continent)
                CP E
                JR NZ, .LoadViewData                                            ; переход, если загруженный континент не совпадает с выбранным континентом героя

                LD BC, (State.BadStoryPos)
                CALL MapCellAddress                                             ; вычислить адрес клетки карты
                SET MAP_BUSY_BIT, (HL)                                          ; клетка стратегической карты занята объектом
.LoadViewData   LD A, #03
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD HL, Engine.Interrupt.UnitTypesFile                           ; имя SOLDIERSC с описателями существ
                LD DE, Memory.Window                                            ; начало выбранного окна расширенной RAM
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                LD HL, Engine.Interrupt.BattleDataFile                          ; имя DATA1C с коэффициентами, правителями и заклинаниями
                LD DE, Data.Battle.MeleeFactors                                 ; адрес загрузки DATA1 в логическом банке3
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                LD HL, Engine.Interrupt.BattleCodeFile                          ; имя bitwa.coC с боевым модулем
                LD DE, Battle.Battle                                            ; адрес загрузки боевого кода bitwa.co
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                LD A, #0C
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD A, #31
                LD (Engine.Interrupt.OverlayDigit), A
                LD HL, Engine.Interrupt.OverlayFile                             ; изменяемое имя OVR?C группы оверлеев
                LD DE, Memory.Window                                            ; начало выбранного окна расширенной RAM
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                LD A, #0D
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD A, #32
                LD (Engine.Interrupt.OverlayDigit), A
                LD HL, Engine.Interrupt.OverlayFile                             ; изменяемое имя OVR?C группы оверлеев
                LD DE, Memory.Window                                            ; начало выбранного окна расширенной RAM
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                LD A, #0B
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD HL, Engine.Interrupt.FontFile                                ; имя DATA2C со шрифтом
                LD DE, Font.LoadAddress                                         ; адрес загрузки DATA2 в банк11
                CALL LoadFile                                                   ; загрузить именованный файл через TR-DOS
                LD HL, (System.Frames)
                LD (State.RandomState), HL
                LD HL, (System.Frames + 1)
                LD (State.RandomState + FWord), HL
                LD A, R
                LD L, A
                LD H, A
                LD (State.RandomState + 2 * FWord), HL
                CALL RefreshPanels                                              ; перерисовать верхнюю строку и боковую панель игры
