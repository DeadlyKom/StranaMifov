; оверлей 21 из OVR2
; исходный файл каталога 49, смещение #1B8B
                module Overlay
                module Castle
                org #B200

; -----------------------------------------
; управление гарнизоном собственного замка и его защитой
; Указатель имени текущего замка берёт #867B. Сравнивает его с #6AAC и проверяет #6AAA/#6AAB,
; определяя специальный режим защиты. Обычное меню позволяет оставить отряд, забрать отряд,
; покинуть замок и изменить 15-байтовое имя. Во время нападения заменяет подписи на
; исключение/взятие воинов и начало битвы, при возможности добавляет помощь ближайшего города.
; Пять трёхбайтовых записей гарнизона находятся по имени+17. Ветви переноса ищут пустой либо
; совпадающий ID, запрашивают количество ReadUnitCount, складывают/вычитают 16-битные числа и
; уплотняют
; массив #807E. Ветвь защиты создаёт бой через банк 3, #D255 с A=#88, армией #6AAE. Исход боя
; меняет владельца/гарнизон, награждение, магические затраты и возможность вернуться к сохранённой
; армии.
; In:
;   #867B — имя замка, #6A1E — армия героя, #6AAA..#6AAC — нападение
; Out:
;   возврат после выхода из замка или завершения защиты
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом меню, калькулятора, числового ввода и
;   возможного вызова боевого модуля #D255
; Note:
;   гарнизон, имя замка, армия, владельцы, численные поля героя, экран, банки
; Особенность оригинала:
;   при поражении возврат списывает State.ReturnCost из State.Mana
;   при победе проверяет запас магии, но не сохраняет уменьшенное значение
; -----------------------------------------
Entry           LD HL, (State.CastleName)
                LD (ReadUnitCount.CastleName), HL
                LD A, #04
                LD (ReadUnitCount.MenuCount), A
.CheckDefense   XOR A
                LD (ReadUnitCount.DefenseMode), A
                LD A, (State.Attacker)
                OR A
                JR Z, .DrawCastle                                               ; переход, если сейчас нет нападения на замок

                LD BC, (State.CastleName)
                DEC BC
                DEC BC
                DEC BC
                LD HL, (State.AttackCastle)
                OR A
                SBC HL, BC
                JR NZ, .DrawCastle                                              ; переход, если нападающие угрожают другому замку

                LD A, (State.AttackDays)
                CP #05
                JR NC, .DrawCastle                                              ; переход, если до нападения ещё не наступило пятидневное окно защиты

                LD A, #01
                LD (ReadUnitCount.DefenseMode), A
                LD A, #05
                LD (ReadUnitCount.MenuCount), A
.DrawCastle     CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                LD A, #01
                CALL Engine.ShowScene                                           ; показать одну из девяти упакованных сцен BL1/BL2 с восстановлением банка и основных регистров
.MainMenu       XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD A, #47
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #0F01
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
                LD B, #10
                LD DE, Overlay.Castle.ReadUnitCount.CastleNameText              ; формат имени текущего замка
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD DE, Overlay.Castle.ReadUnitCount.PeaceActions                ; пункты помещения отрядов в замок, забора и выхода
                LD A, (ReadUnitCount.DefenseMode)
                OR A
                LD A, #04
                JR Z, .ChooseAction                                             ; переход, если замок открыт в обычном режиме без защиты от нападения

                LD DE, Overlay.Castle.ReadUnitCount.DefenseActions              ; пункты исключения, вызова отрядов и начала боя
                LD A, (ReadUnitCount.MenuCount)
                CP #04
                JR Z, .ChooseAction                                             ; переход, если городской отряд уже запрашивался и пункт помощи убран

                LD B, #15
                LD DE, Overlay.Castle.ReadUnitCount.CallCityText                ; дополнительный пункт призыва отряда из города
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD DE, Overlay.Castle.ReadUnitCount.DefenseActions              ; пункты исключения, вызова отрядов и начала боя
.ChooseAction   LD B, #12
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IX, ReadUnitCount.MenuCount
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #05
                JP NZ, .RenameChoice                                            ; переход, если выбран не пункт помощи ближайшего города

                LD A, #04
                LD (ReadUnitCount.MenuCount), A
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (State.CastleName)
                LD A, (State.Continent)
                LD E, A
                LD D, #02
                LD C, (IX + FCastle.X - FCastle.Name)                           ; -#02, столбец карты
                LD B, (IX + FCastle.Y - FCastle.Name)                           ; -#01, строка карты
                LD HL, #0000
                LD A, #1A
                PUSH BC
                CALL Engine.NearestObject                                       ; найти ближайшую активную запись выбранной группы
                POP BC
                LD E, (IX + FTown.X)                                            ; +#01, столбец карты
                LD D, (IX + FTown.Y)                                            ; +#02, строка карты
                CALL Engine.FloorDistance                                       ; вычислить целую часть евклидова расстояния
                LD A, (State.AttackDays)
                INC A
                LD HL, #FFFB
                LD DE, #0005
.TravelBudget   ADD HL, DE
                DEC A
                JR NZ, .TravelBudget                                            ; переход, если учтены ещё не все оставшиеся дни на прибытие помощи

                OR A
                SBC HL, BC
                JR NC, .CityGarrison                                            ; переход, если городской отряд успевает прибыть к началу осады

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD B, #11
                LD DE, Overlay.Castle.PlaceAuxTroops.CityFarText                ; сообщение о слишком далёком городе для прибытия помощи
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .MainMenu

.CityGarrison   LD (PlaceAuxTroops.HelpTown), IX
                LD A, (IX + FTown.Army + FTroop.ID)                             ; +#11, до трёх отрядов FTroop
                OR A
                JR NZ, .ListCityUnits                                           ; переход, если в ближайшем городе есть хотя бы один отряд

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD B, #12
                LD DE, Overlay.Castle.PlaceAuxTroops.CityEmptyText              ; сообщение об отсутствии солдат в соседнем городе
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .MainMenu

.ListCityUnits  LD A, #45
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD B, #10
                LD DE, Overlay.Castle.PlaceAuxTroops.CityArmyText               ; заголовок армии соседнего города
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #15
                LD DE, Overlay.Castle.PlaceAuxTroops.ChooseCityText             ; вопрос о вызываемом отряде и пункт завершения выбора
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #1202
                LD (Entry.CityListXY), BC
                LD A, #01
                LD (PlaceAuxTroops.CityMenuCount), A
                LD IX, (PlaceAuxTroops.HelpTown)
                LD B, #03
