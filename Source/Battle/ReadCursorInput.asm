
; -----------------------------------------
; прочитать ввод при анимированном курсоре клетки
; SaveCursorBack сохраняет фон клетки, Timer начинает отсчёт с единицы, Delay получает 280
; TickCursorAnim обновляет четыре кадра поверх этого фона, Engine.ReadInput опрашивает ввод
; результат возвращается после 255 распознанных отсчётов ввода, паузы без ввода счётчик не уменьшают
; перед возвратом RestoreCursor восстанавливает пиксели и атрибуты клетки
; In:
;   BC клетка
; Out:
;   BC сохранён, AF содержит последний распознанный код, IX сохранён
; Corrupt:
;   HL, DE, AF, фон Background, Timer, Frame и операнд TickCursorAnim.Delay
;   BC, IX и IY сохранены
; -----------------------------------------
ReadCursorInput PUSH IX
                LD HL, #0001
                LD (Battle.SaveCursorBack.Timer), HL
                LD HL, #0118
                LD (Battle.TickCursorAnim.Delay), HL
                XOR A
                LD (Battle.SaveCursorBack.Frame), A
                CALL SaveCursorBack                                             ; сохранить фон под курсором клетки
                ; результат возвращается после 255 распознанных отсчётов, паузы без ввода счётчик не уменьшают
                LD L, #FF
.ReadRepeated   PUSH HL
.WaitInput      PUSH BC
                CALL TickCursorAnim                                             ; обновить кадр мигающего курсора выбранной клетки
                CALL Engine.ReadInput                                           ; прочитать клавиатуру или Kempston
                POP BC
                JR NC, .WaitInput                                               ; переход, если очередной ввод ещё не распознан

                POP HL
                DEC L
                JR NZ, .ReadRepeated                                            ; переход, если ещё не накоплены 255 распознанных отсчётов ввода

                CALL RestoreCursor                                              ; восстановить фон под курсором клетки
                POP IX
                RET

.SavedStack     DW #0000                                                        ; исходный SP входа в бой, Battle сохраняет, ResolveLosses восстанавливает
