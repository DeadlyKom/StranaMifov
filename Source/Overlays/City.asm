; оверлей 02 из OVR1
; исходный файл каталога 48, смещение #0770
                module Overlay
                module City
                org #B200

; -----------------------------------------
; посещение города и операции с его ресурсами
; Строит городское меню. Ветви проверяют отношение города к герою, стоимость корабля и осадных
; орудий, доступность ближайшего замка и контракта. Для найма ищет пустой либо совпадающий ID
; среди пяти отрядов, вычисляет и показывает возможное добавление по управляемости через #86B1.
; Однако введённое количество непосредственно ограничивает наличием существ в городе и доступными
; деньгами, отдельного сравнения с показанной управляемостью в этой ветви нет. Изменённые
; показатели города и героя остаются в ядре и самом оверлее, сохранение оверлея выполняет
; диспетчер.
; In:
;   текущее состояние героя, армии и объекта в ядре
; Out:
;   состояние обновлено выбранной ветвью либо сохранено при отказе
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; -----------------------------------------
Entry           INC IX
                INC IX
                INC IX
                LD (ShipPrice.CityName), IX
                XOR A
                LD (ShipPrice.Relation), A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                CALL Engine.CheckCalls                                          ; проверить неизменность трёх инструкций CALL #6B8D
                BIT TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)             ; флаг, город требует ранней проверки гарнизона и отказывает в сведениях о замке и новом контракте
                JR NZ, .CheckCityUnits                                          ; переход, если город отмечен как враждебный герою

                LD HL, State.Army
                LD B, #05
.CheckArmyTypes LD A, (HL)
                OR A
                JR Z, .ShowCity                                                 ; переход, если в армии больше нет типов, способных спровоцировать город

                CALL Engine.UnitFlags                                           ; прочитать пару флагов описателя отряда
                BIT UNIT_CITY_BIT, D                                            ; флаг, тип существ разрешает раннюю городскую проверку даже без установленной отметки города
                JR NZ, .CheckCityUnits                                          ; переход, если текущий тип существ вызывает раннюю городскую проверку

                INC HL
                INC HL
                INC HL
                DJNZ .CheckArmyTypes

                JR .ShowCity

.CheckCityUnits LD A, (IX + FTown.Army - FTown.Name + FTroop.ID)
                OR A
                JR Z, .NeutralCity                                              ; переход, если у города нет гарнизона для боя

                SET TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)             ; флаг, город требует ранней проверки гарнизона и отказывает в сведениях о замке и новом контракте
                LD A, #03
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD DE, #000E
                ADD IX, DE
                LD DE, #0000
                LD BC, #0300
                LD A, #07
                CALL Battle.Battle                                              ; выполнить бой на поле 8 на 5 клеток
                PUSH AF
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                POP AF
                OR A
                JR Z, .FriendlyCity                                             ; переход, если герой победил городской гарнизон

                CALL Engine.LoseLeadership                                      ; уменьшить 16 битное поле героя #6A02 с насыщением 0
                CALL Engine.LoseLeadership                                      ; уменьшить 16 битное поле героя #6A02 с насыщением 0
                LD BC, #0000
                LD DE, #1820
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD BC, #0801
                LD DE, #041C
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0A
                LD DE, Overlay.City.ShipPrice.HostileDefeat                     ; сообщение после поражения в бою с городским гарнизоном
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                CALL Engine.MoveToTarget                                        ; преобразовать направление к цели в команду движения героя
                RET

.FriendlyCity   LD A, #02
                LD (ShipPrice.Relation), A
                JR .ShowCity

.NeutralCity    LD A, #01
                LD (ShipPrice.Relation), A

                ; стоимости осадного орудия и корабля пересчитываются перед выводом городского меню
.ShowCity       CALL SiegePrice
                CALL ShipPrice
                LD A, #02
                CALL Engine.ShowScene                                           ; показать одну из девяти упакованных сцен BL1/BL2 с восстановлением банка и основных регистров
                LD A, (ShipPrice.Relation)
                LD B, A
                INC B
                LD IY, Overlay.City.ShipPrice.CityMessages - FCityMessage       ; база на одну запись перед таблицей сообщений городов
                LD DE, #0005
.FindCityDesc   ADD IY, DE
                DJNZ .FindCityDesc

                LD A, (IY + FCityMessage.Attribute)
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD C, (IY + FCityMessage.Position.Low)
                LD B, (IY + FCityMessage.Position.High)
                LD D, (IY + FCityMessage.Text.High)
                LD E, (IY + FCityMessage.Text.Low)
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
.DrawMenu       LD A, #47
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #1601
                LD DE, #011E
                LD A, #41
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #0F02
                LD DE, Engine.NeedMoreMoney.MoneyText                           ; общая надпись денежных средств
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                CALL RefreshMoney
                LD A, (State.ShipPos)
                CP #FF
                JR NZ, .NoNearbyCastle                                          ; переход, если у героя уже есть корабль и цена покупки не выводится

                LD BC, (ShipPrice.ShipCost)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                LD BC, #1312
                CALL Engine.DrawNumber                                          ; преобразовать число и вывести символы подряд
                LD DE, Overlay.City.ShipPrice.BuyShipText                       ; подпись действия покупки корабля
                JR .SetCastleText

.NoNearbyCastle LD DE, Overlay.City.ShipPrice.SellShipText                      ; подпись действия отказа от корабля
.SetCastleText  LD (ShipPrice.ShipAction), DE
                LD BC, #1102
                LD DE, Overlay.City.ShipPrice.ActionsText                       ; текст основного меню города
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IX, Overlay.City.ShipPrice.ActionsMenu                       ; описатель основного меню города
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #01
                JR NZ, .CastleChoice                                            ; переход, если выбран не пункт покупки осадного орудия

                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (ShipPrice.CityName)
                BIT TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)             ; флаг, город требует ранней проверки гарнизона и отказывает в сведениях о замке и новом контракте
                JR Z, .CheckSiege                                               ; переход, если город не враждебен и допускает покупку осадного орудия

                CALL RefuseEntry
                JR .WaitMessage

                ; осадное орудие нельзя покупать повторно, наличие проверяется в флагах
                ; передвижения героя
