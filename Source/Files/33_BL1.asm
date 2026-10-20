; первая банка изображений с распаковщиком
; исходный файл каталога 33, смещение #0000
                module Graphics
                module Scenes1
                org #C000

; -----------------------------------------
; вход в самоперемещаемый распаковщик банка изображений
; JR пропускает четыре байта настроек по смещениям 2..5. Вызывающий код записывает номер картинки
; в смещение 2. Дальше исполняется общий алгоритм по адресу начала+6.
; In:
;   Draw.Picture — номер изображения от 1
; Out:
;   переход к началу+6
; Corrupt:
;   HL, DE, BC, AF, BC', IY. HL', DE', AF', IX сохранены, SP возвращается к входной позиции до
;   RET
; -----------------------------------------
Draw            JR Unpack

.Picture        DB #01                                                          ; номер изображения, FRleState.Picture
.FirstThird     DB #FF                                                          ; начальная треть экрана, #FF брать из заголовка
.ThirdCount     DB #FF                                                          ; число третей экрана, #FF брать из заголовка
.Flags          DB #0C                                                          ; флаги распаковщика, FRleState.Flags
; -----------------------------------------
; выбор изображения, RLE-распаковка пикселей и атрибутов
; CALL #007C использует RET в ПЗУ, оставшийся в стеке адрес позволяет вычислить собственную базу и
; IY=начало+2. По цепочке относительных длин начиная с IY+#012A выбирается изображение. Поток
; содержит начальную треть экрана, число третей и флаги. Координаты ограничиваются диапазоном
; экрана. Бит 0 задаёт порядок обхода строк и столбцов, бит 2 означает продолжающуюся RLE-серию,
; бит 3 переключает вывод на линейные атрибуты. Ненулевой байт является литералом, нулевой
; открывает пару длина/значение. Счётчик серии и повторяемый байт хранятся в альтернативных B'/C',
; серия может пересекать границы внутренних циклов. Пиксели пишутся с нелинейным шагом Spectrum,
; затем записываются атрибуты. После вывода два поля выбора области сбрасываются в #FF.
; In:
;   настройки по IY, таблица относительных длин и упакованный поток
; Out:
;   полный экран для заголовка [0,3, flags], BC=0, A=0, Z=1, CF=0, DE=#5B00, HL после последнего
;   прочитанного байта потока, IY=начало+2, поля области +3/+4 сброшены в #FF
; Corrupt:
;   HL, DE, BC, AF, BC', IY. HL', DE', AF', IX сохранены, SP возвращается к входной позиции до
;   RET
; -----------------------------------------
Unpack          CALL Rom.Return                                                 ; возврат через RET ПЗУ для определения собственного адреса
                DEC SP
                DEC SP
                EX (SP), HL
                INC SP
                INC SP
                AND A
                LD DE, #0007
                SBC HL, DE
                PUSH HL
                POP IY
                LD DE, #012A
                ADD HL, DE
                LD A, (IY + FRleState.Picture)

                ; переход по смещениям заголовков к выбранному изображению
.FindPicture    DEC A
                JR Z, .ReadHeader                                               ; переход, если найдено изображение с запрошенным порядковым номером

                LD E, (HL)
                INC HL
                LD D, (HL)
                ADD HL, DE
                JR .FindPicture

                ; чтение параметров начальной трети, числа третей и порядка пикселей
.ReadHeader     LD DE, Screen.Pixels                                            ; начало видимой пиксельной области Spectrum
                INC HL
                INC HL
                LD A, (IY + FRleState.FirstThird)
                INC A
                JR NZ, .WidthHeader                                             ; переход, если начальная треть экрана задана вызывающим кодом вместо #FF

                LD A, (HL)
                LD (IY + FRleState.FirstThird), A
.WidthHeader    INC HL
                LD A, (IY + FRleState.ThirdCount)
                INC A
                JR NZ, .ReadFlags                                               ; переход, если число третей задано вызывающим кодом вместо #FF

                LD A, (HL)
                LD (IY + FRleState.ThirdCount), A
