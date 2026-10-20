
; -----------------------------------------
; шлюз TR-DOS с перехватом ошибок и служебных возвратов
; Сохраняет SP и ERR_SP (System.ErrorSP), создаёт временный стек у #FFFF, направляет ERR_SP в
; DosErrorReturn. В
; TrDos.ReturnHook ставит JP DosReturnHook, вызывает TrDos.Service, затем восстанавливает стек и
; ERR_SP, возвращает TrDos.ReturnHook в
; RET.
; In:
;   HL — буфер, DE — дисковая позиция, BC — аргументы TR-DOS, IY указывает системные переменные
; Out:
;   A=0 обычный возврат, A=1..3 перехваченная ошибка
; Corrupt:
;   HL, DE, BC, AF по TR-DOS
; Note:
; самомодификация CallDosIO.DosBuffer/CallDosIO.SavedSP/CallDosIO.SavedErrSP, временный SP,
; System.ErrorSP, TrDos.ReturnHook..#5CC4
; -----------------------------------------

                ; временный стек и ERR_SP позволяют перехватить выходы TR-DOS, не отдавая ошибку
                ; в BASIC
CallDosIO       LD (CallDosIO.SavedSP), SP
                LD (CallDosIO.DosBuffer), HL
                LD SP, #0000
                LD HL, (System.ErrorSP)
                LD (CallDosIO.SavedErrSP), HL
                LD HL, DosErrorReturn
                PUSH HL
                LD (System.ErrorSP), SP
                LD (IY + #00), #FF                                              ; ERR_NR, удалить прежний номер ошибки перед вызовом DOS
                LD HL, DosReturnHook
                LD A, #C3
                LD (TrDos.ReturnHook), A
                LD (TrDos.ReturnTarget), HL
                LD HL, #0000
.DosBuffer      EQU $ - 2                                                       ; операнд указателя буфера перед CALL TR-DOS
                CALL TrDos.Service                                              ; вызов сервиса TR-DOS, номер операции находится в C
                XOR A

                ; единая ветвь возвращает исходные SP и ERR_SP и отключает временный перехват по
                ; TrDos.ReturnHook
.RestoreStack   LD SP, #0000
.SavedSP        EQU $ - 2                                                       ; операнд восстановления стека после TR-DOS
                LD HL, #0000
.SavedErrSP     EQU $ - 2                                                       ; операнд восстановления ERR_SP после TR-DOS
                LD (System.ErrorSP), HL
                PUSH AF
                LD A, #C9
                LD (TrDos.ReturnHook), A
                POP AF
                RET
