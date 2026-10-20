"""Статические смысловые метаданные, исходники игры не изменяет."""
from pathlib import Path
import json
import re
import sys

HERE = Path(__file__).resolve().parent
WORK = HERE.parent
sys.path.insert(0, str(WORK))
from analyze import memory, entry

def ev(module, address, operation):
    return {"module": module, "address": int(address, 16), "hex": "#" + address, "operation": operation}

def field(offset, size, name, meaning, evidence, confidence="proven", **extra):
    assert len(name) <= 15, name
    return dict(offset=offset, size=size, name=name, meaning=meaning,
                evidence=evidence, confidence=confidence, **extra)

structures = []
def structure(name, size, fields, meaning, **extra):
    assert len(name) <= 15
    occupied = set()
    for f in fields:
        assert f["offset"] >= 0 and f["offset"] + f["size"] <= size, (name, f)
        for i in range(f["offset"], f["offset"] + f["size"]):
            assert i not in occupied, (name, f)
            occupied.add(i)
    assert len(occupied) == size, (name, "неполное покрытие", sorted(set(range(size))-occupied))
    item = dict(name=name, size=size, meaning=meaning, fields=fields, **extra)
    structures.append(item)
    return item

troop_ev = [ev("S10", "887F", "C=(IX+1), B=(IX+2), ID=(IX+0), затем IX+=3 по #88DB"),
            ev("S10", "A205", "сравнение ID и обновление количества +1/+2, IX+=3")]
structure("FTroop", 3, [
    field(0, 1, "ID", "ID типа отряда, 0 завершает плотный список. В финансовом проходе #9B10/#9B14 временно устанавливаются биты 7/6, поэтому не во всех промежуточных состояниях байт является чистым ID", troop_ev + [ev("S10", "9B07", "AND #1F перед #7AEF, затем SET 7/6,(HL)")]),
    field(1, 2, "Count", "беззнаковая численность little-endian", troop_ev, type="WORD")
], "исходная стратегическая запись отряда", count_examples=[5,3], termination="ID=0")

structure("FMapList", 4, [
    field(0, 2, "Data", "адрес первой записи в банке выбранной группы", [ev("S10", "8E16", "L=(IX+0), H=(IX+1), затем IX=HL"), ev("S10", "9307", "L=(IX+0), H=(IX+1), затем IX=HL")], type="WORD"),
    field(2, 2, "Count", "число записей little-endian, не размер в байтах", [ev("S10", "8E1C", "C=(IX+2), B=(IX+3), DEC BC на каждой записи"), ev("S10", "930D", "C=(IX+2), B=(IX+3), DEC BC на каждой записи")], type="WORD")
], "дескриптор списка объектов одного континента", indexing="#7A74 прибавляет 4*A. У публичных баз #6AE9/#6AF9/... индекс начинается с 1, первая реальная запись находится база+4")

structure("FMoveStep",3,[
    field(0,1,"TerrainMask","маска класса местности кандидата, #FF выделяет водный класс, 0 не требует проверки способностей",[ev("S10","9270","для трёх координат вызываются #80C4/#867D и результат пишется в+0"),ev("S10","93E1","ненулевой класс проверяется через способности отряда")]),
    field(1,1,"X","столбец соседней клетки",[ev("S10","9371","кандидат x=(IY+1), допустимо3..157")]),
    field(2,1,"Y","строка соседней клетки",[ev("S10","937E","кандидат y=(IY+2), допустимо3..96")])
],"рабочий кандидат перемещения внешнего объекта",base=0x92B6,array_count=3)

maparmy_flags = [
    {"mask": 1, "name": "Free", "meaning": "свободная/выключенная запись", "evidence": [ev("S10", "8E3B", "AND #11 пропускает бит 0 и бит 4"),ev("S10", "8F69", "BIT 0,(HL) ищет свободную запись")]},
    {"mask": 14, "name": "Delay", "meaning": "упакованная задержка, каждый проход вычитает 2 из маски #0E и пропускает движение", "evidence": [ev("S10", "8E43", "AND #0E, SUB 2, восстановление остальных битов через AND #F1")]},
    {"mask": 16, "name": "Processed", "meaning": "отметка обработки в текущем проходе, в конце снимается у всех", "evidence": [ev("S10", "9150", "SET 4,(IX+0)"),ev("S10", "9169", "RES 4,(HL)")]},
    {"mask": 32, "name": "Water", "meaning": "1 выбирает водный класс #FF и пиратов, 0 наземный класс и разбойников", "evidence": [ev("S10", "8E6B", "AND #20 и сравнение с режимом героя"),ev("O07", "B22A", "BIT 5,(IX-3), выбор строк разбойники/пираты")]},
    {"mask": 64, "name": "Facing", "meaning": "горизонтальная ориентация, #91BF устанавливает/снимает по направлению, отступление дополнительно инвертирует", "evidence": [ev("S10", "91BF", "A=1/5 не меняет бит 6, A=2..4 ставит, A>=6 снимает"),ev("S10", "912D", "XOR #40 при отступлении")]},
    {"mask": 128, "name": "Unknown7", "meaning": "игровой смысл бита 7 не установлен", "evidence": [ev("S10", "8E4D", "AND #F1 сохраняет бит 7 при обновлении задержки")], "confidence": "unknown"}
]
structure("FMapArmy", 22, [
    field(0, 1, "Flags", "состояние внешней армии", [ev("S10", "8E38", "чтение флагов записи с шагом #16")], bits=maparmy_flags),
    field(1, 1, "X", "столбец стратегической карты", [ev("S10", "8E98", "C=(IX+1) перед определением направления"),ev("S10", "9118", "(IX+1)=C")]),
    field(2, 1, "Y", "строка стратегической карты", [ev("S10", "8E9B", "B=(IX+2)"),ev("S10", "911B", "(IX+2)=B")]),
    field(3, 2, "Mana", "текущий запас магической силы внешней армии. Восстанавливается с пределом 15000 и передаётся словом DE в бой", [ev("S10", "A0A9", "HL=word(IX+3), DE=15000, вызов #A0FC, запись обратно +3/+4"),ev("O07", "B29A", "IX уже смещён на +3, DE=word(IX+0), затем IX+=4, бой #D255")], type="WORD"),
    field(5, 2, "ManaRegen", "прибавляемое при регенерации количество магической силы", [ev("S10", "A0B2", "BC=word(IX+5), прибавление к word(IX+3) с насыщением 15000")], type="WORD"),
    field(7, 15, "Army", "пять стратегических отрядов FTroop", [ev("S10", "8E79", "HL=указатель записи+7, B=5, #9193"),ev("O07", "B263", "IY=указатель записи+3, IY+=4, A=5 перед #7E55")], type="FTroop", count=5)
], "подвижная армия разбойников либо пиратов", bank=1,
    notes=["Разделение #8FC5..#9001 создаёт новую запись, но не инициализирует Mana и ManaRegen. Семантическое описание сохраняет эту особенность оригинала."])

