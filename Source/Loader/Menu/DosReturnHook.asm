
; -----------------------------------------
; перехват возвратов TR-DOS через TrDos.ReturnHook
; Меняет HL с вершиной стека и проверяет адрес возврата. Для #0D6B формирует код 2 или 3 по
; TrDos.IOMode
; и покидает шлюз. Для #1F54 заменяет адрес на #653C, что приводит к успешному выходу поиска.
; Остальные возвраты сохраняет.
; In:
;   стек вызова TR-DOS, TrDos.IOMode
; Out:
;   изменённый адрес возврата или выход через CallDosIO.RestoreStack
; Corrupt:
;   HL, AF временно сохраняются, состояние прерываний DI
; Note:
;   вершина стека
; -----------------------------------------

                ; шлюз распознаёт конкретные адреса возврата ROM TR-DOS, этот контракт зависит
                ; от версии ROM
DosReturnHook   DI
                EX (SP), HL
                PUSH AF
                LD A, H
                CP #0D
                JR NZ, .CheckFoundFile                                          ; переход, если адрес возврата не соответствует перехватываемой ошибке TR-DOS

                LD A, L
                CP #6B
                JR NZ, .CheckFoundFile                                          ; переход, если адрес возврата не соответствует перехватываемой ошибке TR-DOS

                LD A, (TrDos.IOMode)
                OR A
                LD A, #02
                JR Z, CallDosIO.RestoreStack                                    ; переход, если прервана операция чтения, вернуть код ошибки 2

                INC A
                JR CallDosIO.RestoreStack

.CheckFoundFile LD A, H
                CP #1F
                JR NZ, .ReturnToDos                                             ; переход, если возврат не требует подмены обработчиком поиска файла

                LD A, L
                CP #54
                JR NZ, .ReturnToDos                                             ; переход, если возврат не требует подмены обработчиком поиска файла

                LD HL, Loader.Menu.FindFile.Found                               ; SCF нормального завершения FindFile, используется перехватом возврата TR-DOS
.ReturnToDos    POP AF
                EX (SP), HL
                RET
