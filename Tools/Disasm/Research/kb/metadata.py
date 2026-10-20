import sys,json,hashlib
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import *
out=Path(__file__).parent
raw=entry(3)[1]
s1=(out/'kb_stage1.bin').read_bytes()
s2=(out/'kb_stage2.bin').read_bytes()[:299]
s3=(out/'kb_stage3.bin').read_bytes()
assert len(raw)==406 and len(s1)==406 and len(s2)==299 and len(s3)==257
key_outer=bytes(a^b for a,b in zip(raw,s1))
key_reloc=bytes(s1[107+j]^s2[j] for j in range(299))
assert key_reloc==bytes((0x34+9*j)&0x7f for j in range(299))
assert s3==bytes(s2[35+j]^s2[36+j] for j in range(257))
blocks=[
 {'id':'KB_Outer','slot':3,'origin':0x6149,'length':28,'rawOffset':0,'binPath':'work/kb/kb_outer_stub.bin','kind':'code','entryPoints':[0x6149]},
 {'id':'KB_Relocate','slot':3,'origin':0x6165,'length':79,'rawOffset':28,'binPath':'work/kb/kb_relocate.bin','kind':'code','entryPoints':[0x6165]},
 {'id':'KB_Difference','slot':3,'origin':0xbfdd,'length':35,'rawOffset':107,'binPath':'work/kb/kb_difference_stub.bin','kind':'code','entryPoints':[0xbfdd]},
 {'id':'KB_LoadBL3','slot':3,'origin':0xc000,'length':257,'rawOffset':142,'binPath':'work/kb/kb_load_bl3.bin','kind':'mixed','entryPoints':[0xc000,0xc0da]},
 {'id':'KB_Tail','slot':3,'origin':0xc101,'length':7,'rawOffset':399,'binPath':'work/kb/kb_tail.bin','kind':'data','entryPoints':[]},
 {'id':'BL3','slot':4,'origin':0x6149,'length':7147,'rawOffset':0,'binPath':'work/kb/bl3_stage2.bin','kind':'mixed','entryPoints':[0x6149,0x615e,0x6161,0x631c]}
]
parts=[raw[:28],s1[28:107],s2[:35],s3,s2[292:299]]
for b,data in zip(blocks,parts):
    p=WORK.parent/b['binPath'];p.write_bytes(data);b['sha256']=hashlib.sha256(data).hexdigest()
