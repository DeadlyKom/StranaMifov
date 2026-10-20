; имена существующих системных адресов и курсорных смещений, память не выделяют

                module Screen
PairRight       EQU 1                                                           ; правый байт двухбайтовой пиксельной строки шестипиксельного глифа
RowBytes        EQU 32                                                          ; число байтов пикселей или атрибутов в строке знакомест
                endmodule

                module FTargetRule
Count           EQU -1                                                          ; курсор у первого условия группы, Count слева, Value начальное смещение CP, фактическое смещение изменяется через ChooseTarget.RuleOffset
Value           EQU 0                                                           ; курсор у первого условия группы, Count слева, Value начальное смещение CP, фактическое смещение изменяется через ChooseTarget.RuleOffset
                endmodule

                module System
LastKey         EQU #5C08                                                       ; код последней клавиши LAST_K
Frames          EQU #5C78                                                       ; трёхбайтный счётчик кадров ROM
ErrorSP         EQU #5C3D                                                       ; указатель стека возврата при ошибке BASIC
CurrentChannel  EQU #5C51                                                       ; CURCHL, текущий канал вывода BASIC
                endmodule

                module TrDos
Error           EQU #5D10                                                       ; старший байт ошибки TR-DOS
ReturnHook      EQU #5CC2                                                       ; код временного перехвата возврата TR-DOS, RET либо JP
ReturnTarget    EQU #5CC3                                                       ; операнд адреса временного перехвата TR-DOS
IOMode          EQU #5CCE                                                       ; режим секторной операции, #00 чтение, #FF запись
Descriptor      EQU #5CDD                                                       ; рабочий 16-байтовый описатель файла TR-DOS
LoadAddress     EQU #5CE6                                                       ; адрес загрузки в рабочем описателе файла
FileLength      EQU #5CE8                                                       ; длина файла в рабочем описателе
SectorCount     EQU #5CEA                                                       ; число секторов файла в рабочем описателе
FileSector      EQU #5CEB                                                       ; сектор и дорожка начала файла в рабочем описателе
NextSector      EQU #5CF4                                                       ; сектор и дорожка после последнего чтения TR-DOS
Drive           EQU #5D16                                                       ; текущий номер привода TR-DOS
DriveModes      EQU #5CC8                                                       ; четыре байта типов дисководов A..D, заставка использует два перекрывающихся слова для начального состояния генератора
Service         EQU #3D13                                                       ; вход API TR-DOS, код операции в регистре C
                endmodule

                module Memory
BankAF          EQU Memory.CurrentBank - 1                                      ; слово для сохранения банка через PUSH word и POP AF, банк в старшем байте
                endmodule

                module Scene
Number          EQU #C002                                                       ; номер выбранной сцены в загруженном BL1/BL2
                endmodule

                module State
; -----------------------------------------
; State.DefenseSpell
;      7    6    5    4    3    2    1    0
;   +----+----+----+----+----+----+----+----+
;   | .. | .. | .. | .. | .. | .. | .. | CK |
;   +----+----+----+----+----+----+----+----+
;
;   флаги:
;   CK       [0] - разрешает предложить магическое вмешательство героя в защиту замка
;     DEFENSE_OK_BIT
; -----------------------------------------
DefenseSpell    EQU #6A0D                                                       ; состояние заклинания вмешательства в осаду, бит0 разрешает проверку
ReturnCost      EQU #69D9                                                       ; магическая стоимость возврата к сохранённой армии после защиты замка
ReturnMode      EQU #69DB                                                       ; сохранённый MoveFlags героя до переноса к осаждённому замку
ReturnPosition  EQU #69DC                                                       ; сохранённая клетка героя до переноса к осаждённому замку
ReturnArmy      EQU #69DE                                                       ; сохранённые пять FTroop армии героя до переноса к осаждённому замку
Wins            EQU State.Hero + FPerson.Wins                                   ; счётчик побед героя, ResolveLosses увеличивает младший байт, город читает слово
Losses          EQU State.Hero + FPerson.Losses                                 ; счётчик поражений героя, ResolveLosses увеличивает младший байт, город читает слово
                endmodule

                module Loader
                module Menu
