; графические данные заставки
; исходный файл каталога 06, смещение #0000
                module Presentation
                org #C000

screen          INCBIN "Assets/Gfx/PRES/PRES_screen.scr"                        ; графический ресурс, исходное смещение #0000
font            INCBIN "Assets/Gfx/PRES/PRES_font.bin"                          ; графический ресурс, исходное смещение #1B00

; -----------------------------------------
; показать вступление, титры со звёздами и проявить титульный экран
; Инициализирует три слова генератора двумя перекрывающимися словами TrDos.DriveModes/#5CC9 и
; значением R,
; продублированным в оба байта. Создаёт 100 различных точек y=0..191, x=0..255 по stars, сравнивая
; каждую новую пару со всеми 100 слотами. Показывает страницы story через StoryPages. Очищает экран,
; запускает звёзды и выводит две группы кредитных строк из credits увеличенным шрифтом. До каждого
; блока выдерживает 50 кадров, после блока 150 кадров, нажатие сокращает ожидание. Затем по одной
; точке на кадр гасит 100 звёзд, очищает экран и за 768 успешных выборов проявляет исходный SCR из
; screen..#DAFF знакоместами в случайном порядке. Клетка считается уже проявленной по ненулевому
; атрибуту. Все 768 исходных атрибутов ненулевые, поэтому при завершении цикла показан весь
; исходный экран. В этой последней фазе любое обнаруженное нажатие завершает показ раньше
; In:
;   банк 4 выбран, PRES загружен по screen, стандартное ПЗУ 48 и разрешённые прерывания для HALT,
;   исходные SCR/шрифт/сценарии внутри файла
; Out:
;   возврат в BL3 после полного либо прерванного проявления, банк 4 остаётся выбранным, IY
;   сохранён
; Corrupt:
;   HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены
; Note:
; экран #4000..#5AFF, CellPos/CellPos.ScatterHigh, операнды
; StoryPages.StoryRow/StoryPages.StoryColour/PlotStar.StarPixelOp, rng..#E7D7
; -----------------------------------------
Present         LD DE, (TrDos.DriveModes)
                LD (rng.SeedA), DE
                LD DE, (TrDos.DriveModes + FWord.High)
                LD (rng.SeedB), DE
                LD A, R
                LD E, A
                LD D, A
                LD (rng.SeedC), DE
                LD IX, stars
                LD B, #64
.ChooseStar     LD DE, #00BF
                CALL RandomRange                                                ; получить псевдослучайное целое от нуля до указанного предела
                LD H, E
                LD DE, #00FF
                CALL RandomRange                                                ; получить псевдослучайное целое от нуля до указанного предела
                LD L, E
                EX DE, HL
                PUSH IX
                LD IX, stars
                LD A, #64
.CheckDuplicate LD L, (IX + FStar.X)
                LD H, (IX + FStar.Y)
                OR A
                SBC HL, DE
                JR NZ, .NextStar                                                ; переход, если координаты новой звезды отличаются от проверяемой записи

                POP IX
                JR .ChooseStar

.NextStar       INC IX
                INC IX
                DEC A
                JR NZ, .CheckDuplicate                                          ; переход, если остаются существующие звёзды для проверки совпадения координат

                POP IX
                LD (IX + FStar.Y), D
                LD (IX + FStar.X), E
                INC IX
                INC IX
                DJNZ .ChooseStar

                CALL StoryPages                                                 ; показать центрированные текстовые страницы предыстории
                LD BC, #0000
                LD DE, #1820
                XOR A
                CALL ClearRect                                                  ; очистить пиксели прямоугольника и задать его атрибуты
                CALL InitStars                                                  ; подготовить атрибуты фона и включить сто звёзд
                LD IX, credits
.CreditPage     LD B, #01
                CALL WaitStars                                                  ; выдержать заданное число секунд с движущимися звёздами
                PUSH IX
