import sys,json
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import *
from skoolkit.simulator import Simulator
out=Path(__file__).parent
mem=list((out/'kb_before_load_ram.bin').read_bytes());sim=Simulator(mem);sim.registers[:]=json.loads((out/'kb_before_load_regs.json').read_text())
e,data=entry(4);mem[0x6149:0x6149+len(data)]=data
mem[0x5ce6:0x5ce8]=[0x49,0x61]
mem[0x5ce8:0x5cea]=[0xeb,0x1b]
sp=sim.registers[12];sim.registers[24]=mem[sp]+256*mem[sp+1];sim.registers[12]=sp+2
for n in range(2500000):
    pc=sim.registers[24]
    if pc==0x6149:
        print('entry',n,'cycles',sim.registers[25],'R',hex(sim.registers[15]))
        (out/'bl3_plain.bin').write_bytes(bytes(mem[0x6149:0x7d34]));(out/'bl3_plain_ram.bin').write_bytes(bytes(mem));(out/'bl3_entry_regs.json').write_text(json.dumps(sim.registers))
        (out/'bl3_plain.txt').write_text(listing(mem,0x6149,0x7d34),encoding='utf-8')
        print(listing(mem,0x6149,0x62c0));break
    if not 0xc089<=pc<0xc0d0:raise RuntimeError(f'Unexpected pc {pc:04x}')
    sim.run()
else:raise RuntimeError('limit')
