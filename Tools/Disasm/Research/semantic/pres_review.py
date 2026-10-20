from pathlib import Path
import sys,json
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import decoder,listing
BASE=Path(__file__).resolve().parents[2]
ROOT=Path(__file__).resolve().parent
source=BASE/'outputs/MYTHLAND/Extracted/Active/06_PRES.C.bin'
raw=source.read_bytes()
mem=[0]*65536
mem[0xc000:0xc000+len(raw)]=raw
(ROOT/'pres_code.txt').write_text(listing(mem,0xe200,0xc000+len(raw)),encoding='utf-8')
print('length',len(raw),'end',hex(0xc000+len(raw)))
print('first screen bytes',len(raw[:0x1b00]))
print('tail',raw[-32:].hex(' '))
