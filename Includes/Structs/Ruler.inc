; описатель правителя в DATA1
                struct FRuler
Name            DS 21, #00                                                      ; 21 символ имени вражеского правителя, дополнение пробелами
Terminator      DB #00                                                          ; ноль после имени
Mana            FWord                                                           ; текущая магическая сила
ManaMax         FWord                                                           ; максимум магической силы
ManaRegen       FWord                                                           ; пополнение магической силы за вызов восстановления
                ends
                assert FRuler = 28
