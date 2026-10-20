; оверлей 10 из OVR1
; исходный файл каталога 48, смещение #29D4
                module Overlay
                module Dismiss
                org #B200

; -----------------------------------------
; роспуск выбранного отряда
; Показывает пять отрядов и предлагает выбрать удаляемый. Проверяет исходный тип и связанные
; условия, обновляет запись армии либо запускает реакцию отряда. Подпрограмма ShowUnitDialog
; показывает
; выбранное сообщение и ожидает подтверждение. После завершения восстанавливает экран и состояние
; ввода.
; In:
;   текущее состояние героя, армии и объекта в ядре
; Out:
;   состояние обновлено выбранной ветвью либо сохранено при отказе
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; -----------------------------------------
Entry           LD A, (State.Army)
                OR A
                JR NZ, .DrawArmyWindow                                          ; переход, если в армии есть отряд для роспуска

                LD BC, #1000
                LD DE, #0612
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD DE, Overlay.Dismiss.ShowUnitDialog.NoArmyText                ; сообщение о невозможности бросить отряд в пустой армии
                LD B, #13
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                RET

.DrawArmyWindow CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                LD BC, #0E00
                LD DE, #0812
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #1101
                LD DE, #0112
                LD A, #44
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD DE, Overlay.Dismiss.ShowUnitDialog.ChooseText                ; вопрос о распускаемом отряде и пункт Никого
                LD B, #0F
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #1204
                LD (Entry.ListXY), BC
                LD A, #01
                LD (ShowUnitDialog.MenuCount), A
                LD IY, State.Army
                LD B, #05
.UnitRow        LD A, (IY + FTroop.ID)
                OR A
                JR Z, .SelectUnit                                               ; переход, если достигнут конец заполненной части армии

                PUSH BC
                CALL Engine.FormatUnitName                                      ; сформировать имя типа отряда со специальным окончанием
                LD BC, #0000
.ListXY         EQU $ - 2                                                       ; операнд координат списка армии
.ListRow        EQU $ - 1                                                       ; строка списка армии
                LD DE, Engine.FormatUnitName.ArmyUnitText                       ; общий формат имени и количества типа отряда
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (Entry.ListRow)
                INC A
                LD (Entry.ListRow), A
                LD A, (ShowUnitDialog.MenuCount)
                INC A
                LD (ShowUnitDialog.MenuCount), A
                POP BC
                INC IY
                INC IY
                INC IY
                DJNZ .UnitRow

                ; выбор задаёт один из пяти отрядов, дальнейшая реакция зависит от свойств его типа
.SelectUnit     LD IX, ShowUnitDialog.MenuCount
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #01
                RET Z                                                           ; выход, если игрок выбрал отмену роспуска

                DEC A
                LD HL, State.Army - FTroop                                      ; база перед первой записью армии для выбора отряда по номеру после вычитания отмены
.FindChosenUnit INC HL
                INC HL
                INC HL
                DEC A
                JR NZ, .FindChosenUnit                                          ; переход, если указатель ещё не дошёл до выбранного отряда

                PUSH HL
                LD DE, ShowUnitDialog.Dismissed
                LDI
                LDI
                LDI
                POP HL
                LD (HL), #00
                LD HL, State.Army
                LD B, #05
                CALL Engine.CompactArmy                                         ; сжать список трёхбайтных записей армии
                LD BC, (ShowUnitDialog.DismissedCount)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                LD A, (ShowUnitDialog.Dismissed)
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD C, (IX + FSoldier.UnitValue.Low)
                LD B, (IX + FSoldier.UnitValue.High)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #04, #38                                                     ; multiply, умножение, B2BF
                LD HL, Overlay.Dismiss.ShowUnitDialog.DemandMoney               ; пятибайтная сумма компенсации, требуемой распускаемым отрядом
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD A, (ShowUnitDialog.Dismissed)
                LD B, #00
                LD C, A
                LD HL, State.ControlIndex
                ADD HL, BC
                LD C, (HL)
                LD HL, (State.Leadership)
                LD DE, #FFFF
