; оверлей 01 из OVR1
; исходный файл каталога 48, смещение #0000
                module Overlay
                module Capture
                org #B200

; -----------------------------------------
; захват замка, бой и выдача награды
; Читает защитника из объекта, выводит сведения о нём, проверяет необходимость осадных орудий и
; возможность помощи. Подготавливает две армии и вызывает бой #D255. После победы меняет владельца
; замка, проверяет оставшиеся замки противника и наличие контракта, начисляет обычное и
; дополнительное вознаграждение. Если у противника не осталось замков, участок #B54E..#B55C
; вызывает NewMapPiece несколько раз, открывая фрагменты карты цели в #6A55..#6A59. Эти биты не
; являются
; контрактными отметками.
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
                LD (State.CastleName), IX
                LD (NewMapPiece.CastleName), IX
                LD A, (IX + FCastle.Owner - 3)                                  ; +#10, 0 собственный замок, 1..15 правитель FRuler, #FF особое отсутствие правителя/банды
                OR A
                JP Z, Engine.RunOwnCastle                                       ; переход, если замок уже принадлежит герою

                LD A, (State.MoveFlags)
                SET HERO_HIDE_BIT, A                                            ; флаг, пропустить подготовку изображения героя в локальном окне
                LD (State.MoveFlags), A
                CALL Engine.UpdateLocalView                                     ; отметить открытые клетки вокруг героя и подготовить экранные объекты
                HALT
                LD A, (State.MoveFlags)
                RES HERO_HIDE_BIT, A                                            ; флаг, пропустить подготовку изображения героя в локальном окне
                LD (State.MoveFlags), A
                LD BC, #1000
                LD DE, #061E
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #1519
                LD DE, #0106
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #1619
                LD DE, #0106
                LD A, #41
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD B, #12
                LD DE, Overlay.Capture.NewMapPiece.CastleTitle                  ; заголовок осматриваемого замка
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD DE, Overlay.Capture.NewMapPiece.BanditOwner                  ; текст о замке без известного правителя
                LD IX, (State.CastleName)
                LD A, (IX + FCastle.Owner - 3)                                  ; +#10, 0 собственный замок, 1..15 правитель FRuler, #FF особое отсутствие правителя/банды
                LD (NewMapPiece.Defender), A
                CP #FF
                JR Z, .DefenderPrompt                                           ; переход, если у защитника нет правителя и используется особый владелец #FF

                CALL Engine.RulerDesc                                           ; получить описатель одного из пятнадцати вражеских правителей
                LD (NewMapPiece.DefenderName), IX
                LD DE, Overlay.Capture.NewMapPiece.RulerOwner                   ; формат владельца замка с подставляемым именем правителя
.DefenderPrompt LD B, #14
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #15
                LD DE, Overlay.Capture.NewMapPiece.AttackQuestion               ; вопрос о начале штурма замка
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #15
                LD DE, Engine.NeedMoreMoney.AttackText                          ; общие надписи Атакую и Отхожу перед сражением
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IX, Engine.NeedMoreMoney.AttackMenu                          ; общий описатель выбора Атакую или Отхожу
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #02
                JP Z, .FinishMove                                               ; переход, если игрок отказался штурмовать замок

                LD A, (State.MoveFlags)
                BIT HERO_SIEGE_BIT, A                                           ; флаг, у героя есть осадное орудие, перед взлётом требуется его оставить
                JR NZ, .CheckContract                                           ; переход, если у героя имеются осадные орудия

                LD BC, #1000
                LD DE, #061E
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #12
                LD DE, Overlay.Capture.NewMapPiece.NoSiegeText                  ; отказ в штурме без осадных орудий
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .FinishMove

.CheckContract  LD A, (State.Army + FTroopA5.Item4.ID)
                OR A
                JP NZ, .SetEnemyMana                                            ; переход, если пятый слот армии занят и принять вспомогательный отряд нельзя

                LD A, (State.Contract)
                OR A
                JP Z, .SetEnemyMana                                             ; переход, если у героя нет действующего контракта на замок

                LD HL, Runtime.Castles + FCastle.Name - FCastle                 ; база перед именем первой записи замка для цикла с первым ADD на FCastle
                LD DE, #0023
