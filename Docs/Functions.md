# Процедуры и точки входа

В реестре **486 установленных точек входа**. Описания и контракты перенесены из актуальных исходников, адреса и перечни рёбер сохранены из исходного статического графа.

Статический граф не описывает все возможные изменения кода, стековые переходы, загружаемые оверлеи и действия ROM. Списки чтений, записей и вызовов служат навигацией по распознанным инструкциям. Наличие аннотации не означает проверку каждого сценария в эмуляторе.

Машинные реестры: [functions.json](../Tools/Disasm/Reports/functions.json), [Functions.tsv](../Tools/Disasm/Reports/Functions.tsv). Исторические имена сохранены в `original_name`.

[Оглавление документации](README.md)

## Индекс модулей

- [Loader.Basic](#loaderbasic) — 1 точек входа
- [Loader.Sectors](#loadersectors) — 4 точек входа
- [Loader.Menu](#loadermenu) — 55 точек входа
- [Music.Menu](#musicmenu) — 17 точек входа
- [Startup](#startup) — 53 точек входа
- [MemoryDriver](#memorydriver) — 11 точек входа
- [Presentation](#presentation) — 18 точек входа
- [Graphics.Heroes](#graphicsheroes) — 2 точек входа
- [Engine](#engine) — 169 точек входа
- [Graphics.Scenes1](#graphicsscenes1) — 2 точек входа
- [Graphics.Scenes2](#graphicsscenes2) — 2 точек входа
- [Battle](#battle) — 77 точек входа
- [Protection.Outer](#protectionouter) — 1 точек входа
- [Protection.Move](#protectionmove) — 5 точек входа
- [Protection.Xor](#protectionxor) — 1 точек входа
- [Protection.Load](#protectionload) — 7 точек входа
- [Overlay.Capture](#overlaycapture) — 2 точек входа
- [Overlay.City](#overlaycity) — 5 точек входа
- [Overlay.Temple](#overlaytemple) — 2 точек входа
- [Overlay.Recruit](#overlayrecruit) — 1 точек входа
- [Overlay.Treasure](#overlaytreasure) — 1 точек входа
- [Overlay.Join](#overlayjoin) — 1 точек входа
- [Overlay.Bandits](#overlaybandits) — 1 точек входа
- [Overlay.Army](#overlayarmy) — 1 точек входа
- [Overlay.Save](#overlaysave) — 3 точек входа
- [Overlay.Dismiss](#overlaydismiss) — 2 точек входа
- [Overlay.TakeOff](#overlaytakeoff) — 1 точек входа
- [Overlay.Land](#overlayland) — 1 точек входа
- [Overlay.Maps](#overlaymaps) — 14 точек входа
- [Overlay.Sail](#overlaysail) — 1 точек входа
- [Overlay.TargetMap](#overlaytargetmap) — 1 точек входа
- [Overlay.Victory](#overlayvictory) — 3 точек входа
- [Overlay.Info](#overlayinfo) — 9 точек входа
- [Overlay.Friendly](#overlayfriendly) — 2 точек входа
- [Overlay.Hostile](#overlayhostile) — 2 точек входа
- [Overlay.Defeat](#overlaydefeat) — 2 точек входа
- [Overlay.Castle](#overlaycastle) — 4 точек входа
- [Overlay.Help](#overlayhelp) — 2 точек входа

## Loader.Basic

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #5D57 | `Loader.Basic.LoadSector` | чтение следующего сектора скрытого загрузчика | [Source/Loader/Basic.asm](../Source/Loader/Basic.asm#L25) |

### Loader.Basic.LoadSector

Адрес #5D57, блок `CTPB`. [Source/Loader/Basic.asm](../Source/Loader/Basic.asm#L25).

чтение следующего сектора скрытого загрузчика

BASIC вызывает USR LoadSector внутри REM. Адрес #8000 одновременно служит назначением сектора и будущим адресом возврата. В DE берётся текущая дисковая позиция TrDos.NextSector, B=1, C=5 выбирают прямое чтение одного сектора TR-DOS. После возврата DOS выполняется загруженный код #8000.

**Вход:** TrDos.NextSector — дорожка и сектор после прочитанного BASIC

**Выход:** управление передано #8000

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 5 инструкций. Чтение: #5CF4. Запись: не выделена. Вызовы: не выделены.

## Loader.Sectors

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #8000 | `Loader.Sectors.DecodeFirst` | очистка экрана и первый слой защиты | [Source/Loader/Sectors.asm](../Source/Loader/Sectors.asm#L22) |
| #804F | `Loader.Sectors.DecodeSecond` | второй слой защиты секторного загрузчика | [Source/Loader/Sectors.asm](../Source/Loader/Sectors.asm#L81) |
| #808A | `Loader.Sectors.LoadHiddenMenu` | чтение двух скрытых блоков дискового меню | [Source/Loader/Sectors.asm](../Source/Loader/Sectors.asm#L130) |
| #80A2 | `Loader.Sectors.ReadDecodeBlock` | чтение секторов и адресное XOR-преобразование | [Source/Loader/Sectors.asm](../Source/Loader/Sectors.asm#L154) |

### Loader.Sectors.DecodeFirst

Адрес #8000, блок `CTPL`. [Source/Loader/Sectors.asm](../Source/Loader/Sectors.asm#L22).

очистка экрана и первый слой защиты

Обнуляет экран и область системных данных #4000..#5AFF. Инициализирует R=#AC и расшифровывает 109 байтов начиная с DecodeSecond. В каждой итерации переключает #1FFD, выполняет длинный LDIR и восстанавливает HL/DE из системных переменных, поэтому ключ зависит от точного числа выборок команд.

**Вход:** нет явных аргументов

**Выход:** переход к DecodeSecond

**Изменяемые регистры и состояние:** HL, DE, BC, AF, R

**Дополнительно:** экран, #5C08, System.ErrorSP, #E2DB..#E940, порт #1FFD

В сохранённом графе: 40 инструкций. Чтение: #5C08, #5C3D. Запись: #5C08, #5C3D. Вызовы: не выделены.

### Loader.Sectors.DecodeSecond

Адрес #804F, блок `CTPL`. [Source/Loader/Sectors.asm](../Source/Loader/Sectors.asm#L81).

второй слой защиты секторного загрузчика

**Вход:** R после первого слоя

**Выход:** переход к #808A

**Изменяемые регистры и состояние:** HL, DE, BC, AF, R

**Дополнительно:** #808A..#80BB, #5C08, #5C3D, #1FFD

В сохранённом графе: 30 инструкций. Чтение: #5C08, #5C3D. Запись: #5C08, #5C3D. Вызовы: не выделены.

### Loader.Sectors.LoadHiddenMenu

Адрес #808A, блок `CTPL`. [Source/Loader/Sectors.asm](../Source/Loader/Sectors.asm#L130).

чтение двух скрытых блоков дискового меню

**Вход:** #5CF4 — текущая позиция чтения TR-DOS

**Выход:** управление на #6171

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** память #6171..#7770, #E000..#EBFF, порт #7FFD

В сохранённом графе: 10 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #80A2.

### Loader.Sectors.ReadDecodeBlock

Адрес #80A2, блок `CTPL`. [Source/Loader/Sectors.asm](../Source/Loader/Sectors.asm#L154).

чтение секторов и адресное XOR-преобразование

Сохраняет адрес назначения и число секторов. Вызывает TR-DOS с C=5 и DE из TrDos.NextSector. Затем преобразует B*256 байтов по формуле value XOR H XOR L.

**Вход:** HL — назначение, B — число секторов

**Выход:** HL после прочитанного блока, BC=0

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** область назначения и состояние TR-DOS

В сохранённом графе: 18 инструкций. Чтение: #5CF4. Запись: не выделена. Вызовы: #3D13.

## Loader.Menu

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #6171 | `Loader.Menu.DecodeMenu` | расшифровка меню с подменой канала вывода BASIC | [Source/Loader/Menu/DecodeMenu.asm](../Source/Loader/Menu/DecodeMenu.asm#L20) |
| #619D | `Loader.Menu.PrintHook` | перехватчик RST #10 внутри защитного преобразования | [Source/Loader/Menu/PrintHook.asm](../Source/Loader/Menu/PrintHook.asm#L15) |
| #61A8 | `Loader.Menu.MainMenu` | вход в скрытое меню дисковой версии | [Source/Loader/Menu/MainMenu.asm](../Source/Loader/Menu/MainMenu.asm#L17) |
| #620B | `Loader.Menu.ShowHelp` | загрузка и постраничный просмотр описания игры | [Source/Loader/Menu/ShowHelp.asm](../Source/Loader/Menu/ShowHelp.asm#L18) |
| #627F | `Loader.Menu.EditUnits` | вход в редактор параметров игровых армий | [Source/Loader/Menu/EditUnits.asm](../Source/Loader/Menu/EditUnits.asm#L19) |
| #63C6 | `Loader.Menu.ToggleDegrade` | переключение настройки редактора и отметки изменения | [Source/Loader/Menu/ToggleDegrade.asm](../Source/Loader/Menu/ToggleDegrade.asm#L20) |
| #63DC | `Loader.Menu.PrintDegrade` | вывод состояния переключаемой настройки редактора | [Source/Loader/Menu/PrintDegrade.asm](../Source/Loader/Menu/PrintDegrade.asm#L16) |
| #63F2 | `Loader.Menu.SaveAYState` | переход к IM 1 с сохранением состояния AY перед дисковой операцией | [Source/Loader/Menu/SaveAYState.asm](../Source/Loader/Menu/SaveAYState.asm#L15) |
| #6429 | `Loader.Menu.MenuInterrupt` | обработчик IM 2 скрытого меню | [Source/Loader/Menu/MenuInterrupt.asm](../Source/Loader/Menu/MenuInterrupt.asm#L17) |
| #644E | `Loader.Menu.RestoreAYState` | установка IM 2 и восстановление регистров AY | [Source/Loader/Menu/RestoreAYState.asm](../Source/Loader/Menu/RestoreAYState.asm#L16) |
| #6481 | `Loader.Menu.ResetUnitValues` | восстановление числовых параметров из встроенной таблицы | [Source/Loader/Menu/ResetUnitValues.asm](../Source/Loader/Menu/ResetUnitValues.asm#L17) |
| #64B2 | `Loader.Menu.SaveUnitValues` | сохранение изменённых параметров на диск | [Source/Loader/Menu/SaveUnitValues.asm](../Source/Loader/Menu/SaveUnitValues.asm#L16) |
| #64FC | `Loader.Menu.AddSectors` | продвижение пары трек-сектор на B секторов | [Source/Loader/Menu/AddSectors.asm](../Source/Loader/Menu/AddSectors.asm#L13) |
| #6508 | `Loader.Menu.FindFile` | поиск 9-байтового имени в каталоге TR-DOS | [Source/Loader/Menu/FindFile.asm](../Source/Loader/Menu/FindFile.asm#L16) |
| #6548 | `Loader.Menu.DiskOperation` | выполнение дисковой операции с выбором привода и обработкой ошибки | [Source/Loader/Menu/DiskOperation.asm](../Source/Loader/Menu/DiskOperation.asm#L17) |
| #6573 | `Loader.Menu.CallDosIO` | шлюз TR-DOS с перехватом ошибок и служебных возвратов | [Source/Loader/Menu/CallDosIO.asm](../Source/Loader/Menu/CallDosIO.asm#L22) |
| #65B2 | `Loader.Menu.DosErrorReturn` | возврат по ошибке через ERR_SP | [Source/Loader/Menu/DosErrorReturn.asm](../Source/Loader/Menu/DosErrorReturn.asm#L17) |
| #65B6 | `Loader.Menu.DosReturnHook` | перехват возвратов TR-DOS через #5CC2 | [Source/Loader/Menu/DosReturnHook.asm](../Source/Loader/Menu/DosReturnHook.asm#L20) |
| #65DE | `Loader.Menu.AccessFile` | операция с файлом по имени и смещению в секторах | [Source/Loader/Menu/AccessFile.asm](../Source/Loader/Menu/AccessFile.asm#L22) |
| #65F1 | `Loader.Menu.ShowDiskError` | показ дисковой ошибки с восстановлением главного меню | [Source/Loader/Menu/ShowDiskError.asm](../Source/Loader/Menu/ShowDiskError.asm#L19) |
| #6631 | `Loader.Menu.ClearScreen` | очистка экранной памяти и заполнение атрибутов | [Source/Loader/Menu/ClearScreen.asm](../Source/Loader/Menu/ClearScreen.asm#L15) |
| #6644 | `Loader.Menu.ByteToDecimal` | преобразование беззнакового байта в три десятичные цифры | [Source/Loader/Menu/ByteToDecimal.asm](../Source/Loader/Menu/ByteToDecimal.asm#L15) |
| #6657 | `Loader.Menu.WriteDigit` | получение одной десятичной цифры повторным вычитанием | [Source/Loader/Menu/WriteDigit.asm](../Source/Loader/Menu/WriteDigit.asm#L15) |
| #6666 | `Loader.Menu.SelectDrive` | установка текущего привода TR-DOS | [Source/Loader/Menu/SelectDrive.asm](../Source/Loader/Menu/SelectDrive.asm#L15) |
| #6938 | `Loader.Menu.HighlightAreas` | подсветка области меню под курсором | [Source/Loader/Menu/HighlightAreas.asm](../Source/Loader/Menu/HighlightAreas.asm#L17) |
| #698A | `Loader.Menu.CursorBackdrop` | сохранение или восстановление фона курсора | [Source/Loader/Menu/CursorBackdrop.asm](../Source/Loader/Menu/CursorBackdrop.asm#L17) |
| #69D8 | `Loader.Menu.DrawCursor` | вывод маскированного пиксельного курсора | [Source/Loader/Menu/DrawCursor.asm](../Source/Loader/Menu/DrawCursor.asm#L17) |
| #6A56 | `Loader.Menu.MoveCursor` | расчёт следующей позиции курсора по управлению | [Source/Loader/Menu/MoveCursor.asm](../Source/Loader/Menu/MoveCursor.asm#L18) |
| #6AB4 | `Loader.Menu.BeginMenu` | подготовка выбора пункта меню курсором | [Source/Loader/Menu/BeginMenu.asm](../Source/Loader/Menu/BeginMenu.asm#L15) |
| #6AD5 | `Loader.Menu.PollMenu` | один шаг ожидания выбора в меню | [Source/Loader/Menu/PollMenu.asm](../Source/Loader/Menu/PollMenu.asm#L17) |
| #6B32 | `Loader.Menu.EndMenu` | завершение выбора пункта меню | [Source/Loader/Menu/EndMenu.asm](../Source/Loader/Menu/EndMenu.asm#L15) |
| #6B40 | `Loader.Menu.ReadControls` | объединённый опрос клавиатуры и Kempston | [Source/Loader/Menu/ReadControls.asm](../Source/Loader/Menu/ReadControls.asm#L15) |
| #6B72 | `Loader.Menu.ReadKeyCodes` | опрос последовательности упакованных кодов кнопок | [Source/Loader/Menu/ReadKeyCodes.asm](../Source/Loader/Menu/ReadKeyCodes.asm#L15) |
| #6BA1 | `Loader.Menu.WaitRelease` | ожидание отпускания кнопки действия | [Source/Loader/Menu/WaitRelease.asm](../Source/Loader/Menu/WaitRelease.asm#L14) |
| #6BA9 | `Loader.Menu.WaitPress` | ожидание нового нажатия кнопки действия | [Source/Loader/Menu/WaitPress.asm](../Source/Loader/Menu/WaitPress.asm#L14) |
| #6BB4 | `Loader.Menu.MenuClick` | короткий звуковой отклик меню | [Source/Loader/Menu/MenuClick.asm](../Source/Loader/Menu/MenuClick.asm#L17) |
| #6BB9 | `Loader.Menu.BeepShortDelay` | вариант биперного эффекта с параметрами D=96, E=8 | [Source/Loader/Menu/BeepShortDelay.asm](../Source/Loader/Menu/BeepShortDelay.asm#L16) |
| #6BBE | `Loader.Menu.BeepLongDelay` | вариант биперного эффекта с параметрами D=64, E=127 | [Source/Loader/Menu/BeepLongDelay.asm](../Source/Loader/Menu/BeepLongDelay.asm#L16) |
| #6BC1 | `Loader.Menu.Beep` | биперный эффект с псевдослучайной задержкой | [Source/Loader/Menu/Beep.asm](../Source/Loader/Menu/Beep.asm#L16) |
| #6BDC | `Loader.Menu.RandomByte` | получение псевдослучайного байта для бипера | [Source/Loader/Menu/RandomByte.asm](../Source/Loader/Menu/RandomByte.asm#L14) |
| #6BEB | `Loader.Menu.WaitCursorFrame` | ожидание одного прерывания с обновлением курсора | [Source/Loader/Menu/WaitCursorFrame.asm](../Source/Loader/Menu/WaitCursorFrame.asm#L16) |
| #6BED | `Loader.Menu.TickCursor` | обновление курсора и подсветки в прерывании | [Source/Loader/Menu/TickCursor.asm](../Source/Loader/Menu/TickCursor.asm#L16) |
| #6C86 | `Loader.Menu.DrawWindow` | рисование окна по дескриптору | [Source/Loader/Menu/DrawWindow.asm](../Source/Loader/Menu/DrawWindow.asm#L19) |
| #6D37 | `Loader.Menu.DrawHBorder` | рисование горизонтальной границы окна | [Source/Loader/Menu/DrawHBorder.asm](../Source/Loader/Menu/DrawHBorder.asm#L15) |
| #6D4D | `Loader.Menu.FillWindowAttrs` | заполнение прямоугольника атрибутов окна | [Source/Loader/Menu/FillWindowAttrs.asm](../Source/Loader/Menu/FillWindowAttrs.asm#L14) |
| #6D67 | `Loader.Menu.PrintString` | печать строки с управляющими кодами | [Source/Loader/Menu/PrintString.asm](../Source/Loader/Menu/PrintString.asm#L16) |
| #6DBD | `Loader.Menu.PrintChar` | печать одного знака шестипиксельного шрифта | [Source/Loader/Menu/PrintChar.asm](../Source/Loader/Menu/PrintChar.asm#L15) |
| #6E07 | `Loader.Menu.StartGame` | загрузка стартового блока игры и удаление скрытого меню | [Source/Loader/Menu/StartGame.asm](../Source/Loader/Menu/StartGame.asm#L23) |
| #6E43 | `Loader.Menu.SwapAttrStrip` | обмен цветов INK и PAPER в полосе атрибутов | [Source/Loader/Menu/SwapAttrStrip.asm](../Source/Loader/Menu/SwapAttrStrip.asm#L15) |
| #6E55 | `Loader.Menu.SwapAttrColors` | обмен INK и PAPER одного атрибута | [Source/Loader/Menu/SwapAttrColors.asm](../Source/Loader/Menu/SwapAttrColors.asm#L12) |
| #6E71 | `Loader.Menu.AttrAddress` | адрес атрибута по символьным координатам | [Source/Loader/Menu/AttrAddress.asm](../Source/Loader/Menu/AttrAddress.asm#L12) |
| #6E90 | `Loader.Menu.MulSix` | умножение беззнакового байта на 6 по модулю 256 | [Source/Loader/Menu/MulSix.asm](../Source/Loader/Menu/MulSix.asm#L13) |
| #6E9B | `Loader.Menu.PixelAddress` | адрес пиксельного байта и положение бита на экране ZX Spectrum | [Source/Loader/Menu/PixelAddress.asm](../Source/Loader/Menu/PixelAddress.asm#L12) |
| #6ECC | `Loader.Menu.DrawShiftedRow` | вывод строки байтов со сдвигом по горизонтали | [Source/Loader/Menu/DrawShiftedRow.asm](../Source/Loader/Menu/DrawShiftedRow.asm#L16) |
| #6F11 | `Loader.Menu.DrawByteRect` | вывод прямоугольника байтов в пиксельных координатах | [Source/Loader/Menu/DrawByteRect.asm](../Source/Loader/Menu/DrawByteRect.asm#L15) |

### Loader.Menu.DecodeMenu

Адрес #6171, блок `CTPM`. [Source/Loader/Menu/DecodeMenu.asm](../Source/Loader/Menu/DecodeMenu.asm#L20).

расшифровка меню с подменой канала вывода BASIC

Сохраняет CURCHL из System.CurrentChannel в операнде DecodeMenu.SavedChannel и заменяет его на указатель #61A6, содержащий PrintHook. Инициализирует R=#59 и обрабатывает #157D байтов MainMenu..Loader.Menu.UnitBuffer включительно. Ключ образуется показаниями R, байтами адреса, остатком DE и дополнительным XOR внутри перехватчика RST #10. Вызов проходит через настоящий путь ПЗУ #0010/#15F2/#162C, поэтому число M1-выборок входит в ключ. После расшифровки восстанавливает HL из сохранённого операнда и передаёт управление MainMenu. На этом участке CURCHL остаётся подменённым.

**Вход:** System.CurrentChannel — исходный канал вывода, стандартное ПЗУ 48

**Выход:** открытый код меню по MainMenu

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', R

В сохранённом графе: 14 инструкций. Чтение: #5C51. Запись: #5C51, #6198. Вызовы: не выделены.

### Loader.Menu.PrintHook

Адрес #619D, блок `CTPM`. [Source/Loader/Menu/PrintHook.asm](../Source/Loader/Menu/PrintHook.asm#L15).

перехватчик RST #10 внутри защитного преобразования

Три POP HL снимают промежуточные адреса пути канала вывода, два DEC SP возвращают позицию к исходному адресу RST. Дополнительные XOR H и L смешивают снятый адрес с A. EXX возвращает рабочие регистры дешифратора, RET возвращает к #618E. Здесь стек является частью алгоритма защиты, обычный подпрограммный контракт неприменим.

**Вход:** стек и альтернативные регистры после пути вывода ПЗУ

**Выход:** A содержит дополнительное XOR-преобразование, возврат к #618E

**Изменяемые регистры и состояние:** HL, AF, HL', DE', BC'

В сохранённом графе: 9 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Loader.Menu.MainMenu

Адрес #61A8, блок `CTPM`. [Source/Loader/Menu/MainMenu.asm](../Source/Loader/Menu/MainMenu.asm#L17).

вход в скрытое меню дисковой версии

Сохраняет исходный SP, запоминает текущий привод TR-DOS, выбирает привод 0, запускает AY-плеер, устанавливает IM 2. Очищает экран, рисует окно и три пункта. Обрабатывает выбор, возвращая управление в главное меню после описания или редактора.

**Вход:** SP — стек вызывающего BASIC, TrDos.Drive — текущий привод

**Выход:** после выбора игры управление передаётся StartGame

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', IX, IY, I, режим прерываний

**Дополнительно:** SaveAYState.MenuStack — сохранённый SP, SelectDrive.Drive — привод, SelectDrive.MenuCursor — начальная позиция курсора

В сохранённом графе: 39 инструкций. Чтение: #5D16, #6935, #6C74. Запись: #6419, #6672, #6935, #6C4C, #6C74. Вызовы: #620B, #627F, #63F2, #644E, #6631, #6666, #6AB4, #6AD5, #6B32, #6C86, #6D67, #6E07, #E000.

### Loader.Menu.ShowHelp

Адрес #620B, блок `CTPM`. [Source/Loader/Menu/ShowHelp.asm](../Source/Loader/Menu/ShowHelp.asm#L18).

загрузка и постраничный просмотр описания игры

Загружает HELPG.tx/C в Loader.Menu.UnitBuffer. Начальное значение R берёт из XOR байтов TrDos.FileSector/#5CEC. Для каждого байта XOR объединяет R, адрес HL, остаток DE и данные, затем обновляет R через XOR с L. После расшифровки выводит страницы в окне. Кнопка 0 завершает просмотр, направления переходят к следующему или предыдущему фрагменту текста.

**Вход:** нет явных аргументов

**Выход:** A=0 при обычном возврате

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

**Дополнительно:** Loader.Menu.UnitBuffer — загруженный и расшифрованный текст, экран, IM 2

В сохранённом графе: 68 инструкций. Чтение: #5CE8, #5CEB. Запись: не выделена. Вызовы: #644E, #65DE, #6B40, #6C86, #6D67.

### Loader.Menu.EditUnits

Адрес #627F, блок `CTPM`. [Source/Loader/Menu/EditUnits.asm](../Source/Loader/Menu/EditUnits.asm#L19).

вход в редактор параметров игровых армий

Обнуляет Loader.Menu.UnitBuffer..#DFFF, загружает SOLDIERS/C и сектор head.co/C со смещением #3E. Рисует таблицу из 25 записей по #2A байта. Для каждой записи выводит имя и байт значения по смещению #29. Меню позволяет сохранить, выйти, восстановить значения, переключить состояние и изменить выбранное число.

**Вход:** нет явных аргументов

**Выход:** возврат по пункту выхода

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

**Дополнительно:** Loader.Menu.UnitBuffer — редактируемые записи, Loader.Menu.HeadSector — сектор head.co, SelectDrive.EditFlags — флаги изменений

В сохранённом графе: 160 инструкций. Чтение: #66B7, #6937. Запись: #66B6, #66B7, #66B9, #6937. Вызовы: #63C6, #63DC, #644E, #6481, #64B2, #65DE, #6644, #6AB4, #6AD5, #6B32, #6B40, #6BA1, #6C86, #6D67.

### Loader.Menu.ToggleDegrade

Адрес #63C6, блок `CTPM`. [Source/Loader/Menu/ToggleDegrade.asm](../Source/Loader/Menu/ToggleDegrade.asm#L20).

переключение настройки редактора и отметки изменения

**Вход:** #6937, #7C41 — текущие состояния

**Выход:** переход к #6316

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** #6937, #7C41, экран

В сохранённом графе: 149 инструкций. Чтение: #66B7, #6937, #7C41. Запись: #66B6, #66B7, #66B9, #6937, #7C41. Вызовы: #63DC, #6481, #64B2, #6644, #6AB4, #6AD5, #6B32, #6B40, #6BA1, #6D67.

### Loader.Menu.PrintDegrade

Адрес #63DC, блок `CTPM`. [Source/Loader/Menu/PrintDegrade.asm](../Source/Loader/Menu/PrintDegrade.asm#L16).

вывод состояния переключаемой настройки редактора

Печатает строку «Деградация». Если Loader.Menu.DegradeSwitch=#18, выбирает подпись «отключена» по #6865, иначе «включена» по #6858.

**Вход:** Loader.Menu.DegradeSwitch — значение настройки

**Выход:** выведена соответствующая подпись

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** экран

В сохранённом графе: 8 инструкций. Чтение: #7C41. Запись: не выделена. Вызовы: #6D67.

### Loader.Menu.SaveAYState

Адрес #63F2, блок `CTPM`. [Source/Loader/Menu/SaveAYState.asm](../Source/Loader/Menu/SaveAYState.asm#L15).

переход к IM 1 с сохранением состояния AY перед дисковой операцией

Запрещает прерывания, включает IM 1, устанавливает I=#3F и IY=#5C3A, задаёт HL'=#2758. Читает регистры AY 0..13 в #641B..#6428 и записывает в них нули. Включает прерывания.

**Вход:** нет явных аргументов

**Выход:** IM 1, EI

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', IY, I

**Дополнительно:** #641B..#6428 — сохранённые регистры AY, порты #FFFD/#BFFD

В сохранённом графе: 21 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Loader.Menu.MenuInterrupt

Адрес #6429, блок `CTPM`. [Source/Loader/Menu/MenuInterrupt.asm](../Source/Loader/Menu/MenuInterrupt.asm#L17).

обработчик IM 2 скрытого меню

Сохраняет AF, BC, DE, HL, IX. Читает адрес возврата прерванной команды со стека. Если он равен #6BEC, вызывает обновление курсора TickCursor. В каждом прерывании вызывает музыкальный тик #E006, восстанавливает регистры, выполняет EI и RET.

**Вход:** вход аппаратного прерывания IM 2

**Выход:** основные сохранённые регистры восстановлены

**Изменяемые регистры и состояние:** оперативное состояние вызываемых процедур, IY не сохраняется явно, альтернативные регистры не сохраняются явно

**Дополнительно:** самомодификация операнда MenuInterrupt.IntStack, AY, экран при ожидании HALT

В сохранённом графе: 23 инструкций. Чтение: не выделено. Запись: #6434. Вызовы: #6BED, #E006.

### Loader.Menu.RestoreAYState

Адрес #644E, блок `CTPM`. [Source/Loader/Menu/RestoreAYState.asm](../Source/Loader/Menu/RestoreAYState.asm#L16).

установка IM 2 и восстановление регистров AY

Заполняет #FE00..#FF00 байтом #FD, записывает JP MenuInterrupt в #FDFD, устанавливает I=#FE и IM 2. Восстанавливает AY-регистры 0..13 из #641B, включает прерывания.

**Вход:** #641B..#6428 — сохранённые значения AY

**Выход:** IM 2, EI

**Изменяемые регистры и состояние:** HL, DE, BC, AF, I

**Дополнительно:** #FE00..#FF00, #FDFD..#FDFF, AY

В сохранённом графе: 33 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Loader.Menu.ResetUnitValues

Адрес #6481, блок `CTPM`. [Source/Loader/Menu/ResetUnitValues.asm](../Source/Loader/Menu/ResetUnitValues.asm#L17).

восстановление числовых параметров из встроенной таблицы

Устанавливает Loader.Menu.DegradeSwitch=#38, отмечает изменения в SelectDrive.EditFlags, затем переносит 25 байтов из #6673..#668B в смещение #29 каждой записи Loader.Menu.UnitBuffer с шагом #2A. Возвращается к перерисовке редактора.

**Вход:** Loader.Menu.DegradeSwitch — прежняя настройка

**Выход:** переход к EditUnits.DrawWindow

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** SelectDrive.EditFlags, Loader.Menu.DegradeSwitch, 25 записей Loader.Menu.UnitBuffer

В сохранённом графе: 169 инструкций. Чтение: #66B7, #6937, #7C41. Запись: #66B6, #66B7, #66B9, #6937, #7C41. Вызовы: #63C6, #63DC, #64B2, #6644, #6AB4, #6AD5, #6B32, #6B40, #6BA1, #6C86, #6D67.

### Loader.Menu.SaveUnitValues

Адрес #64B2, блок `CTPM`. [Source/Loader/Menu/SaveUnitValues.asm](../Source/Loader/Menu/SaveUnitValues.asm#L16).

сохранение изменённых параметров на диск

Сбрасывает флаги изменений. Если был установлен бит 1, записывает SOLDIERS/C. Если был установлен бит 0, записывает один сектор head.co/C со смещением #3E. Перед операциями переключает прерывания и AY, затем при необходимости восстанавливает IM 2.

**Вход:** SelectDrive.EditFlags — бит 1 числовые параметры, бит 0 дополнительная настройка

**Выход:** переход к EditUnits.DrawUnits

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

**Дополнительно:** запись файлов на диск, SelectDrive.EditFlags, самомодификация SaveUnitValues.ResumeMusic

В сохранённом графе: 173 инструкций. Чтение: #64F4, #66B7, #6937. Запись: #64F4, #66B6, #66B7, #66B9, #6937. Вызовы: #63C6, #63DC, #63F2, #644E, #6481, #65DE, #6644, #6AB4, #6AD5, #6B32, #6B40, #6BA1, #6D67.

### Loader.Menu.AddSectors

Адрес #64FC, блок `CTPM`. [Source/Loader/Menu/AddSectors.asm](../Source/Loader/Menu/AddSectors.asm#L13).

продвижение пары трек-сектор на B секторов

Увеличивает L, при L=#10 сбрасывает L и увеличивает H. Повторяет DJNZ. При исходном B=0 выполняются 256 итераций.

**Вход:** HL — H трек, L сектор, B — число секторов

**Выход:** HL — новая позиция, B=0

**Изменяемые регистры и состояние:** HL, BC, AF

В сохранённом графе: 8 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Loader.Menu.FindFile

Адрес #6508, блок `CTPM`. [Source/Loader/Menu/FindFile.asm](../Source/Loader/Menu/FindFile.asm#L16).

поиск 9-байтового имени в каталоге TR-DOS

Читает восемь секторов каталога в #D800, затем просматривает до 127 записей по 16 байтов. Нулевая первая буква завершает поиск, #01 означает удалённый файл. Сравнивает имя 8 байтов и тип с TrDos.Descriptor, найденный 16-байтовый дескриптор копирует туда целиком.

**Вход:** TrDos.Descriptor..#5CE5 — имя и тип

**Выход:** CF=1 найдено, CF=0 не найдено, IX — запись

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

**Дополнительно:** #D800..#DFFF, TrDos.Descriptor..#5CEC при успехе

В сохранённом графе: 35 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6548.

### Loader.Menu.DiskOperation

Адрес #6548, блок `CTPM`. [Source/Loader/Menu/DiskOperation.asm](../Source/Loader/Menu/DiskOperation.asm#L17).

выполнение дисковой операции с выбором привода и обработкой ошибки

Выбирает сохранённый привод SelectDrive.Drive, вызывает защищённый шлюз CallDosIO, возвращает привод 0. При A=0 возвращается. При ненулевом A выбирает сообщения «нет диска», «ошибка чтения» или «защита записи» и аварийно возвращает пользователя в меню.

**Вход:** HL, DE, BC — контракт вызываемой операции TR-DOS

**Выход:** A=0 при обычном возврате

**Изменяемые регистры и состояние:** регистры согласно TR-DOS, HL, AF изменяются обёрткой

**Дополнительно:** привод, вектор TrDos.ReturnHook, обработчик ошибок BASIC

В сохранённом графе: 23 инструкций. Чтение: #6672. Запись: не выделена. Вызовы: #6573, #65F1, #6666.

### Loader.Menu.CallDosIO

Адрес #6573, блок `CTPM`. [Source/Loader/Menu/CallDosIO.asm](../Source/Loader/Menu/CallDosIO.asm#L22).

шлюз TR-DOS с перехватом ошибок и служебных возвратов

**Вход:** HL — буфер, DE — дисковая позиция, BC — аргументы TR-DOS, IY указывает системные переменные

**Выход:** A=0 обычный возврат, A=1..3 перехваченная ошибка

**Изменяемые регистры и состояние:** HL, DE, BC, AF по TR-DOS

**Дополнительно:** самомодификация #659B/#65A2/#65A5, временный SP, #5C3D, #5CC2..#5CC4

В сохранённом графе: 24 инструкций. Чтение: #5C3D. Запись: #5C3D, #5CC2, #5CC3, #659B, #65A2, #65A5. Вызовы: #3D13.

### Loader.Menu.DosErrorReturn

Адрес #65B2, блок `CTPM`. [Source/Loader/Menu/DosErrorReturn.asm](../Source/Loader/Menu/DosErrorReturn.asm#L17).

возврат по ошибке через ERR_SP

Устанавливает A=1 и переходит к восстановлению SP и ERR_SP в CallDosIO.RestoreStack.

**Вход:** контекст ошибки шлюза CallDosIO, сохранённые операнды исходного SP по CallDosIO.SavedSP и ERR_SP по CallDosIO.SavedErrSP, адрес возврата на исходном стеке

**Выход:** A=1, HL=сохранённый ERR_SP, System.ErrorSP восстановлен, TrDos.ReturnHook=#C9, возврат из дискового шлюза через восстановленный SP

**Изменяемые регистры и состояние:** HL, AF, SP восстанавливается из операнда CallDosIO.SavedSP. DE, BC, HL', DE', BC', AF', IX, IY сам обработчик не изменяет, до входа они могли быть изменены TR-DOS

В сохранённом графе: 10 инструкций. Чтение: не выделено. Запись: #5C3D, #5CC2. Вызовы: не выделены.

### Loader.Menu.DosReturnHook

Адрес #65B6, блок `CTPM`. [Source/Loader/Menu/DosReturnHook.asm](../Source/Loader/Menu/DosReturnHook.asm#L20).

перехват возвратов TR-DOS через #5CC2

**Вход:** стек вызова TR-DOS, #5CCE

**Выход:** изменённый адрес возврата или выход через #65A1

**Изменяемые регистры и состояние:** HL, AF временно сохраняются, состояние прерываний DI

**Дополнительно:** вершина стека

В сохранённом графе: 33 инструкций. Чтение: #5CCE. Запись: #5C3D, #5CC2. Вызовы: не выделены.

### Loader.Menu.AccessFile

Адрес #65DE, блок `CTPM`. [Source/Loader/Menu/AccessFile.asm](../Source/Loader/Menu/AccessFile.asm#L22).

операция с файлом по имени и смещению в секторах

**Вход:** HL — 9 байтов имени, DE — буфер, A — секторное смещение, B — число секторов или #FF, C — функция TR-DOS (5 чтение, 6 запись)

**Выход:** успешный возврат из #6548

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

**Дополнительно:** буфер и/или диск, системный дескриптор #5CDD

В сохранённом графе: 23 инструкций. Чтение: #5CEA, #5CEB. Запись: не выделена. Вызовы: #64FC, #6508, #6548.

### Loader.Menu.ShowDiskError

Адрес #65F1, блок `CTPM`. [Source/Loader/Menu/ShowDiskError.asm](../Source/Loader/Menu/ShowDiskError.asm#L19).

показ дисковой ошибки с восстановлением главного меню

**Вход:** HL — строка ошибки, #6419 — исходный SP

**Выход:** не возвращается, JP #61C2

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, SP

**Дополнительно:** экран, IM 2

В сохранённом графе: 45 инструкций. Чтение: #6419, #6935, #6C74. Запись: #6935, #6C4C, #6C74. Вызовы: #620B, #627F, #63F2, #644E, #6631, #6AB4, #6AD5, #6B32, #6BA1, #6BA9, #6C86, #6D67, #6E07.

### Loader.Menu.ClearScreen

Адрес #6631, блок `CTPM`. [Source/Loader/Menu/ClearScreen.asm](../Source/Loader/Menu/ClearScreen.asm#L15).

очистка экранной памяти и заполнение атрибутов

Распространяет ноль из #4000 через #5800 включительно. Затем заменяет #5800 значением A и распространяет его по #5801..#5AFF, заполняя все 768 атрибутов.

**Вход:** A — атрибут заполнения

**Выход:** экран очищен, HL=#5AFF, DE=#5B00, BC=0

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** #4000..#5AFF

В сохранённом графе: 9 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Loader.Menu.ByteToDecimal

Адрес #6644, блок `CTPM`. [Source/Loader/Menu/ByteToDecimal.asm](../Source/Loader/Menu/ByteToDecimal.asm#L15).

преобразование беззнакового байта в три десятичные цифры

Последовательными вычитаниями 100 и 10 получает сотни и десятки, затем записывает единицы. Ведущие нули сохраняются.

**Вход:** A — число 0..255

**Выход:** #66B0..#66B2 — три ASCII-цифры

**Изменяемые регистры и состояние:** HL, BC, AF

**Дополнительно:** #66B0..#66B2

В сохранённом графе: 8 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6657.

### Loader.Menu.WriteDigit

Адрес #6657, блок `CTPM`. [Source/Loader/Menu/WriteDigit.asm](../Source/Loader/Menu/WriteDigit.asm#L15).

получение одной десятичной цифры повторным вычитанием

Вычитает C из A и увеличивает B до займа. Восстанавливает остаток, пишет B+ASCII 0 по HL и увеличивает HL.

**Вход:** A — делимое, C — делитель, B=0, HL — приёмник

**Выход:** A — остаток, HL увеличен на 1

**Изменяемые регистры и состояние:** HL, BC, AF

**Дополнительно:** байт по исходному HL

В сохранённом графе: 12 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Loader.Menu.SelectDrive

Адрес #6666, блок `CTPM`. [Source/Loader/Menu/SelectDrive.asm](../Source/Loader/Menu/SelectDrive.asm#L15).

установка текущего привода TR-DOS

Записывает A в TrDos.Drive, задаёт C=#FF и адрес возврата #2A53 на стеке, затем переходит в TR-DOS #3D2F. Использование внутренних адресов зависит от версии ROM TR-DOS.

**Вход:** A — номер привода

**Выход:** выбран привод

**Изменяемые регистры и состояние:** HL, BC, AF, прочие регистры по ROM TR-DOS

**Дополнительно:** TrDos.Drive, состояние TR-DOS

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: #5D16. Вызовы: не выделены.

### Loader.Menu.HighlightAreas

Адрес #6938, блок `CTPM`. [Source/Loader/Menu/HighlightAreas.asm](../Source/Loader/Menu/HighlightAreas.asm#L17).

подсветка области меню под курсором

Проходит тройки (x, y, длина) по указателю MenuState.Areas до #FF. Проверяет B как строку, C как столбец. Бит 7 первого байта хранит текущую подсветку. При входе или выходе меняет бит и переставляет INK/PAPER в полосе атрибутов через SwapAttrStrip.

**Вход:** B — строка курсора, C — столбец курсора, MenuState.Areas — таблица областей

**Выход:** активная область отмечена битом 7

**Изменяемые регистры и состояние:** HL, DE, AF, IX, BC сохраняется вспомогательным изменением атрибутов

**Дополнительно:** таблица областей, атрибуты экрана

В сохранённом графе: 36 инструкций. Чтение: #6C7A. Запись: не выделена. Вызовы: #6E43.

### Loader.Menu.CursorBackdrop

Адрес #698A, блок `CTPM`. [Source/Loader/Menu/CursorBackdrop.asm](../Source/Loader/Menu/CursorBackdrop.asm#L17).

сохранение или восстановление фона курсора

По позиции MenuState.CursorXY сохраняет три экранных байта на каждой из максимум восьми строк в #6C31 или восстанавливает их обратно. Внизу экрана число строк ограничено 192-y.

**Вход:** C bit 7=0 сохранить фон, C bit 7=1 восстановить, MenuState.CursorXY=x, MenuState.CursorY=y

**Выход:** фон сохранён или экран восстановлен

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** #6C31..#6C48 или экран, самомодификация CursorBackdrop.BackdropY

В сохранённом графе: 46 инструкций. Чтение: #69B7, #6C75. Запись: #69B7. Вызовы: #6E9B.

### Loader.Menu.DrawCursor

Адрес #69D8, блок `CTPM`. [Source/Loader/Menu/DrawCursor.asm](../Source/Loader/Menu/DrawCursor.asm#L17).

вывод маскированного пиксельного курсора

Берёт рисунок и маску по CursorPixels/CursorMask, сдвигает их на x mod 8, объединяет экран как (фон AND маска) OR рисунок. На строке меняет до трёх байтов с проверкой границы строки, ограничивает низ экрана.

**Вход:** MenuState.CursorXY=x, MenuState.CursorY=y

**Выход:** курсор выведен

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

**Дополнительно:** экран, самомодификация DrawCursor.DrawY

В сохранённом графе: 79 инструкций. Чтение: #69F7, #6C75. Запись: #69F7. Вызовы: #6E9B.

### Loader.Menu.MoveCursor

Адрес #6A56, блок `CTPM`. [Source/Loader/Menu/MoveCursor.asm](../Source/Loader/Menu/MoveCursor.asm#L18).

расчёт следующей позиции курсора по управлению

Опросом ReadControls получает C. При удержании одного состояния увеличивает MenuState.HoldTicks, выбирает скорость 1, 2, 3 или 4 пикселя по порогам 12, 16, 20. Биты C задают влево, вправо, вверх, вниз. Ограничивает x диапазоном 0..252, y 0..190 и сохраняет новую пару MenuState.NextXY.

**Вход:** MenuState.CursorXY — текущая позиция, MenuState.KeyMask/MenuState.HoldTicks — история нажатия

**Выход:** HL и MenuState.NextXY — новая позиция, C — управление

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** MenuState.NextXY..MenuState.HoldTicks

В сохранённом графе: 56 инструкций. Чтение: #6C74, #6C79. Запись: #6C76, #6C79. Вызовы: #6B40.

### Loader.Menu.BeginMenu

Адрес #6AB4, блок `CTPM`. [Source/Loader/Menu/BeginMenu.asm](../Source/Loader/Menu/BeginMenu.asm#L15).

подготовка выбора пункта меню курсором

Сохраняет таблицу HL, переводит текущую позицию в символьные координаты, обновляет подсветку, ждёт отпускания кнопки, сохраняет фон и рисует курсор.

**Вход:** HL — таблица троек областей, MenuState.CursorXY — позиция

**Выход:** активное меню готово

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

**Дополнительно:** MenuState.Areas, фон курсора, экран

В сохранённом графе: 13 инструкций. Чтение: #6C74. Запись: #6C7A. Вызовы: #6938, #698A, #69D8, #6BA1.

### Loader.Menu.PollMenu

Адрес #6AD5, блок `CTPM`. [Source/Loader/Menu/PollMenu.asm](../Source/Loader/Menu/PollMenu.asm#L17).

один шаг ожидания выбора в меню

Рассчитывает движение, при ненулевом управлении ждёт кадр через HALT. При кнопке 0 проверяет нахождение курсора в окне и ищет отмеченную область в таблице. Возвращает номер найденной области или #FF вне окна.

**Вход:** состояние меню и управления

**Выход:** CF=1 при выборе, A — индекс пункта или #FF, MenuState.Choice — индекс, при обычном ожидании CF=0

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX сохраняется при прямом обходе выбора, изменяется обработчиком обновления

**Дополнительно:** MenuState.NextXY, MenuState.KeyMask/MenuState.HoldTicks, таблица областей

В сохранённом графе: 52 инструкций. Чтение: #6C74, #6C75, #6C78, #6C7A, #6EC5. Запись: #6C7C. Вызовы: #6A56, #6BEB.

### Loader.Menu.EndMenu

Адрес #6B32, блок `CTPM`. [Source/Loader/Menu/EndMenu.asm](../Source/Loader/Menu/EndMenu.asm#L15).

завершение выбора пункта меню

Восстанавливает фон курсора, снимает подсветку всех областей сравнением с заведомо внешними координатами и воспроизводит короткий звуковой отклик.

**Вход:** состояние активного меню

**Выход:** курсор и подсветка убраны

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, AF'

**Дополнительно:** экран, порт #FE

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6938, #698A, #6BB4.

### Loader.Menu.ReadControls

Адрес #6B40, блок `CTPM`. [Source/Loader/Menu/ReadControls.asm](../Source/Loader/Menu/ReadControls.asm#L15).

объединённый опрос клавиатуры и Kempston

Опросом четырёх наборов по пять кодов получает пять логических кнопок. Объединяет состояния OR. Kempston учитывает только если IN (#1F) не равен #FF.

**Вход:** порты клавиатуры и Kempston

**Выход:** C и A — маска, bit 0 действие, bit 1 вниз, bit 2 вверх, bit 3 вправо, bit 4 влево

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** нет записи

В сохранённом графе: 28 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6B72.

### Loader.Menu.ReadKeyCodes

Адрес #6B72, блок `CTPM`. [Source/Loader/Menu/ReadKeyCodes.asm](../Source/Loader/Menu/ReadKeyCodes.asm#L15).

опрос последовательности упакованных кодов кнопок

**Вход:** HL — коды кнопок, B — число кодов, C — аккумулятор битов

**Выход:** C — собранные биты, HL — следующий код, B=0

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 34 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Loader.Menu.WaitRelease

Адрес #6BA1, блок `CTPM`. [Source/Loader/Menu/WaitRelease.asm](../Source/Loader/Menu/WaitRelease.asm#L14).

ожидание отпускания кнопки действия

Повторяет опрос до сброса bit 0 в C.

**Вход:** нет регистровых аргументов, #6C5F..#6C72 содержат четыре набора назначений пяти действий, доступны настроенные порты клавиатуры/джойстика

**Выход:** B=0, бит 0 C=0, Z=1 после проверки кнопки, остальные биты C содержат результат последнего опроса

**Изменяемые регистры и состояние:** HL, DE, BC, AF. HL', DE', BC', AF', IX, IY сохранены

В сохранённом графе: 4 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6B40.

### Loader.Menu.WaitPress

Адрес #6BA9, блок `CTPM`. [Source/Loader/Menu/WaitPress.asm](../Source/Loader/Menu/WaitPress.asm#L14).

ожидание нового нажатия кнопки действия

Сначала ждёт отпускания, затем повторяет опрос до установки bit 0 в C.

**Вход:** нет регистровых аргументов, #6C5F..#6C72 содержат назначения действий, доступны настроенные порты клавиатуры/джойстика

**Выход:** после отпускания зафиксировано новое нажатие, B=0, бит 0 C=1, Z=0, остальные биты C содержат результат последнего опроса

**Изменяемые регистры и состояние:** HL, DE, BC, AF. HL', DE', BC', AF', IX, IY сохранены

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6B40, #6BA1.

### Loader.Menu.MenuClick

Адрес #6BB4, блок `CTPM`. [Source/Loader/Menu/MenuClick.asm](../Source/Loader/Menu/MenuClick.asm#L17).

короткий звуковой отклик меню

Задаёт D=10, E=5 и переходит к общему биперу Beep.

**Вход:** нет регистровых аргументов, бит 0 MenuState.SoundFlags разрешает звук, MenuState.PortFE — начальный байт порта #FE, MenuState.BeepRandom и R участвуют в псевдослучайной задержке

**Выход:** при разрешённом звуке выведено 10 импульсов, D=0, E=5, B=0. При выключенном звуке немедленный возврат, DE=#0A05. HL и C сохранены

**Изменяемые регистры и состояние:** DE, BC, AF, AF'. HL, C, HL', DE', BC', IX, IY сохранены, C внутри пары BC не изменяется

**Дополнительно:** порт #FE при разрешённом звуке

В сохранённом графе: 2 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6BC1.

### Loader.Menu.BeepShortDelay

Адрес #6BB9, блок `CTPM`. [Source/Loader/Menu/BeepShortDelay.asm](../Source/Loader/Menu/BeepShortDelay.asm#L16).

вариант биперного эффекта с параметрами D=96, E=8

Задаёт параметры и переходит к Beep. Прямой вызывающий код внутри исследованного меню не найден.

**Вход:** нет регистровых аргументов, бит 0 MenuState.SoundFlags разрешает звук, MenuState.PortFE — начальный байт порта #FE, MenuState.BeepRandom и R участвуют в псевдослучайной задержке

**Выход:** при разрешённом звуке выведено 96 импульсов, D=0, E=8, B=0. При выключенном звуке немедленный возврат, DE=#6008. HL и C сохранены

**Изменяемые регистры и состояние:** DE, BC, AF, AF'. HL, C, HL', DE', BC', IX, IY сохранены, C внутри пары BC не изменяется

В сохранённом графе: 2 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6BC1.

### Loader.Menu.BeepLongDelay

Адрес #6BBE, блок `CTPM`. [Source/Loader/Menu/BeepLongDelay.asm](../Source/Loader/Menu/BeepLongDelay.asm#L16).

вариант биперного эффекта с параметрами D=64, E=127

Задаёт параметры и переходит к Beep. Прямой вызывающий код внутри исследованного меню не найден.

**Вход:** нет регистровых аргументов, бит 0 MenuState.SoundFlags разрешает звук, MenuState.PortFE — начальный байт порта #FE, MenuState.BeepRandom и R участвуют в псевдослучайной задержке

**Выход:** при разрешённом звуке выведено 64 импульсов, D=0, E=127, B=0. При выключенном звуке немедленный возврат, DE=#407F. HL и C сохранены

**Изменяемые регистры и состояние:** DE, BC, AF, AF'. HL, C, HL', DE', BC', IX, IY сохранены, C внутри пары BC не изменяется

В сохранённом графе: 1 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Loader.Menu.Beep

Адрес #6BC1, блок `CTPM`. [Source/Loader/Menu/Beep.asm](../Source/Loader/Menu/Beep.asm#L16).

биперный эффект с псевдослучайной задержкой

Проверяет bit 0 MenuState.SoundFlags. Если звук включён, выводит MenuState.PortFE на порт #FE, чередует bit 4 через AF'. Между импульсами выдерживает задержку (случайный байт AND #7F)+E. D задаёт число импульсов.

**Вход:** D — число импульсов, E — добавка к задержке

**Выход:** при выключенном звуке немедленный возврат

**Изменяемые регистры и состояние:** DE, BC, AF, AF'

**Дополнительно:** порт #FE, MenuState.BeepRandom

В сохранённом графе: 16 инструкций. Чтение: #6C4B, #6C4C. Запись: не выделена. Вызовы: #6BDC.

### Loader.Menu.RandomByte

Адрес #6BDC, блок `CTPM`. [Source/Loader/Menu/RandomByte.asm](../Source/Loader/Menu/RandomByte.asm#L14).

получение псевдослучайного байта для бипера

Увеличивает указатель MenuState.BeepRandom, сбрасывает bit 5 H и возвращает XOR байта памяти с R. Использование R связывает результат с исполнением команд.

**Вход:** MenuState.BeepRandom — указатель

**Выход:** A — псевдослучайное значение, HL сохранён

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 9 инструкций. Чтение: #6C49. Запись: #6C49. Вызовы: не выделены.

### Loader.Menu.WaitCursorFrame

Адрес #6BEB, блок `CTPM`. [Source/Loader/Menu/WaitCursorFrame.asm](../Source/Loader/Menu/WaitCursorFrame.asm#L16).

ожидание одного прерывания с обновлением курсора

HALT оставляет адрес возврата #6BEC. Обработчик MenuInterrupt узнаёт этот адрес и вызывает TickCursor, поэтому курсор обновляется только в данном ожидании.

**Вход:** IM 2 уже установлен, прерывания разрешены

**Выход:** после прерывания RET

**Изменяемые регистры и состояние:** сохранённые обработчиком основные регистры не меняются

**Дополнительно:** AY, экран в обработчике

В сохранённом графе: 2 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Loader.Menu.TickCursor

Адрес #6BED, блок `CTPM`. [Source/Loader/Menu/TickCursor.asm](../Source/Loader/Menu/TickCursor.asm#L16).

обновление курсора и подсветки в прерывании

Восстанавливает фон старой позиции, переносит следующую позицию MenuState.NextXY в MenuState.CursorXY, обновляет подсветку, сохраняет фон новой позиции и рисует курсор.

**Вход:** MenuState.CursorXY — старая, MenuState.NextXY — новая позиция

**Выход:** новый курсор на экране

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

**Дополнительно:** MenuState.CursorXY, #6C31, экран

В сохранённом графе: 14 инструкций. Чтение: #6C76. Запись: #6C74. Вызовы: #6938, #698A, #69D8.

### Loader.Menu.DrawWindow

Адрес #6C86, блок `CTPM`. [Source/Loader/Menu/DrawWindow.asm](../Source/Loader/Menu/DrawWindow.asm#L19).

рисование окна по дескриптору

**Вход:** IX — x, y, ширина, высота, атрибут тени, атрибут окна, отступ текста, заголовок с нулём

**Выход:** #6EC5 — активное окно, #6EC7..#6ECB — параметры печати

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX сохраняет адрес дескриптора

**Дополнительно:** экран и параметры печати

В сохранённом графе: 102 инструкций. Чтение: не выделено. Запись: #6EC5, #6EC7, #6EC8, #6EC9, #6ECA, #6ECB. Вызовы: #6D37, #6D4D, #6D67, #6E43, #6E55, #6E9B.

### Loader.Menu.DrawHBorder

Адрес #6D37, блок `CTPM`. [Source/Loader/Menu/DrawHBorder.asm](../Source/Loader/Menu/DrawHBorder.asm#L15).

рисование горизонтальной границы окна

Вычисляет пиксельную строку 8*A+E и x=8*B, заполняет #FF число экранных байтов, равное ширине окна.

**Вход:** A — символьная строка, B — символьный столбец, E — поправка, IX — окно

**Выход:** линия выведена

**Изменяемые регистры и состояние:** HL, BC, AF

**Дополнительно:** экран

В сохранённом графе: 16 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6E9B.

### Loader.Menu.FillWindowAttrs

Адрес #6D4D, блок `CTPM`. [Source/Loader/Menu/FillWindowAttrs.asm](../Source/Loader/Menu/FillWindowAttrs.asm#L14).

заполнение прямоугольника атрибутов окна

По размерам IX+2/IX+3 проходит строки и столбцы, записывая A в вычисленные адреса атрибутов.

**Вход:** A — атрибут, B — столбец, C — строка, IX — окно

**Выход:** прямоугольник заполнен

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** атрибуты экрана

В сохранённом графе: 16 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6E71.

### Loader.Menu.PrintString

Адрес #6D67, блок `CTPM`. [Source/Loader/Menu/PrintString.asm](../Source/Loader/Menu/PrintString.asm#L16).

печать строки с управляющими кодами

Читает до нуля. #16 задаёт абсолютные пиксельные координаты x, y. #17 задаёт смещения от начала текста, x на 6 пикселей на знак, y на 8 на строку. #18 печатает вложенную строку по следующему 16-битному адресу. #10 меняет атрибут. Остальные байты передаёт выводу знака.

**Вход:** HL — строка

**Выход:** HL — байт после терминатора

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** экран, PixelAddress.TextAttr/PixelAddress.TextY/PixelAddress.TextX

В сохранённом графе: 53 инструкций. Чтение: #6EC8, #6EC9. Запись: #6EC7, #6ECA, #6ECB. Вызовы: #6D67, #6DBD, #6E90.

### Loader.Menu.PrintChar

Адрес #6DBD, блок `CTPM`. [Source/Loader/Menu/PrintChar.asm](../Source/Loader/Menu/PrintChar.asm#L15).

печать одного знака шестипиксельного шрифта

Для CR=#0D возвращает x к началу и увеличивает y на 8. Для остальных кодов берёт 8 байтов по FontGlyphs+8*(A-#20), выводит их со сдвигом, задаёт атрибут символьной ячейки и увеличивает x на 6.

**Вход:** A — код знака, параметры PixelAddress.TextAttr..PixelAddress.TextX

**Выход:** следующая позиция печати

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** экран, PixelAddress.TextX

В сохранённом графе: 35 инструкций. Чтение: #6EC7, #6EC9, #6ECA, #6ECB. Запись: #6ECA, #6ECB. Вызовы: #6E71, #6F11.

### Loader.Menu.StartGame

Адрес #6E07, блок `CTPM`. [Source/Loader/Menu/StartGame.asm](../Source/Loader/Menu/StartGame.asm#L23).

загрузка стартового блока игры и удаление скрытого меню

**Вход:** файл KB.co/C, #6672 — исходный привод

**Выход:** управление #6149 после ROM-копирования, обычного возврата нет

**Изменяемые регистры и состояние:** HL, DE, BC, AF, SP, состояние TR-DOS

**Дополнительно:** самоуничтожение меню, очистка памяти, код игры в #6149

В сохранённом графе: 24 инструкций. Чтение: #5CE8, #6672. Запись: не выделена. Вызовы: #65DE, #6666.

### Loader.Menu.SwapAttrStrip

Адрес #6E43, блок `CTPM`. [Source/Loader/Menu/SwapAttrStrip.asm](../Source/Loader/Menu/SwapAttrStrip.asm#L15).

обмен цветов INK и PAPER в полосе атрибутов

Сохраняет BC, получает адрес по столбцу E и строке D. Для A последовательных ячеек меняет цвета через SwapAttrColors.

**Вход:** D — строка, E — столбец, A — длина

**Выход:** BC сохранён, HL после полосы

**Изменяемые регистры и состояние:** HL, DE, AF

**Дополнительно:** атрибуты экрана

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6E55, #6E71.

### Loader.Menu.SwapAttrColors

Адрес #6E55, блок `CTPM`. [Source/Loader/Menu/SwapAttrColors.asm](../Source/Loader/Menu/SwapAttrColors.asm#L12).

обмен INK и PAPER одного атрибута

Меняет местами биты 0..2 и 3..5, сохраняет BRIGHT bit 6. FLASH bit 7 сбрасывается.

**Вход:** A — исходный атрибут

**Выход:** A — преобразованный атрибут, BC сохранён

**Изменяемые регистры и состояние:** DE, AF

В сохранённом графе: 19 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Loader.Menu.AttrAddress

Адрес #6E71, блок `CTPM`. [Source/Loader/Menu/AttrAddress.asm](../Source/Loader/Menu/AttrAddress.asm#L12).

адрес атрибута по символьным координатам

Вычисляет #5800+(C AND #1F)*32+(B AND #1F) побитовым разложением строки. AF сохраняется.

**Вход:** B — столбец, C — строка

**Выход:** HL — адрес атрибута, AF сохранён

**Изменяемые регистры и состояние:** HL

В сохранённом графе: 22 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Loader.Menu.MulSix

Адрес #6E90, блок `CTPM`. [Source/Loader/Menu/MulSix.asm](../Source/Loader/Menu/MulSix.asm#L13).

умножение беззнакового байта на 6 по модулю 256

Повторяет сложение 6 после установки A=#FA. При исходном A=#FF счётчик B оборачивается и даёт 256 итераций, что также сохраняет модульный результат.

**Вход:** A — множитель

**Выход:** A=6*исходное A mod 256, BC сохранён

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 8 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Loader.Menu.PixelAddress

Адрес #6E9B, блок `CTPM`. [Source/Loader/Menu/PixelAddress.asm](../Source/Loader/Menu/PixelAddress.asm#L12).

адрес пиксельного байта и положение бита на экране ZX Spectrum

Разлагает y на трети, строку знакоместа и строку пикселей. Добавляет x/8 к младшему байту.

**Вход:** B — x, C — y

**Выход:** HL=#4000+((y AND #C0)<<5)+((y AND 7)<<8)+((y AND #38)<<2)+(x>>3), A=(NOT x) AND 7

**Изменяемые регистры и состояние:** HL, AF

В сохранённом графе: 28 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Loader.Menu.DrawShiftedRow

Адрес #6ECC, блок `CTPM`. [Source/Loader/Menu/DrawShiftedRow.asm](../Source/Loader/Menu/DrawShiftedRow.asm#L16).

вывод строки байтов со сдвигом по горизонтали

Строит маски по позиции A. Каждый байт источника DE разбивает между текущим и следующим экранным байтом, сохраняя соседние биты. Последний фрагмент при A=7 целиком находится в текущем байте. Повторяет B раз.

**Вход:** HL — экран, DE — данные, B — число байтов, A — обратная позиция бита 0..7

**Выход:** DE после данных, HL после выведенных байтов, B=0

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** экран, PrintChar.LeftMask..PrintChar.BitPosition

В сохранённом графе: 45 инструкций. Чтение: #6E04, #6E05, #6E06. Запись: #6E04, #6E05, #6E06. Вызовы: не выделены.

### Loader.Menu.DrawByteRect

Адрес #6F11, блок `CTPM`. [Source/Loader/Menu/DrawByteRect.asm](../Source/Loader/Menu/DrawByteRect.asm#L15).

вывод прямоугольника байтов в пиксельных координатах

Для каждой строки преобразует координаты HL в адрес экрана, вызывает сдвинутую запись B байтов, затем увеличивает y. Число строк задаёт C.

**Вход:** H — x, L — y, B — ширина в байтах, C — высота в пикселях, DE — источник

**Выход:** L увеличен на высоту, C=0, DE после данных

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** экран, PrintChar.LeftMask..PrintChar.BitPosition

В сохранённом графе: 14 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6E9B, #6ECC.

## Music.Menu

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #E000 | `Music.Menu.InitMenuMusic` | внешний вход запуска музыки скрытого меню | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L19) |
| #E006 | `Music.Menu.TickMenuMusic` | внешний вход одного тика AY-проигрывателя | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L36) |
| #E009 | `Music.Menu.InitPlayer` | инициализация проигрывателя по адресу модуля | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L56) |
| #E0AF | `Music.Menu.FindTableEntry` | поиск записи с заданным первым байтом в таблице фиксированного шага | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L155) |
| #E0B5 | `Music.Menu.ReadRelPointer` | чтение относительного указателя музыкального модуля | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L172) |
| #E0BA | `Music.Menu.RelocatePtr` | преобразование относительного смещения в абсолютный адрес | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L189) |
| #E0C0 | `Music.Menu.ReadSampleStep` | разбор трёхбайтового шага музыкального семпла | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L208) |
| #E0F8 | `Music.Menu.NextPattern` | переход на следующую позицию композиции | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L264) |
| #E139 | `Music.Menu.StepDuration` | обновление задержки чтения команд канала | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L312) |
| #E144 | `Music.Menu.TickPlayer` | один временной шаг композиции | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L333) |
| #E198 | `Music.Menu.DecodeChannel` | интерпретатор команд музыкального канала | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L386) |
| #E235 | `Music.Menu.StepSample` | продвижение позиции семпла и обработка его повтора | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L495) |
| #E269 | `Music.Menu.StoreNoise` | обновление общего параметра шума в начале семпла | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L543) |
| #E271 | `Music.Menu.ApplyEnvelope` | применение аппаратной огибающей к амплитуде канала | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L565) |
| #E28E | `Music.Menu.BuildAYState` | расчёт трёх каналов и общего буфера регистров AY | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L600) |
| #E332 | `Music.Menu.CalcTonePeriod` | расчёт периода ноты с орнаментом и смещением семпла | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L690) |
| #E41F | `Music.Menu.WriteAY` | передача буфера регистров в AY | [Source/Loader/Music.asm](../Source/Loader/Music.asm#L767) |

### Music.Menu.InitMenuMusic

Адрес #E000, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L19).

внешний вход запуска музыки скрытого меню

Задаёт адрес встроенного музыкального модуля WriteAY.SongData и переходит к общему инициализатору.

**Вход:** нет явных аргументов

**Выход:** плеер инициализирован, EI

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX согласно последующим вызовам

**Дополнительно:** состояние плеера и AY

В сохранённом графе: 2 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #E009.

### Music.Menu.TickMenuMusic

Адрес #E006, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L36).

внешний вход одного тика AY-проигрывателя

Переходит к TickPlayer. Вызывается один раз на прерывание из #6429.

**Вход:** нет регистровых аргументов, плеер ранее инициализирован через InitMenuMusic/InitPlayer, состояние InitPlayer.PositionTable..InitPlayer.EnvelopeShape и музыкальные потоки доступны по сохранённым указателям

**Выход:** следующий музыкальный кадр рассчитан и передан AY, HL', DE', BC', AF', IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены

**Дополнительно:** состояние плеера, AY

В сохранённом графе: 1 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #E144.

### Music.Menu.InitPlayer

Адрес #E009, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L56).

инициализация проигрывателя по адресу модуля

**Вход:** HL — музыкальный модуль

**Выход:** инициализированы три канала, EI

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** #E070..#E0AE, #E0BB

В сохранённом графе: 44 инструкций. Чтение: не выделено. Запись: #E070, #E072, #E074, #E076, #E078, #E079, #E07A, #E07B, #E089, #E08B, #E093, #E095, #E09D, #E09F, #E0BB. Вызовы: #E0AF, #E0B5, #E0BA, #E41F.

### Music.Menu.FindTableEntry

Адрес #E0AF, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L155).

поиск записи с заданным первым байтом в таблице фиксированного шага

Сравнивает A с (HL), при несовпадении прибавляет BC и повторяет. Ограничение длины таблицы отсутствует.

**Вход:** A — ключ, HL — начало, BC — шаг

**Выход:** HL — совпавшая запись, Z=1

**Изменяемые регистры и состояние:** HL, AF

В сохранённом графе: 4 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Music.Menu.ReadRelPointer

Адрес #E0B5, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L172).

чтение относительного указателя музыкального модуля

Берёт little-endian слово из (HL), увеличивает исходный HL на 2, прибавляет к слову базу модуля через RelocatePtr.

**Вход:** HL — адрес относительного слова

**Выход:** DE — абсолютный указатель, HL — следующие данные

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Music.Menu.RelocatePtr

Адрес #E0BA, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L189).

преобразование относительного смещения в абсолютный адрес

Прибавляет к HL базовый адрес из самомодифицируемого операнда RelocatePtr.ModuleBase и меняет HL с DE.

**Вход:** HL — смещение, DE — сохраняемое значение

**Выход:** DE — абсолютный адрес, HL — прежний DE

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 4 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Music.Menu.ReadSampleStep

Адрес #E0C0, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L208).

разбор трёхбайтового шага музыкального семпла

Прибавляет 3*A к IX. Из трёх байтов извлекает амплитуду, величину и знак тонового смещения, пятибитовый параметр шума, флаги отключения тона и шума. Конкретная разметка следует битам команд, название формата по одному коду не подтверждено.

**Вход:** IX — семпл, A — номер шага

**Выход:** L — амплитуда 0..15, DE — тоновое смещение с признаком знака в bit 4 D, H — параметр шума, C — маска отключения шума, B — маска отключения тона

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

В сохранённом графе: 33 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Music.Menu.NextPattern

Адрес #E0F8, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L264).

переход на следующую позицию композиции

Берёт индекс InitPlayer.PositionIndex, при достижении числа позиций InitPlayer.PositionCount возвращает его к 0. По таблице позиций получает номер паттерна и транспозицию, находит семибайтовый дескриптор паттерна и вычисляет три указателя каналов.

**Вход:** таблицы InitPlayer.PositionTable/InitPlayer.PatternTable и индекс InitPlayer.PositionIndex

**Выход:** обновлены InitPlayer.PatternA/InitPlayer.PatternB/InitPlayer.PatternC и транспозиция CalcTonePeriod.Transpose

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** индекс позиции и указатели паттерна

В сохранённом графе: 30 инструкций. Чтение: #E070, #E074, #E0A0. Запись: #E07B, #E07D, #E07F, #E0A0, #E344. Вызовы: #E0AF, #E0B5.

### Music.Menu.StepDuration

Адрес #E139, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L312).

обновление задержки чтения команд канала

Уменьшает IX+2. Пока значение неотрицательно, возвращается. При переходе через ноль загружает IX-1, оставляя флаг знака от DEC для вызывающего кода.

**Вход:** IX — состояние канала

**Выход:** S=1 означает наступление чтения новой команды

**Изменяемые регистры и состояние:** AF

**Дополнительно:** IX+2

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Music.Menu.TickPlayer

Адрес #E144, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L333).

один временной шаг композиции

Уменьшает общий счётчик тиков. Когда он равен нулю, восстанавливает темп и обновляет команды трёх каналов. В первом канале #FF запускает следующую позицию композиции. Затем в любом случае рассчитывает состояния семплов и регистры AY через BuildAYState.

**Вход:** состояние InitPlayer.PositionTable..InitPlayer.EnvelopeShape

**Выход:** один кадр музыки

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

**Дополнительно:** каналы, указатели паттернов, AY

В сохранённом графе: 29 инструкций. Чтение: #E078, #E079, #E07B, #E07D, #E07F. Запись: #E079, #E07B, #E07D, #E07F. Вызовы: #E0F8, #E139, #E198, #E28E.

### Music.Menu.DecodeChannel

Адрес #E198, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L386).

интерпретатор команд музыкального канала

Коды <#60 задают ноту и запускают семпл на 32 шага. #60..#6F выбирают семпл по записям #63 байта. #70..#7F выбирают орнамент по записям #21 байт. #80 отключает канал, #81 пропускает строку, #82 выбирает нулевой орнамент. #83..#8E задают форму огибающей и её период из следующего байта. Остальные коды задают задержку A-#A1 и продолжают разбор.

**Вход:** HL — поток команд, IX — состояние канала

**Выход:** HL — следующая команда после музыкальной строки

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** канал, параметры огибающей InitPlayer.Envelope/InitPlayer.EnvelopeShape

В сохранённом графе: 69 инструкций. Чтение: #E072, #E076. Запись: #E0AC, #E0AE. Вызовы: #E0AF.

### Music.Menu.StepSample

Адрес #E235, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L495).

продвижение позиции семпла и обработка его повтора

**Вход:** IX — состояние канала

**Выход:** C — номер шага семпла при активном канале

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** IX+0, IX+7

В сохранённом графе: 32 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Music.Menu.StoreNoise

Адрес #E269, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L543).

обновление общего параметра шума в начале семпла

Если C=0, переносит H в InitPlayer.Noise, иначе возвращается без записи.

**Вход:** C — шаг семпла, H — шумовой параметр

**Выход:** при C=0 записано InitPlayer.Noise=H и A=H, Z=1. При C!=0 запись не выполняется, A=C и Z=0. CF=0 в обеих ветвях

**Изменяемые регистры и состояние:** AF. HL, DE, BC, HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** InitPlayer.Noise при C=0

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: #E0A7. Вызовы: не выделены.

### Music.Menu.ApplyEnvelope

Адрес #E271, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L565).

применение аппаратной огибающей к амплитуде канала

Для активного канала проверяет IX-2. При первом применении переводит состояние 1 в 2. При повторе обнуляет флаг записи формы огибающей InitPlayer.EnvelopeShape. Устанавливает bit 4 в байте громкости по HL.

**Вход:** IX — канал, HL — регистр громкости в буфере

**Выход:** bit 4 громкости включает огибающую AY

**Изменяемые регистры и состояние:** AF

**Дополнительно:** IX-2, (HL), InitPlayer.EnvelopeShape

В сохранённом графе: 14 инструкций. Чтение: не выделено. Запись: #E0AE. Вызовы: не выделены.

### Music.Menu.BuildAYState

Адрес #E28E, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L600).

расчёт трёх каналов и общего буфера регистров AY

**Вход:** состояния трёх каналов и таблицы композиции

**Выход:** #E0A1..#E0AE — значения AY 0..13

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

**Дополнительно:** каналы, AY

В сохранённом графе: 63 инструкций. Чтение: #E087, #E091, #E09B, #E0A8. Запись: #E0A1, #E0A3, #E0A5, #E0A8, #E33C. Вызовы: #E0C0, #E235, #E269, #E271, #E332, #E41F.

### Music.Menu.CalcTonePeriod

Адрес #E332, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L690).

расчёт периода ноты с орнаментом и смещением семпла

Читает байт орнамента по позиции текущего шага, прибавляет ноту канала и транспозицию из CalcTonePeriod.Transpose. По индексу выбирает слово из CalcTonePeriod.NotePeriods и прибавляет либо вычитает тоновое смещение DE согласно bit 4 D.

**Вход:** IX — канал, L — амплитуда, DE — смещение семпла, самомодифицируемый CalcTonePeriod.OrnamentStep — номер шага

**Выход:** HL — итоговый период, A — исходная амплитуда

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** нет записи кроме внешней подготовки операндов

В сохранённом графе: 29 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Music.Menu.WriteAY

Адрес #E41F, блок `CTPA`. [Source/Loader/Music.asm](../Source/Loader/Music.asm#L767).

передача буфера регистров в AY

Если InitPlayer.EnvelopeShape ненулевой, пишет регистры 13..0. Если нулевой, начинает с регистра 10 и буфера InitPlayer.VolumeC, сохраняя прежние параметры аппаратной огибающей AY 11..13. Для каждого регистра выбирает адрес через #FFFD и пишет значение через #BFFD.

**Вход:** InitPlayer.ToneA..InitPlayer.EnvelopeShape — AY-регистры, InitPlayer.EnvelopeShape — флаг/форма огибающей

**Выход:** AY обновлён

**Изменяемые регистры и состояние:** HL, BC, AF

**Дополнительно:** порты #FFFD/#BFFD

В сохранённом графе: 17 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

## Startup

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #6149 | `Startup.DecodeBoot` | расшифровать начальный модуль перед передачей управления | [Source/Startup/DecodeBoot.asm](../Source/Startup/DecodeBoot.asm#L16) |
| #615E | `Startup.Entry` | передать управление начальной настройке игры | [Source/Startup/Entry.asm](../Source/Startup/Entry.asm#L13) |
| #6161 | `Startup.Interrupt` | обработать кадровое прерывание начального модуля | [Source/Startup/Interrupt.asm](../Source/Startup/Interrupt.asm#L16) |
| #631C | `Startup.Init` | настройка памяти, начальное меню и подготовка нового либо сохранённого мира | [Source/Startup/Init.asm](../Source/Startup/Init.asm#L20) |
| #65A9 | `Startup.PromptStateDisk` | показать приглашение вставить диск с состояниями и дождаться клавиши | [Source/Startup/PromptStateDisk.asm](../Source/Startup/PromptStateDisk.asm#L16) |
| #65AE | `Startup.PromptGameDisk` | показать приглашение вставить диск с игрой и дождаться клавиши | [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L15) |
| #6DBC | `Startup.CallTrdos` | вызвать TR-DOS с временным переходом в IM 1 | [Source/Startup/CallTrdos.asm](../Source/Startup/CallTrdos.asm#L14) |
| #6DD6 | `Startup.SelectStateBank` | запросить диск с состояниями и выбрать банк 1 | [Source/Startup/SelectStateBank.asm](../Source/Startup/SelectStateBank.asm#L14) |
| #6DE5 | `Startup.SetStateExt` | установить тип файла состояния M и запросить диск состояний | [Source/Startup/SetStateExt.asm](../Source/Startup/SetStateExt.asm#L12) |
| #6DEE | `Startup.DrawGlyph` | нарисовать символ шириной шесть пикселей с произвольным битовым сдвигом | [Source/Startup/DrawGlyph.asm](../Source/Startup/DrawGlyph.asm#L19) |
| #6E5B | `Startup.GlyphAddress` | вычислить экранный адрес и битовый сдвиг шестипиксельного символа | [Source/Startup/GlyphAddress.asm](../Source/Startup/GlyphAddress.asm#L14) |
| #6E88 | `Startup.DrawGlyphEI` | нарисовать символ с разрешением прерываний после переключения банка | [Source/Startup/DrawGlyphEI.asm](../Source/Startup/DrawGlyphEI.asm#L15) |
| #6E97 | `Startup.DrawGlyphNoEI` | нарисовать символ без дополнительного EI в обёртке переключения банка | [Source/Startup/DrawGlyphNoEI.asm](../Source/Startup/DrawGlyphNoEI.asm#L15) |
| #6EA6 | `Startup.DrawRawSprite` | вывести непрозрачный прямоугольный спрайт с атрибутами | [Source/Startup/DrawRawSprite.asm](../Source/Startup/DrawRawSprite.asm#L16) |
| #6EFA | `Startup.ScreenCharAddr` | вычислить адрес верхней пиксельной строки знакоместа | [Source/Startup/ScreenCharAddr.asm](../Source/Startup/ScreenCharAddr.asm#L13) |
| #6F15 | `Startup.EditText` | ввести строку ограниченной длины с мигающим курсором | [Source/Startup/EditText.asm](../Source/Startup/EditText.asm#L18) |
| #6F81 | `Startup.DrawEditBuffer` | перерисовать поле редактирования и стереть символ за его концом | [Source/Startup/DrawEditBuffer.asm](../Source/Startup/DrawEditBuffer.asm#L15) |
| #6FA8 | `Startup.ReadEditChar` | дождаться допустимого символа для строкового ввода | [Source/Startup/ReadEditChar.asm](../Source/Startup/ReadEditChar.asm#L16) |
| #7092 | `Startup.LoadFile` | загрузить именованный файл в заданную область через TR-DOS | [Source/Startup/LoadFile.asm](../Source/Startup/LoadFile.asm#L13) |
| #70DF | `Startup.PageAndEnable` | выбрать логический банк и разрешить прерывания | [Source/Startup/PageAndEnable.asm](../Source/Startup/PageAndEnable.asm#L14) |
| #70E4 | `Startup.DrawText` | вывести строку с нулевым терминатором и переходами строк | [Source/Startup/DrawText.asm](../Source/Startup/DrawText.asm#L14) |
| #7100 | `Startup.ClearScreen` | обнулить все пиксели и атрибуты ZX-экрана | [Source/Startup/ClearScreen.asm](../Source/Startup/ClearScreen.asm#L13) |
| #7132 | `Startup.RandomRange` | получить псевдослучайное число, масштабированное к входному пределу | [Source/Startup/RandomRange.asm](../Source/Startup/RandomRange.asm#L16) |
| #7196 | `Startup.TickIntroText` | периодический вывод и прокрутка текста во время создания новой игры | [Source/Startup/TickIntroText.asm](../Source/Startup/TickIntroText.asm#L19) |
| #7220 | `Startup.DrawFrame` | рисование рамки из восьми одноклеточных образцов с атрибутами | [Source/Startup/DrawFrame.asm](../Source/Startup/DrawFrame.asm#L17) |
| #7311 | `Startup.RestoreScreen` | восстановление полного экрана из сохранённого фона в банк 4 | [Source/Startup/RestoreScreen.asm](../Source/Startup/RestoreScreen.asm#L15) |
| #732A | `Startup.FindSaveRecord` | поиск N-й неудалённой записи типа M в буфере каталога | [Source/Startup/FindSaveRecord.asm](../Source/Startup/FindSaveRecord.asm#L15) |
| #7347 | `Startup.ListSaveNames` | вывод страницы до пятнадцати имён сохранений | [Source/Startup/ListSaveNames.asm](../Source/Startup/ListSaveNames.asm#L17) |
| #7386 | `Startup.DrawHeroStory` | вывод текстового описания выбранного героя из HERTXT | [Source/Startup/DrawHeroStory.asm](../Source/Startup/DrawHeroStory.asm#L15) |
| #73B0 | `Startup.DrawMenuCursor` | рисование курсора в новой позиции с выравниванием маски | [Source/Startup/DrawMenuCursor.asm](../Source/Startup/DrawMenuCursor.asm#L17) |
| #73EF | `Startup.CursorByteAddr` | адрес экранного пиксельного байта по координатам курсора | [Source/Startup/CursorByteAddr.asm](../Source/Startup/CursorByteAddr.asm#L13) |
| #7416 | `Startup.DrawCursorByte` | маскированная запись одного байта курсора | [Source/Startup/DrawCursorByte.asm](../Source/Startup/DrawCursorByte.asm#L16) |
| #7429 | `Startup.SaveCursorBack` | сохранение фона новой позиции курсора | [Source/Startup/SaveCursorBack.asm](../Source/Startup/SaveCursorBack.asm#L15) |
| #7444 | `Startup.RestoreCursor` | восстановление фона старой позиции курсора | [Source/Startup/RestoreCursor.asm](../Source/Startup/RestoreCursor.asm#L15) |
| #7461 | `Startup.ChooseMenuRect` | выбор прямоугольной области меню пиксельным курсором | [Source/Startup/ChooseMenuRect.asm](../Source/Startup/ChooseMenuRect.asm#L21) |
| #7572 | `Startup.HitTestMenu` | поиск прямоугольника меню под пиксельным курсором | [Source/Startup/HitTestMenu.asm](../Source/Startup/HitTestMenu.asm#L14) |
| #75CA | `Startup.ToggleMenuInk` | обратимая подсветка области меню обменом INK и PAPER | [Source/Startup/ToggleMenuInk.asm](../Source/Startup/ToggleMenuInk.asm#L16) |
| #7612 | `Startup.ReadMenuInput` | опрос клавиатуры ROM и Kempston с преобразованием направлений | [Source/Startup/ReadMenuInput.asm](../Source/Startup/ReadMenuInput.asm#L16) |
| #7644 | `Startup.CursorUp` | движение курсора на один пиксель вверх в пределах меню | [Source/Startup/CursorUp.asm](../Source/Startup/CursorUp.asm#L13) |
| #7650 | `Startup.CursorDown` | движение курсора на один пиксель вниз в пределах меню | [Source/Startup/CursorDown.asm](../Source/Startup/CursorDown.asm#L12) |
| #765C | `Startup.CursorLeft` | движение курсора на один пиксель влево в пределах меню | [Source/Startup/CursorLeft.asm](../Source/Startup/CursorLeft.asm#L12) |
| #7668 | `Startup.CursorRight` | движение курсора на один пиксель вправо в пределах меню | [Source/Startup/CursorRight.asm](../Source/Startup/CursorRight.asm#L12) |
| #7674 | `Startup.RotateCursorR` | циклическое вращение 24-битных строк рисунка и маски курсора вправо | [Source/Startup/RotateCursorR.asm](../Source/Startup/RotateCursorR.asm#L17) |
| #7699 | `Startup.RotateCursorL` | циклическое вращение 24-битных строк рисунка и маски курсора влево | [Source/Startup/RotateCursorL.asm](../Source/Startup/RotateCursorL.asm#L15) |
| #770B | `Startup.InvertState` | побайтовая инверсия блока данных состояния | [Source/Startup/InvertState.asm](../Source/Startup/InvertState.asm#L16) |
| #7715 | `Startup.MarkStructures` | отметка занимаемых строениями клеток стартовых карт | [Source/Startup/MarkStructures.asm](../Source/Startup/MarkStructures.asm#L17) |
| #7746 | `Startup.MarkGroupCells` | обход записей одной группы и отметка их прямоугольного следа на карте | [Source/Startup/MarkGroupCells.asm](../Source/Startup/MarkGroupCells.asm#L19) |
| #7791 | `Startup.MarkUsedCell` | установка бита занятости клетки с восстановлением банка | [Source/Startup/MarkUsedCell.asm](../Source/Startup/MarkUsedCell.asm#L15) |
| #77A3 | `Startup.PickUnusedName` | случайный выбор ещё не использованного имени с копированием в рабочий банк | [Source/Startup/PickUnusedName.asm](../Source/Startup/PickUnusedName.asm#L19) |
| #7808 | `Startup.CreateWanderers` | создание четырёх континентальных групп случайных шестибайтовых отрядов | [Source/Startup/CreateWanderers.asm](../Source/Startup/CreateWanderers.asm#L19) |
| #78A4 | `Startup.MapCellAddress` | адрес клетки карты выбранного континента при создании игры | [Source/Startup/MapCellAddress.asm](../Source/Startup/MapCellAddress.asm#L15) |
| #78B9 | `Startup.RandomMapPos` | выбор случайных внутренних координат стратегической карты | [Source/Startup/RandomMapPos.asm](../Source/Startup/RandomMapPos.asm#L15) |
| #78D0 | `Startup.GenerateArmy` | генерация от двух до пяти трёхбайтовых отрядов по весовой таблице | [Source/Startup/GenerateArmy.asm](../Source/Startup/GenerateArmy.asm#L20) |

### Startup.DecodeBoot

Адрес #6149, блок `S04`. [Source/Startup/DecodeBoot.asm](../Source/Startup/DecodeBoot.asm#L16).

расшифровать начальный модуль перед передачей управления

после внешнего дешифрования из KB отключает прерывания и задаёт R=50, XOR с показаниями R обрабатывает 7125 байтов 615E..7D32, первый ключ 54, шаг 9 по модулю 128, последний байт файла 7D33 не меняется этим проходом

**Вход:** BL3 после внешних 15 проходов KB загружен 6149..7D33, код 6149..615D цел, регистровые аргументы не требуются

**Выход:** 615E..7D32 расшифрованы собственным R-XOR, первый ключ 54 и шаг 9 по модулю 128, последний байт 7D33 не меняется, вход в 615E с HL=7D33, BC=0, A=0, R=4F, DE, SP, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, BC, AF, R, память 615E..7D32, прерывания запрещены через DI

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Startup.Entry

Адрес #615E, блок `S04`. [Source/Startup/Entry.asm](../Source/Startup/Entry.asm#L13).

передать управление начальной настройке игры

передаёт управление инициализации 631C

**Вход:** тело BL3 расшифровано, в 615E находится JP631C

**Выход:** управление передано инициализации 631C, собственная инструкция JP сохраняет все регистры общего назначения, SP и флаги

**Изменяемые регистры и состояние:** собственных изменений общих регистров и памяти нет, R увеличивается при выборке JP

В сохранённом графе: 1 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #631C.

### Startup.Interrupt

Адрес #6161, блок `S04`. [Source/Startup/Interrupt.asm](../Source/Startup/Interrupt.asm#L16).

обработать кадровое прерывание начального модуля

сохраняет основные, альтернативные и индексные регистры и текущий банк памяти сохраняет операнды DrawGlyph.SelectCall и RestoreCall на время фоновых обработчиков EditFlags разрешает мигание текстового курсора, CursorTimer задаёт период смены CursorGlyph TickIntroText выводит текст создания игры, Rom.ScanKeys128 обслуживает клавиатуру ПЗУ 128 затем восстанавливает операнды, банк и регистры и возвращается через EI, RETI

**Вход:** аппаратный адрес возврата на стеке, установлены Memory.SelectBank и фоновые обработчики

**Выход:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY восстановлены, исходный банк восстановлен

**Изменяемые регистры и состояние:** R, IFF, CursorTimer и CursorGlyph при разрешённом мигании, экран курсора и плеер

В сохранённом графе: 63 инструкций. Чтение: #5FA0, #61D0, #61D1, #61D2, #61D5, #6DFE, #6E50. Запись: #61D0, #61D1, #6DFE, #6E50. Вызовы: #386E, #5FA1, #6E97, #7196.

### Startup.Init

Адрес #631C, блок `S04`. [Source/Startup/Init.asm](../Source/Startup/Init.asm#L20).

настройка памяти, начальное меню и подготовка нового либо сохранённого мира

Загружает RAMDRIVE по каталожному адресу #7D34 и вызывает его для проверки 256 К и установки #5FA1. Устанавливает стек #629C, вектор IM 2 на #6161, очищает банк 8. Загружает шрифт, изображения и тексты. Главное меню #63AC предлагает новую игру, чтение сохранения и заставку. Ветка #63F4 читает каталог TR-DOS, считает действующие .M, строит страницы по 15 имён, затем читает состояние героя и три блока сохранения, восстанавливая их инверсией. Ветка #65DF выбирает героя, сложность, имя файла и проверяет его совпадение с существующим. Для нового мира загружает PERSONn, формирует начальные армии, объекты и карты. В конце подготавливает банки состояния, загружает head.co и передаёт ему управление. Загрузка HERIMG перекрывает последний байт исходного BL3 по #7D33, поэтому CALL #7D33 относится к графическому распаковщику другого файла.

**Вход:** IY=#5C3A, доступный TR-DOS и 256 К по одной из поддерживаемых схем

**Выход:** инициализированное состояние для head.co либо повтор начального меню

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY

В сохранённом графе: 996 инструкций. Чтение: #5C78, #5C79, #5CEB, #5CF4, #6CAD, #6CD6, #6CD7, #7385, #7931, #7932, #7972, #7998, #7D35. Запись: #5CE5, #5D10, #62D1, #62E4, #630F, #631A, #692A, #6B80, #6CAD, #6CD7, #7190, #7192, #7194, #7219, #7384, #7385, #7931, #7932, #797C, #7988, #798A, #798F, #7991, #7996, #7998, #7D35. Вызовы: #3D13, #5FA1, #65AE, #6DBC, #6DD6, #6DE5, #6EA6, #6F15, #7092, #70DF, #70E4, #7100, #7132, #7220, #7311, #732A, #7347, #7386, #7461, #770B, #7715, #77A3, #7808, #78A4, #78B9, #78D0, #7D33, #7D34, #E200.

### Startup.PromptStateDisk

Адрес #65A9, блок `S04`. [Source/Startup/PromptStateDisk.asm](../Source/Startup/PromptStateDisk.asm#L16).

показать приглашение вставить диск с состояниями и дождаться клавиши

задаёт DE=70A7 со строкой приглашения и переходит на общую часть 65B1, она восстанавливает экран из банка 4 через 7311, заполняет нижнюю строку атрибутов 5AE0..5AFF значением 42, выводит текст через 70E4 в строке 23, столбце 5, затем IN (FE) с A=0 ожидает отпускания всех клавиш и нового нажатия

**Вход:** регистровых аргументов нет, в логическом банке 4 сохранён экран, установлены RAMDRIVE5FA1 и клавиатурный порт FE

**Выход:** диск может быть сменён пользователем, возврат после нового нажатия

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 24 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #70E4, #7311.

### Startup.PromptGameDisk

Адрес #65AE, блок `S04`. [Source/Startup/PromptGameDisk.asm](../Source/Startup/PromptGameDisk.asm#L15).

показать приглашение вставить диск с игрой и дождаться клавиши

задаёт DE=6D91, далее общая часть 65B1 восстанавливает экран из банка 4, выводит приглашение в нижней строке, ждёт полного отпускания клавиатуры и следующего нажатия, матрица опрашивается как NOT IN(00FE) AND1F

**Вход:** регистровых аргументов нет, в логическом банке 4 сохранён экран, установлены RAMDRIVE5FA1 и клавиатурный порт FE

**Выход:** возврат после нового нажатия клавиши

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 23 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #70E4, #7311.

### Startup.CallTrdos

Адрес #6DBC, блок `S04`. [Source/Startup/CallTrdos.asm](../Source/Startup/CallTrdos.asm#L14).

вызвать TR-DOS с временным переходом в IM 1

DI, IY=5C3A, входной AF сохраняется вокруг установки I=3F, затем IM1 и EI, вызывается 3D13 с исходными A и остальными параметрами, после возврата DI, I=60, IM2, EI, исходный IY не восстанавливается, A к выходу равен 60

**Вход:** A и остальные регистры по контракту функции TR-DOS в C

**Выход:** результат выбранной функции TR-DOS, IY=5C3A, I=60, IM2, прерывания разрешены

**Изменяемые регистры и состояние:** регистры по контракту TR-DOS, AF, IY, I и режим прерываний

В сохранённом графе: 15 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #3D13.

### Startup.SelectStateBank

Адрес #6DD6, блок `S04`. [Source/Startup/SelectStateBank.asm](../Source/Startup/SelectStateBank.asm#L14).

запросить диск с состояниями и выбрать банк 1

вызывает 65A9 для приглашения и ожидания клавиши, затем A=1 и хвостовой JP5FA1 выбирает логический банк 1, возврат выполняет RAMDRIVE

**Вход:** регистровых аргументов нет, подготовлен экран банка 4, доступны клавиатура и RAMDRIVE для выбора банка 1

**Выход:** выбран логический банк 1

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 3 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #65A9.

### Startup.SetStateExt

Адрес #6DE5, блок `S04`. [Source/Startup/SetStateExt.asm](../Source/Startup/SetStateExt.asm#L12).

установить тип файла состояния M и запросить диск состояний

записывает байт 4D по DE, затем хвостовой JP65A9 показывает приглашение и ожидает клавиши

**Вход:** DE адрес байта расширения файла

**Выход:** (DE)=M, приглашение завершено

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 3 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #65A9.

### Startup.DrawGlyph

Адрес #6DEE, блок `S04`. [Source/Startup/DrawGlyph.asm](../Source/Startup/DrawGlyph.asm#L19).

нарисовать символ шириной шесть пикселей с произвольным битовым сдвигом

сохраняет HL, DE, BC, AF, IY, IX и текущий логический банк, код переключения банка находится в изменяемых операндах 6DFE и 6E50, выбирает банк 3 со шрифтом BF00+8*A, 6E5B получает экранный адрес и сдвиг X=6*C+2, 16-битная маска начинается 03FF и сдвигается вправо с заполнением старших битов единицами, восемь байтов символа сдвигаются в пару D,E, каждый экранный байт заменяется по формуле (экран AND маска) OR символ, строки идут INC IXh, исходный банк и регистры восстанавливаются

**Вход:** BC текстовая позиция, B строка знакомест, C шестипиксельный столбец, A код символа

**Выход:** восемь пиксельных строк символа нарисованы, регистры и логический банк сохранены

**Изменяемые регистры и состояние:** пиксели двух соседних экранных байтов на восьми строках, временно выбирается банк 3 и восстанавливается исходный, IFF зависит от выбранной обёртки 6DFE/6E50, HL, DE, BC, AF, IX, IY сохранены

В сохранённом графе: 61 инструкций. Чтение: #5F9F. Запись: не выделена. Вызовы: #6E5B, #70DF.

### Startup.GlyphAddress

Адрес #6E5B, блок `S04`. [Source/Startup/GlyphAddress.asm](../Source/Startup/GlyphAddress.asm#L14).

вычислить экранный адрес и битовый сдвиг шестипиксельного символа

первый адрес строки знакоместа B формируется через биты нелинейной ZX-развёртки, X=6*C+2, IX=4000+((B AND18)<<8)+((B AND7)<<5)+(X>>3), L=X AND7, это отдельная адресная процедура, сама экран не изменяет

**Вход:** BC позиция, B строка 0..23, C столбец шестипиксельного шрифта

**Выход:** IX адрес первого экранного байта, L сдвиг 0..7, DE=X>>3

**Изменяемые регистры и состояние:** HL, DE, AF, IX

В сохранённом графе: 31 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Startup.DrawGlyphEI

Адрес #6E88, блок `S04`. [Source/Startup/DrawGlyphEI.asm](../Source/Startup/DrawGlyphEI.asm#L15).

нарисовать символ с разрешением прерываний после переключения банка

сохраняет HL, записывает адрес 70DF в оба изменяемых операнда 6DFE и 6E50, вызывает 6DEE и восстанавливает HL, обёртка 70DF делает CALL5FA1 и EI, этот вариант используется обычным выводом текста

**Вход:** BC текстовая позиция, A код символа

**Выход:** символ нарисован, регистры сохранены, операнды вызовов настроены на 70DF

**Изменяемые регистры и состояние:** операнды 6DFE/6E50 устанавливаютсяна 70DF, пиксели символа и IFF, прерывания разрешаются, HL, DE, BC, AF, IX, IY сохранены

В сохранённом графе: 7 инструкций. Чтение: не выделено. Запись: #6DFE, #6E50. Вызовы: #6DEE.

### Startup.DrawGlyphNoEI

Адрес #6E97, блок `S04`. [Source/Startup/DrawGlyphNoEI.asm](../Source/Startup/DrawGlyphNoEI.asm#L15).

нарисовать символ без дополнительного EI в обёртке переключения банка

сохраняет HL, записывает прямой адрес 5FA1 в операнды 6DFE и 6E50, вызывает 6DEE, используется из обработчика прерывания 6161, здесь нет EI обёртки 70DF, сохранение и восстановление регистров выполняет 6DEE

**Вход:** BC текстовая позиция, A код символа

**Выход:** символ нарисован, регистры сохранены, операнды вызовов настроены на 5FA1

**Изменяемые регистры и состояние:** операнды 6DFE/6E50 устанавливаютсяна 5FA1 и пиксели символа, дополнительный EI не выполняется, HL, DE, BC, AF, IX, IY сохранены

В сохранённом графе: 7 инструкций. Чтение: не выделено. Запись: #6DFE, #6E50. Вызовы: #6DEE.

### Startup.DrawRawSprite

Адрес #6EA6, блок `S04`. [Source/Startup/DrawRawSprite.asm](../Source/Startup/DrawRawSprite.asm#L16).

вывести непрозрачный прямоугольный спрайт с атрибутами

для каждого из D рядов знакомест 6EFA получает экранный адрес, восемь пиксельных строк копируются LDIR по E байт с INC D в адресе назначения, источник IX продвигается на 8*E, после пикселей вычисляется 5800+32*B+C и копируются D строки атрибутов шириной E с шагом 32, ограничений экраном нет, все явно сохранённые регистры восстановлены

**Вход:** BC левый верхний угол в знакоместах, D высота, E ширина в знакоместах, IX пиксели и следующие атрибуты

**Выход:** 8*D*E пиксельных байтов и D*E атрибутов выведены, регистры сохранены

**Изменяемые регистры и состояние:** пиксели и атрибуты прямоугольника, HL, DE, BC, AF, IX, IY сохранены

В сохранённом графе: 63 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6EFA.

### Startup.ScreenCharAddr

Адрес #6EFA, блок `S04`. [Source/Startup/ScreenCharAddr.asm](../Source/Startup/ScreenCharAddr.asm#L13).

вычислить адрес верхней пиксельной строки знакоместа

HL=4000+((B AND18)<<8)+((B AND7)<<5)+C, BC сохраняется, это адрес для первой из восьми пиксельных строк заданного ряда знакомест

**Вход:** BC позиция в знакоместах

**Выход:** HL экранный адрес

**Изменяемые регистры и состояние:** HL, AF

В сохранённом графе: 18 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Startup.EditText

Адрес #6F15, блок `S04`. [Source/Startup/EditText.asm](../Source/Startup/EditText.asm#L18).

ввести строку ограниченной длины с мигающим курсором

сохраняет BC в 6FA3, IX буфер в 6FA5, максимальную длину A в 6FA7, текущую позицию BC в 61D2, ставит бит 5 поля 61D5 для прерывания, H хранит предел и L введённую длину, 6F81 обновляет строку, 6FA8 возвращает допустимый код, 0C удаляет предыдущий символ с заменой пробелом, 0D/0E завершают и сбрасывают бит 5, остальные коды записываются пока L<H, выходное поле не получает нулевого терминатора

**Вход:** BC позиция строки, A предел длины>0, IX буфер не короче A байтов, флаги 61D5 задают допустимый алфавит

**Выход:** буфер содержит введённые символы, A код завершения 0D/0E, L число введённых, H предел, прерывания разрешены

**Изменяемые регистры и состояние:** HL, DE, AF, IX

В сохранённом графе: 54 инструкций. Чтение: #61D2, #61D5, #6FA5. Запись: #61D2, #61D5, #6FA3, #6FA5, #6FA7. Вызовы: #6F81, #6FA8.

### Startup.DrawEditBuffer

Адрес #6F81, блок `S04`. [Source/Startup/DrawEditBuffer.asm](../Source/Startup/DrawEditBuffer.asm#L15).

перерисовать поле редактирования и стереть символ за его концом

из 6FA5 берёт буфер, из 6FA3 позицию, из 6FA7 число символов, рисует ровно эту длину через 6E88 с увеличением столбца, затем один пробел после поля, входные DE, BC, AF сохраняются, HL не используется

**Вход:** 6FA3 позиция, 6FA5 буфер, 6FA7 длина>0

**Выход:** поле строки и следующий пробел нарисованы, регистры сохранены

**Изменяемые регистры и состояние:** пиксели поля ввода и пробела за ним, операнды 6DFE/6E50 и IFF через 6E88, HL, DE, BC, AF, IX, IY сохранены

В сохранённом графе: 20 инструкций. Чтение: #6FA3, #6FA5, #6FA7. Запись: не выделена. Вызовы: #6E88.

### Startup.ReadEditChar

Адрес #6FA8, блок `S04`. [Source/Startup/ReadEditChar.asm](../Source/Startup/ReadEditChar.asm#L16).

дождаться допустимого символа для строкового ввода

обнуляет LAST_K5C08 и ждёт ненулевого значения от ROM-сканера, код 07 переключает бит 6 поля 61D5 и продолжает ожидание, 0C/0D/0E возвращаются напрямую, бит 4 разрешает только цифры и управляющие коды, без него допустимы пробел и латинские буквы, малые буквы переводятся в большие, бит 6 включает перекодировку цифр по 701A и букв по 7024 в символы альтернативного алфавита

**Вход:** биты 4 и 6 поля 61D5, работающие прерывания с ROM-сканером

**Выход:** A допустимый код, HL и BC сохранены

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 60 инструкций. Чтение: #5C08, #61D5. Запись: #5C08, #61D5. Вызовы: не выделены.

### Startup.LoadFile

Адрес #7092, блок `S04`. [Source/Startup/LoadFile.asm](../Source/Startup/LoadFile.asm#L13).

загрузить именованный файл в заданную область через TR-DOS

копирует девять байт имени и расширения из HL в 5CDD, записывает 0 в 5D10, исходный DE переносит в HL, задаёт C=0E и A=3, хвостовой JP 6DBC вызывает TR-DOS, длина выбирается из параметров файла

**Вход:** HL имя из восьми байтов и однобайтовый тип, DE адрес загрузки

**Выход:** файл загружен через TR-DOS, I=60, IM2

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IY

В сохранённом графе: 10 инструкций. Чтение: не выделено. Запись: #5D10. Вызовы: #6DBC.

### Startup.PageAndEnable

Адрес #70DF, блок `S04`. [Source/Startup/PageAndEnable.asm](../Source/Startup/PageAndEnable.asm#L14).

выбрать логический банк и разрешить прерывания

вызывает RAMDRIVE5FA1 с входным A, затем EI и RET, это вариант переключения банка для обычного вывода текста

**Вход:** A номер логического банка

**Выход:** банк выбран, прерывания разрешены

**Изменяемые регистры и состояние:** текущий логический банк и аппаратное отображение памяти, поле 5FA0 и IFF, HL, DE, BC, AF, IX, IY сохраняет установленный RAMDRIVE

В сохранённом графе: 3 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #5FA1.

### Startup.DrawText

Адрес #70E4, блок `S04`. [Source/Startup/DrawText.asm](../Source/Startup/DrawText.asm#L14).

вывести строку с нулевым терминатором и переходами строк

читает символы из DE до 0, обычный байт передаёт 6E88 и увеличивает C, код 0D потребляет следующий байт как новый столбец C и увеличивает строку B, DE, BC, AF сохраняются, ограничения длины и экранного края отсутствуют

**Вход:** DE строка, BC начальная текстовая позиция

**Выход:** текст выведен, регистры сохранены

**Изменяемые регистры и состояние:** пиксели текста, операнды 6DFE/6E50 и IFF через 6E88, HL, DE, BC, AF, IX, IY сохранены

В сохранённом графе: 21 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6E88.

### Startup.ClearScreen

Адрес #7100, блок `S04`. [Source/Startup/ClearScreen.asm](../Source/Startup/ClearScreen.asm#L13).

обнулить все пиксели и атрибуты ZX-экрана

записывает ноль по 4000 и распространяет его LDIR с BC=1AFF из 4000 в 4001, общий диапазон 4000..5AFF составляет 6912 байтов, HL, DE, BC сохраняются, A не изменяется, флаги F меняет LDIR

**Вход:** регистровых аргументов нет, экранная память 4000..5AFF доступна для записи

**Выход:** пиксели и атрибуты экрана нулевые, HL, DE, BC, A, IX, IY сохранены, флаги LDIR изменены

**Изменяемые регистры и состояние:** AF, меняются только флаги LDIR, экран 4000..5AFF, HL, DE, BC, A, IX, IY сохранены

В сохранённом графе: 12 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Startup.RandomRange

Адрес #7132, блок `S04`. [Source/Startup/RandomRange.asm](../Source/Startup/RandomRange.asm#L16).

получить псевдослучайное число, масштабированное к входному пределу

состояние x, y, z хранится словами 7190,7192,7194, обновление x=y, y=z, z=ROL16(x+y+z,1), новое z становится множителем BC, входной DE сохраняется в 718E и двоичными сдвигами умножается на z в 32-битный результат DE,HL, проверка бита 15 младшей половины увеличивает старшую половину для округления, поэтому DE=round(z*предел/65536), слово 718E после шестнадцати сдвигов нулевое, HL, BC, AF, IX сохраняются

**Вход:** DE неотрицательный предел, состояние 7190..7195 инициализировано

**Выход:** DE масштабированный результат, состояние генератора обновлено, HL, BC, AF, IX сохранены

**Изменяемые регистры и состояние:** DE, временное поле 718E..718F и три слова 7190..7195, HL, BC, AF, IX, IY сохранены

В сохранённом графе: 46 инструкций. Чтение: #7190, #7192, #7194. Запись: #718E, #7190, #7192, #7194. Вызовы: не выделены.

### Startup.TickIntroText

Адрес #7196, блок `S04`. [Source/Startup/TickIntroText.asm](../Source/Startup/TickIntroText.asm#L19).

периодический вывод и прокрутка текста во время создания новой игры

Если #7219 ненулевой, сразу возвращается. Каждые 6 вызовов уменьшает второй счётчик, раз в 8 таких шагов очищает 38 знаков строки 18 и печатает очередную строку из банка 6 по указателю #721C до CR. Маркер #B0 устанавливает #7219=#FF и завершает обработку. На остальных активных шагах прокручивает область от #40A2 вверх на один пиксель, 14 рядов знакомест, 7 копирований по 28 байтов и переход по 30 байтов к следующему ряду. Внешний обработчик прерываний сохраняет регистры и банк, сама процедура этого полного сохранения не делает.

**Вход:** #7219 — разрешение/завершение, #721A/#721B — счётчики, #721C — текстовый указатель

**Выход:** при маркере #B0 #7219=#FF, иначе очередной шаг прокрутки

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

**Дополнительно:** экран, банк 6, #7219..#721F

В сохранённом графе: 69 инструкций. Чтение: #7219, #721C, #721E. Запись: #7219, #721C, #721E. Вызовы: #5FA1, #6E97.

### Startup.DrawFrame

Адрес #7220, блок `S04`. [Source/Startup/DrawFrame.asm](../Source/Startup/DrawFrame.asm#L17).

рисование рамки из восьми одноклеточных образцов с атрибутами

Сохраняет позицию и внутренний размер. Устанавливает A как атрибут в восьми 9-байтовых образцах #72C9..#7308. Верх и низ рисует углами и горизонтальными элементами, середину вертикальными границами и пустым заполнителем. Каждый элемент передаёт #6EA6 как спрайт 1x1 знакоместо. Полная рамка занимает (E+2)x(D+2) знакоместа.

**Вход:** B — строка, C — столбец, D — внутренняя высота, E — внутренняя ширина, A — атрибут

**Выход:** рамка выведена

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

**Дополнительно:** #72C5..#72C8, атрибуты образцов, экран

В сохранённом графе: 66 инструкций. Чтение: #72C5, #72C7, #72C8. Запись: #72C5, #72C7. Вызовы: #6EA6.

### Startup.RestoreScreen

Адрес #7311, блок `S04`. [Source/Startup/RestoreScreen.asm](../Source/Startup/RestoreScreen.asm#L15).

восстановление полного экрана из сохранённого фона в банк 4

Сохраняет номер текущего банка из #5FA0, выбирает банк 4 и копирует #1B00 байтов из #C000 в #4000. Возвращает исходный банк. Копируются и 6144 пиксельных байта, и 768 атрибутов.

**Вход:** банк 4, #C000..#DAFF — исходный экран

**Выход:** текущий банк восстановлен

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** #4000..#5AFF

В сохранённом графе: 11 инструкций. Чтение: #5FA0. Запись: не выделена. Вызовы: #5FA1.

### Startup.FindSaveRecord

Адрес #732A, блок `S04`. [Source/Startup/FindSaveRecord.asm](../Source/Startup/FindSaveRecord.asm#L15).

поиск N-й неудалённой записи типа M в буфере каталога

Начинает перед каталогом с IX=#BFF0, добавляет 16 байтов на запись. Сравнивает тип+8 с ASCII M, пропускает удалённые записи с первым байтом 1. Счётчик B уменьшается только для подходящих записей. Проверки нулевого конца каталога здесь нет, поэтому A должен не превышать уже подсчитанное число сохранений.

**Вход:** A — порядковый номер сохранения с 1, текущий банк содержит каталог по #C000

**Выход:** IX —16-байтовая запись, BC сохранён

**Изменяемые регистры и состояние:** DE, AF, IX

В сохранённом графе: 14 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Startup.ListSaveNames

Адрес #7347, блок `S04`. [Source/Startup/ListSaveNames.asm](../Source/Startup/ListSaveNames.asm#L17).

вывод страницы до пятнадцати имён сохранений

Число активных пунктов #7CA6 начинает с 5 для служебных кнопок. От индекса #7385 выводит не более 15 имён, заканчивая при превышении общего числа #7384. #732A находит каждое сохранение, восемь байтов имени печатает в строках от 4, столбце 4. Для каждого имени увеличивает число пунктов меню.

**Вход:** #7384 — число сохранений, #7385 — первый индекс страницы

**Выход:** #7CA6=5+число показанных имён

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX

**Дополнительно:** экран, #7CA6

В сохранённом графе: 35 инструкций. Чтение: #7385, #7CA6. Запись: #7CA6. Вызовы: #6E88, #732A.

### Startup.DrawHeroStory

Адрес #7386, блок `S04`. [Source/Startup/DrawHeroStory.asm](../Source/Startup/DrawHeroStory.asm#L15).

вывод текстового описания выбранного героя из HERTXT

Берёт номер изображения героя из #7D35, вычитает 1 и ищет соответствующий разделитель #B0 в HERTXT от #D6FF. После двух служебных байтов печатает текст в строке 1, столбце 22. CR начинает новую строку со столбца 22, #B1 завершает описание. Выбор героя и его текст связаны номером, а сами записи PERSON данная процедура не читает.

**Вход:** #7D35 — номер выбранного изображения, HERTXT загружен в банк 0, #D6FF

**Выход:** описание выведено, DE у завершающего #B1

**Изменяемые регистры и состояние:** DE, BC, AF

В сохранённом графе: 25 инструкций. Чтение: #7D35. Запись: не выделена. Вызовы: #6E88.

### Startup.DrawMenuCursor

Адрес #73B0, блок `S04`. [Source/Startup/DrawMenuCursor.asm](../Source/Startup/DrawMenuCursor.asm#L17).

рисование курсора в новой позиции с выравниванием маски

Вычисляет (старый x mod8)-(новый x mod8). Положительную разность компенсирует левым вращением образцов #7699, отрицательную правым #7674. Для восьми строк новой позиции #76C0 получает экранный адрес #73EF и трижды вызывает маскированный вывод #7416. Источник 24 байта #76C2, маска 24 байта #76DA.

**Вход:** #76BE — старые x, y, #76C0 — новые x, y

**Выход:** курсор 8 строк, по 3 экранных байта в строке

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

**Дополнительно:** экран, вращаемые образцы #76C2..#76F1, #770A

В сохранённом графе: 28 инструкций. Чтение: #76BE, #76C0. Запись: не выделена. Вызовы: #73EF, #7416, #7674, #7699.

### Startup.CursorByteAddr

Адрес #73EF, блок `S04`. [Source/Startup/CursorByteAddr.asm](../Source/Startup/CursorByteAddr.asm#L13).

адрес экранного пиксельного байта по координатам курсора

Вычисляет стандартную нелинейную адресацию ZX Spectrum, #4000+((y AND #C0)<<5)+((y AND7)<<8)+((y AND #38)<<2)+(x>>3). Пару BC сохраняет.

**Вход:** B — y, C — x

**Выход:** HL — адрес байта экрана, BC сохранён

**Изменяемые регистры и состояние:** HL, AF

В сохранённом графе: 26 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Startup.DrawCursorByte

Адрес #7416, блок `S04`. [Source/Startup/DrawCursorByte.asm](../Source/Startup/DrawCursorByte.asm#L16).

маскированная запись одного байта курсора

Если H<#58, записывает (экран AND маска IY) OR рисунок IX. При H>=#58 запись пропускается. В любом случае увеличивает HL, IX, IY, сохраняя продвижение источников даже за нижней границей пиксельной памяти.

**Вход:** HL — экран, IX — рисунок, IY — маска

**Выход:** HL, IX, IY увеличены на 1

**Изменяемые регистры и состояние:** HL, AF, IX, IY

**Дополнительно:** байт экрана при H<#58

В сохранённом графе: 11 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Startup.SaveCursorBack

Адрес #7429, блок `S04`. [Source/Startup/SaveCursorBack.asm](../Source/Startup/SaveCursorBack.asm#L15).

сохранение фона новой позиции курсора

Для восьми строк от новых координат #76C0 вычисляет адрес #73EF и копирует по 3 байта в линейный буфер #76F2. Это 24 байта пиксельного фона, атрибуты не копируются.

**Вход:** #76C0 — новая позиция

**Выход:** #76F2..#7709 — сохранённый фон

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** буфер фона

В сохранённом графе: 15 инструкций. Чтение: #76C0. Запись: не выделена. Вызовы: #73EF.

### Startup.RestoreCursor

Адрес #7444, блок `S04`. [Source/Startup/RestoreCursor.asm](../Source/Startup/RestoreCursor.asm#L15).

восстановление фона старой позиции курсора

Для восьми строк от старых координат #76BE копирует три байта из #76F2 обратно на экран, преобразуя адрес каждой строки через #73EF.

**Вход:** #76BE — старая позиция, #76F2..#7709 — фон

**Выход:** изображение прежнего курсора убрано

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** пиксельная память экрана

В сохранённом графе: 17 инструкций. Чтение: #76BE. Запись: не выделена. Вызовы: #73EF.

### Startup.ChooseMenuRect

Адрес #7461, блок `S04`. [Source/Startup/ChooseMenuRect.asm](../Source/Startup/ChooseMenuRect.asm#L21).

выбор прямоугольной области меню пиксельным курсором

Убирает оставшееся вращение образцов по #770A, выравнивает их на начальный x и копирует его в старую/новую позицию. Сохраняет фон, проверяет область под курсором и выделяет её обменом INK/PAPER. Цикл сравнивает новый указатель области с предыдущим #763F, снимает старое выделение и ставит новое. После HALT восстанавливает старый фон, сохраняет новый, рисует курсор и переносит позицию в #76BE. Коды управления перемещают по 1 пикселю, включая диагонали. Код #27 выбирает только существующую область. Перед возвратом убирает подсветку и курсор, сохраняет позицию в дескрипторе.

**Вход:** IX — дескриптор, число областей, +1minX, +2minY, +3maxX, +4maxY, +5currentX, +6currentY, далее четверки left, top, right, bottom в знакоместах

**Выход:** A — номер выбранной области с 1, IX остаётся дескриптором, его+5/+6 содержат позицию

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IY, прерывания EI

**Дополнительно:** экран, #763F, #76BE..#770A, координаты дескриптора

В сохранённом графе: 108 инструкций. Чтение: #763F, #76BE, #76C0, #770A. Запись: #763F, #76BE, #76C0. Вызовы: #73B0, #7429, #7444, #7572, #75CA, #7612, #7644, #7650, #765C, #7668, #7674, #7699.

### Startup.HitTestMenu

Адрес #7572, блок `S04`. [Source/Startup/HitTestMenu.asm](../Source/Startup/HitTestMenu.asm#L14).

поиск прямоугольника меню под пиксельным курсором

Перебирает IX+0 областей по 4 байта от IX+7. Умножает left, top, right, bottom на 8, проверяет left<=x<right и top<=y<bottom по позиции #76C0. При совпадении возвращает порядковый номер и IY. При отсутствии A=0, IY=0. Координаты 0..31 по x и 0..23 по y переводятся в байты без расширения.

**Вход:** IX — дескриптор меню, #76C0 — позиция

**Выход:** A=1..N, IY — четверка найденной области, A=0, IY=0 если вне областей

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IY

В сохранённом графе: 45 инструкций. Чтение: #76C0. Запись: не выделена. Вызовы: не выделены.

### Startup.ToggleMenuInk

Адрес #75CA, блок `S04`. [Source/Startup/ToggleMenuInk.asm](../Source/Startup/ToggleMenuInk.asm#L16).

обратимая подсветка области меню обменом INK и PAPER

По четверке символьных границ IY вычисляет адрес #5800+32*top+left и проходит (bottom-top)*(right-left) атрибутов. Меняет местами биты 0..2 и 3..5. BRIGHT и FLASH сохраняет через AND #C0. Второй вызов с теми же границами возвращает исходные цвета.

**Вход:** IY — left, top, right, bottom, положительные ширина и высота

**Выход:** область инвертирована, IY сохранён

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** атрибуты экрана

В сохранённом графе: 46 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Startup.ReadMenuInput

Адрес #7612, блок `S04`. [Source/Startup/ReadMenuInput.asm](../Source/Startup/ReadMenuInput.asm#L16).

опрос клавиатуры ROM и Kempston с преобразованием направлений

Вызывает ROM #028E. Если E!=#FF, возвращает A=E. Иначе читает порт #1F и повторяет при нуле. Bit4 Kempston немедленно возвращает код действия #27. Для прочих значений ищет точную пару состояние/код в таблице #762F. Проверки отсутствующего порта #FF нет, такое значение имеет бит 4 и будет воспринято как действие.

**Вход:** порты клавиатуры и Kempston

**Выход:** A — код, #13 вверх-влево, #1B вверх, #23 вверх-вправо, #12 влево, #22 вправо, #11 вниз-влево, #19 вниз, #21 вниз-вправо, #27 действие

**Изменяемые регистры и состояние:** HL, DE, BC, AF по ROM и поиску

В сохранённом графе: 18 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #028E.

### Startup.CursorUp

Адрес #7644, блок `S04`. [Source/Startup/CursorUp.asm](../Source/Startup/CursorUp.asm#L13).

движение курсора на один пиксель вверх в пределах меню

Сравнивает старый y #76BF с minY IX+2. При равенстве оставляет новую позицию, иначе пишет y-1 в #76C1. Это шаг от последней показанной позиции, не накопление поверх уже изменённого y.

**Вход:** IX — меню, #76BF — старый y

**Выход:** #76C1 — кандидат нового y

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 6 инструкций. Чтение: #76BF. Запись: #76C1. Вызовы: не выделены.

### Startup.CursorDown

Адрес #7650, блок `S04`. [Source/Startup/CursorDown.asm](../Source/Startup/CursorDown.asm#L12).

движение курсора на один пиксель вниз в пределах меню

Если старый y не равен maxY IX+4, записывает y+1 в #76C1.

**Вход:** IX — меню, #76BF — старый y

**Выход:** новая координата при допустимом шаге

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 6 инструкций. Чтение: #76BF. Запись: #76C1. Вызовы: не выделены.

### Startup.CursorLeft

Адрес #765C, блок `S04`. [Source/Startup/CursorLeft.asm](../Source/Startup/CursorLeft.asm#L12).

движение курсора на один пиксель влево в пределах меню

Если старый x #76BE не равен minX IX+1, записывает x-1 в #76C0.

**Вход:** IX — меню, #76BE — старый x

**Выход:** новый x при допустимом шаге

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 6 инструкций. Чтение: #76BE. Запись: #76C0. Вызовы: не выделены.

### Startup.CursorRight

Адрес #7668, блок `S04`. [Source/Startup/CursorRight.asm](../Source/Startup/CursorRight.asm#L12).

движение курсора на один пиксель вправо в пределах меню

Если старый x не равен maxX IX+3, записывает x+1 в #76C0.

**Вход:** IX — меню, #76BE — старый x

**Выход:** новый x при допустимом шаге

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 6 инструкций. Чтение: #76BE. Запись: #76C0. Вызовы: не выделены.

### Startup.RotateCursorR

Адрес #7674, блок `S04`. [Source/Startup/RotateCursorR.asm](../Source/Startup/RotateCursorR.asm#L17).

циклическое вращение 24-битных строк рисунка и маски курсора вправо

Для 16 последовательных троек байтов #76C2..#76F1 выполняет SRL, RR, RR и возвращает ушедший бит в бит 7 первого байта. Это отдельно 8 строк рисунка и 8 строк маски. Повторяет A раз, увеличивая счётчик суммарного вращения #770A после каждого прохода. A=0 не допускается, поскольку DEC A создаст 256 проходов.

**Вход:** A — положительное число пиксельных сдвигов

**Выход:** A=0, B=0, образцы повёрнуты

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** #76C2..#76F1, #770A

В сохранённом графе: 23 инструкций. Чтение: #770A. Запись: #770A. Вызовы: не выделены.

### Startup.RotateCursorL

Адрес #7699, блок `S04`. [Source/Startup/RotateCursorL.asm](../Source/Startup/RotateCursorL.asm#L15).

циклическое вращение 24-битных строк рисунка и маски курсора влево

Обратный к #7674 проход от #76F1, SLA последнего байта, RL среднего, RL первого, ушедший бит возвращает в бит 0 последнего. Обрабатывает 16 троек, повторяет A раз и уменьшает #770A.

**Вход:** A — положительное число сдвигов

**Выход:** A=0, B=0, вращение вправо отменено на A шагов

**Изменяемые регистры и состояние:** HL, DE, BC, AF

**Дополнительно:** #76C2..#76F1, #770A

В сохранённом графе: 23 инструкций. Чтение: #770A. Запись: #770A. Вызовы: не выделены.

### Startup.InvertState

Адрес #770B, блок `S04`. [Source/Startup/InvertState.asm](../Source/Startup/InvertState.asm#L16).

побайтовая инверсия блока данных состояния

Читает байт по HL, выполняет CPL и записывает обратно, увеличивает HL и уменьшает DE до нуля. Два одинаковых вызова восстанавливают исходные байты. При входном DE=0 цикл затронул бы весь 64 Кдиапазон, реальные вызывающие участки передают ненулевую длину.

**Вход:** HL — начало, DE — ненулевой размер

**Выход:** HL после блока, DE=0

**Изменяемые регистры и состояние:** HL, DE, AF

**Дополнительно:** исходный блок заменён инверсией XOR #FF

В сохранённом графе: 9 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Startup.MarkStructures

Адрес #7715, блок `S04`. [Source/Startup/MarkStructures.asm](../Source/Startup/MarkStructures.asm#L17).

отметка занимаемых строениями клеток стартовых карт

Сохраняет AF, задаёт номер континента #77A2, выбирает банк 0. Вызывает #7746 для трёх таблиц #6CD6, #6CE6, #6CF6, шаги 35, 26, 5 и прямоугольники 3x2, 1x1, 2x2 клетки соответственно. Во всех клетках объектов устанавливается бит 7 стратегической карты. Это отметка занятости/резервирования, а не отдельная битовая маска карты пройденного из банка 11.

**Вход:** A — континент 1..4

**Выход:** AF восстановлен, активен банк 0

**Изменяемые регистры и состояние:** HL, DE, BC, IX, IY

**Дополнительно:** карты банк 10..13, #77A2 и рабочие операнды

В сохранённом графе: 18 инструкций. Чтение: не выделено. Запись: #77A2. Вызовы: #5FA1, #7746.

### Startup.MarkGroupCells

Адрес #7746, блок `S04`. [Source/Startup/MarkGroupCells.asm](../Source/Startup/MarkGroupCells.asm#L19).

обход записей одной группы и отметка их прямоугольного следа на карте

Сохраняет B/C как высоту/ширину, DE как шаг. По номеру #77A2 выбирает один из четырёх дескрипторов по IX+4*A. Дескриптор даёт указатель и 16-битное число записей. Для каждой берёт столбец+1, строку+2, вызывает #7791 для всех клеток прямоугольника и переходит на следующую запись. Нулевой счётчик данным циклом отдельно не обработан, вызывающие таблицы должны иметь корректные положительные числа.

**Вход:** IX — база перед первым 4-байтовым дескриптором континента, B — высота, C — ширина, DE — шаг записи

**Выход:** все записи отмечены, IY после последней записи

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

**Дополнительно:** операнды #7774/#7776/#7787, карты

В сохранённом графе: 37 инструкций. Чтение: #77A2. Запись: #7774, #7776, #7787. Вызовы: #7791.

### Startup.MarkUsedCell

Адрес #7791, блок `S04`. [Source/Startup/MarkUsedCell.asm](../Source/Startup/MarkUsedCell.asm#L15).

установка бита занятости клетки с восстановлением банка

Сохраняет текущий банк, передаёт номер континента #77A2 в #78A4, устанавливает бит 7 полученного байта карты и возвращает прежний банк.

**Вход:** B — строка, C — столбец, #77A2 — континент

**Выход:** выбранный ранее банк восстановлен

**Изменяемые регистры и состояние:** HL, AF

**Дополнительно:** один байт карты

В сохранённом графе: 8 инструкций. Чтение: #5FA0, #77A2. Запись: не выделена. Вызовы: #5FA1, #78A4.

### Startup.PickUnusedName

Адрес #77A3, блок `S04`. [Source/Startup/PickUnusedName.asm](../Source/Startup/PickUnusedName.asm#L19).

случайный выбор ещё не использованного имени с копированием в рабочий банк

Сохраняет IX, использует A как шаг записи, A-1 как длину имени и смещение флага занятости. Выбирает банк 1, случайно определяет начальную запись среди B, затем ищет нулевой последний байт с циклическим переходом к началу. Помечает его #FF. Для каждого символа переключает банк 1 для чтения и банк 0 для записи по IX, после A-1 символов дописывает 0. Исходный IX восстанавливает. Явного выхода при использовании всех имён нет.

**Вход:** A — шаг 16 или 12, B — количество 80 или 160, IY — адрес перед первой записью (BFF0 или C4F4), IX — приёмник банк 0

**Выход:** имя 15 или 11 байтов плюс 0 скопировано, IX сохранён, IY после исходных букв, банк 0 активен

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IY

**Дополнительно:** флаг последнего байта записи банк 1, строка банк 0, операнды #77CB/#77D3/#77E9/#77EB, #6CCE

В сохранённом графе: 47 инструкций. Чтение: #6CCE. Запись: #6CCE, #77CB, #77D3, #77E9, #77EB. Вызовы: #70DF, #7132.

### Startup.CreateWanderers

Адрес #7808, блок `S04`. [Source/Startup/CreateWanderers.asm](../Source/Startup/CreateWanderers.asm#L19).

создание четырёх континентальных групп случайных шестибайтовых отрядов

В четырёх 4-байтовых дескрипторах берёт число записей избайта+2. Для каждой через #78B9 выбирает внутренние координаты, #78A4 требует клетку с бит 7=0 и младшими 6 бит=0 и помечает её бит 7. В банк 0 пишет флаги 0 и координаты. В банк 3 по 50-байтовой таблице #CD3E+50*континент выбирает ID по порогу случайного байта. В описателе SOLDIERS по #C6D6+42*ID проверяет +#12 на совпадение с входным A, неподходящий ID перевыбирает. ID и слово+#20/+#21 копирует в поля+3 и+4/+5 записи. Размер шага приёмника задаёт исходный DE, реальные вызовы передают 6.

**Вход:** A — категория 1..4, HL — четыре дескриптора, IX — приёмник банк 0, DE — шаг

**Выход:** созданы все записи четырёх групп, IX после последней

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

**Дополнительно:** карты, банк 0 записи, счётчик #6CD7, операнды #787D/#7895

В сохранённом графе: 71 инструкций. Чтение: #6CD7. Запись: #6CD7, #787D, #7895. Вызовы: #70DF, #7132, #78A4, #78B9.

### Startup.MapCellAddress

Адрес #78A4, блок `S04`. [Source/Startup/MapCellAddress.asm](../Source/Startup/MapCellAddress.asm#L15).

адрес клетки карты выбранного континента при создании игры

Выбирает логический банк A+9. Вычисляет #BF5F+161*(B+1)+C, что равно #C000+161*row+column. Пары DE/BC сохраняет, выбранный банк остаётся активным.

**Вход:** A — континент 1..4, B — строка, C — столбец

**Выход:** HL — байт карты, BC и DE сохранены

**Изменяемые регистры и состояние:** HL, AF

**Дополнительно:** активныйбанк 10..13

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #70DF.

### Startup.RandomMapPos

Адрес #78B9, блок `S04`. [Source/Startup/RandomMapPos.asm](../Source/Startup/RandomMapPos.asm#L15).

выбор случайных внутренних координат стратегической карты

Вызывает генератор #7132 с масштабом 154, к результату E прибавляет 3 и переносит в C. Затем использует масштаб 93, прибавляет 3 и переносит в B. Исходный DE сохраняет. Точная верхняя включённая граница зависит от округления генератора, поэтому формула результата описана через два вызова без произвольного сужения диапазона.

**Вход:** состояние генератора

**Выход:** C=randomScaled(154)+3, B=randomScaled(93)+3, DE сохранён

**Изменяемые регистры и состояние:** BC, AF

В сохранённом графе: 15 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7132.

### Startup.GenerateArmy

Адрес #78D0, блок `S04`. [Source/Startup/GenerateArmy.asm](../Source/Startup/GenerateArmy.asm#L20).

генерация от двух до пяти трёхбайтовых отрядов по весовой таблице

Сохраняет IX. Число записей получает как scaledRandom(3)+2. Для каждой выбирает банк 3, получает случайный байт с масштабом 254, берёт таблицу по исходному HL+150*A и проходит 6-байтовые записи, пока случайное значение не меньше порога+1. Из записи берёт ID+0, базовое 16-битное количество+2/+3 и разброс+4/+5. Ещё один вызов #7132 даёт добавку, сумма записывается в банк 0 по IY как ID и 16-битное количество. IY увеличиваетсяна 3. Самостоятельной очистки оставшихся мест массива или установки нулевого терминатора нет.

**Вход:** A — номер континентальной таблицы, HL — база перед группами по 150 байтов, IY — приёмник банк 0

**Выход:** записано 2..5 отрядов, IY после них, IX сохранён

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IY

**Дополнительно:** приёмник банк 0, операнды #78EF/#78F2

В сохранённом графе: 42 инструкций. Чтение: не выделено. Запись: #78EF, #78F2. Вызовы: #70DF, #7132.

## MemoryDriver

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #7D34 | `MemoryDriver.Detect` | определение схемы расширенной памяти и установка общего переключателя банков | [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L21) |
| #7DBE | `MemoryDriver.CheckBanks` | проверка независимости нижней и верхней группы банков | [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L100) |
| #7E8F | `MemoryDriver.PortDFFD` | шаблон старшего порта #DFFD | [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L168) |
| #7E97 | `MemoryDriver.PortFDFD` | шаблон старшего порта #FDFD | [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L184) |
| #7E9F | `MemoryDriver.Port1FFD` | шаблон старшего порта #1FFD | [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L200) |
| #7EA7 | `MemoryDriver.Port7FFD` | шаблон расширения верхних битов #7FFD | [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L219) |
| #7EB6 | `MemoryDriver.BankCode` | копируемый общий переключатель логических банков 0..15 | [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L244) |
| #7EDA | `MemoryDriver.FillAttr` | заполнение атрибутов строки сообщения | [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L284) |
| #7EF1 | `MemoryDriver.DrawGlyph` | печать утолщённого символа шрифта ПЗУ | [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L315) |
| #7F32 | `MemoryDriver.AttrAddress` | расчёт атрибутного адреса по символьным координатам | [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L378) |
| #7F4F | `MemoryDriver.Print` | печать строки с управляющими кодами цвета и позиции | [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L412) |

### MemoryDriver.Detect

Адрес #7D34, блок `S05`. [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L21).

определение схемы расширенной памяти и установка общего переключателя банков

Копирует 33-байтовый шаблон BankCode..#7ED6 в #5FA1. Очищает экран, печатает сообщение. Проверяет различимость банков через #7FFD и по очереди устанавливает 8-байтовые варианты старшего порта. Проверка CheckBanks записывает разные значения в одну позицию банков 0 и 8 и читает их обратно. После первого успешного варианта печатает название режима и возвращается. Если подходящая память не найдена, печатает отказ и навсегда меняет бордюр от R&7.

**Вход:** состояние портов расширения памяти

**Выход:** подпрограмма переключения банков по #5FA1, #5FA0 содержит последний логический номер

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 60 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7DBE, #7F4F.

### MemoryDriver.CheckBanks

Адрес #7DBE, блок `S05`. [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L100).

проверка независимости нижней и верхней группы банков

Копирует следующий вариант управляющих команд из HL в #5FAC. В ячейку #C000 банка 0 записывает 0, в ту же ячейку банка 8 записывает 8. Повторным чтением проверяет, что значения сохранились раздельно. Выбирает банк 0 перед возвратом, сохраняя результат сравнения в AF.

**Вход:** HL — следующий вариант, BC — число копируемых байтов

**Выход:** HL после варианта, Z установлен при успехе

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 24 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #5FA1.

### MemoryDriver.PortDFFD

Адрес #7E8F, блок `S05`. [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L168).

шаблон старшего порта #DFFD

B=#DF, затем A с битом 3 сдвигается вправо трижды, получается бит 0 дополнительной группы памяти. Эти байты являются исполняемым шаблоном для копирования в #5FAC, а не обычной вызываемой процедурой.

**Вход:** AF — старшая часть логического номера

**Выход:** BC и A для OUT (C), A

**Изменяемые регистры и состояние:** BC, AF

В сохранённом графе: 4 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### MemoryDriver.PortFDFD

Адрес #7E97, блок `S05`. [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L184).

шаблон старшего порта #FDFD

B=#FD, затем A с битом 3 сдвигается вправо трижды. Эти байты являются исполняемым шаблоном для копирования в #5FAC, а не обычной вызываемой процедурой.

**Вход:** AF — старшая часть логического номера

**Выход:** BC и A для OUT (C), A

**Изменяемые регистры и состояние:** BC, AF

В сохранённом графе: 4 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### MemoryDriver.Port1FFD

Адрес #7E9F, блок `S05`. [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L200).

шаблон старшего порта #1FFD

B=#1F, затем A с битом 3 сдвигается влево один раз, получается бит 4. Эти байты являются исполняемым шаблоном для копирования в #5FAC, а не обычной вызываемой процедурой.

**Вход:** AF — старшая часть логического номера

**Выход:** BC и A для OUT (C), A

**Изменяемые регистры и состояние:** BC, AF

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### MemoryDriver.Port7FFD

Адрес #7EA7, блок `S05`. [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L219).

шаблон расширения верхних битов #7FFD

A с битом 3 сдвигается влево трижды в бит 6, объединяется с младшими тремя битами исходного номера, B=#7F. Эти байты являются исполняемым шаблоном для копирования в #5FAC, а не обычной вызываемой процедурой.

**Вход:** AF — старшая часть логического номера

**Выход:** BC и A для OUT (C), A

**Изменяемые регистры и состояние:** BC, AF

В сохранённом графе: 10 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### MemoryDriver.BankCode

Адрес #7EB6, блок `S05`. [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L244).

копируемый общий переключатель логических банков 0..15

После переноса исполняется с #5FA1. Запрещает прерывания, сохраняет BC и AF. Записывает исходный номер в #5FA0. Патчируемый участок формирует старший порт из бита 3, затем #7FFD получает младшие 3 бита и принудительный бит 4 выбора ПЗУ 48. Возвращает BC и AF, прерывания остаются запрещёнными.

**Вход:** AF — логический номер банка в A

**Выход:** регистры сохранены, выбран банк, DI остаётся действующим

**Изменяемые регистры и состояние:** HL, DE, BC, AF сохранены, регистр R меняется при исполнении, прерывания остаются запрещёнными

В сохранённом графе: 23 инструкций. Чтение: не выделено. Запись: #5FA0. Вызовы: не выделены.

### MemoryDriver.FillAttr

Адрес #7EDA, блок `S05`. [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L284).

заполнение атрибутов строки сообщения

Берёт позицию из BankCode.PrintXY, рассчитывает адрес атрибутов через AttrAddress и записывает A в число соседних ячеек, заданное DrawGlyph.PrintAttr. Внешние HL, BC, AF сохранены стеком.

**Вход:** AF — атрибут в A, BankCode.PrintXY — позиция, DrawGlyph.PrintAttr — длина

**Выход:** заполнена строка атрибутов

**Изменяемые регистры и состояние:** HL, DE, BC, AF сохранены

В сохранённом графе: 16 инструкций. Чтение: #7ED8, #7F31. Запись: не выделена. Вызовы: #7F32.

### MemoryDriver.DrawGlyph

Адрес #7EF1, блок `S05`. [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L315).

печать утолщённого символа шрифта ПЗУ

Вычитает 32 из кода, умножает индекс на 8 и прибавляет #3D00, то есть выбирает символ по #3C00+8*код. Вычисляет нелинейный экранный адрес по позиции BankCode.PrintXY. В каждой из 8 строк объединяет исходный байт со сдвигом влево на 1 и пишет в экран. Увеличивает горизонтальную позицию.

**Вход:** AF — код символа в A, BankCode.PrintXY — координаты

**Выход:** символ выведен, горизонтальная позиция увеличена

**Изменяемые регистры и состояние:** HL, DE, AF

В сохранённом графе: 48 инструкций. Чтение: #7ED8, #7ED9. Запись: не выделена. Вызовы: не выделены.

### MemoryDriver.AttrAddress

Адрес #7F32, блок `S05`. [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L378).

расчёт атрибутного адреса по символьным координатам

Формирует HL=#5800+32*C+B с маскированием B до 5 младших битов и C до 5 младших битов. Возвращённый адрес используется для окраски знакомест.

**Вход:** BC — B колонка, C строка

**Выход:** HL — адрес атрибута

**Изменяемые регистры и состояние:** HL, AF

В сохранённом графе: 20 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### MemoryDriver.Print

Адрес #7F4F, блок `S05`. [Source/Files/05_RAMDRIVE.asm](../Source/Files/05_RAMDRIVE.asm#L412).

печать строки с управляющими кодами цвета и позиции

Читает поток из DE до 0. Код #10 берёт длину и атрибут и вызывает FillAttr. Код #16 читает две координаты и сохраняет их по BankCode.PrintXY. Остальные коды выводятся через DrawGlyph. Цикл продвигает DE до завершающего 0.

**Вход:** DE — нуль-терминированная строка

**Выход:** DE у завершающего 0, текст выведен

**Изменяемые регистры и состояние:** HL, DE, AF

В сохранённом графе: 34 инструкций. Чтение: не выделено. Запись: #7ED8, #7F31. Вызовы: #7EDA, #7EF1.

## Presentation

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #E200 | `Presentation.Present` | показать вступление, титры со звёздами и проявить титульный экран | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L33) |
| #E3A7 | `Presentation.WaitStars` | выдержать заданное число секунд с движущимися звёздами | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L230) |
| #E3BC | `Presentation.StoryPages` | показать центрированные текстовые страницы предыстории | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L264) |
| #E438 | `Presentation.PrintCell` | вывести один знак предыстории с цветом знакоместа | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L350) |
| #E44F | `Presentation.DrawGlyph` | нарисовать собственный 8x8 глиф в экранное знакоместо | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L382) |
| #E46E | `Presentation.PollInput` | проверить клавиатуру и любой ненулевой ввод Kempston | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L424) |
| #E48E | `Presentation.CreditLine` | показать строку титров увеличенным шрифтом на фоне звёзд | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L465) |
| #E4BA | `Presentation.EraseCredit` | стереть строку титров и перейти к следующей записи | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L508) |
| #E4EA | `Presentation.FillAttrs` | заполнить прямоугольник атрибутов заданным цветом | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L553) |
| #E50C | `Presentation.ClearRect` | очистить пиксели прямоугольника и задать его атрибуты | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L599) |
| #E53B | `Presentation.CellAddress` | вычислить экранный адрес верхней линии знакоместа | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L652) |
| #E556 | `Presentation.InitStars` | подготовить атрибуты фона и включить сто звёзд | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L687) |
| #E580 | `Presentation.MoveStars` | сдвинуть сто звёзд на один пиксель влево | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L730) |
| #E5A2 | `Presentation.PlotStar` | изменить один звёздный пиксель только в области свободного фона | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L771) |
| #E5FA | `Presentation.RandomRange` | получить псевдослучайное целое от нуля до указанного предела | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L853) |
| #E65E | `Presentation.LargeGlyph` | нарисовать глиф титров с масштабом два по горизонтали и три по вертикали | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L929) |
| #E6D3 | `Presentation.LargeRow` | записать шестнадцать пикселей и перейти к следующей экранной строке | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L1019) |
| #E6FA | `Presentation.ExpandBits` | удвоить каждый бит восьмибитной строки в шестнадцатибитную | [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L1062) |

### Presentation.Present

Адрес #E200, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L33).

показать вступление, титры со звёздами и проявить титульный экран

Инициализирует три слова генератора двумя перекрывающимися словами TrDos.DriveModes/#5CC9 и значением R, продублированным в оба байта. Создаёт 100 различных точек y=0..191, x=0..255 по stars, сравнивая каждую новую пару со всеми 100 слотами. Показывает страницы story через StoryPages. Очищает экран, запускает звёзды и выводит две группы кредитных строк из credits увеличенным шрифтом. До каждого блока выдерживает 50 кадров, после блока 150 кадров, нажатие сокращает ожидание. Затем по одной точке на кадр гасит 100 звёзд, очищает экран и за 768 успешных выборов проявляет исходный SCR из screen..#DAFF знакоместами в случайном порядке. Клетка считается уже проявленной по ненулевому атрибуту. Все 768 исходных атрибутов ненулевые, поэтому при завершении цикла показан весь исходный экран. В этой последней фазе любое обнаруженное нажатие завершает показ раньше

**Вход:** банк 4 выбран, PRES загружен по screen, стандартное ПЗУ 48 и разрешённые прерывания для HALT, исходные SCR/шрифт/сценарии внутри файла

**Выход:** возврат в BL3 после полного либо прерванного проявления, банк 4 остаётся выбранным, IY сохранён

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены

**Дополнительно:** экран #4000..#5AFF, CellPos/CellPos.ScatterHigh, операнды StoryPages.StoryRow/StoryPages.StoryColour/PlotStar.StarPixelOp, rng..#E7D7

В сохранённом графе: 162 инструкций. Чтение: #5CC8, #5CC9, #E33D, #E33E. Запись: #E33D, #E5F4, #E658, #E65A, #E65C. Вызовы: #E3A7, #E3BC, #E46E, #E48E, #E4BA, #E50C, #E556, #E5A2, #E5FA.

### Presentation.WaitStars

Адрес #E3A7, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L230).

выдержать заданное число секунд с движущимися звёздами

Сохраняет IX. Для каждого шага B выполняет до 50 повторов опроса, HALT и обновления звёзд. При CF=1 от PollInput выходит сразу. Значение B=0 означает 256 внешних повторов из-за DJNZ. Нажатие только завершает эту задержку, вызывающий код вступления не трактует его как выход из всех страниц

**Вход:** BC — B число интервалов по 50 прерываний, разрешённые прерывания, массив звёзд stars

**Выход:** CF=1 при прерывании вводом, CF=0 при окончании задержки. При полном окончании B=0, D=0. HL, IX, IY сохранены

**Изменяемые регистры и состояние:** DE, BC, AF. HL, HL', DE', BC', AF', IX, IY сохранены, внутри DE/BC меняются только D/B

**Дополнительно:** экран и координаты звёзд через MoveStars

В сохранённом графе: 11 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #E46E, #E580.

### Presentation.StoryPages

Адрес #E3BC, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L264).

показать центрированные текстовые страницы предыстории

Сканирует поток от story до маркера #B1. После маркера #FF завершает показ, иначе два следующих байта задают начальную строку и задержку страницы, они записываются в операнды StoryPages.StoryRow/StoryPages.StoryColour. Очищает экран с атрибутом #45, рисует звёзды, выдерживает одну секунду. Для каждой строки до CR считает число знаков и выбирает столбец floor((32-длина)/2), выводит 8x8 глифы с атрибутом #46 через PrintCell. Следующий #B1 начинает новую страницу, задержка текущей страницы проходит с движением звёзд

**Вход:** PRES в текущем банке, текстовый сценарий story..#EC1E, собственный шрифт font..#E1FF

**Выход:** IX указывает на завершающий #FF сценария, возврат после всех страниц, IY сохранён

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены

**Дополнительно:** экран, StoryPages.StoryRow/StoryPages.StoryColour, звёзды и операнд PlotStar.StarPixelOp через помощники

В сохранённом графе: 56 инструкций. Чтение: #E413. Запись: #E413, #E432. Вызовы: #E3A7, #E438, #E50C, #E556.

### Presentation.PrintCell

Адрес #E438, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L350).

вывести один знак предыстории с цветом знакоместа

CP #20 оставляет пробел без вывода. Для остальных знаков задаёт прямоугольнику 1x1 атрибут #46 через FillAttrs, затем извлекает D из сохранённой пары DE как код глифа в A и вызывает DrawGlyph. Поэтому реальный контракт требует совпадения A и D у обычного вызывающего кода, переданный E не определяет цвет. POP AF восстанавливает исходный A и флаги проверки CP #20, но DE после рабочего LD DE, #0101 не восстанавливается

**Вход:** DE — D код глифа, BC — строка B и столбец C, AF — A код проверки пробела, в штатном вызове A=D

**Выход:** при A=#20 экран не меняется. Иначе знак и атрибут #46 записаны, DE=#0101. HL, BC, IX, IY сохранены, A сохранён, F соответствует CP #20

**Изменяемые регистры и состояние:** DE, AF. HL, BC, HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** восемь пиксельных байтов и один атрибут экрана

В сохранённом графе: 15 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #E44F, #E4EA.

### Presentation.DrawGlyph

Адрес #E44F, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L382).

нарисовать собственный 8x8 глиф в экранное знакоместо

Сохраняет HL, DE, BC, AF. Вычисляет исходный указатель #DA00+8*A, поэтому код 32 начинается по font. CellAddress получает экранный адрес по BC. Копирует восемь последовательных исходных байтов в восемь экранных строк с увеличением H. Атрибут здесь не меняет

**Вход:** BC — строка B и столбец C в знакоместах, AF — A код 32..255, шрифт font..#E1FF

**Выход:** глиф выведен, все основные, альтернативные и индексные регистры сохранены

**Изменяемые регистры и состояние:** Нет, HL, DE, BC, AF, HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** восемь пиксельных байтов экрана

В сохранённом графе: 24 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #E53B.

### Presentation.PollInput

Адрес #E46E, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L424).

проверить клавиатуру и любой ненулевой ввод Kempston

Сохраняет IX, IY, HL, DE, BC, вызывает ROM #028E. При E!=#FF устанавливает CF и возвращает A=E. Иначе читает порт #1F, любое ненулевое значение также устанавливает CF. При полном отсутствии ввода XOR A даёт A=0, CF=0. Сохранение альтернативных регистров подтверждено статическим обходом реально вызываемого ROM KEY-SCAN, EXX/EX AF, AF' там не используются

**Вход:** стандартное ПЗУ 48, клавиатура и порт Kempston #1F

**Выход:** CF=1 при обнаруженном вводе, A код клавиши либо байт порта. CF=0, A=0 при отсутствии ввода. HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF. HL, DE, BC, HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** чтение портов ввода

В сохранённом графе: 21 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #028E.

### Presentation.CreditLine

Адрес #E48E, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L465).

показать строку титров увеличенным шрифтом на фоне звёзд

Читает атрибут из IX+0, столбец из IX+1, строку из IX+2, затем знаки с IX+3 до нуля. Каждый знак передаёт LargeGlyph, после него обновляет звёзды и увеличивает C. IX продвигается по строке, после терминатора становится началом следующей записи формата [attr, x, y, text, 0]. Внешние HL, DE, BC, AF восстанавливает

**Вход:** IX — строка сценария титров [атрибут, x, y, ASCII-строка, 0], массив звёзд и собственный шрифт

**Выход:** IX — следующая запись, HL, DE, BC, AF, IY сохранены

**Изменяемые регистры и состояние:** IX. HL, DE, BC, AF, HL', DE', BC', AF', IY сохранены

**Дополнительно:** экран, координаты звёзд и PlotStar.StarPixelOp через MoveStars

В сохранённом графе: 25 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #E580, #E65E.

### Presentation.EraseCredit

Адрес #E4BA, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L508).

стереть строку титров и перейти к следующей записи

Считывает столбец и строку увеличенного текста. Считает знаки включая завершающий нуль, преобразует область в знакоместа x=2*C, y=3*B, ширина=2*(длина+1), высота=3. Очищает пиксели и задаёт атрибут #45 через ClearRect. IX становится началом следующей записи, основные регистры восстанавливаются

**Вход:** IX — запись титров [attr, x, y, text, 0]

**Выход:** IX — следующая запись, HL, DE, BC, AF, IY сохранены

**Изменяемые регистры и состояние:** IX. HL, DE, BC, AF, HL', DE', BC', AF', IY сохранены

**Дополнительно:** прямоугольник экрана, на один увеличенный знак шире исходной строки

В сохранённом графе: 29 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #E50C.

### Presentation.FillAttrs

Адрес #E4EA, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L553).

заполнить прямоугольник атрибутов заданным цветом

Вычисляет #5800+32*B+C, затем D строк по E байтов заполняет A с шагом 32 между строками. Сохраняет HL, но BC используется рабочим счётчиком и адресным шагом. Нулевые D/E оборачивают DJNZ, поэтому штатные размеры должны быть ненулевыми

**Вход:** DE — D высота, E ширина в знакоместах, BC — строка B и столбец C, AF — A атрибут

**Выход:** прямоугольник атрибутов заполнен, HL, DE, A, IX, IY сохранены

**Изменяемые регистры и состояние:** BC, AF. HL, DE, HL', DE', BC', AF', IX, IY сохранены, внутри AF меняется F

**Дополнительно:** атрибуты экрана

В сохранённом графе: 26 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Presentation.ClearRect

Адрес #E50C, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L599).

очистить пиксели прямоугольника и задать его атрибуты

Через CellAddress находит начало прямоугольника. Для каждой строки знакомест очищает восемь пиксельных линий по E байтов, затем переходит к следующей строке с учётом нелинейной памяти Spectrum. Восстанавливает параметры и вызывает FillAttrs для заполнения атрибутов. HL и DE восстанавливает, BC/F остаются результатом FillAttrs

**Вход:** DE — D высота, E ширина в знакоместах, BC — строка B и столбец C, AF — A атрибут, размеры ненулевые

**Выход:** пиксели обнулены, атрибуты заданы, HL, DE, A, IX, IY сохранены

**Изменяемые регистры и состояние:** BC, AF. HL, DE, HL', DE', BC', AF', IX, IY сохранены, внутри AF меняется F

**Дополнительно:** пиксели и атрибуты указанного прямоугольника

В сохранённом графе: 35 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #E4EA, #E53B.

### Presentation.CellAddress

Адрес #E53B, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L652).

вычислить экранный адрес верхней линии знакоместа

Из символьной строки B формирует раздельные части адреса Spectrum, затем прибавляет столбец C. Эквивалентный адрес #4000+((B AND #18)*256)+((B AND7)*32)+C. BC явно сохраняется через стек

**Вход:** BC — строка B=0..23 и столбец C=0..31

**Выход:** HL — адрес первой пиксельной линии знакоместа, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, AF. DE, BC, HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** нет записей вне стека

В сохранённом графе: 18 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Presentation.InitStars

Адрес #E556, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L687).

подготовить атрибуты фона и включить сто звёзд

Сохраняет все основные регистры. Заменяет opcode по PlotStar.StarPixelOp на #B6, то есть OR (HL). Заполняет все 768 атрибутов значением #45 и проходит 100 пар y, x по stars, включая каждую точку через PlotStar. Пиксельную память не очищает, координаты не меняет

**Вход:** массив 100 пар y, x по stars..#E7D7, координаты в пределах экрана

**Выход:** звёзды включены на фоне атрибута #45, все основные, альтернативные и индексные регистры сохранены

**Изменяемые регистры и состояние:** Нет, HL, DE, BC, AF, HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** #5800..#5AFF=#45, звёздные пиксели, opcode PlotStar.StarPixelOp=#B6

В сохранённом графе: 25 инструкций. Чтение: не выделено. Запись: #E5F4. Вызовы: #E5A2.

### Presentation.MoveStars

Адрес #E580, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L730).

сдвинуть сто звёзд на один пиксель влево

Выбирает XOR (HL) кодом #AE по PlotStar.StarPixelOp. Для каждой пары y, x переключает старый пиксель, уменьшает x как восьмибитное число с переходом 0->255, записывает его обратно и переключает новый пиксель. PlotStar пропускает точки под атрибутами отличными от #45. Сохраняет все основные регистры

**Вход:** массив звёзд stars..#E7D7 и экран

**Выход:** все 100 координат x уменьшены по модулю 256, основные, альтернативные и индексные регистры сохранены

**Изменяемые регистры и состояние:** Нет, HL, DE, BC, AF, HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** каждый второй байт массива stars..#E7D7, пиксели звёзд, opcode PlotStar.StarPixelOp=#AE

В сохранённом графе: 23 инструкций. Чтение: не выделено. Запись: #E5F4. Вызовы: #E5A2.

### Presentation.PlotStar

Адрес #E5A2, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L771).

изменить один звёздный пиксель только в области свободного фона

Проверяет атрибут знакоместа по пиксельным координатам, при значении неравном #45 выходит без вывода. Вычисляет нелинейный экранный адрес и маску #80>>(C AND7). Самомодифицируемая инструкция PlotStar.StarPixelOp либо OR-включает, либо XOR-переключает пиксель. HL, BC, AF сохраняются, DE не используется

**Вход:** BC — пиксельные y=B, x=C, opcode PlotStar.StarPixelOp=#B6 для OR или #AE для XOR

**Выход:** при атрибуте #45 точка обработана, все основные, альтернативные и индексные регистры сохранены

**Изменяемые регистры и состояние:** Нет, HL, DE, BC, AF, HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** один пиксель экрана при разрешающем атрибуте

В сохранённом графе: 61 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Presentation.RandomRange

Адрес #E5FA, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L853).

получить псевдослучайное целое от нуля до указанного предела

Три слова состояния по rng.SeedA, rng.SeedB, rng.SeedC переходят из (s0, s1, s2) в (s1, s2, ROL16(s0+s1+s2, 1)), сложение модульное 16 битное. Новое третье слово становится множителем BC. Побитное умножение этого слова на исходный предел DE формирует 32 битный результат, возврат — старшее слово с округлением вверх при бите 15 младшего слова. Формула round(limit*randomWord/65536), диапазон 0..limit включительно. Слово предела по rng разрушается сдвигами

**Вход:** DE — верхний предел, три слова состояния rng.SeedA..#E65D

**Выход:** DE — целое 0..исходного DE, HL, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** DE. HL, BC, AF, HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** rng..#E65D

В сохранённом графе: 46 инструкций. Чтение: #E658, #E65A, #E65C. Запись: #E656, #E658, #E65A, #E65C. Вызовы: не выделены.

### Presentation.LargeGlyph

Адрес #E65E, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L929).

нарисовать глиф титров с масштабом два по горизонтали и три по вертикали

По D задаёт цвет прямоугольнику 2x3 атрибута с началом (2*C, 3*B). Исходный глиф берёт по #DA00+8*E. Каждую из восьми строк ExpandBits разворачивает в 16 бит, затем LargeRow записывает её три раза в последовательные экранные строки. Получается 16x24 пикселя. Сохраняет HL, DE, BC, AF, IX, IY не использует

**Вход:** DE — D атрибут, E код глифа 32..255, BC — координаты увеличенной сетки x=C, y=B, вся область должна помещаться на экране

**Выход:** глиф 16x24 и шесть атрибутов выведены, основные, альтернативные и индексные регистры сохранены

**Изменяемые регистры и состояние:** Нет, HL, DE, BC, AF, HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** 16x24 пикселя и 2x3 атрибута экрана

В сохранённом графе: 74 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #E6D3, #E6FA.

### Presentation.LargeRow

Адрес #E6D3, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L1019).

записать шестнадцать пикселей и перейти к следующей экранной строке

Записывает D в (IX), E в (IX+1). Затем с учётом нелинейной адресации Spectrum переносит IX на следующую пиксельную строку, переходя через границу восьми линий и через экранную треть. HL явно сохраняет

**Вход:** DE — два байта пикселей слева направо, IX — экранный адрес первой половины строки

**Выход:** IX — тот же столбец следующей пиксельной строки, HL, DE, BC, IY сохранены

**Изменяемые регистры и состояние:** AF, IX. HL, DE, BC, HL', DE', BC', AF', IY сохранены

**Дополнительно:** два пиксельных байта экрана

В сохранённом графе: 25 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Presentation.ExpandBits

Адрес #E6FA, блок `S06`. [Source/Files/06_PRES.asm](../Source/Files/06_PRES.asm#L1062).

удвоить каждый бит восьмибитной строки в шестнадцатибитную

Восемь раз сдвигает DE на два бита и циклически читает очередной старший бит A. Для установленного бита выставляет оба младших бита E. Старые биты DE полностью вытесняются за 16 сдвигов. Восемь RLCA возвращают исходный A, BC явно восстанавливается

**Вход:** AF — A исходный байт пиксельной строки

**Выход:** DE — удвоенная 16 битная строка, A и BC сохранены

**Изменяемые регистры и состояние:** DE, AF. HL, BC, HL', DE', BC', AF', IX, IY сохранены, внутри AF меняется F

**Дополнительно:** нет записей вне стека

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

## Graphics.Heroes

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #7D33 | `Graphics.Heroes.Draw` | вход в самоперемещаемый распаковщик банка изображений | [Source/Files/08_HERIMG.asm](../Source/Files/08_HERIMG.asm#L18) |
| #7D39 | `Graphics.Heroes.Unpack` | выбор изображения, RLE-распаковка пикселей и атрибутов | [Source/Files/08_HERIMG.asm](../Source/Files/08_HERIMG.asm#L41) |

### Graphics.Heroes.Draw

Адрес #7D33, блок `S08`. [Source/Files/08_HERIMG.asm](../Source/Files/08_HERIMG.asm#L18).

вход в самоперемещаемый распаковщик банка изображений

JR пропускает четыре байта настроек по смещениям 2..5. Вызывающий код записывает номер картинки в смещение 2. Дальше исполняется общий алгоритм по адресу начала+6.

**Вход:** Draw.Picture — номер изображения от 1

**Выход:** переход к началу+6

**Изменяемые регистры и состояние:** HL, DE, BC, AF, BC', IY после завершения общего распаковщика

В сохранённом графе: 1 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7D39.

### Graphics.Heroes.Unpack

Адрес #7D39, блок `S08`. [Source/Files/08_HERIMG.asm](../Source/Files/08_HERIMG.asm#L41).

выбор изображения, RLE-распаковка пикселей и атрибутов

CALL #007C использует RET в ПЗУ, оставшийся в стеке адрес позволяет вычислить собственную базу и IY=начало+2. По цепочке относительных длин начиная с IY+#012A выбирается изображение. Поток содержит начальную треть экрана, число третей и флаги. Координаты ограничиваются диапазоном экрана. Бит 0 задаёт порядок обхода строк и столбцов, бит 2 означает продолжающуюся RLE-серию, бит 3 переключает вывод на линейные атрибуты. Ненулевой байт является литералом, нулевой открывает пару длина/значение. Счётчик серии и повторяемый байт хранятся в альтернативных B'/C', серия может пересекать границы внутренних циклов. Пиксели пишутся с нелинейным шагом Spectrum, затем записываются атрибуты. После вывода два поля выбора области сбрасываются в #FF.

**Вход:** настройки по IY, таблица относительных длин и упакованный поток

**Выход:** изображение в #4000..#5AFF, параметры области #FF

**Изменяемые регистры и состояние:** HL, DE, BC, AF, BC', IY

В сохранённом графе: 152 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #007C.

## Engine

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #615E | `Engine.MainEntry` | передать управление инициализации игры | [Source/Engine/MainEntry.asm](../Source/Engine/MainEntry.asm#L12) |
| #6161 | `Engine.Interrupt` | обработать маскируемое прерывание IM 2 | [Source/Engine/Interrupt.asm](../Source/Engine/Interrupt.asm#L17) |
| #631C | `Engine.LoadRamDrive` | загрузить RAMDRIVE в служебную область #5FA0 | [Source/Engine/LoadRamDrive.asm](../Source/Engine/LoadRamDrive.asm#L13) |
| #6335 | `Engine.Initialize` | инициализировать стек, IM 2, ресурсы и главный цикл | [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L15) |
| #6470 | `Engine.MainLoop` | обновлять экран и обрабатывать ввод основного режима | [Source/Engine/MainLoop.asm](../Source/Engine/MainLoop.asm#L14) |
| #6B8D | `Engine.ClearBank8` | очистить рабочую область логического банка 8 | [Source/Engine/ClearBank8.asm](../Source/Engine/ClearBank8.asm#L14) |
| #6BB0 | `Engine.CheckCalls` | проверить неизменность трёх инструкций CALL #6B8D | [Source/Engine/CheckCalls.asm](../Source/Engine/CheckCalls.asm#L17) |
| #6BE9 | `Engine.Wait20Frames` | выдержать двадцать прерываний | [Source/Engine/Wait20Frames.asm](../Source/Engine/Wait20Frames.asm#L12) |
| #6BF1 | `Engine.ReadInput` | прочитать клавиатуру или Kempston | [Source/Engine/ReadInput.asm](../Source/Engine/ReadInput.asm#L15) |
| #6C3B | `Engine.LoadOverlay` | скопировать выбранный оверлей в #B200 | [Source/Engine/LoadOverlay.asm](../Source/Engine/LoadOverlay.asm#L16) |
| #6C63 | `Engine.SaveOverlay` | сохранить изменённую рабочую копию оверлея в банк хранения | [Source/Engine/SaveOverlay.asm](../Source/Engine/SaveOverlay.asm#L14) |
| #6C89 | `Engine.OverlayBank` | выбрать банк хранения по номеру оверлея | [Source/Engine/OverlayBank.asm](../Source/Engine/OverlayBank.asm#L12) |
| #6C97 | `Engine.FindOverlay` | найти исходный адрес и размер оверлея | [Source/Engine/FindOverlay.asm](../Source/Engine/FindOverlay.asm#L13) |
| #6CB0 | `Engine.FindOverlayEnd` | найти следующий семибайтный маркер overlay | [Source/Engine/FindOverlayEnd.asm](../Source/Engine/FindOverlayEnd.asm#L13) |
| #6CC8 | `Engine.LoadFile` | загрузить именованный файл через TR-DOS | [Source/Engine/LoadFile.asm](../Source/Engine/LoadFile.asm#L13) |
| #6D15 | `Engine.CallTrdos` | вызвать TR-DOS с временным режимом IM 1 | [Source/Engine/CallTrdos.asm](../Source/Engine/CallTrdos.asm#L13) |
| #6D2F | `Engine.PageEI` | переключить логический банк и разрешить прерывания | [Source/Engine/PageEI.asm](../Source/Engine/PageEI.asm#L13) |
| #6D34 | `Engine.StopView` | выключить обработку объектов в прерывании | [Source/Engine/StopView.asm](../Source/Engine/StopView.asm#L12) |
| #6D3F | `Engine.ResetViewFlags` | сбросить младшие шесть флагов 48 записей объектов | [Source/Engine/ResetViewFlags.asm](../Source/Engine/ResetViewFlags.asm#L13) |
| #6D57 | `Engine.StartView` | включить обработку объектов в прерывании | [Source/Engine/StartView.asm](../Source/Engine/StartView.asm#L12) |
| #6D62 | `Engine.StackBC` | передать целое BC на стек калькулятора ROM | [Source/Engine/StackBC.asm](../Source/Engine/StackBC.asm#L13) |
| #6D76 | `Engine.PopBC` | извлечь результат калькулятора ROM в BC | [Source/Engine/PopBC.asm](../Source/Engine/PopBC.asm#L13) |
| #6D88 | `Engine.StackA` | передать байт A на стек калькулятора ROM | [Source/Engine/StackA.asm](../Source/Engine/StackA.asm#L13) |
| #6D9C | `Engine.PopA` | извлечь байтовое целое из калькулятора ROM | [Source/Engine/PopA.asm](../Source/Engine/PopA.asm#L14) |
| #6DAE | `Engine.StackFloat5` | передать пятибайтное число по HL на стек калькулятора | [Source/Engine/StackFloat5.asm](../Source/Engine/StackFloat5.asm#L14) |
| #6DC4 | `Engine.StoreFloat5` | сохранить вершину калькулятора в пятибайтное поле по HL | [Source/Engine/StoreFloat5.asm](../Source/Engine/StoreFloat5.asm#L14) |
| #6DDA | `Engine.FloatSignZero` | определить знак и нулевое значение результата калькулятора | [Source/Engine/FloatSignZero.asm](../Source/Engine/FloatSignZero.asm#L15) |
| #6E0E | `Engine.EditText` | редактировать строку с анимированным курсором | [Source/Engine/EditText.asm](../Source/Engine/EditText.asm#L15) |
| #6E79 | `Engine.DrawEditText` | перерисовать поле редактирования | [Source/Engine/DrawEditText.asm](../Source/Engine/DrawEditText.asm#L13) |
| #6EA0 | `Engine.ReadTextChar` | прочитать и преобразовать символ текстового ввода | [Source/Engine/ReadTextChar.asm](../Source/Engine/ReadTextChar.asm#L13) |
| #6F25 | `Engine.RemapKey` | заменить специальные коды клавиатуры по таблице | [Source/Engine/RemapKey.asm](../Source/Engine/RemapKey.asm#L12) |
| #6FC0 | `Engine.EditNumber` | ввести число из не более пяти цифр | [Source/Engine/EditNumber.asm](../Source/Engine/EditNumber.asm#L16) |
| #702B | `Engine.DrawGlyph` | нарисовать восьмистрочный символ шрифта | [Source/Engine/DrawGlyph.asm](../Source/Engine/DrawGlyph.asm#L15) |
| #7098 | `Engine.GlyphAddress` | вычислить экранный адрес и сдвиг символа | [Source/Engine/GlyphAddress.asm](../Source/Engine/GlyphAddress.asm#L14) |
| #70C5 | `Engine.DrawGlyphEI` | вывести символ с обычной процедурой переключения банка | [Source/Engine/DrawGlyphEI.asm](../Source/Engine/DrawGlyphEI.asm#L13) |
| #70D4 | `Engine.DrawGlyphDI` | вывести символ из прерывания с сохранением режима DI | [Source/Engine/DrawGlyphDI.asm](../Source/Engine/DrawGlyphDI.asm#L14) |
| #70E3 | `Engine.DrawNumber` | преобразовать число и вывести символы подряд | [Source/Engine/DrawNumber.asm](../Source/Engine/DrawNumber.asm#L14) |
| #7117 | `Engine.PrintMessage` | разобрать строку сообщения с управляющими кодами | [Source/Engine/PrintMessage.asm](../Source/Engine/PrintMessage.asm#L23) |
| #7227 | `Engine.NumberToDecimal` | преобразовать число калькулятора в десятичные цифры | [Source/Engine/NumberToDecimal.asm](../Source/Engine/NumberToDecimal.asm#L16) |
| #72ED | `Engine.GrabUnitTile` | сохранить фон и создать анимированный объект 4 на 4 знакоместа | [Source/Engine/GrabUnitTile.asm](../Source/Engine/GrabUnitTile.asm#L14) |
| #7341 | `Engine.ViewCellAddr` | найти экранный объект клетки и связанное численное поле | [Source/Engine/ViewCellAddr.asm](../Source/Engine/ViewCellAddr.asm#L14) |
| #7366 | `Engine.SetUnitPicture` | создать четырёхкадровый экранный объект | [Source/Engine/SetUnitPicture.asm](../Source/Engine/SetUnitPicture.asm#L14) |
| #73AD | `Engine.FillAttributes` | заполнить прямоугольник атрибутов цветом A | [Source/Engine/FillAttributes.asm](../Source/Engine/FillAttributes.asm#L12) |
| #73CF | `Engine.ClearRectangle` | обнулить пиксели прямоугольника и заполнить его атрибуты | [Source/Engine/ClearRectangle.asm](../Source/Engine/ClearRectangle.asm#L14) |
| #73FE | `Engine.DrawFrame` | нарисовать рамку окна из восьми одноклеточных элементов | [Source/Engine/DrawFrame.asm](../Source/Engine/DrawFrame.asm#L13) |
| #74F7 | `Engine.GrabTile4x4` | сохранить прямоугольник экрана 4 на 4 знакоместа в буфер DE | [Source/Engine/GrabTile4x4.asm](../Source/Engine/GrabTile4x4.asm#L13) |
| #7545 | `Engine.DrawRawSprite` | вывести непрозрачный спрайт с атрибутами | [Source/Engine/DrawRawSprite.asm](../Source/Engine/DrawRawSprite.asm#L14) |
| #75A2 | `Engine.DrawMask` | вывести пиксельный спрайт по маске | [Source/Engine/DrawMask.asm](../Source/Engine/DrawMask.asm#L13) |
| #75E1 | `Engine.DrawRawMirrored` | вывести непрозрачный спрайт с горизонтальным отражением | [Source/Engine/DrawRawMirrored.asm](../Source/Engine/DrawRawMirrored.asm#L14) |
| #7649 | `Engine.DrawMaskFlip` | вывести маскированный спрайт с горизонтальным отражением | [Source/Engine/DrawMaskFlip.asm](../Source/Engine/DrawMaskFlip.asm#L13) |
| #7693 | `Engine.CellAddress` | вычислить ZX-адрес верхней пиксельной строки знакоместа | [Source/Engine/CellAddress.asm](../Source/Engine/CellAddress.asm#L12) |
| #76AE | `Engine.ReverseBits` | отразить восемь бит байта A | [Source/Engine/ReverseBits.asm](../Source/Engine/ReverseBits.asm#L12) |
| #76BC | `Engine.DrawMenuCursor` | нарисовать указатель меню с пиксельным смещением | [Source/Engine/DrawMenuCursor.asm](../Source/Engine/DrawMenuCursor.asm#L13) |
| #76FB | `Engine.PixelAddress` | вычислить адрес байта экрана по пиксельным координатам | [Source/Engine/PixelAddress.asm](../Source/Engine/PixelAddress.asm#L13) |
| #7722 | `Engine.CursorMaskByte` | наложить один байт указателя в пределах пиксельной области | [Source/Engine/CursorMaskByte.asm](../Source/Engine/CursorMaskByte.asm#L14) |
| #7735 | `Engine.SaveCursor` | сохранить фон под указателем меню | [Source/Engine/SaveCursor.asm](../Source/Engine/SaveCursor.asm#L13) |
| #7750 | `Engine.RestoreCursor` | восстановить фон под старой позицией указателя | [Source/Engine/RestoreCursor.asm](../Source/Engine/RestoreCursor.asm#L13) |
| #776D | `Engine.SelectMenuItem` | управлять указателем и выбрать прямоугольный пункт меню | [Source/Engine/SelectMenuItem.asm](../Source/Engine/SelectMenuItem.asm#L16) |
| #787E | `Engine.HitTestMenu` | найти прямоугольник меню под пиксельным указателем | [Source/Engine/HitTestMenu.asm](../Source/Engine/HitTestMenu.asm#L14) |
| #78D6 | `Engine.InvertMenuItem` | поменять местами INK и PAPER прямоугольного пункта меню | [Source/Engine/InvertMenuItem.asm](../Source/Engine/InvertMenuItem.asm#L13) |
| #791E | `Engine.WaitMenuInput` | дождаться клавиши либо Kempston для меню | [Source/Engine/WaitMenuInput.asm](../Source/Engine/WaitMenuInput.asm#L14) |
| #7950 | `Engine.CursorUp` | сдвинуть указатель меню на пиксель вверх | [Source/Engine/CursorUp.asm](../Source/Engine/CursorUp.asm#L14) |
| #795C | `Engine.CursorDown` | сдвинуть указатель меню на пиксель вниз | [Source/Engine/CursorDown.asm](../Source/Engine/CursorDown.asm#L14) |
| #7968 | `Engine.CursorLeft` | сдвинуть указатель меню на пиксель влево | [Source/Engine/CursorLeft.asm](../Source/Engine/CursorLeft.asm#L13) |
| #7974 | `Engine.CursorRight` | сдвинуть указатель меню на пиксель вправо | [Source/Engine/CursorRight.asm](../Source/Engine/CursorRight.asm#L14) |
| #7980 | `Engine.ShiftCursorR` | циклически сдвинуть вправо 24 битные строки указателя и маски | [Source/Engine/ShiftCursorR.asm](../Source/Engine/ShiftCursorR.asm#L14) |
| #79A5 | `Engine.ShiftCursorL` | циклически сдвинуть влево 24 битные строки указателя и маски | [Source/Engine/ShiftCursorL.asm](../Source/Engine/ShiftCursorL.asm#L14) |
| #7A17 | `Engine.SumArmyPower` | сложить произведения количества отрядов на поле силы типа | [Source/Engine/SumArmyPower.asm](../Source/Engine/SumArmyPower.asm#L17) |
| #7A4E | `Engine.SelectThreshold` | определить одну из четырёх категорий по порогам | [Source/Engine/SelectThreshold.asm](../Source/Engine/SelectThreshold.asm#L13) |
| #7A74 | `Engine.IndexFourBytes` | сместить IX к четырёхбайтной записи с индексом A | [Source/Engine/IndexFourBytes.asm](../Source/Engine/IndexFourBytes.asm#L12) |
| #7A80 | `Engine.NthName` | найти строку имени в списке с нулевыми разделителями | [Source/Engine/NthName.asm](../Source/Engine/NthName.asm#L13) |
| #7A94 | `Engine.ClearTwoFlags` | обнулить два связанных байта таблиц | [Source/Engine/ClearTwoFlags.asm](../Source/Engine/ClearTwoFlags.asm#L12) |
| #7AA4 | `Engine.IndexFlagArray` | получить указатель IX=#6A72+A | [Source/Engine/IndexFlagArray.asm](../Source/Engine/IndexFlagArray.asm#L12) |
| #7AB0 | `Engine.ArmyRating` | рассчитать оценку армии из суммы взвешенных количеств | [Source/Engine/ArmyRating.asm](../Source/Engine/ArmyRating.asm#L16) |
| #7AEF | `Engine.UnitFlags` | прочитать пару флагов описателя отряда | [Source/Engine/UnitFlags.asm](../Source/Engine/UnitFlags.asm#L12) |
| #7B0B | `Engine.MarkMapObjects` | пометить занятые клетки карты для групп объектов | [Source/Engine/MarkMapObjects.asm](../Source/Engine/MarkMapObjects.asm#L14) |
| #7B97 | `Engine.MarkObjectGroup` | установить бит 7 карты под активными записями группы | [Source/Engine/MarkObjectGroup.asm](../Source/Engine/MarkObjectGroup.asm#L16) |
| #7BE3 | `Engine.MarkMapCell` | установить бит 7 байта клетки стратегической карты | [Source/Engine/MarkMapCell.asm](../Source/Engine/MarkMapCell.asm#L14) |
| #7BF4 | `Engine.WaitOrInput` | выдержать паузу с досрочным выходом по вводу | [Source/Engine/WaitOrInput.asm](../Source/Engine/WaitOrInput.asm#L15) |
| #7C0D | `Engine.RandomScaled` | получить масштабированное псевдослучайное число | [Source/Engine/RandomScaled.asm](../Source/Engine/RandomScaled.asm#L16) |
| #7C71 | `Engine.GetDirection` | определить одно из восьми направлений от BC к DE | [Source/Engine/GetDirection.asm](../Source/Engine/GetDirection.asm#L15) |
| #7D6B | `Engine.CountWord` | выбрать словесное описание величины HL | [Source/Engine/CountWord.asm](../Source/Engine/CountWord.asm#L13) |
| #7E55 | `Engine.PrintArmyBrief` | вывести краткий список состава армии | [Source/Engine/PrintArmyBrief.asm](../Source/Engine/PrintArmyBrief.asm#L15) |
| #7EA7 | `Engine.FormatUnitName` | сформировать имя типа отряда со специальным окончанием | [Source/Engine/FormatUnitName.asm](../Source/Engine/FormatUnitName.asm#L15) |
| #7F40 | `Engine.MoveToTarget` | преобразовать направление к цели в команду движения героя | [Source/Engine/MoveToTarget.asm](../Source/Engine/MoveToTarget.asm#L15) |
| #7F5F | `Engine.NearestObject` | найти ближайшую активную запись выбранной группы | [Source/Engine/NearestObject.asm](../Source/Engine/NearestObject.asm#L17) |
| #7FF0 | `Engine.FloorDistance` | вычислить целую часть евклидова расстояния | [Source/Engine/FloorDistance.asm](../Source/Engine/FloorDistance.asm#L16) |
| #801F | `Engine.SquareByte` | возвести беззнаковый байт A в квадрат | [Source/Engine/SquareByte.asm](../Source/Engine/SquareByte.asm#L12) |
| #8036 | `Engine.UnitDesc` | получить описатель типа отряда | [Source/Engine/UnitDesc.asm](../Source/Engine/UnitDesc.asm#L13) |
| #804E | `Engine.RulerDesc` | получить описатель одного из пятнадцати вражеских правителей | [Source/Engine/RulerDesc.asm](../Source/Engine/RulerDesc.asm#L14) |
| #8066 | `Engine.SpellDesc` | получить описатель одного из десяти заклинаний | [Source/Engine/SpellDesc.asm](../Source/Engine/SpellDesc.asm#L14) |
| #807E | `Engine.CompactArmy` | сжать список трёхбайтных записей армии | [Source/Engine/CompactArmy.asm](../Source/Engine/CompactArmy.asm#L14) |
| #80AE | `Engine.SelectMapBank` | выбрать логический банк 10 с текущей картой | [Source/Engine/SelectMapBank.asm](../Source/Engine/SelectMapBank.asm#L12) |
| #80B4 | `Engine.MapCellAddress` | вычислить адрес клетки карты | [Source/Engine/MapCellAddress.asm](../Source/Engine/MapCellAddress.asm#L12) |
| #80C4 | `Engine.ReadMapCell` | прочитать байт клетки текущей карты | [Source/Engine/ReadMapCell.asm](../Source/Engine/ReadMapCell.asm#L12) |
| #80DB | `Engine.UnitSpriteAddr` | выбрать банк и начало четырёхкадрового графического ресурса | [Source/Engine/UnitSpriteAddr.asm](../Source/Engine/UnitSpriteAddr.asm#L14) |
| #8104 | `Engine.RenderObjects` | обновить 48 экранных объектов сетки 8 на 6 | [Source/Engine/RenderObjects.asm](../Source/Engine/RenderObjects.asm#L15) |
| #8244 | `Engine.DrawBackLayer` | нарисовать фон объекта 4 на 4 знакоместа | [Source/Engine/DrawBackLayer.asm](../Source/Engine/DrawBackLayer.asm#L12) |
| #825B | `Engine.DrawMaskLayer` | нарисовать маскированный слой объекта 4 на 4 знакоместа | [Source/Engine/DrawMaskLayer.asm](../Source/Engine/DrawMaskLayer.asm#L13) |
| #827A | `Engine.DrawCountDI` | вывести беззнаковое число из HL при обработке прерывания | [Source/Engine/DrawCountDI.asm](../Source/Engine/DrawCountDI.asm#L14) |
| #82D5 | `Engine.UpdateLocalView` | отметить открытые клетки вокруг героя и подготовить экранные объекты | [Source/Engine/UpdateLocalView.asm](../Source/Engine/UpdateLocalView.asm#L15) |
| #84ED | `Engine.PlaceViewLayer` | поставить графический слой только на текущем континенте и в области обзора | [Source/Engine/PlaceViewLayer.asm](../Source/Engine/PlaceViewLayer.asm#L18) |
| #8543 | `Engine.PlaceGroup` | разместить прямоугольные объекты группы в локальном окне | [Source/Engine/PlaceGroup.asm](../Source/Engine/PlaceGroup.asm#L18) |
| #85D0 | `Engine.PlaceCells` | разместить одноклеточные записи группы в локальном окне | [Source/Engine/PlaceCells.asm](../Source/Engine/PlaceCells.asm#L16) |
| #8652 | `Engine.InLocalView` | проверить попадание координат BC в прямоугольник локального окна | [Source/Engine/InLocalView.asm](../Source/Engine/InLocalView.asm#L13) |
| #8672 | `Engine.RunOwnCastle` | загрузить и выполнить обработчик своего замка | [Source/Engine/RunOwnCastle.asm](../Source/Engine/RunOwnCastle.asm#L14) |
| #867D | `Engine.TerrainMask` | преобразовать младшие шесть бит байта местности по таблице порогов | [Source/Engine/TerrainMask.asm](../Source/Engine/TerrainMask.asm#L13) |
| #8697 | `Engine.TerrainBattle` | преобразовать местность по второй таблице порогов | [Source/Engine/TerrainBattle.asm](../Source/Engine/TerrainBattle.asm#L13) |
| #86B1 | `Engine.FreeCapacity` | вычислить остаток допустимого количества выбранного типа отряда | [Source/Engine/FreeCapacity.asm](../Source/Engine/FreeCapacity.asm#L14) |
| #86EA | `Engine.ControlLimit` | рассчитать численный предел типа отряда из поля героя и таблицы | [Source/Engine/ControlLimit.asm](../Source/Engine/ControlLimit.asm#L13) |
| #8712 | `Engine.BottomFrame` | нарисовать окно в нижней части экрана | [Source/Engine/BottomFrame.asm](../Source/Engine/BottomFrame.asm#L12) |
| #871C | `Engine.NeedMoreMoney` | вывести сообщение о нехватке денег | [Source/Engine/NeedMoreMoney.asm](../Source/Engine/NeedMoreMoney.asm#L12) |
| #8799 | `Engine.RunOverlay20` | выполнить оверлей 20 и продолжить подсчётом записей | [Source/Engine/RunOverlay20.asm](../Source/Engine/RunOverlay20.asm#L14) |
| #87A1 | `Engine.CountOwnCastles` | подсчитать записи банка 0 по флагу и полю #13 | [Source/Engine/CountOwnCastles.asm](../Source/Engine/CountOwnCastles.asm#L14) |
| #87D1 | `Engine.HasOwnerCastle` | найти активную запись с заданным владельцем | [Source/Engine/HasOwnerCastle.asm](../Source/Engine/HasOwnerCastle.asm#L15) |
| #8801 | `Engine.ShowScene` | показать одну из девяти упакованных сцен BL1/BL2 с восстановлением банка и основных регистров | [Source/Engine/ShowScene.asm](../Source/Engine/ShowScene.asm#L21) |
| #883A | `Engine.BuildArmy` | преобразовать состав армии в пять боевых записей по 18 байт | [Source/Engine/BuildArmy.asm](../Source/Engine/BuildArmy.asm#L18) |
| #88FA | `Engine.StoreArmy` | преобразовать боевые записи обратно в исходный состав армии | [Source/Engine/StoreArmy.asm](../Source/Engine/StoreArmy.asm#L17) |
| #896D | `Engine.ArmyMood` | оценить совместимость типа отряда с составом армии | [Source/Engine/ArmyMood.asm](../Source/Engine/ArmyMood.asm#L17) |
| #89E0 | `Engine.LoseLeadership` | уменьшить 16 битное поле героя #6A02 с насыщением 0 | [Source/Engine/LoseLeadership.asm](../Source/Engine/LoseLeadership.asm#L14) |
| #8A08 | `Engine.GainLeadership` | увеличить 16 битное поле героя #6A02 с насыщением #FFFF | [Source/Engine/GainLeadership.asm](../Source/Engine/GainLeadership.asm#L14) |
| #8A2C | `Engine.HandleMapInput` | получить команду главного режима и обработать движение | [Source/Engine/HandleMapInput.asm](../Source/Engine/HandleMapInput.asm#L16) |
| #8A31 | `Engine.ApplyMoveCode` | применить уже полученный код движения к позиции героя | [Source/Engine/ApplyMoveCode.asm](../Source/Engine/ApplyMoveCode.asm#L14) |
| #8BDD | `Engine.MapMoveUp` | уменьшить строку героя в пределах рабочей части карты | [Source/Engine/MapMoveUp.asm](../Source/Engine/MapMoveUp.asm#L14) |
| #8BF2 | `Engine.MapMoveDown` | увеличить строку героя в пределах рабочей части карты | [Source/Engine/MapMoveDown.asm](../Source/Engine/MapMoveDown.asm#L14) |
| #8BF9 | `Engine.MapMoveLeft` | уменьшить столбец героя и повернуть его влево | [Source/Engine/MapMoveLeft.asm](../Source/Engine/MapMoveLeft.asm#L15) |
| #8C15 | `Engine.MapMoveRight` | увеличить столбец героя и повернуть его вправо | [Source/Engine/MapMoveRight.asm](../Source/Engine/MapMoveRight.asm#L14) |
| #8C31 | `Engine.MoveMask` | получить маску по текущему байту местности | [Source/Engine/MoveMask.asm](../Source/Engine/MoveMask.asm#L12) |
| #8C39 | `Engine.FilterArmy` | отфильтровать армию по маске местности и обновить записи | [Source/Engine/FilterArmy.asm](../Source/Engine/FilterArmy.asm#L18) |
| #8CD1 | `Engine.FindMapObject` | определить тип объекта в координатах #8D29 | [Source/Engine/FindMapObject.asm](../Source/Engine/FindMapObject.asm#L15) |
| #8D6E | `Engine.FindRecord` | найти активную запись группы, покрывающую координату HL | [Source/Engine/FindRecord.asm](../Source/Engine/FindRecord.asm#L16) |
| #8DDA | `Engine.StepArmies` | сближение, отступление и разделение внешних армий около героя | [Source/Engine/StepArmies.asm](../Source/Engine/StepArmies.asm#L32) |
| #9173 | `Engine.InNearbyRect` | проверить координаты DE относительно ближайшей области героя | [Source/Engine/InNearbyRect.asm](../Source/Engine/InNearbyRect.asm#L12) |
| #9193 | `Engine.CompareArmies` | сопоставить взвешенные величины двух составов армии | [Source/Engine/CompareArmies.asm](../Source/Engine/CompareArmies.asm#L15) |
| #91B6 | `Engine.SumArmyBank1` | вычислить сумму полей армии из банка 1 | [Source/Engine/SumArmyBank1.asm](../Source/Engine/SumArmyBank1.asm#L13) |
| #91BF | `Engine.SetFacing` | изменить бит 6 флагов объекта по коду направления | [Source/Engine/SetFacing.asm](../Source/Engine/SetFacing.asm#L13) |
| #91D1 | `Engine.StepsUp` | сформировать три варианта шага вверх | [Source/Engine/StepsUp.asm](../Source/Engine/StepsUp.asm#L14) |
| #91E1 | `Engine.StepsUpRight` | сформировать три варианта шага вверх-вправо | [Source/Engine/StepsUpRight.asm](../Source/Engine/StepsUpRight.asm#L13) |
| #91EE | `Engine.StepsRight` | сформировать три варианта шага вправо | [Source/Engine/StepsRight.asm](../Source/Engine/StepsRight.asm#L13) |
| #91FE | `Engine.StepsDownRight` | сформировать три варианта шага вниз-вправо | [Source/Engine/StepsDownRight.asm](../Source/Engine/StepsDownRight.asm#L13) |
| #920B | `Engine.StepsDown` | сформировать три варианта шага вниз | [Source/Engine/StepsDown.asm](../Source/Engine/StepsDown.asm#L13) |
| #921B | `Engine.StepsDownLeft` | сформировать три варианта шага вниз-влево | [Source/Engine/StepsDownLeft.asm](../Source/Engine/StepsDownLeft.asm#L13) |
| #9228 | `Engine.StepsLeft` | сформировать три варианта шага влево | [Source/Engine/StepsLeft.asm](../Source/Engine/StepsLeft.asm#L13) |
| #9238 | `Engine.StepsUpLeft` | сформировать три варианта шага вверх-влево | [Source/Engine/StepsUpLeft.asm](../Source/Engine/StepsUpLeft.asm#L13) |
| #9245 | `Engine.MakeSteps` | построить три возможных шага объекта и вызвать обработчик направления | [Source/Engine/MakeSteps.asm](../Source/Engine/MakeSteps.asm#L16) |
| #9270 | `Engine.ClassifySteps` | заполнить тип местности у трёх возможных шагов | [Source/Engine/ClassifySteps.asm](../Source/Engine/ClassifySteps.asm#L15) |
| #92CB | `Engine.StepMapTroops` | перемещение шестибайтовых объектов из континентальной таблицы #6B69 | [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L31) |
| #944A | `Engine.RefreshPanels` | перерисовать верхнюю строку и боковую панель игры | [Source/Engine/RefreshPanels.asm](../Source/Engine/RefreshPanels.asm#L14) |
| #9468 | `Engine.PrintDate` | разобрать счётчик дней и вывести календарную дату | [Source/Engine/PrintDate.asm](../Source/Engine/PrintDate.asm#L14) |
| #94C8 | `Engine.PrintZeroText` | вывести строку с нулевым терминатором | [Source/Engine/PrintZeroText.asm](../Source/Engine/PrintZeroText.asm#L13) |
| #94D2 | `Engine.PrintU16` | вывести 16 битное число HL без ведущих нулей | [Source/Engine/PrintU16.asm](../Source/Engine/PrintU16.asm#L15) |
| #957C | `Engine.RefreshHero` | обновить боковую панель героя, расходы и рейтинг | [Source/Engine/RefreshHero.asm](../Source/Engine/RefreshHero.asm#L16) |
| #9704 | `Engine.TickTime` | продвинуть время игры и выполнить периодические расчёты | [Source/Engine/TickTime.asm](../Source/Engine/TickTime.asm#L18) |
| #9E6D | `Engine.ClearLeftPanel` | очистить основную область слева от боковой панели | [Source/Engine/ClearLeftPanel.asm](../Source/Engine/ClearLeftPanel.asm#L12) |
| #9E78 | `Engine.StackTroopCost` | передать стоимость отряда на стек калькулятора | [Source/Engine/StackTroopCost.asm](../Source/Engine/StackTroopCost.asm#L15) |
| #9EA5 | `Engine.SumExpenses` | сложить отмеченные статьи расходов | [Source/Engine/SumExpenses.asm](../Source/Engine/SumExpenses.asm#L15) |
| #9ECA | `Engine.DevelopTroops` | повышать либо понижать типы отрядов по счётчикам | [Source/Engine/DevelopTroops.asm](../Source/Engine/DevelopTroops.asm#L17) |
| #A056 | `Engine.AddTroops` | добавить количество BC к типу отряда A в армии героя | [Source/Engine/AddTroops.asm](../Source/Engine/AddTroops.asm#L15) |
| #A082 | `Engine.RegenMana` | пополнить численные запасы с ограничением максимума | [Source/Engine/RegenMana.asm](../Source/Engine/RegenMana.asm#L16) |
| #A0FC | `Engine.AddClampedU16` | прибавить BC к HL с верхней границей DE | [Source/Engine/AddClampedU16.asm](../Source/Engine/AddClampedU16.asm#L13) |
| #A107 | `Engine.WeekEvent` | обработать наступление новой недели и связанное изменение типа существ | [Source/Engine/WeekEvent.asm](../Source/Engine/WeekEvent.asm#L18) |
| #A205 | `Engine.GrowTroop` | увеличить количество заданного типа в трёхбайтной записи | [Source/Engine/GrowTroop.asm](../Source/Engine/GrowTroop.asm#L16) |
| #A235 | `Engine.RefreshTowns` | обновить армии объектов группы #6AF9 | [Source/Engine/RefreshTowns.asm](../Source/Engine/RefreshTowns.asm#L17) |
| #A2E0 | `Engine.CheckRevolt` | проверить превышение контроля и обработать доплату либо бой с отделившимся отрядом | [Source/Engine/CheckRevolt.asm](../Source/Engine/CheckRevolt.asm#L30) |
| #A5AE | `Engine.TickCastle` | обновить угрозу замку, автоматически разрешить штурм либо подготовить перенос героя | [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L42) |
| #AC78 | `Engine.RepopulateSites` | восстановить население опустевших объектов по ближайшему населённому объекту | [Source/Engine/RepopulateSites.asm](../Source/Engine/RepopulateSites.asm#L17) |
| #AD31 | `Engine.MoveSitesC` | случайно переместить записи группы #6B39 в соседнюю свободную клетку | [Source/Engine/MoveSitesC.asm](../Source/Engine/MoveSitesC.asm#L17) |
| #ADBF | `Engine.SumCastleIncome` | сложить доход принадлежащих герою замков на четырёх континентах | [Source/Engine/SumCastleIncome.asm](../Source/Engine/SumCastleIncome.asm#L15) |
| #AE1A | `Engine.CastleIncome` | рассчитать доход замка с учётом ближайших городов | [Source/Engine/CastleIncome.asm](../Source/Engine/CastleIncome.asm#L15) |

### Engine.MainEntry

Адрес #615E, блок `S10`. [Source/Engine/MainEntry.asm](../Source/Engine/MainEntry.asm#L12).

передать управление инициализации игры

безусловный переход на #6335, файл содержит открытый машинный код

**Вход:** состояние загрузчика BL3, установленный переключатель банков #5FA1

**Выход:** без возврата передаёт управление #6335, затем главному циклу

**Изменяемые регистры и состояние:** определяется инициализацией #6335, в том числе SP, I, IM и IFF

В сохранённом графе: 1 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6335.

### Engine.Interrupt

Адрес #6161, блок `S10`. [Source/Engine/Interrupt.asm](../Source/Engine/Interrupt.asm#L17).

обработать маскируемое прерывание IM 2

сохраняет основные и альтернативные регистры, IX, IY, текущий банк и изменяемые адреса вызова в #703B и #708D, увеличивает 16-битный счётчик #6561, при бите 5 #6566 обновляет анимацию символов #F2..#F5 через #70D4, при бите 2 вызывает #8104, затем ROM #386E и проверку #6BB0, восстанавливает состояние, EI, RETI

**Вход:** маскируемое прерывание IM 2, SP в доступной памяти, #6566 задаёт фоновые работы

**Выход:** HL, DE, BC, AF, IX, IY сохранены, выбранный до входа банк восстановлен, прерывания разрешены после EI/RETI

**Изменяемые регистры и состояние:** основные и альтернативные HL, DE, BC, AF, IX, IY сохранены, R естественно увеличивается при исполнении, память фоновых процедур и счётчик #6561 изменены

В сохранённом графе: 69 инструкций. Чтение: #5FA0, #655F, #6560, #6561, #6563, #6566, #703B, #708D. Запись: #655F, #6560, #6561, #703B, #708D. Вызовы: #386E, #5FA1, #6BB0, #70D4, #8104.

### Engine.LoadRamDrive

Адрес #631C, блок `S10`. [Source/Engine/LoadRamDrive.asm](../Source/Engine/LoadRamDrive.asm#L13).

загрузить RAMDRIVE в служебную область #5FA0

копирует 9 байт имени RAMDRIVEC из #62A7 в #5CDD и вызывает TR-DOS через #6D15, адрес загрузки #5FA0

**Вход:** TR-DOS доступен, область #5FA0 для загрузки RAMDRIVE

**Выход:** RAMDRIVE загружен по #5FA0, после CALL #6D15 выполнение продолжается в #6335 без RET

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY и регистры TR-DOS, далее инициализация меняет SP, I, IM и IFF

В сохранённом графе: 10 инструкций. Чтение: не выделено. Запись: #5D10. Вызовы: #6D15.

### Engine.Initialize

Адрес #6335, блок `S10`. [Source/Engine/Initialize.asm](../Source/Engine/Initialize.asm#L15).

инициализировать стек, IM 2, ресурсы и главный цикл

SP=#62A5, #6000..#6100 заполнены #61, I=#60, IM 2, загружаются ресурсы по именам из таблицы #62A7..#631B, в конце #6470 начинается цикл игры

**Вход:** таблицы состояния, подготовленные BL3, переключатель #5FA1, диск с ресурсами

**Выход:** SP=#62A5, I=#60, IM2, векторная область #6000..#6100 заполнена #61, ресурсы загружены, далее бесконечный главный цикл #6470

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, SP, I, IM, IFF и память инициализируемых ресурсов, возврата по исходному стеку нет

В сохранённом графе: 118 инструкций. Чтение: #5C78, #5C79, #69ED, #6A2D, #6A44, #6A4B, #6A4D. Запись: #62E2, #62F1, #630D, #6315, #7C6B, #7C6D, #7C6F. Вызовы: #5FA1, #6B8D, #6CC8, #7B0B, #80AE, #80B4, #944A.

### Engine.MainLoop

Адрес #6470, блок `S10`. [Source/Engine/MainLoop.asm](../Source/Engine/MainLoop.asm#L14).

обновлять экран и обрабатывать ввод основного режима

#82D5, HALT, #8A2C, поиск пары в таблице #653A, загрузка оверлея #6C3B и CALL #B200, при отсутствии клавиши обработка #9704/#8DDA/#92CB и событий карты через #8CD1/#8D6E

**Вход:** инициализированные модули, #6A2D континент, #6A2E позиция, #6A33 режим, таблицы оверлеев

**Выход:** обновляет вид, ввод, время и взаимодействия, продолжает главный цикл без обычного RET

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY и состояния вызываемых модулей, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 80 инструкций. Чтение: #6A2E, #6A31, #6A33. Запись: #6A31, #8D29. Вызовы: #6C3B, #6C63, #6D2F, #80C4, #82D5, #8A2C, #8CD1, #8D6E, #8DDA, #92CB, #944A, #9704, #B200.

### Engine.ClearBank8

Адрес #6B8D, блок `S10`. [Source/Engine/ClearBank8.asm](../Source/Engine/ClearBank8.asm#L14).

очистить рабочую область логического банка 8

сохраняет банк, включает 8, заполняет нулём #C000..#D8EF включительно, восстанавливает банк, регистры HL, DE, BC, AF сохранены

**Вход:** состояние рабочих таблиц и текущий логический банк

**Выход:** HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, альтернативные регистры не используются в собственном коде, возможные прерывания работают независимо

В сохранённом графе: 20 инструкций. Чтение: #5FA0. Запись: не выделена. Вызовы: #6D2F.

### Engine.CheckCalls

Адрес #6BB0, блок `S10`. [Source/Engine/CheckCalls.asm](../Source/Engine/CheckCalls.asm#L17).

проверить неизменность трёх инструкций CALL #6B8D

таблица адресов #6BE3 содержит #634D, #9455, #9587, в каждом месте проверяются opcode #CD и адрес #6B8D, нарушение ведёт на #0000, это явная встроенная проверка целостности

**Вход:** состояние рабочих таблиц и текущий логический банк

**Выход:** HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, альтернативные регистры не используются в собственном коде, возможные прерывания работают независимо

**Дополнительно:** Сохранение регистров действует только при успешной проверке. Любое несовпадение немедленно передаёт управление #0000, выполняя сброс вместо возврата вызывающей процедуре.

В сохранённом графе: 30 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.Wait20Frames

Адрес #6BE9, блок `S10`. [Source/Engine/Wait20Frames.asm](../Source/Engine/Wait20Frames.asm#L12).

выдержать двадцать прерываний

B=20 и цикл HALT/DJNZ, исходный BC сохранён

**Вход:** маскируемые прерывания должны быть разрешены, иначе HALT может не завершиться

**Выход:** выполнены 20 последовательных HALT, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, собственный код не затрагивает альтернативные регистры

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.ReadInput

Адрес #6BF1, блок `S10`. [Source/Engine/ReadInput.asm](../Source/Engine/ReadInput.asm#L15).

прочитать клавиатуру или Kempston

вызывает ROM #028E, E=#FF означает отсутствие клавиши, затем десять раз опрашивает порт #1F и объединяет результаты, fire возвращает код #27, направления преобразуются таблицей #6C2B, carry установлен при распознанном вводе

**Вход:** состояние клавиатурной матрицы и порта Kempston #1F

**Выход:** AF, carry=1 при распознанном вводе и A код команды, carry=0 при отсутствии ввода, HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF, альтернативные регистры ROM #028E отдельно не проверены

В сохранённом графе: 36 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #028E.

### Engine.LoadOverlay

Адрес #6C3B, блок `S10`. [Source/Engine/LoadOverlay.asm](../Source/Engine/LoadOverlay.asm#L16).

скопировать выбранный оверлей в #B200

номер A сохраняется в #655E, #6C89 выбирает логический банк 12 либо 13, номер >=14 уменьшается на 13, #6C97 возвращает исходный адрес и длину, LDIR копирует блок вместе с конечным маркером overlay

**Вход:** AF, A номер оверлея 1..22

**Выход:** HL, DE, BC, AF, IX, IY сохранены, выбранный до входа банк восстановлен, рабочий модуль размещён по #B200

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, #655E меняется, процедура не сохраняет предыдущее состояние IFF и заканчивает с разрешёнными прерываниями

В сохранённом графе: 22 инструкций. Чтение: #5FA0, #655E. Запись: #655E. Вызовы: #6C89, #6C97, #6D2F.

### Engine.SaveOverlay

Адрес #6C63, блок `S10`. [Source/Engine/SaveOverlay.asm](../Source/Engine/SaveOverlay.asm#L14).

сохранить изменённую рабочую копию оверлея в банк хранения

обратное направление #6C3B, адреса меняются EX DE, HL перед LDIR, номер берётся из #655E, сохраняются самoизменяемые поля рабочего модуля

**Вход:** состояние рабочих таблиц и текущий логический банк

**Выход:** HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, альтернативные регистры не используются в собственном коде, возможные прерывания работают независимо

В сохранённом графе: 22 инструкций. Чтение: #5FA0, #655E. Запись: не выделена. Вызовы: #6C89, #6C97, #6D2F.

### Engine.OverlayBank

Адрес #6C89, блок `S10`. [Source/Engine/OverlayBank.asm](../Source/Engine/OverlayBank.asm#L12).

выбрать банк хранения по номеру оверлея

номер <14 выбирает логический банк 12, остальные банк 13

**Вход:** #655E номер оверлея

**Выход:** AF, A выбранный логический банк 12 либо 13, банк включён, EI

**Изменяемые регистры и состояние:** AF, остальные HL, DE, BC, IX, IY собственный код и установленный драйвер сохраняют

В сохранённом графе: 7 инструкций. Чтение: #655E. Запись: не выделена. Вызовы: #6D2F.

### Engine.FindOverlay

Адрес #6C97, блок `S10`. [Source/Engine/FindOverlay.asm](../Source/Engine/FindOverlay.asm#L13).

найти исходный адрес и размер оверлея

HL начинается с #C000, пропускает A-1 блоков по маркеру overlay, затем находит конец текущего блока, возвращает HL началом, BC длиной, длина включает семибайтный конечный маркер

**Вход:** AF, A номер блока внутри банка начиная с 1, банк оверлеев уже выбран

**Выход:** HL начало блока, DE длина блока, BC та же длина, длина включает маркер overlay

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX и IY не меняются, предел поиска не задан

В сохранённом графе: 16 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6CB0.

### Engine.FindOverlayEnd

Адрес #6CB0, блок `S10`. [Source/Engine/FindOverlayEnd.asm](../Source/Engine/FindOverlayEnd.asm#L13).

найти следующий семибайтный маркер overlay

сканирует память по байту, сравнивая с #6CC1, HL возвращает адрес сразу после маркера, верхней границы поиска нет

**Вход:** HL начало поиска, доступный завершающий маркер overlay

**Выход:** HL сразу после маркера, DE=#6CC8, BC, B=0 и C сохранён, A последний байт маркера

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX и IY не меняются

В сохранённом графе: 11 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.LoadFile

Адрес #6CC8, блок `S10`. [Source/Engine/LoadFile.asm](../Source/Engine/LoadFile.asm#L13).

загрузить именованный файл через TR-DOS

HL адрес девятибайтного имени с типом, DE адрес загрузки, имя переносится в #5CDD, #5D10=0, HL=адрес назначения, C=#0E, A=3, переход на #6D15

**Вход:** HL девятибайтное имя с типом, DE адрес загрузки

**Выход:** результат сервиса TR-DOS #0E, IM 2 и EI восстановлены

**Изменяемые регистры и состояние:** HL, DE, BC, AF и регистры, изменяемые TR-DOS, точный контракт сервиса здесь не установлен

В сохранённом графе: 10 инструкций. Чтение: не выделено. Запись: #5D10. Вызовы: #6D15.

### Engine.CallTrdos

Адрес #6D15, блок `S10`. [Source/Engine/CallTrdos.asm](../Source/Engine/CallTrdos.asm#L13).

вызвать TR-DOS с временным режимом IM 1

DI, IY=#5C3A, I=#3F, IM1, EI, CALL #3D13, после возврата DI, I=#60, IM2, EI, RET

**Вход:** HL, DE, BC, AF параметры выбранного сервиса TR-DOS, операция в C

**Выход:** результат TR-DOS, I=#60, IM 2, EI, IY=#5C3A перед вызовом сервиса

**Изменяемые регистры и состояние:** регистры определяются сервисом TR-DOS, исходные I, IM и IFF не восстанавливаются, устанавливается игровой режим IM 2/EI

В сохранённом графе: 15 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #3D13.

### Engine.PageEI

Адрес #6D2F, блок `S10`. [Source/Engine/PageEI.asm](../Source/Engine/PageEI.asm#L13).

переключить логический банк и разрешить прерывания

CALL #5FA1, EI, RET, собственный формат номера банка реализует RAMDRIVE

**Вход:** AF, A логический банк 0..15

**Выход:** HL, DE, BC, AF, IX, IY сохранены, #5FA0=A, выбран соответствующий банк, EI

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, IFF заменяется разрешённым состоянием, переключение действует на отображение памяти #C000..#FFFF

В сохранённом графе: 3 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #5FA1.

### Engine.StopView

Адрес #6D34, блок `S10`. [Source/Engine/StopView.asm](../Source/Engine/StopView.asm#L12).

выключить обработку объектов в прерывании

сбрасывает бит 2 в #6566, AF сохранён

**Вход:** флаг фоновой обработки в #6566

**Выход:** бит 2 #6566 сброшен, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** регистры не изменяются, меняется только байт #6566

В сохранённом графе: 6 инструкций. Чтение: #6566. Запись: #6566. Вызовы: не выделены.

### Engine.ResetViewFlags

Адрес #6D3F, блок `S10`. [Source/Engine/ResetViewFlags.asm](../Source/Engine/ResetViewFlags.asm#L13).

сбросить младшие шесть флагов 48 записей объектов

первая запись #6571, шаг 20, каждая маскируется #C0, HL, DE, BC, AF сохранены

**Вход:** состояние рабочих таблиц и текущий логический банк

**Выход:** HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, альтернативные регистры не используются в собственном коде, возможные прерывания работают независимо

В сохранённом графе: 17 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.StartView

Адрес #6D57, блок `S10`. [Source/Engine/StartView.asm](../Source/Engine/StartView.asm#L12).

включить обработку объектов в прерывании

устанавливает бит 2 #6566, AF сохранён

**Вход:** флаг фоновой обработки в #6566

**Выход:** бит 2 #6566 установлен, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** регистры не изменяются, меняется только байт #6566

В сохранённом графе: 6 инструкций. Чтение: #6566. Запись: #6566. Вызовы: не выделены.

### Engine.StackBC

Адрес #6D62, блок `S10`. [Source/Engine/StackBC.asm](../Source/Engine/StackBC.asm#L13).

передать целое BC на стек калькулятора ROM

вызов ROM #2D2B с сохранением основных регистров, IX и IY

**Вход:** BC беззнаковое целое 0..65535

**Выход:** число добавлено на стек калькулятора ROM, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, альтернативные HL', DE', BC', AF' зависят от внутреннего соглашения ROM и отдельно не проверены

В сохранённом графе: 14 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #2D2B.

### Engine.PopBC

Адрес #6D76, блок `S10`. [Source/Engine/PopBC.asm](../Source/Engine/PopBC.asm#L13).

извлечь результат калькулятора ROM в BC

вызов ROM #2DA2, остальные явно сохраняемые регистры восстановлены

**Вход:** верхнее число стека калькулятора ROM

**Выход:** BC преобразованное целое, HL, DE, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** BC, альтернативные HL', DE', BC', AF' зависят от внутреннего соглашения ROM и отдельно не проверены, правила переполнения и округления самого ROM отдельно не доказаны

В сохранённом графе: 12 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #2DA2.

### Engine.StackA

Адрес #6D88, блок `S10`. [Source/Engine/StackA.asm](../Source/Engine/StackA.asm#L13).

передать байт A на стек калькулятора ROM

вызов ROM #2D28 с сохранением основных регистров, IX и IY

**Вход:** AF, A беззнаковое целое 0..255

**Выход:** число добавлено на стек калькулятора ROM, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, альтернативные HL', DE', BC', AF' зависят от внутреннего соглашения ROM и отдельно не проверены

В сохранённом графе: 14 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #2D28.

### Engine.PopA

Адрес #6D9C, блок `S10`. [Source/Engine/PopA.asm](../Source/Engine/PopA.asm#L14).

извлечь байтовое целое из калькулятора ROM

ROM #2DD5 возвращает численный результат в A, в #7227 используется для получения отдельной десятичной цифры, HL, DE, BC, IX, IY сохранены

**Вход:** верхнее число стека калькулятора ROM

**Выход:** AF, A преобразованное байтовое целое, HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF, альтернативные HL', DE', BC', AF' зависят от внутреннего соглашения ROM и отдельно не проверены, обработка переполнения самого ROM отдельно не доказана

В сохранённом графе: 12 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #2DD5.

### Engine.StackFloat5

Адрес #6DAE, блок `S10`. [Source/Engine/StackFloat5.asm](../Source/Engine/StackFloat5.asm#L14).

передать пятибайтное число по HL на стек калькулятора

читает пять байтов в A, E, D, C, B и вызывает ROM #2ABB, возвращает HL после числа, DE, BC, AF сохранены

**Вход:** HL адрес пятибайтного числа в формате калькулятора Spectrum

**Выход:** HL исходный адрес+5, число добавлено на стек калькулятора, DE, BC, AF сохранены

**Изменяемые регистры и состояние:** HL, альтернативные HL', DE', BC', AF' зависят от внутреннего соглашения ROM и отдельно не проверены, IX/IY здесь явно не сохраняются, соглашение ROM #2ABB отдельно не проверено

В сохранённом графе: 20 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #2ABB.

### Engine.StoreFloat5

Адрес #6DC4, блок `S10`. [Source/Engine/StoreFloat5.asm](../Source/Engine/StoreFloat5.asm#L14).

сохранить вершину калькулятора в пятибайтное поле по HL

ROM #2BF1 возвращает A, E, D, C, B, они записываются последовательно, HL увеличен на 5, DE, BC, AF сохранены

**Вход:** HL адрес назначения пятибайтного числа, вершина стека калькулятора ROM

**Выход:** HL исходный адрес+5, число записано последовательно A, E, D, C, B, DE, BC, AF сохранены

**Изменяемые регистры и состояние:** HL, альтернативные HL', DE', BC', AF' зависят от внутреннего соглашения ROM и отдельно не проверены, IX/IY здесь явно не сохраняются, соглашение ROM #2BF1 отдельно не проверено

В сохранённом графе: 20 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #2BF1.

### Engine.FloatSignZero

Адрес #6DDA, блок `S10`. [Source/Engine/FloatSignZero.asm](../Source/Engine/FloatSignZero.asm#L15).

определить знак и нулевое значение результата калькулятора

начинается RST #28 с токеном 03 и END38, результат сохраняется в #6E09, бит 7 #6E0A задаёт carry, OR пяти байт задаёт zero, название отражает только проверенные тесты

**Вход:** два верхних числа на стеке калькулятора ROM

**Выход:** AF, C установлен при отрицательном пятибайтном результате вычитания, Z установлен при всех пяти нулевых байтах, HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF, альтернативные HL', DE', BC', AF' зависят от внутреннего соглашения ROM и отдельно не проверены, сравнение исследовано по байтам #6E09..#6E0D

В сохранённом графе: 28 инструкций. Чтение: #6E0A. Запись: не выделена. Вызовы: #6DC4.

### Engine.EditText

Адрес #6E0E, блок `S10`. [Source/Engine/EditText.asm](../Source/Engine/EditText.asm#L15).

редактировать строку с анимированным курсором

BC экранная позиция, IX буфер, A максимальная длина, сохраняет состояние в #6E9B..#6E9F, бит 5 #6566 включает курсор, #0C удаляет символ, #0D/#0E завершают ввод, вводимый символ записывается в буфер с ограничением длины

**Вход:** BC экранная позиция, AF, A максимальная длина, IX изменяемый буфер указанной длины

**Выход:** HL, H исходная максимальная длина и L число введённых символов, AF, A=#0D либо #0E, IX=#6565, BC и IY сохранены, буфер изменён, бит 5 #6566 снят

**Изменяемые регистры и состояние:** HL, DE, AF, IX, поля #6E9B..#6E9F и #6563, состояние клавиатуры #5C08

В сохранённом графе: 53 инструкций. Чтение: #6563, #6566, #6E9D. Запись: #6563, #6566, #6E9B, #6E9D, #6E9F. Вызовы: #6E79, #6EA0.

### Engine.DrawEditText

Адрес #6E79, блок `S10`. [Source/Engine/DrawEditText.asm](../Source/Engine/DrawEditText.asm#L13).

перерисовать поле редактирования

длина из #6E9F, буфер из #6E9D, экранная позиция #6E9B, по #70C5 выводит все символы и завершающий пробел

**Вход:** поля #6E9B позиция, #6E9D буфер, #6E9F длина

**Выход:** поле текста и следующий пробел перерисованы, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, переключение банка при выводе разрешает прерывания

В сохранённом графе: 20 инструкций. Чтение: #6E9B, #6E9D, #6E9F. Запись: не выделена. Вызовы: #70C5.

### Engine.ReadTextChar

Адрес #6EA0, блок `S10`. [Source/Engine/ReadTextChar.asm](../Source/Engine/ReadTextChar.asm#L13).

прочитать и преобразовать символ текстового ввода

ждёт LAST_K #5C08, #07 меняет бит 6 #6566, #06 меняет бит 1, бит 4 ограничивает ввод цифрами, бит 1 меняет регистр латиницы, бит 6 включает таблицу русского алфавита

**Вход:** LAST_K #5C08, флаги режима ввода #6566

**Выход:** AF, A принятый и преобразованный символ, HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF, #5C08 очищается перед ожиданием, специальные коды переключают биты 1/6 #6566

В сохранённом графе: 66 инструкций. Чтение: #5C08, #6566. Запись: #5C08, #6566. Вызовы: #6F25.

### Engine.RemapKey

Адрес #6F25, блок `S10`. [Source/Engine/RemapKey.asm](../Source/Engine/RemapKey.asm#L12).

заменить специальные коды клавиатуры по таблице

семь пар байтов #6F42, совпавший код заменяется вторым байтом пары

**Вход:** AF, A код символа

**Выход:** AF, A замена по семи парам #6F42 либо исходный A, HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 14 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.EditNumber

Адрес #6FC0, блок `S10`. [Source/Engine/EditNumber.asm](../Source/Engine/EditNumber.asm#L16).

ввести число из не более пяти цифр

ставит бит 4 #6566, пять пробелов в #7025, вызывает #6E0E с длиной 5, #0E либо пустое поле означают отмену, цифры разбираются через ROM калькулятор с десятичным масштабированием, при успешном вводе A=#0D

**Вход:** BC позиция поля ввода

**Выход:** AF, A=#0D при числе на вершине калькулятора либо #0E при отмене, строка до 5 цифр в #7025, IX=#6565 после редактора, численный результат возвращается через калькулятор, не через BC

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, поля #6566/#7025, IY зависит от соглашения ROM, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 55 инструкций. Чтение: #6566, #7025. Запись: #6566. Вызовы: #6D62, #6D88, #6E0E.

### Engine.DrawGlyph

Адрес #702B, блок `S10`. [Source/Engine/DrawGlyph.asm](../Source/Engine/DrawGlyph.asm#L15).

нарисовать восьмистрочный символ шрифта

использует логический банк 11 и восемь байт на символ из #DFD0, вычисляет сдвиг и маску, меняет два соседних экранных байта на каждой из 8 строк, переход строки INC IXH соответствует ZX Spectrum

**Вход:** BC позиция, B строка знакомест и C индекс символа по X=6*C+2, AF код символа A

**Выход:** символ выведен в пиксельную область, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, текущий банк восстановлен, способ разрешения прерываний зависит от патча #703B/#708D

В сохранённом графе: 61 инструкций. Чтение: #5F9F. Запись: не выделена. Вызовы: #6D2F, #7098.

### Engine.GlyphAddress

Адрес #7098, блок `S10`. [Source/Engine/GlyphAddress.asm](../Source/Engine/GlyphAddress.asm#L14).

вычислить экранный адрес и сдвиг символа

B участвует в нелинейном вычислении экранной строки, C задаёт X=6*C+2, IX получает адрес экранного байта, L=X AND7

**Вход:** BC, B строка знакомест и C горизонтальный индекс

**Выход:** HL, H старший байт адреса и L сдвиг 0..7, AF, A тотже сдвиг, IX адрес экранного байта для X=6*C+2, BC и IY сохранены

**Изменяемые регистры и состояние:** HL, DE, AF, IX

В сохранённом графе: 31 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.DrawGlyphEI

Адрес #70C5, блок `S10`. [Source/Engine/DrawGlyphEI.asm](../Source/Engine/DrawGlyphEI.asm#L13).

вывести символ с обычной процедурой переключения банка

патчит операнды CALL в #703B и #708D на #6D2F, затем вызывает #702B

**Вход:** BC позиция, B строка знакомест и C горизонтальный индекс, AF код символа A

**Выход:** символ выведен, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, патчатся операнды #703B/#708D, прерывания разрешаются процедурой #6D2F

В сохранённом графе: 7 инструкций. Чтение: не выделено. Запись: #703B, #708D. Вызовы: #702B.

### Engine.DrawGlyphDI

Адрес #70D4, блок `S10`. [Source/Engine/DrawGlyphDI.asm](../Source/Engine/DrawGlyphDI.asm#L14).

вывести символ из прерывания с сохранением режима DI

патчит операнды CALL в #703B и #708D на #5FA1, затем вызывает #702B, обработчик прерывания сохраняет прежние значения этих операндов

**Вход:** BC позиция, B строка знакомест и C горизонтальный индекс, AF код символа A

**Выход:** символ выведен, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, патчатся операнды #703B/#708D, переключатель #5FA1 оставляет прерывания запрещёнными

В сохранённом графе: 7 инструкций. Чтение: не выделено. Запись: #703B, #708D. Вызовы: #702B.

### Engine.DrawNumber

Адрес #70E3, блок `S10`. [Source/Engine/DrawNumber.asm](../Source/Engine/DrawNumber.asm#L14).

преобразовать число и вывести символы подряд

#7227 формирует строку в #710C, ставится нулевой терминатор, затем #70C5 для каждого символа с INC C

**Вход:** BC позиция вывода, число на вершине калькулятора ROM

**Выход:** десятичное число выведено, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, буфер #710C изменён, альтернативные HL', DE', BC', AF' зависят от внутреннего соглашения ROM и отдельно не проверены

В сохранённом графе: 27 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #70C5, #7227.

### Engine.PrintMessage

Адрес #7117, блок `S10`. [Source/Engine/PrintMessage.asm](../Source/Engine/PrintMessage.asm#L23).

разобрать строку сообщения с управляющими кодами

DE строка, IX указатель разбора, #0E вставляет строку по 16-битному адресу, #0F вставляет целое, #10 вставляет пятибайтное число, #11 меняет формат, #0D завершает строку, 0 завершает сообщение, промежуточный буфер #72B3

**Вход:** DE сообщение с управляющими кодами и нулевым терминатором, BC, B начальная строка и C начальная колонка

**Выход:** сообщение выведено, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, рабочий буфер #72B3 и форматные операнды изменены, числовые вставки используют ROM, альтернативные HL', DE', BC', AF' зависят от внутреннего соглашения ROM и отдельно не проверены

**Дополнительно:** Числовые управляющие поля имеют служебный пропускаемый байт, после #0F читаются двабайта целого и указатель дополнительно увеличивается ещё наодинбайт, после #10 читаются пятьбайт числа и также пропускается одинбайт. Код #0D читает следующий байт горизонтальной позиции, значение #2A включает центрирование. Буфер строки 43 байта очищается, явной проверки его переполнения нет.

В сохранённом графе: 136 инструкций. Чтение: #72B1, #72B2. Запись: #71E8, #71ED, #72B1, #72B2. Вызовы: #6D62, #6DAE, #70C5, #7227.

### Engine.NumberToDecimal

Адрес #7227, блок `S10`. [Source/Engine/NumberToDecimal.asm](../Source/Engine/NumberToDecimal.asm#L16).

преобразовать число калькулятора в десятичные цифры

DE буфер назначения, использует пятьбайтное поле #72DE и десятьбайтный массив цифр #72E3, через калькулятор последовательно получает десять разрядов, подавляет ведущие нули, записывает ASCII0..9 без нулевого терминатора, DE после последней цифры

**Вход:** DE буфер назначения, число на стеке калькулятора ROM

**Выход:** DE сразу после записанных десятичных цифр, нулевой терминатор не добавляется, IX сохранён

**Изменяемые регистры и состояние:** HL, DE, BC, AF, рабочие поля #72DE..#72EC, альтернативные HL', DE', BC', AF' зависят от внутреннего соглашения ROM и отдельно не проверены, IY не защищён собственным PUSH, зависит от калькулятора ROM

В сохранённом графе: 61 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D62, #6D76, #6D9C, #6DAE, #6DC4.

### Engine.GrabUnitTile

Адрес #72ED, блок `S10`. [Source/Engine/GrabUnitTile.asm](../Source/Engine/GrabUnitTile.asm#L14).

сохранить фон и создать анимированный объект 4 на 4 знакоместа

BC индекс объекта, умножается на 4 для #74F7, DE буфер фона, #7341 возвращает объект, задаются тип 4 и четыре кадра из ресурса #80DB, в+5 сохраняется текущий банк, +6/+7 адрес фона

**Вход:** DE буфер 144 байт для фона, BC индекс объекта, AF, A ID графического ресурса

**Выход:** фон 4 на 4 знакоместа сохранён в DE, запись объекта получила тип 4 и 4 кадра, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, память буфера и объектной записи изменена

В сохранённом графе: 38 инструкций. Чтение: #5FA0. Запись: не выделена. Вызовы: #7341, #74F7, #80DB.

### Engine.ViewCellAddr

Адрес #7341, блок `S10`. [Source/Engine/ViewCellAddr.asm](../Source/Engine/ViewCellAddr.asm#L14).

найти экранный объект клетки и связанное численное поле

IX=#6571+160*B+20*C, HL=#6931+16*B+2*C, экранная сетка 8 столбцов на 6 строк, DE, BC, AF сохранены

**Вход:** BC, B строка 0..5 и C столбец 0..7 объектной сетки

**Выход:** HL адрес двухбайтного численного поля, IX адрес двадцатибайтной записи объекта, DE, BC, AF сохранены

**Изменяемые регистры и состояние:** изменяются HL и IX. DE, BC, AF, IY сохранены

В сохранённом графе: 22 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.SetUnitPicture

Адрес #7366, блок `S10`. [Source/Engine/SetUnitPicture.asm](../Source/Engine/SetUnitPicture.asm#L14).

создать четырёхкадровый экранный объект

сначала #7341, затем #80DB выбирает исходный ресурс, тип 4, счётчик 1, задержка 9, кадров 4, фоновый банк 4 по #C000, четыре трёхбайтных кадра получают C и адреса HL с шагом 256

**Вход:** BC индекс объекта, AF, A ID графического ресурса

**Выход:** создан четырёхкадровый объект с фоном банка 4 по #C000, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, изменяется двадцатибайтная запись объекта, #80DB выбирает адрес ресурса без переключения банка

В сохранённом графе: 30 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7341, #80DB.

### Engine.FillAttributes

Адрес #73AD, блок `S10`. [Source/Engine/FillAttributes.asm](../Source/Engine/FillAttributes.asm#L12).

заполнить прямоугольник атрибутов цветом A

B строка, C столбец в знакоместах, D высота, E ширина, адрес #5800+32*B+C, строки с шагом 32

**Вход:** DE, D высота и E ширина в знакоместах, BC, B строка и C столбец, AF атрибут A

**Выход:** атрибутный прямоугольник заполнен, HL, DE, A, IX, IY сохранены

**Изменяемые регистры и состояние:** BC и F изменяются. Нулевые размеры не обрабатываются как пустой прямоугольник из-за DJNZ

В сохранённом графе: 26 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.ClearRectangle

Адрес #73CF, блок `S10`. [Source/Engine/ClearRectangle.asm](../Source/Engine/ClearRectangle.asm#L14).

обнулить пиксели прямоугольника и заполнить его атрибуты

BC начало в знакоместах, D высота, E ширина, восемь пиксельных строк на знакоместо, после очистки #73AD пишет атрибут A

**Вход:** DE, D высота и E ширина в знакоместах, BC начало, AF атрибут A

**Выход:** пиксели обнулены и атрибуты заполнены, HL, DE, A, IX, IY сохранены

**Изменяемые регистры и состояние:** BC и F изменяются в завершающем вызове #73AD после восстановления AF. Нулевые размеры приводят к 256 итерациям DJNZ, область не ограничивается экраном

В сохранённом графе: 35 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #73AD, #7693.

### Engine.DrawFrame

Адрес #73FE, блок `S10`. [Source/Engine/DrawFrame.asm](../Source/Engine/DrawFrame.asm#L13).

нарисовать рамку окна из восьми одноклеточных элементов

BC левый верхний угол, E внутренняя ширина, D внутренняя высота, A атрибут, углы и границы из #74AF..#74ED, центр пустой элемент #74EE, вывод через #7545

**Вход:** DE, D внутренняя высота и E внутренняя ширина окна, BC левый верхний угол, AF атрибут A

**Выход:** рамка и внутреннее поле выведены, IX и IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, рабочие поля #74AB..#74EE изменены, ограничение экраном отсутствует

В сохранённом графе: 70 инструкций. Чтение: #74AB, #74AD, #74AE. Запись: #74AB, #74AD. Вызовы: #7545.

### Engine.GrabTile4x4

Адрес #74F7, блок `S10`. [Source/Engine/GrabTile4x4.asm](../Source/Engine/GrabTile4x4.asm#L13).

сохранить прямоугольник экрана 4 на 4 знакоместа в буфер DE

BC экранная позиция, копирует 128 байт пикселей в порядке 8 строк каждого ряда знакомест, затем 16 байт атрибутов, общий размер 144 байта

**Вход:** DE буфер 144 байта, BC экранная позиция 4 на 4 знакоместа

**Выход:** 128 байт пикселей и 16 байт атрибутов записаны в буфер, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, экран читается, границы прямоугольника не проверяются

В сохранённом графе: 55 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7693.

### Engine.DrawRawSprite

Адрес #7545, блок `S10`. [Source/Engine/DrawRawSprite.asm](../Source/Engine/DrawRawSprite.asm#L14).

вывести непрозрачный спрайт с атрибутами

IX источник, BC позиция в знакоместах, D высота, E ширина, сначала 8*D*E пиксельных байтов, затем D*E атрибутов, ограничение экраном отсутствует

**Вход:** DE, D высота и E ширина в знакоместах, BC экранная позиция, IX пиксели, за ними атрибуты

**Выход:** изображение выведено, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, экран и атрибуты изменены, нулевые размеры небезопасны, границы экрана не проверяются

В сохранённом графе: 69 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7693.

### Engine.DrawMask

Адрес #75A2, блок `S10`. [Source/Engine/DrawMask.asm](../Source/Engine/DrawMask.asm#L13).

вывести пиксельный спрайт по маске

IX пиксели, IY маска, BC позиция в знакоместах, D высота, E ширина, формула экран=(экран AND маска) OR пиксели, атрибуты не изменяются

**Вход:** DE, D высота и E ширина в знакоместах, BC экранная позиция, IX пиксели, IY маска

**Выход:** пиксели наложены по маске, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, атрибуты не меняются, границы экрана не проверяются

В сохранённом графе: 44 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7693.

### Engine.DrawRawMirrored

Адрес #75E1, блок `S10`. [Source/Engine/DrawRawMirrored.asm](../Source/Engine/DrawRawMirrored.asm#L14).

вывести непрозрачный спрайт с горизонтальным отражением

вариант #7545, байты каждой строки идут справа налево, каждый пиксельный байт отражается через #76AE, атрибуты также пишутся справа налево

**Вход:** DE, D высота и E ширина в знакоместах, BC экранная позиция, IX пиксели, за ними атрибуты

**Выход:** изображение выведено, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, экран и атрибуты изменены, нулевые размеры небезопасны, границы экрана не проверяются

В сохранённом графе: 78 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7693, #76AE.

### Engine.DrawMaskFlip

Адрес #7649, блок `S10`. [Source/Engine/DrawMaskFlip.asm](../Source/Engine/DrawMaskFlip.asm#L13).

вывести маскированный спрайт с горизонтальным отражением

вариант #75A2, байты маски и пикселей отражаются через #76AE и строки пишутся справа налево, атрибуты не изменяются

**Вход:** DE, D высота и E ширина в знакоместах, BC экранная позиция, IX пиксели, IY маска

**Выход:** пиксели наложены по маске, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, атрибуты не меняются, границы экрана не проверяются

В сохранённом графе: 50 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7693, #76AE.

### Engine.CellAddress

Адрес #7693, блок `S10`. [Source/Engine/CellAddress.asm](../Source/Engine/CellAddress.asm#L12).

вычислить ZX-адрес верхней пиксельной строки знакоместа

B строка знакомест, C столбец, HL экранный адрес в нелинейной области #4000..#57FF, BC сохранён

**Вход:** BC, B строка знакомест 0..23 и C столбец байтов 0..31

**Выход:** HL адрес первой пиксельной строки знакоместа, BC сохранён

**Изменяемые регистры и состояние:** HL, AF, DE, IX, IY не меняются

В сохранённом графе: 18 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.ReverseBits

Адрес #76AE, блок `S10`. [Source/Engine/ReverseBits.asm](../Source/Engine/ReverseBits.asm#L12).

отразить восемь бит байта A

восемь раз SLA A и RR C, возвращает A с обратным порядком бит, BC сохранён

**Вход:** AF, A исходный байт

**Выход:** AF, A байт с обратным порядком бит, BC сохранён

**Изменяемые регистры и состояние:** AF, HL, DE, BC, IX, IY не меняются

В сохранённом графе: 9 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.DrawMenuCursor

Адрес #76BC, блок `S10`. [Source/Engine/DrawMenuCursor.asm](../Source/Engine/DrawMenuCursor.asm#L13).

нарисовать указатель меню с пиксельным смещением

разница младших 3 бит X прежней позиции #79CA и новой #79CC определяет циклический сдвиг пикселей и маски #7980/#79A5, затем 8 строк по 3 байта рисуются #7722

**Вход:** #79CA старая и #79CC новая пиксельная позиция, #79CE пиксели и #79E6 маска указателя

**Выход:** указатель 8 строк по 3 байта наложен на экран, циклический сдвиг массива согласован с X

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, байты указателя/маски и счётчик сдвига #7A16

В сохранённом графе: 28 инструкций. Чтение: #79CA, #79CC. Запись: не выделена. Вызовы: #76FB, #7722, #7980, #79A5.

### Engine.PixelAddress

Адрес #76FB, блок `S10`. [Source/Engine/PixelAddress.asm](../Source/Engine/PixelAddress.asm#L13).

вычислить адрес байта экрана по пиксельным координатам

B строка пикселей, C X, HL=#4000+((B AND#C0)*32)+((B AND7)*256)+((B AND#38)*4)+(C>>3), BC сохранён

**Вход:** BC, B пиксельная строка и C пиксельный X

**Выход:** HL адрес байта экрана, BC сохранён, DE, IX, IY не меняются

**Изменяемые регистры и состояние:** HL, AF

В сохранённом графе: 26 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.CursorMaskByte

Адрес #7722, блок `S10`. [Source/Engine/CursorMaskByte.asm](../Source/Engine/CursorMaskByte.asm#L14).

наложить один байт указателя в пределах пиксельной области

при H<#58 экран=(экран AND(IY)) OR(IX), затем HL, IX, IY увеличиваются даже для пропущенного байта

**Вход:** HL адрес экрана, IX пиксели, IY маска

**Выход:** HL, IX, IY увеличены на 1, при исходном H<#58 байт наложен как(screen AND mask)ORpixel, DE и BC сохранены

**Изменяемые регистры и состояние:** HL, AF, IX, IY, пиксельный байт при допустимом H

В сохранённом графе: 11 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.SaveCursor

Адрес #7735, блок `S10`. [Source/Engine/SaveCursor.asm](../Source/Engine/SaveCursor.asm#L13).

сохранить фон под указателем меню

позиция #79CC, восемь пиксельных строк по 3 байта копируются в #79FE, всего 24 байта

**Вход:** #79CC позиция указателя

**Выход:** DE=#7A16 после записи 24 байт фона в #79FE..#7A15, BC, B увеличен на 8 от исходной позиции и C сохранён, IX и IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, 24 байта буфера фона

В сохранённом графе: 15 инструкций. Чтение: #79CC. Запись: не выделена. Вызовы: #76FB.

### Engine.RestoreCursor

Адрес #7750, блок `S10`. [Source/Engine/RestoreCursor.asm](../Source/Engine/RestoreCursor.asm#L13).

восстановить фон под старой позицией указателя

позиция #79CA, восемь пиксельных строк по 3 байта берутся из #79FE

**Вход:** #79CA старая позиция, 24 байта сохранённого фона #79FE

**Выход:** фон под старой позицией восстановлен, DE=#7A16, BC, B увеличен на 8 и C сохранён, IX и IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, 24 экранных байта

В сохранённом графе: 17 инструкций. Чтение: #79CA. Запись: не выделена. Вызовы: #76FB.

### Engine.SelectMenuItem

Адрес #776D, блок `S10`. [Source/Engine/SelectMenuItem.asm](../Source/Engine/SelectMenuItem.asm#L16).

управлять указателем и выбрать прямоугольный пункт меню

IX описатель меню, +0 число областей, +1..4 границы перемещения, +5/+6 начальная пиксельная позиция, с+7 идут прямоугольники по 4 байта в знакоместах, #787E определяет активный пункт, #78D6 меняет его атрибуты, ввод через #791E, сохранение фона через #7735/#7750

**Вход:** IX изменяемый описатель меню, экран уже содержит области выбора

**Выход:** BC последняя пиксельная позиция указателя, AF, A выбранный пункт 1..N, IX сохранён, IY выбранный прямоугольник, IX+5/+6 обновлены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IY, экран временно меняется и восстанавливается под указателем, IFF устанавливается через EI, клавиатурный ROM может изменять альтернативные регистры

В сохранённом графе: 108 инструкций. Чтение: #794B, #79CA, #79CC, #7A16. Запись: #794B, #79CA, #79CC. Вызовы: #76BC, #7735, #7750, #787E, #78D6, #791E, #7950, #795C, #7968, #7974, #7980, #79A5.

### Engine.HitTestMenu

Адрес #787E, блок `S10`. [Source/Engine/HitTestMenu.asm](../Source/Engine/HitTestMenu.asm#L14).

найти прямоугольник меню под пиксельным указателем

IX+7 начало четырёхбайтных прямоугольников [left, top, right, bottom] в знакоместах, #79CC позиция в пикселях, границы слева/сверху включены, справа/снизу исключены, A номер 1..N и IY прямоугольник, при отсутствии A=0, IY=0

**Вход:** IX описатель меню, #79CC пиксельные координаты указателя

**Выход:** AF, A номер 1..N либо 0, IY найденный прямоугольник либо 0, IX сохранён

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IY

В сохранённом графе: 45 инструкций. Чтение: #79CC. Запись: не выделена. Вызовы: не выделены.

### Engine.InvertMenuItem

Адрес #78D6, блок `S10`. [Source/Engine/InvertMenuItem.asm](../Source/Engine/InvertMenuItem.asm#L13).

поменять местами INK и PAPER прямоугольного пункта меню

IY [left, top, right, bottom] в знакоместах, для каждого атрибута сохраняет FLASH/BRIGHT и меняет младшую и среднюю тройки бит, повторный вызов восстанавливает исходный цвет

**Вход:** IY четыре байта [left, top, right, bottom] в знакоместах

**Выход:** обмен INK/PAPER в прямоугольнике, IY и IX сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 46 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.WaitMenuInput

Адрес #791E, блок `S10`. [Source/Engine/WaitMenuInput.asm](../Source/Engine/WaitMenuInput.asm#L14).

дождаться клавиши либо Kempston для меню

ROM #028E возвращает E, #FF означает отсутствие клавиши, затем порт #1F, fire возвращает #27, направления ищутся в таблице #793B, при неизвестном ненулевом значении поиск не ограничен

**Вход:** клавиатура и Kempston #1F

**Выход:** AF, A код клавиши либо направления, ожидание продолжается до ненулевого ввода

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX/IY собственный код не изменяет, их сохранение ROM #028E отдельно не проверено

В сохранённом графе: 18 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #028E.

### Engine.CursorUp

Адрес #7950, блок `S10`. [Source/Engine/CursorUp.asm](../Source/Engine/CursorUp.asm#L14).

сдвинуть указатель меню на пиксель вверх

старый Y=#79CB, сравнивается с верхней границей IX+2, при допустимости новый Y-1 сохраняется #79CD

**Вход:** IX описатель границ меню, старая позиция #79CA/#79CB

**Выход:** новая координата Y=Y-1 записана в #79CC/#79CD, если старая не равна IX+2, при равенстве память не меняется, HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 6 инструкций. Чтение: #79CB. Запись: #79CD. Вызовы: не выделены.

### Engine.CursorDown

Адрес #795C, блок `S10`. [Source/Engine/CursorDown.asm](../Source/Engine/CursorDown.asm#L14).

сдвинуть указатель меню на пиксель вниз

старый Y=#79CB, сравнивается с нижней границей IX+4, при допустимости новый Y+1 сохраняется #79CD

**Вход:** IX описатель границ меню, старая позиция #79CA/#79CB

**Выход:** новая координата Y=Y+1 записана в #79CC/#79CD, если старая не равна IX+4, при равенстве память не меняется, HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 6 инструкций. Чтение: #79CB. Запись: #79CD. Вызовы: не выделены.

### Engine.CursorLeft

Адрес #7968, блок `S10`. [Source/Engine/CursorLeft.asm](../Source/Engine/CursorLeft.asm#L13).

сдвинуть указатель меню на пиксель влево

старый X=#79CA, сравнивается с левой границей IX+1, при допустимости новый X-1 сохраняется #79CC

**Вход:** IX описатель границ меню, старая позиция #79CA/#79CB

**Выход:** новая координата X=X-1 записана в #79CC/#79CD, если старая не равна IX+1, при равенстве память не меняется, HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 6 инструкций. Чтение: #79CA. Запись: #79CC. Вызовы: не выделены.

### Engine.CursorRight

Адрес #7974, блок `S10`. [Source/Engine/CursorRight.asm](../Source/Engine/CursorRight.asm#L14).

сдвинуть указатель меню на пиксель вправо

старый X=#79CA, сравнивается с правой границей IX+3, при допустимости новый X+1 сохраняется #79CC

**Вход:** IX описатель границ меню, старая позиция #79CA/#79CB

**Выход:** новая координата X=X+1 записана в #79CC/#79CD, если старая не равна IX+3, при равенстве память не меняется, HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 6 инструкций. Чтение: #79CA. Запись: #79CC. Вызовы: не выделены.

### Engine.ShiftCursorR

Адрес #7980, блок `S10`. [Source/Engine/ShiftCursorR.asm](../Source/Engine/ShiftCursorR.asm#L14).

циклически сдвинуть вправо 24 битные строки указателя и маски

A число сдвигов,16 строк по 3 байта в #79CE..#79FD, крайний правый бит возвращается слева, #7A16 увеличивается на каждый выполненный сдвиг

**Вход:** AF, A ненулевое число циклических сдвигов вправо

**Выход:** 16 трёхбайтных строк #79CE..#79FD сдвинуты, #7A16 увеличен на число сдвигов, IX и IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, C собственный код не меняет, A=0 на выходе, вход A=0 выполнилбы 256 итераций

В сохранённом графе: 23 инструкций. Чтение: #7A16. Запись: #7A16. Вызовы: не выделены.

### Engine.ShiftCursorL

Адрес #79A5, блок `S10`. [Source/Engine/ShiftCursorL.asm](../Source/Engine/ShiftCursorL.asm#L14).

циклически сдвинуть влево 24 битные строки указателя и маски

A число сдвигов,16 строк по 3 байта #79CE..#79FD в обратном порядке, крайний левый бит возвращается справа, #7A16 уменьшается на каждый сдвиг

**Вход:** AF, A ненулевое число циклических сдвигов влево

**Выход:** 16 трёхбайтных строк #79CE..#79FD сдвинуты, #7A16 уменьшен на число сдвигов, IX и IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, C собственный код не меняет, A=0 на выходе, вход A=0 выполнилбы 256 итераций

В сохранённом графе: 23 инструкций. Чтение: #7A16. Запись: #7A16. Вызовы: не выделены.

### Engine.SumArmyPower

Адрес #7A17, блок `S10`. [Source/Engine/SumArmyPower.asm](../Source/Engine/SumArmyPower.asm#L17).

сложить произведения количества отрядов на поле силы типа

стек калькулятора получает 0, для каждой трёхбайтной записи берётся беззнаковое 16 битное количество и 16 битное поле 22/23 описателя SOLDIERS, токен 04 умножает,0F прибавляет, нулевой ID завершает раньше B, #9193 использует результат для сравнения сил армий, поле силы названо по проверенному потребителю

**Вход:** HL список трёхбайтных записей армии, BC, B максимум записей

**Выход:** HL после обработанных записей либо у первого нулевого ID, сумма количества*поле 22/23 на стеке калькулятора, выбранный до входа банк восстановлен

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX и альтернативные регистры калькулятора не сохраняются полностью, IY зависит от ROM

В сохранённом графе: 28 инструкций. Чтение: #5FA0, #7A49. Запись: #7A49. Вызовы: #6D2F, #6D62, #6D88, #8036.

### Engine.SelectThreshold

Адрес #7A4E, блок `S10`. [Source/Engine/SelectThreshold.asm](../Source/Engine/SelectThreshold.asm#L13).

определить одну из четырёх категорий по порогам

IX база таблицы, читает три 16 битных порога со смещений 4,8,12, сравнивает HL с каждым, возвращает A=1..4, HL и IX сохранены

**Вход:** HL сравниваемое 16 битное значение, IX база трёх порогов со смещениями 4/8/12

**Выход:** AF, A категория 1..4, HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF, сравнение использует HL<порог, равенство переходит к следующей категории

В сохранённом графе: 23 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.IndexFourBytes

Адрес #7A74, блок `S10`. [Source/Engine/IndexFourBytes.asm](../Source/Engine/IndexFourBytes.asm#L12).

сместить IX к четырёхбайтной записи с индексом A

IX=IX+4*A, BC сохранён

**Вход:** AF, A индекс 0..63, IX начало четырёхбайтных записей

**Выход:** IX=IX исходный+4*A, HL, DE, BC, A, IY сохранены

**Изменяемые регистры и состояние:** IX и F, для A>=64 происходит усечение 4*A до 8 бит перед сложением

В сохранённом графе: 8 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.NthName

Адрес #7A80, блок `S10`. [Source/Engine/NthName.asm](../Source/Engine/NthName.asm#L13).

найти строку имени в списке с нулевыми разделителями

таблица начинается после #69BB, A номер 1.., пропускается A нулевых терминаторов, DE возвращает начало следующей строки, HL, BC, AF сохранены

**Вход:** AF, A ненулевой номер строки списка после #69BB

**Выход:** DE адрес строки, HL, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** DE, нулевой номер не проверяется и запускает 256 проходов DJNZ

В сохранённом графе: 16 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.ClearTwoFlags

Адрес #7A94, блок `S10`. [Source/Engine/ClearTwoFlags.asm](../Source/Engine/ClearTwoFlags.asm#L12).

обнулить два связанных байта таблиц

#7AA4 даёт IX=#6A72+A, записывает 0 по IX и IX+25, IX сохранён

**Вход:** AF, A индекс типа

**Выход:** байты #6A72+A и #6A8B+A обнулены, HL, DE, BC, A, IX, IY сохранены

**Изменяемые регистры и состояние:** F, меняется только пара указанных байтов состояния

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7AA4.

### Engine.IndexFlagArray

Адрес #7AA4, блок `S10`. [Source/Engine/IndexFlagArray.asm](../Source/Engine/IndexFlagArray.asm#L12).

получить указатель IX=#6A72+A

BC сохранён, индекс A расширяется нулём в B

**Вход:** AF, A индекс типа

**Выход:** IX=#6A72+A, HL, DE, BC, A, IY сохранены

**Изменяемые регистры и состояние:** F, IX

В сохранённом графе: 7 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.ArmyRating

Адрес #7AB0, блок `S10`. [Source/Engine/ArmyRating.asm](../Source/Engine/ArmyRating.asm#L16).

рассчитать оценку армии из суммы взвешенных количеств

на стек сначала 100, до 5 записей #6A1E добавляют количество*поле 22/23 описателя/100, затем токены 27,31 дают floor результата и его копию, формула floor(100+sum(количество*сила/100)), #957C использует показатель в панели с рейтингом

**Вход:** пять трёхбайтных записей #6A1E

**Выход:** на стек калькулятора положены две копии floor(100+sum(количество*поле 22/23)/100), банк 3 остаётся выбранным

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY не сохраняются как единый контракт, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 25 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D62, #6D88, #8036.

### Engine.UnitFlags

Адрес #7AEF, блок `S10`. [Source/Engine/UnitFlags.asm](../Source/Engine/UnitFlags.asm#L12).

прочитать пару флагов описателя отряда

A ID, возвращает DE из полей 13/14 описателя SOLDIERS, сохраняет исходный банк, IX, BC, AF

**Вход:** AF, A ID типа отряда

**Выход:** DE два байта флагов описателя +13/+14, HL, BC, AF, IX, IY сохранены, банк восстановлен

**Изменяемые регистры и состояние:** DE, прочие основные и индексные регистры сохранены

В сохранённом графе: 16 инструкций. Чтение: #5FA0. Запись: не выделена. Вызовы: #6D2F, #8036.

### Engine.MarkMapObjects

Адрес #7B0B, блок `S10`. [Source/Engine/MarkMapObjects.asm](../Source/Engine/MarkMapObjects.asm#L14).

пометить занятые клетки карты для групп объектов

последовательно выбирает банки 0/1 и группы указателей #6B79, #6AE9, #6AF9, #6B09, #6B19, #6B29 и др, задаёт размеры области BC и шаг записи DE, вызывает #7B97 для текущего континента

**Вход:** карта банка 10, группы объектов банков 0/1, #6A2D текущий континент

**Выход:** бит 7 карты установлен под прямоугольниками активных записей десяти групп, последний рабочий банк 0

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, IFF может остаться запрещённым из-за прямого вызова #5FA1 в #7BE3

В сохранённом графе: 45 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #5FA1, #7B97.

### Engine.MarkObjectGroup

Адрес #7B97, блок `S10`. [Source/Engine/MarkObjectGroup.asm](../Source/Engine/MarkObjectGroup.asm#L16).

установить бит 7 карты под активными записями группы

A=#6A2D выбирает четырёхбайтную запись группы, оттуда указатель и количество, объекты с бит 0 поля 0 сброшенным размечаются прямоугольником заданного размера через #7BE3, адресная структура и размеры записаны в самомодифицируемые операнды #7BC6/#7BC8/#7BD9

**Вход:** HL начальное значение не требуется, DE шаг записи, BC размеры прямоугольника, IX группа четырёхбайтных указателей

**Выход:** бит 7 карты отмечает область активных объектов текущего континента, прежний банк восстанавливается в каждом #7BE3

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, операнды #7BC6/#7BC8/#7BD9, IFF может быть запрещён

В сохранённом графе: 36 инструкций. Чтение: #6A2D. Запись: #7BC6, #7BC8, #7BD9. Вызовы: #7A74, #7BE3.

### Engine.MarkMapCell

Адрес #7BE3, блок `S10`. [Source/Engine/MarkMapCell.asm](../Source/Engine/MarkMapCell.asm#L14).

установить бит 7 байта клетки стратегической карты

BC координаты, сохраняет банк, выбирает карту #80AE, адрес #80B4, SET7,(HL), восстанавливает банк

**Вход:** BC координаты клетки

**Выход:** HL адрес клетки карты банка 10, бит 7 клетки установлен, DE, BC, AF, IX, IY сохранены, прежний банк восстановлен

**Изменяемые регистры и состояние:** HL, IFF после прямого #5FA1 запрещён

В сохранённом графе: 8 инструкций. Чтение: #5FA0. Запись: не выделена. Вызовы: #5FA1, #80AE, #80B4.

### Engine.WaitOrInput

Адрес #7BF4, блок `S10`. [Source/Engine/WaitOrInput.asm](../Source/Engine/WaitOrInput.asm#L15).

выдержать паузу с досрочным выходом по вводу

сначала #6BE9, затем до B периодов по 50 HALT, после каждого опрос #6BF1, carry завершает ожидание

**Вход:** BC, B число периодов по 50HALT, прерывания разрешены

**Выход:** сначала 20HALT без прерывания вводом, затем ожидание до B*50HALT с досрочным выходом по вводу, HL, DE, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, обработчик #6BF1 потребляет ввод, причину окончания в регистрах не возвращает, альтернативные регистры ROM клавиатуры отдельно не проверены

В сохранённом графе: 17 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6BE9, #6BF1.

### Engine.RandomScaled

Адрес #7C0D, блок `S10`. [Source/Engine/RandomScaled.asm](../Source/Engine/RandomScaled.asm#L16).

получить масштабированное псевдослучайное число

состояние из трёх слов #7C6B/#7C6D/#7C6F обновляется сложениями и циклическим сдвигом, затем 16 шаговое умножение нового 16 битного состояния на исходное DE, возвращается старшее слово произведения, увеличенное на 1 если бит 15 младшего слова установлен, тоесть округление к ближайшему целому, результат DE

**Вход:** DE верхняя величина масштабирования

**Выход:** DE округлённое масштабированное случайное значение, HL, BC, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** DE, три слова состояния #7C6B/#7C6D/#7C6F и временное поле #7C69, регистры альтернативного набора не используются

В сохранённом графе: 46 инструкций. Чтение: #7C6B, #7C6D, #7C6F. Запись: #7C69, #7C6B, #7C6D, #7C6F. Вызовы: не выделены.

### Engine.GetDirection

Адрес #7C71, блок `S10`. [Source/Engine/GetDirection.asm](../Source/Engine/GetDirection.asm#L15).

определить одно из восьми направлений от BC к DE

разности E-C и D-B сохраняются #7D1A/#7D1B, знак и отношение абсолютных разностей обрабатываются с ROM калькулятором, A возвращает код направления, DE адрес соответствующего названия в списке после #7D1B, HL, BC, IX, IY сохранены

**Вход:** DE координаты цели, BC исходные координаты

**Выход:** DE адрес названия направления, AF, A код 1..8, HL, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** DE, AF, рабочие разности #7D1A/#7D1B, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 79 инструкций. Чтение: #7D1A, #7D1B. Запись: #7D1A, #7D1B. Вызовы: #6D62, #6D76.

### Engine.CountWord

Адрес #7D6B, блок `S10`. [Source/Engine/CountWord.asm](../Source/Engine/CountWord.asm#L13).

выбрать словесное описание величины HL

таблица 16 битных порогов после #7D94, A увеличивается до порога не меньше HL, затем выбирается одно из нуль-терминированных названий после #7DAF, DE адрес текста, HL и IX сохранены

**Вход:** HL количество

**Выход:** DE словесное описание диапазона количества, HL, IX, IY сохранены, C сохранён

**Изменяемые регистры и состояние:** DE, BC, AF, B используется поиском строки, A к выходу равен 0

В сохранённом графе: 25 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.PrintArmyBrief

Адрес #7E55, блок `S10`. [Source/Engine/PrintArmyBrief.asm](../Source/Engine/PrintArmyBrief.asm#L15).

вывести краткий список состава армии

IY трёхбайтные записи, A число записей, BC место вывода, для каждой непустой записи количество передаётся #7D6B для словесной оценки, #7EA7 формирует имя отряда, #7117 печатает сообщение #7E9F, следующая строка увеличивает B

**Вход:** BC позиция вывода, AF, A число записей, IY список трёхбайтных записей

**Выход:** краткий состав армии выведен, HL и IX сохранены, IY после обработанных записей либо на первом нулевом ID, прежний банк восстановлен

**Изменяемые регистры и состояние:** DE, BC, AF, IY, буфер #7EE9 и операнды позиционирования/банка

В сохранённом графе: 32 инструкций. Чтение: #5FA0, #7E7F. Запись: #7E7E, #7E7F, #7E8E, #7EA0. Вызовы: #6D2F, #7117, #7D6B, #7EA7.

### Engine.FormatUnitName

Адрес #7EA7, блок `S10`. [Source/Engine/FormatUnitName.asm](../Source/Engine/FormatUnitName.asm#L15).

сформировать имя типа отряда со специальным окончанием

A ID описателя #8036, в #7EE9 копируется первая часть имени до последнего символа перед пробелом либо 0, затем добавляется строка-окончание из списка #7EF7 по ID, буфер заканчивается 0

**Вход:** AF, A ID типа 1..25

**Выход:** в #7EE9 сформировано имя с нужным окончанием и 0, HL, DE, BC, AF, IX, IY сохранены, банк 3 выбран

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, изменяется буфер #7EE9, банк и IFF, предыдущий банк здесь не восстанавливается

В сохранённом графе: 38 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #8036.

### Engine.MoveToTarget

Адрес #7F40, блок `S10`. [Source/Engine/MoveToTarget.asm](../Source/Engine/MoveToTarget.asm#L15).

преобразовать направление к цели в команду движения героя

BC=#6A2E текущая позиция, DE=#69D5 цель, #7C71 возвращает направление A, код из таблицы #7F56 передаётся обработчику #8A31

**Вход:** #6A2E текущая позиция героя, #69D5 цель

**Выход:** направление к цели преобразовано в команду #8A31, возможен шаг героя либо переход обратно к ожиданию ввода

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY и состояние движения, обычный RET зависит от допустимости маршрута в #8A31

В сохранённом графе: 10 инструкций. Чтение: #69D5, #6A2E. Запись: не выделена. Вызовы: #7C71, #8A31.

### Engine.NearestObject

Адрес #7F5F, блок `S10`. [Source/Engine/NearestObject.asm](../Source/Engine/NearestObject.asm#L17).

найти ближайшую активную запись выбранной группы

D выбирает 16 байтный блок указателей от #6AD9, E континент через #7A74, A шаг исходной записи, BC опорные координаты, HL координаты исключаемой записи, сравнивает квадрат расстояния dx²+dy², IX ближайшая запись, минимум #7FEC и указатель #7FEE

**Вход:** HL исключаемые координаты, DE, D номер группы и E континент, BC опорные координаты, AF, A шаг записи

**Выход:** IX ближайшая подходящая запись, HL и IY сохранены, #7FEC квадрат минимального расстояния, банк 0 выбран

**Изменяемые регистры и состояние:** DE, BC, AF, IX, #7FEE последний найденный указатель, при отсутствии кандидатов #7FEE не очищается и IX не гарантируется

В сохранённом графе: 66 инструкций. Чтение: #7FEC, #7FEE. Запись: #7FA8, #7FB1, #7FDB, #7FEC, #7FEE. Вызовы: #6D2F, #7A74, #801F.

### Engine.FloorDistance

Адрес #7FF0, блок `S10`. [Source/Engine/FloorDistance.asm](../Source/Engine/FloorDistance.asm#L16).

вычислить целую часть евклидова расстояния

BC и DE координаты, абсолютные 8 битные разности возводятся #801F в квадрат,16 битная сумма передаётся калькулятору, токены 28,27 означают квадратный корень и округление вниз, #6D76 возвращает BC, для карты 161 на 100 сумма не переполняет 16 бит, вне этого диапазона сумма усечётся

**Вход:** DE координаты цели, BC координаты начала

**Выход:** BC=floor(sqrt(dx*dx+dy*dy)), HL, DE, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** BC и альтернативные регистры калькулятора ROM, сумма квадратов вычисляется с разрядностью 16 бит

В сохранённом графе: 28 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D62, #6D76, #801F.

### Engine.SquareByte

Адрес #801F, блок `S10`. [Source/Engine/SquareByte.asm](../Source/Engine/SquareByte.asm#L12).

возвести беззнаковый байт A в квадрат

8 шаговое умножение shift-add, HL=A*A, DE и BC сохранены

**Вход:** AF, A беззнаковый множитель

**Выход:** HL=A*A, DE, BC, A, IX, IY сохранены

**Изменяемые регистры и состояние:** HL и F, A после восьми RRCA возвращается к исходному значению

В сохранённом графе: 15 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.UnitDesc

Адрес #8036, блок `S10`. [Source/Engine/UnitDesc.asm](../Source/Engine/UnitDesc.asm#L13).

получить описатель типа отряда

выбирает логический банк 3, IX=#BFD6+42*A, ID1 соответствует первому элементу SOLDIERS по #C000, A сохраняется, нулевой ID не допускается из-за DJNZ

**Вход:** AF, A номер записи начиная с 1, нулевой индекс недопустим

**Выход:** IX адрес записи, банк 3 выбран и прерывания разрешены, HL, DE, BC, AF, IY сохранены

**Изменяемые регистры и состояние:** IX, состояние банка и IFF, остальные регистры не меняются

В сохранённом графе: 14 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D2F.

### Engine.RulerDesc

Адрес #804E, блок `S10`. [Source/Engine/RulerDesc.asm](../Source/Engine/RulerDesc.asm#L14).

получить описатель одного из пятнадцати вражеских правителей

банк 3, IX=#CCAF+28*A, ID1 соответствует #CCCB, записи содержат 21 байт имени и 0, затем 16 битные текущую магическую силу+22, максимум+24 и восстановление+26, имена и вывод владельца подтверждены оверлеями 1/2/17/21, поля пополняются #A082

**Вход:** AF, A номер записи начиная с 1, нулевой индекс недопустим

**Выход:** IX адрес записи, банк 3 выбран и прерывания разрешены, HL, DE, BC, AF, IY сохранены

**Изменяемые регистры и состояние:** IX, состояние банка и IFF, остальные регистры не меняются

В сохранённом графе: 14 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D2F.

### Engine.SpellDesc

Адрес #8066, блок `S10`. [Source/Engine/SpellDesc.asm](../Source/Engine/SpellDesc.asm#L14).

получить описатель одного из десяти заклинаний

банк 3, IX=#CE58+23*A, ID1 соответствует #CE6F, имя 20 байт и 0, стоимость магической силы в+21/+22, бой #D993 читает эту стоимость и передаёт #DB75 для списания, названия Заморозка, Ослепление, Шаровая молния и другие

**Вход:** AF, A номер записи начиная с 1, нулевой индекс недопустим

**Выход:** IX адрес записи, банк 3 выбран и прерывания разрешены, HL, DE, BC, AF, IY сохранены

**Изменяемые регистры и состояние:** IX, состояние банка и IFF, остальные регистры не меняются

В сохранённом графе: 14 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D2F.

### Engine.CompactArmy

Адрес #807E, блок `S10`. [Source/Engine/CompactArmy.asm](../Source/Engine/CompactArmy.asm#L14).

сжать список трёхбайтных записей армии

HL начало списка, B число записей, непустые записи с ID!=0 копируются в начало через LDI, свободный хвост заполняется нулями, C число непустых записей

**Вход:** HL список трёхбайтных записей, BC, B число записей

**Выход:** BC, C число непустых записей и B=0, записи уплотнены, свободный хвост обнулён, IX и IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, операнд #809D хранит исходное число записей

В сохранённом графе: 33 инструкций. Чтение: не выделено. Запись: #809D. Вызовы: не выделены.

### Engine.SelectMapBank

Адрес #80AE, блок `S10`. [Source/Engine/SelectMapBank.asm](../Source/Engine/SelectMapBank.asm#L12).

выбрать логический банк 10 с текущей картой

A=10, CALL #6D2F

**Вход:** без параметров

**Выход:** AF, A=10 при сохранении исходных F, выбран логический банк 10 и EI

**Изменяемые регистры и состояние:** A, состояние банка/IFF, HL, DE, BC, IX, IY и F сохранены

В сохранённом графе: 3 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D2F.

### Engine.MapCellAddress

Адрес #80B4, блок `S10`. [Source/Engine/MapCellAddress.asm](../Source/Engine/MapCellAddress.asm#L12).

вычислить адрес клетки карты

HL=#C000+161*B+C, строки хранятся с шагом 161, DE и BC сохранены

**Вход:** BC, B строка карты и C столбец, нужный банк уже выбран

**Выход:** HL=#C000+161*B+C, DE и BC сохранены

**Изменяемые регистры и состояние:** HL, AF, IX/IY не меняются, координаты не ограничиваются

В сохранённом графе: 11 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.ReadMapCell

Адрес #80C4, блок `S10`. [Source/Engine/ReadMapCell.asm](../Source/Engine/ReadMapCell.asm#L12).

прочитать байт клетки текущей карты

сохраняет банк, выбирает банк 10, вызывает #80B4, возвращает A=(HL), банк восстановлен

**Вход:** BC, B строка и C столбец текущей стратегической карты

**Выход:** AF, A байт карты, HL, DE, BC, IX, IY сохранены, банк восстановлен

**Изменяемые регистры и состояние:** AF, IFF после вызова разрешён, собственные регистры кроме AF сохранены

В сохранённом графе: 15 инструкций. Чтение: #5FA0. Запись: не выделена. Вызовы: #6D2F, #80AE, #80B4.

### Engine.UnitSpriteAddr

Адрес #80DB, блок `S10`. [Source/Engine/UnitSpriteAddr.asm](../Source/Engine/UnitSpriteAddr.asm#L14).

выбрать банк и начало четырёхкадрового графического ресурса

A<10 даёт C=6, HL=#D700+1024*A, A>=10 даёт C=7, HL=#BC00+1024*(A-9), функция сохраняет DE, BC, AF кроме выходного C

**Вход:** AF, A ID графического ресурса 1..25

**Выход:** HL начало четырёхкадровой графики, BC, C логический банк 6 либо 7 и B сохранён, DE, AF, IX, IY сохранены, сам банк не переключается

**Изменяемые регистры и состояние:** HL и C, нулевой ID для первой ветви не поддерживается циклом DJNZ

В сохранённом графе: 28 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.RenderObjects

Адрес #8104, блок `S10`. [Source/Engine/RenderObjects.asm](../Source/Engine/RenderObjects.asm#L15).

обновить 48 экранных объектов сетки 8 на 6

записи #6571 шаг 20, каждая занимает 4 на 4 знакоместа, типы 1 и 2 выводят разные форматы, тип 3 фон и маску, тип 4 анимирован, биты 7/6 выбирают горизонтальное отражение, бит 5 включает численную подпись через #827A

**Вход:** 48 записей #6571 и численные подписи #6931, экранная сетка 8 на 6

**Выход:** пиксельные/атрибутные слои и подписи обновлены по типам/флагам, счётчик #8243=48, IX=#6931, BC=#1800 после обхода

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, банки и IFF переключателя, поля объектов/анимации и экран

В сохранённом графе: 138 инструкций. Чтение: #8243. Запись: #8243. Вызовы: #5FA1, #8244, #825B, #827A.

### Engine.DrawBackLayer

Адрес #8244, блок `S10`. [Source/Engine/DrawBackLayer.asm](../Source/Engine/DrawBackLayer.asm#L12).

нарисовать фон объекта 4 на 4 знакоместа

HL ресурс, A=0 вызывает #7545, A!=0 вызывает зеркальный #75E1

**Вход:** HL графика 4 на 4 знакоместа, BC позиция, AF, A=0 обычно либо A!=0 зеркально

**Выход:** фон объекта выведен, HL, BC, A, IX, IY сохранены, DE=#0404

**Изменяемые регистры и состояние:** DE и F, F соответствует проверке OR A перед выводом

В сохранённом графе: 12 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7545, #75E1.

### Engine.DrawMaskLayer

Адрес #825B, блок `S10`. [Source/Engine/DrawMaskLayer.asm](../Source/Engine/DrawMaskLayer.asm#L13).

нарисовать маскированный слой объекта 4 на 4 знакоместа

HL пиксели, маска следует через 128 байт, A=0 вызывает #75A2, A!=0 вызывает зеркальный #7649

**Вход:** HL пиксели 4 на 4 знакоместа, следующая маска по HL+128, BC позиция, AF признак зеркальности A

**Выход:** маскированный слой выведен, HL, BC, A, IX сохранены, DE=#0404, IY=HL исходный+128

**Изменяемые регистры и состояние:** DE, F, IY, атрибуты не изменяются

В сохранённом графе: 16 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #75A2, #7649.

### Engine.DrawCountDI

Адрес #827A, блок `S10`. [Source/Engine/DrawCountDI.asm](../Source/Engine/DrawCountDI.asm#L14).

вывести беззнаковое число из HL при обработке прерывания

последовательные вычитания 10000,1000,100,10,1 из таблицы #82CB, ведущие нули подавляются самомодификацией условного JP #82B1, вывод символов #70D4

**Вход:** HL число 0..65535, BC позиция числа

**Выход:** HL=0 после разбора, IX и IY сохранены, для ненулевого числа C+=5, при нуле C+=4 и 0 рисуется в этой позиции

**Изменяемые регистры и состояние:** HL, DE, BC, AF, операнды #82B1..#82B3, F изменён, вывод #70D4 использует DI

В сохранённом графе: 41 инструкций. Чтение: не выделено. Запись: #82B1, #82B2, #82B3. Вызовы: #70D4.

### Engine.UpdateLocalView

Адрес #82D5, блок `S10`. [Source/Engine/UpdateLocalView.asm](../Source/Engine/UpdateLocalView.asm#L15).

отметить открытые клетки вокруг героя и подготовить экранные объекты

позиция #6A2E, область 5 на 5 от позиции-2 до+2, в логическом банке 11 карты посещения имеют шаг 2100 байт на континент и 21 байт на строку, устанавливает соответствующие биты, затем читает карту банка 10 и формирует объекты от #6611

**Вход:** #6A2D континент, #6A2E позиция, таблицы объектов и карты банков 0/1/10/11

**Выход:** отмечена видимость 5 на 5, подготовлены экранные записи фона/объектов/героя, в конце бит 2 #6566 установлен через #6D57

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, банки/IFF, #853F..#8542, карта посещений и объектные записи

В сохранённом графе: 216 инструкций. Чтение: #6A2D, #6A2E, #6A30, #6A31, #6A33, #6A44, #6A46, #6A4B, #6A4D, #853F. Запись: #832E, #853F, #8541. Вызовы: #6D2F, #6D34, #6D57, #80AE, #80B4, #84ED, #8543, #85D0.

### Engine.PlaceViewLayer

Адрес #84ED, блок `S10`. [Source/Engine/PlaceViewLayer.asm](../Source/Engine/PlaceViewLayer.asm#L18).

поставить графический слой только на текущем континенте и в области обзора

A должен совпасть #6A2D, BC должен быть в #853F..#8542, иначе RET без размещения, вход H/L задают банк/смещение данных, IY графический адрес, DE задаёт маску E и флаги D, вычисляет запись от #655D со смещениями 160*(B-top+1)+20*(C-left+1), поле 0=(поле 0 AND E) OR D, затем по смещению L записывает байт H и двухбайтный графический адрес из входного IY, операнды #852D/#8534/#8536 являются рабочими параметрами, IX принудительно=#6A2D

**Вход:** HL, H банк и L смещение поля слоя, DE, D флаги и E маска, BC клетка, AF, A континент, IY графический адрес

**Выход:** при совпадении континента и видимости обновляет флаги и поле графики экранного объекта, иначе ранний RET, IX=#6A2D

**Изменяемые регистры и состояние:** HL, BC, AF, IX, IY, DE собственный код сохраняет, изменяемые операнды #852D/#8534/#8536

В сохранённом графе: 37 инструкций. Чтение: #853F. Запись: #852D, #8534, #8536. Вызовы: #8652.

### Engine.PlaceGroup

Адрес #8543, блок `S10`. [Source/Engine/PlaceGroup.asm](../Source/Engine/PlaceGroup.asm#L18).

разместить прямоугольные объекты группы в локальном окне

вход IX группа указателей, DE шаг записей, B высота и C ширина объекта, HL начало графических блоков по 144 байта, для каждой записи с бит 0 флага сброшенным перебирает прямоугольник от+1/+2, видимые клетки получают тип 1, банк 4 и адрес текущего 144 байтного блока, после каждой клетки HL+=144, проверка #8652 исключает клетки вне локальногоокна, размеры/шаг/начало хранятся в изменяемых операндах

**Вход:** HL графические блоки по 144 байта, DE шаг записей, BC, B высота и C ширина, IX группа указателей

**Выход:** видимые клетки активных прямоугольников получают тип 1, банк 4 и адрес соответствующего графического блока

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, объектные записи и операнды размеров/шага/источника

В сохранённом графе: 69 инструкций. Чтение: #6A2D, #853F. Запись: #856E, #8578, #857B, #85C6. Вызовы: #7A74, #8652.

### Engine.PlaceCells

Адрес #85D0, блок `S10`. [Source/Engine/PlaceCells.asm](../Source/Engine/PlaceCells.asm#L16).

разместить одноклеточные записи группы в локальном окне

вход IX группа указателей, DE шаг записи, HL графика при сброшенном бите 5 исходных флагов, BC графика при установленном бите 5, активная видимая запись добавляет маскированный слой, поле 0 экранного объекта OR #03 OR исходныйбит 6, поле 8=4(банк графики), поля 9/10 адрес выбранного изображения, фоновая часть объекта сохраняется

**Вход:** HL графика при бите 5=0, DE шаг, BC графика при бите 5=1, IX группа указателей

**Выход:** активные видимые записи добавляют маскированный слой банка 4 и бит 6 отражения к экранным объектам

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, объектные записи и операнды шаблонов/шага

В сохранённом графе: 55 инструкций. Чтение: #6A2D, #853F. Запись: #8628, #862D, #8648. Вызовы: #7A74, #8652.

### Engine.InLocalView

Адрес #8652, блок `S10`. [Source/Engine/InLocalView.asm](../Source/Engine/InLocalView.asm#L13).

проверить попадание координат BC в прямоугольник локального окна

левая/верхняя границы #853F/#8540, правая/нижняя #8541/#8542, все границы включены, carry=1 внутри, carry=0 снаружи

**Вход:** BC координаты клетки

**Выход:** AF, carry=1 внутри включительных границ #853F..#8542, остальные регистры сохранены

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 18 инструкций. Чтение: #853F, #8540, #8541, #8542. Запись: не выделена. Вызовы: не выделены.

### Engine.RunOwnCastle

Адрес #8672, блок `S10`. [Source/Engine/RunOwnCastle.asm](../Source/Engine/RunOwnCastle.asm#L14).

загрузить и выполнить обработчик своего замка

A=21, #6C3B переносит модуль, CALL #B200

**Вход:** #867B адрес имени текущего своего замка, армия героя и состояние угрозы

**Выход:** оверлей 21 выполнен через #B200, результатом служат гарнизон/армия/состояние защиты, фиксированного результата в регистрах нет

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY и состояния обработчика оверлея 21, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 4 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6C3B, #B200.

### Engine.TerrainMask

Адрес #867D, блок `S10`. [Source/Engine/TerrainMask.asm](../Source/Engine/TerrainMask.asm#L13).

преобразовать младшие шесть бит байта местности по таблице порогов

A AND#3F, пары порог/результат после #868A, выбирается результат первого порога строго больше A, HL сохранён

**Вход:** AF, A байт местности

**Выход:** AF, A результат первой таблицы порогов, HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF, диапазон A сначала ограничивается младшими шестью битами

В сохранённом графе: 10 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.TerrainBattle

Адрес #8697, блок `S10`. [Source/Engine/TerrainBattle.asm](../Source/Engine/TerrainBattle.asm#L13).

преобразовать местность по второй таблице порогов

A AND#3F, пары порог/результат после #86A4, выбирается результат первого порога строго больше A, HL сохранён

**Вход:** AF, A байт местности

**Выход:** AF, A результат второй таблицы порогов, HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF, диапазон A сначала ограничивается младшими шестью битами

В сохранённом графе: 10 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.FreeCapacity

Адрес #86B1, блок `S10`. [Source/Engine/FreeCapacity.asm](../Source/Engine/FreeCapacity.asm#L14).

вычислить остаток допустимого количества выбранного типа отряда

#86EA возвращает floor(лидерство/коэффициент типа), среди 5 записей #6A1E ищется совпадающий ID, из предела вычитается его существующее 16 битное количество, при заёме результат насыщается 0, BC возвращает сколько ещё можно добавить, прочие основные и индексные регистры восстановлены

**Вход:** AF, A ID типа отряда

**Выход:** BC=max(0, предел(#86EA)-текущее количество этого ID), HL, DE, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** BC и альтернативные регистры калькулятора ROM, основные кроме BC восстановлены

В сохранённом графе: 36 инструкций. Чтение: не выделено. Запись: #86C6. Вызовы: #86EA.

### Engine.ControlLimit

Адрес #86EA, блок `S10`. [Source/Engine/ControlLimit.asm](../Source/Engine/ControlLimit.asm#L13).

рассчитать численный предел типа отряда из поля героя и таблицы

BC=#6A02 передаётся ROM, байт по #6AD3+A второй операнд, последовательность калькулятора #05, #27, #38, #6D76 возвращает BC, остальные сохранённые регистры восстановлены

**Вход:** AF, A ID типа отряда

**Выход:** BC=floor(word(#6A02)/byte(#6AD3+A)), HL, DE, AF, IX, IY сохранены

**Изменяемые регистры и состояние:** BC и альтернативные регистры калькулятора ROM, нулевой делитель проверкой не защищён

В сохранённом графе: 21 инструкций. Чтение: #6A02. Запись: не выделена. Вызовы: #6D62, #6D76, #6D88.

### Engine.BottomFrame

Адрес #8712, блок `S10`. [Source/Engine/BottomFrame.asm](../Source/Engine/BottomFrame.asm#L12).

нарисовать окно в нижней части экрана

BC=#0E00, DE=#081E, #73FE строит рамку с атрибутом A

**Вход:** AF, A атрибут окна

**Выход:** нижняя рамка по BC=#0E00 с внутренними размерами DE=#081E нарисована, IX и IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 4 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #73FE.

### Engine.NeedMoreMoney

Адрес #871C, блок `S10`. [Source/Engine/NeedMoreMoney.asm](../Source/Engine/NeedMoreMoney.asm#L12).

вывести сообщение о нехватке денег

A=#42 для #8712, затем #7117 печатает по BC=#1208 строку #872B «Денежки, денежки-то где ?»

**Вход:** параметры не требуются

**Выход:** нижняя рамка и сообщение о нехватке денег выведены, IX и IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, рабочие поля форматирования текста

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7117, #8712.

### Engine.RunOverlay20

Адрес #8799, блок `S10`. [Source/Engine/RunOverlay20.asm](../Source/Engine/RunOverlay20.asm#L14).

выполнить оверлей 20 и продолжить подсчётом записей

A=20, #6C3B, CALL #B200, затем выполнение без RET продолжается в #87A1

**Вход:** BC, C вариант завершения, передаваемый оверлею 20

**Выход:** обычный путь оверлея 20 перезапускает меню без возврата, если он вернётся, выполнение падает в #87A1 и возвращает BC число собственных активных замков

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY и системное состояние оверлея 20, возможен безвозвратный переход к загрузчику

В сохранённом графе: 3 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6C3B, #B200.

### Engine.CountOwnCastles

Адрес #87A1, блок `S10`. [Source/Engine/CountOwnCastles.asm](../Source/Engine/CountOwnCastles.asm#L14).

подсчитать записи банка 0 по флагу и полю #13

просматривает 80 записей с шагом 35 от #C000, запись учитывается, если бит 0 флагов сброшен и поле+19 равно 0, результат C

**Вход:** 80 записей замков банка 0 по 35 байт

**Выход:** BC, B=0 и C число записей с бит 0 поля 0=0 и владельцем+19 равным 0, HL, DE, AF, IX, IY сохранены, прежний банк восстановлен

**Изменяемые регистры и состояние:** BC, IFF после #6D2F разрешён

В сохранённом графе: 24 инструкций. Чтение: #5FA0. Запись: не выделена. Вызовы: #6D2F.

### Engine.HasOwnerCastle

Адрес #87D1, блок `S10`. [Source/Engine/HasOwnerCastle.asm](../Source/Engine/HasOwnerCastle.asm#L15).

найти активную запись с заданным владельцем

вход B сравнивается с полем+19, до 80 записей по 35 байт в логическом банке 0 от #C000, проверяется сброшенный бит 0 поля 0, zero отражает найденное совпадение, все изменённые регистры явно восстанавливаются, указатель IX наружу не возвращается

**Вход:** BC, B искомый владелец

**Выход:** AF, Z=1 если найдена активная запись с данным владельцем, A исходный логический банк, HL, DE, BC, IX, IY сохранены, банк восстановлен

**Изменяемые регистры и состояние:** AF, IFF разрешён, указатель найденной записи IX наружу не возвращается

В сохранённом графе: 25 инструкций. Чтение: #5FA0. Запись: не выделена. Вызовы: #6D2F.

### Engine.ShowScene

Адрес #8801, блок `S10`. [Source/Engine/ShowScene.asm](../Source/Engine/ShowScene.asm#L21).

показать одну из девяти упакованных сцен BL1/BL2 с восстановлением банка и основных регистров

#8801..#8839 сохраняет IX, IY, HL, DE, BC, AF, сохраняет номер банка из #5FA0, выбирает банк, записывает локальный номер в #C002, очищает экран, вызывает #C000 и восстанавливает банк и сохранённые регистры. A=1..5 выбирает банк 14/BL1 и локальный номер A, A=6..9 выбирает банк 15/BL2 и локальный номер A-5. RLE-тело идентично HERIMG, #C0FD..#C104 использует только B'/C' из альтернативного набора

**Вход:** AF — A=1..9, #5FA0 — исходный логический банк, BL1 по #C000 банка 14 и BL2 по #C000 банка 15 ранее загружены

**Выход:** HL, DE, BC, AF, HL', DE', AF', IX, IY и исходный логический банк восстановлены, выбранная сцена на экране, прерывания разрешены

**Изменяемые регистры и состояние:** BC'. HL, DE, BC, AF, HL', DE', AF', IX, IY сохранены

**Дополнительно:** #4000..#5AFF, настройки #C002..#C005 выбранного банка, временное переключение банка, EI через #6D2F

В сохранённом графе: 32 инструкций. Чтение: #5F9F. Запись: #C002. Вызовы: #5FA1, #6D2F, #73CF, #C000.

### Engine.BuildArmy

Адрес #883A, блок `S10`. [Source/Engine/BuildArmy.asm](../Source/Engine/BuildArmy.asm#L18).

преобразовать состав армии в пять боевых записей по 18 байт

целевые записи IY сначала очищаются на 90 байт, исходные записи IX имеют шаг 3, пятибайтное количество записывается в+2..6, координаты из HL в+10/+11, характеристики из описателя #8036 в+7,+8,+9

**Вход:** HL таблица координат в банке 3, BC, B максимум отрядов и C банк источника, AF, A режим/местность, IX трёхбайтные записи, IY90 байт назначения в банке 3

**Выход:** пять боевых записей очищены, до B непустых отрядов преобразованы в 18 байтный формат, HL/IX/IY продвинуты по обработанным записям, прежний банк восстановлен, F исходного входа восстановлен

**Изменяемые регистры и состояние:** HL, DE, BC, A, IX, IY, операнды #88F0/#88F9, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 88 инструкций. Чтение: #5FA0, #88F0, #88F9. Запись: #88F0, #88F9. Вызовы: #6D2F, #6D62, #6DC4, #8036.

### Engine.StoreArmy

Адрес #88FA, блок `S10`. [Source/Engine/StoreArmy.asm](../Source/Engine/StoreArmy.asm#L17).

преобразовать боевые записи обратно в исходный состав армии

IX до 5 боевых записей по 18 байт в банке 3, IY целевой массив записей по 3 байта в банке C, сначала очищает B исходных записей, ID переносится напрямую, пятибайтное количество преобразуется ROM в BC и записывается +1/+2, исходный банк восстановлен

**Вход:** BC, B максимум записей и C банк назначения, IX боевые записи 18 байт банка 3, IY исходные записи 3 байта

**Выход:** до B непустых боевых отрядов преобразованы обратно, IX шагает 18, IY шагает 3, прежний банк и исходные F восстановлены, A=прежнийбанк

**Изменяемые регистры и состояние:** HL, DE, BC, A, IX, IY и целевой массив, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 56 инструкций. Чтение: #5FA0, #88F9. Запись: #88F9. Вызовы: #6D2F, #6D76, #6DAE.

### Engine.ArmyMood

Адрес #896D, блок `S10`. [Source/Engine/ArmyMood.asm](../Source/Engine/ArmyMood.asm#L17).

оценить совместимость типа отряда с составом армии

B ID оцениваемого отряда, C дополнительный параметр, HL список до 5ID, DE шаг записей, в банке 3 используется матрица от #CA40 со строкой 25 байт и индексом ID, значение #FF завершает с результатом #FF, нулевое значение снижает базовый результат, поле 17 описателя может увеличить либо уменьшить итог, A оценка настроения

**Вход:** HL список ID, DE шаг записей, BC, B ID оцениваемого типа и C дополнительный параметр совместимости

**Выход:** AF, A оценка совместимости с учётом матрицы и поля 17 описателя, F исходный, IX и IY сохранены, прежний банк восстановлен

**Изменяемые регистры и состояние:** HL, DE, BC, A, матричные рабочие операнды, IFF разрешён

В сохранённом графе: 59 инструкций. Чтение: #5FA0, #8991. Запись: #8991, #89B4, #89BA, #89BD. Вызовы: #6D2F, #8036.

### Engine.LoseLeadership

Адрес #89E0, блок `S10`. [Source/Engine/LoseLeadership.asm](../Source/Engine/LoseLeadership.asm#L14).

уменьшить 16 битное поле героя #6A02 с насыщением 0

ROM формула использует число 2 и пятибайтные поля #656C, #6567, токены #05, #04, #27, результат BC вычитается из #6A02, при заёме записывается 0

**Вход:** пятибайтные #6567/#656C и поле #6A02

**Выход:** HL новое значение #6A02=max(0, старое-floor(2*#656C/#6567)), BC вычисленное уменьшение

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX/IY зависят от прямых ROM токенов, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 15 инструкций. Чтение: #6A02. Запись: #6A02. Вызовы: #6D76, #6D88, #6DAE.

### Engine.GainLeadership

Адрес #8A08, блок `S10`. [Source/Engine/GainLeadership.asm](../Source/Engine/GainLeadership.asm#L14).

увеличить 16 битное поле героя #6A02 с насыщением #FFFF

ROM формула использует число 2 и поля #6567, #656C в обратном порядке к #89E0, токены #05, #04, #27, результат BC прибавляется, при переносе записывается #FFFF

**Вход:** пятибайтные #6567/#656C и поле #6A02

**Выход:** HL новое значение #6A02=min(65535, старое+floor(2*#6567/#656C)), BC вычисленное увеличение

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX/IY зависят от прямых ROM токенов, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 15 инструкций. Чтение: #6A02. Запись: #6A02. Вызовы: #6D76, #6D88, #6DAE.

### Engine.HandleMapInput

Адрес #8A2C, блок `S10`. [Source/Engine/HandleMapInput.asm](../Source/Engine/HandleMapInput.asm#L16).

получить команду главного режима и обработать движение

ожидает carry от #6BF1, восемь кодов направлений меняют BC относительно #6A2E, остальные проверяются таблицей #653A, движение возвращает 0 в A, команды возвращают код, дальше проверяются режим и клетка назначения

**Вход:** текущее положение #6A2E, режим #6A33, карта, клавиатура/Kempston

**Выход:** AF, A код разрешённой команды либо 0 после обработанного движения, меняются позиция и стоимость времени #69D7, запрещённый шаг снова ждёт ввод

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, рабочие поля движения, банки/IFF, отдельные ветви отбрасывают адрес локального возврата и не возвращаются к нему

В сохранённом графе: 2 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6BF1.

### Engine.ApplyMoveCode

Адрес #8A31, блок `S10`. [Source/Engine/ApplyMoveCode.asm](../Source/Engine/ApplyMoveCode.asm#L14).

применить уже полученный код движения к позиции героя

вход A, BC загружается #6A2E, восемь кодов направлений вызывают ограничивающие процедуры #8BDD/#8BF2/#8BF9/#8C15, затем общая проверка #8AA5, используется и автодвижением #7F40

**Вход:** AF, A уже полученный код направления/команды, остальные данные как у #8A2C

**Выход:** теже результаты движения, что у #8A2C, нереализованный/запрещённый шаг может перейти непосредственно к ожиданию клавиши

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, состояние движения и стек при выходах через #8BE4/#8C39

В сохранённом графе: 174 инструкций. Чтение: #6A2D, #6A2E, #6A31, #6A33, #8BD6, #8BD9, #8BDB, #8BDC. Запись: #69D5, #69D7, #6A2E, #6A31, #6A33, #8BD6, #8BD9, #8BDA, #8BDB, #8BDC. Вызовы: #6D2F, #7A74, #80C4, #8697, #8A2C, #8BDD, #8BF2, #8BF9, #8C15, #8C31, #8C39.

### Engine.MapMoveUp

Адрес #8BDD, блок `S10`. [Source/Engine/MapMoveUp.asm](../Source/Engine/MapMoveUp.asm#L14).

уменьшить строку героя в пределах рабочей части карты

при B=2 переход #8BE4 обрабатывает запрет шага, иначе DEC B, нижняя допустимая строка 2

**Вход:** BC координаты героя, предполагается вызов из обработки перемещения

**Выход:** если B!=2, B изменён на-1 и обычный RET, для горизонтального шага обновлены биты 3/4 #6A33. На границе 7HALT с бордюром, POP HL отбрасывает адрес возврата и JP #8A2C

**Изменяемые регистры и состояние:** AF и изменяемый байт BC в обычной ветви, HL, DE, IX, IY сохранены только до граничного перехода, после перехода действует контракт #8A2C

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #8A2C.

### Engine.MapMoveDown

Адрес #8BF2, блок `S10`. [Source/Engine/MapMoveDown.asm](../Source/Engine/MapMoveDown.asm#L14).

увеличить строку героя в пределах рабочей части карты

при B=#61 переход #8BE4, иначе INC B, верхняя допустимая строка 97

**Вход:** BC координаты героя, предполагается вызов из обработки перемещения

**Выход:** если B!=97, B изменён на+1 и обычный RET, для горизонтального шага обновлены биты 3/4 #6A33. На границе 7HALT с бордюром, POP HL отбрасывает адрес возврата и JP #8A2C

**Изменяемые регистры и состояние:** AF и изменяемый байт BC в обычной ветви, HL, DE, IX, IY сохранены только до граничного перехода, после перехода действует контракт #8A2C

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #8A2C.

### Engine.MapMoveLeft

Адрес #8BF9, блок `S10`. [Source/Engine/MapMoveLeft.asm](../Source/Engine/MapMoveLeft.asm#L15).

уменьшить столбец героя и повернуть его влево

при C=2 переход #8BE4, иначе DEC C, в #6A33 сбрасывается бит 3, при режиме 1 также сбрасывается бит 4

**Вход:** BC координаты героя, предполагается вызов из обработки перемещения

**Выход:** если C!=2, C изменён на-1 и обычный RET, для горизонтального шага обновлены биты 3/4 #6A33. На границе 7HALT с бордюром, POP HL отбрасывает адрес возврата и JP #8A2C

**Изменяемые регистры и состояние:** AF и изменяемый байт BC в обычной ветви, HL, DE, IX, IY сохранены только до граничного перехода, после перехода действует контракт #8A2C

В сохранённом графе: 22 инструкций. Чтение: #6A33. Запись: #6A33. Вызовы: #8A2C.

### Engine.MapMoveRight

Адрес #8C15, блок `S10`. [Source/Engine/MapMoveRight.asm](../Source/Engine/MapMoveRight.asm#L14).

увеличить столбец героя и повернуть его вправо

при C=#9E переход #8BE4, иначе INC C, в #6A33 ставится бит 3, при режиме 1 также ставится бит 4

**Вход:** BC координаты героя, предполагается вызов из обработки перемещения

**Выход:** если C!=158, C изменён на+1 и обычный RET, для горизонтального шага обновлены биты 3/4 #6A33. На границе 7HALT с бордюром, POP HL отбрасывает адрес возврата и JP #8A2C

**Изменяемые регистры и состояние:** AF и изменяемый байт BC в обычной ветви, HL, DE, IX, IY сохранены только до граничного перехода, после перехода действует контракт #8A2C

В сохранённом графе: 22 инструкций. Чтение: #6A33. Запись: #6A33. Вызовы: #8A2C.

### Engine.MoveMask

Адрес #8C31, блок `S10`. [Source/Engine/MoveMask.asm](../Source/Engine/MoveMask.asm#L12).

получить маску по текущему байту местности

A=#8BD9, преобразование #867D, результат L

**Вход:** #8BD9 байт местности текущего шага

**Выход:** HL, L маска из #867D и H сохранён, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** L, AF

В сохранённом графе: 4 инструкций. Чтение: #8BD9. Запись: не выделена. Вызовы: #867D.

### Engine.FilterArmy

Адрес #8C39, блок `S10`. [Source/Engine/FilterArmy.asm](../Source/Engine/FilterArmy.asm#L18).

отфильтровать армию по маске местности и обновить записи

L=0 даёт обычный RET, иначе маска патчится в AND #8C5F/#8C81, если #8CD1 нашёл объект в текущей клетке, несовместимые по флагам E #7AEF ID армии обнуляются и список уплотняется, если объекта нет, первая несовместимая запись вызывает диалог «Мы туда не пойдём!», затем POP HL отбрасывает адрес возврата, обновляется вид #82D5 и управление переходит JP #8A2C, эта ветвь не возвращается вызывающей процедуре

**Вход:** HL, L маска допустимых флагов отрядов, состояние армии/клетки героя

**Выход:** при L=0 обычный RET, при объекте в клетке неподходящие ID обнулены и армия уплотнена. Без объекта неподходящий отряд вызывает сообщение и нелокальный переход в #8A2C

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, армия и операнды маски, ветвь запрета удаляет одно слово возврата из стека

В сохранённом графе: 61 инструкций. Чтение: #6A2E. Запись: #8C5F, #8C81, #8D29. Вызовы: #6D3F, #6D57, #7117, #7366, #73FE, #7AEF, #7BF4, #807E, #82D5, #8A2C, #8CD1.

### Engine.FindMapObject

Адрес #8CD1, блок `S10`. [Source/Engine/FindMapObject.asm](../Source/Engine/FindMapObject.asm#L15).

определить тип объекта в координатах #8D29

проверяет специальные позиции #6A44/#6A4B для текущего континента, возвращает C=10/11 при совпадении, иначе бит 7 карты и девять групп из таблицы #8D41, #8D6E ищет запись, C=1..9 тип группы, C=0 отсутствие объекта

**Вход:** #8D29 координаты искомой клетки, #6A2D текущий континент

**Выход:** BC, C тип 0..11, IX запись при типах 1..9, при специальных типах 10/11 указатель IX не гарантируется

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, логический банк 0 остаётся выбранным, EI

В сохранённом графе: 54 инструкций. Чтение: #6A2D, #6A44, #6A46, #6A4B, #6A4D, #8D29. Запись: не выделена. Вызовы: #6D2F, #80C4, #8D6E.

### Engine.FindRecord

Адрес #8D6E, блок `S10`. [Source/Engine/FindRecord.asm](../Source/Engine/FindRecord.asm#L16).

найти активную запись группы, покрывающую координату HL

сначала бит 7 карты по HL, затем IX указатели текущего континента и количество, DE шаг, B/C размеры записи на карте, сравниваются координаты+1/+2 с областью, при совпадении A!=0 и IX запись, иначе A=0

**Вход:** HL координаты искомой клетки, DE шаг записей, BC размер области, IX таблица четырёхбайтных указателей по континентам

**Выход:** AF, A=0 если не найдено, иначе ненулевое A и IX найденная запись

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY собственный код не меняет, банк выбирается при чтении карты и восстанавливается #80C4

В сохранённом графе: 57 инструкций. Чтение: #6A2D. Запись: #8DB1, #8DB3, #8DB6, #8DBB, #8DCF. Вызовы: #7A74, #80C4.

### Engine.StepArmies

Адрес #8DDA, блок `S10`. [Source/Engine/StepArmies.asm](../Source/Engine/StepArmies.asm#L32).

сближение, отступление и разделение внешних армий около героя

Для континентальной таблицы #6B79 в банке 1, шаг 22, вычисляет включительный прямоугольник ±3 вокруг #6A2E с обрезкой x=0..160, y=0..99. Пропускает записи при (flags AND #11)!=0, уменьшает задержку (flags AND #0E) на 2 ещё до проверки радиуса. Требует совпадения бита 5 флагов с режимом героя 0/1. #9193 сравнивает R=S героя/S группы, суммы количества*слова +22/+23 описателя SOLDIERS, смещения десятичные. При R<2 выбирает три шага к герою, при R>=2 три противоположных шага. Кандидаты требуют x=3..157, y=3..96, совпадение суши/воды, отсутствие занятого объекта кроме находки типа 8. Находка сразу помечается использованной, ещё до проверки совместимости армии с местностью. Ненулевая маска местности требует совместимости с флагами отрядов. При сближении несовместимость может отделить совместимые максимум 4 отряда в свободную запись, если отношение сил к этой части также <2. Переносит 12 байтов временной армии, удаляет их из источника и продолжает остальные кандидаты. Поля новой записи +3..+6 не инициализирует. При отступлении деления нет, проходимость требуется для всей группы. Перенос снимает старый бит 7 карты, обновляет координаты/ориентацию и ставит новый бит 7. Бит 4 блокирует повторную обработку новых/исходных записей внутри прохода, в конце очищается у всех. Боевой вызов и объединение существующих групп отсутствуют, встреча через оверлей 7 возникает позже в main #64E8..#6506.

**Вход:** #6A2D — текущий континент, #6A2E — координаты героя, #6A33 — режим, #6A1E — армия, #6B79 — таблица четырёх континентов с указателями и количествами 22-байтовых записей, банк 1 — состояния, банк 10 — текущая стратегическая карта

**Выход:** позиции, составы и флаги групп обновлены, карта занятости актуальна, бит 4 снят у всех записей, выбран банк 1

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF' зависят от калькулятора ROM, IX, IY

**Дополнительно:** таблица армий банка 1, карта занятости, находки с шагом 3 байта, #8D29, #9172, #928F..#92CA, самомодификация операндов #8F61/#8F64/#8FC6/#8FE2/#9034/#903D/#9161/#9164

В сохранённом графе: 399 инструкций. Чтение: #6A2D, #6A2E, #6A33, #9172, #928F, #9291, #92BF. Запись: #8D29, #8F61, #8F64, #8FC6, #8FE2, #9034, #903D, #9161, #9164, #9172, #928F, #9291, #9292, #9294. Вызовы: #6D2F, #7A74, #7AEF, #7C71, #807E, #80AE, #80B4, #80C4, #8CD1, #9173, #9193, #91BF, #9245.

### Engine.InNearbyRect

Адрес #9173, блок `S10`. [Source/Engine/InNearbyRect.asm](../Source/Engine/InNearbyRect.asm#L12).

проверить координаты DE относительно ближайшей области героя

нижние границы #9292/#9293, верхние #9294/#9295, все включены, carry=1 внутри, carry=0 снаружи

**Вход:** DE координаты

**Выход:** AF, carry=1 внутри включительных границ #9292..#9295, остальные регистры сохранены

**Изменяемые регистры и состояние:** AF

В сохранённом графе: 18 инструкций. Чтение: #9292, #9293, #9294, #9295. Запись: не выделена. Вызовы: не выделены.

### Engine.CompareArmies

Адрес #9193, блок `S10`. [Source/Engine/CompareArmies.asm](../Source/Engine/CompareArmies.asm#L15).

сопоставить взвешенные величины двух составов армии

S героя=sum5 записей #6A1E(количество*поле 22/23), S вход=sumB записей HL, токен 05 получает S героя/S вход, затем на стек 2 и #6DDA вычитает, carry отражает отношение<2, zero отношение=2, деление на нулевую силу входной армии явно не защищено, IX/IY сохранены

**Вход:** HL входной список армии, BC, B число его записей, пять записей армии героя #6A1E

**Выход:** AF, C=1 при силагероя/силавходной<2, Z=1 при равенстве 2, IX и IY сохранены, банк 1 выбран

**Изменяемые регистры и состояние:** HL, DE, BC, AF, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются, делитель нулевой силы явно не защищён

В сохранённом графе: 17 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D88, #6DDA, #91B6.

### Engine.SumArmyBank1

Адрес #91B6, блок `S10`. [Source/Engine/SumArmyBank1.asm](../Source/Engine/SumArmyBank1.asm#L13).

вычислить сумму полей армии из банка 1

A=1, #6D2F, затем #7A17, вход HL/B задаёт список трёхбайтных записей

**Вход:** HL список трёхбайтных записей, BC, B максимум записей

**Выход:** банк 1 выбран, сумма количество*поле 22/23 на стеке калькулятора, как в #7A17

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX/IY не сохраняются единым контрактом ROM, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 4 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D2F, #7A17.

### Engine.SetFacing

Адрес #91BF, блок `S10`. [Source/Engine/SetFacing.asm](../Source/Engine/SetFacing.asm#L13).

изменить бит 6 флагов объекта по коду направления

A=1 либо 5 сохраняет флаг, A2..4 устанавливает бит 6 IX+0, A6..8 сбрасывает бит 6

**Вход:** AF, A направление 1..8, IX запись объекта

**Выход:** для A=1/5 бит 6IX+0 не меняется, A2..4 устанавливает, A6..8 сбрасывает, HL, DE, BC, A, IX, IY сохранены

**Изменяемые регистры и состояние:** F, кроме условно меняемого бита памяти собственный код не изменяет регистры

В сохранённом графе: 9 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.StepsUp

Адрес #91D1, блок `S10`. [Source/Engine/StepsUp.asm](../Source/Engine/StepsUp.asm#L14).

сформировать три варианта шага вверх

IY массив трёх записей [0, X, Y], уменьшает байты+2,+4,+5,+8 и увеличивает+7, получается центрвверх и две соседние диагонали

**Вход:** IY начало трёх записей [тип, C, B] по 3 байта

**Выход:** координаты трёх кандидатов изменены согласно направлению процедуры, HL, DE, BC, A, IX, IY сохранены

**Изменяемые регистры и состояние:** F кроме входного C, поскольку INC/DEC памяти carry не изменяют

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.StepsUpRight

Адрес #91E1, блок `S10`. [Source/Engine/StepsUpRight.asm](../Source/Engine/StepsUpRight.asm#L13).

сформировать три варианта шага вверх-вправо

изменяет байты кандидатов IY+1(+1),+2(-1),+5(-1),+7(+1), три направления вокруг диагонали

**Вход:** IY начало трёх записей [тип, C, B] по 3 байта

**Выход:** координаты трёх кандидатов изменены согласно направлению процедуры, HL, DE, BC, A, IX, IY сохранены

**Изменяемые регистры и состояние:** F кроме входного C, поскольку INC/DEC памяти carry не изменяют

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.StepsRight

Адрес #91EE, блок `S10`. [Source/Engine/StepsRight.asm](../Source/Engine/StepsRight.asm#L13).

сформировать три варианта шага вправо

увеличивает IY+1,+4,+7,+8 и уменьшает+5

**Вход:** IY начало трёх записей [тип, C, B] по 3 байта

**Выход:** координаты трёх кандидатов изменены согласно направлению процедуры, HL, DE, BC, A, IX, IY сохранены

**Изменяемые регистры и состояние:** F кроме входного C, поскольку INC/DEC памяти carry не изменяют

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.StepsDownRight

Адрес #91FE, блок `S10`. [Source/Engine/StepsDownRight.asm](../Source/Engine/StepsDownRight.asm#L13).

сформировать три варианта шага вниз-вправо

увеличивает IY+1,+2,+4,+8

**Вход:** IY начало трёх записей [тип, C, B] по 3 байта

**Выход:** координаты трёх кандидатов изменены согласно направлению процедуры, HL, DE, BC, A, IX, IY сохранены

**Изменяемые регистры и состояние:** F кроме входного C, поскольку INC/DEC памяти carry не изменяют

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.StepsDown

Адрес #920B, блок `S10`. [Source/Engine/StepsDown.asm](../Source/Engine/StepsDown.asm#L13).

сформировать три варианта шага вниз

увеличивает IY+2,+5,+7,+8 и уменьшает+4

**Вход:** IY начало трёх записей [тип, C, B] по 3 байта

**Выход:** координаты трёх кандидатов изменены согласно направлению процедуры, HL, DE, BC, A, IX, IY сохранены

**Изменяемые регистры и состояние:** F кроме входного C, поскольку INC/DEC памяти carry не изменяют

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.StepsDownLeft

Адрес #921B, блок `S10`. [Source/Engine/StepsDownLeft.asm](../Source/Engine/StepsDownLeft.asm#L13).

сформировать три варианта шага вниз-влево

уменьшает IY+1,+4 и увеличивает+2,+8

**Вход:** IY начало трёх записей [тип, C, B] по 3 байта

**Выход:** координаты трёх кандидатов изменены согласно направлению процедуры, HL, DE, BC, A, IX, IY сохранены

**Изменяемые регистры и состояние:** F кроме входного C, поскольку INC/DEC памяти carry не изменяют

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.StepsLeft

Адрес #9228, блок `S10`. [Source/Engine/StepsLeft.asm](../Source/Engine/StepsLeft.asm#L13).

сформировать три варианта шага влево

уменьшает IY+1,+4,+5,+7 и увеличивает+8

**Вход:** IY начало трёх записей [тип, C, B] по 3 байта

**Выход:** координаты трёх кандидатов изменены согласно направлению процедуры, HL, DE, BC, A, IX, IY сохранены

**Изменяемые регистры и состояние:** F кроме входного C, поскольку INC/DEC памяти carry не изменяют

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.StepsUpLeft

Адрес #9238, блок `S10`. [Source/Engine/StepsUpLeft.asm](../Source/Engine/StepsUpLeft.asm#L13).

сформировать три варианта шага вверх-влево

уменьшает IY+1,+2,+5,+7

**Вход:** IY начало трёх записей [тип, C, B] по 3 байта

**Выход:** координаты трёх кандидатов изменены согласно направлению процедуры, HL, DE, BC, A, IX, IY сохранены

**Изменяемые регистры и состояние:** F кроме входного C, поскольку INC/DEC памяти carry не изменяют

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.MakeSteps

Адрес #9245, блок `S10`. [Source/Engine/MakeSteps.asm](../Source/Engine/MakeSteps.asm#L16).

построить три возможных шага объекта и вызвать обработчик направления

A1..8, IY база таблицы слов, выбирает адрес по IY+2*A, кладёт в стек сначала #9270 затем выбранный адрес, создаёт три записи [0, IX+1, IX+2] по #92B6, IY=#92B6, RET передаёт управление выбранному обработчику, его RET возвращается в #9270

**Вход:** AF, A направление 1..8, IX запись объекта с координатами+1/+2, IY база таблицы направлений

**Выход:** три кандидата [тип, C, B] сформированы по #92B6 и классифицированы продолжением #9270, HL=#92BF, BC координаты третьего кандидата, IX сохранён, IY=#92BF

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IY, временно использует два дополнительных адреса в стеке, баланс после #9270 восстановлен

В сохранённом графе: 22 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.ClassifySteps

Адрес #9270, блок `S10`. [Source/Engine/ClassifySteps.asm](../Source/Engine/ClassifySteps.asm#L15).

заполнить тип местности у трёх возможных шагов

продолжение стекового диспетчера #9245, три записи [тип, C, B] по #92B6, #80C4 читает карту по координатам+1/+2, #867D преобразует байт местности в маску, она записывается в поле 0, IY шагает по 3 байта

**Вход:** три записи [тип, C, B] #92B6 уже заполнены координатами

**Выход:** BC координаты третьего кандидата, AF, A его маска местности, IY=#92BF, D=0, HL и IX сохранены

**Изменяемые регистры и состояние:** DE, BC, AF, IY, первый байт каждой из трёх записей получает результат #867D(#80C4)

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #80C4, #867D.

### Engine.StepMapTroops

Адрес #92CB, блок `S10`. [Source/Engine/StepMapTroops.asm](../Source/Engine/StepMapTroops.asm#L31).

перемещение шестибайтовых объектов из континентальной таблицы #6B69

Выбирает список текущего континента по #6B69, банк 0, шаг 6 байтов. Формирует включительный прямоугольник ±3 вокруг героя с обрезкой x=0..160, y=0..99. Пропускает записи с битом 0, вне прямоугольника, на клетке героя либо с битом 5, не соответствующим режиму героя 0/1. Направление к герою вычисляет #7C71, таблица #92A4 и стековый диспетчер #9245 формируют три кандидата. Требует x=3..157, y=3..96. Для объекта с битом 5 разрешён только класс #FF, без бита 5 класс #FF запрещён. #8CD1 различает свободную клетку, находку типа 8 и остальные занятые клетки. Свободная клетка дополнительно требует снятого бита 7 карты. Находка типа 8 сразу получает бит 0 использованной записи, а у её байта карты снимается именно бит 0. Для ненулевого класса кандидат требует пересечения маски местности с E, возвращённым #7AEF для ID объекта из +3. При успехе снимает бит 7 старой клетки, пишет координаты +1/+2 и ориентацию через #91BF, ставит бит 7 новой клетки и завершает перебор кандидатов данной записи. После трёх отказов сохраняет исходную позицию. Конкретное игровое название этого вида объектов по одному списку не устанавливается.

**Вход:** #6A2D — континент, #6A2E — координаты героя, #6A33 — режим, #6B69 — четыре пары указатель/количество шестибайтовых записей, банк 0 — записи объектов

**Выход:** координаты и ориентация подходящих объектов обновлены, занятость карты перенесена, встреченные находки типа 8 могут быть использованы до окончательной проверки проходимости

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

**Дополнительно:** #928F..#92BE, #8D29, записи банка 0 и байты карт, переключение банков через драйвер #5FA1. Исходная особенность, #8CD1 меняет IX на найденный объект. При C!=0 и C!=8 отказ #93BC -> #9432 не восстанавливает IX из #928F. Если так заканчивается последний кандидат, #943E прибавляет 6 к чужому указателю, последующий проход может читать другую запись. Проявление в игре не проверено.

В сохранённом графе: 161 инструкций. Чтение: #6A2D, #6A2E, #6A33, #928F, #9291. Запись: #8D29, #928F, #9291, #9292, #9294. Вызовы: #6D2F, #7A74, #7AEF, #7C71, #80AE, #80B4, #80C4, #8CD1, #9173, #91BF, #9245.

### Engine.RefreshPanels

Адрес #944A, блок `S10`. [Source/Engine/RefreshPanels.asm](../Source/Engine/RefreshPanels.asm#L14).

перерисовать верхнюю строку и боковую панель игры

верхняя рамка #73FE, обязательная проверяемая очистка #6B8D, строка #9525 по BC=#0112, дата через #9468, подробности героя через #957C

**Вход:** поля даты, героя и ресурсов главного экрана

**Выход:** верхняя строка и боковая панель обновлены, #6B8D очищает рабочий банк 8 в проверяемой контрольной точке

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, экран, рабочий банк 8 и калькулятор ROM

В сохранённом графе: 11 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6B8D, #73FE, #9468, #94C8, #957C.

### Engine.PrintDate

Адрес #9468, блок `S10`. [Source/Engine/PrintDate.asm](../Source/Engine/PrintDate.asm#L14).

разобрать счётчик дней и вывести календарную дату

поле #6A36, повторные вычитания #0162 и таблица длин периодов #94BB, печать числа дня по BC=#010C и названия через #70E3/#94C8, точные имена периодов зависят от встроенной таблицы

**Вход:** word(#6A36) счётчик дней

**Выход:** календарная дата выведена в верхнюю строку, IY собственным кодом сохранён

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 41 инструкций. Чтение: #6A36. Запись: не выделена. Вызовы: #73CF, #94C8, #94D2.

### Engine.PrintZeroText

Адрес #94C8, блок `S10`. [Source/Engine/PrintZeroText.asm](../Source/Engine/PrintZeroText.asm#L13).

вывести строку с нулевым терминатором

DE адрес, BC положение, каждый байт выводится #70C5, C и DE увеличиваются, нулевой байт завершает

**Вход:** DE строка с нулевым терминатором, BC позиция

**Выход:** DE у нулевого терминатора, BC, C после последнего символа, B сохранён, HL, IX, IY сохранены

**Изменяемые регистры и состояние:** DE, BC, AF, IFF разрешён вызовом #70C5

В сохранённом графе: 7 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #70C5.

### Engine.PrintU16

Адрес #94D2, блок `S10`. [Source/Engine/PrintU16.asm](../Source/Engine/PrintU16.asm#L15).

вывести 16 битное число HL без ведущих нулей

при HL=0 выводит 0, иначе последовательные вычитания 10000,1000,100,10,1 из #951B, самомодифицируемый JP #9503 подавляет первые нули, символы через #70C5, C сдвигается по каждому разряду

**Вход:** HL число 0..65535, BC позиция

**Выход:** HL=0, для ненулевого числа C+=5 и IX=#9525, для 0 символ 0 рисуется без изменения C и IX, IY сохранён

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX в ненулевой ветви, операнды #9503..#9505

В сохранённом графе: 36 инструкций. Чтение: не выделено. Запись: #9503, #9504, #9505. Вызовы: #70C5.

### Engine.RefreshHero

Адрес #957C, блок `S10`. [Source/Engine/RefreshHero.asm](../Source/Engine/RefreshHero.asm#L16).

обновить боковую панель героя, расходы и рейтинг

рамка BC=#0414, обязательная #6B8D, портрет 144 байта из логического банка 4 по #EF30, сообщения #96AE/#96F6, вывод включает «Расход», «Наличные», «Рейтинг», численные расчёты через калькулятор и #ADBF

**Вход:** поля героя, денежные пятибайтные числа, ресурсы портрета и армии

**Выход:** боковая панель, расходы, наличные и рейтинг перерисованы, #6B8D очищает рабочий банк 8 в контрольной точке

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, экран, банк 8 и поля калькулятора, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 110 инструкций. Чтение: #6A02, #6A31, #6A3B. Запись: не выделена. Вызовы: #6B8D, #6D2F, #6D62, #6D76, #6DAE, #6DC4, #6DDA, #70E3, #7117, #73AD, #73FE, #7545, #7AB0, #94C8, #94D2, #9E78, #ADBF.

### Engine.TickTime

Адрес #9704, блок `S10`. [Source/Engine/TickTime.asm](../Source/Engine/TickTime.asm#L18).

продвинуть время игры и выполнить периодические расчёты

прибавляет стоимость шага #69D7 к дробной части #6A35, перенос увеличивает дни #6A36, без нового дня вызывает #A5AE с A=0, при новом дне продолжается восстановление ресурсов, расчёты армии, регулярные расходы и события, строки #9CD0..#9E5C описывают жалование, корабль и пожертвования

**Вход:** byte(#69D7) стоимость шага, дробное время #6A35, дни #6A36, срок #6A38, состояние ресурсов/армии/угроз

**Выход:** стоимость шага прибавлена к дробному времени, перенос увеличивает дни на 1, дневные и недельные обработчики обновляют ресурсы/армию/замки, #A5AE получает 0 или 1 по факту дня

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, игровые временные поля и вызываемые состояния, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются, достижение срока может перейти к оверлею 20 без возврата

В сохранённом графе: 576 инструкций. Чтение: #69D7, #6A04, #6A06, #6A1E, #6A2E, #6A31, #6A33, #6A35, #6A36, #6A38, #6A3B, #9824, #9825, #9B54, #9B55, #9C70, #9C9D, #9CA3. Запись: #6A04, #6A2E, #6A31, #6A32, #6A33, #6A35, #6A36, #6A3B, #9824, #9825, #982D, #9925, #992D, #9B54, #9B55, #9D6D, #9E59. Вызовы: #6D2F, #6D34, #6D62, #6D88, #6DAE, #6DC4, #6DDA, #70E3, #7117, #73AD, #73CF, #73FE, #776D, #7A80, #7AB0, #7AEF, #7BF4, #7C0D, #8036, #807E, #80C4, #82D5, #8697, #8799, #89E0, #944A, #9468, #957C, #9E6D, #9E78, #9EA5, #9ECA, #A082, #A0FC, #A107, #A235, #A2E0, #A5AE, #AC78, #AD31, #ADBF, #D255.

### Engine.ClearLeftPanel

Адрес #9E6D, блок `S10`. [Source/Engine/ClearLeftPanel.asm](../Source/Engine/ClearLeftPanel.asm#L12).

очистить основную область слева от боковой панели

BC=#0400, DE=#1414, A=0, #73CF обнуляет пиксели и атрибуты

**Вход:** параметры не требуются

**Выход:** прямоугольник 20 на 20 знакомест отстроки 4 очищен, HL, IX, IY сохранены, DE=#1414, A=0

**Изменяемые регистры и состояние:** DE, BC и F через завершающий #73AD, экран и атрибуты

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #73CF.

### Engine.StackTroopCost

Адрес #9E78, блок `S10`. [Source/Engine/StackTroopCost.asm](../Source/Engine/StackTroopCost.asm#L15).

передать стоимость отряда на стек калькулятора

IY трёхбайтная запись армии, по ID читается 16 битное поле 24/25 описателя SOLDIERS, умножается на количество+1/+2 токеном 04, токен 31 дублирует результат, регистры восстановлены

**Вход:** IY трёхбайтная запись ID/количество

**Выход:** на стек калькулятора добавлены две копии произведения количества на поле 24/25 описателя, HL, DE, BC, AF, IX, IY сохранены, банк 3 остаётся выбранным

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY сохранены, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 22 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D62, #8036.

### Engine.SumExpenses

Адрес #9EA5, блок `S10`. [Source/Engine/SumExpenses.asm](../Source/Engine/SumExpenses.asm#L15).

сложить отмеченные статьи расходов

семь записей по 6 байт от #9C7F, бит 7 первого байта включает следующее пятибайтное число в сумму, на стеке сначала 0, токен 0F сложение, результат сохраняется в #9C6B

**Вход:** семь шестибайтных записей расходов #9C7F с флагами бит 7

**Выход:** пятибайтная сумма отмеченных записей записана #9C6B..#9C6F, временно добавленная сумма снята со стека калькулятора

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX/IY зависят от ROM #2ABB/#2BF1, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 19 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D88, #6DAE, #6DC4.

### Engine.DevelopTroops

Адрес #9ECA, блок `S10`. [Source/Engine/DevelopTroops.asm](../Source/Engine/DevelopTroops.asm#L17).

повышать либо понижать типы отрядов по счётчикам

при бите 7 #6565 выходит, иначе увеличивает счётчики #6A72+ID, для пяти записей армии сравнивает второй счётчик+25 с полем 40 описателя и основной счётчик с полем 41, поля 19/20 задают новый ID, исходная запись обнуляется, количество переносится #A056, показываются разные сообщения о долгих странствиях/битвах либо отсутствии сражений

**Вход:** флаг бит 7#6565, армия #6A1E, счётчики #6A72/#6A8B, описатели типов

**Выход:** если бит 7 сброшен, счётчики возрастают и достигшие порогов отряды заменяют ID с переносом количества, показываются сообщения развития/деградации

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, счётчики, состав армии и экран, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 121 инструкций. Чтение: #6565. Запись: не выделена. Вызовы: #6D34, #7117, #73AD, #73FE, #7AA4, #7BF4, #7EA7, #8036, #82D5, #957C, #A056.

### Engine.AddTroops

Адрес #A056, блок `S10`. [Source/Engine/AddTroops.asm](../Source/Engine/AddTroops.asm#L15).

добавить количество BC к типу отряда A в армии героя

уплотняет пять записей #6A1E через #807E, находит совпадающий ID либо первую пустую запись, для нового ID #7A94 очищает два счётчика, записывает ID и прибавляет 16 битное количество BC

**Вход:** BC добавляемое количество, AF, A ID типа, в армии существует этот ID либо свободная запись

**Выход:** ID найден/создан, его 16 битное количество увеличено на BC, HL у младшего байта количества, DE новое количество, BC, A, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE и F, массив #6A1E и два счётчика нового ID, переполнение количества и отсутствие свободной записи отдельно не проверяются

В сохранённом графе: 32 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7A94, #807E.

### Engine.RegenMana

Адрес #A082, блок `S10`. [Source/Engine/RegenMana.asm](../Source/Engine/RegenMana.asm#L16).

пополнить численные запасы с ограничением максимума

герой #6A04 +=#6A08 с максимумом #6A06, затем 744 активные записи по 22 байта в банке 1 от #C000, поля+3/+4 увеличиваются на+5/+6 с пределом 15000, далее 15 записей по 28 байт от #CCCB банка 3, текущие+22/+23 увеличиваются на+26/+27 с максимумом+24/+25, общий ограничитель #A0FC

**Вход:** поля запасов героя и массивов банков 1/3 инициализированы

**Выход:** герой,744 записи по 22 байта банка 1 и 15 записей правителей по 28 байт банка 3 пополнены с указанными максимумами, банк 3 выбран, IY сохранён

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, перечисленные ресурсные поля, IFF разрешён, альтернативные регистры собственным кодом не используются

В сохранённом графе: 47 инструкций. Чтение: #6A04, #6A06, #6A08. Запись: #6A04. Вызовы: #6D2F, #A0FC.

### Engine.AddClampedU16

Адрес #A0FC, блок `S10`. [Source/Engine/AddClampedU16.asm](../Source/Engine/AddClampedU16.asm#L13).

прибавить BC к HL с верхней границей DE

если сложение переносит 16 бит либо сумма>=DE, HL=DE, иначе HL сумма, при сравнении carry от ADD равен 0

**Вход:** HL текущее значение, DE верхний предел, BC прибавление

**Выход:** HL=min(сумма, DE), при переносе 16 биттакже HL=DE, DE, BC, A, IX, IY сохранены

**Изменяемые регистры и состояние:** HL и F

В сохранённом графе: 9 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Engine.WeekEvent

Адрес #A107, блок `S10`. [Source/Engine/WeekEvent.asm](../Source/Engine/WeekEvent.asm#L18).

обработать наступление новой недели и связанное изменение типа существ

выбирает ID=(BC mod19)+7, тоесть 7..25, показывает сообщение новой недели, поле 38 описателя служит делителем прироста города/замкового гарнизона, поле 39 делителем прироста внешних армий и армии героя, #A205 добавляет floor(исходное количество/делитель) только совпадающему ID, обход включает 30 записей выбранной таблицы найма, гарнизоны текущего континента, внешние армии #6B79 и 5 записей героя, нулевой делитель не проверяется

**Вход:** BC номер недели/число для выбора типа, описатели воинов и составы армий

**Выход:** тип ID=(BCmod19)+7 получает прирост в таблице найма, замках, внешних армиях и армии героя по делителям полей 38/39 описателя

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, количества отрядов, операнды #A203/#A204 и экран, вызываемый текст использует ROM

В сохранённом графе: 84 инструкций. Чтение: #6A2D, #A203. Запись: #A203, #A204. Вызовы: #6D2F, #7117, #73FE, #7A74, #7BF4, #8036, #A205.

### Engine.GrowTroop

Адрес #A205, блок `S10`. [Source/Engine/GrowTroop.asm](../Source/Engine/GrowTroop.asm#L16).

увеличить количество заданного типа в трёхбайтной записи

если ID по IX совпадает #A203, количество HL увеличивается на частное от деления исходного количества на #A204 через повторное вычитание, запись+1/+2 обновляется, IX всегда сдвигается на 3

**Вход:** IX трёхбайтная запись, #A203 требуемый ID, #A204 ненулевой делитель прироста

**Выход:** IX увеличен на 3, при совпадении ID количество+=floor(старое/делитель), DE, BC, IY сохранены, HL результат количества при совпадении иначе исходный

**Изменяемые регистры и состояние:** HL, AF, IX, запись количества при совпадении, делитель 0 ведёт незавершающемуся вычитанию, переполнение прибавления не ограничивается

В сохранённом графе: 25 инструкций. Чтение: #A203, #A204. Запись: не выделена. Вызовы: не выделены.

### Engine.RefreshTowns

Адрес #A235, блок `S10`. [Source/Engine/RefreshTowns.asm](../Source/Engine/RefreshTowns.asm#L17).

обновить армии объектов группы #6AF9

активные города текущего континента из #6AF9, независимый RandomScaled(1) определяет обновление, очищаются 9 байт гарнизона по смещению 17, RandomScaled(3) выбирает 0..3 отряда, ID выбирается по порогам #A2DA с отбрасыванием уже выбранных ID, количество=10+RandomScaled(40), старший байт количества 0, шаг города 26, выбор 0 оставляет гарнизон пустым

**Вход:** #6A2D континент, группа городов #6AF9

**Выход:** банк 0 выбран, часть активных городов случайно получает 0..3 уникальных типа отрядов с количеством 10..50, IY сохранён

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, гарнизоны городов и состояние генератора, IFF разрешён, альтернативные регистры собственным кодом не используются

В сохранённом графе: 84 инструкций. Чтение: #6A2D. Запись: #A29A, #A29F. Вызовы: #6D2F, #7A74, #7C0D.

### Engine.CheckRevolt

Адрес #A2E0, блок `S10`. [Source/Engine/CheckRevolt.asm](../Source/Engine/CheckRevolt.asm#L30).

проверить превышение контроля и обработать доплату либо бой с отделившимся отрядом

пять плотных записей от 6A1E, ID0 завершает процедуру, CAP=floor(word[6A02]/byte[6AD3+ID]), конфликт требует Q>CAP и RandomScaled(3)=3, то есть нового слова генератора >=54614, доплата D=Q*word(описатель 8036+22), при M<D сразу бой, при M>=D ответ меню 1 вычитает D и сохраняет отряд, другой ответ вызывает RandomScaled(2), результат 0 сохраняет деньги и отряд, результаты 1/2 ведут к бою, перед боем запись копируется в A475, исходная обнуляется, армия уплотняется, D255 вызывается с DE=0, IX=A475, BC=0500, тип поля 6 при (6A33 AND3)=1 либо по 80C4/8697, A=0 показывает успех, A!=0 вызывает 89E0 для насыщенного вычитания floor(2*float[656C]/float[6567]) из 6A02, мирного удаления отряда без боя нет, оплата не меняет предел контроля, ветки оплаты, тихого отказа и победы вызывают 957C без сохранения IY и потому не гарантируют правильного продолжения обхода

**Вход:** армия 6A1E из пяти плотных записей ID/количество 16, поле 6A02, коэффициенты 6AD3, наличные float5 по 6A14, генератор 7C6B..7C70, текущая клетка 6A2E и младшие два бита 6A33 для выбора поля боя

**Выход:** деньги уменьшены только при оплате или по собственному исходу боя, отряд сохраняется при оплате и тихом отказе, перед боем отделяется от армии героя, непобеда дополнительно уменьшает 6A02, обновляются панели и вид карты

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, армия 6A1E, временный список A475..A483, float5A564, состояние генератора, интерфейсные поля и эффекты вызванного боя

**Дополнительно:** подтверждённая особенность исходника, CALL957C по A43B не сохраняет IY и заменяет его указателем после обхода армии, поэтому дальнейший INC IY×3 может пропустить записи или выйти за пределы армии, код не изменялся

В сохранённом графе: 158 инструкций. Чтение: #6A2E, #6A33. Запись: не выделена. Вызовы: #6D34, #6D3F, #6D57, #6D62, #6DAE, #6DC4, #6DDA, #7117, #7366, #73AD, #73FE, #776D, #7BF4, #7C0D, #8036, #807E, #80C4, #82D5, #8697, #86EA, #89E0, #944A, #957C, #D255.

### Engine.TickCastle

Адрес #A5AE, блок `S10`. [Source/Engine/TickCastle.asm](../Source/Engine/TickCastle.asm#L42).

обновить угрозу замку, автоматически разрешить штурм либо подготовить перенос героя

каждый вход сохраняет A в #A700 и ставит #69D8=1. U=#6AAA равен 0, новая угроза требует сброшенного бита 7 #6565 и R(200)<число своих активных замков, выбирает случайный порядковый номер своего замка, затем ближайший другой замок определяет владельца атакующей стороны, владелец 0 отменяет создание, #FF трактуется отдельными сообщениями о бандах. T=#6AAB=20+R(15), W=#A720=0. Состав 2..4 типов берётся из ближайших групп 4..7 на континенте замка, количества из NAEMARMY по сложности и текущему континенту героя. При U!=0 T=(T-A)AND255, для T>=5 R(400)=0 отменяет угрозу, для 1..4 однократно показывается предупреждение. На T=0 перенос допустим при бите 0 #6A0D, сброшенном бите 7 #6565, томже континенте и магии не меньше 100*floor(расстояние), пункт 2 меню отменяет перенос. При согласии списывается цена, сохраняются прежние режим/координаты/армия, герой ставится внутрь замка, армия временно очищается, U и T=0 сохраняются для O21. Иначе автоматический штурм, пустой гарнизон либо сила атаки>2*силы гарнизона дают захват, остальное успешную защиту. Сила атаки включает текущую магию правителя при U!=#FF. Успешная защита уменьшает количества на один случайный процент по сложности, захват уменьшает #6A02 на 40 с насыщением 0, меняет владельца и копирует 15 байт армии атаки в гарнизон. Обе автоматические ветви очищают U. Сам обработчик #D255 не вызывает

**Вход:** AF, A=0 при шаге без нового дня, A=1 при наступлении дня. #6AAA угроза, #6AAB дни, #6AAC адрес замка, #69EE индекс сложности, #6A2D текущий континент, записи и банки игры инициализированы

**Выход:** без угрозы возможны создание новой угрозы на 20..35 дней и состава 2..4 отрядов. При ожидании уменьшается счётчик, возможно предупреждение либо отмена. На сроке 0 выполняется автоматическая защита/захват либо сохраняются исходные режим, координаты и армия для переноса к замку

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY и альтернативные регистры ROM не сохраняются. Меняются банки, IFF, фоновые флаги, поля угрозы, операнды #A700/#A720 и другие рабочие поля. Точный набор изменений зависит от ветви

**Дополнительно:** Вызов с A=0 также выполняет вероятностные проверки создания/отмены. Дни вычитаются в 8 битах без насыщения. В существующей угрозе владелец и активность P повторно не проверяются. При автоматической защите равенство двух сил остаётся победой гарнизона. Указатель количества использует текущий континент героя, не континент замка. Деление на нулевую силу гарнизона отдельно не защищено. Фактический бой начинается в O21 #B61A..#B63B, когда совпадает замок и T<5, это отдельный путь. Значения неизвестных битов названы по адресам без предположений о полном игровом смысле. Полная таблица условий и эффектов сохранена в Docs/CastleEventBranches.md

В сохранённом графе: 412 инструкций. Чтение: #6565, #69D9, #69EE, #6A02, #6A04, #6A0D, #6A2D, #6A2E, #6A33, #6AAA, #6AAB, #6AAC. Запись: #69D5, #69D8, #69D9, #69DB, #69DC, #6A02, #6A04, #6A2E, #6A33, #6AAA, #6AAB, #6AAC, #A6A6, #A6C1, #A6EC, #A700, #A720, #A8F5, #AA19, #AAA8, #AABC, #AB88, #ABC1. Вызовы: #6D2F, #6D34, #6D62, #6D76, #6D88, #6DAE, #6DC4, #6DDA, #7117, #73FE, #776D, #7A17, #7A4E, #7BF4, #7C0D, #7F5F, #7FF0, #804E, #82D5, #87A1, #957C.

### Engine.RepopulateSites

Адрес #AC78, блок `S10`. [Source/Engine/RepopulateSites.asm](../Source/Engine/RepopulateSites.asm#L17).

восстановить население опустевших объектов по ближайшему населённому объекту

одинразна 4 вызова, группы #6B19/#6B29/#6B39/#6B49, активные записи 6 байт с количеством+4/+5 равным 0, #7A4E определяет континент по адресу записи, #7F5F ищет ближайшую другую запись тойже группы, если у неё количество ненулевое, копируется ID типа+3, количество инициализируется полем 32/33 описателя типа, случайного генератора здесь нет

**Вход:** банк 0 уже выбран, #6A2D континент, группы #6B19/#6B29/#6B39/#6B49, счётчик #AD30

**Выход:** счётчик уменьшен, каждый 4 вызов активные пустые записи получают ID ближайшего населённого объекта и количество из поля 32/33SOLDIERS, при реальном заполнении восстановлен банк 0

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, #AD30 и содержимое объектов, альтернативные регистры собственным кодом не используются

В сохранённом графе: 76 инструкций. Чтение: #6A2D, #AD1D, #AD30. Запись: #ACCA, #AD1D, #AD30. Вызовы: #6D2F, #7A4E, #7A74, #7F5F, #8036.

### Engine.MoveSitesC

Адрес #AD31, блок `S10`. [Source/Engine/MoveSitesC.asm](../Source/Engine/MoveSitesC.asm#L17).

случайно переместить записи группы #6B39 в соседнюю свободную клетку

активные 6 байтные записи текущего континента, сначала проверяет наличие свободной клетки типа 0 в окрестности 3 на 3, если таких нет, запись остаётся, иначе выбирает Xold-1+RandomScaled(2) и Yold-1+RandomScaled(2) до свободной клетки типа 0, меняет координаты существующей записи, ставит бит 7 новой клетки карты и снимает бит 7 старой, новые записи не создаются

**Вход:** банк 0 уже выбран, #6A2D континент, шестибайтные записи группы #6B39

**Выход:** активные записи при наличии свободной соседней клетки типа 0 перемещены, бит 7 старой/новой клетки обновлён, успешная ветвь возвращает банк 0

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, координаты объектов, карта, генератор, IY сохранён, альтернативные регистры не используются

В сохранённом графе: 66 инструкций. Чтение: #6A2D, #ADBD. Запись: #ADBD. Вызовы: #6D2F, #7A74, #7C0D, #80AE, #80B4, #80C4.

### Engine.SumCastleIncome

Адрес #ADBF, блок `S10`. [Source/Engine/SumCastleIncome.asm](../Source/Engine/SumCastleIncome.asm#L15).

сложить доход принадлежащих герою замков на четырёх континентах

начальное 0 на стеке калькулятора, группа #6AE9, активные записи с владельцем+19 равным 0 считаются своими, #AE1A возвращает доход BC каждой, токен 0F суммирует, возвращается число калькулятора

**Вход:** группы замков #6AE9 на четырёх континентах, данные городов банка 0

**Выход:** на стек калькулятора добавлена сумма доходов активных замков с владельцем 0, банк 0 выбран

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, рабочий номер континента #AE19, альтернативные HL', DE', BC', AF' могут изменяться вызываемым калькулятором ROM и здесь не сохраняются

В сохранённом графе: 38 инструкций. Чтение: #AE19. Запись: #AE19. Вызовы: #6D2F, #6D62, #6D88, #7A74, #AE1A.

### Engine.CastleIncome

Адрес #AE1A, блок `S10`. [Source/Engine/CastleIncome.asm](../Source/Engine/CastleIncome.asm#L15).

рассчитать доход замка с учётом ближайших городов

IY запись замка, A континент, группа городов #6AF9, базовый доход 100, города учитываются при абсолютной разнице координат<=17 пообеимосям, отдельная проверка бита 1 поля+1 и поля 17 может исключить город, добавляется 350 либо 450 взависимости от полей 15/16, результат BC

**Вход:** AF, A континент 1..4, IY запись замка, банк 0 с городами уже выбран

**Выход:** BC доход 100 плюс 350/450 за подходящие ближайшие города, IY сохранён

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, накопитель #AE81, альтернативные регистры собственным кодом не используются

В сохранённом графе: 51 инструкций. Чтение: #AE81. Запись: #AE46, #AE56, #AE81. Вызовы: #7A74.

## Graphics.Scenes1

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #C000 | `Graphics.Scenes1.Draw` | вход в самоперемещаемый распаковщик банка изображений | [Source/Files/33_BL1.asm](../Source/Files/33_BL1.asm#L19) |
| #C006 | `Graphics.Scenes1.Unpack` | выбор изображения, RLE-распаковка пикселей и атрибутов | [Source/Files/33_BL1.asm](../Source/Files/33_BL1.asm#L44) |

### Graphics.Scenes1.Draw

Адрес #C000, блок `S33`. [Source/Files/33_BL1.asm](../Source/Files/33_BL1.asm#L19).

вход в самоперемещаемый распаковщик банка изображений

JR пропускает четыре байта настроек по смещениям 2..5. Вызывающий код записывает номер картинки в смещение 2. Дальше исполняется общий алгоритм по адресу начала+6.

**Вход:** Draw.Picture — номер изображения от 1

**Выход:** переход к началу+6

**Изменяемые регистры и состояние:** HL, DE, BC, AF, BC', IY. HL', DE', AF', IX сохранены, SP возвращается к входной позиции до RET

В сохранённом графе: 1 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #C006.

### Graphics.Scenes1.Unpack

Адрес #C006, блок `S33`. [Source/Files/33_BL1.asm](../Source/Files/33_BL1.asm#L44).

выбор изображения, RLE-распаковка пикселей и атрибутов

CALL #007C использует RET в ПЗУ, оставшийся в стеке адрес позволяет вычислить собственную базу и IY=начало+2. По цепочке относительных длин начиная с IY+#012A выбирается изображение. Поток содержит начальную треть экрана, число третей и флаги. Координаты ограничиваются диапазоном экрана. Бит 0 задаёт порядок обхода строк и столбцов, бит 2 означает продолжающуюся RLE-серию, бит 3 переключает вывод на линейные атрибуты. Ненулевой байт является литералом, нулевой открывает пару длина/значение. Счётчик серии и повторяемый байт хранятся в альтернативных B'/C', серия может пересекать границы внутренних циклов. Пиксели пишутся с нелинейным шагом Spectrum, затем записываются атрибуты. После вывода два поля выбора области сбрасываются в #FF.

**Вход:** настройки по IY, таблица относительных длин и упакованный поток

**Выход:** полный экран для заголовка [0,3, flags], BC=0, A=0, Z=1, CF=0, DE=#5B00, HL после последнего прочитанного байта потока, IY=начало+2, поля области +3/+4 сброшены в #FF

**Изменяемые регистры и состояние:** HL, DE, BC, AF, BC', IY. HL', DE', AF', IX сохранены, SP возвращается к входной позиции до RET

В сохранённом графе: 152 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #007C.

## Graphics.Scenes2

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #C000 | `Graphics.Scenes2.Draw` | вход в самоперемещаемый распаковщик банка изображений | [Source/Files/34_BL2.asm](../Source/Files/34_BL2.asm#L19) |
| #C006 | `Graphics.Scenes2.Unpack` | выбор изображения, RLE-распаковка пикселей и атрибутов | [Source/Files/34_BL2.asm](../Source/Files/34_BL2.asm#L44) |

### Graphics.Scenes2.Draw

Адрес #C000, блок `S34`. [Source/Files/34_BL2.asm](../Source/Files/34_BL2.asm#L19).

вход в самоперемещаемый распаковщик банка изображений

JR пропускает четыре байта настроек по смещениям 2..5. Вызывающий код записывает номер картинки в смещение 2. Дальше исполняется общий алгоритм по адресу начала+6.

**Вход:** Draw.Picture — номер изображения от 1

**Выход:** переход к началу+6

**Изменяемые регистры и состояние:** HL, DE, BC, AF, BC', IY. HL', DE', AF', IX сохранены, SP возвращается к входной позиции до RET

В сохранённом графе: 1 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #C006.

### Graphics.Scenes2.Unpack

Адрес #C006, блок `S34`. [Source/Files/34_BL2.asm](../Source/Files/34_BL2.asm#L44).

выбор изображения, RLE-распаковка пикселей и атрибутов

CALL #007C использует RET в ПЗУ, оставшийся в стеке адрес позволяет вычислить собственную базу и IY=начало+2. По цепочке относительных длин начиная с IY+#012A выбирается изображение. Поток содержит начальную треть экрана, число третей и флаги. Координаты ограничиваются диапазоном экрана. Бит 0 задаёт порядок обхода строк и столбцов, бит 2 означает продолжающуюся RLE-серию, бит 3 переключает вывод на линейные атрибуты. Ненулевой байт является литералом, нулевой открывает пару длина/значение. Счётчик серии и повторяемый байт хранятся в альтернативных B'/C', серия может пересекать границы внутренних циклов. Пиксели пишутся с нелинейным шагом Spectrum, затем записываются атрибуты. После вывода два поля выбора области сбрасываются в #FF.

**Вход:** настройки по IY, таблица относительных длин и упакованный поток

**Выход:** полный экран для заголовка [0,3, flags], BC=0, A=0, Z=1, CF=0, DE=#5B00, HL после последнего прочитанного байта потока, IY=начало+2, поля области +3/+4 сброшены в #FF

**Изменяемые регистры и состояние:** HL, DE, BC, AF, BC', IY. HL', DE', AF', IX сохранены, SP возвращается к входной позиции до RET

В сохранённом графе: 152 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #007C.

## Battle

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #D255 | `Battle.Battle` | выполнить бой на поле 8 на 5 клеток | [Source/Battle/Battle.asm](../Source/Battle/Battle.asm#L20) |
| #D2B5 | `Battle.SelectActor` | выбрать следующий отряд героя либо передать ход противнику | [Source/Battle/SelectActor.asm](../Source/Battle/SelectActor.asm#L25) |
| #D41A | `Battle.InputLoop` | ожидать и выполнять команды выбранного отряда героя | [Source/Battle/InputLoop.asm](../Source/Battle/InputLoop.asm#L26) |
| #DB60 | `Battle.ShowSpell` | показать название и параметры выбранного заклинания | [Source/Battle/ShowSpell.asm](../Source/Battle/ShowSpell.asm#L14) |
| #DB75 | `Battle.SpendHeroMagic` | списать магическую силу героя с насыщением нулём | [Source/Battle/SpendHeroMagic.asm](../Source/Battle/SpendHeroMagic.asm#L13) |
| #DB8E | `Battle.PickOccupied` | выбрать клетку, занятую любым отрядом | [Source/Battle/PickOccupied.asm](../Source/Battle/PickOccupied.asm#L13) |
| #E013 | `Battle.CellUp` | уменьшить строку клетки без выхода за верхний край | [Source/Battle/CellUp.asm](../Source/Battle/CellUp.asm#L12) |
| #E018 | `Battle.CellDown` | увеличить строку клетки без выхода за нижний край | [Source/Battle/CellDown.asm](../Source/Battle/CellDown.asm#L12) |
| #E01E | `Battle.CellLeft` | уменьшить столбец клетки без выхода за левый край | [Source/Battle/CellLeft.asm](../Source/Battle/CellLeft.asm#L12) |
| #E023 | `Battle.CellRight` | увеличить столбец клетки без выхода за правый край | [Source/Battle/CellRight.asm](../Source/Battle/CellRight.asm#L12) |
| #E029 | `Battle.SelectCell` | перемещать курсор по боевому полю до подтверждения либо отмены | [Source/Battle/SelectCell.asm](../Source/Battle/SelectCell.asm#L14) |
| #E091 | `Battle.ReadCursorInput` | прочитать ввод при анимированном курсоре клетки | [Source/Battle/ReadCursorInput.asm](../Source/Battle/ReadCursorInput.asm#L16) |
| #E0BF | `Battle.AITurn` | выполнить ход противника и сбросить отметки раунда | [Source/Battle/AITurn.asm](../Source/Battle/AITurn.asm#L15) |
| #E0E8 | `Battle.AIArmyPass` | выполнить проход ИИ по ещё не завершившим ход отрядам | [Source/Battle/AIArmyPass.asm](../Source/Battle/AIArmyPass.asm#L15) |
| #E117 | `Battle.AIUnitTurn` | выбрать движение или атаку одного отряда компьютера | [Source/Battle/AIUnitTurn.asm](../Source/Battle/AIUnitTurn.asm#L18) |
| #E569 | `Battle.MarkAdjacent` | пометить отряды героя, стоящие не далее одной клетки от заданной | [Source/Battle/MarkAdjacent.asm](../Source/Battle/MarkAdjacent.asm#L14) |
| #E5B0 | `Battle.BuildNeighbours` | построить восемь соседних клеток в порядке приближения к цели | [Source/Battle/BuildNeighbours.asm](../Source/Battle/BuildNeighbours.asm#L15) |
| #E5E1 | `Battle.ClassifyCells` | проверить границы, препятствия и занятость восьми соседних клеток | [Source/Battle/ClassifyCells.asm](../Source/Battle/ClassifyCells.asm#L15) |
| #E67D | `Battle.NeighboursN` | задать координаты восьми кандидатов для выбранного направления поиска | [Source/Battle/NeighboursN.asm](../Source/Battle/NeighboursN.asm#L16) |
| #E6A2 | `Battle.NeighboursNE` | задать координаты восьми кандидатов для выбранного направления поиска | [Source/Battle/NeighboursNE.asm](../Source/Battle/NeighboursNE.asm#L16) |
| #E6C7 | `Battle.NeighboursE` | задать координаты восьми кандидатов для выбранного направления поиска | [Source/Battle/NeighboursE.asm](../Source/Battle/NeighboursE.asm#L17) |
| #E6EC | `Battle.NeighboursSE` | задать координаты восьми кандидатов для выбранного направления поиска | [Source/Battle/NeighboursSE.asm](../Source/Battle/NeighboursSE.asm#L16) |
| #E711 | `Battle.NeighboursS` | задать координаты восьми кандидатов для выбранного направления поиска | [Source/Battle/NeighboursS.asm](../Source/Battle/NeighboursS.asm#L16) |
| #E736 | `Battle.NeighboursSW` | задать координаты восьми кандидатов для выбранного направления поиска | [Source/Battle/NeighboursSW.asm](../Source/Battle/NeighboursSW.asm#L16) |
| #E75B | `Battle.NeighboursW` | задать координаты восьми кандидатов для выбранного направления поиска | [Source/Battle/NeighboursW.asm](../Source/Battle/NeighboursW.asm#L16) |
| #E780 | `Battle.NeighboursNW` | задать координаты восьми кандидатов для выбранного направления поиска | [Source/Battle/NeighboursNW.asm](../Source/Battle/NeighboursNW.asm#L16) |
| #E7A5 | `Battle.MarkInRange` | отметить цели героя в пределах подвижности отряда компьютера | [Source/Battle/MarkInRange.asm](../Source/Battle/MarkInRange.asm#L13) |
| #E7E0 | `Battle.ChooseTarget` | выбрать отряд по таблице приоритетов и минимальной весовой оценке | [Source/Battle/ChooseTarget.asm](../Source/Battle/ChooseTarget.asm#L17) |
| #E8AD | `Battle.StackStrength` | вычислить весовую оценку боевого отряда | [Source/Battle/StackStrength.asm](../Source/Battle/StackStrength.asm#L14) |
| #E8E3 | `Battle.AnimatePath` | провести мигающую анимацию от исходной клетки к целевой | [Source/Battle/AnimatePath.asm](../Source/Battle/AnimatePath.asm#L16) |
| #E94A | `Battle.RunUncontrolled` | выполнить случайный ход или атаку вышедшего из подчинения отряда | [Source/Battle/RunUncontrolled.asm](../Source/Battle/RunUncontrolled.asm#L16) |
| #EB08 | `Battle.RandomTarget` | случайно выбрать запись из списка целей | [Source/Battle/RandomTarget.asm](../Source/Battle/RandomTarget.asm#L12) |
| #EB2D | `Battle.ListOtherUnits` | составить список всех отрядов кроме действующего | [Source/Battle/ListOtherUnits.asm](../Source/Battle/ListOtherUnits.asm#L13) |
| #EBA9 | `Battle.AISpell` | выбрать и применить доступное заклинание противника | [Source/Battle/AISpell.asm](../Source/Battle/AISpell.asm#L18) |
| #F028 | `Battle.SpendAIMagic` | списать цену и показать применяемое противником заклинание | [Source/Battle/SpendAIMagic.asm](../Source/Battle/SpendAIMagic.asm#L14) |
| #F0A0 | `Battle.ResolveAttack` | рассчитать атаку и возможный ответный удар | [Source/Battle/ResolveAttack.asm](../Source/Battle/ResolveAttack.asm#L18) |
| #F2A1 | `Battle.RecordFighters` | отметить участие отрядов героя в столкновении | [Source/Battle/RecordFighters.asm](../Source/Battle/RecordFighters.asm#L13) |
| #F2BE | `Battle.MarkUnitFight` | отметить участие типа отряда в бою и сбросить накопленные дни бездействия | [Source/Battle/MarkUnitFight.asm](../Source/Battle/MarkUnitFight.asm#L14) |
| #F2CE | `Battle.WaitAttack` | выдержать десять кадров между фазами атаки | [Source/Battle/WaitAttack.asm](../Source/Battle/WaitAttack.asm#L13) |
| #F2D6 | `Battle.EffectFactor` | получить коэффициент воздействия временного эффекта | [Source/Battle/EffectFactor.asm](../Source/Battle/EffectFactor.asm#L15) |
| #F2F1 | `Battle.ApplyDrainTrait` | увеличить количество атакующего за счёт нанесённого воздействия | [Source/Battle/ApplyDrainTrait.asm](../Source/Battle/ApplyDrainTrait.asm#L15) |
| #F337 | `Battle.ClampRegen` | ограничить количество специального отряда исходной численностью | [Source/Battle/ClampRegen.asm](../Source/Battle/ClampRegen.asm#L14) |
| #F364 | `Battle.RangedMatchup` | получить коэффициент дальнего воздействия для пары типов | [Source/Battle/RangedMatchup.asm](../Source/Battle/RangedMatchup.asm#L14) |
| #F38B | `Battle.CalcDamage` | рассчитать пятибайтный урон по подготовленным коэффициентам | [Source/Battle/CalcDamage.asm](../Source/Battle/CalcDamage.asm#L19) |
| #F3F5 | `Battle.MeleeMatchup` | получить слово коэффициента совместимости двух типов в рукопашном бою | [Source/Battle/MeleeMatchup.asm](../Source/Battle/MeleeMatchup.asm#L12) |
| #F44F | `Battle.HasMagicShield` | проверить магический щит стороны выбранной цели | [Source/Battle/HasMagicShield.asm](../Source/Battle/HasMagicShield.asm#L14) |
| #F4A3 | `Battle.ArmyValue` | сложить стоимостные оценки отрядов армии | [Source/Battle/ArmyValue.asm](../Source/Battle/ArmyValue.asm#L13) |
| #F4D4 | `Battle.RefreshObjects` | сбросить флаги сорока объектов поля и заново отобразить армии | [Source/Battle/RefreshObjects.asm](../Source/Battle/RefreshObjects.asm#L15) |
| #F4F4 | `Battle.DrawBothArmies` | обновить экранные объекты обеих армий | [Source/Battle/DrawBothArmies.asm](../Source/Battle/DrawBothArmies.asm#L12) |
| #F515 | `Battle.DrawArmy` | обновить экранные объекты одной армии | [Source/Battle/DrawArmy.asm](../Source/Battle/DrawArmy.asm#L13) |
| #F529 | `Battle.MarkUnruled` | обновить признак превышения контроля у отрядов героя | [Source/Battle/MarkUnruled.asm](../Source/Battle/MarkUnruled.asm#L14) |
| #F556 | `Battle.ResetTurnFlags` | очистить временные флаги одной армии | [Source/Battle/ResetTurnFlags.asm](../Source/Battle/ResetTurnFlags.asm#L13) |
| #F578 | `Battle.RestoreMovement` | восстановить очки движения армии на новый раунд | [Source/Battle/RestoreMovement.asm](../Source/Battle/RestoreMovement.asm#L13) |
| #F598 | `Battle.ApplySpell` | изменить количество цели по силе заклинания | [Source/Battle/ApplySpell.asm](../Source/Battle/ApplySpell.asm#L16) |
| #F5C4 | `Battle.SpellCoeffs` | получить два байта коэффициентов заклинания для типа существа | [Source/Battle/SpellCoeffs.asm](../Source/Battle/SpellCoeffs.asm#L13) |
| #F5E8 | `Battle.WaitMoveFrames` | выдержать сорок кадров анимации перемещения | [Source/Battle/WaitMoveFrames.asm](../Source/Battle/WaitMoveFrames.asm#L13) |
| #F5F0 | `Battle.TickEffects` | уменьшить длительность временных эффектов одной армии | [Source/Battle/TickEffects.asm](../Source/Battle/TickEffects.asm#L13) |
| #F618 | `Battle.DrawHeader` | оформить рамку заголовка боя цветом A | [Source/Battle/DrawHeader.asm](../Source/Battle/DrawHeader.asm#L12) |
| #F626 | `Battle.GetCellObject` | получить экранный объект боевой клетки | [Source/Battle/GetCellObject.asm](../Source/Battle/GetCellObject.asm#L13) |
| #F62D | `Battle.TestControl` | сравнить численность отряда с пределом управления | [Source/Battle/TestControl.asm](../Source/Battle/TestControl.asm#L14) |
| #F648 | `Battle.DirtyCell` | пометить экранный объект клетки как пустой для перерисовки | [Source/Battle/DirtyCell.asm](../Source/Battle/DirtyCell.asm#L13) |
| #F65E | `Battle.FindUnitAtCell` | найти отряд с заданными координатами в одной армии | [Source/Battle/FindUnitAtCell.asm](../Source/Battle/FindUnitAtCell.asm#L13) |
| #F67C | `Battle.TestObstacle` | проверить препятствие выбранной клетки | [Source/Battle/TestObstacle.asm](../Source/Battle/TestObstacle.asm#L13) |
| #F698 | `Battle.DrawAttack` | вывести маскированное изображение атаки в клетке | [Source/Battle/DrawAttack.asm](../Source/Battle/DrawAttack.asm#L13) |
| #F6B8 | `Battle.ResolveLosses` | удалить погибших, обработать бунт и проверить исход боя | [Source/Battle/ResolveLosses.asm](../Source/Battle/ResolveLosses.asm#L19) |
| #F84D | `Battle.TestDeadStack` | проверить неположительное пятибайтное количество отряда | [Source/Battle/TestDeadStack.asm](../Source/Battle/TestDeadStack.asm#L13) |
| #F864 | `Battle.CompactArmy` | уплотнить пять записей армии и очистить освободившийся хвост | [Source/Battle/CompactArmy.asm](../Source/Battle/CompactArmy.asm#L13) |
| #F893 | `Battle.DefeatStory` | обработать сюжетные последствия поражения | [Source/Battle/DefeatStory.asm](../Source/Battle/DefeatStory.asm#L14) |
| #F8BB | `Battle.MakeStaticUnit` | сформировать неподвижный объект отряда и его отображаемое количество | [Source/Battle/MakeStaticUnit.asm](../Source/Battle/MakeStaticUnit.asm#L17) |
| #F912 | `Battle.MakeActingUnit` | сформировать четырёхкадровый объект действующего отряда | [Source/Battle/MakeActingUnit.asm](../Source/Battle/MakeActingUnit.asm#L15) |
| #F984 | `Battle.TickCursorAnim` | обновить кадр анимированного курсора выбранной клетки | [Source/Battle/TickCursorAnim.asm](../Source/Battle/TickCursorAnim.asm#L15) |
| #F9E4 | `Battle.RestoreCursor` | восстановить фон под курсором клетки | [Source/Battle/RestoreCursor.asm](../Source/Battle/RestoreCursor.asm#L13) |
| #FA08 | `Battle.SaveCursorBack` | сохранить фон под курсором клетки | [Source/Battle/SaveCursorBack.asm](../Source/Battle/SaveCursorBack.asm#L13) |
| #FAAF | `Battle.InitBattle` | инициализировать армии, препятствия, фон и начальные объекты боя | [Source/Battle/InitBattle.asm](../Source/Battle/InitBattle.asm#L19) |
| #FB87 | `Battle.BuildField` | сформировать маску препятствий и фоновые объекты поля боя | [Source/Battle/BuildField.asm](../Source/Battle/BuildField.asm#L20) |
| #FC7D | `Battle.MakeFieldTiles` | создать сорок объектов поля по готовой карте тайлов | [Source/Battle/MakeFieldTiles.asm](../Source/Battle/MakeFieldTiles.asm#L15) |
| #FCB0 | `Battle.FinishField` | добавить обе армии к объектам поля и разрешить их обработку | [Source/Battle/FinishField.asm](../Source/Battle/FinishField.asm#L14) |

### Battle.Battle

Адрес #D255, блок `S47`. [Source/Battle/Battle.asm](../Source/Battle/Battle.asm#L20).

выполнить бой на поле 8 на 5 клеток

сохраняет SP в E0BD и вызывает FAAF, на каждом раунде восстанавливает движения из +7 в +12, уменьшает длительность эффектов +13, выбирает ещё не ходивший отряд по биту 3 поля +9, бунтующий отряд с битом 7 может перейти к противнику или объединиться с таким же типом, восемь направлений разрешают движение в свободную клетку либо рукопашную атаку, S запускает стрельбу, F полёт, U меню заклинаний, G откуп, W откладывает ход, Space обнуляет остаток действий, E0BF выполняет ход компьютера, F6B8 может выйти из боя непосредственно через сохранённый SP, ветка откупа DA9E записывает армии обратно и возвращает FF

**Вход:** DE сила противника, BC число исходных отрядов и банк, A тип боя, IX исходная армия противника

**Выход:** DE остаток FCB9, A=0 победа, A=FF поражение или откуп, армии записаны через 88FA

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, SP на путях завершения боя, обе армии, боевые переменные, объекты и экран, состояние калькулятора и генератора случайных чисел

В сохранённом графе: 34 инструкций. Чтение: #6A04, #CF3C, #FCB9, #FCE7. Запись: #6A04, #E0BD, #FCB9, #FCE7. Вызовы: #D2B5, #F556, #F578, #F5F0, #FAAF.

### Battle.SelectActor

Адрес #D2B5, блок `S47`. [Source/Battle/SelectActor.asm](../Source/Battle/SelectActor.asm#L25).

выбрать следующий отряд героя либо передать ход противнику

пять записей с FCED обходятся с шагом 18, выбирается первая с ненулевым запасом действий +12 и сброшенным битом 3 Flags, при новом проходе оригинал сбрасывает бит в пяти разных полях, см. ниже повторяется только по +12, при полном исчерпании действий E0BF выполняет ход противника и переход D25C начинает следующий раунд, выбранной записи ставится бит 3, F529 обновляет контроль, 8036 получает имя типа и сохраняет IX в DD56, для бита 7 поля +9 выполняется проверка перехода на сторону противника, свободная либо однотипная запись ищется в FD47, нулевой результат #7C0D при DE=5 разрешает перенос или объединение, ненулевой результат оставляет отряд в первой армии, обычный управляемый отряд через D3A9 передаётся циклу D41A

**Вход:** инициализированные армии FCED и FD47 по пять записей длиной 18, в записях +12 остаток действий, +9 биты 3 и 7, сохранённый SP входа в бой по E0BD, разрешённые прерывания для дальнейшего HALT

**Выход:** обычного RET нет, IY выбранный отряд при переходе в D41A, DD56 указатель имени типа, при исчерпании действий управление через E0BF и D25C возвращается к выбору, при уходе последнего отряда возможен выход всего боя через DA9E

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, записи обеих армий, DD56, DD60 и поля текстовых шаблонов, экран, состояние генератора и калькулятора, SP при выходе из всего боя восстанавливается из E0BD, сохранение входных основных регистров не предусмотрено

В сохранённом графе: 208 инструкций. Чтение: #6A04, #6A33, #CF3C, #DD56, #FCB9, #FCBB, #FCBD, #FCBE, #FCE7, #FCED. Запись: #6A04, #6A33, #DD56, #DD60, #DDE1, #DDFC, #DE21, #DE3D, #DF4D, #FCB9, #FCE7. Вызовы: #6D3F, #6DAE, #6DC4, #7117, #7BF4, #7C0D, #8036, #88FA, #D41A, #E0BF, #E94A, #F4D4, #F4F4, #F529, #F556, #F578, #F5F0, #F618, #F864.

### Battle.InputLoop

Адрес #D41A, блок `S47`. [Source/Battle/InputLoop.asm](../Source/Battle/InputLoop.asm#L26).

ожидать и выполнять команды выбранного отряда героя

F912 выбирает оформление по коду 24, HALT синхронизирует ожидание, 6BF1 опрашивается до CF=1, затем BC берётся из +10 и +11 отряда, восемь кодов 13,1B,23,12,22,11,19,21 задают соседнюю клетку через E013, E018, E01E, E023, F67C отбрасывает недопустимую клетку, F65E ищет занятость, свободная клетка очищается F648 и записывается в +10,+11 с уменьшением +12, занятый вражеский либо бунтующий дружественный отряд вызывает рукопашную F0A0 с A=1, код 1D откладывает ход, 20 обнуляет +12, 1E запускает ветвь стрельбы, 0A ветвь заклинаний, остальные распознаваемые команды переходят в обработчики D9D3 и далее, после действия управление возвращается к D2B5 или D2F8, F6B8 может завершить весь бой

**Вход:** IY запись выбранного отряда героя длиной 18, её +10,+11 текущая клетка, +12 остаток действий, DD56 имя типа, армии FCED и FD47 и рабочее поле боя инициализированы, SP входа в бой сохранён в E0BD, прерывания разрешены для HALT

**Выход:** обычного RET нет, недопустимый ввод повторяет D420, выполненное действие переходит в D2B5 либо D2F8, перемещение обновляет +10,+11 и уменьшает +12, пропуск обнуляет +12, завершение боя возвращает результат внешнему вызову D255 через восстановленный SP

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, координаты, действия и прочие боевые поля обеих армий, экран, текстовые и боевые рабочие переменные, состояние генератора и калькулятора, SP на завершающем пути восстанавливается из E0BD, сохранение входных основных регистров не предусмотрено

В сохранённом графе: 839 инструкций. Чтение: #6A04, #6A33, #6A3B, #CEC9, #CEE0, #CEF7, #CF0E, #CF25, #CF3C, #CF53, #D6DF, #D9BB, #DD56, #FCB9, #FCBB, #FCBD, #FCBE, #FCE7, #FCED. Запись: #6A33, #D687, #D6DE, #D6DF, #D867, #D91D, #D9BB, #DA72, #DD0A, #DD22, #DD56, #DD60, #DDE1, #DDFC, #DE21, #DE3D, #DF4D, #DF7F, #DF83, #DF89, #DFC7, #FCE7. Вызовы: #6BF1, #6D34, #6D3F, #6D57, #6D88, #6DAE, #6DC4, #6DDA, #7117, #73CF, #73FE, #776D, #7AEF, #7BF4, #7C0D, #8036, #8066, #88FA, #896D, #D2B5, #DB60, #DB75, #DB8E, #E013, #E018, #E01E, #E023, #E029, #E94A, #F0A0, #F44F, #F4A3, #F4D4, #F4F4, #F529, #F598, #F618, #F626, #F648, #F65E, #F67C, #F6B8, #F864, #F8BB, #F912.

### Battle.ShowSpell

Адрес #DB60, блок `S47`. [Source/Battle/ShowSpell.asm](../Source/Battle/ShowSpell.asm#L14).

показать название и параметры выбранного заклинания

8066 получает описатель заклинания по A, IX сохраняется в DC06 внутри текстового шаблона DC05, F618 оформляет заголовок, 7117 выводит одну строку

**Вход:** A номер заклинания

**Выход:** IX описатель заклинания

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, указатель текста DC06, экран и рабочие поля оформления рамки, IY сохранён

В сохранённом графе: 8 инструкций. Чтение: не выделено. Запись: #DC06. Вызовы: #7117, #8066, #F618.

### Battle.SpendHeroMagic

Адрес #DB75, блок `S47`. [Source/Battle/SpendHeroMagic.asm](../Source/Battle/SpendHeroMagic.asm#L13).

списать магическую силу героя с насыщением нулём

устанавливает бит 2 в FCE7, вычитает BC из слова 6A04, при займе записывает ноль, carry сохраняет признак недостатка, вызывающий код отменяет эффект после исчерпания силы

**Вход:** BC цена заклинания

**Выход:** CF=1 силы не хватило, CF=0 вычитание допустимо, HL новый остаток

**Изменяемые регистры и состояние:** HL, AF, слово 6A04 и бит 2 поля FCE7, DE, BC, IX, IY сохранены

В сохранённом графе: 11 инструкций. Чтение: #6A04, #FCE7. Запись: #6A04, #FCE7. Вызовы: не выделены.

### Battle.PickOccupied

Адрес #DB8E, блок `S47`. [Source/Battle/PickOccupied.asm](../Source/Battle/PickOccupied.asm#L13).

выбрать клетку, занятую любым отрядом

E029 возвращает подтверждение или отмену, при подтверждении F65E ищет отряд сначала в FD47, затем в FCED, пустая клетка повторяет выбор

**Вход:** BC начальная клетка

**Выход:** Z=1 подтверждён отряд, IX его запись, BC клетка, Z=0 отмена

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, фон и состояние анимации курсора, IY не изменяется собственным кодом

В сохранённом графе: 9 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #E029, #F65E.

### Battle.CellUp

Адрес #E013, блок `S47`. [Source/Battle/CellUp.asm](../Source/Battle/CellUp.asm#L12).

уменьшить строку клетки без выхода за верхний край

при B=0 оставляет строку без изменения, иначе уменьшает B

**Вход:** BC клетка, B строка 0..4

**Выход:** BC новая клетка, AF изменён

**Изменяемые регистры и состояние:** BC и AF, меняются B и флаги, HL, DE, C, IX, IY сохранены

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.CellDown

Адрес #E018, блок `S47`. [Source/Battle/CellDown.asm](../Source/Battle/CellDown.asm#L12).

увеличить строку клетки без выхода за нижний край

при B=4 оставляет строку без изменения, иначе увеличивает B

**Вход:** BC клетка

**Выход:** BC новая клетка, AF изменён

**Изменяемые регистры и состояние:** BC и AF, меняются B и флаги, HL, DE, C, IX, IY сохранены

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.CellLeft

Адрес #E01E, блок `S47`. [Source/Battle/CellLeft.asm](../Source/Battle/CellLeft.asm#L12).

уменьшить столбец клетки без выхода за левый край

при C=0 оставляет столбец без изменения, иначе уменьшает C

**Вход:** BC клетка

**Выход:** BC новая клетка, AF изменён

**Изменяемые регистры и состояние:** BC и AF, меняются C и флаги, HL, DE, B, IX, IY сохранены

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.CellRight

Адрес #E023, блок `S47`. [Source/Battle/CellRight.asm](../Source/Battle/CellRight.asm#L12).

увеличить столбец клетки без выхода за правый край

при C=7 оставляет столбец без изменения, иначе увеличивает C

**Вход:** BC клетка

**Выход:** BC новая клетка, AF изменён

**Изменяемые регистры и состояние:** BC и AF, меняются C и флаги, HL, DE, B, IX, IY сохранены

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.SelectCell

Адрес #E029, блок `S47`. [Source/Battle/SelectCell.asm](../Source/Battle/SelectCell.asm#L14).

перемещать курсор по боевому полю до подтверждения либо отмены

E091 выдаёт код ввода с анимацией, коды 13,1B,23,12,22,11,19,21 задают восемь направлений, код 27 подтверждает только клетку без препятствия по F67C, код 20 отменяет

**Вход:** BC начальная клетка

**Выход:** Z=1 подтверждение, Z=0 отмена, BC выбранная клетка

**Изменяемые регистры и состояние:** HL, DE, BC, AF, состояние курсора и изменяемый байт проверки препятствия F694, IX и IY сохраняются вызываемыми процедурами

В сохранённом графе: 46 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #E013, #E018, #E01E, #E023, #E091, #F67C.

### Battle.ReadCursorInput

Адрес #E091, блок `S47`. [Source/Battle/ReadCursorInput.asm](../Source/Battle/ReadCursorInput.asm#L16).

прочитать ввод при анимированном курсоре клетки

SaveCursorBack сохраняет фон клетки, Timer начинает отсчёт с единицы, Delay получает 280 TickCursorAnim обновляет четыре кадра поверх этого фона, Engine.ReadInput опрашивает ввод результат возвращается после 255 распознанных отсчётов ввода, паузы без ввода счётчик не уменьшают перед возвратом RestoreCursor восстанавливает пиксели и атрибуты клетки

**Вход:** BC клетка

**Выход:** BC сохранён, AF содержит последний распознанный код, IX сохранён

**Изменяемые регистры и состояние:** HL, DE, AF, фон Background, Timer, Frame и операнд TickCursorAnim.Delay BC, IX и IY сохранены

В сохранённом графе: 21 инструкций. Чтение: не выделено. Запись: #F98F, #FA1C, #FA1E. Вызовы: #6BF1, #F984, #F9E4, #FA08.

### Battle.AITurn

Адрес #E0BF, блок `S47`. [Source/Battle/AITurn.asm](../Source/Battle/AITurn.asm#L15).

выполнить ход противника и сбросить отметки раунда

EBA9 выбирает заклинание противника, затем очищается верхняя строка интерфейса, F556 сбрасывает временные флаги обеих армий, F578 восстанавливает движения противнику, E0E8 вызывается с режимами 0 и 3

**Вход:** армии FCED и FD47

**Выход:** армии изменены, F6B8 может завершить бой

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, флаги обеих армий, движения и магическая сила противника, экран и рабочие поля ИИ

В сохранённом графе: 15 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #73CF, #E0E8, #EBA9, #F556, #F578.

### Battle.AIArmyPass

Адрес #E0E8, блок `S47`. [Source/Battle/AIArmyPass.asm](../Source/Battle/AIArmyPass.asm#L15).

выполнить проход ИИ по ещё не завершившим ход отрядам

перебирает до пяти записей FD47, пропускает завершившие ход по биту 4 поля +9, первый режим 0 пропускает отложенные битом 3, режим 3 требует этот бит в E117, после действия сканирование начинается с начала массива

**Вход:** A режим 0 либо 3

**Выход:** отряды помечаются битом 4 после завершения действий

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, операнд E111, флаги и действия отрядов противника, состояние атак и перемещений

В сохранённом графе: 20 инструкций. Чтение: #E111. Запись: #E111. Вызовы: #E117.

### Battle.AIUnitTurn

Адрес #E117, блок `S47`. [Source/Battle/AIUnitTurn.asm](../Source/Battle/AIUnitTurn.asm#L18).

выбрать движение или атаку одного отряда компьютера

сохраняет режим в E922, E7A5 отмечает достижимые цели, обычному бойцу E7E0 выбирает цель и E5B0 предлагает соседей в предпочтительном порядке, свободная клетка перемещает отряд и уменьшает +12, выбранная соседняя цель запускает F0A0, стрелки типа 1/2 стреляют вне соседства и расходуют +8, при необходимости ищут выход из ближнего боя в один или два шага, летун типа 4 находит свободную клетку возле цели, эффект 20 запрещает полёт, остальные специальные типы перебирают всё поле, отсутствие действий ставит бит 4, отложенная стыковка со своим отрядом ставит бит 3

**Вход:** IY запись противника, A режим прохода

**Выход:** координаты, движения, боеприпасы и флаги IY обновлены, возможно завершение боя

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, поля ИИ E639..E66C/E8D7..E949, записи армий, боевые объекты, экран, состояние калькулятора и генератора

В сохранённом графе: 435 инструкций. Чтение: #6A3B, #E435, #E669, #E66B, #E8E1, #E922, #FCE7. Запись: #E225, #E420, #E42E, #E435, #E669, #E66B, #E8E1, #E922. Вызовы: #6DAE, #6DDA, #896D, #E569, #E5B0, #E7A5, #E7E0, #E8AD, #E8E3, #F0A0, #F5E8, #F648, #F65E, #F67C, #F6B8, #F8BB, #F912.

### Battle.MarkAdjacent

Адрес #E569, блок `S47`. [Source/Battle/MarkAdjacent.asm](../Source/Battle/MarkAdjacent.asm#L14).

пометить отряды героя, стоящие не далее одной клетки от заданной

у всех FCED сбрасывает бит 5 поля +9, абсолютные разности координат с L/H проверяет на 0 либо 1 по каждой оси, подходящие записи получают бит 5 и переменная E5AA становится FF, пустой ID завершает список

**Вход:** HL клетка, L столбец, H строка

**Выход:** Z=1 рядом никого, Z=0 найден отряд, IX и BC сохранены

**Изменяемые регистры и состояние:** DE, AF, бит 5 поля +9 у отрядов FCED, операнд E5AA, HL, BC, IX, IY сохранены

В сохранённом графе: 35 инструкций. Чтение: не выделено. Запись: #E5AA. Вызовы: не выделены.

### Battle.BuildNeighbours

Адрес #E5B0, блок `S47`. [Source/Battle/BuildNeighbours.asm](../Source/Battle/BuildNeighbours.asm#L15).

построить восемь соседних клеток в порядке приближения к цели

Engine.GetDirection выбирает одно из восьми направлений от BC к DE, DirectionFns содержит генераторы Candidates сначала заполняется восемью одинаковыми записями Status=0, X=C, Y=B вычисленный RET запускает генератор Neighbours, следующий RET передаёт таблицу ClassifyCells ClassifyCells проверяет границы, препятствия и армии, затем возвращает сохранённые регистры

**Вход:** DE цель, BC исходная клетка

**Выход:** ClassifyCells.Candidates восемь записей FBattleCell в порядке приоритета направления

**Изменяемые регистры и состояние:** таблица Candidates и код TestObstacle.ColumnTest, HL, DE, BC, AF, IX и IY восстановлены

В сохранённом графе: 31 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7C71.

### Battle.ClassifyCells

Адрес #E5E1, блок `S47`. [Source/Battle/ClassifyCells.asm](../Source/Battle/ClassifyCells.asm#L15).

проверить границы, препятствия и занятость восьми соседних клеток

каждая запись FBattleCell содержит Status, X и Y, поле боя имеет восемь столбцов и пять строк выход координаты за край или TestObstacle дают статус 1, FindUnitAtCell ищет обе армии отряд героя даёт статус 2, противника 3, свободная клетка сохраняет статус 0 в конце восстанавливается кадр регистров BuildNeighbours, возврат идёт к его вызывающему коду

**Вход:** Candidates после одного из генераторов Neighbours

**Выход:** статусы восьми кандидатов заполнены

**Изменяемые регистры и состояние:** таблица Candidates и код TestObstacle.ColumnTest, HL, DE, BC, AF, IX и IY восстановлены

В сохранённом графе: 40 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #F65E, #F67C.

### Battle.NeighboursN

Адрес #E67D, блок `S47`. [Source/Battle/NeighboursN.asm](../Source/Battle/NeighboursN.asm#L16).

задать координаты восьми кандидатов для выбранного направления поиска

IY указывает на FBattleCells, все восемь записей первоначально содержат исходную клетку порядок кандидатов First..Eighth: север, северо-запад, северо-восток, запад, восток, юго-запад, юго-восток, юг север уменьшает Y, восток увеличивает X, меняются только координаты, Status проверяется позже BuildNeighbours запускает процедуру вычисленным RET, возврат передаёт управление ClassifyCells

**Вход:** IY массив восьми FBattleCell с исходными координатами

**Выход:** координаты кандидатов записаны в порядке приоритета, Status не изменён

**Изменяемые регистры и состояние:** F и координаты по IY, HL, DE, BC, A, IX и IY сохранены

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.NeighboursNE

Адрес #E6A2, блок `S47`. [Source/Battle/NeighboursNE.asm](../Source/Battle/NeighboursNE.asm#L16).

задать координаты восьми кандидатов для выбранного направления поиска

IY указывает на FBattleCells, все восемь записей первоначально содержат исходную клетку порядок кандидатов First..Eighth: северо-восток, север, восток, юго-восток, северо-запад, юг, запад, юго-запад север уменьшает Y, восток увеличивает X, меняются только координаты, Status проверяется позже BuildNeighbours запускает процедуру вычисленным RET, возврат передаёт управление ClassifyCells

**Вход:** IY массив восьми FBattleCell с исходными координатами

**Выход:** координаты кандидатов записаны в порядке приоритета, Status не изменён

**Изменяемые регистры и состояние:** F и координаты по IY, HL, DE, BC, A, IX и IY сохранены

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.NeighboursE

Адрес #E6C7, блок `S47`. [Source/Battle/NeighboursE.asm](../Source/Battle/NeighboursE.asm#L17).

задать координаты восьми кандидатов для выбранного направления поиска

IY указывает на FBattleCells, все восемь записей первоначально содержат исходную клетку порядок кандидатов First..Eighth: восток, северо-восток, юго-восток, север, юг, северо-восток, юго-запад, запад север уменьшает Y, восток увеличивает X, меняются только координаты, Status проверяется позже исходный порядок содержит северо-восток дважды, Sixth повторяет Second, байты игры сохранены BuildNeighbours запускает процедуру вычисленным RET, возврат передаёт управление ClassifyCells

**Вход:** IY массив восьми FBattleCell с исходными координатами

**Выход:** координаты кандидатов записаны в порядке приоритета, Status не изменён

**Изменяемые регистры и состояние:** F и координаты по IY, HL, DE, BC, A, IX и IY сохранены

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.NeighboursSE

Адрес #E6EC, блок `S47`. [Source/Battle/NeighboursSE.asm](../Source/Battle/NeighboursSE.asm#L16).

задать координаты восьми кандидатов для выбранного направления поиска

IY указывает на FBattleCells, все восемь записей первоначально содержат исходную клетку порядок кандидатов First..Eighth: юго-восток, восток, юг, северо-восток, юго-запад, запад, север, северо-запад север уменьшает Y, восток увеличивает X, меняются только координаты, Status проверяется позже BuildNeighbours запускает процедуру вычисленным RET, возврат передаёт управление ClassifyCells

**Вход:** IY массив восьми FBattleCell с исходными координатами

**Выход:** координаты кандидатов записаны в порядке приоритета, Status не изменён

**Изменяемые регистры и состояние:** F и координаты по IY, HL, DE, BC, A, IX и IY сохранены

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.NeighboursS

Адрес #E711, блок `S47`. [Source/Battle/NeighboursS.asm](../Source/Battle/NeighboursS.asm#L16).

задать координаты восьми кандидатов для выбранного направления поиска

IY указывает на FBattleCells, все восемь записей первоначально содержат исходную клетку порядок кандидатов First..Eighth: юг, юго-запад, юго-восток, запад, восток, северо-запад, северо-восток, север север уменьшает Y, восток увеличивает X, меняются только координаты, Status проверяется позже BuildNeighbours запускает процедуру вычисленным RET, возврат передаёт управление ClassifyCells

**Вход:** IY массив восьми FBattleCell с исходными координатами

**Выход:** координаты кандидатов записаны в порядке приоритета, Status не изменён

**Изменяемые регистры и состояние:** F и координаты по IY, HL, DE, BC, A, IX и IY сохранены

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.NeighboursSW

Адрес #E736, блок `S47`. [Source/Battle/NeighboursSW.asm](../Source/Battle/NeighboursSW.asm#L16).

задать координаты восьми кандидатов для выбранного направления поиска

IY указывает на FBattleCells, все восемь записей первоначально содержат исходную клетку порядок кандидатов First..Eighth: юго-запад, запад, юг, северо-запад, юго-восток, восток, север, северо-восток север уменьшает Y, восток увеличивает X, меняются только координаты, Status проверяется позже BuildNeighbours запускает процедуру вычисленным RET, возврат передаёт управление ClassifyCells

**Вход:** IY массив восьми FBattleCell с исходными координатами

**Выход:** координаты кандидатов записаны в порядке приоритета, Status не изменён

**Изменяемые регистры и состояние:** F и координаты по IY, HL, DE, BC, A, IX и IY сохранены

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.NeighboursW

Адрес #E75B, блок `S47`. [Source/Battle/NeighboursW.asm](../Source/Battle/NeighboursW.asm#L16).

задать координаты восьми кандидатов для выбранного направления поиска

IY указывает на FBattleCells, все восемь записей первоначально содержат исходную клетку порядок кандидатов First..Eighth: запад, северо-запад, юго-запад, север, юг, северо-восток, юго-восток, восток север уменьшает Y, восток увеличивает X, меняются только координаты, Status проверяется позже BuildNeighbours запускает процедуру вычисленным RET, возврат передаёт управление ClassifyCells

**Вход:** IY массив восьми FBattleCell с исходными координатами

**Выход:** координаты кандидатов записаны в порядке приоритета, Status не изменён

**Изменяемые регистры и состояние:** F и координаты по IY, HL, DE, BC, A, IX и IY сохранены

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.NeighboursNW

Адрес #E780, блок `S47`. [Source/Battle/NeighboursNW.asm](../Source/Battle/NeighboursNW.asm#L16).

задать координаты восьми кандидатов для выбранного направления поиска

IY указывает на FBattleCells, все восемь записей первоначально содержат исходную клетку порядок кандидатов First..Eighth: северо-запад, север, запад, северо-восток, юго-запад, восток, юг, юго-восток север уменьшает Y, восток увеличивает X, меняются только координаты, Status проверяется позже BuildNeighbours запускает процедуру вычисленным RET, возврат передаёт управление ClassifyCells

**Вход:** IY массив восьми FBattleCell с исходными координатами

**Выход:** координаты кандидатов записаны в порядке приоритета, Status не изменён

**Изменяемые регистры и состояние:** F и координаты по IY, HL, DE, BC, A, IX и IY сохранены

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.MarkInRange

Адрес #E7A5, блок `S47`. [Source/Battle/MarkInRange.asm](../Source/Battle/MarkInRange.asm#L13).

отметить цели героя в пределах подвижности отряда компьютера

до пяти записей FCED получают бит 4 поля +9, если по обеим осям abs(delta)-1 меньше (IY+7), совпадение координаты сразу допустимо, дальность учитывает восемь направлений

**Вход:** IY отряд противника

**Выход:** бит 4 установлен у достижимых целей FCED

**Изменяемые регистры и состояние:** DE, BC, AF, IX, бит 4 поля +9 в FCED, HL и IY не изменяются

В сохранённом графе: 26 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.ChooseTarget

Адрес #E7E0, блок `S47`. [Source/Battle/ChooseTarget.asm](../Source/Battle/ChooseTarget.asm#L17).

выбрать отряд по таблице приоритетов и минимальной весовой оценке

HL патчит два операнда LD IX началом армии, IY задаёт цепочку групп count, значения с терминатором FF, бит 6 поля +9 и эффект 80 исключают отряд, стрелковые флаги без боеприпасов +8 нормализуются, маска 17 выделяет дальность и тип, на первом подходящем приоритете ставит бит 5 кандидатов, E8AD оставляет минимальную пятибайтную весовую оценку, смещение CP (IY+d) изменяется по числу условий группы

**Вход:** HL массив FCED либо FD47, IY правила

**Выход:** IX выбранный отряд, A=FF и Z=0 успех, Z=1 подходящего нет

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, операнды E7F0/E821/E83D, бит 5 кандидатов, оценки E8D7..E8E0, указатель E8E1 и состояние калькулятора

В сохранённом графе: 85 инструкций. Чтение: #E821, #E8E1. Запись: #E7F0, #E821, #E83D, #E8E1. Вызовы: #6DAE, #6DDA, #E8AD.

### Battle.StackStrength

Адрес #E8AD, блок `S47`. [Source/Battle/StackStrength.asm](../Source/Battle/StackStrength.asm#L14).

вычислить весовую оценку боевого отряда

помещает количество IX+2 на стек ROM, 8036 получает описатель типа, слово +16..17 умножается на количество токеном 04, 6DC4 сохраняет результат по входному HL

**Вход:** HL адрес float5 результата, IX отряд

**Выход:** float5=количество*слово описателя 16, IX, IY, BC сохранены

**Изменяемые регистры и состояние:** HL, DE, AF, пять байтов результата по входному HL и состояние калькулятора, BC, IX, IY восстановлены

В сохранённом графе: 21 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D62, #6DAE, #6DC4, #8036.

### Battle.AnimatePath

Адрес #E8E3, блок `S47`. [Source/Battle/AnimatePath.asm](../Source/Battle/AnimatePath.asm#L16).

провести мигающую анимацию от исходной клетки к целевой

BuildNeighbours выбирает первую соседнюю клетку по направлению к цели, занятость здесь не учитывается SaveCursorBack сохраняет фон этой клетки, шесть групп по 1000 вызовов TickCursorAnim дают мигание задержка кадра также равна 1000, после группы RestoreCursor возвращает фон пока выбранная клетка не совпала с целью, анимация продолжается из неё следующим шагом

**Вход:** DE цель, BC исходная клетка

**Выход:** DE цель, BC конечная клетка, фон восстановлен

**Изменяемые регистры и состояние:** HL, DE, BC, AF, Candidates, Timer, Frame, Background, TickCursorAnim.Delay и пиксели анимации IX и IY сохранены

В сохранённом графе: 35 инструкций. Чтение: #E63A. Запись: #F98F, #FA1C, #FA1E. Вызовы: #E5B0, #F984, #F9E4, #FA08.

### Battle.RunUncontrolled

Адрес #E94A, блок `S47`. [Source/Battle/RunUncontrolled.asm](../Source/Battle/RunUncontrolled.asm#L16).

выполнить случайный ход или атаку вышедшего из подчинения отряда

по E5B0 собирает соседние занятые клетки в EB8E, EB08 случайно выбирает цель из любой армии для рукопашной F0A0, при отсутствии соседей стрелок с запасом +8 использует EB2D для списка остальных отрядов и стреляет, летун выбирает свободную клетку возле случайной цели, прочие выбирают случайного свободного соседа, движение уменьшает +12 и повторяется до исчерпания

**Вход:** IY вышедший из подчинения отряд героя

**Выход:** изменены координаты, действия и количества участников, возможно завершение боя

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, список и число целей EB8B..EBA8, армии, боевые объекты, экран и состояние генератора

В сохранённом графе: 183 инструкций. Чтение: #6A3B, #EB8B, #EB8C. Запись: #E9F7, #EB8B, #EB8C. Вызовы: #7C0D, #896D, #E5B0, #E8E3, #EB08, #EB2D, #F0A0, #F5E8, #F648, #F65E, #F6B8, #F8BB, #F912.

### Battle.RandomTarget

Адрес #EB08, блок `S47`. [Source/Battle/RandomTarget.asm](../Source/Battle/RandomTarget.asm#L12).

случайно выбрать запись из списка целей

7C0D выбирает индекс 0..EB8B-1, тройка EB8E+3*индекс содержит тип 2/3 и указатель отряда

**Вход:** EB8B число целей, EB8E список

**Выход:** IX отряд, A тип с временным битом 7, HL адрес тройки

**Изменяемые регистры и состояние:** HL, DE, AF, IX, состояние генератора 7C69..7C70, BC и IY сохранены

В сохранённом графе: 19 инструкций. Чтение: #EB8B. Запись: не выделена. Вызовы: #7C0D.

### Battle.ListOtherUnits

Адрес #EB2D, блок `S47`. [Source/Battle/ListOtherUnits.asm](../Source/Battle/ListOtherUnits.asm#L13).

составить список всех отрядов кроме действующего

сначала добавляет до пяти отрядов FD47 со статусом 3, затем до пяти FCED со статусом 2, текущий IY исключается сравнением указателя, тройки записываются в EB8E, число в EB8B

**Вход:** IY действующий отряд

**Выход:** EB8E список, EB8B число целей, IX за последней тройкой

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, число и список целей EB8B..EBA8, IY не изменяется

В сохранённом графе: 45 инструкций. Чтение: #EB8B. Запись: #EB8B. Вызовы: не выделены.

### Battle.AISpell

Адрес #EBA9, блок `S47`. [Source/Battle/AISpell.asm](../Source/Battle/AISpell.asm#L18).

выбрать и применить доступное заклинание противника

обнуляет десять флагов F081..F08A, проверяет цену заклинаний по 8066 против FCB9, наличие зомби ID19 для подчинения, типы целей и щиты FCE7, случайно выбирает допустимый номер 1..10, непригодный помечается и выбор повторяется, F028 списывает силу, ветки выполняют перемещение, подчинение с добавлением количества к зомби, магический щит, невидимость 82, клонирование 62 или воздействие F598, коды эффектов берутся из DC01, завершение после одного применения либо исчерпания вариантов

**Вход:** FCB9 магическая сила противника, FCED/FD47 армии

**Выход:** сила и армии изменены, возможно завершение боя

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, флаги F081..F08A, FCB9, обе армии, рабочие поля заклинаний, экран и состояния калькулятора и генератора

В сохранённом графе: 459 инструкций. Чтение: #EFE4, #F05C, #F05E, #F083, #F084, #F085, #F086, #F087, #F088, #F089, #F08A, #FCB9, #FCE7. Запись: #EFE4, #F05C, #F05E, #F081, #F082, #F083, #F084, #F085, #F086, #F087, #F088, #F089, #F08A, #FCE7. Вызовы: #6D88, #6DAE, #6DC4, #6DDA, #7AEF, #7C0D, #8066, #E569, #E5B0, #E7A5, #E7E0, #E8AD, #E8E3, #F028, #F4F4, #F556, #F578, #F598, #F5E8, #F648, #F6B8, #F8BB, #F912.

### Battle.SpendAIMagic

Адрес #F028, блок `S47`. [Source/Battle/SpendAIMagic.asm](../Source/Battle/SpendAIMagic.asm#L14).

списать цену и показать применяемое противником заклинание

8066 получает описатель по A, IX сохраняется в F07C текстового шаблона F06A, из FCB9 вычитается слово +15..16 описателя, название выводится через 7117, основные входные регистры восстанавливаются

**Вход:** A номер заклинания

**Выход:** FCB9 уменьшено, HL, DE, BC, IX, IY сохранены

**Изменяемые регистры и состояние:** AF, сила FCB9, указатель F07C и экран заголовка, HL, DE, BC, IX, IY восстанавливаются

В сохранённом графе: 26 инструкций. Чтение: #FCB9. Запись: #F07C, #FCB9. Вызовы: #7117, #8066, #F618.

### Battle.ResolveAttack

Адрес #F0A0, блок `S47`. [Source/Battle/ResolveAttack.asm](../Source/Battle/ResolveAttack.asm#L18).

рассчитать атаку и возможный ответный удар

меняет IX/IY местами и сохраняет атакующего F421 и цель F423, F2A1 отмечает участие своих отрядов, эффект 80 цели обнуляет первый урон, иначе F38B рассчитывает урон по табличной совместимости, численности, разбросу и коэффициентам, F2F1 восстанавливает атакующего по специальному признаку, режим 1 разрешает ответ, прочие обнуляют его, эффект 80 атакующего запрещает ответ, количество F421 уменьшается на ответ F426, количество F423 на основной урон F42B, F337 ограничивает восстановление исходной численностью

**Вход:** IY атакующий, IX цель, A=1 рукопашная с ответом, A=2 дальняя без ответа

**Выход:** изменены пятибайтные количества обоих отрядов

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, параметры и результаты F414..F43A, операнд калькулятора F3F2, количества участников, постоянные отметки типов и состояние калькулятора

В сохранённом графе: 193 инструкций. Чтение: #F421, #F423, #F425. Запись: #F3F2, #F414, #F415, #F416, #F418, #F41B, #F41D, #F41F, #F421, #F423, #F425. Вызовы: #6D34, #6D57, #6D88, #6DAE, #6DC4, #7AEF, #7C0D, #8036, #F2A1, #F2CE, #F2D6, #F2F1, #F337, #F364, #F38B, #F3F5, #F626, #F698.

### Battle.RecordFighters

Адрес #F2A1, блок `S47`. [Source/Battle/RecordFighters.asm](../Source/Battle/RecordFighters.asm#L13).

отметить участие отрядов героя в столкновении

для указателей F421 и F423 сравнивает адрес с FD47, меньшие указатели относятся к FCED и передаются F2BE

**Вход:** F421 и F423 участники

**Выход:** постоянные записи отрядов героя обновлены

**Изменяемые регистры и состояние:** HL, BC, AF и постоянные поля типов, обновляемые F2BE, DE, IX, IY сохранены

В сохранённом графе: 15 инструкций. Чтение: #F421, #F423. Запись: не выделена. Вызовы: #F2BE.

### Battle.MarkUnitFight

Адрес #F2BE, блок `S47`. [Source/Battle/MarkUnitFight.asm](../Source/Battle/MarkUnitFight.asm#L14).

отметить участие типа отряда в бою и сбросить накопленные дни бездействия

IndexFlagArray выбирает IdleDays[ID-1], соседний массив UpgradeCount находится на 25 байтов дальше дни бездействия обнуляются, счётчик развития увеличивается по модулю 256

**Вход:** HL боевой отряд

**Выход:** IdleDays[ID-1]=0, UpgradeCount[ID-1] увеличен

**Изменяемые регистры и состояние:** AF, счётчик дней бездействия и счётчик развития выбранного типа HL, DE, BC, IX и IY сохранены

В сохранённом графе: 7 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7AA4.

### Battle.WaitAttack

Адрес #F2CE, блок `S47`. [Source/Battle/WaitAttack.asm](../Source/Battle/WaitAttack.asm#L13).

выдержать десять кадров между фазами атаки

B=10 и цикл HALT/DJNZ, исходный BC сохраняется

**Вход:** прерывания разрешены

**Выход:** прошло десять прерываний, BC сохранён

**Изменяемые регистры и состояние:** собственных изменений регистров или данных нет, BC восстановлен, исполнение ожидает десять прерываний

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.EffectFactor

Адрес #F2D6, блок `S47`. [Source/Battle/EffectFactor.asm](../Source/Battle/EffectFactor.asm#L15).

получить коэффициент воздействия временного эффекта

старшая тетрада A задаёт номер эффекта, ноль или номер >=7 возвращает 10, иначе SpellCoeffs выбирает слово для эффекта и типа отряда, возвращается старший байт B

**Вход:** A байт эффекта, IX отряд

**Выход:** A=10 либо старший байт табличного слова, BC изменён

**Изменяемые регистры и состояние:** BC, AF, HL, DE, IX, IY не изменяются

В сохранённом графе: 15 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #F5C4.

### Battle.ApplyDrainTrait

Адрес #F2F1, блок `S47`. [Source/Battle/ApplyDrainTrait.asm](../Source/Battle/ApplyDrainTrait.asm#L15).

увеличить количество атакующего за счёт нанесённого воздействия

бит 7 регистра E из 7AEF разрешает ветку, бит 1 описателя цели +15 запрещает её, калькулятор сравнивает урон по HL с количеством цели, меньшее прибавляется к количеству атакующего IX+2, структура соответствует восстановлению по типу вампиризма

**Вход:** HL float5 урона, IX атакующий, IY цель

**Выход:** количество IX+2 может увеличиться

**Изменяемые регистры и состояние:** HL, DE, BC, AF, сохранённый указатель F335, количество атакующего IX+2..6 и состояние калькулятора, IX и IY сохраняют указатели участников

В сохранённом графе: 33 инструкций. Чтение: #F335. Запись: #F335. Вызовы: #6DAE, #6DC4, #6DDA, #7AEF, #8036.

### Battle.ClampRegen

Адрес #F337, блок `S47`. [Source/Battle/ClampRegen.asm](../Source/Battle/ClampRegen.asm#L14).

ограничить количество специального отряда исходной численностью

бит 0 описателя типа +15 разрешает проверку, количество IX+2 сравнивается с исходным целым IX+14..15, превышение заменяется исходным количеством

**Вход:** IX боевой отряд

**Выход:** для специального типа количество не выше исходного

**Изменяемые регистры и состояние:** HL, DE, BC, AF, количество IX+2..6 при превышении исходного, состояние калькулятора, IX восстановлен

В сохранённом графе: 21 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D62, #6DAE, #6DC4, #6DDA, #8036.

### Battle.RangedMatchup

Адрес #F364, блок `S47`. [Source/Battle/RangedMatchup.asm](../Source/Battle/RangedMatchup.asm#L14).

получить коэффициент дальнего воздействия для пары типов

в трёхбайтной таблице по HL ищет ID=A, следующие два байта дают смещение к C8FC, слово индексируется ID цели (IY+0)-1 и сохраняется в F416, терминатор не проверяется, тип должен присутствовать

**Вход:** HL таблица, A ID атакующего, IY цель

**Выход:** DE коэффициент, F416=DE, IX адрес слова

**Изменяемые регистры и состояние:** HL, DE, AF, IX и слово F416, BC и IY не изменяются

В сохранённом графе: 21 инструкций. Чтение: не выделено. Запись: #F416. Вызовы: не выделены.

### Battle.CalcDamage

Адрес #F38B, блок `S47`. [Source/Battle/CalcDamage.asm](../Source/Battle/CalcDamage.asm#L19).

рассчитать пятибайтный урон по подготовленным коэффициентам

основа на стеке ROM=(F416/F41F)*float(F41B), r выбирается 0..2*low(F418)-1, p=floor(r/2)/100, при r<=low(F418) основа умножается на 1-p, иначе на 1+p, затем на low(F41D)/high(F41D), последняя поправка F414/F415 комбинируется токеном по F3F2, F0A0 ставит 05 для деления при первой атаке или 04 для умножения при ответе

**Вход:** F416 совместимость, F41F делитель, F41B количество, F418 разброс, F41D поправка, F414/F415 эффекты

**Выход:** float5 результата на стеке ROM

**Изменяемые регистры и состояние:** HL, DE, BC, AF, состояние калькулятора и генератора 7C69..7C70, IX и IY не используются собственным кодом

В сохранённом графе: 39 инструкций. Чтение: #F414, #F415, #F416, #F418, #F41B, #F41D, #F41E, #F41F. Запись: не выделена. Вызовы: #6D62, #6D88, #6DAE, #7C0D.

### Battle.MeleeMatchup

Адрес #F3F5, блок `S47`. [Source/Battle/MeleeMatchup.asm](../Source/Battle/MeleeMatchup.asm#L12).

получить слово коэффициента совместимости двух типов в рукопашном бою

IX=C3E8+50*B+2*(C-1), из IX читается DE, таблица имеет 25 слов на строку, IX, BC, AF сохраняются

**Вход:** B ID атакующего, C ID цели, оба >0

**Выход:** DE коэффициент рукопашной пары

**Изменяемые регистры и состояние:** DE, HL, BC, AF, IX, IY сохранены

В сохранённом графе: 16 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.HasMagicShield

Адрес #F44F, блок `S47`. [Source/Battle/HasMagicShield.asm](../Source/Battle/HasMagicShield.asm#L14).

проверить магический щит стороны выбранной цели

IX<FD47 означает сторону героя и проверку бита 0 в FCE7, иначе проверяется бит 1, активный щит выводит сообщение F482 и выдерживает пять кадров

**Вход:** IX цель

**Выход:** CF=1 щита нет, CF=0 щит активен, HL, DE, BC сохранены

**Изменяемые регистры и состояние:** AF, экран заголовка и рабочие поля рамки на пути активного щита, HL, DE, BC, IX, IY сохранены

В сохранённом графе: 28 инструкций. Чтение: #FCE7. Запись: не выделена. Вызовы: #7117, #7BF4, #F618.

### Battle.ArmyValue

Адрес #F4A3, блок `S47`. [Source/Battle/ArmyValue.asm](../Source/Battle/ArmyValue.asm#L13).

сложить стоимостные оценки отрядов армии

помещает ноль на стек ROM, до пяти плотных записей IY с шагом 18 умножают float5 количества на слово описателя типа +26..27, токены 04,0F добавляют произведение к сумме, ID0 завершает список

**Вход:** IY начало армии

**Выход:** оценка армии на стеке ROM, IY продвинут

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, состояние калькулятора и текущий банк, выбираемый 8036

В сохранённом графе: 24 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D62, #6D88, #6DAE, #8036.

### Battle.RefreshObjects

Адрес #F4D4, блок `S47`. [Source/Battle/RefreshObjects.asm](../Source/Battle/RefreshObjects.asm#L15).

сбросить флаги сорока объектов поля и заново отобразить армии

через 6D34 временно выключает обработку объектов в прерывании, у сорока объектов от 6611 с шагом 20 в поле 0 сохраняет бит 7 и ставит бит 0, затем F4F4 создаёт объекты отрядов, IX и IY сохраняются, 6D34 сам не переключает банк

**Вход:** армии подготовлены

**Выход:** объекты поля помечены, IX и IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, флаги сорока объектов от 6611, поля их ресурсов и численности, бит 2 поля 6566, IX и IY восстановлены

В сохранённом графе: 16 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D34, #F4F4.

### Battle.DrawBothArmies

Адрес #F4F4, блок `S47`. [Source/Battle/DrawBothArmies.asm](../Source/Battle/DrawBothArmies.asm#L12).

обновить экранные объекты обеих армий

патчит атрибут F51D сначала 23 для FCED, затем 63 для FD47, F515 обходит отряды

**Вход:** армии FCED и FD47

**Выход:** объекты обновлены, IX и IY сохранены

**Изменяемые регистры и состояние:** DE, BC, AF, операнд F51D, объекты обеих армий и бит 2 поля 6566, HL, IX, IY сохранены

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: #F51D. Вызовы: #F515.

### Battle.DrawArmy

Адрес #F515, блок `S47`. [Source/Battle/DrawArmy.asm](../Source/Battle/DrawArmy.asm#L13).

обновить экранные объекты одной армии

до пяти плотных записей IY с шагом 18 передаёт отряд F8BB, A берётся из изменяемого операнда F51D, ID0 завершает список

**Вход:** IY начало армии, F51D флаг объекта

**Выход:** отряды переданы объектной системе, IY продвинут

**Изменяемые регистры и состояние:** DE, BC, AF, IY, объекты отрядов и бит 2 поля 6566, HL и IX сохранены

В сохранённом графе: 10 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #F8BB.

### Battle.MarkUnruled

Адрес #F529, блок `S47`. [Source/Battle/MarkUnruled.asm](../Source/Battle/MarkUnruled.asm#L14).

обновить признак превышения контроля у отрядов героя

у FCED очищает бит 7 поля +9 и вызывает F62D, при carry снова ставит бит, ID0 завершает список, основные регистры и IY сохраняются

**Вход:** FCED, параметры контроля 6A02/6AD3

**Выход:** бит 7 означает численность выше предела контроля

**Изменяемые регистры и состояние:** бит 7 поля +9 в FCED, пятибайтное рабочее поле 6E09..6E0D и состояние калькулятора, HL, DE, BC, AF, IY восстановлены, IX сохраняется вызываемыми обёртками

В сохранённом графе: 23 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #F62D.

### Battle.ResetTurnFlags

Адрес #F556, блок `S47`. [Source/Battle/ResetTurnFlags.asm](../Source/Battle/ResetTurnFlags.asm#L13).

очистить временные флаги одной армии

в каждой непустой записи оставляет только младшие три бита поля +9 через AND07, сбрасывает отметки 3..7, шаг 18, предел пять, DE, BC, AF, IY сохраняются

**Вход:** IY начало армии

**Выход:** поле +9 каждой записи равно исходному AND07

**Изменяемые регистры и состояние:** поля +9 непустых записей армии, HL, DE, BC, AF, IX, IY сохранены

В сохранённом графе: 19 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.RestoreMovement

Адрес #F578, блок `S47`. [Source/Battle/RestoreMovement.asm](../Source/Battle/RestoreMovement.asm#L13).

восстановить очки движения армии на новый раунд

до пяти плотных записей копирует базовую подвижность +7 в остаток +12, шаг 18, DE, BC, AF, IY сохраняются

**Вход:** IY начало армии

**Выход:** движения отрядов восстановлены

**Изменяемые регистры и состояние:** поля +12 непустых записей армии, HL, DE, BC, AF, IX, IY сохранены

В сохранённом графе: 18 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.ApplySpell

Адрес #F598, блок `S47`. [Source/Battle/ApplySpell.asm](../Source/Battle/ApplySpell.asm#L16).

изменить количество цели по силе заклинания

входной C сохраняется как последний токен калькулятора в F5BD, количество IX+2 помещается на стек, F5C4 выбирает слово для заклинания B и типа IX+0, младший байт коэффициента умножается на входной DE/20000, токен 03 вычитает воздействие, 0F прибавляет рассчитанное количество, результат сохраняется в IX+2

**Вход:** IX цель, B номер заклинания, C=03 вычитание или 0F сложение, DE сила

**Выход:** количество цели обновлено

**Изменяемые регистры и состояние:** HL, DE, BC, AF, количество IX+2..6, операнд F5BD и состояние калькулятора, IX сохраняется F5C4

В сохранённом графе: 21 инструкций. Чтение: не выделено. Запись: #F5BD. Вызовы: #6D62, #6D88, #6DAE, #6DC4, #F5C4.

### Battle.SpellCoeffs

Адрес #F5C4, блок `S47`. [Source/Battle/SpellCoeffs.asm](../Source/Battle/SpellCoeffs.asm#L13).

получить два байта коэффициентов заклинания для типа существа

номер B>=4 уменьшается на один, IX=FE66+50*B+2*C, читаются C и B, DE, AF, IX сохраняются, номер 4 «Телепортация» пропущен в упакованной таблице коэффициентов

**Вход:** B номер заклинания или эффекта >0, C ID типа

**Выход:** BC табличное слово

**Изменяемые регистры и состояние:** BC, HL, DE, AF, IX, IY сохранены

В сохранённом графе: 19 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.WaitMoveFrames

Адрес #F5E8, блок `S47`. [Source/Battle/WaitMoveFrames.asm](../Source/Battle/WaitMoveFrames.asm#L13).

выдержать сорок кадров анимации перемещения

B=40 и цикл HALT/DJNZ, исходный BC сохраняется

**Вход:** прерывания разрешены

**Выход:** прошло сорок прерываний, BC сохранён

**Изменяемые регистры и состояние:** собственных изменений регистров или данных нет, BC восстановлен, исполнение ожидает сорок прерываний

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.TickEffects

Адрес #F5F0, блок `S47`. [Source/Battle/TickEffects.asm](../Source/Battle/TickEffects.asm#L13).

уменьшить длительность временных эффектов одной армии

младшая тетрада +13 равна нулю означает пропуск, значение 1 обнуляет весь байт эффекта, остальные значения уменьшаются с сохранением старшей тетрады, до пяти плотных записей

**Вход:** IY начало армии

**Выход:** поле +13 обновлено, IY продвинут

**Изменяемые регистры и состояние:** DE, BC, AF, IY и поля +13 непустых отрядов, HL и IX не изменяются

В сохранённом графе: 20 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.DrawHeader

Адрес #F618, блок `S47`. [Source/Battle/DrawHeader.asm](../Source/Battle/DrawHeader.asm#L12).

оформить рамку заголовка боя цветом A

задаёт BC=0000 и DE=021E, вызывает 73FE, исходные DE и BC сохраняет

**Вход:** A атрибут рамки

**Выход:** рамка верхнего заголовка обновлена

**Изменяемые регистры и состояние:** HL, AF, пиксели и атрибуты рамки, рабочие поля 74AB..74EE, DE, BC, IX, IY сохранены

В сохранённом графе: 8 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #73FE.

### Battle.GetCellObject

Адрес #F626, блок `S47`. [Source/Battle/GetCellObject.asm](../Source/Battle/GetCellObject.asm#L13).

получить экранный объект боевой клетки

увеличивает строку B на один для пропуска верхнего ряда интерфейса, вызывает 7341 и восстанавливает BC

**Вход:** BC клетка, C=0..7, B=0..4

**Выход:** IX объект, HL связанное слово численности, BC сохранён

**Изменяемые регистры и состояние:** HL, AF и IX, в AF изменяются только флаги от INC B, DE, BC, A, IY сохранены

В сохранённом графе: 5 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7341.

### Battle.TestControl

Адрес #F62D, блок `S47`. [Source/Battle/TestControl.asm](../Source/Battle/TestControl.asm#L14).

сравнить численность отряда с пределом управления

86EA получает целый предел BC по типу (IY+0), 6D62 передаёт его на стек ROM, 6DAE передаёт количество IY+2, 6DDA вычитает количество из предела и выдаёт знак, HL, DE, BC сохраняются

**Вход:** IY боевой отряд

**Выход:** CF=1 количество выше предела, Z=1 равенство

**Изменяемые регистры и состояние:** AF, меняются флаги результата, рабочее пятибайтное поле 6E09..6E0D и состояние калькулятора, HL, DE, BC, IX, IY сохранены

В сохранённом графе: 16 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D62, #6DAE, #6DDA, #86EA.

### Battle.DirtyCell

Адрес #F648, блок `S47`. [Source/Battle/DirtyCell.asm](../Source/Battle/DirtyCell.asm#L13).

пометить экранный объект клетки как пустой для перерисовки

F626 получает IX объекта, поле +0 сохраняет только бит 7 и получает бит 0, IX, HL, AF сохраняются

**Вход:** BC клетка

**Выход:** объект клетки помечен для обновления

**Изменяемые регистры и состояние:** поле 0 экранного объекта выбранной клетки, HL, DE, BC, AF, IX, IY сохранены

В сохранённом графе: 12 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #F626.

### Battle.FindUnitAtCell

Адрес #F65E, блок `S47`. [Source/Battle/FindUnitAtCell.asm](../Source/Battle/FindUnitAtCell.asm#L13).

найти отряд с заданными координатами в одной армии

до пяти записей с шагом 18, пустой ID завершает поиск, OR A перед чтением координат очищает carry, слово +10/+11 сравнивается с BC через SBC

**Вход:** IX начало армии, BC клетка

**Выход:** Z=1 найдено, IX найденная запись, Z=0 нет совпадения

**Изменяемые регистры и состояние:** HL, DE, AF, IX, BC и IY сохранены

В сохранённом графе: 17 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.TestObstacle

Адрес #F67C, блок `S47`. [Source/Battle/TestObstacle.asm](../Source/Battle/TestObstacle.asm#L13).

проверить препятствие выбранной клетки

адрес строки HL=FCE8+B, инструкция BIT (7-C),(HL) меняется через операнд F694, единица означает непроходимую клетку, HL и DE сохраняются

**Вход:** BC клетка

**Выход:** Z=1 свободно, Z=0 препятствие, A изменён

**Изменяемые регистры и состояние:** AF и байт инструкции F694, HL, DE, BC, IX, IY сохранены

В сохранённом графе: 17 инструкций. Чтение: не выделено. Запись: #F694. Вызовы: не выделены.

### Battle.DrawAttack

Адрес #F698, блок `S47`. [Source/Battle/DrawAttack.asm](../Source/Battle/DrawAttack.asm#L13).

вывести маскированное изображение атаки в клетке

строка переводится в 4*(B+1), столбец в 4*C, IX=CF55 пиксели, IY=CFD5 маска, DE=0404, 75A2 рисует маскированный спрайт

**Вход:** BC клетка

**Выход:** область 4 на 4 знакоместа обновлена, IX и IY сохранены

**Изменяемые регистры и состояние:** DE, BC, AF и пиксели маркера, HL, IX, IY сохранены

В сохранённом графе: 14 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #75A2.

### Battle.ResolveLosses

Адрес #F6B8, блок `S47`. [Source/Battle/ResolveLosses.asm](../Source/Battle/ResolveLosses.asm#L19).

удалить погибших, обработать бунт и проверить исход боя

F529 обновляет контроль, F84D проверяет количества обоих участников, погибшие ID обнуляются и клетки инвалидируются, F864 уплотняет армии, оставшиеся бунтующие отряды героя передаются противнику, при пустой FD47 победа, при пустой FCED поражение, 88FA записывает армии обратно, победа увеличивает 6AA6, поражение 6AA8, поражение сбрасывает бит 5 в 6A33, вызывает F893 и обнуляет деньги 6A14, завершение восстанавливает SP из E0BD

**Вход:** IX и IY участники обновления

**Выход:** при продолжении IX/IY восстановлены, при завершении A=0 победа либо FF поражение, DE=FCB9, выход из внешнего Battle

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX и IY, параметры F849..F84C, записи обеих армий и их исходные списки, счётчики исходов, экран и объекты, на завершающем пути SP заменяется E0BD и возврат производится из внешнего вызова боя

В сохранённом графе: 152 инструкций. Чтение: #6A33, #6AA6, #6AA8, #E0BD, #F849, #F84B, #FCB9, #FCBB, #FCBD, #FCBE, #FCED, #FD47. Запись: #6A33, #6AA6, #6AA8, #F849, #F84B. Вызовы: #6D3F, #6D88, #6DC4, #88FA, #F529, #F626, #F648, #F84D, #F864, #F893, #F8BB.

### Battle.TestDeadStack

Адрес #F84D, блок `S47`. [Source/Battle/TestDeadStack.asm](../Source/Battle/TestDeadStack.asm#L13).

проверить неположительное пятибайтное количество отряда

бит 7 поля (IX+3) сразу возвращает carry, иначе OR пяти байтов IX+2..6 проверяет ноль, отрицательное и нулевое количества считаются погибшим отрядом

**Вход:** IX боевой отряд

**Выход:** CF=1 погиб, CF=0 положительное количество, IX сохранён

**Изменяемые регистры и состояние:** BC и AF, используется B и меняются A/F, HL, DE, IX, IY сохранены

В сохранённом графе: 12 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.CompactArmy

Адрес #F864, блок `S47`. [Source/Battle/CompactArmy.asm](../Source/Battle/CompactArmy.asm#L13).

уплотнить пять записей армии и очистить освободившийся хвост

непустые записи ID!=0 копируются к началу через LDIR по 18 байт, C считает оставшиеся, затем 5-C записей хвоста обнуляются

**Вход:** HL начало 90-байтной армии

**Выход:** плотный массив и нулевой хвост

**Изменяемые регистры и состояние:** HL, DE, BC, AF и девяносто байтов армии, IX и IY не изменяются

В сохранённом графе: 31 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.DefeatStory

Адрес #F893, блок `S47`. [Source/Battle/DefeatStory.asm](../Source/Battle/DefeatStory.asm#L14).

обработать сюжетные последствия поражения

FCB8=6 сразу вызывает 8799, иначе обходит FD47, 8036 получает описатель и бит 3 поля +15 разрешает 8799 с C=0, процедура 8799 загружает оверлей 20 окончания игры

**Вход:** FCB8 тип боя, FD47 армия противника

**Выход:** возможен переход к окончанию игры

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY и состояние загруженного оверлея 20 на соответствующих ветках, возможен переход к окончанию игры без обычного возврата

В сохранённом графе: 17 инструкций. Чтение: #FCB8. Запись: не выделена. Вызовы: #8036, #8799.

### Battle.MakeStaticUnit

Адрес #F8BB, блок `S47`. [Source/Battle/MakeStaticUnit.asm](../Source/Battle/MakeStaticUnit.asm#L17).

сформировать неподвижный объект отряда и его отображаемое количество

6D34 выключает обработку объектов, F626 находит объект клетки, 80DB даёт банк C и адрес HL ресурса, поля +8,+9,+10 получают ресурс, поле 0 сохраняет бит 7 и объединяет его с входным A, количество передаётся на стек ROM, при первом байте !=0 выполняется INT(x)+1, 6D76 переводит его в BC и записывает связанное слово численности, 6D57 снова разрешает обработку объектов, эта пара процедур меняет бит 2 поля 6566, все сохранённые регистры восстанавливаются

**Вход:** IY отряд, A флаг объекта

**Выход:** объект и численность обновлены, основные и индексные регистры сохранены

**Изменяемые регистры и состояние:** экранный объект клетки, связанное слово численности, бит 2 поля 6566 и состояние калькулятора, HL, DE, BC, AF, IX, IY восстанавливаются

В сохранённом графе: 43 инструкций. Чтение: не выделено. Запись: #F8E8. Вызовы: #6D34, #6D57, #6D76, #6DAE, #80DB, #F626.

### Battle.MakeActingUnit

Адрес #F912, блок `S47`. [Source/Battle/MakeActingUnit.asm](../Source/Battle/MakeActingUnit.asm#L15).

сформировать четырёхкадровый объект действующего отряда

F626 находит объект, 80DB даёт ресурс, поле 0 сохраняет бит 7 и объединяет его с A, поля 1..4 равны 1,1,9,4, четыре кадра по три байта содержат банк C и адреса HL с шагом 256, численность обрабатывается как в F8BB

**Вход:** IY отряд, A флаг объекта

**Выход:** анимационный объект и численность обновлены, регистры сохранены

**Изменяемые регистры и состояние:** экранный объект с четырьмя кадрами, связанное слово численности, бит 2 поля 6566 и состояние калькулятора, HL, DE, BC, AF, IX, IY восстанавливаются

В сохранённом графе: 53 инструкций. Чтение: не выделено. Запись: #F936. Вызовы: #6D34, #6D57, #6D76, #6DAE, #80DB, #F626.

### Battle.TickCursorAnim

Адрес #F984, блок `S47`. [Source/Battle/TickCursorAnim.asm](../Source/Battle/TickCursorAnim.asm#L15).

обновить кадр анимированного курсора выбранной клетки

Timer уменьшается при каждом вызове, пока он ненулевой, экран и кадр не меняются при нуле счётчик перезагружается из изменяемого слова Delay, Frame циклически меняется от 1 до 4 после HALT RestoreCursor убирает предыдущий кадр, выбранные 128 байтов пикселей накладываются OR область курсора занимает четыре на четыре знакоместа, атрибуты сохраняются из фона клетки

**Вход:** BC клетка, SaveCursorBack.Timer и Frame состояние анимации

**Выход:** при истечении Timer на экране следующий кадр курсора

**Изменяемые регистры и состояние:** HL, DE, BC, AF, Timer, Frame и пиксели курсора, IX и IY сохранены

В сохранённом графе: 57 инструкций. Чтение: #FA1C, #FA1E. Запись: #FA1C, #FA1E. Вызовы: #7693, #F9E4.

### Battle.RestoreCursor

Адрес #F9E4, блок `S47`. [Source/Battle/RestoreCursor.asm](../Source/Battle/RestoreCursor.asm#L13).

восстановить фон под курсором клетки

клетка переводится в знакоместа 4*C,4*(B+1), сохранённый Background выводится как блок 4 на 4 восстанавливаются и пиксели, и атрибуты клетки, поэтому предыдущий кадр курсора исчезает

**Вход:** BC клетка, SaveCursorBack.Background сохранённый фон 144 байта

**Выход:** фон восстановлен, регистры сохранены

**Изменяемые регистры и состояние:** пиксели и атрибуты клетки, HL, DE, BC, AF, IX и IY сохранены

В сохранённом графе: 21 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7545.

### Battle.SaveCursorBack

Адрес #FA08, блок `S47`. [Source/Battle/SaveCursorBack.asm](../Source/Battle/SaveCursorBack.asm#L13).

сохранить фон под курсором клетки

клетка переводится в знакоместа 4*C,4*(B+1), Engine.GrabTile4x4 копирует прямоугольник в Background в буфере последовательно хранятся 128 пиксельных и 16 атрибутных байтов

**Вход:** BC клетка

**Выход:** Background заполнен исходным изображением клетки

**Изменяемые регистры и состояние:** AF и 144 байта Background, HL, DE, BC, IX и IY сохранены

В сохранённом графе: 12 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #74F7.

### Battle.InitBattle

Адрес #FAAF, блок `S47`. [Source/Battle/InitBattle.asm](../Source/Battle/InitBattle.asm#L19).

инициализировать армии, препятствия, фон и начальные объекты боя

сохраняет A, DE, BC, IX в FCB8..FCBE, 883A создаёт FD47 и FCED из исходных трёхбайтных записей, бит 7 меняет координатную таблицу, пустая армия героя сразу возвращает FF со снятием адреса возврата, F4A3 записывает оценки в 6567/656C, FCE7 обнуляется, режимы <6 генерируют маску FCE8 как случайное AND с 7E и отвергают общий бит в любых трёх соседних строках, режимы >=6 и бит 7 используют таблицы, создаёт сорок объектов от 6611 с шагом 20, ресурсы местности имеют шаг 144, F4F4 создаёт отряды, продолжение FB87..FCB7 обязательно входит в эту процедуру

**Вход:** DE сила противника, BC число записей и банк, A тип, IX исходная армия противника

**Выход:** FCED/FD47 армии, FCE8 препятствия, 6611 объекты поля подготовлены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, параметры FCB8..FCBE, армии FCED/FD47, оценки 6567/656C, маска FCE8..FCEC, объекты поля, экран и состояние генератора, ранняя ветка пустой армии удаляет внутренний адрес возврата со стека

В сохранённом графе: 77 инструкций. Чтение: #FCB8, #FCB9, #FCED. Запись: #FCB8, #FCB9, #FCBB, #FCBD, #FCBE. Вызовы: #6D34, #6D88, #6DC4, #7117, #73CF, #73FE, #7BF4, #883A, #F4A3, #F893.

### Battle.BuildField

Адрес #FB87, блок `S47`. [Source/Battle/BuildField.asm](../Source/Battle/BuildField.asm#L20).

сформировать маску препятствий и фоновые объекты поля боя

обнуляет FCE7, при бите 7 режима FCB8 копирует пять байтов препятствий из FDF5 и выбирает карту ресурсов FE72, обычные режимы 1..5 генерируют пять масок как (случайное 1 AND7E AND случайное 2), общий ненулевой бит любых трёх соседних строк вызывает повтор всей генерации, режимы >=6 берут пятибайтную маску из таблицы FDE1 с шагом 5, затем экран очищается, для обычной местности источник BD30+720*тип, каждый свободный тайл использует основной ресурс, препятствие случайно выбирает один из следующих трёх ресурсов с шагом 144, создаются сорок объектов от 6611 с шагом 20, для специальных полей выбирается сорокабайтная карта FDD2+40*(тип-5) и переход FC7D

**Вход:** FCB8 тип поля либо особый режим, армии FCED/FD47 созданы, рабочий банк боя выбран вызывающим кодом

**Выход:** FCE7=0, FCE8..FCEC маска 8 на 5, сорок фоновых объектов подготовлены, дальнейший переход FC7D либо FCB0

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY, поля объектов и маски препятствий

В сохранённом графе: 106 инструкций. Чтение: #FCB8. Запись: #FC2F, #FCE7. Вызовы: #73CF, #7C0D, #FC7D, #FCB0.

### Battle.MakeFieldTiles

Адрес #FC7D, блок `S47`. [Source/Battle/MakeFieldTiles.asm](../Source/Battle/MakeFieldTiles.asm#L15).

создать сорок объектов поля по готовой карте тайлов

IY=6611, сорок байтов карты по IX задают индекс и бит 7 флага, в поле 0 объекта сохраняется бит 7 тайла и ставится 1, поле 5 получает 6, адрес ресурса вычисляется как CD80+144*(байт AND7F), записывается в +6/+7, карта продвигается на 1 и объект на 20, нулевой индекс в данных недопустим из-за DJNZ, после сорока объектов выполнение продолжается в FCB0

**Вход:** IX карта из сорока ненулевых индексов с необязательным битом 7

**Выход:** сорок объектов 6611..6930 подготовлены, IX после карты, IY=6931

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY и записи объектов

В сохранённом графе: 21 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Battle.FinishField

Адрес #FCB0, блок `S47`. [Source/Battle/FinishField.asm](../Source/Battle/FinishField.asm#L14).

добавить обе армии к объектам поля и разрешить их обработку

F4F4 создаёт статические объекты FCED с атрибутом 23 и FD47 с 63, затем 6D57 ставит бит 2 поля 6566, HALT ждёт прерывание, RET возвращает из FAAF к боевому циклу, собственного переключения банка здесь нет

**Вход:** армии FCED/FD47 и сорок фоновых объектов подготовлены

**Выход:** обработка объектов включена, прошёл кадр, управление возвращено из FAAF

**Изменяемые регистры и состояние:** AF, память экранных объектов, состояние фоновой обработки

В сохранённом графе: 4 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D57, #F4F4.

## Protection.Outer

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #6149 | `Protection.Outer.Decode` | наружные шесть проходов защиты | [Source/Loader/KB_Outer.asm](../Source/Loader/KB_Outer.asm#L20) |

### Protection.Outer.Decode

Адрес #6149, блок `KBO`. [Source/Loader/KB_Outer.asm](../Source/Loader/KB_Outer.asm#L20).

наружные шесть проходов защиты

отключает прерывания, задаёт R=70 и шесть раз обрабатывает 220 байт с 6165, каждый байт получает XOR с текущим R, H, L и номером оставшегося прохода B, R учитывает реальные M1-циклы инструкций

**Вход:** зашифрованные байты KB находятся в 6165..6240, код 6149..6164 исполняется из RAM, регистровые аргументы не требуются

**Выход:** после шести проходов расшифрованы 220 байтов 6165..6240, переход по потоку в 6165, HL=6241, DE=0, B=0, C сохранён, A=0, R=63, SP, IX, IY и альтернативные регистры сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, R, память 6165..6240, маскируемые прерывания запрещены через DI

В сохранённом графе: 18 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

## Protection.Move

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #6165 | `Protection.Move.Relocate` | перенос следующего слоя защиты | [Source/Loader/KB_Relocate.asm](../Source/Loader/KB_Relocate.asm#L20) |
| #6170 | `Protection.Move.EraseOuter` | самостирание наружного слоя | [Source/Loader/KB_Relocate.asm](../Source/Loader/KB_Relocate.asm#L40) |
| #617D | `Protection.Move.SetStack` | подготовка стекового цикла расшифровки | [Source/Loader/KB_Relocate.asm](../Source/Loader/KB_Relocate.asm#L59) |
| #6192 | `Protection.Move.DecodeShift` | побайтовая расшифровка со сдвигом на один адрес | [Source/Loader/KB_Relocate.asm](../Source/Loader/KB_Relocate.asm#L89) |
| #619E | `Protection.Move.DeadBranch` | недостигаемая в нормальном ходе ветвь защиты | [Source/Loader/KB_Relocate.asm](../Source/Loader/KB_Relocate.asm#L115) |

### Protection.Move.Relocate

Адрес #6165, блок `KBR`. [Source/Loader/KB_Relocate.asm](../Source/Loader/KB_Relocate.asm#L20).

перенос следующего слоя защиты

переносит 299 байтов из 61B4 в BFDE, исходник последних 158 байтов не входит в диапазон наружного шифрования

**Вход:** первый слой расшифрован, исходный блок 299 байтов 61B4..62DE доступен, назначение BFDE..C108 доступно для записи

**Выход:** 299 байтов скопированы в BFDE..C108, HL=62DF, DE=C109, BC=0, исполнение продолжается 6170, SP, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, флаги LDIR и память BFDE..C108, A сохраняется

В сохранённом графе: 4 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Protection.Move.EraseOuter

Адрес #6170, блок `KBR`. [Source/Loader/KB_Relocate.asm](../Source/Loader/KB_Relocate.asm#L40).

самостирание наружного слоя

записывает ноль в 6149 и запускает LDIR с BC=0, после 50 переносов байт ED самой инструкции LDIR по 617B становится нулём, повторение прекращается, байт B0 по 617C исполняется как OR B, нули остаются в 6149..617B

**Вход:** код 6170..617C находится по исходным адресам, RAM6149..617B доступна для записи, прерывания запрещены

**Выход:** самостирание 6149..617B завершает повторение LDIR после 50 переносов, затем исполняется оставшийся B0 как OR B, вход в 617D с HL=617B, DE=617C, BC=FFCE, A=FF, R=27 при штатном пути, SP, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, R и память 6149..617B

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Protection.Move.SetStack

Адрес #617D, блок `KBR`. [Source/Loader/KB_Relocate.asm](../Source/Loader/KB_Relocate.asm#L59).

подготовка стекового цикла расшифровки

нормализует R после самостирания, помещает в стек адрес 6192 и промежуточный адрес BFDD, задаёт HL=BFDE, DE=BFDD, BC=012B

**Вход:** штатный выход 6170 даёт A=B=FF, код 617D..6191 цел, под SP доступны четыре байта стека

**Выход:** HL=BFDE, DE=BFDD, BC=012B, SP восстановлен к входному значению, под SP остаются слова 6192 по SP-2 и BFDD по SP-4, переход в 6192 с R=32 при штатном пути, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, R и четыре байта под входным SP

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Protection.Move.DecodeShift

Адрес #6192, блок `KBR`. [Source/Loader/KB_Relocate.asm](../Source/Loader/KB_Relocate.asm#L89).

побайтовая расшифровка со сдвигом на один адрес

XOR байта(HL) с R, LDI одновременно переносит его на один байт вниз и уменьшает BC, DEC SP дважды возвращает стек к сохранённому адресу 6192, RET PE повторяет цикл пока BC не ноль, затем второй DEC SP дважды и RET PO передают управление в BFDD, ключ первого байта 34 и шаг 9 по модулю 128

**Вход:** HL=BFDE, DE=BFDD, BC=012B, R=32, по SP-2 сохранён 6192 и по SP-4 BFDD,299 байтов источника и назначения доступны

**Выход:** 299 байтов расшифрованы и сдвинуты вниз в BFDD..C107, ключ 34+9*j по модулю 128, HL=C109, DE=C108, BC=0, A=0, RET PO передаёт управление BFDD, итоговый SP равен входному SP-2, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, R, SP, память BFDD..C108, адреса стека используются как управляющие переходы

В сохранённом графе: 10 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Protection.Move.DeadBranch

Адрес #619E, блок `KBR`. [Source/Loader/KB_Relocate.asm](../Source/Loader/KB_Relocate.asm#L115).

недостигаемая в нормальном ходе ветвь защиты

в нормальном ходе не достигается, обе развилки RET PE и RET PO покрывают состояния PV после LDI, поэтому нельзя объявлять этот фрагмент исполняемым без отдельной точки входа

**Вход:** в обычном ходе входа нет, RET PE и RET PO по 619A/619D покрывают оба состояния PV после LDI, при отдельном внешнем входе необходимы доступный байт BFDC и целый код 619E..61B3

**Выход:** при отдельном входе R=7 и 299 итераций XOR одного байта BFDC с показаниями R, затем JP BFDC, HL=BFDC, BC=0, A=0, DE, SP, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, BC, AF, R и один байт BFDC, тело не увеличивает HL и не расшифровывает последовательный блок

В сохранённом графе: 12 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

## Protection.Xor

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #BFDD | `Protection.Xor.DecodeAdjacent` | соседнее XOR-преобразование через стек | [Source/Loader/KB_Difference.asm](../Source/Loader/KB_Difference.asm#L24) |

### Protection.Xor.DecodeAdjacent

Адрес #BFDD, блок `KBD`. [Source/Loader/KB_Difference.asm](../Source/Loader/KB_Difference.asm#L24).

соседнее XOR-преобразование через стек

сохраняет текущий SP в операнде LD SP по BFFE, задаёт SP=C000 и 257 раз читает пару соседних байтов POP DE, обнуляет A после фиктивного LD A, R, записывает E XOR D обратно через PUSH DE, увеличивает SP на 1, тем самым преобразует C000..C100 как p[i]=s[i] XOR s[i+1], затем восстанавливает SP и входит в C000

**Вход:** в памяти BFDD..C107 находится второй слой, C000..C101 доступны, SP указывает исходный стек после RET PO

**Выход:** C000..C100 преобразованы какold[i] XOR old[i+1], выполнено 257 итераций, исходный SP восстановлен через изменённый операнд BFFE, затем вход по потоку в C000, HL сохраняет входной SP, BC=0, A=0, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, R, временное SP=C000..C101, операнд BFFE..BFFF и память C000..C100, прерывания запрещены

В сохранённом графе: 21 инструкций. Чтение: не выделено. Запись: #BFFE. Вызовы: не выделены.

## Protection.Load

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #C000 | `Protection.Load.MakeCheckName` | построение имени проверяемого BASIC-файла | [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L22) |
| #C03E | `Protection.Load.FindBasic` | проверка положения BASIC-файла в каталоге | [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L76) |
| #C050 | `Protection.Load.MakeLoaderName` | построение имени BL3 и настройка ветви защиты | [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L102) |
| #C07F | `Protection.Load.Load` | загрузка BL3 через TR-DOS | [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L147) |
| #C08D | `Protection.Load.Decode` | пятнадцать проходов расшифровки BL3 | [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L171) |
| #C0AB | `Protection.Load.CheckPosition` | ветвь проверки каталога и повреждения при ошибке | [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L215) |
| #C0DA | `Protection.Load.WriteName` | запись имени файла из самомодифицируемых операндов | [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L237) |

### Protection.Load.MakeCheckName

Адрес #C000, блок `KBL`. [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L22).

построение имени проверяемого BASIC-файла

вычисляет семь операндов имени CTPAHA  B из IYh=5C, арифметики и показаний R, изменяя байты C0DE, C0E2, C0E6, C0EA, C0EE, C0F2, C0FE в процедуре C0DA, два исходных пробела C0F6, C0FA сохраняются, затем вызывает C0DA для записи девятибайтового имени в 5CDD

**Вход:** IY=5C3A, расшифрованный блок C000..C100 доступен, байты операндов C0DE..C0FE и переменные 5CDD..5CE5 доступны

**Выход:** вычислены семь операндов имени, два исходных пробела C0F6, C0FA сохранены, в 5CDD..5CE5 записано CTPAHA  B, HL=5CE5, BC=0008, A=42, затем C03E, DE, SP, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, BC, AF, R, семь операндов имени C0DE, C0E2, C0E6, C0EA, C0EE, C0F2, C0FE и 9 байтов 5CDD..5CE5

В сохранённом графе: 38 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #C0DA.

### Protection.Load.FindBasic

Адрес #C03E, блок `KBL`. [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L76).

проверка положения BASIC-файла в каталоге

сохраняет R, вызывает TR-DOS C=0A для поиска CTPAHA.B, восстанавливает R, значение C XOR2 записывает в операнд по C07B, нормальная позиция файла в каталоге 2 даёт ноль

**Вход:** в 5CDD..5CE5 имя CTPAHA  B, доступен TR-DOS и его каталог, под SP доступны байты для сохранённого AF и CALL

**Выход:** выполнен поиск C=0A, операнд C07B получает returnedC XOR2, индекс 2 даёт 0, R восстанавливается из сохранённого AF и далее учитывает три команды, прерывания после DOS запрещены, затем C050

**Изменяемые регистры и состояние:** BC, AF, R, операнд C07B и рабочие переменные TR-DOS, остальные регистры обёртка поиска собственными PUSH не защищает

В сохранённом графе: 10 инструкций. Чтение: не выделено. Запись: #C07B. Вызовы: #3D13.

### Protection.Load.MakeLoaderName

Адрес #C050, блок `KBL`. [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L102).

построение имени BL3 и настройка ветви защиты

меняет операнды процедуры C0DA для формирования BL3     C, использует IYl=3A и R, загружает HL=003E при правильной позиции CTPAHA и сохраняет это слово в C0AB, превращая будущий код в LD A,0

**Вход:** IYl=3A, R восстановлен предыдущим блоком, C07B уже равен returnedC XOR2, доступна процедура C0DA с операндами имени

**Выход:** в 5CDD..5CE5 записано BL3     C, в C0AB..C0AC записана инструкция LD A, returnedC XOR2, при индексе CTPAHA=2 это LD A,0, C подготовлен как 0E, затем C07F, DE, SP, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, BC, AF, R, семь операндов имени C0DE, C0E2, C0E6, C0EA, C0EE, C0F2, C0FE,9 байтов 5CDD..5CE5 и два байта C0AB..C0AC, исходные пробелы C0F6, C0FA сохранены

В сохранённом графе: 28 инструкций. Чтение: не выделено. Запись: #C0AB. Вызовы: #C0DA.

### Protection.Load.Load

Адрес #C07F, блок `KBL`. [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L147).

загрузка BL3 через TR-DOS

сохраняет R, обнуляет 5D10 и вызывает TR-DOS C=0E с A=0 для загрузки BL3 по адресу каталога 6149, затем восстанавливает R

**Вход:** C=0E, имя BL3     C в 5CDD, TR-DOS доступен, файл BL3 имеет адрес 6149 и длину 1BEB, стек доступен

**Выход:** A=0 перед DOS выбирает параметры файла, BL3 загружен в 6149..7D33, слово 5CE6 содержит 6149, слово 5CE8 длину 1BEB, сохранённое значение R восстановлено через POP AF/LD R, A, прерывания запрещены, затем C08D

**Изменяемые регистры и состояние:** AF, R, память загруженного файла и рабочие переменные TR-DOS, вызывающий блок не сохраняет остальные регистры сервиса

В сохранённом графе: 8 инструкций. Чтение: не выделено. Запись: #5D10. Вызовы: #3D13.

### Protection.Load.Decode

Адрес #C08D, блок `KBL`. [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L171).

пятнадцать проходов расшифровки BL3

пятнадцать проходов по 7147 байтам от адреса в 5CE6, на каждом байте читает R, XOR L и записывает результат в R, затем XOR B, C, D, E, H и байт(HL), записывает расшифрованный байт, увеличивает HL и C, уменьшает DE, внешний B от 0F до 01

**Вход:** в 5CE6 адрес 6149, блок 7147 байтов 6149..7D33 загружен, A и R соответствуют восстановленному состоянию C07F, код дешифратора C08D..C0AA цел

**Выход:** выполнено 15 проходов по 7147 байтам, BL3 преобразован внешним XOR-потоком, HL=7D34, DE=0, B=0, A=0, C увеличен на 15*7147 по модулю 256 относительно входного A, затем C0AB, SP, IX, IY сохранены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, R и память 6149..7D33

В сохранённом графе: 21 инструкций. Чтение: #5CE6. Запись: не выделена. Вызовы: не выделены.

### Protection.Load.CheckPosition

Адрес #C0AB, блок `KBL`. [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L215).

ветвь проверки каталога и повреждения при ошибке

после нормального C=2 от поиска выполнит LD A,0, OR A и переход C0CD, затем JP6149, при другом результате копирует десять байтов из C0D0 в 6C16 и портит двадцать псевдослучайных байтов страницы 64xx, поэтому поведение зависит от исходного порядка файлов

**Вход:** C050 заменил исходные C7, C7 в C0AB..C0AC инструкцией LD A, returnedC XOR2, BL3 уже расшифрован

**Выход:** при returnedC=2 выполняется JP6149 без повреждения, иначе десять байтов C0D0..C0D9 копируются в 6C16..6C1F и 20 псевдослучайных байтов страницы 6400..64FF меняются XOR с R, затем также JP6149, SP, IX, IY сохранены

**Изменяемые регистры и состояние:** AF на обоих путях, при нарушении проверки HL, DE, BC, R, память 6C16..6C1F и 20 выбранных байтов 6400..64FF

В сохранённом графе: 1 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Protection.Load.WriteName

Адрес #C0DA, блок `KBL`. [Source/Loader/KB_LoadBL3.asm](../Source/Loader/KB_LoadBL3.asm#L237).

запись имени файла из самомодифицируемых операндов

записывает девять байтов имени и расширения из самомодифицируемых операндов LD A, n в 5CDD..5CE5, операнды находятся C0DE, C0E2, C0E6, C0EA, C0EE, C0F2, C0F6, C0FA, C0FE

**Вход:** девять операндов LD A, n по C0DE, C0E2, C0E6, C0EA, C0EE, C0F2, C0F6, C0FA, C0FE уже содержат имя 8 байтов и тип 1 байт

**Выход:** девять байтов записаны в 5CDD..5CE5, HL=5CE5, A=последний байт типа, DE, BC, F, SP, IX, IY сохранены

**Изменяемые регистры и состояние:** HL и A, память 5CDD..5CE5, флаги F собственным кодом не изменяются

В сохранённом графе: 28 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

## Overlay.Capture

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Capture.Entry` | захват замка, бой и выдача награды | [Source/Overlays/Capture.asm](../Source/Overlays/Capture.asm#L23) |
| #B593 | `Overlay.Capture.NewMapPiece` | выбор новой свободной отметки среди 25 битов | [Source/Overlays/Capture.asm](../Source/Overlays/Capture.asm#L445) |

### Overlay.Capture.Entry

Адрес #B200, блок `O01`. [Source/Overlays/Capture.asm](../Source/Overlays/Capture.asm#L23).

захват замка, бой и выдача награды

Читает защитника из объекта, выводит сведения о нём, проверяет необходимость осадных орудий и возможность помощи. Подготавливает две армии и вызывает бой #D255. После победы меняет владельца замка, проверяет оставшиеся замки противника и наличие контракта, начисляет обычное и дополнительное вознаграждение. Если у противника не осталось замков, участок #B54E..#B55C вызывает NewMapPiece несколько раз, открывая фрагменты карты цели в #6A55..#6A59. Эти биты не являются контрактными отметками.

**Вход:** текущее состояние героя, армии и объекта в ядре

**Выход:** состояние обновлено выбранной ветвью либо сохранено при отказе

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

В сохранённом графе: 355 инструкций. Чтение: #6A02, #6A2A, #6A2D, #6A33, #6A3A, #867B, #B3B1, #B5C8. Запись: #6A02, #6A33, #6A3A, #867B, #B348, #B3AE, #B3B1, #B503, #B5C8, #B6BF, #B726, #B8B4, #B8D6. Вызовы: #6D2F, #6D34, #6D3F, #6D57, #6D88, #6DAE, #6DC4, #7117, #7366, #73AD, #73CF, #73FE, #776D, #7A94, #7BF4, #7C0D, #7F40, #7F5F, #804E, #807E, #82D5, #86B1, #89E0, #8A08, #957C, #B593, #D255.

### Overlay.Capture.NewMapPiece

Адрес #B593, блок `O01`. [Source/Overlays/Capture.asm](../Source/Overlays/Capture.asm#L445).

выбор новой свободной отметки среди 25 битов

Сначала AND пяти байтов #6A55 с #1F проверяет полное заполнение 25 младших битов. Если заполнено всё, возвращает Z. Иначе случайно выбирает номер байта 0..4 и бита 0..4 через #7C0D. Самомодифицируемые BIT/SET получают выбранный номер. Уже установленный бит вызывает повторный выбор, свободный устанавливается.

**Вход:** #6A55..#6A59 — пять масок

**Выход:** выбранный свободный бит установлен либо Z при полном заполнении

**Изменяемые регистры и состояние:** HL, DE, AF

В сохранённом графе: 28 инструкций. Чтение: не выделено. Запись: #B5C2, #B5C6. Вызовы: #7C0D.

## Overlay.City

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.City.Entry` | посещение города и операции с его ресурсами | [Source/Overlays/City.asm](../Source/Overlays/City.asm#L23) |
| #B7AB | `Overlay.City.RefuseEntry` | сообщение об отказе города из-за отношения к герою | [Source/Overlays/City.asm](../Source/Overlays/City.asm#L697) |
| #B7BA | `Overlay.City.RefreshMoney` | обновление строки денежных средств в городском меню | [Source/Overlays/City.asm](../Source/Overlays/City.asm#L715) |
| #B7DB | `Overlay.City.SiegePrice` | выбор стоимости осадных орудий по отношению города | [Source/Overlays/City.asm](../Source/Overlays/City.asm#L740) |
| #B7EB | `Overlay.City.ShipPrice` | расчёт цены найма корабля по составу армии и отношению города | [Source/Overlays/City.asm](../Source/Overlays/City.asm#L766) |

### Overlay.City.Entry

Адрес #B200, блок `O02`. [Source/Overlays/City.asm](../Source/Overlays/City.asm#L23).

посещение города и операции с его ресурсами

Строит городское меню. Ветви проверяют отношение города к герою, стоимость корабля и осадных орудий, доступность ближайшего замка и контракта. Для найма ищет пустой либо совпадающий ID среди пяти отрядов, вычисляет и показывает возможное добавление по управляемости через #86B1. Однако введённое количество непосредственно ограничивает наличием существ в городе и доступными деньгами, отдельного сравнения с показанной управляемостью в этой ветви нет. Изменённые показатели города и героя остаются в ядре и самом оверлее, сохранение оверлея выполняет диспетчер.

**Вход:** текущее состояние героя, армии и объекта в ядре

**Выход:** состояние обновлено выбранной ветвью либо сохранено при отказе

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

В сохранённом графе: 573 инструкций. Чтение: #6A02, #6A2D, #6A31, #6A33, #6A3A, #6AA6, #6AA8, #8BDC, #B9EF, #B9F1, #BA23, #BA36, #BBCD, #BC41, #BD0E, #BD51, #BDD5. Запись: #6A30, #6A31, #6A33, #6A3A, #B901, #B9EF, #B9F1, #BA23, #BA36, #BA56, #BBB8, #BBCD, #BBE0, #BC41, #BD0E, #BD71. Вызовы: #6BB0, #6D2F, #6D34, #6D3F, #6D62, #6D76, #6D88, #6DAE, #6DC4, #6DDA, #6FC0, #70E3, #7117, #73AD, #73CF, #73FE, #776D, #7A17, #7A94, #7AEF, #7BF4, #7C0D, #7C71, #7E55, #7F40, #7F5F, #8036, #804E, #807E, #86B1, #8712, #871C, #8801, #89E0, #B7AB, #B7BA, #B7DB, #B7EB, #D255.

### Overlay.City.RefuseEntry

Адрес #B7AB, блок `O02`. [Source/Overlays/City.asm](../Source/Overlays/City.asm#L697).

сообщение об отказе города из-за отношения к герою

Выбирает представление #42 через #8712 и выводит строку #B9F3 с координатами B=#12, C=7. Возвращает управление обработчику городского меню.

**Вход:** состояние окна ядра

**Выход:** сообщение выведено

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7117, #8712.

### Overlay.City.RefreshMoney

Адрес #B7BA, блок `O02`. [Source/Overlays/City.asm](../Source/Overlays/City.asm#L715).

обновление строки денежных средств в городском меню

Окрашивает строку 15, выводит подпись из #8781. Пятибайтовое число денег по #6A14 помещается в стек калькулятора и печатается #70E3 с колонки 11 строки 15.

**Вход:** #6A14 — пятибайтовое число денег

**Выход:** обновлена строка денежных средств

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 12 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6DAE, #70E3, #7117, #73AD.

### Overlay.City.SiegePrice

Адрес #B7DB, блок `O02`. [Source/Overlays/City.asm](../Source/Overlays/City.asm#L740).

выбор стоимости осадных орудий по отношению города

При нулевом ShipPrice.Relation выбирает 12000, иначе 24000. Сохраняет выбранное 16-битное значение по ShipPrice.SiegeCost, которое подставляется в строку цены городского меню.

**Вход:** ShipPrice.Relation — состояние отношения города

**Выход:** ShipPrice.SiegeCost=12000 либо 24000

**Изменяемые регистры и состояние:** HL, AF

В сохранённом графе: 7 инструкций. Чтение: #BC41. Запись: #BD51. Вызовы: не выделены.

### Overlay.City.ShipPrice

Адрес #B7EB, блок `O02`. [Source/Overlays/City.asm](../Source/Overlays/City.asm#L766).

расчёт цены найма корабля по составу армии и отношению города

Помещает 100 в калькулятор и обходит до пяти троек #6A1E до первого ID0. Для каждого отряда добавляет N_i*(P_i/50), где N_i — его 16-битная численность, P_i — слово описателя SOLDIERS+#16/+#17. Токены #05, #04, #0F означают деление P_i/50, умножение на N_i и прибавление к накопителю. После обхода #27 берёт INT, цена=floor(100+sum(N_i*P_i/50)). При ненулевом ShipPrice.Relation уже целый результат умножается на 2. #6D76 возвращает BC, которое сохраняется в ShipPrice.ShipCost. Ветка найма корабля читает эту сумму по #B469, это не плата за содержание армии.

**Вход:** #6A1E — армия, SOLDIERS+#16/+#17 — цена типа, ShipPrice.Relation — состояние отношения города

**Выход:** ShipPrice.ShipCost —16-битная цена найма корабля

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

В сохранённом графе: 33 инструкций. Чтение: #BC41. Запись: #BDD5. Вызовы: #6D62, #6D76, #8036.

## Overlay.Temple

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Temple.Entry` | посещение храма духов | [Source/Overlays/Temple.asm](../Source/Overlays/Temple.asm#L21) |
| #B4AC | `Overlay.Temple.CheckLanding` | проверка свободной клетки для телепортации | [Source/Overlays/Temple.asm](../Source/Overlays/Temple.asm#L346) |

### Overlay.Temple.Entry

Адрес #B200, блок `O03`. [Source/Overlays/Temple.asm](../Source/Overlays/Temple.asm#L21).

посещение храма духов

Читает тип храма и принадлежность героя к секте. Подготавливает стоимость услуг и коэффициенты скидки либо наценки через калькулятор ПЗУ. Меню предлагает перенос к ближайшему храму, изучение заклинания и вступление в секту. Перенос проверяет окружающие клетки подпрограммой CheckLanding, чтобы не поставить героя в занятое или запрещённое место.

**Вход:** текущее состояние героя, армии и объекта в ядре

**Выход:** состояние обновлено выбранной ветвью либо сохранено при отказе

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

В сохранённом графе: 269 инструкций. Чтение: #6A2D, #6A3B, #B4B9, #B4FE. Запись: #69D5, #6A2E, #6A3B, #B2BD, #B485, #B4B9, #B4DB, #B4FE, #B519, #B53E. Вызовы: #6D2F, #6D34, #6D3F, #6D62, #6D88, #6DAE, #6DC4, #6DDA, #70E3, #7117, #73AD, #776D, #7A80, #7BF4, #7F40, #7F5F, #8036, #8066, #807E, #8712, #871C, #8801, #B4AC.

### Overlay.Temple.CheckLanding

Адрес #B4AC, блок `O03`. [Source/Overlays/Temple.asm](../Source/Overlays/Temple.asm#L346).

проверка свободной клетки для телепортации

Читает клетку BC через #80C4. Если установлен бит 7 либо ненулевые младшие 6 бит, возвращает управление перебору соседей. Для свободной клетки снимает адрес своего возврата POP HL и переходит непосредственно к успешной ветви Entry.MoveHero, обходя остаток перебора.

**Вход:** BC — координаты проверяемой клетки

**Выход:** свободная клетка приводит к Entry.MoveHero, иначе обычный возврат

**Изменяемые регистры и состояние:** HL, AF

В сохранённом графе: 272 инструкций. Чтение: #6A2D, #6A3B, #B4B9, #B4FE. Запись: #69D5, #6A2E, #6A3B, #B2BD, #B485, #B4B9, #B4DB, #B4FE, #B519, #B53E. Вызовы: #6D2F, #6D62, #6D88, #6DAE, #6DC4, #6DDA, #70E3, #7117, #73AD, #776D, #7A80, #7BF4, #7F40, #7F5F, #8036, #8066, #807E, #80C4, #8712, #871C, #B4AC.

## Overlay.Recruit

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Recruit.Entry` | найм существ из объекта карты | [Source/Overlays/Recruit.asm](../Source/Overlays/Recruit.asm#L24) |

### Overlay.Recruit.Entry

Адрес #B200, блок `O04`. [Source/Overlays/Recruit.asm](../Source/Overlays/Recruit.asm#L24).

найм существ из объекта карты

Получает ID и доступное количество существ из шестибайтовой записи объекта, выводит имя и параметры. Ищет свободную либо совпадающую по ID запись среди пяти отрядов. Вычисляет и показывает управляемость через #86B1, сохраняя BC в Entry.Capacity, но после ввода не сравнивает число с этим значением. Ввод принимает только ненулевое число не больше наличия существ и количества, доступного за деньги. Непосредственно записывает новый ID и увеличенную численность в найденную запись, при первом добавлении вызывает сброс счётчиков #7A94. Списывает плату и уменьшает количество существ в объекте.

**Вход:** текущее состояние героя, армии и объекта в ядре

**Выход:** состояние обновлено выбранной ветвью либо сохранено при отказе

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

В сохранённом графе: 180 инструкций. Чтение: #B3D8, #B408, #B41B, #B44D, #B47F, #B481, #B483. Запись: #B25F, #B2D2, #B3D8, #B408, #B41B, #B44D, #B473, #B47F, #B481, #B483. Вызовы: #6D2F, #6D34, #6D3F, #6D57, #6D62, #6D76, #6DAE, #6DC4, #6FC0, #70E3, #7117, #72ED, #73AD, #73CF, #7545, #7A94, #7BF4, #7F40, #8036, #86B1, #8712, #8801.

## Overlay.Treasure

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Treasure.Entry` | получение находки и изменение параметров героя | [Source/Overlays/Treasure.asm](../Source/Overlays/Treasure.asm#L23) |

### Overlay.Treasure.Entry

Адрес #B200, блок `O05`. [Source/Overlays/Treasure.asm](../Source/Overlays/Treasure.asm#L23).

получение находки и изменение параметров героя

Сразу помечает объект находки использованным и снимает bit7 его клетки карты. Уменьшает континентальный счётчик находок, затем выбирает награду генератором, а не читает тип приза из объекта. Редкие ветви устанавливают в #6A34 флаг полной карты текущего континента либо разрешение пути на следующий. Остальные ветви случайно выдают заклинание, увеличивают текущую магическую силу, её восстановление или предел, недельный доход, деньги либо 16-битное поле героя #6A02 при раздаче находки солдатам. Маску фрагментов карты цели #6A55..#6A59 этот оверлей не изменяет.

**Вход:** текущее состояние героя, армии и объекта в ядре

**Выход:** состояние обновлено выбранной ветвью либо сохранено при отказе

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

В сохранённом графе: 291 инструкций. Чтение: #6A02, #6A04, #6A06, #6A08, #6A1E, #6A2D, #B6FB, #B744, #B783. Запись: #6A02, #6A04, #6A06, #6A08, #B289, #B292, #B2C7, #B2D0, #B4BA, #B63C, #B68D, #B6FB, #B744, #B783, #B7D8. Вызовы: #6BB0, #6D2F, #6D62, #6D76, #6D88, #6DAE, #6DC4, #7117, #73AD, #73FE, #776D, #7BF4, #7C0D, #8066, #80AE, #80B4, #82D5.

## Overlay.Join

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Join.Entry` | присоединение встреченного отряда | [Source/Overlays/Join.asm](../Source/Overlays/Join.asm#L22) |

### Overlay.Join.Entry

Адрес #B200, блок `O06`. [Source/Overlays/Join.asm](../Source/Overlays/Join.asm#L22).

присоединение встреченного отряда

До предложения пользователю помечает исходный объект использованным через SET0 его первого байта и снимает bit7 с клетки карты. Показывает отряд, ищет пустой либо совпадающий ID среди пяти троек #6A1E. Если места нет, выводит сообщение и возвращается, объект при этом уже помечен использованным. Проверки управляемости через #86B1/#86EA в оверлее нет. После согласия прямо прибавляет 16-битную численность в найденную запись и устанавливает ID, при первом добавлении сбрасывает служебные счётчики #7A94. Отказ тоже не отменяет уже поставленную отметку объекта.

**Вход:** текущее состояние героя, армии и объекта в ядре

**Выход:** объект помечен использованным при любом ответе, после согласия численность добавлена в армию

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

В сохранённом графе: 80 инструкций. Чтение: #6A33, #B2CC. Запись: #6A33, #B2CC. Вызовы: #6D2F, #6D3F, #7117, #73AD, #73FE, #776D, #7A94, #7BF4, #7E55, #80AE, #80B4, #82D5.

## Overlay.Bandits

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Bandits.Entry` | бой с разбойниками либо пиратами | [Source/Overlays/Bandits.asm](../Source/Overlays/Bandits.asm#L23) |

### Overlay.Bandits.Entry

Адрес #B200, блок `O07`. [Source/Overlays/Bandits.asm](../Source/Overlays/Bandits.asm#L23).

бой с разбойниками либо пиратами

Разновидность «разбойники/пираты» выбирает по bit5 первого байта записи объекта (IX-3 после сдвига к данным), а не по режиму перемещения героя. Выводит до пяти отрядов противника, предлагает бой и вызывает банк 3,#D255. При A=0 выполняет ветвь денежной награды, добавляет сумму к #6A14, вызывает увеличение поля героя #8A08, помечает объект использованным и снимает bit7 карты. При A!=0 вызывает #89E0 для уменьшения поля #6A02, ставит bit3 в объекте и пытается перенести героя в соседнюю незанятую клетку с совместимым классом суша/вода, затем возвращается. Явного перехода к общей обработке гибели в этой ветви оверлея нет.

**Вход:** текущее состояние героя, армии и объекта в ядре

**Выход:** состояние обновлено выбранной ветвью либо сохранено при отказе

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

В сохранённом графе: 165 инструкций. Чтение: #6A2E, #6A33, #B3B3. Запись: #6A2E, #6A33, #B301, #B3B3, #B3C4, #B407. Вызовы: #6D2F, #6D3F, #6D88, #6DAE, #6DC4, #7117, #73AD, #73FE, #776D, #7BF4, #7C0D, #7E55, #7F40, #80AE, #80B4, #80C4, #82D5, #8697, #89E0, #8A08, #D255.

## Overlay.Army

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Army.Entry` | просмотр и выбор отрядов армии | [Source/Overlays/Army.asm](../Source/Overlays/Army.asm#L19) |

### Overlay.Army.Entry

Адрес #B200, блок `O08`. [Source/Overlays/Army.asm](../Source/Overlays/Army.asm#L19).

просмотр и выбор отрядов армии

Обходит пять трёхбайтовых записей #6A1E. Получает описатель типа существа, печатает название, численность, характеристики, настроение и ограничения. Меню перемещает выделение между отрядами, показывает сведения выбранного типа и возвращается к игре по выходу.

**Вход:** текущее состояние героя, армии и объекта в ядре

**Выход:** состояние обновлено выбранной ветвью либо сохранено при отказе

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

В сохранённом графе: 262 инструкций. Чтение: #6A1E, #6A3B, #B4BA. Запись: #B4B5, #B4BA, #B50D, #B567, #B5A1, #B5B9, #B5D6, #B5EE, #B610, #B629. Вызовы: #6BB0, #6D2F, #6D34, #6D3F, #6D57, #70C5, #7117, #7366, #73AD, #73CF, #73FE, #776D, #7BF4, #7EA7, #8036, #86EA, #896D, #944A.

## Overlay.Save

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Save.Entry` | запись четырёх областей состояния в файл .M | [Source/Overlays/Save.asm](../Source/Overlays/Save.asm#L25) |
| #B2D8 | `Overlay.Save.InvertState` | обратимая инверсия полезной области сохранения | [Source/Overlays/Save.asm](../Source/Overlays/Save.asm#L116) |
| #B2E2 | `Overlay.Save.AddSectors` | прибавление смещения секторов к паре дорожка-сектор | [Source/Overlays/Save.asm](../Source/Overlays/Save.asm#L139) |

### Overlay.Save.Entry

Адрес #B200, блок `O09`. [Source/Overlays/Save.asm](../Source/Overlays/Save.asm#L25).

запись четырёх областей состояния в файл .M

Подтверждает сохранение, формирует имя из #69EF и расширение M. Через поиск и чтение дескриптора определяет место файла. Записывает1 сектор из #69ED,41 сектор банка0 из #C000,64 сектора банка1 и33 сектора банка11. Перед записью инвертирует соответственно #FF,#2859,#3FEF,#20CF полезных байтов, затем повторной инверсией восстанавливает память. Разницу между инвертируемой и секторной длиной сохраняет исходный формат. Дисковые смещения1,#2A,#6A прибавляются к старту файла через #B2E2. Завершает перерисовкой #944A.

**Вход:** текущее состояние героя, армии и объекта в ядре

**Выход:** состояние обновлено выбранной ветвью либо сохранено при отказе

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

В сохранённом графе: 77 инструкций. Чтение: #5CEB. Запись: не выделена. Вызовы: #5FA1, #6D15, #6D34, #7117, #73FE, #776D, #944A, #B2D8, #B2E2.

### Overlay.Save.InvertState

Адрес #B2D8, блок `O09`. [Source/Overlays/Save.asm](../Source/Overlays/Save.asm#L116).

обратимая инверсия полезной области сохранения

Для каждого из DE байтов по HL выполняет побитовое дополнение, увеличивает указатель и уменьшает остаток. Повторное применение с той же длиной восстанавливает исходное состояние. Нулевая входная длина обработала бы 65536 байтов из-за разрядности счётчика.

**Вход:** HL — область, DE — ненулевая длина

**Выход:** HL после области, DE=0, A=0

**Изменяемые регистры и состояние:** HL, DE, AF

В сохранённом графе: 9 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Overlay.Save.AddSectors

Адрес #B2E2, блок `O09`. [Source/Overlays/Save.asm](../Source/Overlays/Save.asm#L139).

прибавление смещения секторов к паре дорожка-сектор

Старшую тетраду A прибавляет к D, младшую к E. При результате E>=16 переносит ещё одну дорожку и оставляет в E младшие 4 бита. Формула соответствует 16 секторам на дорожку, арифметика D остаётся 8-битной.

**Вход:** DE — D дорожка, E сектор 0..15, AF — смещение секторов в A

**Выход:** DE — новая дисковая позиция

**Изменяемые регистры и состояние:** DE, AF

В сохранённом графе: 16 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

## Overlay.Dismiss

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Dismiss.Entry` | роспуск выбранного отряда | [Source/Overlays/Dismiss.asm](../Source/Overlays/Dismiss.asm#L21) |
| #B406 | `Overlay.Dismiss.ShowUnitDialog` | оформление сообщения и анимированного отряда при роспуске | [Source/Overlays/Dismiss.asm](../Source/Overlays/Dismiss.asm#L273) |

### Overlay.Dismiss.Entry

Адрес #B200, блок `O10`. [Source/Overlays/Dismiss.asm](../Source/Overlays/Dismiss.asm#L21).

роспуск выбранного отряда

Показывает пять отрядов и предлагает выбрать удаляемый. Проверяет исходный тип и связанные условия, обновляет запись армии либо запускает реакцию отряда. Подпрограмма ShowUnitDialog показывает выбранное сообщение и ожидает подтверждение. После завершения восстанавливает экран и состояние ввода.

**Вход:** текущее состояние героя, армии и объекта в ядре

**Выход:** состояние обновлено выбранной ветвью либо сохранено при отказе

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

В сохранённом графе: 207 инструкций. Чтение: #6A02, #6A1E, #6A2E, #B261, #B420, #B421, #B60C. Запись: #B260, #B261, #B60C. Вызовы: #6D2F, #6D34, #6D3F, #6D62, #6D88, #6DAE, #6DC4, #6DDA, #7117, #73AD, #73CF, #73FE, #776D, #7AEF, #7BF4, #7EA7, #8036, #807E, #80C4, #8697, #89E0, #8A08, #944A, #957C, #B406, #D255.

### Overlay.Dismiss.ShowUnitDialog

Адрес #B406, блок `O10`. [Source/Overlays/Dismiss.asm](../Source/Overlays/Dismiss.asm#L273).

оформление сообщения и анимированного отряда при роспуске

Сохраняет HL со строкой. По BC=#0700, входным DE и A рисует рамку через #73FE. Берёт ID отряда из ShowUnitDialog.Dismissed и вызывает #7366 с позицией 2, 2, создавая четырёхкадровый экранный объект. Печатает строку в строке 13 и вызывает #6D57, которая устанавливает bit2 #6566 для обработки объектов в прерывании. Ожидания либо подтверждения эта вспомогательная процедура не содержит, выбор выполняют её вызывающие ветви.

**Вход:** HL — строка, DE — размеры рамки, A — атрибут рамки, ShowUnitDialog.Dismissed — ID отряда

**Выход:** сообщение выведено, анимированный объект создан, обработка объектов включена

**Изменяемые регистры и состояние:** HL, DE, BC, AF

В сохранённом графе: 11 инструкций. Чтение: #B420. Запись: не выделена. Вызовы: #6D57, #7117, #7366, #73FE.

## Overlay.TakeOff

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.TakeOff.Entry` | проверка состава армии и переход в полёт | [Source/Overlays/TakeOff.asm](../Source/Overlays/TakeOff.asm#L23) |

### Overlay.TakeOff.Entry

Адрес #B200, блок `O11`. [Source/Overlays/TakeOff.asm](../Source/Overlays/TakeOff.asm#L23).

проверка состава армии и переход в полёт

Требует наземный режим и непустую армию. В первом обходе каждый непустой отряд должен иметь bit2 поля SOLDIERS+#0D, прочитанного через #7AEF. Второй обход ищет хотя бы один отряд с bit2 поля SOLDIERS+#15, иначе функция возвращается без взлёта. В данном образе этот второй бит установлен только у ID16 «Драконы» и ID25 «Демоны», HELP объясняет возможность летать с героем на спине. Лишь после нахождения такого перевозчика проверяется глобальный bit5 #6A33 — наличие катапульты. Если она есть, меню предлагает бросить её либо не лететь. При успехе младшие два бита #6A33 становятся 2, bit5 сбрасывается.

**Вход:** текущее состояние героя, армии и объекта в ядре

**Выход:** состояние обновлено выбранной ветвью либо сохранено при отказе

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

В сохранённом графе: 61 инструкций. Чтение: #6A1E, #6A33. Запись: #6A33. Вызовы: #6D34, #6D3F, #6D57, #7117, #7366, #73FE, #776D, #7AEF, #8036, #82D5.

## Overlay.Land

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Land.Entry` | проверка клетки и завершение полёта | [Source/Overlays/Land.asm](../Source/Overlays/Land.asm#L19) |

### Overlay.Land.Entry

Адрес #B200, блок `O12`. [Source/Overlays/Land.asm](../Source/Overlays/Land.asm#L19).

проверка клетки и завершение полёта

Требует текущий режим 2 в младших двух битах #6A33. Читает клетку под героем по #6A2E. Если бит 7 клетки установлен либо младшие 6 бит ненулевые, выходит. Иначе сбрасывает два младших бита режима и возвращает наземное перемещение.

**Вход:** текущее состояние героя, армии и объекта в ядре

**Выход:** состояние обновлено выбранной ветвью либо сохранено при отказе

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY

В сохранённом графе: 14 инструкций. Чтение: #6A2E, #6A33. Запись: #6A33. Вызовы: #80C4.

## Overlay.Maps

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Maps.Entry` | экран выбора трёх вариантов стратегической карты | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L28) |
| #B335 | `Overlay.Maps.DrawExploredMap` | рисование увеличенного участка карты пройденного | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L201) |
| #B47D | `Overlay.Maps.MapCellPattern` | выбор четырёхбайтового образца ландшафта малой карты | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L365) |
| #B48E | `Overlay.Maps.IsCellExplored` | проверка отдельного бита открытия стратегической клетки | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L391) |
| #B4C6 | `Overlay.Maps.XorMiniTile` | XOR-вывод одной клетки малой карты размером 4x4 | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L441) |
| #B504 | `Overlay.Maps.DrawWorldMap` | полная карта континента с просмотром замков | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L503) |
| #B6B2 | `Overlay.Maps.GetCastleRecord` | получение записи выбранного замка континента | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L702) |
| #B6D1 | `Overlay.Maps.ShowCastleName` | вывод имени и принадлежности выбранного замка на полной карте | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L732) |
| #B703 | `Overlay.Maps.BlinkCastle` | переключение мигающей рамки выбранного замка | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L773) |
| #B751 | `Overlay.Maps.MarkKnownSites` | нанесение трёх групп строений на полную карту | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L827) |
| #B779 | `Overlay.Maps.MarkSiteList` | нанесение активных записей одной таблицы объектов на полную карту | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L856) |
| #B7C3 | `Overlay.Maps.XorMapPixel` | инверсия одного экранного пикселя полной карты | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L917) |
| #B7FD | `Overlay.Maps.DrawAerialMap` | вид с высоты птичьего полёта | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L977) |
| #B8E1 | `Overlay.Maps.WaitMapKey` | ожидание действия с десятикадровой задержкой после ввода | [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L1127) |

### Overlay.Maps.Entry

Адрес #B200, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L28).

экран выбора трёх вариантов стратегической карты

Очищает экран, печатает название текущего континента. Карта пройденного доступна всегда. Возможность полной карты вычисляет проверкой бита #6A34, номер бита зависит от #6A2D. Вид с высоты разрешает, если среди пяти отрядов есть описание с бит 2 E из #7AEF. В WaitMapKey.ViewModes сохраняет два бита доступности, в WaitMapKey.MenuCount число пунктов. Восстанавливает последний режим WaitMapKey.LastView при наличии соответствующей возможности. Пункты вызывают DrawExploredMap, DrawWorldMap или DrawAerialMap, выход восстанавливает основной экран.

**Вход:** #6A2D — континент, #6A2E/#6A2F — координаты, #6A34 — флаги карт, #6A1E — армия

**Выход:** возврат после пункта выхода

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом меню #776D и восстановления основного экрана #944A, сохранение входных регистров не предусмотрено

**Дополнительно:** экран, состояние меню WaitMapKey.TileCode..WaitMapKey.MenuCount, логические банки

В сохранённом графе: 128 инструкций. Чтение: #6A2D, #6A2E, #6A2F, #6A34, #B8EF, #B8F3, #B8F4. Запись: #B286, #B8EF, #B8F4, #B90C, #B95B, #B963. Вызовы: #6C63, #6D34, #6D3F, #7117, #73AD, #73CF, #73FE, #776D, #7AEF, #944A, #B335, #B504, #B7FD.

### Overlay.Maps.DrawExploredMap

Адрес #B335, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L201).

рисование увеличенного участка карты пройденного

Задаёт режим 1. От текущей позиции вычитает 12 по строке и 20 по столбцу, ограничивая начало диапазона строкой 0..73 и столбцом 0..118. Проходит участок 26x42 клетки. IsCellExplored проверяет бит открытия клетки. Неоткрытые клетки рисует специальным четырёхбайтовым образцом #B475. Для открытых проверяет три таблицы объектов через #8D6E, применяет специальный образец объекта #B479 или определяет образец ландшафта через MapCellPattern. XorMiniTile выводит клетку 4x4 пикселя. Затем мигает клеткой героя с XOR и ждёт действия.

**Вход:** координаты героя, стратегическая карта и отдельная маска открытия

**Выход:** на экране фрагмент 42x26, затем возврат

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены

**Дополнительно:** DrawExploredMap.ViewCellPos..DrawExploredMap.MiniRow — рабочая и относительная позиция, экран, банк 11

В сохранённом графе: 121 инструкций. Чтение: #6A2E, #B459, #B45B, #B8EC, #B8F1. Запись: #B459, #B45B, #B8EC, #B8F1, #B8F3. Вызовы: #6BF1, #6D2F, #7117, #73AD, #73FE, #80C4, #8D6E, #B47D, #B48E, #B4C6, #B8E1.

### Overlay.Maps.MapCellPattern

Адрес #B47D, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L365).

выбор четырёхбайтового образца ландшафта малой карты

Оставляет в A младшие шесть битов клетки, классифицирует их через #8697. От DrawExploredMap.ViewCellPos делает A шагов по 4 байта и возвращает адрес образца в DE. Классификатор должен вернуть допустимый ненулевой индекс, иначе счётчик DEC A оборачивается.

**Вход:** A — байт стратегической клетки

**Выход:** DE — адрес четырёх строк образца

**Изменяемые регистры и состояние:** HL, DE, AF. BC, HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** HL, DE, AF

В сохранённом графе: 9 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #8697.

### Overlay.Maps.IsCellExplored

Адрес #B48E, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L391).

проверка отдельного бита открытия стратегической клетки

Выбирает банк 11. Расчёт #B7B7+map*#0834+21*(row+1)+floor(column/8) равен #C000+(map-1)*2100+row*21+floor(column/8). Самомодифицирует номер бита команды BIT как 7-(column mod8). На один континент приходится 100 строк по 21 байту, четыре континента занимают 8400 байтов.

**Вход:** DrawExploredMap.ViewCellPos — column, #B45A — row, #6A2D — map 1..4

**Выход:** Z=1 клетка не открыта, Z=0 открыта, HL адрес байта маски

**Изменяемые регистры и состояние:** HL, DE, BC, AF. HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** логический банк 11, операнд BIT по IsCellExplored.ExploreTestOp, HL, DE, BC, AF

В сохранённом графе: 28 инструкций. Чтение: #6A2D, #B459. Запись: #B4C4. Вызовы: #6D2F.

### Overlay.Maps.XorMiniTile

Адрес #B4C6, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L441).

XOR-вывод одной клетки малой карты размером 4x4

Из относительных координат DrawExploredMap.MiniCell/DrawExploredMap.MiniRow вычисляет экранный адрес с началом #484A. Чётная и нечётная строка клетки разделяют знакоместо по вертикали, нечётный столбец поворачивает образец на четыре бита для другой половины байта. Четыре байта DE объединяет с экраном через XOR, переходя к следующей пиксельной строке INC H. Повторный вызов с тем же образцом убирает изображение.

**Вход:** DE — четыре байта образца, DrawExploredMap.MiniCell=column, DrawExploredMap.MiniRow=row

**Выход:** DE после образца, четыре строки экрана изменены

**Изменяемые регистры и состояние:** HL, DE, BC, AF. HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** экран, HL, DE, BC, AF, при нулевом B после SRL цикл DJNZ делает 256 итераций с модульным итоговым адресом

В сохранённом графе: 38 инструкций. Чтение: #B45B, #B45C. Запись: не выделена. Вызовы: не выделены.

### Overlay.Maps.DrawWorldMap

Адрес #B504, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L503).

полная карта континента с просмотром замков

Задаёт режим 2, очищает окно. Проходит 100x161 клетку банк 10, #C000, переключая один экранный пиксель только при (клетка AND #3F)=0 либо >=9. Рисует перекрестие героя и три группы объектов через MarkKnownSites. По таблице замков континента получает число замков, выводит название выбранного и мигающую рамку. Клавиши с кодами #12/#22 листают замки по кругу, #20 завершает просмотр и восстанавливает заголовки основного меню карт.

**Вход:** карта континента, таблицы объектов, координаты героя

**Выход:** выбранный индекс замка DrawWorldMap.CastleIndex сохранён

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены

**Дополнительно:** экран, DrawWorldMap.CastleIndex..DrawWorldMap.BlinkState, WaitMapKey.LastView, рабочие самомодифицируемые операнды

В сохранённом графе: 141 инструкций. Чтение: #6A2D, #6A2E, #6A2F, #B6AF, #B6B0, #B6B1, #B8EF. Запись: #B642, #B6AF, #B6B0, #B6B1, #B8F3. Вызовы: #6BF1, #6D2F, #7117, #73AD, #73FE, #7A74, #80AE, #B6D1, #B703, #B751, #B7C3.

### Overlay.Maps.GetCastleRecord

Адрес #B6B2, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L702).

получение записи выбранного замка континента

Через таблицу #6AE9 и текущий континент получает указатель массива замков. К нему прибавляет (DrawWorldMap.CastleIndex-1)*35. Индекс должен быть 1..число замков.

**Вход:** #6A2D — континент, DrawWorldMap.CastleIndex — выбранный замок 1..N

**Выход:** IX — начало 35-байтовой записи замка

**Изменяемые регистры и состояние:** HL, DE, AF, IX. BC, HL', DE', BC', AF', IY сохранены

**Дополнительно:** HL, DE, AF, IX

В сохранённом графе: 13 инструкций. Чтение: #6A2D, #B6AF. Запись: не выделена. Вызовы: #7A74.

### Overlay.Maps.ShowCastleName

Адрес #B6D1, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L732).

вывод имени и принадлежности выбранного замка на полной карте

Получает запись GetCastleRecord, подставляет адрес имени IX+3 в строки. Владелец IX+19=0 выбирает подпись «Ваш замок» и зелёный атрибут, иначе «Чужой замок» и другой атрибут. Очищает строку и печатает результат.

**Вход:** состояние выбора замка

**Выход:** строка имени обновлена

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены

**Дополнительно:** экран, указатели строк DrawWorldMap.OwnCastleName/DrawWorldMap.OtherFortName

В сохранённом графе: 23 инструкций. Чтение: не выделено. Запись: #B697, #B6AA. Вызовы: #7117, #73CF, #B6B2.

### Overlay.Maps.BlinkCastle

Адрес #B703, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L773).

переключение мигающей рамки выбранного замка

Получает координаты IX+1/IX+2 выбранного замка. С экранными смещениями x+83, y+81 четырнадцатью вызовами XorMapPixel обводит прямоугольник 5x4 пикселя. Инвертирует байт DrawWorldMap.BlinkState, позволяя снять рамку при завершении ожидания.

**Вход:** выбранный замок

**Выход:** DrawWorldMap.BlinkState инвертирован

**Изменяемые регистры и состояние:** HL, DE, AF, IX. BC, HL', DE', BC', AF', IY сохранены, XorMapPixel восстанавливает рабочие регистры после каждого пикселя

**Дополнительно:** экран, HL, DE, AF, IX

В сохранённом графе: 38 инструкций. Чтение: #B6B1. Запись: #B6B1. Вызовы: #B6B2, #B7C3.

### Overlay.Maps.MarkKnownSites

Адрес #B751, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L827).

нанесение трёх групп строений на полную карту

По очереди передаёт MarkSiteList таблицы #6AE9, #6B09, #6AF9 с шагами записей 35, 5, 26 и размерами отметок 3x2, 2x2, 1x1. Тем самым каждый объект использует отдельный размер отметки при общем алгоритме.

**Вход:** текущий континент и таблицы объектов

**Выход:** отметки нанесены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены

**Дополнительно:** экран, HL, DE, BC, AF, IX

В сохранённом графе: 13 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #B779.

### Overlay.Maps.MarkSiteList

Адрес #B779, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L856).

нанесение активных записей одной таблицы объектов на полную карту

Самомодифицирует шаг и размеры отметки. По континенту получает указатель массива и число записей. Пропускает запись при бит 0 её первого байта. Для остальных по координатам +1/+2 и смещениям 84/82 выводит прямоугольник одиночных XOR-пикселей.

**Вход:** IX — четырёхбайтовый дескриптор континентов, DE — шаг записи, B — высота, C — ширина отметки

**Выход:** все доступные записи пройдены

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены

**Дополнительно:** операнды MarkSiteList.SiteRows/MarkSiteList.SiteColumns/MarkSiteList.SiteStride, экран, HL, DE, BC, AF, IX

В сохранённом графе: 36 инструкций. Чтение: #6A2D. Запись: #B7AB, #B7AD, #B7BC. Вызовы: #7A74, #B7C3.

### Overlay.Maps.XorMapPixel

Адрес #B7C3, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L917).

инверсия одного экранного пикселя полной карты

Из D=y, E=x вычисляет стандартный нелинейный адрес ZX Spectrum и маску #80>>(x mod8). XOR меняет ровно один пиксель. HL, BC, AF сохраняет на стеке, DE непосредственно не меняет.

**Вход:** D — y, E — x

**Выход:** HL, DE, BC, AF сохранены

**Изменяемые регистры и состояние:** Нет, HL, DE, BC, AF, HL', DE', BC', AF', IX, IY сохранены, DE используется только как источник координат и не изменяется

**Дополнительно:** один пиксель экрана

В сохранённом графе: 41 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Overlay.Maps.DrawAerialMap

Адрес #B7FD, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L977).

вид с высоты птичьего полёта

Задаёт режим 3. Выбирает область 13x21 клетка вокруг героя, начало ограничено row0..86, column0..139. Для каждой клетки берёт восьмибайтовую текстуру по младшим шести битам. При бит 6 клетки поворачивает строки текстуры на два бита. Атрибут для бит 7 равен #52, иначе берётся из таблицы по классификации ландшафта. У клетки героя устанавливает FLASH в атрибутах, ждёт действия.

**Вход:** текущая стратегическая карта, координаты героя

**Выход:** на экране 21x13 знакомест

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены

**Дополнительно:** экран и атрибуты, WaitMapKey.TilePosition/WaitMapKey.ViewOrigin, WaitMapKey.LastView, логические банки

В сохранённом графе: 120 инструкций. Чтение: #6A2E, #B8EC, #B8ED, #B8F1. Запись: #B8EC, #B8ED, #B8F1, #B8F3. Вызовы: #6D2F, #7117, #73FE, #80C4, #8697, #B8E1.

### Overlay.Maps.WaitMapKey

Адрес #B8E1, блок `O13`. [Source/Overlays/Maps.asm](../Source/Overlays/Maps.asm#L1127).

ожидание действия с десятикадровой задержкой после ввода

Повторяет #6BF1 до CF=1. Затем выполняет десять HALT и возвращается, снижая вероятность повторного использования одного нажатия.

**Вход:** разрешённые прерывания

**Выход:** получен ввод и прошли 10 прерываний

**Изменяемые регистры и состояние:** BC, AF. HL, DE, HL', DE', BC', AF', IX, IY сохранены, B используется как счётчик десяти HALT

**Дополнительно:** BC, AF

В сохранённом графе: 6 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6BF1.

## Overlay.Sail

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Sail.Entry` | переход на выбранный доступный континент по морю | [Source/Overlays/Sail.asm](../Source/Overlays/Sail.asm#L26) |

### Overlay.Sail.Entry

Адрес #B200, блок `O14`. [Source/Overlays/Sail.asm](../Source/Overlays/Sail.asm#L26).

переход на выбранный доступный континент по морю

Возвращается без окна при сброшенном бит 0 #6A34 или если (#6A33 AND3)!=1. Из флагов #6A34 строит список континентов. Выбор текущего континента и отмена ничего не меняют. Для нового задаёт #69D7=#FF, на время десяти вызовов дневного шага #9704 устанавливает бит 7 #6565. Затем меняет #6A2D/#6A30, устанавливает координаты причаливания из #B3AE и загружает KARTA?. Случайно выбирает допустимые клетки для встреч, отмечая их бит 7. Печатает сообщение о прибытии и возвращается к основному экрану.

**Вход:** #6A34 — доступность, #6A33 — режим передвижения, текущий континент

**Выход:** при успехе изменён континент, режим и координаты, обычный возврат

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY на полном пути с переходом континента, загрузкой карты и суточной обработкой #9704. На ранних RET меняются только AF

**Дополнительно:** карта банк 10, #6A2D..#6A32, координаты встреч #6A44/#6A4B, #6A46, экран и временные поля оверлея

В сохранённом графе: 184 инструкций. Чтение: #6565, #6A2D, #6A33, #6A34, #6A4D, #B25A, #B3B6, #B440. Запись: #62E2, #6565, #69D7, #6A2D, #6A2E, #6A30, #6A31, #6A44, #6A46, #6A4B, #B259, #B25A, #B3B6, #B440. Вызовы: #6CC8, #6D34, #6D3F, #7117, #73AD, #73CF, #73FE, #776D, #7B0B, #7BF4, #7C0D, #80AE, #80B4, #82D5, #944A, #957C, #9704.

## Overlay.TargetMap

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.TargetMap.Entry` | показ собранных частей карты местонахождения цели | [Source/Overlays/TargetMap.asm](../Source/Overlays/TargetMap.asm#L24) |

### Overlay.TargetMap.Entry

Адрес #B200, блок `O15`. [Source/Overlays/TargetMap.asm](../Source/Overlays/TargetMap.asm#L24).

показ собранных частей карты местонахождения цели

Считает 25 бит в пяти байтах #6A55..#6A59, по пять бит на строку. Выбирает текст для 0, частичного числа или 25 фрагментов. В банк 4 выводит сетку 5x5 из портретоподобных блоков 4x4 знакоместа. Для отсутствующего фрагмента использует #EEA0, для открытого берёт тайл из #C000+144*(тип AND #3F). Bit6 исходного байта включает горизонтальное отражение #75E1. Типы 25 клеток хранятся в #6A5A..#6A72.

**Вход:** маска открытых частей и 25 байтов целевого узора

**Выход:** карта 5x5 показана до действия пользователя

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом восстановления основного экрана #944A, IX и IY явно используются для рисунка и маски фрагментов

**Дополнительно:** экран, банк 4, числовое поле Entry.KnownPieces, HL, DE, BC, AF, IX, IY

В сохранённом графе: 87 инструкций. Чтение: не выделено. Запись: #B2D3. Вызовы: #6D2F, #6D34, #7117, #73CF, #73FE, #7545, #75E1, #7BF4, #944A.

## Overlay.Victory

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Victory.Entry` | поиск цели сравнением участка карты 5x5 и завершение игры | [Source/Overlays/Victory.asm](../Source/Overlays/Victory.asm#L27) |
| #B40A | `Overlay.Victory.ScrollScores` | прокрутка нижней текстовой области списка победителей | [Source/Overlays/Victory.asm](../Source/Overlays/Victory.asm#L273) |
| #B5F7 | `Overlay.Victory.TerrainCode` | отбрасывание служебных битов клетки при поиске цели | [Source/Overlays/Victory.asm](../Source/Overlays/Victory.asm#L407) |

### Overlay.Victory.Entry

Адрес #B200, блок `O16`. [Source/Overlays/Victory.asm](../Source/Overlays/Victory.asm#L27).

поиск цели сравнением участка карты 5x5 и завершение игры

Доступен только при (#6A33 AND3)=0. После подтверждения проводит 28 дневных шагов #9704. Выбирает квадрат 5x5 вокруг координат героя со сдвигом -2, -2 и сравнивает младшие 6 бит всех 25 клеток с узором #6A5A. При несовпадении показывает провал. При совпадении переходит к сцене победы, показывает сообщения, читает 12 секторов через #6D15 с DE=#9E00 в #C000. Ищет свободную 19-байтовую запись, добавляет 19 байтов #69EF с XOR первых 19 байтов ROM, записывает 12 секторов обратно. Расшифровывает записи тем же XOR и прокручивает список победителей. В конце JP #0000. Область диска задаётся физической парой DE, а не именем файла.

**Вход:** карта, координаты героя, узор #6A5A, данные героя #69EF

**Выход:** провал возвращает управление, победа завершает JP #0000

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY на ветви полного поиска и победы, I и режим IM переключаются дисковым шлюзом #6D15, победа завершается JP #0000 и не сохраняет стек вызывающего кода

**Дополнительно:** время, экран, fixed disk region DE=#9E00 12 секторов, память банк 0, #C000, текущий стек

В сохранённом графе: 195 инструкций. Чтение: #6A2E, #6A33, #B45B. Запись: #69D7, #B45B, #B460, #B463. Вызовы: #6D15, #6D2F, #6D34, #7117, #73AD, #73CF, #73FE, #776D, #7BF4, #80AE, #80B4, #8801, #9704, #B40A, #B5F7.

### Overlay.Victory.ScrollScores

Адрес #B40A, блок `O16`. [Source/Overlays/Victory.asm](../Source/Overlays/Victory.asm#L273).

прокрутка нижней текстовой области списка победителей

Каждый из B шагов ждёт восемь HALT. В шести рядах знакомест начиная #5021 копирует по 30 байтов из следующей пиксельной строки в предыдущую, включая переход к следующему знакоместу. Последнюю строку #57C1..#57DE очищает нулями. Повторение создаёт прокрутку вверх на одну пиксельную строку за шаг.

**Вход:** B — число пиксельных шагов, не ноль

**Выход:** B=0

**Изменяемые регистры и состояние:** HL, DE, BC, AF. HL', DE', BC', AF', IX, IY сохранены, C восстанавливается через PUSH/POP BC, B после цикла равен нулю

**Дополнительно:** часть экранной памяти, HL, DE, BC, AF

В сохранённом графе: 50 инструкций. Чтение: #B45D. Запись: #B45D. Вызовы: не выделены.

### Overlay.Victory.TerrainCode

Адрес #B5F7, блок `O16`. [Source/Overlays/Victory.asm](../Source/Overlays/Victory.asm#L407).

отбрасывание служебных битов клетки при поиске цели

Выполняет AND #3F. При ненулевом результате дополнительно AND #7F, что уже не меняет значение. Сравнение цели игнорирует и бит 6, и бит 7.

**Вход:** A — байт клетки

**Выход:** A=исходное A AND #3F, Z по этому значению

**Изменяемые регистры и состояние:** AF. HL, DE, BC, HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** AF

В сохранённом графе: 4 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

## Overlay.Info

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Info.Entry` | экран статистики с переходами в подробные подменю | [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L25) |
| #B405 | `Overlay.Info.CastleList` | список собственных замков с листанием по 26 названий | [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L269) |
| #B482 | `Overlay.Info.ShowCastleInfo` | карточка замка с доходом, местоположением и гарнизоном | [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L345) |
| #B5E9 | `Overlay.Info.FindOwnCastle` | поиск N-го собственного замка в таблице из 35-байтовых записей | [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L483) |
| #B608 | `Overlay.Info.DrawCastlePage` | вывод текущей страницы списка собственных замков | [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L524) |
| #B6D8 | `Overlay.Info.ListRulers` | показ списка побеждённых противников | [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L618) |
| #B749 | `Overlay.Info.ShowContract` | подробности текущего контракта на захват замка | [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L690) |
| #B819 | `Overlay.Info.ShowThreat` | показ замка, на который готовится нападение | [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L798) |
| #B8F3 | `Overlay.Info.ListSpells` | список изученных заклинаний | [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L857) |

### Overlay.Info.Entry

Адрес #B200, блок `O17`. [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L25).

экран статистики с переходами в подробные подменю

Считает захваченные замки через #87A1, уничтоженных врагов обходом ID1..15 через #87D1, показывает контракт #6A3A, осадные орудия бит 5 #6A33, секту #6A3B, число изученных заклинаний по десяти байтам #6A0A и уведомление о нападении #6AAA. Убирает недоступные области из таблицы выбора. По результату 2..6 берёт адрес из пяти слов #B979..#B982 и выполняет PUSH HL, RET. Это явный стековый диспетчер, его цели нужно включать в CFG вручную.

**Вход:** глобальные поля героя, таблицы замков/врагов/заклинаний

**Выход:** меню 1 закрывает экран, пункты 2..6 переходят к локальным обработчикам

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом выбранного подменю, ROM-калькулятора и заключительного #957C

**Дополнительно:** экран, таблица меню ListSpells.StatsItems/ListSpells.CastleRectMin..ListSpells.SpellRectMax, поля строк, цели CastleList, ListRulers, ShowContract, ListSpells, ShowThreat

В сохранённом графе: 199 инструкций. Чтение: #6A33, #6A3A, #6A3B, #6AAA, #6AAC. Запись: #B670, #B95A, #B965, #B967, #B969, #B96B, #B96D, #B96F, #B971, #B973, #B991, #BA1B, #BA67, #BB79, #BBC6, #BCA8. Вызовы: #6D2F, #6D34, #7117, #73AD, #73CF, #73FE, #776D, #7A80, #87A1, #87D1, #957C.

### Overlay.Info.CastleList

Адрес #B405, блок `O17`. [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L269).

список собственных замков с листанием по 26 названий

Рисует окно и нижние кнопки, DrawCastlePage выводит текущую страницу. Выбор 1 увеличивает первый индекс DrawCastlePage.FirstCastle на 26, если ещё есть замки, выбор 2 уменьшает на 26 до 1, выбор 3 возвращает в статистику. Остальные пункты преобразует в абсолютный индекс, FindOwnCastle находит запись, ShowCastleInfo открывает сведения о ней.

**Вход:** DrawCastlePage.FirstCastle — первый индекс, ListSpells.CastleCount — число своих замков

**Выход:** переход к Entry.DrawStats при закрытии

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом безусловного продолжения общего меню по Entry.DrawStats, локальная обработка листания не сохраняет регистры вызывающего кода

**Дополнительно:** экран, DrawCastlePage.FirstCastle, локальное меню ShowCastleInfo.CastleItems

В сохранённом графе: 246 инструкций. Чтение: #6A33, #6A3A, #6A3B, #6AAA, #6AAC, #B670, #BB79. Запись: #B670, #B95A, #B965, #B967, #B969, #B96B, #B96D, #B96F, #B971, #B973, #B991, #BA1B, #BA67, #BB79, #BBC6, #BCA8. Вызовы: #6D2F, #7117, #73AD, #73CF, #73FE, #776D, #7A80, #87A1, #87D1, #957C, #B482, #B5E9, #B608.

### Overlay.Info.ShowCastleInfo

Адрес #B482, блок `O17`. [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L345).

карточка замка с доходом, местоположением и гарнизоном

Сохраняет IX на имя замка. Определяет континент через #7A4E и недельный доход через #AE1A. На текущем континенте вычисляет направление и расстояние, подставляет их в текст, для близкой цели показывает короткую подпись. На другом континенте выводит его название. При первом ID гарнизона IX+17=0 печатает отсутствие армии, иначе передаёт пять трёхбайтовых записей IX+17 в #7E55. Ждёт действия.

**Вход:** IX — указатель на 15-байтовое имя, физическая запись замка начинается IX-3

**Выход:** возврат после карточки

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом расчёта расстояния #7FF0, ROM-калькулятора и вывода гарнизона #7E55

**Дополнительно:** экран, DrawCastlePage.CastleName, DrawCastlePage.CastleIncome, ShowThreat.DirectionText, ShowThreat.CastleDistance, ShowThreat.ContinentText, банки

В сохранённом графе: 95 инструкций. Чтение: #6A2D, #6A2E, #B678. Запись: #B678, #B690, #B849, #B85C, #B8B2. Вызовы: #6D62, #6D76, #7117, #73AD, #73FE, #7A4E, #7BF4, #7C71, #7E55, #7FF0, #AE1A.

### Overlay.Info.FindOwnCastle

Адрес #B5E9, блок `O17`. [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L483).

поиск N-го собственного замка в таблице из 35-байтовых записей

От IX=#BFE0 прибавляет 35 до указателя имени очередной записи. Пропускает запись при установленном бит 0 по IX-3 либо ненулевом владельце по IX+16. DJNZ считает только подходящие записи. Число A должно соответствовать существующему замку, явной конечной границы у этого поиска нет.

**Вход:** A — порядковый номер своего замка с 1

**Выход:** IX — имя найденного замка, DE, BC, AF сохранены

**Изменяемые регистры и состояние:** IX. HL, DE, BC, AF, HL', DE', BC', AF', IY сохранены, DE, BC и AF явно восстанавливаются со стека

**Дополнительно:** IX

В сохранённом графе: 17 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: не выделены.

### Overlay.Info.DrawCastlePage

Адрес #B608, блок `O17`. [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L524).

вывод текущей страницы списка собственных замков

Очищает область, выбирает банк 0, начинает с индекса DrawCastlePage.FirstCastle и заканчивает после 26 названий либо достижения ListSpells.CastleCount. FindOwnCastle возвращает каждое имя. Названия размещаются в двух столбцах 13 строк, а число активных пунктов меню ShowCastleInfo.CastleItems увеличивается после каждого.

**Вход:** DrawCastlePage.FirstCastle — индекс начала, ListSpells.CastleCount — общее число

**Выход:** меню содержит только фактически напечатанные замки

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX. HL', DE', BC', AF', IY сохранены, имена замков печатаются как обычные строки без числовых управляющих вставок

**Дополнительно:** экран, ShowCastleInfo.CastleItems, DrawCastlePage.CastleListXY, DrawCastlePage.PageItems, банк 0

В сохранённом графе: 47 инструкций. Чтение: #B56E, #B644, #B64A, #B670, #BB79. Запись: #B56E, #B644, #B645, #B64A. Вызовы: #6D2F, #7117, #73CF, #B5E9.

### Overlay.Info.ListRulers

Адрес #B6D8, блок `O17`. [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L618).

показ списка побеждённых противников

Размер окна берёт из ListSpells.RulerCount. Для ID1..15 вызывает #87D1, при ненулевом результате получает 28-байтовый описатель через #804E и печатает его имя. После ожидания возвращается к Entry.DrawStats.

**Вход:** ListSpells.RulerCount — число побеждённых, таблицы врагов/замков

**Выход:** переход к статистике

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом продолжения общего меню по Entry.DrawStats, локальный PUSH/POP AF сохраняет лишь индекс цикла внутри обработчика

**Дополнительно:** экран, банки, рабочие операнды ListRulers.RulerListXY/ListRulers.PluralSuffix

В сохранённом графе: 240 инструкций. Чтение: #6A33, #6A3A, #6A3B, #6AAA, #6AAC, #B722, #BBC6. Запись: #B721, #B722, #B744, #B95A, #B965, #B967, #B969, #B96B, #B96D, #B96F, #B971, #B973, #B991, #BA1B, #BA67, #BB79, #BBC6, #BCA8. Вызовы: #6D2F, #7117, #73AD, #73CF, #73FE, #776D, #7A80, #7BF4, #804E, #87A1, #87D1, #957C.

### Overlay.Info.ShowContract

Адрес #B749, блок `O17`. [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L690).

подробности текущего контракта на захват замка

Берёт указатель цели ListSpells.ContractCastle. Определяет её континент, для текущего показывает направление/расстояние, иначе название континента. Владелец по имени+16=#FF означает отсутствие владельца, прочий ID выбирает описатель #804E. Выводит пять записей гарнизона с имени+17 через #7E55 и возвращается в статистику.

**Вход:** ListSpells.ContractCastle — имя контрактного замка

**Выход:** переход к Entry.DrawStats

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом расчёта расстояния, гарнизона и продолжения общего меню по Entry.DrawStats

**Дополнительно:** экран, банки и поля строк

В сохранённом графе: 280 инструкций. Чтение: #6A2D, #6A2E, #6A33, #6A3A, #6A3B, #6AAA, #6AAC, #BCA8. Запись: #B849, #B85C, #B8B2, #B8DD, #B95A, #B965, #B967, #B969, #B96B, #B96D, #B96F, #B971, #B973, #B991, #BA1B, #BA67, #BB79, #BBC6, #BCA8. Вызовы: #6D2F, #6D62, #6D76, #7117, #73AD, #73CF, #73FE, #776D, #7A4E, #7A80, #7BF4, #7C71, #7E55, #7FF0, #804E, #87A1, #87D1, #957C.

### Overlay.Info.ShowThreat

Адрес #B819, блок `O17`. [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L798).

показ замка, на который готовится нападение

Из ListSpells.ThreatCastle берёт указатель на имя замка, вызывает общую карточку ShowCastleInfo и возвращается к статистике.

**Вход:** ListSpells.ThreatCastle — имя целевого замка

**Выход:** переход к Entry.DrawStats

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY через карточку ShowCastleInfo и продолжение общего меню по Entry.DrawStats

**Дополнительно:** эффекты карточки ShowCastleInfo

В сохранённом графе: 199 инструкций. Чтение: #6A33, #6A3A, #6A3B, #6AAA, #6AAC, #B991. Запись: #B95A, #B965, #B967, #B969, #B96B, #B96D, #B96F, #B971, #B973, #B991, #BA1B, #BA67, #BB79, #BBC6, #BCA8. Вызовы: #6D2F, #7117, #73AD, #73CF, #73FE, #776D, #7A80, #87A1, #87D1, #957C, #B482.

### Overlay.Info.ListSpells

Адрес #B8F3, блок `O17`. [Source/Overlays/Info.asm](../Source/Overlays/Info.asm#L857).

список изученных заклинаний

Размер окна определяется числом ListSpells.SpellCount. Перебирает десять ID1..10, проверяет бит 0 в #6A09+ID. Для изученного получает 23-байтовый описатель через #8066 и печатает его имя, затем ждёт действия и возвращается в статистику.

**Вход:** #6A0A..#6A13 — флаги заклинаний

**Выход:** переход к Entry.DrawStats

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом продолжения общего меню по Entry.DrawStats, PUSH/POP AF внутри списка сохраняет только его текущий номер

**Дополнительно:** экран, банк 3, операнд координат ListSpells.SpellListXY

В сохранённом графе: 236 инструкций. Чтение: #6A33, #6A3A, #6A3B, #6AAA, #6AAC, #B933, #BA1B. Запись: #B932, #B933, #B95A, #B965, #B967, #B969, #B96B, #B96D, #B96F, #B971, #B973, #B991, #BA1B, #BA67, #BB79, #BBC6, #BCA8. Вызовы: #6D2F, #7117, #73AD, #73CF, #73FE, #776D, #7A80, #7BF4, #8066, #87A1, #87D1, #957C.

## Overlay.Friendly

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Friendly.Entry` | встреча доброжелательного рассказчика и перенос его отметки | [Source/Overlays/Friendly.asm](../Source/Overlays/Friendly.asm#L24) |
| #B257 | `Overlay.Friendly.PrintStory` | выбор и постраничная печать анекдота доброжелательной встречи | [Source/Overlays/Friendly.asm](../Source/Overlays/Friendly.asm#L80) |

### Overlay.Friendly.Entry

Адрес #B200, блок `O18`. [Source/Overlays/Friendly.asm](../Source/Overlays/Friendly.asm#L24).

встреча доброжелательного рассказчика и перенос его отметки

Показывает персонажа 4 и приветствие, увеличивает 16-битный счётчик #6A49 и передаёт его в PrintStory. После рассказа снимает бит 7 карты со старой клетки #6A44. Выбирает случайные координаты, пока клетка имеет бит 7=0 и младшие 6 бит=0. Устанавливает бит 7 и сохраняет новую позицию #6A44.

**Вход:** #6A49 — число встреч, #6A44 — старая клетка

**Выход:** рассказчик перенесён на новую клетку

**Изменяемые регистры и состояние:** HL, DE, BC, AF, BC'. HL', DE', AF', IX, IY сохранены. #8801 сохраняет основные и индексные регистры, общий распаковщик BL1 меняет B'/C' как счётчик и значение RLE-серии

**Дополнительно:** #6A49, #6A44, карта банк 10, экран

В сохранённом графе: 35 инструкций. Чтение: #6A44, #6A49. Запись: #6A44, #6A49. Вызовы: #6D34, #7117, #73FE, #7BF4, #7C0D, #80AE, #80B4, #8801, #B257.

### Overlay.Friendly.PrintStory

Адрес #B257, блок `O18`. [Source/Overlays/Friendly.asm](../Source/Overlays/Friendly.asm#L80).

выбор и постраничная печать анекдота доброжелательной встречи

При числе встреч меньше 5 выбирает соответствующий номер последовательно. Иначе получает номер генератором #7C0D с DE=3 и увеличивает его на 1. Ищет в текстовом блоке нужный разделитель #B1, печатает до #B2. CR переводит строку, при строке 22 выводит «Это еще не конец», ждёт ввода и продолжает на новой странице. При #B2 показывает «Вот и все» и ждёт.

**Вход:** HL — положительный номер встречи

**Выход:** возврат после последней страницы

**Изменяемые регистры и состояние:** HL, DE, BC, AF. HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** экран, HL, DE, BC, AF

В сохранённом графе: 57 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #70C5, #7117, #73AD, #73FE, #7BF4, #7C0D.

## Overlay.Hostile

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Hostile.Entry` | встреча враждебного рассказчика и выбор его нового континента | [Source/Overlays/Hostile.asm](../Source/Overlays/Hostile.asm#L24) |
| #B2A8 | `Overlay.Hostile.PrintStory` | постраничный анекдот враждебной встречи | [Source/Overlays/Hostile.asm](../Source/Overlays/Hostile.asm#L97) |

### Overlay.Hostile.Entry

Адрес #B200, блок `O19`. [Source/Overlays/Hostile.asm](../Source/Overlays/Hostile.asm#L24).

встреча враждебного рассказчика и выбор его нового континента

Показывает персонажа 5 и угрожающее приветствие, увеличивает #6A50, вызывает PrintStory. Снимает бит 7 старой клетки #6A4B. Через генератор с DE=3 и увеличением результата выбирает континент #6A4D. Если он текущий, находит случайную клетку с бит 7=0 и младшими 6 бит=0, отмечает её и сохраняет #6A4B. Для другого континента координаты в этом входе не пересчитываются.

**Вход:** #6A50 — число встреч, #6A4B — прежняя позиция

**Выход:** #6A4D — выбранный континент

**Изменяемые регистры и состояние:** HL, DE, BC, AF, BC'. HL', DE', AF', IX, IY сохранены. #8801 сохраняет основные и индексные регистры, общий распаковщик BL1 меняет B'/C' как счётчик и значение RLE-серии

**Дополнительно:** карта, счётчики, экран

В сохранённом графе: 43 инструкций. Чтение: #6A2D, #6A4B, #6A50. Запись: #6A4B, #6A4D, #6A50. Вызовы: #6D34, #7117, #73FE, #7BF4, #7C0D, #80AE, #80B4, #8801, #B2A8.

### Overlay.Hostile.PrintStory

Адрес #B2A8, блок `O19`. [Source/Overlays/Hostile.asm](../Source/Overlays/Hostile.asm#L97).

постраничный анекдот враждебной встречи

Тот же алгоритм разделителей #B1/#B2, нумерации первых четырёх встреч и постраничной печати, что O18, #B257. Собственный текстовый блок начинается #B33B, координаты печати 15, 2, переход страницы при строке 22.

**Вход:** HL — положительный номер встречи

**Выход:** возврат после завершения

**Изменяемые регистры и состояние:** HL, DE, BC, AF. HL', DE', BC', AF', IX, IY сохранены

**Дополнительно:** экран, HL, DE, BC, AF

В сохранённом графе: 57 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #70C5, #7117, #73AD, #73FE, #7BF4, #7C0D.

## Overlay.Defeat

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Defeat.Entry` | экран поражения и повторная загрузка стартового блока KB.co | [Source/Overlays/Defeat.asm](../Source/Overlays/Defeat.asm#L25) |
| #B25B | `Overlay.Defeat.WaitDefeatKey` | печать сообщения поражения и ожидание действия | [Source/Overlays/Defeat.asm](../Source/Overlays/Defeat.asm#L81) |

### Overlay.Defeat.Entry

Адрес #B200, блок `O20`. [Source/Overlays/Defeat.asm](../Source/Overlays/Defeat.asm#L25).

экран поражения и повторная загрузка стартового блока KB.co

Сохраняет вход BC, показывает рамку и загружает BAD/C в #4000 через #6CC8. При входном C=0 печатает текст гибели в бою, иначе текст истечения срока. Включает IM1, I=#3F, банк 0, ставит SP=#5F98, переносит девятибайтовое имя KB.co/C из #6CDD в TrDos.Descriptor, обнуляет #5D10. Вызывает TR-DOS с A=0, C=#0E, затем JP #6149, то есть повторно запускает начальный блок, а не удаляет сохранение.

**Вход:** C — причина, 0 битва, неноль срок

**Выход:** управление #6149, обычного возврата нет

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY не сохраняются как контракт вызывающего кода, обычного возврата нет. SP заменяется на #5F98, I=#3F, IM 1, затем TR-DOS и JP #6149

**Дополнительно:** экран, TR-DOS, системные переменные, стек, режим прерываний

В сохранённом графе: 38 инструкций. Чтение: не выделено. Запись: #5D10. Вызовы: #3D13, #5FA1, #6CC8, #73CF, #73FE, #B25B.

### Overlay.Defeat.WaitDefeatKey

Адрес #B25B, блок `O20`. [Source/Overlays/Defeat.asm](../Source/Overlays/Defeat.asm#L81).

печать сообщения поражения и ожидание действия

Передаёт B/DE в #7117, затем ставит B=#FF и хвостовым JP вызывает ожидание #7BF4.

**Вход:** DE — сообщение, B — строка

**Выход:** возврат из общего ожидания

**Изменяемые регистры и состояние:** BC, HL', DE', BC', AF' при наличии числовых управляющих вставок в переданной строке #7117. HL, DE, AF, IX, IY сохранены, B устанавливается в #FF перед общим ожиданием #7BF4

**Дополнительно:** экран и регистры по процедурам ядра

В сохранённом графе: 3 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7117.

## Overlay.Castle

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Castle.Entry` | управление гарнизоном собственного замка и его защитой | [Source/Overlays/Castle.asm](../Source/Overlays/Castle.asm#L32) |
| #B801 | `Overlay.Castle.PlaceAuxTroops` | размещение сохранённых отрядов как шестибайтовых объектов карты | [Source/Overlays/Castle.asm](../Source/Overlays/Castle.asm#L746) |
| #BB5C | `Overlay.Castle.DrawUnitList` | вывод до пяти отрядов и подготовка меню выбора | [Source/Overlays/Castle.asm](../Source/Overlays/Castle.asm#L942) |
| #BBB2 | `Overlay.Castle.ReadUnitCount` | ввод числа передаваемых воинов с верхней границей | [Source/Overlays/Castle.asm](../Source/Overlays/Castle.asm#L1001) |

### Overlay.Castle.Entry

Адрес #B200, блок `O21`. [Source/Overlays/Castle.asm](../Source/Overlays/Castle.asm#L32).

управление гарнизоном собственного замка и его защитой

Указатель имени текущего замка берёт #867B. Сравнивает его с #6AAC и проверяет #6AAA/#6AAB, определяя специальный режим защиты. Обычное меню позволяет оставить отряд, забрать отряд, покинуть замок и изменить 15-байтовое имя. Во время нападения заменяет подписи на исключение/взятие воинов и начало битвы, при возможности добавляет помощь ближайшего города. Пять трёхбайтовых записей гарнизона находятся по имени+17. Ветви переноса ищут пустой либо совпадающий ID, запрашивают количество ReadUnitCount, складывают/вычитают 16-битные числа и уплотняют массив #807E. Ветвь защиты создаёт бой через банк 3, #D255 с A=#88, армией #6AAE. Исход боя меняет владельца/гарнизон, награждение, магические затраты и возможность вернуться к сохранённой армии.

**Вход:** #867B — имя замка, #6A1E — армия героя, #6AAA..#6AAC — нападение

**Выход:** возврат после выхода из замка или завершения защиты

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY с учётом меню, калькулятора, числового ввода и возможного вызова боевого модуля #D255

**Дополнительно:** гарнизон, имя замка, армия, владельцы, численные поля героя, экран, банки Особенность оригинала: при поражении возврат списывает State.ReturnCost из State.Mana при победе проверяет запас магии, но не сохраняет уменьшенное значение

В сохранённом графе: 610 инструкций. Чтение: #6566, #69D8, #69D9, #69DB, #69DC, #6A02, #6A04, #6A1E, #6A2D, #6AAA, #6AAB, #6AAC, #867B, #B356, #B875, #B876, #B92F, #BBFD, #BD34. Запись: #6566, #6A02, #6A04, #6A2E, #6A33, #6AAA, #B355, #B356, #B3C1, #B4F0, #B5C1, #B875, #B876, #B926, #B92F, #BA92, #BBFD, #BC2B, #BD34. Вызовы: #6D2F, #6D34, #6D3F, #6D88, #6DAE, #6DC4, #6E0E, #70E3, #7117, #73AD, #73CF, #73FE, #776D, #7A94, #7BF4, #7C0D, #7EA7, #7F40, #7F5F, #7FF0, #804E, #807E, #80C4, #8712, #8801, #89E0, #8A08, #B801, #BB5C, #BBB2, #D255.

### Overlay.Castle.PlaceAuxTroops

Адрес #B801, блок `O21`. [Source/Overlays/Castle.asm](../Source/Overlays/Castle.asm#L746).

размещение сохранённых отрядов как шестибайтовых объектов карты

Перебирает до 5 записей по 3 байта от #69DE. Для каждого ID ищет запись с бит 0=1 в текущей таблице объектов #6B69, шаг 6. Записывает ID в+3 и 16-битное число в+4/+5. Случайно выбирает клетку без бит 7, назначает флаги 0 или #20 по типу ландшафта и записывает координаты+1/+2. Для каждой непустой исходной записи требуется свободная запись объекта. При исчерпании таблицы код содержит RET до POP BC, что нарушает обычный баланс стека, этот путь не проверен в игре.

**Вход:** #69DE — сохранённая армия, таблица #6B69 текущего континента

**Выход:** отряды размещены либо ранний возврат на пустой исходной записи

**Изменяемые регистры и состояние:** HL, DE, BC, AF, IX, IY. HL', DE', BC', AF' сохранены. Если свободной шестибайтовой записи нет, RET #B82A выполняется до POP BC, SP остаётся ниже исходного на два байта и обычный возврат нарушается

**Дополнительно:** шестибайтовые объекты карты, генератор случайных чисел, IY, IX и основные регистры

В сохранённом графе: 49 инструкций. Чтение: #6A2D. Запись: не выделена. Вызовы: #7A74, #7C0D, #80C4.

### Overlay.Castle.DrawUnitList

Адрес #BB5C, блок `O21`. [Source/Overlays/Castle.asm](../Source/Overlays/Castle.asm#L942).

вывод до пяти отрядов и подготовка меню выбора

Очищает пять строк, число пунктов ReadUnitCount.UnitMenuCount устанавливает 1 для выхода. Берёт ID и количество из трёхбайтовых записей IY, останавливается на ID0. #8036 даёт название/описатель, строка #BD28 печатает имя и число. После каждой записи увеличивает число пунктов, строку печати и IY на 3.

**Вход:** IY — массив до 5 записей ID+little-endian количество

**Выход:** ReadUnitCount.UnitMenuCount=1+число напечатанных записей

**Изменяемые регистры и состояние:** DE, BC, AF, HL', DE', BC', AF', IX, IY. HL сохранён, остальные основные регистры используются для координат, чисел и описателя отряда, IY продвигается по массиву

**Дополнительно:** экран, ReadUnitCount.UnitName/ReadUnitCount.UnitCount, DrawUnitList.ListIndex, IY после последней записи

В сохранённом графе: 37 инструкций. Чтение: #BB8F, #BD4F. Запись: #BB8F, #BD29, #BD2E, #BD4F. Вызовы: #6D2F, #7117, #73CF, #8036.

### Overlay.Castle.ReadUnitCount

Адрес #BBB2, блок `O21`. [Source/Overlays/Castle.asm](../Source/Overlays/Castle.asm#L1001).

ввод числа передаваемых воинов с верхней границей

Сохраняет IX/IY, по A+17 выбирает строку подсветки и печатает «Сколько?». Повторяет числовой ввод #6FC0 и получение BC через #6D76. Нулевое число и число больше исходного HL отвергает. Код ввода #0E означает отмену. При успехе возвращает положительный BC<=HL и сбрасывает CF.

**Вход:** A — номер строки выбора с 1, HL — максимум

**Выход:** BC — введённое количество, A=#0E/Z=1 при отмене, Z=0 и CF=0 при успехе, A=B OR C, IX, IY сохранены

**Изменяемые регистры и состояние:** DE, BC, AF, HL', DE', BC', AF'. HL, IX, IY сохранены, HL восстанавливается после числового ввода и проверки верхней границы

**Дополнительно:** экран, рабочий операнд ReadUnitCount.CountInputXY, HL сохраняется при сравнении, основные регистры

В сохранённом графе: 33 инструкций. Чтение: не выделено. Запись: #BBD4. Вызовы: #6D76, #6FC0, #7117, #73AD.

## Overlay.Help

| адрес | процедура | назначение | исходник |
| --- | --- | --- | --- |
| #B200 | `Overlay.Help.Entry` | трёхстраничная справка об управлении | [Source/Overlays/Help.asm](../Source/Overlays/Help.asm#L23) |
| #B261 | `Overlay.Help.WaitHelpPage` | нижняя строка продолжения справки и ожидание | [Source/Overlays/Help.asm](../Source/Overlays/Help.asm#L77) |

### Overlay.Help.Entry

Адрес #B200, блок `O22`. [Source/Overlays/Help.asm](../Source/Overlays/Help.asm#L23).

трёхстраничная справка об управлении

Очищает экран и последовательно выводит строки по #B2A0, #B433, #B56F. Первые страницы описывают управление героем/меню, третья — клавиши боя. После первых двух вызывает WaitHelpPage, после последней показывает «Вот и все», ждёт ввода и восстанавливает основной экран.

**Вход:** нет явных аргументов

**Выход:** возврат после третьей страницы

**Изменяемые регистры и состояние:** HL, DE, BC, AF, HL', DE', BC', AF', IX, IY через заключительное восстановление основного экрана #944A, собственный вывод справки сохраняет индексные регистры до этого вызова

**Дополнительно:** экран, состояние общих процедур печати

В сохранённом графе: 36 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #6D34, #6D3F, #7117, #73AD, #73CF, #7BF4, #944A, #B261.

### Overlay.Help.WaitHelpPage

Адрес #B261, блок `O22`. [Source/Overlays/Help.asm](../Source/Overlays/Help.asm#L77).

нижняя строка продолжения справки и ожидание

Заполняет атрибуты строки 23, печатает «Продолжение следует» из #B27A, затем вызывает #7BF4 с B=0. Временное значение B=0 нельзя автоматически понимать как отсутствие ожидания, контракт задаёт процедура ядра.

**Вход:** страница уже выведена

**Выход:** возврат после общего ожидания

**Изменяемые регистры и состояние:** DE, BC, AF. HL, HL', DE', BC', AF', IX, IY сохранены, печатаемая строка продолжения не содержит числовых вставок

**Дополнительно:** экран и регистры по процедурам ядра

В сохранённом графе: 10 инструкций. Чтение: не выделено. Запись: не выделена. Вызовы: #7117, #73AD, #7BF4.
