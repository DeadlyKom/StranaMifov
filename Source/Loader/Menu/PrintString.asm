
; -----------------------------------------
; печать строки с управляющими кодами
; Читает до нуля. #16 задаёт абсолютные пиксельные координаты x, y. #17 задаёт смещения от начала
; текста, x на 6 пикселей на знак, y на 8 на строку. #18 печатает вложенную строку по следующему
; 16-битному адресу. #10 меняет атрибут. Остальные байты передаёт выводу знака.
; In:
;   HL — строка
; Out:
;   HL — байт после терминатора
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   экран, PixelAddress.TextAttr/PixelAddress.TextY/PixelAddress.TextX
; -----------------------------------------
PrintString     LD A, (HL)
                INC HL
                AND A
                RET Z                                                           ; выход, если достигнут нулевой терминатор строки

                CP #16
                JR NZ, .CheckRelative                                           ; переход, если код не задаёт абсолютные координаты текста

                LD A, (HL)
                LD (PixelAddress.TextX), A
                INC HL
                LD A, (HL)
                INC HL
                LD (PixelAddress.TextY), A
                JR PrintString

                ; код #17 задаёт смещения от начала текста, по горизонтали один знак занимает
                ; шесть пикселей
.CheckRelative  CP #17
                JR NZ, .CheckNested                                             ; переход, если код не задаёт относительные координаты текста

                LD A, (PixelAddress.TextBaseX)
                LD B, A
                LD A, (HL)
                CALL MulSix                                                     ; умножение беззнакового байта на 6 по модулю 256
                ADD A, B
                LD (PixelAddress.TextX), A
                INC HL
                LD A, (PixelAddress.TextBaseY)
                LD B, A
                LD A, (HL)
                INC HL
                ADD A, A
                ADD A, A
                ADD A, A
                ADD A, B
                LD (PixelAddress.TextY), A
                JR PrintString

                ; код #18 вставляет строку по следующему двухбайтовому указателю и затем
                ; продолжает исходную
.CheckNested    CP #18
                JR NZ, .CheckAttribute                                          ; переход, если код не вставляет вложенную строку

                LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL
                PUSH HL
                EX DE, HL
                CALL PrintString                                                ; печать строки с управляющими кодами
                POP HL
                JR PrintString

.CheckAttribute CP #10
                JR NZ, .DrawChar                                                ; переход, если код не меняет атрибут печати

                LD A, (HL)
                LD (PixelAddress.TextAttr), A
                INC HL
                JR PrintString

.DrawChar       PUSH HL
                CALL PrintChar                                                  ; печать одного знака шестипиксельного шрифта
                POP HL
                JR PrintString
