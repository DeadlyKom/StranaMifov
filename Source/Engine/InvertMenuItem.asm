
; -----------------------------------------
; поменять местами INK и PAPER прямоугольного пункта меню
; IY [left, top, right, bottom] в знакоместах, для каждого атрибута сохраняет FLASH/BRIGHT и
; меняет младшую и среднюю тройки бит, повторный вызов восстанавливает исходный цвет
; In:
;   IY четыре байта [left, top, right, bottom] в знакоместах
; Out:
;   обмен INK/PAPER в прямоугольнике, IY и IX сохранены
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
InvertMenuItem  LD H, #00
                LD L, (IY + FMenuRect.Top)                                      ; +#01, верхняя включённая граница
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD DE, Screen.Attributes                                        ; основная область атрибутов экрана
                ADD HL, DE
                LD D, #00
                LD E, (IY + FMenuRect.Left)                                     ; +#00, левая включённая граница
                ADD HL, DE
                LD A, (IY + FMenuRect.Bottom)                                   ; +#03, нижняя исключённая граница
                SUB (IY + FMenuRect.Top)                                        ; +#01, верхняя включённая граница
                LD B, A

                ; перебор строк прямоугольника выбранного пункта
.RowLoop        PUSH BC
                PUSH HL
                LD A, (IY + FMenuRect.Right)                                    ; +#02, правая исключённая граница
                SUB (IY + FMenuRect.Left)                                       ; +#00, левая включённая граница
                LD B, A

                ; перестановка INK и PAPER при сохранении остальных битов атрибута
.AttributeLoop  LD A, (HL)
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
                DJNZ .AttributeLoop

                POP HL
                LD BC, #0020
                ADD HL, BC
                POP BC
                DJNZ .RowLoop

                RET