.ContractRecord ADD HL, DE
                DEC A
                JR NZ, .ContractRecord                                          ; переход, если ещё не найдена запись контрактного замка

                LD DE, (State.CastleName)
                OR A
                SBC HL, DE
                JP NZ, .SetEnemyMana                                            ; переход, если штурмуется не тот замок, на который выдан контракт

                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (State.CastleName)
                LD D, #02
                LD A, (State.Continent)
                LD E, A
                LD C, (IX + FCastle.X - FCastle.Name)
                LD B, (IX + FCastle.Y - FCastle.Name)
                LD HL, #0000
                LD A, #1A
                CALL Engine.NearestObject                                       ; найти ближайшую активную запись выбранной группы
                LD (Entry.HelpTown), IX
                LD A, (IX + FTown.Army + FTroop.ID)
                OR A
                JP Z, .SetEnemyMana                                             ; переход, если в ближайшем городе нет первого отряда для помощи

                LD B, #03
                XOR A

                ; помощь выбирается по наибольшему ID типа среди трёх городских отрядов
.StrongestUnit  CP (IX + FTown.Army + FTroop.ID)
                JR NC, .NextUnit                                                ; переход, если ID текущего отряда не превосходит уже выбранный ID помощи

                LD A, (IX + FTown.Army + FTroop.ID)
                PUSH IX
                POP IY
.NextUnit       INC IX
                INC IX
                INC IX
                DJNZ .StrongestUnit

                LD (Entry.HelpType), A
                CALL Engine.FreeCapacity                                        ; вычислить остаток допустимого количества выбранного типа отряда
                LD A, B
                OR C
                JP Z, .SetEnemyMana                                             ; переход, если свободный предел управления не допускает ни одного существа помощи

                LD L, (IY + FTown.Army + FTroop.Count.Low)
                LD H, (IY + FTown.Army + FTroop.Count.High)
                SBC HL, BC
                JR NC, .SubtractUnits                                           ; переход, если в городе хватает существ на весь свободный предел управления

                LD C, (IY + FTown.Army + FTroop.Count.Low)
                LD B, (IY + FTown.Army + FTroop.Count.High)
.SubtractUnits  LD L, (IY + FTown.Army + FTroop.Count.Low)
                LD H, (IY + FTown.Army + FTroop.Count.High)
                OR A
                SBC HL, BC
                JR NZ, .StoreGarrison                                           ; переход, если после выдачи помощи в городском отряде остаются существа

                LD (IY + FTown.Army + FTroop.ID), L
.StoreGarrison  LD (IY + FTown.Army + FTroop.Count.Low), L
                LD (IY + FTown.Army + FTroop.Count.High), H
                LD (Entry.HelpCount), BC
                LD HL, #0000
.HelpTown       EQU $ - 2                                                       ; операнд указателя ближайшего города помощи
                LD DE, #0011
                ADD HL, DE
                LD B, #03
                CALL Engine.CompactArmy                                         ; сжать список трёхбайтных записей армии
                CALL Engine.RefreshHero                                         ; обновить боковую панель героя, расходы и рейтинг
                CALL Engine.UpdateLocalView                                     ; отметить открытые клетки вокруг героя и подготовить экранные объекты
                HALT
                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                LD BC, #0700
                LD DE, #0C12
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #0202
                LD A, (Entry.HelpType)
                CALL Engine.SetUnitPicture                                      ; создать четырёхкадровый экранный объект
                LD B, #0D
                LD DE, Overlay.Capture.NewMapPiece.HelpOffer                    ; предложение поддержки перед штурмом
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                CALL Engine.StartView                                           ; включить обработку объектов в прерывании
                LD IX, Overlay.Capture.NewMapPiece.HelpMenu                     ; меню принятия предложенной поддержки
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #01
                JR Z, .SetEnemyMana                                             ; переход, если игрок отказался принимать помощь

                LD IX, State.Army
.FindArmySlot   LD A, (IX + FTroop.ID)
                OR A
                JR Z, .InitArmySlot                                             ; переход, если найдена свободная запись армии для помощи

                LD A, (Entry.HelpType)
                CP (IX + FTroop.ID)
                JR Z, .InitArmySlot                                             ; переход, если найден существующий отряд того же типа

                INC IX
                INC IX
                INC IX
                JR .FindArmySlot

.InitArmySlot   LD A, (IX + FTroop.ID)
                OR A
                JR NZ, .AddUnits                                                ; переход, если помощь добавляется к уже существующему отряду

                CALL Engine.ClearTwoFlags                                       ; обнулить два связанных байта таблиц
