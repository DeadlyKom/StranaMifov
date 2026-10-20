; оверлей 17 из OVR2
; исходный файл каталога 49, смещение #0810
                module Overlay
                module Info
                org #B200

; -----------------------------------------
; экран статистики с переходами в подробные подменю
; Считает захваченные замки через #87A1, уничтоженных врагов обходом ID1..15 через #87D1,
; показывает контракт #6A3A, осадные орудия бит 5 #6A33, секту #6A3B, число изученных заклинаний
; по десяти байтам #6A0A и уведомление о нападении #6AAA. Убирает недоступные области из таблицы
; выбора. По результату 2..6 берёт адрес из пяти слов #B979..#B982 и выполняет PUSH HL, RET. Это
; явный стековый диспетчер, его цели нужно включать в CFG вручную.
; In:
;   глобальные поля героя, таблицы замков/врагов/заклинаний
; Out:
;   меню 1 закрывает экран, пункты 2..6 переходят к локальным обработчикам
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом выбранного подменю, ROM-калькулятора и
;   заключительного #957C
; Note:
; экран, таблица меню ListSpells.StatsItems/ListSpells.CastleRectMin..ListSpells.SpellRectMax,
; поля строк, цели CastleList, ListRulers, ShowContract, ListSpells, ShowThreat
; -----------------------------------------
Entry           CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD A, #01
                LD (DrawCastlePage.FirstCastle), A
.DrawStats      LD A, #05
                LD (ListSpells.StatsItems), A
                LD BC, #0400
                LD DE, #1420
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD BC, #0400
                LD DE, #011E
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #05
                LD DE, Overlay.Info.ListSpells.StatsHeading                     ; заголовок окна статистики
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #0800
                LD DE, #0E1E
                LD A, #46
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                CALL Engine.CountOwnCastles                                     ; подсчитать записи банка 0 по флагу и полю #13
                LD (ListSpells.CastleCount), BC
                LD A, C
                OR A
                JR NZ, .HideChoices                                             ; переход, если у героя есть собственные замки

                LD HL, ListSpells.CastleRectMin
                LD (HL), #00
                LD DE, Overlay.Info.ListSpells.CastleRectMin + 1                ; следующий байт очищаемых прямоугольников пунктов замков и правителей
                LD BC, #0007
                LDIR
                LD DE, Overlay.Info.ListSpells.NoCastlesText                    ; сообщение о полном отсутствии захваченных замков
                LD B, #0A
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                JP .CheckContract

.HideChoices    CP #50
                JR NZ, .PrintCastleNum                                          ; переход, если захвачены ещё не все 80 замков

                LD HL, ListSpells.CastleRectMin
                LD (HL), #00
                LD DE, Overlay.Info.ListSpells.CastleRectMin + 1                ; следующий байт очищаемых прямоугольников пунктов замков и правителей
                LD BC, #0007
                LDIR
                LD DE, Overlay.Info.ListSpells.AllCastlesText                   ; сообщение о владении всеми замками страны
                LD B, #0A
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                JR .CheckContract

.PrintCastleNum LD DE, Overlay.Info.ListSpells.CastleCounData                   ; формат числа захваченных замков
                LD B, #0A
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #0A14
                LD DE, #0108
                LD A, #44
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #0A14
                LD (ListSpells.CastleRectMin), BC
                LD BC, #0B1C
                LD (ListSpells.CastleRectMax), BC
                LD BC, #0F00

                ; правитель считается побеждённым после потери последнего действующего замка
.CountRulers    CALL Engine.HasOwnerCastle                                      ; найти активную запись с заданным владельцем
                JR Z, .NextRuler                                                ; переход, если у очередного правителя ещё есть замок и его нельзя считать побеждённым

                INC C
.NextRuler      DJNZ .CountRulers

                LD (ListSpells.RulerCount), BC
                LD A, C
                OR A
                JR NZ, .RulerMenuArea                                           ; переход, если есть побеждённые правители и нужен пункт их просмотра

                LD HL, ListSpells.RulerRectMin
                LD BC, #0000
                LD (ListSpells.RulerRectMin), BC
                LD (ListSpells.RulerRectMax), BC
                LD B, #0B
                LD DE, Overlay.Info.ListSpells.NoKilledText                     ; сообщение об отсутствии побеждённых правителей
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                JR .CheckContract

.RulerMenuArea  LD BC, #0B0D
                LD DE, #0107
                LD A, #44
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #0B0D
                LD (ListSpells.RulerRectMin), BC
                LD BC, #0C14
                LD (ListSpells.RulerRectMax), BC
                LD B, #0B
                LD DE, Overlay.Info.ListSpells.KilledCount                      ; формат числа побеждённых правителей
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
.CheckContract  LD A, (State.Contract)
                OR A
                JR NZ, .ContractArea                                            ; переход, если у героя есть действующий контракт

                LD BC, #0000
                LD (ListSpells.ContractMin), BC
                LD (ListSpells.ContractMax), BC
                LD B, #0D
                LD DE, Overlay.Info.ListSpells.NoContract                       ; сообщение об отсутствии контракта
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                JR .SiegeStatus

.ContractArea   LD BC, #0E01
                LD DE, #0113
                LD A, #44
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #0E01
                LD (ListSpells.ContractMin), BC
                LD BC, #0F14
                LD (ListSpells.ContractMax), BC
                LD A, (State.Contract)
                LD B, A
                LD HL, Runtime.Castles + FCastle.Name - FCastle                 ; база перед именем первой записи замка для цикла с первым ADD на FCastle
                LD DE, #0023
.FindContract   ADD HL, DE
                DJNZ .FindContract

                LD (ListSpells.ContractCastle), HL
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD B, #0D
                LD DE, Overlay.Info.ListSpells.ContractText                     ; формат имени контрактного замка
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
.SiegeStatus    LD DE, Overlay.Info.ListSpells.HasSiegeText                     ; сообщение о наличии осадных орудий
                LD A, (State.MoveFlags)
                BIT HERO_SIEGE_BIT, A                                           ; флаг, у героя есть осадное орудие, перед взлётом требуется его оставить
                JR NZ, .CultStatus                                              ; переход, если у героя имеются осадные орудия

                LD DE, Overlay.Info.ListSpells.NeedSiegeText                    ; сообщение о необходимости купить осадные орудия
