
; -----------------------------------------
; один шаг ожидания выбора в меню
; Рассчитывает движение, при ненулевом управлении ждёт кадр через HALT. При кнопке 0 проверяет
; нахождение курсора в окне и ищет отмеченную область в таблице. Возвращает номер найденной
; области или #FF вне окна.
; In:
;   состояние меню и управления
; Out:
; CF=1 при выборе, A — индекс пункта или #FF, MenuState.Choice — индекс, при обычном
; ожидании CF=0
; Corrupt:
;   HL, DE, BC, AF, IX сохраняется при прямом обходе выбора, изменяется обработчиком обновления
; Note:
;   MenuState.NextXY, MenuState.KeyMask/MenuState.HoldTicks, таблица областей
; -----------------------------------------
PollMenu        CALL MoveCursor                                                 ; расчёт следующей позиции курсора по управлению
                LD A, C
                OR A
                RET Z                                                           ; выход, если не нажата ни одна кнопка управления

                CALL WaitCursorFrame                                            ; ожидание одного прерывания с обновлением курсора
                LD A, (MenuState.KeyMask)
                RRA
                RET NC                                                          ; выход, если кнопка подтверждения не нажата

                LD A, (MenuState.CursorXY)
                AND A
                RRA
                AND A
                RRA
                AND A
                RRA
                PUSH IX
                LD IX, (PixelAddress.Window)
                SUB (IX + FMenuWindow.X)
                JR C, .OutsideWindow                                            ; переход, если курсор расположен левее активного окна

                SUB (IX + FMenuWindow.Width)
                JR NC, .OutsideWindow                                           ; переход, если курсор расположен правее активного окна

                LD A, (MenuState.CursorY)
                AND A
                RRA
                AND A
                RRA
                AND A
                RRA
                SUB (IX + FMenuWindow.Y)
                JR C, .OutsideWindow                                            ; переход, если курсор расположен выше активного окна

                SUB (IX + FMenuWindow.Height)
                JR C, .FindSelection                                            ; переход, если курсор находится внутри окна по вертикали

.OutsideWindow  POP IX
                LD A, #FF
                SCF
                RET

                ; выбор ищется по отмеченному биту 7 области, возвращается индекс тройки в
                ; таблице меню
.FindSelection  POP IX
                LD HL, (MenuState.Areas)
                LD DE, #0003
                LD C, #00
.AreaLoop       LD A, (HL)
                CP #FF
                RET Z                                                           ; выход, если достигнут конец таблицы и подсвеченный пункт не найден

                JP M, .SelectedArea                                             ; переход, если найдена подсвеченная область меню

                ADD HL, DE
                INC C
                JR .AreaLoop

.SelectedArea   RES MENU_ACTIVE_BIT, (HL)                                       ; флаг, область меню подсвечена обменом INK и PAPER
                LD A, C
                LD (MenuState.Choice), A
                SCF
                RET
