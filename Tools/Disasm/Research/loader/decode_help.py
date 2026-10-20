from pathlib import Path
import sys
import json

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from analyze import WORK, ROOT, MANIFEST
from skoolkit.simulator import Simulator
from skoolkit.simutils import PC, R, T

entry = MANIFEST['entries'][52]
source = (ROOT / (entry['path'] + '.bin')).read_bytes()
memory = list((WORK/'loader/hidden_stage2.bin').read_bytes())
memory[:16384] = (WORK/'vendor/skoolkit-10.0/skoolkit/resources/48.rom').read_bytes()
memory[0x7724:0x7724+len(source)] = source
memory[0x5CE8:0x5CEA] = len(source).to_bytes(2,'little')
memory[0x5CEB:0x5CED] = [entry['sector'],entry['track']]
sim = Simulator(memory, {'PC':0x6218, 'SP':0x5FB3, 'IY':0x5C3A})
count=0
while sim.registers[PC] != 0x6237:
    sim.run()
    count += 1
    if count > 1000000:
        raise RuntimeError(f'Unexpected PC {sim.registers[PC]:04X}')
decoded = bytes(memory[0x7724:0x7724+len(source)])
(WORK/'loader/help_decoded.bin').write_bytes(decoded)
(WORK/'loader/help_cp866.txt').write_text(decoded.decode('cp866'),encoding='utf-8')

# Разделение страниц выполняется по нулевым байтам, не удаляя информацию о кодах.
pages=[]
for index,raw in enumerate(decoded.split(b'\0')):
    if not raw:
        continue
    pages.append(f'--- Фрагмент {index}, {len(raw)} байтов ---\n' + raw.decode('cp866'))
(WORK/'loader/help_pages.txt').write_text('\n\n'.join(pages),encoding='utf-8')
(WORK/'loader/help_readable.txt').write_text(decoded.decode('cp866').replace('\r','\n').replace('\x00','\n[конец страницы]\n'),encoding='utf-8')
meta=dict(source_slot=52,source_length=len(source),
    descriptor_sector=entry['sector'],descriptor_track=entry['track'],
    register_R_seed=entry['sector']^entry['track'],
    entry_pc='6218',exit_pc='6237',instructions=count,tstates=sim.registers[T],
    decoded_prefix_hex=decoded[:64].hex(' '),decoded_length=len(decoded))
(WORK/'loader/help_decode.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(meta,ensure_ascii=True))
