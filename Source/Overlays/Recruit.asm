; оверлей 04 из OVR1
; исходный файл каталога 48, смещение #17E9
                module Overlay
                module Recruit
                org #B200

; -----------------------------------------
; найм существ из объекта карты
; Получает ID и доступное количество существ из шестибайтовой записи объекта, выводит имя и
; параметры. Ищет свободную либо совпадающую по ID запись среди пяти отрядов. Вычисляет и
; показывает управляемость через #86B1, сохраняя BC в Entry.Capacity, но после ввода не
; сравнивает число с
; этим значением. Ввод принимает только ненулевое число не больше наличия существ и количества,
; доступного за деньги. Непосредственно записывает новый ID и увеличенную численность в найденную
; запись, при первом добавлении вызывает сброс счётчиков #7A94. Списывает плату и уменьшает
; количество существ в объекте.
; In:
;   текущее состояние героя, армии и объекта в ядре
; Out:
;   состояние обновлено выбранной ветвью либо сохранено при отказе
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; -----------------------------------------
Entry           LD (Entry.SourceTroop), IX
                LD A, C
                SUB #03
                PUSH AF
                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                ADD A, #05
                CALL Engine.ShowScene                                           ; показать одну из девяти упакованных сцен BL1/BL2 с восстановлением банка и основных регистров
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (Entry.SourceTroop)
                LD DE, Runtime.UnitBackdrop                                     ; 16-знакоместная копия рисунка нанимаемого типа
                LD C, (IX + FMapTroop.ID)
                LD A, #04
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD A, C
                LD BC, #0202
                CALL Engine.GrabUnitTile                                        ; сохранить фон и создать анимированный объект 4 на 4 знакоместа
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                POP AF
                LD HL, Overlay.Recruit.Entry.ClassAttrs                         ; атрибуты окна по классу нанимаемого типа
                LD D, #00
                LD E, A
                ADD HL, DE
                LD A, (HL)
                LD (Entry.FrameAttr), A
                LD (Entry.PromptAttr), A
                LD C, (IX + FMapTroop.Count.Low)
                LD B, (IX + FMapTroop.Count.High)
                LD (Entry.Available), BC
                LD A, (IX + FMapTroop.ID)
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD (Entry.SoldierDesc), IX
                LD C, (IX + FSoldier.UnitValue.Low)
                LD B, (IX + FSoldier.UnitValue.High)
                LD (Entry.UnitPrice), BC
.DrawOffer      LD A, #00
.FrameAttr      EQU $ - 1                                                       ; операнд цвета окна предложения найма
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, (Entry.Available)
                LD A, B
                OR C
                JR NZ, .ShowAvailable                                           ; переход, если в строении имеются доступные для найма существа

                LD DE, Overlay.Recruit.Entry.NoUnitsText                        ; сообщение Здесь никого не осталось
                LD BC, #1208
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD A, #04
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, Runtime.UnitBackdrop                                     ; 16-знакоместная копия рисунка нанимаемого типа
                LD DE, #0404
                LD BC, #0808
                CALL Engine.DrawRawSprite                                       ; вывести непрозрачный спрайт с атрибутами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .FinishMove

.ShowAvailable  CALL Engine.StartView                                           ; включить обработку объектов в прерывании
                LD A, #03
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD BC, #1007
                LD DE, Overlay.Recruit.Entry.UnitKindsText                      ; формат названия обитающего здесь типа
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (Entry.SourceTroop)
                LD HL, State.Army
                LD B, #05

                ; пять записей героя просматриваются в поиске свободного места или уже
                ; имеющегося типа
.FindArmySlot   LD A, (HL)
                OR A
                JR Z, .ShowHirePrompt                                           ; переход, если найдена свободная запись армии

                CP (IX + FMapTroop.ID)
                JR Z, .ShowHirePrompt                                           ; переход, если в армии уже есть отряд нанимаемого типа

                INC HL
                INC HL
                INC HL
                DJNZ .FindArmySlot

                LD BC, #1204
                LD DE, Engine.NeedMoreMoney.ArmyFullText                        ; сообщение о заполнении всех пяти типов армии
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .FinishMove

.ShowHirePrompt LD (Entry.ArmySlot), HL
                LD A, #00
.PromptAttr     EQU $ - 1                                                       ; операнд цвета запроса количества
                LD BC, #1101
                LD DE, #061E
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD BC, #160F
                LD DE, #010F
                LD A, #46
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #1617
                LD DE, Engine.NeedMoreMoney.MoneyText                           ; общая надпись денежных средств
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, #1620
                CALL Engine.DrawNumber                                          ; преобразовать число и вывести символы подряд
                LD IX, (Entry.SoldierDesc)
                LD IY, (Entry.SourceTroop)
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, (Entry.UnitPrice)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05, #27, #38                                                ; division, деление, B312
                CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD (Entry.Affordable), BC
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD A, (IY + FMapTroop.ID)
                CALL Engine.FreeCapacity                                        ; вычислить остаток допустимого количества выбранного типа отряда
                LD (Entry.Capacity), BC
                LD DE, Overlay.Recruit.Entry.HireOffer                          ; формат количества, цены, доступной суммы и предела контроля
                LD BC, #1102
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #1602
                LD DE, Engine.NeedMoreMoney.QuantityText                        ; общее приглашение Сколько для ввода количества
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами

                ; допустимое число ограничивают наличие существ и цена, отдельной проверки
                ; показанного лидерства здесь нет
