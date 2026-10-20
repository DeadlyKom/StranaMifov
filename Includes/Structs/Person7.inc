; дисковый вариант PERSON7 до нормализации,270байт. Нельзя усекать как обычный PERSON без выполнения алгоритма
                struct FPerson7
Prefix          DS 220, #00                                                     ; первые 220 байт совпадают по расположению с FPerson до UnitControl
ControlRanges   FByteRangeA25                                                   ; 25 пар FByteRange, загрузчик заменяет каждую пару одним коэффициентом на месте и оставляет первые 245 байт как FPerson
                ends
                assert FPerson7 = 270
