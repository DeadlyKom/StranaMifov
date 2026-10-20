
; -----------------------------------------
; установить бит 7 карты под активными записями группы
; A=#6A2D выбирает четырёхбайтную запись группы, оттуда указатель и количество, объекты с бит 0
; поля 0 сброшенным размечаются прямоугольником заданного размера через #7BE3, адресная структура
; и размеры записаны в самомодифицируемые операнды #7BC6/#7BC8/#7BD9
; In:
;   HL начальное значение не требуется, DE шаг записи, BC размеры прямоугольника, IX группа
;   четырёхбайтных указателей
; Out:
;   бит 7 карты отмечает область активных объектов текущего континента, прежний банк
;   восстанавливается в каждом #7BE3
; Corrupt:
;   HL, DE, BC, AF, IX, IY, операнды #7BC6/#7BC8/#7BD9, IFF может быть запрещён
; -----------------------------------------
MarkObjectGroup LD A, B
                LD (Engine.MarkObjectGroup.ObjectRows), A
                LD A, C
                LD (Engine.MarkObjectGroup.ObjectColumns), A
                LD (Engine.MarkObjectGroup.RecordStride), DE
                LD A, (State.Continent)
                CALL IndexFourBytes                                             ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                LD C, (IX + FMapList.Count.Low)
                LD B, (IX + FMapList.Count.High)
                PUSH HL
                POP IY

                ; отметка занимаемых клеток для всех действующих объектов выбранной группы
.ObjectLoop     BIT SITE_OFF_BIT, (IY + FMapSite.Flags)                         ; общий префикс стратегической записи выключает её из обхода
                JR NZ, .NextObject                                              ; переход, если объект исключён из обработки

                PUSH BC
                LD C, (IY + FMapSite.X)
                LD B, (IY + FMapSite.Y)
.ObjectRows     EQU $+1                                                         ; изменяемое число строк области объекта
                LD D, #00
.ObjectColumns  EQU $+1                                                         ; изменяемое число столбцов области объекта
.RowLoop        LD E, #00
.ColumnLoop     CALL MarkMapCell                                                ; установить бит 7 байта клетки стратегической карты
                INC C
                DEC E
                JR NZ, .ColumnLoop                                              ; переход, если в строке объекта остались клетки для отметки

                LD C, (IY + FMapSite.X)
                INC B
                DEC D
                JR NZ, .RowLoop                                                 ; переход, если в области объекта остались строки для отметки

                POP BC
.RecordStride   EQU $+1                                                         ; изменяемый размер записи стратегического объекта
.NextObject     LD DE, #0000
                ADD IY, DE
                DEC BC
                LD A, B
                OR C
                JR NZ, .ObjectLoop                                              ; переход, если в выбранной группе остались объекты

                RET
