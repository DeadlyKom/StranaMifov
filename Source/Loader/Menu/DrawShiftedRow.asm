
; -----------------------------------------
; вывод строки байтов со сдвигом по горизонтали
; Строит маски по позиции A. Каждый байт источника DE разбивает между текущим и следующим экранным
; байтом, сохраняя соседние биты. Последний фрагмент при A=7 целиком находится в текущем байте.
; Повторяет B раз.
; In:
;   HL — экран, DE — данные, B — число байтов, A — обратная позиция бита 0..7
; Out:
;   DE после данных, HL после выведенных байтов, B=0
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   экран, PrintChar.LeftMask..PrintChar.BitPosition
; -----------------------------------------
DrawShiftedRow  LD (PrintChar.BitPosition), A
                PUSH BC
                LD B, A
                INC B
                XOR A

                ; маски разделяют исходный байт на левую и правую части относительно экранной
                ; границы байта
.BuildMask      SCF
                RLA
                DJNZ .BuildMask

                LD (PrintChar.RightMask), A
                CPL
                LD (PrintChar.LeftMask), A
                POP BC

                ; один байт источника может затронуть две соседние экранные ячейки, остальные
                ; биты остаются прежними
.SourceByte     PUSH BC
                LD A, (DE)
                LD C, A
                LD A, (PrintChar.BitPosition)
                LD B, A
                LD A, #07
                SUB B
                JR Z, .MergeLeftPart                                            ; переход, если исходный байт уже выровнен и сдвиг правой части не требуется

                LD B, A
.ShiftRight     SRL C
                DJNZ .ShiftRight

.MergeLeftPart  LD A, (PrintChar.LeftMask)
                AND (HL)
                OR C
                LD (HL), A
                INC HL
                LD A, (PrintChar.BitPosition)
                CP #07
                JR Z, .NextByte                                                 ; переход, если исходный байт целиком помещается в текущем экранном байте

                INC A
                LD B, A
                LD A, (DE)
                LD C, A
.ShiftLeft      SLA C
                DJNZ .ShiftLeft

                LD A, (PrintChar.RightMask)
                AND (HL)
                OR C
                LD (HL), A
.NextByte       POP BC
                INC DE
                DJNZ .SourceByte

                RET
