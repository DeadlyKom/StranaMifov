
; -----------------------------------------
; сжать список трёхбайтных записей армии
; HL начало списка, B число записей, непустые записи с ID!=0 копируются в начало через LDI,
; свободный хвост заполняется нулями, C число непустых записей
; In:
;   HL список трёхбайтных записей, BC, B число записей
; Out:
;   BC, C число непустых записей и B=0, записи уплотнены, свободный хвост обнулён, IX и IY
;   сохранены
; Corrupt:
;   HL, DE, BC, AF, операнд #809D хранит исходное число записей
; -----------------------------------------
CompactArmy     PUSH HL
                POP DE
                LD A, B
                LD (Engine.CompactArmy.Capacity), A
                LD C, #00

                ; перенос занятых трёхбайтных записей к началу списка
.ScanTroop      LD A, (HL)
                OR A
                JR NZ, .CopyTroop                                               ; переход, если найдена занятая запись отряда

                INC HL
                INC HL
                INC HL
                DJNZ .ScanTroop

                JR .CountTail

.CopyTroop      PUSH BC
                LDI
                LDI
                LDI
                POP BC
                INC C
                DJNZ .ScanTroop

                ; очистка освободившегося хвоста после уплотнения
.Capacity       EQU $+1                                                         ; исходное число доступных записей для уплотнения
.CountTail      LD A, #00
                SUB C
                RET Z                                                           ; выход, если после уплотнения не осталось свободного хвоста

                LD B, A
                EX DE, HL
.ClearTail      LD (HL), #00
                INC HL
                LD (HL), #00
                INC HL
                LD (HL), #00
                INC HL
                DJNZ .ClearTail

                RET
