
; -----------------------------------------
; отметить открытые клетки вокруг героя и подготовить экранные объекты
; позиция #6A2E, область 5 на 5 от позиции-2 до+2, в логическом банке 11 карты посещения имеют шаг
; 2100 байт на континент и 21 байт на строку, устанавливает соответствующие биты, затем читает
; карту банка 10 и формирует объекты от #6611
; In:
;   #6A2D континент, #6A2E позиция, таблицы объектов и карты банков 0/1/10/11
; Out:
;   отмечена видимость 5 на 5, подготовлены экранные записи фона/объектов/героя, в конце бит 2
;   #6566 установлен через #6D57
; Corrupt:
;   HL, DE, BC, AF, IX, IY, банки/IFF, #853F..#8542, карта посещений и объектные записи
; -----------------------------------------
UpdateLocalView LD BC, (State.Position)
.FrameLink      EQU FScreenObject20.Frame1Bank                                  ; смещение ссылки при IX=объект+индекс_ссылки*FFrameRef
                INC C
                INC C
                INC B
                INC B
                LD (Engine.PlaceViewLayer.ViewRight), BC
                LD BC, (State.Position)
                DEC C
                DEC C
                DEC B
                DEC B
                LD (Engine.PlaceViewLayer.ViewLeft), BC
                LD A, #0B
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD HL, MapConst.FogIndex                                        ; смещённая база битовых карт открытия логического банка11
                LD DE, #0834
                LD A, (State.Continent)
                LD B, A

                ; поиск области битовой карты открытия вокруг героя
.FogRowOffset   ADD HL, DE
                DJNZ .FogRowOffset

                LD BC, (Engine.PlaceViewLayer.ViewLeft)
                LD DE, #0015
                INC B
.FogCellOffset  ADD HL, DE
                DJNZ .FogCellOffset

                LD E, C
                SRL E
                SRL E
                SRL E
                ADD HL, DE
                LD A, C
                AND #07
                XOR #07
                SLA A
                SLA A
                SLA A
                LD B, #05
.PatchFogMask   OR #C6
                LD (Engine.UpdateLocalView.FogSetOpcode), A
                AND #38
                LD DE, #0015
                PUSH BC
                PUSH HL
                LD B, #05

                ; отметка просмотренных клеток
.FogSetOpcode   EQU $+1                                                         ; CB-операция SET выбранного бита открытости клетки
.MarkFogLoop    SET FOG_SEED_BIT, (HL)                                          ; начальный номер бита команды SET в карте открытия, до исполнения операнд FogSetOpcode меняется по координате X
                ADD HL, DE
                DJNZ .MarkFogLoop

                POP HL
                POP BC
                DEC B
                JR Z, .RebuildView                                              ; переход, если завершён обход пяти колонок области открытия карты

                SUB #08
                JR NC, .PatchFogMask                                            ; переход, если следующая открываемая колонка остаётся в том же байте карты

                LD A, #38
                INC HL
                JR .PatchFogMask

                ; пересборка экранной сетки из местности и объектов текущего окна
.RebuildView    CALL StopView                                                   ; выключить обработку объектов в прерывании
                CALL SelectMapBank                                              ; выбрать логический банк 10 с текущей картой
                LD BC, (Engine.PlaceViewLayer.ViewLeft)
                CALL MapCellAddress                                             ; вычислить адрес клетки карты
                LD IX, State.ViewObjects + 8 * FScreenObject20                  ; первый объект локальной карты, экранная строка1, колонка0
                LD B, #05
.ViewRow        PUSH BC
                PUSH HL
                LD B, #05
.ViewColumn     PUSH BC
                PUSH HL
                LD A, (HL)
                AND #3F
                LD B, A
                LD A, (HL)
                AND #40
                SLA A
                LD HL, Graphics.World.Tile00 - FTile32                          ; база перед первым144-байтным тайлом местности банка4
                INC B
                LD DE, #0090
