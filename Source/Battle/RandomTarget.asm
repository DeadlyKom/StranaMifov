
; -----------------------------------------
; случайно выбрать запись из списка целей
; 7C0D выбирает индекс 0..EB8B-1, тройка EB8E+3*индекс содержит тип 2/3 и указатель отряда
; In:
;   EB8B число целей, EB8E список
; Out:
;   IX отряд, A тип с временным битом 7, HL адрес тройки
; Corrupt:
;   HL, DE, AF, IX, состояние генератора 7C69..7C70, BC и IY сохранены
; -----------------------------------------
RandomTarget    LD A, (Battle.ListOtherUnits.TargetCount)
                LD E, A
                LD D, #00
                DEC DE
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD A, E
                SLA A
                ADD A, E
                LD E, A
                LD IX, Battle.ListOtherUnits.TargetList
                ADD IX, DE
                LD A, (IX + FBattleTarget.Side)
                LD E, (IX + FBattleTarget.Unit.Low)
                LD D, (IX + FBattleTarget.Unit.High)
                PUSH IX
                POP HL
                PUSH DE
                POP IX
                RET
