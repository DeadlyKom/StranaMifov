
; -----------------------------------------
; движение курсора на один пиксель влево в пределах меню
; Если старый x #76BE не равен minX IX+1, записывает x-1 в #76C0.
; In:
;   IX — меню, #76BE — старый x
; Out:
;   новый x при допустимом шаге
; Corrupt:
;   AF
; -----------------------------------------
CursorLeft      LD A, (Startup.RotateCursorL.PixelPos)
                CP (IX + FMenuHeader.MinX)
                RET Z                                                           ; выход, если курсор достиг левой границы меню

                DEC A
                LD (Startup.RotateCursorL.HitPos), A
                RET
