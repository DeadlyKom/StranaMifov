
; -----------------------------------------
; продвинуть время игры и выполнить периодические расчёты
; прибавляет стоимость шага #69D7 к дробной части #6A35, перенос увеличивает дни #6A36, без нового
; дня вызывает #A5AE с A=0, при новом дне продолжается восстановление ресурсов, расчёты армии,
; регулярные расходы и события, строки #9CD0..#9E5C описывают жалование, корабль и пожертвования
; In:
;   byte(#69D7) стоимость шага, дробное время #6A35, дни #6A36, срок #6A38, состояние
;   ресурсов/армии/угроз
; Out:
;   стоимость шага прибавлена к дробному времени, перенос увеличивает дни на 1, дневные и
;   недельные обработчики обновляют ресурсы/армию/замки, #A5AE получает 0 или 1 по факту дня
; Corrupt:
;   HL, DE, BC, AF, IX, IY, игровые временные поля и вызываемые состояния, альтернативные HL',
;   DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются,
;   достижение срока может перейти к оверлею 20 без возврата
; -----------------------------------------
TickTime        LD A, (State.StepCost)
                LD L, A
                LD A, (State.DayFraction)
                ADD A, L
                LD (State.DayFraction), A
                LD BC, #0000
                LD HL, (State.Days)
                PUSH AF
                ADC HL, BC
                POP AF
                LD (State.Days), HL
                JR C, .CheckDeadline                                            ; переход, если прибавление дроби дня завершило очередные сутки

                XOR A
                CALL TickCastle                                                 ; обновить угрозу замку, автоматически разрешить штурм либо подготовить перенос героя
                RET

.CheckDeadline  LD DE, (State.Deadline)
                OR A
                SBC HL, DE
                JR NZ, .DailyUpdates                                            ; переход, если текущий день не совпал с предельным сроком приключения

                LD C, #01
                CALL RunOverlay20                                               ; выполнить оверлей 20 и продолжить подсчётом записей

                ; дневные изменения маны, развития отрядов и подчинения
.DailyUpdates   CALL PrintDate                                                  ; разобрать счётчик дней и вывести календарную дату
                CALL RegenMana                                                  ; пополнить численные запасы с ограничением максимума
                CALL DevelopTroops                                              ; повышать либо понижать типы отрядов по счётчикам
                CALL CheckRevolt                                                ; проверить превышение контроля и обработать доплату либо бой с отделившимся отрядом
                LD A, #01
                CALL TickCastle                                                 ; обновить угрозу замку, автоматически разрешить штурм либо подготовить перенос героя
                LD HL, (State.Days)
                LD DE, #0007
                LD BC, #FFFF
                OR A
.CountWeeks     INC BC
                SBC HL, DE
                JR NC, .CountWeeks                                              ; переход, если в числе дней ещё содержится полный недельный интервал

                ADD HL, DE
                LD A, H
                OR L
                JP NZ, .Return                                                  ; переход, если сегодня не наступила граница недельного расчёта

                CALL StopView                                                   ; выключить обработку объектов в прерывании
                CALL WeekEvent                                                  ; обработать наступление новой недели и связанное изменение типа существ
                CALL RefreshTowns                                               ; обновить армии объектов группы #6AF9
                CALL RepopulateSites                                            ; восстановить население опустевших объектов по ближайшему населённому объекту
                CALL MoveSitesC                                                 ; случайно переместить записи группы #6B39 в соседнюю свободную клетку
                CALL SumCastleIncome                                            ; сложить доход принадлежащих герою замков на четырёх континентах
                LD HL, Engine.TickTime.Income                                   ; пятибайтный недельный доход замков
                CALL StoreFloat5                                                ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD HL, State.BaseIncome
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                LD HL, State.Money
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F                                                          ; addition, сложение, 977C
                DB #0F                                                          ; addition, сложение, 977D
                DB #38                                                          ; end-calc, возврат в Z80, 977E
                LD HL, State.Money
                CALL StoreFloat5                                                ; сохранить вершину калькулятора в пятибайтное поле по HL
                CALL ClearLeftPanel                                             ; очистить основную область слева от боковой панели
                LD BC, #0400
                LD DE, #0312
                LD A, #47
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #05
                LD DE, Engine.TickTime.IncomeText                               ; текст недельных комиссионных, налогов и наличных
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD HL, State.BaseIncome
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                LD BC, #0510
                CALL DrawNumber                                                 ; преобразовать число и вывести символы подряд
                LD HL, Engine.TickTime.Income                                   ; пятибайтный недельный доход замков
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                LD BC, #060A
                CALL DrawNumber                                                 ; преобразовать число и вывести символы подряд
                LD HL, State.Money
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                LD BC, #0710
                CALL DrawNumber                                                 ; преобразовать число и вывести символы подряд
                LD IX, Engine.TickTime.ExpenseList
                LD DE, #0006
                LD B, #07
.ResetChoices   RES EXP_PAY_BIT, (IX + FExpense.Flags)                          ; статья выбрана для оплаты и включается в SumExpenses
                RES EXP_ACTIVE_BIT, (IX + FExpense.Flags)                       ; статья расходов существует и показана в текущем недельном расчёте
                ADD IX, DE
                DJNZ .ResetChoices

                LD BC, #0900
                LD DE, #0D12
                LD A, #47
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD A, (State.Army)
                OR A
                JR NZ, .ShowExpenses                                            ; переход, если у героя есть отряды для вывода расходов на армию

                LD BC, #0A01
                LD DE, #0612
                LD A, #42
                CALL FillAttributes                                             ; заполнить прямоугольник атрибутов цветом A
                LD B, #0B
                LD DE, Engine.TickTime.NoArmyText                               ; предупреждение об отсутствии армии
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                JR .CheckCult

                ; подготовка списка регулярных расходов для выбора оплаты
.ShowExpenses   LD BC, #0A02
                LD DE, Engine.TickTime.PayrollText                              ; заголовок Выплата жалования
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD HL, Engine.TickTime.ExpenseList
                LD (Engine.TickTime.ExpenseItem), HL
                LD BC, #0B03
                LD (Engine.TickTime.ExpensePos), BC
                LD IY, State.Army
                LD B, #05
.ExpenseTroops  LD A, (IY + FTroop.ID)
                OR A
                JR Z, .ShowCult                                                 ; переход, если достигнут конец армии при подготовке расходов

                PUSH BC
                CALL UnitDesc                                                   ; получить описатель типа отряда
                PUSH IX
                POP DE
.ExpensePos     EQU $+1                                                         ; позиция вывода очередной статьи расходов
.ExpenseRow     EQU $+2                                                         ; строка вывода очередной статьи расходов
                LD BC, #0000
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                CALL StackTroopCost                                             ; передать стоимость отряда на стек калькулятора
.ExpenseItem    EQU $+1                                                         ; указатель записи FExpense для текущего отряда
                LD HL, #0000
                SET EXP_ACTIVE_BIT, (HL)                                        ; статья расходов существует и показана в текущем недельном расчёте
                INC HL
                CALL StoreFloat5                                                ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD (Engine.TickTime.ExpenseItem), HL
                LD BC, (Engine.TickTime.ExpensePos)
                LD C, #12
                CALL DrawNumber                                                 ; преобразовать число и вывести символы подряд
                LD A, (Engine.TickTime.ExpenseRow)
                INC A
                LD (Engine.TickTime.ExpenseRow), A
                POP BC
                INC IY
                INC IY
                INC IY
                DJNZ .ExpenseTroops

.ShowCult       LD BC, #1002
                LD DE, Engine.TickTime.RuleLine                                 ; линия разделения финансового отчёта
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
.CheckCult      LD A, (State.Cult)
                OR A
                JR Z, .CheckShip                                                ; переход, если у героя нет действующей секты

                LD HL, Engine.TickTime.CultExpense
                SET EXP_ACTIVE_BIT, (HL)                                        ; статья расходов существует и показана в текущем недельном расчёте
                INC HL
                LD BC, #3A98
                CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
                CALL StoreFloat5                                                ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD A, (State.Cult)
                CALL NthName                                                    ; найти строку имени в списке с нулевыми разделителями
                LD (Engine.TickTime.CultNameText), DE
                LD (Engine.TickTime.UnpaidCultText), DE
                LD DE, Engine.TickTime.CultCostText                             ; подпись Храму с подстановкой имени секты
                LD BC, #1102
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD BC, #3A98
                CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
                LD BC, #1112
                CALL DrawNumber                                                 ; преобразовать число и вывести символы подряд
.CheckShip      LD A, (State.ShipPos)
                CP #FF
                JR Z, .StackMoney                                               ; переход, если у героя нет корабля для начисления содержания

                CALL ArmyRating                                                 ; рассчитать оценку армии из суммы взвешенных количеств
                LD HL, Engine.TickTime.ShipExpense
                SET EXP_ACTIVE_BIT, (HL)                                        ; статья расходов существует и показана в текущем недельном расчёте
                INC HL
                CALL StoreFloat5                                                ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD DE, Engine.TickTime.ShipCostText                             ; подпись платы за корабль
                LD BC, #1202
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD BC, #1212
                CALL DrawNumber                                                 ; преобразовать число и вывести символы подряд
.StackMoney     LD HL, State.Money
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                XOR A
                CALL StackA                                                     ; передать байт A на стек калькулятора ROM
                LD IX, Engine.TickTime.ExpenseList
                LD IY, Engine.TickTime.PaymentRects                             ; прямоугольники выбора семи статей недельных расходов
                LD B, #07

                ; суммирование стоимости отмеченных статей расходов
.ExpenseItems   PUSH BC
                LD A, #01
                BIT EXP_ACTIVE_BIT, (IX + FExpense.Flags)                       ; статья расходов существует и показана в текущем недельном расчёте
                JR Z, .StoreChoice                                              ; переход, если статья расходов не участвует в текущем расчёте

                PUSH IX
                POP HL
                INC HL
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F                                                          ; addition, сложение, 98D9
                DB #38                                                          ; end-calc, возврат в Z80, 98DA
                LD A, (IX + FExpense.Flags)
                AND #1F
.StoreChoice    LD (IY + FMenuRect.Top), A
                INC A
                LD (IY + FMenuRect.Bottom), A
                LD DE, #0006
                ADD IX, DE
                LD DE, #0004
                ADD IY, DE
                POP BC
                DJNZ .ExpenseItems

                CALL FloatSignZero                                              ; определить знак и нулевое значение результата калькулятора
                LD B, #44
                LD C, #80
                JR NC, .ReadSelection                                           ; переход, если наличных денег достаточно для выбранных расходов

                LD B, #42
                LD C, #00
.ReadSelection  LD IX, Engine.TickTime.ExpenseList
                LD A, B
                LD (Engine.TickTime.PaidColor), A
                LD A, C
                LD (Engine.TickTime.PaymentFlag), A
                LD DE, #0006
                LD B, #07
.DrawExpenses   PUSH BC
                BIT EXP_ACTIVE_BIT, (IX + FExpense.Flags)                       ; статья расходов существует и показана в текущем недельном расчёте
                JR Z, .NextExpense                                              ; переход, если статья расходов не отображается в списке

                LD A, (IX + FExpense.Flags)
                AND #1F
                LD B, A
                LD C, #01
                LD DE, #0112
.PaidColor      EQU $+1                                                         ; атрибут списка расходов при текущей платёжеспособности
                LD A, #00
                CALL FillAttributes                                             ; заполнить прямоугольник атрибутов цветом A
                LD A, (IX + FExpense.Flags)
.PaymentFlag    EQU $+1                                                         ; бит 7, включающий оплату статьи при наличии денег
                OR #00
                LD (IX + FExpense.Flags), A
.NextExpense    LD DE, #0006
                ADD IX, DE
                POP BC
                DJNZ .DrawExpenses

                LD BC, #1302
                LD DE, Engine.TickTime.RuleLine                                 ; линия разделения финансового отчёта
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                LD DE, Engine.TickTime.TotalCostText                            ; заголовок общих расходов
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD BC, #1502
                LD DE, Engine.TickTime.RuleLine                                 ; линия разделения финансового отчёта
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                CALL SumExpenses                                                ; сложить отмеченные статьи расходов
.ShowBalance    LD BC, #140D
                LD DE, #0105
                LD A, #47
                CALL ClearRectangle                                             ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD HL, Engine.TickTime.PaymentTotal                             ; сумма отмеченных для оплаты недельных расходов
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                LD BC, #1412
                CALL DrawNumber                                                 ; преобразовать число и вывести символы подряд

                ; переключение оплачиваемой статьи с проверкой наличных денег
.SelectPayment  LD IX, Engine.TickTime.PaymentMenu                              ; описатель меню недельных платежей
                CALL SelectMenuItem                                             ; управлять указателем и выбрать прямоугольный пункт меню
                CP #08
                JR Z, .PayExpenses                                              ; переход, если игрок подтвердил выбранные расходы

                LD IX, Engine.TickTime.ExpenseList - FExpense                   ; база перед первой статьёй расходов, цикл сначала прибавляет FExpense
                LD DE, #0006
.FindExpense    ADD IX, DE
                DEC A
                JR NZ, .FindExpense                                             ; переход, если ещё не найдена выбранная статья расходов

                LD A, (IX + FExpense.Flags)
                XOR #80
                LD (IX + FExpense.Flags), A
                CALL SumExpenses                                                ; сложить отмеченные статьи расходов
                LD HL, State.Money
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Engine.TickTime.PaymentTotal                             ; сумма отмеченных для оплаты недельных расходов
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                CALL FloatSignZero                                              ; определить знак и нулевое значение результата калькулятора
                JR NC, .SetItemColor                                            ; переход, если изменённый выбор ещё укладывается в наличные деньги

                LD A, (IX + FExpense.Flags)
                XOR #80
                LD (IX + FExpense.Flags), A
                CALL SumExpenses                                                ; сложить отмеченные статьи расходов
                JR .SelectPayment

.SetItemColor   LD C, #44
                LD A, (IX + FExpense.Flags)
                BIT EXP_PAY_BIT, A                                              ; статья выбрана для оплаты и включается в SumExpenses
                JR NZ, .ConfirmItem                                             ; переход, если статья выбрана для оплаты

                LD C, #42
.ConfirmItem    AND #1F
                LD B, A
                LD A, C
                LD C, #01
                LD DE, #0112
                CALL FillAttributes                                             ; заполнить прямоугольник атрибутов цветом A
                JR .ShowBalance

                ; окончательное списание выбранных расходов
.PayExpenses    LD HL, State.Money
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Engine.TickTime.PaymentTotal                             ; сумма отмеченных для оплаты недельных расходов
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #03                                                          ; subtract, вычитание, 99D3
                DB #38                                                          ; end-calc, возврат в Z80, 99D4
                LD HL, State.Money
                CALL StoreFloat5                                                ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD A, (Engine.TickTime.ShipExpense)
                AND #C0
                CP #40
                JP NZ, .ApplyWeekly                                             ; переход, если корабельное содержание не привело к утрате корабля

                CALL ClearLeftPanel                                             ; очистить основную область слева от боковой панели
                LD BC, #0900
                LD DE, #0412
                LD A, #42
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0B
                LD DE, Engine.TickTime.ShipLostText                             ; сообщение о невозможности содержать корабль
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL WaitOrInput                                                ; выдержать паузу с досрочным выходом по вводу
                LD A, (State.MoveFlags)
                AND #03
                CP #01
                JR NZ, .RemoveShip                                              ; переход, если герой находится не в режиме корабля

                LD HL, State.Army
                LD B, #05
.CheckFlying    LD A, (HL)
                OR A
                JR Z, .FindSafeOrigin                                           ; переход, если достигнут конец армии при проверке способности пережить крушение

                CALL UnitFlags                                                  ; прочитать пару флагов описателя отряда
                BIT UNIT_AFLOAT_BIT, E                                          ; способность типа защищает от отметки утонувшего при утрате корабля
                JR NZ, .NextFlyUnit                                             ; переход, если отряд допускает выживание при утрате корабля

                SET TROOP_DROWN_BIT, (HL)                                       ; временная отметка утонувшего отряда в старших битах ID недельного расчёта
.NextFlyUnit    INC HL
                INC HL
                INC HL
                DJNZ .CheckFlying

                ; поиск свободной суши после утраты возможности содержать корабль
.FindSafeOrigin LD BC, (State.Position)
                LD A, B
                SUB #05
                JR NC, .ClampSafeY                                              ; переход, если вычитание отступа не вывело область поиска суши выше карты

                XOR A
.ClampSafeY     LD B, A
                LD A, C
                SUB #05
                JR NC, .SafeOrigin                                              ; переход, если вычитание отступа не вывело область поиска суши левее карты

                XOR A
.SafeOrigin     LD C, A
.SafeRow        PUSH BC
                LD E, #0A
.SafeCell       CALL ReadMapCell                                                ; прочитать байт клетки текущей карты
                BIT MAP_BUSY_BIT, A                                             ; клетка стратегической карты занята объектом
                JR NZ, .NextSafeCell                                            ; переход, если клетка поиска суши занята

                AND #3F
                JR Z, .MoveToSafety                                             ; переход, если найдена свободная клетка суши

.NextSafeCell   INC C
                DEC E
                JR NZ, .SafeCell                                                ; переход, если в строке поиска суши остались клетки

                POP BC
                INC B
                JR .SafeRow

.MoveToSafety   POP DE
                LD (State.Position), BC
                LD A, (State.MoveFlags)
                AND #FC
                LD (State.MoveFlags), A
                CALL UpdateLocalView                                            ; отметить открытые клетки вокруг героя и подготовить экранные объекты
                HALT
                LD B, #0A
                CALL WaitOrInput                                                ; выдержать паузу с досрочным выходом по вводу
                CALL StopView                                                   ; выключить обработку объектов в прерывании
                CALL ClearLeftPanel                                             ; очистить основную область слева от боковой панели
.RemoveShip     LD A, #FF
                LD (State.ShipPos), A
                LD (State.ShipPos + FPosition.Y), A

                ; последствия оплаты культа и восстановление магической силы
.ApplyWeekly    LD A, (Engine.TickTime.CultExpense)
                AND #C0
                CP #40
                JR NZ, .RegenHeroMana                                           ; переход, если не произошло событие выбранной секты

                CALL ClearLeftPanel                                             ; очистить основную область слева от боковой панели
                LD BC, #0900
                LD DE, #0612
                LD A, #42
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0B
                LD DE, Engine.TickTime.CultUnpaidText                           ; сообщение об отсутствии пожертвования храму
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL WaitOrInput                                                ; выдержать паузу с досрочным выходом по вводу
                LD HL, State.Army
                LD B, #05
.CheckGrowth    LD A, (HL)
                OR A
                JR Z, .TypeGrowth                                               ; переход, если достигнут конец армии при применении культового события

                AND #1F
                CALL UnitDesc                                                   ; получить описатель типа отряда
                LD A, (State.Cult)
                CP (IX + FSoldier.SectID)
                JR NZ, .NextGrowth                                              ; переход, если секта отряда отличается от секты героя

                SET TROOP_REBEL_BIT, (HL)                                       ; временная отметка отряда для нападения на героя при финансовом либо культовом событии
.NextGrowth     INC HL
                INC HL
                INC HL
                DJNZ .CheckGrowth

.TypeGrowth     LD HL, State.UnitControl + 24                                   ; последний из25байтов коэффициентов контроля, обратный проход по типам
                LD B, #19
.TypeLoop       LD A, B
                CALL UnitDesc                                                   ; получить описатель типа отряда
                LD A, (IX + FSoldier.SectID)
                CP #05
                JR NZ, .CheckCultType                                           ; переход, если тип существа не относится к общей совместимой секте

                LD A, (HL)
                SRL A
                JR .GrowType

.CheckCultType  LD A, (State.Cult)
                CP (IX + FSoldier.SectID)
                JR NZ, .NextType                                                ; переход, если секта типа не совпадает с сектой героя

                LD A, (HL)
.GrowType       SRL A
                INC A
                ADD A, (HL)
                JR NC, .StoreGrowth                                             ; переход, если прирост численности типа не превысил байтовый предел

                LD A, #FF
.StoreGrowth    LD (HL), A
.NextType       DEC HL
                DJNZ .TypeLoop

                XOR A
                LD (State.Cult), A
                JR .CheckArmy

.RegenHeroMana  LD HL, (State.Mana)
                LD DE, (State.ManaMax)
                LD BC, #03E8
                CALL AddClampedU16                                              ; прибавить BC к HL с верхней границей DE
                LD (State.Mana), HL
.CheckArmy      LD A, (State.Army)
                OR A
                JP Z, .RefreshHero                                              ; переход, если армия героя пуста после финансового события

                LD HL, State.Army
                LD IY, Engine.TickTime.ExpenseList
                LD B, #05

                ; пометка неоплаченных отрядов как мятежных или сбежавших по свойствам типа
.MarkUnpaid     LD A, (HL)
                OR A
                JR Z, .ShowArmyReport                                           ; переход, если достигнут конец армии при маркировке неоплаченных отрядов

                BIT EXP_PAY_BIT, (IY + FExpense.Flags)                          ; статья выбрана для оплаты и включается в SumExpenses
                JR NZ, .NextArmyUnit                                            ; переход, если содержание этого отряда оплачено

                AND #1F
                CALL UnitFlags                                                  ; прочитать пару флагов описателя отряда
                BIT UNIT_MUTINY_BIT, D                                          ; при неоплаченном содержании тип выбирает нападение на героя вместо побега
                JR Z, .MarkDesertion                                            ; переход, если свойства типа задают побег вместо нападения на героя

                SET TROOP_REBEL_BIT, (HL)                                       ; временная отметка отряда для нападения на героя при финансовом либо культовом событии
                JR .NextArmyUnit

.MarkDesertion  SET TROOP_FLED_BIT, (HL)                                        ; временная отметка сбежавшего неоплаченного отряда в ID
.NextArmyUnit   INC HL
                INC HL
                INC HL
                LD DE, #0006
                ADD IY, DE
                DJNZ .MarkUnpaid

                ; показ состояния каждого отряда после финансового события
.ShowArmyReport CALL ClearLeftPanel                                             ; очистить основную область слева от боковой панели
                LD BC, #0700
                LD DE, #0912
                LD A, #47
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #0902
                LD DE, Engine.TickTime.ArmyStateText                            ; заголовок отчёта Состояние вашей армии
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD IY, State.Army
                LD BC, #0B02
                LD (Engine.TickTime.ReportPos), BC
                LD B, #05
.ReportUnit     LD A, (IY + FTroop.ID)
                OR A
                JR Z, .WaitReport                                               ; переход, если достигнут конец армии при выводе отчёта

                PUSH BC
                AND #1F
                CALL UnitDesc                                                   ; получить описатель типа отряда
                PUSH IX
                POP DE
.ReportPos      EQU $+1                                                         ; позиция строки отчёта о содержании армии
.ReportRow      EQU $+2                                                         ; строка отчёта о содержании армии
                LD BC, #0000
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD DE, Engine.TickTime.StayedText                               ; состояние отряда остались
                BIT TROOP_DROWN_BIT, (IY + FTroop.ID)                           ; временная отметка утонувшего отряда в старших битах ID недельного расчёта
                JR Z, .ShowDeserted                                             ; переход, если отряд не отмечен погибшим при утрате корабля

                LD DE, Engine.TickTime.DrownedText                              ; состояние отряда утонули
                JR .ShowStatus

.ShowDeserted   BIT TROOP_REBEL_BIT, (IY + FTroop.ID)                           ; временная отметка отряда для нападения на героя при финансовом либо культовом событии
                JR Z, .CheckLost                                                ; переход, если отряд не отмечен мятежным

                LD DE, Engine.TickTime.RebelText                                ; состояние отряда атакуют
                JR .ShowStatus

.CheckLost      BIT TROOP_FLED_BIT, (IY + FTroop.ID)                            ; временная отметка сбежавшего неоплаченного отряда в ID
                JR Z, .ShowStatus                                               ; переход, если отряд не отмечен сбежавшим

                LD DE, Engine.TickTime.DesertedText                             ; состояние отряда сбежали
.ShowStatus     LD BC, (Engine.TickTime.ReportPos)
                LD C, #11
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD A, (Engine.TickTime.ReportRow)
                INC A
                LD (Engine.TickTime.ReportRow), A
                POP BC
                INC IY
                INC IY
                INC IY
                DJNZ .ReportUnit

.WaitReport     LD B, #3C
                CALL WaitOrInput                                                ; выдержать паузу с досрочным выходом по вводу
                LD HL, State.Army
                LD B, #05

                ; удаление отрядов с отметками гибели или побега
.RemoveLosses   LD A, (HL)
                OR A
                JR Z, .CompactLosses                                            ; переход, если достигнут конец армии при удалении погибших и сбежавших

                AND #60
                JR Z, .NextLoss                                                 ; переход, если отряд не имеет отметки гибели или побега

                LD (HL), #00
.NextLoss       INC HL
                INC HL
                INC HL
                DJNZ .RemoveLosses

.CompactLosses  LD HL, State.Army
                LD B, #05
                CALL CompactArmy                                                ; сжать список трёхбайтных записей армии
                LD HL, Engine.TickTime.RebelArmy
                LD DE, Engine.TickTime.RebelArmy + 1                            ; следующий байт при очистке временной армии мятежников
                LD (HL), #00
                LD BC, #000E
                LDIR
                LD HL, State.Army
                LD DE, Engine.TickTime.RebelArmy
                LD B, #05

                ; выделение мятежных отрядов в отдельную армию
.CollectRebels  LD A, (HL)
                OR A
                JR Z, .CompactRebels                                            ; переход, если достигнут конец армии при выделении мятежников

                BIT TROOP_REBEL_BIT, A                                          ; временная отметка отряда для нападения на героя при финансовом либо культовом событии
                JR Z, .NextRebel                                                ; переход, если отряд не отмечен мятежным

                LD A, (HL)
                AND #1F
                LD (DE), A
                LD (HL), #00
                INC DE
                INC HL
                LD C, #FF
                LDI
                LDI
                JR .RebelTail

.NextRebel      INC HL
                INC HL
                INC HL
.RebelTail      DJNZ .CollectRebels

.CompactRebels  LD HL, State.Army
                LD B, #05
                CALL CompactArmy                                                ; сжать список трёхбайтных записей армии
                LD A, (Engine.TickTime.RebelArmy)
                OR A
                JR Z, .RefreshHero                                              ; переход, если после выделения не осталось мятежных отрядов

                LD A, #03
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD DE, #0000
                LD A, (Engine.TickTime.CultExpense)
                AND #C0
                CP #40
                JR NZ, .FightRebels                                             ; переход, если культовое событие не задаёт дополнительное условие боя

                LD DE, #2328
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                EX DE, HL
                LD DE, #03E8
                ADD HL, DE
                EX DE, HL

                ; бой героя с выделенной армией мятежников
.FightRebels    LD IX, Engine.TickTime.RebelArmy
                LD BC, (State.Position)
                CALL ReadMapCell                                                ; прочитать байт клетки текущей карты
                AND #3F
                CALL TerrainBattle                                              ; преобразовать местность по второй таблице порогов
                LD BC, #0500
                CALL Battle.Battle                                              ; выполнить бой на поле 8 на 5 клеток
                OR A
                JR NZ, .LoseRebelFight                                          ; переход, если бой с мятежниками закончился непобедой

                CALL ClearLeftPanel                                             ; очистить основную область слева от боковой панели
                CALL RefreshPanels                                              ; перерисовать верхнюю строку и боковую панель игры
                LD BC, #0800
                LD DE, #0412
                LD A, #42
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0A
                LD DE, Engine.TickTime.VictoryText                              ; сообщение успешного подавления мятежа
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL WaitOrInput                                                ; выдержать паузу с досрочным выходом по вводу
                JR .Return

.LoseRebelFight CALL LoseLeadership                                             ; уменьшить 16 битное поле героя #6A02 с насыщением 0
                CALL RefreshPanels                                              ; перерисовать верхнюю строку и боковую панель игры
                CALL ClearLeftPanel                                             ; очистить основную область слева от боковой панели
                CALL UpdateLocalView                                            ; отметить открытые клетки вокруг героя и подготовить экранные объекты
                HALT
                LD B, #0A
                CALL WaitOrInput                                                ; выдержать паузу с досрочным выходом по вводу
                CALL StopView                                                   ; выключить обработку объектов в прерывании
                JR .Return

.RefreshHero    CALL RefreshHero                                                ; обновить боковую панель героя, расходы и рейтинг
.Return         RET

.Income         EQU $                                                           ; пятибайтный недельный доход замков
.PaymentTotal   EQU $+5                                                         ; сумма отмеченных для оплаты недельных расходов
                DB #00, #00, #00, #00, #00, #00, #00, #00
.RebelArmy      EQU $+2                                                         ; временная группа восставших отрядов
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
.ExpenseList    EQU $+1                                                         ; семь шестибайтных статей недельных расходов
                DB #00, #0B, #00, #00, #00, #00, #00, #0C
                DB #00, #00, #00, #00, #00, #0D, #00, #00
                DB #00, #00, #00, #0E, #00, #00, #00, #00
.CultExpense    EQU $+7                                                         ; заголовок статьи расходов на секту
                DB #00, #0F, #00, #00, #00, #00, #00, #11
.ShipExpense    EQU $+5                                                         ; заголовок статьи расходов на корабль
                DB #00, #00, #00, #00, #00, #12, #00, #00
.PaymentMenu    EQU $+3                                                         ; описатель меню недельных платежей
                DB #00, #00, #00, #08, #0A, #48, #98, #B8
.PaymentRects   EQU $+2                                                         ; прямоугольники выбора семи статей недельных расходов
                DB #32, #B4, #01, #00, #13, #00, #01, #00
                DB #13, #00, #01, #00, #13, #00, #01, #00
                DB #13, #00, #01, #00, #13, #00, #01, #00
                DB #13, #00, #01, #00, #13, #00, #01, #16
.ArmyStateText  EQU $+2                                                         ; заголовок отчёта Состояние вашей армии
                DB #13, #17, #91, #AE, #E1, #E2, #AE, #EF
                DB #AD, #A8, #A5, #20, #A2, #A0, #E8, #A5
                DB #A9, #20, #A0, #E0, #AC, #A8, #A8, #3A
.DrownedText    EQU $+1                                                         ; состояние отряда утонули
                DB #00, #E3, #E2, #AE, #AD, #E3, #AB, #A8
.DesertedText   EQU $+1                                                         ; состояние отряда сбежали
                DB #00, #E1, #A1, #A5, #A6, #A0, #AB, #A8
.RebelText      EQU $+1                                                         ; состояние отряда атакуют
                DB #00, #A0, #E2, #A0, #AA, #E3, #EE, #E2
.StayedText     EQU $+1                                                         ; состояние отряда остались
                DB #00, #AE, #E1, #E2, #A0, #AB, #A8, #E1
.VictoryText    EQU $+2                                                         ; сообщение успешного подавления мятежа
                DB #EC, #00, #11, #00, #1A, #82, #A0, #AC
                DB #20, #E3, #A4, #A0, #AB, #AE, #E1, #EC
                DB #0D, #2A, #A2, #E1, #A5, #E5, #20, #E3
                DB #E1, #AC, #A5, #E0, #A8, #E2, #EC, #2E
.ShipLostText   EQU $+5                                                         ; сообщение о невозможности содержать корабль
                DB #2E, #2E, #0D, #2A, #00, #11, #00, #1A
                DB #82, #EB, #20, #A1, #AE, #AB, #EC, #E8
                DB #A5, #20, #AD, #A5, #20, #AC, #AE, #A6
                DB #A5, #E2, #A5, #0D, #2A, #E1, #AE, #A4
                DB #A5, #E0, #A6, #A0, #E2, #EC, #20, #AA
                DB #AE, #E0, #A0, #A1, #AB, #EC, #2E, #2E
.ShipCostText   EQU $+4                                                         ; подпись платы за корабль
                DB #2E, #0D, #2A, #00, #87, #A0, #20, #AA
                DB #AE, #E0, #A0, #A1, #AB, #EC, #3A, #00
.CultNameText   EQU $+7                                                         ; адрес имени секты в строке недельного платежа
.CultCostText   EQU $                                                           ; подпись Храму с подстановкой имени секты
                DB #95, #E0, #A0, #AC, #E3, #20, #0E, #00
.IncomeText     EQU $+2                                                         ; текст недельных комиссионных, налогов и наличных
                DB #00, #00, #8A, #AE, #AC, #A8, #E1, #E1
                DB #A8, #AE, #AD, #AD, #EB, #A5, #3A, #0D
                DB #02, #8D, #A0, #AB, #AE, #A3, #A8, #3A
                DB #0D, #02, #91, #A5, #A9, #E7, #A0, #E1
                DB #20, #E3, #20, #A2, #A0, #E1, #3A, #0D
.NoArmyText     EQU $+2                                                         ; предупреждение об отсутствии армии
                DB #02, #00, #11, #00, #1A, #93, #20, #A2
                DB #A0, #E1, #20, #E1, #A5, #A9, #E7, #A0
                DB #E1, #20, #AD, #A5, #E2, #20, #A0, #E0
                DB #AC, #A8, #A8, #2C, #0D, #2A, #ED, #E2
                DB #AE, #20, #AE, #E7, #A5, #AD, #EC, #20
                DB #AE, #AF, #A0, #E1, #AD, #AE, #20, #21
                DB #0D, #2A, #8D, #A0, #A9, #AC, #A8, #E2
                DB #A5, #20, #AA, #AE, #A3, #AE, #2D, #AD
                DB #A8, #A1, #E3, #A4, #EC, #2E, #0D, #2A
.PayrollText    EQU $+1                                                         ; заголовок Выплата жалования
                DB #00, #82, #EB, #AF, #AB, #A0, #E2, #A0
                DB #20, #A6, #A0, #AB, #AE, #A2, #A0, #AD
.RuleLine       EQU $+4                                                         ; линия разделения финансового отчёта
                DB #A8, #EF, #3A, #00, #C4, #C4, #C4, #C4
                DB #C4, #C4, #C4, #C4, #C4, #C4, #C4, #C4
                DB #C4, #C4, #C4, #C4, #C4, #C4, #C4, #C4
.TotalCostText  EQU $+3                                                         ; заголовок общих расходов
                DB #C4, #C4, #00, #11, #00, #1A, #8E, #A1
                DB #E9, #A8, #A5, #20, #E0, #A0, #E1, #E5
                DB #AE, #A4, #EB, #3A, #0D, #02, #0D, #00
                DB #82, #EB, #AF, #AB, #A0, #E2, #A8, #E2
.CultUnpaidText EQU $+4                                                         ; сообщение об отсутствии пожертвования храму
                DB #EC, #0D, #2A, #00, #11, #00, #1A, #82
                DB #EB, #20, #AD, #A8, #E7, #A5, #A3, #AE
                DB #0D, #2A, #AD, #A5, #20, #AF, #AE, #A6
                DB #A5, #E0, #E2, #A2, #AE, #A2, #A0, #AB
                DB #A8, #20, #A2, #0D, #2A, #AF, #AE, #AB
                DB #EC, #A7, #E3, #20, #95, #E0, #A0, #AC
.UnpaidCultText EQU $+3                                                         ; поле подстановки имени неоплаченной секты
                DB #A0, #20, #0E, #00, #00, #0D, #2A, #8E
                DB #E7, #A5, #AD, #EC, #20, #A6, #A0, #AB
                DB #EC, #2E, #2E, #2E, #0D, #2A, #00
