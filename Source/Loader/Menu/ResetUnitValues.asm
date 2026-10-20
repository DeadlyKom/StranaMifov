
; -----------------------------------------
; восстановление числовых параметров из встроенной таблицы
; Устанавливает Loader.Menu.DegradeSwitch=#38, отмечает изменения в SelectDrive.EditFlags, затем
; переносит 25 байтов из #6673..#668B в
; смещение #29 каждой записи Loader.Menu.UnitBuffer с шагом #2A. Возвращается к перерисовке
; редактора.
; In:
;   Loader.Menu.DegradeSwitch — прежняя настройка
; Out:
;   переход к EditUnits.DrawWindow
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   SelectDrive.EditFlags, Loader.Menu.DegradeSwitch, 25 записей Loader.Menu.UnitBuffer
; -----------------------------------------
ResetUnitValues LD C, #03
                LD A, (Loader.Menu.DegradeSwitch)
                LD B, A
                LD A, #38
                LD (Loader.Menu.DegradeSwitch), A
                CP B
                JR NZ, .MarkChanged                                             ; переход, если восстановление также изменило настройку деградации

                LD C, #02
.MarkChanged    LD A, C
                LD (SelectDrive.EditFlags), A
                LD HL, Loader.Menu.UnitBuffer
                LD DE, Loader.Menu.SelectDrive.DegradeDefault                   ; 25 исходных счётчиков деградации по типам существ
                LD B, #19

                ; из встроенной таблицы берётся только байт #29 каждой записи, остальные
                ; характеристики не меняются
.CopyValue      PUSH BC
                PUSH HL
                LD BC, #0029
                ADD HL, BC
                EX DE, HL
                LDI
                EX DE, HL
                POP HL
                LD BC, #002A
                ADD HL, BC
                POP BC
                DJNZ .CopyValue

                JP EditUnits.DrawWindow