.CityUnitRow    LD A, (IX + FTown.Army + FTroop.ID)                             ; +#11, до трёх отрядов FTroop
                OR A
                JR Z, .SelectCityUnit                                           ; переход, если закончились непустые отряды городского гарнизона

                PUSH BC
                LD C, (IX + FTown.Army + FTroop.Count.Low)                      ; +#12, до трёх отрядов FTroop
                LD B, (IX + FTown.Army + FTroop.Count.High)                     ; +#13, до трёх отрядов FTroop
                LD (PlaceAuxTroops.CityCount), BC
                CALL Engine.FormatUnitName                                      ; сформировать имя типа отряда со специальным окончанием
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD BC, #0000
.CityListXY     EQU $ - 2                                                       ; операнд координат вывода списка городской помощи
.CityListRow    EQU $ - 1                                                       ; строка вывода списка городской помощи
                LD DE, Overlay.Castle.PlaceAuxTroops.CityUnitText               ; формат строки городского отряда в списке выбора
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (Entry.CityListRow)
                INC A
                LD (Entry.CityListRow), A
                LD A, (PlaceAuxTroops.CityMenuCount)
                INC A
                LD (PlaceAuxTroops.CityMenuCount), A
                POP BC
                INC IX
                INC IX
                INC IX
                DJNZ .CityUnitRow

.SelectCityUnit LD IX, PlaceAuxTroops.CityMenuCount
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #01
                JP Z, .MainMenu                                                 ; переход, если игрок отменил выбор городского отряда

                DEC A
                LD (Entry.CityChoice), A
                DEC A
                LD IX, (PlaceAuxTroops.HelpTown)
                LD C, A
                ADD A, A
                ADD A, C
                LD C, A
                LD B, #00
                ADD IX, BC
                LD IY, (State.CastleName)
                LD B, #05

                ; при помощи города ищется подходящий тип в армии защиты, перенос ограничен
                ; тремя городскими записями
.FindDefendSlot LD A, (IY + FCastle.Army - FCastle.Name + FTroop.ID)            ; +#11, пять записей гарнизона FTroop
                OR A
                JR Z, .ReadCityCount                                            ; переход, если в гарнизоне найдена свободная запись

                CP (IX + FTown.Army + FTroop.ID)                                ; +#11, до трёх отрядов FTroop
                JR Z, .ReadCityCount                                            ; переход, если в гарнизоне найден такой же тип существ

                INC IY
                INC IY
                INC IY
                DJNZ .FindDefendSlot

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #1208
                LD DE, Overlay.Castle.ReadUnitCount.FortFullText                ; сообщение об отсутствии свободного места в замке
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .ListCityUnits

.ReadCityCount  LD A, #00
.CityChoice     EQU $ - 1                                                       ; операнд выбранного городского отряда
                LD L, (IX + FTown.Army + FTroop.Count.Low)                      ; +#12, до трёх отрядов FTroop
                LD H, (IX + FTown.Army + FTroop.Count.High)                     ; +#13, до трёх отрядов FTroop
                CALL ReadUnitCount
                JP Z, .ListCityUnits                                            ; переход, если перенос из города отменён

                LD A, (IY + FCastle.Army - FCastle.Name + FTroop.ID)            ; +#11, пять записей гарнизона FTroop
                OR A
                JR NZ, .AddCityUnits                                            ; переход, если в гарнизоне уже есть отряд выбранного типа

                LD A, (IX + FTown.Army + FTroop.ID)                             ; +#11, до трёх отрядов FTroop
                CALL Engine.ClearTwoFlags                                       ; обнулить два связанных байта таблиц
.AddCityUnits   LD A, (IX + FTown.Army + FTroop.ID)                             ; +#11, до трёх отрядов FTroop
                LD (IY + FCastle.Army - FCastle.Name + FTroop.ID), A            ; +#11, пять записей гарнизона FTroop
                LD L, (IY + FCastle.Army - FCastle.Name + FTroop.Count.Low)     ; +#12, пять записей гарнизона FTroop
                LD H, (IY + FCastle.Army - FCastle.Name + FTroop.Count.High)    ; +#13, пять записей гарнизона FTroop
                ADD HL, BC
                LD (IY + FCastle.Army - FCastle.Name + FTroop.Count.Low), L     ; +#12, пять записей гарнизона FTroop
                LD (IY + FCastle.Army - FCastle.Name + FTroop.Count.High), H    ; +#13, пять записей гарнизона FTroop
                LD L, (IX + FTown.Army + FTroop.Count.Low)                      ; +#12, до трёх отрядов FTroop
                LD H, (IX + FTown.Army + FTroop.Count.High)                     ; +#13, до трёх отрядов FTroop
                OR A
                SBC HL, BC
                JR NZ, .SubtractCity                                            ; переход, если после передачи в городском отряде остаются существа

                LD (IX + FTown.Army + FTroop.ID), L                             ; +#11, до трёх отрядов FTroop
.SubtractCity   LD (IX + FTown.Army + FTroop.Count.Low), L                      ; +#12, до трёх отрядов FTroop
                LD (IX + FTown.Army + FTroop.Count.High), H
                LD HL, (PlaceAuxTroops.HelpTown)
                LD DE, #0011
                ADD HL, DE
                LD B, #03
                CALL Engine.CompactArmy                                         ; сжать список трёхбайтных записей армии
                JP .ListCityUnits

.RenameChoice   CP #04
                JP NZ, .LeaveChoice                                             ; переход, если выбран не пункт переименования замка

                LD BC, #1001
                LD DE, #011E
                LD A, #45
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #1601
                LD DE, #011E
                LD A, #45
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #1602
                LD DE, Overlay.Castle.PlaceAuxTroops.RenameText                 ; приглашение ввести новое имя замка
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD HL, Overlay.Castle.PlaceAuxTroops.NameBuffer                 ; пятнадцать байтов ввода нового имени замка
                LD DE, Overlay.Castle.PlaceAuxTroops.NameBuffer + 1             ; следующий байт буфера имени замка для размножения нуля
                LD BC, #000E
                LD (HL), #00
                LDIR
                LD A, (State.ViewFlags)
                RES TEXT_DIGIT_BIT, A                                           ; флаг, ввод ограничен цифрами и служебными кодами, при 0 разрешён обычный текст
                LD (State.ViewFlags), A
                LD IX, Overlay.Castle.PlaceAuxTroops.NameBuffer                 ; пятнадцать байтов ввода нового имени замка
                LD BC, #1619
                LD A, #0F
                CALL Engine.EditText                                            ; редактировать строку с анимированным курсором
                CP #0E
                JP Z, .MainMenu                                                 ; переход, если ввод нового имени отменён кодом #0E

                LD DE, (State.CastleName)
                LD HL, Overlay.Castle.PlaceAuxTroops.NameBuffer                 ; пятнадцать байтов ввода нового имени замка
                LD BC, #000F
                LDIR
                JP .MainMenu

