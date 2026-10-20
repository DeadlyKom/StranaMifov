; весовая запись выбора типа странствующей группы
; проверено по коду, Startup.CreateWanderers.WeightedType и UnitDescriptor, после выбора тип дополнительно проверяется по категории FSoldier
                struct FWeightedType
UnitID          DB #00                                                          ; идентификатор типа существа
Threshold       DB #00                                                          ; верхняя исключённая граница случайного выбора
                ends
                assert FWeightedType = 2
