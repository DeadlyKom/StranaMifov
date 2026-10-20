; соответствие кода клавиши номеру оверлея
; проверено по коду, MainLoop.CommandLoop и ApplyMoveCode.CommandLoop обходят пары из State.OverlayKeys
                struct FOverlayKey
Code            DB #00                                                          ; код команды, ноль завершает список
Overlay         DB #00                                                          ; номер загружаемого оверлея
                ends
                assert FOverlayKey = 2
