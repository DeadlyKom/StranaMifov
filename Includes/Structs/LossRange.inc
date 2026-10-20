; пределы потерь гарнизона по сложности
; проверено по коду, TickCastle после выбора Difficulty*2 передаёт+1 в RandomScaled и прибавляет+0
                struct FLossRange
Base            DB #00                                                          ; исходный процент потерь
Range           DB #00                                                          ; предел случайной добавки к проценту
                ends
                assert FLossRange = 2
