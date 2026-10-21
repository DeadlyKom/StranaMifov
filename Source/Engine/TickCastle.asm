
; -----------------------------------------
; обновить угрозу замку, автоматически разрешить штурм либо подготовить перенос героя
; каждый вход сохраняет A в #A700 и ставит #69D8=1. U=#6AAA равен 0, новая угроза требует
; сброшенного бита 7 #6565 и R(200)<число своих активных замков, выбирает случайный порядковый
; номер своего замка, затем ближайший другой замок определяет владельца атакующей стороны,
; владелец 0 отменяет создание, #FF трактуется отдельными сообщениями о бандах. T=#6AAB=20+R(15),
; W=#A720=0. Состав 2..4 типов берётся из ближайших групп 4..7 на континенте замка, количества из
; NAEMARMY по сложности и текущему континенту героя. При U!=0 T=(T-A)AND255, для T>=5 R(400)=0
; отменяет угрозу, для 1..4 однократно показывается предупреждение. На T=0 перенос допустим при
; бите 0 #6A0D, сброшенном бите 7 #6565, томже континенте и магии не меньше 100*floor(расстояние),
; пункт 2 меню отменяет перенос. При согласии списывается цена, сохраняются прежние
; режим/координаты/армия, герой ставится внутрь замка, армия временно очищается, U и T=0
; сохраняются для O21. Иначе автоматический штурм, пустой гарнизон либо сила атаки>2*силы
; гарнизона дают захват, остальное успешную защиту. Сила атаки включает текущую магию правителя
; при U!=#FF. Успешная защита уменьшает количества на один случайный процент по сложности, захват
; уменьшает #6A02 на 40 с насыщением 0, меняет владельца и копирует 15 байт армии атаки в
; гарнизон. Обе автоматические ветви очищают U. Сам обработчик #D255 не вызывает
; In:
;   AF, A=0 при шаге без нового дня, A=1 при наступлении дня. #6AAA угроза, #6AAB дни, #6AAC
;   адрес замка, #69EE индекс сложности, #6A2D текущий континент, записи и банки игры
;   инициализированы
; Out:
;   без угрозы возможны создание новой угрозы на 20..35 дней и состава 2..4 отрядов. При
;   ожидании уменьшается счётчик, возможно предупреждение либо отмена. На сроке 0 выполняется
;   автоматическая защита/захват либо сохраняются исходные режим, координаты и армия для
;   переноса к замку
; Corrupt:
;   HL, DE, BC, AF, IX, IY и альтернативные регистры ROM не сохраняются. Меняются банки, IFF,
;   фоновые флаги, поля угрозы, операнды #A700/#A720 и другие рабочие поля. Точный набор
;   изменений зависит от ветви
; Note:
;   Вызов с A=0 также выполняет вероятностные проверки создания/отмены. Дни вычитаются в 8 битах
;   без насыщения. В существующей угрозе владелец и активность P повторно не проверяются. При
;   автоматической защите равенство двух сил остаётся победой гарнизона. Указатель количества
;   использует текущий континент героя, не континент замка. Деление на нулевую силу гарнизона
;   отдельно не защищено. Фактический бой начинается в O21 #B61A..#B63B, когда совпадает замок и
;   T<5, это отдельный путь. Названия битов отражают установленные условия обработчика
;   Назначение неиспользуемых позиций не установлено. Условия и эффекты сохранены в
;   Docs/CastleEventBranches.md
; -----------------------------------------
TickCastle      LD (Engine.TickCastle.ElapsedDays), A
                LD A, #01
                LD (State.EventMarker), A
                LD A, (State.Attacker)
                OR A
                JP NZ, .AdvanceDays                                             ; переход, если уже существует назначенный нападающий

                LD A, (State.EventFlags)
                BIT EVENT_LOCK_BIT, A                                           ; временно запрещает развитие отрядов, нападения на замок и магическое вмешательство
                RET NZ                                                          ; выход, если нападения временно запрещены режимом события

                CALL CountOwnCastles                                            ; подсчитать записи банка 0 по флагу и полю #13
                LD DE, #00C8
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                LD A, E
                CP C
                RET NC                                                          ; выход, если случайная проверка не выбрала нападение на собственные замки

                LD E, C
                DEC E
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                INC E
                LD B, E
                XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD IX, State.AllCastles - FCastle                               ; база перед первым физическим замком, цикл сначала прибавляет FCastle
                LD DE, #0023

                ; случайный выбор одного из собственных действующих замков
