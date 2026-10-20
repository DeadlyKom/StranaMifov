; оверлей 20 из OVR2
; исходный файл каталога 49, смещение #1981
                module Overlay
                module Defeat
                org #B200

; -----------------------------------------
; экран поражения и повторная загрузка стартового блока KB.co
; Сохраняет вход BC, показывает рамку и загружает BAD/C в #4000 через #6CC8. При входном C=0
; печатает текст гибели в бою, иначе текст истечения срока. Включает IM1, I=#3F, банк 0, ставит
; SP=#5F98, переносит девятибайтовое имя KB.co/C из #6CDD в TrDos.Descriptor, обнуляет #5D10.
; Вызывает TR-DOS
; с A=0, C=#0E, затем JP #6149, то есть повторно запускает начальный блок, а не удаляет
; сохранение.
; In:
;   C — причина, 0 битва, неноль срок
; Out:
;   управление #6149, обычного возврата нет
; Corrupt:
;   HL, DE, BC, AF, HL', DE', BC', AF', IX, IY не сохраняются как контракт вызывающего кода,
;   обычного возврата нет. SP заменяется на #5F98, I=#3F, IM 1, затем TR-DOS и JP #6149
; Note:
;   экран, TR-DOS, системные переменные, стек, режим прерываний
; -----------------------------------------
Entry           PUSH BC
                LD A, #42
                LD BC, #0000
                LD DE, #1820
                CALL Engine.ClearRectangle                                      ; обнулить пиксели прямоугольника и заполнить его атрибуты
                LD DE, Engine.LoadFile.GameDiskText                             ; сообщение с требованием вставить диск с игрой
                LD BC, #0B06
                CALL WaitDefeatKey
                LD DE, Screen.Pixels                                            ; начало видимой пиксельной области Spectrum
                LD HL, Overlay.Defeat.WaitDefeatKey.ScreenFile                  ; девятибайтное имя экрана BAD для итогового окна поражения
                CALL Engine.LoadFile                                            ; загрузить именованный файл через TR-DOS
                LD C, B
                LD DE, #160B
                LD A, #42
                CALL Engine.DrawFrame                                           ; нарисовать рамку окна из восьми одноклеточных элементов
                POP BC
                LD A, C
                AND A
                LD DE, Overlay.Defeat.WaitDefeatKey.BattleEndText               ; сообщение об окончательной гибели героя в битве
                JR Z, .RestartGame                                              ; переход, если герой погиб в бою, входная причина C равна 0

                LD DE, Overlay.Defeat.WaitDefeatKey.DeadlineText                ; сообщение об истечении срока поисков талисмана

                ; поражение возвращает системные IM 1 и стек BASIC, затем заново загружает
                ; исходный KB.co
.RestartGame    LD B, #03
                CALL WaitDefeatKey
                IM 1
                LD A, #3F
                LD I, A
                XOR A
                CALL State.BankDriver                                           ; переключение логического банка через установленный драйвер памяти
                LD SP, Runtime.RestartSP                                        ; вершина стека перед повторной загрузкой BL3
                LD HL, Engine.LoadFile.BootFile                                 ; девятибайтное имя KB.co для перезапуска начального модуля
                LD DE, TrDos.Descriptor
                LD BC, #0009
                LDIR
                LD (TrDos.Error), A
                LD C, #0E
                XOR A
                CALL TrDos.Service                                              ; вызов сервиса TR-DOS, номер операции находится в C
                JP Startup.DecodeBoot                                           ; вход повторно загруженного BL3 при возврате к начальному меню

; -----------------------------------------
; печать сообщения поражения и ожидание действия
; Передаёт B/DE в #7117, затем ставит B=#FF и хвостовым JP вызывает ожидание #7BF4.
; In:
;   DE — сообщение, B — строка
; Out:
;   возврат из общего ожидания
; Corrupt:
;   BC, HL', DE', BC', AF' при наличии числовых управляющих вставок в переданной строке #7117.
;   HL, DE, AF, IX, IY сохранены, B устанавливается в #FF перед общим ожиданием #7BF4
; Note:
;   экран и регистры по процедурам ядра
; -----------------------------------------
WaitDefeatKey   CALL Engine.PrintMessage                                        ; разобрать строку сообщения с управляющими кодами
                LD B, #FF
                JP Engine.WaitOrInput

.ScreenFile     EQU $+2                                                         ; девятибайтное имя экрана BAD для итогового окна поражения
                DB #00, #7B, #42, #41, #44, #20, #20, #20
