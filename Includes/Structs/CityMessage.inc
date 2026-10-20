; параметры сообщения об отношении города
; проверено по коду, Overlay.City.Entry.FindCityDesc, далее BottomFrame и PrintMessage
                struct FCityMessage
Attribute       DB #00                                                          ; атрибут нижнего окна
Position        FWord                                                           ; координаты BC печати сообщения
Text            FWord                                                           ; адрес текста сообщения
                ends
                assert FCityMessage = 5