.CheckSiege     LD A, (State.MoveFlags)
                BIT HERO_SIEGE_BIT, A                                           ; флаг, у героя есть осадное орудие, перед взлётом требуется его оставить
                JR Z, .CheckSiegeGold                                           ; переход, если осадных орудий у героя ещё нет

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD DE, Overlay.City.ShipPrice.HasSiegeText                      ; сообщение об уже имеющихся осадных орудиях
                LD BC, #1205
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
.WaitMessage    LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JR .DrawMenu

.CheckSiegeGold LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, (ShipPrice.SiegeCost)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                JR NC, .BuySiege                                                ; переход, если денег хватает на покупку осадного орудия

.NeedGold       CALL Engine.NeedMoreMoney                                       ; вывести сообщение о нехватке денег
                JR .WaitMessage

.BuySiege       LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, (ShipPrice.SiegeCost)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #03, #38                                                     ; subtract, вычитание, B374
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD A, (State.MoveFlags)
                SET HERO_SIEGE_BIT, A                                           ; флаг, у героя есть осадное орудие, перед взлётом требуется его оставить
                LD (State.MoveFlags), A
                JP .DrawMenu

.CastleChoice   CP #02
                JP NZ, .ShipChoice                                              ; переход, если выбран не просмотр ближайшего замка

                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (ShipPrice.CityName)
                BIT TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)             ; флаг, город требует ранней проверки гарнизона и отказывает в сведениях о замке и новом контракте
                JR Z, .FindCastle                                               ; переход, если город не враждебен и допускает сведения о ближайшем замке

                CALL RefuseEntry
                JP .WaitMessage

.FindCastle     XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (ShipPrice.CityName)
                LD A, (State.Continent)
                LD E, A
                LD D, #01
                LD HL, #0000
                LD A, #23
                LD C, (IX + FTown.X - FTown.Name)
                LD B, (IX + FTown.Y - FTown.Name)
                CALL Engine.NearestObject                                       ; найти ближайшую активную запись выбранной группы
.ShowCastle     XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD A, #47
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD IY, (ShipPrice.CityName)
                LD C, (IY + FTown.X - FTown.Name)
                LD B, (IY + FTown.Y - FTown.Name)
                LD E, (IX + FCastle.X)
                LD D, (IX + FCastle.Y)
                CALL Engine.GetDirection                                        ; определить одно из восьми направлений от BC к DE
                LD (ShipPrice.DirectionText), DE
                PUSH IX
                POP DE
                INC DE
                INC DE
                INC DE
                LD (ShipPrice.CastleName), DE
                LD BC, #0F05
                LD DE, Overlay.City.ShipPrice.CastleLocation                    ; направление и имя ближайшего замка
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (IX + FCastle.Owner)
                OR A
                JR NZ, .CheckOwner                                              ; переход, если ближайший замок не принадлежит герою

                LD BC, #110B
                LD DE, Overlay.City.ShipPrice.HeroOwner                         ; сообщение о замке героя
                JR .PrintOwner

.CheckOwner     CP #FF
                JR NZ, .KnownOwner                                              ; переход, если владелец ближайшего замка имеет запись правителя

                LD BC, #110A
                LD DE, Overlay.City.ShipPrice.BanditOwner                       ; сообщение о замке без известного правителя
                JR .PrintOwner

.KnownOwner     CALL Engine.RulerDesc                                           ; получить описатель одного из пятнадцати вражеских правителей
                LD (ShipPrice.RulerName), IX
                LD DE, Overlay.City.ShipPrice.RulerOwner                        ; формат владельца замка с именем правителя
                LD BC, #1103
.PrintOwner     CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IY, (ShipPrice.CastleName)
                LD BC, #1203
                LD DE, #0011
                ADD IY, DE
                LD A, #05
                CALL Engine.PrintArmyBrief                                      ; вывести краткий список состава армии
                LD B, #3C
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .DrawMenu

                ; покупка корабля отдельно проверяет деньги, наличие причала и допустимость клетки
.ShipChoice     CP #03
                JP NZ, .ContractChoice                                          ; переход, если выбран не пункт покупки или сдачи корабля

                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (ShipPrice.CityName)
                LD A, (State.ShipPos)
                CP #FF
                JR NZ, .CheckDock                                               ; переход, если у героя уже есть корабль и проверяется возможность его сдачи

                LD A, (IX + FTown.DockPos.Low - FTown.Name)
                OR (IX + FTown.DockPos.High - FTown.Name)
                JR NZ, .CheckShipGold                                           ; переход, если у города заданы ненулевые координаты причала

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #110A
                LD DE, Overlay.City.ShipPrice.NoBuyDock                         ; отказ в покупке корабля в городе без пристани
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                JP .WaitMessage

.CheckShipGold  LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, (ShipPrice.ShipCost)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                JP C, .NeedGold                                                 ; переход, если денег не хватает на покупку корабля

                LD C, (IX + FTown.DockPos.Low - FTown.Name)
                LD B, (IX + FTown.DockPos.High - FTown.Name)
                LD (State.ShipPos), BC
                LD A, (State.Continent)
                LD (State.ShipMap), A
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, (ShipPrice.ShipCost)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #03, #38                                                     ; subtract, вычитание, B494
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                JP .DrawMenu

