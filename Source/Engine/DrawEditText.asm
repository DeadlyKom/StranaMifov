
; -----------------------------------------
; перерисовать поле редактирования
; длина из #6E9F, буфер из #6E9D, экранная позиция #6E9B, по #70C5 выводит все символы и
; завершающий пробел
; In:
;   поля #6E9B позиция, #6E9D буфер, #6E9F длина
; Out:
;   поле текста и следующий пробел перерисованы, HL, DE, BC, AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, переключение банка при выводе разрешает прерывания
; -----------------------------------------
DrawEditText    PUSH DE
                PUSH BC
                PUSH AF
                LD DE, (Engine.DrawEditText.TextBuffer)
                LD BC, (Engine.DrawEditText.TextPos)
                LD A, (Engine.DrawEditText.TextLength)
.CharLoop       PUSH AF
                LD A, (DE)
                CALL DrawGlyphEI                                                ; вывести символ с обычной процедурой переключения банка
                POP AF
                INC C
                INC DE
                DEC A
                JR NZ, .CharLoop                                                ; переход, если остались позиции редактируемой строки

                LD A, #20
                CALL DrawGlyphEI                                                ; вывести символ с обычной процедурой переключения банка
                POP AF
                POP BC
                POP DE
                RET

.TextPos        EQU $                                                           ; позиция редактируемой строки
.TextBuffer     EQU $+2                                                         ; адрес редактируемого буфера
.TextLength     EQU $+4                                                         ; число символов поля редактирования
                DB #00, #00, #00, #00, #00
