; оверлей 14 из OVR2
; исходный файл каталога 49, смещение #0000
                module Overlay
                module Sail
                org #B200

; -----------------------------------------
; переход на выбранный доступный континент по морю
; Возвращается без окна при сброшенном бит 0 #6A34 или если (#6A33 AND3)!=1. Из флагов #6A34
; строит список континентов. Выбор текущего континента и отмена ничего не меняют. Для нового
; задаёт #69D7=#FF, на время десяти вызовов дневного шага #9704 устанавливает бит 7 #6565. Затем
; меняет #6A2D/#6A30, устанавливает координаты причаливания из #B3AE и загружает KARTA?. Случайно
; выбирает допустимые клетки для встреч, отмечая их бит 7. Печатает сообщение о прибытии и
; возвращается к основному экрану.
; In:
;   #6A34 — доступность, #6A33 — режим передвижения, текущий континент
; Out:
;   при успехе изменён континент, режим и координаты, обычный возврат
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY на полном пути с переходом континента, загрузкой
;   карты и суточной обработкой #9704. На ранних RET меняются только AF
; Note:
;   карта банк 10, #6A2D..#6A32, координаты встреч #6A44/#6A4B, #6A46, экран и временные поля
;   оверлея
; -----------------------------------------
Entry           LD A, (State.MapFlags)
                BIT SEA_ACCESS_BIT, A                                           ; флаг, открыт континент 2 и разрешён вход в морское меню перехода
                RET Z                                                           ; выход, если путешествие по морю ещё не разрешено картой героя

                LD A, (State.MoveFlags)
                AND #03
                CP #01
                RET NZ                                                          ; выход, если герой сейчас не находится на корабле

                LD BC, #1000
                LD DE, #061E
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #1201
                LD DE, #011E
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #1104
                LD DE, Overlay.Sail.Entry.ChooseLandText                        ; вопрос о континенте плавания и пункт отказа
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, #01
                LD (Entry.MenuCount), A
                LD A, (State.MapFlags)
                SLA A
                SET SEA_FIRST_BIT, A                                            ; младший разряд временной маски списка морских континентов, всегда разрешает первый континент после сдвига исходных MapFlags
                AND #0F
                LD DE, Engine.MainLoop.LandNameIndex                            ; смещённая база перед списком имён континентов, поиск начинает с INC HL, первое имя находится по #6992
                LD BC, #1304
                LD (Entry.ChoiceXY), BC
.ContinentFlag  SRL A
                JR NC, .ChooseLand                                              ; переход, если очередной континент недоступен и дальнейших пунктов меню нет

                PUSH AF
                LD A, (Entry.MenuCount)
                INC A
                LD (Entry.MenuCount), A
.NextLandText   INC DE
                LD A, (DE)
                OR A
                JR NZ, .NextLandText                                            ; переход, если ещё не найден конец названия текущего континента

                INC DE
                PUSH DE
                LD BC, #0000
.ChoiceXY       EQU $ - 2                                                       ; операнд координат очередного пункта континента
.ChoiceRow      EQU $ - 1                                                       ; строка очередного пункта континента
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (Entry.ChoiceRow)
                INC A
                LD (Entry.ChoiceRow), A
                POP DE
                POP AF
                JR .ContinentFlag

.ChooseLand     LD IX, Entry.MenuCount
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #01
                JP Z, .RefreshScreen                                            ; переход, если игрок отменил выбор континента

                DEC A
                LD HL, State.Continent
                CP (HL)
                JP Z, .RefreshScreen                                            ; переход, если выбран текущий континент и переход не требуется

                LD (Entry.NextContinent), A
                LD A, #FF
                LD (State.StepCost), A
                LD A, (State.EventFlags)
                SET EVENT_LOCK_BIT, A                                           ; флаг, временно запрещены развитие отрядов и отдельные мировые события
                LD (State.EventFlags), A
                CALL Engine.RefreshHero                                         ; обновить боковую панель героя, расходы и рейтинг
                LD B, #0A

                ; на время десяти дневных шагов отключены отдельные мировые события и развитие
                ; отрядов
