; фиксированная часть строки титров, далее текст с нулём
; проверено по коду, Presentation.CreditLine и EraseCredit, IX+3 начинает текст переменной длины
                struct FCreditLine
Attribute       DB #00                                                          ; цвет строки титров
X               DB #00                                                          ; столбец строки
Y               DB #00                                                          ; строка экрана
                ends
                assert FCreditLine = 3
