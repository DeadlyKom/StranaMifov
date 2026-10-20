
; -----------------------------------------
; определить тип объекта в координатах #8D29
; проверяет специальные позиции #6A44/#6A4B для текущего континента, возвращает C=10/11 при
; совпадении, иначе бит 7 карты и девять групп из таблицы #8D41, #8D6E ищет запись, C=1..9 тип
; группы, C=0 отсутствие объекта
; In:
;   #8D29 координаты искомой клетки, #6A2D текущий континент
; Out:
;   BC, C тип 0..11, IX запись при типах 1..9, при специальных типах 10/11 указатель IX не
;   гарантируется
; Corrupt:
;   HL, DE, BC, AF, IX, IY, логический банк 0 остаётся выбранным, EI
; -----------------------------------------
FindMapObject   XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD BC, (State.ObjectCell)
                LD A, (State.Continent)
                LD E, A
                LD A, (State.GoodStoryMap)
                CP E
                JR NZ, .CheckStory                                              ; переход, если добрая сюжетная точка находится на другом континенте

                LD HL, (State.GoodStoryPos)
                OR A
                SBC HL, BC
                JR NZ, .CheckStory                                              ; переход, если координаты не совпали с доброй сюжетной точкой

                LD C, #0A
                RET

.CheckStory     LD A, (State.BadStoryMap)
                CP E
                JR NZ, .ReadCell                                                ; переход, если злая сюжетная точка находится на другом континенте

                LD HL, (State.BadStoryPos)
                OR A
                SBC HL, BC
                JR NZ, .ReadCell                                                ; переход, если координаты не совпали со злой сюжетной точкой

                LD C, #0B
                RET

.ReadCell       LD BC, (State.ObjectCell)
                CALL ReadMapCell                                                ; прочитать байт клетки текущей карты
                BIT MAP_BUSY_BIT, A                                             ; клетка стратегической карты занята объектом
                JR NZ, .FindGroup                                               ; переход, если клетка помечена занятой стратегическим объектом

                LD C, #00
                RET

                ; поиск занятой клетки среди групп стратегических объектов
.FindGroup      LD IY, Engine.FindMapObject.ObjectGroups
                LD B, #09
.GroupLoop      PUSH BC
                LD D, #00
                LD E, (IY + FMapGroup.Stride)
                LD B, (IY + FMapGroup.Rows)
                LD C, (IY + FMapGroup.Columns)
                LD L, (IY + FMapGroup.Lists.Low)
                LD H, (IY + FMapGroup.Lists.High)
                PUSH HL
                POP IX
                LD HL, #0000
                CALL FindRecord                                                 ; найти активную запись группы, покрывающую координату HL
                POP BC
                OR A
                JR NZ, .ReturnType                                              ; переход, если в текущей группе найдена занимающая клетку запись

                LD DE, #0005
                ADD IY, DE
                DJNZ .GroupLoop

                LD C, #00
                RET

                ; номер найденной группы становится кодом объекта для диспетчера
.ReturnType     LD A, #0A
                SUB B
                LD C, A
                RET

.ObjectGroups   EQU $                                                           ; девять описателей FMapGroup для поиска типа объекта
                DB #E9, #6A, #23, #02, #03, #F9, #6A, #1A
                DB #01, #01, #09, #6B, #05, #02, #02, #19
                DB #6B, #06, #01, #01, #29, #6B, #06, #01
                DB #01, #39, #6B, #06, #01, #01, #49, #6B
                DB #06, #01, #01, #59, #6B, #03, #01, #01
                DB #69, #6B, #06, #01, #01
