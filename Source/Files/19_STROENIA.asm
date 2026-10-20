; исходные координаты замков, городов и храмов
; списки и размеры подтверждены дескрипторами и обходом MarkStructures
; имена, владельцы, армии и параметры храмов заполняются при создании мира
                module Data
                module WorldObjects
                org #7A31

CastlesCont1    ; 26 записей FCastle, континент 1
.Castle01       DB #00, #0A, #08                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle02       DB #00, #0E, #13                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle03       DB #00, #1D, #09                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle04       DB #00, #3A, #0E                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle05       DB #00, #5F, #0A                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle06       DB #00, #7F, #0B                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle07       DB #00, #8E, #11                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle08       DB #00, #15, #18                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle09       DB #00, #2C, #26                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle10       DB #00, #40, #1F                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle11       DB #00, #5C, #25                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle12       DB #00, #6B, #26                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle13       DB #00, #8A, #1D                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle14       DB #00, #1C, #2F                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle15       DB #00, #73, #34                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle16       DB #00, #65, #34                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle17       DB #00, #8B, #33                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle18       DB #00, #24, #47                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle19       DB #00, #3A, #4B                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle20       DB #00, #91, #43                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle21       DB #00, #7F, #43                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle22       DB #00, #17, #5A                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle23       DB #00, #57, #58                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle24       DB #00, #79, #52                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle25       DB #00, #94, #59                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle26       DB #00, #4E, #48                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
                assert $ - CastlesCont1 = 26 * FCastle

CastlesCont2    ; 20 записей FCastle, континент 2
.Castle01       DB #00, #12, #0A                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle02       DB #00, #33, #0E                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle03       DB #00, #17, #38                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle04       DB #00, #1F, #58                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle05       DB #00, #38, #47                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle06       DB #00, #4D, #55                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle07       DB #00, #65, #54                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle08       DB #00, #78, #47                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle09       DB #00, #8A, #41                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle10       DB #00, #94, #32                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle11       DB #00, #71, #35                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle12       DB #00, #76, #21                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle13       DB #00, #8E, #1B                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle14       DB #00, #8A, #0C                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle15       DB #00, #59, #1E                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle16       DB #00, #47, #24                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle17       DB #00, #47, #34                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle18       DB #00, #3F, #31                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle19       DB #00, #5B, #07                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle20       DB #00, #8F, #49                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
                assert $ - CastlesCont2 = 20 * FCastle

CastlesCont3    ; 23 записей FCastle, континент 3
.Castle01       DB #00, #10, #13                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle02       DB #00, #28, #18                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle03       DB #00, #11, #2F                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle04       DB #00, #2F, #2D                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle05       DB #00, #1A, #36                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle06       DB #00, #1B, #4F                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle07       DB #00, #35, #57                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle08       DB #00, #48, #58                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle09       DB #00, #55, #48                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle10       DB #00, #72, #3A                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle11       DB #00, #81, #42                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle12       DB #00, #7D, #4C                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle13       DB #00, #5C, #31                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle14       DB #00, #69, #28                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle15       DB #00, #5C, #21                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle16       DB #00, #55, #1E                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle17       DB #00, #7F, #23                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle18       DB #00, #87, #2E                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle19       DB #00, #97, #1D                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle20       DB #00, #46, #0A                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle21       DB #00, #26, #40                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle22       DB #00, #46, #3F                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle23       DB #00, #50, #53                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
                assert $ - CastlesCont3 = 23 * FCastle

CastlesCont4    ; 11 записей FCastle, континент 4
.Castle01       DB #00, #1A, #58                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle02       DB #00, #0A, #11                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle03       DB #00, #84, #04                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle04       DB #00, #88, #57                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle05       DB #00, #51, #52                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle06       DB #00, #2F, #2D                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle07       DB #00, #5B, #2E                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle08       DB #00, #45, #14                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle09       DB #00, #5A, #15                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle10       DB #00, #77, #2A                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
.Castle11       DB #00, #67, #43                                                ; FCastle.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FCastle.Name, поле имени CP866
                DB #00, #00, #00, #00, #00, #00, #00                            ; продолжение FCastle.Name, поле имени CP866
                DB #00, #00                                                     ; FCastle.Terminator и Owner, конец имени и владелец
                DB #00                                                          ; FCastle.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item0.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item1.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item2.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item3.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item3.Count, количество существ
                DB #00                                                          ; FCastle.Army.Item4.ID, тип отряда
                DW #0000                                                        ; FCastle.Army.Item4.Count, количество существ
                assert $ - CastlesCont4 = 11 * FCastle

