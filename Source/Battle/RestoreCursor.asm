
; -----------------------------------------
; восстановить фон под курсором клетки
; клетка переводится в знакоместа 4*C,4*(B+1), сохранённый Background выводится как блок 4 на 4
; восстанавливаются и пиксели, и атрибуты клетки, поэтому предыдущий кадр курсора исчезает
; In:
;   BC клетка, SaveCursorBack.Background сохранённый фон 144 байта
; Out:
;   фон восстановлен, регистры сохранены
; Corrupt:
;   пиксели и атрибуты клетки, HL, DE, BC, AF, IX и IY сохранены
; -----------------------------------------
RestoreCursor   PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH IX
                PUSH IY
                INC B
                SLA B
                SLA B
                SLA C
                SLA C
                LD IX, Battle.SaveCursorBack.Background
                LD DE, #0404
                CALL Engine.DrawRawSprite                                       ; вывести непрозрачный спрайт с атрибутами
                POP IY
                POP IX
                POP AF
                POP BC
                POP DE
                POP HL
                RET
