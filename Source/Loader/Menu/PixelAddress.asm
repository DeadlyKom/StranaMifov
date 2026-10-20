
; -----------------------------------------
; адрес пиксельного байта и положение бита на экране ZX Spectrum
; Разлагает y на трети, строку знакоместа и строку пикселей. Добавляет x/8 к младшему байту.
; In:
;   B — x, C — y
; Out:
;   HL=#4000+((y AND #C0)<<5)+((y AND 7)<<8)+((y AND #38)<<2)+(x>>3), A=(NOT x) AND 7
; Corrupt:
;   HL, AF
; -----------------------------------------
PixelAddress    LD HL, Screen.Pixels                                            ; начало видимой пиксельной области Spectrum
                LD A, C
                AND #C0
                SRL A
                SRL A
                SRL A
                ADD A, H
                LD H, A
                LD A, C
                AND #07
                ADD A, H
                LD H, A
                LD A, C
                AND #38
                SLA A
                SLA A
                ADD A, L
                LD L, A
                LD A, B
                SRL A
                SRL A
                SRL A
                ADD A, L
                LD L, A
                LD A, B
                CPL
                AND #07
                RET

.Window         DW #0000                                                        ; адрес активного описателя окна
.TextAttr       DB #00                                                          ; атрибут печатаемого текста
.TextBaseY      DB #00                                                          ; начальная строка текста в пикселях
.TextBaseX      DB #00                                                          ; начальный столбец текста в пикселях
.TextY          DB #00                                                          ; текущая строка текста в пикселях
.TextX          DB #00                                                          ; текущий столбец текста в пикселях