structure("FMapTroop", 6, [
    field(0, 1, "Flags", "состояние шестибайтовой группы, бит 0 свободна/использована, бит 5 вода, бит 6 ориентация, другие биты отдельно не именуются", [ev("S10", "931A", "BIT 0,(IX+0)"),ev("S10", "9333", "AND #20"),ev("S10", "9425", "#91BF изменяет бит 6"),ev("O21", "B801", "поиск свободной шестибайтовой записи и заполнение полей")]),
    field(1, 1, "X", "столбец карты", [ev("S10", "941C", "(IX+1)=C")]),
    field(2, 1, "Y", "строка карты", [ev("S10", "941F", "(IX+2)=B")]),
    field(3, 1, "ID", "тип отряда, описатель SOLDIERS", [ev("S10", "93EF", "A=(IX+3), CALL #7AEF"),ev("S10", "ACF1", "тип соседней записи переносится в +3")]),
    field(4, 2, "Count", "беззнаковая численность little-endian", [ev("S10", "ACE9", "проверка пары IY+4/+5"),ev("S10", "AD08", "(IX+4)=C, (IX+5)=B после чтения начальной численности SOLDIERS")], type="WORD")
], "шестибайтовая группа существ на стратегической карте", bank=0,
    notes=["Структура встречается в списке #6B69 и родственных списках #6B19/#6B29/#6B39/#6B49. Роль списка и формат весовых записей WERWOIN различаются.",
           "Обход #92CB после отказа C!=0,8 от #8CD1 может продолжить с изменённым IX, восстановление #928F отсутствует на этом пути."])

structure("FCastle", 35, [
    field(0, 1, "Flags", "бит 0 выключает запись, значения остальных битов отдельно не установлены", [ev("S10", "87B4", "BIT 0,(IX+0), шаг35")]),
    field(1, 1, "X", "столбец карты", [ev("S10", "A607", "координаты атакуемого замка из +1/+2")]),
    field(2, 1, "Y", "строка карты", [ev("S10", "A607", "координаты атакуемого замка из +1/+2")]),
    field(3, 15, "Name", "15 символов имени CP866, допускается редактирование всех 15", [ev("O21", "B200", "интерфейс получает #867B, указатель на имя физической записи+3"),ev("S04", "686B", "#77A3 выбирает имя шаг16 и копирует15символов")], encoding="cp866"),
    field(18, 1, "Terminator", "нулевой терминатор после имени", [ev("S04", "77A3", "после копирования15символов дописывается ноль")]),
    field(19, 1, "Owner", "0 собственный замок, 1..15 правитель FRuler, #FF особое отсутствие правителя/банды", [ev("S10", "87BA", "владелец0 учитывается как собственный"),ev("S10", "87ED", "поиск по заданному владельцу"),ev("S10", "A616", "владелец ближайшего замка определяет нападающего")]),
    field(20, 15, "Army", "пять записей гарнизона FTroop", [ev("S10", "A86A", "15 байтов атакующей армии копируются в гарнизон"),ev("O21", "B200", "гарнизон вычисляется имя+17, то есть запись+20")], type="FTroop", count=5)
], "35-байтная запись замка", bank=0, array_base=0xC000, array_count=80,
    pointer_views=[{"name":"NameView","base_offset":3,"evidence":[ev("S10","8672","IX передаётся через #867B как указатель имени замка")],"warning":"IX+16 от имени соответствует Owner+19 физической записи, IX+17 соответствует Army+20"}])

structure("FMapItem", 3, [
    field(0,1,"Flags","бит0 означает использованную/выключенную находку",[ev("S10","93BF","SET 0,(IX+0) для типа8 от #8CD1")]),
    field(1,1,"X","столбец карты",[ev("S10","8D0D","тип8 выбирает группу #6B59, общий поиск координат +1/+2")]),
    field(2,1,"Y","строка карты",[ev("S10","8D0D","тип8 выбирает группу #6B59, общий поиск координат +1/+2")])
],"трёхбайтовая находка, не FTroop несмотря на одинаковую длину",bank=0)

