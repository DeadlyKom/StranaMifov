
; -----------------------------------------
; сохранение или восстановление фона курсора
; По позиции MenuState.CursorXY сохраняет три экранных байта на каждой из максимум восьми
; строк в #6C31 или
; восстанавливает их обратно. Внизу экрана число строк ограничено 192-y.
; In:
; C bit 7=0 сохранить фон, C bit 7=1 восстановить, MenuState.CursorXY=x,
; MenuState.CursorY=y
; Out:
;   фон сохранён или экран восстановлен
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   #6C31..#6C48 или экран, самомодификация CursorBackdrop.BackdropY
; -----------------------------------------
CursorBackdrop  LD HL, MenuState.CursorXY
                LD A, (HL)
                RRA
                RRA
                RRA
                AND #1F
                OR C
                LD C, A
                INC HL
                LD A, #C0
                SUB (HL)
                RET C                                                           ; выход, если верх курсора расположен ниже экрана

                RET Z                                                           ; выход, если верх курсора расположен сразу за последней строкой экрана

                CP #08
                JR C, .RowCount                                                 ; переход, если до нижнего края осталось меньше восьми строк

                LD A, #08
.RowCount       LD B, A
                LD A, (MenuState.CursorY)
                LD (CursorBackdrop.BackdropY), A
                LD DE, Loader.Menu.MenuState                                    ; 24 байта сохранённого фона под курсором меню

                ; фон курсора состоит из трёх байтов на строку, нижняя граница ограничивает
                ; число строк
.CopyRow        PUSH BC
                LD A, C
                AND #1F
                SLA A
                SLA A
                SLA A
                LD B, A
                LD C, #00
.BackdropY      EQU $ - 1                                                       ; счётчик пиксельных строк сохранения фона курсора
                CALL PixelAddress                                               ; адрес пиксельного байта и положение бита на экране ZX Spectrum
                POP BC
                LD A, (CursorBackdrop.BackdropY)
                INC A
                LD (CursorBackdrop.BackdropY), A
                BIT CUR_RESTORE_BIT, C                                          ; флаг, восстановить фон курсора из буфера, при 0 сохранить экранный фон в буфер
                JR Z, .CopyThreeBytes                                           ; переход, если требуется сохранить фон из экрана в буфер

                EX DE, HL
.CopyThreeBytes PUSH BC
                LDI
                LDI
                LDI
                POP BC
                BIT CUR_RESTORE_BIT, C                                          ; флаг, восстановить фон курсора из буфера, при 0 сохранить экранный фон в буфер
                JR Z, .NextRow                                                  ; переход, если фон сохранялся и указатели источника с назначением не менялись местами

                EX DE, HL
.NextRow        DJNZ .CopyRow

                RET
