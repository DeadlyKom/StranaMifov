
; -----------------------------------------
; разобрать строку сообщения с управляющими кодами
; DE строка, IX указатель разбора, #0E вставляет строку по 16-битному адресу, #0F вставляет целое,
; #10 вставляет пятибайтное число, #11 меняет формат, #0D завершает строку, 0 завершает сообщение,
; промежуточный буфер #72B3
; In:
;   DE сообщение с управляющими кодами и нулевым терминатором, BC, B начальная строка и C
;   начальная колонка
; Out:
;   сообщение выведено, HL, DE, BC, AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, рабочий буфер #72B3 и форматные операнды изменены,
;   числовые вставки используют ROM, альтернативные HL', DE', BC', AF' зависят от внутреннего
;   соглашения ROM и отдельно не проверены
; Note:
;   Числовые управляющие поля имеют служебный пропускаемый байт, после #0F читаются двабайта
;   целого и указатель дополнительно увеличивается ещё наодинбайт, после #10 читаются пятьбайт
;   числа и также пропускается одинбайт. Код #0D читает следующий байт горизонтальной позиции,
;   значение #2A включает центрирование. Буфер строки 43 байта очищается, явной проверки его
;   переполнения нет.
; -----------------------------------------
PrintMessage    PUSH IX
.CharAhead      EQU 1                                                           ; следующий символ относительно текущего указателя текста
                PUSH IY
                PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH DE
                POP IX
                LD A, #2A
                LD (Engine.PrintMessage.LineWidth), A
                XOR A
                LD (Engine.PrintMessage.LeftMargin), A
                LD (Engine.NumberToDecimal.PrintPos), BC

                ; подготовка буфера очередной строки сообщения
.ClearLine      LD HL, Engine.NumberToDecimal.LineBuffer
                LD DE, Engine.NumberToDecimal.LineBuffer + 1                    ; следующий байт при очистке буфера распакованной строки
                LD BC, #002A
                LD (HL), #00
                LDIR
                LD DE, Engine.NumberToDecimal.LineBuffer

                ; разбор текста и управляющих вставок до переноса строки
.ReadControl    LD A, (IX + #00)
                OR A
                JP Z, .FinalLine                                                ; переход, если достигнут конец сообщения

                CP #0D
                JP Z, .FlushLine                                                ; переход, если обнаружена команда переноса строки

                CP #0E
                JR NZ, .CheckWord                                               ; переход, если символ не задаёт вставку строки

                INC IX
                LD L, (IX + #00)
                INC IX
                LD H, (IX + #00)
                INC IX
                PUSH HL
                POP IY

                ; вставка строки, адрес которой задан в сообщении
.CopyInsert     LD A, (IY + #00)
                OR A
                JR Z, .ReadControl                                              ; переход, если достигнут конец вставляемой строки

                CP #20
                JR NZ, .StoreInsert                                             ; переход, если вставляемый символ не пробел

                CP (IY + .CharAhead)
                JR Z, .NextInsert                                               ; переход, если следующий вставляемый символ также пробел

.StoreInsert    LD (DE), A
                INC DE
.NextInsert     INC IY
                JR .CopyInsert

                ; вставка целого числа из двухбайтного операнда сообщения
.CheckWord      CP #0F
                JR NZ, .CheckFloat                                              ; переход, если код не задаёт вставку целого числа

                INC IX
                LD C, (IX + #00)
                INC IX
                LD B, (IX + #00)
                INC IX
                INC IX
                CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
                CALL NumberToDecimal                                            ; преобразовать число калькулятора в десятичные цифры
                LD A, #20
                LD (DE), A
                INC DE
                JR .ReadControl

                ; вставка пятибайтового числа калькулятора
.CheckFloat     CP #10
                JR NZ, .CheckFormat                                             ; переход, если код не задаёт вставку пятибайтового числа

                INC IX
                PUSH IX
                POP HL
                CALL StackFloat5                                                ; передать пятибайтное число по HL на стек калькулятора
                PUSH HL
                POP IX
                INC IX
                CALL NumberToDecimal                                            ; преобразовать число калькулятора в десятичные цифры
                LD A, #20
                LD (DE), A
                INC DE
                JR .ReadControl

                ; обновление параметров форматирования следующей строки
.CheckFormat    CP #11
                JR NZ, .CheckSpace                                              ; переход, если код не задаёт смену форматирования

                INC IX
                LD A, (IX + #00)
                LD (Engine.PrintMessage.LeftMargin), A
                INC IX
                LD A, (IX + #00)
                LD (Engine.PrintMessage.LineWidth), A
                INC IX
                JP .ReadControl

.CheckSpace     CP #20
                JR NZ, .StoreChar                                               ; переход, если обычный символ не является пробелом

                CP (IX + .CharAhead)
                JR Z, .NextChar                                                 ; переход, если следующий символ также пробел

.StoreChar      LD (DE), A
                INC DE
.NextChar       INC IX
                JP .ReadControl

                ; вычисление начала вывода подготовленной строки, включая центрирование
.FlushLine      PUSH DE
                POP HL
                LD BC, Engine.NumberToDecimal.LineBuffer
                OR A
                SBC HL, BC
                INC IX
                LD A, (IX + #00)
                INC IX
                CP #2A
                JR NZ, .SetLineOrigin                                           ; переход, если для строки задана явная колонка без центрирования

.LineWidth      EQU $+1                                                         ; изменяемая ширина области центрирования текста
                LD A, #00
                SUB L
                SRL A
.LeftMargin     EQU $+1                                                         ; изменяемая левая граница области центрирования
                ADD A, #00
.SetLineOrigin  LD C, A
                LD A, (Engine.NumberToDecimal.PrintRow)
                LD B, A
                LD DE, Engine.NumberToDecimal.LineBuffer
                INC L
.DrawLine       DEC L
                JR Z, .NextLine                                                 ; переход, если выведены все символы подготовленной строки

                LD A, (DE)
                CALL DrawGlyphEI                                                ; вывести символ с обычной процедурой переключения банка
                INC DE
                INC C
                JR .DrawLine

.NextLine       LD A, (Engine.NumberToDecimal.PrintRow)
                INC A
                LD (Engine.NumberToDecimal.PrintRow), A
                JP .ClearLine

                ; вывод остатка буфера при завершении сообщения
.FinalLine      LD BC, (Engine.NumberToDecimal.PrintPos)
                LD DE, Engine.NumberToDecimal.LineBuffer
.FinalChars     LD A, (DE)
                OR A
                JR Z, .RestoreRegs                                              ; переход, если достигнут конец последнего фрагмента сообщения

                CALL DrawGlyphEI                                                ; вывести символ с обычной процедурой переключения банка
                INC DE
                INC C
                JR .FinalChars

.RestoreRegs    POP AF
                POP BC
                POP DE
                POP HL
                POP IY
                POP IX
                RET
