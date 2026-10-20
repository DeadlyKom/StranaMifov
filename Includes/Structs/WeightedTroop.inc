; весовая запись выбора типа и численности случайного отряда
; проверено по коду, Startup.GenerateArmy и PromptGameDisk.TroopWeight сравнивают случайное A с порогом и складывают BaseCount с RandomRange(CountRange)
                struct FWeightedTroop
UnitID          DB #00                                                          ; идентификатор типа существа
Threshold       DB #00                                                          ; верхняя исключённая граница случайного выбора, равный порогу результат пропускает запись
BaseCount       FWord                                                           ; исходное количество существ
CountRange      FWord                                                           ; предел добавки, передаваемый RandomRange с округлением результата
                ends
                assert FWeightedTroop = 6
