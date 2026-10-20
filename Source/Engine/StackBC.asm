
; -----------------------------------------
; передать целое BC на стек калькулятора ROM
; вызов ROM #2D2B с сохранением основных регистров, IX и IY
; In:
;   BC беззнаковое целое 0..65535
; Out:
;   число добавлено на стек калькулятора ROM, HL, DE, BC, AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, альтернативные HL', DE', BC', AF' зависят от внутреннего
;   соглашения ROM и отдельно не проверены
; -----------------------------------------
StackBC         PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH IX
                PUSH IY
                CALL Rom.StackBC                                                ; помещение целого BC на стек калькулятора
                POP IY
                POP IX
                POP AF
                POP BC
                POP DE
                POP HL
                RET