.TerrainOffset  ADD HL, DE
                DJNZ .TerrainOffset

                OR #01
                LD (IX + FScreenObject20.Flags), A                              ; +#00, режим и флаги экранного объекта
                LD (IX + FScreenObject20.BaseBank), #04                         ; +#05, банк фонового изображения
                LD (IX + FScreenObject20.BaseAddress.Low), L                    ; +#06, младший байт адреса фона
                LD (IX + FScreenObject20.BaseAddress.High), H                   ; +#07, старший байт адреса фона
                POP HL
                INC HL
                LD BC, #0014
                ADD IX, BC
                POP BC
                DJNZ .ViewColumn

                POP HL
                LD DE, #00A1
                ADD HL, DE
                LD DE, #003C
                ADD IX, DE
                POP BC
                DJNZ .ViewRow

                XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD IX, State.CastlesIndex
                LD DE, #0023
                LD BC, #0203
                LD HL, Graphics.World.Tile41                                    ; графический ресурс SPR1 логического банка4, первая клетка изображения замка
                CALL PlaceGroup                                                 ; разместить прямоугольные объекты группы в локальном окне
                LD IX, State.TownsIndex
                LD DE, #001A
                LD HL, Graphics.World.Tile47                                    ; графический ресурс SPR1 логического банка4, одноклеточное изображение города
                LD BC, #0101
                CALL PlaceGroup                                                 ; разместить прямоугольные объекты группы в локальном окне
                LD IX, State.TemplesIndex
                LD DE, #0005
                LD HL, Graphics.World.Tile48                                    ; графический ресурс SPR1 логического банка4, первая клетка изображения храма
                LD BC, #0202
                CALL PlaceGroup                                                 ; разместить прямоугольные объекты группы в локальном окне
                LD IX, State.SitesAIndex
                LD DE, #0006
                LD HL, Graphics.World.Tile52                                    ; графический ресурс SPR1 логического банка4, изображение группы мест A
                LD BC, #0101
                CALL PlaceGroup                                                 ; разместить прямоугольные объекты группы в локальном окне
                LD IX, State.SitesBIndex
                LD DE, #0006
                LD HL, Graphics.World.Tile53                                    ; графический ресурс SPR1 логического банка4, изображение группы мест B и злой сюжетной точки
                LD BC, #0101
                CALL PlaceGroup                                                 ; разместить прямоугольные объекты группы в локальном окне
                LD IX, State.SitesCIndex
                LD DE, #0006
                LD HL, Graphics.World.Tile54                                    ; графический ресурс SPR1 логического банка4, изображение группы мест C и доброй сюжетной точки
                LD BC, #0101
                CALL PlaceGroup                                                 ; разместить прямоугольные объекты группы в локальном окне
                LD IX, State.SitesDIndex
                LD DE, #0006
                LD HL, Graphics.World.Tile55                                    ; графический ресурс SPR1 логического банка4, изображение группы мест D
                LD BC, #0101
                CALL PlaceGroup                                                 ; разместить прямоугольные объекты группы в локальном окне
                LD IX, State.ItemsIndex
                LD DE, #0003
                LD HL, Graphics.World.Tile56                                    ; графический ресурс SPR1 логического банка4, изображение находки
                LD BC, #0101
                CALL PlaceGroup                                                 ; разместить прямоугольные объекты группы в локальном окне
                LD IX, State.MapTroopsIndex
                LD DE, #0006
                LD HL, Graphics.World.SPR1_overlay_0                            ; графический ресурс SPR1 логического банка4, основное изображение одноклеточной группы
                LD BC, Graphics.World.SPR1_overlay_1                            ; графический ресурс SPR1 логического банка4, альтернативное изображение одноклеточной группы
                CALL PlaceCells                                                 ; разместить одноклеточные записи группы в локальном окне
                LD A, #01
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD IX, State.MapArmiesIndex
                LD DE, #0016
                LD HL, Graphics.World.SPR1_overlay_0                            ; графический ресурс SPR1 логического банка4, основное изображение одноклеточной группы
                LD BC, Graphics.World.SPR1_overlay_1                            ; графический ресурс SPR1 логического банка4, альтернативное изображение одноклеточной группы
                CALL PlaceCells                                                 ; разместить одноклеточные записи группы в локальном окне
                LD A, (State.MoveFlags)
                BIT HERO_HIDE_BIT, A                                            ; временно исключает изображение героя из локального окна
                JR NZ, .CheckShip                                               ; переход, если изображение героя временно исключено из вывода

                LD IX, State.ViewObjects + 26 * FScreenObject20                 ; экранный объект героя в центре карты, строка3 и колонка2
                LD A, (IX + FScreenObject20.Flags)                              ; +#00, режим и флаги экранного объекта
                AND #80
                OR #04
                LD (IX + FScreenObject20.Flags), A                              ; +#00, режим и флаги экранного объекта
                LD A, (State.MoveFlags)
                BIT HERO_FACE_BIT, A                                            ; горизонтальное отражение изображения героя
                JR Z, .HeroObject                                               ; переход, если для изображения героя не выбрано горизонтальное отражение

                SET FRONT_FLIP_BIT, (IX + FScreenObject20.Flags)                ; +#00, режим и флаги экранного объекта

                ; подготовка анимации изображения героя
