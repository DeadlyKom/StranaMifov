import sys,json
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import *
from skoolkit.simulator import Simulator
out=Path(__file__).parent
mem=list((out/'kb_at_c000_ram.bin').read_bytes()); sim=Simulator(mem);sim.registers[:]=json.loads((out/'kb_at_c000_regs.json').read_text())
for n in range(100000):
    pc=sim.registers[24]
    if pc==0x3d13:
        print('TRDOS', n, 'C=',sim.registers[3], 'R=',sim.registers[15], 'filename=',bytes(mem[0x5cdd:0x5ce6]), 'sysvars=',bytes(mem[0x5ce6:0x5cf0]).hex())
        print('c0de...',bytes(mem[0xc0da:0xc101]).hex())
        (out/'kb_before_trdos_ram.bin').write_bytes(bytes(mem));(out/'kb_before_trdos_regs.json').write_text(json.dumps(sim.registers))
        break
    sim.run()
else:raise RuntimeError('limit')
