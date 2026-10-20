from pathlib import Path
import sys, re, json
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from analyze import entry, memory, decoder

OUT = Path(__file__).resolve().parent
for slot, origin, seeds, name in ((10,0x615E,[0x615E,0x6161,0x631C],'head'),(47,0xD255,[0xD255],'bitwa')):
    _, raw = entry(slot)
    mem = memory(slot, origin)
    dec = decoder(mem)
    end = origin+len(raw)
    queue = list(seeds)
    done, calls, external, calcs = {}, {}, {}, []
    while queue:
        address = queue.pop()
        while origin <= address < end and address not in done:
            ins = dec.disassemble(address, address+1, 'h')[0]
            op = ins.operation
            done[address] = {'address':address,'hex':bytes(ins.data).hex(),'op':op}
            after = address+len(ins.data)
            if op == 'RST $28':
                calc = []
                while after < end:
                    value=mem[after]; calc.append(value); after+=1
                    if value==0x38: break
                    # Relative branch and calculator constants require exact parsing;
                    # no calculator branch is present in the initial simple cases.
                calcs.append({'address':address,'bytes':bytes(calc).hex()})
            elif op.startswith(('CALL ', 'JP ', 'JR ', 'DJNZ ')):
                match = re.search(r'\$([0-9A-F]{4})$',op)
                if match:
                    target=int(match[1],16)
                    if op.startswith('CALL '):
                        calls.setdefault(target,[]).append(address)
                    if origin <= target < end: queue.append(target)
                    else: external.setdefault(target,[]).append(address)
                if op.startswith(('JP $', 'JR $','JP (')): break
            if op in ('RET','RETI','RETN'): break
            if op.startswith('RST ') and op != 'RST $28': break
            address=after
    result={'slot':slot,'origin':origin,'end':end,'seeds':seeds,'instructions':[done[k] for k in sorted(done)],'call_targets':calls,'external_targets':external,'calculator_blocks':calcs,'limitation':'Conservative entry-reachable static graph, indirect targets omitted; RST 28 parser scans to first 38 and needs manual verification.'}
    (OUT/(name+'_reachable.json')).write_text(json.dumps(result,indent=2),encoding='utf-8')
    (OUT/(name+'_reachable.lst')).write_text('\n'.join(f"{k:04X} {done[k]['hex']:<12} {done[k]['op']}" for k in sorted(done)),encoding='utf-8')
    print(name,len(done),'instructions',len(calls),'direct call targets',len(external),'external targets',len(calcs),'calculator blocks')