.AddUnits       LD BC, #0000
.HelpCount      EQU $ - 2                                                       ; операнд количества передаваемых существ помощи
                LD A, #00
.HelpType       EQU $ - 1                                                       ; операнд ID типа выбранной помощи
                LD L, (IX + FTroop.Count.Low)
                LD H, (IX + FTroop.Count.High)
                ADD HL, BC
                LD (IX + FTroop.ID), A
                LD (IX + FTroop.Count.Low), L
                LD (IX + FTroop.Count.High), H

                ; сила противника берётся из описателя владельца, особый владелец #FF оставляет
                ; её нулевой
.SetEnemyMana   LD A, (NewMapPiece.Defender)
                LD DE, #0000
                CP #FF
                JR Z, .StartBattle                                              ; переход, если защитник не имеет правителя и его магическая сила остаётся нулевой

                CALL Engine.RulerDesc                                           ; получить описатель одного из пятнадцати вражеских правителей
                LD E, (IX + FRuler.Mana.Low)                                    ; +#16, младший байт, текущая магическая сила
                LD D, (IX + FRuler.Mana.High)                                   ; +#17, старший байт, текущая магическая сила
.StartBattle    LD IX, (State.CastleName)
                LD BC, #0011
                ADD IX, BC
                LD BC, #0500
                LD A, #03
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD A, #08
                CALL Battle.Battle                                              ; выполнить бой на поле 8 на 5 клеток
                PUSH AF
                LD A, (NewMapPiece.Defender)
                CP #FF
                JR Z, .BattleResult                                             ; переход, если у защитника нет правителя для сохранения оставшейся магии

                CALL Engine.RulerDesc                                           ; получить описатель одного из пятнадцати вражеских правителей
                LD (IX + FRuler.Mana.Low), E                                    ; +#16, младший байт, текущая магическая сила
                LD (IX + FRuler.Mana.High), D                                   ; +#17, старший байт, текущая магическая сила
.BattleResult   POP AF
                OR A
                JR Z, .CaptureCastle                                            ; переход, если герой победил в бою за замок

                CALL Engine.LoseLeadership                                      ; уменьшить 16 битное поле героя #6A02 с насыщением 0
                LD BC, #0000
                LD DE, #1820
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD BC, #0801
                LD DE, #051C
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0A
                LD DE, Overlay.Capture.NewMapPiece.DefeatText                   ; первое сообщение о проигранном штурме
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD BC, #0801
                LD DE, #051C
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0B
                LD DE, Overlay.Capture.NewMapPiece.DefeatReturn                 ; сообщение о неудачном штурме и возврате
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
.FinishMove     CALL Engine.MoveToTarget                                        ; преобразовать направление к цели в команду движения героя
                RET

                ; после победы владелец замка меняется до расчёта вознаграждения и проверки
                ; оставшихся владений
.CaptureCastle  XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (State.CastleName)
                LD (IX + FCastle.Owner - FCastle.Name), #00
                LD DE, Overlay.Capture.NewMapPiece.CaptureReward                ; текст обычной награды за взятие замка
                LD (Entry.RewardText), DE
                LD A, (State.Contract)
                OR A
                JR Z, .AwardGold                                                ; переход, если действующего контракта нет и дополнительная награда не нужна

                LD E, A
                XOR A
                LD HL, (State.CastleName)
                LD BC, Runtime.Castles                                          ; 80 записей FCastle текущего мира в логическом банке 0
                SBC HL, BC
                LD BC, #0023
.CastleIndex    INC A
                SBC HL, BC
                JR NC, .CastleIndex                                             ; переход, если до текущего замка остаются полные записи каталога

                CP E
                JR NZ, .AwardGold                                               ; переход, если захваченный замок не совпадает с контрактным

                XOR A
                LD (State.Contract), A
                LD DE, Overlay.Capture.NewMapPiece.ContractReward               ; текст повышенной награды за контрактный замок
                LD (Entry.RewardText), DE
                LD DE, #0002
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD HL, State.FloatA
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD A, E
                INC A
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05, #27, #31, #38                                           ; division, деление, B48C
                LD HL, Overlay.Capture.NewMapPiece.RewardMoney                  ; пятибайтная вычисленная сумма награды в тексте контракта
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F, #38                                                     ; addition, сложение, B49D
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
.AwardGold      LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, State.FloatA
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F, #38                                                     ; addition, сложение, B4B2
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                CALL Engine.GainLeadership                                      ; увеличить 16 битное поле героя #6A02 с насыщением #FFFF
                LD HL, (State.Leadership)
                LD BC, #0028
                ADD HL, BC
                JR NC, .SetLeadership                                           ; переход, если прибавление лидерства не вызвало переполнения

                LD HL, #FFFF
