; ссылка на кадр в расширенной памяти
                struct FFrameRef
Bank            DB #00                                                          ; логический банк графического ресурса
Address         FWord                                                           ; адрес кадра в окне памяти
                ends
                assert FFrameRef = 3
