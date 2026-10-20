
; -----------------------------------------
; вызвать TR-DOS с временным режимом IM 1
; DI, IY=#5C3A, I=#3F, IM1, EI, CALL #3D13, после возврата DI, I=#60, IM2, EI, RET
; In:
;   HL, DE, BC, AF параметры выбранного сервиса TR-DOS, операция в C
; Out:
;   результат TR-DOS, I=#60, IM 2, EI, IY=#5C3A перед вызовом сервиса
; Corrupt:
;   регистры определяются сервисом TR-DOS, исходные I, IM и IFF не восстанавливаются,
;   устанавливается игровой режим IM 2/EI
; -----------------------------------------
CallTrdos       DI
                LD IY, System.IYBase                                            ; системная база IY для внешнего вызова
                PUSH AF
                LD A, #3F
                LD I, A
                POP AF
                IM 1
                EI
                CALL TrDos.Service                                              ; вызов сервиса TR-DOS, номер операции находится в C
                DI
                LD A, #60
                LD I, A
                IM 2
                EI
                RET
