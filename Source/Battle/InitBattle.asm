
; -----------------------------------------
; инициализировать армии, препятствия, фон и начальные объекты боя
; сохраняет A, DE, BC, IX в FCB8..FCBE, 883A создаёт FD47 и FCED из исходных трёхбайтных записей,
; бит 7 меняет координатную таблицу, пустая армия героя сразу возвращает FF со снятием адреса
; возврата, F4A3 записывает оценки в 6567/656C, FCE7 обнуляется, режимы <6 генерируют маску FCE8
; как случайное AND с 7E и отвергают общий бит в любых трёх соседних строках, режимы >=6 и бит 7
; используют таблицы, создаёт сорок объектов от 6611 с шагом 20, ресурсы местности имеют шаг 144,
; F4F4 создаёт отряды, продолжение FB87..FCB7 обязательно входит в эту процедуру
; In:
;   DE сила противника, BC число записей и банк, A тип, IX исходная армия противника
; Out:
;   FCED/FD47 армии, FCE8 препятствия, 6611 объекты поля подготовлены
; Corrupt:
;   HL, DE, BC, AF, IX, IY, параметры FCB8..FCBE, армии FCED/FD47, оценки 6567/656C, маска
;   FCE8..FCEC, объекты поля, экран и состояние генератора, ранняя ветка пустой армии удаляет
;   внутренний адрес возврата со стека
; -----------------------------------------
InitBattle      CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD (Battle.FinishField.FieldKind), A
                LD (Battle.FinishField.EnemyMana), DE
                LD A, C
                LD (Battle.FinishField.SourceBank), A
                LD A, B
                LD (Battle.FinishField.SourceCount), A
                LD (Battle.FinishField.SourceArmy), IX
                LD A, (Battle.FinishField.FieldKind)
                BIT FIELD_SPEC_BIT, A                                           ; флаг, особый режим боя с готовой маской поля и создаваемой армией противника
                JR NZ, .GeneratedArmy                                           ; переход, если бой требует сгенерированную армию

                LD HL, Battle.FinishField.EnemyCells                            ; пять исходных клеток противника у правого края поля
                LD IY, Battle.FinishField.EnemyArmy
                LD A, (Battle.FinishField.FieldKind)
                CALL Engine.BuildArmy                                           ; преобразовать состав армии в пять боевых записей по 18 байт
                LD HL, Battle.FinishField.HeroStartCells
                LD A, (Battle.FinishField.FieldKind)
                CP #08
                JR NZ, .HeroArmy                                                ; переход, если тип боя не требует особого построения армии 8

                LD HL, Battle.FinishField.HeroTightCells                        ; пять исходных клеток героя для специального режима8
.HeroArmy       LD IX, State.Army
                LD IY, Battle.FinishField.HeroArmy
                LD BC, #0503
                CALL Engine.BuildArmy                                           ; преобразовать состав армии в пять боевых записей по 18 байт
                JR .TestHeroArmy

.GeneratedArmy  LD HL, Battle.FinishField.InnerCells                            ; пять исходных клеток противника для сгенерированной армии
                LD IY, Battle.FinishField.EnemyArmy
                LD A, (Battle.FinishField.FieldKind)
                AND #7F
                CALL Engine.BuildArmy                                           ; преобразовать состав армии в пять боевых записей по 18 байт
                LD HL, Battle.FinishField.HeroStartCells
                LD IX, State.Army
                LD IY, Battle.FinishField.HeroArmy
                LD BC, #0503
                LD A, (Battle.FinishField.FieldKind)
                AND #7F
                CALL Engine.BuildArmy                                           ; преобразовать состав армии в пять боевых записей по 18 байт
.TestHeroArmy   LD A, (Battle.FinishField.HeroArmy)
                OR A
                JR NZ, .CompareValues                                           ; переход, если армия героя содержит хотя бы один отряд

                CALL DefeatStory                                                ; обработать сюжетные последствия поражения
                LD A, #01
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD HL, State.FloatA
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD HL, State.FloatB
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD BC, #0000
                LD DE, #1820
                LD A, #47
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD BC, #0603
                LD DE, #0518
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #08
                LD DE, Battle.FinishField.NoArmyText                            ; сообщение об отсутствии армии героя в начале боя
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #3C
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                XOR A
                CALL Engine.StackA                                              ; передать байт A на стек калькулятора ROM
                LD HL, State.Money
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                POP BC
                LD DE, (Battle.FinishField.EnemyMana)
                LD A, #FF
                RET

.CompareValues  LD IY, Battle.FinishField.EnemyArmy
                CALL ArmyValue                                                  ; сложить стоимостные оценки отрядов армии
                LD HL, State.FloatA
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
                LD IY, Battle.FinishField.HeroArmy
                CALL ArmyValue                                                  ; сложить стоимостные оценки отрядов армии
                LD HL, State.FloatB
                CALL Engine.StoreFloat5                                         ; сохранить вершину калькулятора в пятибайтное поле по HL