.CultStatus     LD B, #0F
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD DE, Overlay.Info.ListSpells.NoCultText                       ; сообщение об отсутствии выбранного культа
                LD A, (State.Cult)
                OR A
                JR Z, .SpellStatus                                              ; переход, если герой не принадлежит секте

                CALL Engine.NthName                                             ; найти строку имени в списке с нулевыми разделителями
                LD (ListSpells.CultText), DE
                LD DE, Overlay.Info.ListSpells.CultTextData                     ; формат имени выбранного культа
.SpellStatus    LD B, #11
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD HL, State.Spells
                XOR A
                LD B, #0A

                ; десять состояний заклинаний складываются в число изученных магических действий
.CountSpells    ADD A, (HL)
                INC HL
                DJNZ .CountSpells

                LD BC, #0000
                LD (ListSpells.SpellRectMin), BC
                LD (ListSpells.SpellRectMax), BC
                LD DE, Overlay.Info.ListSpells.NoSpellsText                     ; сообщение об отсутствии изученных заклинаний
                OR A
                JR Z, .ThreatStatus                                             ; переход, если герой ещё не изучил ни одного заклинания

                LD BC, #1307
                LD (ListSpells.SpellRectMin), BC
                LD BC, #1412
                LD (ListSpells.SpellRectMax), BC
                LD (ListSpells.SpellCount), A
                LD BC, #1307
                LD DE, #010B
                LD A, #44
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD DE, Overlay.Info.ListSpells.SpellCountData                   ; формат числа изученных заклинаний
.ThreatStatus   LD B, #12
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (State.Attacker)
                OR A
                JR Z, .ChoiceFooter                                             ; переход, если сейчас нет нападения на замок героя

                LD BC, #1401
                LD DE, #021E
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD DE, (State.AttackCastle)
                INC DE
                INC DE
                INC DE
                LD (ListSpells.ThreatCastle), DE
                LD DE, Overlay.Info.ListSpells.ThreatText                       ; сообщение о готовящемся нападении на замок
                LD B, #14
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, #06
                LD (ListSpells.StatsItems), A
.ChoiceFooter   LD BC, #1614
                LD DE, #010B
                LD A, #41
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD B, #16
                LD DE, Overlay.Info.ListSpells.CloseText                        ; надпись пункта Я насмотрелся
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IX, ListSpells.StatsItems
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #01
                JR Z, .CloseStats                                               ; переход, если выбран выход из экрана статистики

                LD IY, Overlay.Info.ListSpells.StatsHandlers - 2 * FWord        ; база на два слова перед обработчиками, пункт 2 задаёт первый адрес

                ; выбранный пункт задаёт слово адреса, PUSH и RET выполняют стековую диспетчеризацию
.FindHandler    INC IY
                INC IY
                DEC A
                JR NZ, .FindHandler                                             ; переход, если указатель ещё не дошёл до обработчика выбранного пункта

                LD L, (IY + FWord.Low)
                LD H, (IY + FWord.High)
                PUSH HL
                RET

.CloseStats     LD BC, #0400
                LD DE, #1420
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                CALL Engine.RefreshHero                                         ; обновить боковую панель героя, расходы и рейтинг
                RET

; -----------------------------------------
; список собственных замков с листанием по 26 названий
; Рисует окно и нижние кнопки, DrawCastlePage выводит текущую страницу. Выбор 1 увеличивает
; первый индекс
; DrawCastlePage.FirstCastle на 26, если ещё есть замки, выбор 2 уменьшает на 26 до 1, выбор 3
; возвращает в статистику.
; Остальные пункты преобразует в абсолютный индекс, FindOwnCastle находит запись, ShowCastleInfo
; открывает сведения
; о ней.
; In:
;   DrawCastlePage.FirstCastle — первый индекс, ListSpells.CastleCount — число своих замков
; Out:
;   переход к Entry.DrawStats при закрытии
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом безусловного продолжения общего меню по
;   Entry.DrawStats, локальная обработка листания не сохраняет регистры вызывающего кода
; Note:
;   экран, DrawCastlePage.FirstCastle, локальное меню ShowCastleInfo.CastleItems
; -----------------------------------------
CastleList      LD BC, #0501
                LD DE, #101C
                LD A, #45
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #1502
                LD DE, #011C
                LD A, #46
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #1504
                LD DE, Overlay.Info.DrawCastlePage.NextPageText                 ; надпись следующей страницы замков
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #150D
                LD DE, Overlay.Info.DrawCastlePage.PrevPageText                 ; надпись предыдущей страницы замков
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #1515
                LD DE, Overlay.Info.DrawCastlePage.ClosePageText                ; надпись закрытия списка замков
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
.DrawPage       CALL DrawCastlePage
.ChooseCastle   LD IX, ShowCastleInfo.CastleItems
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #03
                JP Z, Entry.DrawStats                                           ; переход, если игрок вернулся из списка замков на общий экран статистики

                CP #02
                JR NZ, .CheckPrevPage                                           ; переход, если выбран не переход на предыдущую страницу замков

                LD A, (DrawCastlePage.FirstCastle)
                CP #01
                JR Z, .ChooseCastle                                             ; переход, если показана первая страница и предыдущей страницы нет

                LD A, (DrawCastlePage.FirstCastle)
                SUB #1A
                LD (DrawCastlePage.FirstCastle), A
                JR .DrawPage

.CheckPrevPage  CP #01
                JR NZ, .OpenCastle                                              ; переход, если выбран не переход на следующую страницу замков

                LD A, (DrawCastlePage.FirstCastle)
                LD E, A
                LD A, (ListSpells.CastleCount)
                SUB E
                CP #1A
                JR C, .ChooseCastle                                             ; переход, если оставшиеся замки помещаются на текущей странице

                LD A, E
                ADD A, #1A
                LD (DrawCastlePage.FirstCastle), A
                JR .DrawPage

.OpenCastle     SUB #04
                LD E, A
                LD A, (DrawCastlePage.FirstCastle)
                ADD A, E
                CALL FindOwnCastle
                CALL ShowCastleInfo
                JP CastleList

