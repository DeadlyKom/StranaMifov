
; -----------------------------------------
; случайно переместить записи группы #6B39 в соседнюю свободную клетку
; активные 6 байтные записи текущего континента, сначала проверяет наличие свободной клетки типа 0
; в окрестности 3 на 3, если таких нет, запись остаётся, иначе выбирает Xold-1+RandomScaled(2) и
; Yold-1+RandomScaled(2) до свободной клетки типа 0, меняет координаты существующей записи, ставит
; бит 7 новой клетки карты и снимает бит 7 старой, новые записи не создаются
; In:
;   банк 0 уже выбран, #6A2D континент, шестибайтные записи группы #6B39
; Out:
;   активные записи при наличии свободной соседней клетки типа 0 перемещены, бит 7 старой/новой
;   клетки обновлён, успешная ветвь возвращает банк 0
; Corrupt:
;   HL, DE, BC, AF, IX, координаты объектов, карта, генератор, IY сохранён, альтернативные
;   регистры не используются
; -----------------------------------------
MoveSitesC      LD IX, State.SitesCIndex
                LD A, (State.Continent)
                CALL IndexFourBytes                                             ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                LD B, (IX + FMapList.Count.Low)
                PUSH HL
                POP IX
.SiteLoop       BIT TROOP_FREE_BIT, (IX + FMapTroop.Flags)                      ; свободная либо использованная шестибайтовая запись существ карты
                JR NZ, .NextSite                                                ; переход, если запись места исключена из обработки

                PUSH BC
                LD C, (IX + FMapTroop.X)
                LD B, (IX + FMapTroop.Y)
                LD (Engine.MoveSitesC.SourcePos), BC
                DEC B
                DEC C
                LD D, #03

                ; поиск свободной клетки в области перемещения стратегической записи
.RowLoop        PUSH BC
                LD E, #03
.CellLoop       CALL ReadMapCell                                                ; прочитать байт клетки текущей карты
                BIT MAP_BUSY_BIT, A                                             ; клетка стратегической карты занята объектом
                JR NZ, .NextCell                                                ; переход, если проверяемая клетка занята объектом

                AND #3F
                JR NZ, .NextCell                                                ; переход, если проверяемая клетка не относится к свободной суше

.TryMove        LD BC, (Engine.MoveSitesC.SourcePos)
                LD DE, #0002
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                LD A, C
                DEC A
                ADD A, E
                LD C, A
                LD DE, #0002
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                LD A, B
                DEC A
                ADD A, E
                LD B, A
                CALL ReadMapCell                                                ; прочитать байт клетки текущей карты
                BIT MAP_BUSY_BIT, A                                             ; клетка стратегической карты занята объектом
                JR NZ, .TryMove                                                 ; переход, если случайная целевая клетка занята объектом

                AND #3F
                JR NZ, .TryMove                                                 ; переход, если случайная целевая клетка не относится к свободной суше

                LD (IX + FMapTroop.X), C
                LD (IX + FMapTroop.Y), B
                CALL SelectMapBank                                              ; выбрать логический банк 10 с текущей картой
                CALL MapCellAddress                                             ; вычислить адрес клетки карты
                SET MAP_BUSY_BIT, (HL)                                          ; клетка стратегической карты занята объектом
                LD BC, (Engine.MoveSitesC.SourcePos)
                CALL MapCellAddress                                             ; вычислить адрес клетки карты
                RES MAP_BUSY_BIT, (HL)                                          ; клетка стратегической карты занята объектом
                XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                POP BC
                JR .RestoreCount

.NextCell       INC C
                DEC E
                JR NZ, .CellLoop                                                ; переход, если в проверяемой строке остались клетки

                POP BC
                INC B
                DEC D
                JR NZ, .RowLoop                                                 ; переход, если в области поиска остались строки

.RestoreCount   POP BC
.NextSite       LD DE, #0006
                ADD IX, DE
                DJNZ .SiteLoop

                RET

.SourcePos      EQU $                                                           ; позиция перемещаемого места до случайного шага
                DB #00, #00
