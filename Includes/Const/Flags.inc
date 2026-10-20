; позиции битов и маски, объявления EQU не выделяют память
; *_BIT применяется в BIT/SET/RES, имя без суффикса задаёт маску 1 << *_BIT
; схемы байтов находятся у полей структур и рабочих переменных
                ifndef _CONST_FLAGS_
                define _CONST_FLAGS_

; битовые флаги, группа AIMode
; поле или контекст: Battle.AnimatePath.TurnMode
AI_REPEAT_BIT   EQU 0                                                           ; флаг, режим отложенного прохода ИИ требует отметки AI_DEFERRED_BIT
; поле или контекст: Battle.AnimatePath.TurnMode
AI_NO_WAIT_BIT  EQU 1                                                           ; флаг, повторный проход ИИ запрещает снова откладывать отряд за своим соседом
AI_REPEAT       EQU 1 << AI_REPEAT_BIT                                          ; маска, режим отложенного прохода ИИ требует отметки AI_DEFERRED_BIT
AI_NO_WAIT      EQU 1 << AI_NO_WAIT_BIT                                         ; маска, повторный проход ИИ запрещает снова откладывать отряд за своим соседом

; битовые флаги, группа AISpell
; поле или контекст: Battle.SpendAIMagic.NoFreeze..NoSubjugate
SPELL_BLOCK_BIT EQU 0                                                           ; флаг, это заклинание исключено из выбора ИИ в текущей попытке
SPELL_BLOCK     EQU 1 << SPELL_BLOCK_BIT                                        ; маска, это заклинание исключено из выбора ИИ в текущей попытке

; битовые флаги, группа AyAmplitude
; поле или контекст: буфер регистра амплитуды AY, (HL)
AY_ENVELOPE_BIT EQU 4                                                           ; флаг, регистр амплитуды канала AY использует аппаратную огибающую
AY_ENVELOPE     EQU 1 << AY_ENVELOPE_BIT                                        ; маска, регистр амплитуды канала AY использует аппаратную огибающую

; битовые флаги, группа BattleField
; поле или контекст: Battle.FinishField.Flags
HERO_WARD_BIT   EQU 0                                                           ; флаг, армия героя защищена магическим щитом
; поле или контекст: Battle.FinishField.Flags
ENEMY_WARD_BIT  EQU 1                                                           ; флаг, армия противника защищена магическим щитом
; поле или контекст: Battle.FinishField.Flags
SPELL_USED_BIT  EQU 2                                                           ; флаг, попытка магии героя уже использована в текущем раунде
HERO_WARD       EQU 1 << HERO_WARD_BIT                                          ; маска, армия героя защищена магическим щитом
ENEMY_WARD      EQU 1 << ENEMY_WARD_BIT                                         ; маска, армия противника защищена магическим щитом
SPELL_USED      EQU 1 << SPELL_USED_BIT                                         ; маска, попытка магии героя уже использована в текущем раунде

; битовые флаги, группа BattleKind
; поле или контекст: Battle.FinishField.FieldKind
FIELD_SPEC_BIT  EQU 7                                                           ; флаг, особый режим боя с готовой маской поля и создаваемой армией противника
FIELD_SPEC      EQU 1 << FIELD_SPEC_BIT                                         ; маска, особый режим боя с готовой маской поля и создаваемой армией противника

; битовые флаги, группа BattleTarget
; поле или контекст: FBattleTarget.Side
TARGET_SKIP_BIT EQU 7                                                           ; флаг, цель полёта уже проверена и исключена из следующих попыток
TARGET_SKIP     EQU 1 << TARGET_SKIP_BIT                                        ; маска, цель полёта уже проверена и исключена из следующих попыток

; битовые флаги, группа BattleTile
; поле или контекст: BattleTile.IndexAndFlags
TILE_MIRROR_BIT EQU 7                                                           ; флаг, горизонтальное отражение фонового тайла, переносится в Flags экранного объекта
TILE_MIRROR     EQU 1 << TILE_MIRROR_BIT                                        ; маска, горизонтальное отражение фонового тайла, переносится в Flags экранного объекта

