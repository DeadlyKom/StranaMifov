; AY-плеер и музыкальный модуль меню
; исходный файл каталога 02, смещение #1800
                module Music
                module Menu
                org #E000

; -----------------------------------------
; внешний вход запуска музыки скрытого меню
; Задаёт адрес встроенного музыкального модуля WriteAY.SongData и переходит к общему инициализатору.
; In:
;   нет явных аргументов
; Out:
;   плеер инициализирован, EI
; Corrupt:
;   HL, DE, BC, AF, IX согласно последующим вызовам
; Note:
;   состояние плеера и AY
; -----------------------------------------
InitMenuMusic   LD HL, WriteAY.SongData
                JP InitPlayer

; -----------------------------------------
; внешний вход одного тика AY-проигрывателя
; Переходит к TickPlayer. Вызывается один раз на прерывание из #6429.
; In:
;   нет регистровых аргументов, плеер ранее инициализирован через InitMenuMusic/InitPlayer, состояние
; InitPlayer.PositionTable..InitPlayer.EnvelopeShape и музыкальные потоки доступны по
; сохранённым указателям
; Out:
;   следующий музыкальный кадр рассчитан и передан AY, HL', DE', BC', AF', IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены
; Note:
;   состояние плеера, AY
; -----------------------------------------
TickMenuMusic   JP TickPlayer

; -----------------------------------------
; инициализация проигрывателя по адресу модуля
; Запрещает прерывания. Читает темп, относительные смещения таблиц позиций, семплов и паттернов,
; сохраняет базу модуля в операнде RelocatePtr.ModuleBase. Обнуляет состояния трёх каналов и
; регистров AY, выбирает
; начальные семплы/орнаменты по таблицам, устанавливает счётчик тика 1, выводит нулевое состояние
; AY и разрешает прерывания.
; In:
;   HL — музыкальный модуль
; Out:
;   инициализированы три канала, EI
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   InitPlayer.PositionTable..InitPlayer.EnvelopeShape, RelocatePtr.ModuleBase
; -----------------------------------------

                ; относительные смещения таблиц переводятся в адреса текущего музыкального модуля
InitPlayer      DI
                LD A, (HL)
                LD (InitPlayer.Tempo), A
                LD (RelocatePtr.ModuleBase), HL
                INC HL
                CALL ReadRelPointer                                             ; чтение относительного указателя музыкального модуля
                LD A, (DE)
                INC DE
                INC A
                LD (InitPlayer.PositionCount), A
                LD (InitPlayer.PositionTable), DE
                CALL ReadRelPointer                                             ; чтение относительного указателя музыкального модуля
                LD (InitPlayer.OrnamentTable), DE
                PUSH DE
                CALL ReadRelPointer                                             ; чтение относительного указателя музыкального модуля
                LD (InitPlayer.PatternTable), DE
                LD HL, #001B
                CALL RelocatePtr                                                ; преобразование относительного смещения в абсолютный адрес
                EX DE, HL
                LD (InitPlayer.SampleTable), HL
                LD HL, InitPlayer.InitDummy
                LD (InitPlayer.PatternA), HL
                LD HL, InitPlayer.ChannelA
                LD DE, Music.Menu.InitPlayer.ChannelA + FMusicChannel.Duration  ; следующий байт после первого состояния канала, используется очисткой состояний проигрывателя
                LD BC, #002C
                LD (HL), B
                LDIR
                POP HL
                LD BC, #0021
                XOR A
                CALL FindTableEntry                                             ; поиск записи с заданным первым байтом в таблице фиксированного шага
                DEC A
                LD (InitPlayer.RemainingA), A
                LD (InitPlayer.RemainingB), A
                LD (InitPlayer.RemainingC), A
                LD A, #01
                LD (InitPlayer.TickLeft), A
                INC HL
                LD (InitPlayer.OrnamentA), HL
                LD (InitPlayer.OrnamentB), HL
                LD (InitPlayer.OrnamentC), HL
                CALL WriteAY                                                    ; передача буфера регистров в AY
                EI
                RET

.PositionTable  DW #F177                                                        ; адрес таблицы позиций композиции
.OrnamentTable  DW #F18F                                                        ; адрес таблицы орнаментов
.PatternTable   DW #F213                                                        ; адрес таблицы паттернов
.SampleTable    DW #EE5E                                                        ; адрес таблицы семплов
.Tempo          DB #06                                                          ; число тиков на музыкальную строку
.TickLeft       DB #04                                                          ; тики до следующей музыкальной строки
.PositionCount  DB #0C                                                          ; число позиций композиции
.PatternA       DW #F263                                                        ; поток команд паттерна канала A
.PatternB       DW #F2A4                                                        ; поток команд паттерна канала B
.PatternC       DW #F2CF                                                        ; поток команд паттерна канала C
.InitDummy      DB #FF                                                          ; байт перед блоком сбрасываемого состояния
.ChannelA       DB #00                                                          ; начало состояния канала A
                DB #00
.ChannelAStep   DB #03                                                          ; поле Step канала A, рабочая база IX
                DB #3C, #00
.SampleA        DW #EE5F                                                        ; адрес текущего семпла канала A
.OrnamentA      DW #F190                                                        ; адрес текущего орнамента канала A
.RemainingA     DB #1D                                                          ; остаток семпла канала A, #FF канал выключен
                DB #02, #01
.ChannelBStep   DB #03                                                          ; поле Step канала B, рабочая база IX
                DB #1C, #01
.SampleB        DW #EF25                                                        ; адрес текущего семпла канала B
.OrnamentB      DW #F190                                                        ; адрес текущего орнамента канала B
.RemainingB     DB #1D                                                          ; остаток семпла канала B, #FF канал выключен
                DB #00, #3F
.ChannelCStep   DB #00                                                          ; поле Step канала C, рабочая база IX
                DB #00, #27
