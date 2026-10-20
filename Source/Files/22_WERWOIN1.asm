; таблицы случайных отрядов, уровень сложности 1
; файл загружается в логический банк 3 по #CB1A независимо от адреса в каталоге
; блоки Sites, Roam, Castle и Army задают разные способы создания отрядов
                module S22
                org #8000

; гарнизоны шестибайтовых объектов, континент 1
SitesCont1      ; 25 записей FWeightedTroop
.Peasants       DB UnitID.Peasants, #28                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Soldiers       DB UnitID.Soldiers, #32                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Archers        DB UnitID.Archers, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spearmen       DB UnitID.Spearmen, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Cavalry        DB UnitID.Cavalry, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Knights        DB UnitID.Knights, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Nomads         DB UnitID.Nomads, #41                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0003                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0004                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Celts          DB UnitID.Celts, #00                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vikings        DB UnitID.Vikings, #4B                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0004                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0004                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Wolves         DB UnitID.Wolves, #64                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Orcs           DB UnitID.Orcs, #82                                             ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Elves          DB UnitID.Elves, #89                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ogres          DB UnitID.Ogres, #8E                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0004                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Trolls         DB UnitID.Trolls, #91                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Giants         DB UnitID.Giants, #96                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0001                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0001                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dragons        DB UnitID.Dragons, #97                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0001                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ghosts         DB UnitID.Ghosts, #B4                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0028                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Skeletons      DB UnitID.Skeletons, #BE                                        ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Zombies        DB UnitID.Zombies, #D2                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spectres       DB UnitID.Spectres, #D7                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vampires       DB UnitID.Vampires, #DC                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0001                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dwarves        DB UnitID.Dwarves, #FA                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Druids         DB UnitID.Druids, #FD                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Warlocks       DB UnitID.Warlocks, #FF                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0001                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0001                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Demons         DB UnitID.Demons, #00                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
                assert $ - SitesCont1 = 25 * FWeightedTroop

; гарнизоны шестибайтовых объектов, континент 2
SitesCont2      ; 25 записей FWeightedTroop
.Peasants       DB UnitID.Peasants, #1E                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0032                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Soldiers       DB UnitID.Soldiers, #2D                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0011                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Archers        DB UnitID.Archers, #37                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0010                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spearmen       DB UnitID.Spearmen, #41                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0007                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0006                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Cavalry        DB UnitID.Cavalry, #05                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Knights        DB UnitID.Knights, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Nomads         DB UnitID.Nomads, #4B                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Celts          DB UnitID.Celts, #50                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0004                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vikings        DB UnitID.Vikings, #5A                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Wolves         DB UnitID.Wolves, #82                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Orcs           DB UnitID.Orcs, #96                                             ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Elves          DB UnitID.Elves, #AA                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ogres          DB UnitID.Ogres, #B2                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0008                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Trolls         DB UnitID.Trolls, #BA                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0003                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0003                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Giants         DB UnitID.Giants, #BE                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0003                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dragons        DB UnitID.Dragons, #BF                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0001                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0001                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ghosts         DB UnitID.Ghosts, #C8                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0019                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Skeletons      DB UnitID.Skeletons, #D7                                        ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Zombies        DB UnitID.Zombies, #E6                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spectres       DB UnitID.Spectres, #E9                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0008                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vampires       DB UnitID.Vampires, #EB                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0003                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0007                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dwarves        DB UnitID.Dwarves, #F0                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Druids         DB UnitID.Druids, #F7                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Warlocks       DB UnitID.Warlocks, #FF                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0008                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Demons         DB UnitID.Demons, #00                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
                assert $ - SitesCont2 = 25 * FWeightedTroop

