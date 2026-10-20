
; -----------------------------------------
; поиск прямоугольника меню под пиксельным курсором
; Перебирает IX+0 областей по 4 байта от IX+7. Умножает left, top, right, bottom на 8, проверяет
; left<=x<right и top<=y<bottom по позиции #76C0. При совпадении возвращает порядковый номер и IY.
; При отсутствии A=0, IY=0. Координаты 0..31 по x и 0..23 по y переводятся в байты без расширения.
; In:
;   IX — дескриптор меню, #76C0 — позиция
; Out:
;   A=1..N, IY — четверка найденной области, A=0, IY=0 если вне областей
; Corrupt:
;   HL, DE, BC, AF, IY
; -----------------------------------------
HitTestMenu     PUSH IX
                POP IY
                LD DE, #0007
                ADD IY, DE
                LD B, (IX + FMenuHeader.Count)

                ; перевод границ прямоугольника из знакомест в пиксели для проверки позиции курсора
.RectangleLoop  PUSH BC
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
                LD BC, (Startup.RotateCursorL.HitPos)
                LD A, C
                CP L
                JR C, .NextRectangle                                            ; переход, если курсор находится левее прямоугольника

                CP E
                JR NC, .NextRectangle                                           ; переход, если курсор достиг правого края прямоугольника или правее

                LD A, B
                CP H
                JR C, .NextRectangle                                            ; переход, если курсор находится выше прямоугольника

                CP D
                JR C, .RectangleFound                                           ; переход, если курсор находится внутри нижней границы прямоугольника

.NextRectangle  LD DE, #0004
                ADD IY, DE
                POP BC
                DJNZ .RectangleLoop

                XOR A
                LD IY, #0000
                RET

.RectangleFound POP BC
                LD A, (IX + FMenuHeader.Count)
                INC A
                SUB B
                RET
