
; -----------------------------------------
; случайный выбор ещё не использованного имени с копированием в рабочий банк
; Сохраняет IX, использует A как шаг записи, A-1 как длину имени и смещение флага занятости.
; Выбирает банк 1, случайно определяет начальную запись среди B, затем ищет нулевой последний байт
; с циклическим переходом к началу. Помечает его #FF. Для каждого символа переключает банк 1 для
; чтения и банк 0 для записи по IX, после A-1 символов дописывает 0. Исходный IX восстанавливает.
; Явного выхода при использовании всех имён нет.
; In:
;   A — шаг 16 или 12, B — количество 80 или 160, IY — адрес перед первой записью (BFF0 или
;   C4F4), IX — приёмник банк 0
; Out:
;   имя 15 или 11 байтов плюс 0 скопировано, IX сохранён, IY после исходных букв, банк 0 активен
; Corrupt:
;   HL, DE, BC, AF, IY
; Note:
;   флаг последнего байта записи банк 1, строка банк 0, операнды #77CB/#77D3/#77E9/#77EB, #6CCE
; -----------------------------------------
PickUnusedName  PUSH IX
.InitialUsed    EQU 15                                                          ; исходное смещение флага, ReadUsed и WriteUsed патчатся на длину имени 15 либо 11
                LD (Startup.PickUnusedName.RecordSize), A
                DEC A
                LD (Startup.PickUnusedName.ReadUsed), A
                LD (Startup.PickUnusedName.WriteUsed), A
                LD (Startup.PickUnusedName.NameLength), A
                LD (Startup.PromptGameDisk.NameBase), IY
                LD A, #01
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                DEC B
                LD D, #00
                LD E, B
                LD L, B
                CALL RandomRange                                                ; получить псевдослучайное число, масштабированное к входному пределу
                LD H, E
                INC E
                LD B, E
                LD IY, (Startup.PromptGameDisk.NameBase)
.RecordSize     EQU $+1                                                         ; операнд DE шага записи имени, 16 или 12
                LD DE, #0000
.NameOffset     ADD IY, DE
                DJNZ .NameOffset

                ; поиск ещё не использованного имени, при конце списка поиск продолжается с первой записи
.ReadUsed       EQU $+2                                                         ; смещение флага использованного имени в операнде LD A,(IY+d)
.TestUsedName   LD A, (IY + .InitialUsed)
                OR A
                JR Z, .MarkNameUsed                                             ; переход, если имя ещё не использовалось

.NextName       ADD IY, DE
                INC H
                LD A, L
                CP H
                JR NC, .TestUsedName                                            ; переход, если номер проверяемого имени не превышает предел списка

                LD IY, (Startup.PromptGameDisk.NameBase)
                LD H, #FF
                JR .NextName

                ; резервирование выбранного имени и копирование строки через переключение банков
.MarkNameUsed   CPL
.WriteUsed      EQU $+2                                                         ; смещение флага использованного имени в операнде LD (IY+d),A
                LD (IY + .InitialUsed), A
.NameLength     EQU $+1                                                         ; операнд B длины имени, 15 или 11
                LD B, #00
.CopyNameByte   LD A, #01
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                LD C, (IY + #00)
                XOR A
                CALL PageAndEnable                                              ; выбрать логический банк и разрешить прерывания
                LD (IX + #00), C
                INC IX
                INC IY
                DJNZ .CopyNameByte

                LD (IX + #00), #00
                POP IX
                RET
