; оверлей 19 из OVR2
; исходный файл каталога 49, смещение #161F
                module Overlay
                module Hostile
                org #B200

; -----------------------------------------
; встреча враждебного рассказчика и выбор его нового континента
; Показывает персонажа 5 и угрожающее приветствие, увеличивает #6A50, вызывает PrintStory.
; Снимает бит
; 7 старой клетки #6A4B. Через генератор с DE=3 и увеличением результата выбирает континент #6A4D.
; Если он текущий, находит случайную клетку с бит 7=0 и младшими 6 бит=0, отмечает её и сохраняет
; #6A4B. Для другого континента координаты в этом входе не пересчитываются.
; In:
;   #6A50 — число встреч, #6A4B — прежняя позиция
; Out:
;   #6A4D — выбранный континент
; Corrupt:
;   HL, DE, BC, AF, BC'. HL', DE', AF', IX, IY сохранены. #8801 сохраняет основные и индексные
;   регистры, общий распаковщик BL1 меняет B'/C' как счётчик и значение RLE-серии
; Note:
;   карта, счётчики, экран
; -----------------------------------------
Entry           CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD A, #05
                CALL Engine.ShowScene                                           ; показать одну из девяти упакованных сцен BL1/BL2 с восстановлением банка и основных регистров
                LD BC, #0E00
                LD DE, #081E
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #11
                LD DE, Overlay.Hostile.Entry.GreetingText                       ; приветственная реплика рассказчика
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #28
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD HL, (State.BadVisits)
                INC HL
                LD (State.BadVisits), HL
                CALL PrintStory
                CALL Engine.SelectMapBank                                       ; выбрать логический банк 10 с текущей картой
                LD BC, (State.BadStoryPos)
                CALL Engine.MapCellAddress                                      ; вычислить адрес клетки карты
                RES MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты занята объектом
                LD DE, #0003
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                INC E
                LD A, (State.Continent)
                CP E
                LD A, E
                LD (State.BadStoryMap), A
                JR NZ, .Return                                                  ; переход, если новая отметка рассказчика находится на другом континенте

                ; координаты меняются только на текущем континенте, выбранный другой континент
                ; сохраняется отдельно
.FindStoryCell  LD DE, #00A0
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD C, E
                LD DE, #0063
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                LD B, E
                CALL Engine.MapCellAddress                                      ; вычислить адрес клетки карты
                LD A, (HL)
                BIT MAP_BUSY_BIT, A                                             ; флаг, клетка стратегической карты занята объектом
                JR NZ, .FindStoryCell                                           ; переход, если случайная клетка уже занята объектом

                AND #3F
                JR NZ, .FindStoryCell                                           ; переход, если случайная клетка имеет ненулевой код местности

                SET MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты занята объектом
                LD (State.BadStoryPos), BC
.Return         RET

.GreetingText   EQU $                                                           ; приветственная реплика рассказчика
                DB #93, #A1, #A8, #A2, #A0, #E2, #EC, #20
                DB #EF, #20, #E2, #A5, #A1, #EF, #20, #AF
                DB #AE, #AA, #A0, #20, #AD, #A5, #20, #A1
                DB #E3, #A4, #E3, #2C, #0D, #2A, #EF, #20
                DB #E2, #A5, #A1, #A5, #20, #AB, #E3, #E7
                DB #E8, #A5, #20, #E1, #AA, #A0, #A7, #AE
                DB #E7, #AA, #E3, #20, #E0, #A0, #E1, #E1
                DB #AA, #A0, #A6, #E3, #2E, #0D, #2A, #00

; -----------------------------------------
; постраничный анекдот враждебной встречи
; Тот же алгоритм разделителей #B1/#B2, нумерации первых четырёх встреч и постраничной печати, что
; O18, #B257. Собственный текстовый блок начинается #B33B, координаты печати 15, 2, переход
; страницы при строке 22.
; In:
;   HL — положительный номер встречи
; Out:
;   возврат после завершения
; Corrupt:
;   HL, DE, BC, AF. HL', DE', BC', AF', IX, IY сохранены
; Note:
;   экран, HL, DE, BC, AF
; -----------------------------------------
PrintStory      LD BC, #0005
                OR A
                PUSH HL
                SBC HL, BC
                POP BC
                JR C, .StoryTable                                               ; переход, если это одна из первых четырёх встреч и номер рассказа задан порядком

                LD DE, #0003
                CALL Engine.RandomScaled                                        ; получить масштабированное псевдослучайное число
                INC DE
                LD C, E
                LD B, D