.SetLeadership  LD (State.Leadership), HL
                LD HL, Screen.Pixels                                            ; начало видимой пиксельной области Spectrum
                LD DE, Screen.Pixels + 1                                        ; следующий байт видимой пиксельной области для размножения заполнителя
                LD BC, #1AFF
                LD (HL), #00
                LDIR
                LD BC, #0603
                LD DE, #0D18
                LD A, #46
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #0804
                LD DE, #0116
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD HL, State.FloatA
                LD DE, Overlay.Capture.NewMapPiece.PrizeMoney                   ; пятибайтная сумма первой награды в сообщении
                LD BC, #0005
                LDIR
                LD B, #08
                LD DE, Overlay.Capture.NewMapPiece.VictoryText                  ; сообщение о победе и вознаграждении
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD DE, #0000
.RewardText     EQU $ - 2                                                       ; операнд текста обычной либо контрактной награды
                LD B, #0F
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #3C
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD HL, Screen.Pixels                                            ; начало видимой пиксельной области Spectrum
                LD DE, Screen.Pixels + 1                                        ; следующий байт видимой пиксельной области для размножения заполнителя
                LD BC, #1AFF
                LD (HL), #00
                LDIR
                LD A, (NewMapPiece.Defender)
                CP #FF
                JP Z, Engine.RunOwnCastle                                       ; переход, если побеждённый защитник не был правителем

                CALL Engine.RulerDesc                                           ; получить описатель одного из пятнадцати вражеских правителей
                LD (NewMapPiece.LostRulerName), IX
                LD (NewMapPiece.RulerName), IX
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD A, (NewMapPiece.Defender)
                LD IX, Runtime.Castles                                          ; 80 записей FCastle текущего мира в логическом банке 0
                LD DE, #0023
                LD B, #50

                ; обход ищет хотя бы один действующий замок прежнего владельца
.FindRulerFort  BIT CASTLE_OFF_BIT, (IX + FCastle.Flags)                        ; флаг, запись замка выключена из обхода
                JR NZ, .NextCastle                                              ; переход, если очередная запись замка помечена неактивной

                CP (IX + FCastle.Owner)
                JR Z, .RulerHasCastle                                           ; переход, если найден ещё один замок побеждённого правителя

.NextCastle     ADD IX, DE
                DJNZ .FindRulerFort

                LD HL, NewMapPiece.Defender
                LD A, (NewMapPiece.Defender)
                LD D, #00
                LD E, A
                ADD HL, DE
                LD B, (HL)

                ; поражение последнего замка правителя открывает несколько случайных фрагментов
                ; карты цели
.RevealPieces   CALL NewMapPiece
                DJNZ .RevealPieces

                LD A, #03
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD BC, #0601
                LD DE, #061C
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD DE, Overlay.Capture.NewMapPiece.RulerDefeated                ; сообщение о лишившемся последнего замка правителе
                JR .RewardMessage

.RulerHasCastle LD A, #03
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD BC, #0601
                LD DE, #061C
                LD A, #46
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD DE, Overlay.Capture.NewMapPiece.RulerSurvived                ; сообщение о правителе, сохранившем другие замки
.RewardMessage  LD B, #08
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #1E
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP Engine.RunOwnCastle

; -----------------------------------------
; выбор новой свободной отметки среди 25 битов
; Сначала AND пяти байтов #6A55 с #1F проверяет полное заполнение 25 младших битов. Если заполнено
; всё, возвращает Z. Иначе случайно выбирает номер байта 0..4 и бита 0..4 через #7C0D.
; Самомодифицируемые BIT/SET получают выбранный номер. Уже установленный бит вызывает повторный
; выбор, свободный устанавливается.
; In:
;   #6A55..#6A59 — пять масок
; Out:
;   выбранный свободный бит установлен либо Z при полном заполнении
; Corrupt:
;   HL, DE, AF
; -----------------------------------------
NewMapPiece     PUSH BC
                LD HL, State.PuzzleOpen
                LD B, #05
                LD A, #1F