.DivideQuantity INC DE
                OR A
                SBC HL, BC
                JR NC, .DivideQuantity                                          ; переход, если лидерства хватает ещё на одну единицу распускаемого типа

                EX DE, HL
                LD DE, (ShowUnitDialog.DismissedCount)
                OR A
                SBC HL, DE
                JR NC, .CheckTraits                                             ; переход, если распускаемая численность не превышает предел управления

                LD DE, #0812
                LD A, #42
                LD HL, Overlay.Dismiss.ShowUnitDialog.RefusalText               ; реплика отказа отряда спокойно уйти
                CALL ShowUnitDialog
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу

                ; враждебная реакция распускаемого отряда запускает бой в банке 3
.StartBattle    LD A, #03
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD BC, (State.Position)
                CALL Engine.ReadMapCell                                         ; прочитать байт клетки текущей карты
                AND #3F
                CALL Engine.TerrainBattle                                       ; преобразовать местность по второй таблице порогов
                LD IX, ShowUnitDialog.Dismissed
                LD DE, #0000
                LD BC, #0100
                CALL Battle.Battle                                              ; выполнить бой на поле 8 на 5 клеток
                PUSH AF
                LD BC, #0000
                LD DE, #1820
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                CALL Engine.RefreshPanels                                       ; перерисовать верхнюю строку и боковую панель игры
                POP AF
                OR A
                JR NZ, .BattleLost                                              ; переход, если бой с распущенным отрядом завершился поражением героя

                CALL Engine.GainLeadership                                      ; увеличить 16 битное поле героя #6A02 с насыщением #FFFF
                LD BC, #0A00
                LD DE, #0512
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD DE, Overlay.Dismiss.ShowUnitDialog.WonRevoltText             ; сообщение об успешном подавлении мятежа
                JR .ShowResult

.BattleLost     CALL Engine.LoseLeadership                                      ; уменьшить 16 битное поле героя #6A02 с насыщением 0
                LD BC, #0A00
                LD DE, #0412
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD DE, Overlay.Dismiss.ShowUnitDialog.LostRevoltText            ; сообщение о поражении в мятеже
.ShowResult     LD B, #0C
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
.RefreshHero    CALL Engine.RefreshHero                                         ; обновить боковую панель героя, расходы и рейтинг
                RET

                ; особые флаги типа определяют денежное требование или обычный роспуск
.CheckTraits    LD A, (ShowUnitDialog.Dismissed)
                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                LD A, D
                AND #60
                OR A
                JR Z, .RefreshHero                                              ; переход, если у типа нет особой реакции на роспуск в битах 5 и 6

                CP #20
                JR NZ, .CheckGoldTrait                                          ; переход, если реакция типа отличается от обязательной выплаты с маской #20

                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Overlay.Dismiss.ShowUnitDialog.DemandMoney               ; пятибайтная сумма компенсации, требуемой распускаемым отрядом
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                JR NC, .PayDemand                                               ; переход, если денег героя хватает на требуемую выплату

                XOR A
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                JR .ShowPayment

.PayDemand      LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Overlay.Dismiss.ShowUnitDialog.DemandMoney               ; пятибайтная сумма компенсации, требуемой распускаемым отрядом
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #03, #38                                                     ; subtract, вычитание, B394
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
.ShowPayment    LD DE, #0A12
                LD A, #44
                LD HL, Overlay.Dismiss.ShowUnitDialog.TakeMoneyText             ; сообщение об уходе отряда с денежной компенсацией
                CALL ShowUnitDialog
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .RefreshHero

.CheckGoldTrait CP #40
                JR NZ, .ShowRevolt                                              ; переход, если реакция типа отличается от предложения выплаты с маской #40

                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Overlay.Dismiss.ShowUnitDialog.DemandMoney               ; пятибайтная сумма компенсации, требуемой распускаемым отрядом
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                JR NC, .AskDemand                                               ; переход, если денег хватает и можно предложить выплату вместо бунта

.ShowRevolt     LD DE, #0A12
                LD HL, Overlay.Dismiss.ShowUnitDialog.BetrayalText              ; реплика преданного отряда перед мятежом
                LD A, #42
                CALL ShowUnitDialog
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .StartBattle