structure("FTemple", 5, [
    field(0,1,"Flags","бит0 выключает запись",[ev("S10","8D41","дескриптор типа3 задаёт шаг5 и общий поиск")]),
    field(1,1,"X","столбец карты",[ev("S10","8D6E","общий поиск читает +1/+2")]),
    field(2,1,"Y","строка карты",[ev("S10","8D6E","общий поиск читает +1/+2")]),
    field(3,1,"Cult","тип храма/секты",[ev("O03","B211","поле+3 выбирает строку секты и коэффициенты услуг")]),
    field(4,1,"Spell","ID доступного для изучения заклинания",[ev("O03","B247","A=(IX+4), CALL #8066")])
],"запись храма духов",bank=0)

structure("FTown",26,[
    field(0,1,"Flags","бит0 выключает запись, бит1 проверяется при доступности контракта",[ev("S10","A235","таблица #6AF9 и шаг26"),ev("O02","B4EB","BIT 1,(IX-3), IX указывает на имя")]),
    field(1,1,"X","столбец карты",[ev("S10","AE1A","координаты города используются для дохода замка")]),
    field(2,1,"Y","строка карты",[ev("S10","AE1A","координаты города используются для дохода замка")]),
    field(3,11,"Name","11 символов имени CP866",[ev("S04","68F9","выбор уникального имени с шагом12, копирование11символов")]),
    field(14,1,"Terminator","нулевой терминатор имени",[ev("S04","77A3","после копирования имени записывается0")]),
    field(15,2,"Unknown15","пара численных/служебных полей, более узкий смысл не установлен, #AE1A использует их при выборе прибавки дохода350/450",[ev("S10","AE1A","проверки полей15/16 влияют на доход")],"partial"),
    field(17,9,"Army","до трёх отрядов FTroop",[ev("S10","A235","обнуляет9байт с+17, формирует0..3отряда")],type="FTroop",count=3)
],"26-байтная запись города",bank=0)

structure("FRuler",28,[
    field(0,21,"Name","21 символ имени вражеского правителя, дополнение пробелами",[ev("S10","804E","IX=#CCAF+28*ID, ID1 даёт#CCCB"),ev("O17","B6D8","печать имён побеждённых правителей ID1..15"),ev("S46","CCCB","первые21байт записи являются CP866-именем")]),
    field(21,1,"Terminator","ноль после имени",[ev("S46","CCE0","нулевой байт записи0+21")]),
    field(22,2,"Mana","текущая магическая сила",[ev("S10","A0D8","чтение word(IX+22) и восстановление к максимуму+24"),ev("O01","B3CF","DE=word(IX+22) перед #D255"),ev("O01","B3F6","остаток магии из DE записывается в+22/+23")],type="WORD"),
    field(24,2,"ManaMax","максимум магической силы",[ev("S10","A0DE","DE=word(IX+24), общий ограничитель#A0FC")],type="WORD"),
    field(26,2,"ManaRegen","пополнение магической силы за вызов восстановления",[ev("S10","A0E4","BC=word(IX+26), прибавление к word(IX+22)")],type="WORD")
],"описатель правителя в DATA1",bank=3,array_base=0xCCCB,array_count=15)

structure("FSpell",23,[
    field(0,20,"Name","20 символов названия заклинания, дополнение пробелами",[ev("S10","8066","IX=#CE58+23*ID, ID1 даёт#CE6F"),ev("O17","B8F3","печать имён изученных заклинаний ID1..10"),ev("S46","CE6F","первые20байт записи являются CP866-именем")]),
    field(20,1,"Terminator","ноль после имени",[ev("S46","CE83","нулевой байт записи0+20")]),
    field(21,2,"ManaCost","магическая стоимость, также служит основанием цены изучения с множителем100 и модификатором секты",[ev("S47","D996","BC=word(IX+21) после #8066, далее проверка/списание магии"),ev("O03","B251","BC=word(IX+21), умножение на100")],type="WORD")
],"описатель заклинания в DATA1",bank=3,array_base=0xCE6F,array_count=10)

state_copy = [ev("S10","6355","256байт из банк3:#C700 копируются в #69ED"),ev("S04","6C2E","первый блок сохранения начинается #7931, инверсия255байт и запись одного сектора")]
person_copy = [ev("S04","6720","PERSONn загружается в #793C"),ev("S10","6358","соответствие #7931→#69ED через сектор состояния, PERSON+0 соответствует #69F8")]
hero_fields=[]
def hero(address,size,name,meaning,evidence,confidence="proven",**kw):
    hero_fields.append(field(int(address,16)-0x69F8,size,name,meaning,evidence,confidence,**kw))