.ReadFlags      INC HL
                LD A, (HL)
                LD (IY + FRleState.Flags), A
                LD A, (IY + FRleState.FirstThird)
                CP #03
                JR C, .HeightLimit                                              ; переход, если начальная треть экрана находится в допустимом диапазоне 0..2

                LD (IY + FRleState.FirstThird), #00
.HeightLimit    LD A, (IY + FRleState.ThirdCount)
                CP #04
                JR C, .WidthLimit                                               ; переход, если число третей экрана не превышает 3

                LD (IY + FRleState.ThirdCount), #01
.WidthLimit     ADD A, (IY + FRleState.FirstThird)
                CP #04
                JR C, .EnsureWidth                                              ; переход, если выбранная область заканчивается не ниже третьей трети экрана

                LD (IY + FRleState.ThirdCount), #01
.EnsureWidth    LD A, (IY + FRleState.ThirdCount)
                AND A
                JR NZ, .PixelBase                                               ; переход, если число выводимых третей ненулевое

                LD (IY + FRleState.ThirdCount), #01

                ; настройка экранного адреса перед пиксельными циклами
.PixelBase      INC HL
                LD E, #00
                LD A, (IY + FRleState.FirstThird)
                ADD A, A
                ADD A, A
                ADD A, A
                ADD A, #40
                LD D, A
                LD C, A
                LD B, #01
                BIT RLE_ROW_BIT, (IY + FRleState.Flags)                         ; флаг, поток пикселей обходится горизонтальными строками, при 0 вертикальными блоками
                JR NZ, .CellRow                                                 ; переход, если поток пикселей записан в порядке целых горизонтальных строк

                LD B, #20

                ; обход выбранных третей экранной памяти
.CellRow        PUSH BC
                LD B, (IY + FRleState.ThirdCount)
.CellColumn     PUSH BC
                LD B, #08
.PixelRow       PUSH BC
                LD B, #08
.PixelColumn    PUSH BC
                LD B, #01
                BIT RLE_ROW_BIT, (IY + FRleState.Flags)                         ; флаг, поток пикселей обходится горизонтальными строками, при 0 вертикальными блоками
                JR Z, .SelectStride                                             ; переход, если поток пикселей записан в порядке вертикальных блоков

                LD B, #20
.SelectStride   PUSH DE
.DecodePixel    PUSH BC
                JR .RepeatRun

.NextPixel      POP BC
                INC DE
                DJNZ .DecodePixel

                POP DE
                POP BC
                INC D
                DJNZ .PixelColumn

                LD A, D
                SUB #08
                LD D, A
                LD A, E
                ADD A, #20
                LD E, A
                POP BC
                DJNZ .PixelRow

                LD A, D
                ADD A, #08
                LD D, A
                POP BC
                DJNZ .CellColumn

                LD D, C
                INC E
                POP BC
                DJNZ .CellRow

                LD E, #00
                LD A, #58
                ADD A, (IY + FRleState.FirstThird)
                LD D, A
                LD B, (IY + FRleState.ThirdCount)
                LD C, E
                SET RLE_ATTR_BIT, (IY + FRleState.Flags)                        ; флаг, распаковщик перешёл к линейному выводу атрибутов

                ; после пикселей атрибуты выводятся линейной последовательностью
.LinearPixel    PUSH BC
                JR .RepeatRun

.NextLinear     POP BC
                DEC BC
                INC DE
                LD A, B
                OR C
                JR NZ, .LinearPixel                                             ; переход, если остаются линейные байты атрибутов изображения

                LD (IY + FRleState.FirstThird), #FF
                LD (IY + FRleState.ThirdCount), #FF
                RET

                ; продолжение RLE-серии использует оставшееся число повторов и сохранённый байт
