# Документация проекта «Страна мифов»

[Главная страница проекта](../README.md) · [Галерея ресурсов](../Assets/Index.html)

## Устройство и работа с проектом

- [Инструменты дизассемблирования](../Tools/Disasm/README.md)

- [Архитектура и загрузка](Architecture.md)
- [Форматы данных и ресурсов](DataFormats.md)
- [Runtime-копии, рабочие области и банки](Runtime.md)
- [Таблицы генерации мира и армий](GenerationTables.md)
- [Структуры и поля](Structures.md)
- [Битовые флаги и поля](Flags.md)
- [Графика, шрифты и карты](Graphics.md)
- [Соглашения оформления HoMM](HoMMConventions.md)
- [Границы проверки](VerificationLimits.md)
- [Сохранённые результаты сборки](Build.md)
- [Полный журнал проверочной сборки](BuildLog.md)

## Навигация по исходникам и данным

- [Процедуры и точки входа](Functions.md)
- [Символы, адреса и смещения](Symbols.md)
- [Матрица коэффициентов существ](UnitMatchups.md)
- [Каталог TR-DOS](DiskCatalog.md)
- [Листинг BASIC](BasicListing.md)
- [Пути загрузки и форматы сцен](AnimationResources.md)

## Подробные разборы ветвей

- [Движение соседних армий](NearbyArmiesBranches.md)
- [Шестибайтовые объекты карты](SixByteObjectsBranches.md)
- [Мятежи](RebellionBranches.md)
- [События замков](CastleEventBranches.md)

## Извлечённые тексты игры

- [Оригинальная справка](OriginalHelp.md)
- [Тексты героев HERTXT](Text_HERTXT.md)
- [Названия NAZWANIE](Text_NAZWANIE.md)
- [Тексты TEXT](Text_TEXT.md)

## Машинные реестры и отчёты

JSON и TSV в [`Tools/Disasm/Reports`](../Tools/Disasm/Reports) хранят точные данные для инструментов и дополняют описания Markdown.
Реестры структур, флагов, процедур и символов обновляются по действующим объявлениям. Исторические имена сохраняются отдельно, доказательства сохраняют привязку к исходным операциям.

Компоновка, побайтовая проверка, принятие синтаксиса ассемблером и работа в эмуляторе — отдельные виды проверки. Границы каждого результата указаны в соответствующем отчёте.

