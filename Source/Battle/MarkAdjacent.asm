
; -----------------------------------------
; пометить отряды героя, стоящие не далее одной клетки от заданной
; у всех FCED сбрасывает бит 5 поля +9, абсолютные разности координат с L/H проверяет на 0 либо 1
; по каждой оси, подходящие записи получают бит 5 и переменная E5AA становится FF, пустой ID
; завершает список
; In:
;   HL клетка, L столбец, H строка
; Out:
;   Z=1 рядом никого, Z=0 найден отряд, IX и BC сохранены
; Corrupt:
;   DE, AF, бит 5 поля +9 у отрядов FCED, операнд E5AA, HL, BC, IX, IY сохранены
; -----------------------------------------
MarkAdjacent    PUSH IX
                PUSH BC
                LD IX, Battle.FinishField.HeroArmy
                LD B, #05
                XOR A
                LD (Battle.MarkAdjacent.Result), A
.UnitLoop       RES UNIT_MARK_BIT, (IX + FBattleUnit.Flags)                     ; +#09, флаг, временная отметка соседства или кандидата в текущем проходе выбора цели
                LD A, (IX + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                OR A
                JR Z, .ReturnResult                                             ; переход, если список отрядов героя завершён

                LD A, L
                SUB (IX + FBattleUnit.X)                                        ; +#0A, колонка 0..7
                JR Z, .CheckDeltaY                                              ; переход, если цель находится в том же столбце

                JR NC, .CheckDeltaX                                             ; переход, если разность столбцов неотрицательна

                NEG
.CheckDeltaX    DEC A
                JR NZ, .NextUnit                                                ; переход, если расстояние по горизонтали больше единицы

.CheckDeltaY    LD A, H
                SUB (IX + FBattleUnit.Y)                                        ; +#0B, строка 0..4
                JR Z, .MarkNeighbour                                            ; переход, если цель находится в той же строке

                JR NC, .LimitDeltaY                                             ; переход, если разность строк неотрицательна

                NEG
.LimitDeltaY    DEC A
                JR NZ, .NextUnit                                                ; переход, если расстояние по вертикали больше единицы

.MarkNeighbour  SET UNIT_MARK_BIT, (IX + FBattleUnit.Flags)                     ; +#09, флаг, временная отметка соседства или кандидата в текущем проходе выбора цели
                CPL
                LD (Battle.MarkAdjacent.Result), A
.NextUnit       LD DE, #0012
                ADD IX, DE
                DJNZ .UnitLoop

.Result         EQU $+1                                                         ; операнд возвращаемого признака наличия соседнего отряда героя
.ReturnResult   LD A, #00
                OR A
                POP BC
                POP IX
                RET
