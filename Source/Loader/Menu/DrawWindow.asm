
; -----------------------------------------
; рисование окна по дескриптору
; Сохраняет IX как активное окно. Заполняет смещённый прямоугольник цветом тени и основной
; прямоугольник цветом окна, рисует горизонтальные и вертикальные края. Печатает заголовок после 7
; байтов дескриптора, затем задаёт начало текстового содержимого.
; In:
;   IX — x, y, ширина, высота, атрибут тени, атрибут окна, отступ текста, заголовок с нулём
; Out:
;   PixelAddress.Window — активное окно, PixelAddress.TextAttr..PixelAddress.TextX — параметры печати
; Corrupt:
;   HL, DE, BC, AF, IX сохраняет адрес дескриптора
; Note:
;   экран и параметры печати
; -----------------------------------------

                ; описатель окна задаёт рамку, тень и начало текста, этот формат отличается от
                ; FMenuHeader игрового ядра
DrawWindow      LD (PixelAddress.Window), IX
                LD B, (IX + FMenuWindow.X)
                LD C, (IX + FMenuWindow.Y)
                PUSH BC
                PUSH BC
                INC C
                INC B
                LD A, (IX + FMenuWindow.ShadowAttr)
                CALL FillWindowAttrs                                            ; заполнение прямоугольника атрибутов окна
                POP BC
                LD A, (IX + FMenuWindow.WindowAttr)
                CALL FillWindowAttrs                                            ; заполнение прямоугольника атрибутов окна
                POP BC
                LD A, C
                ADD A, (IX + FMenuWindow.Height)
                PUSH BC
                LD E, #FF
                CALL DrawHBorder                                                ; рисование горизонтальной границы окна
                POP BC
                PUSH BC
                LD A, C
                INC A
                LD E, #00
                CALL DrawHBorder                                                ; рисование горизонтальной границы окна
                POP BC
                PUSH BC
                LD A, C
                INC A
                ADD A, A
                ADD A, A
                ADD A, A
                INC A
                LD C, A
                LD A, B
                ADD A, A
                ADD A, A
                ADD A, A
                LD B, A
                LD A, (IX + FMenuWindow.Height)
                DEC A
                ADD A, A
                ADD A, A
                ADD A, A
                DEC A
                DEC A
                LD D, A

                ; боковые границы выводятся одновременно с очисткой внутренних пиксельных байтов
                ; каждой строки
.BorderRow      CALL PixelAddress                                               ; адрес пиксельного байта и положение бита на экране ZX Spectrum
                LD (HL), #80
                INC HL
                PUSH BC
                LD B, (IX + FMenuWindow.Width)
                DEC B
                DEC B
.ClearInnerRow  LD (HL), #00
                INC HL
                DJNZ .ClearInnerRow

                POP BC
                LD (HL), #01
                INC C
                DEC D
                JR NZ, .BorderRow                                               ; переход, если остаются пиксельные строки боковых границ

                POP BC
                LD D, C
                LD E, B
                LD A, (IX + FMenuWindow.Width)
                CALL SwapAttrStrip                                              ; обмен цветов INK и PAPER в полосе атрибутов
                LD A, (IX + FMenuWindow.X)
                ADD A, A
                ADD A, A
                ADD A, A
                LD (PixelAddress.TextX), A
                LD A, (IX + FMenuWindow.Y)
                ADD A, A
                ADD A, A
                ADD A, A
                LD (PixelAddress.TextY), A
                LD A, (IX + FMenuWindow.WindowAttr)
                CALL SwapAttrColors                                             ; обмен INK и PAPER одного атрибута
                LD (PixelAddress.TextAttr), A
                PUSH IX
                POP HL
                LD BC, #0007
                ADD HL, BC
                CALL PrintString                                                ; печать строки с управляющими кодами
                LD A, (IX + FMenuWindow.Y)
                INC A
                INC A
                ADD A, A
                ADD A, A
                ADD A, A
                LD (PixelAddress.TextY), A
                LD (PixelAddress.TextBaseY), A
                LD A, (IX + FMenuWindow.X)
                ADD A, A
                ADD A, A
                ADD A, A
                ADD A, (IX + FMenuWindow.TextIndent)
                LD (PixelAddress.TextX), A
                LD (PixelAddress.TextBaseX), A
                LD A, (IX + FMenuWindow.WindowAttr)
                LD (PixelAddress.TextAttr), A
                RET
