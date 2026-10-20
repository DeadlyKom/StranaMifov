"""Lossless, read-only TRD extraction. Does not assemble or execute the game."""
from pathlib import Path
import hashlib
import json
import struct

SOURCE = Path(__file__).resolve().parents[1] / "Disk/original.trd"
DEST = Path(__file__).resolve().parents[1] / "outputs" / "MYTHLAND"


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    disk = SOURCE.read_bytes()
    assert len(disk) == 655360
    for directory in ("Extracted/Active", "Extracted/Deleted", "Disk", "Source", "Docs", "Tools", "Build"):
        (DEST / directory).mkdir(parents=True, exist_ok=True)
    (DEST / "Disk/original.trd").write_bytes(disk)
    (DEST / "Disk/track00.bin").write_bytes(disk[:4096])
    occupied = bytearray(len(disk))
    occupied[:4096] = b"\1" * 4096
    entries = []
    for slot in range(128):
        header = disk[slot * 16:slot * 16 + 16]
        if header[0] == 0:
            break
        deleted = header[0] == 1
        raw_name = header[:8]
        name = ''.join(chr(c) if 32 <= c < 127 and chr(c) not in '<>:"/\\|?*' else '_' for c in raw_name).rstrip()
        ext = chr(header[8])
        start, length = struct.unpack_from('<HH', header, 9)
        count, sector, track = header[13:16]
        offset = (track * 16 + sector) * 256
        size = count * 256
        assert offset >= 4096 and offset + size <= len(disk)
        assert not any(occupied[offset:offset + size])
        occupied[offset:offset + size] = b'\1' * size
        payload = disk[offset:offset + size]
        assert length <= size
        stem = f'{slot:02}_{name}.{ext}'
        folder = f'Extracted/{"Deleted" if deleted else "Active"}/{stem}'
        (DEST / (folder + '.bin')).write_bytes(payload[:length])
        (DEST / (folder + '.sectors.bin')).write_bytes(payload)
        (DEST / (folder + '.header.bin')).write_bytes(header)
        (DEST / (folder + '.tail.bin')).write_bytes(payload[length:])
        entry = dict(slot=slot, deleted=deleted, name=name, name_hex=raw_name.hex(), type=ext,
                     start=start, start_hex=f'{start:04X}', length=length, sectors=count,
                     sector=sector, track=track, offset=offset, allocated=size,
                     path=folder, sha256=sha(payload[:length]), sectors_sha256=sha(payload))
        if ext == 'B':
            trailer = payload[length:length+4]
            entry.update(basic_program_length=start, basic_trailer_hex=trailer.hex(),
                         basic_autostart=struct.unpack_from('<H', trailer, 2)[0] if trailer[:2] == b'\x80\xAA' else None)
        entries.append(entry)
    residual = bytearray(disk)
    for p, used in enumerate(occupied):
        if used:
            residual[p] = 0
    (DEST / 'Disk/unallocated.bin').write_bytes(residual)
    manifest = dict(source=str(SOURCE), size=len(disk), sha256=sha(disk), entries=entries,
                    active=sum(not e['deleted'] for e in entries),
                    deleted=sum(e['deleted'] for e in entries),
                    disk_label_hex=disk[0x8F5:0x900].hex(),
                    system_sector_hex=disk[0x800:0x900].hex())
    (DEST / 'Disk/manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    # Verify every byte from the extraction components, without writing a TRD.
    reconstructed = bytearray(residual)
    reconstructed[:4096] = (DEST / 'Disk/track00.bin').read_bytes()
    for e in entries:
        data = (DEST / (e['path'] + '.sectors.bin')).read_bytes()
        reconstructed[e['offset']:e['offset'] + len(data)] = data
    assert reconstructed == disk
    report = dict(extraction_byte_identical=True, sha256=sha(reconstructed),
                  total=len(entries), active=manifest['active'], deleted=manifest['deleted'],
                  allocated_file_bytes=sum(e['allocated'] for e in entries),
                  unallocated_nonzero_bytes=sum(c != 0 for c in residual))
    (DEST / 'Disk/extraction_verification.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