.HeroObject     LD (IX + FScreenObject20.AnimationTimer), #01                   ; +#01, счётчик смены кадра
                LD (IX + FScreenObject20.AnimationFrame), #01                   ; +#02, номер текущего кадра
                LD (IX + FScreenObject20.AnimationPeriod), #09                  ; +#03, период смены кадров
                LD (IX + FScreenObject20.FrameCount), #04                       ; +#04, число кадров
                LD A, (State.MoveFlags)
                AND #03
                JR NZ, .CheckHeroMode                                           ; переход, если герой находится не в обычном пешем режиме

                LD HL, Graphics.World.HeroMode0F1                               ; графический ресурс SPR1 логического банка4, первый кадр пешего героя
                JR .FrameCount

.CheckHeroMode  CP #01
                JR NZ, .FlyingHero                                              ; переход, если герой находится не в корабельном режиме

                LD HL, Graphics.World.HeroMode1F1                               ; графический ресурс SPR1 логического банка4, первый кадр корабельного героя либо отдельного корабля
                JR .FrameCount

.FlyingHero     LD HL, Graphics.World.HeroMode2F1                               ; графический ресурс SPR1 логического банка4, первый кадр летящего героя
.FrameCount     LD B, #04
.FrameLoop      LD (IX + .FrameLink + FFrameRef.Bank), #04
                LD (IX + .FrameLink + FFrameRef.Address.Low), L
                LD (IX + .FrameLink + FFrameRef.Address.High), H
                INC IX
                INC IX
                INC IX
                INC H
                DJNZ .FrameLoop

                ; добавление корабля и сюжетных объектов поверх местности
.CheckShip      LD A, (State.MoveFlags)
                AND #03
                CP #01
                JR Z, .StoryObject                                              ; переход, если герой находится на корабле и отдельное изображение корабля не требуется

                LD D, #03
                LD A, (State.MoveFlags)
                BIT SHIP_FACE_BIT, A                                            ; альтернативное горизонтальное представление корабля
                JR Z, .ShipObject                                               ; переход, если для корабля не выбрано альтернативное представление

                LD D, #43
.ShipObject     LD BC, (State.ShipPos)
                LD A, (State.ShipMap)
                LD IY, Graphics.World.HeroMode1F1                               ; графический ресурс SPR1 логического банка4, первый кадр корабельного героя либо отдельного корабля
                LD E, #80
                LD HL, #0408
                CALL PlaceViewLayer                                             ; поставить графический слой только на текущем континенте и в области обзора
.StoryObject    LD BC, (State.GoodStoryPos)
                LD A, (State.GoodStoryMap)
                LD IY, Graphics.World.Tile54                                    ; графический ресурс SPR1 логического банка4, изображение группы мест C и доброй сюжетной точки
                LD E, #00
                LD D, #01
                LD HL, #0405
                CALL PlaceViewLayer                                             ; поставить графический слой только на текущем континенте и в области обзора
                LD BC, (State.BadStoryPos)
                LD A, (State.BadStoryMap)
                LD IY, Graphics.World.Tile53                                    ; графический ресурс SPR1 логического банка4, изображение группы мест B и злой сюжетной точки
                LD E, #00
                LD D, #01
                LD HL, #0405
                CALL PlaceViewLayer                                             ; поставить графический слой только на текущем континенте и в области обзора
                CALL StartView                                                  ; включить обработку объектов в прерывании
                RET
