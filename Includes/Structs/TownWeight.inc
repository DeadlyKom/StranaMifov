; весовая запись выбора типа отряда в городе
; проверено по коду, Startup.PromptGameDisk.TownUnitWeight сравнивает A с первым байтом и получает UnitID из второго, порядок обратен FWeightedType
                struct FTownWeight
Threshold       DB #00                                                          ; верхняя исключённая граница случайного выбора
UnitID          DB #00                                                          ; идентификатор предлагаемого городу типа существа
                ends
                assert FTownWeight = 2
