
; -----------------------------------------
; обратимая подсветка области меню обменом INK и PAPER
; По четверке символьных границ IY вычисляет адрес #5800+32*top+left и проходит
; (bottom-top)*(right-left) атрибутов. Меняет местами биты 0..2 и 3..5. BRIGHT и FLASH сохраняет
; через AND #C0. Второй вызов с теми же границами возвращает исходные цвета.
; In:
;   IY — left, top, right, bottom, положительные ширина и высота
; Out:
;   область инвертирована, IY сохранён
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   атрибуты экрана
; -----------------------------------------
ToggleMenuInk   LD H, #00
                LD L, (IY + FMenuRect.Top)                                      ; +#01, верхняя включённая граница
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD DE, Screen.Attributes                                        ; база атрибутной памяти, далее добавляется смещение выбранного знакоместа
                ADD HL, DE
                LD D, #00
                LD E, (IY + FMenuRect.Left)                                     ; +#00, левая включённая граница
                ADD HL, DE
                LD A, (IY + FMenuRect.Bottom)                                   ; +#03, нижняя исключённая граница
                SUB (IY + FMenuRect.Top)                                        ; +#01, верхняя включённая граница
                LD B, A
.AttributeRow   PUSH BC
                PUSH HL
                LD A, (IY + FMenuRect.Right)                                    ; +#02, правая исключённая граница
                SUB (IY + FMenuRect.Left)                                       ; +#00, левая включённая граница
                LD B, A

                ; обмен трёхбитовых полей INK и PAPER при сохранении FLASH и BRIGHT
.SwapInkPaper   LD A, (HL)
                LD D, A
                AND #38
                LD E, A
                LD A, D
                AND #07
                SRL E
                SRL E
                SRL E
                RLCA
                RLCA
                RLCA
                OR E
                LD E, A
                LD A, D
                AND #C0
                OR E
                LD (HL), A
                INC HL
                DJNZ .SwapInkPaper

                POP HL
                LD BC, #0020
                ADD HL, BC
                POP BC
                DJNZ .AttributeRow

                RET
