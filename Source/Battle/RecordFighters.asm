
; -----------------------------------------
; отметить участие отрядов героя в столкновении
; для указателей F421 и F423 сравнивает адрес с FD47, меньшие указатели относятся к FCED и
; передаются F2BE
; In:
;   F421 и F423 участники
; Out:
;   постоянные записи отрядов героя обновлены
; Corrupt:
;   HL, BC, AF и постоянные поля типов, обновляемые F2BE, DE, IX, IY сохранены
; -----------------------------------------
RecordFighters  LD HL, (Battle.MeleeMatchup.Attacker)
                LD BC, Battle.FinishField.EnemyArmy
                OR A
                PUSH HL
                SBC HL, BC
                POP HL
                CALL C, MarkUnitFight                                           ; вызов, если первый участник относится к армии героя
                LD HL, (Battle.MeleeMatchup.Defender)
                LD BC, Battle.FinishField.EnemyArmy
                OR A
                PUSH HL
                SBC HL, BC
                POP HL
                CALL C, MarkUnitFight                                           ; вызов, если второй участник относится к армии героя
                RET
