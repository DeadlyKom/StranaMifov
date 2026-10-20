from pathlib import Path
import hashlib,json

BASE=Path(__file__).resolve().parents[2]
ROOT=Path(__file__).resolve().parent
OUT=BASE/'outputs/MYTHLAND'
manifest=json.loads((OUT/'Disk/manifest.json').read_text(encoding='utf-8'))
entries={e['slot']:e for e in manifest['entries']}
rom=(BASE/'work/vendor/skoolkit-10.0/skoolkit/resources/48.rom').read_bytes()
assert rom[0x7c]==0xc9
raw={slot:(OUT/(entries[slot]['path']+'.bin')).read_bytes() for slot in (8,33,34)}
assert raw[33][:0x113]==raw[34][:0x113]
assert raw[33][6:0x113]==raw[8][6:0x113]
assert [i for i,(a,b) in enumerate(zip(raw[8][:0x12c],raw[33][:0x12c])) if a!=b]==[5]

resources=[]
rows=[]
for slot,bank,count,global_start,load_call in ((33,14,5,1,'head #636D..#637D'),(34,15,4,6,'head #6380..#6390')):
    data=raw[slot]
    records=[]
    position=0x12c
    for index in range(1,count+1):
        distance=int.from_bytes(data[position:position+2],'little')
        next_position=position+1+distance
        assert position+5<=next_position<=len(data)
        record={
          'localIndex':index,'inputA8801':global_start+index-1,
          'fileOffset':position,'fileOffsetHex':f'{position:04X}',
          'trdOffset':entries[slot]['offset']+position,'trdOffsetHex':f'{entries[slot]["offset"]+position:05X}',
          'runtimeHeader':f'{0xc000+position:04X}',
          'relativeLinkWord':distance,'nextRecordFormula':'offset + 1 + little_endian_word(offset)',
          'screenStartThird':data[position+2],'screenThirdCount':data[position+3],
          'flags':data[position+4], 'payloadOffset':position+5,
          'payloadLength':next_position-position-5,'endExclusive':next_position
        }
        records.append(record)
        rows.append(f"| {record['inputA8801']} | {bank} | {entries[slot]['name']}.C | {index} | #{position:04X} | #{0xc000+position:04X} | #{record['payloadOffset']:04X} | {record['payloadLength']} | {record['screenStartThird']},{record['screenThirdCount']},#{record['flags']:02X} |")
        position=next_position
    assert position==len(data)
    resources.append({
      'slot':slot,'file':entries[slot]['name']+'.C','bank':bank,'loadRange':load_call,
      'loadAddress':'C000','fileLength':len(data),'trdBaseOffset':entries[slot]['offset'],
      'entryPoints':['C000','C006'],'codeRangesInclusive':[['C000','C001'],['C006','C112']],
      'dataRangesInclusive':[['C002','C005'],['C113',f'{0xc000+len(data)-1:04X}']],
      'commonDecoderSha256':hashlib.sha256(data[6:0x113]).hexdigest(),
      'alreadyDecodedFunctions':[f'S{slot}:C000',f'S{slot}:C006'],
      'pictures':records
    })

