
; -----------------------------------------
; нарисовать рамку окна из восьми одноклеточных элементов
; BC левый верхний угол, E внутренняя ширина, D внутренняя высота, A атрибут, углы и границы из
; #74AF..#74ED, центр пустой элемент #74EE, вывод через #7545
; In:
;   DE, D внутренняя высота и E внутренняя ширина окна, BC левый верхний угол, AF атрибут A
; Out:
;   рамка и внутреннее поле выведены, IX и IY сохранены
; Corrupt:
;   HL, DE, BC, AF, рабочие поля #74AB..#74EE изменены, ограничение экраном отсутствует
; -----------------------------------------
DrawFrame       PUSH IX
                PUSH IY
                LD (Engine.DrawFrame.FramePos), BC
                LD (Engine.DrawFrame.FrameWidth), DE
                LD HL, Engine.headFpart_0Attr                                   ; существующий элемент пикселей или атрибутов рамки по исходному адресу
                LD B, #08
                LD DE, #0009

                ; одинаковый атрибут для восьми элементов рамки
.SetFrameAttrs  LD (HL), A
                ADD HL, DE
                DJNZ .SetFrameAttrs

                LD BC, (Engine.DrawFrame.FramePos)
                LD IX, Engine.headFpart_0                                       ; существующий элемент пикселей или атрибутов рамки по исходному адресу
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный спрайт с атрибутами
                LD A, (Engine.DrawFrame.FrameWidth)
.TopEdge        INC C
                OR A
                JR Z, .TopRight                                                 ; переход, если верхняя граница достигла правого угла

                LD IX, Engine.headFpart_1                                       ; существующий элемент пикселей или атрибутов рамки по исходному адресу
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный спрайт с атрибутами
                DEC A
                JR .TopEdge

.TopRight       LD IX, Engine.headFpart_2                                       ; существующий элемент пикселей или атрибутов рамки по исходному адресу
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный спрайт с атрибутами
                LD BC, (Engine.DrawFrame.FramePos)
                LD A, (Engine.DrawFrame.FrameHeight)

                ; вывод внутренних строк между верхней и нижней границами
.InteriorRow    INC B
                OR A
                JR Z, .BottomLeft                                               ; переход, если выведены все внутренние строки окна

                LD IX, Engine.headFpart_3                                       ; существующий элемент пикселей или атрибутов рамки по исходному адресу
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный спрайт с атрибутами
                PUSH AF
                LD A, (Engine.DrawFrame.FrameWidth)

                ; заполнение внутренней ширины пустым элементом
.InteriorColumn INC C
                OR A
                JR Z, .RightEdge                                                ; переход, если выведена вся внутренняя ширина окна

                LD IX, Engine.headFpart_7                                       ; существующий элемент пикселей или атрибутов рамки по исходному адресу
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный спрайт с атрибутами
                DEC A
                JR .InteriorColumn

.RightEdge      LD IX, Engine.headFpart_3                                       ; существующий элемент пикселей или атрибутов рамки по исходному адресу
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный спрайт с атрибутами
                LD A, (Engine.DrawFrame.FramePos)
                LD C, A
                POP AF
                DEC A
                JR .InteriorRow

.BottomLeft     LD IX, Engine.headFpart_4                                       ; существующий элемент пикселей или атрибутов рамки по исходному адресу
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный спрайт с атрибутами
                LD A, (Engine.DrawFrame.FrameWidth)
.BottomEdge     INC C
                OR A
                JR Z, .BottomRight                                              ; переход, если нижняя граница достигла правого угла

                LD IX, Engine.headFpart_5                                       ; существующий элемент пикселей или атрибутов рамки по исходному адресу
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный спрайт с атрибутами
                DEC A
                JR .BottomEdge

.BottomRight    LD IX, Engine.headFpart_6                                       ; существующий элемент пикселей или атрибутов рамки по исходному адресу
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный спрайт с атрибутами
                POP IY
                POP IX
                RET

.FramePos       EQU $                                                           ; левый верхний угол рамки
.FrameWidth     EQU $+2                                                         ; внутренняя ширина рамки
.FrameHeight    EQU $+3                                                         ; внутренняя высота рамки
                DB #00, #00, #00, #00
headFpart_0     INCBIN "Assets/Gfx/raw/head_frame_part_0.ink"                   ; графический ресурс, исходное смещение #1351
headFpart_0Attr INCBIN "Assets/Gfx/raw/head_frame_part_0.attr"                  ; графический ресурс, исходное смещение #1359
headFpart_1     INCBIN "Assets/Gfx/raw/head_frame_part_1.ink"                   ; графический ресурс, исходное смещение #135A
headFpart_1Attr INCBIN "Assets/Gfx/raw/head_frame_part_1.attr"                  ; графический ресурс, исходное смещение #1362
headFpart_2     INCBIN "Assets/Gfx/raw/head_frame_part_2.ink"                   ; графический ресурс, исходное смещение #1363
headFpart_2Attr INCBIN "Assets/Gfx/raw/head_frame_part_2.attr"                  ; графический ресурс, исходное смещение #136B
headFpart_3     INCBIN "Assets/Gfx/raw/head_frame_part_3.ink"                   ; графический ресурс, исходное смещение #136C
headFpart_3Attr INCBIN "Assets/Gfx/raw/head_frame_part_3.attr"                  ; графический ресурс, исходное смещение #1374
headFpart_4     INCBIN "Assets/Gfx/raw/head_frame_part_4.ink"                   ; графический ресурс, исходное смещение #1375
headFpart_4Attr INCBIN "Assets/Gfx/raw/head_frame_part_4.attr"                  ; графический ресурс, исходное смещение #137D
headFpart_5     INCBIN "Assets/Gfx/raw/head_frame_part_5.ink"                   ; графический ресурс, исходное смещение #137E
headFpart_5Attr INCBIN "Assets/Gfx/raw/head_frame_part_5.attr"                  ; графический ресурс, исходное смещение #1386
headFpart_6     INCBIN "Assets/Gfx/raw/head_frame_part_6.ink"                   ; графический ресурс, исходное смещение #1387
headFpart_6Attr INCBIN "Assets/Gfx/raw/head_frame_part_6.attr"                  ; графический ресурс, исходное смещение #138F
headFpart_7     INCBIN "Assets/Gfx/raw/head_frame_part_7.ink"                   ; графический ресурс, исходное смещение #1390
headFpart_7Attr INCBIN "Assets/Gfx/raw/head_frame_part_7.attr"                  ; графический ресурс, исходное смещение #1398