.LeaveChoice    CP #01
                JP NZ, .TakeChoice                                              ; переход, если выбран не перенос отряда героя в гарнизон

                LD A, (State.Army)
                OR A
                JR NZ, .ListHeroUnits                                           ; переход, если в армии героя есть отряд для передачи

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #120C
                LD DE, Overlay.Castle.ReadUnitCount.NoArmyText                  ; сообщение об отсутствии армии героя
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .MainMenu

.ListHeroUnits  LD A, #47
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD B, #0F
                LD DE, Overlay.Castle.ReadUnitCount.LeaveUnitText               ; вопрос о помещении отряда героя в замок
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IY, State.Army
                CALL DrawUnitList
                LD IX, ReadUnitCount.UnitMenuCount
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #01
                JP Z, .MainMenu                                                 ; переход, если игрок отменил выбор отряда героя

                LD IX, State.Army - FTroop                                      ; смещённая база выбора отряда героя, первый шаг приводит к началу State.Army
                DEC A
                LD (Entry.HeroChoice), A
.FindHeroUnit   INC IX
                INC IX
                INC IX
                DEC A
                JR NZ, .FindHeroUnit                                            ; переход, если указатель ещё не дошёл до выбранного отряда героя

                LD IY, (State.CastleName)
                LD DE, #0011
                ADD IY, DE
                LD B, #05

                ; оставляемый отряд объединяется с тем же типом гарнизона либо занимает
                ; свободный слот
.FindCastleSlot LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                OR A
                JR Z, .ReadLeaveCount                                           ; переход, если в гарнизоне найдена свободная запись

                CP (IX + FTroop.ID)                                             ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                JR Z, .ReadLeaveCount                                           ; переход, если в гарнизоне найден такой же тип существ

                INC IY
                INC IY
                INC IY
                DJNZ .FindCastleSlot

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #1208
                LD DE, Overlay.Castle.ReadUnitCount.FortFullText                ; сообщение об отсутствии свободного места в замке
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .ListHeroUnits

