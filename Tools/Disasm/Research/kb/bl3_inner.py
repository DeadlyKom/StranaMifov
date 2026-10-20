import sys,json
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import *
from skoolkit.simulator import Simulator
out=Path(__file__).parent
mem=list((out/'bl3_plain_ram.bin').read_bytes());sim=Simulator(mem);sim.registers[:]=json.loads((out/'bl3_entry_regs.json').read_text())
for n in range(100000):
    pc=sim.registers[24]
    if pc==0x615e:
        print('stage5',n,'cycles',sim.registers[25],'R',hex(sim.registers[15]))
        (out/'bl3_stage2.bin').write_bytes(bytes(mem[0x6149:0x7d34]));(out/'bl3_stage2_ram.bin').write_bytes(bytes(mem));(out/'bl3_stage2_regs.json').write_text(json.dumps(sim.registers))
        (out/'bl3_stage2.txt').write_text(listing(mem,0x6149,0x7d34),encoding='utf-8')
        print(listing(mem,0x615e,0x629f));break
    sim.run()
else:raise RuntimeError('limit')