; -----------------------------------------
; карточка замка с доходом, местоположением и гарнизоном
; Сохраняет IX на имя замка. Определяет континент через #7A4E и недельный доход через #AE1A. На
; текущем континенте вычисляет направление и расстояние, подставляет их в текст, для близкой цели
; показывает короткую подпись. На другом континенте выводит его название. При первом ID гарнизона
; IX+17=0 печатает отсутствие армии, иначе передаёт пять трёхбайтовых записей IX+17 в #7E55. Ждёт
; действия.
; In:
;   IX — указатель на 15-байтовое имя, физическая запись замка начинается IX-3
; Out:
;   возврат после карточки
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом расчёта расстояния #7FF0,
;   ROM-калькулятора и вывода гарнизона #7E55
; Note:
; экран, DrawCastlePage.CastleName, DrawCastlePage.CastleIncome, ShowThreat.DirectionText,
; ShowThreat.CastleDistance, ShowThreat.ContinentText, банки
; -----------------------------------------
ShowCastleInfo  LD (DrawCastlePage.CastleName), IX
                LD BC, #0901
                LD DE, #0C1C
                LD A, #41
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #0A02
                LD DE, #011C
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #0B02
                LD DE, #011C
                LD A, #06
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD HL, (DrawCastlePage.CastleName)
                LD IX, State.CastlesLists
                CALL Engine.SelectThreshold                                     ; определить одну из четырёх категорий по порогам
                LD C, A
                PUSH BC
                LD A, C
                LD IY, (DrawCastlePage.CastleName)
                DEC IY
                DEC IY
                DEC IY
                CALL Engine.CastleIncome                                        ; рассчитать доход замка с учётом ближайших городов
                LD (DrawCastlePage.CastleIncome), BC
                LD B, #0A
                LD DE, Overlay.Info.DrawCastlePage.CastleDetails                ; формат имени замка и недельного дохода
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                POP BC
                LD A, (State.Continent)
                CP C
                JR NZ, .OwnerText                                               ; переход, если выбранный замок находится на другом континенте

                LD IX, (DrawCastlePage.CastleName)
                LD BC, (State.Position)
                LD E, (IX + FCastle.X - FCastle.Name)                           ; -#02, столбец карты
                LD D, (IX + FCastle.Y - FCastle.Name)                           ; -#01, строка карты
                CALL Engine.GetDirection                                        ; определить одно из восьми направлений от BC к DE
                LD (ShowThreat.DirectionText), DE
                LD BC, (State.Position)
                LD E, (IX + FCastle.X - FCastle.Name)                           ; -#02, столбец карты
                LD D, (IX + FCastle.Y - FCastle.Name)                           ; -#01, строка карты
                CALL Engine.FloorDistance                                       ; вычислить целую часть евклидова расстояния
                LD L, C
                LD H, B
                ADD HL, HL
                ADD HL, HL
                LD BC, #0005
                ADD HL, BC
                LD C, L
                LD B, H
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #A4, #05, #27, #A4, #04, #27, #38                            ; токен калькулятора, исходное значение, B504
                CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD (ShowThreat.CastleDistance), BC
                LD DE, Overlay.Info.ShowThreat.DistanceText                     ; формат направления и расстояния до замка
                LD L, C
                LD H, B
                LD BC, #0014
                OR A
                SBC HL, BC
                JR NC, .PrintOwner                                              ; переход, если расчётное расстояние до замка составляет не менее 20

                LD DE, Overlay.Info.ShowThreat.NearbyText                       ; сообщение о близком расположении замка
                JR .PrintOwner

.OwnerText      LD B, C
                LD HL, Engine.MainLoop.LandNameIndex                            ; смещённая база перед списком имён континентов, поиск начинает с INC HL, первое имя находится по #6992
                XOR A
.FindOwnerText  INC HL
                CP (HL)
                JR NZ, .FindOwnerText                                           ; переход, если ещё не найден конец очередного названия континента

                DJNZ .FindOwnerText

                INC HL
                LD (ShowThreat.ContinentText), HL
                LD DE, Overlay.Info.ShowThreat.OtherLandText                    ; формат континента удалённого замка
.PrintOwner     LD B, #0D
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IX, (DrawCastlePage.CastleName)
                LD A, (IX + FCastle.Army - FCastle.Name + FTroop.ID)            ; +#11, пять записей гарнизона FTroop
                OR A
                JR Z, .NoGarrison                                               ; переход, если у выбранного замка нет гарнизона

                LD B, #10
                LD DE, Overlay.Info.ShowThreat.GarrisonText                     ; заголовок армии замка
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IY, (DrawCastlePage.CastleName)
                LD BC, #1103
                LD DE, #0011
                ADD IY, DE
                LD A, #05
                CALL Engine.PrintArmyBrief                                      ; вывести краткий список состава армии
                JR .WaitClose

.NoGarrison     LD B, #12
                LD DE, Overlay.Info.DrawCastlePage.NoGarrison                   ; сообщение об отсутствии армии в замке
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
.WaitClose      LD B, #FF
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                RET

.CastleItems    DB #03                                                          ; число пунктов страницы списка замков
                DB #08, #30, #ED, #B7, #B2, #B2, #03, #15
                DB #08, #16, #0A, #15, #0E, #16, #0F, #15
                DB #1B, #16, #02, #07, #0E, #08, #0F, #07
                DB #1E, #08, #02, #08, #0E, #09, #0F, #08
                DB #1E, #09, #02, #09, #0E, #0A, #0F, #09
                DB #1E, #0A, #02, #0A, #0E, #0B, #0F, #0A
                DB #1E, #0B, #02, #0B, #0E, #0C, #0F, #0B
                DB #1E, #0C, #02, #0C, #0E, #0D, #0F, #0C
                DB #1E, #0D, #02, #0D, #0E, #0E, #0F, #0D
                DB #1E, #0E, #02, #0E, #0E, #0F, #0F, #0E
                DB #1E, #0F, #02, #0F, #0E, #10, #0F, #0F
                DB #1E, #10, #02, #10, #0E, #11, #0F, #10
                DB #1E, #11, #02, #11, #0E, #12, #0F, #11
                DB #1E, #12, #02, #12, #0E, #13, #0F, #12
                DB #1E, #13, #02, #13, #0E, #14, #0F, #13
                DB #1E, #14