.SampleC        DW #0000                                                        ; адрес текущего семпла канала C
.OrnamentC      DW #F190                                                        ; адрес текущего орнамента канала C
.RemainingC     DB #FF                                                          ; остаток семпла канала C, #FF канал выключен
.PositionIndex  DB #01                                                          ; индекс следующей позиции композиции
.ToneA          DW #0077                                                        ; AY0..1, период тона A
.ToneB          DW #02F2                                                        ; AY2..3, период тона B
.ToneC          DW #0000                                                        ; AY4..5, период тона C
.Noise          DB #00                                                          ; AY6, период шума
.Mixer          DB #11                                                          ; AY7, маски выключения тона и шума
.VolumeA        DB #08                                                          ; AY8, громкость и огибающая A
.VolumeB        DB #14                                                          ; AY9, громкость и огибающая B
.VolumeC        DB #00                                                          ; AY10, громкость и огибающая C
.Envelope       DB #18                                                          ; AY11..12, период аппаратной огибающей
                DB #00
.EnvelopeShape  DB #00                                                          ; AY13, форма огибающей, 0 запрещает её повторную запись

; -----------------------------------------
; поиск записи с заданным первым байтом в таблице фиксированного шага
; Сравнивает A с (HL), при несовпадении прибавляет BC и повторяет. Ограничение длины таблицы
; отсутствует.
; In:
;   A — ключ, HL — начало, BC — шаг
; Out:
;   HL — совпавшая запись, Z=1
; Corrupt:
;   HL, AF
; -----------------------------------------
FindTableEntry  CP (HL)
                RET Z                                                           ; выход, если найден дескриптор с требуемым номером

                ADD HL, BC
                JP FindTableEntry

; -----------------------------------------
; чтение относительного указателя музыкального модуля
; Берёт little-endian слово из (HL), увеличивает исходный HL на 2, прибавляет к слову базу модуля
; через RelocatePtr.
; In:
;   HL — адрес относительного слова
; Out:
;   DE — абсолютный указатель, HL — следующие данные
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
ReadRelPointer  LD E, (HL)
                INC HL
                LD D, (HL)
                INC HL
                EX DE, HL

; -----------------------------------------
; преобразование относительного смещения в абсолютный адрес
; Прибавляет к HL базовый адрес из самомодифицируемого операнда RelocatePtr.ModuleBase и меняет
; HL с DE.
; In:
;   HL — смещение, DE — сохраняемое значение
; Out:
;   DE — абсолютный адрес, HL — прежний DE
; Corrupt:
;   HL, DE, BC, AF
; -----------------------------------------
RelocatePtr     LD BC, #EE43
.ModuleBase     EQU $ - 2                                                       ; операнд базового адреса музыкального модуля
                ADD HL, BC
                EX DE, HL
                RET

; -----------------------------------------
; разбор трёхбайтового шага музыкального семпла
; Прибавляет 3*A к IX. Из трёх байтов извлекает амплитуду, величину и знак тонового смещения,
; пятибитовый параметр шума, флаги отключения тона и шума. Конкретная разметка следует битам
; команд, название формата по одному коду не подтверждено.
; In:
;   IX — семпл, A — номер шага
; Out:
;   L — амплитуда 0..15, DE — тоновое смещение с признаком знака в bit 4 D, H — параметр шума, C
;   — маска отключения шума, B — маска отключения тона
; Corrupt:
;   HL, DE, BC, AF, IX
; -----------------------------------------
ReadSampleStep  LD D, #00
                LD E, A
                ADD A, A
                ADD A, E
                LD E, A
                ADD IX, DE
                LD A, (IX + FSampleStep.NoiseAndFlags)
                BIT SMP_MUTE_N_BIT, A                                           ; флаг, шум текущего канала отключён шагом семпла
                LD C, #10
                JP NZ, .ToneDisable                                             ; переход, если в шаге семпла установлен запрет шума

                LD C, D

                ; бит 6 семпла задаёт отключение тона канала, пятибитовый период шума
                ; обрабатывается отдельно
.ToneDisable    BIT SMP_MUTE_T_BIT, A                                           ; флаг, тон текущего канала отключён шагом семпла
                LD B, #02
                JP NZ, .NoisePeriod                                             ; переход, если в шаге семпла установлен запрет тона

                LD B, D
.NoisePeriod    AND #1F
                LD H, A
                LD E, (IX + FSampleStep.ToneLow)
                LD A, (IX + FSampleStep.ToneAndVolume)
                PUSH AF
                AND #F0
                RRCA
                RRCA
                RRCA
                RRCA
                LD D, A
                POP AF
                AND #0F
                LD L, A
                BIT SMP_ADD_BIT, (IX + FSampleStep.NoiseAndFlags)               ; флаг, смещение семпла прибавляется к периоду ноты, при 0 вычитается
                RET Z                                                           ; выход, если смещение периода семпла не требует положительного знака

                SET SLIDE_ADD_BIT, D                                            ; флаг, упакованное смещение периода в D положительное, снимается перед ADD HL,DE
                RET

; -----------------------------------------
; переход на следующую позицию композиции
; Берёт индекс InitPlayer.PositionIndex, при достижении числа позиций InitPlayer.PositionCount
; возвращает его к 0. По таблице позиций
; получает номер паттерна и транспозицию, находит семибайтовый дескриптор паттерна и вычисляет три
; указателя каналов.
; In:
;   таблицы InitPlayer.PositionTable/InitPlayer.PatternTable и индекс InitPlayer.PositionIndex
; Out:
; обновлены InitPlayer.PatternA/InitPlayer.PatternB/InitPlayer.PatternC и транспозиция
; CalcTonePeriod.Transpose
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   индекс позиции и указатели паттерна
; -----------------------------------------
NextPattern     LD A, (InitPlayer.PositionIndex)
                LD C, A
                LD HL, InitPlayer.PositionCount
                CP (HL)
                JP C, .PositionIndex                                            ; переход, если индекс позиции ещё меньше длины композиции

                XOR A
                LD C, A

                ; позиция композиции циклически возвращается к началу, затем выбираются три
                ; потока команд
.PositionIndex  INC A
                LD (InitPlayer.PositionIndex), A
                LD L, C
                LD H, #00
                ADD HL, HL
                LD DE, (InitPlayer.PositionTable)
                ADD HL, DE
                LD C, (HL)
                INC HL
                LD A, (HL)
                LD (CalcTonePeriod.Transpose), A
                LD A, C
                LD HL, (InitPlayer.PatternTable)
                LD BC, #0007
                CALL FindTableEntry                                             ; поиск записи с заданным первым байтом в таблице фиксированного шага
                INC HL
                CALL ReadRelPointer                                             ; чтение относительного указателя музыкального модуля
                LD (InitPlayer.PatternA), DE
                CALL ReadRelPointer                                             ; чтение относительного указателя музыкального модуля
                LD (InitPlayer.PatternB), DE
                CALL ReadRelPointer                                             ; чтение относительного указателя музыкального модуля
                LD (InitPlayer.PatternC), DE
                RET

