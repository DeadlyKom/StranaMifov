
; -----------------------------------------
; обновить боковую панель героя, расходы и рейтинг
; рамка BC=#0414, обязательная #6B8D, портрет 144 байта из логического банка 4 по #EF30, сообщения
; #96AE/#96F6, вывод включает «Расход», «Наличные», «Рейтинг», численные расчёты через калькулятор
; и #ADBF
; In:
;   поля героя, денежные пятибайтные числа, ресурсы портрета и армии
; Out:
;   боковая панель, расходы, наличные и рейтинг перерисованы, #6B8D очищает рабочий банк 8 в
;   контрольной точке
; Corrupt:
;   HL, DE, BC, AF, IX, IY, экран, банк 8 и поля калькулятора, альтернативные HL', DE', BC', AF'
;   могут изменяться вызываемым калькулятором ROM и здесь не сохраняются
; -----------------------------------------
RefreshHero     LD BC, #0414
                LD DE, #120A
                LD A, #41
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                CALL ClearBank8                                                 ; очистить рабочую область логического банка 8
                LD A, #04
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD BC, #0518
                LD DE, #0404
                LD IX, Graphics.HeroPortrait                                    ; текущий портрет героя в банке4
                CALL DrawRawSprite                                              ; вывести непрозрачный спрайт с атрибутами
                LD B, #0A
                LD DE, Engine.RefreshHero.HeroText                              ; сообщение с именем героя и именем сохранения
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD BC, #0C1C
                LD DE, Engine.RefreshHero.RuleLine                              ; горизонтальная текстовая линия панели героя
                CALL PrintZeroText                                              ; вывести строку с нулевым терминатором
                LD BC, #141C
                LD DE, Engine.RefreshHero.RuleLine                              ; горизонтальная текстовая линия панели героя
                CALL PrintZeroText                                              ; вывести строку с нулевым терминатором
                CALL SumCastleIncome                                            ; сложить доход принадлежащих герою замков на четырёх континентах
                CALL PopBC                                                      ; извлечь результат калькулятора ROM в BC
                LD HL, State.BaseIncome
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F                                                          ; addition, сложение, 95C3
                DB #38                                                          ; end-calc, возврат в Z80, 95C4
                LD HL, Engine.RefreshHero.Income                                ; пятибайтный расчётный доход героя
                CALL StoreFloat5                                                ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD BC, #0000
                LD A, (State.Cult)
                OR A
                JR Z, .AddShipCost                                              ; переход, если у героя нет активной секты

                LD BC, #3A98
.AddShipCost    CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
                LD A, (State.ShipPos)
                CP #FF
                JR Z, .StartArmy                                                ; переход, если у героя нет сохранённого корабля

                CALL ArmyRating                                                 ; рассчитать оценку армии из суммы взвешенных количеств
                CALL PopBC                                                      ; извлечь результат калькулятора ROM в BC
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F                                                          ; addition, сложение, 95E8
                DB #38                                                          ; end-calc, возврат в Z80, 95E9

                ; суммирование стоимости содержания отрядов армии
.StartArmy      LD IY, State.Army
                LD B, #05
.UnitLoop       LD A, (IY + FTroop.ID)                                          ; +#00, тип отряда и временные отметки
                OR A
                JR Z, .SumExpenses                                              ; переход, если достигнут конец армии при суммировании содержания

                PUSH BC
                CALL StackTroopCost                                             ; передать стоимость отряда на стек калькулятора
                CALL PopBC                                                      ; извлечь результат калькулятора ROM в BC
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F                                                          ; addition, сложение, 95FE
                DB #38                                                          ; end-calc, возврат в Z80, 95FF
                POP BC
                INC IY
                INC IY
                INC IY
                DJNZ .UnitLoop

.SumExpenses    LD HL, Engine.RefreshHero.Expenses                              ; пятибайтные расчётные расходы героя
                CALL StoreFloat5                                                ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD HL, Engine.RefreshHero.Income                                ; пятибайтный расчётный доход героя
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Engine.RefreshHero.Expenses                              ; пятибайтные расчётные расходы героя
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                CALL FloatSignZero                                              ; определить знак и нулевое значение результата калькулятора
                LD A, #44
                JR NC, .UpdatePanels                                            ; переход, если расчётный доход не меньше расходов

                LD A, #42

                ; обновление числовых полей боковых панелей