.PassDay        PUSH BC
                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                LD BC, #0400
                LD DE, #1414
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                CALL Engine.TickTime                                            ; продвинуть время игры и выполнить периодические расчёты
                LD A, (State.MoveFlags)
                AND #03
                JR NZ, .NextDay                                                 ; переход, если после хода времени герой ещё не перешёл в пеший режим

                POP BC
                JP .RefreshScreen

.NextDay        POP BC
                DJNZ .PassDay

                LD A, (State.EventFlags)
                RES EVENT_LOCK_BIT, A                                           ; флаг, временно запрещены развитие отрядов и отдельные мировые события
                LD (State.EventFlags), A
                LD A, (Entry.NextContinent)
                LD (State.Continent), A
                LD (State.ShipMap), A
                LD E, A
                DEC E
                SLA E
                LD HL, Overlay.Sail.Entry.ArrivalCells                          ; четыре слова начальных клеток прибытия на континенты
                ADD HL, DE
                LD C, (HL)
                INC HL
                LD B, (HL)
                LD (State.Position), BC
                LD (State.ShipPos), BC
                CALL Engine.SelectMapBank                                       ; выбрать логический банк 10 с текущей картой
                LD A, (State.Continent)
                ADD A, #30
                LD (Engine.Interrupt.MapFileDigit), A
                LD HL, Engine.Interrupt.MapFile                                 ; девятибайтное изменяемое имя KARTA? для загрузки континента
                LD DE, Runtime.CurrentMap                                       ; адрес загрузки карты континента в логическом банке 10
                CALL Engine.LoadFile                                            ; загрузить именованный файл через TR-DOS
                CALL Engine.MarkMapObjects                                      ; пометить занятые клетки карты для групп объектов
                CALL Engine.SelectMapBank                                       ; выбрать логический банк 10 с текущей картой
                LD A, (State.Continent)
                LD (State.GoodStoryMap), A

                ; доброжелательный рассказчик получает новую свободную клетку текущего континента
.GoodStoryCell  LD DE, #00A0
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD C, E
                LD DE, #0063
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD B, E
                CALL Engine.MapCellAddress                                      ; вычислить адрес клетки карты
                LD A, (HL)
                BIT MAP_BUSY_BIT, A                                             ; флаг, клетка стратегической карты занята объектом
                JR NZ, .GoodStoryCell                                           ; переход, если случайная клетка уже занята объектом

                AND #3F
                JR NZ, .GoodStoryCell                                           ; переход, если случайная клетка имеет ненулевой тип местности

                SET MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты занята объектом
                LD (State.GoodStoryPos), BC
                LD A, (State.Continent)
                LD E, A
                LD A, (State.BadStoryMap)
                CP E
                JR NZ, .ArrivalText                                             ; переход, если враждебный рассказчик находится на другом континенте

                ; враждебный рассказчик размещается здесь только если его выбранный континент
                ; совпал с текущим
.BadStoryCell   LD DE, #00A0
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD C, E
                LD DE, #0063
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD B, E
                CALL Engine.MapCellAddress                                      ; вычислить адрес клетки карты
                LD A, (HL)
                BIT MAP_BUSY_BIT, A                                             ; флаг, клетка стратегической карты занята объектом
                JR NZ, .BadStoryCell                                            ; переход, если случайная клетка уже занята объектом

                AND #3F
                JR NZ, .BadStoryCell                                            ; переход, если случайная клетка имеет ненулевой тип местности

                SET MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты занята объектом
                LD (State.BadStoryPos), BC
.ArrivalText    LD HL, Overlay.Sail.Entry.LandNameBuffer                        ; одиннадцатибайтный буфер имени континента в сообщении о прибытии
                LD DE, Overlay.Sail.Entry.LandNameBuffer + 1                    ; следующий байт буфера имени континента, используется очисткой через LDIR
                LD BC, #000A
                LD (HL), #00
                LDIR
                LD A, (State.Continent)
                LD B, A
                XOR A
                LD IX, Engine.MainLoop.LandNameIndex                            ; смещённая база перед списком имён континентов, поиск начинает с INC HL, первое имя находится по #6992