hero("69F8",9,"Name","имя выбранного героя, девять символов CP866",person_copy+[ev("S10","96AE","строка панели содержит указатель#69F8")])
hero("6A01",1,"Terminator","нулевой терминатор имени",person_copy)
hero("6A02",2,"Leadership","лидерство, задаёт предел количества отряда через деление на коэффициент типа",[ev("S10","86F1","BC=word(#6A02), деление на byte(#6AD3+ID) и floor"),ev("S10","89F9","насыщенное уменьшение"),ev("S10","8A21","насыщенное увеличение")],type="WORD")
hero("6A04",2,"Mana","текущая магическая сила героя",[ev("S10","A082","текущее значение, прибавление#6A08 с максимумом#6A06"),ev("S47","DB75","вычитает стоимость заклинания из#6A04 с насыщением0")],type="WORD")
hero("6A06",2,"ManaMax","максимум магической силы",[ev("S10","A085","верхняя граница DE для#6A04")],type="WORD")
hero("6A08",2,"ManaRegen","пополнение магической силы при очередном восстановлении",[ev("S10","A089","BC=word(#6A08), прибавляется к#6A04")],type="WORD")
hero("6A0A",10,"Spells","10 байтов состояния заклинаний, бит0 — заклинание изучено, остальные биты отдельно не именуются",[ev("O17","B8F3","ID1..10 проверяют бит0 по #6A09+ID")],count=10)
hero("6A14",5,"Money","наличные монеты в пятибайтном формате калькулятора ROM",[ev("S10","9698","панель печатает поле под подписью Наличные"),ev("S10","A395","оплата неподконтрольного отряда вычитает из#6A14")],type="Float5")
hero("6A19",5,"BaseIncome","постоянная часть недельного дохода в формате Float5, складывается с доходами замков",[ev("S10","9766","сумма доходов замков, затем#6A19+#6A14 складываются и пишутся в#6A14"),ev("O05","B42D","награда увеличивает#6A19")],type="Float5")
hero("6A1E",15,"Army","пять записей армии героя FTroop",troop_ev,type="FTroop",count=5)
hero("6A2D",1,"Continent","текущий континент1..4",[ev("S10","63D9","индекс выбирает KARTA?"),ev("S10","9301","выбор континентального списка")])
hero("6A2E",1,"X","столбец текущей клетки героя",[ev("S10","92CB","BC=word(#6A2E), C=x,B=y")])
hero("6A2F",1,"Y","строка текущей клетки героя",[ev("S10","92CB","BC=word(#6A2E), C=x,B=y")])
hero("6A30",1,"ShipMap","континент корабля, #FF означает отсутствие корабля",[ev("O02","B4D8","при отказе от корабля #6A30=#FF"),ev("S10","84B0","континент при размещении корабля")])
hero("6A31",1,"ShipX","столбец корабля, #FF является признаком отсутствия",[ev("S10","64AD","проверка #FF"),ev("O02","B4D2","word(#6A31)=#FFFF при отказе от корабля")])
hero("6A32",1,"ShipY","строка корабля",[ev("S10","84AC","координаты корабля BC=word(#6A31)")])
hero("6A33",1,"MoveFlags","младшие2бита — режим0суша/1корабль/2полёт, бит2 служебный режим вида, биты3/4 ориентация героя/корабля, бит5 наличие осадных орудий. Биты6/7 здесь не установлены",[ev("S10","9330","AND3 сверяется с водным битом группы"),ev("S10","8C04","запись горизонтальной ориентации"),ev("O17","B336","бит5 определяет сообщение об осадных орудиях"),ev("O11","B200","переход к режиму полёта"),ev("O12","B200","выход из режима полёта")])
hero("6A34",1,"MapFlags","флаги доступных полных карт/континентов, биты выбираются по континенту",[ev("O13","B200","по биту текущего континента доступна полная карта"),ev("O14","B200","из флагов строится список континентов")])
hero("6A35",1,"DayFraction","дробная часть дня в единицах1/256, переполнение увеличивает Days",[ev("S10","9708","прибавляется стоимость шага#69D7, перенос увеличиваетword#6A36")])
hero("6A36",2,"Days","счётчик прошедших дней",[ev("S10","9712","при переносе дробной части увеличивается на1"),ev("S10","947E","печать календаря")],type="WORD")
hero("6A38",2,"Deadline","предел числа дней, поражение вызывается именно при Days == Deadline",[ev("S10","9723","DE=word#6A38, SBC HL,DE, только равенство вызывает #8799")],type="WORD")
hero("6A3A",1,"Contract","номер замка текущего контракта с1, 0 означает отсутствие",[ev("O17","B314","35*номер от#BFE0 даёт имя замка"),ev("O02","B4F7","ненулевой контракт запрещает новый")])
hero("6A3B",1,"Cult","принадлежность героя к секте,0не состоит",[ev("O03","B235","сравнение с типом храма"),ev("S10","95CE","наличие секты добавляет15000 к расходам")])
hero("6A3C",8,"Unknown6A3C","содержимое восьми байтов не получило подтверждённых игровых имён",person_copy,"unknown")
for base,title in [(0x6A44,"Good"),(0x6A4B,"Bad")]:
    mod="O18" if title=="Good" else "O19"
    hero(f"{base:04X}",1,title+"X","столбец соответствующего рассказчика",[ev(mod,"B200","встреча переносит отметку рассказчика и обновляет координаты")])
    hero(f"{base+1:04X}",1,title+"Y","строка соответствующего рассказчика",[ev(mod,"B200","координаты рассказчика")])
    hero(f"{base+2:04X}",1,title+"Map","континент соответствующего рассказчика",[ev("S10","8CD1","континент сверяется с текущим перед поиском специальной клетки")])
    hero(f"{base+3:04X}",2,"Unknown"+f"{base+3:04X}","два байта между континентом и счётчиком встреч, назначение не установлено",person_copy,"unknown")
    hero(f"{base+5:04X}",2,title+"Visits","число встреч с соответствующим рассказчиком",[ev(mod,"B220","счётчик встречи увеличивается и используется при выборе рассказа")],type="WORD")