; гарнизоны шестибайтовых объектов, континент 3
SitesCont3      ; 25 записей FWeightedTroop
.Peasants       DB UnitID.Peasants, #0F                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0064                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0028                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Soldiers       DB UnitID.Soldiers, #1E                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Archers        DB UnitID.Archers, #28                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spearmen       DB UnitID.Spearmen, #37                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Cavalry        DB UnitID.Cavalry, #12                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Knights        DB UnitID.Knights, #14                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0003                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Nomads         DB UnitID.Nomads, #3E                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Celts          DB UnitID.Celts, #50                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vikings        DB UnitID.Vikings, #5F                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Wolves         DB UnitID.Wolves, #6E                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Orcs           DB UnitID.Orcs, #82                                             ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Elves          DB UnitID.Elves, #8C                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ogres          DB UnitID.Ogres, #91                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0007                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Trolls         DB UnitID.Trolls, #96                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0007                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0008                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Giants         DB UnitID.Giants, #99                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dragons        DB UnitID.Dragons, #9B                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0001                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ghosts         DB UnitID.Ghosts, #AA                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0050                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0046                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Skeletons      DB UnitID.Skeletons, #B9                                        ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0023                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Zombies        DB UnitID.Zombies, #C8                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0023                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spectres       DB UnitID.Spectres, #D4                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0006                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0009                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vampires       DB UnitID.Vampires, #DC                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0004                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0007                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dwarves        DB UnitID.Dwarves, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Druids         DB UnitID.Druids, #EB                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Warlocks       DB UnitID.Warlocks, #FA                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Demons         DB UnitID.Demons, #FF                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0003                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0007                                                        ; FWeightedTroop.CountRange, предел случайной добавки
                assert $ - SitesCont3 = 25 * FWeightedTroop

; гарнизоны шестибайтовых объектов, континент 4
SitesCont4      ; 25 записей FWeightedTroop
.Peasants       DB UnitID.Peasants, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Soldiers       DB UnitID.Soldiers, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Archers        DB UnitID.Archers, #14                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spearmen       DB UnitID.Spearmen, #23                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Cavalry        DB UnitID.Cavalry, #28                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Knights        DB UnitID.Knights, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Nomads         DB UnitID.Nomads, #37                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Celts          DB UnitID.Celts, #41                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vikings        DB UnitID.Vikings, #50                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Wolves         DB UnitID.Wolves, #00                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Orcs           DB UnitID.Orcs, #00                                             ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Elves          DB UnitID.Elves, #6E                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ogres          DB UnitID.Ogres, #82                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0007                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0008                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Trolls         DB UnitID.Trolls, #8C                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0004                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Giants         DB UnitID.Giants, #96                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dragons        DB UnitID.Dragons, #AA                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0006                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0007                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ghosts         DB UnitID.Ghosts, #00                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Skeletons      DB UnitID.Skeletons, #B2                                        ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0050                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0032                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Zombies        DB UnitID.Zombies, #B9                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0050                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0032                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spectres       DB UnitID.Spectres, #BE                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vampires       DB UnitID.Vampires, #CD                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dwarves        DB UnitID.Dwarves, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Druids         DB UnitID.Druids, #E1                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Warlocks       DB UnitID.Warlocks, #F5                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Demons         DB UnitID.Demons, #FF                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
                assert $ - SitesCont4 = 25 * FWeightedTroop

; типы странствующих групп, континент 1
RoamCont1       ; 25 записей FWeightedType
.Peasants       DB UnitID.Peasants, #00                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Soldiers       DB UnitID.Soldiers, #00                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Archers        DB UnitID.Archers, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Spearmen       DB UnitID.Spearmen, #00                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Cavalry        DB UnitID.Cavalry, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Knights        DB UnitID.Knights, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Nomads         DB UnitID.Nomads, #14                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Celts          DB UnitID.Celts, #1E                                            ; FWeightedType.UnitID и Threshold, порог выбора типа
.Vikings        DB UnitID.Vikings, #23                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Wolves         DB UnitID.Wolves, #3C                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Orcs           DB UnitID.Orcs, #50                                             ; FWeightedType.UnitID и Threshold, порог выбора типа
.Elves          DB UnitID.Elves, #64                                            ; FWeightedType.UnitID и Threshold, порог выбора типа
.Ogres          DB UnitID.Ogres, #6E                                            ; FWeightedType.UnitID и Threshold, порог выбора типа
.Trolls         DB UnitID.Trolls, #78                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Giants         DB UnitID.Giants, #00                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Dragons        DB UnitID.Dragons, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Ghosts         DB UnitID.Ghosts, #96                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Skeletons      DB UnitID.Skeletons, #B9                                        ; FWeightedType.UnitID и Threshold, порог выбора типа
.Zombies        DB UnitID.Zombies, #DC                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Spectres       DB UnitID.Spectres, #E6                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Vampires       DB UnitID.Vampires, #00                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Dwarves        DB UnitID.Dwarves, #F5                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Druids         DB UnitID.Druids, #FA                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Warlocks       DB UnitID.Warlocks, #FF                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Demons         DB UnitID.Demons, #00                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
                assert $ - RoamCont1 = 25 * FWeightedType

