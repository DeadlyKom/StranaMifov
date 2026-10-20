
; -----------------------------------------
; управлять указателем и выбрать прямоугольный пункт меню
; IX описатель меню, +0 число областей, +1..4 границы перемещения, +5/+6 начальная пиксельная
; позиция, с+7 идут прямоугольники по 4 байта в знакоместах, #787E определяет активный пункт,
; #78D6 меняет его атрибуты, ввод через #791E, сохранение фона через #7735/#7750
; In:
;   IX изменяемый описатель меню, экран уже содержит области выбора
; Out:
;   BC последняя пиксельная позиция указателя, AF, A выбранный пункт 1..N, IX сохранён, IY
;   выбранный прямоугольник, IX+5/+6 обновлены
; Corrupt:
;   HL, DE, BC, AF, IY, экран временно меняется и восстанавливается под указателем, IFF
;   устанавливается через EI, клавиатурный ROM может изменять альтернативные регистры
; -----------------------------------------
SelectMenuItem  LD A, (Engine.head_cursorMask.PixelShift)
                OR A
                JR Z, .PrepareCursor                                            ; переход, если шаблон курсора уже не имеет остаточного сдвига

                CALL ShiftCursorL                                               ; циклически сдвинуть влево 24 битные строки указателя и маски
.PrepareCursor  LD A, (IX + FMenuHeader.CursorX)                                ; +#05, сохраняемая X указателя
                AND #07
                CALL NZ, ShiftCursorR                                           ; вызов процедуры, если начальная позиция указателя требует пиксельного сдвига шаблона
                LD C, (IX + FMenuHeader.CursorX)                                ; +#05, сохраняемая X указателя
                LD B, (IX + FMenuHeader.CursorY)                                ; +#06, сохраняемая Y указателя
                LD (Engine.ShiftCursorL.NewCursor), BC
                LD (Engine.ShiftCursorL.OldCursor), BC
                CALL SaveCursor                                                 ; сохранить фон под указателем меню
                CALL HitTestMenu                                                ; найти прямоугольник меню под пиксельным указателем
                LD (Engine.WaitMenuInput.HighlightRect), IY
                OR A
                CALL NZ, InvertMenuItem                                         ; вызов процедуры, если указатель находится над пунктом меню
                EI

                ; смена подсветки только при переходе указателя на другой пункт
.TestSelection  CALL HitTestMenu                                                ; найти прямоугольник меню под пиксельным указателем
                OR A
                JR Z, .ClearHighlight                                           ; переход, если указатель находится вне всех пунктов

                LD BC, (Engine.WaitMenuInput.HighlightRect)
                LD A, B
                OR C
                JR NZ, .CheckChanged                                            ; переход, если ранее уже был подсвечен пункт

                LD (Engine.WaitMenuInput.HighlightRect), IY
                CALL InvertMenuItem                                             ; поменять местами INK и PAPER прямоугольного пункта меню
                JR .DrawCursor

.CheckChanged   PUSH IY
                POP HL
                LD BC, (Engine.WaitMenuInput.HighlightRect)
                OR A
                SBC HL, BC
                JR Z, .DrawCursor                                               ; переход, если указатель остался над тем же пунктом

                PUSH IY
                LD IY, (Engine.WaitMenuInput.HighlightRect)
                CALL InvertMenuItem                                             ; поменять местами INK и PAPER прямоугольного пункта меню
                POP IY
                LD (Engine.WaitMenuInput.HighlightRect), IY
                CALL InvertMenuItem                                             ; поменять местами INK и PAPER прямоугольного пункта меню
                JR .DrawCursor

                ; снятие подсветки при выходе указателя за все пункты
.ClearHighlight LD BC, (Engine.WaitMenuInput.HighlightRect)
                LD A, B
                OR C
                JR Z, .DrawCursor                                               ; переход, если подсвеченного пункта уже нет

                LD IY, (Engine.WaitMenuInput.HighlightRect)
                CALL InvertMenuItem                                             ; поменять местами INK и PAPER прямоугольного пункта меню
                LD BC, #0000
                LD (Engine.WaitMenuInput.HighlightRect), BC

                ; восстановление старого фона курсора и вывод его нового положения
