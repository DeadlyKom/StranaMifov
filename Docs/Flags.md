# Битовые флаги и именованные позиции

[Оглавление](README.md) · [Структуры](Structures.md) · [Исходные объявления Flags.inc](../Includes/Const/Flags.inc)

Позиции битов объявлены константами с окончанием `_BIT`, как в HoMM. `BIT`, `SET` и `RES` получают номер позиции 0..7. Для настоящих флагов отдельно объявлена маска без `_BIT`, её значение равно `1 << имя_позиции`. Числовой разряд, разряд адреса и исходный номер бита изменяемой команды не становятся самостоятельными флагами только из-за появления имени.

Констант позиций: **108**. Именованных масок флагов: **82**. Текущих применений в `BIT`/`SET`/`RES`: **386**.

## Реестр констант

| имя позиции | бит | маска | назначение | поле | потребители |
| --- | ---: | --- | --- | --- | --- |
| [`AI_DEFERRED_BIT`](../Includes/Const/Flags.inc#L73) | 3 | [`AI_DEFERRED`](../Includes/Const/Flags.inc#L76) = `#08` | флаг, действие отряда ИИ отложено до повторного прохода армии с режимом 3 | `FBattleUnit.Flags` | [Battle.AIArmyPass](../Source/Battle/AIArmyPass.asm#L34) — `BIT AI_DEFERRED_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L22) — `BIT AI_DEFERRED_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L137) — `SET AI_DEFERRED_BIT, (IY + FBattleUnit.Flags)` |
| [`AI_DONE_BIT`](../Includes/Const/Flags.inc#L75) | 4 | [`AI_DONE`](../Includes/Const/Flags.inc#L77) = `#10` | флаг, обработка отряда ИИ в текущем раунде завершена | `FBattleUnit.Flags` | [Battle.AIArmyPass](../Source/Battle/AIArmyPass.asm#L27) — `BIT AI_DONE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L109) — `SET AI_DONE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L166) — `SET AI_DONE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L173) — `SET AI_DONE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L216) — `SET AI_DONE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L412) — `SET AI_DONE_BIT, (IY + FBattleUnit.Flags)` |
| [`AI_NO_WAIT_BIT`](../Includes/Const/Flags.inc#L11) | 1 | [`AI_NO_WAIT`](../Includes/Const/Flags.inc#L13) = `#02` | флаг, повторный проход ИИ запрещает снова откладывать отряд за своим соседом | `Battle.AnimatePath.TurnMode` | [Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L123) — `BIT AI_NO_WAIT_BIT, A` |
| [`AI_REPEAT_BIT`](../Includes/Const/Flags.inc#L9) | 0 | [`AI_REPEAT`](../Includes/Const/Flags.inc#L12) = `#01` | флаг, режим отложенного прохода ИИ требует отметки AI_DEFERRED_BIT | `Battle.AnimatePath.TurnMode` | [Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L19) — `BIT AI_REPEAT_BIT, A` |
| [`ARMY_FREE_BIT`](../Includes/Const/Flags.inc#L137) | 0 | [`ARMY_FREE`](../Includes/Const/Flags.inc#L142) = `#01` | свободная либо выключенная запись внешней армии | `FMapArmy.Flags` | [Engine.RegenMana](../Source/Engine/RegenMana.asm#L26) — `BIT ARMY_FREE_BIT, (IX + FMapArmy.Flags)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L234) — `BIT ARMY_FREE_BIT, (HL)`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L196) — `SET ARMY_FREE_BIT, (IX + FMapArmy.Flags - FMapArmy.Mana)` |
| [`ARMY_MOVED_BIT`](../Includes/Const/Flags.inc#L139) | 4 | [`ARMY_MOVED`](../Includes/Const/Flags.inc#L143) = `#10` | внешняя армия уже обработана в текущем проходе движения | `FMapArmy.Flags` | [Engine.StepArmies](../Source/Engine/StepArmies.asm#L316) — `SET ARMY_MOVED_BIT, (IX + FMapArmy.Flags)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L495) — `SET ARMY_MOVED_BIT, (IX + FMapArmy.Flags)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L511) — `RES ARMY_MOVED_BIT, (HL)` |
| [`ARMY_WATER_BIT`](../Includes/Const/Flags.inc#L141) | 5 | [`ARMY_WATER`](../Includes/Const/Flags.inc#L144) = `#20` | выбирает водный класс перемещения внешней армии либо шестибайтовой группы | `FMapArmy.Flags` | [Engine.StepArmies](../Source/Engine/StepArmies.asm#L170) — `BIT ARMY_WATER_BIT, (HL)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L393) — `BIT ARMY_WATER_BIT, (HL)`<br>[Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L132) — `BIT ARMY_WATER_BIT, (HL)`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L39) — `BIT ARMY_WATER_BIT, (IX + FMapArmy.Flags - 3)`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L168) — `BIT ARMY_WATER_BIT, (IX + FMapArmy.Flags - FMapArmy.Mana)` |
| [`ATTR_FLASH_BIT`](../Includes/Const/Flags.inc#L236) | 7 | [`ATTR_FLASH`](../Includes/Const/Flags.inc#L237) = `#80` | флаг, атрибут знакоместа мигает, используется для отметки героя в виде с высоты | `Screen.Attributes` | [Overlay.Maps.DrawAerialMap](../Source/Overlays/Maps.asm#L1110) — `SET ATTR_FLASH_BIT, (HL)` |
| [`AY_ENVELOPE_BIT`](../Includes/Const/Flags.inc#L22) | 4 | [`AY_ENVELOPE`](../Includes/Const/Flags.inc#L23) = `#10` | флаг, регистр амплитуды канала AY использует аппаратную огибающую | `буфер регистра амплитуды AY, (HL)` | [Music.Menu.ApplyEnvelope](../Source/Loader/Music.asm#L581) — `SET AY_ENVELOPE_BIT, (HL)` |
| [`BANISH_OK_BIT`](../Includes/Const/Flags.inc#L253) | 3 | [`BANISH_OK`](../Includes/Const/Flags.inc#L256) = `#08` | флаг, тип цели допускает выбор ИИ для заклинания возвращения в могилу | `FSoldier.ExtraFlags` | [Battle.AISpell](../Source/Battle/AISpell.asm#L463) — `BIT BANISH_OK_BIT, D` |
| [`BAR_FILL_BIT`](../Includes/Const/Flags.inc#L363) | 7 | — | позиция левого пикселя, заполняемого при построении частичного деления шкалы маны | `Battle.InputLoop.PartialBits` | [Battle.InputLoop](../Source/Battle/InputLoop.asm#L365) — `SET BAR_FILL_BIT, A` |
| [`BEEP_WRAP_BIT`](../Includes/Const/Flags.inc#L414) | 5 | — | разряд старшего байта указателя генератора бипера, сброс удерживает адрес последовательности в диапазоне первых 8 Кбайт при исходном нулевом указателе | `Loader.Menu.MenuState.BeepRandom.High` | [Loader.Menu.RandomByte](../Source/Loader/Menu/RandomByte.asm#L17) — `RES BEEP_WRAP_BIT, H` |
| [`CASTLE_OFF_BIT`](../Includes/Const/Flags.inc#L89) | 0 | [`CASTLE_OFF`](../Includes/Const/Flags.inc#L90) = `#01` | замок выключен из обходов стратегических объектов и подсчёта владений | `FCastle.Flags` | [Engine.ApplyMoveCode](../Source/Engine/ApplyMoveCode.asm#L109) — `BIT CASTLE_OFF_BIT, (IX + FCastle.Flags)`<br>[Engine.CountOwnCastles](../Source/Engine/CountOwnCastles.asm#L23) — `BIT CASTLE_OFF_BIT, (IX + FCastle.Flags)`<br>[Engine.HasOwnerCastle](../Source/Engine/HasOwnerCastle.asm#L26) — `BIT CASTLE_OFF_BIT, (IX + FCastle.Flags)`<br>[Engine.SumCastleIncome](../Source/Engine/SumCastleIncome.asm#L28) — `BIT CASTLE_OFF_BIT, (IY + FCastle.Flags)`<br>[Engine.TickCastle](../Source/Engine/TickCastle.asm#L72) — `BIT CASTLE_OFF_BIT, (IX + FCastle.Flags)`<br>[Overlay.Capture.Entry](../Source/Overlays/Capture.asm#L389) — `BIT CASTLE_OFF_BIT, (IX + FCastle.Flags)`<br>[Overlay.Info.FindOwnCastle](../Source/Overlays/Info.asm#L493) — `BIT CASTLE_OFF_BIT, (IX + FCastle.Flags - FCastle.Name)` |
| [`COL_ODD_BIT`](../Includes/Const/Flags.inc#L370) | 0 | — | младший разряд столбца миникарты, нечётный столбец требует перестановки полубайтов узора | числовой разряд алгоритма | [Overlay.Maps.XorMiniTile](../Source/Overlays/Maps.asm#L470) — `BIT COL_ODD_BIT, C` |
| [`CUR_RESTORE_BIT`](../Includes/Const/Flags.inc#L99) | 7 | [`CUR_RESTORE`](../Includes/Const/Flags.inc#L100) = `#80` | флаг, восстановить фон курсора из буфера, при 0 сохранить экранный фон в буфер | `Loader.Menu.CursorBackdrop, входной C` | [Loader.Menu.CursorBackdrop](../Source/Loader/Menu/CursorBackdrop.asm#L57) — `BIT CUR_RESTORE_BIT, C`<br>[Loader.Menu.CursorBackdrop](../Source/Loader/Menu/CursorBackdrop.asm#L66) — `BIT CUR_RESTORE_BIT, C` |
| [`DEFENSE_OK_BIT`](../Includes/Const/Flags.inc#L104) | 0 | [`DEFENSE_OK`](../Includes/Const/Flags.inc#L105) = `#01` | разрешает предложить магическое вмешательство героя в защиту замка | `State.DefenseSpell` | [Engine.TickCastle](../Source/Engine/TickCastle.asm#L267) — `BIT DEFENSE_OK_BIT, A` |
| [`DELTA_NEG_BIT`](../Includes/Const/Flags.inc#L347) | 7 | — | знак отрицательной однобайтовой разности координат | `GetDirection.DeltaX/DeltaY`<br>`FPosition.X`<br>`FPosition.Y` | [Engine.GetDirection](../Source/Engine/GetDirection.asm#L35) — `BIT DELTA_NEG_BIT, A`<br>[Engine.GetDirection](../Source/Engine/GetDirection.asm#L45) — `BIT DELTA_NEG_BIT, A`<br>[Engine.GetDirection](../Source/Engine/GetDirection.asm#L71) — `BIT DELTA_NEG_BIT, (IX + FPosition.X)`<br>[Engine.GetDirection](../Source/Engine/GetDirection.asm#L82) — `BIT DELTA_NEG_BIT, (IX + FPosition.X)`<br>[Engine.GetDirection](../Source/Engine/GetDirection.asm#L85) — `BIT DELTA_NEG_BIT, (IX + FPosition.Y)`<br>[Engine.GetDirection](../Source/Engine/GetDirection.asm#L91) — `BIT DELTA_NEG_BIT, (IX + FPosition.Y)`<br>[Engine.GetDirection](../Source/Engine/GetDirection.asm#L101) — `BIT DELTA_NEG_BIT, (IX + FPosition.Y)` |
| [`DRAIN_CAP_BIT`](../Includes/Const/Flags.inc#L265) | 0 | [`DRAIN_CAP`](../Includes/Const/Flags.inc#L270) = `#01` | флаг, восстановление численности типа ограничено исходным InitialCount | `FSoldier.SpecialFlags` | [Battle.ClampRegen](../Source/Battle/ClampRegen.asm#L17) — `BIT DRAIN_CAP_BIT, (IX + FSoldier.SpecialFlags)` |
| [`DRAIN_HIT_BIT`](../Includes/Const/Flags.inc#L260) | 7 | [`DRAIN_HIT`](../Includes/Const/Flags.inc#L261) = `#80` | флаг, атакующий тип восстанавливает численность за счёт нанесённого воздействия | `FSoldier.MoveFlags` | [Battle.ApplyDrainTrait](../Source/Battle/ApplyDrainTrait.asm#L18) — `BIT DRAIN_HIT_BIT, E` |
| [`DRAW_NUMBER_BIT`](../Includes/Const/Flags.inc#L241) | 5 | [`DRAW_NUMBER`](../Includes/Const/Flags.inc#L244) = `#20` | после рисунка выводит численную подпись экранного объекта | `FScreenObject20.Flags` | [Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L130) — `BIT DRAW_NUMBER_BIT, (IX + FScreenObject20.Flags)` |
| [`ENEMY_WARD_BIT`](../Includes/Const/Flags.inc#L29) | 1 | [`ENEMY_WARD`](../Includes/Const/Flags.inc#L33) = `#02` | флаг, армия противника защищена магическим щитом | `Battle.FinishField.Flags` | [Battle.AISpell](../Source/Battle/AISpell.asm#L90) — `BIT ENEMY_WARD_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L362) — `SET ENEMY_WARD_BIT, A`<br>[Battle.Battle](../Source/Battle/Battle.asm#L47) — `BIT ENEMY_WARD_BIT, A`<br>[Battle.Battle](../Source/Battle/Battle.asm#L56) — `RES ENEMY_WARD_BIT, A`<br>[Battle.HasMagicShield](../Source/Battle/HasMagicShield.asm#L25) — `BIT ENEMY_WARD_BIT, A`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L317) — `BIT ENEMY_WARD_BIT, A` |
| [`EVENT_LOCK_BIT`](../Includes/Const/Flags.inc#L109) | 7 | [`EVENT_LOCK`](../Includes/Const/Flags.inc#L110) = `#80` | временно запрещает развитие отрядов, нападения на замок и магическое вмешательство | `State.EventFlags` | [Engine.DevelopTroops](../Source/Engine/DevelopTroops.asm#L18) — `BIT EVENT_LOCK_BIT, A`<br>[Engine.TickCastle](../Source/Engine/TickCastle.asm#L50) — `BIT EVENT_LOCK_BIT, A`<br>[Engine.TickCastle](../Source/Engine/TickCastle.asm#L271) — `BIT EVENT_LOCK_BIT, A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L94) — `SET EVENT_LOCK_BIT, A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L120) — `RES EVENT_LOCK_BIT, A` |
| [`EXP_ACTIVE_BIT`](../Includes/Const/Flags.inc#L114) | 6 | [`EXP_ACTIVE`](../Includes/Const/Flags.inc#L117) = `#40` | статья расходов существует и показана в текущем недельном расчёте | `FExpense.Flags` | [Engine.TickTime](../Source/Engine/TickTime.asm#L105) — `RES EXP_ACTIVE_BIT, (IX + FExpense.Flags)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L151) — `SET EXP_ACTIVE_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L175) — `SET EXP_ACTIVE_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L197) — `SET EXP_ACTIVE_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L216) — `BIT EXP_ACTIVE_BIT, (IX + FExpense.Flags)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L253) — `BIT EXP_ACTIVE_BIT, (IX + FExpense.Flags)` |
| [`EXP_PAY_BIT`](../Includes/Const/Flags.inc#L116) | 7 | [`EXP_PAY`](../Includes/Const/Flags.inc#L118) = `#80` | статья выбрана для оплаты и включается в SumExpenses | `FExpense.Flags` | [Engine.SumExpenses](../Source/Engine/SumExpenses.asm#L19) — `BIT EXP_PAY_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L104) — `RES EXP_PAY_BIT, (IX + FExpense.Flags)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L323) — `BIT EXP_PAY_BIT, A`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L510) — `BIT EXP_PAY_BIT, (IY + FExpense.Flags)` |
| [`FIELD_COL_BIT`](../Includes/Const/Flags.inc#L426) | 0 | — | исходная позиция бита в шаблоне самоменяемой проверки либо установки столбца поля | `Battle.FinishField.ObstacleRows`<br>`FObstacleRows.First` | [Battle.BuildField](../Source/Battle/BuildField.asm#L103) — `BIT FIELD_COL_BIT, (IX + FObstacleRows.First)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L585) — `SET FIELD_COL_BIT, (HL)`<br>[Battle.TestObstacle](../Source/Battle/TestObstacle.asm#L27) — `BIT FIELD_COL_BIT, (HL)` |
| [`FIELD_SPEC_BIT`](../Includes/Const/Flags.inc#L38) | 7 | [`FIELD_SPEC`](../Includes/Const/Flags.inc#L39) = `#80` | флаг, особый режим боя с готовой маской поля и создаваемой армией противника | `Battle.FinishField.FieldKind` | [Battle.BuildField](../Source/Battle/BuildField.asm#L23) — `BIT FIELD_SPEC_BIT, A`<br>[Battle.InitBattle](../Source/Battle/InitBattle.asm#L28) — `BIT FIELD_SPEC_BIT, A` |
| [`FILE_MISS_BIT`](../Includes/Const/Flags.inc#L399) | 7 | — | позиция бита результата поиска TR-DOS, C=#FF означает отсутствие файла, при находке C содержит номер 0..127 | `C after TrDos function #0A` | [Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L154) — `BIT FILE_MISS_BIT, C` |
| [`FLOAT_SIGN_BIT`](../Includes/Const/Flags.inc#L355) | 7 | — | позиция знака в байте мантиссы пятибайтового числа ROM | `FBattleUnit.Quantity + 1`<br>`FloatSignZero.DifferenceSign`<br>`FBattleUnit.Quantity` | [Battle.TestDeadStack](../Source/Battle/TestDeadStack.asm#L13) — `BIT FLOAT_SIGN_BIT, (IX + FBattleUnit.Quantity + 1)`<br>[Engine.FloatSignZero](../Source/Engine/FloatSignZero.asm#L27) — `BIT FLOAT_SIGN_BIT, A` |
| [`FOG_INDEX_BIT`](../Includes/Const/Flags.inc#L422) | 0 | — | начальный номер бита шаблона проверки разведки, фактический номер 7-(X AND 7) переписывается в opcode | `Overlay.Maps.IsCellExplored.ExploreTestOp` | [Overlay.Maps.IsCellExplored](../Source/Overlays/Maps.asm#L419) — `BIT FOG_INDEX_BIT, (HL)` |
| [`FOG_SEED_BIT`](../Includes/Const/Flags.inc#L430) | 7 | — | начальный номер бита команды SET в карте открытия, до исполнения операнд FogSetOpcode меняется по координате X | `UpdateLocalView.FogSetOpcode` | [Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L67) — `SET FOG_SEED_BIT, (HL)` |
| [`FRONT_FLIP_BIT`](../Includes/Const/Flags.inc#L243) | 6 | [`FRONT_FLIP`](../Includes/Const/Flags.inc#L245) = `#40` | горизонтально отражает передний маскированный слой экранного объекта | `FScreenObject20.Flags` | [Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L194) — `SET FRONT_FLIP_BIT, (IX + FScreenObject20.Flags)` |
| [`GIFT_MAP_BIT`](../Includes/Const/Flags.inc#L410) | 0 | — | младший разряд случайного результата 0..1, 1 выбирает предложение награды картой текущего континента | числовой разряд алгоритма | [Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L77) — `BIT GIFT_MAP_BIT, E` |
| [`HALF_HIT_BIT`](../Includes/Const/Flags.inc#L251) | 2 | [`HALF_HIT`](../Includes/Const/Flags.inc#L255) = `#04` | флаг, тип атакующего допускает вероятностный удар с делением численности цели на два | `FSoldier.ExtraFlags` | [Battle.ResolveAttack](../Source/Battle/ResolveAttack.asm#L54) — `BIT HALF_HIT_BIT, D` |
| [`HERO_ACTED_BIT`](../Includes/Const/Flags.inc#L81) | 3 | [`HERO_ACTED`](../Includes/Const/Flags.inc#L84) = `#08` | флаг, отряд героя уже выбирался в текущем круге выбора действующего отряда | `FBattleUnit.Flags` | [Battle.SelectActor](../Source/Battle/SelectActor.asm#L34) — `BIT HERO_ACTED_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.SelectActor](../Source/Battle/SelectActor.asm#L42) — `RES HERO_ACTED_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.SelectActor](../Source/Battle/SelectActor.asm#L59) — `SET HERO_ACTED_BIT, (IY + FBattleUnit.Flags)` |
| [`HERO_CARRY_BIT`](../Includes/Const/Flags.inc#L319) | 2 | [`HERO_CARRY`](../Includes/Const/Flags.inc#L320) = `#04` | флаг, тип существ способен переносить героя в полёте | `FSoldier.SpecialFlags` | [Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L59) — `BIT HERO_CARRY_BIT, (IX + FSoldier.SpecialFlags)` |
| [`HERO_FACE_BIT`](../Includes/Const/Flags.inc#L200) | 3 | [`HERO_FACE`](../Includes/Const/Flags.inc#L204) = `#08` | горизонтальное отражение изображения героя | `State.MoveFlags` | [Engine.MapMoveLeft](../Source/Engine/MapMoveLeft.asm#L21) — `RES HERO_FACE_BIT, A`<br>[Engine.MapMoveRight](../Source/Engine/MapMoveRight.asm#L20) — `SET HERO_FACE_BIT, A`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L191) — `BIT HERO_FACE_BIT, A` |
| [`HERO_HIDE_BIT`](../Includes/Const/Flags.inc#L198) | 2 | [`HERO_HIDE`](../Includes/Const/Flags.inc#L203) = `#04` | временно исключает изображение героя из локального окна | `State.MoveFlags`<br>`FPerson.MoveFlags` | [Engine.TickCastle](../Source/Engine/TickCastle.asm#L351) — `SET HERO_HIDE_BIT, A`<br>[Engine.TickCastle](../Source/Engine/TickCastle.asm#L355) — `RES HERO_HIDE_BIT, A`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L182) — `BIT HERO_HIDE_BIT, A`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L28) — `SET HERO_HIDE_BIT, A`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L33) — `RES HERO_HIDE_BIT, A`<br>[Overlay.Capture.Entry](../Source/Overlays/Capture.asm#L33) — `SET HERO_HIDE_BIT, A`<br>[Overlay.Capture.Entry](../Source/Overlays/Capture.asm#L38) — `RES HERO_HIDE_BIT, A`<br>[Overlay.Join.Entry](../Source/Overlays/Join.asm#L27) — `SET HERO_HIDE_BIT, A`<br>[Overlay.Join.Entry](../Source/Overlays/Join.asm#L32) — `RES HERO_HIDE_BIT, A` |
| [`HERO_REACH_BIT`](../Includes/Const/Flags.inc#L83) | 4 | [`HERO_REACH`](../Includes/Const/Flags.inc#L85) = `#10` | флаг, отряд героя достижим для проверяемого отряда ИИ | `FBattleUnit.Flags` | [Battle.AISpell](../Source/Battle/AISpell.asm#L390) — `BIT HERO_REACH_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L29) — `RES HERO_REACH_BIT, (HL)`<br>[Battle.MarkInRange](../Source/Battle/MarkInRange.asm#L42) — `SET HERO_REACH_BIT, (IX + FBattleUnit.Flags)` |
| [`HERO_SIEGE_BIT`](../Includes/Const/Flags.inc#L122) | 5 | [`HERO_SIEGE`](../Includes/Const/Flags.inc#L123) = `#20` | флаг, герой располагает осадным орудием | `FPerson.MoveFlags` | [Battle.InputLoop](../Source/Battle/InputLoop.asm#L837) — `RES HERO_SIEGE_BIT, A`<br>[Battle.ResolveLosses](../Source/Battle/ResolveLosses.asm#L181) — `RES HERO_SIEGE_BIT, A`<br>[Overlay.Capture.Entry](../Source/Overlays/Capture.asm#L81) — `BIT HERO_SIEGE_BIT, A`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L165) — `BIT HERO_SIEGE_BIT, A`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L196) — `SET HERO_SIEGE_BIT, A`<br>[Overlay.Info.Entry](../Source/Overlays/Info.asm#L154) — `BIT HERO_SIEGE_BIT, A`<br>[Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L63) — `BIT HERO_SIEGE_BIT, A`<br>[Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L93) — `RES HERO_SIEGE_BIT, A` |
| [`HERO_WARD_BIT`](../Includes/Const/Flags.inc#L27) | 0 | [`HERO_WARD`](../Includes/Const/Flags.inc#L32) = `#01` | флаг, армия героя защищена магическим щитом | `Battle.FinishField.Flags` | [Battle.AISpell](../Source/Battle/AISpell.asm#L80) — `BIT HERO_WARD_BIT, A`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L180) — `BIT HERO_WARD_BIT, A`<br>[Battle.Battle](../Source/Battle/Battle.asm#L35) — `BIT HERO_WARD_BIT, A`<br>[Battle.Battle](../Source/Battle/Battle.asm#L44) — `RES HERO_WARD_BIT, A`<br>[Battle.HasMagicShield](../Source/Battle/HasMagicShield.asm#L28) — `BIT HERO_WARD_BIT, A`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L471) — `BIT HERO_WARD_BIT, A` |
| [`ITEM_USED_BIT`](../Includes/Const/Flags.inc#L153) | 0 | [`ITEM_USED`](../Includes/Const/Flags.inc#L154) = `#01` | находка использована и исключена из обработки | `FMapItem.Flags` | [Engine.StepArmies](../Source/Engine/StepArmies.asm#L194) — `SET ITEM_USED_BIT, (IX + FMapItem.Flags)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L417) — `SET ITEM_USED_BIT, (IX + FMapItem.Flags)`<br>[Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L156) — `SET ITEM_USED_BIT, (IX + FMapItem.Flags)`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L31) — `SET ITEM_USED_BIT, (IX + FMapItem.Flags)` |
| [`JOY_FIRE_BIT`](../Includes/Const/Flags.inc#L132) | 4 | [`JOY_FIRE`](../Includes/Const/Flags.inc#L133) = `#10` | флаг, кнопка действия Kempston нажата | `Kempston port #1F`<br>`KempstonPort` | [Engine.ReadInput](../Source/Engine/ReadInput.asm#L34) — `BIT JOY_FIRE_BIT, A`<br>[Engine.WaitMenuInput](../Source/Engine/WaitMenuInput.asm#L23) — `BIT JOY_FIRE_BIT, A`<br>[Startup.ReadMenuInput](../Source/Startup/ReadMenuInput.asm#L25) — `BIT JOY_FIRE_BIT, A` |
| [`MAGIC_IMM_BIT`](../Includes/Const/Flags.inc#L249) | 1 | [`MAGIC_IMM`](../Includes/Const/Flags.inc#L254) = `#02` | флаг, тип цели невосприимчив к целевому магическому действию | `FSoldier.ExtraFlags` | [Battle.AISpell](../Source/Battle/AISpell.asm#L104) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L121) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L240) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L440) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L498) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L610) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L666) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L696) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L723) — `BIT MAGIC_IMM_BIT, D` |
| [`MAP_BUSY_BIT`](../Includes/Const/Flags.inc#L337) | 7 | [`MAP_BUSY`](../Includes/Const/Flags.inc#L338) = `#80` | флаг, клетка стратегической карты уже занята объектом при генерации | `MapCell.FlagsAndTerrain`<br>`MapCell`<br>`MapConst` | [Engine.ApplyMoveCode](../Source/Engine/ApplyMoveCode.asm#L95) — `BIT MAP_BUSY_BIT, A`<br>[Engine.FindMapObject](../Source/Engine/FindMapObject.asm#L46) — `BIT MAP_BUSY_BIT, A`<br>[Engine.FindRecord](../Source/Engine/FindRecord.asm#L20) — `BIT MAP_BUSY_BIT, A`<br>[Engine.Initialize](../Source/Engine/Initialize.asm#L85) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.Initialize](../Source/Engine/Initialize.asm#L94) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.MainLoop](../Source/Engine/MainLoop.asm#L56) — `BIT MAP_BUSY_BIT, A`<br>[Engine.MarkMapCell](../Source/Engine/MarkMapCell.asm#L18) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.MoveSitesC](../Source/Engine/MoveSitesC.asm#L40) — `BIT MAP_BUSY_BIT, A`<br>[Engine.MoveSitesC](../Source/Engine/MoveSitesC.asm#L60) — `BIT MAP_BUSY_BIT, A`<br>[Engine.MoveSitesC](../Source/Engine/MoveSitesC.asm#L70) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.MoveSitesC](../Source/Engine/MoveSitesC.asm#L73) — `RES MAP_BUSY_BIT, (HL)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L199) — `RES MAP_BUSY_BIT, (HL)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L205) — `BIT MAP_BUSY_BIT, A`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L319) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L422) — `RES MAP_BUSY_BIT, (HL)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L428) — `BIT MAP_BUSY_BIT, A`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L464) — `RES MAP_BUSY_BIT, (HL)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L482) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L167) — `BIT MAP_BUSY_BIT, A`<br>[Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L192) — `RES MAP_BUSY_BIT, (HL)`<br>[Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L203) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L398) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L126) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L201) — `RES MAP_BUSY_BIT, (HL)`<br>[Overlay.Castle.Entry](../Source/Overlays/Castle.asm#L648) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Castle.PlaceAuxTroops](../Source/Overlays/Castle.asm#L788) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Friendly.Entry](../Source/Overlays/Friendly.asm#L43) — `RES MAP_BUSY_BIT, (HL)`<br>[Overlay.Friendly.Entry](../Source/Overlays/Friendly.asm#L55) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Friendly.Entry](../Source/Overlays/Friendly.asm#L61) — `SET MAP_BUSY_BIT, (HL)`<br>[Overlay.Hostile.Entry](../Source/Overlays/Hostile.asm#L43) — `RES MAP_BUSY_BIT, (HL)`<br>[Overlay.Hostile.Entry](../Source/Overlays/Hostile.asm#L63) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Hostile.Entry](../Source/Overlays/Hostile.asm#L69) — `SET MAP_BUSY_BIT, (HL)`<br>[Overlay.Join.Entry](../Source/Overlays/Join.asm#L42) — `RES MAP_BUSY_BIT, (HL)`<br>[Overlay.Land.Entry](../Source/Overlays/Land.asm#L26) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Maps.DrawAerialMap](../Source/Overlays/Maps.asm#L1056) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L156) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L162) — `SET MAP_BUSY_BIT, (HL)`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L180) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L186) — `SET MAP_BUSY_BIT, (HL)`<br>[Overlay.Temple.CheckLanding](../Source/Overlays/Temple.asm#L347) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L36) — `RES MAP_BUSY_BIT, (HL)`<br>[Startup.CreateWanderers](../Source/Startup/CreateWanderers.asm#L40) — `BIT MAP_BUSY_BIT, (HL)`<br>[Startup.CreateWanderers](../Source/Startup/CreateWanderers.asm#L47) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.MarkUsedCell](../Source/Startup/MarkUsedCell.asm#L19) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L291) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L551) — `BIT MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L606) — `BIT MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L613) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L649) — `BIT MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L657) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L730) — `BIT MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L738) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L794) — `BIT MAP_BUSY_BIT, A`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L803) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L815) — `BIT MAP_BUSY_BIT, A` |
| [`MAP_INDEX_BIT`](../Includes/Const/Flags.inc#L418) | 0 | — | начальный номер бита шаблонов проверки и открытия карт континентов, фактический номер вычисляется из номера континента и переписывается в opcode | `State.MapFlags, изменяемые BIT/SET` | [Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L84) — `BIT MAP_INDEX_BIT, B`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L88) — `BIT MAP_INDEX_BIT, (HL)`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L94) — `SET MAP_INDEX_BIT, (HL)`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L126) — `BIT MAP_INDEX_BIT, (HL)`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L132) — `SET MAP_INDEX_BIT, (HL)` |
| [`MAP_MIRROR_BIT`](../Includes/Const/Flags.inc#L148) | 6 | [`MAP_MIRROR`](../Includes/Const/Flags.inc#L149) = `#40` | флаг, тайл клетки стратегической карты выводится с горизонтальным отражением | `MapConst` | [Overlay.Maps.DrawAerialMap](../Source/Overlays/Maps.asm#L1045) — `BIT MAP_MIRROR_BIT, C`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L97) — `BIT MAP_MIRROR_BIT, (HL)` |
| [`MASK_FILL_BIT`](../Includes/Const/Flags.inc#L359) | 7 | — | позиция старшего бита маски, заполняемого единицей при смещении шестипиксельного символа | `Startup.DrawGlyph.ShiftMask`<br>`DrawGlyph.ShiftMask` | [Engine.DrawGlyph](../Source/Engine/DrawGlyph.asm#L38) — `SET MASK_FILL_BIT, B`<br>[Startup.DrawGlyph](../Source/Startup/DrawGlyph.asm#L41) — `SET MASK_FILL_BIT, B` |
| [`MENU_ACTIVE_BIT`](../Includes/Const/Flags.inc#L176) | 7 | [`MENU_ACTIVE`](../Includes/Const/Flags.inc#L177) = `#80` | флаг, область меню подсвечена обменом INK и PAPER | `FMenuArea.XAndActive` | [Loader.Menu.HighlightAreas](../Source/Loader/Menu/HighlightAreas.asm#L41) — `SET MENU_ACTIVE_BIT, (IX + FMenuArea.XAndActive)`<br>[Loader.Menu.HighlightAreas](../Source/Loader/Menu/HighlightAreas.asm#L60) — `RES MENU_ACTIVE_BIT, (IX + FMenuArea.XAndActive)`<br>[Loader.Menu.PollMenu](../Source/Loader/Menu/PollMenu.asm#L76) — `RES MENU_ACTIVE_BIT, (HL)` |
| [`MENU_DOWN_BIT`](../Includes/Const/Flags.inc#L183) | 1 | [`MENU_DOWN`](../Includes/Const/Flags.inc#L191) = `#02` | флаг, движение вниз | `Loader.Menu.ReadControls, C/A и MenuState.KeyMask` | [Loader.Menu.MoveCursor](../Source/Loader/Menu/MoveCursor.asm#L80) — `BIT MENU_DOWN_BIT, C` |
| [`MENU_FIRE_BIT`](../Includes/Const/Flags.inc#L181) | 0 | [`MENU_FIRE`](../Includes/Const/Flags.inc#L190) = `#01` | флаг, действие или завершение выбора | `Loader.Menu.ReadControls, C/A и MenuState.KeyMask` | [Loader.Menu.EditUnits](../Source/Loader/Menu/EditUnits.asm#L162) — `BIT MENU_FIRE_BIT, A`<br>[Loader.Menu.ShowHelp](../Source/Loader/Menu/ShowHelp.asm#L63) — `BIT MENU_FIRE_BIT, A`<br>[Loader.Menu.WaitPress](../Source/Loader/Menu/WaitPress.asm#L16) — `BIT MENU_FIRE_BIT, C`<br>[Loader.Menu.WaitRelease](../Source/Loader/Menu/WaitRelease.asm#L15) — `BIT MENU_FIRE_BIT, C` |
| [`MENU_LEFT_BIT`](../Includes/Const/Flags.inc#L189) | 4 | [`MENU_LEFT`](../Includes/Const/Flags.inc#L194) = `#10` | флаг, движение влево | `Loader.Menu.ReadControls, C/A и MenuState.KeyMask` | [Loader.Menu.EditUnits](../Source/Loader/Menu/EditUnits.asm#L175) — `BIT MENU_LEFT_BIT, A`<br>[Loader.Menu.MoveCursor](../Source/Loader/Menu/MoveCursor.asm#L50) — `BIT MENU_LEFT_BIT, C` |
| [`MENU_RIGHT_BIT`](../Includes/Const/Flags.inc#L187) | 3 | [`MENU_RIGHT`](../Includes/Const/Flags.inc#L193) = `#08` | флаг, движение вправо | `Loader.Menu.ReadControls, C/A и MenuState.KeyMask` | [Loader.Menu.EditUnits](../Source/Loader/Menu/EditUnits.asm#L179) — `BIT MENU_RIGHT_BIT, A`<br>[Loader.Menu.MoveCursor](../Source/Loader/Menu/MoveCursor.asm#L59) — `BIT MENU_RIGHT_BIT, C` |
| [`MENU_UP_BIT`](../Includes/Const/Flags.inc#L185) | 2 | [`MENU_UP`](../Includes/Const/Flags.inc#L192) = `#04` | флаг, движение вверх | `Loader.Menu.ReadControls, C/A и MenuState.KeyMask` | [Loader.Menu.EditUnits](../Source/Loader/Menu/EditUnits.asm#L183) — `BIT MENU_UP_BIT, A`<br>[Loader.Menu.MoveCursor](../Source/Loader/Menu/MoveCursor.asm#L71) — `BIT MENU_UP_BIT, C` |
| [`NO_DRAIN_BIT`](../Includes/Const/Flags.inc#L267) | 1 | [`NO_DRAIN`](../Includes/Const/Flags.inc#L271) = `#02` | флаг, тип жертвы запрещает атакующему восстанавливать численность за нанесённый ей урон | `FSoldier.SpecialFlags` | [Battle.ApplyDrainTrait](../Source/Battle/ApplyDrainTrait.asm#L24) — `BIT NO_DRAIN_BIT, (IX + FSoldier.SpecialFlags)` |
| [`OBJECT_FACE_BIT`](../Includes/Const/Flags.inc#L332) | 6 | [`OBJECT_FACE`](../Includes/Const/Flags.inc#L333) = `#40` | горизонтальное отражение стратегического объекта, направления 2..4 ставят, 6..8 снимают | `FMapSite.Flags` | [Engine.SetFacing](../Source/Engine/SetFacing.asm#L21) — `RES OBJECT_FACE_BIT, (IX + FMapSite.Flags)`<br>[Engine.SetFacing](../Source/Engine/SetFacing.asm#L24) — `SET OBJECT_FACE_BIT, (IX + FMapSite.Flags)` |
| [`PASS_CLEAR_BIT`](../Includes/Const/Flags.inc#L380) | 3 | — | позиция бита, снимаемого исходным проходом очистки SelectActor в четырёх полях за первой записью | `Battle.SelectActor.ClearPassFlags`<br>`FBattleArmy.Second`<br>`FBattleArmy.Third`<br>`FBattleArmy.Fourth` | [Battle.SelectActor](../Source/Battle/SelectActor.asm#L43) — `RES PASS_CLEAR_BIT, (IY + FBattleArmy.Second.Quantity + 3)`<br>[Battle.SelectActor](../Source/Battle/SelectActor.asm#L44) — `RES PASS_CLEAR_BIT, (IY + FBattleArmy.Third.Affinity)`<br>[Battle.SelectActor](../Source/Battle/SelectActor.asm#L45) — `RES PASS_CLEAR_BIT, (IY + FBattleArmy.Third.InitialCount.High)`<br>[Battle.SelectActor](../Source/Battle/SelectActor.asm#L46) — `RES PASS_CLEAR_BIT, (IY + FBattleArmy.Fourth.Y)` |
| [`PIECE_INDEX_BIT`](../Includes/Const/Flags.inc#L434) | 0 | — | начальный номер бита шаблонов BIT/SET карты головоломки, фактический номер 0..4 переписывается вычисленным opcode перед выполнением | `Overlay.Capture.NewMapPiece.TestPiece/OpenPiece` | [Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L472) — `BIT PIECE_INDEX_BIT, (HL)`<br>[Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L476) — `SET PIECE_INDEX_BIT, (HL)` |
| [`PIXEL_LEFT_BIT`](../Includes/Const/Flags.inc#L386) | 7 | — | позиция левого пикселя в экранном байте Spectrum | `Spectrum bitmap byte`<br>`ShiftCursorR.PixelByte` | [Engine.ShiftCursorR](../Source/Engine/ShiftCursorR.asm#L28) — `SET PIXEL_LEFT_BIT, (HL)`<br>[Startup.RotateCursorR](../Source/Startup/RotateCursorR.asm#L33) — `SET PIXEL_LEFT_BIT, (HL)` |
| [`PIXEL_RIGHT_BIT`](../Includes/Const/Flags.inc#L384) | 0 | — | позиция правого пикселя в экранном байте Spectrum | `Spectrum bitmap byte`<br>`ShiftCursorL.PixelByte` | [Engine.ShiftCursorL](../Source/Engine/ShiftCursorL.asm#L28) — `SET PIXEL_RIGHT_BIT, (HL)`<br>[Startup.RotateCursorL](../Source/Startup/RotateCursorL.asm#L31) — `SET PIXEL_RIGHT_BIT, (HL)` |
| [`PIX_PAIR_HI_BIT`](../Includes/Const/Flags.inc#L351) | 1 | — | старший пиксель удвоенной пары при горизонтальном увеличении глифа | числовой разряд алгоритма | [Presentation.ExpandBits](../Source/Files/06_PRES.asm#L1072) — `SET PIX_PAIR_HI_BIT, E` |
| [`PIX_PAIR_LO_BIT`](../Includes/Const/Flags.inc#L350) | 0 | — | младший пиксель удвоенной пары при горизонтальном увеличении глифа | числовой разряд алгоритма | [Presentation.ExpandBits](../Source/Files/06_PRES.asm#L1071) — `SET PIX_PAIR_LO_BIT, E` |
| [`RLE_ATTR_BIT`](../Includes/Const/Flags.inc#L213) | 3 | [`RLE_ATTR`](../Includes/Const/Flags.inc#L216) = `#08` | флаг, распаковщик перешёл к линейному выводу атрибутов | `FRleState.Flags` | [Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L175) — `SET RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L225) — `BIT RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L178) — `SET RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L228) — `BIT RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L178) — `SET RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L228) — `BIT RLE_ATTR_BIT, (IY + FRleState.Flags)` |
| [`RLE_ROW_BIT`](../Includes/Const/Flags.inc#L209) | 0 | [`RLE_ROW`](../Includes/Const/Flags.inc#L214) = `#01` | флаг, поток пикселей обходится горизонтальными строками, при 0 вертикальными блоками | `FRleState.Flags` | [Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L118) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L132) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L121) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L135) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L121) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L135) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)` |
| [`RLE_RUN_BIT`](../Includes/Const/Flags.inc#L211) | 2 | [`RLE_RUN`](../Includes/Const/Flags.inc#L215) = `#04` | флаг, продолжается RLE-серия, остаток и повторяемый байт находятся в альтернативных B и C | `FRleState.Flags` | [Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L193) — `BIT RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L205) — `RES RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L223) — `SET RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L196) — `BIT RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L208) — `RES RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L226) — `SET RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L196) — `BIT RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L208) — `RES RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L226) — `SET RLE_RUN_BIT, (IY + FRleState.Flags)` |
| [`RNG_FEED_BIT`](../Includes/Const/Flags.inc#L390) | 0 | — | позиция младшего бита слова, принимающего перенос старшего бита при циклическом обновлении генератора | `Startup.RandomRange.SeedZ`<br>`State.RandomState` | [Engine.RandomScaled](../Source/Engine/RandomScaled.asm#L34) — `SET RNG_FEED_BIT, L`<br>[Presentation.RandomRange](../Source/Files/06_PRES.asm#L871) — `SET RNG_FEED_BIT, L`<br>[Startup.RandomRange](../Source/Startup/RandomRange.asm#L34) — `SET RNG_FEED_BIT, L` |
| [`RNG_ROUND_BIT`](../Includes/Const/Flags.inc#L392) | 7 | — | позиция старшего бита дробной половины произведения, единица требует округления вверх | `H in fractional low word of product`<br>`RandomScaled.RoundResult` | [Engine.RandomScaled](../Source/Engine/RandomScaled.asm#L62) — `BIT RNG_ROUND_BIT, H`<br>[Presentation.RandomRange](../Source/Files/06_PRES.asm#L896) — `BIT RNG_ROUND_BIT, H`<br>[Startup.RandomRange](../Source/Startup/RandomRange.asm#L59) — `BIT RNG_ROUND_BIT, H` |
| [`ROW_ODD_BIT`](../Includes/Const/Flags.inc#L371) | 0 | — | младший разряд номера строки миникарты, нечётная строка выбирает вторую половину знакоместа | числовой разряд алгоритма | [Overlay.Maps.XorMiniTile](../Source/Overlays/Maps.asm#L459) — `BIT ROW_ODD_BIT, A` |
| [`SEA_ACCESS_BIT`](../Includes/Const/Flags.inc#L94) | 0 | [`SEA_ACCESS`](../Includes/Const/Flags.inc#L95) = `#01` | флаг, открыт континент 2 и разрешён вход в морское меню перехода | `FPerson.MapFlags` | [Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L27) — `BIT SEA_ACCESS_BIT, A` |
| [`SEA_FIRST_BIT`](../Includes/Const/Flags.inc#L395) | 0 | — | младший разряд временной маски списка морских континентов, всегда разрешает первый континент после сдвига исходных MapFlags | числовой разряд алгоритма | [Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L50) — `SET SEA_FIRST_BIT, A` |
| [`SHIP_FACE_BIT`](../Includes/Const/Flags.inc#L202) | 4 | [`SHIP_FACE`](../Includes/Const/Flags.inc#L205) = `#10` | альтернативное горизонтальное представление корабля | `State.MoveFlags` | [Engine.MapMoveLeft](../Source/Engine/MapMoveLeft.asm#L28) — `RES SHIP_FACE_BIT, A`<br>[Engine.MapMoveRight](../Source/Engine/MapMoveRight.asm#L27) — `SET SHIP_FACE_BIT, A`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L233) — `BIT SHIP_FACE_BIT, A` |
| [`SITE_ALT_BIT`](../Includes/Const/Flags.inc#L342) | 5 | [`SITE_ALT`](../Includes/Const/Flags.inc#L343) = `#20` | выбирает альтернативное изображение одноклеточной стратегической записи в PlaceCells | `FMapSite.Flags` | [Engine.PlaceCells](../Source/Engine/PlaceCells.asm#L56) — `BIT SITE_ALT_BIT, (IX + FMapSite.Flags)` |
| [`SITE_OFF_BIT`](../Includes/Const/Flags.inc#L158) | 0 | [`SITE_OFF`](../Includes/Const/Flags.inc#L159) = `#01` | общий префикс стратегической записи выключает её из обхода | `FMapSite.Flags` | [Engine.FindRecord](../Source/Engine/FindRecord.asm#L44) — `BIT SITE_OFF_BIT, (IX + FMapSite.Flags)`<br>[Engine.MarkObjectGroup](../Source/Engine/MarkObjectGroup.asm#L31) — `BIT SITE_OFF_BIT, (IY + FMapSite.Flags)`<br>[Engine.NearestObject](../Source/Engine/NearestObject.asm#L44) — `BIT SITE_OFF_BIT, (IX + FMapSite.Flags)`<br>[Engine.PlaceCells](../Source/Engine/PlaceCells.asm#L27) — `BIT SITE_OFF_BIT, (IX + FMapSite.Flags)`<br>[Engine.PlaceGroup](../Source/Engine/PlaceGroup.asm#L32) — `BIT SITE_OFF_BIT, (IX + FMapSite.Flags)`<br>[Overlay.Maps.MarkSiteList](../Source/Overlays/Maps.asm#L871) — `BIT SITE_OFF_BIT, (IX + FMapSite.Flags)` |
| [`SLIDE_ADD_BIT`](../Includes/Const/Flags.inc#L231) | 4 | [`SLIDE_ADD`](../Includes/Const/Flags.inc#L232) = `#10` | флаг, упакованное смещение периода в D положительное, снимается перед ADD HL,DE | `Music.Menu.ReadSampleStep/CalcTonePeriod, D` | [Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L245) — `SET SLIDE_ADD_BIT, D`<br>[Music.Menu.CalcTonePeriod](../Source/Loader/Music.asm#L713) — `BIT SLIDE_ADD_BIT, D`<br>[Music.Menu.CalcTonePeriod](../Source/Loader/Music.asm#L716) — `RES SLIDE_ADD_BIT, D` |
| [`SMP_ADD_BIT`](../Includes/Const/Flags.inc#L220) | 5 | [`SMP_ADD`](../Includes/Const/Flags.inc#L225) = `#20` | флаг, смещение семпла прибавляется к периоду ноты, при 0 вычитается | `FSampleStep.NoiseAndFlags` | [Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L242) — `BIT SMP_ADD_BIT, (IX + FSampleStep.NoiseAndFlags)` |
| [`SMP_MUTE_N_BIT`](../Includes/Const/Flags.inc#L224) | 7 | [`SMP_MUTE_N`](../Includes/Const/Flags.inc#L227) = `#80` | флаг, шум текущего канала отключён шагом семпла | `FSampleStep.NoiseAndFlags` | [Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L215) — `BIT SMP_MUTE_N_BIT, A` |
| [`SMP_MUTE_T_BIT`](../Includes/Const/Flags.inc#L222) | 6 | [`SMP_MUTE_T`](../Includes/Const/Flags.inc#L226) = `#40` | флаг, тон текущего канала отключён шагом семпла | `FSampleStep.NoiseAndFlags` | [Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L223) — `BIT SMP_MUTE_T_BIT, A` |
| [`SPELL_BLOCK_BIT`](../Includes/Const/Flags.inc#L17) | 0 | [`SPELL_BLOCK`](../Includes/Const/Flags.inc#L18) = `#01` | флаг, это заклинание исключено из выбора ИИ в текущей попытке | `Battle.SpendAIMagic.NoFreeze..NoSubjugate` | [Battle.AISpell](../Source/Battle/AISpell.asm#L41) — `SET SPELL_BLOCK_BIT, (IY)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L137) — `BIT SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L145) — `BIT SPELL_BLOCK_BIT, (HL)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L154) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L206) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L295) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L353) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L407) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L430) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L477) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L505) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L559) — `SET SPELL_BLOCK_BIT, (HL)` |
| [`SPELL_KNOWN_BIT`](../Includes/Const/Flags.inc#L127) | 0 | [`SPELL_KNOWN`](../Includes/Const/Flags.inc#L128) = `#01` | флаг, заклинание изучено героем и включается в список доступной магии | `State.Spells`<br>`FPerson.Spells` | [Battle.InputLoop](../Source/Battle/InputLoop.asm#L287) — `BIT SPELL_KNOWN_BIT, (HL)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L379) — `BIT SPELL_KNOWN_BIT, (HL)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L420) — `BIT SPELL_KNOWN_BIT, (HL)`<br>[Overlay.Info.ListSpells](../Source/Overlays/Info.asm#L879) — `BIT SPELL_KNOWN_BIT, (HL)`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L203) — `BIT SPELL_KNOWN_BIT, (HL)`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L215) — `SET SPELL_KNOWN_BIT, (HL)` |
| [`SPELL_USED_BIT`](../Includes/Const/Flags.inc#L31) | 2 | [`SPELL_USED`](../Includes/Const/Flags.inc#L34) = `#04` | флаг, попытка магии героя уже использована в текущем раунде | `Battle.FinishField.Flags` | [Battle.Battle](../Source/Battle/Battle.asm#L26) — `RES SPELL_USED_BIT, A`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L281) — `BIT SPELL_USED_BIT, A`<br>[Battle.SpendHeroMagic](../Source/Battle/SpendHeroMagic.asm#L14) — `SET SPELL_USED_BIT, A` |
| [`STORY_END_BIT`](../Includes/Const/Flags.inc#L269) | 3 | [`STORY_END`](../Includes/Const/Flags.inc#L272) = `#08` | флаг, поражение от этого типа запускает сюжетное окончание | `FSoldier.SpecialFlags` | [Battle.DefeatStory](../Source/Battle/DefeatStory.asm#L26) — `BIT STORY_END_BIT, (IX + FSoldier.SpecialFlags)` |
| [`TARGET_SKIP_BIT`](../Includes/Const/Flags.inc#L43) | 7 | [`TARGET_SKIP`](../Includes/Const/Flags.inc#L44) = `#80` | флаг, цель полёта уже проверена и исключена из следующих попыток | `FBattleTarget.Side` | [Battle.RunUncontrolled](../Source/Battle/RunUncontrolled.asm#L147) — `BIT TARGET_SKIP_BIT, (IX + FBattleTarget.Side)`<br>[Battle.RunUncontrolled](../Source/Battle/RunUncontrolled.asm#L159) — `BIT TARGET_SKIP_BIT, A`<br>[Battle.RunUncontrolled](../Source/Battle/RunUncontrolled.asm#L179) — `SET TARGET_SKIP_BIT, (HL)` |
| [`TERRAIN_LSB_BIT`](../Includes/Const/Flags.inc#L367) | 0 | — | младший разряд байта местности, исходный StepMapTroops снимает его после поглощения находки, бит занятости при этом отдельно не снимается | `MapCell` | [Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L161) — `RES TERRAIN_LSB_BIT, (HL)` |
| [`TEXT_CASE_BIT`](../Includes/Const/Flags.inc#L324) | 1 | [`TEXT_CASE`](../Includes/Const/Flags.inc#L327) = `#02` | меняет регистр латинских букв и вариант таблицы перекодировки | `State.ViewFlags` | [Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L65) — `BIT TEXT_CASE_BIT, (HL)`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L92) — `BIT TEXT_CASE_BIT, (HL)` |
| [`TEXT_CURSOR_BIT`](../Includes/Const/Flags.inc#L278) | 5 | [`TEXT_CURSOR`](../Includes/Const/Flags.inc#L282) = `#20` | флаг, прерывание рисует мигающий текстовый курсор | `Startup.Interrupt.EditFlags`<br>`State.ViewFlags` | [Engine.EditText](../Source/Engine/EditText.asm#L22) — `SET TEXT_CURSOR_BIT, A`<br>[Engine.EditText](../Source/Engine/EditText.asm#L33) — `RES TEXT_CURSOR_BIT, (IX + State.ViewFlags - State.EventFlags)`<br>[Engine.Interrupt](../Source/Engine/Interrupt.asm#L41) — `BIT TEXT_CURSOR_BIT, A`<br>[Startup.EditText](../Source/Startup/EditText.asm#L25) — `SET TEXT_CURSOR_BIT, A`<br>[Startup.EditText](../Source/Startup/EditText.asm#L35) — `RES TEXT_CURSOR_BIT, (IX + .FlagsOfs)`<br>[Startup.Interrupt](../Source/Startup/Interrupt.asm#L37) — `BIT TEXT_CURSOR_BIT, A` |
| [`TEXT_DIGIT_BIT`](../Includes/Const/Flags.inc#L276) | 4 | [`TEXT_DIGIT`](../Includes/Const/Flags.inc#L281) = `#10` | флаг, разрешены только цифры и служебные коды ввода | `Startup.Interrupt.EditFlags`<br>`State.ViewFlags` | [Engine.EditNumber](../Source/Engine/EditNumber.asm#L17) — `SET TEXT_DIGIT_BIT, A`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L53) — `BIT TEXT_DIGIT_BIT, (HL)`<br>[Overlay.Castle.Entry](../Source/Overlays/Castle.asm#L295) — `RES TEXT_DIGIT_BIT, A`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L42) — `BIT TEXT_DIGIT_BIT, (HL)`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L56) — `BIT TEXT_DIGIT_BIT, (HL)`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L69) — `BIT TEXT_DIGIT_BIT, (HL)` |
| [`TEXT_RUS_BIT`](../Includes/Const/Flags.inc#L280) | 6 | [`TEXT_RUS`](../Includes/Const/Flags.inc#L283) = `#40` | флаг, вводимые цифры и буквы преобразуются в русский алфавит | `Startup.Interrupt.EditFlags`<br>`State.ViewFlags` | [Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L86) — `BIT TEXT_RUS_BIT, (HL)`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L59) — `BIT TEXT_RUS_BIT, (HL)`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L85) — `BIT TEXT_RUS_BIT, (HL)` |
| [`TILE_MIRROR_BIT`](../Includes/Const/Flags.inc#L48) | 7 | [`TILE_MIRROR`](../Includes/Const/Flags.inc#L49) = `#80` | флаг, горизонтальное отражение фонового тайла, переносится в Flags экранного объекта | `BattleTile.IndexAndFlags` | [Battle.MakeFieldTiles](../Source/Battle/MakeFieldTiles.asm#L26) — `RES TILE_MIRROR_BIT, B` |
| [`TOWN_ANGER_BIT`](../Includes/Const/Flags.inc#L289) | 1 | [`TOWN_ANGER`](../Includes/Const/Flags.inc#L291) = `#02` | флаг, город требует ранней проверки гарнизона и отказывает в сведениях о замке и новом контракте | `FTown.Flags` | [Overlay.City.Entry](../Source/Overlays/City.asm#L33) — `BIT TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L57) — `SET TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L156) — `BIT TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L206) — `BIT TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L354) — `BIT TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)` |
| [`TOWN_OFF_BIT`](../Includes/Const/Flags.inc#L287) | 0 | [`TOWN_OFF`](../Includes/Const/Flags.inc#L290) = `#01` | город выключен из стратегического обхода и обновления гарнизона | `FTown.Flags` | [Engine.CastleIncome](../Source/Engine/CastleIncome.asm#L30) — `BIT TOWN_OFF_BIT, (IX + FTown.Flags)`<br>[Engine.RefreshTowns](../Source/Engine/RefreshTowns.asm#L29) — `BIT TOWN_OFF_BIT, (IX + FTown.Flags - FTown.Army)` |
| [`TOWN_ROLL_BIT`](../Includes/Const/Flags.inc#L403) | 0 | — | младший бит результата RandomScaled(1), единица откладывает обновление города | `RefreshTowns.RandomResult` | [Engine.RefreshTowns](../Source/Engine/RefreshTowns.asm#L34) — `BIT TOWN_ROLL_BIT, E` |
| [`TOWN_XCHECK_BIT`](../Includes/Const/Flags.inc#L407) | 1 | — | бит координаты X города, исходный код проверяет гарнизон только при его установке, это не флаг FTown.Flags | `FTown.X` | [Engine.CastleIncome](../Source/Engine/CastleIncome.asm#L59) — `BIT TOWN_XCHECK_BIT, (IX + FTown.X)` |
| [`TROOP_DROWN_BIT`](../Includes/Const/Flags.inc#L295) | 5 | [`TROOP_DROWN`](../Includes/Const/Flags.inc#L300) = `#20` | временная отметка утонувшего отряда в старших битах ID недельного расчёта | `FTroop.ID` | [Engine.TickTime](../Source/Engine/TickTime.asm#L375) — `SET TROOP_DROWN_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L556) — `BIT TROOP_DROWN_BIT, (IY + FTroop.ID)` |
| [`TROOP_FLED_BIT`](../Includes/Const/Flags.inc#L297) | 6 | [`TROOP_FLED`](../Includes/Const/Flags.inc#L301) = `#40` | временная отметка сбежавшего неоплаченного отряда в ID | `FTroop.ID` | [Engine.TickTime](../Source/Engine/TickTime.asm#L521) — `SET TROOP_FLED_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L568) — `BIT TROOP_FLED_BIT, (IY + FTroop.ID)` |
| [`TROOP_FREE_BIT`](../Includes/Const/Flags.inc#L163) | 0 | [`TROOP_FREE`](../Includes/Const/Flags.inc#L164) = `#01` | свободная либо использованная шестибайтовая запись существ карты | `FMapTroop.Flags` | [Engine.MoveSitesC](../Source/Engine/MoveSitesC.asm#L25) — `BIT TROOP_FREE_BIT, (IX + FMapTroop.Flags)`<br>[Engine.RepopulateSites](../Source/Engine/RepopulateSites.asm#L40) — `BIT TROOP_FREE_BIT, (IX + FMapTroop.Flags)`<br>[Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L74) — `BIT TROOP_FREE_BIT, (IX + FMapTroop.Flags)`<br>[Overlay.Castle.PlaceAuxTroops](../Source/Overlays/Castle.asm#L762) — `BIT TROOP_FREE_BIT, (HL)`<br>[Overlay.Join.Entry](../Source/Overlays/Join.asm#L37) — `SET TROOP_FREE_BIT, (IX + FMapTroop.Flags - FMapTroop.ID)` |
| [`TROOP_REBEL_BIT`](../Includes/Const/Flags.inc#L299) | 7 | [`TROOP_REBEL`](../Includes/Const/Flags.inc#L302) = `#80` | временная отметка отряда для нападения на героя при финансовом либо культовом событии | `FTroop.ID` | [Engine.TickTime](../Source/Engine/TickTime.asm#L455) — `SET TROOP_REBEL_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L518) — `SET TROOP_REBEL_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L562) — `BIT TROOP_REBEL_BIT, (IY + FTroop.ID)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L620) — `BIT TROOP_REBEL_BIT, A` |
| [`UNIT_AFLOAT_BIT`](../Includes/Const/Flags.inc#L306) | 6 | [`UNIT_AFLOAT`](../Includes/Const/Flags.inc#L307) = `#40` | способность типа защищает от отметки утонувшего при утрате корабля | `FSoldier.MoveFlags` | [Engine.TickTime](../Source/Engine/TickTime.asm#L372) — `BIT UNIT_AFLOAT_BIT, E` |
| [`UNIT_CITY_BIT`](../Includes/Const/Flags.inc#L313) | 4 | [`UNIT_CITY`](../Includes/Const/Flags.inc#L315) = `#10` | флаг, тип существ разрешает раннюю городскую проверку даже без установленной отметки города | `FSoldier.ExtraFlags` | [Overlay.City.Entry](../Source/Overlays/City.asm#L43) — `BIT UNIT_CITY_BIT, D` |
| [`UNIT_FLY_BIT`](../Includes/Const/Flags.inc#L57) | 2 | [`UNIT_FLY`](../Includes/Const/Flags.inc#L66) = `#04` | флаг, способность к полёту, доступность действия дополнительно зависит от эффекта | `FBattleUnit.Flags`<br>`FSoldier.MoveFlags` | [Battle.InputLoop](../Source/Battle/InputLoop.asm#L878) — `BIT UNIT_FLY_BIT, (IY + FBattleUnit.Flags)`<br>[Engine.BuildArmy](../Source/Engine/BuildArmy.asm#L100) — `RES UNIT_FLY_BIT, C`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L106) — `BIT UNIT_FLY_BIT, E`<br>[Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L41) — `BIT UNIT_FLY_BIT, E` |
| [`UNIT_ID_HI_BIT`](../Includes/Const/Flags.inc#L375) | 4 | — | позиция старшего значащего бита ID, при допустимых ID 1..25 единица означает диапазон 16..25 | `FBattleUnit.UnitID` | [Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L134) — `BIT UNIT_ID_HI_BIT, (HL)` |
| [`UNIT_MAGIC_BIT`](../Includes/Const/Flags.inc#L53) | 0 | [`UNIT_MAGIC`](../Includes/Const/Flags.inc#L64) = `#01` | флаг, тип отряда использует магическое дальнее действие | `FBattleUnit.Flags`<br>`FSoldier.MoveFlags` | [Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L220) — `RES UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L171) — `BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L215) — `BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L235) — `BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)` |
| [`UNIT_MARK_BIT`](../Includes/Const/Flags.inc#L59) | 5 | [`UNIT_MARK`](../Includes/Const/Flags.inc#L67) = `#20` | флаг, временная отметка соседства или кандидата в текущем проходе выбора цели | `FBattleUnit.Flags` | [Battle.AISpell](../Source/Battle/AISpell.asm#L217) — `SET UNIT_MARK_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L230) — `BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L277) — `BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L295) — `BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L427) — `BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.ChooseTarget](../Source/Battle/ChooseTarget.asm#L59) — `SET UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.ChooseTarget](../Source/Battle/ChooseTarget.asm#L75) — `BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.ChooseTarget](../Source/Battle/ChooseTarget.asm#L106) — `BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.MarkAdjacent](../Source/Battle/MarkAdjacent.asm#L20) — `RES UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.MarkAdjacent](../Source/Battle/MarkAdjacent.asm#L45) — `SET UNIT_MARK_BIT, (IX + FBattleUnit.Flags)` |
| [`UNIT_MUTINY_BIT`](../Includes/Const/Flags.inc#L311) | 0 | [`UNIT_MUTINY`](../Includes/Const/Flags.inc#L314) = `#01` | при неоплаченном содержании тип выбирает нападение на героя вместо побега | `FSoldier.ExtraFlags` | [Engine.TickTime](../Source/Engine/TickTime.asm#L515) — `BIT UNIT_MUTINY_BIT, D` |
| [`UNIT_SHOT_BIT`](../Includes/Const/Flags.inc#L55) | 1 | [`UNIT_SHOT`](../Includes/Const/Flags.inc#L65) = `#02` | флаг, тип отряда использует обычную дальнюю атаку | `FBattleUnit.Flags`<br>`FSoldier.MoveFlags` | [Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L221) — `RES UNIT_SHOT_BIT, (IY + FBattleUnit.Flags)`<br>[Engine.BuildArmy](../Source/Engine/BuildArmy.asm#L99) — `RES UNIT_SHOT_BIT, C` |
| [`UNIT_SKIP_BIT`](../Includes/Const/Flags.inc#L61) | 6 | [`UNIT_SKIP`](../Includes/Const/Flags.inc#L68) = `#40` | флаг, временно исключить отряд из повторного выбора цели | `FBattleUnit.Flags` | [Battle.AISpell](../Source/Battle/AISpell.asm#L107) — `SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L124) — `SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L261) — `SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L396) — `SET UNIT_SKIP_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L466) — `SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L532) — `SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L458) — `SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L481) — `RES UNIT_SKIP_BIT, (HL)`<br>[Battle.ChooseTarget](../Source/Battle/ChooseTarget.asm#L33) — `BIT UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)` |
| [`UNIT_UNRULE_BIT`](../Includes/Const/Flags.inc#L63) | 7 | [`UNIT_UNRULE`](../Includes/Const/Flags.inc#L69) = `#80` | флаг, численность отряда превышает предел управления героя | `FBattleUnit.Flags` | [Battle.InputLoop](../Source/Battle/InputLoop.asm#L48) — `BIT UNIT_UNRULE_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L848) — `BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.MarkUnruled](../Source/Battle/MarkUnruled.asm#L25) — `RES UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.MarkUnruled](../Source/Battle/MarkUnruled.asm#L29) — `SET UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.ResolveLosses](../Source/Battle/ResolveLosses.asm#L79) — `BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.ResolveLosses](../Source/Battle/ResolveLosses.asm#L103) — `BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.ResolveLosses](../Source/Battle/ResolveLosses.asm#L117) — `BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.SelectActor](../Source/Battle/SelectActor.asm#L66) — `BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)` |
| [`VIEW_AIR_BIT`](../Includes/Const/Flags.inc#L170) | 1 | [`VIEW_AIR`](../Includes/Const/Flags.inc#L172) = `#02` | флаг, в меню доступен вид с высоты, в армии найден летающий тип | `Overlay.Maps.WaitMapKey.ViewModes` | [Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L125) — `SET VIEW_AIR_BIT, A`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L132) — `BIT VIEW_AIR_BIT, A`<br>[Overlay.Maps.DrawWorldMap](../Source/Overlays/Maps.asm#L657) — `BIT VIEW_AIR_BIT, A` |
| [`VIEW_RENDER_BIT`](../Includes/Const/Flags.inc#L326) | 2 | [`VIEW_RENDER`](../Includes/Const/Flags.inc#L328) = `#04` | разрешает обновление экранных объектов из прерывания | `State.ViewFlags` | [Engine.Interrupt](../Source/Engine/Interrupt.asm#L66) — `BIT VIEW_RENDER_BIT, A`<br>[Engine.StartView](../Source/Engine/StartView.asm#L14) — `SET VIEW_RENDER_BIT, A`<br>[Engine.StopView](../Source/Engine/StopView.asm#L14) — `RES VIEW_RENDER_BIT, A` |
| [`VIEW_WORLD_BIT`](../Includes/Const/Flags.inc#L168) | 0 | [`VIEW_WORLD`](../Includes/Const/Flags.inc#L171) = `#01` | флаг, в меню доступна полная карта текущего континента | `Overlay.Maps.WaitMapKey.ViewModes` | [Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L142) — `BIT VIEW_WORLD_BIT, A`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L172) — `BIT VIEW_WORLD_BIT, A`<br>[Overlay.Maps.DrawWorldMap](../Source/Overlays/Maps.asm#L648) — `BIT VIEW_WORLD_BIT, A` |

## Флаги записей и рабочих байтов

Слева показан бит 7, справа бит 0. Повторяющаяся метка означает многобитное числовое поле. `..` не разрешает использовать разряд как свободный. Схемы описывают установленный смысл потребителей, а не исчерпывающее выполнение всех игровых сценариев.

## FMapArmy.Flags, смещение +#00

[Includes/Structs/MapArmy.inc](../Includes/Structs/MapArmy.inc#L27)

```asm
; -----------------------------------------
; FMapArmy.Flags, смещение +#00
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | FC | WA | PR | DL | DL | DL | FR |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   FC       [6] - флаг, горизонтальная ориентация, направления 2..4 ставят бит, 6..8 снимают, 1 и 5 сохраняют
;   WA       [5] - флаг, 1 выбирает водный класс группы пиратов, 0 наземный класс разбойников
;     ARMY_WATER_BIT
;   PR       [4] - флаг, запись уже обработана в текущем проходе, в конце обхода отметка снимается
;     ARMY_MOVED_BIT
;   DL       [3..1] - поле, задержка 0..7, ненулевое значение уменьшается на 1 и пропускает движение
;   FR       [0] - флаг, 1 означает свободную или выключенную запись, 0 допускает обработку
;     ARMY_FREE_BIT
; .. [7] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `FC` | — | горизонтальная ориентация, направления 2..4 ставят бит, 6..8 снимают, 1 и 5 сохраняют | [Engine.SetFacing](../Source/Engine/SetFacing.asm#L13) — `CP #01`<br>[Engine.SetFacing](../Source/Engine/SetFacing.asm#L16) — `CP #05`<br>[Engine.SetFacing](../Source/Engine/SetFacing.asm#L21) — `RES OBJECT_FACE_BIT, (IX + FMapSite.Flags)`<br>[Engine.SetFacing](../Source/Engine/SetFacing.asm#L24) — `SET OBJECT_FACE_BIT, (IX + FMapSite.Flags)` |
| `WA` | `ARMY_WATER_BIT` | 1 выбирает водный класс группы пиратов, 0 наземный класс разбойников | [Engine.StepArmies](../Source/Engine/StepArmies.asm#L106) — `AND #20`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L39) — `BIT ARMY_WATER_BIT, (IX + FMapArmy.Flags - 3)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L170) — `BIT ARMY_WATER_BIT, (HL)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L393) — `BIT ARMY_WATER_BIT, (HL)`<br>[Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L132) — `BIT ARMY_WATER_BIT, (HL)`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L168) — `BIT ARMY_WATER_BIT, (IX + FMapArmy.Flags - FMapArmy.Mana)` |
| `PR` | `ARMY_MOVED_BIT` | запись уже обработана в текущем проходе, в конце обхода отметка снимается | [Engine.StepArmies](../Source/Engine/StepArmies.asm#L82) — `AND #11`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L495) — `SET ARMY_MOVED_BIT, (IX + FMapArmy.Flags)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L511) — `RES ARMY_MOVED_BIT, (HL)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L316) — `SET ARMY_MOVED_BIT, (IX + FMapArmy.Flags)` |
| `DL` | — | задержка 0..7, ненулевое значение уменьшается на 1 и пропускает движение | [Engine.StepArmies](../Source/Engine/StepArmies.asm#L86) — `AND #0E`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L89) — `SUB #02`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L92) — `AND #F1` |
| `FR` | `ARMY_FREE_BIT` | 1 означает свободную или выключенную запись, 0 допускает обработку | [Engine.StepArmies](../Source/Engine/StepArmies.asm#L82) — `AND #11`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L234) — `BIT ARMY_FREE_BIT, (HL)`<br>[Engine.RegenMana](../Source/Engine/RegenMana.asm#L26) — `BIT ARMY_FREE_BIT, (IX + FMapArmy.Flags)`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L196) — `SET ARMY_FREE_BIT, (IX + FMapArmy.Flags - FMapArmy.Mana)` |

## FMapTroop.Flags, смещение +#00

[Includes/Structs/MapTroop.inc](../Includes/Structs/MapTroop.inc#L21)

```asm
; -----------------------------------------
; FMapTroop.Flags, смещение +#00
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | FC | WA | .. | .. | .. | .. | FR |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   FC       [6] - флаг, горизонтальная ориентация, изменяется общей процедурой SetFacing
;   WA       [5] - флаг, 1 соответствует водному режиму группы, 0 наземному
;   FR       [0] - флаг, 1 означает свободную или использованную запись, 0 допускает обработку
;     TROOP_FREE_BIT
; .. [7, 4, 3, 2, 1] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `FC` | — | горизонтальная ориентация, изменяется общей процедурой SetFacing | [Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L200) — `CALL SetFacing`<br>[Engine.SetFacing](../Source/Engine/SetFacing.asm#L21) — `RES OBJECT_FACE_BIT, (IX + FMapSite.Flags)`<br>[Engine.SetFacing](../Source/Engine/SetFacing.asm#L24) — `SET OBJECT_FACE_BIT, (IX + FMapSite.Flags)` |
| `WA` | — | 1 соответствует водному режиму группы, 0 наземному | [Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L82) — `LD A, (State.MoveFlags)`<br>[Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L83) — `AND #03`<br>[Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L86) — `AND #20` |
| `FR` | `TROOP_FREE_BIT` | 1 означает свободную или использованную запись, 0 допускает обработку | [Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L74) — `BIT TROOP_FREE_BIT, (IX + FMapTroop.Flags)`<br>[Engine.MoveSitesC](../Source/Engine/MoveSitesC.asm#L25) — `BIT TROOP_FREE_BIT, (IX + FMapTroop.Flags)`<br>[Engine.RepopulateSites](../Source/Engine/RepopulateSites.asm#L40) — `BIT TROOP_FREE_BIT, (IX + FMapTroop.Flags)`<br>[Overlay.Castle.PlaceAuxTroops](../Source/Overlays/Castle.asm#L762) — `BIT TROOP_FREE_BIT, (HL)`<br>[Overlay.Join.Entry](../Source/Overlays/Join.asm#L37) — `SET TROOP_FREE_BIT, (IX + FMapTroop.Flags - FMapTroop.ID)` |

## FCastle.Flags, смещение +#00

[Includes/Structs/Castle.inc](../Includes/Structs/Castle.inc#L17)

```asm
; -----------------------------------------
; FCastle.Flags, смещение +#00
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | .. | NO |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   NO       [0] - флаг, 1 выключает запись замка из обхода, 0 оставляет её активной
;     CASTLE_OFF_BIT
; .. [7, 6, 5, 4, 3, 2, 1] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `NO` | `CASTLE_OFF_BIT` | 1 выключает запись замка из обхода, 0 оставляет её активной | [Engine.CountOwnCastles](../Source/Engine/CountOwnCastles.asm#L23) — `BIT CASTLE_OFF_BIT, (IX + FCastle.Flags)`<br>[Engine.CountOwnCastles](../Source/Engine/CountOwnCastles.asm#L24) — `JR NZ, .NextCastle`<br>[Engine.ApplyMoveCode](../Source/Engine/ApplyMoveCode.asm#L109) — `BIT CASTLE_OFF_BIT, (IX + FCastle.Flags)`<br>[Engine.HasOwnerCastle](../Source/Engine/HasOwnerCastle.asm#L26) — `BIT CASTLE_OFF_BIT, (IX + FCastle.Flags)`<br>[Engine.SumCastleIncome](../Source/Engine/SumCastleIncome.asm#L28) — `BIT CASTLE_OFF_BIT, (IY + FCastle.Flags)`<br>[Engine.TickCastle](../Source/Engine/TickCastle.asm#L72) — `BIT CASTLE_OFF_BIT, (IX + FCastle.Flags)`<br>[Overlay.Capture.Entry](../Source/Overlays/Capture.asm#L389) — `BIT CASTLE_OFF_BIT, (IX + FCastle.Flags)`<br>[Overlay.Info.FindOwnCastle](../Source/Overlays/Info.asm#L493) — `BIT CASTLE_OFF_BIT, (IX + FCastle.Flags - FCastle.Name)` |

## FMapItem.Flags, смещение +#00

[Includes/Structs/MapItem.inc](../Includes/Structs/MapItem.inc#L19)

```asm
; -----------------------------------------
; FMapItem.Flags, смещение +#00
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | .. | NO |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   NO       [0] - флаг, 1 отмечает использованную или выключенную находку, 0 оставляет её активной
;     ITEM_USED_BIT
; .. [7, 6, 5, 4, 3, 2, 1] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `NO` | `ITEM_USED_BIT` | 1 отмечает использованную или выключенную находку, 0 оставляет её активной | [Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L156) — `SET ITEM_USED_BIT, (IX + FMapItem.Flags)`<br>[Engine.FindRecord](../Source/Engine/FindRecord.asm#L44) — `BIT SITE_OFF_BIT, (IX + FMapSite.Flags)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L194) — `SET ITEM_USED_BIT, (IX + FMapItem.Flags)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L417) — `SET ITEM_USED_BIT, (IX + FMapItem.Flags)`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L31) — `SET ITEM_USED_BIT, (IX + FMapItem.Flags)` |

## FTemple.Flags, смещение +#00

[Includes/Structs/Temple.inc](../Includes/Structs/Temple.inc#L19)

Дескриптор типа 3 в FindMapObject задаёт шаг 5 байтов для записей храма

```asm
; -----------------------------------------
; FTemple.Flags, смещение +#00
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | .. | NO |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   NO       [0] - флаг, 1 выключает запись храма из общего поиска, 0 оставляет её активной
; .. [7, 6, 5, 4, 3, 2, 1] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `NO` | — | 1 выключает запись храма из общего поиска, 0 оставляет её активной | [Engine.FindMapObject](../Source/Engine/FindMapObject.asm#L85) — `DB #01, #01, #09, #6B, #05, #02, #02, #19`<br>[Engine.FindRecord](../Source/Engine/FindRecord.asm#L44) — `BIT SITE_OFF_BIT, (IX + FMapSite.Flags)` |

## FTown.Flags, смещение +#00

[Includes/Structs/Town.inc](../Includes/Structs/Town.inc#L23)

Нулевой CB сам по себе не гарантирует новый контракт, далее есть другие проверки

```asm
; -----------------------------------------
; FTown.Flags, смещение +#00
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | CB | NO |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   CB       [1] - флаг, 1 разрешает раннюю городскую ветвь, но вызывает отказ при запросе нового контракта
;     TOWN_ANGER_BIT
;   NO       [0] - флаг, 1 выключает запись города из общего поиска, 0 оставляет её активной
;     TOWN_OFF_BIT
; .. [7, 6, 5, 4, 3, 2] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `CB` | `TOWN_ANGER_BIT` | 1 разрешает раннюю городскую ветвь, но вызывает отказ при запросе нового контракта | [Overlay.City.Entry](../Source/Overlays/City.asm#L33) — `BIT TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L34) — `JR NZ, .CheckCityUnits`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L354) — `BIT TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L355) — `JR Z, .HasContract`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L357) — `CALL RefuseEntry`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L57) — `SET TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L156) — `BIT TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L206) — `BIT TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)` |
| `NO` | `TOWN_OFF_BIT` | 1 выключает запись города из общего поиска, 0 оставляет её активной | [Engine.FindMapObject](../Source/Engine/FindMapObject.asm#L84) — `DB #E9, #6A, #23, #02, #03, #F9, #6A, #1A`<br>[Engine.FindMapObject](../Source/Engine/FindMapObject.asm#L85) — `DB #01, #01, #09, #6B, #05, #02, #02, #19`<br>[Engine.FindRecord](../Source/Engine/FindRecord.asm#L44) — `BIT SITE_OFF_BIT, (IX + FMapSite.Flags)`<br>[Engine.CastleIncome](../Source/Engine/CastleIncome.asm#L30) — `BIT TOWN_OFF_BIT, (IX + FTown.Flags)`<br>[Engine.RefreshTowns](../Source/Engine/RefreshTowns.asm#L29) — `BIT TOWN_OFF_BIT, (IX + FTown.Flags - FTown.Army)` |

## FPerson.Spells, каждый из 10 байтов, смещение +#12

[Includes/Structs/Person.inc](../Includes/Structs/Person.inc#L24)

```asm
; -----------------------------------------
; FPerson.Spells, каждый из 10 байтов, смещение +#12
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | .. | KN |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   KN       [0] - флаг, заклинание изучено, 1 позволяет вывести его в списке известных заклинаний
;     SPELL_KNOWN_BIT
; .. [7, 6, 5, 4, 3, 2, 1] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `KN` | `SPELL_KNOWN_BIT` | заклинание изучено, 1 позволяет вывести его в списке известных заклинаний | [Overlay.Info.ListSpells](../Source/Overlays/Info.asm#L877) — `LD HL, State.Spells - 1`<br>[Overlay.Info.ListSpells](../Source/Overlays/Info.asm#L878) — `ADD HL, BC`<br>[Overlay.Info.ListSpells](../Source/Overlays/Info.asm#L879) — `BIT SPELL_KNOWN_BIT, (HL)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L287) — `BIT SPELL_KNOWN_BIT, (HL)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L379) — `BIT SPELL_KNOWN_BIT, (HL)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L420) — `BIT SPELL_KNOWN_BIT, (HL)`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L203) — `BIT SPELL_KNOWN_BIT, (HL)`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L215) — `SET SPELL_KNOWN_BIT, (HL)` |

## FPerson.MoveFlags, смещение +#3B, адрес #6A33

[Includes/Structs/Person.inc](../Includes/Structs/Person.inc#L60)

Значение режима 3 отдельным способом движения не объявляется

```asm
; -----------------------------------------
; FPerson.MoveFlags, смещение +#3B, адрес #6A33
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | SG | SF | HF | NH | MD | MD |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   SG       [5] - флаг, наличие осадного орудия, перед полётом предлагается его оставить
;     HERO_SIEGE_BIT
;   SF       [4] - флаг, ориентация корабля, 1 задаётся при шаге вправо на корабле, 0 при шаге влево
;     SHIP_FACE_BIT
;   HF       [3] - флаг, ориентация героя, 1 задаётся при шаге вправо, 0 при шаге влево
;     HERO_FACE_BIT
;   NH       [2] - флаг, 1 пропускает подготовку изображения героя в локальном окне
;     HERO_HIDE_BIT
;   MD       [1..0] - поле, режим движения, 0 суша, 1 корабль, 2 полёт
; .. [7, 6] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `SG` | `HERO_SIEGE_BIT` | наличие осадного орудия, перед полётом предлагается его оставить | [Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L63) — `BIT HERO_SIEGE_BIT, A`<br>[Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L93) — `RES HERO_SIEGE_BIT, A`<br>[Overlay.Info.Entry](../Source/Overlays/Info.asm#L154) — `BIT HERO_SIEGE_BIT, A`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L837) — `RES HERO_SIEGE_BIT, A`<br>[Battle.ResolveLosses](../Source/Battle/ResolveLosses.asm#L181) — `RES HERO_SIEGE_BIT, A`<br>[Overlay.Capture.Entry](../Source/Overlays/Capture.asm#L81) — `BIT HERO_SIEGE_BIT, A`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L165) — `BIT HERO_SIEGE_BIT, A`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L196) — `SET HERO_SIEGE_BIT, A` |
| `SF` | `SHIP_FACE_BIT` | ориентация корабля, 1 задаётся при шаге вправо на корабле, 0 при шаге влево | [Engine.MapMoveRight](../Source/Engine/MapMoveRight.asm#L23) — `CP #01`<br>[Engine.MapMoveRight](../Source/Engine/MapMoveRight.asm#L27) — `SET SHIP_FACE_BIT, A`<br>[Engine.MapMoveLeft](../Source/Engine/MapMoveLeft.asm#L24) — `CP #01`<br>[Engine.MapMoveLeft](../Source/Engine/MapMoveLeft.asm#L28) — `RES SHIP_FACE_BIT, A`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L233) — `BIT SHIP_FACE_BIT, A`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L236) — `LD D, #43` |
| `HF` | `HERO_FACE_BIT` | ориентация героя, 1 задаётся при шаге вправо, 0 при шаге влево | [Engine.MapMoveRight](../Source/Engine/MapMoveRight.asm#L20) — `SET HERO_FACE_BIT, A`<br>[Engine.MapMoveLeft](../Source/Engine/MapMoveLeft.asm#L21) — `RES HERO_FACE_BIT, A`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L191) — `BIT HERO_FACE_BIT, A`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L194) — `SET FRONT_FLIP_BIT, (IX + FScreenObject20.Flags)` |
| `NH` | `HERO_HIDE_BIT` | 1 пропускает подготовку изображения героя в локальном окне | [Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L182) — `BIT HERO_HIDE_BIT, A`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L183) — `JR NZ, .CheckShip`<br>[Engine.TickCastle](../Source/Engine/TickCastle.asm#L351) — `SET HERO_HIDE_BIT, A`<br>[Engine.TickCastle](../Source/Engine/TickCastle.asm#L355) — `RES HERO_HIDE_BIT, A`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L28) — `SET HERO_HIDE_BIT, A`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L33) — `RES HERO_HIDE_BIT, A`<br>[Overlay.Capture.Entry](../Source/Overlays/Capture.asm#L33) — `SET HERO_HIDE_BIT, A`<br>[Overlay.Capture.Entry](../Source/Overlays/Capture.asm#L38) — `RES HERO_HIDE_BIT, A`<br>[Overlay.Join.Entry](../Source/Overlays/Join.asm#L27) — `SET HERO_HIDE_BIT, A`<br>[Overlay.Join.Entry](../Source/Overlays/Join.asm#L32) — `RES HERO_HIDE_BIT, A` |
| `MD` | — | режим движения, 0 суша, 1 корабль, 2 полёт | [Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L202) — `AND #03`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L203) — `JR NZ, .CheckHeroMode`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L208) — `CP #01`<br>[Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L92) — `OR #02`<br>[Overlay.Land.Entry](../Source/Overlays/Land.asm#L19) — `LD A, (State.MoveFlags)` |

## FPerson.MapFlags, смещение +#3C, адрес #6A34

[Includes/Structs/Person.inc](../Includes/Structs/Person.inc#L85)

Континент 1 добавляется морским меню независимо от флага, число пунктов строится по маске #0F

Оверлей 13 модифицирует номер бита инструкции BIT по формуле Continent + 3

```asm
; -----------------------------------------
; FPerson.MapFlags, смещение +#3C, адрес #6A34
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | M4 | M3 | M2 | M1 | .. | C4 | C3 | C2 |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   M4       [7] - флаг, доступна полная карта континента 4
;   M3       [6] - флаг, доступна полная карта континента 3
;   M2       [5] - флаг, доступна полная карта континента 2
;   M1       [4] - флаг, доступна полная карта континента 1
;   C4       [2] - флаг, разрешён выбор континента 4 в морском меню
;   C3       [1] - флаг, разрешён выбор континента 3 в морском меню
;   C2       [0] - флаг, разрешён выбор континента 2 в морском меню, этот же бит разрешает вход в меню перехода
;     SEA_ACCESS_BIT
; .. [3] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `M4` | — | доступна полная карта континента 4 | [Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L75) — `LD A, (State.MapFlags)`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L77) — `LD A, (State.Continent)`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L78) — `ADD A, #03`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L83) — `LD (Entry.MapTestOp), A`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L84) — `BIT MAP_INDEX_BIT, B` |
| `M3` | — | доступна полная карта континента 3 | [Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L75) — `LD A, (State.MapFlags)`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L77) — `LD A, (State.Continent)`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L78) — `ADD A, #03`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L83) — `LD (Entry.MapTestOp), A`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L84) — `BIT MAP_INDEX_BIT, B` |
| `M2` | — | доступна полная карта континента 2 | [Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L75) — `LD A, (State.MapFlags)`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L77) — `LD A, (State.Continent)`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L78) — `ADD A, #03`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L83) — `LD (Entry.MapTestOp), A`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L84) — `BIT MAP_INDEX_BIT, B` |
| `M1` | — | доступна полная карта континента 1 | [Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L75) — `LD A, (State.MapFlags)`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L77) — `LD A, (State.Continent)`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L78) — `ADD A, #03`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L83) — `LD (Entry.MapTestOp), A`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L84) — `BIT MAP_INDEX_BIT, B` |
| `C4` | — | разрешён выбор континента 4 в морском меню | [Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L49) — `SLA A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L51) — `AND #0F`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L55) — `SRL A` |
| `C3` | — | разрешён выбор континента 3 в морском меню | [Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L49) — `SLA A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L51) — `AND #0F`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L55) — `SRL A` |
| `C2` | `SEA_ACCESS_BIT` | разрешён выбор континента 2 в морском меню, этот же бит разрешает вход в меню перехода | [Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L27) — `BIT SEA_ACCESS_BIT, A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L28) — `RET Z`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L48) — `LD A, (State.MapFlags)`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L49) — `SLA A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L50) — `SET SEA_FIRST_BIT, A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L51) — `AND #0F`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L55) — `SRL A` |

## FPerson.PuzzleOpen, каждый из 5 байтов строки, смещение +#5D

[Includes/Structs/Person.inc](../Includes/Structs/Person.inc#L128)

Пять младших битов соответствуют пяти фрагментам строки, старшие три потребитель отбрасывает

```asm
; -----------------------------------------
; FPerson.PuzzleOpen, каждый из 5 байтов строки, смещение +#5D
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | P0 | P1 | P2 | P3 | P4 |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   P0       [4] - флаг, открыт фрагмент текущей строки в столбце 0, столбцы считаются слева с 0
;   P1       [3] - флаг, открыт фрагмент текущей строки в столбце 1, столбцы считаются слева с 0
;   P2       [2] - флаг, открыт фрагмент текущей строки в столбце 2, столбцы считаются слева с 0
;   P3       [1] - флаг, открыт фрагмент текущей строки в столбце 3, столбцы считаются слева с 0
;   P4       [0] - флаг, открыт фрагмент текущей строки в столбце 4, столбцы считаются слева с 0
; .. [7, 6, 5] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `P0` | — | открыт фрагмент текущей строки в столбце 0, столбцы считаются слева с 0 | [Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L71) — `LD E, (IY)`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L72) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L73) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L74) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L78) — `SLA E`<br>[Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L472) — `BIT PIECE_INDEX_BIT, (HL)`<br>[Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L476) — `SET PIECE_INDEX_BIT, (HL)` |
| `P1` | — | открыт фрагмент текущей строки в столбце 1, столбцы считаются слева с 0 | [Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L71) — `LD E, (IY)`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L72) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L73) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L74) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L78) — `SLA E`<br>[Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L472) — `BIT PIECE_INDEX_BIT, (HL)`<br>[Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L476) — `SET PIECE_INDEX_BIT, (HL)` |
| `P2` | — | открыт фрагмент текущей строки в столбце 2, столбцы считаются слева с 0 | [Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L71) — `LD E, (IY)`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L72) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L73) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L74) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L78) — `SLA E`<br>[Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L472) — `BIT PIECE_INDEX_BIT, (HL)`<br>[Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L476) — `SET PIECE_INDEX_BIT, (HL)` |
| `P3` | — | открыт фрагмент текущей строки в столбце 3, столбцы считаются слева с 0 | [Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L71) — `LD E, (IY)`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L72) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L73) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L74) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L78) — `SLA E`<br>[Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L472) — `BIT PIECE_INDEX_BIT, (HL)`<br>[Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L476) — `SET PIECE_INDEX_BIT, (HL)` |
| `P4` | — | открыт фрагмент текущей строки в столбце 4, столбцы считаются слева с 0 | [Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L71) — `LD E, (IY)`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L72) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L73) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L74) — `SLA E`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L78) — `SLA E`<br>[Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L472) — `BIT PIECE_INDEX_BIT, (HL)`<br>[Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L476) — `SET PIECE_INDEX_BIT, (HL)` |

## FSoldier.MoveFlags, смещение +#0D

[Includes/Structs/Soldier.inc](../Includes/Structs/Soldier.inc#L34)

Младшие три бита копируются в боевую запись, режим построения 3 дополнительно снимает SH и FL

```asm
; -----------------------------------------
; FSoldier.MoveFlags, смещение +#0D
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | DR | WA | CL | CL | CL | FL | SH | MA |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   DR       [7] - флаг, разрешает атакующему увеличивать численность за счёт нанесённого урона
;     DRAIN_HIT_BIT
;   WA       [6] - флаг, при корабельном событии 1 защищает от отметки утонувшего отряда, 0 ставит её в ID
;     UNIT_AFLOAT_BIT
;   CL       [5..3] - поле, биты маски совместимости с классом местности, отдельные игровые имена классов не установлены
;   FL       [2] - флаг, способность полёта, для взлёта героя требуется у всех отрядов
;     UNIT_FLY_BIT
;   SH       [1] - флаг, обычная дальняя атака, при сброшенном MA не используется ветвь магического действия
;     UNIT_SHOT_BIT
;   MA       [0] - флаг, магическое дальнее действие, включает проверку магической защиты цели
;     UNIT_MAGIC_BIT
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `DR` | `DRAIN_HIT_BIT` | разрешает атакующему увеличивать численность за счёт нанесённого урона | [Battle.ApplyDrainTrait](../Source/Battle/ApplyDrainTrait.asm#L18) — `BIT DRAIN_HIT_BIT, E`<br>[Battle.ApplyDrainTrait](../Source/Battle/ApplyDrainTrait.asm#L23) — `CALL Engine.UnitDesc`<br>[Battle.ApplyDrainTrait](../Source/Battle/ApplyDrainTrait.asm#L26) — `RET NZ` |
| `WA` | `UNIT_AFLOAT_BIT` | при корабельном событии 1 защищает от отметки утонувшего отряда, 0 ставит её в ID | [Engine.TickTime](../Source/Engine/TickTime.asm#L371) — `CALL UnitFlags`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L372) — `BIT UNIT_AFLOAT_BIT, E`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L373) — `JR NZ, .NextFlyUnit`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L375) — `SET TROOP_DROWN_BIT, (HL)` |
| `CL` | — | биты маски совместимости с классом местности, отдельные игровые имена классов не установлены | [Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L178) — `CALL UnitFlags`<br>[Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L181) — `JR Z, .NextCandidate`<br>[Engine.FilterArmy](../Source/Engine/FilterArmy.asm#L39) — `CALL UnitFlags`<br>[Engine.FilterArmy](../Source/Engine/FilterArmy.asm#L42) — `AND #00` |
| `FL` | `UNIT_FLY_BIT` | способность полёта, для взлёта героя требуется у всех отрядов | [Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L40) — `CALL Engine.UnitFlags`<br>[Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L42) — `RET Z`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L878) — `BIT UNIT_FLY_BIT, (IY + FBattleUnit.Flags)`<br>[Engine.BuildArmy](../Source/Engine/BuildArmy.asm#L100) — `RES UNIT_FLY_BIT, C`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L106) — `BIT UNIT_FLY_BIT, E`<br>[Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L41) — `BIT UNIT_FLY_BIT, E` |
| `SH` | `UNIT_SHOT_BIT` | обычная дальняя атака, при сброшенном MA не используется ветвь магического действия | [Battle.InputLoop](../Source/Battle/InputLoop.asm#L155) — `AND #03`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L235) — `BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L221) — `RES UNIT_SHOT_BIT, (IY + FBattleUnit.Flags)`<br>[Engine.BuildArmy](../Source/Engine/BuildArmy.asm#L99) — `RES UNIT_SHOT_BIT, C` |
| `MA` | `UNIT_MAGIC_BIT` | магическое дальнее действие, включает проверку магической защиты цели | [Battle.InputLoop](../Source/Battle/InputLoop.asm#L235) — `BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L240) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L220) — `RES UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L171) — `BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L215) — `BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)` |

## FSoldier.ExtraFlags, смещение +#0E

[Includes/Structs/Soldier.inc](../Includes/Structs/Soldier.inc#L62)

```asm
; -----------------------------------------
; FSoldier.ExtraFlags, смещение +#0E
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | CT | G5 | HV | MI | AT |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   CT       [4] - флаг, допускает раннюю городскую ветвь даже при сброшенном бите 1 флагов города
;     UNIT_CITY_BIT
;   G5       [3] - флаг, допускает цель для выбора ИИ заклинания 5, игрокова ветвь отдельно этот бит не проверяет
;     BANISH_OK_BIT
;   HV       [2] - флаг, особый удар, при случайном результате от #59 численность цели делится на 2
;     HALF_HIT_BIT
;   MI       [1] - флаг, цель не поддаётся целевому магическому воздействию, проверяется также перед лечением и переносом
;     MAGIC_IMM_BIT
;   AT       [0] - флаг, при финансовом событии 1 выбирает отметку атакующего отряда, 0 отметку сбежавшего
;     UNIT_MUTINY_BIT
; .. [7, 6, 5] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `CT` | `UNIT_CITY_BIT` | допускает раннюю городскую ветвь даже при сброшенном бите 1 флагов города | [Overlay.City.Entry](../Source/Overlays/City.asm#L33) — `BIT TOWN_ANGER_BIT, (IX + FTown.Flags - FTown.Name)`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L42) — `CALL Engine.UnitFlags`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L43) — `BIT UNIT_CITY_BIT, D`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L44) — `JR NZ, .CheckCityUnits`<br>[Overlay.City.Entry](../Source/Overlays/City.asm#L53) — `LD A, (IX + FTown.Army - FTown.Name + FTroop.ID)` |
| `G5` | `BANISH_OK_BIT` | допускает цель для выбора ИИ заклинания 5, игрокова ветвь отдельно этот бит не проверяет | [Battle.AISpell](../Source/Battle/AISpell.asm#L462) — `CALL Engine.UnitFlags`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L466) — `SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L481) — `LD A, #05`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L463) — `BIT BANISH_OK_BIT, D` |
| `HV` | `HALF_HIT_BIT` | особый удар, при случайном результате от #59 численность цели делится на 2 | [Battle.ResolveAttack](../Source/Battle/ResolveAttack.asm#L53) — `CALL Engine.UnitFlags`<br>[Battle.ResolveAttack](../Source/Battle/ResolveAttack.asm#L74) — `CALL Engine.StoreFloat5`<br>[Battle.ResolveAttack](../Source/Battle/ResolveAttack.asm#L54) — `BIT HALF_HIT_BIT, D` |
| `MI` | `MAGIC_IMM_BIT` | цель не поддаётся целевому магическому воздействию, проверяется также перед лечением и переносом | [Battle.InputLoop](../Source/Battle/InputLoop.asm#L240) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L440) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L498) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L610) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L666) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L696) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L723) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L104) — `BIT MAGIC_IMM_BIT, D`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L121) — `BIT MAGIC_IMM_BIT, D` |
| `AT` | `UNIT_MUTINY_BIT` | при финансовом событии 1 выбирает отметку атакующего отряда, 0 отметку сбежавшего | [Engine.TickTime](../Source/Engine/TickTime.asm#L515) — `BIT UNIT_MUTINY_BIT, D`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L516) — `JR Z, .MarkDesertion`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L518) — `SET TROOP_REBEL_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L521) — `SET TROOP_FLED_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L562) — `BIT TROOP_REBEL_BIT, (IY + FTroop.ID)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L568) — `BIT TROOP_FLED_BIT, (IY + FTroop.ID)` |

## FSoldier.SpecialFlags, смещение +#15

[Includes/Structs/Soldier.inc](../Includes/Structs/Soldier.inc#L93)

```asm
; -----------------------------------------
; FSoldier.SpecialFlags, смещение +#15
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | EN | CR | ND | CP |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   EN       [3] - флаг, поражение от армии с таким типом запускает ветвь сюжетного окончания
;     STORY_END_BIT
;   CR       [2] - флаг, позволяет отряду переносить героя в полёте, нужен хотя бы один такой отряд
;     HERO_CARRY_BIT
;   ND       [1] - флаг, цель запрещает атакующему восстанавливать численность за счёт нанесённого ей урона
;     NO_DRAIN_BIT
;   CP       [0] - флаг, при восстановлении численности ограничивает результат исходным InitialCount
;     DRAIN_CAP_BIT
; .. [7, 6, 5, 4] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `EN` | `STORY_END_BIT` | поражение от армии с таким типом запускает ветвь сюжетного окончания | [Battle.DefeatStory](../Source/Battle/DefeatStory.asm#L25) — `CALL Engine.UnitDesc`<br>[Battle.DefeatStory](../Source/Battle/DefeatStory.asm#L26) — `BIT STORY_END_BIT, (IX + FSoldier.SpecialFlags)`<br>[Battle.DefeatStory](../Source/Battle/DefeatStory.asm#L30) — `CALL Engine.RunOverlay20` |
| `CR` | `HERO_CARRY_BIT` | позволяет отряду переносить героя в полёте, нужен хотя бы один такой отряд | [Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L58) — `CALL Engine.UnitDesc`<br>[Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L60) — `JR Z, .NextCarrier`<br>[Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L59) — `BIT HERO_CARRY_BIT, (IX + FSoldier.SpecialFlags)` |
| `ND` | `NO_DRAIN_BIT` | цель запрещает атакующему восстанавливать численность за счёт нанесённого ей урона | [Battle.ApplyDrainTrait](../Source/Battle/ApplyDrainTrait.asm#L23) — `CALL Engine.UnitDesc`<br>[Battle.ApplyDrainTrait](../Source/Battle/ApplyDrainTrait.asm#L26) — `RET NZ`<br>[Battle.ApplyDrainTrait](../Source/Battle/ApplyDrainTrait.asm#L24) — `BIT NO_DRAIN_BIT, (IX + FSoldier.SpecialFlags)` |
| `CP` | `DRAIN_CAP_BIT` | при восстановлении численности ограничивает результат исходным InitialCount | [Battle.ClampRegen](../Source/Battle/ClampRegen.asm#L16) — `CALL Engine.UnitDesc`<br>[Battle.ClampRegen](../Source/Battle/ClampRegen.asm#L19) — `RET Z`<br>[Battle.ClampRegen](../Source/Battle/ClampRegen.asm#L26) — `LD C, (IX + FBattleUnit.InitialCount.Low)`<br>[Battle.ClampRegen](../Source/Battle/ClampRegen.asm#L36) — `CALL Engine.StoreFloat5`<br>[Battle.ClampRegen](../Source/Battle/ClampRegen.asm#L17) — `BIT DRAIN_CAP_BIT, (IX + FSoldier.SpecialFlags)` |

## FBattleUnit.Flags, смещение +#09

[Includes/Structs/BattleUnit.inc](../Includes/Structs/BattleUnit.inc#L60)

ResetTurnFlags очищает биты 7..3 и сохраняет способности 2..0

BuildArmy при режиме #88F0=3 снимает биты SH и FL после копирования

Разряды 3 и 4 имеют разные значения у героя и ИИ, используются HERO_ACTED_BIT/HERO_REACH_BIT и AI_DEFERRED_BIT/AI_DONE_BIT

Поля `UnitID` и `Flags` не определяют сторону сами по себе. Нужен контекст армии. Для одного и того же байта используются следующие два представления.

### FBattleUnit.Flags, армия героя

```asm
; -----------------------------------------
; FBattleUnit.Flags, армия героя
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | OC | TX | TC | HR | HA | FL | SH | MA |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   OC       [7] - флаг, численность превышает предел управления, выбирается ветвь неуправляемого отряда
;     UNIT_UNRULE_BIT
;   TX       [6] - флаг, временно исключает запись из повторного выбора цели
;     UNIT_SKIP_BIT
;   TC       [5] - флаг, временная отметка соседа или кандидата при выборе цели
;     UNIT_MARK_BIT
;   HR       [4] - флаг, отряд героя достижим для проверяемого отряда ИИ
;     HERO_REACH_BIT
;   HA       [3] - флаг, отряд героя уже выбирался в текущем круге выбора действующего отряда
;     HERO_ACTED_BIT
;   FL       [2] - флаг, воздушное перемещение, отдельный действующий эффект может дополнительно запретить его
;     UNIT_FLY_BIT
;   SH       [1] - флаг, обычная дальняя атака, исходно копируется из FSoldier.MoveFlags
;     UNIT_SHOT_BIT
;   MA       [0] - флаг, магическое дальнее действие, исходно копируется из FSoldier.MoveFlags
;     UNIT_MAGIC_BIT
; -----------------------------------------
```

### FBattleUnit.Flags, армия ИИ

```asm
; -----------------------------------------
; FBattleUnit.Flags, армия ИИ
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | OC | TX | TC | DN | DF | FL | SH | MA |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   OC       [7] - флаг, численность превышает предел управления, выбирается ветвь неуправляемого отряда
;     UNIT_UNRULE_BIT
;   TX       [6] - флаг, временно исключает запись из повторного выбора цели
;     UNIT_SKIP_BIT
;   TC       [5] - флаг, временная отметка соседа или кандидата при выборе цели
;     UNIT_MARK_BIT
;   DN       [4] - флаг, обработка отряда ИИ в текущем раунде завершена
;     AI_DONE_BIT
;   DF       [3] - флаг, действие отряда ИИ отложено до повторного прохода армии с режимом 3
;     AI_DEFERRED_BIT
;   FL       [2] - флаг, воздушное перемещение, отдельный действующий эффект может дополнительно запретить его
;     UNIT_FLY_BIT
;   SH       [1] - флаг, обычная дальняя атака, исходно копируется из FSoldier.MoveFlags
;     UNIT_SHOT_BIT
;   MA       [0] - флаг, магическое дальнее действие, исходно копируется из FSoldier.MoveFlags
;     UNIT_MAGIC_BIT
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `OC` | `UNIT_UNRULE_BIT` | численность превышает предел управления, выбирается ветвь неуправляемого отряда | [Battle.MarkUnruled](../Source/Battle/MarkUnruled.asm#L25) — `RES UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.MarkUnruled](../Source/Battle/MarkUnruled.asm#L26) — `CALL TestControl`<br>[Battle.MarkUnruled](../Source/Battle/MarkUnruled.asm#L29) — `SET UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.SelectActor](../Source/Battle/SelectActor.asm#L66) — `BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L48) — `BIT UNIT_UNRULE_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L848) — `BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.ResolveLosses](../Source/Battle/ResolveLosses.asm#L79) — `BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.ResolveLosses](../Source/Battle/ResolveLosses.asm#L103) — `BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.ResolveLosses](../Source/Battle/ResolveLosses.asm#L117) — `BIT UNIT_UNRULE_BIT, (IY + FBattleUnit.Flags)` |
| `TX` | `UNIT_SKIP_BIT` | временно исключает запись из повторного выбора цели | [Battle.ChooseTarget](../Source/Battle/ChooseTarget.asm#L33) — `BIT UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L107) — `SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L124) — `SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L458) — `SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L481) — `RES UNIT_SKIP_BIT, (HL)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L261) — `SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L396) — `SET UNIT_SKIP_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L466) — `SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L532) — `SET UNIT_SKIP_BIT, (IX + FBattleUnit.Flags)` |
| `TC` | `UNIT_MARK_BIT` | временная отметка соседа или кандидата при выборе цели | [Battle.MarkAdjacent](../Source/Battle/MarkAdjacent.asm#L20) — `RES UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.MarkAdjacent](../Source/Battle/MarkAdjacent.asm#L45) — `SET UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.ChooseTarget](../Source/Battle/ChooseTarget.asm#L59) — `SET UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.ChooseTarget](../Source/Battle/ChooseTarget.asm#L75) — `BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L217) — `SET UNIT_MARK_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L230) — `BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L277) — `BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L295) — `BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L427) — `BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.ChooseTarget](../Source/Battle/ChooseTarget.asm#L106) — `BIT UNIT_MARK_BIT, (IX + FBattleUnit.Flags)` |
| `HR / DN` | `AI_DONE_BIT`<br>`HERO_REACH_BIT` | у армии ИИ обработка завершена, у армии героя цель достижима по подвижности | [Battle.AIArmyPass](../Source/Battle/AIArmyPass.asm#L27) — `BIT AI_DONE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L173) — `SET AI_DONE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.MarkInRange](../Source/Battle/MarkInRange.asm#L42) — `SET HERO_REACH_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L109) — `SET AI_DONE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L166) — `SET AI_DONE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L216) — `SET AI_DONE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L412) — `SET AI_DONE_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L390) — `BIT HERO_REACH_BIT, (IX + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L29) — `RES HERO_REACH_BIT, (HL)` |
| `HA / DF` | `AI_DEFERRED_BIT`<br>`HERO_ACTED_BIT` | у героя отряд уже выбран в текущем круге, у ИИ отложен до прохода 3 | [Battle.SelectActor](../Source/Battle/SelectActor.asm#L34) — `BIT HERO_ACTED_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.SelectActor](../Source/Battle/SelectActor.asm#L59) — `SET HERO_ACTED_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIArmyPass](../Source/Battle/AIArmyPass.asm#L34) — `BIT AI_DEFERRED_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L22) — `BIT AI_DEFERRED_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L137) — `SET AI_DEFERRED_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.SelectActor](../Source/Battle/SelectActor.asm#L42) — `RES HERO_ACTED_BIT, (IY + FBattleUnit.Flags)` |
| `FL` | `UNIT_FLY_BIT` | воздушное перемещение, отдельный действующий эффект может дополнительно запретить его | [Battle.InputLoop](../Source/Battle/InputLoop.asm#L878) — `BIT UNIT_FLY_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L395) — `CP #04`<br>[Engine.BuildArmy](../Source/Engine/BuildArmy.asm#L100) — `RES UNIT_FLY_BIT, C`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L106) — `BIT UNIT_FLY_BIT, E`<br>[Overlay.TakeOff.Entry](../Source/Overlays/TakeOff.asm#L41) — `BIT UNIT_FLY_BIT, E` |
| `SH` | `UNIT_SHOT_BIT` | обычная дальняя атака, исходно копируется из FSoldier.MoveFlags | [Battle.InputLoop](../Source/Battle/InputLoop.asm#L155) — `AND #03`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L235) — `BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L221) — `RES UNIT_SHOT_BIT, (IY + FBattleUnit.Flags)`<br>[Engine.BuildArmy](../Source/Engine/BuildArmy.asm#L99) — `RES UNIT_SHOT_BIT, C` |
| `MA` | `UNIT_MAGIC_BIT` | магическое дальнее действие, исходно копируется из FSoldier.MoveFlags | [Engine.BuildArmy](../Source/Engine/BuildArmy.asm#L91) — `LD A, (IX + FSoldier.MoveFlags)`<br>[Engine.BuildArmy](../Source/Engine/BuildArmy.asm#L93) — `AND #07`<br>[Engine.BuildArmy](../Source/Engine/BuildArmy.asm#L103) — `LD (IY + FBattleUnit.Flags), C`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L235) — `BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L220) — `RES UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L171) — `BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L215) — `BIT UNIT_MAGIC_BIT, (IY + FBattleUnit.Flags)` |

## FBattleUnit.Effect, смещение +#0D, два числовых поля

[Includes/Structs/BattleUnit.inc](../Includes/Structs/BattleUnit.inc#L81)

EF и TM являются числами из четырёх битов, не независимыми флагами

```asm
; -----------------------------------------
; FBattleUnit.Effect, смещение +#0D, два числовых поля
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | EF | EF | EF | EF | TM | TM | TM | TM |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   EF       [7..4] - поле, номер действующего эффекта, извлекается четырьмя SRL
;   TM       [3..0] - поле, оставшаяся длительность, уменьшается в конце раунда, при 1 очищается весь байт
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `EF` | — | номер действующего эффекта, извлекается четырьмя SRL | [Battle.EffectFactor](../Source/Battle/EffectFactor.asm#L15) — `SRL A`<br>[Battle.EffectFactor](../Source/Battle/EffectFactor.asm#L18) — `SRL A` |
| `TM` | — | оставшаяся длительность, уменьшается в конце раунда, при 1 очищается весь байт | [Battle.TickEffects](../Source/Battle/TickEffects.asm#L19) — `LD A, (IY + FBattleUnit.Effect)`<br>[Battle.TickEffects](../Source/Battle/TickEffects.asm#L35) — `LD (IY + FBattleUnit.Effect), A` |

## FPictureHeader.Flags, смещение +#04

[Includes/Structs/PictureHeader.inc](../Includes/Structs/PictureHeader.inc#L28)

Флаги заголовка копируются в начало распаковщика +5, рабочие RN и AT изменяются во время вывода

Алгоритм одинаков у HERIMG, BL1 и BL2, указанные адреса относятся к BL1 с базой #C000

```asm
; -----------------------------------------
; FPictureHeader.Flags, смещение +#04
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | AT | RN | .. | RO |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   AT       [3] - флаг, в рабочей копии распаковщика идёт линейный вывод атрибутов вместо пиксельных циклов
;     RLE_ATTR_BIT
;   RN       [2] - флаг, в рабочей копии распаковщика продолжается RLE-серия, B' содержит остаток, C' значение
;     RLE_RUN_BIT
;   RO       [0] - флаг, порядок обхода пикселей, 1 внутренними сериями по 32 байта, 0 по одному байту с вертикальным шагом
;     RLE_ROW_BIT
; .. [7, 6, 5, 4, 1] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `AT` | `RLE_ATTR_BIT` | в рабочей копии распаковщика идёт линейный вывод атрибутов вместо пиксельных циклов | [Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L178) — `SET RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L228) — `BIT RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L229) — `JR NZ, .NextLinear`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L175) — `SET RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L225) — `BIT RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L178) — `SET RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L228) — `BIT RLE_ATTR_BIT, (IY + FRleState.Flags)` |
| `RN` | `RLE_RUN_BIT` | в рабочей копии распаковщика продолжается RLE-серия, B' содержит остаток, C' значение | [Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L196) — `BIT RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L208) — `RES RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L226) — `SET RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L193) — `BIT RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L205) — `RES RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L223) — `SET RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L196) — `BIT RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L208) — `RES RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L226) — `SET RLE_RUN_BIT, (IY + FRleState.Flags)` |
| `RO` | `RLE_ROW_BIT` | порядок обхода пикселей, 1 внутренними сериями по 32 байта, 0 по одному байту с вертикальным шагом | [Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L121) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L124) — `LD B, #20`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L135) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L138) — `LD B, #20`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L118) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L132) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L121) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L135) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)` |

## FScreenObject20.Flags, смещение +#00

[Includes/Structs/ScreenObject20.inc](../Includes/Structs/ScreenObject20.inc#L22)

После режимов 1..3 младшие пять битов очищаются, режим 4 сохраняется между тиками

```asm
; -----------------------------------------
; FScreenObject20.Flags, смещение +#00
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | BM | FM | NU | MD | MD | MD | MD | MD |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   BM       [7] - флаг, горизонтально отражать основное изображение в режимах 1, 2, 3 и 4
;   FM       [6] - флаг, горизонтально отражать передний маскированный слой в режимах 3 и 4
;     FRONT_FLIP_BIT
;   NU       [5] - флаг, после выполненного вывода подписать число из массива #6931 + 2*индекс объекта
;     DRAW_NUMBER_BIT
;   MD       [4..0] - поле, режим 0 без вывода, 1 фон с атрибутами, 2 маска, 3 фон и маска, 4 фон и кадры
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `BM` | — | горизонтально отражать основное изображение в режимах 1, 2, 3 и 4 | [Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L36) — `AND #80`<br>[Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L52) — `AND #80`<br>[Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L68) — `AND #80`<br>[Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L105) — `AND #80` |
| `FM` | `FRONT_FLIP_BIT` | горизонтально отражать передний маскированный слой в режимах 3 и 4 | [Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L77) — `AND #40`<br>[Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L123) — `AND #40`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L194) — `SET FRONT_FLIP_BIT, (IX + FScreenObject20.Flags)` |
| `NU` | `DRAW_NUMBER_BIT` | после выполненного вывода подписать число из массива #6931 + 2*индекс объекта | [Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L130) — `BIT DRAW_NUMBER_BIT, (IX + FScreenObject20.Flags)`<br>[Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L150) — `LD HL, State.ViewCounts`<br>[Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L156) — `CALL DrawCountDI` |
| `MD` | — | режим 0 без вывода, 1 фон с атрибутами, 2 маска, 3 фон и маска, 4 фон и кадры | [Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L27) — `AND #1F`<br>[Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L30) — `CP #01`<br>[Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L46) — `CP #02`<br>[Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L62) — `CP #03`<br>[Engine.RenderObjects](../Source/Engine/RenderObjects.asm#L85) — `CP #04` |

## Байт клетки стратегической карты, группа MapConst

[Includes/Const/Map.inc](../Includes/Const/Map.inc#L20)

```asm
; -----------------------------------------
; Байт клетки стратегической карты, группа MapConst
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | OC | MR | ID | ID | ID | ID | ID | ID |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   OC       [7] - флаг, занятость клетки объектом, маска Occupied=#80
;     MAP_BUSY_BIT
;   MR       [6] - флаг, горизонтальное отражение тайла, маска Mirror=#40
;     MAP_MIRROR_BIT
;   ID       [5..0] - поле, индекс графического тайла, маска TileMask=#3F
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `OC` | `MAP_BUSY_BIT` | занятость клетки объектом, маска Occupied=#80 | [Engine.FindMapObject](../Source/Engine/FindMapObject.asm#L45) — `CALL ReadMapCell`<br>[Engine.FindMapObject](../Source/Engine/FindMapObject.asm#L46) — `BIT MAP_BUSY_BIT, A`<br>[Engine.ApplyMoveCode](../Source/Engine/ApplyMoveCode.asm#L95) — `BIT MAP_BUSY_BIT, A`<br>[Engine.FindRecord](../Source/Engine/FindRecord.asm#L20) — `BIT MAP_BUSY_BIT, A`<br>[Engine.Initialize](../Source/Engine/Initialize.asm#L85) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.Initialize](../Source/Engine/Initialize.asm#L94) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.MainLoop](../Source/Engine/MainLoop.asm#L56) — `BIT MAP_BUSY_BIT, A`<br>[Engine.MarkMapCell](../Source/Engine/MarkMapCell.asm#L18) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.MoveSitesC](../Source/Engine/MoveSitesC.asm#L40) — `BIT MAP_BUSY_BIT, A`<br>[Engine.MoveSitesC](../Source/Engine/MoveSitesC.asm#L60) — `BIT MAP_BUSY_BIT, A`<br>[Engine.MoveSitesC](../Source/Engine/MoveSitesC.asm#L70) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.MoveSitesC](../Source/Engine/MoveSitesC.asm#L73) — `RES MAP_BUSY_BIT, (HL)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L199) — `RES MAP_BUSY_BIT, (HL)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L205) — `BIT MAP_BUSY_BIT, A`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L319) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L422) — `RES MAP_BUSY_BIT, (HL)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L428) — `BIT MAP_BUSY_BIT, A`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L464) — `RES MAP_BUSY_BIT, (HL)`<br>[Engine.StepArmies](../Source/Engine/StepArmies.asm#L482) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L167) — `BIT MAP_BUSY_BIT, A`<br>[Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L192) — `RES MAP_BUSY_BIT, (HL)`<br>[Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L203) — `SET MAP_BUSY_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L398) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L126) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Bandits.Entry](../Source/Overlays/Bandits.asm#L201) — `RES MAP_BUSY_BIT, (HL)`<br>[Overlay.Castle.Entry](../Source/Overlays/Castle.asm#L648) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Castle.PlaceAuxTroops](../Source/Overlays/Castle.asm#L788) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Friendly.Entry](../Source/Overlays/Friendly.asm#L43) — `RES MAP_BUSY_BIT, (HL)`<br>[Overlay.Friendly.Entry](../Source/Overlays/Friendly.asm#L55) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Friendly.Entry](../Source/Overlays/Friendly.asm#L61) — `SET MAP_BUSY_BIT, (HL)`<br>[Overlay.Hostile.Entry](../Source/Overlays/Hostile.asm#L43) — `RES MAP_BUSY_BIT, (HL)`<br>[Overlay.Hostile.Entry](../Source/Overlays/Hostile.asm#L63) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Hostile.Entry](../Source/Overlays/Hostile.asm#L69) — `SET MAP_BUSY_BIT, (HL)`<br>[Overlay.Join.Entry](../Source/Overlays/Join.asm#L42) — `RES MAP_BUSY_BIT, (HL)`<br>[Overlay.Land.Entry](../Source/Overlays/Land.asm#L26) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Maps.DrawAerialMap](../Source/Overlays/Maps.asm#L1056) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L156) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L162) — `SET MAP_BUSY_BIT, (HL)`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L180) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L186) — `SET MAP_BUSY_BIT, (HL)`<br>[Overlay.Temple.CheckLanding](../Source/Overlays/Temple.asm#L347) — `BIT MAP_BUSY_BIT, A`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L36) — `RES MAP_BUSY_BIT, (HL)`<br>[Startup.CreateWanderers](../Source/Startup/CreateWanderers.asm#L40) — `BIT MAP_BUSY_BIT, (HL)`<br>[Startup.CreateWanderers](../Source/Startup/CreateWanderers.asm#L47) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.MarkUsedCell](../Source/Startup/MarkUsedCell.asm#L19) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L291) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L551) — `BIT MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L606) — `BIT MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L613) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L649) — `BIT MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L657) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L730) — `BIT MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L738) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L794) — `BIT MAP_BUSY_BIT, A`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L803) — `SET MAP_BUSY_BIT, (HL)`<br>[Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L815) — `BIT MAP_BUSY_BIT, A` |
| `MR` | `MAP_MIRROR_BIT` | горизонтальное отражение тайла, маска Mirror=#40 | [Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L98) — `LD A, (HL)`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L99) — `AND #40`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L100) — `SLA A`<br>[Overlay.Maps.DrawAerialMap](../Source/Overlays/Maps.asm#L1045) — `BIT MAP_MIRROR_BIT, C`<br>[Overlay.TargetMap.Entry](../Source/Overlays/TargetMap.asm#L97) — `BIT MAP_MIRROR_BIT, (HL)` |
| `ID` | — | индекс графического тайла, маска TileMask=#3F | [Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L95) — `LD A, (HL)`<br>[Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L96) — `AND #3F` |

## FTroop.ID, смещение +#00, обычный ID и временные отметки TickTime

[Includes/Structs/Troop.inc](../Includes/Structs/Troop.inc#L22)

Вне указанных промежуточных ветвей поле остаётся обычным идентификатором

Это не набор постоянных свойств типа, постоянные способности лежат в FSoldier

```asm
; -----------------------------------------
; FTroop.ID, смещение +#00, обычный ID и временные отметки TickTime
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | AT | RU | DW | ID | ID | ID | ID | ID |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   AT       [7] - флаг, временная отметка атакующего отряда, также ставится при совпадении секты
;     TROOP_REBEL_BIT
;   RU       [6] - флаг, временная отметка сбежавшего отряда в финансовой ветви
;     TROOP_FLED_BIT
;   DW       [5] - флаг, временная отметка утонувшего отряда в корабельном событии
;     TROOP_DROWN_BIT
;   ID       [4..0] - поле, ID типа существа 1..25, 0 завершает плотный список
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `AT` | `TROOP_REBEL_BIT` | временная отметка атакующего отряда, также ставится при совпадении секты | [Engine.TickTime](../Source/Engine/TickTime.asm#L452) — `CP (IX + FSoldier.SectID)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L455) — `SET TROOP_REBEL_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L518) — `SET TROOP_REBEL_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L562) — `BIT TROOP_REBEL_BIT, (IY + FTroop.ID)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L620) — `BIT TROOP_REBEL_BIT, A` |
| `RU` | `TROOP_FLED_BIT` | временная отметка сбежавшего отряда в финансовой ветви | [Engine.TickTime](../Source/Engine/TickTime.asm#L515) — `BIT UNIT_MUTINY_BIT, D`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L516) — `JR Z, .MarkDesertion`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L521) — `SET TROOP_FLED_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L568) — `BIT TROOP_FLED_BIT, (IY + FTroop.ID)` |
| `DW` | `TROOP_DROWN_BIT` | временная отметка утонувшего отряда в корабельном событии | [Engine.TickTime](../Source/Engine/TickTime.asm#L372) — `BIT UNIT_AFLOAT_BIT, E`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L373) — `JR NZ, .NextFlyUnit`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L375) — `SET TROOP_DROWN_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L556) — `BIT TROOP_DROWN_BIT, (IY + FTroop.ID)` |
| `ID` | — | ID типа существа 1..25, 0 завершает плотный список | [Engine.TickTime](../Source/Engine/TickTime.asm#L513) — `AND #1F`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L547) — `AND #1F` |

## State.EventFlags, адрес #6565

[Includes/Address.inc](../Includes/Address.inc#L41)

```asm
; -----------------------------------------
; State.EventFlags, адрес #6565
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | NE | .. | .. | .. | .. | .. | .. | .. |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   NE       [7] - флаг, 1 временно запрещает развитие отрядов и отдельные события замков, 0 допускает их проверки
;     EVENT_LOCK_BIT
; .. [6, 5, 4, 3, 2, 1, 0] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `NE` | `EVENT_LOCK_BIT` | 1 временно запрещает развитие отрядов и отдельные события замков, 0 допускает их проверки | [Engine.DevelopTroops](../Source/Engine/DevelopTroops.asm#L18) — `BIT EVENT_LOCK_BIT, A`<br>[Engine.DevelopTroops](../Source/Engine/DevelopTroops.asm#L19) — `RET NZ`<br>[Engine.TickCastle](../Source/Engine/TickCastle.asm#L50) — `BIT EVENT_LOCK_BIT, A`<br>[Engine.TickCastle](../Source/Engine/TickCastle.asm#L271) — `BIT EVENT_LOCK_BIT, A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L94) — `SET EVENT_LOCK_BIT, A`<br>[Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L120) — `RES EVENT_LOCK_BIT, A` |

## State.ViewFlags, адрес #6566

[Includes/Address.inc](../Includes/Address.inc#L68)

```asm
; -----------------------------------------
; State.ViewFlags, адрес #6566
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | RU | CU | DG | .. | OB | CS | .. |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   RU       [6] - флаг, 1 включает табличное преобразование ввода в русский алфавит, 0 оставляет обычный код
;     TEXT_RUS_BIT
;   CU       [5] - флаг, 1 включает анимируемый символ текстового курсора в прерывании
;     TEXT_CURSOR_BIT
;   DG       [4] - флаг, 1 ограничивает обычный ввод цифрами 0..9, служебные коды удаления и завершения сохраняются
;     TEXT_DIGIT_BIT
;   OB       [2] - флаг, 1 разрешает обработку экранных объектов из прерывания, 0 запрещает
;     VIEW_RENDER_BIT
;   CS       [1] - флаг, переключение регистра латинских букв, 1 меняет A..Z с a..z местами при вводе
;     TEXT_CASE_BIT
; .. [7, 3, 0] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `RU` | `TEXT_RUS_BIT` | 1 включает табличное преобразование ввода в русский алфавит, 0 оставляет обычный код | [Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L29) — `XOR #40`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L86) — `BIT TEXT_RUS_BIT, (HL)`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L87) — `JR Z, .RestoreRegs`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L93) — `LD HL, Engine.RemapKey.AltPunct - 32`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L96) — `LD HL, Engine.RemapKey.CharTable - 32`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L99) — `LD HL, Engine.RemapKey.CharTable - 32`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L59) — `BIT TEXT_RUS_BIT, (HL)`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L85) — `BIT TEXT_RUS_BIT, (HL)` |
| `CU` | `TEXT_CURSOR_BIT` | 1 включает анимируемый символ текстового курсора в прерывании | [Engine.EditText](../Source/Engine/EditText.asm#L22) — `SET TEXT_CURSOR_BIT, A`<br>[Engine.EditText](../Source/Engine/EditText.asm#L33) — `RES TEXT_CURSOR_BIT, (IX + State.ViewFlags - State.EventFlags)`<br>[Engine.Interrupt](../Source/Engine/Interrupt.asm#L41) — `BIT TEXT_CURSOR_BIT, A`<br>[Startup.EditText](../Source/Startup/EditText.asm#L25) — `SET TEXT_CURSOR_BIT, A`<br>[Startup.EditText](../Source/Startup/EditText.asm#L35) — `RES TEXT_CURSOR_BIT, (IX + .FlagsOfs)`<br>[Startup.Interrupt](../Source/Startup/Interrupt.asm#L37) — `BIT TEXT_CURSOR_BIT, A` |
| `DG` | `TEXT_DIGIT_BIT` | 1 ограничивает обычный ввод цифрами 0..9, служебные коды удаления и завершения сохраняются | [Engine.EditNumber](../Source/Engine/EditNumber.asm#L17) — `SET TEXT_DIGIT_BIT, A`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L53) — `BIT TEXT_DIGIT_BIT, (HL)`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L56) — `CP #30`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L59) — `CP #3A`<br>[Overlay.Castle.Entry](../Source/Overlays/Castle.asm#L295) — `RES TEXT_DIGIT_BIT, A`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L42) — `BIT TEXT_DIGIT_BIT, (HL)`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L56) — `BIT TEXT_DIGIT_BIT, (HL)`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L69) — `BIT TEXT_DIGIT_BIT, (HL)` |
| `OB` | `VIEW_RENDER_BIT` | 1 разрешает обработку экранных объектов из прерывания, 0 запрещает | [Engine.Interrupt](../Source/Engine/Interrupt.asm#L66) — `BIT VIEW_RENDER_BIT, A`<br>[Engine.StartView](../Source/Engine/StartView.asm#L14) — `SET VIEW_RENDER_BIT, A`<br>[Engine.StopView](../Source/Engine/StopView.asm#L14) — `RES VIEW_RENDER_BIT, A` |
| `CS` | `TEXT_CASE_BIT` | переключение регистра латинских букв, 1 меняет A..Z с a..z местами при вводе | [Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L37) — `XOR #02`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L65) — `BIT TEXT_CASE_BIT, (HL)`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L74) — `SUB #20`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L83) — `ADD A, #20`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L92) — `BIT TEXT_CASE_BIT, (HL)` |

## FMenuArea.XAndActive, смещение +#00

[Includes/Structs/MenuArea.inc](../Includes/Structs/MenuArea.inc#L20)

Значение #FF целиком завершает список и проверяется раньше флага AC

```asm
; -----------------------------------------
; FMenuArea.XAndActive, смещение +#00
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | AC | X  | X  | X  | X  | X  | X  | X  |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   AC       [7] - флаг, 1 область подсвечена обменом INK и PAPER, 0 подсветка снята
;     MENU_ACTIVE_BIT
;   X        [6..0] - поле, столбец начала области в знакоместах
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `AC` | `MENU_ACTIVE_BIT` | 1 область подсвечена обменом INK и PAPER, 0 подсветка снята | [Loader.Menu.HighlightAreas](../Source/Loader/Menu/HighlightAreas.asm#L17)<br>[Loader.Menu.PollMenu](../Source/Loader/Menu/PollMenu.asm#L17)<br>[Loader.Menu.HighlightAreas](../Source/Loader/Menu/HighlightAreas.asm#L41) — `SET MENU_ACTIVE_BIT, (IX + FMenuArea.XAndActive)`<br>[Loader.Menu.HighlightAreas](../Source/Loader/Menu/HighlightAreas.asm#L60) — `RES MENU_ACTIVE_BIT, (IX + FMenuArea.XAndActive)`<br>[Loader.Menu.PollMenu](../Source/Loader/Menu/PollMenu.asm#L76) — `RES MENU_ACTIVE_BIT, (HL)` |
| `X` | — | столбец начала области в знакоместах | [Loader.Menu.HighlightAreas](../Source/Loader/Menu/HighlightAreas.asm#L17)<br>[Loader.Menu.PollMenu](../Source/Loader/Menu/PollMenu.asm#L17) |

## FSampleStep.ToneAndVolume, смещение +#00

[Includes/Structs/SampleStep.inc](../Includes/Structs/SampleStep.inc#L19)

Младший байт смещения хранится отдельно в FSampleStep.ToneLow

```asm
; -----------------------------------------
; FSampleStep.ToneAndVolume, смещение +#00
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | TH | TH | TH | TH | VL | VL | VL | VL |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   TH       [7..4] - поле, старшая тетрада величины смещения периода тона
;   VL       [3..0] - поле, громкость канала 0..15
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `TH` | — | старшая тетрада величины смещения периода тона | [Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L208) |
| `VL` | — | громкость канала 0..15 | [Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L208) |

## FSampleStep.NoiseAndFlags, смещение +#01

[Includes/Structs/SampleStep.inc](../Includes/Structs/SampleStep.inc#L37)

```asm
; -----------------------------------------
; FSampleStep.NoiseAndFlags, смещение +#01
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | ND | TD | PL | NS | NS | NS | NS | NS |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   ND       [7] - флаг, 1 отключает шум канала
;     SMP_MUTE_N_BIT
;   TD       [6] - флаг, 1 отключает тон канала
;     SMP_MUTE_T_BIT
;   PL       [5] - флаг, 1 прибавляет смещение к периоду ноты, 0 вычитает его
;     SMP_ADD_BIT
;   NS       [4..0] - поле, период шума AY 0..31
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `ND` | `SMP_MUTE_N_BIT` | 1 отключает шум канала | [Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L208)<br>[Music.Menu.CalcTonePeriod](../Source/Loader/Music.asm#L690)<br>[Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L215) — `BIT SMP_MUTE_N_BIT, A` |
| `TD` | `SMP_MUTE_T_BIT` | 1 отключает тон канала | [Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L208)<br>[Music.Menu.CalcTonePeriod](../Source/Loader/Music.asm#L690)<br>[Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L223) — `BIT SMP_MUTE_T_BIT, A` |
| `PL` | `SMP_ADD_BIT` | 1 прибавляет смещение к периоду ноты, 0 вычитает его | [Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L208)<br>[Music.Menu.CalcTonePeriod](../Source/Loader/Music.asm#L690)<br>[Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L242) — `BIT SMP_ADD_BIT, (IX + FSampleStep.NoiseAndFlags)` |
| `NS` | — | период шума AY 0..31 | [Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L208)<br>[Music.Menu.CalcTonePeriod](../Source/Loader/Music.asm#L690) |

## FRleState.Flags, смещение +#03

[Includes/Structs/RleState.inc](../Includes/Structs/RleState.inc#L27)

RN меняется внутри распаковщика, AT устанавливается после завершения пикселей

```asm
; -----------------------------------------
; FRleState.Flags, смещение +#03
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | AT | RN | .. | HR |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   AT       [3] - флаг, 1 декодирует линейные атрибуты, 0 пиксели с нелинейным экранным шагом
;     RLE_ATTR_BIT
;   RN       [2] - флаг, 1 продолжает ранее начатую RLE-серию из альтернативных B и C
;     RLE_RUN_BIT
;   HR       [0] - флаг, 1 поток идёт горизонтальными строками, 0 вертикальными блоками
;     RLE_ROW_BIT
; .. [7, 6, 5, 4, 1] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `AT` | `RLE_ATTR_BIT` | 1 декодирует линейные атрибуты, 0 пиксели с нелинейным экранным шагом | [Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L41)<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L44)<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L44)<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L175) — `SET RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L225) — `BIT RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L178) — `SET RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L228) — `BIT RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L178) — `SET RLE_ATTR_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L228) — `BIT RLE_ATTR_BIT, (IY + FRleState.Flags)` |
| `RN` | `RLE_RUN_BIT` | 1 продолжает ранее начатую RLE-серию из альтернативных B и C | [Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L41)<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L44)<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L44)<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L193) — `BIT RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L205) — `RES RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L223) — `SET RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L196) — `BIT RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L208) — `RES RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L226) — `SET RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L196) — `BIT RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L208) — `RES RLE_RUN_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L226) — `SET RLE_RUN_BIT, (IY + FRleState.Flags)` |
| `HR` | `RLE_ROW_BIT` | 1 поток идёт горизонтальными строками, 0 вертикальными блоками | [Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L41)<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L44)<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L44)<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L118) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Heroes.Unpack](../Source/Files/08_HERIMG.asm#L132) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L121) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes1.Unpack](../Source/Files/33_BL1.asm#L135) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L121) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)`<br>[Graphics.Scenes2.Unpack](../Source/Files/34_BL2.asm#L135) — `BIT RLE_ROW_BIT, (IY + FRleState.Flags)` |

## FMapSite.Flags, смещение +#00

[Includes/Structs/MapSite.inc](../Includes/Structs/MapSite.inc#L19)

Это общий префикс разных записей, остальные биты зависят от конкретного типа

```asm
; -----------------------------------------
; FMapSite.Flags, смещение +#00
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | .. | NO |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   NO       [0] - флаг, 1 запись выключена из общего обхода карты
;     SITE_OFF_BIT
; .. [7, 6, 5, 4, 3, 2, 1] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `NO` | `SITE_OFF_BIT` | 1 запись выключена из общего обхода карты | [Overlay.Maps.MarkSiteList](../Source/Overlays/Maps.asm#L856)<br>[Engine.FindRecord](../Source/Engine/FindRecord.asm#L44) — `BIT SITE_OFF_BIT, (IX + FMapSite.Flags)`<br>[Engine.MarkObjectGroup](../Source/Engine/MarkObjectGroup.asm#L31) — `BIT SITE_OFF_BIT, (IY + FMapSite.Flags)`<br>[Engine.NearestObject](../Source/Engine/NearestObject.asm#L44) — `BIT SITE_OFF_BIT, (IX + FMapSite.Flags)`<br>[Engine.PlaceCells](../Source/Engine/PlaceCells.asm#L27) — `BIT SITE_OFF_BIT, (IX + FMapSite.Flags)`<br>[Engine.PlaceGroup](../Source/Engine/PlaceGroup.asm#L32) — `BIT SITE_OFF_BIT, (IX + FMapSite.Flags)`<br>[Overlay.Maps.MarkSiteList](../Source/Overlays/Maps.asm#L871) — `BIT SITE_OFF_BIT, (IX + FMapSite.Flags)` |

## FExpense.Flags, смещение +#00

[Includes/Structs/Expense.inc](../Includes/Structs/Expense.inc#L22)

До подтверждения выбора PY ещё не означает фактического списания денег

```asm
; -----------------------------------------
; FExpense.Flags, смещение +#00
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | PY | AC | .. | RW | RW | RW | RW | RW |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   PY       [7] - флаг, 1 статья выбрана для оплаты и включается в SumExpenses
;     EXP_PAY_BIT
;   AC       [6] - флаг, 1 статья существует и показана в текущем недельном расчёте
;     EXP_ACTIVE_BIT
;   RW       [4..0] - поле, строка показа статьи и её прямоугольника выбора
; .. [5] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `PY` | `EXP_PAY_BIT` | 1 статья выбрана для оплаты и включается в SumExpenses | [Engine.TickTime](../Source/Engine/TickTime.asm#L18)<br>[Engine.SumExpenses](../Source/Engine/SumExpenses.asm#L15)<br>[Engine.SumExpenses](../Source/Engine/SumExpenses.asm#L19) — `BIT EXP_PAY_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L104) — `RES EXP_PAY_BIT, (IX + FExpense.Flags)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L323) — `BIT EXP_PAY_BIT, A`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L510) — `BIT EXP_PAY_BIT, (IY + FExpense.Flags)` |
| `AC` | `EXP_ACTIVE_BIT` | 1 статья существует и показана в текущем недельном расчёте | [Engine.TickTime](../Source/Engine/TickTime.asm#L18)<br>[Engine.SumExpenses](../Source/Engine/SumExpenses.asm#L15)<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L105) — `RES EXP_ACTIVE_BIT, (IX + FExpense.Flags)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L151) — `SET EXP_ACTIVE_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L175) — `SET EXP_ACTIVE_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L197) — `SET EXP_ACTIVE_BIT, (HL)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L216) — `BIT EXP_ACTIVE_BIT, (IX + FExpense.Flags)`<br>[Engine.TickTime](../Source/Engine/TickTime.asm#L253) — `BIT EXP_ACTIVE_BIT, (IX + FExpense.Flags)` |
| `RW` | — | строка показа статьи и её прямоугольника выбора | [Engine.TickTime](../Source/Engine/TickTime.asm#L18)<br>[Engine.SumExpenses](../Source/Engine/SumExpenses.asm#L15) |

## FBattleTarget.Side, смещение +#00

[Includes/Structs/BattleTarget.inc](../Includes/Structs/BattleTarget.inc#L21)

```asm
; -----------------------------------------
; FBattleTarget.Side, смещение +#00
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | TX | SD | SD | SD | SD | SD | SD | SD |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   TX       [7] - флаг, 1 эта цель уже проверена и исключена из очередных попыток полёта
;     TARGET_SKIP_BIT
;   SD       [6..0] - поле, 2 отряд героя, 3 отряд противника
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `TX` | `TARGET_SKIP_BIT` | 1 эта цель уже проверена и исключена из очередных попыток полёта | [Battle.ListOtherUnits](../Source/Battle/ListOtherUnits.asm#L13)<br>[Battle.RandomTarget](../Source/Battle/RandomTarget.asm#L12)<br>[Battle.RunUncontrolled](../Source/Battle/RunUncontrolled.asm#L16)<br>[Battle.RunUncontrolled](../Source/Battle/RunUncontrolled.asm#L147) — `BIT TARGET_SKIP_BIT, (IX + FBattleTarget.Side)`<br>[Battle.RunUncontrolled](../Source/Battle/RunUncontrolled.asm#L159) — `BIT TARGET_SKIP_BIT, A`<br>[Battle.RunUncontrolled](../Source/Battle/RunUncontrolled.asm#L179) — `SET TARGET_SKIP_BIT, (HL)` |
| `SD` | — | 2 отряд героя, 3 отряд противника | [Battle.ListOtherUnits](../Source/Battle/ListOtherUnits.asm#L13)<br>[Battle.RandomTarget](../Source/Battle/RandomTarget.asm#L12)<br>[Battle.RunUncontrolled](../Source/Battle/RunUncontrolled.asm#L16) |

## Startup.Interrupt.EditFlags, первый байт

[Source/Startup/Interrupt.asm](../Source/Startup/Interrupt.asm#L105)

```asm
; -----------------------------------------
; Startup.Interrupt.EditFlags, первый байт
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | RU | CU | DG | .. | .. | .. | .. |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   RU       [6] - флаг, 1 включает перекодировку вводимых символов в русский алфавит
;     TEXT_RUS_BIT
;   CU       [5] - флаг, 1 прерывание рисует мигающий символ текстового курсора
;     TEXT_CURSOR_BIT
;   DG       [4] - флаг, 1 разрешает цифры и служебные коды, запрещает буквы и пробел
;     TEXT_DIGIT_BIT
; .. [7, 3, 2, 1, 0] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `RU` | `TEXT_RUS_BIT` | 1 включает перекодировку вводимых символов в русский алфавит | [Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L16)<br>[Startup.EditText](../Source/Startup/EditText.asm#L18)<br>[Startup.Interrupt](../Source/Startup/Interrupt.asm#L16)<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L86) — `BIT TEXT_RUS_BIT, (HL)`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L59) — `BIT TEXT_RUS_BIT, (HL)`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L85) — `BIT TEXT_RUS_BIT, (HL)` |
| `CU` | `TEXT_CURSOR_BIT` | 1 прерывание рисует мигающий символ текстового курсора | [Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L16)<br>[Startup.EditText](../Source/Startup/EditText.asm#L18)<br>[Startup.Interrupt](../Source/Startup/Interrupt.asm#L16)<br>[Engine.EditText](../Source/Engine/EditText.asm#L22) — `SET TEXT_CURSOR_BIT, A`<br>[Engine.EditText](../Source/Engine/EditText.asm#L33) — `RES TEXT_CURSOR_BIT, (IX + State.ViewFlags - State.EventFlags)`<br>[Engine.Interrupt](../Source/Engine/Interrupt.asm#L41) — `BIT TEXT_CURSOR_BIT, A`<br>[Startup.EditText](../Source/Startup/EditText.asm#L25) — `SET TEXT_CURSOR_BIT, A`<br>[Startup.EditText](../Source/Startup/EditText.asm#L35) — `RES TEXT_CURSOR_BIT, (IX + .FlagsOfs)`<br>[Startup.Interrupt](../Source/Startup/Interrupt.asm#L37) — `BIT TEXT_CURSOR_BIT, A` |
| `DG` | `TEXT_DIGIT_BIT` | 1 разрешает цифры и служебные коды, запрещает буквы и пробел | [Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L16)<br>[Startup.EditText](../Source/Startup/EditText.asm#L18)<br>[Startup.Interrupt](../Source/Startup/Interrupt.asm#L16)<br>[Engine.EditNumber](../Source/Engine/EditNumber.asm#L17) — `SET TEXT_DIGIT_BIT, A`<br>[Engine.ReadTextChar](../Source/Engine/ReadTextChar.asm#L53) — `BIT TEXT_DIGIT_BIT, (HL)`<br>[Overlay.Castle.Entry](../Source/Overlays/Castle.asm#L295) — `RES TEXT_DIGIT_BIT, A`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L42) — `BIT TEXT_DIGIT_BIT, (HL)`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L56) — `BIT TEXT_DIGIT_BIT, (HL)`<br>[Startup.ReadEditChar](../Source/Startup/ReadEditChar.asm#L69) — `BIT TEXT_DIGIT_BIT, (HL)` |

## Loader.Menu.MenuState.SoundFlags

[Source/Loader/Menu/TickCursor.asm](../Source/Loader/Menu/TickCursor.asm#L51)

```asm
; -----------------------------------------
; Loader.Menu.MenuState.SoundFlags
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | .. | SN |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   SN       [0] - флаг, 1 разрешает биперные эффекты, 0 Beep сразу возвращается
; .. [7, 6, 5, 4, 3, 2, 1] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `SN` | — | 1 разрешает биперные эффекты, 0 Beep сразу возвращается | [Loader.Menu.Beep](../Source/Loader/Menu/Beep.asm#L16) |

## Battle.FinishField.Flags

[Source/Battle/FinishField.asm](../Source/Battle/FinishField.asm#L49)

SPELL_USED_BIT отмечает использованную попытку, флаг ставится до проверки достаточности маны

```asm
; -----------------------------------------
; Battle.FinishField.Flags
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | SM | EW | HW |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   SM       [2] - флаг, попытка магии героя уже использована в текущем раунде
;     SPELL_USED_BIT
;   EW       [1] - флаг, армия противника защищена магическим щитом
;     ENEMY_WARD_BIT
;   HW       [0] - флаг, армия героя защищена магическим щитом
;     HERO_WARD_BIT
; .. [7, 6, 5, 4, 3] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `SM` | `SPELL_USED_BIT` | попытка магии героя уже использована в текущем раунде | [Battle.Battle](../Source/Battle/Battle.asm#L26) — `RES SPELL_USED_BIT, A`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L281) — `BIT SPELL_USED_BIT, A`<br>[Battle.SpendHeroMagic](../Source/Battle/SpendHeroMagic.asm#L14) — `SET SPELL_USED_BIT, A` |
| `EW` | `ENEMY_WARD_BIT` | армия противника защищена магическим щитом | [Battle.AISpell](../Source/Battle/AISpell.asm#L90) — `BIT ENEMY_WARD_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L362) — `SET ENEMY_WARD_BIT, A`<br>[Battle.Battle](../Source/Battle/Battle.asm#L47) — `BIT ENEMY_WARD_BIT, A`<br>[Battle.Battle](../Source/Battle/Battle.asm#L56) — `RES ENEMY_WARD_BIT, A`<br>[Battle.HasMagicShield](../Source/Battle/HasMagicShield.asm#L25) — `BIT ENEMY_WARD_BIT, A`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L317) — `BIT ENEMY_WARD_BIT, A` |
| `HW` | `HERO_WARD_BIT` | армия героя защищена магическим щитом | [Battle.AISpell](../Source/Battle/AISpell.asm#L80) — `BIT HERO_WARD_BIT, A`<br>[Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L180) — `BIT HERO_WARD_BIT, A`<br>[Battle.Battle](../Source/Battle/Battle.asm#L35) — `BIT HERO_WARD_BIT, A`<br>[Battle.Battle](../Source/Battle/Battle.asm#L44) — `RES HERO_WARD_BIT, A`<br>[Battle.HasMagicShield](../Source/Battle/HasMagicShield.asm#L28) — `BIT HERO_WARD_BIT, A`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L471) — `BIT HERO_WARD_BIT, A` |

## Battle.AnimatePath.TurnMode

[Source/Battle/AnimatePath.asm](../Source/Battle/AnimatePath.asm#L69)

Штатные режимы задаются значениями 0 и 3, каждый бит проверяется своим потребителем

```asm
; -----------------------------------------
; Battle.AnimatePath.TurnMode
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | NW | RP |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   NW       [1] - флаг, повторный проход ИИ запрещает снова откладывать отряд за своим соседом
;     AI_NO_WAIT_BIT
;   RP       [0] - флаг, режим отложенного прохода ИИ требует отметки AI_DEFERRED_BIT
;     AI_REPEAT_BIT
; .. [7, 6, 5, 4, 3, 2] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `NW` | `AI_NO_WAIT_BIT` | повторный проход ИИ запрещает снова откладывать отряд за своим соседом | [Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L123) — `BIT AI_NO_WAIT_BIT, A` |
| `RP` | `AI_REPEAT_BIT` | режим отложенного прохода ИИ требует отметки AI_DEFERRED_BIT | [Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L19) — `BIT AI_REPEAT_BIT, A` |

## Battle.SpendAIMagic, байт исключения заклинания

[Source/Battle/SpendAIMagic.asm](../Source/Battle/SpendAIMagic.asm#L62)

Схема применяется к каждому байту NoFreeze..NoSubjugate

```asm
; -----------------------------------------
; Battle.SpendAIMagic, байт исключения заклинания
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | .. | BL |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   BL       [0] - флаг, это заклинание исключено из выбора ИИ в текущей попытке
;     SPELL_BLOCK_BIT
; .. [7, 6, 5, 4, 3, 2, 1] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `BL` | `SPELL_BLOCK_BIT` | это заклинание исключено из выбора ИИ в текущей попытке | [Battle.AISpell](../Source/Battle/AISpell.asm#L41) — `SET SPELL_BLOCK_BIT, (IY)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L137) — `BIT SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L145) — `BIT SPELL_BLOCK_BIT, (HL)`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L154) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L206) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L295) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L353) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L407) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L430) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L477) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L505) — `SET SPELL_BLOCK_BIT, A`<br>[Battle.AISpell](../Source/Battle/AISpell.asm#L559) — `SET SPELL_BLOCK_BIT, (HL)` |

## Overlay.Maps.WaitMapKey.ViewModes

[Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L1151)

```asm
; -----------------------------------------
; Overlay.Maps.WaitMapKey.ViewModes
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | AV | WM |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   AV       [1] - флаг, в меню доступен вид с высоты, в армии найден летающий тип
;     VIEW_AIR_BIT
;   WM       [0] - флаг, в меню доступна полная карта текущего континента
;     VIEW_WORLD_BIT
; .. [7, 6, 5, 4, 3, 2] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `AV` | `VIEW_AIR_BIT` | в меню доступен вид с высоты, в армии найден летающий тип | [Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L125) — `SET VIEW_AIR_BIT, A`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L132) — `BIT VIEW_AIR_BIT, A`<br>[Overlay.Maps.DrawWorldMap](../Source/Overlays/Maps.asm#L657) — `BIT VIEW_AIR_BIT, A` |
| `WM` | `VIEW_WORLD_BIT` | в меню доступна полная карта текущего континента | [Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L142) — `BIT VIEW_WORLD_BIT, A`<br>[Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L172) — `BIT VIEW_WORLD_BIT, A`<br>[Overlay.Maps.DrawWorldMap](../Source/Overlays/Maps.asm#L648) — `BIT VIEW_WORLD_BIT, A` |

## Loader.Menu.MenuState.KeyMask, нормализованный ввод

[Source/Loader/Menu/TickCursor.asm](../Source/Loader/Menu/TickCursor.asm#L83)

```asm
; -----------------------------------------
; Loader.Menu.MenuState.KeyMask, нормализованный ввод
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | LT | RT | UP | DN | OK |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   LT       [4] - флаг, движение влево
;     MENU_LEFT_BIT
;   RT       [3] - флаг, движение вправо
;     MENU_RIGHT_BIT
;   UP       [2] - флаг, движение вверх
;     MENU_UP_BIT
;   DN       [1] - флаг, движение вниз
;     MENU_DOWN_BIT
;   OK       [0] - флаг, действие или завершение выбора
;     MENU_FIRE_BIT
; .. [7, 6, 5] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `LT` | `MENU_LEFT_BIT` | движение влево | [Loader.Menu.EditUnits](../Source/Loader/Menu/EditUnits.asm#L175) — `BIT MENU_LEFT_BIT, A`<br>[Loader.Menu.MoveCursor](../Source/Loader/Menu/MoveCursor.asm#L50) — `BIT MENU_LEFT_BIT, C` |
| `RT` | `MENU_RIGHT_BIT` | движение вправо | [Loader.Menu.EditUnits](../Source/Loader/Menu/EditUnits.asm#L179) — `BIT MENU_RIGHT_BIT, A`<br>[Loader.Menu.MoveCursor](../Source/Loader/Menu/MoveCursor.asm#L59) — `BIT MENU_RIGHT_BIT, C` |
| `UP` | `MENU_UP_BIT` | движение вверх | [Loader.Menu.EditUnits](../Source/Loader/Menu/EditUnits.asm#L183) — `BIT MENU_UP_BIT, A`<br>[Loader.Menu.MoveCursor](../Source/Loader/Menu/MoveCursor.asm#L71) — `BIT MENU_UP_BIT, C` |
| `DN` | `MENU_DOWN_BIT` | движение вниз | [Loader.Menu.MoveCursor](../Source/Loader/Menu/MoveCursor.asm#L80) — `BIT MENU_DOWN_BIT, C` |
| `OK` | `MENU_FIRE_BIT` | действие или завершение выбора | [Loader.Menu.EditUnits](../Source/Loader/Menu/EditUnits.asm#L162) — `BIT MENU_FIRE_BIT, A`<br>[Loader.Menu.ShowHelp](../Source/Loader/Menu/ShowHelp.asm#L63) — `BIT MENU_FIRE_BIT, A`<br>[Loader.Menu.WaitPress](../Source/Loader/Menu/WaitPress.asm#L16) — `BIT MENU_FIRE_BIT, C`<br>[Loader.Menu.WaitRelease](../Source/Loader/Menu/WaitRelease.asm#L15) — `BIT MENU_FIRE_BIT, C` |

## State.DefenseSpell

[Includes/Const/Runtime.inc](../Includes/Const/Runtime.inc#L56)

```asm
; -----------------------------------------
; State.DefenseSpell
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | .. | CK |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   CK       [0] - флаг, разрешает предложить магическое вмешательство героя в защиту замка
;     DEFENSE_OK_BIT
; .. [7, 6, 5, 4, 3, 2, 1] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `CK` | `DEFENSE_OK_BIT` | разрешает предложить магическое вмешательство героя в защиту замка | [Engine.TickCastle](../Source/Engine/TickCastle.asm#L267) — `BIT DEFENSE_OK_BIT, A` |

## Battle.FinishField.FieldKind

[Source/Battle/FinishField.asm](../Source/Battle/FinishField.asm#L19)

Показаны только подтверждённые этой разметкой биты, остальные не считаются свободными

```asm
; -----------------------------------------
; Battle.FinishField.FieldKind
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | SP | .. | .. | .. | .. | .. | .. | .. |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   SP       [7] - флаг, особый режим боя с готовой маской поля и создаваемой армией противника
;     FIELD_SPEC_BIT
; .. [6, 5, 4, 3, 2, 1, 0] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `SP` | `FIELD_SPEC_BIT` | флаг, особый режим боя с готовой маской поля и создаваемой армией противника | [Battle.BuildField](../Source/Battle/BuildField.asm#L23) — `BIT FIELD_SPEC_BIT, A`<br>[Battle.InitBattle](../Source/Battle/InitBattle.asm#L28) — `BIT FIELD_SPEC_BIT, A` |

## BattleTile.IndexAndFlags

Показаны только подтверждённые этой разметкой биты, остальные не считаются свободными

```asm
; -----------------------------------------
; BattleTile.IndexAndFlags
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | MR | .. | .. | .. | .. | .. | .. | .. |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   MR       [7] - флаг, горизонтальное отражение фонового тайла, переносится в Flags экранного объекта
;     TILE_MIRROR_BIT
; .. [6, 5, 4, 3, 2, 1, 0] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `MR` | `TILE_MIRROR_BIT` | флаг, горизонтальное отражение фонового тайла, переносится в Flags экранного объекта | [Battle.MakeFieldTiles](../Source/Battle/MakeFieldTiles.asm#L26) — `RES TILE_MIRROR_BIT, B` |

## Screen.Attributes

Показаны только подтверждённые этой разметкой биты, остальные не считаются свободными

```asm
; -----------------------------------------
; Screen.Attributes
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | FL | .. | .. | .. | .. | .. | .. | .. |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   FL       [7] - флаг, атрибут знакоместа мигает, используется для отметки героя в виде с высоты
;     ATTR_FLASH_BIT
; .. [6, 5, 4, 3, 2, 1, 0] - в этой схеме не описаны и не считаются свободными
; -----------------------------------------
```

| поле | именованные позиции | смысл | потребители и свидетельства |
| --- | --- | --- | --- |
| `FL` | `ATTR_FLASH_BIT` | флаг, атрибут знакоместа мигает, используется для отметки героя в виде с высоты | [Overlay.Maps.DrawAerialMap](../Source/Overlays/Maps.asm#L1110) — `SET ATTR_FLASH_BIT, (HL)` |

## Флаги параметров, портов и регистров

Эти константы описывают интерфейс процедуры или аппаратный регистр. Они не объявляют новую переменную и не являются дополнительными полями структур. Например, бит `CUR_RESTORE_BIT` выбирает направление копирования в параметре C, а `SLIDE_ADD_BIT` передаёт знак смещения периода внутри D.

| позиция | носитель | назначение | потребители |
| --- | --- | --- | --- |
| `AY_ENVELOPE_BIT` | буфер регистра амплитуды AY, (HL) | флаг, регистр амплитуды канала AY использует аппаратную огибающую | [Music.Menu.ApplyEnvelope](../Source/Loader/Music.asm#L581) — `SET AY_ENVELOPE_BIT, (HL)` |
| `CUR_RESTORE_BIT` | Loader.Menu.CursorBackdrop, входной C | флаг, восстановить фон курсора из буфера, при 0 сохранить экранный фон в буфер | [Loader.Menu.CursorBackdrop](../Source/Loader/Menu/CursorBackdrop.asm#L57) — `BIT CUR_RESTORE_BIT, C`<br>[Loader.Menu.CursorBackdrop](../Source/Loader/Menu/CursorBackdrop.asm#L66) — `BIT CUR_RESTORE_BIT, C` |
| `JOY_FIRE_BIT` | Kempston port #1F, KempstonPort | флаг, кнопка действия Kempston нажата | [Engine.ReadInput](../Source/Engine/ReadInput.asm#L34) — `BIT JOY_FIRE_BIT, A`<br>[Engine.WaitMenuInput](../Source/Engine/WaitMenuInput.asm#L23) — `BIT JOY_FIRE_BIT, A`<br>[Startup.ReadMenuInput](../Source/Startup/ReadMenuInput.asm#L25) — `BIT JOY_FIRE_BIT, A` |
| `SLIDE_ADD_BIT` | Music.Menu.ReadSampleStep/CalcTonePeriod, D | флаг, упакованное смещение периода в D положительное, снимается перед ADD HL,DE | [Music.Menu.ReadSampleStep](../Source/Loader/Music.asm#L245) — `SET SLIDE_ADD_BIT, D`<br>[Music.Menu.CalcTonePeriod](../Source/Loader/Music.asm#L713) — `BIT SLIDE_ADD_BIT, D`<br>[Music.Menu.CalcTonePeriod](../Source/Loader/Music.asm#L716) — `RES SLIDE_ADD_BIT, D` |

## Числовые и адресные разряды

В этих операциях проверяется часть числа, адреса или графического байта. Маски самостоятельных флагов для них не вводятся. Имя объясняет роль разряда в вычислении.

| позиция | вид | назначение | потребители |
| --- | --- | --- | --- |
| `BAR_FILL_BIT` | разряд числового или графического значения | позиция левого пикселя, заполняемого при построении частичного деления шкалы маны | [Battle.InputLoop](../Source/Battle/InputLoop.asm#L365) — `SET BAR_FILL_BIT, A` |
| `BEEP_WRAP_BIT` | разряд адреса | разряд старшего байта указателя генератора бипера, сброс удерживает адрес последовательности в диапазоне первых 8 Кбайт при исходном нулевом указателе | [Loader.Menu.RandomByte](../Source/Loader/Menu/RandomByte.asm#L17) — `RES BEEP_WRAP_BIT, H` |
| `COL_ODD_BIT` | разряд числового или графического значения | младший разряд столбца миникарты, нечётный столбец требует перестановки полубайтов узора | [Overlay.Maps.XorMiniTile](../Source/Overlays/Maps.asm#L470) — `BIT COL_ODD_BIT, C` |
| `DELTA_NEG_BIT` | разряд числового или графического значения | знак отрицательной однобайтовой разности координат | [Engine.GetDirection](../Source/Engine/GetDirection.asm#L35) — `BIT DELTA_NEG_BIT, A`<br>[Engine.GetDirection](../Source/Engine/GetDirection.asm#L45) — `BIT DELTA_NEG_BIT, A`<br>[Engine.GetDirection](../Source/Engine/GetDirection.asm#L71) — `BIT DELTA_NEG_BIT, (IX + FPosition.X)`<br>[Engine.GetDirection](../Source/Engine/GetDirection.asm#L82) — `BIT DELTA_NEG_BIT, (IX + FPosition.X)`<br>[Engine.GetDirection](../Source/Engine/GetDirection.asm#L85) — `BIT DELTA_NEG_BIT, (IX + FPosition.Y)`<br>[Engine.GetDirection](../Source/Engine/GetDirection.asm#L91) — `BIT DELTA_NEG_BIT, (IX + FPosition.Y)`<br>[Engine.GetDirection](../Source/Engine/GetDirection.asm#L101) — `BIT DELTA_NEG_BIT, (IX + FPosition.Y)` |
| `FILE_MISS_BIT` | разряд числового или графического значения | позиция бита результата поиска TR-DOS, C=#FF означает отсутствие файла, при находке C содержит номер 0..127 | [Startup.PromptGameDisk](../Source/Startup/PromptGameDisk.asm#L154) — `BIT FILE_MISS_BIT, C` |
| `FLOAT_SIGN_BIT` | разряд числового или графического значения | позиция знака в байте мантиссы пятибайтового числа ROM | [Battle.TestDeadStack](../Source/Battle/TestDeadStack.asm#L13) — `BIT FLOAT_SIGN_BIT, (IX + FBattleUnit.Quantity + 1)`<br>[Engine.FloatSignZero](../Source/Engine/FloatSignZero.asm#L27) — `BIT FLOAT_SIGN_BIT, A` |
| `GIFT_MAP_BIT` | разряд числового или графического значения | младший разряд случайного результата 0..1, 1 выбирает предложение награды картой текущего континента | [Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L77) — `BIT GIFT_MAP_BIT, E` |
| `MASK_FILL_BIT` | разряд числового или графического значения | позиция старшего бита маски, заполняемого единицей при смещении шестипиксельного символа | [Engine.DrawGlyph](../Source/Engine/DrawGlyph.asm#L38) — `SET MASK_FILL_BIT, B`<br>[Startup.DrawGlyph](../Source/Startup/DrawGlyph.asm#L41) — `SET MASK_FILL_BIT, B` |
| `PASS_CLEAR_BIT` | разряд числового или графического значения | позиция бита, снимаемого исходным проходом очистки SelectActor в четырёх полях за первой записью | [Battle.SelectActor](../Source/Battle/SelectActor.asm#L43) — `RES PASS_CLEAR_BIT, (IY + FBattleArmy.Second.Quantity + 3)`<br>[Battle.SelectActor](../Source/Battle/SelectActor.asm#L44) — `RES PASS_CLEAR_BIT, (IY + FBattleArmy.Third.Affinity)`<br>[Battle.SelectActor](../Source/Battle/SelectActor.asm#L45) — `RES PASS_CLEAR_BIT, (IY + FBattleArmy.Third.InitialCount.High)`<br>[Battle.SelectActor](../Source/Battle/SelectActor.asm#L46) — `RES PASS_CLEAR_BIT, (IY + FBattleArmy.Fourth.Y)` |
| `PIXEL_LEFT_BIT` | разряд числового или графического значения | позиция левого пикселя в экранном байте Spectrum | [Engine.ShiftCursorR](../Source/Engine/ShiftCursorR.asm#L28) — `SET PIXEL_LEFT_BIT, (HL)`<br>[Startup.RotateCursorR](../Source/Startup/RotateCursorR.asm#L33) — `SET PIXEL_LEFT_BIT, (HL)` |
| `PIXEL_RIGHT_BIT` | разряд числового или графического значения | позиция правого пикселя в экранном байте Spectrum | [Engine.ShiftCursorL](../Source/Engine/ShiftCursorL.asm#L28) — `SET PIXEL_RIGHT_BIT, (HL)`<br>[Startup.RotateCursorL](../Source/Startup/RotateCursorL.asm#L31) — `SET PIXEL_RIGHT_BIT, (HL)` |
| `PIX_PAIR_HI_BIT` | разряд числового или графического значения | старший пиксель удвоенной пары при горизонтальном увеличении глифа | [Presentation.ExpandBits](../Source/Files/06_PRES.asm#L1072) — `SET PIX_PAIR_HI_BIT, E` |
| `PIX_PAIR_LO_BIT` | разряд числового или графического значения | младший пиксель удвоенной пары при горизонтальном увеличении глифа | [Presentation.ExpandBits](../Source/Files/06_PRES.asm#L1071) — `SET PIX_PAIR_LO_BIT, E` |
| `RNG_FEED_BIT` | разряд числового или графического значения | позиция младшего бита слова, принимающего перенос старшего бита при циклическом обновлении генератора | [Engine.RandomScaled](../Source/Engine/RandomScaled.asm#L34) — `SET RNG_FEED_BIT, L`<br>[Presentation.RandomRange](../Source/Files/06_PRES.asm#L871) — `SET RNG_FEED_BIT, L`<br>[Startup.RandomRange](../Source/Startup/RandomRange.asm#L34) — `SET RNG_FEED_BIT, L` |
| `RNG_ROUND_BIT` | разряд числового или графического значения | позиция старшего бита дробной половины произведения, единица требует округления вверх | [Engine.RandomScaled](../Source/Engine/RandomScaled.asm#L62) — `BIT RNG_ROUND_BIT, H`<br>[Presentation.RandomRange](../Source/Files/06_PRES.asm#L896) — `BIT RNG_ROUND_BIT, H`<br>[Startup.RandomRange](../Source/Startup/RandomRange.asm#L59) — `BIT RNG_ROUND_BIT, H` |
| `ROW_ODD_BIT` | разряд числового или графического значения | младший разряд номера строки миникарты, нечётная строка выбирает вторую половину знакоместа | [Overlay.Maps.XorMiniTile](../Source/Overlays/Maps.asm#L459) — `BIT ROW_ODD_BIT, A` |
| `SEA_FIRST_BIT` | разряд числового или графического значения | младший разряд временной маски списка морских континентов, всегда разрешает первый континент после сдвига исходных MapFlags | [Overlay.Sail.Entry](../Source/Overlays/Sail.asm#L50) — `SET SEA_FIRST_BIT, A` |
| `TERRAIN_LSB_BIT` | разряд числового или графического значения | младший разряд байта местности, исходный StepMapTroops снимает его после поглощения находки, бит занятости при этом отдельно не снимается | [Engine.StepMapTroops](../Source/Engine/StepMapTroops.asm#L161) — `RES TERRAIN_LSB_BIT, (HL)` |
| `TOWN_ROLL_BIT` | разряд числового или графического значения | младший бит результата RandomScaled(1), единица откладывает обновление города | [Engine.RefreshTowns](../Source/Engine/RefreshTowns.asm#L34) — `BIT TOWN_ROLL_BIT, E` |
| `TOWN_XCHECK_BIT` | разряд числового или графического значения | бит координаты X города, исходный код проверяет гарнизон только при его установке, это не флаг FTown.Flags | [Engine.CastleIncome](../Source/Engine/CastleIncome.asm#L59) — `BIT TOWN_XCHECK_BIT, (IX + FTown.X)` |
| `UNIT_ID_HI_BIT` | разряд числового или графического значения | позиция старшего значащего бита ID, при допустимых ID 1..25 единица означает диапазон 16..25 | [Battle.AIUnitTurn](../Source/Battle/AIUnitTurn.asm#L134) — `BIT UNIT_ID_HI_BIT, (HL)` |

### Результат поиска файла TR-DOS

`FILE_MISS_BIT` применяется к результату функции `#0A`, а не к самостоятельному байту флагов. После поиска `C=#FF` означает отсутствие файла, `C=0..127` означает номер найденной записи каталога. Поэтому установленный старший разряд результата выбирает ветвь отсутствующего файла. Эти значения приведены в [описании стандартных вызовов TR-DOS](https://zxpress.ru/book_articles.php?id=1352).

## Изменяемые номера битов

В этих местах `BIT`/`SET` содержит начальную позицию шаблона команды. Предыдущий код вычисляет настоящий номер бита и записывает новый opcode. Константа в исходнике сохраняет исходные байты шаблона, но не фиксирует во время игры одну и ту же позицию поля.

| позиция шаблона | начальный бит | назначение и место подмены | потребители |
| --- | ---: | --- | --- |
| `FIELD_COL_BIT` | 0 | исходная позиция бита в шаблоне самоменяемой проверки либо установки столбца поля<br>Battle.FinishField.ObstacleRows, FObstacleRows.First | [Battle.BuildField](../Source/Battle/BuildField.asm#L103) — `BIT FIELD_COL_BIT, (IX + FObstacleRows.First)`<br>[Battle.InputLoop](../Source/Battle/InputLoop.asm#L585) — `SET FIELD_COL_BIT, (HL)`<br>[Battle.TestObstacle](../Source/Battle/TestObstacle.asm#L27) — `BIT FIELD_COL_BIT, (HL)` |
| `FOG_INDEX_BIT` | 0 | начальный номер бита шаблона проверки разведки, фактический номер 7-(X AND 7) переписывается в opcode<br>Overlay.Maps.IsCellExplored.ExploreTestOp | [Overlay.Maps.IsCellExplored](../Source/Overlays/Maps.asm#L419) — `BIT FOG_INDEX_BIT, (HL)` |
| `FOG_SEED_BIT` | 7 | начальный номер бита команды SET в карте открытия, до исполнения операнд FogSetOpcode меняется по координате X<br>UpdateLocalView.FogSetOpcode | [Engine.UpdateLocalView](../Source/Engine/UpdateLocalView.asm#L67) — `SET FOG_SEED_BIT, (HL)` |
| `MAP_INDEX_BIT` | 0 | начальный номер бита шаблонов проверки и открытия карт континентов, фактический номер вычисляется из номера континента и переписывается в opcode<br>State.MapFlags, изменяемые BIT/SET | [Overlay.Maps.Entry](../Source/Overlays/Maps.asm#L84) — `BIT MAP_INDEX_BIT, B`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L88) — `BIT MAP_INDEX_BIT, (HL)`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L94) — `SET MAP_INDEX_BIT, (HL)`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L126) — `BIT MAP_INDEX_BIT, (HL)`<br>[Overlay.Treasure.Entry](../Source/Overlays/Treasure.asm#L132) — `SET MAP_INDEX_BIT, (HL)` |
| `PIECE_INDEX_BIT` | 0 | начальный номер бита шаблонов BIT/SET карты головоломки, фактический номер 0..4 переписывается вычисленным opcode перед выполнением<br>Overlay.Capture.NewMapPiece.TestPiece/OpenPiece | [Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L472) — `BIT PIECE_INDEX_BIT, (HL)`<br>[Overlay.Capture.NewMapPiece](../Source/Overlays/Capture.asm#L476) — `SET PIECE_INDEX_BIT, (HL)` |

## Проверка и границы

Ссылки новых потребителей получены из действующих именованных инструкций, без использования прежних номеров строк. Исторические свидетельства с адресом перепривязаны к той же операции в исходном блоке. Сохраняется различие банков с совпадающими адресами. Свидетельства без однозначной операции не получают вымышленного номера строки.

Смысловые имена не меняют номера битов и сами по себе не выделяют память. Эта документация обновляется без сборки и без запуска игры в эмуляторе. [Границы общей проверки проекта](VerificationLimits.md).

[Машинный реестр Flags.json](../Tools/Disasm/Reports/Flags.json) · [Оглавление](README.md)
