
; -----------------------------------------
; выбрать словесное описание величины HL
; таблица 16 битных порогов после #7D94, A увеличивается до порога не меньше HL, затем выбирается
; одно из нуль-терминированных названий после #7DAF, DE адрес текста, HL и IX сохранены
; In:
;   HL количество
; Out:
;   DE словесное описание диапазона количества, HL, IX, IY сохранены, C сохранён
; Corrupt:
;   DE, BC, AF, B используется поиском строки, A к выходу равен 0
; -----------------------------------------
CountWord       PUSH HL
                PUSH IX
                LD IX, Engine.CountWord.Thresholds - 2                          ; 16-битные пороги словесной оценки численности
                XOR A

                ; выбор окончания по диапазону значения, заданному таблицей
.FindThreshold  INC A
                INC IX
                INC IX
                PUSH HL
                LD E, (IX + FWord.Low)
                LD D, (IX + FWord.High)
                SBC HL, DE
                POP HL
                JR Z, .SelectEnding                                             ; переход, если число совпало с порогом выбранного окончания

                JR NC, .FindThreshold                                           ; переход, если число ещё не меньше очередного порога

.SelectEnding   LD B, A
                LD DE, Engine.CountWord.CountWords - 1                          ; нулевая строка перед словами диапазонов численности

                ; пропуск строк окончаний до выбранного варианта
.SkipEnding     INC DE
                LD A, (DE)
                OR A
                JR NZ, .SkipEnding                                              ; переход, если не достигнут конец пропускаемой строки окончания

                DJNZ .SkipEnding

                INC DE
                POP IX
                POP HL
                RET

.Thresholds     EQU $                                                           ; 16-битные пороги словесной оценки численности
                DB #04, #00, #0C, #00, #14, #00, #28, #00
                DB #46, #00, #78, #00, #AA, #00, #F4, #01
                DB #BC, #02, #B0, #04, #88, #13, #10, #27
.CountWords     EQU $+2                                                         ; нулевая строка перед словами диапазонов численности
                DB #FF, #FF, #00, #8F, #A0, #E0, #A0, #2C
                DB #20, #A4, #E0, #E3, #A3, #A0, #EF, #00
                DB #8D, #A5, #E1, #AA, #AE, #AB, #EC, #AA
                DB #AE, #00, #84, #A5, #E1, #EF, #E2, #AE
                DB #AA, #2C, #20, #A4, #E0, #E3, #A3, #AE
                DB #A9, #00, #8D, #A5, #E1, #AA, #AE, #AB
                DB #EC, #AA, #AE, #20, #A4, #A5, #E1, #EF
                DB #E2, #AA, #AE, #A2, #00, #91, #20, #AF
                DB #AE, #AB, #E1, #AE, #E2, #AD, #A8, #00
                DB #8E, #AA, #AE, #AB, #AE, #20, #E1, #AE
                DB #E2, #AD, #A8, #00, #91, #AE, #E2, #AD
                DB #A8, #20, #AF, #AE, #AB, #E2, #AE, #E0
                DB #EB, #00, #8D, #A5, #E1, #AA, #AE, #AB
                DB #EC, #AA, #AE, #20, #E1, #AE, #E2, #A5
                DB #AD, #00, #8E, #AA, #AE, #AB, #AE, #20
                DB #AF, #AE, #AB, #E3, #E2, #EB, #E1, #EF
                DB #E7, #A8, #00, #83, #A4, #A5, #2D, #E2
                DB #AE, #20, #E2, #EB, #E1, #EF, #E7, #A0
                DB #00, #92, #EB, #E1, #EF, #E7, #A8, #00
                DB #8C, #AD, #AE, #A3, #AE, #00, #84, #AE
                DB #20, #E5, #E0, #A5, #AD, #A0, #00