.DrawCursor     HALT
                PUSH IX
                PUSH IY
                CALL RestoreCursor                                              ; восстановить фон под старой позицией указателя
                CALL SaveCursor                                                 ; сохранить фон под указателем меню
                CALL DrawMenuCursor                                             ; нарисовать указатель меню с пиксельным смещением
                LD BC, (Engine.ShiftCursorL.NewCursor)
                LD (Engine.ShiftCursorL.OldCursor), BC
                POP IY
                POP IX
                CALL WaitMenuInput                                              ; дождаться клавиши либо Kempston для меню
                CP #13
                JR NZ, .CheckNorth                                              ; переход, если команда не задаёт шаг вверх-влево

                CALL CursorUp                                                   ; сдвинуть указатель меню на пиксель вверх
                CALL CursorLeft                                                 ; сдвинуть указатель меню на пиксель влево
                JR .TestSelection

.CheckNorth     CP #1B
                JR NZ, .CheckNorthEast                                          ; переход, если команда не задаёт шаг вверх

                CALL CursorUp                                                   ; сдвинуть указатель меню на пиксель вверх
                JR .TestSelection

.CheckNorthEast CP #23
                JR NZ, .CheckWest                                               ; переход, если команда не задаёт шаг вверх-вправо

                CALL CursorUp                                                   ; сдвинуть указатель меню на пиксель вверх
                CALL CursorRight                                                ; сдвинуть указатель меню на пиксель вправо
                JP .TestSelection

.CheckWest      CP #12
                JR NZ, .CheckEast                                               ; переход, если команда не задаёт шаг влево

                CALL CursorLeft                                                 ; сдвинуть указатель меню на пиксель влево
                JP .TestSelection

.CheckEast      CP #22
                JR NZ, .CheckSouthWest                                          ; переход, если команда не задаёт шаг вправо

                CALL CursorRight                                                ; сдвинуть указатель меню на пиксель вправо
                JP .TestSelection

.CheckSouthWest CP #11
                JR NZ, .CheckSouth                                              ; переход, если команда не задаёт шаг вниз-влево

                CALL CursorLeft                                                 ; сдвинуть указатель меню на пиксель влево
                CALL CursorDown                                                 ; сдвинуть указатель меню на пиксель вниз
                JP .TestSelection

.CheckSouth     CP #19
                JR NZ, .CheckSouthEast                                          ; переход, если команда не задаёт шаг вниз

                CALL CursorDown                                                 ; сдвинуть указатель меню на пиксель вниз
                JP .TestSelection

.CheckSouthEast CP #21
                JR NZ, .CheckConfirm                                            ; переход, если команда не задаёт шаг вниз-вправо

                CALL CursorRight                                                ; сдвинуть указатель меню на пиксель вправо
                CALL CursorDown                                                 ; сдвинуть указатель меню на пиксель вниз
                JP .TestSelection

                ; подтверждение допускается только над действующим пунктом
.CheckConfirm   CP #27
                JP NZ, .TestSelection                                           ; переход, если не нажата команда подтверждения пункта

                CALL HitTestMenu                                                ; найти прямоугольник меню под пиксельным указателем
                OR A
                JP Z, .TestSelection                                            ; переход, если указатель находится вне всех пунктов

                PUSH AF
                CALL InvertMenuItem                                             ; поменять местами INK и PAPER прямоугольного пункта меню
                CALL RestoreCursor                                              ; восстановить фон под старой позицией указателя
                LD BC, (Engine.ShiftCursorL.OldCursor)
                LD (IX + FMenuHeader.CursorX), C                                ; +#05, сохраняемая X указателя
                LD (IX + FMenuHeader.CursorY), B                                ; +#06, сохраняемая Y указателя
                POP AF
                RET
