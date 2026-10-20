
; -----------------------------------------
; ввести строку ограниченной длины с мигающим курсором
; сохраняет BC в 6FA3, IX буфер в 6FA5, максимальную длину A в 6FA7, текущую позицию BC в 61D2,
; ставит бит 5 поля 61D5 для прерывания, H хранит предел и L введённую длину, 6F81 обновляет
; строку, 6FA8 возвращает допустимый код, 0C удаляет предыдущий символ с заменой пробелом, 0D/0E
; завершают и сбрасывают бит 5, остальные коды записываются пока L<H, выходное поле не получает
; нулевого терминатора
; In:
;   BC позиция строки, A предел длины>0, IX буфер не короче A байтов, флаги 61D5 задают
;   допустимый алфавит
; Out:
;   буфер содержит введённые символы, A код завершения 0D/0E, L число введённых, H предел,
;   прерывания разрешены
; Corrupt:
;   HL, DE, AF, IX
; -----------------------------------------
EditText        LD (Startup.DrawEditBuffer.Position), BC
                LD (Startup.DrawEditBuffer.Buffer), IX
                LD (Startup.DrawEditBuffer.MaxLength), A
                LD (Startup.Interrupt.CursorPos), BC
                LD H, A
                LD L, #00
                LD A, (Startup.Interrupt.EditFlags)
                SET TEXT_CURSOR_BIT, A                                          ; флаг, прерывание рисует мигающий текстовый курсор
                LD (Startup.Interrupt.EditFlags), A
                EI
.Redraw         CALL DrawEditBuffer                                             ; перерисовать поле редактирования и стереть символ за его концом
.ReadChar       CALL ReadEditChar                                               ; дождаться допустимого символа для строкового ввода
                CP #0E
                JR NZ, .TestEditKey                                             ; переход, если не нажата отмена редактирования

.FinishEdit     LD IX, Startup.Interrupt.EditAnchor
.FlagsOfs       EQU Startup.Interrupt.EditFlags - Startup.Interrupt.EditAnchor  ; смещение флагов относительно курсора EditAnchor
                RES TEXT_CURSOR_BIT, (IX + .FlagsOfs)                           ; флаг, прерывание рисует мигающий текстовый курсор
                CALL DrawEditBuffer                                             ; перерисовать поле редактирования и стереть символ за его концом
                RET

.TestEditKey    CP #0D
                JR Z, .FinishEdit                                               ; переход, если нажато подтверждение текста

                CP #0C
                JR NZ, .InsertChar                                              ; переход, если не нажато удаление последнего символа

                LD A, L
                OR A
                JR Z, .ReadChar                                                 ; переход, если буфер ввода уже пуст

                DEC L
                PUSH HL
                EX DE, HL
                LD D, #00
                LD HL, (Startup.DrawEditBuffer.Buffer)
                ADD HL, DE
                LD (HL), #20
                LD HL, (Startup.Interrupt.CursorPos)
                DEC L
                LD (Startup.Interrupt.CursorPos), HL
                POP HL
                JR .Redraw

.InsertChar     LD D, A
                LD A, L
                CP H
                JR Z, .ReadChar                                                 ; переход, если длина текста достигла предела

                LD A, D
                PUSH HL
                EX DE, HL
                LD D, #00
                LD HL, (Startup.DrawEditBuffer.Buffer)
                ADD HL, DE
                LD (HL), A
                LD HL, (Startup.Interrupt.CursorPos)
                INC L
                LD (Startup.Interrupt.CursorPos), HL
                POP HL
                INC L
                JR .Redraw
