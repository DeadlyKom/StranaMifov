; фиксированная часть меню, далее N записей FMenuRect
                struct FMenuHeader
Count           DB #00                                                          ; число пунктов меню
MinX            DB #00                                                          ; минимальная X указателя
MinY            DB #00                                                          ; минимальная Y указателя
MaxX            DB #00                                                          ; максимальная X указателя
MaxY            DB #00                                                          ; максимальная Y указателя
CursorX         DB #00                                                          ; сохраняемая пиксельная X указателя
CursorY         DB #00                                                          ; сохраняемая пиксельная Y указателя
                ends
                assert FMenuHeader = 7