TownsCont1      ; 41 записей FTown, континент 1
.Town01         DB #00, #12, #0F                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1012                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town02         DB #00, #1E, #06                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town03         DB #00, #31, #0C                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0D31                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town04         DB #00, #58, #10                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1059                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town05         DB #00, #73, #0D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0D72                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town06         DB #00, #8C, #07                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #068C                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town07         DB #00, #13, #21                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2214                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town08         DB #00, #32, #27                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town09         DB #00, #4A, #23                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #234B                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town10         DB #00, #5B, #1E                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1D5B                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town11         DB #00, #78, #26                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2578                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town12         DB #00, #85, #1C                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town13         DB #00, #13, #2B                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town14         DB #00, #06, #38                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #3807                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town15         DB #00, #28, #36                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #3528                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town16         DB #00, #48, #34                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #3548                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town17         DB #00, #5F, #30                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town18         DB #00, #75, #2D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2D74                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town19         DB #00, #68, #36                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #3568                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town20         DB #00, #8D, #2C                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town21         DB #00, #0E, #48                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #470E                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town22         DB #00, #26, #3D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town23         DB #00, #3A, #43                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #443B                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town24         DB #00, #6E, #48                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town25         DB #00, #0A, #5A                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5B0B                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town26         DB #00, #1E, #5A                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5B1D                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town27         DB #00, #31, #53                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town28         DB #00, #3C, #58                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #573C                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town29         DB #00, #52, #55                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5451                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town30         DB #00, #46, #57                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town31         DB #00, #7C, #56                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town32         DB #00, #6A, #54                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town33         DB #00, #70, #5F                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5F6F                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town34         DB #00, #8E, #58                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #588D                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town35         DB #00, #83, #5F                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #6083                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town36         DB #00, #9A, #43                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #439B                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town37         DB #00, #9B, #29                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #299C                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town38         DB #00, #88, #29                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2888                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town39         DB #00, #09, #21                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2108                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town40         DB #00, #3E, #07                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #063E                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town41         DB #00, #75, #29                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2875                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
                assert $ - TownsCont1 = 41 * FTown

TownsCont2      ; 50 записей FTown, континент 2
.Town01         DB #00, #08, #0B                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0C08                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town02         DB #00, #07, #1C                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1D06                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town03         DB #00, #1B, #05                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #051A                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town04         DB #00, #17, #29                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2A18                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town05         DB #00, #14, #17                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town06         DB #00, #2A, #16                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town07         DB #00, #2E, #05                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #042D                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town08         DB #00, #28, #2B                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town09         DB #00, #33, #22                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2334                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town10         DB #00, #28, #38                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #3927                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town11         DB #00, #07, #35                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #3406                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town12         DB #00, #07, #59                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5806                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town13         DB #00, #1B, #52                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #511B                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town14         DB #00, #26, #4F                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town15         DB #00, #2C, #40                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town16         DB #00, #3A, #53                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5239                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town17         DB #00, #32, #5F                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5E31                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town18         DB #00, #45, #5E                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town19         DB #00, #4B, #4C                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4C4C                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town20         DB #00, #5A, #59                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5859                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town21         DB #00, #53, #45                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4552                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town22         DB #00, #65, #49                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4865                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town23         DB #00, #6A, #55                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #566A                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town24         DB #00, #79, #40                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #407A                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town25         DB #00, #83, #53                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town26         DB #00, #7A, #57                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #587A                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town27         DB #00, #84, #5E                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5F83                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town28         DB #00, #99, #5B                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5C9A                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town29         DB #00, #90, #38                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town30         DB #00, #8C, #35                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town31         DB #00, #95, #2D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town32         DB #00, #9B, #3B                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #3C9B                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town33         DB #00, #97, #46                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4597                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town34         DB #00, #90, #0C                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town35         DB #00, #9A, #07                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #089A                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town36         DB #00, #84, #0A                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0984                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town37         DB #00, #8F, #21                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #228E                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town38         DB #00, #8A, #15                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town39         DB #00, #9B, #16                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #179C                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town40         DB #00, #7E, #2A                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town41         DB #00, #72, #24                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town42         DB #00, #6E, #1A                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town43         DB #00, #61, #0E                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0F60                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town44         DB #00, #6A, #06                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0569                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town45         DB #00, #56, #07                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0757                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town46         DB #00, #37, #15                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1437                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town47         DB #00, #46, #11                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town48         DB #00, #3C, #20                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #213C                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town49         DB #00, #39, #31                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #3238                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town50         DB #00, #4E, #41                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #424F                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
                assert $ - TownsCont2 = 50 * FTown

