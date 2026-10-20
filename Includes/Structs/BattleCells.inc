; восемь кандидатов в порядке выбранного направления, First..Eighth не фиксированные стороны света
; проверено по коду, NeighboursN, NeighboursNE, NeighboursE, NeighboursSE, NeighboursS, NeighboursSW, NeighboursW, NeighboursNW
                struct FBattleCells
First           FBattleCell                                                     ; кандидат First
Second          FBattleCell                                                     ; кандидат Second
Third           FBattleCell                                                     ; кандидат Third
Fourth          FBattleCell                                                     ; кандидат Fourth
Fifth           FBattleCell                                                     ; кандидат Fifth
Sixth           FBattleCell                                                     ; кандидат Sixth
Seventh         FBattleCell                                                     ; кандидат Seventh
Eighth          FBattleCell                                                     ; кандидат Eighth
                ends
                assert FBattleCells = 24
