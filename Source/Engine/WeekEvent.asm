
; -----------------------------------------
; обработать наступление новой недели и связанное изменение типа существ
; выбирает ID=(BC mod19)+7, тоесть 7..25, показывает сообщение новой недели, поле 38 описателя
; служит делителем прироста города/замкового гарнизона, поле 39 делителем прироста внешних армий и
; армии героя, #A205 добавляет floor(исходное количество/делитель) только совпадающему ID, обход
; включает 30 записей выбранной таблицы найма, гарнизоны текущего континента, внешние армии #6B79
; и 5 записей героя, нулевой делитель не проверяется
; In:
;   BC номер недели/число для выбора типа, описатели воинов и составы армий
; Out:
;   тип ID=(BCmod19)+7 получает прирост в таблице найма, замках, внешних армиях и армии героя по
;   делителям полей 38/39 описателя
; Corrupt:
;   HL, DE, BC, AF, IX, IY, количества отрядов, операнды #A203/#A204 и экран, вызываемый текст
;   использует ROM
; -----------------------------------------
WeekEvent       LD L, C
                LD H, B
                LD DE, #0013
                OR A
.WeekModulo     SBC HL, DE
                JR NC, .WeekModulo                                              ; переход, если номер недели ещё не приведён к циклу из 19 типов существ

                ADD HL, DE
                LD A, L
                ADD A, #07
                LD (Engine.WeekEvent.GrowthUnitID), A
                LD BC, #0A00
                LD DE, #0512
                LD A, #45
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0C
                LD DE, Engine.WeekEvent.NewWeekText                             ; сообщение о наступлении новой недели
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL WaitOrInput                                                ; выдержать паузу с досрочным выходом по вводу
                LD A, (Engine.WeekEvent.GrowthUnitID)
                CALL UnitDesc                                                   ; получить описатель типа отряда
                LD A, (IX + FSoldier.SiteGrowthDiv)
                LD (Engine.WeekEvent.GrowthDivisor), A
                LD D, #00
                LD E, (IX + FSoldier.SpawnClass)
                SLA E
                XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD IX, Engine.WeekEvent.RecruitLists - FWord
                ADD IX, DE
                LD L, (IX + FWord.Low)
                LD H, (IX + FWord.High)
                PUSH HL
                POP IX
                LD DE, #0003
                LD B, #1E

                ; рост выбранного типа в тридцати записях таблицы найма
.GrowRecruit    CALL GrowTroop                                                  ; увеличить количество заданного типа в трёхбайтной записи
                ADD IX, DE
                DJNZ .GrowRecruit

                LD IX, State.CastlesIndex
                LD A, (State.Continent)
                CALL IndexFourBytes                                             ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                LD B, (IX + FMapList.Count.Low)
                PUSH HL
                POP IX
                LD DE, #0014
                ADD IX, DE

                ; рост отрядов в гарнизонах замков
.CastleLoop     PUSH BC
                LD B, #05
.GrowGarrison   CALL GrowTroop                                                  ; увеличить количество заданного типа в трёхбайтной записи
                DJNZ .GrowGarrison

                ADD IX, DE
                POP BC
                DJNZ .CastleLoop

                LD A, (Engine.WeekEvent.GrowthUnitID)
                CALL UnitDesc                                                   ; получить описатель типа отряда
                LD A, (IX + FSoldier.ArmyGrowthDiv)
                LD (Engine.WeekEvent.GrowthDivisor), A
                LD A, #01
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD IX, State.MapArmiesIndex
                LD A, (State.Continent)
                CALL IndexFourBytes                                             ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                LD B, (IX + FMapList.Count.Low)
                PUSH HL
                POP IX
                LD DE, #0007
                ADD IX, DE

                ; рост отрядов стратегических армий
.ArmyLoop       PUSH BC
                LD B, #05
.GrowArmy       CALL GrowTroop                                                  ; увеличить количество заданного типа в трёхбайтной записи
                DJNZ .GrowArmy

                ADD IX, DE
                POP BC
                DJNZ .ArmyLoop

                LD IX, State.Army
                LD B, #05

                ; рост выбранного типа в пяти отрядах героя
.GrowHero       CALL GrowTroop                                                  ; увеличить количество заданного типа в трёхбайтной записи
                DJNZ .GrowHero

                RET

.RecruitLists   EQU $                                                           ; четыре адреса таблиц найма по классу источника
                DB #2D, #DC, #E1, #DC, #95, #DD, #49, #DE
.NewWeekText    EQU $                                                           ; сообщение о наступлении новой недели
                DB #11, #00, #1A, #8F, #E0, #AE, #E8, #AB
                DB #A0, #20, #AD, #A5, #A4, #A5, #AB, #EF
                DB #0D, #2A, #AF, #AE, #E0, #A0, #20, #A7
                DB #A0, #AD, #EF, #E2, #E1, #EF, #0D, #2A
                DB #A4, #A5, #AB, #A0, #AC, #A8, #2E, #2E
.GrowthUnitID   EQU $+4                                                         ; ID типа существа текущей недели
.GrowthDivisor  EQU $+5                                                         ; делитель недельного прироста выбранного типа
                DB #2E, #0D, #2A, #00, #00, #00
