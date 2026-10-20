
; -----------------------------------------
; получить коэффициент дальнего воздействия для пары типов
; в трёхбайтной таблице по HL ищет ID=A, следующие два байта дают смещение к C8FC, слово
; индексируется ID цели (IY+0)-1 и сохраняется в F416, терминатор не проверяется, тип должен
; присутствовать
; In:
;   HL таблица, A ID атакующего, IY цель
; Out:
;   DE коэффициент, F416=DE, IX адрес слова
; Corrupt:
;   HL, DE, AF, IX и слово F416, BC и IY не изменяются
; -----------------------------------------
RangedMatchup   CP (HL)
                JR Z, .LookupRanged                                             ; переход, если в таблице найден тип атакующего

                INC HL
                INC HL
                INC HL
                JR RangedMatchup

.LookupRanged   INC HL
                LD E, (HL)
                INC HL
                LD D, (HL)
                LD IX, Data.Battle.VsDemons.RangedFactors                       ; база матрицы дальнего действия в DATA1, после25строк рукопашных коэффициентов
                ADD IX, DE
                LD E, (IY + FBattleUnit.UnitID)                                 ; +#00, ID типа, 0 завершает плотный список
                DEC E
                SLA E
                LD D, #00
                ADD IX, DE
                LD E, (IX + FWord.Low)
                LD D, (IX + FWord.High)
                LD (Battle.MeleeMatchup.MatchFactor), DE
                RET