UnitBuffer      EQU #7724                                                       ; буфер редактора SOLDIERS либо загружаемой справки скрытого меню
HeadSector      EQU #7C38                                                       ; буфер сектора head.co с настройкой деградации
DegradeSwitch   EQU #7C41                                                       ; байт настройки деградации в загруженном секторе head.co
                endmodule
                endmodule

                module Font
IndexBase       EQU Font.LoadAddress - 32 * 8                                   ; смещённая база шрифта для обращения по восьмибайтному коду символа
LoadAddress     EQU #E0D0                                                       ; начало файла DATA2, коды шрифта32..255 после загрузки в логический банк11
                endmodule

                module Graphics
HeroPortrait    EQU #EF30                                                       ; адрес текущего портрета IP? после загрузки в логический банк4
                endmodule

                module Loader
                module Menu
Directory       EQU #D800                                                       ; буфер восьми секторов каталога TR-DOS
EraseTail       EQU #7918                                                       ; первый байт хвостовой области, стираемой перед переносом KB.co
                endmodule
                endmodule

                module Loader
                module Sectors
IMVector        EQU #E2DB                                                       ; начало заполнения RST-вектора для аппаратной проверки загрузчика
                endmodule
                endmodule

                module MapConst
FogIndex        EQU Memory.Window - (MapConst.Height + 1) * MapConst.FogRowBytes; смещённая база битовых карт открытия, индексы континента и строки начинаются с1
FogRowBytes     EQU #0015                                                       ; число байтов битовой карты открытия на 161 клетку строки
RowIndex        EQU Memory.Window - MapConst.Width                              ; смещённая база стратегической карты перед первой строкой
                endmodule

                module Memory
BankWindow      EQU #C000                                                       ; начало 16-килобайтного окна выбранного логического банка
PageWindow      EQU #C000                                                       ; начало отображаемого окна памяти, пробная ячейка проверки банка
Window          EQU #C000                                                       ; начало переключаемого окна RAM, конкретный логический банк задаёт вызывающий код
                endmodule

                module Overlay
Storage         EQU #C000                                                       ; первый упакованный оверлей в выбранном логическом банке12/13
                endmodule

                module Protection
                module Move
InnerSource     EQU #61B4                                                       ; исходный адрес закодированного внутреннего слоя в перенесённом KB.co
                endmodule
                endmodule

                module Rom
CopyBytes       EQU #33C3                                                       ; LDIR и возврат ROM, копирует загруженный KB.co в Protection.Outer.Decode
KeyScan         EQU #028E                                                       ; опрос клавиатурной матрицы, вызывающий код проверяет E=#FF
PopA            EQU #2DD5                                                       ; преобразование вершины калькулятора в байтовое A
PopBC           EQU #2DA2                                                       ; преобразование вершины калькулятора в целое BC
PopFloat        EQU #2BF1                                                       ; снятие пятибайтного числа калькулятора в A,E,D,C,B
Return          EQU #007C                                                       ; команда RET в ROM, распаковщик сохраняет оставшийся на стеке адрес возврата CALL
ScanKeyboard    EQU #028E                                                       ; сканер клавиатуры ROM
ScanKeys        EQU #028E                                                       ; сканер клавиатуры ROM, E=#FF означает отсутствие клавиши
ScanKeys128     EQU #386E                                                       ; обработчик клавиатуры ПЗУ Spectrum 128, KEYS, сохраняет IX и вызывает KEYBOARD
StackA          EQU #2D28                                                       ; помещение байтового целого A на стек калькулятора
StackBC         EQU #2D2B                                                       ; помещение целого BC на стек калькулятора
StackFloat      EQU #2ABB                                                       ; помещение пятибайтного числа A,E,D,C,B на стек калькулятора
Start           EQU #0000                                                       ; вход сброса ROM, также первые байты ROM служат XOR-ключом таблицы победителей
                endmodule

                module Runtime
Castles         EQU #C000                                                       ; 80 записей FCastle текущего мира в логическом банке 0
CurrentMap      EQU #C000                                                       ; карта выбранного континента в логическом банке 10
ExploreIndex    EQU #B7B7                                                       ; смещённая база четырёх битовых карт открытия
RestartSP       EQU #5F98                                                       ; вершина стека перед повторной загрузкой BL3
ScoreTable      EQU #C000                                                       ; буфер таблицы победителей в банке 0
UnitBackdrop    EQU #EFC0                                                       ; 16-знакоместная копия рисунка нанимаемого типа
UnitTextIndex   EQU #E7CF                                                       ; база перед разделителем описаний типов существ в DATA2
                endmodule

                module Scene
