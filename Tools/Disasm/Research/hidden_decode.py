from analyze import *
from skoolkit.simulator import Simulator
from skoolkit.simutils import PC, R, SP, T

m = list((WORK / 'loader/hidden_memory.bin').read_bytes())
m[:16384] = (WORK / 'vendor/skoolkit-10.0/skoolkit/resources/48.rom').read_bytes()
m[0x5C51:0x5C53] = [0x26,0x5D]
s = Simulator(m, {'PC':0x6171,'SP':0x5FB3,'IY':0x5C3A})
trace = []
count = 0
while s.registers[PC] != 0x61A8:
    p = s.registers[PC]
    if count < 70:
        trace.append((hex(p),s.registers[R],hex(s.registers[SP])))
    if count > 800000:
        raise RuntimeError((hex(p),trace))
    s.run()
    count += 1
(WORK/'loader/hidden_stage2.bin').write_bytes(bytes(m))
(WORK/'loader/hidden_stage2.txt').write_text(listing(m,0x6171,0x7771),encoding='utf-8')
print('instructions',count,'R',s.registers[R],'T',s.registers[T])
print('first trace',trace[:45])
print(listing(m,0x61A8,0x6320))