; -----------------------------------------
; поиск N-го собственного замка в таблице из 35-байтовых записей
; От IX=#BFE0 прибавляет 35 до указателя имени очередной записи. Пропускает запись при
; установленном бит 0 по IX-3 либо ненулевом владельце по IX+16. DJNZ считает только подходящие
; записи. Число A должно соответствовать существующему замку, явной конечной границы у этого
; поиска нет.
; In:
;   A — порядковый номер своего замка с 1
; Out:
;   IX — имя найденного замка, DE, BC, AF сохранены
; Corrupt:
;   IX. HL, DE, BC, AF, HL', DE', BC', AF', IY сохранены, DE, BC и AF явно восстанавливаются со
;   стека
; Note:
;   IX
; -----------------------------------------
FindOwnCastle   PUSH DE
                PUSH BC
                PUSH AF
                LD B, A
                LD IX, Runtime.Castles + FCastle.Name - FCastle                 ; база перед именем первой записи замка для цикла с первым ADD на FCastle
                LD DE, #0023

                ; счётчик уменьшается только на действующих собственных замках, чужие и
                ; выключенные записи пропускаются
.NextCastle     ADD IX, DE
                BIT CASTLE_OFF_BIT, (IX + FCastle.Flags - FCastle.Name)         ; -#03, бит 0 выключает запись, значения остальных битов отдельно не установлены
                JR NZ, .NextCastle                                              ; переход, если запись замка выключена из общего поиска

                LD A, (IX + FCastle.Owner - FCastle.Name)                       ; +#10, 0 собственный замок, 1..15 правитель FRuler, #FF особое отсутствие правителя/банды
                OR A
                JR NZ, .NextCastle                                              ; переход, если замок принадлежит другому правителю

                DJNZ .NextCastle

                POP AF
                POP BC
                POP DE
                RET

; -----------------------------------------
; вывод текущей страницы списка собственных замков
; Очищает область, выбирает банк 0, начинает с индекса DrawCastlePage.FirstCastle и заканчивает
; после 26 названий либо
; достижения ListSpells.CastleCount. FindOwnCastle возвращает каждое имя. Названия размещаются в
; двух столбцах 13 строк, а
; число активных пунктов меню ShowCastleInfo.CastleItems увеличивается после каждого.
; In:
;   DrawCastlePage.FirstCastle — индекс начала, ListSpells.CastleCount — общее число
; Out:
;   меню содержит только фактически напечатанные замки
; Corrupt:
;   HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены, имена замков печатаются как обычные
;   строки без числовых управляющих вставок
; Note:
;   экран, ShowCastleInfo.CastleItems, DrawCastlePage.CastleListXY, DrawCastlePage.PageItems, банк 0
; -----------------------------------------
DrawCastlePage  LD BC, #0702
                LD DE, #0D1C
                LD A, #45
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD BC, #0703
                LD (DrawCastlePage.CastleListXY), BC
                LD A, #03
                LD (ShowCastleInfo.CastleItems), A
                XOR A
                LD (DrawCastlePage.PageItems), A
                LD A, (ListSpells.CastleCount)
                LD L, A
                LD A, (DrawCastlePage.FirstCastle)
                LD H, A

                ; одна страница содержит не более 26 собственных замков в двух столбцах
.CastleItem     LD A, (DrawCastlePage.PageItems)
                CP #1A
                RET Z                                                           ; выход, если напечатано 26 названий текущей страницы

                LD A, (DrawCastlePage.PageItems)
                ADD A, H
                INC L
                CP L
                RET NC                                                          ; выход, если перечислены все собственные замки до конца каталога

                DEC L
                CALL FindOwnCastle
                PUSH IX
                POP DE
                LD BC, #0000
.CastleListXY   EQU $ - 2                                                       ; координаты очередного названия в списке замков
.CastleListRow  EQU $ - 1                                                       ; строка очередного названия в списке замков
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, #00
.PageItems      EQU $ - 1                                                       ; число показанных замков на текущей странице
                INC A
                LD (DrawCastlePage.PageItems), A
                LD A, (DrawCastlePage.PageItems)
                SRL A
                ADD A, #07
                LD (DrawCastlePage.CastleListRow), A
                LD A, (DrawCastlePage.CastleListXY)
                CP #03
                LD A, #14
                JR Z, .StoreItem                                                ; переход, если предыдущее название стояло слева и следующее выводится справа

                LD A, #03
.StoreItem      LD (DrawCastlePage.CastleListXY), A
                LD A, (ShowCastleInfo.CastleItems)
                INC A
                LD (ShowCastleInfo.CastleItems), A
                JR .CastleItem

.FirstCastle    DB #00                                                          ; индекс первого замка текущей страницы
.CastleDetails  EQU $                                                           ; формат имени замка и недельного дохода
                DB #87, #A0, #AC, #AE, #AA, #20, #0E
.CastleName     DW #0000                                                        ; адрес имени выбранного собственного замка
                DB #0D, #2A, #85, #A6, #A5, #AD, #A5, #A4
                DB #A5, #AB, #EC, #AD, #EB, #A9, #20, #E1
                DB #A1, #AE, #E0, #3A, #20, #0F
.CastleIncome   DW #0000                                                        ; еженедельный доход выбранного замка
                DB #00, #AC, #AE, #AD, #A5, #E2, #2E, #0D
                DB #05, #00, #82, #A0, #E8, #A8, #20, #A7
.NextPageText   EQU $+6                                                         ; надпись следующей страницы замков
                DB #A0, #AC, #AA, #A8, #3A, #00, #82, #AF
.PrevPageText   EQU $+5                                                         ; надпись предыдущей страницы замков
                DB #A5, #E0, #A5, #A4, #00, #8D, #A0, #A7
.ClosePageText  EQU $+3                                                         ; надпись закрытия списка замков
                DB #A0, #A4, #00, #9F, #20, #AD, #A0, #E1
                DB #AC, #AE, #E2, #E0, #A5, #AB, #E1, #EF
.NoGarrison     EQU $+1                                                         ; сообщение об отсутствии армии в замке
                DB #00, #82, #20, #A7, #A0, #AC, #AA, #A5
                DB #20, #AD, #A5, #E2, #20, #A0, #E0, #AC
                DB #A8, #A8, #2E, #0D, #2A, #00