; -----------------------------------------
; обновление задержки чтения команд канала
; Уменьшает IX+2. Пока значение неотрицательно, возвращается. При переходе через ноль загружает
; IX-1, оставляя флаг знака от DEC для вызывающего кода.
; In:
;   IX — состояние канала
; Out:
;   S=1 означает наступление чтения новой команды
; Corrupt:
;   AF
; Note:
;   IX+2
; -----------------------------------------
StepDuration    DEC (IX + FMusicChannel.Wait - FMusicChannel.Step)
                RET P                                                           ; выход, если задержка до новой команды канала ещё не истекла

                LD A, (IX + FMusicChannel.Duration - FMusicChannel.Step)
                LD (IX + FMusicChannel.Wait - FMusicChannel.Step), A
                RET

; -----------------------------------------
; один временной шаг композиции
; Уменьшает общий счётчик тиков. Когда он равен нулю, восстанавливает темп и обновляет команды
; трёх каналов. В первом канале #FF запускает следующую позицию композиции. Затем в любом случае
; рассчитывает состояния семплов и регистры AY через BuildAYState.
; In:
;   состояние InitPlayer.PositionTable..InitPlayer.EnvelopeShape
; Out:
;   один кадр музыки
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   каналы, указатели паттернов, AY
; -----------------------------------------
TickPlayer      LD A, (InitPlayer.TickLeft)
                DEC A
                LD (InitPlayer.TickLeft), A
                JP NZ, BuildAYState                                             ; переход, если до чтения следующей музыкальной строки остаются тики

                LD A, (InitPlayer.Tempo)
                LD (InitPlayer.TickLeft), A
                LD IX, InitPlayer.ChannelAStep
                CALL StepDuration                                               ; обновление задержки чтения команд канала
                JP P, .ChannelB                                                 ; переход, если каналу A ещё не нужна новая команда

                LD HL, (InitPlayer.PatternA)
                LD A, (HL)
                INC A
                CALL Z, NextPattern                                             ; вызов, если поток канала A содержит маркер конца паттерна #FF
                LD HL, (InitPlayer.PatternA)
                CALL DecodeChannel                                              ; интерпретатор команд музыкального канала
                LD (InitPlayer.PatternA), HL

                ; канал B читает новую команду только после истечения собственной задержки
.ChannelB       LD IX, InitPlayer.ChannelBStep
                CALL StepDuration                                               ; обновление задержки чтения команд канала
                JP P, .ChannelC                                                 ; переход, если каналу B ещё не нужна новая команда

                LD HL, (InitPlayer.PatternB)
                CALL DecodeChannel                                              ; интерпретатор команд музыкального канала
                LD (InitPlayer.PatternB), HL

                ; канал C имеет отдельные поток команд и счётчик задержки
.ChannelC       LD IX, InitPlayer.ChannelCStep
                CALL StepDuration                                               ; обновление задержки чтения команд канала
                JP P, BuildAYState                                              ; переход, если каналу C ещё не нужна новая команда

                LD HL, (InitPlayer.PatternC)
                CALL DecodeChannel                                              ; интерпретатор команд музыкального канала
                LD (InitPlayer.PatternC), HL
                JP BuildAYState

; -----------------------------------------
; интерпретатор команд музыкального канала
; Коды <#60 задают ноту и запускают семпл на 32 шага. #60..#6F выбирают семпл по записям #63
; байта. #70..#7F выбирают орнамент по записям #21 байт. #80 отключает канал, #81 пропускает
; строку, #82 выбирает нулевой орнамент. #83..#8E задают форму огибающей и её период из следующего
; байта. Остальные коды задают задержку A-#A1 и продолжают разбор.
; In:
;   HL — поток команд, IX — состояние канала
; Out:
;   HL — следующая команда после музыкальной строки
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   канал, параметры огибающей InitPlayer.Envelope/InitPlayer.EnvelopeShape
; -----------------------------------------
DecodeChannel   LD A, (HL)
                CP #60
                JP C, .SetNote                                                  ; переход, если команда #00..#5F задаёт ноту

                CP #70
                JP C, .SetSample                                                ; переход, если команда #60..#6F выбирает семпл

                CP #80
                JP C, .SetOrnament                                              ; переход, если команда #70..#7F выбирает орнамент

                JP Z, .StopAdvance                                              ; переход, если команда #80 выключает канал

                CP #81
                JP Z, .NextCommand                                              ; переход, если команда #81 завершает текущую строку без изменения ноты

                CP #82
                JP Z, .ZeroOrnament                                             ; переход, если команда #82 выбирает нулевой орнамент

                CP #8F
                JP C, .EnvelopeForm                                             ; переход, если команда #83..#8E задаёт форму аппаратной огибающей

                SUB #A1
                LD (IX + FMusicChannel.Wait - FMusicChannel.Step), A
                LD (IX + FMusicChannel.Duration - FMusicChannel.Step), A
                INC HL
                JP DecodeChannel

                ; нота запускает семпл заново и задаёт начальную длительность в 32 шага
.SetNote        LD (IX + FMusicChannel.Note - FMusicChannel.Step), A
                LD (IX + FMusicChannel.Step - FMusicChannel.Step), #00
                LD (IX + FMusicChannel.Remaining - FMusicChannel.Step), #20
.NextCommand    INC HL
                RET

                ; код выбора семпла ищется в таблице записей фиксированного размера
.SetSample      SUB #60
                PUSH HL
                LD BC, #0063
                LD HL, (InitPlayer.SampleTable)
                CALL FindTableEntry                                             ; поиск записи с заданным первым байтом в таблице фиксированного шага
                INC HL
                LD (IX + FMusicChannel.Sample.Low - FMusicChannel.Step), L
                LD (IX + FMusicChannel.Sample.High - FMusicChannel.Step), H
                POP HL
                INC HL
                JP DecodeChannel

.StopAdvance    INC HL

                ; значение #FF в счётчике семпла помечает выключенный канал
.StopChannel    LD (IX + FMusicChannel.Remaining - FMusicChannel.Step), #FF
                RET

