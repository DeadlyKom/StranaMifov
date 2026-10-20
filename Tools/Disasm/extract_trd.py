"""Extract a TRD losslessly into a new directory outside the Strana project.

Installed location: Tools/Disasm/extract_trd.py. No assembly or game execution.
The original project is read-only, and --out is always required.
"""
from pathlib import Path
import argparse
import hashlib
import json
import struct


PROJECT = Path(__file__).resolve().parents[2]
SOURCE = PROJECT / 'Tools/Disasm/Disk' / 'original.trd'


def sha(data):
    return hashlib.sha256(data).hexdigest()


def safe_name(data):
    return ''.join(chr(value) if 32 <= value < 127 and chr(value) not in '<>:"/\\|?*'
                   else '_' for value in data).rstrip()


def extract(source, destination):
    source = Path(source).expanduser().resolve()
    destination = Path(destination).expanduser().resolve()
    # Refuse a project destination and any existing folder before writing files.
    if destination == PROJECT or destination.is_relative_to(PROJECT):
        raise ValueError('--out must be outside the Strana project')
    if destination.exists():
        raise FileExistsError('--out must name a new directory')
    disk = source.read_bytes()
    if len(disk) != 655360:
        raise ValueError('Expected a 655360-byte TRD image')

    # Plan and validate every extraction component before creating the output.
    files = {'Disk/original.trd': disk, 'Disk/track00.bin': disk[:4096]}
    occupied = bytearray(len(disk))
    occupied[:4096] = b'\1' * 4096
    entries = []
    for slot in range(128):
        header = disk[slot * 16:slot * 16 + 16]
        if header[0] == 0:
            break
        deleted = header[0] == 1
        raw_name = header[:8]
        name = safe_name(raw_name)
        ext = chr(header[8])
        start, length = struct.unpack_from('<HH', header, 9)
        count, sector, track = header[13:16]
        offset = (track * 16 + sector) * 256
        size = count * 256
        if sector >= 16 or offset < 4096 or offset + size > len(disk):
            raise ValueError(f'Invalid sector allocation in catalog slot {slot}')
        if any(occupied[offset:offset + size]) or length > size:
            raise ValueError(f'Overlapping or insufficient allocation in catalog slot {slot}')
        occupied[offset:offset + size] = b'\1' * size
        payload = disk[offset:offset + size]
        stem = f'{slot:02}_{name}.{safe_name(header[8:9])}'
        folder = f'Extracted/{"Deleted" if deleted else "Active"}/{stem}'
        files[folder + '.bin'] = payload[:length]
        files[folder + '.sectors.bin'] = payload
        files[folder + '.header.bin'] = header
        files[folder + '.tail.bin'] = payload[length:]
        item = dict(slot=slot, deleted=deleted, name=name, name_hex=raw_name.hex(), type=ext,
                    start=start, start_hex=f'{start:04X}', length=length, sectors=count,
                    sector=sector, track=track, offset=offset, allocated=size,
                    path=folder, sha256=sha(payload[:length]), sectors_sha256=sha(payload))
        if ext == 'B':
            trailer = payload[length:length + 4]
            item.update(basic_program_length=start, basic_trailer_hex=trailer.hex(),
                        basic_autostart=struct.unpack_from('<H', trailer, 2)[0]
                        if len(trailer) == 4 and trailer[:2] == b'\x80\xAA' else None)
        entries.append(item)

    # Preserve every byte outside the catalog and allocated file sectors too.
    residual = bytearray(disk)
    for position, used in enumerate(occupied):
        if used:
            residual[position] = 0
    files['Disk/unallocated.bin'] = bytes(residual)
    manifest = dict(source=str(source), size=len(disk), sha256=sha(disk), entries=entries,
                    active=sum(not item['deleted'] for item in entries),
                    deleted=sum(item['deleted'] for item in entries),
                    disk_label_hex=disk[0x8F5:0x900].hex(),
                    system_sector_hex=disk[0x800:0x900].hex())
    files['Disk/manifest.json'] = (json.dumps(manifest, ensure_ascii=False, indent=2) + '\n').encode('utf-8')

    # Check the planned components against the complete original image.
    reconstructed = bytearray(residual)
    reconstructed[:4096] = files['Disk/track00.bin']
    for item in entries:
        payload = files[item['path'] + '.sectors.bin']
        reconstructed[item['offset']:item['offset'] + len(payload)] = payload
    if reconstructed != disk:
        raise ValueError('Extraction components do not reproduce the original image')
    report = dict(extraction_byte_identical=True, sha256=sha(reconstructed),
                  total=len(entries), active=manifest['active'], deleted=manifest['deleted'],
                  allocated_file_bytes=sum(item['allocated'] for item in entries),
                  unallocated_nonzero_bytes=sum(value != 0 for value in residual))
    files['Disk/extraction_verification.json'] = (json.dumps(report, indent=2) + '\n').encode('utf-8')

    # Write exclusively into the new destination and verify each saved component.
    destination.mkdir(parents=True, exist_ok=False)
    for relative, payload in files.items():
        target = destination / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        with target.open('xb') as output:
            output.write(payload)
        if target.read_bytes() != payload:
            raise OSError(f'Written component differs from its source: {relative}')
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input', type=Path, default=SOURCE, help='TRD image, default: PROJECT/Tools/Disasm/Disk/original.trd')
    parser.add_argument('--out', type=Path, required=True, help='new output directory outside the project')
    args = parser.parse_args()
    try:
        report = extract(args.input, args.out)
    except (OSError, ValueError) as exc:
        parser.exit(1, f'{parser.prog}: {exc}\n')
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
