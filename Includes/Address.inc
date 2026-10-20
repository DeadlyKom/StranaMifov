; исходные адреса, объявления EQU не выделяют память

                module Memory
CurrentBank     EQU #5FA0                                                       ; текущий логический банк
SelectBank      EQU #5FA1                                                       ; установленный драйвер выбора банка
                endmodule

                module Overlay
Entry           EQU #B200                                                       ; область исполнения выбранного оверлея
                endmodule

                module State
AwaySteps       EQU #9294                                                       ; смещённая база направлений отступления от героя
TowardSteps     EQU #92A4                                                       ; смещённая база направлений движения к герою
OverlayKeys     EQU #653A                                                       ; таблица соответствия кодов клавиш и номеров оверлеев
ObjectOverlays  EQU #6550                                                       ; таблица оверлеев для типов объектов карты
Bank            EQU #5FA0                                                       ; текущий логический банк
BankDriver      EQU #5FA1                                                       ; установленная точка переключения банков, исполняемый код
Overlay         EQU #655E                                                       ; номер загруженного рабочего оверлея
CursorDelay     EQU #655F                                                       ; счётчик кадров до смены символа курсора
CursorGlyph     EQU #6560                                                       ; текущий символ анимации курсора #F2..#F5
FrameCount      EQU #6561                                                       ; число маскируемых прерываний по модулю 65536
CursorPos       EQU #6563                                                       ; позиция BC анимируемого символа

; -----------------------------------------
; State.EventFlags, адрес #6565
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | NE | .. | .. | .. | .. | .. | .. | .. |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   NE       [7]      - флаг, 1 временно запрещает развитие отрядов и отдельные события замков,
;     0 допускает их проверки
; .. [6, 5, 4, 3, 2, 1, 0] - назначение не установлено
; Проверено по потребителям:
;   Source/Engine/DevelopTroops.asm, #9ECD/#9ECF
;   Source/Engine/TickCastle.asm, #A5C0/#A76F
;   Source/Overlays/Sail.asm, #B288/#B2B7
; -----------------------------------------
EventFlags      EQU #6565                                                       ; бит 7 временно запрещает ряд мировых событий и развития отрядов, остальные биты не именуются

