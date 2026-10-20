import sys,json
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import *
from skoolkit.simulator import Simulator
out=Path(__file__).parent
mem=list((out/'kb_before_trdos_ram.bin').read_bytes());sim=Simulator(mem);sim.registers[:]=json.loads((out/'kb_before_trdos_regs.json').read_text())
sim.registers[3]=2
sp=sim.registers[12];sim.registers[24]=mem[sp]+256*mem[sp+1];sim.registers[12]=sp+2
for n in range(100000):
    pc=sim.registers[24]
    if pc==0x3d13:
        print('TRDOS',n,'C=',sim.registers[3],'A=',sim.registers[0],'HL=',hex(sim.registers[6]*256+sim.registers[7]),'R=',sim.registers[15],'filename=',bytes(mem[0x5cdd:0x5ce6]))
        (out/'kb_before_load_ram.bin').write_bytes(bytes(mem));(out/'kb_before_load_regs.json').write_text(json.dumps(sim.registers))
        print('postdecrypt opcode',bytes(mem[0xc0ab:0xc0b0]).hex());break
    sim.run()
else:raise RuntimeError('limit')