.StoryTable     LD HL, Overlay.Hostile.PrintStory.StoriesIndex                  ; нулевой байт перед первым разделителем #B1 встроенных историй

                ; номер встречи приводит к одной из пяти историй, разделитель записи имеет код #B1
.FindStory      INC HL
                LD A, (HL)
                CP #B1
                JR NZ, .FindStory                                               ; переход, если разделитель следующей истории ещё не найден

                DEC BC
                LD A, B
                OR C
                JR NZ, .FindStory                                               ; переход, если до выбранной истории остаются другие записи

.DrawStoryBox   PUSH HL
                LD BC, #0E00
                LD DE, #081E
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD BC, #1601
                LD DE, #011E
                LD A, #44
                CALL Engine.FillAttributes                                      ; заполнить прямоугольник атрибутов цветом A
                POP HL
                LD BC, #0F02
.ReadStoryChar  INC HL
                LD A, (HL)
                CP #B2
                JR Z, .WaitClose                                                ; переход, если достигнут конец выбранной истории

                CP #0D
                JR NZ, .DrawStoryChar                                           ; переход, если прочитан символ рассказа, а не перевод строки

                LD C, #02
                INC B
                LD A, B
                CP #16
                JR NZ, .ReadStoryChar                                           ; переход, если текст ещё помещается до нижней строки страницы

                LD BC, #160F
                LD DE, Overlay.Hostile.PrintStory.MoreText                      ; сообщение Это ещё не конец между страницами истории
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #FF
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JR .DrawStoryBox

.DrawStoryChar  CALL Engine.DrawGlyphEI                                         ; вывести символ с обычной процедурой переключения банка
                INC C
                JR .ReadStoryChar

.WaitClose      LD BC, #1614
                LD DE, Overlay.Hostile.PrintStory.EndText                       ; сообщение Вот и всё после последней страницы
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #FF
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                RET

.MoreText       EQU $                                                           ; сообщение Это ещё не конец между страницами истории
                DB #9D, #E2, #AE, #20, #A5, #E9, #A5, #20
                DB #AD, #A5, #20, #AA, #AE, #AD, #A5, #E6
.EndText        EQU $+4                                                         ; сообщение Вот и всё после последней страницы
                DB #2E, #2E, #2E, #00, #82, #AE, #E2, #20
                DB #A8, #20, #A2, #E1, #A5, #2E, #2E, #2E
