
; -----------------------------------------
; движение курсора на один пиксель вправо в пределах меню
; Если старый x не равен maxX IX+3, записывает x+1 в #76C0.
; In:
;   IX — меню, #76BE — старый x
; Out:
;   новый x при допустимом шаге
; Corrupt:
;   AF
; -----------------------------------------
CursorRight     LD A, (Startup.RotateCursorL.PixelPos)
                CP (IX + FMenuHeader.MaxX)
                RET Z                                                           ; выход, если курсор достиг правой границы меню

                INC A
                LD (Startup.RotateCursorL.HitPos), A
                RET