.ReadLeaveCount LD A, #00
.HeroChoice     EQU $ - 1                                                       ; операнд выбранного отряда героя
                LD L, (IX + FTroop.Count.Low)                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD H, (IX + FTroop.Count.High)                                  ; +#02, старший байт, беззнаковая численность little-endian
                CALL ReadUnitCount
                JR Z, .ListHeroUnits                                            ; переход, если оставление отряда отменено

                LD L, (IY + FTroop.Count.Low)                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD H, (IY + FTroop.Count.High)                                  ; +#02, старший байт, беззнаковая численность little-endian
                ADD HL, BC
                LD (IY + FTroop.Count.Low), L                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD (IY + FTroop.Count.High), H                                  ; +#02, старший байт, беззнаковая численность little-endian
                LD A, (IX + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                LD (IY + FTroop.ID), A                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                LD L, (IX + FTroop.Count.Low)                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD H, (IX + FTroop.Count.High)                                  ; +#02, старший байт, беззнаковая численность little-endian
                OR A
                SBC HL, BC
                LD (IX + FTroop.Count.Low), L                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD (IX + FTroop.Count.High), H                                  ; +#02, старший байт, беззнаковая численность little-endian
                LD A, H
                OR L
                JR NZ, .CompactHero                                             ; переход, если после передачи в армии героя остаются существа этого типа

                LD (IX + FTroop.ID), #00                                        ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
.CompactHero    LD HL, State.Army
                LD B, #05
                CALL Engine.CompactArmy                                         ; сжать список трёхбайтных записей армии
                JP .ListHeroUnits

.TakeChoice     CP #02
                JP NZ, .LeaveCastle                                             ; переход, если выбран не перенос отряда гарнизона к герою

                LD IX, (State.CastleName)
                LD A, (IX + FCastle.Army - FCastle.Name + FTroop.ID)            ; +#11, пять записей гарнизона FTroop
                OR A
                JR NZ, .ListFortUnits                                           ; переход, если гарнизон замка содержит хотя бы один отряд

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #1210
                LD DE, Overlay.Castle.ReadUnitCount.FortEmptyText               ; сообщение об отсутствии армии в замке
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .MainMenu

.ListFortUnits  LD A, #47
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD B, #0F
                LD DE, Overlay.Castle.ReadUnitCount.TakeUnitText                ; вопрос о заборе отряда из замка
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IY, (State.CastleName)
                LD DE, #0011
                ADD IY, DE
                CALL DrawUnitList
                LD IX, ReadUnitCount.UnitMenuCount
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #01
                JP Z, .MainMenu                                                 ; переход, если игрок отменил выбор отряда гарнизона

                DEC A
                LD (Entry.FortChoice), A
                LD IX, (State.CastleName)
                LD DE, #000E
                ADD IX, DE
.FindFortUnit   INC IX
                INC IX
                INC IX
                DEC A
                JR NZ, .FindFortUnit                                            ; переход, если указатель ещё не дошёл до выбранного отряда гарнизона

                LD IY, State.Army
                LD B, #05

                ; забираемый отряд должен поместиться среди пяти типов армии героя
.FindHeroSlot   LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                OR A
                JR Z, .ReadTakeCount                                            ; переход, если в армии героя найдена свободная запись

                CP (IX + FTroop.ID)                                             ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                JR Z, .ReadTakeCount                                            ; переход, если в армии героя найден такой же тип существ

                INC IY
                INC IY
                INC IY
                DJNZ .FindHeroSlot

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #1204
                LD DE, Engine.NeedMoreMoney.ArmyFullText                        ; сообщение о заполнении всех пяти типов армии
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .ListFortUnits

.ReadTakeCount  LD A, #00
.FortChoice     EQU $ - 1                                                       ; операнд выбранного отряда гарнизона
                LD L, (IX + FTroop.Count.Low)                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD H, (IX + FTroop.Count.High)                                  ; +#02, старший байт, беззнаковая численность little-endian
                CALL ReadUnitCount
                JR Z, .ListFortUnits                                            ; переход, если взятие отряда отменено

                LD L, (IY + FTroop.Count.Low)                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD H, (IY + FTroop.Count.High)                                  ; +#02, старший байт, беззнаковая численность little-endian
                LD A, H
                OR L
                JR NZ, .TakeUnits                                               ; переход, если у героя уже есть отряд выбранного типа

                LD A, (IX + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                CALL Engine.ClearTwoFlags                                       ; обнулить два связанных байта таблиц
.TakeUnits      ADD HL, BC
                LD (IY + FTroop.Count.Low), L                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD (IY + FTroop.Count.High), H                                  ; +#02, старший байт, беззнаковая численность little-endian
                LD A, (IX + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                LD (IY + FTroop.ID), A                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                LD L, (IX + FTroop.Count.Low)                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD H, (IX + FTroop.Count.High)                                  ; +#02, старший байт, беззнаковая численность little-endian
                OR A
                SBC HL, BC
                LD (IX + FTroop.Count.Low), L                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD (IX + FTroop.Count.High), H                                  ; +#02, старший байт, беззнаковая численность little-endian
                LD A, H
                OR L
                JR NZ, .CompactCastle                                           ; переход, если после передачи в гарнизоне остаются существа этого типа

                LD (IX + FTroop.ID), #00                                        ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
.CompactCastle  LD HL, (State.CastleName)
                LD DE, #0011
                ADD HL, DE
                LD B, #05
                CALL Engine.CompactArmy                                         ; сжать список трёхбайтных записей армии
                JP .ListFortUnits

.LeaveCastle    LD A, (ReadUnitCount.DefenseMode)
                OR A
                JR NZ, .SetEnemyMana                                            ; переход, если выход из меню в режиме защиты должен начать бой

                CALL Engine.MoveToTarget                                        ; преобразовать направление к цели в команду движения героя
                RET

.SetEnemyMana   LD A, (State.Attacker)
                LD DE, #0000
                CP #FF
                JR Z, .StartDefense                                             ; переход, если нападающая армия не принадлежит правителю и её магия остаётся нулевой

                CALL Engine.RulerDesc                                           ; получить описатель одного из пятнадцати вражеских правителей
                LD E, (IX + FRuler.Mana.Low)                                    ; +#16, младший байт, текущая магическая сила
                LD D, (IX + FRuler.Mana.High)                                   ; +#17, старший байт, текущая магическая сила

                ; режим #88 запускает оборону с временной армией нападения и заданной силой
                ; противника
.StartDefense   LD IX, State.AttackArmy
                LD BC, #0500
                LD A, #03
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD A, #88
                CALL Battle.Battle                                              ; выполнить бой на поле 8 на 5 клеток
                PUSH AF
                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD A, (State.Attacker)
                LD (PlaceAuxTroops.Attacker), A
                XOR A
                LD (State.Attacker), A
                LD A, (PlaceAuxTroops.Attacker)
                CP #FF
                JR Z, .DefenseResult                                            ; переход, если у нападающего нет правителя для сохранения оставшейся магии

                CALL Engine.RulerDesc                                           ; получить описатель одного из пятнадцати вражеских правителей
                LD (IX + FRuler.Mana.Low), E                                    ; +#16, младший байт, текущая магическая сила
                LD (IX + FRuler.Mana.High), D                                   ; +#17, старший байт, текущая магическая сила
.DefenseResult  LD BC, #0000
                LD DE, #1820
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                POP AF
                OR A
                JP Z, .DefenseWon                                               ; переход, если герой успешно защитил замок

                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (State.AttackCastle)
                LD A, (PlaceAuxTroops.Attacker)
                LD (IX + FCastle.Owner), A                                      ; +#13, 0 собственный замок, 1..15 правитель FRuler, #FF особое отсутствие правителя/банды
                PUSH IX
                POP HL
                LD DE, #0014
                ADD HL, DE
                EX DE, HL
                LD HL, State.AttackArmy
                LD BC, #000F
                LDIR
                CALL Engine.LoseLeadership                                      ; уменьшить 16 битное поле героя #6A02 с насыщением 0
                LD HL, (State.Leadership)
                LD BC, #0028
                OR A
                SBC HL, BC
                JR NC, .SetLeadership                                           ; переход, если потеря ещё 40 единиц лидерства не опускает его ниже нуля

                LD HL, #0000
.SetLeadership  LD (State.Leadership), HL
                LD BC, #0800
                LD DE, #061E
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0A
                LD DE, Overlay.Castle.PlaceAuxTroops.LostCastleText             ; сообщение о проигранной защите замка
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD DE, Overlay.Castle.PlaceAuxTroops.BanditLootText             ; сообщение о захвате и разграблении замка бандитами
                LD A, (PlaceAuxTroops.Attacker)
                CP #FF
                JR Z, .ShowEvent                                                ; переход, если победивший нападающий не имеет правителя

                CALL Engine.RulerDesc                                           ; получить описатель одного из пятнадцати вражеских правителей
                LD (PlaceAuxTroops.AttackerName), IX
                LD DE, Overlay.Castle.PlaceAuxTroops.NewRulerText               ; формат нового владельца потерянного замка
.ShowEvent      LD B, #0B
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (State.EventMarker)
                OR A
                JR Z, .CheckMana                                                ; переход, если маркер события не задан и нужно проверить возможность магического возврата

                LD DE, Overlay.Castle.PlaceAuxTroops.LossText                   ; реплика после неудачной защиты замка
                LD B, #0C
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                CALL Engine.MoveToTarget                                        ; преобразовать направление к цели в команду движения героя
                RET

.CheckMana      LD HL, (State.Mana)
                LD BC, (State.ReturnCost)
                OR A
                SBC HL, BC
                JR C, .NoManaEscape                                             ; переход, если магии не хватает на возврат к сохранённой армии

                LD (State.Mana), HL
                LD B, #0C
                LD DE, Overlay.Castle.PlaceAuxTroops.ReturnText                 ; сообщение о возвращении к сохранённой армии
.ReturnHero     CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD A, (State.ReturnMode)
                LD (State.MoveFlags), A
                LD BC, (State.ReturnPosition)
                LD (State.Position), BC
                LD HL, State.ReturnArmy                                         ; сохранённые пять записей FTroop перед переносом героя к осаждённому замку
                LD DE, State.Army
                LD BC, #000F
                LDIR
                RET

.NoManaEscape   LD DE, Overlay.Castle.PlaceAuxTroops.NoReturnText               ; сообщение о нехватке магии для возврата
                LD B, #0C
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                CALL PlaceAuxTroops
                LD HL, #0000
                LD (State.Mana), HL
                LD HL, State.Army
                LD DE, State.Army + 1                                           ; следующий байт очищаемой армии героя для размножения нуля
                LD BC, #000E
                LD (HL), #00
                LDIR
.FindEscapeCell LD BC, #00A0
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD C, E
                LD BC, #0063
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD B, E
                CALL Engine.ReadMapCell                                         ; прочитать байт клетки текущей карты
                BIT MAP_BUSY_BIT, A                                             ; флаг, клетка стратегической карты занята объектом
                JR NZ, .FindEscapeCell                                          ; переход, если случайная клетка бегства занята объектом

                AND #3F
                JR NZ, .FindEscapeCell                                          ; переход, если местность случайной клетки не допускает пешее размещение героя

                LD (State.Position), BC
                RET

.DefenseWon     CALL Engine.GainLeadership                                      ; увеличить 16 битное поле героя #6A02 с насыщением #FFFF
                LD HL, State.FloatA
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD A, #02
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #04, #38                                                     ; multiply, умножение, B766
                LD HL, Overlay.Castle.PlaceAuxTroops.RewardMoney                ; пятибайтная сумма награды за защиту замка
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Overlay.Castle.PlaceAuxTroops.RewardMoney                ; пятибайтная сумма награды за защиту замка
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F, #38                                                     ; addition, сложение, B77B
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD BC, #0800
                LD DE, #051E
                LD A, #46
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0A
                LD DE, Overlay.Castle.PlaceAuxTroops.RewardText                 ; сообщение о награде городов за спасение земли
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD BC, #0000
                LD DE, #1820
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD A, (State.EventMarker)
                OR A
                JP NZ, .CheckDefense                                            ; переход, если задан маркер события и нужно вернуться к проверке защиты

                LD HL, (State.Mana)
                LD BC, (State.ReturnCost)
                OR A
                SBC HL, BC
                JR C, .VictoryMessage                                           ; переход, если после победы магии не хватает на возврат к сохранённой армии

                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD HL, (State.AttackCastle)
                LD DE, #0014
                ADD HL, DE
                EX DE, HL
                LD HL, State.Army
                LD BC, #000F
                LDIR
                LD BC, #0800
                LD DE, #041E
                LD A, #44
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD DE, Overlay.Castle.PlaceAuxTroops.VictoryReturn              ; сообщение о победе и возвращении к армии
                LD B, #0A
                JP .ReturnHero

.VictoryMessage LD BC, #0800
                LD DE, #041E
                LD A, #46
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0A
                LD DE, Overlay.Castle.PlaceAuxTroops.VictoryStay                ; сообщение о победе без сил вернуться к армии
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                CALL PlaceAuxTroops
                JP .CheckDefense

; -----------------------------------------
; размещение сохранённых отрядов как шестибайтовых объектов карты
; Перебирает до 5 записей по 3 байта от #69DE. Для каждого ID ищет запись с бит 0=1 в текущей
; таблице объектов #6B69, шаг 6. Записывает ID в+3 и 16-битное число в+4/+5. Случайно выбирает
; клетку без бит 7, назначает флаги 0 или #20 по типу ландшафта и записывает координаты+1/+2. Для
; каждой непустой исходной записи требуется свободная запись объекта. При исчерпании таблицы код
; содержит RET до POP BC, что нарушает обычный баланс стека, этот путь не проверен в игре.
; In:
;   #69DE — сохранённая армия, таблица #6B69 текущего континента
; Out:
;   отряды размещены либо ранний возврат на пустой исходной записи
; Corrupt:
;   HL, DE, BC, AF, IX, IY. HL', DE', BC', AF' сохранены. Если свободной шестибайтовой записи
;   нет, RET #B82A выполняется до POP BC, SP остаётся ниже исходного на два байта и обычный
;   возврат нарушается
; Note:
;   шестибайтовые объекты карты, генератор случайных чисел, IY, IX и основные регистры
; -----------------------------------------
PlaceAuxTroops  LD IY, State.ReturnArmy                                         ; сохранённые пять записей FTroop перед переносом героя к осаждённому замку
                LD B, #05

                ; вспомогательные отряды возвращаются в свободные записи войск текущего континента
.AuxUnit        LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                OR A
                RET Z                                                           ; выход, если список возвращаемых вспомогательных отрядов закончился

                PUSH BC
                LD IX, State.MapTroopsIndex
                LD A, (State.Continent)
                CALL Engine.IndexFourBytes                                      ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)                                  ; +#00, младший байт, адрес первой записи в банке выбранной группы
                LD H, (IX + FMapList.Data.High)                                 ; +#01, старший байт, адрес первой записи в банке выбранной группы
                LD B, (IX + FMapList.Count)                                     ; +#02, число записей little-endian, не размер в байтах
                LD DE, #0006
.FindMapSlot    BIT TROOP_FREE_BIT, (HL)                                        ; флаг, шестибайтовая запись войск карты свободна или уже использована
                JR NZ, .FillMapTroop                                            ; переход, если найдена свободная запись войск карты

                ADD HL, DE
                DJNZ .FindMapSlot

                RET

.FillMapTroop   PUSH HL
                POP IX
                LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                LD (IX + FMapTroop.ID), A                                       ; +#03, тип отряда, описатель SOLDIERS
                LD A, (IY + FTroop.Count.Low)                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD (IX + FMapTroop.Count.Low), A                                ; +#04, младший байт, беззнаковая численность little-endian
                LD A, (IY + FTroop.Count.High)                                  ; +#02, старший байт, беззнаковая численность little-endian
                LD (IX + FMapTroop.Count.High), A                               ; +#05, старший байт, беззнаковая численность little-endian

                ; клетка возвращаемого отряда выбирается случайно и должна пройти проверки
                ; занятости и местности
.FindTroopCell  LD DE, #00A0
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD C, E
                LD DE, #0063
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD B, E
                CALL Engine.ReadMapCell                                         ; прочитать байт клетки текущей карты
                BIT MAP_BUSY_BIT, A                                             ; флаг, клетка стратегической карты занята объектом
                JR NZ, .FindTroopCell                                           ; переход, если случайная клетка размещения отряда занята объектом

                LD (IX + FMapTroop.Flags), #00                                  ; +#00, состояние шестибайтовой группы, бит 0 свободна/использована, бит 5 вода, бит 6 ориентация, другие биты отдельно не именуются
                AND #3F
                JR Z, .StoreTroopPos                                            ; переход, если код местности равен 0 и отряд размещается как сухопутный

                CP #09
                JR NC, .StoreTroopPos                                           ; переход, если код местности не входит в водный диапазон 1..8

                LD (IX + FMapTroop.Flags), #20                                  ; +#00, состояние шестибайтовой группы, бит 0 свободна/использована, бит 5 вода, бит 6 ориентация, другие биты отдельно не именуются
.StoreTroopPos  LD (IX + FMapTroop.X), C                                        ; +#01, столбец карты
                LD (IX + FMapTroop.Y), B                                        ; +#02, строка карты
                POP BC
                INC IY
                INC IY
                INC IY
                DJNZ .AuxUnit

                RET

.Attacker       DB #00                                                          ; ID нападающего, сохраняется после завершения боя
.HelpTown       DW #0000                                                        ; адрес города, предлагающего помощь
.CityFarText    EQU $                                                           ; сообщение о слишком далёком городе для прибытия помощи
                DB #83, #AE, #E0, #AE, #A4, #20, #E1, #AB
                DB #A8, #E8, #AA, #AE, #AC, #20, #A4, #A0
                DB #AB, #A5, #AA, #AE, #2C, #20, #AF, #AE
                DB #AC, #AE, #E9, #EC, #0D, #2A, #AD, #A5
                DB #20, #E3, #E1, #AF, #A5, #A5, #E2, #20
                DB #AF, #E0, #A8, #A9, #E2, #A8, #20, #A2
                DB #AE, #20, #A2, #E0, #A5, #AC, #EF, #2E
.CityEmptyText  EQU $+5                                                         ; сообщение об отсутствии солдат в соседнем городе
                DB #2E, #2E, #0D, #2A, #00, #82, #20, #E1
                DB #AE, #E1, #A5, #A4, #AD, #A5, #AC, #20
                DB #A3, #AE, #E0, #AE, #A4, #A5, #20, #AD
                DB #A5, #E2, #20, #A0, #E0, #AC, #A8, #A8
.CityArmyText   EQU $+4                                                         ; заголовок армии соседнего города
                DB #2E, #0D, #2A, #00, #80, #E0, #AC, #A8
                DB #EF, #20, #A2, #20, #A3, #AE, #E0, #AE
                DB #A4, #A5, #20, #E1, #AE, #E1, #E2, #AE
                DB #A8, #E2, #20, #A8, #A7, #3A, #0D, #2A
.ChooseCityText EQU $+1                                                         ; вопрос о вызываемом отряде и пункт завершения выбора
                DB #00, #82, #EB, #A1, #A5, #E0, #A5, #E2
                DB #A5, #20, #E2, #A5, #E5, #2C, #20, #AA
                DB #AE, #A3, #AE, #20, #E5, #AE, #E2, #A8
                DB #E2, #A5, #20, #AF, #E0, #A8, #A7, #A2
                DB #A0, #E2, #EC, #2E, #0D, #2A, #82, #EB
                DB #A1, #AE, #E0, #20, #E1, #A4, #A5, #AB
.CityUnitText   EQU $+5                                                         ; формат строки городского отряда в списке выбора
                DB #A0, #AD, #0D, #1A, #00, #0F
.CityCount      DW #0000                                                        ; численность городского отряда для текста
                DB #00, #0E, #E9, #7E, #0D, #02, #00
.CityMenuCount  DB #04                                                          ; число пунктов меню городской помощи
                DB #0A, #78, #ED, #B8, #32, #92, #13, #16
                DB #1E, #17, #01, #12, #1F, #13, #01, #13
.RenameText     EQU $+6                                                         ; приглашение ввести новое имя замка
                DB #1F, #14, #01, #14, #1F, #15, #84, #A0
                DB #A9, #E2, #A5, #20, #A7, #A0, #AC, #AA
                DB #E3, #20, #AD, #AE, #A2, #AE, #A5, #20
.NameBuffer     EQU $+5                                                         ; пятнадцать байтов ввода нового имени замка
                DB #A8, #AC, #EF, #3A, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
.RewardText     EQU $+4                                                         ; сообщение о награде городов за спасение земли
                DB #00, #00, #00, #00, #87, #A0, #20, #E1
                DB #AF, #A0, #E1, #A5, #AD, #A8, #A5, #20
                DB #A7, #A5, #AC, #A5, #AB, #A8, #20, #AE
                DB #E2, #0D, #2A, #A7, #A0, #E5, #A2, #A0
                DB #E2, #E7, #A8, #AA, #AE, #A2, #20, #A6
                DB #A8, #E2, #A5, #AB, #A8, #20, #AE, #AA
                DB #E0, #A5, #E1, #E2, #AD, #EB, #E5, #20
                DB #A3, #AE, #E0, #AE, #A4, #AE, #A2, #0D
                DB #2A, #A7, #A0, #AF, #AB, #A0, #E2, #A8
                DB #AB, #A8, #20, #A2, #A0, #AC, #20, #10
.RewardMoney    EQU $                                                           ; пятибайтная сумма награды за защиту замка
                DB #00, #00, #00, #00, #00, #00, #AC, #AE
.VictoryReturn  EQU $+7                                                         ; сообщение о победе и возвращении к армии
                DB #AD, #A5, #E2, #2E, #0D, #2A, #00, #82
                DB #EB, #20, #E0, #A0, #A7, #A3, #E0, #AE
                DB #AC, #A8, #AB, #A8, #20, #AD, #A5, #AF
                DB #E0, #A8, #EF, #E2, #A5, #AB, #EF, #2C
                DB #20, #A8, #20, #E1, #20, #E7, #A8, #E1
                DB #E2, #AE, #A9, #0D, #2A, #E1, #AE, #A2
                DB #A5, #E1, #E2, #EC, #EE, #20, #A2, #AE
                DB #A7, #A2, #E0, #A0, #E9, #A0, #A5, #E2
                DB #A5, #E1, #EC, #20, #AA, #20, #E1, #A2
                DB #AE, #A5, #A9, #20, #A0, #E0, #AC, #A8
.VictoryStay    EQU $+5                                                         ; сообщение о победе без сил вернуться к армии
                DB #A8, #2E, #0D, #2A, #00, #82, #E0, #A0
                DB #A3, #20, #E0, #A0, #A7, #A1, #A8, #E2
                DB #2C, #20, #AD, #AE, #20, #E3, #20, #A2
                DB #A0, #E1, #20, #AD, #A5, #E2, #20, #E1
                DB #A8, #AB, #2C, #0D, #2A, #E7, #E2, #AE
                DB #A1, #EB, #20, #A2, #A5, #E0, #AD, #E3
                DB #E2, #EC, #E1, #EF, #20, #AA, #20, #E1
                DB #A2, #AE, #A5, #A9, #20, #A0, #E0, #AC
                DB #A8, #A8, #2E, #2E, #2E, #0D, #2A, #00
.LostCastleText EQU $                                                           ; сообщение о проигранной защите замка
                DB #82, #A0, #AC, #20, #AD, #A5, #20, #E3
                DB #A4, #A0, #AB, #AE, #E1, #EC, #20, #AE
                DB #E2, #E1, #E2, #AE, #EF, #E2, #EC, #20
                DB #E1, #A2, #AE, #A9, #20, #A7, #A0, #AC
.NewRulerText   EQU $+6                                                         ; формат нового владельца потерянного замка
                DB #AE, #AA, #2C, #0D, #2A, #00, #AE, #E2
                DB #AD, #EB, #AD, #A5, #20, #A5, #A3, #AE
                DB #20, #E5, #AE, #A7, #EF, #A8, #AD, #3A
                DB #20, #0E
.AttackerName   DW #0000                                                        ; адрес имени нападающего правителя
.BanditLootText EQU $+3                                                         ; сообщение о захвате и разграблении замка бандитами
                DB #0D, #2A, #00, #AE, #AD, #20, #A7, #A0
                DB #E5, #A2, #A0, #E7, #A5, #AD, #20, #A8
                DB #20, #E0, #A0, #A7, #A3, #E0, #A0, #A1
                DB #AB, #A5, #AD, #20, #A1, #A0, #AD, #A4
                DB #A8, #E2, #A0, #AC, #A8, #2E, #0D, #2A
.LossText       EQU $+1                                                         ; реплика после неудачной защиты замка
                DB #00, #8E, #A1, #A8, #A4, #AD, #AE, #2C
                DB #0D, #2A, #A0, #20, #E7, #E2, #AE, #20
                DB #A4, #A5, #AB, #A0, #E2, #EC, #2E, #2E
.NoReturnText   EQU $+4                                                         ; сообщение о нехватке магии для возврата
                DB #2E, #0D, #2A, #00, #8A, #E0, #AE, #AC
                DB #A5, #20, #E2, #AE, #A3, #AE, #2C, #20
                DB #E3, #20, #A2, #A0, #E1, #20, #AD, #A5
                DB #20, #AE, #E1, #E2, #A0, #AB, #AE, #E1
                DB #EC, #0D, #2A, #AC, #A0, #A3, #A8, #E7
                DB #A5, #E1, #AA, #A8, #E5, #20, #E1, #A8
                DB #AB, #20, #E7, #E2, #AE, #A1, #EB, #20
                DB #A2, #A5, #E0, #AD, #E3, #E2, #EC, #E1
                DB #EF, #20, #AA, #20, #A0, #E0, #AC, #A8
.ReturnText     EQU $+4                                                         ; сообщение о возвращении к сохранённой армии
                DB #A8, #0D, #2A, #00, #8E, #A4, #AD, #A0
                DB #AA, #AE, #20, #E3, #20, #A2, #A0, #E1
                DB #20, #E5, #A2, #A0, #E2, #A8, #AB, #AE
                DB #20, #E1, #A8, #AB, #2C, #20, #E7, #E2
                DB #AE, #A1, #EB, #0D, #2A, #A2, #A5, #E0
                DB #AD, #E3, #E2, #EC, #E1, #EF, #20, #AA
                DB #20, #E1, #A2, #AE, #A5, #A9, #20, #A0
                DB #E0, #AC, #A8, #A8, #2E, #0D, #2A, #00

; -----------------------------------------
; вывод до пяти отрядов и подготовка меню выбора
; Очищает пять строк, число пунктов ReadUnitCount.UnitMenuCount устанавливает 1 для выхода.
; Берёт ID и количество из
; трёхбайтовых записей IY, останавливается на ID0. #8036 даёт название/описатель, строка #BD28
; печатает имя и число. После каждой записи увеличивает число пунктов, строку печати и IY на 3.
; In:
;   IY — массив до 5 записей ID+little-endian количество
; Out:
;   ReadUnitCount.UnitMenuCount=1+число напечатанных записей
; Corrupt:
;   DE, BC, AF, HL', DE', BC', AF', IX, IY. HL сохранён, остальные основные регистры
;   используются для координат, чисел и описателя отряда, IY продвигается по массиву
; Note:
; экран, ReadUnitCount.UnitName/ReadUnitCount.UnitCount, DrawUnitList.ListIndex, IY после
; последней записи
; -----------------------------------------
DrawUnitList    LD BC, #1201
                LD DE, #051E
                LD A, #47
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD A, #01
                LD (ReadUnitCount.UnitMenuCount), A
                LD A, #12
                LD (DrawUnitList.ListIndex), A
                LD B, #05

                ; список прекращается на нулевом ID и не просматривает оставшиеся пустые записи
.UnitRow        XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD A, (IY + FTroop.ID)                                          ; +#00, ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID
                OR A
                RET Z                                                           ; выход, если достигнут конец заполненных записей выводимой армии

                PUSH BC
                LD C, (IY + FTroop.Count.Low)                                   ; +#01, младший байт, беззнаковая численность little-endian
                LD B, (IY + FTroop.Count.High)                                  ; +#02, старший байт, беззнаковая численность little-endian
                LD (ReadUnitCount.UnitCount), BC
                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD (ReadUnitCount.UnitName), IX
                LD B, #00
.ListIndex      EQU $ - 1                                                       ; операнд номера выводимого отряда
                LD DE, Overlay.Castle.ReadUnitCount.ArmyUnitText                ; формат строки списка гарнизона или армии героя
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, (DrawUnitList.ListIndex)
                INC A
                LD (DrawUnitList.ListIndex), A
                LD A, (ReadUnitCount.UnitMenuCount)
                INC A
                LD (ReadUnitCount.UnitMenuCount), A
                POP BC
                INC IY
                INC IY
                INC IY
                DJNZ .UnitRow

                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                RET

; -----------------------------------------
; ввод числа передаваемых воинов с верхней границей
; Сохраняет IX/IY, по A+17 выбирает строку подсветки и печатает «Сколько?». Повторяет числовой
; ввод #6FC0 и получение BC через #6D76. Нулевое число и число больше исходного HL отвергает. Код
; ввода #0E означает отмену. При успехе возвращает положительный BC<=HL и сбрасывает CF.
; In:
;   A — номер строки выбора с 1, HL — максимум
; Out:
;   BC — введённое количество, A=#0E/Z=1 при отмене, Z=0 и CF=0 при успехе, A=B OR C, IX, IY
;   сохранены
; Corrupt:
;   DE, BC, AF, HL', DE', BC', AF'. HL, IX, IY сохранены, HL восстанавливается после числового
;   ввода и проверки верхней границы
; Note:
;   экран, рабочий операнд ReadUnitCount.CountInputXY, HL сохраняется при сравнении, основные регистры
; -----------------------------------------
ReadUnitCount   PUSH IX
                PUSH IY
                ADD A, #11
                LD B, A
                PUSH BC
                LD C, #01
                LD DE, #011E
                LD A, #46
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                POP BC
                LD C, #18
                LD DE, Overlay.Castle.ReadUnitCount.QuantityText                ; приглашение ввести число воинов
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD C, #22
                LD (ReadUnitCount.CountInputXY), BC

                ; запрошенное количество не должно превышать имеющееся в выбранном отряде
.ReadCount      LD BC, #0000
.CountInputXY   EQU $ - 2                                                       ; операнд координат поля ввода численности
                PUSH HL
                CALL Engine.EditNumber                                          ; ввести число из не более пяти цифр
                POP HL
                CP #0E
                JR Z, .ReturnCount                                              ; переход, если ввод количества отменён кодом #0E

                CALL Engine.PopBC                                               ; извлечь результат калькулятора ROM в BC
                LD A, B
                OR C
                JR Z, .ReadCount                                                ; переход, если введено нулевое количество и требуется повторить ввод

                PUSH HL
                SBC HL, BC
                POP HL
                JR C, .ReadCount                                                ; переход, если введённое количество превышает численность исходного отряда

                OR A
.ReturnCount    POP IY
                POP IX
                RET

.QuantityText   EQU $                                                           ; приглашение ввести число воинов
                DB #91, #AA, #AE, #AB, #EC, #AA, #AE, #20
                DB #3F, #20, #00
.DefenseMode    DB #00                                                          ; режим защиты от близкого нападения
.FortFullText   EQU $                                                           ; сообщение об отсутствии свободного места в замке
                DB #82, #20, #A7, #A0, #AC, #AA, #A5, #20
                DB #A1, #AE, #AB, #EC, #E8, #A5, #20, #AD
                DB #A5, #E2, #20, #AC, #A5, #E1, #E2, #A0
.FortEmptyText  EQU $+2                                                         ; сообщение об отсутствии армии в замке
                DB #2E, #00, #87, #A0, #AC, #AE, #AA, #20
.CastleNameText EQU $+6                                                         ; формат имени текущего замка
                DB #AF, #E3, #E1, #E2, #2E, #00, #87, #A0
                DB #AC, #AE, #AA, #20, #0E
.CastleName     DW #0000                                                        ; адрес имени текущего замка для текста
.PeaceActions   EQU $+3                                                         ; пункты помещения отрядов в замок, забора и выхода
                DB #0D, #2A, #00, #8E, #E1, #E2, #A0, #A2
                DB #A8, #E2, #EC, #20, #A2, #AE, #A8, #AD
                DB #AE, #A2, #20, #A2, #20, #A7, #A0, #AC
                DB #AA, #A5, #0D, #02, #87, #A0, #A1, #E0
                DB #A0, #E2, #EC, #20, #A2, #AE, #A8, #AD
                DB #AE, #A2, #20, #A8, #A7, #20, #A7, #A0
                DB #AC, #AA, #A0, #0D, #02, #8F, #AE, #AA
                DB #A8, #AD, #E3, #E2, #EC, #20, #A7, #A0
.DefenseActions EQU $+6                                                         ; пункты исключения, вызова отрядов и начала боя
                DB #AC, #AE, #AA, #0D, #02, #00, #88, #E1
                DB #AA, #AB, #EE, #E7, #A8, #E2, #EC, #20
                DB #A2, #AE, #A8, #AD, #AE, #A2, #20, #A8
                DB #A7, #20, #A0, #E0, #AC, #A8, #A8, #0D
                DB #02, #82, #A7, #EF, #E2, #EC, #20, #A2
                DB #AE, #A8, #AD, #AE, #A2, #20, #A2, #20
                DB #A0, #E0, #AC, #A8, #EE, #0D, #02, #8D
                DB #A0, #E7, #A0, #E2, #EC, #20, #E1, #E0
                DB #A0, #A6, #A5, #AD, #A8, #A5, #0D, #02
.CallCityText   EQU $+1                                                         ; дополнительный пункт призыва отряда из города
                DB #00, #8F, #E0, #A8, #A7, #A2, #A0, #E2
                DB #EC, #20, #A2, #AE, #A8, #AD, #AE, #A2
                DB #20, #A8, #A7, #20, #A3, #AE, #E0, #AE
.NoArmyText     EQU $+5                                                         ; сообщение об отсутствии армии героя
                DB #A4, #A0, #0D, #02, #00, #93, #20, #A2
                DB #A0, #E1, #20, #AD, #A5, #E2, #20, #A0
.LeaveUnitText  EQU $+6                                                         ; вопрос о помещении отряда героя в замок
                DB #E0, #AC, #A8, #A8, #2E, #00, #8A, #AE
                DB #A3, #AE, #20, #E5, #AE, #E2, #A8, #E2
                DB #A5, #20, #AE, #E1, #E2, #A0, #A2, #A8
                DB #E2, #EC, #20, #3F, #0D, #2A, #0D, #00
                DB #8D, #A8, #AA, #AE, #A3, #AE, #0D, #02
.TakeUnitText   EQU $+1                                                         ; вопрос о заборе отряда из замка
                DB #00, #8A, #AE, #A3, #AE, #20, #E5, #AE
                DB #E2, #A8, #E2, #A5, #20, #A7, #A0, #A1
                DB #E0, #A0, #E2, #EC, #20, #3F, #0D, #2A
                DB #0D, #00, #8D, #A8, #AA, #AE, #A3, #AE
.ArmyUnitText   EQU $+3                                                         ; формат строки списка гарнизона или армии героя
                DB #0D, #02, #00, #0E
.UnitName       DW #0000                                                        ; адрес имени выводимого отряда
                DB #3A, #20, #0F
.UnitCount      DW #0000                                                        ; численность выводимого отряда
                DB #00, #0D, #02, #00
.MenuCount      DB #04                                                          ; число пунктов главного меню замка
                DB #00, #70, #ED, #BF, #0A, #88, #01, #12
                DB #1F, #13, #01, #13, #1F, #14, #01, #14
                DB #1F, #15, #01, #10, #1F, #11, #01, #15
                DB #1F, #16
.UnitMenuCount  DB #01                                                          ; число пунктов выбора отряда
                DB #00, #70, #ED, #BF, #0A, #88, #01, #11
                DB #1F, #12, #01, #12, #1F, #13, #01, #13
                DB #1F, #14, #01, #14, #1F, #15, #01, #15
                DB #1F, #16, #01, #16, #1F, #17, #6F, #76
                DB #65, #72, #6C, #61, #79

                assert $ = #BD75
                endmodule
                endmodule
