
; -----------------------------------------
; подготовка выбора пункта меню курсором
; Сохраняет таблицу HL, переводит текущую позицию в символьные координаты, обновляет подсветку,
; ждёт отпускания кнопки, сохраняет фон и рисует курсор.
; In:
;   HL — таблица троек областей, MenuState.CursorXY — позиция
; Out:
;   активное меню готово
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   MenuState.Areas, фон курсора, экран
; -----------------------------------------
BeginMenu       LD (MenuState.Areas), HL
                LD BC, (MenuState.CursorXY)
                SRL B
                SRL B
                SRL B
                SRL C
                SRL C
                SRL C
                CALL HighlightAreas                                             ; подсветка области меню под курсором
                CALL WaitRelease                                                ; ожидание отпускания кнопки действия
                LD C, #00
                CALL CursorBackdrop                                             ; сохранение или восстановление фона курсора
                JP DrawCursor
