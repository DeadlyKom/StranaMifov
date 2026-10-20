; описатель окна скрытого меню
; проверено по коду, Loader.Menu.DrawWindow, FillWindowAttrs, DrawHBorder и PollMenu
                struct FMenuWindow
X               DB #00                                                          ; столбец окна в знакоместах
Y               DB #00                                                          ; строка окна в знакоместах
Width           DB #00                                                          ; ширина окна в знакоместах
Height          DB #00                                                          ; высота окна в знакоместах
ShadowAttr      DB #00                                                          ; атрибут смещённой тени
WindowAttr      DB #00                                                          ; атрибут основного прямоугольника
TextIndent      DB #00                                                          ; горизонтальный отступ текста в пикселях
                ends
                assert FMenuWindow = 7