; типы странствующих групп, континент 2
RoamCont2       ; 25 записей FWeightedType
.Peasants       DB UnitID.Peasants, #00                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Soldiers       DB UnitID.Soldiers, #00                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Archers        DB UnitID.Archers, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Spearmen       DB UnitID.Spearmen, #00                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Cavalry        DB UnitID.Cavalry, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Knights        DB UnitID.Knights, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Nomads         DB UnitID.Nomads, #14                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Celts          DB UnitID.Celts, #28                                            ; FWeightedType.UnitID и Threshold, порог выбора типа
.Vikings        DB UnitID.Vikings, #41                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Wolves         DB UnitID.Wolves, #4B                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Orcs           DB UnitID.Orcs, #5F                                             ; FWeightedType.UnitID и Threshold, порог выбора типа
.Elves          DB UnitID.Elves, #7D                                            ; FWeightedType.UnitID и Threshold, порог выбора типа
.Ogres          DB UnitID.Ogres, #8C                                            ; FWeightedType.UnitID и Threshold, порог выбора типа
.Trolls         DB UnitID.Trolls, #96                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Giants         DB UnitID.Giants, #A0                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Dragons        DB UnitID.Dragons, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Ghosts         DB UnitID.Ghosts, #B4                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Skeletons      DB UnitID.Skeletons, #C3                                        ; FWeightedType.UnitID и Threshold, порог выбора типа
.Zombies        DB UnitID.Zombies, #D2                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Spectres       DB UnitID.Spectres, #DC                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Vampires       DB UnitID.Vampires, #E1                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Dwarves        DB UnitID.Dwarves, #EB                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Druids         DB UnitID.Druids, #FA                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Warlocks       DB UnitID.Warlocks, #FE                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Demons         DB UnitID.Demons, #FF                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
                assert $ - RoamCont2 = 25 * FWeightedType

; типы странствующих групп, континент 3
RoamCont3       ; 25 записей FWeightedType
.Peasants       DB UnitID.Peasants, #00                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Soldiers       DB UnitID.Soldiers, #00                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Archers        DB UnitID.Archers, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Spearmen       DB UnitID.Spearmen, #00                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Cavalry        DB UnitID.Cavalry, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Knights        DB UnitID.Knights, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Nomads         DB UnitID.Nomads, #14                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Celts          DB UnitID.Celts, #28                                            ; FWeightedType.UnitID и Threshold, порог выбора типа
.Vikings        DB UnitID.Vikings, #41                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Wolves         DB UnitID.Wolves, #4B                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Orcs           DB UnitID.Orcs, #55                                             ; FWeightedType.UnitID и Threshold, порог выбора типа
.Elves          DB UnitID.Elves, #6E                                            ; FWeightedType.UnitID и Threshold, порог выбора типа
.Ogres          DB UnitID.Ogres, #78                                            ; FWeightedType.UnitID и Threshold, порог выбора типа
.Trolls         DB UnitID.Trolls, #82                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Giants         DB UnitID.Giants, #91                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Dragons        DB UnitID.Dragons, #92                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Ghosts         DB UnitID.Ghosts, #9B                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Skeletons      DB UnitID.Skeletons, #AA                                        ; FWeightedType.UnitID и Threshold, порог выбора типа
.Zombies        DB UnitID.Zombies, #B9                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Spectres       DB UnitID.Spectres, #C8                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Vampires       DB UnitID.Vampires, #D2                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Dwarves        DB UnitID.Dwarves, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Druids         DB UnitID.Druids, #E6                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Warlocks       DB UnitID.Warlocks, #FA                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Demons         DB UnitID.Demons, #FF                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
                assert $ - RoamCont3 = 25 * FWeightedType

