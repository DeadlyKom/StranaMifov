"""Ограниченная проверка формата спрайтов исходными процедурами Z80, без сборки."""
from pathlib import Path
import hashlib
import json
import sys

WORK = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(WORK))
from analyze import entry, memory
from skoolkit.simulator import Simulator


def screen_address(y, byte_x):
    return 0x4000 + ((y & 192) << 5) + ((y & 7) << 8) + ((y & 56) << 2) + byte_x


def reverse(value):
    return int(f'{value:08b}'[::-1], 2)


results = []
for routine, masked, mirrored in ((0x7545, False, False), (0x75E1, False, True),
                                  (0x75A2, True, False), (0x7649, True, True)):
    for row, column in ((3, 5), (20, 28)):
        mem = memory(10, 0x615E)
        source = entry(45)[1][:256] if masked else entry(35)[1][10 * 144:11 * 144]
        mem[0xC000:0xC000 + len(source)] = source
        background = bytes(((index * 37) ^ (index >> 3) ^ 0xA5) & 255 for index in range(6912))
        mem[0x4000:0x5B00] = background
        expected = list(mem)
        for y in range(32):
            for x in range(4):
                source_x = 3 - x if mirrored else x
                value = source[y * 4 + source_x]
                value = reverse(value) if mirrored else value
                address = screen_address(row * 8 + y, column + x)
                if masked:
                    mask = source[128 + y * 4 + source_x]
                    mask = reverse(mask) if mirrored else mask
                    expected[address] = (expected[address] & mask) | value
                else:
                    expected[address] = value
        if not masked:
            for y in range(4):
                for x in range(4):
                    expected[0x5800 + (row + y) * 32 + column + x] = source[128 + y * 4 + (3 - x if mirrored else x)]
        mem[0x5FFE:0x6000] = (0, 0x5F)
        simulator = Simulator(mem, {'PC': routine, 'SP': 0x5FFE, 'BC': row * 256 + column,
                                    'DE': 0x0404, 'IX': 0xC000, 'IY': 0xC080})
        for steps in range(200000):
            if simulator.registers[24] == 0x5F00:
                break
            simulator.run()
        else:
            raise AssertionError(f'превышен предел инструкций {routine:04X}')
        actual = bytes(mem[0x4000:0x5B00])
        assert actual == bytes(expected[0x4000:0x5B00]), f'несовпадение {routine:04X}, {row}, {column}'
        results.append(dict(routine=f'#{routine:04X}', row=row, column=column,
                            source_slot=45 if masked else 35,
                            source_offset=0 if masked else 1440, instructions=steps,
                            pixels_and_all_attributes_identical=True,
                            entire_screen_sha256=hashlib.sha256(actual).hexdigest()))

report = dict(engine='SkoolKit 10.0 Python Simulator, interrupts=False, fast_ldir=False',
              boundary='от входа7545/75E1/75A2/7649 до RET на5F00, исходные машинные байты head.co',
              fixture='32x32, позиции(3,5) и(20,28), фон всех6912байтов детерминированно заполнен',
              exclusions='ассемблер, полная машина, переключение банков, графический интерфейс игры',
              cases=results, passed=len(results))
(WORK / 'semantic/graphics_consumer_verification.json').write_text(
    json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(dict(passed=len(results), cases=results), ensure_ascii=True))
