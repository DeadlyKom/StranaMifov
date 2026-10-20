"""Read-only listing helpers for the extracted Strana project.

Installed location: Tools/Disasm/analyze.py. SkoolKit is retained in Research.
This helper does not write sources, assemble code, or execute the game.
"""
from pathlib import Path
from types import SimpleNamespace
import argparse
import json
import sys


WORK = Path(__file__).resolve().parent
ROOT = Path(__file__).resolve().parents[2]
SKOOLKIT = WORK / 'Research' / 'vendor' / 'skoolkit-10.0'
MANIFEST = None


class Instruction:
    def __init__(self, address, operation, data):
        self.address, self.operation, self.data = address, operation, list(data)


def decoder(mem):
    # Load the archived decoder only when disassembly is requested.
    if str(SKOOLKIT) not in sys.path:
        sys.path.insert(0, str(SKOOLKIT))
    from skoolkit.disassembler import Disassembler
    return Disassembler(mem, SimpleNamespace(
        asm_hex=True, asm_lower=False, defb_size=16, defm_size=64,
        defw_size=1, handle_rst=False, imaker=Instruction,
        opcodes='ALL', wrap=False))


def entry(slot, sectors=False):
    global MANIFEST
    # Resolve the catalog and its project-relative extraction path.
    if MANIFEST is None:
        MANIFEST = json.loads((ROOT / 'Tools/Disasm/Disk' / 'manifest.json').read_text(encoding='utf-8'))
    matches = [item for item in MANIFEST['entries'] if item['slot'] == slot]
    if len(matches) != 1:
        raise ValueError(f'Catalog slot {slot} is absent or ambiguous')
    item = matches[0]
    suffix = '.sectors.bin' if sectors else '.bin'
    path = (ROOT / (item['path'] + suffix)).resolve()
    if not path.is_relative_to(ROOT):
        raise ValueError('Catalog payload path is outside the project')
    return item, path.read_bytes()


def memory(slot, origin=None, sectors=False):
    item, data = entry(slot, sectors)
    origin = item['start'] if origin is None else origin
    # Validate the complete load range before creating the memory snapshot.
    if not 0 <= origin <= 65536 or origin + len(data) > 65536:
        raise ValueError('The payload does not fit in the 64K address space')
    mem = [0] * 65536
    mem[origin:origin + len(data)] = data
    return mem


def listing(mem, start, end):
    if len(mem) != 65536 or not 0 <= start <= end <= 65536:
        raise ValueError('Expected a 64K snapshot and a valid listing range')
    return '\n'.join(
        f'{item.address:04X} {bytes(item.data).hex(" ").upper():<14} {item.operation}'
        for item in decoder(mem).disassemble(start, end, 'h'))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('slot', type=int, help='TRD catalog slot, decimal')
    parser.add_argument('origin', nargs='?', type=lambda value: int(value, 16), help='load address, hex')
    parser.add_argument('start', nargs='?', type=lambda value: int(value, 16), help='listing start, hex')
    parser.add_argument('end', nargs='?', type=lambda value: int(value, 16), help='listing end, hex, exclusive')
    parser.add_argument('--sectors', action='store_true', help='include all allocated sector bytes')
    args = parser.parse_args()
    try:
        item, data = entry(args.slot, args.sectors)
        origin = item['start'] if args.origin is None else args.origin
        start = origin if args.start is None else args.start
        end = min(origin + len(data), start + 512) if args.end is None else args.end
        print(listing(memory(args.slot, origin, args.sectors), start, end))
    except (OSError, ValueError, KeyError, ImportError) as exc:
        parser.exit(1, f'{parser.prog}: {exc}\n')


if __name__ == '__main__':
    main()