.FindLandText   INC IX
                CP (IX + #00)
                JR NZ, .FindLandText                                            ; переход, если ещё не найден терминатор очередного названия континента

                DJNZ .FindLandText

                LD HL, Overlay.Sail.Entry.LandNameBuffer                        ; одиннадцатибайтный буфер имени континента в сообщении о прибытии
.NextChar       EQU 1                                                           ; смещение следующего символа, текущий символ ещё копируется из (IX)
.CopyLandText   INC IX
                LD A, (IX + .NextChar)                                          ; проверить завершение строки перед переносом текущего символа
                OR A
                JR Z, .PrintArrival                                             ; переход, если название континента полностью скопировано в сообщение прибытия

                LD A, (IX + #00)
                LD (HL), A
                INC HL
                JR .CopyLandText

.PrintArrival   LD (HL), #EF
                INC HL
                LD (HL), #00
                CALL Engine.UpdateLocalView                                     ; отметить открытые клетки вокруг героя и подготовить экранные объекты
                HALT
                LD BC, #1000
                LD DE, #061E
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #1101
                LD DE, #061E
                LD A, #46
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #1501
                LD DE, #011E
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD B, #12
                LD DE, Overlay.Sail.Entry.ArrivalTexData                        ; сообщение о завершении плавания и имени континента прибытия
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
.RefreshScreen  CALL Engine.RefreshPanels                                       ; перерисовать верхнюю строку и боковую панель игры
                RET

.ArrivalCells   EQU $                                                           ; четыре слова начальных клеток прибытия на континенты
                DB #08, #15, #16, #05, #14, #0F, #96, #04
.NextContinent  DB #00                                                          ; номер выбранного континента
.ChooseLandText EQU $                                                           ; вопрос о континенте плавания и пункт отказа
                DB #8D, #A0, #20, #AA, #A0, #AA, #AE, #A9
                DB #20, #AA, #AE, #AD, #E2, #A8, #AD, #A5
                DB #AD, #E2, #20, #E5, #AE, #E2, #A8, #E2
                DB #A5, #20, #AF, #AB, #EB, #E2, #EC, #20
                DB #3F, #0D, #2A, #9F, #20, #AF, #A5, #E0
                DB #A5, #A4, #E3, #AC, #A0, #AB, #0D, #03
.ArrivalTexData EQU $+1                                                         ; сообщение о завершении плавания и имени континента прибытия
                DB #00, #8F, #AE, #E1, #AB, #A5, #20, #A4
                DB #AE, #AB, #A3, #AE, #A3, #AE, #20, #A8
                DB #20, #E3, #E2, #AE, #AC, #A8, #E2, #A5
                DB #AB, #EC, #AD, #AE, #A3, #AE, #20, #AF
                DB #AB, #A0, #A2, #A0, #AD, #A8, #EF, #0D
                DB #2A, #A2, #EB, #20, #AD, #A0, #AA, #AE
                DB #AD, #A5, #E6, #20, #A4, #AE, #E1, #E2
                DB #A8, #A3, #AB, #A8, #20, #A1, #A5, #E0
                DB #A5, #A3, #AE, #A2, #0D, #2A, #0D, #00
.LandNameBuffer EQU $+6                                                         ; одиннадцатибайтный буфер имени континента в сообщении о прибытии
                DB #0E, #35, #B4, #0D, #2A, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00
.MenuCount      DB #01                                                          ; число доступных континентов в меню
                DB #0A, #90, #ED, #BF, #32, #96, #01, #12
                DB #1F, #13, #01, #13, #1F, #14, #01, #14
                DB #1F, #15, #01, #15, #1F, #16, #01, #16
                DB #1F, #17, #6F, #76, #65, #72, #6C, #61
                DB #79

                assert $ = #B462
                endmodule
                endmodule
