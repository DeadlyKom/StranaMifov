
; -----------------------------------------
; сложить доход принадлежащих герою замков на четырёх континентах
; начальное 0 на стеке калькулятора, группа #6AE9, активные записи с владельцем+19 равным 0
; считаются своими, #AE1A возвращает доход BC каждой, токен 0F суммирует, возвращается число
; калькулятора
; In:
;   группы замков #6AE9 на четырёх континентах, данные городов банка 0
; Out:
;   на стек калькулятора добавлена сумма доходов активных замков с владельцем 0, банк 0 выбран
; Corrupt:
;   HL, DE, BC, AF, IX, IY, рабочий номер континента #AE19, альтернативные HL', DE', BC', AF'
;   могут изменяться вызываемым калькулятором ROM и здесь не сохраняются
; -----------------------------------------
SumCastleIncome XOR A
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                CALL StackA                                                     ; передать байт A на стек калькулятора ROM
                INC A
                LD (Engine.SumCastleIncome.Continent), A
.ContinentLoop  LD IX, State.CastlesIndex
                LD A, (Engine.SumCastleIncome.Continent)
                CALL IndexFourBytes                                             ; сместить IX к четырёхбайтной записи с индексом A
                LD L, (IX + FMapList.Data.Low)
                LD H, (IX + FMapList.Data.High)
                LD B, (IX + FMapList.Count.Low)
                PUSH HL
                POP IY
.CastleLoop     BIT CASTLE_OFF_BIT, (IY + FCastle.Flags)                        ; замок выключен из обходов стратегических объектов и подсчёта владений
                JR NZ, .NextCastle                                              ; переход, если замок исключён из обработки

                LD A, (IY + FCastle.Owner)
                OR A
                JR NZ, .NextCastle                                              ; переход, если замок не принадлежит герою

                PUSH BC
                LD A, (Engine.SumCastleIncome.Continent)
                CALL CastleIncome                                               ; рассчитать доход замка с учётом ближайших городов
                CALL StackBC                                                    ; передать целое BC на стек калькулятора ROM
                PUSH IX
                PUSH IY
                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #0F                                                          ; addition, сложение, ADFB
                DB #38                                                          ; end-calc, возврат в Z80, ADFC
                POP IY
                POP IX
                POP BC
.NextCastle     LD DE, #0023
                ADD IY, DE
                DJNZ .CastleLoop

                LD A, (Engine.SumCastleIncome.Continent)
                INC A
                LD (Engine.SumCastleIncome.Continent), A
                CP #05
                JP NZ, .ContinentLoop                                           ; переход, если остались континенты для суммирования дохода

                RST #28                                                         ; передача вычисления стековому калькулятору ПЗУ, токены следуют ниже
                DB #31                                                          ; duplicate, дублирование вершины, AE16
                DB #38                                                          ; end-calc, возврат в Z80, AE17
                RET

.Continent      EQU $                                                           ; номер континента при суммировании дохода
                DB #00