; -----------------------------------------
; показ списка побеждённых противников
; Размер окна берёт из ListSpells.RulerCount. Для ID1..15 вызывает #87D1, при ненулевом
; результате получает
; 28-байтовый описатель через #804E и печатает его имя. После ожидания возвращается к
; Entry.DrawStats.
; In:
;   ListSpells.RulerCount — число побеждённых, таблицы врагов/замков
; Out:
;   переход к статистике
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом продолжения общего меню по Entry.DrawStats,
;   локальный PUSH/POP AF сохраняет лишь индекс цикла внутри обработчика
; Note:
;   экран, банки, рабочие операнды ListRulers.RulerListXY/ListRulers.PluralSuffix
; -----------------------------------------
ListRulers      LD BC, #0506
                LD A, (ListSpells.RulerCount)
                LD D, A
                INC D
                LD E, #12
                LD A, #41
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD D, #20
                LD A, (ListSpells.RulerCount)
                CP #01
                JR Z, .TitleRow                                                 ; переход, если побеждён только один правитель и заголовок требует единственного числа

                LD D, #EB
.TitleRow       LD A, D
                LD (ListRulers.PluralSuffix), A
                LD BC, #0607
                LD DE, #0112
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD B, #06
                LD DE, Overlay.Info.ListRulers.KilledTitle                      ; заголовок списка побеждённых правителей с изменяемым суффиксом
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #070C
                LD (ListRulers.RulerListXY), BC
                LD A, #01
.RulerRecord    PUSH AF
                LD B, A
                CALL Engine.HasOwnerCastle                                      ; найти активную запись с заданным владельцем
                JR Z, .NextRuler                                                ; переход, если у очередного правителя ещё есть замок и его нельзя считать побеждённым

                LD A, B
                CALL Engine.RulerDesc                                           ; получить описатель одного из пятнадцати вражеских правителей
                PUSH IX
                POP DE
                LD BC, #0000
.RulerListXY    EQU $ - 2                                                       ; координаты очередного имени правителя
.RulerListRow   EQU $ - 1                                                       ; строка очередного имени правителя
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (ListRulers.RulerListRow)
                INC A
                LD (ListRulers.RulerListRow), A
.NextRuler      POP AF
                INC A
                CP #10
                JR NZ, .RulerRecord                                             ; переход, если проверены ещё не все 15 правителей

                LD B, #FF
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP Entry.DrawStats

.KilledTitle    EQU $                                                           ; заголовок списка побеждённых правителей с изменяемым суффиксом
                DB #82, #A0, #AC, #A8, #20, #E3, #A1, #A8
                DB #E2
.PluralSuffix   DB #20                                                          ; суффикс заголовка «Вами убит[ы]», пробел для одного правителя и буква ы для нескольких
                DB #3A, #0D, #0A, #00

; -----------------------------------------
; подробности текущего контракта на захват замка
; Берёт указатель цели ListSpells.ContractCastle. Определяет её континент, для текущего показывает
; направление/расстояние, иначе название континента. Владелец по имени+16=#FF означает отсутствие
; владельца, прочий ID выбирает описатель #804E. Выводит пять записей гарнизона с имени+17 через
; #7E55 и возвращается в статистику.
; In:
;   ListSpells.ContractCastle — имя контрактного замка
; Out:
;   переход к Entry.DrawStats
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом расчёта расстояния, гарнизона и
;   продолжения общего меню по Entry.DrawStats
; Note:
;   экран, банки и поля строк
; -----------------------------------------
ShowContract    LD BC, #0901
                LD DE, #0C1C
                LD A, #45
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0A
                LD DE, Overlay.Info.ListSpells.ContractText                     ; формат имени контрактного замка
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD HL, (ListSpells.ContractCastle)
                DEC HL
                DEC HL
                DEC HL
                LD IX, State.CastlesLists
                CALL Engine.SelectThreshold                                     ; определить одну из четырёх категорий по порогам
                LD C, A
                LD A, (State.Continent)
                CP C
                JR NZ, .OwnerText                                               ; переход, если контрактный замок находится на другом континенте

                LD IX, (ListSpells.ContractCastle)
                LD BC, (State.Position)
                LD E, (IX + FCastle.X - FCastle.Name)                           ; -#02, столбец карты
                LD D, (IX + FCastle.Y - FCastle.Name)                           ; -#01, строка карты
                CALL Engine.GetDirection                                        ; определить одно из восьми направлений от BC к DE
                LD (ShowThreat.DirectionText), DE
                LD BC, (State.Position)
                LD E, (IX + FCastle.X - FCastle.Name)                           ; -#02, столбец карты
                LD D, (IX + FCastle.Y - FCastle.Name)                           ; -#01, строка карты
                CALL Engine.FloorDistance                                       ; вычислить целую часть евклидова расстояния
                LD L, C
                LD H, B
                ADD HL, HL
                ADD HL, HL
                LD BC, #0005
                ADD HL, BC
                LD C, L
                LD B, H
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #A4, #05, #27, #A4, #04, #27, #38                            ; токен калькулятора, исходное значение, B7A0
                CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD (ShowThreat.CastleDistance), BC
                LD DE, Overlay.Info.ShowThreat.DistanceText                     ; формат направления и расстояния до замка
                LD L, C
                LD H, B
                LD BC, #0014
                OR A
                SBC HL, BC
                JR NC, .PrintOwner                                              ; переход, если расчётное расстояние до контрактного замка составляет не менее 20

                LD DE, Overlay.Info.ShowThreat.NearbyText                       ; сообщение о близком расположении замка
                JR .PrintOwner

.OwnerText      LD B, C
                LD HL, Engine.MainLoop.LandNameIndex                            ; смещённая база перед списком имён континентов, поиск начинает с INC HL, первое имя находится по #6992
                XOR A
.FindOwnerText  INC HL
                CP (HL)
                JR NZ, .FindOwnerText                                           ; переход, если ещё не найден конец очередного названия континента

                DJNZ .FindOwnerText

                INC HL
                LD (ShowThreat.ContinentText), HL
                LD DE, Overlay.Info.ShowThreat.OtherLandText                    ; формат континента удалённого замка
