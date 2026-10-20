
; -----------------------------------------
; уплотнить пять записей армии и очистить освободившийся хвост
; непустые записи ID!=0 копируются к началу через LDIR по 18 байт, C считает оставшиеся, затем 5-C
; записей хвоста обнуляются
; In:
;   HL начало 90-байтной армии
; Out:
;   плотный массив и нулевой хвост
; Corrupt:
;   HL, DE, BC, AF и девяносто байтов армии, IX и IY не изменяются
; -----------------------------------------
CompactArmy     PUSH HL
                POP DE
                LD B, #05
                LD C, #00

                ; уплотнение непустых записей армии без изменения их взаимного порядка
.FindLiveUnit   LD A, (HL)
                OR A
                JR NZ, .CopyLiveUnit                                            ; переход, если запись содержит живой отряд

                PUSH BC
                LD BC, #0012
                ADD HL, BC
                POP BC
                DJNZ .FindLiveUnit

                JR .ClearTail

.CopyLiveUnit   PUSH BC
                LD BC, #0012
                LDIR
                POP BC
                INC C
                DJNZ .FindLiveUnit

                ; очистка освободившихся записей после последнего живого отряда
.ClearTail      LD A, #05
                SUB C
                RET Z                                                           ; выход, если после уплотнения свободных записей нет

                LD B, A
                EX DE, HL
.ClearUnit      LD C, #12
.ClearByte      LD (HL), #00
                INC HL
                DEC C
                JR NZ, .ClearByte                                               ; переход, если ещё не очищены все байты записи

                DJNZ .ClearUnit

                RET