.CheckDock      LD A, (IX + FTown.DockPos.Low - FTown.Name)
                OR (IX + FTown.DockPos.High - FTown.Name)
                JR NZ, .CheckShipCell                                           ; переход, если у города есть причал для сдачи корабля

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #120C
                LD DE, Overlay.City.ShipPrice.NoSellDock                        ; отказ в отказе от корабля в городе без пристани
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                JP .WaitMessage

.CheckShipCell  LD A, (Engine.ApplyMoveCode.SourceWater)
                OR A
                JR NZ, .ClearShip                                               ; переход, если сохранённый признак исходной клетки разрешает сдать корабль

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #1108
                LD DE, Overlay.City.ShipPrice.ShipElsewhere                     ; отказ, если корабль находится не у этой пристани
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                JP .WaitMessage

.ClearShip      LD BC, #FFFF
                LD (State.ShipPos), BC
                LD A, #FF
                LD (State.ShipMap), A
                JP .DrawMenu

                ; контракт требует подходящего города и отсутствия уже действующего задания
.ContractChoice CP #04
                JP NZ, .RecruitChoice                                           ; переход, если выбран не пункт получения контракта

                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (ShipPrice.CityName)
                BIT TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)             ; флаг, город требует ранней проверки гарнизона и отказывает в сведениях о замке и новом контракте
                JR Z, .HasContract                                              ; переход, если город не враждебен и может выдать контракт

                CALL RefuseEntry
                JP .WaitMessage

.HasContract    LD A, (State.Contract)
                OR A
                JR Z, .LeadershipGate                                           ; переход, если действующего контракта нет и можно проверить заслуги героя

                LD A, #47
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD DE, Overlay.City.ShipPrice.HasContract                       ; отказ в выдаче второго контракта
                LD BC, #110A
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                JP .WaitMessage

.LeadershipGate LD DE, Overlay.City.ShipPrice.LowLeadership                     ; отказ при лидерстве менее 200
                LD HL, (State.Leadership)
                LD BC, #00C8
                OR A
                SBC HL, BC
                JR C, .ShowRefusal                                              ; переход, если лидерство героя меньше необходимых 200

                LD DE, Overlay.City.ShipPrice.FewVictories                      ; отказ при числе побед менее 30
                LD HL, (State.Wins)
                LD BC, #001E
                SBC HL, BC
                JR C, .ShowRefusal                                              ; переход, если счётчик побед меньше необходимых 30

                LD BC, (State.Losses)
                LD A, B
                OR C
                JR Z, .FindContract                                             ; переход, если поражений ещё не было и проверка отношения побед к поражениям не нужна

                LD A, #04
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD BC, (State.Wins)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                LD BC, (State.Losses)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05, #38                                                     ; division, деление, B545
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                LD DE, Overlay.City.ShipPrice.BadWinRatio                       ; отказ при недостаточном соотношении побед и поражений
                JR C, .FindContract                                             ; переход, если отношение побед к поражениям превышает 4

.ShowRefusal    PUSH DE
                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                POP DE
                LD B, #12
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                JP .WaitMessage

.FindContract   XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (ShipPrice.CityName)
                LD A, (State.Continent)
                LD E, A
                LD D, #01
                LD C, (IX + FTown.X - FTown.Name)
                LD B, (IX + FTown.Y - FTown.Name)
                LD HL, #0000
                LD A, #23
                CALL Engine.NearestObject                                       ; найти ближайшую активную запись выбранной группы
                LD A, (IX + FCastle.Owner)
                OR A
                JR NZ, .ContractIndex                                           ; переход, если ближайший замок ещё не принадлежит герою и подходит для контракта

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD B, #11
                LD DE, Overlay.City.ShipPrice.CastleIsOwn                       ; отказ в контракте на собственный замок
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                JP .WaitMessage

.ContractIndex  PUSH IX
                POP HL
                PUSH HL
                PUSH HL
                LD BC, Runtime.Castles                                          ; 80 записей FCastle текущего мира в логическом банке 0
                XOR A
                SBC HL, BC
                LD BC, #0023
.CountContract  INC A
                SBC HL, BC
                JR NC, .CountContract                                           ; переход, если до найденного замка остаются полные записи каталога

                LD (State.Contract), A
                PUSH IX
                POP HL
                INC HL
                INC HL
                INC HL
                LD (ShipPrice.ContractName), HL
                LD A, #46
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD DE, Overlay.City.ShipPrice.ContractText                      ; сообщение о выданном контракте и дополнительной награде
                LD B, #11
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                POP HL
                LD DE, #0014
                ADD HL, DE
                LD B, #05
                CALL Engine.SumArmyPower                                        ; сложить произведения количества отрядов на поле силы типа
                LD DE, #0001
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                INC E
                LD A, E
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05, #27, #31, #38                                           ; division, деление, B5D7
                LD HL, Overlay.City.ShipPrice.AdvanceMoney                      ; пятибайтная сумма аванса контракта
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD A, #46
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #1401
                LD DE, #011E
                LD A, #44
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD DE, Overlay.City.ShipPrice.AdvanceText                       ; сообщение о выдаваемом авансе контракта
                LD B, #11
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F, #38                                                     ; addition, сложение, B605
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                POP IX
                JP .ShowCastle

.RecruitChoice  CP #05
                JP NZ, .FinishMove                                              ; переход, если выбран не пункт найма городских отрядов

                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (ShipPrice.CityName)
                LD A, (IX + FTown.Army - FTown.Name + FTroop.ID)
                OR A
                JR NZ, .CityUnitList                                            ; переход, если в городе есть отряды для найма

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD DE, Overlay.City.ShipPrice.NoUnitsText                       ; сообщение об отсутствии солдат в городе
                LD BC, #1209
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                JP .WaitMessage

