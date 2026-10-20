; оверлей 09 из OVR1
; исходный файл каталога 48, смещение #2871
                module Overlay
                module Save
                org #B200

; -----------------------------------------
; запись четырёх областей состояния в файл .M
; Подтверждает сохранение, формирует имя из #69EF и расширение M. Через поиск и чтение дескриптора
; определяет место файла. Записывает 1 сектор из #69ED,41 сектор банка 0 из #C000,64 сектора банка
; 1 и 33 сектора банка 11. Перед записью инвертирует соответственно #FF, #2859, #3FEF, #20CF
; полезных байтов, затем повторной инверсией восстанавливает память. Разницу между инвертируемой и
; секторной длиной сохраняет исходный формат. Дисковые смещения 1, #2A, #6A прибавляются к старту
; файла через AddSectors. Завершает перерисовкой #944A.
; In:
;   текущее состояние героя, армии и объекта в ядре
; Out:
;   состояние обновлено выбранной ветвью либо сохранено при отказе
; Corrupt:
;   HL, DE, BC, AF, IX, IY
; -----------------------------------------

                ; сохранение инвертирует полезные байты перед записью и сразу возвращает их в
                ; исходный вид в памяти
Entry           CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD BC, #1000
                LD DE, #061E
                LD A, #45
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #12
                LD DE, Overlay.Save.AddSectors.ConfirmText                      ; вопрос о записи текущей ситуации на диск
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD IX, Overlay.Save.AddSectors.ConfirmMenu                      ; меню подтверждения записи сохранения
                CALL Engine.SelectMenuItem                                      ; управлять указателем и выбрать прямоугольный пункт меню
                CP #02
                JP Z, .RefreshScreen                                            ; переход, если игрок отменил сохранение

                LD HL, State.SaveName
                LD DE, TrDos.Descriptor
                LD BC, #0008
                LDIR
                LD A, #4D
                LD (DE), A
                LD C, #0A
                CALL Engine.CallTrdos                                           ; вызвать TR-DOS с временным режимом IM 1
                LD A, C
                LD C, #08
                CALL Engine.CallTrdos                                           ; вызвать TR-DOS с временным режимом IM 1
                LD HL, State.Game
                LD DE, #00FF
                CALL InvertState
                LD DE, (TrDos.FileSector)
                LD HL, State.Game
                LD BC, #0106
                CALL Engine.CallTrdos                                           ; вызвать TR-DOS с временным режимом IM 1
                LD HL, State.Game
                LD DE, #00FF
                CALL InvertState
                XOR A
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD HL, Memory.PageWindow                                        ; начало сохраняемого банка, конкретный банк задаётся перед каждым блоком
                LD DE, #2859
                CALL InvertState
                LD DE, (TrDos.FileSector)
                LD A, #01
                CALL AddSectors
                LD HL, Memory.PageWindow                                        ; начало сохраняемого банка, конкретный банк задаётся перед каждым блоком
                LD BC, #2906
                CALL Engine.CallTrdos                                           ; вызвать TR-DOS с временным режимом IM 1
                LD HL, Memory.PageWindow                                        ; начало сохраняемого банка, конкретный банк задаётся перед каждым блоком
                LD DE, #2859
                CALL InvertState
                LD A, #01
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD HL, Memory.PageWindow                                        ; начало сохраняемого банка, конкретный банк задаётся перед каждым блоком
                LD DE, #3FEF
                CALL InvertState
                LD DE, (TrDos.FileSector)
                LD A, #2A
                CALL AddSectors
                LD HL, Memory.PageWindow                                        ; начало сохраняемого банка, конкретный банк задаётся перед каждым блоком
                LD BC, #4006
                CALL Engine.CallTrdos                                           ; вызвать TR-DOS с временным режимом IM 1
                LD HL, Memory.PageWindow                                        ; начало сохраняемого банка, конкретный банк задаётся перед каждым блоком
                LD DE, #3FEF
                CALL InvertState
                LD A, #0B
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD HL, Memory.PageWindow                                        ; начало сохраняемого банка, конкретный банк задаётся перед каждым блоком
                LD DE, #20CF
                CALL InvertState
                LD DE, (TrDos.FileSector)
                LD A, #6A
                CALL AddSectors
                LD HL, Memory.PageWindow                                        ; начало сохраняемого банка, конкретный банк задаётся перед каждым блоком
                LD BC, #2106
                CALL Engine.CallTrdos                                           ; вызвать TR-DOS с временным режимом IM 1
                LD HL, Memory.PageWindow                                        ; начало сохраняемого банка, конкретный банк задаётся перед каждым блоком
                LD DE, #20CF
                CALL InvertState
