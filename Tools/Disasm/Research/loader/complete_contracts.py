from pathlib import Path
import json

ROOT=Path(__file__).resolve().parent
ALT="HL', DE', BC', AF'"
ALL=f"HL, DE, BC, AF, {ALT}, IX, IY"
PRES_ALT=f"{ALT}, IY сохранены"

contracts={
 'O13:B200':ALL+' с учётом меню #776D и восстановления основного экрана #944A, сохранение входных регистров не предусмотрено',
 'O13:B335':f'HL, DE, BC, AF, IX. {PRES_ALT}',
 'O13:B47D':f'HL, DE, AF. BC, {ALT}, IX, IY сохранены',
 'O13:B48E':f'HL, DE, BC, AF. {ALT}, IX, IY сохранены',
 'O13:B4C6':f'HL, DE, BC, AF. {ALT}, IX, IY сохранены',
 'O13:B504':f'HL, DE, BC, AF, IX. {PRES_ALT}',
 'O13:B6B2':f'HL, DE, AF, IX. BC, {ALT}, IY сохранены',
 'O13:B6D1':f'HL, DE, BC, AF, IX. {PRES_ALT}',
 'O13:B703':f'HL, DE, AF, IX. BC, {ALT}, IY сохранены, #B7C3 восстанавливает рабочие регистры после каждого пикселя',
 'O13:B751':f'HL, DE, BC, AF, IX. {PRES_ALT}',
 'O13:B779':f'HL, DE, BC, AF, IX. {PRES_ALT}',
 'O13:B7C3':f'Нет, HL, DE, BC, AF, {ALT}, IX, IY сохранены, DE используется только как источник координат и не изменяется',
 'O13:B7FD':f'HL, DE, BC, AF, IX. {PRES_ALT}',
 'O13:B8E1':f'BC, AF. HL, DE, {ALT}, IX, IY сохранены, B используется как счётчик десяти HALT',
 'O14:B200':ALL+' на полном пути с переходом континента, загрузкой карты и суточной обработкой #9704. На ранних RET меняются только AF',
 'O15:B200':ALL+' с учётом восстановления основного экрана #944A, IX и IY явно используются для рисунка и маски фрагментов',
 'O16:B200':ALL+' на ветви полного поиска и победы, I и режим IM переключаются дисковым шлюзом #6D15, победа завершается JP #0000 и не сохраняет стек вызывающего кода',
 'O16:B40A':f'HL, DE, BC, AF. {ALT}, IX, IY сохранены, C восстанавливается через PUSH/POP BC, B после цикла равен нулю',
 'O16:B5F7':f'AF. HL, DE, BC, {ALT}, IX, IY сохранены',
 'O17:B200':ALL+' с учётом выбранного подменю, ROM-калькулятора и заключительного #957C',
 'O17:B405':ALL+' с учётом безусловного продолжения общего меню по #B208, локальная обработка листания не сохраняет регистры вызывающего кода',
 'O17:B482':ALL+' с учётом расчёта расстояния #7FF0, ROM-калькулятора и вывода гарнизона #7E55',
 'O17:B5E9':f'IX. HL, DE, BC, AF, {ALT}, IY сохранены, DE, BC и AF явно восстанавливаются со стека',
 'O17:B608':f'HL, DE, BC, AF, IX. {PRES_ALT}, имена замков печатаются как обычные строки без числовых управляющих вставок',
 'O17:B6D8':ALL+' с учётом продолжения общего меню по #B208, локальный PUSH/POP AF сохраняет лишь индекс цикла внутри обработчика',
 'O17:B749':ALL+' с учётом расчёта расстояния, гарнизона и продолжения общего меню по #B208',
 'O17:B819':ALL+' через карточку #B482 и продолжение общего меню по #B208',
 'O17:B8F3':ALL+' с учётом продолжения общего меню по #B208, PUSH/POP AF внутри списка сохраняет только его текущий номер',
 'O18:B200':"HL, DE, BC, AF, BC'. HL', DE', AF', IX, IY сохранены. #8801 сохраняет основные и индексные регистры, общий распаковщик BL1 меняет B'/C' как счётчик и значение RLE-серии",
 'O18:B257':f'HL, DE, BC, AF. {ALT}, IX, IY сохранены',
 'O19:B200':"HL, DE, BC, AF, BC'. HL', DE', AF', IX, IY сохранены. #8801 сохраняет основные и индексные регистры, общий распаковщик BL1 меняет B'/C' как счётчик и значение RLE-серии",
 'O19:B2A8':f'HL, DE, BC, AF. {ALT}, IX, IY сохранены',
 'O20:B200':ALL+' не сохраняются как контракт вызывающего кода, обычного возврата нет. SP заменяется на #5F98, I=#3F, IM 1, затем TR-DOS и JP #6149',
 'O20:B25B':f"BC, {ALT} при наличии числовых управляющих вставок в переданной строке #7117. HL, DE, AF, IX, IY сохранены, B устанавливается в #FF перед общим ожиданием #7BF4",
 'O21:B200':ALL+' с учётом меню, калькулятора, числового ввода и возможного вызова боевого модуля #D255',
 'O21:B801':f'HL, DE, BC, AF, IX, IY. {ALT} сохранены. Если свободной шестибайтовой записи нет, RET #B82A выполняется до POP BC, SP остаётся ниже исходного на два байта и обычный возврат нарушается',
 'O21:BB5C':f'DE, BC, AF, {ALT}, IX, IY. HL сохранён, остальные основные регистры используются для координат, чисел и описателя отряда, IY продвигается по массиву',
 'O21:BBB2':f'DE, BC, AF, {ALT}. HL, IX, IY сохранены, HL восстанавливается после числового ввода и проверки верхней границы',
 'O22:B200':ALL+' через заключительное восстановление основного экрана #944A, собственный вывод справки сохраняет индексные регистры до этого вызова',
 'O22:B261':f'DE, BC, AF. HL, {ALT}, IX, IY сохранены, печатаемая строка продолжения не содержит числовых вставок'
}

