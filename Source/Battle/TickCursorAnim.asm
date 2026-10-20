
; -----------------------------------------
; обновить кадр анимированного курсора выбранной клетки
; Timer уменьшается при каждом вызове, пока он ненулевой, экран и кадр не меняются
; при нуле счётчик перезагружается из изменяемого слова Delay, Frame циклически меняется от 1 до 4
; после HALT RestoreCursor убирает предыдущий кадр, выбранные 128 байтов пикселей накладываются OR
; область курсора занимает четыре на четыре знакоместа, атрибуты сохраняются из фона клетки
; In:
;   BC клетка, SaveCursorBack.Timer и Frame состояние анимации
; Out:
;   при истечении Timer на экране следующий кадр курсора
; Corrupt:
;   HL, DE, BC, AF, Timer, Frame и пиксели курсора, IX и IY сохранены
; -----------------------------------------
TickCursorAnim  LD HL, (Battle.SaveCursorBack.Timer)
                DEC HL
                LD (Battle.SaveCursorBack.Timer), HL
                LD A, L
                OR H
                RET NZ                                                          ; выход, если задержка следующего кадра ещё не истекла

.Delay          EQU $+1                                                         ; изменяемый операнд HL длительности кадра курсора
                LD HL, #0001
                LD (Battle.SaveCursorBack.Timer), HL
                LD A, (Battle.SaveCursorBack.Frame)
                INC A
                LD (Battle.SaveCursorBack.Frame), A
                CP #05
                JR NZ, .DrawFrame                                               ; переход, если номер следующего кадра меньше пяти

                LD A, #01
                LD (Battle.SaveCursorBack.Frame), A
.DrawFrame      HALT
                CALL RestoreCursor                                              ; восстановить фон под курсором клетки
                INC B
                SLA B
                SLA B
                SLA C
                SLA C
                LD HL, Data.Battle.CursorFrame1 - 128                           ; база перед первым128байтным кадром курсора, цикл сначала добавляет128
                LD DE, #0080
.FrameOffset    ADD HL, DE
                DEC A
                JR NZ, .FrameOffset                                             ; переход, если ещё не достигнут выбранный кадр ресурса

                EX DE, HL
                CALL Engine.CellAddress                                         ; вычислить ZX-адрес верхней пиксельной строки знакоместа
                LD B, #04
.CharacterRow   PUSH BC
                PUSH HL
                LD B, #08
.PixelRow       PUSH HL
                PUSH BC
                LD B, #04
.PixelBytes     LD A, (DE)
                OR (HL)
                LD (HL), A
                INC HL
                INC DE
                DJNZ .PixelBytes

                POP BC
                POP HL
                INC H
                DJNZ .PixelRow

                POP HL
                POP BC
                LD A, L
                ADD A, #20
                LD L, A
                JR NC, .NextCharRow                                             ; переход, если следующий ряд знакомест остаётся в той же трети экрана

                LD A, H
                ADD A, #08
                LD H, A
.NextCharRow    DJNZ .CharacterRow

                RET
