
; -----------------------------------------
; найти ближайшую активную запись выбранной группы
; D выбирает 16 байтный блок указателей от #6AD9, E континент через #7A74, A шаг исходной записи,
; BC опорные координаты, HL координаты исключаемой записи, сравнивает квадрат расстояния dx²+dy²,
; IX ближайшая запись, минимум #7FEC и указатель #7FEE
; In:
;   HL исключаемые координаты, DE, D номер группы и E континент, BC опорные координаты, AF, A
;   шаг записи
; Out:
;   IX ближайшая подходящая запись, HL и IY сохранены, #7FEC квадрат минимального расстояния,
;   банк 0 выбран
; Corrupt:
;   DE, BC, AF, IX, #7FEE последний найденный указатель, при отсутствии кандидатов #7FEE не
;   очищается и IX не гарантируется
; -----------------------------------------
NearestObject   PUSH HL
                PUSH IY
                LD (Engine.NearestObject.Origin), BC
                LD (Engine.NearestObject.IgnorePos), HL
                LD (Engine.NearestObject.RecordStride), A
                LD BC, #FFFF
                LD (Engine.NearestObject.BestDistance), BC
                LD B, #00
                LD C, D
                SLA C
                SLA C
                SLA C
                SLA C
                LD IX, State.CastlesIndex - 4 * FMapList                        ; смещённая база групп континентальных списков, группа1 задаёт замки
                ADD IX, BC
                LD A, E
                CALL IndexFourBytes                                             ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                LD C, (IX + FMapList.Count.Low)
                LD B, (IX + FMapList.Count.High)
                PUSH HL
                POP IX
                XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания

                ; выбор действующего объекта с минимальным квадратом расстояния
.ObjectLoop     BIT SITE_OFF_BIT, (IX + FMapSite.Flags)                         ; общий префикс стратегической записи выключает её из обхода
                JR NZ, .NextObject                                              ; переход, если объект исключён из обработки

                LD E, (IX + FMapSite.X)
                LD D, (IX + FMapSite.Y)
.IgnorePos      EQU $+1                                                         ; координаты записи, исключаемой из поиска ближайшей
                LD HL, #0000
                OR A
                SBC HL, DE
                JR Z, .NextObject                                               ; переход, если объект находится в исходной клетке

                PUSH BC
.Origin         EQU $+1                                                         ; опорные координаты при поиске ближайшего объекта
                LD BC, #0000
                LD A, C
                SUB E
                JR NC, .SquareDeltaX                                            ; переход, если горизонтальная разность координат неотрицательна

                NEG
.SquareDeltaX   CALL SquareByte                                                 ; возвести беззнаковый байт A в квадрат
                LD A, B
                SUB D
                JR NC, .SquareDeltaY                                            ; переход, если вертикальная разность координат неотрицательна

                NEG
.SquareDeltaY   EX DE, HL
                CALL SquareByte                                                 ; возвести беззнаковый байт A в квадрат
                ADD HL, DE
                LD C, L
                LD B, H
                LD HL, (Engine.NearestObject.BestDistance)
                OR A
                SBC HL, BC
                JR C, .RestoreCount                                             ; переход, если ранее найденный объект уже ближе текущего

                LD (Engine.NearestObject.BestDistance), BC
                LD (Engine.NearestObject.BestObject), IX
.RestoreCount   POP BC
.RecordStride   EQU $+1                                                         ; изменяемый размер записи при поиске ближайшего
.NextObject     LD DE, #0000
                ADD IX, DE
                DEC BC
                LD A, B
                OR C
                JR NZ, .ObjectLoop                                              ; переход, если в группе остались записи объектов

                LD IX, (Engine.NearestObject.BestObject)
                POP IY
                POP HL
                RET

.BestDistance   EQU $                                                           ; квадрат расстояния до лучшего найденного объекта
.BestObject     EQU $+2                                                         ; адрес лучшего найденного объекта
                DB #00, #00, #00, #00