; типы странствующих групп, континент 4
RoamCont4       ; 25 записей FWeightedType
.Peasants       DB UnitID.Peasants, #00                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Soldiers       DB UnitID.Soldiers, #00                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Archers        DB UnitID.Archers, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Spearmen       DB UnitID.Spearmen, #00                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Cavalry        DB UnitID.Cavalry, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Knights        DB UnitID.Knights, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Nomads         DB UnitID.Nomads, #0A                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Celts          DB UnitID.Celts, #19                                            ; FWeightedType.UnitID и Threshold, порог выбора типа
.Vikings        DB UnitID.Vikings, #23                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Wolves         DB UnitID.Wolves, #28                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Orcs           DB UnitID.Orcs, #32                                             ; FWeightedType.UnitID и Threshold, порог выбора типа
.Elves          DB UnitID.Elves, #41                                            ; FWeightedType.UnitID и Threshold, порог выбора типа
.Ogres          DB UnitID.Ogres, #5A                                            ; FWeightedType.UnitID и Threshold, порог выбора типа
.Trolls         DB UnitID.Trolls, #6E                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Giants         DB UnitID.Giants, #91                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Dragons        DB UnitID.Dragons, #A5                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Ghosts         DB UnitID.Ghosts, #00                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Skeletons      DB UnitID.Skeletons, #00                                        ; FWeightedType.UnitID и Threshold, порог выбора типа
.Zombies        DB UnitID.Zombies, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Spectres       DB UnitID.Spectres, #B4                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Vampires       DB UnitID.Vampires, #C3                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Dwarves        DB UnitID.Dwarves, #00                                          ; FWeightedType.UnitID и Threshold, порог выбора типа
.Druids         DB UnitID.Druids, #D2                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
.Warlocks       DB UnitID.Warlocks, #EB                                         ; FWeightedType.UnitID и Threshold, порог выбора типа
.Demons         DB UnitID.Demons, #FF                                           ; FWeightedType.UnitID и Threshold, порог выбора типа
                assert $ - RoamCont4 = 25 * FWeightedType

; армии замков, континент 1
CastleCont1     ; 25 записей FWeightedTroop
.Peasants       DB UnitID.Peasants, #32                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Soldiers       DB UnitID.Soldiers, #3C                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Archers        DB UnitID.Archers, #4B                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spearmen       DB UnitID.Spearmen, #5A                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Cavalry        DB UnitID.Cavalry, #5F                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Knights        DB UnitID.Knights, #64                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Nomads         DB UnitID.Nomads, #6E                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0007                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Celts          DB UnitID.Celts, #7D                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0003                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vikings        DB UnitID.Vikings, #87                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0003                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0004                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Wolves         DB UnitID.Wolves, #A0                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Orcs           DB UnitID.Orcs, #AF                                             ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Elves          DB UnitID.Elves, #B4                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ogres          DB UnitID.Ogres, #B9                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0004                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Trolls         DB UnitID.Trolls, #BE                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0004                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Giants         DB UnitID.Giants, #00                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dragons        DB UnitID.Dragons, #C0                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0001                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ghosts         DB UnitID.Ghosts, #CD                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Skeletons      DB UnitID.Skeletons, #DC                                        ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Zombies        DB UnitID.Zombies, #EB                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spectres       DB UnitID.Spectres, #F5                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vampires       DB UnitID.Vampires, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dwarves        DB UnitID.Dwarves, #FF                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Druids         DB UnitID.Druids, #00                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Warlocks       DB UnitID.Warlocks, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Demons         DB UnitID.Demons, #00                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
                assert $ - CastleCont1 = 25 * FWeightedTroop

