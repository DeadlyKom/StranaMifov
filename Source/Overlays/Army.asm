; оверлей 08 из OVR1
; исходный файл каталога 48, смещение #241F
                module Overlay
                module Army
                org #B200

; -----------------------------------------
; просмотр и выбор отрядов армии
; Обходит пять трёхбайтовых записей #6A1E. Получает описатель типа существа, печатает название,
; численность, характеристики, настроение и ограничения. Меню перемещает выделение между отрядами,
; показывает сведения выбранного типа и возвращается к игре по выходу.
; In:
;   текущее состояние героя, армии и объекта в ядре
; Out:
;   состояние обновлено выбранной ветвью либо сохранено при отказе
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; -----------------------------------------
Entry           CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                CALL Engine.CheckCalls                                          ; проверить неизменность трёх инструкций CALL #6B8D
                LD BC, #0000
                LD DE, #1820
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD A, (State.Army)
                OR A
                JR NZ, .DrawArmyWindow                                          ; переход, если в армии имеется хотя бы один отряд

                LD BC, #0601
                LD DE, #041C
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #08
                LD DE, Overlay.Army.Entry.NoArmyText                            ; сообщение об отсутствии армии героя
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .CloseArmy

.DrawArmyWindow LD BC, #0000
                LD DE, #021E
                XOR A
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #01
                LD DE, Overlay.Army.Entry.ArmyTitle                             ; заголовок окна армии и пункт закрытия
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, #01
                LD (Entry.RowIndex), A
                LD IY, State.Army

                ; для каждого отряда печатаются имя, количество, параметры боя, настроение и
                ; особенности передвижения
.UnitRow        LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                OR A
                JP Z, .ArmyFooter                                               ; переход, если достигнут конец заполненной части армии

                LD A, (Entry.RowIndex)
                LD B, A
                LD C, #00
                LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                CALL Engine.SetUnitPicture                                      ; создать четырёхкадровый экранный объект
                LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD C, (IY + FTroop.Count.Low)                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD B, (IY + FTroop.Count.High)                                  ; +#02, старший байт, беззнаковая численность little-endian
                LD (Entry.UnitCount), BC
                CALL Engine.FormatUnitName                                      ; сформировать имя типа отряда со специальным окончанием
                LD A, (Entry.RowIndex)
                SLA A
                SLA A
                LD B, A
                LD DE, Overlay.Army.Entry.UnitCountText                         ; формат названия и количества отряда в списке
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                CALL Engine.ControlLimit                                        ; рассчитать численный предел типа отряда из поля героя и таблицы
                LD L, C
                LD H, B
                LD E, (IY + FTroop.Count.Low)                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD D, (IY + FTroop.Count.High)                                  ; +#02, старший байт, беззнаковая численность little-endian
                OR A
                SBC HL, DE
                JR NC, .ArmyMood                                                ; переход, если численность отряда не превышает предел управления героя

                LD DE, Overlay.Army.Entry.Uncontrolled                          ; предупреждение об отряде, вышедшем из-под контроля
                LD A, (Entry.RowIndex)
                SLA A
                SLA A
                LD B, A
                INC B
                LD C, #07
                LD DE, Overlay.Army.Entry.Uncontrolled                          ; предупреждение об отряде, вышедшем из-под контроля
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                JR .RangedInfo

.ArmyMood       LD A, (State.Cult)
                LD C, A
                LD B, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                LD HL, State.Army
                LD DE, #0003
                CALL Engine.ArmyMood                                            ; оценить совместимость типа отряда с составом армии
                LD HL, Overlay.Army.Entry.MoodNames - 2                         ; база поиска перед нулевым разделителем и первой строкой названий настроения
                ADD A, #03
                LD B, A
.FindMoodText   INC HL
                LD A, (HL)
                OR A
                JR NZ, .FindMoodText                                            ; переход, если ещё не найден конец очередной строки настроения

                DJNZ .FindMoodText

                INC HL
                LD (Entry.MoodText), HL
                LD A, (Entry.RowIndex)
                SLA A
                SLA A
                INC A
                LD B, A
                LD C, #07
                LD DE, Overlay.Army.Entry.MoodTextData                          ; формат сообщения о настроении отряда
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
.RangedInfo     LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD C, (IX + FSoldier.Actions)                                   ; +#0F, исходное число действий на раунд
                LD B, #00
                LD (Entry.Actions), BC
                LD A, (Entry.RowIndex)
                SLA A
                SLA A
                ADD A, #02
                LD B, A
                LD C, #07
                LD DE, Overlay.Army.Entry.ActionsText                           ; формат числа ходов отряда на поле битвы
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (IX + FSoldier.MoveFlags)
                AND #07
                JR Z, .NextUnit                                                 ; переход, если у типа нет отдельного дальнего или воздушного действия

                CP #01
                JR NZ, .CheckShotKind                                           ; переход, если младшие биты способностей задают не режим магического действия 1

                LD DE, Overlay.Army.Entry.MagicText                             ; формат числа магических действий отряда
                JR .MovementInfo

