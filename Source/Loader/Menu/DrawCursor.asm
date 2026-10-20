
; -----------------------------------------
; вывод маскированного пиксельного курсора
; Берёт рисунок и маску по CursorPixels/CursorMask, сдвигает их на x mod 8, объединяет
; экран как (фон AND
; маска) OR рисунок. На строке меняет до трёх байтов с проверкой границы строки, ограничивает низ
; экрана.
; In:
;   MenuState.CursorXY=x, MenuState.CursorY=y
; Out:
;   курсор выведен
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   экран, самомодификация DrawCursor.DrawY
; -----------------------------------------
DrawCursor      LD HL, MenuState.CursorXY
                LD C, (HL)
                INC HL
                LD A, #C0
                SUB (HL)
                RET C                                                           ; выход, если верх курсора уже ниже экрана

                RET Z                                                           ; выход, если курсор начинается сразу за последней строкой экрана

                CP #08
                JR C, .RowCount                                                 ; переход, если до нижнего края осталось меньше восьми строк

                LD A, #08
.RowCount       LD B, A
                LD A, (MenuState.CursorY)
                LD (DrawCursor.DrawY), A
                LD IX, CursorPixels

                ; двухбайтные рисунок и маска сдвигаются на остаток X по модулю 8
.DrawRow        PUSH BC
                PUSH BC
                LD B, C
                LD C, #00
.DrawY          EQU $ - 1                                                       ; счётчик пиксельных строк вывода курсора
                EX DE, HL
                CALL PixelAddress                                               ; адрес пиксельного байта и положение бита на экране ZX Spectrum
                EX DE, HL
                POP BC
                LD A, (DrawCursor.DrawY)
                INC A
                LD (DrawCursor.DrawY), A
                LD A, E
                OR D
                JR Z, .NextRow                                                  ; переход, если PixelAddress вернула недопустимый экранный адрес

                PUSH HL
                EX DE, HL
                PUSH HL
                LD A, C
                LD B, (IX + FMenuCursor.Pixels)
                LD D, (IX + FMenuCursor.Pixels + FWord.High)
                LD H, #00
                LD C, (IX + FMenuCursor.Mask)
                LD E, (IX + FMenuCursor.Mask + FWord.High)
                LD L, #FF
                AND #07
                JR Z, .MergeFirstByte                                           ; переход, если рисунок курсора уже выровнен по границе экранного байта

.ShiftRow       SRL B
                RR D
                RR H
                SCF
                RR C
                RR E
                RR L
                DEC A
                JR NZ, .ShiftRow                                                ; переход, если ещё не выполнен сдвиг на остаток X по модулю 8

                ; соседние пиксели сохраняются маской, затем к ним добавляется рисунок курсора
.MergeFirstByte EX (SP), HL
                LD A, C
                AND (HL)
                OR B
                LD (HL), A
                INC HL
                LD A, L
                AND #1F
                JR Z, .AdvancePattern                                           ; переход, если второй байт рисунка оказался за правым краем экрана

                LD A, E
                AND (HL)
                OR D
                LD (HL), A
                INC HL
                LD A, L
                AND #1F
                JR Z, .AdvancePattern                                           ; переход, если третий байт рисунка оказался за правым краем экрана

                POP DE
                PUSH DE
                LD A, E
                AND (HL)
                OR D
                LD (HL), A
.AdvancePattern POP DE
                INC IX
                INC IX
                POP HL
.NextRow        POP BC
                DJNZ .DrawRow

                RET