; битовые флаги, группа BattleUnit
; поле или контекст: FBattleUnit.Flags, FSoldier.MoveFlags
UNIT_MAGIC_BIT  EQU 0                                                           ; флаг, тип отряда использует магическое дальнее действие
; поле или контекст: FBattleUnit.Flags, FSoldier.MoveFlags
UNIT_SHOT_BIT   EQU 1                                                           ; флаг, тип отряда использует обычную дальнюю атаку
; поле или контекст: FBattleUnit.Flags, FSoldier.MoveFlags
UNIT_FLY_BIT    EQU 2                                                           ; флаг, способность к полёту, доступность действия дополнительно зависит от эффекта
; поле или контекст: FBattleUnit.Flags
UNIT_MARK_BIT   EQU 5                                                           ; флаг, временная отметка соседства или кандидата в текущем проходе выбора цели
; поле или контекст: FBattleUnit.Flags
UNIT_SKIP_BIT   EQU 6                                                           ; флаг, временно исключить отряд из повторного выбора цели
; поле или контекст: FBattleUnit.Flags
UNIT_UNRULE_BIT EQU 7                                                           ; флаг, численность отряда превышает предел управления героя
UNIT_MAGIC      EQU 1 << UNIT_MAGIC_BIT                                         ; маска, тип отряда использует магическое дальнее действие
UNIT_SHOT       EQU 1 << UNIT_SHOT_BIT                                          ; маска, тип отряда использует обычную дальнюю атаку
UNIT_FLY        EQU 1 << UNIT_FLY_BIT                                           ; маска, способность к полёту, доступность действия дополнительно зависит от эффекта
UNIT_MARK       EQU 1 << UNIT_MARK_BIT                                          ; маска, временная отметка соседства или кандидата в текущем проходе выбора цели
UNIT_SKIP       EQU 1 << UNIT_SKIP_BIT                                          ; маска, временно исключить отряд из повторного выбора цели
UNIT_UNRULE     EQU 1 << UNIT_UNRULE_BIT                                        ; маска, численность отряда превышает предел управления героя

; битовые флаги, группа BattleUnitAI
; поле или контекст: FBattleUnit.Flags
AI_DEFERRED_BIT EQU 3                                                           ; флаг, действие отряда ИИ отложено до повторного прохода армии с режимом 3
; поле или контекст: FBattleUnit.Flags
AI_DONE_BIT     EQU 4                                                           ; флаг, обработка отряда ИИ в текущем раунде завершена
AI_DEFERRED     EQU 1 << AI_DEFERRED_BIT                                        ; маска, действие отряда ИИ отложено до повторного прохода армии с режимом 3
AI_DONE         EQU 1 << AI_DONE_BIT                                            ; маска, обработка отряда ИИ в текущем раунде завершена

; битовые флаги, группа BattleUnitHero
; поле или контекст: FBattleUnit.Flags
HERO_ACTED_BIT  EQU 3                                                           ; флаг, отряд героя уже выбирался в текущем круге выбора действующего отряда
; поле или контекст: FBattleUnit.Flags
HERO_REACH_BIT  EQU 4                                                           ; флаг, отряд героя достижим для проверяемого отряда ИИ
HERO_ACTED      EQU 1 << HERO_ACTED_BIT                                         ; маска, отряд героя уже выбирался в текущем круге выбора действующего отряда
HERO_REACH      EQU 1 << HERO_REACH_BIT                                         ; маска, отряд героя достижим для проверяемого отряда ИИ

; битовые флаги, группа CastleFlags
; поле или контекст: FCastle.Flags
CASTLE_OFF_BIT  EQU 0                                                           ; замок выключен из обходов стратегических объектов и подсчёта владений
CASTLE_OFF      EQU 1 << CASTLE_OFF_BIT                                         ; маска, замок выключен из обходов стратегических объектов и подсчёта владений

; битовые флаги, группа ContinentAccess
; поле или контекст: FPerson.MapFlags
SEA_ACCESS_BIT  EQU 0                                                           ; флаг, открыт континент 2 и разрешён вход в морское меню перехода
SEA_ACCESS      EQU 1 << SEA_ACCESS_BIT                                         ; маска, открыт континент 2 и разрешён вход в морское меню перехода

; битовые флаги, группа CursorBackdropMode
; поле или контекст: Loader.Menu.CursorBackdrop, входной C
CUR_RESTORE_BIT EQU 7                                                           ; флаг, восстановить фон курсора из буфера, при 0 сохранить экранный фон в буфер
CUR_RESTORE     EQU 1 << CUR_RESTORE_BIT                                        ; маска, восстановить фон курсора из буфера, при 0 сохранить экранный фон в буфер

; битовые флаги, группа DefenseSpell
; поле или контекст: State.DefenseSpell
DEFENSE_OK_BIT  EQU 0                                                           ; разрешает предложить магическое вмешательство героя в защиту замка
DEFENSE_OK      EQU 1 << DEFENSE_OK_BIT                                         ; маска, разрешает предложить магическое вмешательство героя в защиту замка

