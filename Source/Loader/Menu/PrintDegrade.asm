
; -----------------------------------------
; вывод состояния переключаемой настройки редактора
; Печатает строку «Деградация». Если Loader.Menu.DegradeSwitch=#18, выбирает подпись «отключена»
; по #6865, иначе
; «включена» по #6858.
; In:
;   Loader.Menu.DegradeSwitch — значение настройки
; Out:
;   выведена соответствующая подпись
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   экран
; -----------------------------------------
PrintDegrade    LD HL, Loader.Menu.SelectDrive.DegradeHeading                   ; надпись Деградация перед состоянием переключателя
                CALL PrintString                                                ; печать строки с управляющими кодами
                LD A, (Loader.Menu.DegradeSwitch)
                LD HL, Loader.Menu.SelectDrive.DegradeOff                       ; надпись отключена для настройки деградации
                CP #18
                JR Z, .PrintState                                               ; переход, если деградация отключена, выбрана соответствующая подпись

                LD HL, Loader.Menu.SelectDrive.DegradeOn                        ; надпись включена для настройки деградации
.PrintState     JP PrintString
