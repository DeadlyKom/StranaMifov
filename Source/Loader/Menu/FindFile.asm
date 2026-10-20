
; -----------------------------------------
; поиск 9-байтового имени в каталоге TR-DOS
; Читает восемь секторов каталога в #D800, затем просматривает до 127 записей по 16 байтов.
; Нулевая первая буква завершает поиск, #01 означает удалённый файл. Сравнивает имя 8 байтов и тип
; с TrDos.Descriptor, найденный 16-байтовый дескриптор копирует туда целиком.
; In:
;   TrDos.Descriptor..#5CE5 — имя и тип
; Out:
;   CF=1 найдено, CF=0 не найдено, IX — запись
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   #D800..#DFFF, TrDos.Descriptor..#5CEC при успехе
; -----------------------------------------
FindFile        LD HL, Loader.Menu.Directory                                    ; буфер восьми секторов каталога TR-DOS
                LD DE, #0000
                LD BC, #0805
                PUSH HL
                CALL DiskOperation                                              ; выполнение дисковой операции с выбором привода и обработкой ошибки
                POP IX
                LD C, #7F

                ; нулевая первая буква завершает плотный каталог, #01 обозначает удалённую запись
.DirectoryEntry LD A, (IX + FTrdosEntry.Name)
                OR A
                RET Z                                                           ; выход, если достигнут конец каталога

                DEC A
                JR Z, .NextEntry                                                ; переход, если запись каталога помечена удалённой

                PUSH IX
                POP DE
                LD HL, TrDos.Descriptor
                LD B, #09

                ; сравниваются восемь байтов имени и байт типа, найденный дескриптор копируется
                ; целиком
.CompareName    LD A, (DE)
                CP (HL)
                JR NZ, .NextEntry                                               ; переход, если байт имени или типа файла не совпал

                INC DE
                INC HL
                DJNZ .CompareName

                PUSH IX
                POP HL
                LD DE, TrDos.Descriptor
                LD BC, #0010
                LDIR
.Found          EQU $                                                           ; SCF нормального завершения FindFile, используется перехватом возврата TR-DOS
                SCF
                RET

.NextEntry      LD DE, #0010
                ADD IX, DE
                DEC C
                JR NZ, .DirectoryEntry                                          ; переход, если остаются непросмотренные записи каталога

                AND A
                RET
