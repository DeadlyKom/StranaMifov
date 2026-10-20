
; -----------------------------------------
; создать сорок объектов поля по готовой карте тайлов
; IY=6611, сорок байтов карты по IX задают индекс и бит 7 флага, в поле 0 объекта сохраняется бит
; 7 тайла и ставится 1, поле 5 получает 6, адрес ресурса вычисляется как CD80+144*(байт AND7F),
; записывается в +6/+7, карта продвигается на 1 и объект на 20, нулевой индекс в данных недопустим
; из-за DJNZ, после сорока объектов выполнение продолжается в FCB0
; In:
;   IX карта из сорока ненулевых индексов с необязательным битом 7
; Out:
;   сорок объектов 6611..6930 подготовлены, IX после карты, IY=6931
; Corrupt:
;   HL, DE, BC, AF, IX, IY и записи объектов
; -----------------------------------------
MakeFieldTiles  LD IY, State.ViewObjects + 8 * FScreenObject20                  ; первые восемь экранных объектов зарезервированы, далее40объектов боевых клеток
                LD B, #28
.ObjectLoop     PUSH BC
                LD A, (IX + #00)
                AND #80
                OR #01
                LD (IY + FScreenObject20.Flags), A
                LD (IY + FScreenObject20.BaseBank), #06
                LD HL, Graphics.Battle.Tile25Pixels - FTile32                   ; база специальных фоновых тайлов банка6 до первого допустимого индекса1
                LD DE, #0090
                LD B, (IX + #00)
                RES TILE_MIRROR_BIT, B                                          ; флаг, горизонтальное отражение фонового тайла, переносится в Flags экранного объекта
.TileOffset     ADD HL, DE
                DJNZ .TileOffset

                LD (IY + FScreenObject20.BaseAddress.Low), L
                LD (IY + FScreenObject20.BaseAddress.High), H
                INC IX
                LD DE, #0014
                ADD IY, DE
                POP BC
                DJNZ .ObjectLoop
