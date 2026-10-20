; два слоя расшифровки секторного загрузчика
; исходный файл каталога 02, смещение #0100
                module Loader
                module Sectors
                org #8000

; -----------------------------------------
; очистка экрана и первый слой защиты
; Обнуляет экран и область системных данных #4000..#5AFF. Инициализирует R=#AC и расшифровывает
; 109 байтов начиная с DecodeSecond. В каждой итерации переключает #1FFD, выполняет длинный LDIR и
; восстанавливает HL/DE из системных переменных, поэтому ключ зависит от точного числа выборок
; команд.
; In:
;   нет явных аргументов
; Out:
;   переход к DecodeSecond
; Corrupt:
;   HL, DE, BC, AF, R
; Note:
;   экран, #5C08, System.ErrorSP, #E2DB..#E940, порт #1FFD
; -----------------------------------------
DecodeFirst     DI
                LD A, #AC
                LD R, A
                XOR A
                OUT (#FE), A
                LD HL, Screen.Pixels                                            ; начало видимой пиксельной области Spectrum
                LD DE, Screen.Pixels + 1                                        ; следующий байт видимой пиксельной области для размножения заполнителя
                LD BC, #1AFF
                LD (HL), A
                LDIR
                LD HL, DecodeSecond
                LD DE, #006D

                ; длинный перенос и переключение порта входят в расчёт ключа через счётчик R
.DecodeByte     LD A, R
                XOR (HL)
                XOR H
                XOR L
                XOR E
                LD (HL), A
                LD (System.ErrorSP), HL
                EX DE, HL
                LD (System.LastKey), HL
                LD BC, #1FFD
                LD A, #10
                OUT (C), A
                LD HL, Loader.Sectors.IMVector                                  ; начало заполнения RST-вектора для аппаратной проверки загрузчика
                LD DE, Loader.Sectors.IMVector + 1                              ; следующий байт заполняемой области аппаратной проверки
                LD BC, #0665
                LD (HL), #C7
                LDIR
                LD HL, (System.LastKey)
                EX DE, HL
                LD HL, (System.ErrorSP)
                LD BC, #1FFD
                XOR A
                OUT (C), A
                INC HL
                DEC DE
                LD A, E
                OR D
                JR NZ, .DecodeByte                                              ; переход, если остаются байты зашифрованного сектора

; -----------------------------------------
; второй слой защиты секторного загрузчика
; Расшифровывает 50 байтов LoadHiddenMenu..#80BB, используя R, адрес HL и старший байт остатка
; D. Длинный
; LDIR намеренно участвует в формировании ключа через R.
; In:
;   R после первого слоя
; Out:
;   переход к LoadHiddenMenu
; Corrupt:
;   HL, DE, BC, AF, R
; Note:
;   LoadHiddenMenu..#80BB, #5C08, System.ErrorSP, #1FFD
; -----------------------------------------

                ; второй слой открывает код чтения остальных секторов и перехода в скрытое меню
DecodeSecond    LD HL, LoadHiddenMenu
                LD DE, #0032
.DecodeByte     LD A, R
                XOR (HL)
                XOR H
                XOR L
                XOR D
                LD (HL), A
                LD (System.ErrorSP), HL
                EX DE, HL
                LD (System.LastKey), HL
                LD BC, #1FFD
                LD A, #10
                OUT (C), A
                LD HL, Loader.Sectors.IMVector                                  ; начало заполнения RST-вектора для аппаратной проверки загрузчика
                LD DE, Loader.Sectors.IMVector + 1                              ; следующий байт заполняемой области аппаратной проверки
                LD BC, #0675
                LD (HL), #C7
                LDIR
                LD HL, (System.LastKey)
                EX DE, HL
                LD HL, (System.ErrorSP)
                LD BC, #1FFD
                XOR A
                OUT (C), A
                INC HL
                DEC DE
                LD A, E
                OR D
                JR NZ, .DecodeByte                                              ; переход, если остаются байты следующего зашифрованного сектора

; -----------------------------------------
; чтение двух скрытых блоков дискового меню
; Выбирает обычную страницу памяти через #7FFD. Читает 22 сектора в #6171 и 12 секторов в #E000.
; Подпрограмма ReadDecodeBlock расшифровывает каждый байт XOR старшего и младшего байтов его
; адреса. Заранее
; помещает в стек #6171 и завершает хвостовым переходом к чтению второго блока.
; In:
;   TrDos.NextSector — текущая позиция чтения TR-DOS
; Out:
;   управление на #6171
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   память #6171..#7770, #E000..#EBFF, порт #7FFD
; -----------------------------------------

                ; адрес меню заранее кладётся на стек, возврат последней загрузки передаёт ему
                ; управление
LoadHiddenMenu  LD HL, Loader.Menu.DecodeMenu                                   ; адрес чтения и отложенного входа в скрытое меню
                PUSH HL
                LD BC, #7FFD
                LD A, #10
                OUT (C), A
                LD B, #16
                CALL ReadDecodeBlock                                            ; чтение секторов и адресное XOR-преобразование
                LD HL, Music.Menu.InitMenuMusic                                 ; адрес загрузки музыкального модуля меню
                LD B, #0C
                JP ReadDecodeBlock

; -----------------------------------------
; чтение секторов и адресное XOR-преобразование
; Сохраняет адрес назначения и число секторов. Вызывает TR-DOS с C=5 и DE из TrDos.NextSector. Затем
; преобразует B*256 байтов по формуле value XOR H XOR L.
; In:
;   HL — назначение, B — число секторов
; Out:
;   HL после прочитанного блока, BC=0
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   область назначения и состояние TR-DOS
; -----------------------------------------
ReadDecodeBlock PUSH BC
                PUSH HL
                LD DE, (TrDos.NextSector)
                LD C, #05
                CALL TrDos.Service                                              ; вызов сервиса TR-DOS, номер операции находится в C
                POP HL
                POP BC
                LD C, #00

                ; после чтения сектора данные восстанавливаются XOR с обеими половинами адреса
.DecodeByte     LD A, (HL)
                XOR H
                XOR L
                LD (HL), A
                INC HL
                DEC BC
                LD A, B
                OR C
                JR NZ, .DecodeByte                                              ; переход, если остаются байты шифруемого блока

                RET

                DB #00, #00, #00, #00, #20, #20, #20, #20
                DB #20, #20, #20, #20, #27, #53, #54, #41
                DB #52, #53, #20, #4F, #46, #20, #4B, #45
                DB #4C, #41, #44, #41, #4E, #27, #20, #66
                DB #72, #6F, #6D, #20, #53, #41, #4D, #41
                DB #52, #41, #20, #43, #49, #54, #59, #2C
                DB #20, #30, #36, #2E, #30, #38, #2E, #31
                DB #39, #39, #36, #20, #41, #44, #2E, #20
                DB #20, #20, #20, #20                                           ; 80FC

                assert $ = #8100
                endmodule
                endmodule