; битовые флаги, группа EventFlags
; поле или контекст: State.EventFlags
EVENT_LOCK_BIT  EQU 7                                                           ; временно запрещает развитие отрядов, нападения на замок и магическое вмешательство
EVENT_LOCK      EQU 1 << EVENT_LOCK_BIT                                         ; маска, временно запрещает развитие отрядов, нападения на замок и магическое вмешательство

; битовые флаги, группа ExpenseFlags
; поле или контекст: FExpense.Flags
EXP_ACTIVE_BIT  EQU 6                                                           ; статья расходов существует и показана в текущем недельном расчёте
; поле или контекст: FExpense.Flags
EXP_PAY_BIT     EQU 7                                                           ; статья выбрана для оплаты и включается в SumExpenses
EXP_ACTIVE      EQU 1 << EXP_ACTIVE_BIT                                         ; маска, статья расходов существует и показана в текущем недельном расчёте
EXP_PAY         EQU 1 << EXP_PAY_BIT                                            ; маска, статья выбрана для оплаты и включается в SumExpenses

; битовые флаги, группа HeroMove
; поле или контекст: FPerson.MoveFlags
HERO_SIEGE_BIT  EQU 5                                                           ; флаг, герой располагает осадным орудием
HERO_SIEGE      EQU 1 << HERO_SIEGE_BIT                                         ; маска, герой располагает осадным орудием

; битовые флаги, группа HeroSpells
; поле или контекст: State.Spells, FPerson.Spells
SPELL_KNOWN_BIT EQU 0                                                           ; флаг, заклинание изучено героем и включается в список доступной магии
SPELL_KNOWN     EQU 1 << SPELL_KNOWN_BIT                                        ; маска, заклинание изучено героем и включается в список доступной магии

; битовые флаги, группа Input
; поле или контекст: порт Kempston #1F, KempstonPort
JOY_FIRE_BIT    EQU 4                                                           ; флаг, кнопка действия Kempston нажата
JOY_FIRE        EQU 1 << JOY_FIRE_BIT                                           ; маска, кнопка действия Kempston нажата

; битовые флаги, группа MapArmyFlags
; поле или контекст: FMapArmy.Flags
ARMY_FREE_BIT   EQU 0                                                           ; свободная либо выключенная запись внешней армии
; поле или контекст: FMapArmy.Flags
ARMY_MOVED_BIT  EQU 4                                                           ; внешняя армия уже обработана в текущем проходе движения
; поле или контекст: FMapArmy.Flags
ARMY_WATER_BIT  EQU 5                                                           ; выбирает водный класс перемещения внешней армии либо шестибайтовой группы
ARMY_FREE       EQU 1 << ARMY_FREE_BIT                                          ; маска, свободная либо выключенная запись внешней армии
ARMY_MOVED      EQU 1 << ARMY_MOVED_BIT                                         ; маска, внешняя армия уже обработана в текущем проходе движения
ARMY_WATER      EQU 1 << ARMY_WATER_BIT                                         ; маска, выбирает водный класс перемещения внешней армии либо шестибайтовой группы

; битовые флаги, группа MapCell
; поле или контекст: MapConst
MAP_MIRROR_BIT  EQU 6                                                           ; флаг, тайл клетки стратегической карты выводится с горизонтальным отражением
MAP_MIRROR      EQU 1 << MAP_MIRROR_BIT                                         ; маска, тайл клетки стратегической карты выводится с горизонтальным отражением

; битовые флаги, группа MapItemFlags
; поле или контекст: FMapItem.Flags
ITEM_USED_BIT   EQU 0                                                           ; находка использована и исключена из обработки
ITEM_USED       EQU 1 << ITEM_USED_BIT                                          ; маска, находка использована и исключена из обработки

; битовые флаги, группа MapSiteFlags
; поле или контекст: FMapSite.Flags
SITE_OFF_BIT    EQU 0                                                           ; общий префикс стратегической записи выключает её из обхода
SITE_OFF        EQU 1 << SITE_OFF_BIT                                           ; маска, общий префикс стратегической записи выключает её из обхода

; битовые флаги, группа MapTroopFlags
; поле или контекст: FMapTroop.Flags
TROOP_FREE_BIT  EQU 0                                                           ; свободная либо использованная шестибайтовая запись существ карты
TROOP_FREE      EQU 1 << TROOP_FREE_BIT                                         ; маска, свободная либо использованная шестибайтовая запись существ карты

