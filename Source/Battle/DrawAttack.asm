
; -----------------------------------------
; вывести маскированное изображение атаки в клетке
; строка переводится в 4*(B+1), столбец в 4*C, IX=CF55 пиксели, IY=CFD5 маска, DE=0404, 75A2
; рисует маскированный спрайт
; In:
;   BC клетка
; Out:
;   область 4 на 4 знакоместа обновлена, IX и IY сохранены
; Corrupt:
;   DE, BC, AF и пиксели маркера, HL, IX, IY сохранены
; -----------------------------------------
DrawAttack      PUSH IY
                PUSH IX
                INC B
                SLA B
                SLA B
                SLA C
                SLA C
                LD IX, Data.Battle.AttackPixels                                 ; пиксели32x32изDATA1 для изображения атаки
                LD IY, Data.Battle.AttackMask                                   ; маска32x32изDATA1 для изображения атаки
                LD DE, #0404
                CALL Engine.DrawMask                                            ; вывести пиксельный спрайт по маске
                POP IX
                POP IY
                RET
