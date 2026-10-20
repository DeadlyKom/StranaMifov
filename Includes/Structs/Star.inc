; координаты звезды заставки
; проверено по коду, Presentation.Present.CheckDuplicate, InitStars и MoveStars
                struct FStar
Y               DB #00                                                          ; вертикальная пиксельная координата
X               DB #00                                                          ; горизонтальная пиксельная координата
                ends
                assert FStar = 2
