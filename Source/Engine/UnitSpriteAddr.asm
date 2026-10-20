
; -----------------------------------------
; выбрать банк и начало четырёхкадрового графического ресурса
; A<10 даёт C=6, HL=#D700+1024*A, A>=10 даёт C=7, HL=#BC00+1024*(A-9), функция сохраняет DE, BC,
; AF кроме выходного C
; In:
;   AF, A ID графического ресурса 1..25
; Out:
;   HL начало четырёхкадровой графики, BC, C логический банк 6 либо 7 и B сохранён, DE, AF, IX,
;   IY сохранены, сам банк не переключается
; Corrupt:
;   HL и C, нулевой ID для первой ветви не поддерживается циклом DJNZ
; -----------------------------------------
UnitSpriteAddr  PUSH DE
                PUSH BC
                PUSH AF
                CP #0A
                JR NC, .HighBank                                                ; переход, если ID графического ресурса относится к старшей группе банков

                LD HL, Graphics.Battle.unit_01F1 - 4 * FMasked32                ; смещённая база четырёхкадровых ресурсов ID1..9 банка6/SPR2
                LD B, A
.LowBankLoop    LD A, H
                ADD A, #04
                LD H, A
                DJNZ .LowBankLoop

                POP AF
                POP BC
                POP DE
                LD C, #06
                RET

.HighBank       LD HL, Graphics.Units.unit_10F1 - 4 * FMasked32                 ; смещённая база ресурсов ID10..25 банка7/SPR3
                SUB #09
                LD B, A
.HighBankLoop   LD A, H
                ADD A, #04
                LD H, A
                DJNZ .HighBankLoop

                POP AF
                POP BC
                POP DE
                LD C, #07
                RET