.AskDemand      LD DE, #0D12
                LD HL, Overlay.Dismiss.ShowUnitDialog.DemandText                ; реплика требования компенсации за роспуск
                LD A, #46
                CALL ShowUnitDialog
                LD IX, Overlay.Dismiss.ShowUnitDialog.DemandMenu                ; меню согласия на компенсацию отряду
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #02
                JP Z, .StartBattle                                              ; переход, если игрок отказался платить и начинается бой

                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Overlay.Dismiss.ShowUnitDialog.DemandMoney               ; пятибайтная сумма компенсации, требуемой распускаемым отрядом
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #03, #38                                                     ; subtract, вычитание, B3FB
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                JP .RefreshHero

; -----------------------------------------
; оформление сообщения и анимированного отряда при роспуске
; Сохраняет HL со строкой. По BC=#0700, входным DE и A рисует рамку через #73FE. Берёт ID отряда
; из ShowUnitDialog.Dismissed и вызывает #7366 с позицией 2, 2, создавая четырёхкадровый
; экранный объект. Печатает
; строку в строке 13 и вызывает #6D57, которая устанавливает bit2 #6566 для обработки объектов в
; прерывании. Ожидания либо подтверждения эта вспомогательная процедура не содержит, выбор
; выполняют её вызывающие ветви.
; In:
;   HL — строка, DE — размеры рамки, A — атрибут рамки, ShowUnitDialog.Dismissed — ID отряда
; Out:
;   сообщение выведено, анимированный объект создан, обработка объектов включена
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
ShowUnitDialog  PUSH HL
                LD BC, #0700
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #0202
                LD A, (ShowUnitDialog.Dismissed)
                CALL Engine.SetUnitPicture                                      ; создать четырёхкадровый экранный объект
                POP DE
                LD B, #0D
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                CALL Engine.StartView                                           ; включить обработку объектов в прерывании
                RET

.Dismissed      DB #00                                                          ; ID распущенного отряда, далее слово количества
.DismissedCount DW #0000                                                        ; численность распущенного отряда
.DemandText     EQU $                                                           ; реплика требования компенсации за роспуск
                DB #11, #00, #1A, #9D, #E2, #AE, #20, #AD
                DB #A0, #A3, #AB, #AE, #A5, #20, #AE, #E1
                DB #AA, #AE, #E0, #A1, #AB, #A5, #AD, #A8
                DB #A5, #2C, #0D, #2A, #AD, #AE, #20, #A7
.DemandMoney    EQU $+3                                                         ; пятибайтная сумма компенсации, требуемой распускаемым отрядом
                DB #A0, #20, #10, #00, #00, #00, #00, #00
                DB #00, #AC, #AE, #AD, #A5, #E2, #0D, #2A
                DB #AC, #EB, #20, #2C, #AF, #AE, #A6, #A0
                DB #AB, #E3, #A9, #2C, #0D, #2A, #AF, #E0
                DB #AE, #E1, #E2, #A8, #AC, #20, #E2, #A5
                DB #A1, #EF, #0D, #2A, #0D, #00, #95, #AE
                DB #E0, #AE, #E8, #AE, #2C, #20, #A4, #AE
                DB #A3, #AE, #A2, #AE, #E0, #A8, #AB, #A8
                DB #E1, #EC, #0D, #2A, #8F, #AE, #E8, #AB
                DB #A8, #20, #A2, #EB, #20, #AA, #20, #E7
                DB #A5, #E0, #E2, #E3, #20, #21, #0D, #2A
.BetrayalText   EQU $+1                                                         ; реплика преданного отряда перед мятежом
                DB #00, #11, #00, #1A, #8C, #EB, #20, #E1
                DB #AB, #E3, #A6, #A8, #AB, #A8, #20, #E2
                DB #A5, #A1, #A5, #0D, #2A, #A2, #A5, #E0
                DB #AE, #A9, #20, #A8, #20, #AF, #E0, #A0
                DB #A2, #A4, #AE, #A9, #2C, #0D, #2A, #A0
                DB #20, #E2, #EB, #20, #AD, #A0, #E1, #20
                DB #A1, #E0, #AE, #E1, #A0, #A5, #E8, #EC
                DB #2E, #0D, #2A, #8F, #90, #85, #84, #80
                DB #92, #85, #8B, #9C, #2E, #2E, #2E, #0D