Entry           EQU #C000                                                       ; одинаковый вход декодера BL1/BL2 в выбранном банке14/15
                endmodule

                module Screen
Attributes      EQU #5800                                                       ; начало основной области атрибутов Spectrum
Pixels          EQU #4000                                                       ; начало пикселей экрана
                endmodule

                module Startup
IM2Vectors      EQU #6000                                                       ; таблица257векторов IM2 начального модуля
ResumeEntry     EQU #FF00                                                       ; перемещённая программа окончательной загрузки head.co
                endmodule

                module StartupTables
ArmyWeights     EQU #D092                                                       ; континентальные таблицы генерации подвижных армий банка3
CastleNames     EQU #C000                                                       ; 80 записей названий замков по16байтов в логическом банке1
CastleWeights   EQU #CE3A                                                       ; континентальные таблицы генерации армий замков банка3
Directory       EQU #C000                                                       ; буфер каталога сохранений в логическом банке3
FontGlyphs      EQU #C000                                                       ; первый глиф шрифта, код 32, в логическом банке 3
HeroStories     EQU #D6FF                                                       ; перемещённый блок HERTXT в логическом банке 0
ManaPools       EQU #D2EA                                                       ; последовательные группы MGPOWERn банка3
RoamWeights     EQU #CD72                                                       ; континентальные таблицы выбора типов странствующих отрядов банка3
SaveHeader      EQU #C700                                                       ; буфер 256байтного заголовка загружаемого сохранения в банке3
SiteWeights     EQU #CB1A                                                       ; континентальные таблицы гарнизонов объектов банка3
TownNames       EQU #C500                                                       ; 160 записей названий городов по12байтов в логическом банке1
                endmodule

                module StartupWorld
Items           EQU #992B                                                       ; начало создаваемой группы Items в банке0
MapArmies       EQU #A28B                                                       ; начало создаваемой группы MapArmies в банке0
MapTroops       EQU #A033                                                       ; начало создаваемой группы MapTroops в банке0
SitesA          EQU #965B                                                       ; начало создаваемой группы SitesA в банке0
SitesB          EQU #970F                                                       ; начало создаваемой группы SitesB в банке0
SitesC          EQU #97C3                                                       ; начало создаваемой группы SitesC в банке0
SitesD          EQU #9877                                                       ; начало создаваемой группы SitesD в банке0
                endmodule

                module State
AllArmies       EQU #C000                                                       ; начало физических FMapArmy логического банка1
AllCastles      EQU #C000                                                       ; начало 80 физических записей FCastle в логическом банке0
LoadedGame      EQU #C700                                                       ; временный 256-байтный снимок игры банка3 до загрузки рабочих таблиц, записывается Startup и копируется Initialize
ViewCounts      EQU State.ViewObjects + 48 * FScreenObject20                    ; 48 двухбайтных численных подписей экранных объектов
                endmodule

                module System
FlagsAnchor     EQU #5C3A                                                       ; системная база IY, ERR_NR перед FLAGS
IM2Vectors      EQU #6000                                                       ; существующая таблица IM2, Initialize заполняет 257 байт значением #61
IYBase          EQU #5C3A                                                       ; стандартная база IY системных переменных перед внешним ROM/TR-DOS вызовом
Reset           EQU #0000                                                       ; вход сброса, используется при нарушении проверки CALL
Vars            EQU #5C3A                                                       ; база системных переменных ROM в IY для BASIC и TR-DOS
                endmodule

                module UnitTypes
RuntimeBase     EQU #C000                                                       ; дескрипторы SOLDIERS после загрузки в логический банк3, файловый origin UnitTypes.Peasants имеет другое значение
                endmodule

                module TrDos
DriveReturn     EQU #2A53                                                       ; адрес на стеке перед внутренним входом SelectDrive, контракт зависит от версии TR-DOS
DriveEntry      EQU #3D2F                                                       ; внутренний вход из SelectDrive с C=#FF, контракт зависит от версии TR-DOS
                endmodule