.CheckShotKind  CP #02
                JR NZ, .CheckAirKind                                            ; переход, если младшие биты способностей задают не режим стрельбы 2

                LD DE, Overlay.Army.Entry.RangedText                            ; формат числа выстрелов отряда
                JR .MovementInfo

.CheckAirKind   CP #04
                JR NZ, .CheckRareKind                                           ; переход, если младшие биты способностей задают не режим полёта 4

                LD DE, Overlay.Army.Entry.FlyingText                            ; сообщение о способности летать
                JR .MovementInfo

.CheckRareKind  CP #05
                JR NZ, .NormalKind                                              ; переход, если младшие биты способностей задают не совмещённый режим 5

                LD DE, Overlay.Army.Entry.MagicFlyText                          ; формат числа магических действий летающего отряда
                JR .MovementInfo

.NormalKind     LD DE, Overlay.Army.Entry.ShotFlyText                           ; формат числа выстрелов летающего отряда
.MovementInfo   LD C, (IX + FSoldier.ActionStock)                               ; +#10, запас расходуемого дальнего действия
                LD B, #00
                LD (Entry.ShotStock), BC
                LD (Entry.OtherStock), BC
                LD (Entry.MagicStock), BC
                LD (Entry.MixedStock), BC
                LD A, (Entry.RowIndex)
                SLA A
                SLA A
                ADD A, #03
                LD B, A
                LD C, #07
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
.NextUnit       INC IY
                INC IY
                INC IY
                LD A, (Entry.RowIndex)
                INC A
                LD (Entry.RowIndex), A
                CP #06
                JP NZ, .UnitRow                                                 ; переход, если показаны ещё не все пять отрядов армии

.ArmyFooter     LD A, (Entry.RowIndex)
                LD (Entry.MenuCount), A
                LD BC, #0000
                LD DE, #0420
                LD A, #41
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #0201
                LD DE, #011E
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD A, #04
                LD (Entry.RowIndex), A
                LD IY, State.Army
.UnitCost       LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                OR A
                JR Z, .SelectUnit                                               ; переход, если достигнут конец заполненной части армии

                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD C, (IX + FSoldier.SpawnClass)                                ; +#12, категория 1..4 при выборе начального типа
                LD B, #00
                LD HL, Overlay.Army.Entry.ClassAttrs                            ; атрибуты классов существ для окна армии
                ADD HL, BC
                LD DE, #041C
                LD A, (Entry.RowIndex)
                LD B, A
                LD C, #04
                LD A, (HL)
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                INC IY
                INC IY
                INC IY
                LD A, (Entry.RowIndex)
                ADD A, #04
                LD (Entry.RowIndex), A
                CP #18
                JR NZ, .UnitCost                                                ; переход, если остаются строки отрядов для окраски

                ; пункт меню определяет запись FTroop, подробности затем берутся из описателя
                ; FSoldier
.SelectUnit     CALL Engine.StartView                                           ; включить обработку объектов в прерывании
                LD IX, Entry.MenuCount
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #01
                JP Z, .CloseArmy                                                ; переход, если выбран выход из просмотра армии

                LD IY, State.Army - 2 * FTroop                                  ; смещённая база армии, пункт меню 2 приводит к первой записи через два шага FTroop
