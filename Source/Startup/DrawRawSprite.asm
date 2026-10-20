
; -----------------------------------------
; вывести непрозрачный прямоугольный спрайт с атрибутами
; для каждого из D рядов знакомест 6EFA получает экранный адрес, восемь пиксельных строк
; копируются LDIR по E байт с INC D в адресе назначения, источник IX продвигается на 8*E, после
; пикселей вычисляется 5800+32*B+C и копируются D строки атрибутов шириной E с шагом 32,
; ограничений экраном нет, все явно сохранённые регистры восстановлены
; In:
;   BC левый верхний угол в знакоместах, D высота, E ширина в знакоместах, IX пиксели и
;   следующие атрибуты
; Out:
;   8*D*E пиксельных байтов и D*E атрибутов выведены, регистры сохранены
; Corrupt:
;   пиксели и атрибуты прямоугольника, HL, DE, BC, AF, IX, IY сохранены
; -----------------------------------------
DrawRawSprite   PUSH HL
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH IX
                PUSH DE
                PUSH BC

                ; переход к следующему знакоместному ряду прямоугольного изображения
.CharacterRow   CALL ScreenCharAddr                                             ; вычислить адрес верхней пиксельной строки знакоместа
                PUSH BC
                PUSH DE
                LD C, E
                LD B, #08
                EX DE, HL
                PUSH IX
                POP HL

                ; копирование восьми пиксельных строк текущего ряда с нелинейной адресацией экрана
.PixelRow       PUSH BC
                PUSH DE
                LD B, #00
                LDIR
                POP DE
                POP BC
                INC D
                DJNZ .PixelRow

                PUSH HL
                POP IX
                POP DE
                POP BC
                INC B
                DEC D
                JR NZ, .CharacterRow                                            ; переход, если ещё не выведены все ряды знакомест спрайта

                POP BC
                LD L, B
                LD H, #00
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                ADD HL, HL
                LD DE, Screen.Attributes                                        ; база атрибутной памяти, далее добавляется смещение выбранного знакоместа
                ADD HL, DE
                LD B, #00
                ADD HL, BC
                POP BC
                EX DE, HL
                PUSH IX
                POP HL

                ; копирование прямоугольника атрибутов после завершения пиксельной части
.AttributeRow   PUSH BC
                PUSH DE
                LD B, #00
                LDIR
                POP DE
                EX DE, HL
                LD BC, #0020
                ADD HL, BC
                EX DE, HL
                POP BC
                DJNZ .AttributeRow

                POP IX
                POP AF
                POP BC
                POP DE
                POP HL
                RET