decoder_effects={
 'inputs':'настроечная область начала+2..+5, номер изображения начинается с 1, +3/+4 задают переопределение начальной трети/числа третей, #FF берёт значение из заголовка картинки',
 'outputs':"полный экран для заголовка [0,3,flags], BC=0, A=0, Z=1, CF=0, DE=#5B00, HL после последнего прочитанного байта потока, IY=начало+2, поля области +3/+4 сброшены в #FF",
 'corrupt':"HL, DE, BC, AF, BC', IY. HL', DE', AF', IX сохранены, SP возвращается к входной позиции до RET",
 'memory':'#4000..#5AFF, параметры начала+3..+5 и временное слово ниже SP при определении собственной базы',
 'whyBCprime':"#C0FD/#C0FE сохраняют длину RLE-серии в B', #C102/#C103 — байт в C', #C0EA..#C0ED уменьшают B' и читают C'. В активном коде нет изменения HL'/DE' или EX AF,AF'",
 'callGraph':'#C006 вызывает только ROM #007C, который содержит RET, остальные переходы остаются в #C006..#C112, #C0E4 — внутреннее продолжение, не отдельная CALL-процедура'
}
wrapper={
 'entry':'head #8801',
 'selection':'A=1..5 выбирает банк14/BL1 и локальный номер A, A=6..9 выбирает банк15/BL2 и локальный номер A-5',
 'procedure':'#8801..#8839 сохраняет IX, IY, HL, DE, BC, AF, сохраняет номер банка из #5FA0, выбирает банк, записывает локальный номер в #C002, очищает экран, вызывает #C000 и восстанавливает банк и сохранённые регистры',
 'corrupt':"BC'. HL, DE, BC, AF, HL', DE', AF', IX, IY сохранены. Прерывания разрешены заключительным #6D2F",
 'memory':'экран, текущая область настроек BL1/BL2 по #C002..#C005, #5FA0 временно меняется и восстанавливается'
}
proof={
 'resources':resources,'decoderEffects':decoder_effects,'wrapper':wrapper,
 'O18':{'call':'O18 #B203 LD A,4, #B205 CALL #8801','bank':14,'slot':33,'localIndex':4,'fileOffsetHex':'23FF','runtimeHeader':'E3FF','payloadOffsetHex':'2404','payloadLength':2312},
 'O19':{'call':'O19 #B203 LD A,5, #B205 CALL #8801','bank':14,'slot':33,'localIndex':5,'fileOffsetHex':'2D0C','runtimeHeader':'ED0C','payloadOffsetHex':'2D11','payloadLength':3411},
 'otherConfirmedCallers':[
   {'caller':'O21 #B23B..#B23D','A':1,'meaning':'собственный замок'},
   {'caller':'O02 #B29D..#B29F','A':2,'meaning':'покупка корабля'},
   {'caller':'O03 #B206..#B208','A':3,'meaning':'встреча по оверлею3'},
   {'caller':'O16 #B2DF..#B2E1','A':4,'meaning':'ветвь успешного поиска'},
   {'caller':'O04 #B204..#B210','A':'C+2 при типе C=4..7','meaning':'четыре группы объектов, номера6..9, локальные номера BL2 1..4'}
 ],
 'herimgComparison':{'slot':8,'entry':'7D33','body':'7D39..7E45','identicalCodeOffset':'0006..0112','prefix0000_012BdiffersAt':[5]},
 'additionalExecutableCodeFound':False,
 'generatorAction':'новых диапазонов кода не требуется, S33/S34 уже имеют обе точки входа и всё тело распаковщика в Source/Files/33_BL1.asm и 34_BL2.asm',
 'unresolvedRegisterContracts':0,
 'validation':'побайтовое сравнение исходных файлов, полный статический разбор единственного тела и относительных цепочек до точного EOF, без сборки и исполнения игры'
}
(ROOT/'animation_resource_map.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

report='''# Путь от сцен к исходным файлам

head #636D..#637D выбирает логический банк 14, подставляет символ 1 в имя BL? по #6315 и загружает BL1.C из слота 33 по #C000. head #6380..#6390 делает то же для банка 15, символа 2 и BL2.C из слота 34. Имя состоит из девяти байтов «BL?     C» по #6313.

Общий вызов head #8801 принимает номер A=1..9. При A<6 выбирает банк 14 без изменения номера, иначе выбирает банк 15 и вычитает 5. Локальный номер записывается по #C002, затем вызывается #C000. Это показ статического упакованного экрана, не отдельный анимационный скрипт.

O18 передаёт A=4, O19 A=5. Обе сцены находятся в BL1.C, банк 14. Заголовки картинок лежат в файле по #23FF и #2D0C, адреса в памяти #E3FF и #ED0C. RLE-потоки начинаются по смещениям #2404/#2D11 и имеют длины 2312/3411 байтов.

| A для #8801 | Банк | Файл | Локальный номер | Смещение заголовка | Адрес заголовка | Смещение потока | Длина потока | Начальная треть, число третей, флаги |
|---|---|---|---|---|---|---|---|---|
'''+ '\n'.join(rows)+'''

Заголовок картинки содержит относительную ссылку, начальную треть экрана, число третей и флаги. Следующий заголовок находится по формуле offset+1+word(offset), потому что перед ADD HL,DE код уже увеличил HL на единицу. Две цепочки из девяти записей полностью покрывают хвосты файлов, BL1 содержит пять картинок, BL2 четыре. Настройка по смещению +5 не является счётчиком картинок.

# Исполняемые диапазоны и совпадение с HERIMG

В обоих файлах исполняются только #C000..#C001 и #C006..#C112. #C002..#C005 являются настройками. С #C113 начинаются данные, цепочка картинок — с #C12C. Во всём теле есть только один CALL, в ROM #007C с командой RET. #C0E4 является внутренним продолжением общих циклов, отдельного адреса возврата туда через CALL нет.

Байты файлов BL1/BL2 от +0 до +#112 совпадают полностью. Их байты +6..+#112 также побайтно совпадают с HERIMG.C, который исполняется по #7D39..#7E45. У всего префикса +0..+#12B единственное отличие HERIMG — настроечный байт +5. Дополнительного кода, скрытого в DB, не найдено. В текущей документации уже существуют S33:C000/C006 и S34:C000/C006, всё тело уже разобрано.

# Регистровый контракт

Внутренний распаковщик меняет HL, DE, BC, AF, BC', IY. Сохраняет HL', DE', AF', IX. Он использует EXX только для изменения счётчика RLE в B' и повторяемого байта в C'. HL'/DE' при этих обменах не изменяются. Команд EX AF,AF' в исполняемом теле нет, похожие байты после #C113 относятся к данным. SP после временного получения собственного адреса сбалансирован. Для полных изображений [0,3,flags] на выходе BC=0, A=0, Z=1, CF=0, DE=#5B00. Поля начальной трети и высоты по #C003/#C004 сброшены в #FF.

Обёртка #8801 сохраняет и восстанавливает HL, DE, BC, AF, IX, IY и исходный банк. Поэтому её итоговый Corrupt — только BC'. HL', DE', AF' также сохранены телом распаковщика. Через #6D2F на выходе разрешаются прерывания.

Полные O18:B200/O19:B200 меняют HL, DE, BC, AF, BC'. HL', DE', AF', IX, IY сохранены. Другие локальные вызовы этих двух оверлеев не используют альтернативные регистры. Неопределённых контрактов не осталось.

Проверено статически по исходным байтам и листингам. Сборка и исполнение игры не выполнялись.
'''
(ROOT/'animation_resource_map.txt').write_text(report,encoding='utf-8')

notes=json.loads((ROOT/'overlay_annotations.json').read_text(encoding='utf-8'))
contract="HL, DE, BC, AF, BC'. HL', DE', AF', IX, IY сохранены. #8801 сохраняет основные и индексные регистры, общий распаковщик BL1 меняет B'/C' как счётчик и значение RLE-серии"
for key in ('O18:B200','O19:B200'):notes[key]['corrupt']=contract
(ROOT/'overlay_annotations.json').write_text(json.dumps(notes,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

annotations={
 '10:8801':{
   'purpose':'показать одну из девяти упакованных сцен BL1/BL2 с восстановлением банка и основных регистров',
   'details':wrapper['procedure']+'. '+wrapper['selection']+'. RLE-тело идентично HERIMG, #C0FD..#C104 использует только B\'/C\' из альтернативного набора',
   'inputs':'AF — A=1..9, #5FA0 — исходный логический банк, BL1 по #C000 банка14 и BL2 по #C000 банка15 ранее загружены',
   'outputs':'HL, DE, BC, AF, HL\', DE\', AF\', IX, IY и исходный логический банк восстановлены, выбранная сцена на экране, прерывания разрешены',
   'corrupt':"BC'. HL, DE, BC, AF, HL', DE', AF', IX, IY сохранены",
   'effects':'#4000..#5AFF, настройки #C002..#C005 выбранного банка, временное переключение банка, EI через #6D2F',
   'confidence':'proven'
 }
}
existing=json.loads((ROOT/'animation_existing_functions.json').read_text(encoding='utf-8'))
for slot in (33,34):
    for address in (0xc000,0xc006):
        entry=next(f for f in existing if f['slot']==slot and f['address']==address)
        note=dict(entry['analysis'])
        note['corrupt']=decoder_effects['corrupt']
        if address==0xc006:note['outputs']=decoder_effects['outputs']
        note['confidence']='proven'
        annotations[f'{slot}:{address:04X}']=note
(ROOT/'animation_resource_annotations.json').write_text(json.dumps(annotations,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

audit=json.loads((ROOT/'contract_completion.json').read_text(encoding='utf-8'))
audit['not_proven_preserved']={}
audit['resolved_external_images']='O18/O19 используют уже разобранный распаковщик BL1, код совпадает с HERIMG, из альтернативных регистров меняется только BC\''
(ROOT/'contract_completion.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('map and annotations written, 9 pictures, 0 additional code ranges, 0 unresolved register contracts')
