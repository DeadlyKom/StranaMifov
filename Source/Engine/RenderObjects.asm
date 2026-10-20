
; -----------------------------------------
; обновить 48 экранных объектов сетки 8 на 6
; записи #6571 шаг 20, каждая занимает 4 на 4 знакоместа, типы 1 и 2 выводят разные форматы, тип 3
; фон и маску, тип 4 анимирован, биты 7/6 выбирают горизонтальное отражение, бит 5 включает
; численную подпись через #827A
; In:
;   48 записей #6571 и численные подписи #6931, экранная сетка 8 на 6
; Out:
;   пиксельные/атрибутные слои и подписи обновлены по типам/флагам, счётчик #8243=48, IX=#6931,
;   BC=#1800 после обхода
; Corrupt:
;   HL, DE, BC, AF, IX, IY, банки и IFF переключателя, поля объектов/анимации и экран
; -----------------------------------------
RenderObjects   XOR A
.FrameLink      EQU FScreenObject20.Frame1Bank - FFrameRef                      ; смещение ссылки при IX=объект+номер_кадра*FFrameRef
                LD (Engine.RenderObjects.ObjectIndex), A
                LD E, #30
                LD BC, #0000
                LD IX, State.ViewObjects

                ; выбор режима вывода следующего двадцатибайтного объекта
.ObjectLoop     PUSH BC
                PUSH DE
                PUSH IX
                LD A, (IX + FScreenObject20.Flags)                              ; +#00, режим и флаги экранного объекта
                AND #1F
                JP Z, .NextObject                                               ; переход, если режим вывода объекта равен нулю

                CP #01
                JR NZ, .CheckMasked                                             ; переход, если режим объекта не задаёт непрозрачный фон

                LD A, (IX + FScreenObject20.BaseBank)                           ; +#05, банк фонового изображения
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD A, (IX + FScreenObject20.Flags)                              ; +#00, режим и флаги экранного объекта
                AND #80
                LD H, (IX + FScreenObject20.BaseAddress.High)                   ; +#07, старший байт адреса фона
                LD L, (IX + FScreenObject20.BaseAddress.Low)                    ; +#06, младший байт адреса фона
                CALL DrawBackLayer                                              ; нарисовать фон объекта 4 на 4 знакоместа
                LD A, (IX + FScreenObject20.Flags)                              ; +#00, режим и флаги экранного объекта
                AND #E0
                LD (IX + FScreenObject20.Flags), A                              ; +#00, режим и флаги экранного объекта
                JP .CheckCount

                ; режим маскированного изображения
.CheckMasked    CP #02
                JR NZ, .CheckComposite                                          ; переход, если режим объекта не задаёт одиночную маску

                LD A, (IX + FScreenObject20.BaseBank)                           ; +#05, банк фонового изображения
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD A, (IX + FScreenObject20.Flags)                              ; +#00, режим и флаги экранного объекта
                AND #80
                LD H, (IX + FScreenObject20.BaseAddress.High)                   ; +#07, старший байт адреса фона
                LD L, (IX + FScreenObject20.BaseAddress.Low)                    ; +#06, младший байт адреса фона
                CALL DrawMaskLayer                                              ; нарисовать маскированный слой объекта 4 на 4 знакоместа
                LD A, (IX + FScreenObject20.Flags)                              ; +#00, режим и флаги экранного объекта
                AND #E0
                LD (IX + FScreenObject20.Flags), A                              ; +#00, режим и флаги экранного объекта
                JP .CheckCount

                ; раздельный вывод фона и переднего маскированного слоя
.CheckComposite CP #03
                JR NZ, .TickAnimation                                           ; переход, если режим объекта не задаёт композицию фона и маски

                LD A, (IX + FScreenObject20.BaseBank)                           ; +#05, банк фонового изображения
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD A, (IX + FScreenObject20.Flags)                              ; +#00, режим и флаги экранного объекта
                AND #80
                LD H, (IX + FScreenObject20.BaseAddress.High)                   ; +#07, старший байт адреса фона
                LD L, (IX + FScreenObject20.BaseAddress.Low)                    ; +#06, младший байт адреса фона
                CALL DrawBackLayer                                              ; нарисовать фон объекта 4 на 4 знакоместа
                LD A, (IX + FScreenObject20.Frame1Bank)                         ; +#08, банк переднего слоя
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD H, (IX + FScreenObject20.Frame1Address.High)                 ; +#0A, старший байт адреса переднего слоя
                LD L, (IX + FScreenObject20.Frame1Address.Low)                  ; +#09, младший байт адреса переднего слоя
                LD A, (IX + FScreenObject20.Flags)                              ; +#00, режим и флаги экранного объекта
                AND #40
                CALL DrawMaskLayer                                              ; нарисовать маскированный слой объекта 4 на 4 знакоместа
                LD A, (IX + FScreenObject20.Flags)                              ; +#00, режим и флаги экранного объекта
                AND #E0
                LD (IX + FScreenObject20.Flags), A                              ; +#00, режим и флаги экранного объекта
                JP .CheckCount

                ; анимация обновляется только при истечении счётчика кадра