.PrintOwner     LD B, #0C
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IX, (ListSpells.ContractCastle)
                LD DE, Overlay.Info.ShowThreat.UnownedText                      ; сообщение об отсутствии владельца замка
                LD A, (IX + FCastle.Owner - FCastle.Name)                       ; +#10, 0 собственный замок, 1..15 правитель FRuler, #FF особое отсутствие правителя/банды
                CP #FF
                JR Z, .ContractArmy                                             ; переход, если контрактный замок не имеет правителя и показывается только его армия

                CALL Engine.RulerDesc                                           ; получить описатель одного из пятнадцати вражеских правителей
                LD (ShowThreat.ContractRuler), IX
                LD DE, Overlay.Info.ShowThreat.RulerText                        ; формат имени владельца замка
.ContractArmy   LD B, #0E
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #10
                LD DE, Overlay.Info.ShowThreat.GarrisonText                     ; заголовок армии замка
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IY, (ListSpells.ContractCastle)
                LD BC, #1103
                LD DE, #0011
                ADD IY, DE
                LD A, #05
                CALL Engine.PrintArmyBrief                                      ; вывести краткий список состава армии
                LD B, #FF
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP Entry.DrawStats

; -----------------------------------------
; показ замка, на который готовится нападение
; Из ListSpells.ThreatCastle берёт указатель на имя замка, вызывает общую карточку
; ShowCastleInfo и возвращается к
; статистике.
; In:
;   ListSpells.ThreatCastle — имя целевого замка
; Out:
;   переход к Entry.DrawStats
; Corrupt:
; HL, DE, BC, AF, HL', DE', BC', AF', IX, IY через карточку ShowCastleInfo и продолжение общего
; меню по
;   Entry.DrawStats
; Note:
;   эффекты карточки ShowCastleInfo
; -----------------------------------------
ShowThreat      LD IX, (ListSpells.ThreatCastle)
                CALL ShowCastleInfo
                JP Entry.DrawStats

.DistanceText   EQU $                                                           ; формат направления и расстояния до замка
                DB #8E, #E2, #AD, #AE, #E1, #A8, #E2, #A5
                DB #AB, #EC, #AD, #AE, #20, #A2, #A0, #E1
                DB #20, #A7, #A0, #AC, #AE, #AA, #20, #AD
                DB #A0, #E5, #AE, #A4, #A8, #E2, #E1, #EF
                DB #20, #AD, #A0, #0D, #05, #0E
.DirectionText  DW #0000                                                        ; адрес направления к выбранному замку
                DB #2C, #20, #A4, #AE, #20, #AD, #A5, #A3
                DB #AE, #20, #AE, #AA, #AE, #AB, #AE, #20
                DB #0F
.CastleDistance DW #0000                                                        ; численное расстояние для сообщения о замке
                DB #00, #AC, #A8, #AB, #EC, #2E, #0D, #02
.NearbyText     EQU $+1                                                         ; сообщение о близком расположении замка
                DB #00, #82, #EB, #20, #AD, #A0, #E5, #AE
                DB #A4, #A8, #E2, #A5, #E1, #EC, #20, #AE
                DB #AA, #AE, #AB, #AE, #20, #AD, #A5, #A3
.OtherLandText  EQU $+5                                                         ; формат континента удалённого замка
                DB #AE, #2E, #0D, #05, #00, #87, #A0, #AC
                DB #AE, #AA, #20, #AD, #A0, #E5, #AE, #A4
                DB #A8, #E2, #E1, #EF, #20, #AD, #A0, #20
                DB #AA, #AE, #AD, #E2, #A8, #AD, #A5, #AD
                DB #E2, #A5, #2C, #0D, #05, #AF, #AE, #A4
                DB #20, #AD, #A0, #A7, #A2, #A0, #AD, #A8
                DB #A5, #AC, #20, #0E
.ContinentText  DW #0000                                                        ; адрес названия континента выбранного замка
.UnownedText    EQU $+3                                                         ; сообщение об отсутствии владельца замка
                DB #0D, #02, #00, #93, #20, #AD, #A5, #A3
                DB #AE, #20, #AD, #A5, #E2, #20, #A2, #AB
                DB #A0, #A4, #A5, #AB, #EC, #E6, #A0, #2E
.RulerText      EQU $+3                                                         ; формат имени владельца замка
                DB #0D, #05, #00, #85, #A3, #AE, #20, #E5
                DB #AE, #A7, #EF, #A8, #AD, #20, #3A, #20
                DB #0E
.ContractRuler  DW #0000                                                        ; адрес имени владельца контрактного замка
.GarrisonText   EQU $+3                                                         ; заголовок армии замка
                DB #0D, #05, #00, #80, #E0, #AC, #A8, #EF
                DB #20, #A2, #20, #A7, #A0, #AC, #AA, #A5
                DB #3A, #0D, #05, #00

; -----------------------------------------
; список изученных заклинаний
; Размер окна определяется числом ListSpells.SpellCount. Перебирает десять ID1..10, проверяет
; бит 0 в #6A09+ID.
; Для изученного получает 23-байтовый описатель через #8066 и печатает его имя, затем ждёт
; действия и возвращается в статистику.
; In:
;   #6A0A..#6A13 — флаги заклинаний
; Out:
;   переход к Entry.DrawStats
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом продолжения общего меню по Entry.DrawStats,
;   PUSH/POP AF внутри списка сохраняет только его текущий номер
; Note:
;   экран, банк 3, операнд координат ListSpells.SpellListXY
; -----------------------------------------
ListSpells      LD BC, #0806
                LD A, (ListSpells.SpellCount)
                LD D, A
                INC D
                LD E, #12
                LD A, #41
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #0907
                LD DE, #0112
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD B, #09
                LD DE, Overlay.Info.ListSpells.SpellsTitle                      ; заголовок списка изученных заклинаний
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #0A0C
                LD (ListSpells.SpellListXY), BC
                LD A, #01