TownsCont3      ; 30 записей FTown, континент 3
.Town01         DB #00, #16, #1A                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1B15                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town02         DB #00, #24, #11                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1224                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town03         DB #00, #21, #1D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town04         DB #00, #19, #29                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #291A                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town05         DB #00, #27, #38                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town06         DB #00, #18, #35                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town07         DB #00, #09, #2E                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2F09                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town08         DB #00, #14, #3D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #3E15                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town09         DB #00, #30, #41                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4230                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town10         DB #00, #20, #2D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town11         DB #00, #35, #36                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #3534                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town12         DB #00, #3D, #3B                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town13         DB #00, #14, #50                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4F14                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town14         DB #00, #0E, #55                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town15         DB #00, #4C, #4F                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4F4D                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town16         DB #00, #62, #50                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4F62                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town17         DB #00, #68, #54                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town18         DB #00, #71, #52                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5372                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town19         DB #00, #83, #57                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5884                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town20         DB #00, #8E, #4D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4E8F                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town21         DB #00, #86, #4D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4C85                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town22         DB #00, #8E, #46                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town23         DB #00, #88, #43                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town24         DB #00, #64, #2C                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2D63                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town25         DB #00, #4D, #21                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #224E                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town26         DB #00, #64, #20                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2165                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town27         DB #00, #80, #28                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2981                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town28         DB #00, #89, #33                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #3488                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town29         DB #00, #92, #1C                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1B91                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town30         DB #00, #48, #12                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1349                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
                assert $ - TownsCont3 = 30 * FTown

TownsCont4      ; 39 записей FTown, континент 4
.Town01         DB #00, #0C, #4A                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town02         DB #00, #23, #5F                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5F24                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town03         DB #00, #11, #5F                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5F12                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town04         DB #00, #05, #57                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5604                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town05         DB #00, #05, #4A                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4904                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town06         DB #00, #1C, #4D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4C1C                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town07         DB #00, #0F, #3A                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #390F                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town08         DB #00, #2D, #5A                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town09         DB #00, #12, #08                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town10         DB #00, #05, #0B                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0A05                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town11         DB #00, #06, #19                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1805                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town12         DB #00, #1B, #18                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #191A                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town13         DB #00, #27, #10                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1126                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town14         DB #00, #89, #0D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town15         DB #00, #94, #18                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town16         DB #00, #76, #0E                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0F75                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town17         DB #00, #7A, #5C                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5B7A                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town18         DB #00, #93, #50                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town19         DB #00, #9C, #5B                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5A9C                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town20         DB #00, #52, #5D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5E53                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town21         DB #00, #67, #58                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #5968                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town22         DB #00, #4E, #4D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town23         DB #00, #63, #47                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town24         DB #00, #33, #31                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town25         DB #00, #3E, #4A                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #493D                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town26         DB #00, #2F, #44                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #452E                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town27         DB #00, #18, #27                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2618                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town28         DB #00, #25, #1F                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1E24                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town29         DB #00, #54, #2D                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #2E55                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town30         DB #00, #3B, #22                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town31         DB #00, #31, #13                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1230                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town32         DB #00, #48, #06                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0547                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town33         DB #00, #5F, #0F                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town34         DB #00, #78, #45                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4679                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town35         DB #00, #70, #18                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #1971                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town36         DB #00, #6D, #4E                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #4F6E                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town37         DB #00, #80, #38                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #0000                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town38         DB #00, #85, #44                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #C584                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
.Town39         DB #00, #96, #37                                                ; FTown.Flags, X, Y, состояние и клетка объекта
                DB #00, #00, #00, #00, #00, #00, #00, #00                       ; FTown.Name, поле имени CP866
                DB #00, #00, #00                                                ; продолжение FTown.Name, поле имени CP866
                DB #00                                                          ; FTown.Terminator, конец имени
                DW #3797                                                        ; FTown.DockPos, столбец причала в младшем байте и строка в старшем
                DB #00                                                          ; FTown.Army.Item0.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item0.Count, количество существ
                DB #00                                                          ; FTown.Army.Item1.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item1.Count, количество существ
                DB #00                                                          ; FTown.Army.Item2.ID, тип отряда
                DW #0000                                                        ; FTown.Army.Item2.Count, количество существ
                assert $ - TownsCont4 = 39 * FTown

