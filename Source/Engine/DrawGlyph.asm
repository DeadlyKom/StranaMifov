
; -----------------------------------------
; нарисовать восьмистрочный символ шрифта
; использует логический банк 11 и восемь байт на символ из #DFD0, вычисляет сдвиг и маску, меняет
; два соседних экранных байта на каждой из 8 строк, переход строки INC IXH соответствует ZX
; Spectrum
; In:
;   BC позиция, B строка знакомест и C индекс символа по X=6*C+2, AF код символа A
; Out:
;   символ выведен в пиксельную область, HL, DE, BC, AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, текущий банк восстановлен, способ разрешения прерываний
;   зависит от патча #703B/#708D
; -----------------------------------------
DrawGlyph       PUSH HL
.NextPixel      EQU 1                                                           ; правый экранный байт пары
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH IY
                PUSH IX
                LD HL, (Memory.BankAF)
                PUSH HL
                PUSH AF
                LD A, #0B
.EnterPageCall  EQU $+1                                                         ; операнд CALL выбора банка шрифта
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                POP AF
                PUSH AF
                CALL GlyphAddress                                               ; вычислить экранный адрес и сдвиг символа
                LD BC, #03FF
                OR A
                JR Z, .GlyphAddress                                             ; переход, если символ не требует горизонтального сдвига

                ; сдвиг маски очистки под пиксельное смещение символа
.ShiftMask      SRL B
                RR C
                SET MASK_FILL_BIT, B                                            ; старший бит маски очистки, заполняемый единицей при сдвиге под символ
                DEC A
                JR NZ, .ShiftMask                                               ; переход, если маска ещё не сдвинута на нужное число пикселей

.GlyphAddress   POP AF
                LD IYL, A
                LD IYH, #00
                ADD IY, IY
                ADD IY, IY
                ADD IY, IY
                LD DE, Font.IndexBase                                           ; база обращения к восьмибайтным глифам по коду символа
                ADD IY, DE
                LD H, #08

                ; наложение одной строки шрифта на два соседних экранных байта
.PixelRow       LD D, (IY + #00)
                LD E, #00
                LD A, L
                OR A
                JR Z, .MergePixels                                              ; переход, если строка символа не требует горизонтального сдвига

.ShiftPixels    SRL D
                RR E
                DEC A
                JR NZ, .ShiftPixels                                             ; переход, если пиксели строки ещё не сдвинуты в нужную позицию

.MergePixels    LD A, (IX + #00)
                AND B
                OR D
                LD (IX + #00), A
                LD A, (IX + .NextPixel)
                AND C
                OR E
                LD (IX + .NextPixel), A
                INC IXH
                INC IY
                DEC H
                JR NZ, .PixelRow                                                ; переход, если остались пиксельные строки символа

                POP AF
.LeavePageCall  EQU $+1                                                         ; операнд CALL восстановления прежнего банка
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                POP IX
                POP IY
                POP AF
                POP BC
                POP DE
                POP HL
                RET
