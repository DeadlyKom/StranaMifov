
; -----------------------------------------
; обход записей одной группы и отметка их прямоугольного следа на карте
; Сохраняет B/C как высоту/ширину, DE как шаг. По номеру #77A2 выбирает один из четырёх
; дескрипторов по IX+4*A. Дескриптор даёт указатель и 16-битное число записей. Для каждой берёт
; столбец+1, строку+2, вызывает #7791 для всех клеток прямоугольника и переходит на следующую
; запись. Нулевой счётчик данным циклом отдельно не обработан, вызывающие таблицы должны иметь
; корректные положительные числа.
; In:
;   IX — база перед первым 4-байтовым дескриптором континента, B — высота, C — ширина, DE — шаг
;   записи
; Out:
;   все записи отмечены, IY после последней записи
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; Note:
;   операнды #7774/#7776/#7787, карты
; -----------------------------------------
MarkGroupCells  LD A, B
                LD (Startup.MarkGroupCells.Height), A
                LD A, C
                LD (Startup.MarkGroupCells.Width), A
                LD (Startup.MarkGroupCells.RecordSize), DE
                LD DE, #0004
                LD A, (Startup.MarkUsedCell.Continent)
.GroupOffset    ADD IX, DE
                DEC A
                JR NZ, .GroupOffset                                             ; переход, если ещё не достигнут дескриптор выбранного континента

                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                LD C, (IX + FMapList.Count.Low)
                LD B, (IX + FMapList.Count.High)
                PUSH HL
                POP IY

                ; отметка прямоугольного следа очередного строения на выбранной карте континента
.ObjectLoop     PUSH BC
                LD C, (IY + FMapSite.X)
                LD B, (IY + FMapSite.Y)
.Height         EQU $+1                                                         ; операнд D высоты прямоугольного следа объекта
                LD D, #00
.Width          EQU $+1                                                         ; операнд E ширины прямоугольного следа объекта
.FootprintRow   LD E, #00
.FootprintCell  CALL MarkUsedCell                                               ; установка бита занятости клетки с восстановлением банка
                INC C
                DEC E
                JR NZ, .FootprintCell                                           ; переход, если ещё не отмечена вся ширина объекта

                LD C, (IY + FMapSite.X)
                INC B
                DEC D
                JR NZ, .FootprintRow                                            ; переход, если ещё не отмечена вся высота объекта

                POP BC
.RecordSize     EQU $+1                                                         ; операнд DE шага записи группы объектов
                LD DE, #0000
                ADD IY, DE
                DEC BC
                LD A, B
                OR C
                JR NZ, .ObjectLoop                                              ; переход, если ещё не обработаны все объекты группы

                RET