.FindChosenUnit INC IY
                INC IY
                INC IY
                DEC A
                JR NZ, .FindChosenUnit                                          ; переход, если указатель ещё не дошёл до выбранной записи отряда

                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                LD BC, #0101
                CALL Engine.SetUnitPicture                                      ; создать четырёхкадровый экранный объект
                LD HL, Overlay.Army.Entry.ClassAttrs                            ; атрибуты классов существ для окна армии
                LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD C, (IX + FSoldier.SpawnClass)                                ; +#12, категория 1..4 при выборе начального типа
                LD B, #00
                ADD HL, BC
                LD A, (HL)
                LD BC, #0303
                LD DE, #101A
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #050D
                LD DE, Overlay.Army.Entry.InfoTopBorder                         ; верхняя строка рамки подробной информации об отряде
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #070D
                LD DE, Overlay.Army.Entry.InfoBottom                            ; нижняя строка рамки подробной информации об отряде
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #060D
                LD A, #BA
                CALL Engine.DrawGlyphEI                                         ; вывести символ с обычной процедурой переключения банка
                LD BC, #0624
                LD A, #BA
                CALL Engine.DrawGlyphEI                                         ; вывести символ с обычной процедурой переключения банка
                LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD (Entry.UnitInfoPtr), IX
                LD DE, Overlay.Army.Entry.InfoTitle                             ; формат заголовка подробной информации об отряде
                LD B, #06
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, #0B
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD B, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                LD HL, Runtime.UnitTextIndex                                    ; база перед разделителем описаний типов существ в DATA2
.FindUnitText   INC HL
                LD A, (HL)
                CP #B1
                JR NZ, .FindUnitText                                            ; переход, если разделитель описания нужного типа ещё не найден

                DJNZ .FindUnitText

                INC HL
                LD BC, #0805

                ; разделитель #B1 завершает описание типа, перевод строки изменяет координаты вывода
.ReadTextChar   LD A, (HL)
                CP #B1
                JR Z, .WaitUnitInfo                                             ; переход, если описание типа завершено разделителем

                CP #0D
                JR NZ, .DrawTextChar                                            ; переход, если прочитан обычный символ описания, а не перевод строки

                INC B
                LD C, #05
                JR .NextTextChar

.DrawTextChar   CALL Engine.DrawGlyphEI                                         ; вывести символ с обычной процедурой переключения банка
                INC C
.NextTextChar   INC HL
                JR .ReadTextChar

.WaitUnitInfo   CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                CALL Engine.StartView                                           ; включить обработку объектов в прерывании
                LD B, #FF
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP Entry

.CloseArmy      CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                LD BC, #0000
                LD DE, #1820
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                CALL Engine.RefreshPanels                                       ; перерисовать верхнюю строку и боковую панель игры
                RET

.InfoTopBorder  EQU $                                                           ; верхняя строка рамки подробной информации об отряде
                DB #C9, #CD, #CD, #CD, #CD, #CD, #CD, #CD
                DB #CD, #CD, #CD, #CD, #CD, #CD, #CD, #CD
                DB #CD, #CD, #CD, #CD, #CD, #CD, #CD, #BB
.InfoBottom     EQU $+1                                                         ; нижняя строка рамки подробной информации об отряде
                DB #00, #C8, #CD, #CD, #CD, #CD, #CD, #CD
                DB #CD, #CD, #CD, #CD, #CD, #CD, #CD, #CD
                DB #CD, #CD, #CD, #CD, #CD, #CD, #CD, #CD
.InfoTitle      EQU $+2                                                         ; формат заголовка подробной информации об отряде
                DB #BC, #00, #11, #0D, #18, #0E
.UnitInfoPtr    DW #0000                                                        ; адрес текста описания выбранного типа
                DB #0D, #2A, #00
.RowIndex       DB #00                                                          ; номер выводимого отряда либо строка окраски
.NoArmyText     EQU $                                                           ; сообщение об отсутствии армии героя
                DB #93, #20, #A2, #A0, #E1, #20, #AD, #A5
                DB #E2, #20, #A0, #E0, #AC, #A8, #A8, #20
                DB #21, #0D, #2A, #9D, #E2, #AE, #20, #A4
                DB #AE, #A2, #AE, #AB, #EC, #AD, #AE, #20
                DB #AE, #AF, #A0, #E1, #AD, #A0, #EF, #20
                DB #E1, #A8, #E2, #E3, #A0, #E6, #A8, #EF
.ArmyTitle      EQU $+5                                                         ; заголовок окна армии и пункт закрытия
                DB #20, #21, #0D, #2A, #00, #82, #A0, #E8
                DB #A0, #20, #A0, #E0, #AC, #A8, #EF, #2E
                DB #0D, #2A, #9F, #20, #AD, #A0, #E1, #AC
                DB #AE, #E2, #E0, #A5, #AB, #E1, #EF, #0D
                DB #1A, #00
.MenuCount      DB #01                                                          ; число доступных пунктов выбора
                DB #28, #08, #ED, #BE, #C8, #12, #12, #02
                DB #1F, #03, #05, #04, #1F, #05, #05, #08
                DB #1F, #09, #05, #0C, #1F, #0D, #05, #10