.AllPiecesKnown AND (HL)
                INC HL
                DJNZ .AllPiecesKnown

                POP BC
                CP #1F
                RET Z                                                           ; выход, если открыты все 25 частей карты цели

                ; повторный случайный выбор исключает уже открытый фрагмент карты
.ChoosePiece    LD DE, #0004
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD HL, State.PuzzleOpen
                ADD HL, DE
                LD DE, #0004
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD A, E
                RLCA
                RLCA
                RLCA
                OR #46
                LD (NewMapPiece.TestPiece), A
                OR #C6
                LD (NewMapPiece.OpenPiece), A
                BIT PIECE_INDEX_BIT, (HL)                                       ; начальный номер бита шаблонов BIT/SET карты головоломки, фактический номер 0..4 переписывается вычисленным opcode перед выполнением
.TestPiece      EQU $ - 1                                                       ; код проверки случайно выбранного бита карты
                JR NZ, .ChoosePiece                                             ; переход, если выбранная часть карты уже открыта и требуется другой случайный выбор

                SET PIECE_INDEX_BIT, (HL)                                       ; начальный номер бита шаблонов BIT/SET карты головоломки, фактический номер 0..4 переписывается вычисленным opcode перед выполнением
.OpenPiece      EQU $ - 1                                                       ; код установки случайно выбранного бита карты
                RET

.Defender       DB #00                                                          ; ID прежнего владельца замка
                DB #01, #01, #01, #01, #01, #01, #01, #01
.HelpOffer      EQU $+7                                                         ; предложение поддержки перед штурмом
                DB #01, #02, #02, #02, #03, #03, #04, #11
                DB #00, #1A, #8C, #EB, #20, #A1, #EB, #20
                DB #E5, #AE, #E2, #A5, #AB, #A8, #20, #AF
                DB #AE, #AC, #AE, #E7, #EC, #0D, #2A, #A2
                DB #A0, #AC, #20, #A2, #20, #A7, #A0, #E5
                DB #A2, #A0, #E2, #A5, #0D, #2A, #ED, #E2
                DB #AE, #A3, #AE, #20, #A7, #A0, #AC, #AA
                DB #A0, #2E, #0D, #2A, #0D, #00, #9F, #20
                DB #AE, #E2, #AA, #A0, #A7, #EB, #A2, #A0
                DB #EE, #E1, #EC, #0D, #2A, #8A, #A0, #AA
                DB #20, #A2, #A0, #AC, #20, #E3, #A3, #AE
.HelpMenu       EQU $+6                                                         ; меню принятия предложенной поддержки
                DB #A4, #AD, #AE, #0D, #2A, #00, #02, #0A
                DB #82, #96, #9C, #32, #86, #01, #11, #13
.DefeatText     EQU $+5                                                         ; первое сообщение о проигранном штурме
                DB #12, #01, #12, #13, #13, #92, #EB, #20
                DB #A1, #EB, #AB, #20, #E5, #AE, #E0, #AE
                DB #E8, #2C, #20, #AD, #AE, #20, #E2, #EB
                DB #20, #A1, #EB, #AB, #20, #E1, #AB, #A0
                DB #A1, #2C, #0D, #2A, #AD, #AE, #20, #AD
                DB #A5, #20, #E0, #A0, #E1, #E1, #E2, #E0
                DB #A0, #A8, #A2, #A0, #A9, #E1, #EF, #3A
                DB #0D, #2A, #93, #AF, #AE, #E0, #E1, #E2
                DB #A2, #AE, #20, #A3, #AE, #E0, #AE, #A4
                DB #A0, #20, #A1, #A5, #E0, #A5, #E2, #2C
                DB #0D, #2A, #A8, #20, #A7, #A0, #AC, #AA
                DB #A8, #20, #E2, #AE, #A6, #A5, #2E, #2E
.DefeatReturn   EQU $+4                                                         ; сообщение о неудачном штурме и возврате
                DB #2E, #0D, #2A, #00, #92, #A5, #E0, #AF
                DB #A8, #2C, #20, #AA, #A0, #A7, #A0, #AA
                DB #2C, #20, #A0, #E2, #A0, #AC, #A0, #AD
                DB #AE, #AC, #20, #A1, #E3, #A4, #A5, #E8
