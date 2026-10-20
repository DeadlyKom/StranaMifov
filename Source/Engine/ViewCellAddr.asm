
; -----------------------------------------
; найти экранный объект клетки и связанное численное поле
; IX=#6571+160*B+20*C, HL=#6931+16*B+2*C, экранная сетка 8 столбцов на 6 строк, DE, BC, AF
; сохранены
; In:
;   BC, B строка 0..5 и C столбец 0..7 объектной сетки
; Out:
;   HL адрес двухбайтного численного поля, IX адрес двадцатибайтной записи объекта, DE, BC, AF
;   сохранены
; Corrupt:
;   изменяются HL и IX. DE, BC, AF, IY сохранены
; -----------------------------------------
ViewCellAddr    PUSH DE
                PUSH BC
                PUSH AF
                LD IX, State.ViewObjects - 9 * FScreenObject20                  ; база перед объектами с учётом предварительных инкрементов строки и колонки
                LD HL, State.ViewCounts - 9 * FWord                             ; база перед численными подписями с учётом предварительных инкрементов координат
                INC B
.RowOffset      LD DE, #00A0
                ADD IX, DE
                LD DE, #0010
                ADD HL, DE
                DJNZ .RowOffset

                LD B, C
                INC B
                LD DE, #0014
.ColumnOffset   ADD IX, DE
                INC HL
                INC HL
                DJNZ .ColumnOffset

                POP AF
                POP BC
                POP DE
                RET
