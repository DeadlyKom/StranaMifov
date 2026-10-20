
; -----------------------------------------
; найти активную запись группы, покрывающую координату HL
; сначала бит 7 карты по HL, затем IX указатели текущего континента и количество, DE шаг, B/C
; размеры записи на карте, сравниваются координаты+1/+2 с областью, при совпадении A!=0 и IX
; запись, иначе A=0
; In:
;   HL координаты искомой клетки, DE шаг записей, BC размер области, IX таблица четырёхбайтных
;   указателей по континентам
; Out:
;   AF, A=0 если не найдено, иначе ненулевое A и IX найденная запись
; Corrupt:
;   HL, DE, BC, AF, IX, IY собственный код не меняет, банк выбирается при чтении карты и
;   восстанавливается #80C4
; -----------------------------------------
FindRecord      PUSH BC
                PUSH HL
                POP BC
                CALL ReadMapCell                                                ; прочитать байт клетки текущей карты
                BIT MAP_BUSY_BIT, A                                             ; клетка стратегической карты занята объектом
                LD A, #00
                POP BC
                RET Z                                                           ; выход, если клетка не помечена занятой

                LD A, B
                LD (Engine.FindRecord.ObjectRows), A
                LD A, C
                LD (Engine.FindRecord.ObjectColumns), A
                LD A, L
                LD (Engine.FindRecord.TargetX), A
                LD A, H
                LD (Engine.FindRecord.TargetY), A
                LD (Engine.FindRecord.RecordStride), DE
                LD A, (State.Continent)
                CALL IndexFourBytes                                             ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                LD C, (IX + FMapList.Count.Low)
                LD B, (IX + FMapList.Count.High)
                PUSH HL
                POP IX

                ; обход действующих записей и проверка области занимаемых ими клеток
.RecordLoop     BIT SITE_OFF_BIT, (IX + FMapSite.Flags)                         ; общий префикс стратегической записи выключает её из обхода
                JR NZ, .NextRecord                                              ; переход, если запись объекта исключена из обработки

                PUSH BC
                LD C, (IX + FMapSite.X)
                LD B, (IX + FMapSite.Y)
.ObjectRows     EQU $+1                                                         ; число строк занимаемой объектом области
                LD D, #00
.ObjectColumns  EQU $+1                                                         ; число столбцов занимаемой объектом области
.RowLoop        LD E, #00
.ColumnLoop     LD A, C
.TargetX        EQU $+1                                                         ; столбец искомой клетки
                CP #00
                JR NZ, .NextColumn                                              ; переход, если колонка проверяемой клетки не совпала с искомой

                LD A, B
.TargetY        EQU $+1                                                         ; строка искомой клетки
                CP #00
                JR NZ, .NextColumn                                              ; переход, если строка проверяемой клетки не совпала с искомой

                POP BC
                LD A, #FF
                RET

.NextColumn     INC C
                DEC E
                JR NZ, .ColumnLoop                                              ; переход, если в текущей строке области объекта остались клетки

                LD C, (IX + FMapSite.X)
                INC B
                DEC D
                JR NZ, .RowLoop                                                 ; переход, если в области объекта остались строки

                POP BC
.RecordStride   EQU $+1                                                         ; размер записи просматриваемой группы
.NextRecord     LD DE, #0000
                ADD IX, DE
                DEC BC
                LD A, B
                OR C
                JR NZ, .RecordLoop                                              ; переход, если в списке группы остались записи

                XOR A
                RET
