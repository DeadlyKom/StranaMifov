from pathlib import Path
import json

work=Path(__file__).resolve().parent
dest=work/'semantic'
dest.mkdir(exist_ok=True)

def field(offset,size,name,meaning,evidence):
    return dict(offset=offset,size=size,name=name,meaning=meaning,evidence=evidence,confidence='proven')

structures=[dict(name='FSoldier',size=42,purpose='описатель типа существа, SOLDIERS, 25 записей',fields=[
    field(0,12,'Name','имя CP866, дополненное пробелами','SOLDIERS, меню #62D8'),
    field(12,1,'NameEnd','нулевой терминатор имени','SOLDIERS, #7117'),
    field(13,1,'MoveFlags','первый байт способностей, младшие 3 бита копируются в боевые флаги','head #7AEF, #883A'),
    field(14,1,'ExtraFlags','второй байт флагов, возвращаемый в D без назначения всех битов','head #7AEF'),
    field(15,1,'Actions','исходное число действий на раунд','head #883A, battle #F578'),
    field(16,1,'ActionStock','запас расходуемого дальнего действия','head #883A, battle #D5BB'),
    field(17,1,'SectID','секта типа, 0 без поправки, 5 либо совпадение с сектой героя повышает совместимость','head #896D/#89C7..#89D7, O03'),
    field(18,1,'SpawnClass','категория 1..4 при выборе начального типа','BL3 #7808'),
    field(19,1,'UpgradeID','ID замены по служебному порогу участия','head #9EF8..#9F18'),
    field(20,1,'DegradeID','ID замены при утрате квалификации, 0 запрещает замену','head #9F5B..#9F75'),
    field(21,1,'SpecialFlags','особые способности, ограничение восстановления и участие в перевозке','battle #F2F1/#F337, O11:B200'),
    field(22,2,'UnitValue','вес одного воина в оценке армии и цене найма корабля','battle #E8AD, O02:B7EB'),
    field(24,2,'Upkeep','расходы на содержание одного воина','head #9E86, включение в расходы #95F7'),
    field(26,2,'BattleValue','вес одного воина в общей оценке армии при начале и завершении боя','battle #F4A3, #FAAF, head #89E0'),
    field(28,4,'Unknown1C','четыре сохраняемых байта','исходная запись +#1C..+#1F'),
    field(32,2,'SpawnCount','начальная численность создаваемой шестибайтовой группы','BL3 #7808 и потребитель генерации'),
    field(34,2,'DamageSpread','слово разброса урона, удваивается только младший байт E без переноса в D','battle #F15C..#F162, #F210..#F216, #F3AA..#F3B0'),
    field(36,2,'DamageDivisor','делитель базовой формулы урона','battle #F166..#F16C, #F21A..#F220, #F38B'),
    field(38,1,'SiteGrowthDiv','делитель недельного прироста в строениях и гарнизонах','head #A136 -> #A204'),
    field(39,1,'ArmyGrowthDiv','делитель недельного прироста внешней армии и армии героя','head #A190 -> #A204'),
    field(40,1,'UpgradeLimit','порог служебного счётчика для первой замены','head #9F01'),
    field(41,1,'DegradeDays','порог дней без боя, исходная ветвь требует также ненулевой DegradeID','head #9F64, скрытый редактор SOLDIERS')]),
dict(name='FBattleUnit',size=18,purpose='рабочий отряд боя, две армии по 5 записей',fields=[
    field(0,1,'UnitID','ID типа, 0 завершает плотный список','head #883A, battle #F864'),
    field(1,1,'Affinity','знаковая совместимость состава от -2 до 2, для выбора поправки прибавляется 3','head #896D, battle #D485..#D49B, #F17C..#F192'),
    field(2,5,'Quantity','пятибайтовое число ROM, сохраняет дробные потери','head #883A, battle #F0A0'),
    field(7,1,'BaseActions','число действий в начале раунда','head #883A, battle #F578'),
    field(8,1,'ActionStock','остаток расходуемого дальнего действия','battle #D5BB, #E117'),
    field(9,1,'Flags','способности и временные отметки раунда, цели и контроля','battle #F556, #E0E8, #E7A5, #F62D'),
    field(10,1,'X','колонка 0..7','battle #F65E'),
    field(11,1,'Y','строка 0..4','battle #F65E'),
    field(12,1,'ActionsLeft','оставшиеся действия текущего раунда','battle #D2B5, #F578'),
    field(13,1,'Effect','старшая тетрада вид эффекта, младшая оставшаяся длительность','battle #F5FF'),
    field(14,2,'InitialCount','исходное целое количество, ограничивает восстановление','head #883A, battle #F337'),
    field(16,2,'Unknown10','два сохраняемых служебных байта','обнуление #883A и копирование записей #F864')]),
dict(name='FMenuRect',size=4,purpose='прямоугольник пункта меню в знакоместах',fields=[
    field(0,1,'Left','левая включённая граница','head #787E'),
    field(1,1,'Top','верхняя включённая граница','head #787E'),
    field(2,1,'Right','правая исключённая граница','head #787E'),
    field(3,1,'Bottom','нижняя исключённая граница','head #787E')]),
dict(name='FMenuHeader',size=7,purpose='фиксированная часть меню, далее N записей FMenuRect',fields=[
    field(0,1,'Count','число пунктов меню','head #77A1/#787E'),
    field(1,1,'MinX','минимальная X указателя','head #77A1'),
    field(2,1,'MinY','минимальная Y указателя','head #77A1'),
    field(3,1,'MaxX','максимальная X указателя','head #77A1'),
    field(4,1,'MaxY','максимальная Y указателя','head #77A1'),
    field(5,1,'CursorX','сохраняемая пиксельная X указателя','head #77A1/#791E'),
    field(6,1,'CursorY','сохраняемая пиксельная Y указателя','head #77A1/#791E')]),
dict(name='FTile32',size=144,purpose='непрозрачный тайл или портрет 32 на 32 пикселя',fields=[
    field(0,128,'Pixels','32 строки по 4 байта пикселей, бит 7 слева','head #7545/#75E1'),
    field(128,16,'Attributes','4 строки по 4 атрибута знакомест','head #7545/#75E1')]),
dict(name='FMasked32',size=256,purpose='маскированный кадр 32 на 32 пикселя',fields=[
    field(0,128,'Pixels','передний слой INK, 32 строки по 4 байта','head #75A2/#7649'),
    field(128,128,'Mask','маска, единица сохраняет соответствующий бит фона','head #75A2/#7649')]),
dict(name='FPictureHeader',size=5,purpose='заголовок RLE-изображения HERIMG, BL1 и BL2',fields=[
    field(0,2,'NextOffset','следующий заголовок равен текущий адрес +1+NextOffset','распаковщик +#21..+#25'),
    field(2,1,'FirstThird','начальная треть экрана 0..2','распаковщик +#32'),
    field(3,1,'ThirdCount','число третей 1..3','распаковщик +#3D'),
    field(4,1,'Flags','бит 0 задаёт порядок обхода пикселей, биты 2/3 рабочие','распаковщик +#42, +#80, +#E4')]),
dict(name='FFrameRef',size=3,purpose='ссылка на кадр в расширенной памяти',fields=[
    field(0,1,'Bank','логический банк графического ресурса','head #7366/#8104'),
    field(1,2,'Address','адрес кадра в окне памяти','head #7366/#8104')])]

for record in structures:
    cursor=0
    for part in record['fields']:
        assert part['offset']==cursor,(record['name'],part)
        cursor+=part['size']
    assert cursor==record['size']
(dest/'unit_structures.json').write_text(json.dumps(structures,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Structures:',len(structures))
