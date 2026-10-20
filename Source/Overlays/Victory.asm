; оверлей 16 из OVR2
; исходный файл каталога 49, смещение #0387
                module Overlay
                module Victory
                org #B200

; -----------------------------------------
; поиск цели сравнением участка карты 5x5 и завершение игры
; Доступен только при (#6A33 AND3)=0. После подтверждения проводит 28 дневных шагов #9704.
; Выбирает квадрат 5x5 вокруг координат героя со сдвигом -2, -2 и сравнивает младшие 6 бит всех 25
; клеток с узором #6A5A. При несовпадении показывает провал. При совпадении переходит к сцене
; победы, показывает сообщения, читает 12 секторов через #6D15 с DE=#9E00 в #C000. Ищет свободную
; 19-байтовую запись, добавляет 19 байтов #69EF с XOR первых 19 байтов ROM, записывает 12 секторов
; обратно. Расшифровывает записи тем же XOR и прокручивает список победителей. В конце JP #0000.
; Область диска задаётся физической парой DE, а не именем файла.
; In:
;   карта, координаты героя, узор #6A5A, данные героя #69EF
; Out:
;   провал возвращает управление, победа завершает JP #0000
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY на ветви полного поиска и победы, I и режим IM
;   переключаются дисковым шлюзом #6D15, победа завершается JP #0000 и не сохраняет стек
;   вызывающего кода
; Note:
;   время, экран, fixed disk region DE=#9E00 12 секторов, память банк 0, #C000, текущий стек
; -----------------------------------------
Entry           LD A, (State.MoveFlags)
                AND #03
                RET NZ                                                          ; выход, если герой не находится в пешем режиме

                LD BC, #1000
                LD DE, #0612
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #1501
                LD DE, #0112
                LD A, #44
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #1601
                LD DE, #0112
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD B, #12
                LD DE, Overlay.Victory.TerrainCode.SearchText                   ; предложение начать четырёхнедельные поиски талисмана
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IX, Overlay.Victory.TerrainCode.SearchMenu                   ; меню начала или отмены поисков талисмана
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #01
                RET NZ                                                          ; выход, если игрок отказался проверять клетку цели

                LD A, #FF
                LD (State.StepCost), A
                LD B, #1C
.PassDay        PUSH BC
                CALL Engine.TickTime                                            ; продвинуть время игры и выполнить периодические расчёты
                POP BC
                DJNZ .PassDay

                CALL Engine.SelectMapBank                                       ; выбрать логический банк 10 с текущей картой
                LD BC, (State.Position)
                DEC B
                DEC B
                DEC C
                DEC C
                CALL Engine.MapCellAddress                                      ; вычислить адрес клетки карты
                LD DE, State.PuzzleTiles
                LD B, #05
.CompareRow     PUSH BC
                LD B, #05

                ; сравниваются только типы 25 клеток, временные старшие биты карты не влияют на
                ; совпадение
.CompareCell    LD A, (DE)
                CALL TerrainCode
                LD C, A
                LD A, (HL)
                CALL TerrainCode
                CP C
                JR Z, .NextCell                                                 ; переход, если преобразованный тип местности совпал с эталонной клеткой карты цели

                POP BC
                LD BC, #1000
                LD DE, #0612
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #12
                LD DE, Overlay.Victory.TerrainCode.SearchFailText               ; сообщение о неудачном поиске талисмана
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #14
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                RET

.NextCell       INC DE
                INC HL
                DJNZ .CompareCell

                LD BC, #009C
                ADD HL, BC
                POP BC
                DJNZ .CompareRow

                CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                JR .VictoryScreen

                DB #D3, #FE, #3E, #02, #01, #00, #00, #11
                DB #20, #18, #CD, #CF, #73, #01, #00, #1B
                DB #21, #00, #40, #36, #02, #0B, #79, #B0
                DB #20, #F9, #01, #00, #1B, #21, #00, #40
                DB #36, #00, #0B, #79, #B0, #20, #F9, #3E
                DB #38, #01, #00, #00, #11, #20, #18, #CD
                DB #CF, #73, #01, #9D, #B4, #21, #E0, #50
                DB #CD, #D7, #B5, #06, #FA, #76, #10, #FD
.VictoryScreen  XOR A
                OUT (#FE), A
                LD BC, #0000
                LD DE, #1820
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD A, #04
                CALL Engine.ShowScene                                           ; показать одну из девяти упакованных сцен BL1/BL2 с восстановлением банка и основных регистров
                LD BC, #0E00
                LD DE, #081E
                LD A, #44
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #11
                LD DE, Overlay.Victory.ScrollScores.DiskPrompt                  ; приглашение вставить диск для заключительной записи
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #28
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD BC, #0E00
                LD DE, #081E
                LD A, #44
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #10
                LD DE, Overlay.Victory.ScrollScores.VictoryText                 ; сообщение об успешном завершении игры
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #28
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD BC, #0E00
                LD DE, #081E
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #12
                LD DE, Overlay.Victory.ScrollScores.WaitDiskText                ; сообщение перед обращением к таблице победителей
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                XOR A
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD BC, #0C05
                LD DE, #9E00
                LD HL, Runtime.ScoreTable                                       ; буфер таблицы победителей в банке 0
                CALL Engine.CallTrdos                                           ; вызвать TR-DOS с временным режимом IM 1
                LD HL, Runtime.ScoreTable - 19                                  ; база на одну 19-байтную запись перед первым победителем
                LD DE, #0013

                ; таблица победителей хранится записями по 19 байтов, новая запись занимает
                ; первый свободный слот
.FindScoreSlot  ADD HL, DE
                LD A, (HL)
                OR A
                JR NZ, .FindScoreSlot                                           ; переход, если запись таблицы победителей уже занята

                LD IX, Rom.Start                                                ; первые девятнадцать байтов ROM как XOR-ключ записи победителя
                LD DE, State.SaveName
                LD B, #13

                ; имя победителя маскируется первыми 19 байтами ROM, обратное преобразование
                ; выполняется тем же XOR
.EncodeScore    LD A, (DE)
                XOR (IX + #00)
                LD (HL), A
                INC IX
                INC HL
                INC DE
                DJNZ .EncodeScore

                LD BC, #0C06
                LD DE, #9E00
                LD HL, Runtime.ScoreTable                                       ; буфер таблицы победителей в банке 0
                CALL Engine.CallTrdos                                           ; вызвать TR-DOS с временным режимом IM 1
                LD DE, Runtime.ScoreTable                                       ; буфер таблицы победителей в банке 0

                ; перед показом списка каждая занятая запись расшифровывается на месте
.ScoreRecord    LD A, (DE)
                OR A
                JR Z, .DrawScorePanel                                           ; переход, если достигнут конец заполненных записей победителей

                LD HL, Rom.Start                                                ; первые девятнадцать байтов ROM как XOR-ключ записи победителя
                LD B, #13
.DecodeScore    LD A, (DE)
                XOR (HL)
                LD (DE), A
                INC DE
                INC HL
                DJNZ .DecodeScore

                JR .ScoreRecord

.DrawScorePanel LD BC, #0E00
                LD DE, #081E
                LD A, #05
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #0F01
                LD DE, #011E
                LD A, #42
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD BC, #1001
                LD DE, #011E
                XOR A
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                LD B, #0F
                LD DE, Overlay.Victory.ScrollScores.ScoreTitle                  ; заголовок списка спасителей Страны Мифов
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
.NextScoreName  LD BC, #1601
                LD DE, #011E
                XOR A
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD HL, (ScrollScores.ScoreRecord)
                LD DE, #0013
                ADD HL, DE
                LD (ScrollScores.ScoreRecord), HL
                LD A, (HL)
                OR A
                JP Z, .ScrollLine                                               ; переход, если текущая строка итогового текста закончилась

                LD (ScrollScores.ScoreName), HL
                LD DE, #0009
                ADD HL, DE
                LD (ScrollScores.ScoreText), HL
                LD B, #16
                LD DE, Overlay.Victory.ScrollScores.ScoreLine                   ; формат отображаемой записи таблицы победителей
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #08
                CALL ScrollScores
                JP .NextScoreName

.ScrollLine     LD B, #30
                CALL ScrollScores
                LD BC, #1601
                LD DE, #011E
                LD A, #41
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD B, #16
                LD DE, Overlay.Victory.ScrollScores.EndListText                 ; сообщение о завершении списка победителей
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #28
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD BC, #0E00
                LD DE, #081E
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #12
                LD DE, Overlay.Victory.ScrollScores.FarewellText                ; прощальное сообщение перед перезапуском ROM
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #00
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JP Rom.Start                                                    ; вход сброса ROM, также первые байты ROM служат XOR-ключом таблицы победителей

; -----------------------------------------
; прокрутка нижней текстовой области списка победителей
; Каждый из B шагов ждёт восемь HALT. В шести рядах знакомест начиная #5021 копирует по 30 байтов
; из следующей пиксельной строки в предыдущую, включая переход к следующему знакоместу. Последнюю
; строку #57C1..#57DE очищает нулями. Повторение создаёт прокрутку вверх на одну пиксельную строку
; за шаг.
; In:
;   B — число пиксельных шагов, не ноль
; Out:
;   B=0
; Corrupt:
;   HL, DE, BC, AF. HL', DE', BC', AF', IX, IY сохранены, C восстанавливается через PUSH/POP BC,
;   B после цикла равен нулю
; Note:
;   часть экранной памяти, HL, DE, BC, AF
; -----------------------------------------
ScrollScores    PUSH BC
                HALT
                HALT
                HALT
                HALT
                HALT
                HALT
                HALT
                HALT
                LD DE, Screen.Pixels + #1021                                    ; начало прокручиваемой полосы списка победителей, пиксельная строка 136, байтовый столбец 1
                LD B, #06
.ScrollBand     PUSH BC
                LD (ScrollScores.ScrollAddress), DE
                PUSH DE
                POP HL
                INC H
                LD B, #07
.CopyBandRows   PUSH HL
                PUSH DE
                PUSH BC
                LD BC, #001E
                LDIR
                POP BC
                POP DE
                POP HL
                INC D
                INC H
                DJNZ .CopyBandRows

                LD HL, (ScrollScores.ScrollAddress)
                LD A, L
                ADD A, #20
                LD L, A
                JR NC, .CopyLastRow                                             ; переход, если следующая строка знакомест остаётся в текущей трети экрана

                LD A, H
                ADD A, #08
                LD H, A
.CopyLastRow    PUSH HL
                LD BC, #001E
                LDIR
                POP DE
                POP BC
                DJNZ .ScrollBand

                LD HL, Screen.Pixels + #17C1                                    ; нижняя строка очищаемой полосы списка победителей
                LD DE, Screen.Pixels + #17C2                                    ; следующий байт нижней очищаемой строки для размножения нуля
                LD BC, #001D
                LD (HL), #00
                LDIR
                POP BC
                DJNZ ScrollScores

                RET

                DB #02, #01
.ScoreRecord    DW #BFED                                                        ; адрес текущей 19-байтовой записи таблицы победителей
.ScrollAddress  DW #0000                                                        ; адрес начала прокручиваемой полосы экрана
.ScoreLine      EQU $                                                           ; формат отображаемой записи таблицы победителей
                DB #0E
.ScoreText      DW #0000                                                        ; адрес второй части имени в строке победителя
                DB #0E
.ScoreName      DW #0000                                                        ; адрес первой части имени в строке победителя
.EndListText    EQU $+3                                                         ; сообщение о завершении списка победителей
                DB #0D, #2A, #00, #82, #AE, #E2, #20, #A8
                DB #20, #A2, #E1, #A5, #2E, #0D, #2A, #00
.FarewellText   EQU $                                                           ; прощальное сообщение перед перезапуском ROM
                DB #8F, #E0, #AE, #E9, #A0, #A9, #0D, #2A
.ScoreTitle     EQU $+1                                                         ; заголовок списка спасителей Страны Мифов
                DB #00, #92, #A5, #2C, #20, #AA, #E2, #AE
                DB #20, #E1, #AF, #A0, #E1, #AB, #A8, #20
                DB #91, #92, #90, #80, #8D, #93, #20, #8C
                DB #88, #94, #8E, #82, #2E, #0D, #2A, #00
                DB #7F, #20, #31, #39, #38, #32, #20, #53
                DB #69, #6E, #63, #6C, #61, #69, #72, #20
                DB #52, #65, #73, #65, #61, #72, #63, #68
.DiskPrompt     EQU $+5                                                         ; приглашение вставить диск для заключительной записи
                DB #20, #4C, #74, #64, #00, #8A, #A0, #AA
                DB #20, #AD, #A5, #20, #AF, #A5, #E7, #A0
                DB #AB, #EC, #AD, #AE, #2C, #AD, #AE, #20
                DB #ED, #E2, #AE, #20, #AF, #AE, #E1, #AB
                DB #A5, #A4, #AD, #A8, #A9, #20, #AF, #E0
                DB #A8, #AA, #AE, #AB, #2E, #0D, #2A, #82
                DB #E1, #E2, #A0, #A2, #EC, #E2, #A5, #20
                DB #A2, #20, #A4, #A8, #E1, #AA, #AE, #A2
                DB #AE, #A4, #20, #A4, #A8, #E1, #AA, #A5
                DB #E2, #E3, #20, #E1, #20, #A8, #A3, #E0
                DB #AE, #A9, #2E, #0D, #2A, #0D, #0D, #00
                DB #00, #E1, #AC, #AE, #A3, #AB, #A8, #20
                DB #A5, #A3, #AE, #20, #E3, #A2, #A8, #A4
.VictoryText    EQU $+7                                                         ; сообщение об успешном завершении игры
                DB #A5, #E2, #EC, #2E, #0D, #2A, #00, #97
                DB #E2, #AE, #20, #AA, #A0, #E1, #A0, #A5
                DB #E2, #E1, #EF, #20, #A8, #A3, #E0, #EB
                DB #2C, #20, #E2, #AE, #20, #A2, #A0, #AC
                DB #20, #E2, #A0, #AA, #A8, #20, #E3, #A4
                DB #A0, #AB, #AE, #E1, #EC, #0D, #2A, #AF
                DB #E0, #A5, #AE, #A4, #AE, #AB, #A5, #E2
                DB #EC, #20, #A2, #E1, #A5, #20, #E2, #E0
                DB #E3, #A4, #AD, #AE, #E1, #E2, #A8, #20
                DB #A8, #0D, #2A, #A2, #EB, #AF, #AE, #AB
                DB #AD, #A8, #E2, #EC, #20, #E7, #A5, #E1
                DB #E2, #AD, #AE, #20, #A3, #AE, #A2, #AE
                DB #E0, #EF, #20, #AD, #A5, #A2, #EB, #AF
                DB #AE, #AB, #AD, #A8, #AC, #EB, #A5, #0D
                DB #2A, #E3, #E1, #AB, #AE, #A2, #A8, #EF
                DB #2E, #0D, #2A, #92, #A0, #AA, #A8, #E5
                DB #20, #AA, #A0, #AA, #20, #A2, #EB, #20
                DB #A1, #EB, #AB, #AE, #20, #AD, #A5, #20
                DB #E2, #A0, #AA, #20, #E3, #A6, #20, #AC
                DB #AD, #AE, #A3, #AE, #2E, #2E, #2E, #0D
.WaitDiskText   EQU $+2                                                         ; сообщение перед обращением к таблице победителей
                DB #2A, #00, #8D, #A5, #20, #AF, #E3, #A3
                DB #A0, #A9, #E1, #EF, #2C, #20, #AF, #E0
                DB #A8, #EF, #E2, #A5, #AB, #EC, #2E, #0D
                DB #2A, #00, #0A, #B7, #C8, #E5, #E5, #6F
                DB #26, #00, #29, #29, #29, #ED, #5B, #36
                DB #5C, #19, #D1, #C5, #06, #08, #7E, #12
                DB #23, #14, #10, #FA, #C1, #E1, #23, #03
                DB #18, #E0

; -----------------------------------------
; отбрасывание служебных битов клетки при поиске цели
; Выполняет AND #3F. При ненулевом результате дополнительно AND #7F, что уже не меняет значение.
; Сравнение цели игнорирует и бит 6, и бит 7.
; In:
;   A — байт клетки
; Out:
;   A=исходное A AND #3F, Z по этому значению
; Corrupt:
;   AF. HL, DE, BC, HL', DE', BC', AF', IX, IY сохранены
; Note:
;   AF
; -----------------------------------------
TerrainCode     AND #3F
                RET Z                                                           ; выход, если младшие шесть бит клетки задают базовый тип местности 0

                AND #7F
                RET

.SearchText     EQU $                                                           ; предложение начать четырёхнедельные поиски талисмана
                DB #11, #00, #1A, #8D, #A0, #20, #AF, #AE
                DB #A8, #E1, #AA, #A8, #20, #AF, #AE, #AD
                DB #A0, #A4, #AE, #A1, #A8, #E2, #E1, #EF
                DB #0D, #2A, #34, #20, #AD, #A5, #A4, #A5
                DB #AB, #A8, #20, #2E, #2E, #2E, #0D, #2A
                DB #0D, #00, #8F, #E0, #A8, #E1, #E2, #E3
                DB #AF, #A8, #E2, #EC, #20, #AA, #20, #AF
                DB #AE, #A8, #E1, #AA, #E3, #0D, #2A, #9F
                DB #20, #AF, #A5, #E0, #A5, #A4, #E3, #AC
.SearchFailText EQU $+5                                                         ; сообщение о неудачном поиске талисмана
                DB #A0, #AB, #0D, #2A, #00, #11, #00, #1A
                DB #8F, #AE, #A8, #E1, #A8, #20, #A7, #A0
                DB #AA, #AE, #AD, #E7, #A8, #AB, #A8, #E1
                DB #EC, #0D, #2A, #AF, #AE, #AB, #AD, #EB
                DB #AC, #20, #AF, #E0, #AE, #A2, #A0, #AB
.SearchMenu     EQU $+6                                                         ; меню начала или отмены поисков талисмана
                DB #AE, #AC, #2E, #0D, #2A, #00, #02, #0A
                DB #A0, #A0, #BF, #32, #AA, #01, #15, #13
                DB #16, #01, #16, #13, #17, #6F, #76, #65
                DB #72, #6C, #61, #79

                assert $ = #B689
                endmodule
                endmodule
