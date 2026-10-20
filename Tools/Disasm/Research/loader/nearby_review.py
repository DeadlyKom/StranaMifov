from pathlib import Path
import sys,json
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import decoder,listing
BASE=Path(__file__).resolve().parents[2]
ROOT=Path(__file__).resolve().parent
path=next((BASE/'outputs').glob('*/Extracted/Active/10_head.co.C.bin'))
raw=path.read_bytes();mem=[0]*65536;mem[0x615E:0x615E+len(raw)]=raw
(ROOT/'nearby_extra.txt').write_text(listing(mem,0x91D1,0x92CB),encoding='utf-8')
print('TABLES',bytes(mem[0x9292:0x92CB]).hex(' '))
(ROOT/'nearby_head_memory.bin').write_bytes(bytes(mem))