hero("6A52",3,"Unknown6A52","назначение трёх байтов не установлено",person_copy,"unknown")
hero("6A55",5,"PuzzleOpen","пять строк по5бит открытых частей карты цели",[ev("O15","B200","подсчёт25открытых частей по пяти байтам")],count=5)
hero("6A5A",25,"PuzzleTiles","образец квадратного участка5x5 для поиска посоха, сравнение младших6бит",[ev("O16","B200","сравнение массива с5x5стратегической карты")],count=25)
hero("6A73",25,"IdleDays","25 счётчиков дней по ID1..25, сброс при добавлении нового ID, используется порогом деградации",[ev("S10","7AA4","IX=#6A72+ID"),ev("S10","9EDC","увеличение счётчиков"),ev("S10","9F61","чтение счётчика для сравнения с SOLDIERS+41")],count=25)
hero("6A8C",25,"UpgradeCount","25 счётчиков развития по ID1..25, сравниваются с SOLDIERS+40, точная единица накопления в данном файле не устанавливается",[ev("S10","9EFE","чтение IX+25 при IX=#6A72+ID"),ev("S10","7A94","оба массива сбрасываются для нового ID")],"partial",count=25)
hero("6AA5",1,"Unknown6AA5","назначение байта не установлено",person_copy,"unknown")
hero("6AA6",2,"Unknown6AA6","метрика доступа к новому контракту, сравнивается с30 и участвует в отношении с#6AA8, её точный игровой смысл не установлен",[ev("O02","B51F","word#6AA6 сравнивается с30"),ev("O02","B536","участвует в проверке отношения кword#6AA8")],"partial",type="WORD")
hero("6AA8",2,"Unknown6AA8","вторая метрика доступа к контракту, ноль обходит проверку отношения, точный смысл не установлен",[ev("O02","B529","нулевое значение разрешает дальнейшую ветвь"),ev("O02","B53D","делитель отношенияword#6AA6/word#6AA8")],"partial",type="WORD")
hero("6AAA",1,"Attacker","0нет угрозы замку,1..15 правитель, #FFбанды",[ev("S10","A5B6","выбор новой/существующей угрозы"),ev("S10","A61B","записывается владелец ближайшего другого замка")])
hero("6AAB",1,"AttackDays","дни до разрешения угрозы, исходно20+R(15)",[ev("S10","A65F","запись20+R(15)"),ev("S10","A702","вычитание входного0/1 по факту дня")])
hero("6AAC",2,"AttackCastle","адрес физической35байтной записи атакуемого замка в банке0",[ev("S10","A5F1","сохранение IX выбранного замка"),ev("O21","B21C","сравнение с текущим замком с поправкой на указатель имени")],type="WORD")
hero("6AAE",15,"AttackArmy","пять записей FTroop атакующей армии, построение создаёт2..4отряда",[ev("S10","A666","обнуление15байт"),ev("S10","A69F","формирование FTroop"),ev("O21","B62D","IX=#6AAE перед боем")],type="FTroop",count=5)
hero("6ABD",23,"Unknown6ABD","23 сохраняемых байта до массива коэффициентов контроля, назначение не установлено",person_copy,"unknown")
hero("6AD4",25,"UnitControl","25 коэффициентов предела контроля армии по ID1..25, предел=floor(Leadership/коэффициент)",[ev("S10","86F8","HL=#6AD3, затем прибавляется ID и читается байт-делитель"),ev("S04","6731","PERSON7 сворачивает25пар диапазонов в25коэффициентов")],count=25)
structure("FPerson",245,hero_fields,"персональная часть состояния, имя и игровые поля. Совпадает с245байтными PERSON1..6/8 после загрузки",base=0x69F8,source_files=[f"PERSON{i}" for i in range(1,9) if i!=7],mapping_evidence=person_copy)

structure("FGameState",256,[
    field(0,1,"Hero","номер выбранного героя1..8",[ev("S04","6658","результат выбора героя записывается#7931"),ev("S10","63A1","#69ED выбирает IP? для портрета")]),
    field(1,1,"Difficulty","сложность1..3",[ev("S04","6768","#7932 определяет начальный предел дней5000/4000/3000"),ev("S10","A673","#69EE выбирает таблицу сложности NAEMARMY")]),
    field(2,8,"SaveName","8символьное имя файла сохранения",[ev("S04","66B1","ввод имени по#7933"),ev("S10","96B6","панель содержит указатель#69EF")]),
    field(10,1,"Terminator","терминатор после имени файла",state_copy),
    field(11,245,"Person","FPerson, шаблон персонажа после нормализации PERSON7",person_copy,type="FPerson")
],"полный256байтный заголовок состояния, включает героя и глобальные события",base=0x69ED,save_format="первый сектор .M, первые255байт инвертируются #770B",mapping_evidence=state_copy)
structure("FByteRange",2,[
    field(0,1,"Min","нижняя граница исходного диапазона",[ev("S04","673D","из max вычитается min")]),
    field(1,1,"Max","верхняя граница исходного диапазона",[ev("S04","673A","A=(IX+1)")])
],"пара диапазона коэффициента PERSON7")
structure("FPerson7",270,[
    field(0,220,"Prefix","первые220байт совпадают по расположению с FPerson до UnitControl",person_copy),
    field(220,50,"ControlRanges","25пар FByteRange, загрузчик заменяет каждую пару одним коэффициентом на месте и оставляет первые245байт как FPerson",[ev("S04","6731","IX=HL=#7A18, B=25, IXшагает2, HLшагает1"),ev("S04","6743","min+RandomScaled(max-min), дополнительно возможны удвоение или floor(значение/2)+1")],type="FByteRange",count=25)
],"дисковый вариант PERSON7 до нормализации,270байт. Нельзя усекать как обычный PERSON без выполнения алгоритма")