; битовые флаги, группа MapViewModes
; поле или контекст: Overlay.Maps.WaitMapKey.ViewModes
VIEW_WORLD_BIT  EQU 0                                                           ; флаг, в меню доступна полная карта текущего континента
; поле или контекст: Overlay.Maps.WaitMapKey.ViewModes
VIEW_AIR_BIT    EQU 1                                                           ; флаг, в меню доступен вид с высоты, в армии найден летающий тип
VIEW_WORLD      EQU 1 << VIEW_WORLD_BIT                                         ; маска, в меню доступна полная карта текущего континента
VIEW_AIR        EQU 1 << VIEW_AIR_BIT                                           ; маска, в меню доступен вид с высоты, в армии найден летающий тип

; битовые флаги, группа MenuAreaFlags
; поле или контекст: FMenuArea.XAndActive
MENU_ACTIVE_BIT EQU 7                                                           ; флаг, область меню подсвечена обменом INK и PAPER
MENU_ACTIVE     EQU 1 << MENU_ACTIVE_BIT                                        ; маска, область меню подсвечена обменом INK и PAPER

; битовые флаги, группа MenuControls
; поле или контекст: Loader.Menu.ReadControls, C/A и MenuState.KeyMask
MENU_FIRE_BIT   EQU 0                                                           ; флаг, действие или завершение выбора
; поле или контекст: Loader.Menu.ReadControls, C/A и MenuState.KeyMask
MENU_DOWN_BIT   EQU 1                                                           ; флаг, движение вниз
; поле или контекст: Loader.Menu.ReadControls, C/A и MenuState.KeyMask
MENU_UP_BIT     EQU 2                                                           ; флаг, движение вверх
; поле или контекст: Loader.Menu.ReadControls, C/A и MenuState.KeyMask
MENU_RIGHT_BIT  EQU 3                                                           ; флаг, движение вправо
; поле или контекст: Loader.Menu.ReadControls, C/A и MenuState.KeyMask
MENU_LEFT_BIT   EQU 4                                                           ; флаг, движение влево
MENU_FIRE       EQU 1 << MENU_FIRE_BIT                                          ; маска, действие или завершение выбора
MENU_DOWN       EQU 1 << MENU_DOWN_BIT                                          ; маска, движение вниз
MENU_UP         EQU 1 << MENU_UP_BIT                                            ; маска, движение вверх
MENU_RIGHT      EQU 1 << MENU_RIGHT_BIT                                         ; маска, движение вправо
MENU_LEFT       EQU 1 << MENU_LEFT_BIT                                          ; маска, движение влево

; битовые флаги, группа MoveFlags
; поле или контекст: State.MoveFlags, FPerson.MoveFlags
HERO_HIDE_BIT   EQU 2                                                           ; временно исключает изображение героя из локального окна
; поле или контекст: State.MoveFlags
HERO_FACE_BIT   EQU 3                                                           ; горизонтальное отражение изображения героя
; поле или контекст: State.MoveFlags
SHIP_FACE_BIT   EQU 4                                                           ; альтернативное горизонтальное представление корабля
HERO_HIDE       EQU 1 << HERO_HIDE_BIT                                          ; маска, временно исключает изображение героя из локального окна
HERO_FACE       EQU 1 << HERO_FACE_BIT                                          ; маска, горизонтальное отражение изображения героя
SHIP_FACE       EQU 1 << SHIP_FACE_BIT                                          ; маска, альтернативное горизонтальное представление корабля

; битовые флаги, группа RleFlags
; поле или контекст: FRleState.Flags
RLE_ROW_BIT     EQU 0                                                           ; флаг, поток пикселей обходится горизонтальными строками, при 0 вертикальными блоками
; поле или контекст: FRleState.Flags
RLE_RUN_BIT     EQU 2                                                           ; флаг, продолжается RLE-серия, остаток и повторяемый байт находятся в альтернативных B и C
; поле или контекст: FRleState.Flags
RLE_ATTR_BIT    EQU 3                                                           ; флаг, распаковщик перешёл к линейному выводу атрибутов
RLE_ROW         EQU 1 << RLE_ROW_BIT                                            ; маска, поток пикселей обходится горизонтальными строками, при 0 вертикальными блоками
RLE_RUN         EQU 1 << RLE_RUN_BIT                                            ; маска, продолжается RLE-серия, остаток и повторяемый байт находятся в альтернативных B и C
RLE_ATTR        EQU 1 << RLE_ATTR_BIT                                           ; маска, распаковщик перешёл к линейному выводу атрибутов

