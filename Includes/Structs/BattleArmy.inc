; пять плотных записей армии боя
; проверено по коду, SelectActor
                struct FBattleArmy
First           FBattleUnit                                                     ; боевой отряд First в массиве армии
Second          FBattleUnit                                                     ; боевой отряд Second в массиве армии
Third           FBattleUnit                                                     ; боевой отряд Third в массиве армии
Fourth          FBattleUnit                                                     ; боевой отряд Fourth в массиве армии
Fifth           FBattleUnit                                                     ; боевой отряд Fifth в массиве армии
                ends
                assert FBattleArmy = 90
