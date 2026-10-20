
; -----------------------------------------
; обновить экранные объекты обеих армий
; патчит атрибут F51D сначала 23 для FCED, затем 63 для FD47, F515 обходит отряды
; In:
;   армии FCED и FD47
; Out:
;   объекты обновлены, IX и IY сохранены
; Corrupt:
;   DE, BC, AF, операнд F51D, объекты обеих армий и бит 2 поля 6566, HL, IX, IY сохранены
; -----------------------------------------
DrawBothArmies  PUSH IY
                PUSH IX
                LD A, #23
                LD (Battle.DrawArmy.ObjectFlags), A
                LD IY, Battle.FinishField.HeroArmy
                CALL DrawArmy                                                   ; обновить экранные объекты одной армии
                LD A, #63
                LD (Battle.DrawArmy.ObjectFlags), A
                LD IY, Battle.FinishField.EnemyArmy
                CALL DrawArmy                                                   ; обновить экранные объекты одной армии
                POP IX
                POP IY
                RET
