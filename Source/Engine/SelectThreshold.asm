
; -----------------------------------------
; определить одну из четырёх категорий по порогам
; IX база таблицы, читает три 16 битных порога со смещений 4,8,12, сравнивает HL с каждым,
; возвращает A=1..4, HL и IX сохранены
; In:
;   HL сравниваемое 16 битное значение, IX база трёх порогов со смещениями 4/8/12
; Out:
;   AF, A категория 1..4, HL, DE, BC, IX, IY сохранены
; Corrupt:
;   AF, сравнение использует HL<порог, равенство переходит к следующей категории
; -----------------------------------------
SelectThreshold PUSH IX
                PUSH DE
                PUSH BC
                XOR A
                LD B, #03
.ThresholdLoop  INC IX
                INC IX
                INC IX
                INC IX
                INC A
                LD E, (IX + FWord.Low)
                LD D, (IX + FWord.High)
                PUSH HL
                OR A
                SBC HL, DE
                POP HL
                JR C, .RestoreRegs                                              ; переход, если значение оказалось меньше очередного табличного порога

                DJNZ .ThresholdLoop

                LD A, #04
.RestoreRegs    POP BC
                POP DE
                POP IX
                RET
