; оверлей 18 из OVR2
; исходный файл каталога 49, смещение #12C4
                module Overlay
                module Friendly
                org #B200

; -----------------------------------------
; встреча доброжелательного рассказчика и перенос его отметки
; Показывает персонажа 4 и приветствие, увеличивает 16-битный счётчик #6A49 и передаёт его в
; PrintStory. После рассказа снимает бит 7 карты со старой клетки #6A44. Выбирает случайные
; координаты,
; пока клетка имеет бит 7=0 и младшие 6 бит=0. Устанавливает бит 7 и сохраняет новую позицию
; #6A44.
; In:
;   #6A49 — число встреч, #6A44 — старая клетка
; Out:
;   рассказчик перенесён на новую клетку
; Corrupt:
;   HL, DE, BC, AF, BC'. HL', DE', AF', IX, IY сохранены. #8801 сохраняет основные и индексные
;   регистры, общий распаковщик BL1 меняет B'/C' как счётчик и значение RLE-серии
; Note:
;   #6A49, #6A44, карта банк 10, экран
; -----------------------------------------
Entry           CALL Engine.StopView                                            ; выключить обработку объектов в прерывании
                LD A, #04
                CALL Engine.ShowScene                                           ; показать одну из девяти упакованных сцен BL1/BL2 с восстановлением банка и основных регистров
                LD BC, #0E00
                LD DE, #081E
                LD A, #47
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                LD B, #11
                LD DE, Overlay.Friendly.PrintStory.GreetingText                 ; приветственная реплика рассказчика
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #28
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                LD HL, (State.GoodVisits)
                INC HL
                LD (State.GoodVisits), HL
                CALL PrintStory
                CALL Engine.SelectMapBank                                       ; выбрать логический банк 10 с текущей картой
                LD BC, (State.GoodStoryPos)
                CALL Engine.MapCellAddress                                      ; вычислить адрес клетки карты
                RES MAP_BUSY_BIT, (HL)                                          ; флаг, клетка стратегической карты занята объектом

                ; новая клетка рассказчика должна быть свободной от объектов и иметь нулевой код
                ; местности
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
                LD (State.GoodStoryPos), BC
                RET

; -----------------------------------------
; выбор и постраничная печать анекдота доброжелательной встречи
; При числе встреч меньше 5 выбирает соответствующий номер последовательно. Иначе получает номер
; генератором #7C0D с DE=3 и увеличивает его на 1. Ищет в текстовом блоке нужный разделитель #B1,
; печатает до #B2. CR переводит строку, при строке 22 выводит «Это еще не конец», ждёт ввода и
; продолжает на новой странице. При #B2 показывает «Вот и все» и ждёт.
; In:
;   HL — положительный номер встречи
; Out:
;   возврат после последней страницы
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
.StoryTable     LD HL, Overlay.Friendly.PrintStory.StoriesIndex                 ; нулевой байт перед первым разделителем #B1 встроенных историй

                ; истории отделены байтом #B1, номер встречи выбирает очередной фрагмент текста
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

                ; конец истории задаёт #B2, управляющий перевод строки обрабатывается отдельно
                ; от обычного знака
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
                LD DE, Overlay.Friendly.PrintStory.MoreText                     ; сообщение Это ещё не конец между страницами истории
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #FF
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                JR .DrawStoryBox

.DrawStoryChar  CALL Engine.DrawGlyphEI                                         ; вывести символ с обычной процедурой переключения банка
                INC C
                JR .ReadStoryChar

.WaitClose      LD BC, #1614
                LD DE, Overlay.Friendly.PrintStory.EndText                      ; сообщение Вот и всё после последней страницы
                CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #FF
                CALL Engine.WaitOrInput                                         ; выдержать паузу с досрочным выходом по вводу
                RET

.GreetingText   EQU $                                                           ; приветственная реплика рассказчика
                DB #8F, #E0, #A8, #A2, #A5, #E2, #20, #A4
                DB #AE, #A1, #E0, #EB, #A9, #20, #E7, #A5
                DB #AB, #AE, #A2, #A5, #AA, #2C, #0D, #2A
                DB #AF, #E0, #A8, #E1, #EF, #A4, #EC, #2C
                DB #20, #AE, #E2, #A4, #AE, #E5, #AD, #A8
                DB #2C, #0D, #2A, #A0, #20, #EF, #20, #E2
                DB #A5, #A1, #A5, #20, #A0, #AD, #A5, #AA
                DB #A4, #AE, #E2, #A5, #E6, #20, #E0, #A0
                DB #E1, #E1, #AA, #A0, #A6, #E3, #2E, #0D
.MoreText       EQU $+2                                                         ; сообщение Это ещё не конец между страницами истории
                DB #2A, #00, #9D, #E2, #AE, #20, #A5, #E9
                DB #A5, #20, #AD, #A5, #20, #AA, #AE, #AD
.EndText        EQU $+6                                                         ; сообщение Вот и всё после последней страницы
                DB #A5, #E6, #2E, #2E, #2E, #00, #82, #AE
                DB #E2, #20, #A8, #20, #A2, #E1, #A5, #2E