.CityUnitList   LD B, #03
                LD IY, (ShipPrice.CityName)
.CityUnit       XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD A, (IY + FTown.Army - FTown.Name + FTroop.ID)
                OR A
                JP Z, .CompactCity                                              ; переход, если городская армия закончилась и её список нужно уплотнить

                PUSH BC
                PUSH IY
                LD A, #47
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                CALL RefreshMoney
                LD C, (IY + FTown.Army - FTown.Name + FTroop.Count.Low)
                LD B, (IY + FTown.Army - FTown.Name + FTroop.Count.High)
                LD (ShipPrice.Available), BC
                LD A, (IY + FTown.Army - FTown.Name + FTroop.ID)
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD C, (IX + FSoldier.UnitValue.Low)
                LD B, (IX + FSoldier.UnitValue.High)
                LD (ShipPrice.UnitPrice), BC
                LD BC, #100D
                PUSH IX
                POP DE
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD A, (IY + FTown.Army - FTown.Name + FTroop.ID)
                CALL Engine.FreeCapacity                                        ; вычислить остаток допустимого количества выбранного типа отряда
                LD (ShipPrice.Capacity), BC
                LD BC, #1518
                LD DE, #0207
                LD A, #41
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #1203
                LD DE, Overlay.City.ShipPrice.HireOffer                         ; формат количества, цены и доступности нанимаемого типа
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                PUSH IX
                PUSH IY
                LD IX, Overlay.City.ShipPrice.HireMenu                          ; меню подтверждения найма отряда
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                POP IY
                POP IX
                CP #02
                JP Z, .NextCityUnit                                             ; переход, если игрок отказался нанимать текущий тип существ

                LD HL, State.Army
                LD B, #05

                ; городской найм допускает объединение с тем же типом либо свободную запись,
                ; число записей армии не расширяется
.FindArmySlot   LD A, (HL)
                OR A
                JR Z, .ShowMaxHire                                              ; переход, если найдена свободная запись армии героя

                CP (IY + FTown.Army - FTown.Name + FTroop.ID)
                JR Z, .ShowMaxHire                                              ; переход, если в армии героя уже есть нанимаемый тип существ

                INC HL
                INC HL
                INC HL
                DJNZ .FindArmySlot

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #1204
                LD DE, Engine.NeedMoreMoney.ArmyFullText                        ; сообщение о заполнении всех пяти типов армии
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .NextCityUnit

.ShowMaxHire    LD (ShipPrice.ArmySlot), HL
                LD BC, #1603
                LD DE, Engine.NeedMoreMoney.QuantityText                        ; общее приглашение Сколько для ввода количества
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами

                ; ввод ограничивается доступными существами и деньгами, показанная управляемость
                ; отдельно с вводом не сравнивается
.ReadHireCount  LD BC, #160D
                PUSH IX
                PUSH IY
                CALL Engine.EditNumber                                          ; ввести число из не более пяти цифр
                POP IY
                POP IX
                CP #0E
                JP Z, .NextCityUnit                                             ; переход, если ввод количества отменён кодом #0E

                CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD A, B
                OR C
                JR Z, .ReadHireCount                                            ; переход, если введено нулевое количество

                LD (ShipPrice.HireCount), BC
                LD HL, (ShipPrice.Available)
                OR A
                SBC HL, BC
                JR C, .ReadHireCount                                            ; переход, если запрошено больше существ, чем осталось в городе

                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, (ShipPrice.HireCount)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                LD BC, (ShipPrice.UnitPrice)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #04, #38                                                     ; multiply, умножение, B71B
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                JP C, .ReadHireCount                                            ; переход, если денег не хватает на введённое количество существ

                LD HL, (ShipPrice.ArmySlot)
                INC HL
                LD E, (HL)
                INC HL
                LD D, (HL)
                LD A, D
                OR E
                JR NZ, .AddHiredUnits                                           ; переход, если нанятые существа добавляются к уже существующему отряду

                LD A, (IY + FTown.Army - FTown.Name + FTroop.ID)
                CALL Engine.ClearTwoFlags                                       ; обнулить два связанных байта таблиц
.AddHiredUnits  EX DE, HL
                LD DE, (ShipPrice.HireCount)
                ADD HL, DE
                EX DE, HL
                LD HL, (ShipPrice.ArmySlot)
                LD A, (IY + FTown.Army - FTown.Name + FTroop.ID)
                LD (HL), A
                INC HL
                LD (HL), E
                INC HL
                LD (HL), D
                PUSH IX
                PUSH IY
                CALL ShipPrice
                POP IY
                POP IX
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, (ShipPrice.UnitPrice)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                LD BC, (ShipPrice.HireCount)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #04, #03, #38                                                ; multiply, умножение, B76A
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD HL, (ShipPrice.Available)
                LD BC, (ShipPrice.HireCount)
                OR A
                SBC HL, BC
                LD (IY + FTown.Army - FTown.Name + FTroop.Count.Low), L
                LD (IY + FTown.Army - FTown.Name + FTroop.Count.High), H
                LD A, L
                OR H
                JR NZ, .NextCityUnit                                            ; переход, если после найма в городском отряде остаются существа

                LD (IY + FTown.Army - FTown.Name + FTroop.ID), #00
.NextCityUnit   POP IY
                POP BC
                INC IY
                INC IY
                INC IY
                DEC B
                JP NZ, .CityUnit                                                ; переход, если остаются городские записи отрядов для предложения найма

.CompactCity    LD HL, (ShipPrice.CityName)
                LD DE, #000E
                ADD HL, DE
                LD B, #03
                CALL Engine.CompactArmy                                         ; сжать список трёхбайтных записей армии
                JP .DrawMenu

.FinishMove     CALL Engine.MoveToTarget                                        ; преобразовать направление к цели в команду движения героя
                RET

