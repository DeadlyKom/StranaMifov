
; -----------------------------------------
; вход в редактор параметров игровых армий
; Обнуляет Loader.Menu.UnitBuffer..#DFFF, загружает SOLDIERS/C и сектор head.co/C со смещением
; #3E. Рисует таблицу
; из 25 записей по #2A байта. Для каждой записи выводит имя и байт значения по смещению #29. Меню
; позволяет сохранить, выйти, восстановить значения, переключить состояние и изменить выбранное
; число.
; In:
;   нет явных аргументов
; Out:
;   возврат по пункту выхода
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
; Loader.Menu.UnitBuffer — редактируемые записи, Loader.Menu.HeadSector — сектор head.co,
; SelectDrive.EditFlags — флаги изменений
; -----------------------------------------
EditUnits       LD HL, Loader.Menu.UnitBuffer
                LD DE, Loader.Menu.UnitBuffer + 1                               ; следующий байт области загрузки, используется размножением нуля LDIR
                LD BC, #68DB
                XOR A
                LD (HL), A
                LD (SelectDrive.EditFlags), A
                LDIR
                LD HL, Loader.Menu.SelectDrive.UnitsFile                        ; девятибайтное имя SOLDIERS для редактора и записи настроек
                LD DE, Loader.Menu.UnitBuffer
                LD BC, #FF05
                CALL AccessFile                                                 ; операция с файлом по имени и смещению в секторах
                LD A, #3E
                LD DE, Loader.Menu.HeadSector
                LD HL, Loader.Menu.SelectDrive.HeadFile                         ; девятибайтное имя head.co для настройки деградации
                LD BC, #0105
                CALL AccessFile                                                 ; операция с файлом по имени и смещению в секторах
                CALL RestoreAYState                                             ; установка IM 2 и восстановление регистров AY

                ; повторный вход после восстановления значений заново рисует окно редактора
.DrawWindow     LD IX, Loader.Menu.SelectDrive.EditWindow                       ; семибайтный описатель окна редактора деградации
                CALL DrawWindow                                                 ; рисование окна по дескриптору
.DrawUnits      CALL PrintDegrade                                               ; вывод состояния переключаемой настройки редактора
                LD HL, Loader.Menu.SelectDrive.EditHeading                      ; заголовок счётчиков деградации в днях
                CALL PrintString                                                ; печать строки с управляющими кодами
                LD HL, Loader.Menu.UnitBuffer
                LD B, #19
                LD A, #01
                LD (SelectDrive.EditX), A
                LD A, #04
                LD (SelectDrive.EditY), A
                LD A, #20
                LD (SelectDrive.EditAttr), A

                ; одна строка содержит имя типа и редактируемый байт квалификации из SOLDIERS+#29
.UnitRow        PUSH BC
                PUSH HL
                LD HL, Loader.Menu.SelectDrive.EditPosition                     ; управляющая строка позиции и атрибута числового поля редактора
                CALL PrintString                                                ; печать строки с управляющими кодами
                POP HL
                PUSH HL
                CALL PrintString                                                ; печать строки с управляющими кодами
                LD HL, Loader.Menu.SelectDrive.ValueSeparator                   ; двоеточие и цвет перед числовым полем строки типа
                CALL PrintString                                                ; печать строки с управляющими кодами
                POP HL
                PUSH HL
                LD DE, #0029
                ADD HL, DE
                LD A, (HL)
                CALL ByteToDecimal                                              ; преобразование беззнакового байта в три десятичные цифры
                LD HL, Loader.Menu.SelectDrive.DecimalText                      ; трёхзначное десятичное число с нулевым терминатором
                CALL PrintString                                                ; печать строки с управляющими кодами
                POP HL
                LD DE, #002A
                ADD HL, DE
                LD A, (SelectDrive.EditY)
                INC A
                LD (SelectDrive.EditY), A
                CP #11
                JR NZ, .NextUnit                                                ; переход, если следующая запись ещё помещается в текущем столбце таблицы

                LD A, #04
                LD (SelectDrive.EditY), A
                LD A, #15
                LD (SelectDrive.EditX), A
.NextUnit       POP BC
                DJNZ .UnitRow

                LD HL, Loader.Menu.SelectDrive.EditActions                      ; надписи Записать, Выйти, Стандарт
                CALL PrintString                                                ; печать строки с управляющими кодами

                ; меню объединяет операции с файлом и выбор одного из 25 числовых параметров
.BeginChoice    LD HL, Loader.Menu.SelectDrive.EditAreas                        ; области выбора строк и кнопок редактора деградации
                CALL BeginMenu                                                  ; подготовка выбора пункта меню курсором
