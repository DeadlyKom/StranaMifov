
; -----------------------------------------
; сохранить фон и создать анимированный объект 4 на 4 знакоместа
; BC индекс объекта, умножается на 4 для #74F7, DE буфер фона, #7341 возвращает объект, задаются
; тип 4 и четыре кадра из ресурса #80DB, в+5 сохраняется текущий банк, +6/+7 адрес фона
; In:
;   DE буфер 144 байт для фона, BC индекс объекта, AF, A ID графического ресурса
; Out:
;   фон 4 на 4 знакоместа сохранён в DE, запись объекта получила тип 4 и 4 кадра, HL, DE, BC,
;   AF, IX, IY сохранены
; Corrupt:
;   HL, DE, BC, AF, IX, IY сохранены, память буфера и объектной записи изменена
; -----------------------------------------
GrabUnitTile    PUSH HL
.FrameLink      EQU FScreenObject20.Frame1Bank                                  ; смещение ссылки при IX=объект+индекс_ссылки*FFrameRef
                PUSH DE
                PUSH BC
                PUSH AF
                PUSH IX
                PUSH BC

                ; перевод индекса объекта в экранные координаты знакомест
                SLA B
                SLA B
                SLA C
                SLA C
                CALL GrabTile4x4                                                ; сохранить прямоугольник экрана 4 на 4 знакоместа в буфер DE
                POP BC
                CALL ViewCellAddr                                               ; найти экранный объект клетки и связанное численное поле
                CALL UnitSpriteAddr                                             ; выбрать банк и начало четырёхкадрового графического ресурса

                ; создание анимированного объекта с сохранённым фоном
                LD (IX + FScreenObject20.Flags), #04                            ; +#00, режим и флаги экранного объекта
                LD (IX + FScreenObject20.AnimationTimer), #01                   ; +#01, счётчик смены кадра
                LD (IX + FScreenObject20.AnimationFrame), #01                   ; +#02, номер текущего кадра
                LD (IX + FScreenObject20.AnimationPeriod), #09                  ; +#03, период смены кадров
                LD (IX + FScreenObject20.FrameCount), #04                       ; +#04, число кадров
                LD A, (State.Bank)
                LD (IX + FScreenObject20.BaseBank), A                           ; +#05, банк фонового изображения
                LD (IX + FScreenObject20.BaseAddress.Low), E                    ; +#06, младший байт адреса фона
                LD (IX + FScreenObject20.BaseAddress.High), D                   ; +#07, старший байт адреса фона
                LD B, #04

                ; заполнение четырёх трёхбайтных ссылок на кадры, IX служит скользящим указателем
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
