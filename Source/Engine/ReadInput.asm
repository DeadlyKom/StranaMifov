
; -----------------------------------------
; прочитать клавиатуру или Kempston
; вызывает ROM #028E, E=#FF означает отсутствие клавиши, затем десять раз опрашивает порт #1F и
; объединяет результаты, fire возвращает код #27, направления преобразуются таблицей #6C2B, carry
; установлен при распознанном вводе
; In:
;   состояние клавиатурной матрицы и порта Kempston #1F
; Out:
;   AF, carry=1 при распознанном вводе и A код команды, carry=0 при отсутствии ввода, HL, DE,
;   BC, IX, IY сохранены
; Corrupt:
;   AF, альтернативные регистры ROM #028E отдельно не проверены
; -----------------------------------------
ReadInput       PUSH IX
                PUSH IY
                PUSH HL
                PUSH DE
                PUSH BC
                CALL Rom.KeyScan                                                ; сканирование матрицы клавиатуры и возврат E=#FF при отсутствии клавиши
                LD A, E
                CP #FF
                JR NZ, .SetPressed                                              ; переход, если ROM вернул нажатую клавишу

                LD B, #0A
                LD C, #00

                ; повторное чтение Kempston для объединения кратковременных нажатий
.PollKempston   IN A, (#1F)
                OR C
                LD C, A
                DJNZ .PollKempston

                BIT JOY_FIRE_BIT, A                                             ; кнопка огня в прочитанном байте Kempston
                JR Z, .DecodeKey                                                ; переход, если кнопка огня Kempston не нажата

                LD A, #27
                JR .SetPressed

                ; перевод клавиатурного кода в команду управления по таблице
.DecodeKey      LD HL, Engine.ReadInput.KempstonPairs - 1                       ; восемь пар Kempston-код и команда движения
                LD B, #08
.KeyLoop        INC HL
                CP (HL)
                INC HL
                JR Z, .KeyFound                                                 ; переход, если клавиатурный код совпал с элементом таблицы управления

                DJNZ .KeyLoop

                XOR A
                JR .RestoreRegs

.KeyFound       LD A, (HL)
.SetPressed     SCF
.RestoreRegs    POP BC
                POP DE
                POP HL
                POP IY
                POP IX
                RET

.KempstonPairs  EQU $                                                           ; восемь пар Kempston-код и команда движения
                DB #08, #1B, #09, #23, #01, #22, #05, #21
                DB #04, #19, #06, #11, #02, #12, #0A, #13
