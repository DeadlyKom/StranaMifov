
; -----------------------------------------
; обработчик IM 2 скрытого меню
; Сохраняет AF, BC, DE, HL, IX. Читает адрес возврата прерванной команды со стека. Если он равен
; #6BEC, вызывает обновление курсора TickCursor. В каждом прерывании вызывает музыкальный тик #E006,
; восстанавливает регистры, выполняет EI и RET.
; In:
;   вход аппаратного прерывания IM 2
; Out:
;   основные сохранённые регистры восстановлены
; Corrupt:
;   оперативное состояние вызываемых процедур, IY не сохраняется явно, альтернативные регистры
;   не сохраняются явно
; Note:
;   самомодификация операнда MenuInterrupt.IntStack, AY, экран при ожидании HALT
; -----------------------------------------
MenuInterrupt   LD (MenuInterrupt.IntStack), SP
                PUSH AF
                PUSH BC
                PUSH DE
                PUSH HL
                PUSH IX
                LD HL, #0000
.IntStack       EQU $ - 2                                                       ; операнд адреса стека на входе в прерывание
                LD A, (HL)
                INC HL
                LD H, (HL)
                LD L, A
                LD DE, Loader.Menu.WaitCursorFrame.Resume                       ; RET после HALT в WaitCursorFrame, сравнивается с адресом возврата прерывания перед TickCursor
                OR A
                SBC HL, DE
                CALL Z, TickCursor                                              ; вызов, если прерывание застало ожидание с разрешённым обновлением курсора
                CALL Music.Menu.TickMenuMusic                                   ; внешний вход одного тика AY-проигрывателя
                POP IX
                POP HL
                POP DE
                POP BC
                POP AF
                EI
                RET
