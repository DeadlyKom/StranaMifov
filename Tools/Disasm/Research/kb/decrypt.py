import sys, json
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import *
from skoolkit.simulator import Simulator
out=Path(__file__).parent
mem=memory(3)
sim=Simulator(mem, {'PC':0x6149,'SP':0x6000})
trace=[]
for n in range(30000):
    pc=sim.registers[24]
    if pc==0x6165: break
    sim.run()
else: raise RuntimeError('step limit')
(out/'kb_stage1.bin').write_bytes(bytes(mem[0x6149:0x62df]))
(out/'kb_stage1.txt').write_text(listing(mem,0x6149,0x6241),encoding='utf-8')
print('steps',n,'cycles',sim.registers[25],'R',sim.registers[15])
print(listing(mem,0x6165,0x6241))