.ZeroOrnament   XOR A
                JR .FindOrnament

.SetOrnament    SUB #70

                ; указатель орнамента сохраняется в состоянии канала для последующего расчёта
                ; периода
.FindOrnament   PUSH HL
                LD BC, #0021
                LD HL, (InitPlayer.OrnamentTable)
                CALL FindTableEntry                                             ; поиск записи с заданным первым байтом в таблице фиксированного шага
                INC HL
                LD (IX + FMusicChannel.Ornament.Low - FMusicChannel.Step), L
                LD (IX + FMusicChannel.Ornament.High - FMusicChannel.Step), H
                LD (IX + FMusicChannel.EnvelopeMode - FMusicChannel.Step), #00
                POP HL
                INC HL
                JP DecodeChannel

                ; форма огибающей и её период берутся из команды, отдельный флаг разрешает
                ; запись AY-регистра 13
.EnvelopeForm   SUB #80
                LD (InitPlayer.EnvelopeShape), A
                INC HL
                LD A, (HL)
                INC HL
                LD (InitPlayer.Envelope), A
                LD (IX + FMusicChannel.EnvelopeMode - FMusicChannel.Step), #01
                PUSH HL
                XOR A
                LD BC, #0021
                LD HL, (InitPlayer.OrnamentTable)
                CALL FindTableEntry                                             ; поиск записи с заданным первым байтом в таблице фиксированного шага
                INC HL
                LD (IX + FMusicChannel.Ornament.Low - FMusicChannel.Step), L
                LD (IX + FMusicChannel.Ornament.High - FMusicChannel.Step), H
                POP HL
                JP DecodeChannel

; -----------------------------------------
; продвижение позиции семпла и обработка его повтора
; При IX+7=#FF канал выключен. Иначе уменьшает счётчик, продвигает позицию IX+0 по модулю 32. При
; исчерпании читает параметры повтора у семпла+96 и +97, либо выключает канал при нулевой позиции
; повтора.
; In:
;   IX — состояние канала
; Out:
;   C — номер шага семпла при активном канале
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   IX+0, IX+7
; -----------------------------------------

                ; по окончании семпла параметры повтора выбирают следующую позицию либо
                ; выключают канал
StepSample      LD A, (IX + FMusicChannel.Remaining - FMusicChannel.Step)
                INC A
                RET Z                                                           ; выход, если канал выключен маркером #FF

                DEC A
                DEC A
                LD (IX + FMusicChannel.Remaining - FMusicChannel.Step), A
                PUSH AF
                LD A, (IX + FMusicChannel.Step - FMusicChannel.Step)
                LD C, A
                INC A
                AND #1F
                LD (IX + FMusicChannel.Step - FMusicChannel.Step), A
                POP AF
                RET NZ                                                          ; выход, если в текущем семпле остаются шаги до обработки повтора

                LD E, (IX + FMusicChannel.Sample.Low - FMusicChannel.Step)
                LD D, (IX + FMusicChannel.Sample.High - FMusicChannel.Step)
                LD HL, #0060
                ADD HL, DE
                LD A, (HL)
                DEC A
                JP M, DecodeChannel.StopChannel                                 ; переход, если семпл не содержит продолжения и канал следует выключить

                LD C, A
                INC A
                AND #1F
                LD (IX + FMusicChannel.Step - FMusicChannel.Step), A
                INC HL
                LD A, (HL)
                INC A
                LD (IX + FMusicChannel.Remaining - FMusicChannel.Step), A
                RET

; -----------------------------------------
; обновление общего параметра шума в начале семпла
; Если C=0, переносит H в InitPlayer.Noise, иначе возвращается без записи.
; In:
;   C — шаг семпла, H — шумовой параметр
; Out:
; при C=0 записано InitPlayer.Noise=H и A=H, Z=1. При C!=0 запись не выполняется, A=C и Z=0.
; CF=0 в обеих
;   ветвях
; Corrupt:
;   AF. HL, DE, BC, HL', DE', BC', AF', IX, IY сохранены
; Note:
;   InitPlayer.Noise при C=0
; -----------------------------------------
StoreNoise      LD A, C
                OR A
                RET NZ                                                          ; выход, если текущий шаг семпла не является первым

                LD A, H
                LD (InitPlayer.Noise), A
                RET

; -----------------------------------------
; применение аппаратной огибающей к амплитуде канала
; Для активного канала проверяет IX-2. При первом применении переводит состояние 1 в 2. При
; повторе обнуляет флаг записи формы огибающей InitPlayer.EnvelopeShape. Устанавливает bit 4 в
; байте громкости по HL.
; In:
;   IX — канал, HL — регистр громкости в буфере
; Out:
;   bit 4 громкости включает огибающую AY
; Corrupt:
;   AF
; Note:
;   IX-2, (HL), InitPlayer.EnvelopeShape
; -----------------------------------------
ApplyEnvelope   LD A, (IX + FMusicChannel.Remaining - FMusicChannel.Step)
                INC A
                RET Z                                                           ; выход, если канал выключен и огибающая ему не нужна

                LD A, (IX + FMusicChannel.EnvelopeMode - FMusicChannel.Step)
                OR A
                RET Z                                                           ; выход, если для канала не задан режим аппаратной огибающей

                CP #02
                JP Z, .KeepEnvelope                                             ; переход, если огибающая уже включена и повторная запись её формы не нужна

                LD (IX + FMusicChannel.EnvelopeMode - FMusicChannel.Step), #02
                JP .SetVolumeFlag

.KeepEnvelope   XOR A
                LD (InitPlayer.EnvelopeShape), A
.SetVolumeFlag  SET AY_ENVELOPE_BIT, (HL)                                       ; флаг, регистр амплитуды канала AY использует аппаратную огибающую
                RET

; -----------------------------------------
; расчёт трёх каналов и общего буфера регистров AY
; Для A, B, C продвигает семплы, разбирает их шаги, объединяет маски микшера, вычисляет период
; тона с орнаментом и транспозицией, записывает амплитуды и огибающие. Передаёт буфер на AY через
; WriteAY.
; In:
;   состояния трёх каналов и таблицы композиции
; Out:
;   InitPlayer.ToneA..InitPlayer.EnvelopeShape — значения AY 0..13
; Corrupt:
;   HL, DE, BC, AF, IX
; Note:
;   каналы, AY
; -----------------------------------------

                ; три независимых канала объединяются в общий микшер и буфер регистров AY
