
; -----------------------------------------
; переключение настройки редактора и отметки изменения
; Инвертирует бит 0 в SelectDrive.EditFlags и бит 5 в Loader.Menu.DegradeSwitch. Последний байт
; представляет код команды head.co со
; смещением #3E09, адрес исполнения #9F67. Переключение #38/#18 меняет JR C на безусловный JR,
; разрешая либо обходя деградацию армии. Обновляет подпись и возвращается в меню редактора.
; In:
;   SelectDrive.EditFlags, Loader.Menu.DegradeSwitch — текущие состояния
; Out:
;   переход к EditUnits.BeginChoice
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   SelectDrive.EditFlags, Loader.Menu.DegradeSwitch, экран
; -----------------------------------------

                ; редактор меняет исходный код JR C на JR и обратно, отдельного игрового поля
                ; для этой настройки нет
ToggleDegrade   LD A, (SelectDrive.EditFlags)
                XOR #01
                LD (SelectDrive.EditFlags), A
                LD A, (Loader.Menu.DegradeSwitch)
                XOR #20
                LD (Loader.Menu.DegradeSwitch), A
                CALL PrintDegrade                                               ; вывод состояния переключаемой настройки редактора
                JP EditUnits.BeginChoice
