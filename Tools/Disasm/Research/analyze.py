from pathlib import Path
from types import SimpleNamespace
import json
import sys

WORK = Path(__file__).resolve().parent
sys.path.insert(0, str(WORK / 'vendor/skoolkit-10.0'))
from skoolkit.disassembler import Disassembler

ROOT = WORK.parent / 'outputs/MYTHLAND'
MANIFEST = json.loads((ROOT / 'Disk/manifest.json').read_text(encoding='utf-8'))

class Instruction:
    def __init__(self, address, operation, data):
        self.address, self.operation, self.data = address, operation, list(data)

def decoder(memory):
    return Disassembler(memory, SimpleNamespace(asm_hex=True, asm_lower=False, defb_size=16,
        defm_size=64, defw_size=1, handle_rst=False, imaker=Instruction, opcodes='ALL', wrap=False))

def entry(slot, sectors=False):
    e = MANIFEST['entries'][slot]
    return e, (ROOT / (e['path'] + ('.sectors.bin' if sectors else '.bin'))).read_bytes()

def memory(slot, origin=None, sectors=False):
    e, data = entry(slot, sectors)
    origin = e['start'] if origin is None else origin
    m = [0] * 65536
    assert origin + len(data) <= 65536
    m[origin:origin + len(data)] = data
    return m

def listing(mem, start, end):
    return '\n'.join(f'{i.address:04X} {bytes(i.data).hex(" ").upper():<14} {i.operation}' for i in decoder(mem).disassemble(start, end, 'h'))

if __name__ == '__main__':
    slot = int(sys.argv[1])
    e, data = entry(slot, '--sectors' in sys.argv)
    org = int(sys.argv[2], 16) if len(sys.argv) > 2 and not sys.argv[2].startswith('--') else e['start']
    start = int(sys.argv[3], 16) if len(sys.argv) > 3 and not sys.argv[3].startswith('--') else org
    end = int(sys.argv[4], 16) if len(sys.argv) > 4 and not sys.argv[4].startswith('--') else min(org + len(data), start + 512)
    print(listing(memory(slot, org, '--sectors' in sys.argv), start, end))