BuildAYState    LD IX, InitPlayer.ChannelAStep
                CALL StepSample                                                 ; продвижение позиции семпла и обработка его повтора
                LD A, C
                LD (CalcTonePeriod.OrnamentStep), A
                LD IX, (InitPlayer.SampleA)
                CALL ReadSampleStep                                             ; разбор трёхбайтового шага музыкального семпла
                LD A, C
                OR B
                RRCA
                LD (InitPlayer.Mixer), A
                LD IX, InitPlayer.ChannelAStep
                LD A, (IX + FMusicChannel.Remaining - FMusicChannel.Step)
                INC A
                JP Z, .VolumeA                                                  ; переход, если канал A выключен и расчёт периода пропускается

                CALL StoreNoise                                                 ; обновление общего параметра шума в начале семпла
                CALL CalcTonePeriod                                             ; расчёт периода ноты с орнаментом и смещением семпла
                LD (InitPlayer.ToneA), HL

                ; амплитуда канала A дополняется флагом аппаратной огибающей
.VolumeA        LD HL, InitPlayer.VolumeA
                LD (HL), A
                CALL ApplyEnvelope                                              ; применение аппаратной огибающей к амплитуде канала
                LD IX, InitPlayer.ChannelBStep
                CALL StepSample                                                 ; продвижение позиции семпла и обработка его повтора
                LD A, (IX + FMusicChannel.Remaining - FMusicChannel.Step)
                INC A
                JP Z, .VolumeB                                                  ; переход, если канал B выключен и расчёт периода пропускается

                LD A, C
                LD (CalcTonePeriod.OrnamentStep), A
                LD IX, (InitPlayer.SampleB)
                CALL ReadSampleStep                                             ; разбор трёхбайтового шага музыкального семпла
                LD A, (InitPlayer.Mixer)
                OR C
                OR B
                LD (InitPlayer.Mixer), A
                CALL StoreNoise                                                 ; обновление общего параметра шума в начале семпла
                LD IX, InitPlayer.ChannelBStep
                CALL CalcTonePeriod                                             ; расчёт периода ноты с орнаментом и смещением семпла
                LD (InitPlayer.ToneB), HL

                ; амплитуда канала B использует собственное состояние семпла
.VolumeB        LD HL, InitPlayer.VolumeB
                LD (HL), A
                CALL ApplyEnvelope                                              ; применение аппаратной огибающей к амплитуде канала
                LD IX, InitPlayer.ChannelCStep
                CALL StepSample                                                 ; продвижение позиции семпла и обработка его повтора
                LD A, (IX + FMusicChannel.Remaining - FMusicChannel.Step)
                INC A
                JP Z, .VolumeC                                                  ; переход, если канал C выключен и расчёт периода пропускается

                LD A, C
                LD (CalcTonePeriod.OrnamentStep), A
                LD IX, (InitPlayer.SampleC)
                CALL ReadSampleStep                                             ; разбор трёхбайтового шага музыкального семпла
                LD A, (InitPlayer.Mixer)
                RLC C
                RLC B
                OR B
                OR C
                LD (InitPlayer.Mixer), A
                CALL StoreNoise                                                 ; обновление общего параметра шума в начале семпла
                LD IX, InitPlayer.ChannelCStep
                CALL CalcTonePeriod                                             ; расчёт периода ноты с орнаментом и смещением семпла
                LD (InitPlayer.ToneC), HL

                ; после канала C готовый буфер передаётся звуковому генератору
.VolumeC        LD HL, InitPlayer.VolumeC
                LD (HL), A
                CALL ApplyEnvelope                                              ; применение аппаратной огибающей к амплитуде канала
                JP WriteAY

; -----------------------------------------
; расчёт периода ноты с орнаментом и смещением семпла
; Читает байт орнамента по позиции текущего шага, прибавляет ноту канала и транспозицию из
; CalcTonePeriod.Transpose.
; По индексу выбирает слово из CalcTonePeriod.NotePeriods и прибавляет либо вычитает тоновое
; смещение DE согласно bit 4
; D.
; In:
; IX — канал, L — амплитуда, DE — смещение семпла, самомодифицируемый
; CalcTonePeriod.OrnamentStep — номер шага
; Out:
;   HL — итоговый период, A — исходная амплитуда
; Corrupt:
;   HL, DE, BC, AF
; Note:
;   нет записи кроме внешней подготовки операндов
; -----------------------------------------
CalcTonePeriod  LD A, L
                PUSH AF
                PUSH DE
                LD L, (IX + FMusicChannel.Ornament.Low - FMusicChannel.Step)
                LD H, (IX + FMusicChannel.Ornament.High - FMusicChannel.Step)
                LD DE, #0003
.OrnamentStep   EQU $ - 2                                                       ; операнд позиции внутри текущего орнамента
                ADD HL, DE
                LD A, (IX + FMusicChannel.Note - FMusicChannel.Step)
                ADD A, (HL)
                ADD A, #00
.Transpose      EQU $ - 1                                                       ; операнд транспозиции текущей позиции композиции
                ADD A, A
                LD E, A
                LD D, #00
                LD HL, CalcTonePeriod.NotePeriods
                ADD HL, DE
                LD E, (HL)
                INC HL
                LD D, (HL)
                EX DE, HL
                POP DE
                POP AF
                BIT SLIDE_ADD_BIT, D                                            ; флаг, упакованное смещение периода в D положительное, снимается перед ADD HL,DE
                JR Z, .SubtractSlide                                            ; переход, если смещение семпла следует вычесть из периода ноты

                RES SLIDE_ADD_BIT, D                                            ; флаг, упакованное смещение периода в D положительное, снимается перед ADD HL,DE
                ADD HL, DE
                RET

                ; знак смещения семпла выбирает вычитание из базового периода ноты
.SubtractSlide  AND A
                SBC HL, DE
                RET

