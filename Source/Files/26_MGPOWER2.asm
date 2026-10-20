; начальные магические параметры подвижных армий, уровень сложности 2
; файл загружается в логический банк 3 по #D2EA независимо от адреса в каталоге
; счётчик каждой группы расходуется при создании очередной внешней армии
                module S26
                org #806E

; континент 1, 160 создаваемых армий
Continent1      ; последовательность записей FArmyManaPool
.ManaGroup1     DB #50                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #0000                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0000                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup2     DB #0A                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #0000                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0064                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup3     DB #0A                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #0BB8                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0000                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup4     DB #1E                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #00C8                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #000A                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup5     DB #1E                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #01F4                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #000A                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы

; континент 2, 180 создаваемых армий
Continent2      ; последовательность записей FArmyManaPool
.ManaGroup1     DB #46                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #0000                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0000                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup2     DB #1E                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #01F4                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0000                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup3     DB #1E                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #03E8                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0005                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup4     DB #1E                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #03E8                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #000F                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup5     DB #14                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #03E8                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #001E                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы

; континент 3, 190 создаваемых армий
Continent3      ; последовательность записей FArmyManaPool
.ManaGroup1     DB #46                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #0000                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0000                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup2     DB #1E                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #01F4                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0000                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup3     DB #1E                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #00C8                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #000A                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup4     DB #1E                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #0064                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0014                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup5     DB #14                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #00C8                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #001E                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup6     DB #0A                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #00C8                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0032                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы

; континент 4, 214 создаваемых армий
Continent4      ; последовательность записей FArmyManaPool
.ManaGroup1     DB #46                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #0000                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0000                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup2     DB #1E                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #3A98                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0000                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup3     DB #1E                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #00C8                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0014                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup4     DB #1E                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #00FA                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0019                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup5     DB #14                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #00C8                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0023                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup6     DB #14                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #00C8                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #0032                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы
.ManaGroup7     DB #0E                                                          ; FArmyManaPool.Remaining, число армий с этой парой параметров
                DW #00C8                                                        ; FArmyManaPool.Mana, начальная магическая сила
                DW #004B                                                        ; FArmyManaPool.ManaRegen, пополнение магической силы

                assert $ = #80E1
                endmodule