M=memory(10)
lists=[]
for anchor,rec,bank,title in [(0x6AE9,"FCastle",0,"Castles"),(0x6AF9,"FTown",0,"Towns"),(0x6B09,"FTemple",0,"Temples"),
    (0x6B19,"FMapTroop",0,"SitesA"),(0x6B29,"FMapTroop",0,"SitesB"),(0x6B39,"FMapTroop",0,"SitesC"),(0x6B49,"FMapTroop",0,"SitesD"),
    (0x6B59,"FMapItem",0,"Items"),(0x6B69,"FMapTroop",0,"MapTroops"),(0x6B79,"FMapArmy",1,"MapArmies")]:
    rows=[]
    for i in range(1,5):
        a=anchor+4*i
        rows.append(dict(continent=i,descriptor=a,data=M[a]+256*M[a+1],count=M[a+2]+256*M[a+3]))
    lists.append(dict(name=title,anchor=anchor,first=anchor+4,bank=bank,type=rec,descriptors=rows,evidence=[ev("S10","7A74","IX+=4*A"),ev("S10",f"{anchor+4:04X}","исходные слова адреса и числа записей")]))

out=dict(schema_version=1,source="MYTHLAND.TRD, исходные байты и подтверждённые обращения",structures=structures,world_lists=lists,
    rules=["Все offset и size выражены в байтах, слова little-endian, исходные адреса и размещение не меняются", "confidence unknown/partial не означает резерв для нового кода, исходное поле сохраняется", "Структуры описывают разные представления, FPerson вложен в FGameState и не требует отдельной памяти", "IX/IY могут указывать внутрь записи, смещение базы обязательно учитывать"])
