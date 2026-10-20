; запись каталога TRDOS
; проверено по коду, Loader.Menu.FindFile сверяет первые9байтов и копирует16байтов в #5CDD
                struct FTrdosEntry
Name            DS 8, #00                                                       ; имя файла, первый байт0 конец каталога и1 удалённая запись
Type            DB #00                                                          ; тип файла
Start           FWord                                                           ; адрес загрузки
Length          FWord                                                           ; длина файла в байтах
Sectors         DB #00                                                          ; число секторов файла
Sector          DB #00                                                          ; начальный сектор
Track           DB #00                                                          ; начальная дорожка
                ends
                assert FTrdosEntry = 16