.BattleEndText  EQU $+3                                                         ; сообщение об окончательной гибели героя в битве
                DB #20, #20, #43, #11, #01, #0E, #8A, #20
                DB #AD, #A5, #E1, #E7, #A0, #E1, #E2, #EC
                DB #EE, #0D, #2A, #ED, #E2, #A0, #20, #A1
                DB #A8, #E2, #A2, #A0, #20, #A1, #EB, #AB
                DB #A0, #0D, #2A, #A1, #EB, #AB, #A0, #20
                DB #A4, #AB, #EF, #20, #E2, #A5, #A1, #EF
                DB #0D, #2A, #AF, #AE, #E1, #AB, #A5, #A4
                DB #AD, #A5, #A9, #2C, #0D, #2A, #E2, #EB
                DB #20, #E5, #E0, #A0, #A1, #E0, #AE, #0D
                DB #2A, #E1, #E0, #A0, #A6, #A0, #AB, #E1
                DB #EF, #2C, #20, #AD, #AE, #0D, #2A, #A2
                DB #E0, #A0, #A3, #AE, #A2, #20, #A1, #EB
                DB #AB, #AE, #0D, #2A, #E1, #AB, #A8, #E8
                DB #AA, #AE, #AC, #20, #AC, #AD, #AE, #A3
                DB #AE, #2E, #0D, #2A, #0D, #00, #93, #20
                DB #91, #92, #90, #80, #8D, #9B, #20, #8C
                DB #88, #94, #8E, #82, #0D, #2A, #AD, #A5
                DB #20, #AE, #E1, #E2, #A0, #AB, #AE, #E1
                DB #EC, #0D, #2A, #A7, #A0, #E9, #A8, #E2
                DB #AD, #A8, #AA, #AE, #A2, #0D, #2A, #A8
                DB #20, #E1, #AF, #E3, #E1, #E2, #EF, #0D
                DB #2A, #AD, #A5, #E1, #AA, #AE, #AB, #EC
                DB #AA, #AE, #20, #AB, #A5, #E2, #0D, #2A
                DB #AE, #AD, #A0, #20, #A1, #EB, #AB, #A0
                DB #0D, #2A, #E0, #A0, #A7, #AE, #E0, #A5
                DB #AD, #A0, #2E, #2E, #2E, #0D, #2A, #00
.DeadlineText   EQU $                                                           ; сообщение об истечении срока поисков талисмана
                DB #11, #01, #0E, #92, #9B, #20, #8D, #85
                DB #20, #93, #91, #8F, #85, #8B, #20, #21
                DB #0D, #2A, #0D, #00, #8C, #A0, #A3, #A8
                DB #E7, #A5, #E1, #AA, #A8, #A9, #0D, #2A
                DB #E2, #A0, #AB, #A8, #E1, #AC, #A0, #AD
                DB #0D, #2A, #E2, #A0, #AA, #20, #A8, #20
                DB #AE, #E1, #E2, #A0, #AB, #E1, #EF, #0D
                DB #2A, #AB, #A5, #A6, #A0, #E2, #EC, #0D
                DB #2A, #AF, #AE, #A3, #E0, #A5, #A1, #A5
                DB #AD, #AD, #EB, #AC, #0D, #2A, #A2, #20
                DB #A3, #AB, #E3, #A1, #A8, #AD, #A0, #E5
                DB #0D, #2A, #A7, #A5, #AC, #AB, #A8, #2E
                DB #0D, #2A, #0D, #00, #81, #A5, #A7, #20
                DB #AD, #A5, #A3, #AE, #0D, #2A, #AF, #A5
                DB #E0, #A5, #AC, #A8, #E0, #A8, #A5, #20
                DB #AD, #A5, #0D, #2A, #AF, #E0, #A5, #A2
                DB #E0, #A0, #E2, #A8, #AB, #AE, #E1, #EC
                DB #20, #A2, #0D, #2A, #84, #AE, #A1, #E0
                DB #EB, #A9, #20, #8C, #A8, #E0, #2C, #0D
                DB #2A, #A0, #20, #AE, #A1, #A5, #E0, #AD
                DB #E3, #AB, #AE, #E1, #EC, #0D, #2A, #86
                DB #A5, #E1, #E2, #AE, #AA, #AE, #A9, #0D
                DB #2A, #83, #E0, #A0, #A6, #A4, #A0, #AD
                DB #E1, #AA, #AE, #A9, #0D, #2A, #82, #8E
                DB #89, #8D, #8E, #89, #2E, #0D, #2A, #00
                DB #6F, #76, #65, #72, #6C, #61, #79

                assert $ = #B40A
                endmodule
                endmodule
