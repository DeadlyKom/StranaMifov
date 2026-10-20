; оверлей 03 из OVR1
; исходный файл каталога 48, смещение #137C
                module Overlay
                module Temple
                org #B200

; -----------------------------------------
; посещение храма духов
; Читает тип храма и принадлежность героя к секте. Подготавливает стоимость услуг и коэффициенты
; скидки либо наценки через калькулятор ПЗУ. Меню предлагает перенос к ближайшему храму, изучение
; заклинания и вступление в секту. Перенос проверяет окружающие клетки подпрограммой
; CheckLanding, чтобы
; не поставить героя в занятое или запрещённое место.
; In:
;   текущее состояние героя, армии и объекта в ядре
; Out:
;   состояние обновлено выбранной ветвью либо сохранено при отказе
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; -----------------------------------------
Entry           CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                CALL Engine.ResetViewFlags                                      ; сбросить младшие шесть флагов 48 записей объектов
                LD A, #03
                CALL Engine.ShowScene                                           ; показать одну из девяти упакованных сцен BL1/BL2 с восстановлением банка и основных регистров
.TempleSetup    LD (CheckLanding.Temple), IX
                LD B, #00
                LD C, (IX + FTemple.Cult)                                       ; +#03, тип храма/секты
                LD HL, Overlay.Temple.CheckLanding.CultAttributes               ; пять атрибутов рамки, индексируемых значением FTemple.Cult
                ADD HL, BC
                LD A, (HL)
                LD (Entry.FrameAttr), A
                LD A, (IX + FTemple.Cult)                                       ; +#03, тип храма/секты
                CALL Engine.NthName                                             ; найти строку имени в списке с нулевыми разделителями
                LD (CheckLanding.CultName), DE
                LD (CheckLanding.CultNameAgain), DE

                ; стоимость услуг зависит от секты героя и принадлежности храма
.ServicePrices  XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (CheckLanding.Temple)
                LD BC, #07D0
                LD A, (State.Cult)
                OR A
                JR Z, .SpellPrice                                               ; переход, если герой ещё не принадлежит секте и наценка за чужую секту не нужна

                CP (IX + FTemple.Cult)                                          ; +#03, тип храма/секты
                JR Z, .SpellPrice                                               ; переход, если секта героя совпадает с сектой храма

                LD BC, #1770
.SpellPrice     LD (CheckLanding.TeleportCost), BC
                LD A, (IX + FTemple.Spell)                                      ; +#04, ID доступного для изучения заклинания
                CALL Engine.SpellDesc                                           ; получить описатель одного из десяти заклинаний
                LD (CheckLanding.SpellName), IX
                LD C, (IX + FSpell.ManaCost.Low)                                ; +#15, младший байт, магическая стоимость, также служит основанием цены изучения с множителем 100 и модификатором секты
                LD B, (IX + FSpell.ManaCost.High)                               ; +#16, старший байт, магическая стоимость, также служит основанием цены изучения с множителем 100 и модификатором секты
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                LD BC, #0064
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #04, #38                                                     ; multiply, умножение, B261
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (CheckLanding.Temple)
                LD A, (State.Cult)
                OR A
                JR Z, .StoreSpellCost                                           ; переход, если герой ещё не принадлежит секте и цена заклинания остаётся базовой

                CP (IX + FTemple.Cult)                                          ; +#03, тип храма/секты
                JR NZ, .CultMarkup                                              ; переход, если секта героя отличается от секты храма и применяется наценка

                LD A, #02
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05, #38                                                     ; division, деление, B27C
                JR .StoreSpellCost

.CultMarkup     LD A, #03
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #04, #38                                                     ; multiply, умножение, B286
.StoreSpellCost LD HL, CheckLanding.SpellCost
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD IX, (CheckLanding.Temple)
                LD C, (IX + FTemple.Cult)                                       ; +#03, тип храма/секты
                LD B, #00
                LD HL, Overlay.Temple.CheckLanding.CultFees                     ; пять коэффициентов стоимости вступления, индексируемых FTemple.Cult
                ADD HL, BC
                LD A, (HL)
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD BC, #2710
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #04, #38                                                     ; multiply, умножение, B2A6
                LD A, (State.Cult)
                OR A
                JR NZ, .StoreCultCost                                           ; переход, если вступление заменяет существующую секту и скидка новичку не нужна

                LD A, #02
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #05, #38                                                     ; division, деление, B2B4
.StoreCultCost  LD HL, CheckLanding.CultCost
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
.DrawMenu       LD A, #00
.FrameAttr      EQU $ - 1                                                       ; операнд цвета храмового окна
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD BC, #0F01
                LD DE, #011E
                LD A, #46
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD B, #10
                LD DE, Overlay.Temple.CheckLanding.WelcomeText                  ; формат названия храма и его культа
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD BC, #0F02
                LD DE, Engine.NeedMoreMoney.MoneyText                           ; общая надпись денежных средств
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, #0F0B
                CALL Engine.DrawNumber                                          ; преобразовать число и вывести символы подряд
                LD A, #03
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD B, #12
                LD DE, Overlay.Temple.CheckLanding.ServicesText                 ; надписи услуг храма с параметрами цены и заклинания
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IX, Overlay.Temple.CheckLanding.ServicesMenu                 ; описатель меню услуг храма
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #01
                JP NZ, .LearnChoice                                             ; переход, если выбран не перенос героя

                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, (CheckLanding.TeleportCost)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                JR NC, .PayTeleport                                             ; переход, если денег героя хватает на перенос

