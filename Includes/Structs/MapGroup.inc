; описатель группы при поиске занятой клетки
; проверено по коду, FindMapObject загружает IX из слова+0, DE из+2, B/C из+3/+4 для FindRecord
                struct FMapGroup
Lists           FWord                                                           ; адрес таблицы FMapList по континентам
Stride          DB #00                                                          ; размер записи объекта
Rows            DB #00                                                          ; число занимаемых строк карты
Columns         DB #00                                                          ; число занимаемых столбцов карты
                ends
                assert FMapGroup = 5
