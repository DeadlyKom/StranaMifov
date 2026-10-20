
; -----------------------------------------
; возврат по ошибке через ERR_SP
; Устанавливает A=1 и переходит к восстановлению SP и ERR_SP в CallDosIO.RestoreStack.
; In:
; контекст ошибки шлюза CallDosIO, сохранённые операнды исходного SP по CallDosIO.SavedSP и
; ERR_SP по CallDosIO.SavedErrSP,
;   адрес возврата на исходном стеке
; Out:
; A=1, HL=сохранённый ERR_SP, System.ErrorSP восстановлен, TrDos.ReturnHook=#C9, возврат из
; дискового шлюза через
;   восстановленный SP
; Corrupt:
;   HL, AF, SP восстанавливается из операнда CallDosIO.SavedSP. DE, BC, HL', DE', BC', AF', IX, IY сам
;   обработчик не изменяет, до входа они могли быть изменены TR-DOS
; -----------------------------------------
DosErrorReturn  LD A, #01
                JR CallDosIO.RestoreStack
