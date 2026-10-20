
; -----------------------------------------
; объединённый опрос клавиатуры и Kempston
; Опросом четырёх наборов по пять кодов получает пять логических кнопок. Объединяет состояния OR.
; Kempston учитывает только если IN (#1F) не равен #FF.
; In:
;   порты клавиатуры и Kempston
; Out:
;   C и A — маска, bit 0 действие, bit 1 вниз, bit 2 вверх, bit 3 вправо, bit 4 влево
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   нет записи
; -----------------------------------------
ReadControls    LD HL, Loader.Menu.MenuState.KeyMaps                            ; первые три набора соответствия кнопок управления
                LD BC, #0500
                CALL ReadKeyCodes                                               ; опрос последовательности упакованных кодов кнопок
                PUSH BC
                LD BC, #0500
                CALL ReadKeyCodes                                               ; опрос последовательности упакованных кодов кнопок
                LD A, C
                POP BC
                OR C
                LD C, A
                PUSH BC
                LD BC, #0500
                IN A, (#1F)
                CP #FF
                CALL NZ, ReadKeyCodes                                           ; вызов, если порт Kempston ответил значением, отличным от #FF
                LD A, C
                POP BC
                OR C
                LD C, A
                PUSH BC
                LD BC, #0500
                LD HL, Loader.Menu.MenuState.ExtraKeys                          ; четвёртый набор соответствия кнопок управления
                CALL ReadKeyCodes                                               ; опрос последовательности упакованных кодов кнопок
                LD A, C
                POP BC
                OR C
                LD C, A
                RET