.FindCastle     ADD IX, DE
                BIT CASTLE_OFF_BIT, (IX + FCastle.Flags)                        ; замок выключен из обходов стратегических объектов и подсчёта владений
                JR NZ, .FindCastle                                              ; переход, если замок исключён из обработки

                LD A, (IX + FCastle.Owner)
                OR A
                JR NZ, .FindCastle                                              ; переход, если замок принадлежит не герою

                DJNZ .FindCastle

                LD (State.AttackCastle), IX
                LD IX, State.CastlesLists
                LD HL, (State.AttackCastle)
                CALL SelectThreshold                                            ; определить одну из четырёх категорий по порогам
                LD IX, (State.AttackCastle)
                LD (Engine.TickCastle.CastleMap), A
                LD E, A
                LD D, #01
                LD C, (IX + FCastle.X)
                LD B, (IX + FCastle.Y)
                LD L, C
                LD H, B
                LD A, #23
                CALL NearestObject                                              ; найти ближайшую активную запись выбранной группы
                LD A, (IX + FCastle.Owner)
                OR A
                RET Z                                                           ; выход, если ближайший возможный нападающий принадлежит герою

                LD (State.Attacker), A
                LD HL, (State.AttackCastle)
                INC HL
                INC HL
                INC HL
                LD (Engine.TickCastle.WarningName), HL
                CALL StopView                                                   ; выключить обработку объектов в прерывании
                LD BC, #0801
                LD DE, #081C
                LD A, #47
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0A
                LD DE, Engine.TickCastle.CastleNews                             ; сообщение с именем угрожаемого замка
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD A, (State.Attacker)
                LD DE, Engine.TickCastle.BanditNews                             ; сообщение об объединении окрестных банд
                CP #FF
                JR Z, .WarnAttack                                               ; переход, если нападение исходит от безымянных враждебных отрядов

                CALL RulerDesc                                                  ; получить описатель одного из пятнадцати вражеских правителей
                LD (Engine.TickCastle.WarningRuler), IX
                LD DE, Engine.TickCastle.RulerNews                              ; сообщение о сборе армии правителем
.WarnAttack     LD B, #0C
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD DE, #000F
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                LD A, #14
                ADD A, E
                LD (State.AttackDays), A
                XOR A
                LD (Engine.TickCastle.WarningShown), A
                LD HL, State.AttackArmy
                LD DE, State.AttackArmy + 1                                     ; следующий байт при очистке армии нападающих
                LD BC, #000E
                LD (HL), #00
                LDIR
                LD A, (State.Difficulty)
                LD HL, Data.Recruits.SpawnRanges - 5 * 25 * FTroopRange         ; смещённая база диапазонов, до первой сложности и континента пропускаются400+100байт
                LD DE, #0190

                ; таблица состава нападающих выбирается по сложности и континенту
.DifficultyData ADD HL, DE
                DEC A
                JR NZ, .DifficultyData                                          ; переход, если ещё не достигнута таблица выбранной сложности

                LD A, (State.Continent)
                LD DE, #0064
.ContinentData  ADD HL, DE
                DEC A
                JR NZ, .ContinentData                                           ; переход, если ещё не достигнута таблица выбранного континента

                LD (Engine.TickCastle.AttackRanges), HL
                XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD DE, #0002
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                LD A, E
                ADD A, #06
                LD (Engine.TickCastle.LastClass), A
                LD A, #04
                LD IY, State.AttackArmy

                ; формирование армии, которая нападёт на выбранный замок
