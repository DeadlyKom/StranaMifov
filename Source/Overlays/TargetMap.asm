; оверлей 15 из OVR2
; исходный файл каталога 49, смещение #0262
                module Overlay
                module TargetMap
                org #B200

; -----------------------------------------
; показ собранных частей карты местонахождения цели
; Считает 25 бит в пяти байтах #6A55..#6A59, по пять бит на строку. Выбирает текст для 0,
; частичного числа или 25 фрагментов. В банк 4 выводит сетку 5x5 из портретоподобных блоков 4x4
; знакоместа. Для отсутствующего фрагмента использует #EEA0, для открытого берёт тайл из
; #C000+144*(тип AND #3F). Bit6 исходного байта включает горизонтальное отражение #75E1. Типы 25
; клеток хранятся в #6A5A..#6A72.
; In:
;   маска открытых частей и 25 байтов целевого узора
; Out:
;   карта 5x5 показана до действия пользователя
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом восстановления основного экрана #944A,
;   IX и IY явно используются для рисунка и маски фрагментов
; Note:
;   экран, банк 4, числовое поле Entry.KnownPieces, HL, DE, BC, AF, IX, IY
; -----------------------------------------
Entry           CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD BC, #0000
                LD DE, #1820
                LD A, #46
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD BC, #0105
                LD DE, #1414
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD HL, State.PuzzleOpen
                LD BC, #0500
.PieceRow       LD E, #05
                LD A, (HL)

                ; каждый из пяти байтов содержит пять открываемых фрагментов одной строки карты цели
.PieceBit       RRCA
                JR NC, .NextPieceBit                                            ; переход, если текущий фрагмент карты цели ещё не открыт

                INC C
.NextPieceBit   DEC E
                JR NZ, .PieceBit                                                ; переход, если в строке остались непроверенные фрагменты

                INC HL
                DJNZ .PieceRow

                LD B, #00
                LD (Entry.KnownPieces), BC
                LD DE, Overlay.TargetMap.Entry.SomePiecesText                   ; сообщение о числе собранных частей карты цели
                LD A, C
                OR A
                JR NZ, .AllPiecesText                                           ; переход, если найдена хотя бы одна часть карты цели

                LD DE, Overlay.TargetMap.Entry.NoPiecesText                     ; сообщение об отсутствии собранных частей карты
                JR .PrintPieces

.AllPiecesText  CP #19
                JR NZ, .PrintPieces                                             ; переход, если открыты ещё не все 25 частей карты цели

                LD DE, Overlay.TargetMap.Entry.AllPiecesTData                   ; сообщение о полностью собранной карте цели
.PrintPieces    LD B, #00
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD A, #04
                CALL Engine.PageEI                                              ; переключить логический банк и разрешить прерывания
                LD IY, State.PuzzleOpen
                LD BC, #0206
                LD HL, State.PuzzleTiles
                LD D, #19
                LD E, (IY + #00)
                SLA E
                SLA E
                SLA E
.TileCell       LD A, (HL)
                AND #3F
                INC A
                SLA E
                JR C, .TilePattern                                              ; переход, если текущая часть карты открыта и можно показать её местность

                PUSH DE
                LD IX, Graphics.World.MapGapPixels                              ; графическая заглушка отсутствующей части карты в банке 4
                LD DE, #0404
                CALL Engine.DrawRawSprite                                       ; вывести непрозрачный спрайт с атрибутами
                JR .NextTile

                ; индекс рисунка клетки выбирает блок из 144 байтов, закрытые фрагменты
                ; используют отдельную заглушку
.TilePattern    PUSH DE
                LD IX, Graphics.World.Tile00 - #0090                            ; база на один 144-байтный тайл перед первым рисунком местности банка 4
                LD DE, #0090
.FindPattern    ADD IX, DE
                DEC A
                JR NZ, .FindPattern                                             ; переход, если указатель ещё не дошёл до тайла нужного типа местности

                LD DE, #0404
                BIT MAP_MIRROR_BIT, (HL)                                        ; флаг, тайл клетки стратегической карты выводится с горизонтальным отражением
                JR NZ, .MirroredTile                                            ; переход, если клетка карты требует зеркального тайла

                CALL Engine.DrawRawSprite                                       ; вывести непрозрачный спрайт с атрибутами
                JR .NextTile

.MirroredTile   CALL Engine.DrawRawMirrored                                     ; вывести непрозрачный спрайт с горизонтальным отражением
.NextTile       POP DE
                INC HL
                LD A, C
                ADD A, #04
                LD C, A
                CP #1A
                JR NZ, .NextTileRow                                             ; переход, если в текущей строке остаются части карты цели

                INC IY
                LD E, (IY + #00)
                SLA E
                SLA E
                SLA E
                LD C, #06
                LD A, B
                ADD A, #04
                LD B, A
.NextTileRow    DEC D
                JR NZ, .TileCell                                                ; переход, если остаются клетки массива 5 на 5 частей

                LD B, #FF
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                CALL Engine.RefreshPanels                                       ; перерисовать верхнюю строку и боковую панель игры
                RET

.SomePiecesText EQU $                                                           ; сообщение о числе собранных частей карты цели
                DB #8F, #AE, #AA, #A0, #20, #E7, #E2, #AE
                DB #20, #A2, #EB, #20, #E0, #A0, #A7, #A4
                DB #AE, #A1, #EB, #AB, #A8, #20, #0F
.KnownPieces    DW #0000                                                        ; число открытых частей карты цели
                DB #00, #E7, #A0, #E1, #E2, #A8, #20, #AA
.NoPiecesText   EQU $+7                                                         ; сообщение об отсутствии собранных частей карты
                DB #A0, #E0, #E2, #EB, #0D, #2A, #00, #8D
                DB #A8, #E7, #A5, #A3, #AE, #20, #E2, #AE
                DB #20, #A2, #EB, #20, #AD, #A5, #20, #A7
                DB #AD, #A0, #A5, #E2, #A5, #0D, #2A, #00
.AllPiecesTData EQU $                                                           ; сообщение о полностью собранной карте цели
                DB #92, #A5, #AF, #A5, #E0, #EC, #20, #A2
                DB #E1, #EF, #20, #AA, #A0, #E0, #E2, #A0
                DB #20, #A2, #20, #A2, #A0, #E8, #A8, #E5
                DB #20, #E0, #E3, #AA, #A0, #E5, #0D, #2A
                DB #00, #6F, #76, #65, #72, #6C, #61, #79

                assert $ = #B325
                endmodule
                endmodule
