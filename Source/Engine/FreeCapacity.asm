
; -----------------------------------------
; вычислить остаток допустимого количества выбранного типа отряда
; #86EA возвращает floor(лидерство/коэффициент типа), среди 5 записей #6A1E ищется совпадающий ID,
; из предела вычитается его существующее 16 битное количество, при заёме результат насыщается 0,
; BC возвращает сколько ещё можно добавить, прочие основные и индексные регистры восстановлены
; In:
;   AF, A ID типа отряда
; Out:
;   BC=max(0, предел(#86EA)-текущее количество этого ID), HL, DE, AF, IX, IY сохранены
; Corrupt:
;   BC и альтернативные регистры калькулятора ROM, основные кроме BC восстановлены
; -----------------------------------------
FreeCapacity    PUSH IX
                PUSH IY
                PUSH HL
                PUSH DE
                PUSH AF
                LD (Engine.FreeCapacity.TargetUnitID), A
                CALL ControlLimit                                               ; рассчитать численный предел типа отряда из поля героя и таблицы
                PUSH BC
                LD HL, State.Army
                LD B, #05
.FindUnit       LD A, (HL)
.TargetUnitID   EQU $+1                                                         ; ID типа, для которого ищется ёмкость армии
                CP #00
                JR Z, .ReadCount                                                ; переход, если найден отряд нужного типа

                INC HL
                INC HL
                INC HL
                DJNZ .FindUnit

                LD BC, #0000
                JR .SubtractCount

.ReadCount      INC HL
                LD C, (HL)
                INC HL
                LD B, (HL)

                ; свободная численность ограничивается снизу нулём
.SubtractCount  POP HL
                OR A
                SBC HL, BC
                JR NC, .RestoreRegs                                             ; переход, если текущая численность не превышает предел управления

                LD HL, #0000
.RestoreRegs    PUSH HL
                POP BC
                POP AF
                POP DE
                POP HL
                POP IY
                POP IX
                RET
