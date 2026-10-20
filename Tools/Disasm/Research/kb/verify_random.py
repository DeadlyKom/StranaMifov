import sys,json,random
from pathlib import Path
sys.path.insert(0,str(Path('work').resolve()))
from analyze import *
from skoolkit.simulator import Simulator
m=list(Path('work/kb/bl3_stage2_ram.bin').read_bytes())
fixtures=[]
for x,y,z,n in [(1,2,3,0),(1,2,3,1),(123,456,789,10),(65535,65535,65535,65535),(0x8123,0x7fff,0x9999,1000),(0,0,1,65000)]:
 mem=m.copy()
 for a,v in [(0x7190,x),(0x7192,y),(0x7194,z)]:mem[a:a+2]=[v&255,v>>8]
 sim=Simulator(mem,{'PC':0x7132,'SP':0x5f00,'DE':n,'HL':0x2345,'BC':0x5678,'A':0x9a,'F':0x41,'IX':0xabcd})
 mem[0x5f00:0x5f02]=[0x00,0x5f]
 for count in range(2000):
  if sim.registers[24]==0x5f00:break
  sim.run()
 else:raise RuntimeError('limit')
 zz=(x+y+z)&0xffff;zz=((zz<<1)|(zz>>15))&0xffff
 expected=(zz*n+32768)>>16
 actual=sim.registers[4]*256+sim.registers[5]
 assert actual==expected,(actual,expected)
 assert sim.registers[6:8]==[0x23,0x45] and sim.registers[2:4]==[0x56,0x78]
 fixtures.append({'x':x,'y':y,'z':z,'limit':n,'result':actual,'newz':zz,'instructions':count})
Path('work/kb/bl3_random_verification.json').write_text(json.dumps({'mode':'bounded individual routine simulation, no build/full game','fixtures':fixtures},indent=2))
print('verified',len(fixtures))