; битовые флаги, группа SampleFlags
; поле или контекст: FSampleStep.NoiseAndFlags
SMP_ADD_BIT     EQU 5                                                           ; флаг, смещение семпла прибавляется к периоду ноты, при 0 вычитается
; поле или контекст: FSampleStep.NoiseAndFlags
SMP_MUTE_T_BIT  EQU 6                                                           ; флаг, тон текущего канала отключён шагом семпла
; поле или контекст: FSampleStep.NoiseAndFlags
SMP_MUTE_N_BIT  EQU 7                                                           ; флаг, шум текущего канала отключён шагом семпла
SMP_ADD         EQU 1 << SMP_ADD_BIT                                            ; маска, смещение семпла прибавляется к периоду ноты, при 0 вычитается
SMP_MUTE_T      EQU 1 << SMP_MUTE_T_BIT                                         ; маска, тон текущего канала отключён шагом семпла
SMP_MUTE_N      EQU 1 << SMP_MUTE_N_BIT                                         ; маска, шум текущего канала отключён шагом семпла

; битовые флаги, группа SamplePeriodOffset
; поле или контекст: Music.Menu.ReadSampleStep/CalcTonePeriod, D
SLIDE_ADD_BIT   EQU 4                                                           ; флаг, упакованное смещение периода в D положительное, снимается перед ADD HL,DE
SLIDE_ADD       EQU 1 << SLIDE_ADD_BIT                                          ; маска, упакованное смещение периода в D положительное, снимается перед ADD HL,DE

; битовые флаги, группа ScreenAttribute
; поле или контекст: Screen.Attributes
ATTR_FLASH_BIT  EQU 7                                                           ; флаг, атрибут знакоместа мигает, используется для отметки героя в виде с высоты
ATTR_FLASH      EQU 1 << ATTR_FLASH_BIT                                         ; маска, атрибут знакоместа мигает, используется для отметки героя в виде с высоты

; битовые флаги, группа ScreenObjectFlags
; поле или контекст: FScreenObject20.Flags
DRAW_NUMBER_BIT EQU 5                                                           ; после рисунка выводит численную подпись экранного объекта
; поле или контекст: FScreenObject20.Flags
FRONT_FLIP_BIT  EQU 6                                                           ; горизонтально отражает передний маскированный слой экранного объекта
DRAW_NUMBER     EQU 1 << DRAW_NUMBER_BIT                                        ; маска, после рисунка выводит численную подпись экранного объекта
FRONT_FLIP      EQU 1 << FRONT_FLIP_BIT                                         ; маска, горизонтально отражает передний маскированный слой экранного объекта

; битовые флаги, группа SoldierExtra
; поле или контекст: FSoldier.ExtraFlags
MAGIC_IMM_BIT   EQU 1                                                           ; флаг, тип цели невосприимчив к целевому магическому действию
; поле или контекст: FSoldier.ExtraFlags
HALF_HIT_BIT    EQU 2                                                           ; флаг, тип атакующего допускает вероятностный удар с делением численности цели на два
; поле или контекст: FSoldier.ExtraFlags
BANISH_OK_BIT   EQU 3                                                           ; флаг, тип цели допускает выбор ИИ для заклинания возвращения в могилу
MAGIC_IMM       EQU 1 << MAGIC_IMM_BIT                                          ; маска, тип цели невосприимчив к целевому магическому действию
HALF_HIT        EQU 1 << HALF_HIT_BIT                                           ; маска, тип атакующего допускает вероятностный удар с делением численности цели на два
BANISH_OK       EQU 1 << BANISH_OK_BIT                                          ; маска, тип цели допускает выбор ИИ для заклинания возвращения в могилу

; битовые флаги, группа SoldierMove
; поле или контекст: FSoldier.MoveFlags
DRAIN_HIT_BIT   EQU 7                                                           ; флаг, атакующий тип восстанавливает численность за счёт нанесённого воздействия
DRAIN_HIT       EQU 1 << DRAIN_HIT_BIT                                          ; маска, атакующий тип восстанавливает численность за счёт нанесённого воздействия

; битовые флаги, группа SoldierSpecial
; поле или контекст: FSoldier.SpecialFlags
DRAIN_CAP_BIT   EQU 0                                                           ; флаг, восстановление численности типа ограничено исходным InitialCount
; поле или контекст: FSoldier.SpecialFlags
NO_DRAIN_BIT    EQU 1                                                           ; флаг, тип жертвы запрещает атакующему восстанавливать численность за нанесённый ей урон
; поле или контекст: FSoldier.SpecialFlags
STORY_END_BIT   EQU 3                                                           ; флаг, поражение от этого типа запускает сюжетное окончание
DRAIN_CAP       EQU 1 << DRAIN_CAP_BIT                                          ; маска, восстановление численности типа ограничено исходным InitialCount
NO_DRAIN        EQU 1 << NO_DRAIN_BIT                                           ; маска, тип жертвы запрещает атакующему восстанавливать численность за нанесённый ей урон
STORY_END       EQU 1 << STORY_END_BIT                                          ; маска, поражение от этого типа запускает сюжетное окончание

