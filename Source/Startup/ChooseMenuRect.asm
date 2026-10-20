
; -----------------------------------------
; выбор прямоугольной области меню пиксельным курсором
; Убирает оставшееся вращение образцов по #770A, выравнивает их на начальный x и копирует его в
; старую/новую позицию. Сохраняет фон, проверяет область под курсором и выделяет её обменом
; INK/PAPER. Цикл сравнивает новый указатель области с предыдущим #763F, снимает старое выделение
; и ставит новое. После HALT восстанавливает старый фон, сохраняет новый, рисует курсор и
; переносит позицию в #76BE. Коды управления перемещают по 1 пикселю, включая диагонали. Код #27
; выбирает только существующую область. Перед возвратом убирает подсветку и курсор, сохраняет
; позицию в дескрипторе.
; In:
;   IX — дескриптор, число областей, +1minX, +2minY, +3maxX, +4maxY, +5currentX, +6currentY,
;   далее четверки left, top, right, bottom в знакоместах
; Out:
;   A — номер выбранной области с 1, IX остаётся дескриптором, его+5/+6 содержат позицию
; Corrupt:
;   HL, DE, BC, AF, IY, прерывания EI
; Note:
;   экран, #763F, #76BE..#770A, координаты дескриптора
; -----------------------------------------
ChooseMenuRect  LD A, (Startup.BL3_cursorMask.Rotation)
                OR A
                JR Z, .InitCursor                                               ; переход, если курсор уже имеет исходное вращение

                CALL RotateCursorL                                              ; циклическое вращение 24-битных строк рисунка и маски курсора влево
.InitCursor     LD A, (IX + FMenuHeader.CursorX)                                ; +#05, сохраняемая пиксельная X указателя
                AND #07
                CALL NZ, RotateCursorR                                          ; вызов, если X курсора не выровнен на начало знакоместа
                LD C, (IX + FMenuHeader.CursorX)                                ; +#05, сохраняемая пиксельная X указателя
                LD B, (IX + FMenuHeader.CursorY)                                ; +#06, сохраняемая пиксельная Y указателя
                LD (Startup.RotateCursorL.HitPos), BC
                LD (Startup.RotateCursorL.PixelPos), BC
                CALL SaveCursorBack                                             ; сохранение фона новой позиции курсора
                CALL HitTestMenu                                                ; поиск прямоугольника меню под пиксельным курсором
                LD (Startup.ReadMenuInput.HoverRect), IY
                OR A
                CALL NZ, ToggleMenuInk                                          ; вызов, если курсор попал в пункт меню
                EI
.HitTest        CALL HitTestMenu                                                ; поиск прямоугольника меню под пиксельным курсором
                OR A
                JR Z, .ClearHover                                               ; переход, если под курсором нет пункта меню

                LD BC, (Startup.ReadMenuInput.HoverRect)
                LD A, B
                OR C
                JR NZ, .ChangeHover                                             ; переход, если предыдущий подсвеченный пункт существует

                LD (Startup.ReadMenuInput.HoverRect), IY
                CALL ToggleMenuInk                                              ; обратимая подсветка области меню обменом INK и PAPER
                JR .DrawCursor

                ; снятие подсветки прежнего пункта и включение подсветки нового прямоугольника
.ChangeHover    PUSH IY
                POP HL
                LD BC, (Startup.ReadMenuInput.HoverRect)
                OR A
                SBC HL, BC
                JR Z, .DrawCursor                                               ; переход, если курсор остался в прежнем пункте меню

                PUSH IY
                LD IY, (Startup.ReadMenuInput.HoverRect)
                CALL ToggleMenuInk                                              ; обратимая подсветка области меню обменом INK и PAPER
                POP IY
                LD (Startup.ReadMenuInput.HoverRect), IY
                CALL ToggleMenuInk                                              ; обратимая подсветка области меню обменом INK и PAPER
                JR .DrawCursor