.NeedGold       CALL Engine.NeedMoreMoney                                       ; вывести сообщение о нехватке денег
                LD BC, #0014
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .DrawMenu

                ; после оплаты перенос ищет допустимую клетку вокруг нужного храма
.PayTeleport    LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD BC, (CheckLanding.TeleportCost)
                CALL Engine.StackBC                                             ; передать целое BC на стек калькулятора ROM
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #03, #38                                                     ; subtract, вычитание, B32E
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (CheckLanding.Temple)
                LD C, (IX + FTemple.X)                                          ; +#01, столбец карты
                LD B, (IX + FTemple.Y)                                          ; +#02, строка карты
                LD L, C
                LD H, B
                LD A, (State.Continent)
                LD E, A
                LD D, #03
                LD A, #05
                CALL Engine.NearestObject                                       ; найти ближайшую активную запись выбранной группы
                LD (CheckLanding.Temple), IX
                LD C, (IX + FTemple.X)                                          ; +#01, столбец карты
                LD B, (IX + FTemple.Y)                                          ; +#02, строка карты
                PUSH BC
                POP DE
                DEC B
                DEC C
                CALL CheckLanding
                INC C
                CALL CheckLanding
                INC C
                CALL CheckLanding
                INC C
                INC E
                CALL CheckLanding
                INC B
                CALL CheckLanding
                INC B
                CALL CheckLanding
                INC B
                INC D
                CALL CheckLanding
                DEC C
                CALL CheckLanding
                DEC C
                CALL CheckLanding
                DEC C
                DEC E
                CALL CheckLanding
                DEC B
                CALL CheckLanding
                DEC B
                CALL CheckLanding
.MoveHero       LD (State.MoveTarget), BC
                LD (State.Position), DE
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (CheckLanding.Temple)
                JP .TempleSetup

.LearnChoice    CP #02
                JR NZ, .CultChoice                                              ; переход, если выбран не пункт изучения заклинания

                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, CheckLanding.SpellCost
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                JP C, .NeedGold                                                 ; переход, если денег не хватает на изучение заклинания

                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (CheckLanding.Temple)
                LD C, (IX + FTemple.Spell)                                      ; +#04, ID доступного для изучения заклинания
                LD B, #00
                LD HL, State.Spells - 1                                         ; смещённая база состояний заклинаний, ID 1 приводит к первому байту State.Spells
                ADD HL, BC
                LD A, (HL)
                OR A
                JR Z, .LearnSpell                                               ; переход, если предлагаемое заклинание ещё не изучено

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD B, #11
                LD DE, Overlay.Temple.CheckLanding.SpellKnown                   ; отказ при уже изученном заклинании
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .DrawMenu

                ; изученное заклинание отмечается в десятибайтной таблице героя, затем
                ; списывается плата
.LearnSpell     LD A, #01
                LD (HL), A
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, CheckLanding.SpellCost
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #03, #38                                                     ; subtract, вычитание, B3F4
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                JP .DrawMenu

.CultChoice     CP #03
                JP NZ, .FinishMove                                              ; переход, если выбран не пункт вступления в секту

                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (CheckLanding.Temple)
                LD A, (State.Cult)
                CP (IX + FTemple.Cult)                                          ; +#03, тип храма/секты
                JR NZ, .CheckCultGold                                           ; переход, если герой выбирает новую для себя секту

                LD A, #42
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD B, #11
                LD DE, Overlay.Temple.CheckLanding.CultKnown                    ; отказ при уже выбранном культе
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP .DrawMenu

