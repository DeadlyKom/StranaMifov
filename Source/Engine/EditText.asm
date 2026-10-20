
; -----------------------------------------
; редактировать строку с анимированным курсором
; BC экранная позиция, IX буфер, A максимальная длина, сохраняет состояние в #6E9B..#6E9F, бит 5
; #6566 включает курсор, #0C удаляет символ, #0D/#0E завершают ввод, вводимый символ записывается
; в буфер с ограничением длины
; In:
;   BC экранная позиция, AF, A максимальная длина, IX изменяемый буфер указанной длины
; Out:
;   HL, H исходная максимальная длина и L число введённых символов, AF, A=#0D либо #0E,
;   IX=#6565, BC и IY сохранены, буфер изменён, бит 5 #6566 снят
; Corrupt:
;   HL, DE, AF, IX, поля #6E9B..#6E9F и #6563, состояние клавиатуры #5C08
; -----------------------------------------
EditText        LD (Engine.DrawEditText.TextPos), BC
                LD (Engine.DrawEditText.TextBuffer), IX
                LD (Engine.DrawEditText.TextLength), A
                LD (State.CursorPos), BC
                LD H, A
                LD L, #00
                LD A, (State.ViewFlags)
                SET TEXT_CURSOR_BIT, A                                          ; разрешает мигающий текстовый курсор в кадровом обработчике
                LD (State.ViewFlags), A

                ; перерисовка буфера после принятого изменения текста
.Redraw         CALL DrawEditText                                               ; перерисовать поле редактирования
.ReadKey        CALL ReadTextChar                                               ; прочитать и преобразовать символ текстового ввода
                CP #0E
                JR NZ, .CheckEnter                                              ; переход, если введена не команда отмены

                ; отключение текстового курсора при завершении ввода
.FinishEdit     LD IX, State.EventFlags
                RES TEXT_CURSOR_BIT, (IX + State.ViewFlags - State.EventFlags)  ; разрешает мигающий текстовый курсор в кадровом обработчике
                CALL DrawEditText                                               ; перерисовать поле редактирования
                RET

.CheckEnter     CP #0D
                JR Z, .FinishEdit                                               ; переход, если введена команда подтверждения строки

                CP #0C
                JR NZ, .InsertChar                                              ; переход, если введена не команда удаления символа

                LD A, L
                OR A
                JR Z, .ReadKey                                                  ; переход, если буфер уже пуст и удалять нечего

                DEC L
                PUSH HL
                EX DE, HL
                LD D, #00
                LD HL, (Engine.DrawEditText.TextBuffer)
                ADD HL, DE
                LD (HL), #20
                LD HL, (State.CursorPos)
                DEC L
                LD (State.CursorPos), HL
                POP HL
                JR .Redraw

                ; добавление символа допускается только до предела длины
.InsertChar     LD D, A
                LD A, L
                CP H
                JR Z, .ReadKey                                                  ; переход, если буфер достиг предельной длины

                LD A, D
                PUSH HL
                EX DE, HL
                LD D, #00
                LD HL, (Engine.DrawEditText.TextBuffer)
                ADD HL, DE
                LD (HL), A
                LD HL, (State.CursorPos)
                INC L
                LD (State.CursorPos), HL
                POP HL
                INC L
                JR .Redraw