.RefreshScreen  CALL Engine.RefreshPanels                                       ; перерисовать верхнюю строку и боковую панель игры
                RET

; -----------------------------------------
; обратимая инверсия полезной области сохранения
; Для каждого из DE байтов по HL выполняет побитовое дополнение, увеличивает указатель и уменьшает
; остаток. Повторное применение с той же длиной восстанавливает исходное состояние. Нулевая
; входная длина обработала бы 65536 байтов из-за разрядности счётчика.
; In:
;   HL — область, DE — ненулевая длина
; Out:
;   HL после области, DE=0, A=0
; Corrupt:
;   HL, DE, AF
; -----------------------------------------
InvertState     LD A, (HL)
                CPL
                LD (HL), A
                INC HL
                DEC DE
                LD A, D
                OR E
                JR NZ, InvertState                                              ; переход, если остаются байты состояния для инвертирования

                RET

; -----------------------------------------
; прибавление смещения секторов к паре дорожка-сектор
; Старшую тетраду A прибавляет к D, младшую к E. При результате E>=16 переносит ещё одну дорожку и
; оставляет в E младшие 4 бита. Формула соответствует 16 секторам на дорожку, арифметика D
; остаётся 8-битной.
; In:
;   DE — D дорожка, E сектор 0..15, AF — смещение секторов в A
; Out:
;   DE — новая дисковая позиция
; Corrupt:
;   DE, AF
; -----------------------------------------
AddSectors      PUSH AF
                SRL A
                SRL A
                SRL A
                SRL A
                ADD A, D
                LD D, A
                POP AF
                AND #0F
                ADD A, E
                CP #10
                JR C, .StoreSector                                              ; переход, если новый номер сектора не требует переноса на следующую дорожку

                INC D
                AND #0F
.StoreSector    LD E, A
                RET

.ConfirmText    EQU $                                                           ; вопрос о записи текущей ситуации на диск
                DB #82, #EB, #20, #A6, #A5, #AB, #A0, #A5
                DB #E2, #A5, #20, #A7, #A0, #AF, #A8, #E1
                DB #A0, #E2, #EC, #0D, #2A, #A4, #A0, #AD
                DB #AD, #E3, #EE, #20, #E1, #A8, #E2, #E3
                DB #A0, #E6, #A8, #EE, #20, #AD, #A0, #20
                DB #A4, #A8, #E1, #AA, #20, #3F, #0D, #2A
                DB #0D, #00, #84, #A0, #2C, #20, #AF, #AE
                DB #A6, #A0, #AB, #E3, #A9, #E1, #E2, #A0
                DB #0D, #2A, #8D, #A5, #E2, #2C, #20, #E1
                DB #AF, #A0, #E1, #A8, #A1, #AE, #20, #21
.ConfirmMenu    EQU $+3                                                         ; меню подтверждения записи сохранения
                DB #0D, #2A, #00, #02, #0A, #80, #ED, #BE
                DB #16, #A9, #01, #15, #1F, #16, #01, #16
                DB #1F, #17, #6F, #76, #65, #72, #6C, #61
                DB #79

                assert $ = #B363
                endmodule
                endmodule
