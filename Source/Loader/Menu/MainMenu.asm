
; -----------------------------------------
; вход в скрытое меню дисковой версии
; Сохраняет исходный SP, запоминает текущий привод TR-DOS, выбирает привод 0, запускает AY-плеер,
; устанавливает IM 2. Очищает экран, рисует окно и три пункта. Обрабатывает выбор, возвращая
; управление в главное меню после описания или редактора.
; In:
;   SP — стек вызывающего BASIC, TrDos.Drive — текущий привод
; Out:
;   после выбора игры управление передаётся StartGame
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', IX, IY, I, режим прерываний
; Note:
; SaveAYState.MenuStack — сохранённый SP, SelectDrive.Drive — привод, SelectDrive.MenuCursor —
; начальная позиция курсора
; -----------------------------------------
MainMenu        LD (SaveAYState.MenuStack), SP
                LD A, (TrDos.Drive)
                LD (SelectDrive.Drive), A
                XOR A
                CALL SelectDrive                                                ; установка текущего привода TR-DOS
                CALL Music.Menu.InitMenuMusic                                   ; внешний вход запуска музыки скрытого меню
                CALL RestoreAYState                                             ; установка IM 2 и восстановление регистров AY
                LD HL, #4860
                LD (SelectDrive.MenuCursor), HL
.ResetBorder    LD A, #01
                LD (MenuState.PortFE), A
                OUT (#FE), A
.DrawMenu       LD A, #0F
                CALL ClearScreen                                                ; очистка экранной памяти и заполнение атрибутов
                LD IX, Loader.Menu.SelectDrive.MainWindow                       ; семибайтный описатель главного окна FMenuWindow
                CALL DrawWindow                                                 ; рисование окна по дескриптору
                LD HL, Loader.Menu.SelectDrive.MainText                         ; надписи трёх пунктов главного меню
                CALL PrintString                                                ; печать строки с управляющими кодами
                LD HL, (SelectDrive.MenuCursor)
                LD (MenuState.CursorXY), HL
                LD HL, Loader.Menu.SelectDrive.MainAreas                        ; прямоугольные области выбора трёх пунктов главного меню
                CALL BeginMenu                                                  ; подготовка выбора пункта меню курсором

                ; пункты обрабатываются только при подтверждённом выборе, нажатие вне областей
                ; меню игнорируется
.PollChoice     CALL PollMenu                                                   ; один шаг ожидания выбора в меню
                JR NC, .PollChoice                                              ; переход, если пункт ещё не подтверждён

                INC A
                JR Z, .PollChoice                                               ; переход, если подтверждение произошло вне пунктов меню

                PUSH AF
                CALL SaveAYState                                                ; переход к IM 1 с сохранением состояния AY перед дисковой операцией
                LD HL, (MenuState.CursorXY)
                LD (SelectDrive.MenuCursor), HL
                CALL EndMenu                                                    ; завершение выбора пункта меню
                POP AF
                DEC A
                JP Z, StartGame                                                 ; переход, если выбран запуск игры

                DEC A
                CALL Z, ShowHelp                                                ; вызов, если выбрана справка
                DEC A
                CALL Z, EditUnits                                               ; вызов, если выбран редактор параметров существ
                JR .DrawMenu
