
; -----------------------------------------
; подсветка области меню под курсором
; Проходит тройки (x, y, длина) по указателю MenuState.Areas до #FF. Проверяет B как
; строку, C как столбец.
; Бит 7 первого байта хранит текущую подсветку. При входе или выходе меняет бит и переставляет
; INK/PAPER в полосе атрибутов через SwapAttrStrip.
; In:
;   B — строка курсора, C — столбец курсора, MenuState.Areas — таблица областей
; Out:
;   активная область отмечена битом 7
; Corrupt:
;   HL, DE, AF, IX, BC сохраняется вспомогательным изменением атрибутов
; Note:
;   таблица областей, атрибуты экрана
; -----------------------------------------
HighlightAreas  LD IX, (MenuState.Areas)

                ; тройка области задаёт столбец, строку и длину, бит 7 первого байта хранит
                ; состояние подсветки
.AreaLoop       LD A, (IX + FMenuArea.XAndActive)
                CP #FF
                RET Z                                                           ; выход, если достигнут завершающий байт таблицы областей

                JP M, .CheckActive                                              ; переход, если область уже подсвечена и нужно проверить выход курсора

                LD E, A
                LD A, B
                CP (IX + FMenuArea.Y)
                JR NZ, .NextArea                                                ; переход, если курсор находится в другой строке

                LD A, C
                SUB E
                JR C, .NextArea                                                 ; переход, если курсор расположен левее области

                CP (IX + FMenuArea.Width)
                JR NC, .NextArea                                                ; переход, если курсор расположен справа от области

                LD D, (IX + FMenuArea.Y)
                LD A, (IX + FMenuArea.Width)
                SET MENU_ACTIVE_BIT, (IX + FMenuArea.XAndActive)                ; флаг, область меню подсвечена обменом INK и PAPER
                CALL SwapAttrStrip                                              ; обмен цветов INK и PAPER в полосе атрибутов
                JR .NextArea

.CheckActive    AND #7F
                LD E, A
                LD A, B
                CP (IX + FMenuArea.Y)
                JR NZ, .Unhighlight                                             ; переход, если курсор покинул строку подсвеченной области

                LD A, C
                SUB E
                JR C, .Unhighlight                                              ; переход, если курсор вышел за левую границу подсвеченной области

                CP (IX + FMenuArea.Width)
                JR C, .NextArea                                                 ; переход, если курсор всё ещё находится внутри подсвеченной области

                ; при выходе курсора из области инверсия цветов выполняется повторно и снимает
                ; подсветку
.Unhighlight    RES MENU_ACTIVE_BIT, (IX + FMenuArea.XAndActive)                ; флаг, область меню подсвечена обменом INK и PAPER
                LD D, (IX + FMenuArea.Y)
                LD A, (IX + FMenuArea.Width)
                CALL SwapAttrStrip                                              ; обмен цветов INK и PAPER в полосе атрибутов
.NextArea       LD DE, #0003
                ADD IX, DE
                JR .AreaLoop
