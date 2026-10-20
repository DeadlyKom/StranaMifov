
; -----------------------------------------
; установка IM 2 и восстановление регистров AY
; Заполняет #FE00..#FF00 байтом #FD, записывает JP MenuInterrupt в #FDFD, устанавливает I=#FE и
; IM 2.
; Восстанавливает AY-регистры 0..13 из #641B, включает прерывания.
; In:
;   #641B..#6428 — сохранённые значения AY
; Out:
;   IM 2, EI
; Corrupt:
;   HL, DE, BC, AF, I
; Note:
;   #FE00..#FF00, #FDFD..#FDFF, AY
; -----------------------------------------
RestoreAYState  DI
                LD A, #FE
                LD I, A
                LD H, A
                LD D, A
                LD BC, #0100
                LD L, C
                LD E, B
                DEC A
                LD (HL), A
                LDIR
                LD H, A
                LD L, A
                LD DE, MenuInterrupt
                LD (HL), #C3
                INC HL
                LD (HL), E
                INC HL
                LD (HL), D
                IM 2
                LD C, #FD
                LD DE, #BFFF
                LD HL, Loader.Menu.SaveAYState.AYRegisters                      ; буфер четырнадцати сохранённых регистров AY
                XOR A

                ; после настройки IM 2 возвращаются все 14 сохранённых регистров AY
.LoadRegister   LD B, E
                OUT (C), A
                LD B, D
                OUTI
                INC A
                CP #0E
                JR NZ, .LoadRegister                                            ; переход, если восстановлены ещё не все 14 регистров AY

                EI
                RET