; -----------------------------------------
; сообщение об отказе города из-за отношения к герою
; Выбирает представление #42 через #8712 и выводит строку #B9F3 с координатами B=#12, C=7.
; Возвращает управление обработчику городского меню.
; In:
;   состояние окна ядра
; Out:
;   сообщение выведено
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
RefuseEntry     LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #1207
                LD DE, Overlay.City.ShipPrice.RefusalText                       ; реплика враждебного города при отказе во входе
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                RET

; -----------------------------------------
; обновление строки денежных средств в городском меню
; Окрашивает строку 15, выводит подпись из #8781. Пятибайтовое число денег по #6A14 помещается в
; стек калькулятора и печатается #70E3 с колонки 11 строки 15.
; In:
;   #6A14 — пятибайтовое число денег
; Out:
;   обновлена строка денежных средств
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
RefreshMoney    LD BC, #0F01
                LD DE, #011E
                LD A, #46
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #0F02
                LD DE, Engine.NeedMoreMoney.MoneyText                           ; общая надпись денежных средств
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, #0F0B
                CALL Engine.DrawNumber                                          ; преобразовать число и вывести символы подряд
                RET

; -----------------------------------------
; выбор стоимости осадных орудий по отношению города
; При нулевом ShipPrice.Relation выбирает 12000, иначе 24000. Сохраняет выбранное 16-битное
; значение по ShipPrice.SiegeCost,
; которое подставляется в строку цены городского меню.
; In:
;   ShipPrice.Relation — состояние отношения города
; Out:
;   ShipPrice.SiegeCost=12000 либо 24000
; Corrupt:
;   HL, AF
; -----------------------------------------
SiegePrice      LD HL, #2EE0
                LD A, (ShipPrice.Relation)
                OR A
                JR Z, .StoreSiegeCost                                           ; переход, если отношение города обычное и осадное орудие стоит 12000

                LD HL, #5DC0
.StoreSiegeCost LD (ShipPrice.SiegeCost), HL
                RET

; -----------------------------------------
; расчёт цены найма корабля по составу армии и отношению города
; Помещает 100 в калькулятор и обходит до пяти троек #6A1E до первого ID0. Для каждого отряда
; добавляет N_i*(P_i/50), где N_i — его 16-битная численность, P_i — слово описателя
; SOLDIERS+#16/+#17. Токены #05, #04, #0F означают деление P_i/50, умножение на N_i и прибавление
; к накопителю. После обхода #27 берёт INT, цена=floor(100+sum(N_i*P_i/50)). При ненулевом
; ShipPrice.Relation
; уже целый результат умножается на 2. #6D76 возвращает BC, которое сохраняется в
; ShipPrice.ShipCost. Ветка
; найма корабля читает эту сумму по #B469, это не плата за содержание армии.
; In:
;   #6A1E — армия, SOLDIERS+#16/+#17 — цена типа, ShipPrice.Relation — состояние отношения города
; Out:
;   ShipPrice.ShipCost —16-битная цена найма корабля
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; -----------------------------------------
ShipPrice       LD BC, #0064
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                LD IY, State.Army
                LD B, #05
.ArmyValueLoop  LD A, (IY + FTroop.ID)
                OR A
                JR Z, .RoundPrice                                               ; переход, если достигнут конец заполненной части армии при расчёте цены корабля

                PUSH BC
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD C, (IY + FTroop.Count.Low)
                LD B, (IY + FTroop.Count.High)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                LD C, (IX + FSoldier.UnitValue.Low)
                LD B, (IX + FSoldier.UnitValue.High)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                LD BC, #0032
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05, #04, #0F, #38                                           ; division, деление, B81A
                INC IY
                INC IY
                INC IY
                POP BC
                DJNZ .ArmyValueLoop

.RoundPrice     RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #27, #38                                                     ; int, округление вниз, B828
                LD A, (ShipPrice.Relation)
                OR A
                JR Z, .StoreShipPrice                                           ; переход, если отношение города обычное и удваивать цену корабля не требуется

                LD BC, #0002
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #04, #38                                                     ; multiply, умножение, B837
.StoreShipPrice CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD (ShipPrice.ShipCost), BC
                RET

.HostileDefeat  EQU $                                                           ; сообщение после поражения в бою с городским гарнизоном
                DB #8F, #E0, #AE, #A2, #A0, #AB, #A8, #A2
                DB #A0, #A9, #20, #AE, #E2, #E1, #EE, #A4
                DB #A0, #2C, #20, #AF, #E0, #AE, #AA, #AB
                DB #EF, #E2, #EB, #A9, #20, #AA, #AE, #AB
                DB #A4, #E3, #AD, #2C, #0D, #2A, #A8, #20
                DB #A1, #AE, #AB, #EC, #E8, #A5, #20, #AD
                DB #A5, #20, #A7, #A0, #E5, #AE, #A4, #A8
                DB #20, #A2, #20, #AD, #A0, #E8, #20, #A3
                DB #AE, #E0, #AE, #A4, #20, #21, #0D, #2A
.CastleIsOwn    EQU $+1                                                         ; отказ в контракте на собственный замок
                DB #00, #81, #AB, #A8, #A6, #A0, #A9, #E8
                DB #A8, #A9, #20, #AA, #20, #AD, #A0, #E8
                DB #A5, #AC, #E3, #20, #A3, #AE, #E0, #AE
                DB #A4, #E3, #20, #A7, #A0, #AC, #AE, #AA
                DB #0D, #2A, #E3, #A6, #A5, #20, #AF, #E0
                DB #A8, #AD, #A0, #A4, #AB, #A5, #A6, #A8
                DB #E2, #20, #A2, #A0, #AC, #2C, #0D, #2A
                DB #A7, #A0, #E7, #A5, #AC, #20, #A2, #A0
                DB #AC, #20, #A5, #A3, #AE, #20, #A7, #A0
                DB #E5, #A2, #A0, #E2, #EB, #A2, #A0, #E2
