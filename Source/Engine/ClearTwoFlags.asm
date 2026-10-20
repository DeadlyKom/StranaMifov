
; -----------------------------------------
; обнулить два связанных байта таблиц
; #7AA4 даёт IX=#6A72+A, записывает 0 по IX и IX+25, IX сохранён
; In:
;   AF, A индекс типа
; Out:
;   байты #6A72+A и #6A8B+A обнулены, HL, DE, BC, A, IX, IY сохранены
; Corrupt:
;   F, меняется только пара указанных байтов состояния
; -----------------------------------------
ClearTwoFlags   PUSH IX
                CALL IndexFlagArray                                             ; получить указатель IX=#6A72+A
                LD (IX + #00), #00
                LD (IX + State.UpgradeIndex - State.IdleIndex), #00
                POP IX
                RET
