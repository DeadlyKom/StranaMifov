
; -----------------------------------------
; сформировать маску препятствий и фоновые объекты поля боя
; обнуляет FCE7, при бите 7 режима FCB8 копирует пять байтов препятствий из FDF5 и выбирает карту
; ресурсов FE72, обычные режимы 1..5 генерируют пять масок как (случайное 1 AND7E AND случайное
; 2), общий ненулевой бит любых трёх соседних строк вызывает повтор всей генерации, режимы >=6
; берут пятибайтную маску из таблицы FDE1 с шагом 5, затем экран очищается, для обычной местности
; источник BD30+720*тип, каждый свободный тайл использует основной ресурс, препятствие случайно
; выбирает один из следующих трёх ресурсов с шагом 144, создаются сорок объектов от 6611 с шагом
; 20, для специальных полей выбирается сорокабайтная карта FDD2+40*(тип-5) и переход FC7D
; In:
;   FCB8 тип поля либо особый режим, армии FCED/FD47 созданы, рабочий банк боя выбран вызывающим
;   кодом
; Out:
;   FCE7=0, FCE8..FCEC маска 8 на 5, сорок фоновых объектов подготовлены, дальнейший переход
;   FC7D либо FCB0
; Corrupt:
;   HL, DE, BC, AF, IX, IY, поля объектов и маски препятствий
; -----------------------------------------
BuildField      XOR A
                LD (Battle.FinishField.Flags), A
                LD A, (Battle.FinishField.FieldKind)
                BIT FIELD_SPEC_BIT, A                                           ; флаг, особый режим боя с готовой маской поля и создаваемой армией противника
                JR Z, .CheckFieldKind                                           ; переход, если поле требует обычного построения

                LD HL, Battle.FinishField.SpecialMask                           ; пятибайтная маска препятствий для режима с установленным битом7
                LD DE, Battle.FinishField.ObstacleRows
                LD BC, #0005
                LDIR
                LD BC, #0000
                LD DE, #1820
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD IX, Battle.SpecialTileMap                                    ; сорок индексов тайлов для режима с установленным битом7
                JP MakeFieldTiles

.CheckFieldKind CP #06
                JR NC, .FixedMask                                               ; переход, если тип поля использует готовую маску

.RandomMask     LD HL, Battle.FinishField.ObstacleRows
                LD B, #05
.MaskRow        LD DE, #00FF
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD A, E
                LD DE, #00FF
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                AND #7E
                AND E
                LD (HL), A
                INC HL
                DJNZ .MaskRow

                LD IX, Battle.FinishField.ObstacleRows
                LD B, #03
.TestMask       LD A, #FF
                AND (IX + FObstacleRows.First)
                AND (IX + FObstacleRows.Second)
                AND (IX + FObstacleRows.Third)
                JR NZ, .RandomMask                                              ; переход, если три соседние строки содержат препятствие в одном столбце

                INC IX
                DJNZ .TestMask

                JR .DrawBackground

.FixedMask      LD HL, Battle.FinishField.FixedMasks - 5                        ; смещённая база масок до первого режима6
                LD BC, #0005
                SUB #05
.MaskOffset     ADD HL, BC
                DEC A
                JR NZ, .MaskOffset                                              ; переход, если ещё не достигнута маска выбранного типа

                LD DE, Battle.FinishField.ObstacleRows
                LDIR
.DrawBackground LD BC, #0000
                LD DE, #1820
                LD A, #47
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD A, (Battle.FinishField.FieldKind)
                CP #06
                JR NC, .FixedTileMap                                            ; переход, если тип поля использует готовую раскладку

                LD HL, Graphics.Battle.Tile00Pixels - 5 * FTile32               ; смещённая база пяти наборов фоновых тайлов в банке6, каждый набор5тайлов
                LD DE, #02D0
.BackgroundType ADD HL, DE
                DEC A
                JR NZ, .BackgroundType                                          ; переход, если ещё не достигнут фон выбранного типа

                LD IY, State.ViewObjects + 8 * FScreenObject20                  ; первые восемь экранных объектов зарезервированы, далее40объектов боевых клеток
                LD IX, Battle.FinishField.ObstacleRows
                LD B, #05
.ObjectRow      PUSH BC
                LD B, #08
.ObjectColumn   PUSH BC
                LD A, B
                DEC A
                SLA A
                SLA A
                SLA A
                OR #46
                LD (Battle.BuildField.ColumnTest), A
.ColumnTest     EQU $+3                                                         ; изменяемый байт BIT при выборе фонового объекта по маске поля
                BIT FIELD_COL_BIT, (IX + FObstacleRows.First)                   ; исходная позиция бита в шаблоне самоменяемой проверки либо установки столбца поля
                JR NZ, .RandomTile                                              ; переход, если клетка маски занята препятствием

                LD (IY + FScreenObject20.Flags), #01
                LD (IY + FScreenObject20.BaseBank), #06
                LD (IY + FScreenObject20.BaseAddress.Low), L
                LD (IY + FScreenObject20.BaseAddress.High), H
                JR .NextObject

.RandomTile     PUSH HL
                LD DE, #0003
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD B, E
                INC B
                LD DE, #0090
.TileOffset     ADD HL, DE
                DJNZ .TileOffset

                LD (IY + FScreenObject20.Flags), #01
                LD (IY + FScreenObject20.BaseBank), #06
                LD (IY + FScreenObject20.BaseAddress.Low), L
                LD (IY + FScreenObject20.BaseAddress.High), H
                POP HL
.NextObject     POP BC
                LD DE, #0014
                ADD IY, DE
                DJNZ .ObjectColumn

                POP BC
                INC IX
                DJNZ .ObjectRow

                JR FinishField

.FixedTileMap   LD IX, Battle.Mode6TileMap - 40                                 ; смещённая база40байтных карт режимов6..8, до первой карты
                LD DE, #0028
                SUB #05
.MapOffset      ADD IX, DE
                DEC A
                JR NZ, .MapOffset                                               ; переход, если ещё не достигнута раскладка выбранного типа