.CheckCultGold  LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, CheckLanding.CultCost
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                CALL Engine.FloatSignZero                                       ; определить знак и нулевое значение результата калькулятора
                JP C, .NeedGold                                                 ; переход, если денег не хватает на вступление в секту

                LD A, #47
                CALL Engine.BottomFrame                                         ; нарисовать окно в нижней части экрана
                LD B, #10
                LD DE, Overlay.Temple.CheckLanding.JoinCultText                 ; сообщение о плате за вступление и недельном взносе
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD HL, State.Money
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                LD HL, CheckLanding.CultCost
                CALL Engine.StackFloat5                                         ; передать пятибайтное число по HL на стек калькулятора
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #03, #38                                                     ; subtract, вычитание, B45A
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD A, (State.Cult)
                OR A
                JR Z, .CompactArmy                                              ; переход, если прежней секты не было и исключать её существ из армии не требуется

                LD HL, State.Army
                LD A, (State.Cult)
                LD (Entry.OldCult), A
                LD B, #05

                ; смена секты может удалить несовместимые отряды, после обхода армия уплотняется
.CheckArmyCult  LD A, (HL)
                OR A
                JR Z, .CompactArmy                                              ; переход, если достигнут конец заполненной части армии

                CALL Engine.UnitDesc                                            ; получить описатель типа отряда
                LD A, (IX + FSoldier.SectID)                                    ; +#11, секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость
                CP #05
                JR Z, .NextArmyUnit                                             ; переход, если тип существ имеет универсальную принадлежность к секте 5

                OR A
                JR Z, .NextArmyUnit                                             ; переход, если тип существ не принадлежит ни к одной секте

                CP #00
.OldCult        EQU $ - 1                                                       ; операнд секты, из которой герой выходит
                JR NZ, .NextArmyUnit                                            ; переход, если секта типа не совпадает с прежней сектой героя

                LD (HL), #00
.NextArmyUnit   INC HL
                INC HL
                INC HL
                DJNZ .CheckArmyCult

.CompactArmy    LD HL, State.Army
                LD B, #05
                CALL Engine.CompactArmy                                         ; сжать список трёхбайтных записей армии
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IX, (CheckLanding.Temple)
                LD A, (IX + FTemple.Cult)                                       ; +#03, тип храма/секты
                LD (State.Cult), A
                JP .ServicePrices

.FinishMove     CALL Engine.MoveToTarget                                        ; преобразовать направление к цели в команду движения героя
                RET

; -----------------------------------------
; проверка свободной клетки для телепортации
; Читает клетку BC через #80C4. Если установлен бит 7 либо ненулевые младшие 6 бит, возвращает
; управление перебору соседей. Для свободной клетки снимает адрес своего возврата POP HL и
; переходит непосредственно к успешной ветви Entry.MoveHero, обходя остаток перебора.
; In:
;   BC — координаты проверяемой клетки
; Out:
;   свободная клетка приводит к Entry.MoveHero, иначе обычный возврат
; Corrupt:
;   HL, AF
; -----------------------------------------
CheckLanding    CALL Engine.ReadMapCell                                         ; прочитать байт клетки текущей карты
                BIT MAP_BUSY_BIT, A                                             ; флаг, клетка стратегической карты занята объектом
                RET NZ                                                          ; выход, если клетка переноса занята объектом

                AND #3F
                RET NZ                                                          ; выход, если местность клетки переноса не допускает высадку

                POP HL
                JP Entry.MoveHero

.CultAttributes EQU $+1                                                         ; пять атрибутов рамки, индексируемых значением FTemple.Cult
.Temple         DW #0000                                                        ; адрес текущей записи храма
.WelcomeText    EQU $+4                                                         ; формат названия храма и его культа
                DB #41, #06, #45, #42, #82, #EB, #20, #AE
                DB #AA, #A0, #A7, #A0, #AB, #A8, #E1, #EC
                DB #20, #A2, #20, #95, #E0, #A0, #AC, #A5
                DB #20, #84, #E3, #E5, #AE, #A2, #20, #0E
.CultName       DW #0000                                                        ; адрес названия секты храма в приветствии
.ServicesText   EQU $+3                                                         ; надписи услуг храма с параметрами цены и заклинания
                DB #0D, #2A, #00, #8F, #A5, #E0, #A5, #AD
                DB #A5, #E1, #E2, #A8, #E1, #EC, #20, #A2
                DB #20, #A1, #AB, #A8, #A6, #A0, #A9, #E8
                DB #A8, #A9, #20, #E5, #E0, #A0, #AC, #20
                DB #0F