TemplesCont1    ; 10 записей FTemple, континент 1
.Temple01       DB #00, #59, #26                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple02       DB #00, #67, #24                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple03       DB #00, #29, #2D                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple04       DB #00, #50, #30                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple05       DB #00, #79, #2F                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple06       DB #00, #21, #46                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple07       DB #00, #5B, #45                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple08       DB #00, #6D, #45                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple09       DB #00, #2F, #52                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple10       DB #00, #5D, #55                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
                assert $ - TemplesCont1 = 10 * FTemple

TemplesCont2    ; 15 записей FTemple, континент 2
.Temple01       DB #00, #27, #0F                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple02       DB #00, #22, #33                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple03       DB #00, #0F, #59                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple04       DB #00, #2C, #48                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple05       DB #00, #57, #4B                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple06       DB #00, #64, #5D                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple07       DB #00, #8F, #58                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple08       DB #00, #67, #36                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple09       DB #00, #8F, #15                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple10       DB #00, #56, #12                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple11       DB #00, #65, #29                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple12       DB #00, #3F, #19                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple13       DB #00, #52, #31                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple14       DB #00, #48, #0D                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple15       DB #00, #7C, #51                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
                assert $ - TemplesCont2 = 15 * FTemple

TemplesCont3    ; 7 записей FTemple, континент 3
.Temple01       DB #00, #26, #33                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple02       DB #00, #0C, #4C                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple03       DB #00, #6B, #0B                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple04       DB #00, #7C, #18                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple05       DB #00, #96, #18                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple06       DB #00, #9A, #27                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple07       DB #00, #3F, #33                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
                assert $ - TemplesCont3 = 7 * FTemple

TemplesCont4    ; 18 записей FTemple, континент 4
.Temple01       DB #00, #14, #53                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple02       DB #00, #0A, #43                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple03       DB #00, #19, #08                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple04       DB #00, #25, #08                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple05       DB #00, #91, #12                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple06       DB #00, #91, #56                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple07       DB #00, #58, #41                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple08       DB #00, #45, #3E                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple09       DB #00, #30, #3C                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple10       DB #00, #49, #2D                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple11       DB #00, #23, #28                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple12       DB #00, #38, #15                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple13       DB #00, #4B, #1B                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple14       DB #00, #41, #1D                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple15       DB #00, #68, #1F                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple16       DB #00, #6A, #3A                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple17       DB #00, #77, #34                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
.Temple18       DB #00, #87, #2F                                                ; FTemple.Flags, X, Y, состояние и клетка объекта
                DB #00, #00                                                     ; FTemple.Cult и Spell, секта и доступное заклинание
                assert $ - TemplesCont4 = 18 * FTemple

                assert $ = #965B
                endmodule
                endmodule