.BuildAttackers PUSH AF
                LD D, A
.CastleMap      EQU $+1                                                         ; континент замка, выбранного для нападения
                LD E, #00
                LD IX, (State.AttackCastle)
                LD C, (IX + FCastle.X)
                LD B, (IX + FCastle.Y)
                LD A, #06
                LD HL, #0000
                CALL NearestObject                                              ; найти ближайшую активную запись выбранной группы
                LD A, (IX + FMapTroop.ID)
                LD (IY + FTroop.ID), A
.AttackRanges   EQU $+2                                                         ; таблица количества нападающих по типам существ
                LD IX, #0000
                LD D, #00
                DEC A
                SLA A
                SLA A
                LD E, A
                ADD IX, DE
                LD L, (IX + FTroopRange.BaseCount.Low)
                LD H, (IX + FTroopRange.BaseCount.High)
                LD E, (IX + FTroopRange.CountRange.Low)
                LD D, (IX + FTroopRange.CountRange.High)
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                ADD HL, DE
                LD (IY + FTroop.Count.Low), L
                LD (IY + FTroop.Count.High), H
                POP AF
                INC IY
                INC IY
                INC IY
                INC A
.LastClass      EQU $+1                                                         ; исключённая верхняя граница категорий нападающих
                CP #08
                JR NZ, .BuildAttackers                                          ; переход, если остались категории для формирования армии нападающих

                LD B, #14
                CALL WaitOrInput                                                ; выдержать паузу с досрочным выходом по вводу
                CALL RefreshHero                                                ; обновить боковую панель героя, расходы и рейтинг
                CALL UpdateLocalView                                            ; отметить открытые клетки вокруг героя и подготовить экранные объекты
                HALT
                RET

                ; обновление срока до нападения и разовая выдача предупреждения
.AdvanceDays    LD A, (State.AttackDays)
.ElapsedDays    EQU $+1                                                         ; число дней, вычитаемое из срока угрозы
                LD E, #00
                SUB E
                LD (State.AttackDays), A
                JR Z, .OfferDefense                                             ; переход, если срок до нападения истёк

                CP #05
                JR C, .CheckWarning                                             ; переход, если до нападения осталось меньше пяти дней

                LD DE, #0190
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                LD A, E
                OR D
                RET NZ                                                          ; выход, если случайная проверка сохранила угрозу нападения

                XOR A
                LD (State.Attacker), A
                LD A, #44
                LD DE, Engine.TickCastle.CancelledText                          ; сообщение об отмене угрозы нападения
                JR .DrawWarning

.WarningShown   EQU $+1                                                         ; признак уже показанного предупреждения об осаде
.CheckWarning   LD A, #00
                OR A
                RET NZ                                                          ; выход, если предупреждение об этом нападении уже показано

                LD A, #01
                LD (Engine.TickCastle.WarningShown), A
                LD DE, Engine.TickCastle.DeadlineText                           ; предупреждение об осаде за четыре дня
                LD A, #42
.DrawWarning    PUSH DE
                PUSH AF
                XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                CALL StopView                                                   ; выключить обработку объектов в прерывании
                LD BC, #0800
                LD DE, #071E
                POP AF
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD HL, (State.AttackCastle)
                INC HL
                INC HL
                INC HL
                LD (Engine.TickCastle.WarningName), HL
                LD B, #0A
                LD DE, Engine.TickCastle.CastleNews                             ; сообщение с именем угрожаемого замка
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD B, #0C
                POP DE
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD B, #FF
                CALL WaitOrInput                                                ; выдержать паузу с досрочным выходом по вводу
                CALL RefreshHero                                                ; обновить боковую панель героя, расходы и рейтинг
                CALL UpdateLocalView                                            ; отметить открытые клетки вокруг героя и подготовить экранные объекты
                HALT
                RET

                ; проверка возможности вмешательства героя в защиту замка