.ReadHireCount  LD BC, #160D
                PUSH IX
                PUSH IY
                CALL Engine.EditNumber                                          ; ввести число из не более пяти цифр
                POP IY
                POP IX
                CP #0E
                JP Z, .FinishMove                                               ; переход, если ввод численности отменён кодом #0E

                CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD A, B
                OR C
                JR Z, .ReadHireCount                                            ; переход, если введена нулевая численность

                LD (Entry.HireCount), BC
                LD HL, (Entry.Available)
                LD BC, (Entry.HireCount)
                OR A
                SBC HL, BC
                JR C, .ReadHireCount                                            ; переход, если запрошено больше существ, чем имеется в строении

                LD HL, (Entry.Affordable)
                SBC HL, BC
                JP C, .ReadHireCount                                            ; переход, если запрошенная численность превышает свободный предел управления

                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD HL, (Entry.ArmySlot)
                INC HL
                LD E, (HL)
                INC HL
                LD D, (HL)
                LD A, D
                OR E
                JR NZ, .AddHiredUnits                                           ; переход, если нанятые существа добавляются к уже существующему отряду

                LD A, (IY + FMapTroop.ID)
                CALL Engine.ClearTwoFlags                                       ; обнулить два связанных байта таблиц

                ; после найма численность добавляется в армию, а остаток доступных существ и
                ; деньги уменьшаются
.AddHiredUnits  EX DE, HL
                ADD HL, BC
                EX DE, HL
                LD HL, (Entry.ArmySlot)
                LD A, (IY + FMapTroop.ID)
                LD (HL), A
                INC HL
                LD (HL), E
                INC HL
                LD (HL), D
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, (Entry.UnitPrice)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                LD BC, (Entry.HireCount)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #04, #03, #38                                                ; multiply, умножение, B3A6
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD HL, (Entry.Available)
                LD BC, (Entry.HireCount)
                OR A
                SBC HL, BC
                LD (IY + FMapTroop.Count.Low), L
                LD (IY + FMapTroop.Count.High), H
                LD (Entry.Available), HL
                JP .DrawOffer

.FinishMove     CALL Engine.MoveToTarget                                        ; преобразовать направление к цели в команду движения героя
                RET

.UnitKindsText  EQU $                                                           ; формат названия обитающего здесь типа
                DB #87, #A4, #A5, #E1, #EC, #20, #AE, #A1
                DB #A8, #E2, #A0, #EE, #E2, #20, #0E
.SoldierDesc    DW #0000                                                        ; адрес описателя нанимаемого типа
.NoUnitsText    EQU $+3                                                         ; сообщение Здесь никого не осталось
                DB #0D, #2A, #00, #87, #A4, #A5, #E1, #EC
                DB #20, #AD, #A8, #AA, #AE, #A3, #AE, #20
                DB #AD, #A5, #20, #AE, #E1, #E2, #A0, #AB
.HireOffer      EQU $+5                                                         ; формат количества, цены, доступной суммы и предела контроля
                DB #AE, #E1, #EC, #2E, #00, #91, #A5, #A9
                DB #E7, #A0, #E1, #20, #A8, #E5, #20, #A7
                DB #A4, #A5, #E1, #EC, #20, #0F
.Available      DW #0000                                                        ; число существ в исходной записи объекта
                DB #00, #0D, #02, #8A, #A0, #A6, #A4, #EB
                DB #A9, #20, #E1, #E2, #AE, #A8, #E2, #20
                DB #0F
.UnitPrice      DW #0000                                                        ; цена найма одного существа
                DB #00, #0D, #02, #8D, #A0, #20, #A8, #AC
                DB #A5, #EE, #E9, #A8, #A5, #E1, #EF, #20
                DB #E3, #20, #A2, #A0, #E1, #20, #A4, #A5
                DB #AD, #EC, #A3, #A8, #0D, #02, #A2, #EB
                DB #20, #AC, #AE, #A6, #A5, #E2, #A5, #20
                DB #AD, #A0, #AD, #EF, #E2, #EC, #20, #0F
.Affordable     DW #0000                                                        ; число существ, доступное за имеющиеся деньги
                DB #00, #A2, #AE, #A8, #AD, #AE, #A2, #0D
                DB #07, #8F, #AE, #A4, #20, #AA, #AE, #AD
                DB #E2, #E0, #AE, #AB, #A5, #AC, #20, #A2
                DB #EB, #20, #E3, #A4, #A5, #E0, #A6, #A8
                DB #E2, #A5, #20, #0F
.Capacity       DW #0000                                                        ; свободный предел управления для текста
                DB #00, #A2, #AE, #A8, #AD, #AE, #A2, #0D
                DB #02, #00
.SourceTroop    DW #0000                                                        ; адрес исходной записи отряда карты
.ArmySlot       DW #0000                                                        ; адрес целевого слота армии героя
.ClassAttrs     EQU $+1                                                         ; атрибуты окна по классу нанимаемого типа
.HireCount      DW #0000                                                        ; введённая численность найма
                DB #42, #44, #46, #47, #6F, #76, #65, #72
                DB #6C, #61, #79

                assert $ = #B490
                endmodule
                endmodule
