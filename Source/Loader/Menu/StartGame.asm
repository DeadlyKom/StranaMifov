
; -----------------------------------------
; загрузка стартового блока игры и удаление скрытого меню
; Читает KB.co/C в Loader.Menu.UnitBuffer, восстанавливает исходный привод. Заполняет нулями
; память начиная с #7918
; с оборачиванием адреса в ROM. Следующий LDIR с HL=MainMenu, DE=#61A9, BC=#FFFF стирает меню до
; собственной команды ED B0. Когда записывается ноль в #6E32, повторное чтение команды превращает
; её в NOP и OR B, после чего продолжается #6E34. Берёт длину файла TrDos.FileLength, копирует
; из Loader.Menu.UnitBuffer в
; #6149 через ROM #33C3, передав #6149 адресом возврата.
; In:
;   файл KB.co/C, SelectDrive.Drive — исходный привод
; Out:
;   управление #6149 после ROM-копирования, обычного возврата нет
; Corrupt:
;   HL, DE, BC, AF, SP, состояние TR-DOS
; Note:
;   самоуничтожение меню, очистка памяти, код игры в #6149
; -----------------------------------------

                ; при стирании скрытого меню LDIR переписывает собственную команду, после чего
                ; загрузка игры продолжается в оставшемся хвосте
StartGame       LD DE, Loader.Menu.UnitBuffer
                LD HL, Loader.Menu.SelectDrive.BootFile                         ; девятибайтное имя KB.co для запуска игры
                LD BC, #FF05
                XOR A
                CALL AccessFile                                                 ; операция с файлом по имени и смещению в секторах
                LD A, (SelectDrive.Drive)
                CALL SelectDrive                                                ; установка текущего привода TR-DOS
                LD HL, Loader.Menu.EraseTail                                    ; первый байт хвостовой области, стираемой перед переносом KB.co
                LD DE, Loader.Menu.EraseTail + 1                                ; следующий байт стираемого хвоста для перекрывающегося LDIR
                LD BC, #88DB
                LD (HL), #00
                LDIR
                LD HL, MainMenu
                LD DE, Loader.Menu.MainMenu + 1                                 ; следующий байт стираемого главного меню, используется перекрывающимся LDIR
                LD BC, #FFFF
                LD (HL), #00
                LDIR
                LD HL, (TrDos.FileLength)
                PUSH HL
                POP BC
                LD HL, Loader.Menu.UnitBuffer
                LD DE, Protection.Outer.Decode                                  ; адрес переноса KB.co, записывается на стек для входа после ROM LDIR
                PUSH DE
                JP Rom.CopyBytes                                                ; LDIR и возврат ROM, копирует загруженный KB.co в Protection.Outer.Decode