.ContractText   EQU $+6                                                         ; сообщение о выданном контракте и дополнительной награде
                DB #EC, #20, #3F, #0D, #2A, #00, #85, #E1
                DB #AB, #A8, #20, #A2, #EB, #20, #E1, #E3
                DB #AC, #A5, #A5, #E2, #A5, #20, #A7, #A0
                DB #E5, #A2, #A0, #E2, #A8, #E2, #EC, #0D
                DB #2A, #A7, #A0, #AC, #AE, #AA, #20, #0E
.ContractName   DW #0000                                                        ; адрес имени замка нового контракта
                DB #0D, #2A, #E2, #AE, #20, #AC, #EB, #20
                DB #A2, #A0, #AC, #20, #A2, #EB, #AF, #AB
                DB #A0, #E2, #A8, #AC, #20, #A4, #AE, #AF
                DB #AE, #AB, #AD, #A8, #E2, #A5, #AB, #EC
                DB #AD, #AE, #A5, #0D, #2A, #A2, #AE, #A7
                DB #AD, #A0, #A3, #E0, #A0, #A6, #A4, #A5
.NoBuyDock      EQU $+7                                                         ; отказ в покупке корабля в городе без пристани
                DB #AD, #A8, #A5, #2E, #0D, #2A, #00, #8F
                DB #AE, #E0, #A0, #E1, #AA, #A8, #AD, #EC
                DB #E2, #A5, #20, #AC, #AE, #A7, #A3, #A0
                DB #AC, #A8, #2C, #0D, #2A, #AA, #A0, #AA
                DB #20, #AC, #AE, #A6, #AD, #AE, #20, #AD
                DB #A0, #AD, #EF, #E2, #EC, #20, #AA, #AE
                DB #E0, #A0, #A1, #AB, #EC, #0D, #2A, #A2
                DB #20, #AD, #A0, #E8, #A5, #AC, #20, #A3
                DB #AE, #E0, #AE, #A4, #A5, #20, #21, #0D
.NoSellDock     EQU $+2                                                         ; отказ в отказе от корабля в городе без пристани
                DB #2A, #00, #87, #A4, #A5, #E1, #EC, #20
                DB #A2, #A0, #E8, #20, #AA, #AE, #E0, #A0
                DB #A1, #AB, #EC, #0D, #2A, #AD, #A8, #AA
                DB #AE, #AC, #E3, #20, #AD, #A5, #AD, #E3
                DB #A6, #A5, #AD, #20, #21, #0D, #2A, #00
.ShipElsewhere  EQU $                                                           ; отказ, если корабль находится не у этой пристани
                DB #8F, #E0, #A5, #A6, #A4, #A5, #20, #E7
                DB #A5, #AC, #20, #E1, #A4, #A0, #A2, #A0
                DB #E2, #EC, #20, #AA, #AE, #E0, #A0, #A1
                DB #AB, #EC, #2C, #0D, #2A, #AC, #AE, #A6
                DB #A5, #E2, #20, #A1, #EB, #E2, #EC, #20
                DB #A2, #EB, #20, #E1, #AD, #A8, #AC, #A5
                DB #E2, #A5, #20, #E1, #20, #AD, #A5, #A3
                DB #AE, #0D, #2A, #E1, #A2, #AE, #A8, #E5
                DB #20, #A2, #AE, #A8, #AD, #AE, #A2, #20
                DB #3F, #0D, #2A, #00
.ArmySlot       DW #0000                                                        ; адрес выбранного слота армии героя
.HireCount      DW #0000                                                        ; введённое количество нанимаемых существ
.RefusalText    EQU $                                                           ; реплика враждебного города при отказе во входе
                DB #8E, #E2, #A2, #A0, #AB, #A8, #2C, #20
                DB #AD, #A5, #E7, #A8, #E1, #E2, #A8, #A2
                DB #EB, #A9, #20, #E3, #A1, #AB, #EE, #A4
.HireOffer      EQU $+5                                                         ; формат количества, цены и доступности нанимаемого типа
                DB #AE, #AA, #20, #21, #00, #82, #E1, #A5
                DB #A3, #AE, #20, #A8, #E5, #20, #A2, #20
                DB #A3, #AE, #E0, #AE, #A4, #A5, #20, #0F
.Available      DW #0000                                                        ; число доступных существ текущего городского отряда
                DB #00, #0D, #03, #AA, #A0, #A6, #A4, #EB
                DB #A9, #20, #E1, #E2, #AE, #A8, #E2, #20
                DB #0F
.UnitPrice      DW #0000                                                        ; денежная стоимость одного нанимаемого существа
                DB #00, #0D, #03, #82, #EB, #20, #E1, #AC
                DB #AE, #A6, #A5, #E2, #A5, #20, #AA, #AE
                DB #AD, #E2, #E0, #AE, #AB, #A8, #E0, #AE
                DB #A2, #A0, #E2, #EC, #20, #0F
.Capacity       DW #0000                                                        ; свободный предел управления для текста
                DB #00, #0D, #03, #81, #A5, #E0, #E3, #0D
                DB #22, #84, #A0, #AB, #EC, #E8, #A5, #0D
.LowLeadership  EQU $+2                                                         ; отказ при лидерстве менее 200
                DB #21, #00, #93, #20, #A2, #A0, #E1, #20
                DB #AC, #A0, #AB, #AE, #20, #AE, #AF, #EB
                DB #E2, #A0, #20, #A4, #AB, #EF, #20, #E2
                DB #A0, #AA, #AE, #A3, #AE, #20, #A4, #A5
