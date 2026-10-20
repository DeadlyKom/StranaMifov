import sys,json
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import *
from skoolkit.simulator import Simulator
out=Path(__file__).parent
mem=memory(3)
sim=Simulator(mem, {'PC':0x6149,'SP':0x6000})
hits={}
for n in range(100000):
    pc=sim.registers[24]
    if pc not in hits and pc in (0x6165,0x6170,0x617b,0x617c,0x617d,0x6192,0xbfdd,0xbfdc):
        hits[pc]={'steps':n,'registers':sim.registers.copy()}
        print(f'HIT {pc:04X} step={n} BC={sim.registers[2]*256+sim.registers[3]:04X} HL={sim.registers[6]*256+sim.registers[7]:04X} DE={sim.registers[4]*256+sim.registers[5]:04X} R={sim.registers[15]:02X} SP={sim.registers[12]:04X}')
        if pc in (0xbfdd,0xbfdc):
            (out/f'kb_at_{pc:04x}_ram.bin').write_bytes(bytes(mem))
            print(listing(mem,0xbfdc,0xc109))
            break
    if pc<0x4000:
        print('external',hex(pc));break
    sim.run()
else: raise RuntimeError('step limit')
(out/'kb_simulation.json').write_text(json.dumps(hits,indent=2))
(out/'kb_stage2.bin').write_bytes(bytes(mem[0xbfdd:0xc109]))