; битовые флаги, группа StartupEdit
; поле или контекст: Startup.Interrupt.EditFlags, State.ViewFlags
TEXT_DIGIT_BIT  EQU 4                                                           ; флаг, разрешены только цифры и служебные коды ввода
; поле или контекст: Startup.Interrupt.EditFlags, State.ViewFlags
TEXT_CURSOR_BIT EQU 5                                                           ; флаг, прерывание рисует мигающий текстовый курсор
; поле или контекст: Startup.Interrupt.EditFlags, State.ViewFlags
TEXT_RUS_BIT    EQU 6                                                           ; флаг, вводимые цифры и буквы преобразуются в русский алфавит
TEXT_DIGIT      EQU 1 << TEXT_DIGIT_BIT                                         ; маска, разрешены только цифры и служебные коды ввода
TEXT_CURSOR     EQU 1 << TEXT_CURSOR_BIT                                        ; маска, прерывание рисует мигающий текстовый курсор
TEXT_RUS        EQU 1 << TEXT_RUS_BIT                                           ; маска, вводимые цифры и буквы преобразуются в русский алфавит

; битовые флаги, группа TownFlags
; поле или контекст: FTown.Flags
TOWN_OFF_BIT    EQU 0                                                           ; город выключен из стратегического обхода и обновления гарнизона
; поле или контекст: FTown.Flags
TOWN_ANGER_BIT  EQU 1                                                           ; флаг, город требует ранней проверки гарнизона и отказывает в сведениях о замке и новом контракте
TOWN_OFF        EQU 1 << TOWN_OFF_BIT                                           ; маска, город выключен из стратегического обхода и обновления гарнизона
TOWN_ANGER      EQU 1 << TOWN_ANGER_BIT                                         ; маска, город требует ранней проверки гарнизона и отказывает в сведениях о замке и новом контракте

; битовые флаги, группа TroopFinancialFlags
; поле или контекст: FTroop.ID
TROOP_DROWN_BIT EQU 5                                                           ; временная отметка утонувшего отряда в старших битах ID недельного расчёта
; поле или контекст: FTroop.ID
TROOP_FLED_BIT  EQU 6                                                           ; временная отметка сбежавшего неоплаченного отряда в ID
; поле или контекст: FTroop.ID
TROOP_REBEL_BIT EQU 7                                                           ; временная отметка отряда для нападения на героя при финансовом либо культовом событии
TROOP_DROWN     EQU 1 << TROOP_DROWN_BIT                                        ; маска, временная отметка утонувшего отряда в старших битах ID недельного расчёта
TROOP_FLED      EQU 1 << TROOP_FLED_BIT                                         ; маска, временная отметка сбежавшего неоплаченного отряда в ID
TROOP_REBEL     EQU 1 << TROOP_REBEL_BIT                                        ; маска, временная отметка отряда для нападения на героя при финансовом либо культовом событии

; битовые флаги, группа UnitAbilities
; поле или контекст: FSoldier.MoveFlags
UNIT_AFLOAT_BIT EQU 6                                                           ; способность типа защищает от отметки утонувшего при утрате корабля
UNIT_AFLOAT     EQU 1 << UNIT_AFLOAT_BIT                                        ; маска, способность типа защищает от отметки утонувшего при утрате корабля

; битовые флаги, группа UnitExtraFlags
; поле или контекст: FSoldier.ExtraFlags
UNIT_MUTINY_BIT EQU 0                                                           ; при неоплаченном содержании тип выбирает нападение на героя вместо побега
; поле или контекст: FSoldier.ExtraFlags
UNIT_CITY_BIT   EQU 4                                                           ; флаг, тип существ разрешает раннюю городскую проверку даже без установленной отметки города
UNIT_MUTINY     EQU 1 << UNIT_MUTINY_BIT                                        ; маска, при неоплаченном содержании тип выбирает нападение на героя вместо побега
UNIT_CITY       EQU 1 << UNIT_CITY_BIT                                          ; маска, тип существ разрешает раннюю городскую проверку даже без установленной отметки города