.CreditLine     CALL CreditLine                                                 ; показать строку титров увеличенным шрифтом на фоне звёзд
                LD A, (IX + #00)
                CP #FF
                JR NZ, .CreditLine                                              ; переход, если в текущей странице титров остаются строки до маркера #FF

                POP IX
                LD B, #03
                CALL WaitStars                                                  ; выдержать заданное число секунд с движущимися звёздами
.EraseLine      CALL EraseCredit                                                ; стереть строку титров и перейти к следующей записи
                CALL InitStars                                                  ; подготовить атрибуты фона и включить сто звёзд
                LD A, (IX + #00)
                CP #FF
                JR NZ, .EraseLine                                               ; переход, если в текущей странице остаются строки титров для стирания

                INC IX
                LD A, (IX + #00)
                CP #FE
                JR NZ, .CreditPage                                              ; переход, если после страницы не достигнут финальный маркер титров #FE

                LD E, #00
                LD A, #AE
                LD (PlotStar.StarPixelOp), A
.RandomCell     LD HL, stars
                SLA E
                LD D, #00
                ADD HL, DE
                LD B, (HL)
                INC HL
                LD C, (HL)
                CALL PlotStar                                                   ; изменить один звёздный пиксель только в области свободного фона
                HALT
                SRL E
                INC E
                LD A, E
                CP #64
                JR NZ, .RandomCell                                              ; переход, если ещё не выбраны координаты всех 100 звёзд

                LD BC, #0000
                LD DE, #1820
                XOR A
                CALL ClearRect                                                  ; очистить пиксели прямоугольника и задать его атрибуты
                LD BC, #0300
.ScatterLoop    PUSH BC
.ChooseCell     LD DE, #0017
                CALL RandomRange                                                ; получить псевдослучайное целое от нуля до указанного предела
                LD B, E
                LD DE, #001F
                CALL RandomRange                                                ; получить псевдослучайное целое от нуля до указанного предела
                LD C, E
                LD (CellPos), BC
                LD L, B
                LD H, #00
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD B, #00
                ADD HL, BC
                LD BC, Screen.Attributes                                        ; начало видимой области атрибутов Spectrum
                ADD HL, BC
                LD A, (HL)
                OR A
                JR NZ, .ChooseCell                                              ; переход, если случайно выбранное знакоместо уже занято цветом

                LD A, (CellPos.ScatterHigh)
                LD B, A
                LD H, #B8
                LD L, #E0
                INC B
.ScreenRow      LD A, L
                ADD A, #20
                LD L, A
                JR NC, .NextRow                                                 ; переход, если следующая строка знакомест остаётся в текущей трети экрана

                LD A, H
                ADD A, #08
                LD H, A
.NextRow        DJNZ .ScreenRow

                LD A, (CellPos)
                LD C, A
                ADD HL, BC
                PUSH HL
                LD A, H
                SUB #80
                LD H, A
                EX DE, HL
                POP HL
                LD B, #08
.CopyPixel      LD A, (HL)
                LD (DE), A
                INC H
                INC D
                DJNZ .CopyPixel

                LD BC, (CellPos)
                LD L, B
                LD H, #00
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD B, #00
                ADD HL, BC
                LD BC, Presentation.screen + #1800                              ; исходные атрибуты экрана заставки, отступ #1800 после пикселей
                ADD HL, BC
                PUSH HL
                LD A, H
                SUB #80
                LD H, A
                EX DE, HL
                POP HL
                LDI
                POP BC
                CALL PollInput                                                  ; проверить клавиатуру и любой ненулевой ввод Kempston
                JR C, .Return                                                   ; переход, если пользователь прервал эффект рассыпания

                DEC BC
                LD A, B
                OR C
                JR NZ, .ScatterLoop                                             ; переход, если остаются байты эффекта рассыпания

.Return         RET

CellPos         INCBIN "Assets/Gfx/PRES/PRES_cell_position.bin"                 ; графический ресурс, исходное смещение #233D
.ScatterHigh    EQU $ - 1                                                       ; старший байт адреса обхода знакомест
credits         INCBIN "Assets/Gfx/PRES/PRES_credits.bin"                       ; графический ресурс, исходное смещение #233F

; -----------------------------------------
; выдержать заданное число секунд с движущимися звёздами
; Сохраняет IX. Для каждого шага B выполняет до 50 повторов опроса, HALT и обновления звёзд. При
; CF=1 от PollInput выходит сразу. Значение B=0 означает 256 внешних повторов из-за DJNZ. Нажатие
; только завершает эту задержку, вызывающий код вступления не трактует его как выход из всех
; страниц
; In:
;   BC — B число интервалов по 50 прерываний, разрешённые прерывания, массив звёзд stars
; Out:
;   CF=1 при прерывании вводом, CF=0 при окончании задержки. При полном окончании B=0, D=0. HL,
;   IX, IY сохранены
; Corrupt:
;   DE, BC, AF. HL, HL', DE', BC', AF', IX, IY сохранены, внутри DE/BC меняются только D/B
; Note:
;   экран и координаты звёзд через MoveStars
; -----------------------------------------
WaitStars       PUSH IX
.WaitBlock      LD D, #32
.WaitFrame      CALL PollInput                                                  ; проверить клавиатуру и любой ненулевой ввод Kempston
                JR C, .RestoreWait                                              ; переход, если пользователь прервал ожидание со звёздами

                HALT
                CALL MoveStars                                                  ; сдвинуть сто звёзд на один пиксель влево
                DEC D
                JR NZ, .WaitFrame                                               ; переход, если ещё не прошли 50 кадров текущего блока ожидания

                DJNZ .WaitBlock

.RestoreWait    POP IX
                RET

; -----------------------------------------
; показать центрированные текстовые страницы предыстории
; Сканирует поток от story до маркера #B1. После маркера #FF завершает показ, иначе два следующих
; байта задают начальную строку и задержку страницы, они записываются в операнды
; StoryPages.StoryRow/StoryPages.StoryColour.
; Очищает экран с атрибутом #45, рисует звёзды, выдерживает одну секунду. Для каждой строки до CR
; считает число знаков и выбирает столбец floor((32-длина)/2), выводит 8x8 глифы с атрибутом #46
; через PrintCell. Следующий #B1 начинает новую страницу, задержка текущей страницы проходит с
; движением звёзд
; In:
;   PRES в текущем банке, текстовый сценарий story..#EC1E, собственный шрифт font..#E1FF
; Out:
;   IX указывает на завершающий #FF сценария, возврат после всех страниц, IY сохранён
; Corrupt:
;   HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены
; Note:
; экран, StoryPages.StoryRow/StoryPages.StoryColour, звёзды и операнд PlotStar.StarPixelOp через
; помощники
; -----------------------------------------
StoryPages      LD IX, story
.FindPage       LD A, (IX + #00)
                CP #B1
                JR Z, .NextPage                                                 ; переход, если найден маркер начала следующей страницы рассказа

                INC IX
                JR .FindPage

.NextPage       INC IX
                LD A, (IX + #00)
                CP #FF
                RET Z                                                           ; выход, если за маркером страницы расположен конец рассказа #FF

                LD (StoryPages.StoryRow), A
                INC IX
                LD A, (IX + #00)
                LD (StoryPages.StoryColour), A
                INC IX
                LD BC, #0000
                LD DE, #1820
                LD A, #45
                CALL ClearRect                                                  ; очистить пиксели прямоугольника и задать его атрибуты
                CALL InitStars                                                  ; подготовить атрибуты фона и включить сто звёзд
                LD B, #01
                CALL WaitStars                                                  ; выдержать заданное число секунд с движущимися звёздами
.StoryLine      LD A, (IX + #00)
                CP #B1
                JR Z, .WaitPage                                                 ; переход, если достигнут маркер конца текущей страницы рассказа

                PUSH IX
                LD B, #00
.MeasureLine    LD A, (IX + #00)
                CP #0D
                JR Z, .CenterLine                                               ; переход, если найден перевод строки и её длина уже известна

                INC B
                INC IX
                JR .MeasureLine

.CenterLine     POP IX
                LD A, #20
                SUB B
                SRL A
                LD C, A
                LD B, #04
.StoryRow       EQU $ - 1                                                       ; номер строки рассказа
.PrintLine      LD A, (IX + #00)
                CP #0D
                JR Z, .NextLine                                                 ; переход, если напечатан последний символ строки рассказа

                LD D, A
                LD E, #46
                CALL PrintCell                                                  ; вывести один знак предыстории с цветом знакоместа
                INC IX
                INC C
                JR .PrintLine

.NextLine       INC IX
                LD A, (StoryPages.StoryRow)
                INC A
                LD (StoryPages.StoryRow), A
                JR .StoryLine

.WaitPage       LD B, #12
.StoryColour    EQU $ - 1                                                       ; операнд атрибута рассказа
                CALL WaitStars                                                  ; выдержать заданное число секунд с движущимися звёздами
                JR .FindPage

; -----------------------------------------
; вывести один знак предыстории с цветом знакоместа
; CP #20 оставляет пробел без вывода. Для остальных знаков задаёт прямоугольнику 1x1 атрибут #46
; через FillAttrs, затем извлекает D из сохранённой пары DE как код глифа в A и вызывает DrawGlyph.
; Поэтому реальный контракт требует совпадения A и D у обычного вызывающего кода, переданный E не
; определяет цвет. POP AF восстанавливает исходный A и флаги проверки CP #20, но DE после рабочего
; LD DE, #0101 не восстанавливается
; In:
;   DE — D код глифа, BC — строка B и столбец C, AF — A код проверки пробела, в штатном вызове
;   A=D
; Out:
;   при A=#20 экран не меняется. Иначе знак и атрибут #46 записаны, DE=#0101. HL, BC, IX, IY
;   сохранены, A сохранён, F соответствует CP #20
; Corrupt:
;   DE, AF. HL, BC, HL', DE', BC', AF', IX, IY сохранены
; Note:
;   восемь пиксельных байтов и один атрибут экрана
; -----------------------------------------
PrintCell       CP #20
                RET Z                                                           ; выход, если глиф является пробелом и пиксели выводить не требуется

                PUSH HL
                PUSH AF
                PUSH BC
                PUSH DE
                LD DE, #0101
                LD A, #46
                CALL FillAttrs                                                  ; заполнить прямоугольник атрибутов заданным цветом
                POP AF
                POP BC
                CALL DrawGlyph                                                  ; нарисовать собственный 8x8 глиф в экранное знакоместо
                POP AF
                POP HL
                RET

; -----------------------------------------
; нарисовать собственный 8x8 глиф в экранное знакоместо
; Сохраняет HL, DE, BC, AF. Вычисляет исходный указатель #DA00+8*A, поэтому код 32 начинается по
; font. CellAddress получает экранный адрес по BC. Копирует восемь последовательных исходных
; байтов в
; восемь экранных строк с увеличением H. Атрибут здесь не меняет
; In:
;   BC — строка B и столбец C в знакоместах, AF — A код 32..255, шрифт font..#E1FF
; Out:
;   глиф выведен, все основные, альтернативные и индексные регистры сохранены
; Corrupt:
;   Нет, HL, DE, BC, AF, HL', DE', BC', AF', IX, IY сохранены
; Note:
;   восемь пиксельных байтов экрана
; -----------------------------------------
DrawGlyph       PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                LD L, A
                LD H, #00
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD DE, Presentation.font - #0100                                ; смещённая база шрифта, код пробела 32 после умножения на 8 даёт первый глиф по #DB00
                ADD HL, DE
                EX DE, HL
                CALL CellAddress                                                ; вычислить экранный адрес верхней линии знакоместа
                LD B, #08
.GlyphPixelRow  LD A, (DE)
                LD (HL), A
                INC DE
                INC H
                DJNZ .GlyphPixelRow

                POP AF
                POP BC
                POP DE
                POP HL
                RET

; -----------------------------------------
; проверить клавиатуру и любой ненулевой ввод Kempston
; Сохраняет IX, IY, HL, DE, BC, вызывает ROM #028E. При E!=#FF устанавливает CF и возвращает A=E.
; Иначе читает порт #1F, любое ненулевое значение также устанавливает CF. При полном отсутствии
; ввода XOR A даёт A=0, CF=0. Сохранение альтернативных регистров подтверждено статическим обходом
; реально вызываемого ROM KEY-SCAN, EXX/EX AF, AF' там не используются
; In:
;   стандартное ПЗУ 48, клавиатура и порт Kempston #1F
; Out:
;   CF=1 при обнаруженном вводе, A код клавиши либо байт порта. CF=0, A=0 при отсутствии ввода.
;   HL, DE, BC, IX, IY сохранены
; Corrupt:
;   AF. HL, DE, BC, HL', DE', BC', AF', IX, IY сохранены
; Note:
;   чтение портов ввода
; -----------------------------------------
PollInput       PUSH IX
                PUSH IY
                PUSH HL
                PUSH DE
                PUSH BC
                CALL Rom.ScanKeys                                               ; сканер клавиатуры ROM, E=#FF означает отсутствие клавиши
                LD A, E
                CP #FF
                JR NZ, .InputReady                                              ; переход, если ПЗУ обнаружило нажатую клавишу

                IN A, (#1F)
                OR A
                JR NZ, .InputReady                                              ; переход, если Kempston сообщил хотя бы одну нажатую кнопку

                XOR A
                JR .RestoreInput

.InputReady     SCF
.RestoreInput   POP BC
                POP DE
                POP HL
                POP IY
                POP IX
                RET

; -----------------------------------------
; показать строку титров увеличенным шрифтом на фоне звёзд
; Читает атрибут из IX+0, столбец из IX+1, строку из IX+2, затем знаки с IX+3 до нуля. Каждый знак
; передаёт LargeGlyph, после него обновляет звёзды и увеличивает C. IX продвигается по строке, после
; терминатора становится началом следующей записи формата [attr, x, y, text, 0]. Внешние HL, DE,
; BC, AF восстанавливает
; In:
;   IX — строка сценария титров [атрибут, x, y, ASCII-строка, 0], массив звёзд и собственный
;   шрифт
; Out:
;   IX — следующая запись, HL, DE, BC, AF, IY сохранены
; Corrupt:
;   IX. HL, DE, BC, AF, HL', DE', BC', AF', IY сохранены
; Note:
;   экран, координаты звёзд и PlotStar.StarPixelOp через MoveStars
; -----------------------------------------
CreditLine      PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                LD D, (IX + FCreditLine.Attribute)
                LD C, (IX + FCreditLine.X)
                LD B, (IX + FCreditLine.Y)
.CreditGlyph    LD A, (IX + FCreditLine)
                OR A
                JR Z, .NextCredit                                               ; переход, если текущая строка титров закончилась нулевым байтом

                LD E, A
                CALL LargeGlyph                                                 ; нарисовать глиф титров с масштабом два по горизонтали и три по вертикали
                CALL MoveStars                                                  ; сдвинуть сто звёзд на один пиксель влево
                INC C
                INC IX
                JR .CreditGlyph

.NextCredit     INC IX
                INC IX
                INC IX
                INC IX
                POP AF
                POP BC
                POP DE
                POP HL
                RET

; -----------------------------------------
; стереть строку титров и перейти к следующей записи
; Считывает столбец и строку увеличенного текста. Считает знаки включая завершающий нуль,
; преобразует область в знакоместа x=2*C, y=3*B, ширина=2*(длина+1), высота=3. Очищает пиксели и
; задаёт атрибут #45 через ClearRect. IX становится началом следующей записи, основные регистры
; восстанавливаются
; In:
;   IX — запись титров [attr, x, y, text, 0]
; Out:
;   IX — следующая запись, HL, DE, BC, AF, IY сохранены
; Corrupt:
;   IX. HL, DE, BC, AF, HL', DE', BC', AF', IY сохранены
; Note:
;   прямоугольник экрана, на один увеличенный знак шире исходной строки
; -----------------------------------------
EraseCredit     PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                LD C, (IX + FCreditLine.X)
                LD B, (IX + FCreditLine.Y)
                LD E, #00
.SkipCredit     INC E
                INC IX
                LD A, (IX + FCreditLine - 1)
                OR A
                JR NZ, .SkipCredit                                              ; переход, если ещё не найден нулевой терминатор стираемой строки титров

                INC IX
                INC IX
                INC IX
                SLA E
                LD D, #03
                SLA C
                LD A, B
                SLA A
                ADD A, B
                LD B, A
                LD A, #45
                CALL ClearRect                                                  ; очистить пиксели прямоугольника и задать его атрибуты
                POP AF
                POP BC
                POP DE
                POP HL
                RET

; -----------------------------------------
; заполнить прямоугольник атрибутов заданным цветом
; Вычисляет #5800+32*B+C, затем D строк по E байтов заполняет A с шагом 32 между строками.
; Сохраняет HL, но BC используется рабочим счётчиком и адресным шагом. Нулевые D/E оборачивают
; DJNZ, поэтому штатные размеры должны быть ненулевыми
; In:
;   DE — D высота, E ширина в знакоместах, BC — строка B и столбец C, AF — A атрибут
; Out:
;   прямоугольник атрибутов заполнен, HL, DE, A, IX, IY сохранены
; Corrupt:
;   BC, AF. HL, DE, HL', DE', BC', AF', IX, IY сохранены, внутри AF меняется F
; Note:
;   атрибуты экрана
; -----------------------------------------
FillAttrs       PUSH HL
                LD H, #00
                LD L, B
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD B, #00
                ADD HL, BC
                LD BC, Screen.Attributes                                        ; начало видимой области атрибутов Spectrum
                ADD HL, BC
                LD B, D
.AttrRow        PUSH BC
                PUSH HL
                LD B, E
.AttrColumn     LD (HL), A
                INC HL
                DJNZ .AttrColumn

                POP HL
                LD BC, #0020
                ADD HL, BC
                POP BC
                DJNZ .AttrRow

                POP HL
                RET

; -----------------------------------------
; очистить пиксели прямоугольника и задать его атрибуты
; Через CellAddress находит начало прямоугольника. Для каждой строки знакомест очищает восемь
; пиксельных
; линий по E байтов, затем переходит к следующей строке с учётом нелинейной памяти Spectrum.
; Восстанавливает параметры и вызывает FillAttrs для заполнения атрибутов. HL и DE восстанавливает,
; BC/F остаются результатом FillAttrs
; In:
;   DE — D высота, E ширина в знакоместах, BC — строка B и столбец C, AF — A атрибут, размеры
;   ненулевые
; Out:
;   пиксели обнулены, атрибуты заданы, HL, DE, A, IX, IY сохранены
; Corrupt:
;   BC, AF. HL, DE, HL', DE', BC', AF', IX, IY сохранены, внутри AF меняется F
; Note:
;   пиксели и атрибуты указанного прямоугольника
; -----------------------------------------
ClearRect       PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                CALL CellAddress                                                ; вычислить экранный адрес верхней линии знакоместа
                LD B, D
.CellRow        PUSH HL
                PUSH BC
                LD B, #08
.ClearPixelRow  PUSH HL
                PUSH BC
                LD B, E
.ClearBytes     LD (HL), #00
                INC HL
                DJNZ .ClearBytes

                POP BC
                POP HL
                INC H
                DJNZ .ClearPixelRow

                POP BC
                POP HL
                LD A, L
                ADD A, #20
                LD L, A
                JR NC, .NextCellRow                                             ; переход, если следующая строка знакомест остаётся в текущей трети экрана

                LD A, H
                ADD A, #08
                LD H, A
.NextCellRow    DJNZ .CellRow

                POP AF
                POP BC
                POP DE
                CALL FillAttrs                                                  ; заполнить прямоугольник атрибутов заданным цветом
                POP HL
                RET

; -----------------------------------------
; вычислить экранный адрес верхней линии знакоместа
; Из символьной строки B формирует раздельные части адреса Spectrum, затем прибавляет столбец C.
; Эквивалентный адрес #4000+((B AND #18)*256)+((B AND7)*32)+C. BC явно сохраняется через стек
; In:
;   BC — строка B=0..23 и столбец C=0..31
; Out:
;   HL — адрес первой пиксельной линии знакоместа, DE, BC, IX, IY сохранены
; Corrupt:
;   HL, AF. DE, BC, HL', DE', BC', AF', IX, IY сохранены
; Note:
;   нет записей вне стека
; -----------------------------------------
CellAddress     PUSH BC
                LD HL, #0800
                LD A, B
                SRL A
                RR L
                SRL A
                RR L
                SRL A
                RR L
                OR H
                RLCA
                RLCA
                RLCA
                LD H, A
                LD B, #00
                ADD HL, BC
                POP BC
                RET

; -----------------------------------------
; подготовить атрибуты фона и включить сто звёзд
; Сохраняет все основные регистры. Заменяет opcode по PlotStar.StarPixelOp на #B6, то есть OR
; (HL). Заполняет все
; 768 атрибутов значением #45 и проходит 100 пар y, x по stars, включая каждую точку через PlotStar.
; Пиксельную память не очищает, координаты не меняет
; In:
;   массив 100 пар y, x по stars..#E7D7, координаты в пределах экрана
; Out:
;   звёзды включены на фоне атрибута #45, все основные, альтернативные и индексные регистры
;   сохранены
; Corrupt:
;   Нет, HL, DE, BC, AF, HL', DE', BC', AF', IX, IY сохранены
; Note:
;   #5800..#5AFF=#45, звёздные пиксели, opcode PlotStar.StarPixelOp=#B6
; -----------------------------------------
InitStars       PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                LD A, #B6
                LD (PlotStar.StarPixelOp), A
                LD HL, Screen.Attributes                                        ; начало видимой области атрибутов Spectrum
                LD DE, Screen.Attributes + 1                                    ; следующий байт атрибутов для размножения заполнителя
                LD (HL), #45
                LD BC, #02FF
                LDIR
                LD HL, stars
                LD D, #64
.InitStarLoop   LD B, (HL)
                INC HL
                LD C, (HL)
                INC HL
                CALL PlotStar                                                   ; изменить один звёздный пиксель только в области свободного фона
                DEC D
                JR NZ, .InitStarLoop                                            ; переход, если остаются звёзды для начального вывода

                POP AF
                POP BC
                POP DE
                POP HL
                RET

; -----------------------------------------
; сдвинуть сто звёзд на один пиксель влево
; Выбирает XOR (HL) кодом #AE по PlotStar.StarPixelOp. Для каждой пары y, x переключает старый
; пиксель, уменьшает
; x как восьмибитное число с переходом 0->255, записывает его обратно и переключает новый пиксель.
; PlotStar пропускает точки под атрибутами отличными от #45. Сохраняет все основные регистры
; In:
;   массив звёзд stars..#E7D7 и экран
; Out:
;   все 100 координат x уменьшены по модулю 256, основные, альтернативные и индексные регистры
;   сохранены
; Corrupt:
;   Нет, HL, DE, BC, AF, HL', DE', BC', AF', IX, IY сохранены
; Note:
;   каждый второй байт массива stars..#E7D7, пиксели звёзд, opcode PlotStar.StarPixelOp=#AE
; -----------------------------------------
MoveStars       PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                LD A, #AE
                LD (PlotStar.StarPixelOp), A
                LD HL, stars
                LD D, #64
.MoveStarLoop   LD B, (HL)
                INC HL
                LD C, (HL)
                CALL PlotStar                                                   ; изменить один звёздный пиксель только в области свободного фона
                DEC C
                LD (HL), C
                CALL PlotStar                                                   ; изменить один звёздный пиксель только в области свободного фона
                INC HL
                DEC D
                JR NZ, .MoveStarLoop                                            ; переход, если остаются звёзды для сдвига на один пиксель

                POP AF
                POP BC
                POP DE
                POP HL
                RET

; -----------------------------------------
; изменить один звёздный пиксель только в области свободного фона
; Проверяет атрибут знакоместа по пиксельным координатам, при значении неравном #45 выходит без
; вывода. Вычисляет нелинейный экранный адрес и маску #80>>(C AND7). Самомодифицируемая инструкция
; PlotStar.StarPixelOp либо OR-включает, либо XOR-переключает пиксель. HL, BC, AF сохраняются,
; DE не используется
; In:
;   BC — пиксельные y=B, x=C, opcode PlotStar.StarPixelOp=#B6 для OR или #AE для XOR
; Out:
;   при атрибуте #45 точка обработана, все основные, альтернативные и индексные регистры
;   сохранены
; Corrupt:
;   Нет, HL, DE, BC, AF, HL', DE', BC', AF', IX, IY сохранены
; Note:
;   один пиксель экрана при разрешающем атрибуте
; -----------------------------------------
PlotStar        PUSH HL
                PUSH BC
                PUSH AF
                LD H, #00
                LD L, B
                SRL L
                SRL L
                SRL L
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD A, C
                SRL A
                SRL A
                SRL A
                ADD A, L
                LD L, A
                LD A, H
                ADD A, #58
                LD H, A
                LD A, (HL)
                CP #45
                JR NZ, .RestorePlot                                             ; переход, если атрибут знакоместа запрещает рисовать на нём звёздный пиксель

                LD HL, #0200
                SLA B
                RL H
                SLA B
                RL H
                LD A, B
                AND #E0
                LD L, A
                LD A, B
                RRCA
                RRCA
                AND #07
                SLA H
                SLA H
                SLA H
                OR H
                LD H, A
                LD A, C
                AND #07
                SRL C
                SRL C
                SRL C
                LD B, #00
                ADD HL, BC
                INC A
                LD B, A
                XOR A
                SCF
.ShiftStarBit   RRA
                DJNZ .ShiftStarBit

                XOR (HL)
.StarPixelOp    EQU $ - 1                                                       ; код операции со звёздным пикселем, #B6 OR либо #AE XOR
                LD (HL), A
.RestorePlot    POP AF
                POP BC
                POP HL
                RET

; -----------------------------------------
; получить псевдослучайное целое от нуля до указанного предела
; Три слова состояния по rng.SeedA, rng.SeedB, rng.SeedC переходят из (s0, s1, s2) в (s1, s2,
; ROL16(s0+s1+s2,
; 1)), сложение модульное 16 битное. Новое третье слово становится множителем BC. Побитное
; умножение этого слова на исходный предел DE формирует 32 битный результат, возврат — старшее
; слово с округлением вверх при бите 15 младшего слова. Формула round(limit*randomWord/65536),
; диапазон 0..limit включительно. Слово предела по rng разрушается сдвигами
; In:
;   DE — верхний предел, три слова состояния rng.SeedA..#E65D
; Out:
;   DE — целое 0..исходного DE, HL, BC, AF, IX, IY сохранены
; Corrupt:
;   DE. HL, BC, AF, HL', DE', BC', AF', IX, IY сохранены
; Note:
;   rng..#E65D
; -----------------------------------------
RandomRange     PUSH HL
                PUSH BC
                PUSH AF
                PUSH IX
                LD (rng), DE
                LD BC, (rng.SeedA)
                LD HL, (rng.SeedB)
                LD (rng.SeedA), HL
                ADD HL, BC
                LD C, L
                LD B, H
                LD HL, (rng.SeedC)
                LD (rng.SeedB), HL
                ADD HL, BC
                SLA L
                RL H
                JR NC, .StoreSeed                                               ; переход, если циклический сдвиг слова генератора не требует переноса в младший бит

                SET RNG_FEED_BIT, L                                             ; младший разряд слова состояния, принимает перенос при циклическом сдвиге суммы генератора
.StoreSeed      LD (rng.SeedC), HL
                LD C, L
                LD B, H
                LD IX, rng
                LD HL, #0000
                LD DE, #0000
                LD A, #10
.MultiplyBit    SLA (IX + FWord.Low)
                RL (IX + FWord.High)
                JR NC, .ShiftProduct                                            ; переход, если текущий бит предела равен нулю и множимое добавлять не нужно

                ADD HL, BC
                JR NC, .ShiftProduct                                            ; переход, если прибавление множимого не переполнило младшее слово произведения

                INC DE
.ShiftProduct   DEC A
                JR Z, .RoundResult                                              ; переход, если обработаны все 16 бит предела случайного числа

                SLA L
                RL H
                RL E
                RL D
                JR .MultiplyBit

.RoundResult    BIT RNG_ROUND_BIT, H                                            ; старший разряд дробной части произведения, 1 требует округления масштабированного случайного числа вверх
                JR Z, .RestoreRandom                                            ; переход, если дробная часть произведения меньше половины и округление не требуется

                INC DE
.RestoreRandom  POP IX
                POP AF
                POP BC
                POP HL
                RET

rng             INCBIN "Assets/Gfx/PRES/PRES_rng.bin"                           ; графический ресурс, исходное смещение #2656
.SeedA          EQU $ - 6                                                       ; первое слово состояния генератора
.SeedB          EQU $ - 4                                                       ; второе слово состояния генератора
.SeedC          EQU $ - 2                                                       ; третье слово состояния генератора

; -----------------------------------------
; нарисовать глиф титров с масштабом два по горизонтали и три по вертикали
; По D задаёт цвет прямоугольнику 2x3 атрибута с началом (2*C, 3*B). Исходный глиф берёт по
; #DA00+8*E. Каждую из восьми строк ExpandBits разворачивает в 16 бит, затем LargeRow записывает
; её три
; раза в последовательные экранные строки. Получается 16x24 пикселя. Сохраняет HL, DE, BC, AF, IX,
; IY не использует
; In:
;   DE — D атрибут, E код глифа 32..255, BC — координаты увеличенной сетки x=C, y=B, вся область
;   должна помещаться на экране
; Out:
;   глиф 16x24 и шесть атрибутов выведены, основные, альтернативные и индексные регистры
;   сохранены
; Corrupt:
;   Нет, HL, DE, BC, AF, HL', DE', BC', AF', IX, IY сохранены
; Note:
;   16x24 пикселя и 2x3 атрибута экрана
; -----------------------------------------
LargeGlyph      PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH IX
                PUSH DE
                LD A, B
                SLA A
                ADD A, B
                LD H, #00
                LD L, A
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD A, C
                SLA A
                ADD A, L
                LD L, A
                LD A, H
                ADD A, #58
                LD H, A
                PUSH HL
                POP IX
                LD (IX + #00), D
                LD (IX + Screen.PairRight), D
                LD (IX + Screen.RowBytes), D
                LD (IX + Screen.RowBytes + Screen.PairRight), D
                LD (IX + Screen.RowBytes + Screen.RowBytes), D
                LD (IX + Screen.RowBytes + Screen.RowBytes + Screen.PairRight), D
                LD A, B
                RLCA
                ADD A, B
                LD B, A
                SLA C
                LD HL, #0800
                LD A, B
                SRL A
                RR L
                SRL A
                RR L
                SRL A
                RR L
                OR H
                RLCA
                RLCA
                RLCA
                LD H, A
                LD B, #00
                ADD HL, BC
                PUSH HL
                POP IX
                POP HL
                LD H, #00
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD BC, Presentation.font - #0100                                ; смещённая база шрифта, код пробела 32 после умножения на 8 даёт первый глиф по #DB00
                ADD HL, BC
                LD B, #08
.LargeGlyphRow  LD A, (HL)
                CALL ExpandBits                                                 ; удвоить каждый бит восьмибитной строки в шестнадцатибитную
                CALL LargeRow                                                   ; записать шестнадцать пикселей и перейти к следующей экранной строке
                CALL LargeRow                                                   ; записать шестнадцать пикселей и перейти к следующей экранной строке
                CALL LargeRow                                                   ; записать шестнадцать пикселей и перейти к следующей экранной строке
                INC HL
                DJNZ .LargeGlyphRow

                POP IX
                POP AF
                POP BC
                POP DE
                POP HL
                RET

; -----------------------------------------
; записать шестнадцать пикселей и перейти к следующей экранной строке
; Записывает D в (IX), E в (IX+1). Затем с учётом нелинейной адресации Spectrum переносит IX на
; следующую пиксельную строку, переходя через границу восьми линий и через экранную треть. HL явно
; сохраняет
; In:
;   DE — два байта пикселей слева направо, IX — экранный адрес первой половины строки
; Out:
;   IX — тот же столбец следующей пиксельной строки, HL, DE, BC, IY сохранены
; Corrupt:
;   AF, IX. HL, DE, BC, HL', DE', BC', AF', IY сохранены
; Note:
;   два пиксельных байта экрана
; -----------------------------------------
LargeRow        LD (IX + #00), D
                LD (IX + Screen.PairRight), E
                PUSH HL
                PUSH IX
                POP HL
                LD A, H
                AND #07
                CP #07
                JR Z, .NextScreenRow                                            ; переход, если достигнута восьмая пиксельная строка знакоместа

                INC H
                JR .RestoreLarge

.NextScreenRow  LD A, H
                AND #F8
                LD H, A
                LD A, L
                ADD A, #20
                LD L, A
                JR NC, .RestoreLarge                                            ; переход, если следующая строка знакомест не пересекла границу трети экрана

                LD A, H
                ADD A, #08
                LD H, A
.RestoreLarge   PUSH HL
                POP IX
                POP HL
                RET

; -----------------------------------------
; удвоить каждый бит восьмибитной строки в шестнадцатибитную
; Восемь раз сдвигает DE на два бита и циклически читает очередной старший бит A. Для
; установленного бита выставляет оба младших бита E. Старые биты DE полностью вытесняются за 16
; сдвигов. Восемь RLCA возвращают исходный A, BC явно восстанавливается
; In:
;   AF — A исходный байт пиксельной строки
; Out:
;   DE — удвоенная 16 битная строка, A и BC сохранены
; Corrupt:
;   DE, AF. HL, BC, HL', DE', BC', AF', IX, IY сохранены, внутри AF меняется F
; Note:
;   нет записей вне стека
; -----------------------------------------
ExpandBits      PUSH BC
                LD B, #08
.ExpandBit      SLA E
                RL D
                SLA E
                RL D
                RLCA
                JR NC, .NextExpandBit                                           ; переход, если очередной исходный пиксель погашен и удвоенная пара остаётся нулевой

                SET PIX_PAIR_LO_BIT, E                                          ; младший пиксель удвоенной пары при горизонтальном увеличении глифа
                SET PIX_PAIR_HI_BIT, E                                          ; старший пиксель удвоенной пары при горизонтальном увеличении глифа
.NextExpandBit  DJNZ .ExpandBit

                POP BC
                RET

stars           INCBIN "Assets/Gfx/PRES/PRES_stars.bin"                         ; графический ресурс, исходное смещение #2710
story           INCBIN "Assets/Gfx/PRES/PRES_story.bin"                         ; графический ресурс, исходное смещение #27D8

                assert $ = #EC1F
                endmodule
