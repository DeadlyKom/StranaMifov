
; -----------------------------------------
; проверить границы, препятствия и занятость восьми соседних клеток
; каждая запись FBattleCell содержит Status, X и Y, поле боя имеет восемь столбцов и пять строк
; выход координаты за край или TestObstacle дают статус 1, FindUnitAtCell ищет обе армии
; отряд героя даёт статус 2, противника 3, свободная клетка сохраняет статус 0
; в конце восстанавливается кадр регистров BuildNeighbours, возврат идёт к его вызывающему коду
; In:
;   Candidates после одного из генераторов Neighbours
; Out:
;   статусы восьми кандидатов заполнены
; Corrupt:
;   таблица Candidates и код TestObstacle.ColumnTest, HL, DE, BC, AF, IX и IY восстановлены
; -----------------------------------------
ClassifyCells   LD IY, Battle.ClassifyCells.Candidates
                LD B, #08

                ; проверка границ поля 8 на 5 и содержимого очередной клетки-кандидата
.NeighbourLoop  PUSH BC
                LD C, (IY + FBattleCell.X)
                LD B, (IY + FBattleCell.Y)
                LD A, B
                CP #05
                JR Z, .BlockedCell                                              ; переход, если строка вышла за нижний край поля

                CP #FF
                JR Z, .BlockedCell                                              ; переход, если строка вышла за верхний край поля

                LD A, C
                CP #08
                JR Z, .BlockedCell                                              ; переход, если столбец вышел за правый край поля

                CP #FF
                JR Z, .BlockedCell                                              ; переход, если столбец вышел за левый край поля

                CALL TestObstacle                                               ; проверить препятствие выбранной клетки
                JR Z, .TestHeroCell                                             ; переход, если в клетке нет препятствия

                ; отметка недопустимой или непроходимой клетки значением статуса 1
.BlockedCell    LD (IY + FBattleCell.Status), #01
                JR .NextNeighbour

                ; поиск отряда героя в свободной от препятствия клетке, найденная цель получает статус 2
.TestHeroCell   LD IX, Battle.FinishField.HeroArmy
                CALL FindUnitAtCell                                             ; найти отряд с заданными координатами в одной армии
                JR NZ, .TestEnemyCell                                           ; переход, если отряд героя в клетке отсутствует

                LD (IY + FBattleCell.Status), #02
                JR .NextNeighbour

                ; поиск отряда противника, найденная цель получает статус 3
.TestEnemyCell  LD IX, Battle.FinishField.EnemyArmy
                CALL FindUnitAtCell                                             ; найти отряд с заданными координатами в одной армии
                JR NZ, .NextNeighbour                                           ; переход, если отряд противника в клетке отсутствует

                LD (IY + FBattleCell.Status), #03

                ; переход к следующей трёхбайтовой записи кандидата
.NextNeighbour  INC IY
                INC IY
                INC IY
                POP BC
                DJNZ .NeighbourLoop

                POP AF
                POP BC
                POP DE
                POP HL
                POP IX
                POP IY
                RET

.Candidates     DB #00                                                          ; восемь записей кандидатов FBattleCells, статус, X и Y
.FirstCoords    DB #00, #00, #00, #00, #00, #00, #00                            ; координаты первого кандидата, младший X и старший Y
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
.BackupCells    EQU $                                                           ; сохранённая копия восьми кандидатов для двухшагового поиска отхода ИИ
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
.MoveTarget     DW #0000                                                        ; указатель выбранного отряда, к которому направляется ИИ
.MovingUnit     DW #0000                                                        ; указатель перемещаемого отряда ИИ
.DirectionFns   DB #7D, #E6, #A2, #E6                                           ; восемь указателей генераторов порядка соседних клеток
                DB #C7, #E6, #EC, #E6, #11, #E7, #36, #E7
                DB #5B, #E7, #80, #E7