.PollChoice     CALL PollMenu                                                   ; один шаг ожидания выбора в меню
                JR NC, .PollChoice                                              ; переход, если пользователь ещё не подтвердил пункт меню

                PUSH AF
                CALL EndMenu                                                    ; завершение выбора пункта меню
                POP AF
                INC A
                RET Z                                                           ; выход, если выбор меню отменён кодом #FF

                DEC A
                JP Z, SaveUnitValues                                            ; переход, если выбран пункт сохранения параметров

                DEC A
                RET Z                                                           ; выход, если выбран пункт выхода из редактора

                DEC A
                JP Z, ResetUnitValues                                           ; переход, если выбран пункт восстановления параметров

                DEC A
                JP Z, ToggleDegrade                                             ; переход, если выбран переключатель деградации

                PUSH AF
                DEC A
                LD B, #0F
                LD C, A
                SUB #0D
                JR C, .ValuePosition                                            ; переход, если выбранное число находится в первом столбце таблицы

                LD B, #23
                LD C, A
.ValuePosition  LD A, B
                LD (SelectDrive.EditX), A
                LD A, #04
                ADD A, C
                LD (SelectDrive.EditY), A
                LD A, #27
                LD (SelectDrive.EditAttr), A
                CALL WaitRelease                                                ; ожидание отпускания кнопки действия
                POP AF
                LD B, A
                LD HL, Loader.Menu.UnitBuffer - 1                               ; смещённая база квалификации, после добавления FSoldier первым получается поле DegradeDays записи 1
                LD DE, #002A

                ; выбранное поле ищется с шагом полной 42-байтной записи SOLDIERS
.FindValue      ADD HL, DE
                DJNZ .FindValue

                LD A, (SelectDrive.EditFlags)
                PUSH AF
                LD A, (HL)
                LD B, A

                ; число перерисовывается до следующего нажатия, исходное значение сохранено для
                ; отметки изменений
.DrawValue      PUSH BC
                PUSH HL
                LD HL, Loader.Menu.SelectDrive.EditPosition                     ; управляющая строка позиции и атрибута числового поля редактора
                CALL PrintString                                                ; печать строки с управляющими кодами
                POP HL
                PUSH HL
                LD A, (HL)
                CALL ByteToDecimal                                              ; преобразование беззнакового байта в три десятичные цифры
                LD HL, Loader.Menu.SelectDrive.DecimalText                      ; трёхзначное десятичное число с нулевым терминатором
                CALL PrintString                                                ; печать строки с управляющими кодами
.WaitValueKey   CALL ReadControls                                               ; объединённый опрос клавиатуры и Kempston
                AND A
                JR Z, .WaitValueKey                                             ; переход, если ни одна кнопка управления не нажата

                POP HL
                POP BC
                BIT MENU_FIRE_BIT, A                                            ; флаг, действие или завершение выбора
                JR Z, .ValueDelta                                               ; переход, если кнопка завершения изменения числа не нажата

                LD A, (SelectDrive.EditFlags)
                LD B, A
                POP AF
                OR B
                LD (SelectDrive.EditFlags), A
                JP .DrawUnits

                ; четыре направления изменяют число на +1, -1, +10 или -10 без ограничения
                ; переполнения байта
.ValueDelta     LD C, #01
                BIT MENU_LEFT_BIT, A                                            ; флаг, движение влево
                JR NZ, .ChangeValue                                             ; переход, если нажато влево, число увеличивается на 1

                LD C, #FF
                BIT MENU_RIGHT_BIT, A                                           ; флаг, движение вправо
                JR NZ, .ChangeValue                                             ; переход, если нажато вправо, число уменьшается на 1

                LD C, #0A
                BIT MENU_UP_BIT, A                                              ; флаг, движение вверх
                JR NZ, .ChangeValue                                             ; переход, если нажато вверх, число увеличивается на 10

                LD C, #F6
.ChangeValue    LD A, (HL)
                ADD A, C
                LD (HL), A
                LD D, A
                LD A, (SelectDrive.EditFlags)
                AND #01
                LD C, #00
                LD E, A
                LD A, D
                CP B
                LD A, E
                JR Z, .MarkChanged                                              ; переход, если изменяемое число совпало с исходным значением

                LD C, #02

                ; бит изменения числовых параметров сохраняется вместе с отдельной отметкой
                ; режима деградации
.MarkChanged    OR C
                LD (SelectDrive.EditFlags), A
                LD DE, #5FFF

                ; программная задержка ограничивает скорость повторного изменения удерживаемой
                ; кнопкой
.RepeatDelay    DEC DE
                LD A, D
                OR E
                JR NZ, .RepeatDelay                                             ; переход, если задержка повторного изменения числа ещё не истекла

                JR .DrawValue
