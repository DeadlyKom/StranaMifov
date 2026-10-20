
; -----------------------------------------
; получить указатель IX=#6A72+A
; BC сохранён, индекс A расширяется нулём в B
; In:
;   AF, A индекс типа
; Out:
;   IX=#6A72+A, HL, DE, BC, A, IY сохранены
; Corrupt:
;   F, IX
; -----------------------------------------
IndexFlagArray  PUSH BC
                LD IX, State.IdleIndex
                LD B, #00
                LD C, A
                ADD IX, BC
                POP BC
                RET
