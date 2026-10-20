
; -----------------------------------------
; получить масштабированное псевдослучайное число
; состояние из трёх слов #7C6B/#7C6D/#7C6F обновляется сложениями и циклическим сдвигом, затем 16
; шаговое умножение нового 16 битного состояния на исходное DE, возвращается старшее слово
; произведения, увеличенное на 1 если бит 15 младшего слова установлен, тоесть округление к
; ближайшему целому, результат DE
; In:
;   DE верхняя величина масштабирования
; Out:
;   DE округлённое масштабированное случайное значение, HL, BC, AF, IX, IY сохранены
; Corrupt:
;   DE, три слова состояния #7C6B/#7C6D/#7C6F и временное поле #7C69, регистры альтернативного
;   набора не используются
; -----------------------------------------
RandomScaled    PUSH HL
                PUSH BC
                PUSH AF
                PUSH IX
                LD (Engine.RandomScaled.Scale), DE
                LD BC, (State.RandomState)
                LD HL, (State.RandomState + FWord)
                LD (State.RandomState), HL
                ADD HL, BC
                LD C, L
                LD B, H
                LD HL, (State.RandomState + 2 * FWord)
                LD (State.RandomState + FWord), HL
                ADD HL, BC
                SLA L
                RL H
                JR NC, .StoreSeed                                               ; переход, если старший бит сдвигаемого состояния генератора равен нулю

                SET RNG_FEED_BIT, L                                             ; младший бит состояния генератора, куда возвращается старший вытесненный разряд
.StoreSeed      LD (State.RandomState + 2 * FWord), HL
                LD C, L
                LD B, H
                LD IX, Engine.RandomScaled.Scale
                LD HL, #0000
                LD DE, #0000
                LD A, #10

                ; умножение обновлённого состояния генератора на заданный диапазон
.MultiplyBit    SLA (IX + FWord.Low)
                RL (IX + FWord.High)
                JR NC, .ShiftProduct                                            ; переход, если очередной бит диапазона масштабирования равен нулю, состояние генератора не прибавляется

                ADD HL, BC
                JR NC, .ShiftProduct                                            ; переход, если прибавление частичного произведения не увеличило старшее слово

                INC DE
.ShiftProduct   DEC A
                JR Z, .RoundResult                                              ; переход, если обработаны все биты множителя

                SLA L
                RL H
                RL E
                RL D
                JR .MultiplyBit

                ; округление результата по старшему биту остатка
.RoundResult    BIT RNG_ROUND_BIT, H                                            ; старший бит H остатка произведения, определяет округление масштабированного результата
                JR Z, .RestoreRegs                                              ; переход, если остаток произведения не требует округления вверх

                INC DE
.RestoreRegs    POP IX
                POP AF
                POP BC
                POP HL
                RET

.Scale          EQU $                                                           ; диапазон масштабирования, расходуемый умножением
                DB #00, #00, #00, #00, #00, #00, #00, #00