; битовые флаги, группа UnitSpecialFlags
; поле или контекст: FSoldier.SpecialFlags
HERO_CARRY_BIT  EQU 2                                                           ; флаг, тип существ способен переносить героя в полёте
HERO_CARRY      EQU 1 << HERO_CARRY_BIT                                         ; маска, тип существ способен переносить героя в полёте

; битовые флаги, группа ViewFlags
; поле или контекст: State.ViewFlags
TEXT_CASE_BIT   EQU 1                                                           ; меняет регистр латинских букв и вариант таблицы перекодировки
; поле или контекст: State.ViewFlags
VIEW_RENDER_BIT EQU 2                                                           ; разрешает обновление экранных объектов из прерывания
TEXT_CASE       EQU 1 << TEXT_CASE_BIT                                          ; маска, меняет регистр латинских букв и вариант таблицы перекодировки
VIEW_RENDER     EQU 1 << VIEW_RENDER_BIT                                        ; маска, разрешает обновление экранных объектов из прерывания

; битовые флаги, группа WorldFacing
; поле или контекст: FMapSite.Flags
OBJECT_FACE_BIT EQU 6                                                           ; горизонтальное отражение стратегического объекта, направления 2..4 ставят, 6..8 снимают
OBJECT_FACE     EQU 1 << OBJECT_FACE_BIT                                        ; маска, горизонтальное отражение стратегического объекта, направления 2..4 ставят, 6..8 снимают

; битовые флаги, группа WorldMap
; поле или контекст: MapCell.FlagsAndTerrain, MapCell, MapConst
MAP_BUSY_BIT    EQU 7                                                           ; флаг, клетка стратегической карты уже занята объектом при генерации
MAP_BUSY        EQU 1 << MAP_BUSY_BIT                                           ; маска, клетка стратегической карты уже занята объектом при генерации

; битовые флаги, группа WorldPicture
; поле или контекст: FMapSite.Flags
SITE_ALT_BIT    EQU 5                                                           ; выбирает альтернативное изображение одноклеточной стратегической записи в PlaceCells
SITE_ALT        EQU 1 << SITE_ALT_BIT                                           ; маска, выбирает альтернативное изображение одноклеточной стратегической записи в PlaceCells

; разряды чисел и пикселей, группа DirectionDelta
; поле или контекст: GetDirection.DeltaX/DeltaY, FPosition.X, FPosition.Y
DELTA_NEG_BIT   EQU 7                                                           ; знак отрицательной однобайтовой разности координат

; разряды чисел и пикселей, группа ExpandedPixelPair
PIX_PAIR_LO_BIT EQU 0                                                           ; младший пиксель удвоенной пары при горизонтальном увеличении глифа
PIX_PAIR_HI_BIT EQU 1                                                           ; старший пиксель удвоенной пары при горизонтальном увеличении глифа

; разряды чисел и пикселей, группа FloatFormat
; поле или контекст: FBattleUnit.Quantity + 1, FloatSignZero.DifferenceSign, FBattleUnit.Quantity
FLOAT_SIGN_BIT  EQU 7                                                           ; позиция знака в байте мантиссы пятибайтового числа ROM

; разряды чисел и пикселей, группа GlyphMask
; поле или контекст: Startup.DrawGlyph.ShiftMask, DrawGlyph.ShiftMask
MASK_FILL_BIT   EQU 7                                                           ; позиция старшего бита маски, заполняемого единицей при смещении шестипиксельного символа

; разряды чисел и пикселей, группа ManaBar
; поле или контекст: Battle.InputLoop.PartialBits
BAR_FILL_BIT    EQU 7                                                           ; позиция левого пикселя, заполняемого при построении частичного деления шкалы маны

; разряды чисел и пикселей, группа MapTerrain
; поле или контекст: MapCell
TERRAIN_LSB_BIT EQU 0                                                           ; младший разряд байта местности, исходный StepMapTroops снимает его после поглощения находки, бит занятости при этом отдельно не снимается

; разряды чисел и пикселей, группа MiniMapParity
COL_ODD_BIT     EQU 0                                                           ; младший разряд столбца миникарты, нечётный столбец требует перестановки полубайтов узора
ROW_ODD_BIT     EQU 0                                                           ; младший разряд номера строки миникарты, нечётная строка выбирает вторую половину знакоместа

; разряды чисел и пикселей, группа NumericUnitID
; поле или контекст: FBattleUnit.UnitID
UNIT_ID_HI_BIT  EQU 4                                                           ; позиция старшего значащего бита ID, при допустимых ID 1..25 единица означает диапазон 16..25