.UpdatePanels   LD BC, #0D15
                LD DE, #040A
                CALL FillAttributes                                             ; заполнить прямоугольник атрибутов цветом A
                LD BC, #1115
                LD DE, #020A
                LD A, #46
                CALL FillAttributes                                             ; заполнить прямоугольник атрибутов цветом A
                LD BC, #0D1C
                LD DE, Engine.RefreshHero.IncomeText                            ; подпись Доход в панели героя
                CALL PrintZeroText                                              ; вывести строку с нулевым терминатором
                LD BC, #0E24
                LD DE, Engine.RefreshHero.CoinsText                             ; денежная единица монет
                CALL PrintZeroText                                              ; вывести строку с нулевым терминатором
                LD BC, #0F1C
                LD DE, Engine.RefreshHero.ExpensesText                          ; подпись Расход в панели героя
                CALL PrintZeroText                                              ; вывести строку с нулевым терминатором
                LD BC, #1024
                LD DE, Engine.RefreshHero.CoinsText                             ; денежная единица монет
                CALL PrintZeroText                                              ; вывести строку с нулевым терминатором
                LD BC, #111C
                LD DE, Engine.RefreshHero.MoneyText                             ; подпись Наличные в панели героя
                CALL PrintZeroText                                              ; вывести строку с нулевым терминатором
                LD BC, #1224
                LD DE, Engine.RefreshHero.CoinsText                             ; денежная единица монет
                CALL PrintZeroText                                              ; вывести строку с нулевым терминатором
                LD BC, #151C
                LD DE, Engine.RefreshHero.RatingText                            ; подпись Рейтинг в панели героя
                CALL PrintZeroText                                              ; вывести строку с нулевым терминатором
                LD BC, #1622
                LD DE, Engine.RefreshHero.PointsText                            ; единица рейтинга пунктов
                CALL PrintZeroText                                              ; вывести строку с нулевым терминатором
                LD HL, Engine.RefreshHero.Income                                ; пятибайтный расчётный доход героя
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                LD BC, #0E1C
                CALL DrawNumber                                                 ; преобразовать число и вывести символы подряд
                LD HL, Engine.RefreshHero.Expenses                              ; пятибайтные расчётные расходы героя
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                LD BC, #101C
                CALL DrawNumber                                                 ; преобразовать число и вывести символы подряд
                LD HL, State.Money
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                LD BC, #121C
                CALL DrawNumber                                                 ; преобразовать число и вывести символы подряд
                LD HL, (State.Leadership)
                LD BC, #161C
                CALL PrintU16                                                   ; вывести 16 битное число HL без ведущих нулей
                RET

.HeroText       EQU $                                                           ; сообщение с именем героя и именем сохранения
                DB #11, #1C, #0E, #0E, #F8, #69, #0D, #2A
.IncomeText     EQU $+6                                                         ; подпись Доход в панели героя
                DB #0E, #EF, #69, #0D, #2A, #00, #84, #AE
.ExpensesText   EQU $+5                                                         ; подпись Расход в панели героя
                DB #E5, #AE, #A4, #3A, #00, #90, #A0, #E1
.MoneyText      EQU $+5                                                         ; подпись Наличные в панели героя
                DB #E5, #AE, #A4, #3A, #00, #8D, #A0, #AB
.RatingText     EQU $+7                                                         ; подпись Рейтинг в панели героя
                DB #A8, #E7, #AD, #EB, #A5, #3A, #00, #90
                DB #A5, #A9, #E2, #A8, #AD, #A3, #3A, #00
.CoinsText      EQU $                                                           ; денежная единица монет
.PointsText     EQU $+6                                                         ; единица рейтинга пунктов
                DB #AC, #AE, #AD, #A5, #E2, #00, #AF, #E3
.Income         EQU $+6                                                         ; пятибайтный расчётный доход героя
                DB #AD, #AA, #E2, #AE, #A2, #00, #00, #00
.Expenses       EQU $+3                                                         ; пятибайтные расчётные расходы героя
                DB #00, #00, #00, #00, #00, #00, #00, #00
.RuleLine       EQU $                                                           ; горизонтальная текстовая линия панели героя
                DB #C4, #C4, #C4, #C4, #C4, #C4, #C4, #C4
                DB #C4, #C4, #C4, #C4, #C4, #00
