from analyze import *
fs=json.loads((ROOT/'Docs/functions.json').read_text(encoding='utf-8'))
cs={b['block']:b for b in json.loads((ROOT/'Docs/coverage.json').read_text(encoding='utf-8'))}
lines=[]
for f in fs:
    if f['block'] not in ('CTPB','S04','S05','S08','S33','S34') and not (f['block'].startswith('O') and int(f['block'][1:])<=12): continue
    if f['annotated'] and f['block'] not in ('S04','S05'): continue
    c=cs[f['block']]
    print(f['block'],'%04X'%f['address'],f['description'],len(f['instructions']))
    if f['block']=='S04':
        mem=[0]*65536
        raw=(WORK/'kb/bl3_stage2.bin').read_bytes()
        mem[0x6149:0x6149+len(raw)]=raw
    elif f['block'].startswith('O'):
        _,raw=entry(c['slot'])
        data=raw[c['offset']:c['offset']+c['length']]
        mem=[0]*65536; mem[c['origin']:c['origin']+len(data)]=data
    else:
        mem=memory(c['slot'],c['origin'])
    lines.append('\n== '+f['block']+' %04X'%f['address']+' ==\n')
    for p in f['instructions']:
        lines.append(listing(mem,p,p+1))
    lines.append('READS '+str([hex(a) for a in f['reads']])+' WRITES '+str([hex(a) for a in f['writes']]))
(WORK/'root_functions.txt').write_text('\n'.join(lines),encoding='utf-8')
