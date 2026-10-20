import sys,json
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import *
from skoolkit.simulator import Simulator
out=Path(__file__).parent
mem=list((out/'kb_at_bfdd_ram.bin').read_bytes())
state=json.loads((out/'kb_simulation.json').read_text())['49117']['registers']
sim=Simulator(mem)
sim.registers[:]=state
trace=[]
for n in range(20000):
    pc=sim.registers[24]
    if pc==0xc000:
        (out/'kb_at_c000_ram.bin').write_bytes(bytes(mem))
        (out/'kb_at_c000_regs.json').write_text(json.dumps(sim.registers))
        (out/'kb_stage3.bin').write_bytes(bytes(mem[0xc000:0xc101]))
        print('steps',n,'cycles',sim.registers[25],'R',sim.registers[15])
        print(listing(mem,0xc000,0xc101))
        break
    sim.run()
else:raise RuntimeError('limit')
