
; -----------------------------------------
; расшифровка меню с подменой канала вывода BASIC
; Сохраняет CURCHL из System.CurrentChannel в операнде DecodeMenu.SavedChannel и заменяет его на
; указатель #61A6, содержащий PrintHook.
; Инициализирует R=#59 и обрабатывает #157D байтов MainMenu..Loader.Menu.UnitBuffer
; включительно. Ключ образуется
; показаниями R, байтами адреса, остатком DE и дополнительным XOR внутри перехватчика RST #10.
; Вызов проходит через настоящий путь ПЗУ #0010/#15F2/#162C, поэтому число M1-выборок входит в
; ключ. После расшифровки восстанавливает HL из сохранённого операнда и передаёт управление
; MainMenu.
; На этом участке CURCHL остаётся подменённым.
; In:
;   System.CurrentChannel — исходный канал вывода, стандартное ПЗУ 48
; Out:
;   открытый код меню по MainMenu
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', R
; -----------------------------------------
DecodeMenu      DI
                LD HL, (System.CurrentChannel)
                LD (DecodeMenu.SavedChannel), HL
                LD HL, Loader.Menu.PrintHook.OutputChannel                      ; слово адреса PrintHook, временный канал вывода BASIC
                LD (System.CurrentChannel), HL
                LD A, #59
                LD R, A
                LD HL, MainMenu
                LD DE, #157D
                LD A, R
                XOR (HL)
                XOR H
                XOR L
                RST #10

                DB #AA, #AB, #77, #23, #1B, #7B, #B2, #20
                DB #F1, #21
.SavedChannel   DW #5D26                                                        ; сохранённый канал вывода BASIC, операнд восстанавливающей LD HL
                DB #C3, #A8, #61
