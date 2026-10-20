
; -----------------------------------------
; загрузка и постраничный просмотр описания игры
; Загружает HELPG.tx/C в Loader.Menu.UnitBuffer. Начальное значение R берёт из XOR байтов
; TrDos.FileSector/#5CEC. Для каждого
; байта XOR объединяет R, адрес HL, остаток DE и данные, затем обновляет R через XOR с L. После
; расшифровки выводит страницы в окне. Кнопка 0 завершает просмотр, направления переходят к
; следующему или предыдущему фрагменту текста.
; In:
;   нет явных аргументов
; Out:
;   A=0 при обычном возврате
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   Loader.Menu.UnitBuffer — загруженный и расшифрованный текст, экран, IM 2
; -----------------------------------------
ShowHelp        LD DE, Loader.Menu.UnitBuffer
                LD HL, Loader.Menu.SelectDrive.HelpFile                         ; девятибайтное имя HELPG.tx для чтения справки
                LD BC, #FF05
                XOR A
                CALL AccessFile                                                 ; операция с файлом по имени и смещению в секторах
                DI
                LD HL, (TrDos.FileSector)
                LD A, H
                XOR L
                LD R, A
                LD HL, (TrDos.FileLength)
                EX DE, HL
                LD HL, Loader.Menu.UnitBuffer

                ; ключ описания зависит от R, текущего адреса и оставшейся длины файла
.DecodeByte     LD A, R
                XOR L
                LD R, A
                XOR H
                XOR E
                XOR D
                XOR (HL)
                LD (HL), A
                INC HL
                DEC DE
                LD A, D
                OR E
                JR NZ, .DecodeByte                                              ; переход, если остаются зашифрованные байты справки

                CALL RestoreAYState                                             ; установка IM 2 и восстановление регистров AY
                LD HL, Loader.Menu.UnitBuffer

                ; каждая страница использует одно и то же окно, позиция чтения сохраняется для
                ; переходов назад
.DrawPage       LD IX, Loader.Menu.SelectDrive.HelpWindow                       ; семибайтный описатель окна страниц справки
                PUSH HL
                CALL DrawWindow                                                 ; рисование окна по дескриптору
                POP HL
                CALL PrintString                                                ; печать строки с управляющими кодами
                PUSH HL
.WaitPageKey    CALL ReadControls                                               ; объединённый опрос клавиатуры и Kempston
                AND A
                JR Z, .WaitPageKey                                              ; переход, если кнопка перелистывания или выхода ещё не нажата

                POP HL
                BIT MENU_FIRE_BIT, A                                            ; флаг, действие или завершение выбора
                JR NZ, .ExitHelp                                                ; переход, если нажата кнопка выхода из справки

                AND #0A
                JR Z, .PreviousPage                                             ; переход, если не нажато направление вперёд, выбирается предыдущая страница

.SkipNewlines   LD A, (HL)
                INC HL
                CP #0D
                JR Z, .SkipNewlines                                             ; переход, если между страницами остаётся перевод строки

                DEC HL
                CP #FF
                JR NZ, .DrawPage                                                ; переход, если после переводов строк не достигнут конец справки

.ExitHelp       XOR A
                RET

.PreviousPage   DEC HL
                LD B, #FF
.CheckStart     EX DE, HL
                LD HL, Loader.Menu.UnitBuffer
                AND A
                SBC HL, DE
                EX DE, HL
                JR NC, .DrawPage                                                ; переход, если обратный поиск дошёл до начала загруженной справки

                DEC HL
                LD A, (HL)
                AND A
                JR NZ, .CheckStart                                              ; переход, если текущий байт ещё не является разделителем страниц

                INC B
                JR Z, .CheckStart                                               ; переход, если найден только первый из двух разделителей при обратном поиске

                INC HL
                INC HL
                JR .DrawPage