; разряды чисел и пикселей, группа OriginalPassClear
; поле или контекст: Battle.SelectActor.ClearPassFlags, FBattleArmy.Second, FBattleArmy.Third,
;     FBattleArmy.Fourth
PASS_CLEAR_BIT  EQU 3                                                           ; позиция бита, снимаемого исходным проходом очистки SelectActor в четырёх полях за первой записью

; разряды чисел и пикселей, группа PixelLayout
; поле или контекст: байт пикселей Spectrum, ShiftCursorL.PixelByte
PIXEL_RIGHT_BIT EQU 0                                                           ; позиция правого пикселя в экранном байте Spectrum
; поле или контекст: байт пикселей Spectrum, ShiftCursorR.PixelByte
PIXEL_LEFT_BIT  EQU 7                                                           ; позиция левого пикселя в экранном байте Spectrum

; разряды чисел и пикселей, группа RandomRange
; поле или контекст: Startup.RandomRange.SeedZ, State.RandomState
RNG_FEED_BIT    EQU 0                                                           ; позиция младшего бита слова, принимающего перенос старшего бита при циклическом обновлении генератора
; поле или контекст: H в дробной половине произведения, RandomScaled.RoundResult
RNG_ROUND_BIT   EQU 7                                                           ; позиция старшего бита дробной половины произведения, единица требует округления вверх

; разряды чисел и пикселей, группа SailMenuMask
SEA_FIRST_BIT   EQU 0                                                           ; младший разряд временной маски списка морских континентов, всегда разрешает первый континент после сдвига исходных MapFlags

; разряды чисел и пикселей, группа TRDosResult
; поле или контекст: C после функции TR-DOS #0A
FILE_MISS_BIT   EQU 7                                                           ; позиция бита результата поиска TR-DOS, C=#FF означает отсутствие файла, при находке C содержит номер 0..127

; разряды чисел и пикселей, группа TownRefresh
; поле или контекст: RefreshTowns.RandomResult
TOWN_ROLL_BIT   EQU 0                                                           ; младший бит результата RandomScaled(1), единица откладывает обновление города

; разряды чисел и пикселей, группа TownXCheck
; поле или контекст: FTown.X
TOWN_XCHECK_BIT EQU 1                                                           ; бит координаты X города, исходный код проверяет гарнизон только при его установке, это не флаг FTown.Flags

; разряды чисел и пикселей, группа TreasureChoice
GIFT_MAP_BIT    EQU 0                                                           ; младший разряд случайного результата 0..1, 1 выбирает предложение награды картой текущего континента

; разряды адреса, группа BeepPointer
; поле или контекст: Loader.Menu.MenuState.BeepRandom.High
BEEP_WRAP_BIT   EQU 5                                                           ; разряд старшего байта указателя генератора бипера, сброс удерживает адрес последовательности в диапазоне первых 8 Кбайт при исходном нулевом указателе

; начальные позиции самомодифицируемых команд, группа ContinentMapOpcode
; поле или контекст: State.MapFlags, изменяемые BIT/SET
MAP_INDEX_BIT   EQU 0                                                           ; начальный номер бита шаблонов проверки и открытия карт континентов, фактический номер вычисляется из номера континента и переписывается в opcode

; начальные позиции самомодифицируемых команд, группа ExplorationOpcode
; поле или контекст: Overlay.Maps.IsCellExplored.ExploreTestOp
FOG_INDEX_BIT   EQU 0                                                           ; начальный номер бита шаблона проверки разведки, фактический номер 7-(X AND 7) переписывается в opcode

; начальные позиции самомодифицируемых команд, группа FieldColumn
; поле или контекст: Battle.FinishField.ObstacleRows, FObstacleRows.First
FIELD_COL_BIT   EQU 0                                                           ; исходная позиция бита в шаблоне самоменяемой проверки либо установки столбца поля

; начальные позиции самомодифицируемых команд, группа FogBitmap
; поле или контекст: UpdateLocalView.FogSetOpcode
FOG_SEED_BIT    EQU 7                                                           ; начальный номер бита команды SET в карте открытия, до исполнения операнд FogSetOpcode меняется по координате X

; начальные позиции самомодифицируемых команд, группа PuzzleBitOpcode
; поле или контекст: Overlay.Capture.NewMapPiece.TestPiece/OpenPiece
PIECE_INDEX_BIT EQU 0                                                           ; начальный номер бита шаблонов BIT/SET карты головоломки, фактический номер 0..4 переписывается вычисленным opcode перед выполнением

                endif
