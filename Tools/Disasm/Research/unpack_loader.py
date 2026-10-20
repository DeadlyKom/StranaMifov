from analyze import *
from skoolkit.simulator import Simulator
from skoolkit.simutils import PC, R, SP, T

out = WORK / 'loader'
out.mkdir(exist_ok=True)
e, data = entry(2, True)
m = [0] * 65536
m[0x8000:0x8000 + len(data) - 256] = data[256:]
s = Simulator(m, {'PC':0x8000,'SP':0x5FB3})
steps = 0
while s.registers[PC] != 0x804F:
    if steps > 300000:
        raise RuntimeError(hex(s.registers[PC]))
    s.run()
    steps += 1
(out / 'stage1.bin').write_bytes(bytes(m[0x8000:0xA300]))
(out / 'stage1.txt').write_text(listing(m,0x8000,0x80BC), encoding='utf-8')
print('stage1 instructions',steps,'R',s.registers[R],'T',s.registers[T])
print(listing(m,0x804F,0x80BC))
while s.registers[PC] != 0x808A:
    if steps > 600000:
        raise RuntimeError(hex(s.registers[PC]))
    s.run()
    steps += 1
(out / 'stage2.bin').write_bytes(bytes(m[0x8000:0xA300]))
(out / 'stage2.txt').write_text(listing(m,0x8000,0x80BC), encoding='utf-8')
print('stage2 instructions',steps,'R',s.registers[R],'T',s.registers[T])
print(listing(m,0x808A,0x80BC))