.NotePeriods    DB #F8                                                          ; таблица периодов нот
                DB #0E, #10, #0E, #60, #0D, #80, #0C, #D8
                DB #0B, #28, #0B, #88, #0A, #F0, #09, #60
                DB #09, #E0, #08, #58, #08, #E0, #07, #7C
                DB #07, #08, #07, #B0, #06, #40, #06, #EC
                DB #05, #94, #05, #44, #05, #F8, #04, #B0
                DB #04, #70, #04, #2C, #04, #F0, #03, #BE
                DB #03, #84, #03, #58, #03, #20, #03, #F6
                DB #02, #CA, #02, #A2, #02, #7C, #02, #58
                DB #02, #38, #02, #16, #02, #F8, #01, #DF
                DB #01, #C2, #01, #AC, #01, #90, #01, #7B
                DB #01, #65, #01, #51, #01, #3E, #01, #2C
                DB #01, #1C, #01, #0B, #01, #FC, #00, #EF
                DB #00, #E1, #00, #D6, #00, #C8, #00, #BD
                DB #00, #B2, #00, #A8, #00, #9F, #00, #96
                DB #00, #8E, #00, #85, #00, #7E, #00, #77
                DB #00, #70, #00, #6B, #00, #64, #00, #5E
                DB #00, #59, #00, #54, #00, #4F, #00, #4B
                DB #00, #47, #00, #42, #00, #3F, #00, #3B
                DB #00, #38, #00, #35, #00, #32, #00, #2F
                DB #00, #2C, #00, #2A, #00, #27, #00, #25
                DB #00, #23, #00, #21, #00, #1F, #00, #1D
                DB #00, #1C, #00, #1A, #00, #19, #00, #17
                DB #00, #16, #00, #15, #00, #13, #00, #12
                DB #00, #11, #00, #10, #00, #0F, #00

; -----------------------------------------
; передача буфера регистров в AY
; Если InitPlayer.EnvelopeShape ненулевой, пишет регистры 13..0. Если нулевой, начинает с
; регистра 10 и буфера InitPlayer.VolumeC,
; сохраняя прежние параметры аппаратной огибающей AY 11..13. Для каждого регистра выбирает адрес
; через #FFFD и пишет значение через #BFFD.
; In:
; InitPlayer.ToneA..InitPlayer.EnvelopeShape — AY-регистры, InitPlayer.EnvelopeShape —
; флаг/форма огибающей
; Out:
;   AY обновлён
; Corrupt:
;   HL, BC, AF
; Note:
;   порты #FFFD/#BFFD
; -----------------------------------------
WriteAY         LD HL, InitPlayer.EnvelopeShape
                XOR A
                OR (HL)
                LD A, #0D
                JR NZ, .SelectAYPort                                            ; переход, если требуется записать форму огибающей вместе с регистрами 13..0

                SUB #03
                DEC HL
                DEC HL
                DEC HL

                ; адрес регистра выбирается через #FFFD, данные передаются через #BFFD
.SelectAYPort   LD C, #FD

                ; регистры отправляются в обратном порядке, нулевой флаг формы сохраняет прежние
                ; AY 11..13
.RegisterLoop   LD B, #FF
                OUT (C), A
                LD B, #BF
                OUTD
                DEC A
                JP P, .RegisterLoop                                             ; переход, если после текущего регистра AY остаются младшие регистры

                RET

