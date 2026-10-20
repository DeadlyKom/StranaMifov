; скользящее окно трёх соседних масок строк для проверки общего препятствия
; проверено по коду, BuildField.TestMask
                struct FObstacleRows
First           DB #00                                                          ; маска First строки в скользящем окне препятствий
Second          DB #00                                                          ; маска Second строки в скользящем окне препятствий
Third           DB #00                                                          ; маска Third строки в скользящем окне препятствий
                ends
                assert FObstacleRows = 3
