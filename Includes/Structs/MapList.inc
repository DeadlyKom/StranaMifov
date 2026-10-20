; дескриптор списка объектов одного континента
                struct FMapList
Data            FWord                                                           ; адрес первой записи в банке выбранной группы
Count           FWord                                                           ; число записей little-endian, не размер в байтах
                ends
                assert FMapList = 4
