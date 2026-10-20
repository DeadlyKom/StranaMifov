
; -----------------------------------------
; восстановить население опустевших объектов по ближайшему населённому объекту
; одинразна 4 вызова, группы #6B19/#6B29/#6B39/#6B49, активные записи 6 байт с количеством+4/+5
; равным 0, #7A4E определяет континент по адресу записи, #7F5F ищет ближайшую другую запись тойже
; группы, если у неё количество ненулевое, копируется ID типа+3, количество инициализируется полем
; 32/33 описателя типа, случайного генератора здесь нет
; In:
;   банк 0 уже выбран, #6A2D континент, группы #6B19/#6B29/#6B39/#6B49, счётчик #AD30
; Out:
;   счётчик уменьшен, каждый 4 вызов активные пустые записи получают ID ближайшего населённого
;   объекта и количество из поля 32/33SOLDIERS, при реальном заполнении восстановлен банк 0
; Corrupt:
;   HL, DE, BC, AF, IX, IY, #AD30 и содержимое объектов, альтернативные регистры собственным
;   кодом не используются
; -----------------------------------------
RepopulateSites LD A, (Engine.RepopulateSites.RefreshDelay)
                DEC A
                LD (Engine.RepopulateSites.RefreshDelay), A
                RET NZ                                                          ; выход, если ещё не наступил срок пополнения мест

                LD A, #04
                LD (Engine.RepopulateSites.RefreshDelay), A
                LD IY, Engine.RepopulateSites.SiteGroups
                LD A, #04
                LD (Engine.RepopulateSites.GroupNumber), A
.GroupLoop      PUSH IY
                LD L, (IY + FWord.Low)
                LD H, (IY + FWord.High)
                PUSH HL
                LD (Engine.RepopulateSites.GroupIndex), HL
                POP IX
                LD A, (State.Continent)
                CALL IndexFourBytes                                             ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                LD B, (IX + FMapList.Count.Low)
                PUSH HL
                POP IX
.SiteLoop       BIT TROOP_FREE_BIT, (IX + FMapTroop.Flags)                      ; свободная либо использованная шестибайтовая запись существ карты
                JR NZ, .NextSite                                                ; переход, если место исключено из обработки

                LD A, (IX + FMapTroop.Count.Low)
                OR (IX + FMapTroop.Count.High)
                JR NZ, .NextSite                                                ; переход, если место уже содержит ненулевое количество

                PUSH BC
                PUSH IX
                LD C, (IX + FMapTroop.X)
                LD B, (IX + FMapTroop.Y)
                PUSH IX
                POP HL
.GroupIndex     EQU $+2                                                         ; адрес таблицы FMapList обрабатываемой группы мест
                LD IX, #0000
                INC IX
                INC IX
                INC IX
                INC IX
                CALL SelectThreshold                                            ; определить одну из четырёх категорий по порогам
                LD E, A
                LD A, (Engine.RepopulateSites.GroupNumber)
                LD D, A
                LD L, C
                LD H, B
                LD A, #06
                CALL NearestObject                                              ; найти ближайшую активную запись выбранной группы
                PUSH IX
                POP IY
                POP IX
                LD A, (IY + FMapTroop.Count.Low)
                OR (IY + FMapTroop.Count.High)
                JR Z, .NextSite                                                 ; переход, если исходная запись пополнения не содержит количества

                LD A, (IY + FMapTroop.ID)
                LD (IX + FMapTroop.ID), A
                PUSH IX
                CALL UnitDesc                                                   ; получить описатель типа отряда
                LD C, (IX + FSoldier.SpawnCount.Low)
                LD B, (IX + FSoldier.SpawnCount.High)
                XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                POP IX
                LD (IX + FMapTroop.Count.Low), C
                LD (IX + FMapTroop.Count.High), B
                POP BC
.NextSite       LD DE, #0006
                ADD IX, DE
                DJNZ .SiteLoop

                POP IY
                INC IY
                INC IY
.GroupNumber    EQU $+1                                                         ; номер обрабатываемой группы мест
                LD A, #00
                INC A
                LD (Engine.RepopulateSites.GroupNumber), A
                CP #08
                JP NZ, .GroupLoop                                               ; переход, если остались группы мест для пополнения

                RET

.SiteGroups     EQU $                                                           ; четыре слова с адресами таблиц континентальных групп мест
                DB #19, #6B, #29, #6B, #39, #6B, #49, #6B
.RefreshDelay   EQU $                                                           ; счётчик вызовов до пополнения опустевших мест
                DB #04