.OfferDefense   LD A, (State.DefenseSpell)
                BIT DEFENSE_OK_BIT, A                                           ; разрешает предложить магическое вмешательство героя в защиту замка
                JP Z, .ResolveSiege                                             ; переход, если у героя нет возможности магического вмешательства

                LD A, (State.EventFlags)
                BIT EVENT_LOCK_BIT, A                                           ; временно запрещает развитие отрядов, нападения на замок и магическое вмешательство
                JP NZ, .ResolveSiege                                            ; переход, если магическое вмешательство запрещено текущим событием

                LD IX, State.CastlesLists
                LD HL, (State.AttackCastle)
                CALL SelectThreshold                                            ; определить одну из четырёх категорий по порогам
                LD C, A
                LD A, (State.Continent)
                CP C
                JP NZ, .ResolveSiege                                            ; переход, если атакуемый замок находится на другом континенте

                XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD IX, (State.AttackCastle)
                LD BC, (State.Position)
                LD E, (IX + FCastle.X)
                LD D, (IX + FCastle.Y)
                CALL FloorDistance                                              ; вычислить целую часть евклидова расстояния
                CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
                LD A, #64
                CALL StackA                                                     ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #04                                                          ; multiply, умножение, A7A4
                DB #38                                                          ; end-calc, возврат в Z80, A7A5
                CALL PopBC                                                      ; извлечь результат калькулятора ROM в BC
                LD (State.ReturnCost), BC
                OR A
                LD HL, (State.Mana)
                SBC HL, BC
                JP C, .ResolveSiege                                             ; переход, если маны недостаточно для перемещения к осаде

                LD HL, (State.AttackCastle)
                INC HL
                INC HL
                INC HL
                LD (Engine.TickCastle.InterveneName), HL
                CALL StopView                                                   ; выключить обработку объектов в прерывании
                LD BC, #0800
                LD DE, #0A12
                LD A, #42
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0A
                LD DE, Engine.TickCastle.OfferText                              ; предложение магического вмешательства в защиту замка
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD IX, Engine.TickCastle.DefenseMenu                            ; два пункта меню согласия или отказа вмешаться
                CALL SelectMenuItem                                             ; управлять указателем и выбрать прямоугольный пункт меню
                CP #02
                JP Z, .ResolveSiege                                             ; переход, если игрок отказался вмешиваться в осаду

                XOR A
                LD (State.EventMarker), A
                LD HL, (State.Mana)
                LD BC, (State.ReturnCost)
                SBC HL, BC
                LD (State.Mana), HL
                LD A, (State.MoveFlags)
                LD (State.ReturnMode), A
                LD BC, (State.Position)
                LD (State.ReturnPosition), BC
                LD HL, State.Army
                LD DE, State.ReturnArmy
                LD BC, #000F
                LDIR
                LD IX, (State.AttackCastle)
                LD C, (IX + FCastle.X)
                LD B, (IX + FCastle.Y)
                INC C
                INC B
                LD (State.Position), BC
                INC B
                LD (State.MoveTarget), BC
                LD A, (State.MoveFlags)
                AND #FC
                LD (State.MoveFlags), A
                LD HL, State.Army
                LD DE, State.Army + 1                                           ; следующий байт при очистке армии героя перед переносом к осаде
                LD (HL), #00
                LD BC, #000E
                LDIR
                LD A, (State.MoveFlags)
                SET HERO_HIDE_BIT, A                                            ; временно исключает изображение героя из локального окна
                LD (State.MoveFlags), A
                CALL UpdateLocalView                                            ; отметить открытые клетки вокруг героя и подготовить экранные объекты
                LD A, (State.MoveFlags)
                RES HERO_HIDE_BIT, A                                            ; временно исключает изображение героя из локального окна
                LD (State.MoveFlags), A
                LD B, #01
                CALL WaitOrInput                                                ; выдержать паузу с досрочным выходом по вводу
                RET

                ; разрешение осады по силам нападающих и гарнизона
