; база и случайная добавка количества нападающего отряда
; проверено по коду, TickCastle.BuildAttackers читает HL из+0/+1, DE из+2/+3, вызывает RandomScaled и складывает HL+DE
                struct FTroopRange
BaseCount       FWord                                                           ; исходное количество
CountRange      FWord                                                           ; предел случайной добавки
                ends
                assert FTroopRange = 4
