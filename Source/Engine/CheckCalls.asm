
; -----------------------------------------
; проверить неизменность трёх инструкций CALL #6B8D
; таблица адресов #6BE3 содержит #634D, #9455, #9587, в каждом месте проверяются opcode #CD и
; адрес #6B8D, нарушение ведёт на #0000, это явная встроенная проверка целостности
; In:
;   состояние рабочих таблиц и текущий логический банк
; Out:
;   HL, DE, BC, AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, альтернативные регистры не используются в собственном
;   коде, возможные прерывания работают независимо
; Note:
;   Сохранение регистров действует только при успешной проверке. Любое несовпадение немедленно
;   передаёт управление #0000, выполняя сброс вместо возврата вызывающей процедуре.
; -----------------------------------------
CheckCalls      PUSH IX
                PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                LD IX, Engine.CheckCalls.CallAddresses                          ; три адреса команд CALL ClearBank8, проверяемые защитой
                LD B, #03
.CallLoop       LD L, (IX + FWord.Low)
                LD H, (IX + FWord.High)
                LD A, (HL)
                INC HL
                CP #CD
                JP NZ, System.Reset                                             ; переход, если по сохранённому адресу нет команды CALL

                LD E, (HL)
                INC HL
                LD D, (HL)
                EX DE, HL
                LD DE, Engine.ClearBank8                                        ; ожидаемая цель трёх проверяемых CALL
                OR A
                SBC HL, DE
                JP NZ, System.Reset                                             ; переход, если операнд найденной CALL не указывает на проверяемый вход

                INC IX
                INC IX
                DJNZ .CallLoop

                POP AF
                POP BC
                POP DE
                POP HL
                POP IX
                RET

.CallAddresses  EQU $                                                           ; три адреса команд CALL ClearBank8, проверяемые защитой
                DB #4D, #63, #55, #94, #87, #95
