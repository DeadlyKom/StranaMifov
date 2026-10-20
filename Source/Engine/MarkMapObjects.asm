
; -----------------------------------------
; пометить занятые клетки карты для групп объектов
; последовательно выбирает банки 0/1 и группы указателей #6B79, #6AE9, #6AF9, #6B09, #6B19, #6B29
; и др, задаёт размеры области BC и шаг записи DE, вызывает #7B97 для текущего континента
; In:
;   карта банка 10, группы объектов банков 0/1, #6A2D текущий континент
; Out:
;   бит 7 карты установлен под прямоугольниками активных записей десяти групп, последний рабочий
;   банк 0
; Corrupt:
;   HL, DE, BC, AF, IX, IY, IFF может остаться запрещённым из-за прямого вызова #5FA1 в #7BE3
; -----------------------------------------
MarkMapObjects  LD A, #01
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD IX, State.MapArmiesIndex
                LD BC, #0101
                LD DE, #0016
                CALL MarkObjectGroup                                            ; установить бит 7 карты под активными записями группы
                XOR A
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD IX, State.CastlesIndex
                LD BC, #0203
                LD DE, #0023
                CALL MarkObjectGroup                                            ; установить бит 7 карты под активными записями группы
                LD IX, State.TownsIndex
                LD BC, #0101
                LD DE, #001A
                CALL MarkObjectGroup                                            ; установить бит 7 карты под активными записями группы
                LD IX, State.TemplesIndex
                LD BC, #0202
                LD DE, #0005
                CALL MarkObjectGroup                                            ; установить бит 7 карты под активными записями группы
                LD IX, State.SitesAIndex
                LD BC, #0101
                LD DE, #0006
                CALL MarkObjectGroup                                            ; установить бит 7 карты под активными записями группы
                LD IX, State.SitesBIndex
                LD BC, #0101
                LD DE, #0006
                CALL MarkObjectGroup                                            ; установить бит 7 карты под активными записями группы
                LD IX, State.SitesCIndex
                LD BC, #0101
                LD DE, #0006
                CALL MarkObjectGroup                                            ; установить бит 7 карты под активными записями группы
                LD IX, State.SitesDIndex
                LD BC, #0101
                LD DE, #0006
                CALL MarkObjectGroup                                            ; установить бит 7 карты под активными записями группы
                LD IX, State.ItemsIndex
                LD BC, #0101
                LD DE, #0003
                CALL MarkObjectGroup                                            ; установить бит 7 карты под активными записями группы
                LD IX, State.MapTroopsIndex
                LD BC, #0101
                LD DE, #0006
                CALL MarkObjectGroup                                            ; установить бит 7 карты под активными записями группы
                RET
