
; -----------------------------------------
; выполнение дисковой операции с выбором привода и обработкой ошибки
; Выбирает сохранённый привод SelectDrive.Drive, вызывает защищённый шлюз CallDosIO, возвращает
; привод 0. При A=0
; возвращается. При ненулевом A выбирает сообщения «нет диска», «ошибка чтения» или «защита
; записи» и аварийно возвращает пользователя в меню.
; In:
;   HL, DE, BC — контракт вызываемой операции TR-DOS
; Out:
;   A=0 при обычном возврате
; Corrupt:
;   регистры согласно TR-DOS, HL, AF изменяются обёрткой
; Note:
;   привод, вектор TrDos.ReturnHook, обработчик ошибок BASIC
; -----------------------------------------
DiskOperation   LD A, (SelectDrive.Drive)
                PUSH HL
                PUSH DE
                PUSH BC
                CALL SelectDrive                                                ; установка текущего привода TR-DOS
                POP BC
                POP DE
                POP HL
                CALL CallDosIO                                                  ; шлюз TR-DOS с перехватом ошибок и служебных возвратов
                PUSH AF
                XOR A
                CALL SelectDrive                                                ; установка текущего привода TR-DOS
                POP AF
                OR A
                RET Z                                                           ; выход, если дисковая операция завершилась без ошибки

                LD HL, Loader.Menu.SelectDrive.NoDiskText                       ; сообщение НЕТ ДИСКА
                DEC A
                JP Z, ShowDiskError                                             ; переход, если DOS вернула код ошибки 1

                LD HL, Loader.Menu.SelectDrive.ReadErrorText                    ; сообщение ОШИБКА ЧТЕНИЯ
                DEC A
                JP Z, ShowDiskError                                             ; переход, если DOS вернула код ошибки 2

                LD HL, Loader.Menu.SelectDrive.WriteLockText                    ; сообщение ЗАЩИТА ЗАПИСИ
                JP ShowDiskError
