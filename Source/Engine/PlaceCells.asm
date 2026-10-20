
; -----------------------------------------
; разместить одноклеточные записи группы в локальном окне
; вход IX группа указателей, DE шаг записи, HL графика при сброшенном бите 5 исходных флагов, BC
; графика при установленном бите 5, активная видимая запись добавляет маскированный слой, поле 0
; экранного объекта OR #03 OR исходныйбит 6, поле 8=4(банк графики), поля 9/10 адрес выбранного
; изображения, фоновая часть объекта сохраняется
; In:
;   HL графика при бите 5=0, DE шаг, BC графика при бите 5=1, IX группа указателей
; Out:
;   активные видимые записи добавляют маскированный слой банка 4 и бит 6 отражения к экранным
;   объектам
; Corrupt:
;   HL, DE, BC, AF, IX, IY, объектные записи и операнды шаблонов/шага
; -----------------------------------------
PlaceCells      LD (Engine.PlaceCells.RecordStride), DE
                LD (Engine.PlaceCells.PrimaryTile), HL
                LD (Engine.PlaceCells.AlternateTile), BC
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

                PUSH BC
                LD C, (IX + FMapSite.X)
                LD B, (IX + FMapSite.Y)
                CALL InLocalView                                                ; проверить попадание координат BC в прямоугольник локального окна
                JR NC, .RestoreCount                                            ; переход, если клетка объекта находится вне локального окна

                PUSH BC
                POP HL
                LD BC, (Engine.PlaceViewLayer.ViewLeft)
                OR A
                SBC HL, BC
                LD IY, State.ViewObjects - FScreenObject20                      ; база на одну экранную запись перед массивом, строка и колонка передаются с предварительным инкрементом
                INC H
                INC L
                LD DE, #00A0

                ; перевод координат клетки в адрес двадцатибайтного экранного объекта
.ViewRow        ADD IY, DE
                DEC H
                JR NZ, .ViewRow                                                 ; переход, если адрес ещё не достиг строки экранного объекта

                LD DE, #0014
.ViewColumn     ADD IY, DE
                DEC L
                JR NZ, .ViewColumn                                              ; переход, если адрес ещё не достиг колонки экранного объекта

                BIT SITE_ALT_BIT, (IX + FMapSite.Flags)                         ; выбирает альтернативное изображение одноклеточной стратегической записи в PlaceCells
                JR NZ, .SelectPicture                                           ; переход, если у объекта выбрано альтернативное изображение

.PrimaryTile    EQU $+1                                                         ; адрес изображения при сброшенном бите альтернативы
                LD HL, #0000
                JR .WriteLayer

.AlternateTile  EQU $+1                                                         ; адрес изображения при установленном бите альтернативы
.SelectPicture  LD HL, #0000

                ; добавление переднего слоя с сохранением уже заданного фона
.WriteLayer     LD A, (IX + FMapSite.Flags)
                AND #40
                OR (IY + FScreenObject20.Flags)                                 ; +#00, режим и флаги экранного объекта
                OR #03
                LD (IY + FScreenObject20.Flags), A                              ; +#00, режим и флаги экранного объекта
                LD (IY + FScreenObject20.Frame1Bank), #04                       ; +#08, банк переднего слоя
                LD (IY + FScreenObject20.Frame1Address.Low), L                  ; +#09, младший байт адреса переднего слоя
                LD (IY + FScreenObject20.Frame1Address.High), H                 ; +#0A, старший байт адреса переднего слоя
.RestoreCount   POP BC
.RecordStride   EQU $+1                                                         ; размер одноклеточной стратегической записи
.NextObject     LD DE, #0000
                ADD IX, DE
                DEC BC
                LD A, B
                OR C
                JR NZ, .ObjectLoop                                              ; переход, если в группе остались стратегические объекты

                RET
