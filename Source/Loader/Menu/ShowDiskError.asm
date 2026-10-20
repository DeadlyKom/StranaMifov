
; -----------------------------------------
; показ дисковой ошибки с восстановлением главного меню
; Восстанавливает начальный SP, устанавливает IM 2, рисует окно ошибки. Подставляет 8-байтовое имя
; файла в строку #6733, печатает сообщение HL, ждёт нажатия и отпускания кнопки, переходит в
; главное меню.
; In:
;   HL — строка ошибки, SaveAYState.MenuStack — исходный SP
; Out:
;   не возвращается, JP MainMenu.ResetBorder
; Corrupt:
;   HL, DE, BC, AF, IX, SP
; Note:
;   экран, IM 2
; -----------------------------------------

                ; ошибка восстанавливает исходный стек меню, поэтому возврата в прерванную
                ; дисковую операцию нет
ShowDiskError   DI
                LD SP, (SaveAYState.MenuStack)
                PUSH HL
                CALL RestoreAYState                                             ; установка IM 2 и восстановление регистров AY
                LD IX, Loader.Menu.SelectDrive.ErrorWindow                      ; семибайтный описатель окна дисковой ошибки
                CALL DrawWindow                                                 ; рисование окна по дескриптору
                LD HL, TrDos.Descriptor
                LD DE, Loader.Menu.SelectDrive.MissingName                      ; восемь символов имени внутри сообщения о ненайденном файле
                LD BC, #0008
                LDIR
                POP HL
                CALL PrintString                                                ; печать строки с управляющими кодами
                CALL WaitPress                                                  ; ожидание нового нажатия кнопки действия
                CALL WaitRelease                                                ; ожидание отпускания кнопки действия
                JP MainMenu.ResetBorder

.FileOffset     LD HL, (TrDos.FileSector)
                POP AF
                LD B, A
                AND A
                CALL NZ, AddSectors                                             ; вызов, если к найденному файлу требуется прибавить смещение в секторах
                EX DE, HL
                POP HL
                POP BC
                LD A, B
                CP #FF
                JR NZ, .SectorCount                                             ; переход, если число секторов задано явно, а не берётся из каталога

                LD A, (TrDos.SectorCount)
.SectorCount    LD B, A
                JP DiskOperation
