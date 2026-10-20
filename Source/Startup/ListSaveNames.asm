
; -----------------------------------------
; вывод страницы до пятнадцати имён сохранений
; Число активных пунктов #7CA6 начинает с 5 для служебных кнопок. От индекса #7385 выводит не
; более 15 имён, заканчивая при превышении общего числа #7384. #732A находит каждое сохранение,
; восемь байтов имени печатает в строках от 4, столбце 4. Для каждого имени увеличивает число
; пунктов меню.
; In:
;   #7384 — число сохранений, #7385 — первый индекс страницы
; Out:
;   #7CA6=5+число показанных имён
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   экран, #7CA6
; -----------------------------------------
ListSaveNames   LD A, #05
                LD (Startup.GenerateArmy.SaveMenu), A
                LD A, (Startup.ListSaveNames.FirstSave)
                LD E, #0F
                LD BC, #0404
.SaveNameLoop   PUSH AF
                PUSH BC
                PUSH DE
                LD HL, Startup.ListSaveNames.SaveCount
                CP (HL)
                JR Z, .DrawSaveName                                             ; переход, если номер записи совпал с общим количеством сохранений

                JR C, .DrawSaveName                                             ; переход, если номер записи меньше общего количества сохранений

                POP DE
                POP BC
                POP AF
                RET

.DrawSaveName   CALL FindSaveRecord                                             ; поиск N-й неудалённой записи типа M в буфере каталога
                LD E, #08
.NameCharLoop   LD A, (IX + #00)
                CALL DrawGlyphEI                                                ; нарисовать символ с разрешением прерываний после переключения банка
                INC IX
                INC C
                DEC E
                JR NZ, .NameCharLoop                                            ; переход, если ещё не выведены все символы имени сохранения

                LD A, (Startup.GenerateArmy.SaveMenu)
                INC A
                LD (Startup.GenerateArmy.SaveMenu), A
                POP DE
                POP BC
                POP AF
                INC B
                INC A
                DEC E
                JR NZ, .SaveNameLoop                                            ; переход, если ещё не выведены все строки страницы

                RET

.SaveCount      DB #00                                                          ; число доступных сохранений на диске
.FirstSave      DB #00                                                          ; номер первой записи на текущей странице сохранений
