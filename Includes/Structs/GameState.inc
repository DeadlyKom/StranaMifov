; полный256байтный заголовок состояния, включает героя и глобальные события
                struct FGameState
Hero            DB #00                                                          ; номер выбранного героя 1..8
Difficulty      DB #00                                                          ; сложность 1..3
SaveName        DS 8, #00                                                       ; 8 символьное имя файла сохранения
Terminator      DB #00                                                          ; терминатор после имени файла
Person          FPerson                                                         ; FPerson, шаблон персонажа после нормализации PERSON7
                ends
                assert FGameState = 256
