
; -----------------------------------------
; вывести краткий список состава армии
; IY трёхбайтные записи, A число записей, BC место вывода, для каждой непустой записи количество
; передаётся #7D6B для словесной оценки, #7EA7 формирует имя отряда, #7117 печатает сообщение
; #7E9F, следующая строка увеличивает B
; In:
;   BC позиция вывода, AF, A число записей, IY список трёхбайтных записей
; Out:
;   краткий состав армии выведен, HL и IX сохранены, IY после обработанных записей либо на
;   первом нулевом ID, прежний банк восстановлен
; Corrupt:
;   DE, BC, AF, IY, буфер #7EE9 и операнды позиционирования/банка
; -----------------------------------------
PrintArmyBrief  PUSH HL
                PUSH IX
                LD (Engine.PrintArmyBrief.PrintPos), BC
                LD B, A
                LD A, (State.Bank)
                LD (Engine.PrintArmyBrief.SavedPage), A
.UnitLoop       LD A, (IY + FTroop.ID)                                          ; +#00, тип отряда и временные отметки
                OR A
                JR Z, .RestoreRegs                                              ; переход, если достигнут конец плотного списка армии

                PUSH BC
                LD L, (IY + FTroop.Count.Low)                                   ; +#01, младший байт численности
                LD H, (IY + FTroop.Count.High)                                  ; +#02, старший байт численности
                CALL CountWord                                                  ; выбрать словесное описание величины HL
                LD (Engine.PrintArmyBrief.CountName), DE
                LD A, (IY + FTroop.ID)                                          ; +#00, тип отряда и временные отметки
                CALL FormatUnitName                                             ; сформировать имя типа отряда со специальным окончанием
.PrintPos       EQU $+1                                                         ; изменяемая позиция краткого описания армии
.PrintRow       EQU $+2                                                         ; изменяемая строка краткого описания армии
                LD BC, #0000
                LD DE, Engine.PrintArmyBrief.BriefMessage                       ; сообщение с подстановкой словесной численности и имени типа
                CALL PrintMessage                                               ; разобрать строку сообщения с управляющими кодами
                LD A, (Engine.PrintArmyBrief.PrintRow)
                INC A
                LD (Engine.PrintArmyBrief.PrintRow), A
.SavedPage      EQU $+1                                                         ; логический банк до вывода краткого состава армии
                LD A, #00
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                POP BC
                INC IY
                INC IY
                INC IY
                DJNZ .UnitLoop

.RestoreRegs    POP IX
                POP HL
                RET

.CountName      EQU $+1                                                         ; адрес словесной оценки численности отряда
.BriefMessage   EQU $                                                           ; сообщение с подстановкой словесной численности и имени типа
                DB #0E, #00, #00, #20, #0E, #E9, #7E, #00