.SpellRecord    PUSH AF
                LD B, #00
                LD C, A
                LD HL, State.Spells - 1                                         ; смещённая база состояний заклинаний, ID 1 приводит к первому байту State.Spells
                ADD HL, BC
                BIT SPELL_KNOWN_BIT, (HL)                                       ; флаг, заклинание изучено героем
                JR Z, .NextSpell                                                ; переход, если очередное заклинание ещё не изучено

                LD A, C
                CALL Engine.SpellDesc                                           ; получить описатель одного из десяти заклинаний
                PUSH IX
                POP DE
                LD BC, #0000
.SpellListXY    EQU $ - 2                                                       ; координаты очередного заклинания
.SpellListRow   EQU $ - 1                                                       ; строка очередного заклинания
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (ListSpells.SpellListRow)
                INC A
                LD (ListSpells.SpellListRow), A
.NextSpell      POP AF
                INC A
                CP #0B
                JR NZ, .SpellRecord                                             ; переход, если проверены ещё не все десять заклинаний

                LD B, #FF
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP Entry.DrawStats

.SpellsTitle    EQU $                                                           ; заголовок списка изученных заклинаний
                DB #82, #EB, #20, #AF, #AE, #A7, #AD, #A0
                DB #AB, #A8, #3A, #0D, #0A, #00
.StatsItems     DB #00                                                          ; число пунктов основного меню статистики
                DB #08, #48, #ED, #B8, #B2, #B2, #14, #16
                DB #1F, #17
.CastleRectMin  DW #0000                                                        ; начало прямоугольника выбора списка замков
.CastleRectMax  DW #0000                                                        ; конец прямоугольника выбора списка замков
.RulerRectMin   DW #0000                                                        ; начало прямоугольника выбора правителей
.RulerRectMax   DW #0000                                                        ; конец прямоугольника выбора правителей
.ContractMin    DW #0000                                                        ; начало прямоугольника выбора контракта
.ContractMax    DW #0000                                                        ; конец прямоугольника выбора контракта
.SpellRectMin   DW #0000                                                        ; начало прямоугольника выбора заклинаний
.SpellRectMax   DW #0000                                                        ; конец прямоугольника выбора заклинаний
.StatsHandlers  EQU $+4                                                         ; пять адресов обработчиков пунктов статистики без пункта закрытия
                DB #01, #14, #1F, #16, #05, #B4, #D8, #B6
.ThreatText     EQU $+6                                                         ; сообщение о готовящемся нападении на замок
                DB #49, #B7, #F3, #B8, #19, #B8, #8D, #A0
                DB #20, #A2, #A0, #E8, #20, #A7, #A0, #AC
                DB #AE, #AA, #20, #0E
.ThreatCastle   DW #0000                                                        ; адрес имени атакуемого замка
                DB #0D, #2A, #A3, #AE, #E2, #AE, #A2, #A8
                DB #E2, #E1, #EF, #20, #AD, #A0, #AF, #A0
                DB #A4, #A5, #AD, #A8, #A5, #2E, #0D, #2A
.CloseText      EQU $+1                                                         ; надпись пункта Я насмотрелся
                DB #00, #9F, #20, #AD, #A0, #E1, #AC, #AE
                DB #E2, #E0, #A5, #AB, #E1, #EF, #0D, #1B
.NoSpellsText   EQU $+1                                                         ; сообщение об отсутствии изученных заклинаний
                DB #00, #8F, #AE, #AA, #A0, #20, #E7, #E2
                DB #AE, #20, #A2, #EB, #20, #AD, #A5, #20
                DB #20, #AF, #AE, #A7, #AD, #A0, #AB, #A8
                DB #20, #20, #AD, #A8, #20, #AE, #A4, #AD
                DB #AE, #A3, #AE, #0D, #05, #A7, #A0, #AA
                DB #AB, #A8, #AD, #A0, #AD, #A8, #EF, #2E
.SpellCountData EQU $+3                                                         ; формат числа изученных заклинаний
                DB #0D, #02, #00, #87, #A0, #20, #A2, #E0
                DB #A5, #AC, #EF, #20, #20, #E1, #E2, #E0
                DB #A0, #AD, #E1, #E2, #A2, #A8, #A9, #20
                DB #20, #A2, #A0, #AC, #20, #20, #E3, #A4
                DB #A0, #AB, #AE, #E1, #EC, #0D, #05, #AF
                DB #AE, #A7, #AD, #A0, #E2, #EC, #20, #0F
.SpellCount     DB #00                                                          ; число изученных заклинаний
                DB #00, #00, #A7, #A0, #AA, #AB, #A8, #AD
                DB #A0, #AD, #A8, #A9, #2E, #0D, #02, #00
.NoCultText     EQU $                                                           ; сообщение об отсутствии выбранного культа
                DB #82, #EB, #20, #AD, #A5, #20, #A2, #E1
                DB #E2, #E3, #AF, #A8, #AB, #A8, #20, #AD
                DB #A8, #20, #A2, #20, #AE, #A4, #AD, #E3
                DB #20, #A8, #A7, #20, #E1, #A5, #AA, #E2
.CultTextData   EQU $+4                                                         ; формат имени выбранного культа
                DB #2E, #0D, #05, #00, #82, #EB, #20, #AF
                DB #AE, #AA, #AB, #AE, #AD, #EF, #A5, #E2
                DB #A5, #E1, #EC, #20, #84, #E3, #E5, #A0
                DB #AC, #20, #0E
.CultText       DW #0000                                                        ; адрес названия секты
.HasSiegeText   EQU $+3                                                         ; сообщение о наличии осадных орудий
                DB #0D, #05, #00, #84, #AB, #EF, #20, #E8
                DB #E2, #E3, #E0, #AC, #A0, #20, #A7, #A0
                DB #AC, #AA, #A0, #20, #E3, #20, #20, #A2
                DB #A0, #E1, #20, #20, #A5, #E1, #E2, #EC
                DB #20, #20, #A2, #E1, #A5, #0D, #05, #AD
                DB #A5, #AE, #A1, #E5, #AE, #A4, #A8, #AC
                DB #EB, #A5, #20, #AE, #E1, #A0, #A4, #AD
                DB #EB, #A5, #20, #AE, #E0, #E3, #A4, #A8
