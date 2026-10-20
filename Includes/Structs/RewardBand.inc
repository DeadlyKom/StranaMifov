; порог и сотни базовой стоимости случайной награды
; проверено по коду, Overlay.Treasure.Entry.ChooseReward сравнивает случайный байт с Threshold, затем передаёт Hundreds в калькулятор и умножает на100
                struct FRewardBand
Threshold       DB #00                                                          ; верхний порог случайного выбора
Hundreds        DB #00                                                          ; базовая стоимость награды в сотнях
                ends
                assert FRewardBand = 2