.RulerDefeated  EQU $+5                                                         ; сообщение о лишившемся последнего замка правителе
                DB #EC, #2E, #0D, #2A, #00, #0E
.LostRulerName  DW #0000                                                        ; адрес имени правителя, потерявшего последний замок
                DB #0D, #2A, #AE, #E2, #AD, #EB, #AD, #A5
                DB #20, #AD, #A5, #20, #A1, #E3, #A4, #A5
                DB #E2, #20, #E3, #A3, #E0, #AE, #A6, #A0
                DB #E2, #EC, #20, #AB, #EE, #A4, #EF, #AC
                DB #2C, #0D, #2A, #A8, #A1, #AE, #20, #AF
                DB #AE, #E1, #AB, #A5, #A4, #AD, #A8, #A9
                DB #20, #A8, #A7, #20, #A5, #A3, #AE, #20
                DB #A7, #A0, #AC, #AA, #AE, #A2, #20, #A7
                DB #A0, #E5, #A2, #A0, #E7, #A5, #AD, #2C
                DB #0D, #2A, #A0, #20, #E1, #A0, #AC, #20
                DB #AE, #AD, #20, #AF, #AE, #A3, #A8, #A1
                DB #20, #A2, #20, #A1, #A8, #E2, #A2, #A5
.RulerSurvived  EQU $+4                                                         ; сообщение о правителе, сохранившем другие замки
                DB #2E, #0D, #2A, #00, #0E
.RulerName      DW #0000                                                        ; адрес имени правителя, сохранившего другие замки
                DB #0D, #2A, #AF, #AE, #E2, #A5, #E0, #EF
                DB #AB, #20, #AE, #A4, #A8, #AD, #20, #A8
                DB #A7, #20, #E1, #A2, #AE, #A8, #E5, #20
                DB #A7, #A0, #AC, #AA, #AE, #A2, #2C, #0D
                DB #2A, #AD, #AE, #20, #AD, #A5, #20, #AE
                DB #A1, #AE, #AB, #EC, #E9, #A0, #A9, #E2
                DB #A5, #E1, #EC, #2C, #0D, #2A, #AE, #AD
                DB #20, #A5, #E9, #A5, #20, #A4, #A0, #AB
                DB #A5, #AA, #AE, #20, #AD, #A5, #20, #AF
                DB #AE, #A1, #A5, #A6, #A4, #A5, #AD, #2E
.VictoryText    EQU $+5                                                         ; сообщение о победе и вознаграждении
                DB #2E, #2E, #0D, #2A, #00, #8F, #AE, #A1
                DB #A5, #A4, #A0, #20, #21, #0D, #2A, #0D
                DB #00, #82, #A0, #AC, #20, #E3, #A4, #A0
                DB #AB, #AE, #E1, #EC, #20, #A7, #A0, #E5
                DB #A2, #A0, #E2, #A8, #E2, #EC, #0D, #2A
                DB #ED, #E2, #AE, #E2, #20, #A7, #A0, #AC
                DB #AE, #AA, #2C, #20, #A8, #20, #AE, #E2
                DB #AD, #EB, #AD, #A5, #20, #AE, #AD, #0D
                DB #2A, #AF, #E0, #A8, #AD, #A0, #A4, #AB
                DB #A5, #A6, #A8, #E2, #20, #A2, #A0, #AC
                DB #2E, #0D, #2A, #82, #EB, #20, #AF, #AE
                DB #AB, #E3, #E7, #A0, #A5, #E2, #A5, #20
.PrizeMoney     EQU $+1                                                         ; пятибайтная сумма первой награды в сообщении
                DB #10, #00, #00, #00, #00, #00, #00, #AC
                DB #AE, #AD, #A5, #E2, #0D, #2A, #A2, #20
                DB #AA, #A0, #E7, #A5, #E1, #E2, #A2, #A5
                DB #20, #A2, #AE, #A7, #AD, #A0, #A3, #E0
                DB #A0, #A6, #A4, #A5, #AD, #A8, #EF, #2E
.ContractReward EQU $+3                                                         ; текст повышенной награды за контрактный замок
                DB #0D, #2A, #00, #8A, #E0, #AE, #AC, #A5
                DB #20, #E2, #AE, #A3, #AE, #20, #AF, #AE
                DB #20, #AA, #AE, #AD, #E2, #E0, #A0, #AA
                DB #E2, #E3, #0D, #2A, #A7, #A0, #20, #A7
                DB #A0, #E5, #A2, #A0, #E2, #20, #ED, #E2
                DB #AE, #A3, #AE, #20, #A7, #A0, #AC, #AA
                DB #A0, #0D, #2A, #A2, #EB, #20, #AF, #AE
                DB #AB, #E3, #E7, #A0, #A5, #E2, #A5, #20