.TakeMoneyText  EQU $+2                                                         ; сообщение об уходе отряда с денежной компенсацией
                DB #2A, #00, #11, #00, #1A, #8C, #EB, #20
                DB #AF, #AE, #AA, #A8, #A4, #A0, #A5, #AC
                DB #20, #A2, #A0, #E1, #2C, #0D, #2A, #A8
                DB #20, #A1, #A5, #E0, #A5, #AC, #20, #E1
                DB #20, #E1, #AE, #A1, #AE, #A9, #0D, #2A
                DB #AD, #A5, #AC, #AD, #AE, #A3, #AE, #20
                DB #A2, #A0, #E8, #A8, #E5, #20, #A4, #A5
                DB #AD, #A5, #A3, #2C, #0D, #2A, #E1, #E3
                DB #A4, #A0, #E0, #EC, #2E, #0D, #2A, #00
.WonRevoltText  EQU $                                                           ; сообщение об успешном подавлении мятежа
                DB #11, #00, #1A, #82, #A0, #AC, #20, #E3
                DB #A4, #A0, #AB, #AE, #E1, #EC, #20, #E1
                DB #AF, #E0, #A0, #A2, #A8, #E2, #EC, #E1
                DB #EF, #0D, #2A, #E1, #20, #ED, #E2, #A8
                DB #AC, #A8, #0D, #2A, #AC, #A5, #AB, #AA
                DB #A8, #AC, #A8, #20, #AD, #A5, #AF, #E0
                DB #A8, #EF, #E2, #AD, #AE, #E1, #E2, #EF
.LostRevoltText EQU $+6                                                         ; сообщение о поражении в мятеже
                DB #AC, #A8, #2E, #0D, #2A, #00, #11, #00
                DB #1A, #8E, #A1, #A8, #A4, #AD, #AE, #20
                DB #21, #0D, #2A, #80, #20, #E7, #E2, #AE
                DB #20, #A4, #A5, #AB, #A0, #E2, #EC, #2E
.RefusalText    EQU $+5                                                         ; реплика отказа отряда спокойно уйти
                DB #2E, #2E, #0D, #2A, #00, #11, #00, #1A
                DB #8D, #A5, #20, #E2, #A0, #AA, #20, #AF
                DB #E0, #AE, #E1, #E2, #AE, #2C, #0D, #2A
                DB #AF, #E0, #A8, #EF, #E2, #A5, #AB, #EC
.ChooseText     EQU $+6                                                         ; вопрос о распускаемом отряде и пункт Никого
                DB #2E, #2E, #2E, #0D, #2A, #00, #8A, #AE
                DB #A3, #AE, #20, #E5, #AE, #E2, #A8, #E2
                DB #A5, #20, #A1, #E0, #AE, #E1, #A8, #E2
                DB #EC, #20, #3F, #0D, #02, #0D, #00, #8D
                DB #A8, #AA, #AE, #A3, #AE, #0D, #02, #00
.NoArmyText     EQU $                                                           ; сообщение о невозможности бросить отряд в пустой армии
                DB #11, #00, #1A, #82, #20, #A2, #A0, #E8
                DB #A5, #A9, #20, #A0, #E0, #AC, #A8, #A8
                DB #20, #AD, #A8, #AA, #AE, #A3, #AE, #20
                DB #AD, #A5, #E2, #2C, #0D, #2A, #AA, #AE
                DB #A3, #AE, #20, #A2, #EB, #20, #E1, #AE
                DB #A1, #A8, #E0, #A0, #A5, #E2, #A5, #E1
                DB #EC, #0D, #2A, #AE, #E1, #E2, #A0, #A2
                DB #AB, #EF, #E2, #EC, #20, #3F, #0D, #2A
                DB #00
.MenuCount      DB #06                                                          ; число пунктов выбора распускаемого отряда
                DB #0A, #80, #8C, #BE, #14, #82, #01, #11
                DB #13, #12, #01, #12, #13, #13, #01, #13
                DB #13, #14, #01, #14, #13, #15, #01, #15
.DemandMenu     EQU $+6                                                         ; меню согласия на компенсацию отряду
                DB #13, #16, #01, #16, #13, #17, #02, #0A
                DB #8C, #A0, #A5, #32, #96, #01, #12, #13
                DB #13, #01, #13, #13, #14, #6F, #76, #65
                DB #72, #6C, #61, #79

                assert $ = #B641
                endmodule
                endmodule