.FewVictories   EQU $+6                                                         ; отказ при числе побед менее 30
                DB #AB, #A0, #2E, #0D, #2A, #00, #82, #EB
                DB #20, #AD, #A5, #20, #AC, #A0, #AB, #AE
                DB #20, #AF, #AE, #A2, #A8, #A4, #A0, #AB
                DB #A8, #2C, #20, #AD, #AE, #20, #AC, #A0
                DB #AB, #AE, #20, #A4, #E0, #A0, #AB, #A8
.BadWinRatio    EQU $+6                                                         ; отказ при недостаточном соотношении побед и поражений
                DB #E1, #EC, #2E, #0D, #2A, #00, #81, #A8
                DB #E2, #A2, #EB, #20, #AD, #A0, #A4, #AE
                DB #20, #A2, #EB, #A8, #A3, #E0, #EB, #A2
                DB #A0, #E2, #EC, #2C, #0D, #2A, #A0, #20
                DB #AD, #A5, #20, #E3, #E7, #A0, #E1, #E2
                DB #A2, #AE, #A2, #A0, #E2, #EC, #20, #A2
                DB #20, #AD, #A8, #E5, #2E, #0D, #2A, #00
.AdvanceText    EQU $                                                           ; сообщение о выдаваемом авансе контракта
                DB #8A, #E0, #AE, #AC, #A5, #20, #E2, #AE
                DB #A3, #AE, #20, #E1, #A5, #A9, #E7, #A0
                DB #E1, #20, #AC, #EB, #20, #A3, #AE, #E2
                DB #AE, #A2, #EB, #0D, #2A, #A4, #A0, #E2
.AdvanceMoney   EQU $+7                                                         ; пятибайтная сумма аванса контракта
                DB #EC, #20, #A2, #A0, #AC, #20, #10, #00
                DB #00, #00, #00, #00, #00, #AC, #AE, #AD
                DB #A5, #E2, #2E, #0D, #2A, #84, #AB, #EF
                DB #20, #AD, #A0, #A9, #AC, #A0, #20, #A2
                DB #AE, #A8, #AD, #AE, #A2, #20, #A8, #20
                DB #A4, #E0, #E3, #A3, #A8, #E5, #20, #E0
                DB #A0, #E1, #E5, #AE, #A4, #AE, #A2, #2E
                DB #0D, #2A, #8F, #E3, #E1, #E2, #EC, #20
                DB #E3, #A4, #A0, #E7, #A0, #20, #E1, #AE
                DB #AF, #E3, #E2, #E1, #E2, #A2, #E3, #A5
                DB #E2, #20, #A2, #A0, #AC, #20, #21, #0D
.HasContract    EQU $+2                                                         ; отказ в выдаче второго контракта
                DB #2A, #00, #93, #20, #A2, #A0, #E1, #20
                DB #E3, #A6, #A5, #20, #A5, #E1, #E2, #EC
                DB #20, #AA, #AE, #AD, #E2, #E0, #A0, #AA
                DB #E2, #2C, #0D, #2A, #AF, #AE, #E2, #E0
                DB #E3, #A4, #A8, #E2, #A5, #E1, #EC, #20
                DB #A5, #A3, #AE, #20, #A2, #EB, #AF, #AE
                DB #AB, #AD, #A8, #E2, #EC, #2E, #0D, #2A
.NoUnitsText    EQU $+1                                                         ; сообщение об отсутствии солдат в городе
                DB #00, #82, #20, #AD, #A0, #E8, #A5, #AC
                DB #20, #A3, #AE, #E0, #AE, #A4, #A5, #20
                DB #AD, #A5, #E2, #20, #E1, #AE, #AB, #A4
.CastleLocation EQU $+4                                                         ; направление и имя ближайшего замка
                DB #A0, #E2, #2E, #00, #8D, #A0, #20, #0E
.DirectionText  DW #0000                                                        ; адрес названия направления к ближайшему замку
                DB #20, #AD, #A0, #E5, #AE, #A4, #A8, #E2
                DB #E1, #EF, #20, #A7, #A0, #AC, #AE, #AA
                DB #0D, #2A, #0E
.CastleName     DW #0000                                                        ; адрес имени ближайшего замка
.RulerOwner     EQU $+3                                                         ; формат владельца замка с именем правителя
                DB #0D, #2A, #00, #85, #A3, #AE, #20, #E5
                DB #AE, #A7, #EF, #A8, #AD, #20, #3A, #20
                DB #0E
.RulerName      DW #0000                                                        ; адрес имени владельца ближайшего замка
.BanditOwner    EQU $+3                                                         ; сообщение о замке без известного правителя
                DB #0D, #2A, #00, #93, #20, #AD, #A5, #A3
                DB #AE, #20, #AD, #A5, #E2, #20, #A2, #AB
                DB #A0, #A4, #A5, #AB, #EC, #E6, #A0, #2E
.HeroOwner      EQU $+1                                                         ; сообщение о замке героя
                DB #00, #8E, #AD, #20, #AF, #E0, #A8, #AD
                DB #A0, #A4, #AB, #A5, #A6, #A8, #E2, #20
.HasSiegeText   EQU $+5                                                         ; сообщение об уже имеющихся осадных орудиях
                DB #A2, #A0, #AC, #2E, #00, #93, #20, #A2
                DB #A0, #E1, #20, #E3, #A6, #A5, #20, #A5
                DB #E1, #E2, #EC, #20, #A2, #E1, #A5, #20
                DB #AD, #A5, #AE, #A1, #E5, #AE, #A4, #A8
                DB #AC, #EB, #A5, #0D, #2A, #AE, #E1, #A0
                DB #A4, #AD, #EB, #A5, #20, #AE, #E0, #E3
                DB #A4, #A8, #EF, #2E, #0D, #2A, #00