.MoodNames      EQU $+7                                                         ; пять нуль-терминированных названий настроения от худшего к лучшему
                DB #1F, #11, #05, #14, #1F, #15, #00, #95
                DB #E3, #A6, #A5, #20, #AD, #A5, #20, #A1
                DB #EB, #A2, #A0, #A5, #E2, #00, #8F, #AB
                DB #AE, #E5, #AE, #A5, #00, #8D, #AE, #E0
                DB #AC, #A0, #AB, #EC, #AD, #AE, #A5, #00
                DB #95, #AE, #E0, #AE, #E8, #A5, #A5, #00
                DB #82, #A5, #AB, #A8, #AA, #AE, #AB, #A5
.UnitCountText  EQU $+5                                                         ; формат названия и количества отряда в списке
                DB #AF, #AD, #AE, #A5, #00, #11, #06, #24
                DB #0F
.UnitCount      DW #0000                                                        ; численность отряда для текста
.Uncontrolled   EQU $+7                                                         ; предупреждение об отряде, вышедшем из-под контроля
                DB #00, #0E, #E9, #7E, #0D, #2A, #00, #8E
                DB #AD, #A8, #20, #A2, #EB, #E8, #AB, #A8
                DB #20, #A8, #A7, #20, #AF, #AE, #A4, #20
                DB #A2, #A0, #E8, #A5, #A3, #AE, #20, #AA
                DB #AE, #AD, #E2, #E0, #AE, #AB, #EF, #20
.MoodTextData   EQU $+2                                                         ; формат сообщения о настроении отряда
                DB #21, #00, #8D, #A0, #E1, #E2, #E0, #AE
                DB #A5, #AD, #A8, #A5, #20, #3A, #20, #0E
.MoodText       DW #0000                                                        ; адрес подписи настроения
.ActionsText    EQU $+1                                                         ; формат числа ходов отряда на поле битвы
                DB #00, #8D, #A0, #20, #AF, #AE, #AB, #A5
                DB #20, #A1, #A8, #E2, #A2, #EB, #20, #E5
                DB #AE, #A4, #EF, #E2, #20, #0F
.Actions        DW #0000                                                        ; число действий для текста
.ClassAttrs     EQU $+6                                                         ; атрибуты классов существ для окна армии
                DB #00, #E0, #A0, #A7, #2E, #00, #05, #42
.RangedText     EQU $+3                                                         ; формат числа выстрелов отряда
                DB #44, #46, #47, #8C, #AE, #A3, #E3, #E2
                DB #20, #E1, #E2, #E0, #A5, #AB, #EF, #E2
                DB #EC, #20, #0F
.ShotStock      DW #0000                                                        ; запас дальнего действия для текста
.ShotFlyText    EQU $+6                                                         ; формат числа выстрелов летающего отряда
                DB #00, #E0, #A0, #A7, #2E, #00, #8C, #AE
                DB #A3, #E3, #E2, #20, #E1, #E2, #E0, #A5
                DB #AB, #EF, #E2, #EC, #20, #0F
.OtherStock     DW #0000                                                        ; запас дальнего действия для обычной ветви текста
                DB #00, #E0, #A0, #A7, #20, #A8, #20, #AB
.MagicText      EQU $+7                                                         ; формат числа магических действий отряда
                DB #A5, #E2, #A0, #E2, #EC, #2E, #00, #8C
                DB #AE, #A3, #E3, #E2, #20, #AA, #AE, #AB
                DB #A4, #AE, #A2, #A0, #E2, #EC, #20, #0F
.MagicStock     DW #0000                                                        ; запас магического действия для текста
.MagicFlyText   EQU $+6                                                         ; формат числа магических действий летающего отряда
                DB #00, #E0, #A0, #A7, #2E, #00, #8C, #AE
                DB #A3, #E3, #E2, #20, #AA, #AE, #AB, #A4
                DB #AE, #A2, #A0, #E2, #EC, #20, #0F
.MixedStock     DW #0000                                                        ; запас совмещённого действия для текста
                DB #00, #E0, #A0, #A7, #20, #A8, #20, #AB
.FlyingText     EQU $+7                                                         ; сообщение о способности летать
                DB #A5, #E2, #A0, #E2, #EC, #2E, #00, #91
                DB #AF, #AE, #E1, #AE, #A1, #AD, #EB, #20
                DB #AB, #A5, #E2, #A0, #E2, #EC, #2E, #00
                DB #6F, #76, #65, #72, #6C, #61, #79

                assert $ = #B652
                endmodule
                endmodule