.ResolveSiege   XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD HL, (State.AttackCastle)
                INC HL
                INC HL
                INC HL
                LD (Engine.TickCastle.DefenseName), HL
                LD IX, (State.AttackCastle)
                LD A, (IX + FCastle.Army)
                OR A
                JP Z, .ClampLeader                                              ; переход, если у замка нет гарнизона для обороны

                LD A, #02
                CALL StackA                                                     ; передать байт A на стек калькулятора ROM
                LD HL, State.AttackArmy
                LD B, #05
                CALL SumArmyPower                                               ; сложить произведения количества отрядов на поле силы типа
                LD A, (State.Attacker)
                CP #FF
                JR Z, .ComparePowers                                            ; переход, если нападающий не имеет описателя правителя

                CALL RulerDesc                                                  ; получить описатель одного из пятнадцати вражеских правителей
                LD C, (IX + FRuler.Mana.Low)
                LD B, (IX + FRuler.Mana.High)
                CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F                                                          ; addition, сложение, A886
                DB #38                                                          ; end-calc, возврат в Z80, A887
.ComparePowers  LD HL, Engine.TickCastle.AttackPower                            ; пятибайтная сила нападающих с поправкой маны правителя
                CALL StoreFloat5                                                ; сохранить вершину калькулятора в пятибайтное поле по HL
                XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD HL, (State.AttackCastle)
                LD DE, #0014
                ADD HL, DE
                LD B, #05
                CALL SumArmyPower                                               ; сложить произведения количества отрядов на поле силы типа
                LD HL, Engine.TickCastle.DefensePower                           ; пятибайтная взвешенная сила гарнизона
                CALL StoreFloat5                                                ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD HL, Engine.TickCastle.AttackPower                            ; пятибайтная сила нападающих с поправкой маны правителя
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                LD HL, Engine.TickCastle.DefensePower                           ; пятибайтная взвешенная сила гарнизона
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05                                                          ; division, деление, A8B1
                DB #38                                                          ; end-calc, возврат в Z80, A8B2
                CALL FloatSignZero                                              ; определить знак и нулевое значение результата калькулятора
                JP C, .ClampLeader                                              ; переход, если сила нападения больше удвоенной силы гарнизона

                LD IX, Engine.TickCastle.LossRanges - FLossRange
                LD A, (State.Difficulty)
                SLA A
                LD D, #00
                LD E, A
                ADD IX, DE
                LD E, (IX + FLossRange.Range)
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                LD A, (IX + FLossRange.Base)
                ADD A, E
                LD (Engine.TickCastle.LossPercent), A
                LD IY, (State.AttackCastle)
                LD DE, #0014
                ADD IY, DE
                LD B, #05

                ; применение потерь гарнизона после успешной защиты
.GarrisonLoss   LD A, (IY + FTroop.ID)
                OR A
                JR Z, .ShowDefense                                              ; переход, если достигнут конец гарнизона при применении потерь

                PUSH BC
                PUSH IY
                LD C, (IY + FTroop.Count.Low)
                LD B, (IY + FTroop.Count.High)
                CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
                CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
.LossPercent    EQU $+1                                                         ; процент потерь гарнизона при успешной защите
                LD A, #00
                CALL StackA                                                     ; передать байт A на стек калькулятора ROM
                LD A, #64
                CALL StackA                                                     ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05                                                          ; division, деление, A8FF
                DB #04                                                          ; multiply, умножение, A900
                DB #03                                                          ; subtract, вычитание, A901
                DB #27                                                          ; int, округление вниз, A902
                DB #38                                                          ; end-calc, возврат в Z80, A903
                CALL PopBC                                                      ; извлечь результат калькулятора ROM в BC
                POP IY
                LD (IY + FTroop.Count.Low), C
                LD (IY + FTroop.Count.High), B
                POP BC
                INC IY
                INC IY
                INC IY
                DJNZ .GarrisonLoss