.Relation       DB #00                                                          ; 0 обычный город, 1 пустой встречный гарнизон, 2 победа над гарнизоном
                DB #81, #E3, #A4, #EC, #20, #AF, #E0, #AE
                DB #AA, #AB, #EF, #E2, #AE, #20, #A8, #AC
                DB #EF, #20, #E2, #A2, #AE, #A5, #0D, #2A
                DB #A2, #AE, #20, #A2, #A5, #AA, #A8, #20
                DB #A2, #A5, #AA, #AE, #A2, #2E, #0D, #2A
                DB #8A, #AE, #A3, #A4, #A0, #2D, #AD, #A8
                DB #A1, #E3, #A4, #EC, #20, #AD, #A0, #E8
                DB #A8, #20, #A4, #A5, #E2, #A8, #0D, #2A
                DB #AE, #E2, #AE, #AC, #E1, #E2, #EF, #E2
                DB #20, #E2, #A5, #A1, #A5, #2E, #0D, #2A
                DB #00, #86, #A8, #E2, #A5, #AB, #A8, #20
                DB #A3, #AE, #E0, #AE, #A4, #A0, #20, #A1
                DB #E3, #A4, #E3, #E2, #0D, #2A, #AE, #E7
                DB #A5, #AD, #EC, #20, #A1, #AB, #A0, #A3
                DB #AE, #A4, #A0, #E0, #AD, #EB, #20, #A2
                DB #A0, #AC, #2C, #0D, #2A, #A5, #E1, #AB
                DB #A8, #20, #A2, #EB, #20, #AF, #AE, #AA
                DB #A8, #AD, #A5, #E2, #A5, #20, #A5, #A3
                DB #AE, #20, #AA, #A0, #AA, #0D, #2A, #AC
                DB #AE, #A6, #AD, #AE, #20, #E1, #AA, #AE
                DB #E0, #A5, #A5, #2E, #0D, #2A, #00, #84
                DB #AE, #A1, #E0, #AE, #20, #AF, #AE, #A6
                DB #A0, #AB, #AE, #A2, #A0, #E2, #EC, #20
                DB #21, #0D, #2A, #0D, #00, #86, #A8, #E2
                DB #A5, #AB, #A8, #20, #A3, #AE, #E0, #AE
                DB #A4, #A0, #20, #0E
.CityName       DW #0000                                                        ; адрес имени текущего города
                DB #0D, #2A, #AE, #E7, #A5, #AD, #EC, #20
                DB #E0, #A0, #A4, #EB, #20, #A2, #A0, #E1
                DB #20, #A2, #A8, #A4, #A5, #E2, #EC, #2E
.CityMessages   EQU $+3                                                         ; три FCityMessage по отношению города, порядок выбирается Entry
                DB #0D, #2A, #00, #47, #0B, #10, #E9, #BC
                DB #06, #0B, #11, #93, #BC, #42, #09, #11
.ActionsText    EQU $+2                                                         ; текст основного меню города
                DB #42, #BC, #8A, #E3, #AF, #A8, #E2, #EC
                DB #20, #AE, #E1, #A0, #A4, #AD, #EB, #A5
                DB #20, #AE, #E0, #E3, #A4, #A8, #EF, #20
                DB #0F
.SiegeCost      DW #0000                                                        ; цена осадного орудия
                DB #00, #0D, #02, #93, #A7, #AD, #A0, #E2
                DB #EC, #20, #AE, #20, #A1, #AB, #A8, #A6
                DB #A0, #A9, #E8, #A5, #AC, #20, #A7, #A0
                DB #AC, #AA, #A5, #0D, #02, #0E
.ShipAction     DW #0000                                                        ; адрес подписи покупки либо сдачи корабля
                DB #0D, #02, #87, #A0, #AA, #AB, #EE, #E7
                DB #A8, #E2, #EC, #20, #AA, #AE, #AD, #E2
                DB #E0, #A0, #AA, #E2, #0D, #02, #8D, #A0
                DB #AD, #EF, #E2, #EC, #20, #E1, #AE, #AB
                DB #A4, #A0, #E2, #0D, #02, #8F, #AE, #AA
                DB #A8, #AD, #E3, #E2, #EC, #20, #A3, #AE
.BuyShipText    EQU $+6                                                         ; подпись действия покупки корабля
                DB #E0, #AE, #A4, #0D, #02, #00, #8D, #A0
                DB #AD, #EF, #E2, #EC, #20, #AA, #AE, #E0
.SellShipText   EQU $+5                                                         ; подпись действия отказа от корабля
                DB #A0, #A1, #AB, #EC, #00, #8E, #E2, #AA
                DB #A0, #A7, #A0, #E2, #EC, #E1, #EF, #20
                DB #AE, #E2, #20, #A0, #E0, #A5, #AD, #A4
                DB #EB, #20, #AA, #AE, #E0, #A0, #A1, #AB
                DB #EF, #00
.ShipCost       DW #0000                                                        ; цена покупки корабля
.ActionsMenu    EQU $                                                           ; описатель основного меню города
                DB #06, #00, #70, #EE, #BF, #1C, #88, #01
                DB #11, #1F, #12, #01, #12, #1F, #13, #01
                DB #13, #1F, #14, #01, #14, #1F, #15, #01
.HireMenu       EQU $+7                                                         ; меню подтверждения найма отряда
                DB #15, #1F, #16, #01, #16, #1F, #17, #02
                DB #00, #70, #EE, #BF, #C8, #B4, #18, #15
                DB #1F, #16, #18, #16, #1F, #17, #6F, #76
                DB #65, #72, #6C, #61, #79

                assert $ = #BE0C
                endmodule
                endmodule
