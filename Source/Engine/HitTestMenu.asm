
; -----------------------------------------
; найти прямоугольник меню под пиксельным указателем
; IX+7 начало четырёхбайтных прямоугольников [left, top, right, bottom] в знакоместах, #79CC
; позиция в пикселях, границы слева/сверху включены, справа/снизу исключены, A номер 1..N и IY
; прямоугольник, при отсутствии A=0, IY=0
; In:
;   IX описатель меню, #79CC пиксельные координаты указателя
; Out:
;   AF, A номер 1..N либо 0, IY найденный прямоугольник либо 0, IX сохранён
; Corrupt:
;   HL, DE, BC, AF, IY
; -----------------------------------------
HitTestMenu     PUSH IX
                POP IY
                LD DE, #0007
                ADD IY, DE
                LD B, (IX + FMenuHeader.Count)                                  ; +#00, число пунктов меню

                ; перевод границ пункта из знакомест в пиксели для проверки указателя
.ItemLoop       PUSH BC
                LD L, (IY + FMenuRect.Left)                                     ; +#00, левая включённая граница
                SLA L
                SLA L
                SLA L
                LD H, (IY + FMenuRect.Top)                                      ; +#01, верхняя включённая граница
                SLA H
                SLA H
                SLA H
                LD D, (IY + FMenuRect.Bottom)                                   ; +#03, нижняя исключённая граница
                SLA D
                SLA D
                SLA D
                LD E, (IY + FMenuRect.Right)                                    ; +#02, правая исключённая граница
                SLA E
                SLA E
                SLA E
                LD BC, (Engine.ShiftCursorL.NewCursor)
                LD A, C
                CP L
                JR C, .NextItem                                                 ; переход, если указатель левее левой границы пункта

                CP E
                JR NC, .NextItem                                                ; переход, если указатель находится на правой границе пункта или правее

                LD A, B
                CP H
                JR C, .NextItem                                                 ; переход, если указатель выше верхней границы пункта

                CP D
                JR C, .ItemFound                                                ; переход, если указатель выше нижней исключённой границы пункта

.NextItem       LD DE, #0004
                ADD IY, DE
                POP BC
                DJNZ .ItemLoop

                XOR A
                LD IY, #0000
                RET

                ; возврат номера найденного пункта, нумерация начинается с единицы
.ItemFound      POP BC
                LD A, (IX + FMenuHeader.Count)                                  ; +#00, число пунктов меню
                INC A
                SUB B
                RET
