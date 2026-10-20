
; -----------------------------------------
; периодический вывод и прокрутка текста во время создания новой игры
; Если #7219 ненулевой, сразу возвращается. Каждые 6 вызовов уменьшает второй счётчик, раз в 8
; таких шагов очищает 38 знаков строки 18 и печатает очередную строку из банка 6 по указателю
; #721C до CR. Маркер #B0 устанавливает #7219=#FF и завершает обработку. На остальных активных
; шагах прокручивает область от #40A2 вверх на один пиксель, 14 рядов знакомест, 7 копирований по
; 28 байтов и переход по 30 байтов к следующему ряду. Внешний обработчик прерываний сохраняет
; регистры и банк, сама процедура этого полного сохранения не делает.
; In:
;   #7219 — разрешение/завершение, #721A/#721B — счётчики, #721C — текстовый указатель
; Out:
;   при маркере #B0 #7219=#FF, иначе очередной шаг прокрутки
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   экран, банк 6, #7219..#721F
; -----------------------------------------
TickIntroText   LD A, (Startup.TickIntroText.Stopped)
                OR A
                RET NZ                                                          ; выход, если вступительный текст остановлен или уже завершён

                LD IX, Startup.TickIntroText.Timers
                DEC (IX + FIntroTimers.Scroll)
                RET NZ                                                          ; выход, если ещё не истёк шеститактовый таймер прокрутки

                LD (IX + FIntroTimers.Scroll), #06
                DEC (IX + FIntroTimers.Line)
                JR NZ, .ScrollText                                              ; переход, если до печати следующей строки остались шаги прокрутки

                LD (IX + FIntroTimers.Line), #08
                LD BC, #1202
                LD D, #26
                LD A, #20
.ClearLine      CALL DrawGlyphNoEI                                              ; нарисовать символ без дополнительного EI в обёртке переключения банка
                INC C
                DEC D
                JR NZ, .ClearLine                                               ; переход, если ещё не очищены все 38 символов строки

                LD A, #06
                CALL Memory.SelectBank                                          ; переключение логического банка через установленный драйвер памяти
                LD HL, (Startup.TickIntroText.TextPos)
                LD BC, #1202

                ; печать следующей строки вступления из банка текста до маркера конца либо перевода строки
.ReadIntroChar  LD A, (HL)
                CP #0D
                JR Z, .StoreTextPos                                             ; переход, если встретился перевод строки вступления

                CP #B0
                JR NZ, .DrawIntroChar                                           ; переход, если маркер конца вступления ещё не достигнут

                LD A, #FF
                LD (Startup.TickIntroText.Stopped), A
                RET

.DrawIntroChar  CALL DrawGlyphNoEI                                              ; нарисовать символ без дополнительного EI в обёртке переключения банка
                INC HL
                INC C
                JR .ReadIntroChar

.StoreTextPos   INC HL
                LD (Startup.TickIntroText.TextPos), HL

                ; прокрутка текстовой области, при переходе через границы экранных секций учитывается раскладка ZX Spectrum
.ScrollText     LD DE, Screen.Pixels + 5 * Screen.RowBytes + 2                  ; верхний адрес области прокрутки вступления, x16/y40
                LD B, #0E
.CharacterRow   PUSH BC
                LD (Startup.TickIntroText.RowStart), DE
                PUSH DE
                POP HL
                INC H
                LD B, #07
.PixelRow       PUSH HL
                PUSH DE
                PUSH BC
                LD BC, #001C
                LDIR
                POP BC
                POP DE
                POP HL
                INC D
                INC H
                DJNZ .PixelRow

                LD HL, (Startup.TickIntroText.RowStart)
                LD A, L
                ADD A, #20
                LD L, A
                JR NC, .NextCharRow                                             ; переход, если следующий ряд знакомест остаётся в той же трети экрана

                LD A, H
                ADD A, #08
                LD H, A
.NextCharRow    PUSH HL
                LD BC, #001E
                LDIR
                POP DE
                POP BC
                DJNZ .CharacterRow

                RET

.Stopped        DB #FF                                                          ; ненулевой байт останавливает прокрутку вступления
.Timers         DB #02, #01                                                     ; два счётчика прокрутки вступления FIntroTimers
.TextPos        DW #C000                                                        ; указатель следующего символа вступительного текста
.RowStart       DW #0000                                                        ; сохранённое начало ряда знакомест при прокрутке