.TeleportCost   DW #0000                                                        ; цена переноса между храмами
                DB #00, #0D, #02, #8F, #AE, #A7, #AD, #A0
                DB #E2, #EC, #20, #A7, #A0, #AA, #AB, #A8
                DB #AD, #A0, #AD, #A8, #A5, #3A, #0D, #02
                DB #0E
.SpellName      DW #0000                                                        ; адрес имени предлагаемого для изучения заклинания
                DB #20, #10
.SpellCost      DB #00, #00, #00, #00, #00                                      ; пятибайтовая денежная цена изучения заклинания
                DB #00, #0D, #04, #91, #E2, #A0, #E2, #EC
                DB #20, #AF, #AE, #AA, #AB, #AE, #AD, #AD
                DB #A8, #AA, #AE, #AC, #20, #84, #E3, #E5
                DB #AE, #A2, #20, #0E
.CultNameAgain  DW #0000                                                        ; адрес названия секты храма в подписи услуг
                DB #0D, #02, #8F, #AE, #AA, #A8, #AD, #E3
                DB #E2, #EC, #20, #E5, #E0, #A0, #AC, #0D
.CultFees       EQU $+1                                                         ; пять коэффициентов стоимости вступления, индексируемых FTemple.Cult
.SpellKnown     EQU $+6                                                         ; отказ при уже изученном заклинании
                DB #02, #00, #0A, #0C, #09, #0E, #91, #EB
                DB #AD, #20, #AC, #AE, #A9, #2C, #20, #E0
                DB #A0, #E1, #E1, #E3, #A4, #AE, #AA, #20
                DB #E2, #A2, #AE, #A9, #20, #AF, #AE, #AC
                DB #E3, #E2, #A8, #AB, #E1, #EF, #2C, #0D
                DB #2A, #A8, #A1, #AE, #20, #A7, #A0, #E7
                DB #A5, #AC, #20, #AF, #AE, #A7, #AD, #A0
                DB #A2, #A0, #E2, #EC, #20, #E2, #AE, #2C
                DB #20, #E7, #E2, #AE, #20, #E3, #A6, #A5
                DB #0D, #2A, #A7, #AD, #A0, #A5, #E8, #EC
.JoinCultText   EQU $+5                                                         ; сообщение о плате за вступление и недельном взносе
                DB #20, #3F, #0D, #2A, #00, #87, #A0, #20
                DB #ED, #E2, #E3, #20, #E7, #A5, #E1, #E2
                DB #EC, #20, #A2, #EB, #20, #E3, #AF, #AB
                DB #A0, #E2, #A8, #AB, #A8, #0D, #2A, #10
.CultCost       DB #00, #00, #00, #00, #00                                      ; пятибайтовая денежная цена вступления в секту
                DB #00, #AC, #AE, #AD, #A5, #E2, #2E, #0D
                DB #2A, #8A, #E0, #AE, #AC, #A5, #20, #E2
                DB #AE, #A3, #AE, #20, #AA, #A0, #A6, #A4
                DB #E3, #EE, #20, #AD, #A5, #A4, #A5, #AB
                DB #EE, #20, #A2, #A0, #AC, #20, #AD, #A0
                DB #A4, #AE, #0D, #2A, #AE, #E2, #E7, #A8
                DB #E1, #AB, #EF, #E2, #EC, #20, #A2, #20
                DB #AF, #AE, #AB, #EC, #A7, #E3, #20, #AD
                DB #A0, #E8, #A5, #A3, #AE, #20, #E5, #E0
                DB #A0, #AC, #A0, #0D, #2A, #0F, #98, #3A
                DB #00, #AC, #AE, #AD, #A5, #E2, #2E, #0D
.CultKnown      EQU $+2                                                         ; отказ при уже выбранном культе
                DB #2A, #00, #91, #EB, #AD, #20, #AC, #AE
                DB #A9, #2C, #20, #EF, #20, #AD, #A5, #20
                DB #E1, #AE, #A2, #E1, #A5, #AC, #20, #AF
                DB #AE, #AD, #A8, #AC, #A0, #EE, #0D, #2A
                DB #E2, #A2, #AE, #A8, #20, #AD, #A0, #AC
                DB #A5, #E0, #A5, #AD, #A8, #EF, #2E, #0D
.ServicesMenu   EQU $+2                                                         ; описатель меню услуг храма
                DB #2A, #00, #04, #00, #80, #ED, #BF, #00
                DB #80, #01, #12, #1F, #13, #01, #13, #1F
                DB #14, #01, #15, #1F, #16, #01, #16, #1F
                DB #17, #6F, #76, #65, #72, #6C, #61, #79

                assert $ = #B66D
                endmodule
                endmodule