.RewardMoney    EQU $+1                                                         ; пятибайтная вычисленная сумма награды в тексте контракта
                DB #10, #00, #00, #00, #00, #00, #00, #AC
                DB #AE, #AD, #A5, #E2, #2E, #0D, #2A, #00
.CaptureReward  EQU $                                                           ; текст обычной награды за взятие замка
                DB #93, #20, #A2, #A0, #E1, #20, #AD, #A5
                DB #E2, #20, #AA, #AE, #AD, #E2, #E0, #A0
                DB #AA, #E2, #A0, #20, #AD, #A0, #20, #A7
                DB #A0, #E5, #A2, #A0, #E2, #0D, #2A, #ED
                DB #E2, #AE, #A3, #AE, #20, #A7, #A0, #AC
                DB #AA, #A0, #2C, #20, #AF, #AE, #ED, #E2
                DB #AE, #AC, #E3, #0D, #2A, #A4, #AE, #AF
                DB #AE, #AB, #AD, #A8, #E2, #A5, #AB, #EC
                DB #AD, #AE, #20, #A2, #EB, #20, #AD, #A8
                DB #E7, #A5, #A3, #AE, #0D, #2A, #AD, #A5
                DB #20, #AF, #AE, #AB, #E3, #E7, #A8, #E2
.CastleTitle    EQU $+5                                                         ; заголовок осматриваемого замка
                DB #A5, #2E, #0D, #2A, #00, #87, #A0, #AC
                DB #AE, #AA, #20, #0E
.CastleName     DW #0000                                                        ; адрес имени штурмуемого замка
.BanditOwner    EQU $+3                                                         ; текст о замке без известного правителя
                DB #0D, #2A, #00, #90, #A0, #A7, #AB, #A8
                DB #E7, #AD, #EB, #A5, #20, #A3, #E0, #E3
                DB #AF, #AF, #EB, #20, #AC, #AE, #AD, #E1
.RulerOwner     EQU $+7                                                         ; формат владельца замка с подставляемым именем правителя
                DB #E2, #E0, #AE, #A2, #0D, #2A, #00, #0E
.DefenderName   DW #0000                                                        ; адрес имени защитника для предложения боя
                DB #20, #A8, #20, #A5, #A3, #AE, #20, #A0
.AttackQuestion EQU $+7                                                         ; вопрос о начале штурма замка
                DB #E0, #AC, #A8, #EF, #0D, #2A, #00, #A7
                DB #A0, #E5, #A2, #A0, #E2, #A8, #AB, #A8
                DB #20, #ED, #E2, #AE, #E2, #20, #A7, #A0
                DB #AC, #AE, #AA, #2E, #2E, #2E, #0D, #2A
.NoSiegeText    EQU $+1                                                         ; отказ в штурме без осадных орудий
                DB #00, #97, #E2, #AE, #A1, #EB, #20, #E1
                DB #E0, #A0, #A7, #A8, #E2, #EC, #E1, #EF
                DB #20, #E1, #20, #AE, #A1, #A8, #E2, #A0
                DB #E2, #A5, #AB, #EF, #AC, #A8, #20, #A7
                DB #A0, #AC, #AA, #A0, #0D, #2A, #A2, #A0
                DB #AC, #20, #AD, #E3, #A6, #AD, #AE, #20
                DB #AE, #A1, #E0, #E3, #E8, #A8, #E2, #EC
                DB #20, #A5, #A3, #AE, #20, #E1, #E2, #A5
                DB #AD, #EB, #2C, #0D, #2A, #A0, #20, #A4
                DB #AB, #EF, #20, #ED, #E2, #AE, #A3, #AE
                DB #20, #AD, #E3, #A6, #AD, #EB, #20, #AE
                DB #E1, #A0, #A4, #AD, #EB, #A5, #20, #AE
                DB #E0, #E3, #A4, #A8, #EF, #2E, #0D, #2A
                DB #00, #6F, #76, #65, #72, #6C, #61, #79

                assert $ = #B970
                endmodule
                endmodule
