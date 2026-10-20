import sys,json
from pathlib import Path
sys.path.insert(0,str(Path('work').resolve()))
from analyze import *
m=memory(10)
for a,b in [(0x86ea,0x8712),(0x89e0,0x8a10),(0x944a,0x94ad),(0x957c,0x9592),(0x8697,0x86b5),(0x7c0d,0x7c71)]:print(listing(m,a,b))
rom=list(Path('work/vendor/skoolkit-10.0/skoolkit/resources/48.rom').read_bytes())+[0]*49152
print(listing(rom,0x2da2,0x2dd5))
for a,b in [(0xa484,0xa4c4),(0xa4c4,0xa4f5),(0xa4f5,0xa532),(0xa532,0xa574),(0xa574,0xa59f)]:
 print(hex(a),m[a:b],bytes(m[a:b]).decode('cp866').encode('unicode_escape').decode())