; армии замков, континент 2
CastleCont2     ; 25 записей FWeightedTroop
.Peasants       DB UnitID.Peasants, #0A                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0032                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0064                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Soldiers       DB UnitID.Soldiers, #14                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0064                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0032                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Archers        DB UnitID.Archers, #23                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spearmen       DB UnitID.Spearmen, #2D                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Cavalry        DB UnitID.Cavalry, #37                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Knights        DB UnitID.Knights, #41                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Nomads         DB UnitID.Nomads, #50                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Celts          DB UnitID.Celts, #5F                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vikings        DB UnitID.Vikings, #6E                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Wolves         DB UnitID.Wolves, #7D                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0028                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Orcs           DB UnitID.Orcs, #87                                             ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Elves          DB UnitID.Elves, #96                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ogres          DB UnitID.Ogres, #A5                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0008                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0004                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Trolls         DB UnitID.Trolls, #B9                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Giants         DB UnitID.Giants, #BE                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0003                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dragons        DB UnitID.Dragons, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ghosts         DB UnitID.Ghosts, #C3                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0032                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Skeletons      DB UnitID.Skeletons, #CD                                        ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0032                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Zombies        DB UnitID.Zombies, #D7                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0032                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spectres       DB UnitID.Spectres, #E1                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vampires       DB UnitID.Vampires, #E6                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0004                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dwarves        DB UnitID.Dwarves, #F5                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0019                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Druids         DB UnitID.Druids, #FF                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Warlocks       DB UnitID.Warlocks, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Demons         DB UnitID.Demons, #00                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
                assert $ - CastleCont2 = 25 * FWeightedTroop

; армии замков, континент 3
CastleCont3     ; 25 записей FWeightedTroop
.Peasants       DB UnitID.Peasants, #05                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #00C8                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #00C8                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Soldiers       DB UnitID.Soldiers, #0F                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0064                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0032                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Archers        DB UnitID.Archers, #23                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0028                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spearmen       DB UnitID.Spearmen, #2D                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0028                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Cavalry        DB UnitID.Cavalry, #37                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Knights        DB UnitID.Knights, #46                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Nomads         DB UnitID.Nomads, #50                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0028                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Celts          DB UnitID.Celts, #5F                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vikings        DB UnitID.Vikings, #6E                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0028                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Wolves         DB UnitID.Wolves, #73                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0096                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0032                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Orcs           DB UnitID.Orcs, #8C                                             ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0032                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0028                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Elves          DB UnitID.Elves, #A5                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0028                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ogres          DB UnitID.Ogres, #AF                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Trolls         DB UnitID.Trolls, #B9                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Giants         DB UnitID.Giants, #BE                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dragons        DB UnitID.Dragons, #C3                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0001                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0003                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ghosts         DB UnitID.Ghosts, #C8                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #00C8                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0064                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Skeletons      DB UnitID.Skeletons, #CD                                        ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #00C8                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0064                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Zombies        DB UnitID.Zombies, #D2                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #012C                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0064                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spectres       DB UnitID.Spectres, #DC                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vampires       DB UnitID.Vampires, #E1                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dwarves        DB UnitID.Dwarves, #E6                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0050                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Druids         DB UnitID.Druids, #F0                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Warlocks       DB UnitID.Warlocks, #FA                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Demons         DB UnitID.Demons, #FF                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0004                                                        ; FWeightedTroop.CountRange, предел случайной добавки
                assert $ - CastleCont3 = 25 * FWeightedTroop

