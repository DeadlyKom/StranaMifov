
; -----------------------------------------
; оценить совместимость типа отряда с составом армии
; B ID оцениваемого отряда, C дополнительный параметр, HL список до 5ID, DE шаг записей, в банке 3
; используется матрица от #CA40 со строкой 25 байт и индексом ID, значение #FF завершает с
; результатом #FF, нулевое значение снижает базовый результат, поле 17 описателя может увеличить
; либо уменьшить итог, A оценка настроения
; In:
;   HL список ID, DE шаг записей, BC, B ID оцениваемого типа и C дополнительный параметр
;   совместимости
; Out:
;   AF, A оценка совместимости с учётом матрицы и поля 17 описателя, F исходный, IX и IY
;   сохранены, прежний банк восстановлен
; Corrupt:
;   HL, DE, BC, A, матричные рабочие операнды, IFF разрешён
; -----------------------------------------
ArmyMood        PUSH IX
                LD A, (State.Bank)
                PUSH AF
                LD A, B
                LD (Engine.ArmyMood.TargetUnitID), A
                LD A, C
                LD (Engine.ArmyMood.SectModifier), A
                LD (Engine.ArmyMood.RecordStride), DE
                LD A, #01
                LD (Engine.ArmyMood.MoodValue), A
                LD A, #03
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD B, #05

                ; сопоставление типов отрядов по таблице совместимости
.UnitLoop       LD A, (HL)
                OR A
                JR Z, .BaseMood                                                 ; переход, если достигнут конец плотного списка армии

                PUSH BC
.TargetUnitID   EQU $+1                                                         ; ID типа, совместимость которого оценивается
                LD B, #00
                LD IX, Data.Battle.VsDemons.Morale - 26                         ; смещённая база двумерной матрицы совместимости, оба ID начинаются с1
                LD DE, #0019
.RelationLoop   ADD IX, DE
                DJNZ .RelationLoop

                LD C, (HL)
                LD B, #00
                ADD IX, BC
                LD A, (IX + #00)
                CP #FF
                JR NZ, .MergeMood                                               ; переход, если таблица не задаёт особое несовместимое сочетание

                POP BC
                JR .ApplyModifier

.MergeMood      OR A
                JR NZ, .NextUnit                                                ; переход, если сочетание типов сохраняет исходную совместимость

                LD (Engine.ArmyMood.MoodValue), A
.NextUnit       POP BC
.RecordStride   EQU $+1                                                         ; расстояние между исходными ID отрядов
                LD DE, #0012
                ADD HL, DE
                DJNZ .UnitLoop

.MoodValue      EQU $+1                                                         ; оценка совместимости, накопленная по матрице
.BaseMood       LD A, #00

                ; поправка совместимости по секте после обхода армии
.ApplyModifier  LD B, A
.SectModifier   EQU $+1                                                         ; секта для дополнительной поправки совместимости
                LD A, #00
                OR A
                JR Z, .RestorePage                                              ; переход, если поправка по секте не запрошена

                LD A, (Engine.ArmyMood.TargetUnitID)
                CALL UnitDesc                                                   ; получить описатель типа отряда
                LD A, (IX + FSoldier.SectID)                                    ; +#11, секта типа существа
                OR A
                JR Z, .RestorePage                                              ; переход, если у типа отряда нет секты

                CP #05
                JR Z, .IncreaseMood                                             ; переход, если тип отряда имеет общую совместимую секту

                CP C
                JR NZ, .DecreaseMood                                            ; переход, если секта типа отличается от секты героя

.IncreaseMood   INC B
                JR .RestorePage

.DecreaseMood   DEC B
.RestorePage    POP AF
                CALL PageEI                                                     ; переключить логический банк и разрешить прерывания
                LD A, B
                POP IX
                RET
