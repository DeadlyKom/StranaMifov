
; -----------------------------------------
; расчёт следующей позиции курсора по управлению
; Опросом ReadControls получает C. При удержании одного состояния увеличивает
; MenuState.HoldTicks, выбирает скорость 1,
; 2, 3 или 4 пикселя по порогам 12, 16, 20. Биты C задают влево, вправо, вверх, вниз. Ограничивает
; x диапазоном 0..252, y 0..190 и сохраняет новую пару MenuState.NextXY.
; In:
; MenuState.CursorXY — текущая позиция, MenuState.KeyMask/MenuState.HoldTicks
; — история нажатия
; Out:
;   HL и MenuState.NextXY — новая позиция, C — управление
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   MenuState.NextXY..MenuState.HoldTicks
; -----------------------------------------
MoveCursor      CALL ReadControls                                               ; объединённый опрос клавиатуры и Kempston
                LD A, (MenuState.HoldTicks)
                INC A
                LD D, A
                LD HL, MenuState.KeyMask
                LD A, C
                CP (HL)
                JR Z, .StoreKeyState                                            ; переход, если комбинация кнопок не изменилась с прошлого опроса

                LD D, #00

                ; длительность удержания одной комбинации выбирает скорость движения от одного
                ; до четырёх пикселей
.StoreKeyState  LD (HL), A
                LD A, D
                LD (MenuState.HoldTicks), A
                LD D, #01
                CP #0C
                JR C, .MoveLeft                                                 ; переход, если удержание короче 12 опросов, скорость равна 1 пикселю

                INC D
                CP #10
                JR C, .MoveLeft                                                 ; переход, если удержание короче 16 опросов, скорость равна 2 пикселям

                INC D
                CP #14
                JR C, .MoveLeft                                                 ; переход, если удержание короче 20 опросов, скорость равна 3 пикселям

                INC D

                ; горизонтальное движение ограничено координатами 0..252, вертикальное 0..190
.MoveLeft       LD HL, (MenuState.CursorXY)
                BIT MENU_LEFT_BIT, C                                            ; флаг, движение влево
                JR Z, .MoveRight                                                ; переход, если движение влево не запрошено

                LD A, L
                SUB D
                JR NC, .StoreLeftX                                              ; переход, если новая координата X не вышла за левый край

                XOR A
.StoreLeftX     LD L, A
.MoveRight      BIT MENU_RIGHT_BIT, C                                           ; флаг, движение вправо
                JR Z, .MoveUp                                                   ; переход, если движение вправо не запрошено

                LD A, L
                ADD A, D
                JR C, .ClampRight                                               ; переход, если движение вправо переполнило байтовую координату

                CP #FC
                JR C, .StoreRightX                                              ; переход, если новая координата X меньше правого предела 252

.ClampRight     LD A, #FC
.StoreRightX    LD L, A
.MoveUp         BIT MENU_UP_BIT, C                                              ; флаг, движение вверх
                JR Z, .MoveDown                                                 ; переход, если движение вверх не запрошено

                LD A, H
                SUB D
                JR NC, .StoreUpY                                                ; переход, если новая координата Y не вышла за верхний край

                XOR A
.StoreUpY       LD H, A
.MoveDown       BIT MENU_DOWN_BIT, C                                            ; флаг, движение вниз
                JR Z, .StorePosition                                            ; переход, если движение вниз не запрошено

                LD A, H
                ADD A, D
                CP #BE
                JR C, .StoreDownY                                               ; переход, если новая координата Y меньше нижнего предела 190

                LD A, #BE
.StoreDownY     LD H, A
.StorePosition  LD (MenuState.NextXY), HL
                RET
