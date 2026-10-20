from pathlib import Path
import json
import sys

work=Path(__file__).resolve().parent
sys.path.insert(0,str(work/'vendor/skoolkit-10.0'))
from skoolkit.simulator import Simulator
from skoolkit.simutils import PC,H,L,T
from semantic_screens import ROOT,source,export

items=export()
results=[]
rom=(work/'vendor/skoolkit-10.0/skoolkit/resources/48.rom').read_bytes()
for slot in (8,33,34):
    original=source(slot)
    origin=0x7D33 if slot==8 else 0xC000
    group=[item for item in items if item['slot']==slot]
    for number,item in enumerate(group,1):
        memory=[0]*65536
        memory[:16384]=rom
        memory[origin:origin+len(original)]=original
        memory[origin+2]=number
        memory[0x5FF0:0x5FF2]=(0x5B00).to_bytes(2,'little')
        sim=Simulator(memory,{'PC':origin,'SP':0x5FF0})
        count=0
        while sim.registers[PC]!=0x5B00:
            sim.run();count+=1
            assert count<1_000_000,(slot,number,sim.registers[PC])
        actual=bytes(memory[0x4000:0x5B00])
        expected=(ROOT/item['raw']).read_bytes()
        assert actual==expected,(slot,number,'independent RLE vs original Z80')
        consumed=sim.registers[L]+256*sim.registers[H]-origin-item['offset']-5
        assert consumed==item['consumed_stream_bytes']
        results.append(dict(slot=slot,picture=number,instructions=count,tstates=sim.registers[T],
            independent_decoder_matches_original=True,trailing_bytes=item['trailing_bytes']))
(ROOT/'Docs/ScreenDecodeVerification.json').write_text(json.dumps(dict(
    decoder='independent Python RLE compared to original Z80 decoder in SkoolKit Simulator',
    rom_call='standard 48K ROM, CALL 007C, RET',full_machine=False,results=results),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(pictures_verified=len(results),slots=[8,33,34],matches_original_decoder=True)))
