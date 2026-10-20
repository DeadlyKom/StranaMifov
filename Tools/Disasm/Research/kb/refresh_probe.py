import sys,json
from pathlib import Path
sys.path.insert(0,str(Path('work').resolve()))
from analyze import decoder
from skoolkit.simulator import Simulator
mem=list(Path('work/kb/bl3_plain_ram.bin').read_bytes());sim=Simulator(mem);sim.registers[:]=json.loads(Path('work/kb/bl3_entry_regs.json').read_text())
for k in range(10):
 print(f'{sim.registers[24]:04X}',f'R={sim.registers[15]:02X}',f'A={sim.registers[0]:02X}')
 sim.run()

