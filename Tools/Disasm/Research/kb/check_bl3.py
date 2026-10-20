from pathlib import Path
m=Path('work/kb/bl3_stage2_ram.bin').read_bytes()
for a in [0x70a7,0x6d91,0x7b21,0x7b7a,0x7b87,0x7be0]:
 end=m.find(b'\0',a);print(hex(a),m[a:end].decode('cp866',errors='replace'))
# Проверка точного сходства графических процедур с ядром после выравнивания инструкций.
import sys
sys.path.insert(0,str(Path('work').resolve()))
from analyze import entry,listing
for start,end in [(0x6d91,0x6dbc),(0x703e,0x7092)]:print(listing(list(m),start,end))
