
; -----------------------------------------
; построить восемь соседних клеток в порядке приближения к цели
; Engine.GetDirection выбирает одно из восьми направлений от BC к DE, DirectionFns содержит генераторы
; Candidates сначала заполняется восемью одинаковыми записями Status=0, X=C, Y=B
; вычисленный RET запускает генератор Neighbours, следующий RET передаёт таблицу ClassifyCells
; ClassifyCells проверяет границы, препятствия и армии, затем возвращает сохранённые регистры
; In:
;   DE цель, BC исходная клетка
; Out:
;   ClassifyCells.Candidates восемь записей FBattleCell в порядке приоритета направления
; Corrupt:
;   таблица Candidates и код TestObstacle.ColumnTest, HL, DE, BC, AF, IX и IY восстановлены
; -----------------------------------------
BuildNeighbours PUSH IY
                PUSH IX
                PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                CALL Engine.GetDirection                                        ; определить одно из восьми направлений от BC к DE
                LD HL, Battle.ClassifyCells.DirectionFns

                ; выбор генератора порядка соседей по направлению к цели
.DirectionEntry DEC A
                JR Z, .BuildCells                                               ; переход, если достигнута запись выбранного направления

                INC HL
                INC HL
                JR .DirectionEntry

                ; подготовка возвратов, сначала генератор координат, затем проверка заполненной таблицы кандидатов
.BuildCells     LD DE, Battle.ClassifyCells                                     ; вычисленный RET передаёт созданные координаты проверке кандидатов
                PUSH DE
                LD E, (HL)
                INC HL
                LD D, (HL)
                PUSH DE
                LD HL, Battle.ClassifyCells.Candidates
                LD A, #08

                ; инициализация восьми трёхбайтовых записей исходной клеткой, статус 0 до проверки занятости
.CellLoop       LD (HL), #00
                INC HL
                LD (HL), C
                INC HL
                LD (HL), B
                INC HL
                DEC A
                JR NZ, .CellLoop                                                ; переход, если ещё не заполнены все восемь кандидатов

                LD IY, Battle.ClassifyCells.Candidates
                RET