; -----------------------------------------
; State.ViewFlags, адрес #6566
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | RU | CU | DG | .. | OB | CS | .. |
;   +----+----+----+----+----+----+----+----+
;
;   флаги и поля:
;   RU       [6]      - флаг, 1 включает табличное преобразование ввода в русский алфавит, 0
;     оставляет обычный код
;   CU       [5]      - флаг, 1 включает анимируемый символ текстового курсора в прерывании
;   DG       [4]      - флаг, 1 ограничивает обычный ввод цифрами 0..9, служебные коды удаления
;     и завершения сохраняются
;   OB       [2]      - флаг, 1 разрешает обработку экранных объектов из прерывания, 0 запрещает
;   CS       [1]      - флаг, переключение регистра латинских букв, 1 меняет A..Z с a..z местами
;     при вводе
; .. [7, 3, 0] - назначение не установлено
; Проверено по потребителям:
;   Source/Engine/ReadTextChar.asm, #6EC7/#6EEC/#6EF8/#6F04/#6EDE/#6EE2/#6EE6/#6EB9/#6F06/#6F08/#6F10/#6F15/#6F1A
;   Source/Engine/Interrupt.asm, #61B1/#6187
;   Source/Engine/StartView.asm, #6D5B
;   Source/Engine/StopView.asm, #6D38
;   Source/Engine/EditNumber.asm, #6FC3
;   Source/Engine/EditText.asm, #6E23/#6E36
; -----------------------------------------
ViewFlags       EQU #6566                                                       ; бит 2 разрешает #8104 из прерывания, бит 5 включает анимируемый символ
FloatA          EQU #6567                                                       ; первое пятибайтное рабочее число калькулятора, используется расчётами лидерства и боя
FloatB          EQU #656C                                                       ; второе пятибайтное рабочее число калькулятора, используется расчётами лидерства и боя
ViewObjects     EQU #6571                                                       ; 48 экранных записей по 20 байт, формат уточняется графическими метаданными
MoveTarget      EQU #69D5                                                       ; целевая клетка автоматического движения
StepCost        EQU #69D7                                                       ; прибавляемая стоимость шага в долях 1/256 дня
EventMarker     EQU #69D8                                                       ; #A5AE пишет 1, более узкий смысл не установлен
Game            EQU #69ED                                                       ; FGameState
Difficulty      EQU #69EE                                                       ; сложность 1..3
SaveName        EQU #69EF                                                       ; имя файла сохранения с 0
Hero            EQU #69F8                                                       ; FPerson
Leadership      EQU #6A02                                                       ; лидерство
Mana            EQU #6A04                                                       ; текущая магическая сила героя
ManaMax         EQU #6A06                                                       ; максимальная магическая сила героя
ManaRegen       EQU #6A08                                                       ; пополнение магической силы героя
Spells          EQU #6A0A                                                       ; десять состояний заклинаний
Money           EQU #6A14                                                       ; наличные Float5
BaseIncome      EQU #6A19                                                       ; базовая часть недельного дохода Float5
Army            EQU #6A1E                                                       ; пять FTroop армии героя
Continent       EQU #6A2D                                                       ; текущий континент
Position        EQU #6A2E                                                       ; X/Y героя в C/B
ShipMap         EQU #6A30                                                       ; континент корабля
ShipPos         EQU #6A31                                                       ; X/Y корабля, #FFFF нет
MoveFlags       EQU #6A33                                                       ; режим движения и флаги героя
MapFlags        EQU #6A34                                                       ; доступность карт
DayFraction     EQU #6A35                                                       ; дробная часть дня
Days            EQU #6A36                                                       ; прошедшие дни
Deadline        EQU #6A38                                                       ; предел дней
Contract        EQU #6A3A                                                       ; номер контрактного замка
Cult            EQU #6A3B                                                       ; секта героя
GoodStoryPos    EQU #6A44                                                       ; клетка доброго рассказчика
GoodStoryMap    EQU #6A46                                                       ; континент доброго рассказчика
GoodVisits      EQU #6A49                                                       ; число встреч с добрым рассказчиком
BadStoryPos     EQU #6A4B                                                       ; клетка враждебного рассказчика
BadStoryMap     EQU #6A4D                                                       ; континент враждебного рассказчика
BadVisits       EQU #6A50                                                       ; число встреч с враждебным рассказчиком
PuzzleOpen      EQU #6A55                                                       ; открытые части карты цели
PuzzleTiles     EQU #6A5A                                                       ; эталон 5x5 карты цели
IdleIndex       EQU #6A72                                                       ; база на 1 байт перед 25 счётчиками дней по ID
IdleDays        EQU #6A73                                                       ; счётчики дней по ID1..25
UpgradeIndex    EQU #6A8B                                                       ; база на 1 байт перед 25 счётчиками развития по ID
UpgradeCount    EQU #6A8C                                                       ; счётчики развития по ID
Attacker        EQU #6AAA                                                       ; кто угрожает замку, 0 нет
AttackDays      EQU #6AAB                                                       ; дни до разрешения угрозы
AttackCastle    EQU #6AAC                                                       ; адрес физической записи атакуемого замка
AttackArmy      EQU #6AAE                                                       ; пять FTroop нападающей армии
ControlIndex    EQU #6AD3                                                       ; база на 1 байт перед 25 коэффициентами контроля
UnitControl     EQU #6AD4                                                       ; коэффициенты контроля по ID
CastlesIndex    EQU #6AE9                                                       ; база на 4 байта перед дескрипторами FMapList континентов 1..4, FCastle
CastlesLists    EQU #6AED                                                       ; четыре реальные записи FMapList, континенты 1..4, FCastle
TownsIndex      EQU #6AF9                                                       ; база на 4 байта перед дескрипторами FMapList континентов 1..4, FTown
TownsLists      EQU #6AFD                                                       ; четыре реальные записи FMapList, континенты 1..4, FTown
TemplesIndex    EQU #6B09                                                       ; база на 4 байта перед дескрипторами FMapList континентов 1..4, FTemple
TemplesLists    EQU #6B0D                                                       ; четыре реальные записи FMapList, континенты 1..4, FTemple
SitesAIndex     EQU #6B19                                                       ; база на 4 байта перед дескрипторами FMapList континентов 1..4, FMapTroop
SitesALists     EQU #6B1D                                                       ; четыре реальные записи FMapList, континенты 1..4, FMapTroop
SitesBIndex     EQU #6B29                                                       ; база на 4 байта перед дескрипторами FMapList континентов 1..4, FMapTroop
SitesBLists     EQU #6B2D                                                       ; четыре реальные записи FMapList, континенты 1..4, FMapTroop
SitesCIndex     EQU #6B39                                                       ; база на 4 байта перед дескрипторами FMapList континентов 1..4, FMapTroop
SitesCLists     EQU #6B3D                                                       ; четыре реальные записи FMapList, континенты 1..4, FMapTroop
SitesDIndex     EQU #6B49                                                       ; база на 4 байта перед дескрипторами FMapList континентов 1..4, FMapTroop
SitesDLists     EQU #6B4D                                                       ; четыре реальные записи FMapList, континенты 1..4, FMapTroop
ItemsIndex      EQU #6B59                                                       ; база на 4 байта перед дескрипторами FMapList континентов 1..4, FMapItem
ItemsLists      EQU #6B5D                                                       ; четыре реальные записи FMapList, континенты 1..4, FMapItem
MapTroopsIndex  EQU #6B69                                                       ; база на 4 байта перед дескрипторами FMapList континентов 1..4, FMapTroop
MapTroopsLists  EQU #6B6D                                                       ; четыре реальные записи FMapList, континенты 1..4, FMapTroop
MapArmiesIndex  EQU #6B79                                                       ; база на 4 байта перед дескрипторами FMapList континентов 1..4, FMapArmy
MapArmiesLists  EQU #6B7D                                                       ; четыре реальные записи FMapList, континенты 1..4, FMapArmy
RandomState     EQU #7C6B                                                       ; три слова состояния генератора случайных чисел
CastleName      EQU #867B                                                       ; указатель имени текущего замка, физическая запись+3
ObjectCell      EQU #8D29                                                       ; координаты для поиска #8CD1
Approaching     EQU #9172                                                       ; #FF сближение, #00 отступление при #8DDA
MovingObject    EQU #928F                                                       ; сохранённый адрес текущей движущейся записи
MoveDirection   EQU #9291                                                       ; направление к герою 1..8
NearbyMin       EQU #9292                                                       ; минимальные X/Y области внимания
NearbyMax       EQU #9294                                                       ; максимальные X/Y области внимания, тот же адрес как смещённая база таблицы отступления
StepCandidates  EQU #92B6                                                       ; три записи [маскаместности, X, Y]
SplitArmy       EQU #92BF                                                       ; временная армия до 4 отрядов FTroop
                endmodule
