
; -----------------------------------------
; движение курсора на один пиксель вниз в пределах меню
; Если старый y не равен maxY IX+4, записывает y+1 в #76C1.
; In:
;   IX — меню, #76BF — старый y
; Out:
;   новая координата при допустимом шаге
; Corrupt:
;   AF
; -----------------------------------------
CursorDown      LD A, (Startup.RotateCursorL.PixelY)
                CP (IX + FMenuHeader.MaxY)
                RET Z                                                           ; выход, если курсор достиг нижней границы меню

                INC A
                LD (Startup.RotateCursorL.HitY), A
                RET