| файл | формат |
| --- | --- |
| [AnimationAnnotations.json](../Tools/Disasm/Reports/AnimationAnnotations.json) | JSON |
| [AnimationResources.json](../Tools/Disasm/Reports/AnimationResources.json) | JSON |
| [AssetCatalog.json](../Tools/Disasm/Reports/AssetCatalog.json) | JSON |
| [BankLoads.json](../Tools/Disasm/Reports/BankLoads.json) | JSON |
| [BattleAnnotations.json](../Tools/Disasm/Reports/BattleAnnotations.json) | JSON |
| [BattleRecord.json](../Tools/Disasm/Reports/BattleRecord.json) | JSON |
| [BootHelpersAnnotations.json](../Tools/Disasm/Reports/BootHelpersAnnotations.json) | JSON |
| [BootstrapAndOverlayAnnotations.json](../Tools/Disasm/Reports/BootstrapAndOverlayAnnotations.json) | JSON |
| [BootUIAnnotations.json](../Tools/Disasm/Reports/BootUIAnnotations.json) | JSON |
| [BuildVerification.json](../Tools/Disasm/Reports/BuildVerification.json) | JSON |
| [coverage.json](../Tools/Disasm/Reports/coverage.json) | JSON |
| [DataTables.json](../Tools/Disasm/Reports/DataTables.json) | JSON |
| [EngineAnnotations.json](../Tools/Disasm/Reports/EngineAnnotations.json) | JSON |
| [Flags.json](../Tools/Disasm/Reports/Flags.json) | JSON |
| [functions.json](../Tools/Disasm/Reports/functions.json) | JSON |
| [Functions.tsv](../Tools/Disasm/Reports/Functions.tsv) | TSV |
| [GlobalState.json](../Tools/Disasm/Reports/GlobalState.json) | JSON |
| [GraphicsConsumerVerification.json](../Tools/Disasm/Reports/GraphicsConsumerVerification.json) | JSON |
| [GraphicsFormats.json](../Tools/Disasm/Reports/GraphicsFormats.json) | JSON |
| [HelpDecryption.json](../Tools/Disasm/Reports/HelpDecryption.json) | JSON |
| [InstructionReference.json](../Tools/Disasm/Reports/InstructionReference.json) | JSON |
| [KeyboardDispatch.json](../Tools/Disasm/Reports/KeyboardDispatch.json) | JSON |
| [MenuAnnotations.json](../Tools/Disasm/Reports/MenuAnnotations.json) | JSON |
| [NearbyArmiesAnnotations.json](../Tools/Disasm/Reports/NearbyArmiesAnnotations.json) | JSON |
| [Overlay13_22Annotations.json](../Tools/Disasm/Reports/Overlay13_22Annotations.json) | JSON |
| [Overlays.json](../Tools/Disasm/Reports/Overlays.json) | JSON |
| [PRESAnnotations.json](../Tools/Disasm/Reports/PRESAnnotations.json) | JSON |
| [PRESGraph.json](../Tools/Disasm/Reports/PRESGraph.json) | JSON |
| [PRESGraphicsChunks.json](../Tools/Disasm/Reports/PRESGraphicsChunks.json) | JSON |
| [PRESLayout.json](../Tools/Disasm/Reports/PRESLayout.json) | JSON |
| [ProtectionContracts.json](../Tools/Disasm/Reports/ProtectionContracts.json) | JSON |
| [ProtectionLayers.json](../Tools/Disasm/Reports/ProtectionLayers.json) | JSON |
| [ProtectionSimulation.json](../Tools/Disasm/Reports/ProtectionSimulation.json) | JSON |
| [RebellionAnnotations.json](../Tools/Disasm/Reports/RebellionAnnotations.json) | JSON |
| [ScreenAssets.json](../Tools/Disasm/Reports/ScreenAssets.json) | JSON |
| [ScreenDecodeVerification.json](../Tools/Disasm/Reports/ScreenDecodeVerification.json) | JSON |
| [SixByteObjectsAnnotations.json](../Tools/Disasm/Reports/SixByteObjectsAnnotations.json) | JSON |
| [SoldierRecords.json](../Tools/Disasm/Reports/SoldierRecords.json) | JSON |
| [SourceAudit.json](../Tools/Disasm/Reports/SourceAudit.json) | JSON |
| [StaticVerification.json](../Tools/Disasm/Reports/StaticVerification.json) | JSON |
| [Structures.json](../Tools/Disasm/Reports/Structures.json) | JSON |
| [SemanticNames.json](../Tools/Disasm/Reports/SemanticNames.json) | JSON |
| [Symbols.json](../Tools/Disasm/Reports/Symbols.json) | JSON |
| [Symbols.tsv](../Tools/Disasm/Reports/Symbols.tsv) | TSV |
| [UnitMatchups.tsv](../Tools/Disasm/Reports/UnitMatchups.tsv) | TSV |

- [Имена и комментарии исходников](Naming.md)

- [ReadabilityAudit.json](../Tools/Disasm/Reports/ReadabilityAudit.json)

- [SymbolAudit.json](../Tools/Disasm/Reports/SymbolAudit.json)

- [ConditionalCommentAudit.json](../Tools/Disasm/Reports/ConditionalCommentAudit.json)

- [VerifierGuards.json](../Tools/Disasm/Reports/VerifierGuards.json)

- [GenerationTables.json](../Tools/Disasm/Reports/GenerationTables.json)

- [RuntimeSymbols.json](../Tools/Disasm/Reports/RuntimeSymbols.json)

- [PointerNames.json](../Tools/Disasm/Reports/PointerNames.json)

- [Проверка именованных битов](../Tools/Disasm/Reports/FlagConstantsVerification.json)

- [Проверка загрузки в эмуляторе](RuntimeVerification.md)
