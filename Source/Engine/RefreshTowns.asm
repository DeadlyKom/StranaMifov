
; -----------------------------------------
; обновить армии объектов группы #6AF9
; активные города текущего континента из #6AF9, независимый RandomScaled(1) определяет обновление,
; очищаются 9 байт гарнизона по смещению 17, RandomScaled(3) выбирает 0..3 отряда, ID выбирается
; по порогам #A2DA с отбрасыванием уже выбранных ID, количество=10+RandomScaled(40), старший байт
; количества 0, шаг города 26, выбор 0 оставляет гарнизон пустым
; In:
;   #6A2D континент, группа городов #6AF9
; Out:
;   банк 0 выбран, часть активных городов случайно получает 0..3 уникальных типа отрядов с
;   количеством 10..50, IY сохранён
; Corrupt:
;   HL, DE, BC, AF, IX, гарнизоны городов и состояние генератора, IFF разрешён, альтернативные
;   регистры собственным кодом не используются
; -----------------------------------------
RefreshTowns    XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD IX, State.TownsIndex
                LD A, (State.Continent)
                CALL IndexFourBytes                                             ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                LD B, (IX + FMapList.Count.Low)
                LD DE, #0011
                ADD HL, DE
                PUSH HL
                POP IX
.TownLoop       BIT TOWN_OFF_BIT, (IX + FTown.Flags - FTown.Army)               ; город выключен из стратегического обхода и обновления гарнизона
                JP NZ, .NextTown                                                ; переход, если город исключён из обработки

                LD DE, #0001
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                BIT TOWN_ROLL_BIT, E                                            ; младший бит результата RandomScaled(1), единица откладывает обновление города
                JR NZ, .NextTown                                                ; переход, если случайная проверка отложила обновление города

                PUSH BC
                PUSH IX
                PUSH IX
                POP HL
                LD E, L
                LD D, H
                INC DE
                LD BC, #0008
                LD (HL), #00
                LDIR
                LD DE, #0003
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                LD A, E
                OR A
                JR Z, .RestoreTown                                              ; переход, если случайная проверка оставила текущее место незаполненным

                LD B, E
                LD (Engine.RefreshTowns.TroopCount), A
                LD (Engine.RefreshTowns.FilledTroops), IX
.StartRefill    PUSH BC
                PUSH BC

                ; случайный выбор нового типа из таблицы порогов города
.ChooseUnit     LD DE, #00FE
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                LD HL, Engine.RefreshTowns.UnitThresholds - 1                   ; шесть порогов выбора типа гарнизона города
                LD A, E
                LD E, #00
.UnitThreshold  INC E
                INC HL
                CP (HL)
                JR NC, .UnitThreshold                                           ; переход, если случайный порог ещё не достиг категории существа

.FilledTroops   EQU $+1                                                         ; начало заполняемого гарнизона для проверки повторных ID
                LD HL, #0000
                POP BC
                PUSH BC
.TroopCount     EQU $+1                                                         ; выбранное число отрядов гарнизона
                LD A, #00
                SUB B
                LD B, A

                ; повторный выбор, если такой тип уже присутствует в заполняемых местах
.CheckDuplicate LD A, B
                OR A
                JR Z, .StoreUnit                                                ; переход, если в проверяемом списке ещё нет ранее выбранных типов

                LD A, (HL)
                CP E
                JR Z, .ChooseUnit                                               ; переход, если выбранный тип уже присутствует среди предыдущих мест

                DEC B
                INC HL
                INC HL
                INC HL
                JR .CheckDuplicate

.StoreUnit      POP BC
                LD (IX + FTroop.ID), E
                LD DE, #0028
                CALL RandomScaled                                               ; получить масштабированное псевдослучайное число
                LD A, E
                ADD A, #0A
                LD (IX + FTroop.Count.Low), A
                LD (IX + FTroop.Count.High), #00
                POP BC
                INC IX
                INC IX
                INC IX
                DJNZ .StartRefill

.RestoreTown    POP IX
                POP BC
.NextTown       LD DE, #001A
                ADD IX, DE
                DEC B
                JP NZ, .TownLoop                                                ; переход, если остались города для обновления

                RET

.UnitThresholds EQU $                                                           ; шесть порогов выбора типа гарнизона города
                DB #7D, #C8, #E1, #EB, #FA, #FF