.StoriesIndex   EQU $                                                           ; нулевой байт перед первым разделителем #B1 встроенных историй
                DB #00, #B1, #20, #20, #20, #8B, #A5, #A6
                DB #A0, #E2, #20, #A3, #AE, #AB, #AE, #A4
                DB #AD, #EB, #A5, #20, #AE, #E0, #AA, #A8
                DB #20, #A8, #20, #AC, #A5, #E7, #E2, #A0
                DB #EE, #E2, #3A, #0D, #20, #2D, #80, #20
                DB #E7, #E2, #AE, #2C, #20, #A4, #A0, #A2
                DB #A0, #A9, #E2, #A5, #20, #E1, #A2, #A8
                DB #AD, #EC, #EE, #20, #A7, #A0, #A2, #A5
                DB #A4, #A5, #AC, #20, #21, #0D, #20, #20
                DB #20, #20, #20, #8C, #EF, #E1, #AE, #20
                DB #A1, #E3, #A4, #A5, #E2, #2C, #20, #E1
                DB #A0, #AB, #AE, #2E, #2E, #2E, #0D, #20
                DB #2D, #84, #A0, #20, #E2, #EB, #20, #E7
                DB #E2, #AE, #20, #3F, #21, #20, #83, #E0
                DB #EF, #A7, #EC, #2C, #20, #A2, #AE, #AD
                DB #EC, #20, #21, #0D, #20, #2D, #8D, #A8
                DB #E7, #A5, #A3, #AE, #2C, #20, #AF, #E0
                DB #A8, #A2, #EB, #AA, #AD, #A5, #E2, #20
                DB #E1, #AE, #20, #A2, #E0, #A5, #AC, #A5
                DB #AD, #A5, #AC, #2E, #B2, #B1, #20, #20
                DB #20, #8F, #E0, #AE, #E1, #EB, #AF, #A0
                DB #A5, #E2, #E1, #EF, #20, #AC, #E3, #A6
                DB #A8, #AA, #20, #E1, #20, #A1, #A0, #A0
                DB #AB, #EC, #E8, #AE, #A3, #AE, #20, #A1
                DB #AE, #A4, #E3, #AD, #A0, #2E, #0D, #20
                DB #92, #E3, #E2, #20, #AA, #AE, #E2, #A5
                DB #AD, #AE, #AA, #20, #E0, #EF, #A4, #AE
                DB #AC, #20, #A8, #A4, #A5, #E2, #2E, #0D
                DB #20, #2D, #8D, #A5, #20, #E2, #AE, #AF
                DB #A0, #A9, #2C, #20, #E1, #A2, #AE, #AB
                DB #AE, #E7, #EC, #20, #21, #21, #21, #B2
                DB #B1, #20, #20, #20, #8F, #E0, #A8, #E5
                DB #AE, #A4, #A8, #E2, #20, #AC, #E3, #A6
                DB #A8, #AA, #20, #A4, #AE, #AC, #AE, #A9
                DB #20, #AF, #AE, #A7, #A4, #AD, #AE, #20
                DB #AD, #AE, #E7, #EC, #EE, #2C, #0D, #AF
                DB #EC, #EF, #AD, #A5, #A5, #20, #A3, #E0
                DB #EF, #A7, #A8, #2E, #0D, #20, #20, #20
                DB #88, #20, #AD, #A0, #E7, #A0, #AB, #A0
                DB #20, #A5, #A3, #AE, #20, #A6, #A5, #AD
                DB #A0, #20, #A2, #AE, #E1, #AF, #A8, #E2
                DB #EB, #A2, #A0, #E2, #EC, #3A, #0D, #A1
                DB #EC, #A5, #E2, #20, #E1, #AA, #A0, #AB
                DB #AA, #AE, #A9, #20, #AF, #AE, #20, #A3
                DB #AE, #AB, #AE, #A2, #A5, #20, #A8, #20
                DB #AE, #E0, #A5, #E2, #3A, #0D, #20, #2D
                DB #81, #E3, #A4, #A5, #E8, #EC, #20, #A5
                DB #E9, #A5, #20, #AF, #A8, #E2, #EC, #2C
                DB #20, #E1, #AA, #AE, #E2, #A8, #AD, #A0
                DB #21, #20, #81, #E3, #A4, #A5, #E8, #EC
                DB #3F, #21, #0D, #20, #2D, #8D, #AD, #AD
                DB #A0, #AB, #AB, #A8, #A2, #A0, #A9, #20
                DB #21, #B2, #B1, #20, #2D, #9F, #20, #AD
                DB #A5, #20, #E5, #AE, #E7, #E3, #20, #A2
                DB #EB, #E5, #AE, #A4, #A8, #E2, #EC, #20
                DB #A7, #A0, #AC, #E3, #A6, #20, #A7, #A0
                DB #20, #E2, #A0, #AA, #AE, #A3, #AE, #0D
                DB #20, #20, #A6, #E3, #E2, #AA, #AE, #A3
                DB #AE, #20, #E1, #AA, #E3, #AF, #A5, #E0
                DB #A4, #EF, #EF, #20, #AA, #A0, #AA, #20
                DB #E2, #EB, #20, #21, #0D, #20, #20, #87
                DB #A0, #A1, #A5, #E0, #A8, #20, #E1, #A2
                DB #AE, #A5, #20, #AE, #A1, #E0, #E3, #E7
                DB #A0, #AB, #EC, #AD, #AE, #A5, #20, #AA
                DB #AE, #AB, #EC, #E6, #AE, #20, #21, #0D
                DB #20, #2D, #80, #20, #A3, #A4, #A5, #20
                DB #A6, #A5, #20, #AA, #AE, #E0, #AE, #A1
                DB #AE, #E7, #AA, #A0, #20, #3F, #21, #B2
                DB #6F, #76, #65, #72, #6C, #61, #79

                assert $ = #B562
                endmodule
                endmodule