.ClearHover     LD BC, (Startup.ReadMenuInput.HoverRect)
                LD A, B
                OR C
                JR Z, .DrawCursor                                               ; переход, если подсвеченного пункта уже нет

                LD IY, (Startup.ReadMenuInput.HoverRect)
                CALL ToggleMenuInk                                              ; обратимая подсветка области меню обменом INK и PAPER
                LD BC, #0000
                LD (Startup.ReadMenuInput.HoverRect), BC

                ; восстановление прежнего фона курсора, сохранение нового и повторное наложение рисунка
.DrawCursor     HALT
                PUSH IX
                PUSH IY
                CALL RestoreCursor                                              ; восстановление фона старой позиции курсора
                CALL SaveCursorBack                                             ; сохранение фона новой позиции курсора
                CALL DrawMenuCursor                                             ; рисование курсора в новой позиции с выравниванием маски
                LD BC, (Startup.RotateCursorL.HitPos)
                LD (Startup.RotateCursorL.PixelPos), BC
                POP IY
                POP IX
                CALL ReadMenuInput                                              ; опрос клавиатуры ROM и Kempston с преобразованием направлений
                CP #13
                JR NZ, .TestUp                                                  ; переход, если не выбрано движение влево вверх

                CALL CursorUp                                                   ; движение курсора на один пиксель вверх в пределах меню
                CALL CursorLeft                                                 ; движение курсора на один пиксель влево в пределах меню
                JR .HitTest

.TestUp         CP #1B
                JR NZ, .TestNorthEast                                           ; переход, если не выбрано движение вверх

                CALL CursorUp                                                   ; движение курсора на один пиксель вверх в пределах меню
                JR .HitTest

.TestNorthEast  CP #23
                JR NZ, .TestLeft                                                ; переход, если не выбрано движение вправо вверх

                CALL CursorUp                                                   ; движение курсора на один пиксель вверх в пределах меню
                CALL CursorRight                                                ; движение курсора на один пиксель вправо в пределах меню
                JP .HitTest

.TestLeft       CP #12
                JR NZ, .TestRight                                               ; переход, если не выбрано движение влево

                CALL CursorLeft                                                 ; движение курсора на один пиксель влево в пределах меню
                JP .HitTest

.TestRight      CP #22
                JR NZ, .TestSouthWest                                           ; переход, если не выбрано движение вправо

                CALL CursorRight                                                ; движение курсора на один пиксель вправо в пределах меню
                JP .HitTest

.TestSouthWest  CP #11
                JR NZ, .TestDown                                                ; переход, если не выбрано движение влево вниз

                CALL CursorLeft                                                 ; движение курсора на один пиксель влево в пределах меню
                CALL CursorDown                                                 ; движение курсора на один пиксель вниз в пределах меню
                JP .HitTest

.TestDown       CP #19
                JR NZ, .TestSouthEast                                           ; переход, если не выбрано движение вниз

                CALL CursorDown                                                 ; движение курсора на один пиксель вниз в пределах меню
                JP .HitTest

.TestSouthEast  CP #21
                JR NZ, .TestConfirm                                             ; переход, если не выбрано движение вправо вниз

                CALL CursorRight                                                ; движение курсора на один пиксель вправо в пределах меню
                CALL CursorDown                                                 ; движение курсора на один пиксель вниз в пределах меню
                JP .HitTest

.TestConfirm    CP #27
                JP NZ, .HitTest                                                 ; переход, если не нажато подтверждение выбора

                CALL HitTestMenu                                                ; поиск прямоугольника меню под пиксельным курсором
                OR A
                JP Z, .HitTest                                                  ; переход, если подтверждение нажато вне пунктов меню

                PUSH AF
                CALL ToggleMenuInk                                              ; обратимая подсветка области меню обменом INK и PAPER
                CALL RestoreCursor                                              ; восстановление фона старой позиции курсора
                LD BC, (Startup.RotateCursorL.PixelPos)
                LD (IX + FMenuHeader.CursorX), C                                ; +#05, сохраняемая пиксельная X указателя
                LD (IX + FMenuHeader.CursorY), B                                ; +#06, сохраняемая пиксельная Y указателя
                POP AF
                RET