HERE.mkdir(exist_ok=True)
(HERE/"structures.json").write_text(json.dumps(out,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")

annotations=json.loads((WORK/"main_analysis/annotations.json").read_text(encoding="utf-8"))
for path in [WORK/"loader/nearby_group_annotations.json",WORK/"kb/rebellion_annotations.json",WORK/"special_group_annotations.json"]:
    annotations.update(json.loads(path.read_text(encoding="utf-8")))
short={
"6C89":"OverlayBank","6D2F":"PageEI","6D34":"StopView","6D3F":"ResetViewFlags","6D57":"StartView",
"87A1":"CountOwnCastles","87D1":"HasOwnerCastle","8801":"ShowScene","883A":"BuildArmy","88FA":"StoreArmy",
"8036":"UnitDesc","804E":"RulerDesc","8066":"SpellDesc","7341":"ViewCellAddr","7366":"SetUnitPicture",
"75A2":"DrawMask","7649":"DrawMaskFlip","7693":"CellAddress","8244":"DrawBackLayer","825B":"DrawMaskLayer",
"72ED":"GrabUnitTile","76FB":"PixelAddress","7735":"SaveCursor","7750":"RestoreCursor","7A17":"SumArmyPower",
"7AB0":"ArmyRating","7C71":"GetDirection","7D6B":"CountWord","7F40":"MoveToTarget","7F5F":"NearestObject",
"80DB":"UnitSpriteAddr","84ED":"PlaceViewLayer","8543":"PlaceGroup","85D0":"PlaceCells","867D":"TerrainMask",
"8697":"TerrainBattle","86B1":"FreeCapacity","8712":"BottomFrame","89E0":"LoseLeadership","8A08":"GainLeadership",
"8C31":"MoveMask","8C39":"FilterArmy","8D6E":"FindRecord","8DDA":"StepArmies","9173":"InNearbyRect",
"9193":"CompareArmies","91B6":"SumArmyBank1","91BF":"SetFacing","91E1":"StepsUpRight","91FE":"StepsDownRight",
"920B":"StepsDown","921B":"StepsDownLeft","9228":"StepsLeft","9238":"StepsUpLeft","91D1":"StepsUp","91EE":"StepsRight",
"9245":"MakeSteps","9270":"ClassifySteps","92CB":"StepMapTroops","944A":"RefreshPanels","957C":"RefreshHero",
"9704":"TickTime","9EA5":"SumExpenses","9ECA":"DevelopTroops","A082":"RegenMana","A205":"GrowTroop",
"A235":"RefreshTowns","A2E0":"CheckRevolt","A5AE":"TickCastle","AC78":"RepopulateSites","AD31":"MoveSitesC",
"74F7":"GrabTile4x4","6E79":"DrawEditText","6EA0":"ReadTextChar","6F25":"RemapKey","7980":"ShiftCursorR","79A5":"ShiftCursorL","7722":"CursorMaskByte",
"653A":"OverlayKeys","6550":"ObjectOverlays","6D62":"StackBC","6D76":"PopBC","6D88":"StackA","6D9C":"PopA",
}
symbols=[]
for k,a in annotations.items():
    if not k.startswith("10:") or not a.get("name"): continue
    addr=k.split(":")[1]
    name=short.get(addr,a["name"])
    assert len(name)<=15,(addr,name)
    symbols.append(dict(module="S10",address=int(addr,16),hex="#"+addr,name=name,kind="table" if addr in ("653A","6550") else "function",meaning=a["purpose"],evidence=[ev("S10",addr,a.get("details",a["purpose"]))],confidence=a.get("confidence","proven")))

g={
0x5FA0:("Bank",1,"текущий логический банк"),0x5FA1:("BankDriver",1,"установленная точка переключения банков, исполняемый код"),
0x655E:("Overlay",1,"номер загруженного рабочего оверлея"),0x655F:("CursorDelay",1,"счётчик кадров до смены символа курсора"),
0x6560:("CursorGlyph",1,"текущий символ анимации курсора#F2..#F5"),0x6561:("FrameCount",2,"число маскируемых прерываний по модулю65536"),
0x6563:("CursorPos",2,"позиция BC анимируемого символа"),0x6565:("EventFlags",1,"бит7 временно запрещает ряд мировых событий и развития отрядов, остальные биты не именуются"),
0x6566:("ViewFlags",1,"бит2 разрешает #8104 из прерывания, бит5 включает анимируемый символ"),
0x6567:("FloatA",5,"первое пятибайтное рабочее число калькулятора, используется расчётами лидерства и боя"),
0x656C:("FloatB",5,"второе пятибайтное рабочее число калькулятора, используется расчётами лидерства и боя"),
0x6571:("ViewObjects",960,"48 экранных записей по20байт, формат уточняется графическими метаданными"),
0x69D5:("MoveTarget",2,"целевая клетка автоматического движения"),0x69D7:("StepCost",1,"прибавляемая стоимость шага в долях1/256дня"),
0x69D8:("EventMarker",1,"#A5AE пишет1, более узкий смысл не установлен"),0x69ED:("Game",256,"FGameState"),
0x69EE:("Difficulty",1,"сложность1..3"),0x69EF:("SaveName",9,"имя файла сохранения с0"),0x69F8:("Hero",245,"FPerson"),
0x6A02:("Leadership",2,"лидерство"),0x6A04:("Mana",2,"текущая магическая сила героя"),0x6A06:("ManaMax",2,"максимальная магическая сила героя"),
0x6A08:("ManaRegen",2,"пополнение магической силы героя"),0x6A0A:("Spells",10,"десять состояний заклинаний"),0x6A14:("Money",5,"наличные Float5"),
0x6A19:("BaseIncome",5,"базовая часть недельного дохода Float5"),0x6A1E:("Army",15,"пять FTroop армии героя"),
0x6A2D:("Continent",1,"текущий континент"),0x6A2E:("Position",2,"X/Y героя в C/B"),0x6A30:("ShipMap",1,"континент корабля"),
0x6A31:("ShipPos",2,"X/Y корабля, #FFFFнет"),0x6A33:("MoveFlags",1,"режим движения и флаги героя"),0x6A34:("MapFlags",1,"доступность карт"),
0x6A35:("DayFraction",1,"дробная часть дня"),0x6A36:("Days",2,"прошедшие дни"),0x6A38:("Deadline",2,"предел дней"),
0x6A3A:("Contract",1,"номер контрактного замка"),0x6A3B:("Cult",1,"секта героя"),0x6A44:("GoodStoryPos",2,"клетка доброго рассказчика"),
0x6A46:("GoodStoryMap",1,"континент доброго рассказчика"),0x6A49:("GoodVisits",2,"число встреч с добрым рассказчиком"),
0x6A4B:("BadStoryPos",2,"клетка враждебного рассказчика"),0x6A4D:("BadStoryMap",1,"континент враждебного рассказчика"),0x6A50:("BadVisits",2,"число встреч с враждебным рассказчиком"),
0x6A55:("PuzzleOpen",5,"открытые части карты цели"),0x6A5A:("PuzzleTiles",25,"эталон5x5карты цели"),
0x6A72:("IdleIndex",1,"база на1байт перед25счётчиками дней поID"),0x6A73:("IdleDays",25,"счётчики дней поID1..25"),
0x6A8B:("UpgradeIndex",1,"база на1байт перед25счётчиками развития поID"),0x6A8C:("UpgradeCount",25,"счётчики развития поID"),
0x6AAA:("Attacker",1,"кто угрожает замку,0нет"),0x6AAB:("AttackDays",1,"дни до разрешения угрозы"),0x6AAC:("AttackCastle",2,"адрес физической записи атакуемого замка"),
0x6AAE:("AttackArmy",15,"пять FTroop нападающей армии"),0x6AD3:("ControlIndex",1,"база на1байт перед25коэффициентами контроля"),0x6AD4:("UnitControl",25,"коэффициенты контроля поID"),
0x867B:("CastleName",2,"указатель имени текущего замка, физическая запись+3"),0x8D29:("ObjectCell",2,"координаты для поиска #8CD1"),
0x9172:("Approaching",1,"#FFсближение,#00отступление при#8DDA"),0x928F:("MovingObject",2,"сохранённый адрес текущей движущейся записи"),
0x9291:("MoveDirection",1,"направление к герою1..8"),0x9292:("NearbyMin",2,"минимальныеX/Yобласти внимания"),0x9294:("NearbyMax",2,"максимальныеX/Yобласти внимания, тот же адрес как смещённая база таблицы отступления"),
0x92B6:("StepCandidates",9,"три записи [маскаместности,X,Y]"),0x92BF:("SplitArmy",12,"временная армия до4отрядов FTroop"),
0x7C6B:("RandomState",6,"три слова состояния генератора случайных чисел"),
}
for item in lists:
    g[item["anchor"]]=(item["name"]+"Index",16,"база на4байта перед дескрипторами FMapList континентов1..4, "+item["type"])
    g[item["first"]]=(item["name"]+"Lists",16,"четыре реальные записи FMapList, континенты1..4, "+item["type"])

F=json.loads((WORK.parent/"outputs/MYTHLAND/Docs/functions.json").read_text(encoding="utf-8"))
for address,(name,size,meaning) in sorted(g.items()):
    assert len(name)<=15,name
    refs=[f for f in F if f["block"]=="S10" and address in f["reads"]+f["writes"]]
    evidence=[ev("S10",f"{f['address']:04X}","прямая ссылка на поле в графе процедуры") for f in refs]
    if not evidence:
        evidence=[x for s in structures for f in s["fields"] if s.get("base",-1)+f["offset"]==address for x in f["evidence"]]
    if not evidence:
        evidence=[ev("S10",f"{address:04X}","адрес подтверждён статическими таблицами и операндами, см. structures.json и исходный листинг")]
    symbols.append(dict(module="State",address=address,hex=f"#{address:04X}",name=name,kind="equ",size=size,meaning=meaning,evidence=evidence,confidence="partial" if name in ("FloatA","FloatB","EventMarker","UpgradeCount") else "proven"))

contexts=[]
def context(module,start,end,register,typ,offset=0,reason="",exceptions=None):
    contexts.append(dict(module=module,start=int(start,16),end=int(end,16),end_inclusive=True,register=register,type=typ,base_offset=offset,evidence=[ev(module,start,reason)],exceptions=exceptions or []))
context("S10","87B4","87C4","IX","FCastle",reason="начало#C000, шаг35")
context("S10","87E7","87F2","IX","FCastle",reason="начало#C000, шаг35, поле владельца+19")
context("S10","8E16","8E1F","IX","FMapList",reason="после#7A74 выбран континентальный дескриптор, до переноса Data в IX")
context("S10","9307","9310","IX","FMapList",reason="после#7A74 выбран континентальный дескриптор, до переноса Data в IX")
context("S10","8E38","8E9B","IX","FMapArmy",reason="#6B79, банк1, шаг22, #9193 сохраняет IX")
context("S10","90FB","912F","IX","FMapArmy",reason="IX восстановлен из#928F, запись координат и флагов")
context("S10","931A","9359","IX","FMapTroop",reason="#6B69, банк0, шаг6")
context("S10","93EB","93F9","IX","FMapTroop",reason="IX восстановлен из#928F, #7AEF сохраняет IX")
context("S10","9400","9425","IX","FMapTroop",reason="IX восстановлен из#928F, запись координат и ориентации")
context("S10","8EC5","9048","IY","FMoveStep",reason="IY=#92B6, три кандидата с шагом3, #8CD1 окружён PUSH/POP IY")
context("S10","905D","913C","IY","FMoveStep",reason="IY=#92B6, три кандидата с шагом3, #8CD1 окружён PUSH/POP IY")
context("S10","9371","943A","IY","FMoveStep",reason="IY=#92B6, три кандидата с шагом3, #8CD1 окружён PUSH/POP IY")
context("S10","A0A2","A0C5","IX","FMapArmy",reason="банк1,#C000,744записи с шагом22")
context("S10","A0D7","A0F7","IX","FRuler",reason="банк3,#CCCB,15записей с шагом28")
context("S10","AE33","AE39","IY","FCastle",reason="#ADBF передаёт физическую запись замка для вычисления дохода")
context("S10","AE3F","AE88","IX","FTown",reason="данные континентального списка#6AF9, шаг26")
context("S10","9E78","9EA4","IY","FTroop",reason="подпрограмма расчёта стоимости получает трёхбайтную запись, сохраняет IY")
context("S10","A205","A234","IX","FTroop",reason="сравнениеID, изменение+1/+2, на выходе IX+=3")
context("S10","883A","88EF","IY","FBattleUnit",reason="создание боевой записи18байт, IYшагает18, см.FBattleUnit корневого агента")
context("S10","885B","88DB","IX","FTroop",reason="входной массив с шагом3, IX временно заменяется описателем SOLDIERS",exceptions=[{"start":0x88A5,"end":0x88C8,"type":"FSoldier","reason":"#8036 подменяет IX до POP IX по#88C8"}])
context("S10","891A","8963","IX","FBattleUnit",reason="обратное преобразование, исходный IXшагает18")
context("S10","8905","8968","IY","FTroop",reason="обратное преобразование боевой армии в тройки, IYшагает3")
context("O07","B226","B29D","IX","FMapArmy",offset=3,reason="#B200..#B204 прибавили3к адресу физической записи, #B288 восстанавливает указатель",exceptions=[{"start":0xB27C,"end":0xB287,"type":"FMenu","reason":"LD IX,#878A перед вызовом меню, затем IX восстанавливается по#B288"}])
context("O03","B251","B254","IX","FSpell",reason="#8066 вернул описатель заклинания")
context("O01","B3CF","B3D2","IX","FRuler",reason="#804E вернул описатель владельца замка")
context("O01","B3F6","B3F9","IX","FRuler",reason="#804E вернул описатель владельца замка")
context("O01","B20E","B20E","IX","FCastle",offset=3,reason="#B200..#B204 сместили входной IX к имени, чтение Owner по+16")
context("O01","B25D","B25D","IX","FCastle",offset=3,reason="IX восстановлен из#867B, указатель на имя")
context("O21","B82E","B868","IX","FMapTroop",reason="IX получает адрес свободной шестибайтовой записи из#6B69")

meta=dict(schema_version=1,symbols=symbols,register_contexts=contexts,
    rewrite_rules=["Адреса не меняются, имена меток и каждого поля <=15символов", "Контексты IX/IY применяются только к явно указанному регистру и диапазону, переход за диапазон не наследует тип", "Для указателя внутрь записи исходное +k переводится в +(Type.Field-base_offset)", "#8CD1 меняет IX на тип найденного объекта, после вызова нельзя сохранять прежний тип без восстановления указателя", "#A43B вызывает#957C, после этого IY не гарантированно указывает на прежний FTroop", "Ссылка State.* создаётся EQU, это не новая память и не изменение исходного размещения"])
(HERE/"engine_symbols.json").write_text(json.dumps(meta,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
print(json.dumps({"structures":len(structures),"fields":sum(len(s["fields"]) for s in structures),"symbols":len(symbols),"register_contexts":len(contexts)}))
