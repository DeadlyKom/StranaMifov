
; -----------------------------------------
; создать четырёхкадровый экранный объект
; сначала #7341, затем #80DB выбирает исходный ресурс, тип 4, счётчик 1, задержка 9, кадров 4,
; фоновый банк 4 по #C000, четыре трёхбайтных кадра получают C и адреса HL с шагом 256
; In:
;   BC индекс объекта, AF, A ID графического ресурса
; Out:
;   создан четырёхкадровый объект с фоном банка 4 по #C000, HL, DE, BC, AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, изменяется двадцатибайтная запись объекта, #80DB выбирает
;   адрес ресурса без переключения банка
; -----------------------------------------
SetUnitPicture  PUSH HL
.FrameLink      EQU FScreenObject20.Frame1Bank                                  ; смещение ссылки при IX=объект+индекс_ссылки*FFrameRef
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH IX
                CALL ViewCellAddr                                               ; найти экранный объект клетки и связанное численное поле
                CALL UnitSpriteAddr                                             ; выбрать банк и начало четырёхкадрового графического ресурса
                LD (IX + FScreenObject20.Flags), #04                            ; +#00, младшие 5 бит режим 0..4, бит 5 численная подпись, биты 6/7 отражение
                LD (IX + FScreenObject20.AnimationTimer), #01                   ; +#01, счётчик смены кадра
                LD (IX + FScreenObject20.AnimationFrame), #01                   ; +#02, текущий номер кадра 1..FrameCount, увеличивается перед выводом
                LD (IX + FScreenObject20.AnimationPeriod), #09                  ; +#03, значение перезагрузки счётчика
                LD (IX + FScreenObject20.FrameCount), #04                       ; +#04, число кадров
                LD (IX + FScreenObject20.BaseBank), #04                         ; +#05, банк основного изображения
                LD (IX + FScreenObject20.BaseAddress.Low), #00                  ; +#06, младший байт адреса фона
                LD (IX + FScreenObject20.BaseAddress.High), #C0                 ; +#07, старший байт адреса фона
                LD B, #04

                ; заполнение четырёх ссылок на кадры, IX продвигается на размер ссылки, а не объекта
.StorePicture   LD (IX + .FrameLink + FFrameRef.Bank), C
                LD (IX + .FrameLink + FFrameRef.Address.Low), L
                LD (IX + .FrameLink + FFrameRef.Address.High), H
                INC IX
                INC IX
                INC IX
                INC H
                DJNZ .StorePicture

                POP IX
                POP AF
                POP BC
                POP DE
                POP HL
                RET