.SongData       DB #09                                                          ; встроенный музыкальный модуль меню
                DB #6D, #02, #84, #02, #08, #03, #53, #4F
                DB #4E, #47, #20, #42, #59, #20, #53, #54
                DB #20, #43, #4F, #4D, #50, #49, #4C, #45
                DB #CF, #06, #01, #0E, #00, #00, #0D, #80
                DB #00, #0D, #80, #00, #0C, #80, #00, #0C
                DB #80, #00, #0C, #80, #00, #0B, #80, #00
                DB #0B, #80, #00, #0B, #80, #00, #0B, #80
                DB #00, #0A, #80, #00, #0A, #80, #00, #0A
                DB #80, #00, #0A, #80, #00, #09, #80, #00
                DB #09, #80, #00, #09, #80, #00, #09, #80
                DB #00, #08, #80, #00, #08, #80, #00, #08
                DB #80, #00, #08, #80, #00, #08, #80, #00
                DB #08, #80, #00, #07, #80, #00, #07, #80
                DB #00, #07, #80, #00, #07, #80, #00, #07
                DB #80, #00, #07, #80, #00, #07, #80, #00
                DB #07, #80, #00, #1E, #01, #02, #0E, #68
                DB #5D, #0D, #69, #00, #0C, #69, #00, #1B
                DB #6A, #3A, #0D, #A0, #00, #0C, #A0, #00
                DB #0C, #A0, #00, #0C, #A0, #00, #0B, #A0
                DB #00, #0B, #80, #00, #0B, #80, #00, #0A
                DB #80, #00, #0A, #80, #00, #0A, #80, #00
                DB #09, #80, #00, #09, #80, #00, #09, #80
                DB #00, #08, #80, #00, #08, #80, #00, #08
                DB #80, #00, #07, #80, #00, #07, #80, #00
                DB #07, #80, #00, #06, #80, #00, #06, #80
                DB #00, #06, #80, #00, #05, #80, #00, #05
                DB #80, #00, #05, #80, #00, #04, #80, #00
                DB #04, #80, #00, #04, #80, #00, #00, #00
                DB #03, #2F, #3F, #00, #4F, #A0, #00, #6E
                DB #A0, #80, #8D, #A0, #07, #0D, #80, #00
                DB #0C, #80, #00, #0C, #80, #00, #0C, #80
                DB #00, #0B, #80, #00, #0B, #80, #00, #0B
                DB #80, #00, #0A, #80, #00, #0A, #80, #00
                DB #0A, #80, #00, #09, #80, #00, #09, #80
                DB #00, #09, #80, #00, #08, #80, #00, #08
                DB #80, #00, #08, #80, #00, #07, #80, #00
                DB #07, #80, #00, #07, #80, #00, #06, #80
                DB #00, #06, #80, #00, #06, #80, #00, #05
                DB #80, #00, #05, #80, #00, #05, #80, #00
                DB #04, #80, #00, #04, #80, #00, #04, #80
                DB #00, #00, #01, #0D, #0D, #E0, #00, #0B
                DB #E0, #00, #09, #C0, #00, #07, #C0, #00
                DB #00, #C0, #00, #00, #C0, #00, #00, #C0
                DB #00, #00, #C0, #00, #00, #C0, #00, #00
                DB #C0, #00, #00, #C0, #00, #00, #C0, #00
                DB #00, #C0, #00, #00, #C0, #00, #00, #C0
                DB #00, #00, #C0, #00, #00, #C0, #00, #00
                DB #C0, #00, #00, #C0, #00, #00, #C0, #00
                DB #00, #C0, #00, #00, #C0, #00, #00, #C0
                DB #00, #00, #C0, #00, #00, #C0, #00, #00
                DB #C0, #00, #00, #C0, #00, #00, #C0, #00
                DB #00, #C0, #00, #00, #C0, #00, #00, #C0
                DB #00, #00, #C0, #00, #0B, #00, #0E, #0D
                DB #80, #00, #0C, #80, #00, #0C, #80, #00
                DB #0C, #80, #00, #0B, #80, #00, #0B, #80
                DB #00, #0B, #80, #00, #0A, #80, #00, #0A
                DB #80, #00, #0A, #80, #00, #0A, #80, #00
                DB #0A, #80, #00, #0A, #A0, #00, #0A, #A0
                DB #00, #0A, #80, #00, #0A, #80, #00, #0A
                DB #80, #00, #0A, #80, #00, #0A, #80, #02
                DB #0A, #80, #02, #0A, #80, #00, #0A, #80
                DB #00, #0A, #A0, #02, #0A, #A0, #02, #0A
                DB #80, #00, #0A, #80, #00, #0A, #80, #02
                DB #0A, #80, #02, #0A, #80, #00, #0A, #80
                DB #00, #0A, #A0, #02, #0A, #A0, #02, #15
                DB #0B, #0F, #0B, #80, #00, #0A, #A0, #00
                DB #0A, #A0, #00, #09, #A0, #00, #09, #80
                DB #00, #08, #80, #00, #08, #80, #00, #08
                DB #A0, #00, #08, #A0, #00, #08, #A0, #00
                DB #08, #A0, #00, #07, #80, #00, #07, #80
                DB #00, #07, #80, #00, #07, #80, #00, #07
                DB #A0, #00, #07, #A0, #00, #07, #A0, #00
                DB #07, #A0, #00, #06, #A0, #00, #06, #A0
                DB #00, #06, #80, #00, #06, #80, #00, #06
                DB #80, #00, #06, #80, #00, #06, #A0, #00
                DB #05, #A0, #00, #05, #80, #00, #05, #80
                DB #00, #05, #80, #00, #05, #80, #00, #05
                DB #80, #00, #1C, #03, #0A, #01, #00, #01
                DB #00, #02, #00, #03, #00, #04, #00, #07
                DB #00, #05, #00, #06, #00, #06, #00, #04
                DB #00, #07, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #07, #0C, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #0A, #18, #18
                DB #18, #18, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #0D, #18
                DB #0C, #00, #18, #0C, #00, #18, #00, #0C
                DB #00, #18, #00, #0C, #00, #18, #00, #0C
                DB #00, #18, #00, #0C, #00, #18, #00, #0C
                DB #00, #18, #00, #0C, #00, #18, #00, #01
                DB #3A, #03, #4E, #03, #65, #03, #02, #A5
                DB #03, #31, #04, #56, #04, #03, #A5, #03
                DB #65, #04, #56, #04, #04, #85, #04, #13
                DB #05, #48, #05, #05, #63, #05, #77, #05
                DB #8E, #05, #06, #D5, #05, #61, #06, #81
                DB #06, #07, #85, #04, #95, #06, #48, #05
                DB #FF, #A4, #61, #70, #1D, #1D, #22, #1F
                DB #1D, #1D, #22, #1D, #1D, #1D, #22, #1F
                DB #1C, #1C, #24, #20, #FF, #A2, #81, #A4
                DB #61, #70, #18, #20, #20, #1D, #19, #20
                DB #20, #1B, #19, #20, #20, #1D, #18, #1F
                DB #22, #A2, #1F, #FF, #A2, #6D, #8E, #2C
                DB #1D, #1D, #1D, #A1, #1D, #1D, #A2, #1D
                DB #1D, #A1, #1D, #1D, #A2, #1D, #8E, #38
                DB #1D, #1D, #1D, #1D, #A1, #1D, #1D, #A2
                DB #1D, #A1, #1D, #1D, #A2, #1D, #8E, #21
                DB #1D, #1D, #1D, #1D, #1D, #1D, #A1, #1D
                DB #1D, #A2, #1D, #8E, #3C, #1D, #1D, #1D
                DB #1D, #A1, #1D, #1D, #A2, #1D, #A1, #1D
                DB #1D, #1D, #1D, #FF, #A1, #63, #7A, #1D
                DB #6F, #70, #1D, #61, #18, #6F, #18, #61
                DB #1D, #6F, #1D, #61, #20, #6F, #20, #62
                DB #22, #6F, #22, #61, #20, #6F, #20, #61
                DB #1F, #6F, #1F, #61, #1B, #6F, #1B, #63
                DB #7A, #1D, #6F, #70, #1D, #61, #19, #6F
                DB #19, #61, #1D, #6F, #1D, #63, #7A, #20
                DB #6F, #70, #20, #62, #22, #6F, #22, #61
                DB #20, #6F, #20, #61, #1F, #6F, #1F, #61
                DB #1B, #6F, #1B, #63, #7A, #1D, #6F, #70
                DB #1D, #61, #19, #6F, #19, #61, #1D, #6F
                DB #1D, #61, #20, #6F, #20, #62, #22, #6F
                DB #22, #61, #20, #6F, #20, #61, #1F, #6F
                DB #1F, #61, #1D, #6F, #1D, #63, #7A, #1C
                DB #6F, #70, #1C, #61, #18, #6F, #18, #61
                DB #1C, #6F, #1C, #61, #1F, #6F, #1F, #62
                DB #24, #6F, #24, #61, #22, #6F, #22, #61
                DB #20, #6F, #20, #61, #1F, #6F, #1F, #FF
                DB #A2, #6E, #77, #80, #24, #2C, #24, #2E
                DB #24, #2B, #27, #A1, #2B, #2C, #A8, #29
                DB #A2, #2C, #A1, #2B, #2C, #A2, #2B, #AE
                DB #25, #A2, #25, #A6, #24, #A2, #24, #A3
                DB #2E, #2C, #A2, #2B, #FF, #B0, #6D, #8E
                DB #2C, #11, #8E, #38, #0D, #8E, #21, #16
                DB #8E, #3C, #0C, #FF, #A6, #6E, #77, #2C
                DB #A2, #24, #2E, #2C, #2B, #27, #A1, #29
                DB #27, #A8, #29, #A2, #29, #27, #29, #AA
                DB #2C, #A2, #25, #2E, #2C, #AA, #2B, #A6
                DB #6F, #70, #2B, #FF, #A1, #63, #7A, #1D
                DB #6F, #70, #1D, #61, #18, #6F, #18, #61
                DB #1D, #6F, #1D, #61, #20, #6F, #20, #62
                DB #1D, #6F, #1D, #61, #19, #6F, #19, #61
                DB #1D, #6F, #1D, #61, #20, #6F, #20, #63
                DB #7A, #1B, #6F, #70, #1B, #61, #16, #6F
                DB #16, #61, #1B, #6F, #1B, #63, #7A, #1F
                DB #6F, #70, #1F, #62, #1F, #6F, #1F, #61
                DB #1B, #6F, #1B, #61, #1F, #6F, #1F, #61
                DB #22, #6F, #22, #63, #7A, #1D, #6F, #70
                DB #1D, #61, #18, #6F, #18, #61, #1D, #6F
                DB #1D, #61, #20, #6F, #20, #62, #1D, #6F
                DB #1D, #61, #19, #6F, #19, #61, #1D, #6F
                DB #1D, #61, #20, #6F, #20, #63, #7A, #1B
                DB #6F, #70, #1B, #61, #16, #6F, #16, #61
                DB #1B, #6F, #1B, #63, #7A, #1F, #6F, #70
                DB #1F, #62, #1B, #6F, #1B, #61, #18, #6F
                DB #18, #61, #1B, #6F, #1B, #61, #1F, #6F
                DB #1F, #FF, #A4, #6E, #77, #30, #A2, #6F
                DB #70, #30, #6E, #77, #29, #30, #31, #A3
                DB #2C, #A1, #6F, #70, #2C, #A2, #6E, #77
                DB #2E, #27, #2E, #31, #31, #30, #A4, #2B
                DB #30, #A2, #6F, #70, #30, #6E, #77, #33
                DB #33, #31, #A4, #2C, #A2, #2E, #2C, #2B
                DB #2C, #A4, #2B, #6F, #70, #2B, #FF, #A8
                DB #6D, #8E, #2C, #11, #8E, #38, #1D, #8E
                DB #32, #0D, #8E, #3C, #1A, #8E, #2C, #11
                DB #8E, #38, #1D, #8E, #32, #0D, #8E, #3C
                DB #30, #FF, #A4, #61, #70, #1D, #1D, #22
                DB #1F, #1D, #1D, #1B, #1B, #1D, #1D, #22
                DB #1F, #1D, #1D, #1B, #1B, #FF, #A2, #81
                DB #A4, #61, #70, #18, #20, #20, #1D, #19
                DB #20, #18, #1F, #18, #20, #20, #1D, #19
                DB #20, #18, #A2, #1F, #FF, #A2, #6D, #8E
                DB #2C, #1D, #1D, #1D, #A1, #1D, #1D, #A2
                DB #1D, #1D, #A1, #1D, #1D, #A2, #1D, #8E
                DB #38, #1D, #1D, #1D, #1D, #A1, #8E, #32
                DB #1D, #1D, #A2, #1D, #A1, #1D, #1D, #A2
                DB #1D, #8E, #2C, #1D, #1D, #1D, #A1, #1D
                DB #1D, #A2, #1D, #1D, #A1, #1D, #1D, #A2
                DB #1D, #8E, #38, #1D, #1D, #1D, #1D, #A1
                DB #8E, #32, #1D, #1D, #A2, #1D, #A1, #1D
                DB #1D, #A2, #1D, #FF, #A1, #63, #7A, #1D
                DB #6F, #70, #1D, #61, #18, #6F, #18, #61
                DB #1D, #6F, #1D, #61, #20, #6F, #20, #62
                DB #22, #6F, #22, #61, #20, #6F, #20, #61
                DB #1F, #6F, #1F, #61, #1B, #6F, #1B, #63
                DB #7A, #1D, #6F, #70, #1D, #61, #19, #6F
                DB #19, #61, #1D, #6F, #1D, #63, #7A, #20
                DB #6F, #70, #20, #62, #1B, #6F, #1B, #61
                DB #18, #6F, #18, #61, #1B, #6F, #1B, #61
                DB #1F, #6F, #1F, #63, #7A, #1D, #6F, #70
                DB #1D, #61, #19, #6F, #19, #61, #1D, #6F
                DB #1D, #61, #20, #6F, #20, #62, #22, #6F
                DB #22, #61, #20, #6F, #20, #61, #22, #6F
                DB #22, #61, #25, #6F, #25, #63, #7A, #18
                DB #6F, #70, #18, #61, #1C, #6F, #1C, #61
                DB #1F, #6F, #1F, #61, #22, #6F, #22, #62
                DB #18, #6F, #18, #61, #1C, #6F, #1C, #61
                DB #1F, #6F, #1F, #61, #18, #6F, #18, #FF
                DB #A2, #81, #6F, #7D, #30, #35, #38, #AA
                DB #35, #A2, #31, #35, #37, #A4, #38, #A6
                DB #37, #A2, #31, #35, #37, #38, #37, #35
                DB #38, #37, #35, #34, #35, #A8, #37, #FF
                DB #B0, #6D, #8E, #2C, #11, #A8, #8E, #38
                DB #0D, #8E, #32, #18, #B0, #8E, #21, #16
                DB #8E, #3C, #0C, #FF, #A4, #6E, #77, #30
                DB #A2, #6F, #70, #30, #6E, #77, #29, #30
                DB #31, #A3, #2C, #A1, #6F, #70, #2C, #A2
                DB #6E, #77, #2E, #2C, #2B, #2C, #2C, #2B
                DB #A4, #27, #30, #A2, #6F, #70, #30, #6E
                DB #77, #33, #33, #31, #A4, #35, #A2, #33
                DB #31, #30, #31, #A4, #30, #A2, #6F, #70
                DB #30, #A1, #77, #2B, #29, #FF, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00, #00, #00, #00, #00, #00
                DB #00, #00, #00

                assert $ = #EC00
                endmodule
                endmodule