.StoriesIndex   EQU $+2                                                         ; нулевой байт перед первым разделителем #B1 встроенных историй
                DB #2E, #2E, #00, #B1, #20, #20, #20, #8B
                DB #A5, #A6, #A0, #E2, #20, #A3, #AE, #AB
                DB #AE, #A4, #AD, #EB, #A5, #20, #AE, #E0
                DB #AA, #A8, #20, #A8, #20, #AC, #A5, #E7
                DB #E2, #A0, #EE, #E2, #3A, #0D, #20, #2D
                DB #80, #20, #E7, #E2, #AE, #2C, #20, #A4
                DB #A0, #A2, #A0, #A9, #E2, #A5, #20, #E1
                DB #A2, #A8, #AD, #EC, #EE, #20, #A7, #A0
                DB #A2, #A5, #A4, #A5, #AC, #20, #21, #0D
                DB #20, #20, #20, #20, #20, #8C, #EF, #E1
                DB #AE, #20, #A1, #E3, #A4, #A5, #E2, #2C
                DB #20, #E1, #A0, #AB, #AE, #2E, #2E, #2E
                DB #0D, #20, #2D, #84, #A0, #20, #E2, #EB
                DB #20, #E7, #E2, #AE, #20, #3F, #21, #20
                DB #83, #E0, #EF, #A7, #EC, #2C, #20, #A2
                DB #AE, #AD, #EC, #20, #21, #0D, #20, #2D
                DB #8D, #A8, #E7, #A5, #A3, #AE, #2C, #20
                DB #AF, #E0, #A8, #A2, #EB, #AA, #AD, #A5
                DB #E2, #20, #E1, #AE, #20, #A2, #E0, #A5
                DB #AC, #A5, #AD, #A5, #AC, #2E, #B2, #B1
                DB #20, #20, #20, #8F, #E0, #AE, #E1, #EB
                DB #AF, #A0, #A5, #E2, #E1, #EF, #20, #AC
                DB #E3, #A6, #A8, #AA, #20, #E1, #20, #A1
                DB #A0, #A0, #AB, #EC, #E8, #AE, #A3, #AE
                DB #20, #A1, #AE, #A4, #E3, #AD, #A0, #2E
                DB #0D, #20, #92, #E3, #E2, #20, #AA, #AE
                DB #E2, #A5, #AD, #AE, #AA, #20, #E0, #EF
                DB #A4, #AE, #AC, #20, #A8, #A4, #A5, #E2
                DB #2E, #0D, #20, #2D, #8D, #A5, #20, #E2
                DB #AE, #AF, #A0, #A9, #2C, #20, #E1, #A2
                DB #AE, #AB, #AE, #E7, #EC, #20, #21, #21
                DB #21, #B2, #B1, #20, #20, #20, #8F, #E0
                DB #A8, #E5, #AE, #A4, #A8, #E2, #20, #AC
                DB #E3, #A6, #A8, #AA, #20, #A4, #AE, #AC
                DB #AE, #A9, #20, #AF, #AE, #A7, #A4, #AD
                DB #AE, #20, #AD, #AE, #E7, #EC, #EE, #2C
                DB #0D, #AF, #EC, #EF, #AD, #A5, #A5, #20
                DB #A3, #E0, #EF, #A7, #A8, #2E, #0D, #20
                DB #20, #20, #88, #20, #AD, #A0, #E7, #A0
                DB #AB, #A0, #20, #A5, #A3, #AE, #20, #A6
                DB #A5, #AD, #A0, #20, #A2, #AE, #E1, #AF
                DB #A8, #E2, #EB, #A2, #A0, #E2, #EC, #3A
                DB #0D, #A1, #EC, #A5, #E2, #20, #E1, #AA
                DB #A0, #AB, #AA, #AE, #A9, #20, #AF, #AE
                DB #20, #A3, #AE, #AB, #AE, #A2, #A5, #20
                DB #A8, #20, #AE, #E0, #A5, #E2, #3A, #0D
                DB #20, #2D, #81, #E3, #A4, #A5, #E8, #EC
                DB #20, #A5, #E9, #A5, #20, #AF, #A8, #E2
                DB #EC, #2C, #20, #E1, #AA, #AE, #E2, #A8
                DB #AD, #A0, #21, #20, #81, #E3, #A4, #A5
                DB #E8, #EC, #3F, #21, #0D, #20, #2D, #8D
                DB #AD, #AD, #A0, #AB, #AB, #A8, #A2, #A0
                DB #A9, #20, #21, #B2, #B1, #20, #2D, #9F
                DB #20, #AD, #A5, #20, #E5, #AE, #E7, #E3
                DB #20, #A2, #EB, #E5, #AE, #A4, #A8, #E2
                DB #EC, #20, #A7, #A0, #AC, #E3, #A6, #20
                DB #A7, #A0, #20, #E2, #A0, #AA, #AE, #A3
                DB #AE, #0D, #20, #20, #A6, #E3, #E2, #AA
                DB #AE, #A3, #AE, #20, #E1, #AA, #E3, #AF
                DB #A5, #E0, #A4, #EF, #EF, #20, #AA, #A0
                DB #AA, #20, #E2, #EB, #20, #21, #0D, #20
                DB #20, #87, #A0, #A1, #A5, #E0, #A8, #20
                DB #E1, #A2, #AE, #A5, #20, #AE, #A1, #E0
                DB #E3, #E7, #A0, #AB, #EC, #AD, #AE, #A5
                DB #20, #AA, #AE, #AB, #EC, #E6, #AE, #20
                DB #21, #0D, #20, #2D, #80, #20, #A3, #A4
                DB #A5, #20, #A6, #A5, #20, #AA, #AE, #E0
                DB #AE, #A1, #AE, #E7, #AA, #A0, #20, #3F
                DB #21, #B2, #6F, #76, #65, #72, #6C, #61
                DB #79

                assert $ = #B55B
                endmodule
                endmodule