.ShowDefense    CALL StopView                                                   ; выключить обработку объектов в прерывании
                LD BC, #0800
                LD DE, #0712
                LD A, #44
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0A
                LD DE, Engine.TickCastle.CastleText                             ; вводная строка результата нападения на замок
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD DE, Engine.TickCastle.HeldText                               ; сообщение об успешной автоматической защите
.FinishReport   LD B, #0D
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD B, #28
                CALL WaitOrInput                                                ; выдержать паузу с досрочным выходом по вводу
                CALL UpdateLocalView                                            ; отметить открытые клетки вокруг героя и подготовить экранные объекты
                HALT
                CALL RefreshHero                                                ; обновить боковую панель героя, расходы и рейтинг
                XOR A
                LD (State.Attacker), A
                RET

.ClampLeader    LD HL, (State.Leadership)
                LD BC, #0028
                OR A
                SBC HL, BC
                JR NC, .CaptureCastle                                           ; переход, если штраф за потерю замка не уменьшил лидерство ниже нуля

                LD HL, #0000

                ; передача замка новому владельцу и копирование армии победителя
.CaptureCastle  LD (State.Leadership), HL
                LD IX, (State.AttackCastle)
                LD A, (State.Attacker)
                LD (IX + FCastle.Owner), A
                LD HL, (State.AttackCastle)
                LD DE, #0014
                ADD HL, DE
                EX DE, HL
                LD HL, State.AttackArmy
                LD BC, #000F
                LDIR
                CALL StopView                                                   ; выключить обработку объектов в прерывании
                LD BC, #0800
                LD DE, #0812
                LD A, #42
                CALL DrawFrame                                                  ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #0A
                LD DE, Engine.TickCastle.CastleText                             ; вводная строка результата нападения на замок
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD DE, Engine.TickCastle.BanditsText                            ; сообщение о захвате замка безымянными отрядами
                LD A, (State.Attacker)
                CP #FF
                JR Z, .FinishReport                                             ; переход, если замок захвачен безымянными враждебными отрядами

                CALL RulerDesc                                                  ; получить описатель одного из пятнадцати вражеских правителей
                LD (Engine.TickCastle.AttackerName), IX
                LD DE, Engine.TickCastle.CapturedText                           ; сообщение о захвате замка с именем нового владельца
                JR .FinishReport

.AttackPower    EQU $+5                                                         ; пятибайтная сила нападающих с поправкой маны правителя
.DefensePower   EQU $                                                           ; пятибайтная взвешенная сила гарнизона
                DB #00, #00, #00, #00, #00, #00, #00, #00
.LossRanges     EQU $+2                                                         ; три пары база/разброс процента потерь по сложности
                DB #00, #00, #05, #0A, #0A, #0F, #14, #1E
.CancelledText  EQU $                                                           ; сообщение об отмене угрозы нападения
                DB #82, #A5, #AB, #A8, #AA, #A8, #A5, #20
                DB #A1, #AE, #A3, #A8, #20, #AD, #A0, #20
                DB #A2, #A0, #E8, #A5, #A9, #20, #E1, #E2
                DB #AE, #E0, #AE, #AD, #A5, #2C, #20, #E1
                DB #E3, #A4, #A0, #E0, #EC, #0D, #2A, #A8
                DB #A1, #AE, #20, #E1, #AB, #E3, #E5, #A8
                DB #20, #AE, #20, #A2, #AE, #A7, #AC, #AE
                DB #A6, #AD, #AE, #AC, #20, #AD, #A0, #AF
                DB #A0, #A4, #A5, #AD, #A8, #A8, #0D, #2A
                DB #AD, #A5, #20, #AF, #AE, #A4, #E2, #A2
                DB #A5, #E0, #A4, #A8, #AB, #A8, #E1, #EC
