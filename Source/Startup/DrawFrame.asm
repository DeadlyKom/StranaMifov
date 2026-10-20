
; -----------------------------------------
; рисование рамки из восьми одноклеточных образцов с атрибутами
; Сохраняет позицию и внутренний размер. Устанавливает A как атрибут в восьми 9-байтовых образцах
; #72C9..#7308. Верх и низ рисует углами и горизонтальными элементами, середину вертикальными
; границами и пустым заполнителем. Каждый элемент передаёт #6EA6 как спрайт 1x1 знакоместо. Полная
; рамка занимает (E+2)x(D+2) знакоместа.
; In:
;   B — строка, C — столбец, D — внутренняя высота, E — внутренняя ширина, A — атрибут
; Out:
;   рамка выведена
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   #72C5..#72C8, атрибуты образцов, экран
; -----------------------------------------
DrawFrame       LD (Startup.DrawFrame.Position), BC
                LD (Startup.DrawFrame.Width), DE
                LD HL, Startup.BL3Fpart_0Attr                                   ; байт атрибута левого верхнего угла, рамка подставляет общий цвет
                LD B, #08
                LD DE, #0009

                ; подстановка выбранного атрибута в восемь исходных элементов рамки
.SaveFrameArgs  LD (HL), A
                ADD HL, DE
                DJNZ .SaveFrameArgs

                LD BC, (Startup.DrawFrame.Position)
                LD IX, Startup.BL3Fpart_0                                       ; левый верхний угол рамки
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный прямоугольный спрайт с атрибутами
                LD A, (Startup.DrawFrame.Width)

                ; формирование верхнего края рамки между угловыми элементами
.TopEdge        INC C
                OR A
                JR Z, .TopRight                                                 ; переход, если горизонтальных средних плиток нет

                LD IX, Startup.BL3Fpart_1                                       ; средняя плитка верхней стороны рамки
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный прямоугольный спрайт с атрибутами
                DEC A
                JR .TopEdge

.TopRight       LD IX, Startup.BL3Fpart_2                                       ; правый верхний угол рамки
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный прямоугольный спрайт с атрибутами
                LD BC, (Startup.DrawFrame.Position)
                LD A, (Startup.DrawFrame.Height)

                ; построение промежуточных рядов с вертикальными краями и заполнением внутри
.SideRow        INC B
                OR A
                JR Z, .BottomLeft                                               ; переход, если вертикальных средних рядов нет

                LD IX, Startup.BL3Fpart_3                                       ; плитка вертикальной стороны рамки
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный прямоугольный спрайт с атрибутами
                PUSH AF
                LD A, (Startup.DrawFrame.Width)
.FillRow        INC C
                OR A
                JR Z, .RightEdge                                                ; переход, если в текущем ряду нет средних плиток

                LD IX, Startup.BL3Fpart_7                                       ; плитка заполнения внутренней области рамки
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный прямоугольный спрайт с атрибутами
                DEC A
                JR .FillRow

.RightEdge      LD IX, Startup.BL3Fpart_3                                       ; плитка вертикальной стороны рамки
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный прямоугольный спрайт с атрибутами
                LD A, (Startup.DrawFrame.Position)
                LD C, A
                POP AF
                DEC A
                JR .SideRow

                ; формирование нижнего края и двух нижних углов рамки
.BottomLeft     LD IX, Startup.BL3Fpart_4                                       ; левый нижний угол рамки
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный прямоугольный спрайт с атрибутами
                LD A, (Startup.DrawFrame.Width)
.BottomEdge     INC C
                OR A
                JR Z, .BottomRight                                              ; переход, если нижняя сторона не содержит средних плиток

                LD IX, Startup.BL3Fpart_5                                       ; средняя плитка нижней стороны рамки
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный прямоугольный спрайт с атрибутами
                DEC A
                JR .BottomEdge

.BottomRight    LD IX, Startup.BL3Fpart_6                                       ; правый нижний угол рамки
                LD DE, #0101
                CALL DrawRawSprite                                              ; вывести непрозрачный прямоугольный спрайт с атрибутами
                RET

.Position       DW #0000                                                        ; координаты BC левого верхнего угла рамки
.Width          DB #00                                                          ; число средних плиток горизонтальной стороны рамки
.Height         DB #00                                                          ; число средних рядов вертикальной стороны рамки
BL3Fpart_0      INCBIN "Assets/Gfx/raw/BL3_frame_part_0.ink"                    ; графический ресурс, исходное смещение #1180
BL3Fpart_0Attr  INCBIN "Assets/Gfx/raw/BL3_frame_part_0.attr"                   ; графический ресурс, исходное смещение #1188
BL3Fpart_1      INCBIN "Assets/Gfx/raw/BL3_frame_part_1.ink"                    ; графический ресурс, исходное смещение #1189
BL3Fpart_1Attr  INCBIN "Assets/Gfx/raw/BL3_frame_part_1.attr"                   ; графический ресурс, исходное смещение #1191
BL3Fpart_2      INCBIN "Assets/Gfx/raw/BL3_frame_part_2.ink"                    ; графический ресурс, исходное смещение #1192
BL3Fpart_2Attr  INCBIN "Assets/Gfx/raw/BL3_frame_part_2.attr"                   ; графический ресурс, исходное смещение #119A
BL3Fpart_3      INCBIN "Assets/Gfx/raw/BL3_frame_part_3.ink"                    ; графический ресурс, исходное смещение #119B
BL3Fpart_3Attr  INCBIN "Assets/Gfx/raw/BL3_frame_part_3.attr"                   ; графический ресурс, исходное смещение #11A3
BL3Fpart_4      INCBIN "Assets/Gfx/raw/BL3_frame_part_4.ink"                    ; графический ресурс, исходное смещение #11A4
BL3Fpart_4Attr  INCBIN "Assets/Gfx/raw/BL3_frame_part_4.attr"                   ; графический ресурс, исходное смещение #11AC
BL3Fpart_5      INCBIN "Assets/Gfx/raw/BL3_frame_part_5.ink"                    ; графический ресурс, исходное смещение #11AD
BL3Fpart_5Attr  INCBIN "Assets/Gfx/raw/BL3_frame_part_5.attr"                   ; графический ресурс, исходное смещение #11B5
BL3Fpart_6      INCBIN "Assets/Gfx/raw/BL3_frame_part_6.ink"                    ; графический ресурс, исходное смещение #11B6
BL3Fpart_6Attr  INCBIN "Assets/Gfx/raw/BL3_frame_part_6.attr"                   ; графический ресурс, исходное смещение #11BE
BL3Fpart_7      INCBIN "Assets/Gfx/raw/BL3_frame_part_7.ink"                    ; графический ресурс, исходное смещение #11BF
BL3Fpart_7Attr  INCBIN "Assets/Gfx/raw/BL3_frame_part_7.attr"                   ; графический ресурс, исходное смещение #11C7
