
; -----------------------------------------
; получить псевдослучайное число, масштабированное к входному пределу
; состояние x, y, z хранится словами 7190,7192,7194, обновление x=y, y=z, z=ROL16(x+y+z,1), новое
; z становится множителем BC, входной DE сохраняется в 718E и двоичными сдвигами умножается на z в
; 32-битный результат DE,HL, проверка бита 15 младшей половины увеличивает старшую половину для
; округления, поэтому DE=round(z*предел/65536), слово 718E после шестнадцати сдвигов нулевое, HL,
; BC, AF, IX сохраняются
; In:
;   DE неотрицательный предел, состояние 7190..7195 инициализировано
; Out:
;   DE масштабированный результат, состояние генератора обновлено, HL, BC, AF, IX сохранены
; Corrupt:
;   DE, временное поле 718E..718F и три слова 7190..7195, HL, BC, AF, IX, IY сохранены
; -----------------------------------------
RandomRange     PUSH HL
                PUSH BC
                PUSH AF
                PUSH IX
                LD (Startup.RandomRange.Multiplier), DE
                LD BC, (Startup.RandomRange.SeedX)
                LD HL, (Startup.RandomRange.SeedY)
                LD (Startup.RandomRange.SeedX), HL
                ADD HL, BC
                LD C, L
                LD B, H
                LD HL, (Startup.RandomRange.SeedZ)
                LD (Startup.RandomRange.SeedY), HL
                ADD HL, BC
                SLA L
                RL H
                JR NC, .SaveSeed                                                ; переход, если старший бит суммы не требует циклического переноса в младший

                SET RNG_FEED_BIT, L                                             ; позиция младшего бита слова, принимающего перенос старшего бита при циклическом обновлении генератора
.SaveSeed       LD (Startup.RandomRange.SeedZ), HL
                LD C, L
                LD B, H
                LD IX, Startup.RandomRange.Multiplier
                LD HL, #0000
                LD DE, #0000
                LD A, #10
.MultiplyBit    SLA (IX + FWord.Low)
                RL (IX + FWord.High)
                JR NC, .NextProductBit                                          ; переход, если очередной бит множителя нулевой

                ADD HL, BC
                JR NC, .NextProductBit                                          ; переход, если сложение младшей половины произведения не переполнилось

                INC DE
.NextProductBit DEC A
                JR Z, .RoundProduct                                             ; переход, если обработаны все шестнадцать битов множителя

                SLA L
                RL H
                RL E
                RL D
                JR .MultiplyBit

.RoundProduct   BIT RNG_ROUND_BIT, H                                            ; позиция старшего бита дробной половины произведения, единица требует округления вверх
                JR Z, .RestoreRegs                                              ; переход, если дробная половина произведения меньше половины единицы

                INC DE
.RestoreRegs    POP IX
                POP AF
                POP BC
                POP HL
                RET

.Multiplier     DW #0000                                                        ; временное слово предела при побитовом умножении
.SeedX          DW #0000                                                        ; первое слово состояния генератора
.SeedY          DW #0000                                                        ; второе слово состояния генератора
.SeedZ          DW #0000                                                        ; третье слово состояния генератора