.RepeatRun      BIT RLE_RUN_BIT, (IY + FRleState.Flags)                         ; флаг, продолжается RLE-серия, остаток и повторяемый байт находятся в альтернативных B и C
                JR Z, .ReadByte                                                 ; переход, если предыдущая RLE-серия уже закончилась и нужен следующий байт потока

                EXX
                DEC B
                LD A, C
                EXX
                JR Z, .EndRun                                                   ; переход, если счётчик оставшихся повторов текущей RLE-серии исчерпан

                LD (DE), A
                JR .ContinueRun

.EndRun         RES RLE_RUN_BIT, (IY + FRleState.Flags)                         ; флаг, продолжается RLE-серия, остаток и повторяемый байт находятся в альтернативных B и C

                ; нулевой маркер начинает новую RLE-серию, остальные байты выводятся буквально
.ReadByte       LD A, (HL)
                INC HL
                AND A
                JR NZ, .StoreByte                                               ; переход, если прочитан литерал, а не нулевой маркер RLE-серии

                LD A, (HL)
                EXX
                LD B, A
                EXX
                INC HL
                LD A, (HL)
                EXX
                LD C, A
                EXX
                INC HL
                SET RLE_RUN_BIT, (IY + FRleState.Flags)                         ; флаг, продолжается RLE-серия, остаток и повторяемый байт находятся в альтернативных B и C
.StoreByte      LD (DE), A
.ContinueRun    BIT RLE_ATTR_BIT, (IY + FRleState.Flags)                        ; флаг, распаковщик перешёл к линейному выводу атрибутов
                JR NZ, .NextLinear                                              ; переход, если распаковщик уже перешёл от пикселей к линейным атрибутам

                JR .NextPixel

                DB #08, #10, #11, #12, #12, #14, #00, #03
                DB #00, #01, #02, #01, #00, #03, #00, #0F
                DB #19, #0E, #00, #04, #00, #08, #18, #22
                DB #22
Image01         DW #0C26                                                        ; FPictureHeader.NextOffset, относительная ссылка
.FirstThird     DB #00                                                          ; начальная треть экрана
.ThirdCount     DB #03                                                          ; число третей экрана
.Flags          DB #00                                                          ; порядок обхода и рабочие флаги
                INCBIN "Assets/Screens/Scenes1/01.rle"                          ; исходный поток RLE, включая сохранённый хвост
Image02         DW #0CBC                                                        ; FPictureHeader.NextOffset, относительная ссылка
.FirstThird     DB #00                                                          ; начальная треть экрана
.ThirdCount     DB #03                                                          ; число третей экрана
.Flags          DB #01                                                          ; порядок обхода и рабочие флаги
                INCBIN "Assets/Screens/Scenes1/02.rle"                          ; исходный поток RLE, включая сохранённый хвост
Image03         DW #09EE                                                        ; FPictureHeader.NextOffset, относительная ссылка
.FirstThird     DB #00                                                          ; начальная треть экрана
.ThirdCount     DB #03                                                          ; число третей экрана
.Flags          DB #00                                                          ; порядок обхода и рабочие флаги
                INCBIN "Assets/Screens/Scenes1/03.rle"                          ; исходный поток RLE, включая сохранённый хвост
Image04         DW #090C                                                        ; FPictureHeader.NextOffset, относительная ссылка
.FirstThird     DB #00                                                          ; начальная треть экрана
.ThirdCount     DB #03                                                          ; число третей экрана
.Flags          DB #01                                                          ; порядок обхода и рабочие флаги
                INCBIN "Assets/Screens/Scenes1/04.rle"                          ; исходный поток RLE, включая сохранённый хвост
Image05         DW #0D57                                                        ; FPictureHeader.NextOffset, относительная ссылка
.FirstThird     DB #00                                                          ; начальная треть экрана
.ThirdCount     DB #03                                                          ; число третей экрана
.Flags          DB #00                                                          ; порядок обхода и рабочие флаги
                INCBIN "Assets/Screens/Scenes1/05.rle"                          ; исходный поток RLE, включая сохранённый хвост

                assert $ = #FA64
                endmodule
                endmodule