for name,data in [('kb_outer_xor.bin',key_outer),('kb_relocate_xor.bin',key_reloc),('bl3_net_xor.bin',bytes(a^b for a,b in zip(entry(4)[1],(out/'bl3_stage2.bin').read_bytes())))]: (out/name).write_bytes(data)
# Проверка обратного преобразования всех слоёв KB без вызова ассемблера.
recon=bytearray(s2)
for j in range(256,-1,-1):recon[35+j]=s3[j]^recon[36+j]
assert bytes(recon)==s2
stage1=bytearray(parts[0]+parts[1]+bytes(recon[j]^key_reloc[j] for j in range(299)))
rebuilt=bytes(stage1[j]^key_outer[j] for j in range(406))
assert rebuilt==raw
(out/'kb_roundtrip.bin').write_bytes(rebuilt)
meta={
 'blocks':blocks,
 'kbReconstruction':{
   'outerXorKeyPath':'work/kb/kb_outer_xor.bin','relocationXorKeyPath':'work/kb/kb_relocate_xor.bin',
   'stepsRu':[
      'составить промежуточный блок длиной 299 байт из KB_Difference, KB_LoadBL3 и KB_Tail в этом порядке',
      'для j от 256 до 0 заменить байт 35+j на plaintext_LoadBL3[j] XOR intermediate[36+j], это обратное соседнее XOR-преобразование',
      'каждый из 299 байтов преобразовать XOR с kb_relocate_xor.bin, затем присоединить результат после KB_Outer и KB_Relocate',
      'все 406 байтов преобразовать XOR с kb_outer_xor.bin, нулевые байты ключа оставляют непокрытые первым шифратором диапазоны без изменения'
    ],
    'fixedNetXorSafe':False,
    'warningRu':'единый ключ original XOR final воспроизводит исходные байты, но не подходит для редактирования KB_LoadBL3, потому что соседнее XOR-преобразование требует пересчитывать цепочку справа налево',
    'checkedOriginalRoundtrip':True,
    'assemblyOrRuntimeTest':False
 },
 'bl3Reconstruction':{
    'netXorKeyPath':'work/kb/bl3_net_xor.bin',
    'fixedNetXorSafe':True,
    'conditionRu':'ключ корректен при неизменных длинах и инструкциях внешнего шифратора KB и начального шифратора BL3, оба преобразования являются независимым от данных XOR-потоком'
 },
 'simulation':{
   'engine':'SkoolKit 10.0 Python Simulator, fast_ldir=False, interrupts=False',
   'initialRegisters':{'PC':0x6149,'SP':0x6000,'IY':0x5c3a},
   'firstTrdosModel':'C=0A, имя CTPAHA  B, результат C=2',
   'secondTrdosModel':'C=0E, имя BL3     C, файл slot4 загружен в6149, слово5CE6=6149, слово5CE8=1BEB',
   'modelBoundaryRu':'TR-DOS не исполнялся, два успешных обращения заменены указанной моделью, значения R вокруг обращений восстанавливает сам загрузчик',
   'kbStage1Steps':14542,'kbStage1Tstates':88630,
   'kbLayer2EntrySteps':17010,'kbLayer3EntryTotalTstates':134824,
   'bl3ExternalDecodeSteps':1715334,'bl3OwnDecodeSteps':57005,
   'bl3FirstRefreshKey':0x57,'bl3OwnRefreshStep':9,
 },
 'kbFunctions':[
  {'address':0x6149,'endExclusive':0x6165,'name':'DecryptOuter','descriptionRu':'отключает прерывания, задаёт R=70 и шесть раз обрабатывает 220 байт с6165, каждый байт получает XOR с текущим R, H, L и номером оставшегося прохода B, R учитывает реальные M1-циклы инструкций'},
  {'address':0x6165,'endExclusive':0x6170,'name':'CopyInner','descriptionRu':'переносит 299 байтов из61B4 вBFDE, исходник последних 158 байтов не входит в диапазон наружного шифрования'},
  {'address':0x6170,'endExclusive':0x617d,'name':'EraseOuter','descriptionRu':'записывает ноль в6149 и запускает LDIR с BC=0, после 50 переносов байт ED самой инструкции LDIR по617B становится нулём, повторение прекращается, байт B0 по617C исполняется как OR B, нули остаются в6149..617B'},
  {'address':0x617d,'endExclusive':0x6192,'name':'PrepareStackLoop','descriptionRu':'нормализует R после самостирания, помещает в стек адрес6192 и промежуточный адресBFDD, задаёт HL=BFDE, DE=BFDD, BC=012B'},
  {'address':0x6192,'endExclusive':0x619e,'name':'DecryptShift','descriptionRu':'XOR байта(HL) с R, LDI одновременно переносит его на один байт вниз и уменьшает BC, DEC SP дважды возвращает стек к сохранённому адресу6192, RET PE повторяет цикл пока BC не ноль, затем второй DEC SP дважды и RET PO передают управление вBFDD, ключ первого байта34 и шаг9 по модулю128'},
  {'address':0x619e,'endExclusive':0x61b4,'name':'UnusedBranch','descriptionRu':'в нормальном ходе не достигается, обе развилки RET PE и RET PO покрывают состояния PV после LDI, поэтому нельзя объявлять этот фрагмент исполняемым без отдельной точки входа'},
  {'address':0xbfdd,'endExclusive':0xc000,'name':'DecryptDifference','descriptionRu':'сохраняет текущий SP в операнде LD SP поBFFE, задаёт SP=C000 и 257 раз читает пару соседних байтов POP DE, обнуляет A после фиктивного LD A,R, записывает E XOR D обратно через PUSH DE, увеличивает SP на1, тем самым преобразует C000..C100 как p[i]=s[i] XOR s[i+1], затем восстанавливает SP и входит вC000'},
  {'address':0xc000,'endExclusive':0xc03e,'name':'BuildProtectionName','descriptionRu':'вычисляет имя CTPAHA  B из IYh=5C, арифметики и показаний R, изменяя восемь операндов LD A,n в процедуреC0DA, затем вызывает её для записи девятибайтового имени в5CDD'},
  {'address':0xc03e,'endExclusive':0xc050,'name':'CheckDirectoryPosition','descriptionRu':'сохраняет R, вызывает TR-DOS C=0A для поиска CTPAHA.B, восстанавливает R, значение C XOR2 записывает в операнд поC07B, нормальная позиция файла в каталоге2 даёт ноль'},
  {'address':0xc050,'endExclusive':0xc07f,'name':'BuildBlockName','descriptionRu':'меняет операнды процедурыC0DA для формирования BL3     C, использует IYl=3A и R, загружает HL=003E при правильной позицииCTPAHA и сохраняет это слово вC0AB, превращая будущий код в LD A,0'},
  {'address':0xc07f,'endExclusive':0xc08d,'name':'LoadBlock','descriptionRu':'сохраняет R, обнуляет5D10 и вызывает TR-DOS C=0E с A=0 для загрузки BL3 по адресу каталога6149, затем восстанавливает R'},
  {'address':0xc08d,'endExclusive':0xc0ab,'name':'DecryptBL3','descriptionRu':'пятнадцать проходов по7147 байтам от адреса в5CE6, на каждом байте читает R, XOR L и записывает результат вR, затем XOR B,C,D,E,H и байт(HL), записывает расшифрованный байт, увеличивает HL и C, уменьшает DE, внешний B от0F до01'},
  {'address':0xc0ab,'endExclusive':0xc0d0,'name':'ProtectionBranch','descriptionRu':'после нормального C=2 от поиска выполнит LD A,0, OR A и переходC0CD, затем JP6149, при другом результате копирует десять байтов изC0D0 в6C16 и портит двадцать псевдослучайных байтов страницы64xx, поэтому поведение зависит от исходного порядка файлов'},
  {'address':0xc0d0,'endExclusive':0xc0da,'name':'CorruptionData','descriptionRu':'десять байтов ветки повреждения при нарушении проверки положения файла'},
  {'address':0xc0da,'endExclusive':0xc101,'name':'WriteFilename','descriptionRu':'записывает девять байтов имени и расширения из самомодифицируемых операндов LD A,n в5CDD..5CE5, операнды находятсяC0DE,C0E2,C0E6,C0EA,C0EE,C0F2,C0F6,C0FA,C0FE'}
 ],
 'bl3Functions':[
  {'address':0x6149,'endExclusive':0x615e,'name':'DecryptOwnBody','descriptionRu':'после внешнего дешифрования изKB отключает прерывания и задаётR=50, XOR с показаниямиR обрабатывает7125 байтов615E..7D32, первый ключ57, шаг9 по модулю128, последний байт файла7D33 не меняется этим проходом'},
  {'address':0x615e,'endExclusive':0x6161,'name':'EntryJump','descriptionRu':'передаёт управление инициализации631C'},
  {'address':0x6161,'endExclusive':0x61d0,'name':'Interrupt','descriptionRu':'обработчикIM2 сохраняет основные, альтернативные и индексные регистры и текущую страницу памяти, сохраняет временные операнды6DFE и6E50, при бите5 в61D5 периодически вызывает6E97 с координатами61D2 и изменяемым значением61D1, вызывает7196 и ROM386E с IY=5C3A, восстанавливает страницу через5FA1, возвращает все регистры и выполняет EI,RETI'},
  {'address':0x61d0,'endExclusive':0x629e,'name':'InterruptAndStackData','descriptionRu':'поля61D0=06,61D1=F2,61D2..61D3 координаты и61D5 флаги, далее нулевая область, начало стека629C, не размечать её как цепочку NOP-процедур'},
  {'address':0x629e,'endExclusive':0x631c,'name':'Names','descriptionRu':'имена загружаемых файлов, включая RAMDRIVE,C, DATA2,C, HERIMG,C, HERTXT,C и другие записи по9 байтов, интерпретация как код ошибочна'},
  {'address':0x631c,'endExclusive':0x639b,'name':'Initialize','descriptionRu':'загружает RAMDRIVE.C черезTRDOS C=0E и вызывает7D34, ставитSP=629C, заполняет6000..6100 значением61 для IM2-вектора6161, задаётI=60 иIM2, выбирает страницу08 через5FA1 и очищаетC000..FFFF, сохраняет системные значения5C78..5C7A иR для генератора, загружает ресурсы в страницы4,3,0 через7092'},
  {'address':0x7092,'name':'LoadResource','descriptionRu':'основная загрузка файла по девятибайтовому имениHL и адресуDE, вызывается из инициализации и остальных экранов, требует отдельного разбора по исходнику'},
  {'address':0x6dbc,'name':'ReadSectors','descriptionRu':'вызов чтения секторов TR-DOS из банка и оболочек'},
  {'address':0x6e97,'name':'InterruptDraw','descriptionRu':'процедура, вызываемая прерыванием при разрешённом бите5 в61D5, семантика конкретного изображения пока не установлена'},
  {'address':0x7196,'name':'InterruptTick','descriptionRu':'безусловный обработчик каждого прерывания, точная семантика требует отдельного разбора'}
 ],
 'bl3CodeSeeds':[0x6149,0x615e,0x6161,0x631c,0x7092,0x6dbc,0x6dd6,0x6e97,0x7196,0x7311,0x7220,0x70e4,0x7461,0x6ea6],
 'bl3ConfirmedDataRanges':[[0x61d0,0x631c]],
 'warningsRu':['BL3 plaintext получен при стандартном IY=5C3A и успешных двух вызовах TR-DOS, это статическая проверка дешифратора с моделированием DOS, не запуск игры в полном эмуляторе','описания загрузчика основаны на трассировке инструкций, смысл большей части игровых процедур BL3 ещё не разобран']
}
(out/'segments.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'roundtrip':rebuilt==raw,'blocks':[(b['id'],hex(b['origin']),b['length'],b['rawOffset']) for b in blocks]},ensure_ascii=False))
