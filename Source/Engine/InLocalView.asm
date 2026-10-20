
; -----------------------------------------
; проверить попадание координат BC в прямоугольник локального окна
; левая/верхняя границы #853F/#8540, правая/нижняя #8541/#8542, все границы включены, carry=1
; внутри, carry=0 снаружи
; In:
;   BC координаты клетки
; Out:
;   AF, carry=1 внутри включительных границ #853F..#8542, остальные регистры сохранены
; Corrupt:
;   AF
; -----------------------------------------
InLocalView     LD A, (Engine.PlaceViewLayer.ViewRight)
                CP C
                JR C, .OutsideView                                              ; переход, если клетка правее правой границы окна

                LD A, (Engine.PlaceViewLayer.ViewLeft)
                CP C
                JR Z, .CheckRow                                                 ; переход, если клетка находится на левой включённой границе

                JR NC, .OutsideView                                             ; переход, если клетка левее левой границы окна

.CheckRow       LD A, (Engine.PlaceViewLayer.ViewBottom)
                CP B
                JR C, .OutsideView                                              ; переход, если клетка ниже нижней границы окна

                LD A, (Engine.PlaceViewLayer.ViewTop)
                CP B
                JR Z, .InsideView                                               ; переход, если клетка находится на верхней включённой границе

                JR C, .InsideView                                               ; переход, если клетка ниже верхней границы и остаётся внутри окна

.OutsideView    OR A
                RET

.InsideView     SCF
                RET