; армии замков, континент 4
CastleCont4     ; 25 записей FWeightedTroop
.Peasants       DB UnitID.Peasants, #05                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #03E8                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #01F4                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Soldiers       DB UnitID.Soldiers, #0A                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0190                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #00C8                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Archers        DB UnitID.Archers, #1E                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0064                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0032                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spearmen       DB UnitID.Spearmen, #28                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0096                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0064                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Cavalry        DB UnitID.Cavalry, #32                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0050                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Knights        DB UnitID.Knights, #4B                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Nomads         DB UnitID.Nomads, #50                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0064                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0032                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Celts          DB UnitID.Celts, #5A                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0050                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0032                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vikings        DB UnitID.Vikings, #64                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0046                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Wolves         DB UnitID.Wolves, #00                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Orcs           DB UnitID.Orcs, #78                                             ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0096                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0046                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Elves          DB UnitID.Elves, #8C                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0064                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0064                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ogres          DB UnitID.Ogres, #A0                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0028                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0028                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Trolls         DB UnitID.Trolls, #AF                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0028                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Giants         DB UnitID.Giants, #BE                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dragons        DB UnitID.Dragons, #C8                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ghosts         DB UnitID.Ghosts, #00                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Skeletons      DB UnitID.Skeletons, #D7                                        ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #012C                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0064                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Zombies        DB UnitID.Zombies, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spectres       DB UnitID.Spectres, #E1                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0046                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0032                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vampires       DB UnitID.Vampires, #E6                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0032                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0028                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dwarves        DB UnitID.Dwarves, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Druids         DB UnitID.Druids, #EB                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Warlocks       DB UnitID.Warlocks, #F5                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Demons         DB UnitID.Demons, #FF                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
                assert $ - CastleCont4 = 25 * FWeightedTroop

; состав подвижных армий, континент 1
ArmyCont1       ; 25 записей FWeightedTroop
.Peasants       DB UnitID.Peasants, #28                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Soldiers       DB UnitID.Soldiers, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Archers        DB UnitID.Archers, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spearmen       DB UnitID.Spearmen, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Cavalry        DB UnitID.Cavalry, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Knights        DB UnitID.Knights, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Nomads         DB UnitID.Nomads, #32                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0003                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Celts          DB UnitID.Celts, #35                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0003                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vikings        DB UnitID.Vikings, #39                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0004                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0001                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Wolves         DB UnitID.Wolves, #5A                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Orcs           DB UnitID.Orcs, #6E                                             ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Elves          DB UnitID.Elves, #78                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0007                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0003                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ogres          DB UnitID.Ogres, #7D                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0001                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Trolls         DB UnitID.Trolls, #87                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0001                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Giants         DB UnitID.Giants, #89                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0001                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dragons        DB UnitID.Dragons, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ghosts         DB UnitID.Ghosts, #A0                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Skeletons      DB UnitID.Skeletons, #B4                                        ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Zombies        DB UnitID.Zombies, #C8                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spectres       DB UnitID.Spectres, #D2                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0001                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0003                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vampires       DB UnitID.Vampires, #D7                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0001                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0001                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dwarves        DB UnitID.Dwarves, #F5                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Druids         DB UnitID.Druids, #FF                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0001                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Warlocks       DB UnitID.Warlocks, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Demons         DB UnitID.Demons, #00                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
                assert $ - ArmyCont1 = 25 * FWeightedTroop

; состав подвижных армий, континент 2
ArmyCont2       ; 25 записей FWeightedTroop
.Peasants       DB UnitID.Peasants, #0A                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0019                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Soldiers       DB UnitID.Soldiers, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Archers        DB UnitID.Archers, #0F                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spearmen       DB UnitID.Spearmen, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Cavalry        DB UnitID.Cavalry, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Knights        DB UnitID.Knights, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Nomads         DB UnitID.Nomads, #1E                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Celts          DB UnitID.Celts, #28                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vikings        DB UnitID.Vikings, #3C                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Wolves         DB UnitID.Wolves, #4B                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Orcs           DB UnitID.Orcs, #5F                                             ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Elves          DB UnitID.Elves, #6E                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ogres          DB UnitID.Ogres, #78                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Trolls         DB UnitID.Trolls, #87                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0007                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Giants         DB UnitID.Giants, #91                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0004                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0004                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dragons        DB UnitID.Dragons, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ghosts         DB UnitID.Ghosts, #A0                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0028                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Skeletons      DB UnitID.Skeletons, #AF                                        ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Zombies        DB UnitID.Zombies, #BE                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spectres       DB UnitID.Spectres, #CD                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vampires       DB UnitID.Vampires, #D7                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0003                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0003                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dwarves        DB UnitID.Dwarves, #E6                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Druids         DB UnitID.Druids, #F5                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0007                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Warlocks       DB UnitID.Warlocks, #FF                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Demons         DB UnitID.Demons, #00                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
                assert $ - ArmyCont2 = 25 * FWeightedTroop

