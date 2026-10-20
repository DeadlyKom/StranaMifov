
; -----------------------------------------
; сохранение изменённых параметров на диск
; Сбрасывает флаги изменений. Если был установлен бит 1, записывает SOLDIERS/C. Если был
; установлен бит 0, записывает один сектор head.co/C со смещением #3E. Перед операциями
; переключает прерывания и AY, затем при необходимости восстанавливает IM 2.
; In:
;   SelectDrive.EditFlags — бит 1 числовые параметры, бит 0 дополнительная настройка
; Out:
;   переход к EditUnits.DrawUnits
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   запись файлов на диск, SelectDrive.EditFlags, самомодификация SaveUnitValues.ResumeMusic
; -----------------------------------------
SaveUnitValues  LD A, (SelectDrive.EditFlags)
                LD B, A
                XOR A
                LD (SaveUnitValues.ResumeMusic), A
                LD (SelectDrive.EditFlags), A
                LD A, B
                PUSH AF
                AND #02
                JR Z, .CheckDegrade                                             ; переход, если числовые параметры SOLDIERS не менялись

                LD (SaveUnitValues.ResumeMusic), A
                CALL SaveAYState                                                ; переход к IM 1 с сохранением состояния AY перед дисковой операцией
                LD HL, Loader.Menu.SelectDrive.UnitsFile                        ; девятибайтное имя SOLDIERS для редактора и записи настроек
                LD DE, Loader.Menu.UnitBuffer
                LD BC, #FF06
                XOR A
                CALL AccessFile                                                 ; операция с файлом по имени и смещению в секторах

                ; режим деградации хранится в отдельном секторе head.co и записывается
                ; независимо от SOLDIERS
.CheckDegrade   POP AF
                AND #01
                JR Z, .RestoreMusic                                             ; переход, если настройка деградации не менялась

                LD A, (SaveUnitValues.ResumeMusic)
                OR A
                CALL Z, SaveAYState                                             ; вызов, если AY ещё не сохранён перед записью head.co
                LD A, #3E
                LD (SaveUnitValues.ResumeMusic), A
                LD DE, Loader.Menu.HeadSector
                LD HL, Loader.Menu.SelectDrive.HeadFile                         ; девятибайтное имя head.co для настройки деградации
                LD BC, #0106
                CALL AccessFile                                                 ; операция с файлом по имени и смещению в секторах

                ; самомодифицируемый флаг показывает, нужно ли после дисковых операций
                ; возобновить музыку
.RestoreMusic   LD A, #00
.ResumeMusic    EQU $ - 1                                                       ; операнд признака временно отключённой музыки
                OR A
                CALL NZ, RestoreAYState                                         ; вызов, если дисковая запись потребовала временного отключения музыки
                JP EditUnits.DrawUnits