.TickAnimation  CP #04
                JP NZ, .NextObject                                              ; переход, если режим объекта не является анимацией

                DEC (IX + FScreenObject20.AnimationTimer)                       ; +#01, счётчик смены кадра
                JP NZ, .NextObject                                              ; переход, если счётчик анимации ещё не истёк

                PUSH IX
                LD A, (IX + FScreenObject20.AnimationPeriod)                    ; +#03, значение перезагрузки счётчика
                LD (IX + FScreenObject20.AnimationTimer), A                     ; +#01, счётчик смены кадра
                INC (IX + FScreenObject20.AnimationFrame)                       ; +#02, текущий номер кадра 1..FrameCount, увеличивается перед выводом
                LD A, (IX + FScreenObject20.FrameCount)                         ; +#04, число кадров
                CP (IX + FScreenObject20.AnimationFrame)                        ; +#02, текущий номер кадра 1..FrameCount, увеличивается перед выводом
                JR NC, .BaseFrame                                               ; переход, если номер кадра ещё укладывается в число кадров объекта

                LD (IX + FScreenObject20.AnimationFrame), #01                   ; +#02, текущий номер кадра 1..FrameCount, увеличивается перед выводом

                ; восстановление фона перед наложением очередного кадра
.BaseFrame      LD A, (IX + FScreenObject20.BaseBank)                           ; +#05, банк основного изображения
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD A, (IX + FScreenObject20.Flags)                              ; +#00, младшие 5 бит режим 0..4, бит 5 численная подпись, биты 6/7 отражение
                AND #80
                LD H, (IX + FScreenObject20.BaseAddress.High)                   ; +#07, старший байт адреса фона
                LD L, (IX + FScreenObject20.BaseAddress.Low)                    ; +#06, младший байт адреса фона
                CALL DrawBackLayer                                              ; нарисовать фон объекта 4 на 4 знакоместа
                LD A, (IX + FScreenObject20.Flags)                              ; +#00, младшие 5 бит режим 0..4, бит 5 численная подпись, биты 6/7 отражение
                PUSH AF
                LD A, (IX + FScreenObject20.AnimationFrame)                     ; +#02, текущий номер кадра 1..FrameCount, увеличивается перед выводом

                ; выбор трёхбайтной ссылки по номеру кадра, IX временно сдвигается внутри записи
.FrameLoop      INC IX
                INC IX
                INC IX
                DEC A
                JR NZ, .FrameLoop                                               ; переход, если ещё не достигнута ссылка на выбранный кадр

                LD A, (IX + .FrameLink + FFrameRef.Bank)
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                POP AF
                AND #40
                LD H, (IX + .FrameLink + FFrameRef.Address.High)
                LD L, (IX + .FrameLink + FFrameRef.Address.Low)
                CALL DrawMaskLayer                                              ; нарисовать маскированный слой объекта 4 на 4 знакоместа
                POP IX

                ; численная подпись берётся из отдельного массива по индексу объекта
.CheckCount     BIT DRAW_NUMBER_BIT, (IX + FScreenObject20.Flags)               ; +#00, режим и флаги экранного объекта
                JR Z, .NextObject                                               ; переход, если численная подпись объекта отключена

                PUSH BC
                SLA C
                SLA C
                SLA C
                LD A, C
                LD C, #FF
.DivideCount    INC C
                SUB #06
                JR NC, .DivideCount                                             ; переход, если пиксельная ширина ещё содержит полную шестипиксельную позицию

                INC B
                INC B
                INC B
                LD A, (Engine.RenderObjects.ObjectIndex)
                SLA A
                LD D, #00
                LD E, A
                LD HL, State.ViewCounts                                         ; база численных подписей48экранных объектов
                ADD HL, DE
                LD E, (HL)
                INC HL
                LD D, (HL)
                EX DE, HL
                CALL DrawCountDI                                                ; вывести беззнаковое число из HL при обработке прерывания
                POP BC

                ; переход к следующей записи и следующей клетке сетки 8 на 6
.NextObject     POP IX
                LD A, (Engine.RenderObjects.ObjectIndex)
                INC A
                LD (Engine.RenderObjects.ObjectIndex), A
                LD BC, #0014
                ADD IX, BC
                POP DE
                POP BC
                LD A, C
                ADD A, #04
                LD C, A
                CP #20
                JR NZ, .ObjectTail                                              ; переход, если в текущей строке экранной сетки остались объекты

                LD C, #00
                LD A, B
                ADD A, #04
                LD B, A
.ObjectTail     DEC E
                JP NZ, .ObjectLoop                                              ; переход, если в экранной сетке остались объекты

                RET

.ObjectIndex    EQU $                                                           ; индекс экранного объекта для численной подписи
                DB #00