; состав подвижных армий, континент 3
ArmyCont3       ; 25 записей FWeightedTroop
.Peasants       DB UnitID.Peasants, #05                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0032                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0032                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Soldiers       DB UnitID.Soldiers, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Archers        DB UnitID.Archers, #0A                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spearmen       DB UnitID.Spearmen, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Cavalry        DB UnitID.Cavalry, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Knights        DB UnitID.Knights, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Nomads         DB UnitID.Nomads, #19                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Celts          DB UnitID.Celts, #28                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vikings        DB UnitID.Vikings, #3C                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Wolves         DB UnitID.Wolves, #46                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0028                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Orcs           DB UnitID.Orcs, #55                                             ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Elves          DB UnitID.Elves, #64                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000F                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ogres          DB UnitID.Ogres, #73                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Trolls         DB UnitID.Trolls, #87                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Giants         DB UnitID.Giants, #91                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0006                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0004                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dragons        DB UnitID.Dragons, #96                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0001                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ghosts         DB UnitID.Ghosts, #A0                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0050                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0032                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Skeletons      DB UnitID.Skeletons, #AA                                        ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0028                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Zombies        DB UnitID.Zombies, #B4                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #002D                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0019                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spectres       DB UnitID.Spectres, #C3                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vampires       DB UnitID.Vampires, #D2                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dwarves        DB UnitID.Dwarves, #DC                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Druids         DB UnitID.Druids, #EB                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Warlocks       DB UnitID.Warlocks, #FA                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Demons         DB UnitID.Demons, #FF                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0002                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0002                                                        ; FWeightedTroop.CountRange, предел случайной добавки
                assert $ - ArmyCont3 = 25 * FWeightedTroop

; состав подвижных армий, континент 4
ArmyCont4       ; 25 записей FWeightedTroop
.Peasants       DB UnitID.Peasants, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Soldiers       DB UnitID.Soldiers, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Archers        DB UnitID.Archers, #05                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #003C                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0019                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spearmen       DB UnitID.Spearmen, #00                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Cavalry        DB UnitID.Cavalry, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Knights        DB UnitID.Knights, #00                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0000                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0000                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Nomads         DB UnitID.Nomads, #14                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0028                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Celts          DB UnitID.Celts, #28                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0019                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vikings        DB UnitID.Vikings, #3C                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Wolves         DB UnitID.Wolves, #41                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0050                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0028                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Orcs           DB UnitID.Orcs, #4B                                             ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #003C                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0028                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Elves          DB UnitID.Elves, #5A                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0032                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0019                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ogres          DB UnitID.Ogres, #69                                            ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Trolls         DB UnitID.Trolls, #73                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #001E                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Giants         DB UnitID.Giants, #82                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000F                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dragons        DB UnitID.Dragons, #91                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Ghosts         DB UnitID.Ghosts, #96                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0096                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0032                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Skeletons      DB UnitID.Skeletons, #A5                                        ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #003C                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Zombies        DB UnitID.Zombies, #AA                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0064                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0028                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Spectres       DB UnitID.Spectres, #BE                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0014                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Vampires       DB UnitID.Vampires, #CD                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Dwarves        DB UnitID.Dwarves, #D2                                          ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0050                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #001E                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Druids         DB UnitID.Druids, #E6                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0014                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #000A                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Warlocks       DB UnitID.Warlocks, #F5                                         ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #000A                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
.Demons         DB UnitID.Demons, #FF                                           ; FWeightedTroop.UnitID и Threshold, порог выбора типа
                DW #0005                                                        ; FWeightedTroop.BaseCount, исходное количество
                DW #0005                                                        ; FWeightedTroop.CountRange, предел случайной добавки
                assert $ - ArmyCont4 = 25 * FWeightedTroop

                assert $ = #87D0
                endmodule