.NeedSiegeText  EQU $+5                                                         ; сообщение о необходимости купить осадные орудия
                DB #EF, #2E, #0D, #02, #00, #84, #AB, #EF
                DB #20, #E8, #E2, #E3, #E0, #AC, #A0, #20
                DB #A7, #A0, #AC, #AA, #A0, #20, #20, #A2
                DB #A0, #AC, #20, #20, #AD, #A0, #A4, #AE
                DB #20, #AA, #E3, #AF, #A8, #E2, #EC, #0D
                DB #05, #AE, #E1, #A0, #A4, #AD, #EB, #A5
                DB #20, #AE, #E0, #E3, #A4, #A8, #EF, #2E
.StatsHeading   EQU $+3                                                         ; заголовок окна статистики
                DB #0D, #02, #00, #8D, #A5, #AC, #AD, #AE
                DB #A3, #AE, #20, #E1, #E2, #A0, #E2, #A8
                DB #E1, #E2, #A8, #AA, #A8, #2E, #0D, #2A
.NoCastlesText  EQU $+1                                                         ; сообщение о полном отсутствии захваченных замков
                DB #00, #8A, #20, #ED, #E2, #AE, #AC, #E3
                DB #20, #AC, #AE, #AC, #A5, #AD, #E2, #E3
                DB #20, #A2, #EB, #20, #AD, #A5, #20, #A7
                DB #A0, #E5, #A2, #A0, #E2, #A8, #AB, #A8
                DB #20, #AD, #A8, #0D, #05, #AE, #A4, #AD
                DB #AE, #A3, #AE, #20, #A7, #A0, #AC, #AA
                DB #A0, #2C, #20, #A2, #E1, #A5, #20, #A2
                DB #A0, #E8, #A8, #20, #20, #A2, #E0, #A0
                DB #A3, #A8, #20, #20, #A6, #A8, #A2, #EB
                DB #20, #20, #A8, #0D, #02, #E7, #E3, #A2
                DB #E1, #E2, #A2, #E3, #EE, #E2, #20, #E1
                DB #A5, #A1, #EF, #20, #AF, #E0, #A5, #AA
                DB #E0, #A0, #E1, #AD, #AE, #2E, #0D, #02
.CastleCounData EQU $+1                                                         ; формат числа захваченных замков
                DB #00, #8F, #AE, #AA, #A0, #20, #E7, #E2
                DB #AE, #20, #A2, #EB, #20, #A7, #A0, #E5
                DB #A2, #A0, #E2, #A8, #AB, #A8, #20, #0F
.CastleCount    DW #0000                                                        ; число собственных замков
                DB #00, #A7, #A0, #AC, #AA, #AE, #A2, #2C
.NoKilledText   EQU $+3                                                         ; сообщение об отсутствии побеждённых правителей
                DB #0D, #05, #00, #AD, #AE, #20, #AD, #A8
                DB #20, #AE, #A4, #A8, #AD, #20, #A8, #A7
                DB #20, #A2, #A0, #E8, #A8, #E5, #20, #A2
                DB #E0, #A0, #A3, #AE, #A2, #20, #A5, #E9
                DB #A5, #20, #AD, #A5, #0D, #02, #E3, #AD
                DB #A8, #E7, #E2, #AE, #A6, #A5, #AD, #2E
.KilledCount    EQU $+3                                                         ; формат числа побеждённых правителей
                DB #0D, #02, #00, #A2, #A0, #AC, #A8, #20
                DB #AF, #AE, #A1, #A5, #A6, #A4, #A5, #AD
                DB #EB, #20, #0F
.RulerCount     DW #0000                                                        ; число побеждённых правителей, у которых не осталось действующих замков
                DB #00, #A2, #E0, #A0, #A3, #AE, #A2, #2C
                DB #20, #AA, #20, #E1, #AE, #A6, #A0, #AB
                DB #A5, #AD, #A8, #EE, #0D, #02, #A2, #A0
                DB #AC, #20, #A5, #E1, #E2, #EC, #20, #A5
                DB #E9, #A5, #20, #E7, #A5, #AC, #20, #A7
                DB #A0, #AD, #EF, #E2, #E1, #EF, #2E, #0D
.AllCastlesText EQU $+2                                                         ; сообщение о владении всеми замками страны
                DB #02, #00, #82, #E1, #A5, #20, #A7, #A0
                DB #AC, #AA, #A8, #20, #91, #92, #90, #80
                DB #8D, #9B, #20, #8C, #88, #94, #8E, #82
                DB #20, #AF, #E0, #A8, #AD, #A0, #A4, #AB
                DB #A5, #A6, #A0, #E2, #0D, #05, #A2, #A0
                DB #AC, #2C, #20, #E3, #20, #A2, #A0, #E1
                DB #20, #AD, #A5, #20, #AE, #E1, #E2, #A0
                DB #AB, #AE, #E1, #EC, #20, #AD, #A8, #20
                DB #A2, #E0, #A0, #A3, #AE, #A2, #2E, #0D
.NoContract     EQU $+2                                                         ; сообщение об отсутствии контракта
                DB #02, #00, #82, #20, #AD, #A0, #E1, #E2
                DB #AE, #EF, #E9, #A5, #A5, #20, #A2, #E0
                DB #A5, #AC, #EF, #20, #A2, #EB, #20, #AD
                DB #A5, #20, #E1, #A2, #EF, #A7, #A0, #AD
                DB #EB, #20, #20, #AD, #A8, #0D, #05, #AA
                DB #A0, #AA, #A8, #AC, #20, #AA, #AE, #AD
                DB #E2, #E0, #A0, #AA, #E2, #AE, #AC, #2E
.ContractText   EQU $+3                                                         ; формат имени контрактного замка
                DB #0D, #02, #00, #82, #EB, #20, #20, #A7
                DB #A0, #AA, #AB, #EE, #E7, #A8, #AB, #A8
                DB #20, #20, #20, #AA, #AE, #AD, #E2, #E0
                DB #A0, #AA, #E2, #20, #20, #AD, #A0, #20
                DB #20, #A7, #A0, #E5, #A2, #A0, #E2, #0D
                DB #05, #A7, #A0, #AC, #AA, #A0, #20, #0E
.ContractCastle DW #0000                                                        ; адрес записи контрактного замка
                DB #0D, #02, #00, #6F, #76, #65, #72, #6C
                DB #61, #79

                assert $ = #BCB4
                endmodule
                endmodule