.CastleText     EQU $+4                                                         ; вводная строка результата нападения на замок
                DB #2E, #0D, #2A, #00, #11, #00, #1A, #82
                DB #A0, #E8, #20, #A7, #A0, #AC, #AE, #AA
.DefenseName    EQU $+3                                                         ; поле подстановки имени замка в результат защиты
                DB #0D, #2A, #0E, #00, #00, #0D, #2A, #A1
                DB #EB, #AB, #20, #A0, #E2, #A0, #AA, #AE
.HeldText       EQU $+6                                                         ; сообщение об успешной автоматической защите
                DB #A2, #A0, #AD, #0D, #2A, #00, #11, #00
                DB #1A, #AD, #AE, #20, #A3, #A0, #E0, #AD
                DB #A8, #A7, #AE, #AD, #20, #A2, #20, #A7
                DB #A0, #AC, #AA, #A5, #0D, #2A, #E1, #E3
                DB #AC, #A5, #AB, #20, #AE, #E2, #A1, #A8
                DB #E2, #EC, #20, #AD, #A0, #AF, #A0, #A4
                DB #A5, #AD, #A8, #A5, #2E, #0D, #2A, #00
.BanditsText    EQU $                                                           ; сообщение о захвате замка безымянными отрядами
                DB #11, #00, #1A, #A8, #20, #A7, #A0, #E5
                DB #A2, #A0, #E7, #A5, #AD, #0D, #2A, #AE
                DB #AA, #E0, #A5, #E1, #E2, #AD, #EB, #AC
                DB #A8, #20, #A1, #A0, #AD, #A4, #A0, #AC
.CapturedText   EQU $+5                                                         ; сообщение о захвате замка с именем нового владельца
                DB #A8, #2E, #0D, #2A, #00, #11, #00, #1A
                DB #A8, #20, #A7, #A0, #E5, #A2, #A0, #E7
                DB #A5, #AD, #2C, #20, #AE, #E2, #AD, #EB
                DB #AD, #A5, #0D, #2A, #A5, #A3, #AE, #20
                DB #E5, #AE, #A7, #A0, #A8, #AD, #3A, #0D
.AttackerName   EQU $+2                                                         ; поле подстановки имени нападающего в результат боя
.OfferText      EQU $+7                                                         ; предложение магического вмешательства в защиту замка
                DB #2A, #0E, #00, #00, #0D, #2A, #00, #11
                DB #00, #1A, #82, #A0, #E8, #20, #A7, #A0
.InterveneName  EQU $+6                                                         ; поле подстановки имени замка в предложение вмешательства
                DB #AC, #AE, #AA, #0D, #2A, #0E, #00, #00
                DB #0D, #2A, #A0, #E2, #A0, #AA, #AE, #A2
                DB #A0, #AD, #20, #AD, #A5, #AF, #E0, #A8
                DB #EF, #E2, #A5, #AB, #A5, #AC, #2C, #0D
                DB #2A, #8D, #AE, #20, #E3, #20, #A2, #A0
                DB #E1, #20, #A5, #E9, #A5, #20, #E5, #A2
                DB #A0, #E2, #A8, #E2, #20, #E1, #A8, #AB
                DB #0D, #2A, #AF, #A5, #E0, #A5, #AD, #A5
                DB #E1, #E2, #A8, #E1, #EC, #20, #AA, #20
                DB #AD, #A5, #AC, #E3, #0D, #2A, #0D, #00
                DB #8F, #AE, #AB, #A5, #E2, #A5, #AB, #A8
                DB #20, #21, #0D, #2A, #91, #A0, #AC, #A8
                DB #20, #E0, #A0, #A7, #A1, #A5, #E0, #E3
.DefenseMenu    EQU $+7                                                         ; два пункта меню согласия или отказа вмешаться
                DB #E2, #EC, #E1, #EF, #0D, #2A, #00, #02
                DB #08, #78, #98, #A0, #32, #82, #01, #10
