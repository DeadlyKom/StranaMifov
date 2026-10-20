
; -----------------------------------------
; разместить прямоугольные объекты группы в локальном окне
; вход IX группа указателей, DE шаг записей, B высота и C ширина объекта, HL начало графических
; блоков по 144 байта, для каждой записи с бит 0 флага сброшенным перебирает прямоугольник
; от+1/+2, видимые клетки получают тип 1, банк 4 и адрес текущего 144 байтного блока, после каждой
; клетки HL+=144, проверка #8652 исключает клетки вне локальногоокна, размеры/шаг/начало хранятся
; в изменяемых операндах
; In:
;   HL графические блоки по 144 байта, DE шаг записей, BC, B высота и C ширина, IX группа
;   указателей
; Out:
;   видимые клетки активных прямоугольников получают тип 1, банк 4 и адрес соответствующего
;   графического блока
; Corrupt:
;   HL, DE, BC, AF, IX, IY, объектные записи и операнды размеров/шага/источника
; -----------------------------------------
PlaceGroup      LD A, B
                LD (Engine.PlaceGroup.ObjectRows), A
                LD A, C
                LD (Engine.PlaceGroup.ObjectColumns), A
                LD (Engine.PlaceGroup.RecordStride), DE
                LD (Engine.PlaceGroup.TileAddress), HL
                LD A, (State.Continent)
                CALL IndexFourBytes                                             ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                LD C, (IX + FMapList.Count.Low)
                LD B, (IX + FMapList.Count.High)
                PUSH HL
                POP IX
.ObjectLoop     BIT SITE_OFF_BIT, (IX + FMapSite.Flags)                         ; общий префикс стратегической записи выключает её из обхода
                JR NZ, .NextObject                                              ; переход, если стратегический объект исключён из обработки

.TileAddress    EQU $+1                                                         ; начальный адрес графических клеток объекта
                LD HL, #0000
                PUSH BC
                LD C, (IX + FMapSite.X)
                LD B, (IX + FMapSite.Y)
.ObjectRows     EQU $+1                                                         ; число строк прямоугольного объекта
                LD D, #00

                ; обход клеток графической области объекта
.RowLoop        PUSH DE
.ObjectColumns  EQU $+1                                                         ; число столбцов прямоугольного объекта
                LD D, #00
.ColumnLoop     PUSH DE
                CALL InLocalView                                                ; проверить попадание координат BC в прямоугольник локального окна
                JR NC, .NextCell                                                ; переход, если проверяемая клетка находится вне локального окна

                PUSH BC
                PUSH HL
                PUSH BC
                POP HL
                LD BC, (Engine.PlaceViewLayer.ViewLeft)
                OR A
                SBC HL, BC
                LD IY, State.ViewObjects - FScreenObject20                      ; база на одну экранную запись перед массивом, строка и колонка передаются с предварительным инкрементом
                INC H
                INC L
                LD DE, #00A0

                ; выбор записи экранного объекта для видимой клетки
.ViewRow        ADD IY, DE
                DEC H
                JR NZ, .ViewRow                                                 ; переход, если адрес ещё не достиг строки экранного объекта

                LD DE, #0014
.ViewColumn     ADD IY, DE
                DEC L
                JR NZ, .ViewColumn                                              ; переход, если адрес ещё не достиг колонки экранного объекта

                POP HL
                LD (IY + FScreenObject20.Flags), #01                            ; +#00, режим и флаги экранного объекта
                LD (IY + FScreenObject20.BaseBank), #04                         ; +#05, банк фонового изображения
                LD (IY + FScreenObject20.BaseAddress.Low), L                    ; +#06, младший байт адреса фона
                LD (IY + FScreenObject20.BaseAddress.High), H                   ; +#07, старший байт адреса фона
                POP BC
.NextCell       LD DE, #0090
                ADD HL, DE
                POP DE
                INC C
                DEC D
                JR NZ, .ColumnLoop                                              ; переход, если в области изображения остались столбцы

                POP DE
                LD C, (IX + FMapSite.X)
                INC B
                DEC D
                JR NZ, .RowLoop                                                 ; переход, если в области изображения остались строки

                POP BC
.RecordStride   EQU $+1                                                         ; размер записи стратегического объекта
.NextObject     LD DE, #0000
                ADD IX, DE
                DEC BC
                LD A, B
                OR C
                JR NZ, .ObjectLoop                                              ; переход, если в группе остались стратегические объекты

                RET