path=ROOT/'overlay_annotations.json'
notes=json.loads(path.read_text(encoding='utf-8'))
before={key:[field for field in ('inputs','outputs','corrupt') if not note.get(field)] for key,note in notes.items()}
assert set(contracts)==set(notes)
added=0
for key,contract in contracts.items():
    if not notes[key].get('corrupt'):
        notes[key]['corrupt']=contract
        added+=1
# Убираем противоречие между Effects и подтверждённым сохранением BC через #B7C3.
notes['O13:B703']['effects']='экран, HL, DE, AF, IX'
path.write_text(json.dumps(notes,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

path=ROOT/'annotations.json'
loader=json.loads(path.read_text(encoding='utf-8'))
updates={
 '65B2':{
   'inputs':'контекст ошибки шлюза #6573, сохранённые операнды исходного SP по #65A2 и ERR_SP по #65A5, адрес возврата на исходном стеке',
   'outputs':'A=1, HL=сохранённый ERR_SP, #5C3D восстановлен, #5CC2=#C9, возврат из дискового шлюза через восстановленный SP',
   'corrupt':f'HL, AF, SP восстанавливается из операнда #65A2. DE, BC, {ALT}, IX, IY сам обработчик не изменяет, до входа они могли быть изменены TR-DOS'
 },
 '6BA1':{
   'inputs':'нет регистровых аргументов, #6C5F..#6C72 содержат четыре набора назначений пяти действий, доступны настроенные порты клавиатуры/джойстика',
   'outputs':'B=0, бит 0 C=0, Z=1 после проверки кнопки, остальные биты C содержат результат последнего опроса',
   'corrupt':f'HL, DE, BC, AF. {ALT}, IX, IY сохранены'
 },
 '6BA9':{
   'inputs':'нет регистровых аргументов, #6C5F..#6C72 содержат назначения действий, доступны настроенные порты клавиатуры/джойстика',
   'outputs':'после отпускания зафиксировано новое нажатие, B=0, бит 0 C=1, Z=0, остальные биты C содержат результат последнего опроса',
   'corrupt':f'HL, DE, BC, AF. {ALT}, IX, IY сохранены'
 },
 'E006':{
   'inputs':'нет регистровых аргументов, плеер ранее инициализирован через #E000/#E009, состояние #E070..#E0AE и музыкальные потоки доступны по сохранённым указателям',
   'outputs':f'следующий музыкальный кадр рассчитан и передан AY, {ALT}, IY сохранены',
   'corrupt':f'HL, DE, BC, AF, IX. {ALT}, IY сохранены'
 },
 'E269':{
   'outputs':'при C=0 записано #E0A7=H и A=H, Z=1. При C!=0 запись не выполняется, A=C и Z=0. CF=0 в обеих ветвях',
   'corrupt':f'AF. HL, DE, BC, {ALT}, IX, IY сохранены'
 }
}
for key,d,e in (('6BB4',10,5),('6BB9',96,8),('6BBE',64,127)):
    updates[key]={
      'inputs':'нет регистровых аргументов, бит 0 #6C4B разрешает звук, #6C4C — начальный байт порта #FE, #6C49 и R участвуют в псевдослучайной задержке',
      'outputs':f'при разрешённом звуке выведено {d} импульсов, D=0, E={e}, B=0. При выключенном звуке немедленный возврат, DE=#{d:02X}{e:02X}. HL и C сохранены',
      'corrupt':"DE, BC, AF, AF'. HL, C, HL', DE', BC', IX, IY сохранены, C внутри пары BC не изменяется"
    }
loader_added=0
loader_revised=0
for key,fields in updates.items():
    for field,value in fields.items():
        if not loader[key].get(field):loader_added+=1
        elif loader[key][field]!=value:loader_revised+=1
        loader[key][field]=value
path.write_text(json.dumps(loader,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

files={}
for name in ('overlay_annotations.json','bl3_annotations.json','annotations.json'):
    obj=json.loads((ROOT/name).read_text(encoding='utf-8'))
    missing={key:[field for field in ('inputs','outputs','corrupt') if not note.get(field)] for key,note in obj.items()}
    missing={key:fields for key,fields in missing.items() if fields}
    files[name]={'procedures':len(obj),'missing':missing,'missing_fields':sum(map(len,missing.values()))}
report={
 'overlay_fields_added':added,
 'loader_fields_added':loader_added,
 'loader_fields_revised':loader_revised,
 'overlay_effects_corrected':['O13:B703 BC сохранён'],
 'files':files,
 'nonminimal_contracts':'У сложных входов Corrupt является консервативным разрешённым набором изменений через все вызываемые ветви, а не обещанием, что каждый указанный регистр меняется при каждом вызове',
 'not_proven_preserved':{},
 'resolved_external_images':'O18/O19 используют уже разобранный распаковщик BL1, код совпадает с HERIMG, из альтернативных регистров меняется только BC\'',
 'abnormal_return':'O21:B801 при отсутствии свободной записи оставляет PUSH BC на стеке перед RET #B82A',
 'validation':'сверка листингов и PUSH/POP, графов вызовов и фиксированных печатаемых строк, сборка и запуск игры не выполнялись'
}
(ROOT/'contract_completion.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(report,ensure_ascii=True,indent=2))