.DeadlineText   EQU $+6                                                         ; предупреждение об осаде за четыре дня
                DB #13, #11, #01, #11, #13, #12, #87, #A0
                DB #AC, #AE, #AA, #20, #A2, #20, #AE, #AF
                DB #A0, #E1, #AD, #AE, #E1, #E2, #A8, #2C
                DB #20, #E7, #A5, #E0, #A5, #A7, #20, #34
                DB #20, #A4, #AD, #EF, #0D, #2A, #AD, #A0
                DB #A7, #AD, #A0, #E7, #A5, #AD, #20, #E8
                DB #E2, #E3, #E0, #AC, #2C, #20, #AF, #AE
                DB #E2, #AE, #E0, #AE, #AF, #A8, #E2, #A5
                DB #E1, #EC, #0D, #2A, #E1, #E3, #A4, #A0
                DB #E0, #EC, #2E, #2E, #2E, #0D, #2A, #00
.CastleNews     EQU $                                                           ; сообщение с именем угрожаемого замка
                DB #88, #A7, #20, #A7, #A0, #AC, #AA, #A0
.WarningName    EQU $+2                                                         ; поле подстановки имени замка в предупреждение
                DB #20, #0E, #00, #00, #20, #A4, #AE, #AA
                DB #AB, #A0, #A4, #EB, #A2, #A0, #EE, #E2
.RulerNews      EQU $+4                                                         ; сообщение о сборе армии правителем
                DB #3A, #0D, #2A, #00, #82, #20, #AE, #AA
                DB #E0, #A5, #E1, #E2, #AD, #EB, #E5, #20
                DB #A3, #AE, #E0, #AE, #A4, #A0, #E5, #20
                DB #E5, #AE, #A4, #EF, #E2, #20, #E1, #AB
                DB #E3, #E5, #A8, #2C, #0D, #2A, #E7, #E2
.WarningRuler   EQU $+3                                                         ; поле подстановки имени правителя в предупреждение
                DB #AE, #20, #0E, #00, #00, #0D, #2A, #E1
                DB #AE, #A1, #A8, #E0, #A0, #A5, #E2, #20
                DB #A0, #E0, #AC, #A8, #EE, #2C, #20, #AD
                DB #A0, #AC, #A5, #E0, #A5, #A2, #A0, #EF
                DB #E1, #EC, #0D, #2A, #AD, #A0, #AF, #A0
                DB #E1, #E2, #EC, #20, #AD, #A0, #20, #AD
                DB #A0, #E8, #20, #A7, #A0, #AC, #AE, #AA
.BanditNews     EQU $+4                                                         ; сообщение об объединении окрестных банд
                DB #2E, #0D, #2A, #00, #8D, #A0, #E8, #A8
                DB #20, #E0, #A0, #A7, #A2, #A5, #A4, #E7
                DB #A8, #AA, #A8, #20, #AE, #E2, #AC, #A5
                DB #E7, #A0, #EE, #E2, #2C, #20, #E7, #E2
                DB #AE, #0D, #2A, #AE, #AA, #E0, #A5, #E1
                DB #E2, #AD, #EB, #A5, #20, #A1, #A0, #AD
                DB #A4, #EB, #2C, #20, #AD, #A0, #E7, #A8
                DB #AD, #A0, #EE, #E2, #0D, #2A, #AE, #A1
                DB #EA, #A5, #A4, #A8, #AD, #EF, #E2, #EC
                DB #E1, #EF, #2C, #20, #A5, #E1, #AB, #A8
                DB #20, #ED, #E2, #AE, #20, #AF, #E0, #AE
                DB #A8, #A7, #AE, #A9, #A4, #A5, #E2, #2C
                DB #0D, #2A, #E2, #AE, #20, #A7, #A0, #AC
                DB #AE, #AA, #20, #AE, #AA, #A0, #A6, #A5
                DB #E2, #E1, #EF, #20, #AF, #AE, #A4, #20
                DB #E3, #A3, #E0, #AE, #A7, #AE, #A9, #0D
                DB #2A, #00
