from pathlib import Path
import sys,re,json
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import entry,decoder,memory
OUT=Path(__file__).resolve().parent

def walk(data,origin,seeds):
    end=origin+len(data); mem=[0]*65536;mem[origin:end]=data; dec=decoder(mem)
    queue=list(seeds);seen={};calls={};external={};calcs=[];warnings=[]
    while queue:
        address=queue.pop()
        while origin<=address<end and address not in seen:
            ins=dec.disassemble(address,address+1,'h')[0]
            op=ins.operation;seen[address]={'address':address,'hex':bytes(ins.data).hex(),'op':op}
            after=address+len(ins.data)
            if op.startswith('DEFB '):warnings.append({'address':address,'reason':'decoder fallback on reachable path'});break
            if op=='RST $28':
                calc=[]
                while after<end:
                    byte=mem[after];calc.append(byte);after+=1
                    if byte==0x38:break
                calcs.append({'address':address,'bytes':bytes(calc).hex()})
            elif op.startswith(('CALL ','JP ','JR ','DJNZ ')):
                match=re.search(r'\$([0-9A-F]{4})$',op)
                if match:
                    target=int(match[1],16)
                    if op.startswith('CALL '):calls.setdefault(target,[]).append(address)
                    if origin<=target<end:queue.append(target)
                    else:external.setdefault(target,[]).append(address)
                if op.startswith(('JP $','JR $','JP (')):break
            if op in ('RET','RETI','RETN'):break
            if op.startswith('RST ') and op!='RST $28':
                warnings.append({'address':address,'reason':'non-calculator RST reached'});break
            address=after
    return {'origin':origin,'end':end,'seeds':list(seeds),'instructions':[seen[k] for k in sorted(seen)],'call_targets':calls,'external_targets':external,'calculator_blocks':calcs,'warnings':warnings}

graphs=[];main_seeds={0x615E,0x6161,0x631C}
segments=json.loads((OUT/'segments.json').read_text(encoding='utf-8'))
for seg in segments:
    _,raw=entry(seg['slot']);data=raw[seg['offset']:seg['offset']+seg['code_payload_length']]
    graph=walk(data,0xB200,[0xB200]);graph['module_id']=seg['module_id'];graph['slot']=seg['slot'];graph['file_offset']=seg['offset']
    graphs.append(graph)
    main_seeds.update(int(x) for x in graph['external_targets'] if 0x615E<=int(x)<0xAE94)
_,battle=entry(47);bg=walk(battle,0xD255,[0xD255])
main_seeds.update(int(x) for x in bg['external_targets'] if 0x615E<=int(x)<0xAE94)
_,head=entry(10);hg=walk(head,0x615E,sorted(main_seeds))
indices={'head':{'slot':10,'seeds':sorted(main_seeds),'call_targets':[int(k) for k in hg['call_targets'] if 0x615E<=int(k)<0xAE94]},'battle':{'slot':47,'seeds':[0xD255],'call_targets':[int(k) for k in bg['call_targets'] if 0xD255<=int(k)<0xFF94]},'overlays':[{'module_id':g['module_id'],'slot':g['slot'],'offset':g['file_offset'],'entrypoints':[0xB200],'call_targets':[int(k) for k in g['call_targets'] if g['origin']<=int(k)<g['end']]} for g in graphs],'limitation':'Reachability of static direct control flow only. Unknown indirect/stack-driven dispatch can add entries. Calculator payloads retained as data, exact ROM semantics not checked. Function start set consists of entrypoints plus direct CALL targets; tail calls in external_targets may add entries.'}
for name,data in [('overlay_graphs',graphs),('head_reachable',hg),('bitwa_reachable',bg),('entrypoints',indices)]:
    (OUT/(name+'.json')).write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name,g in [('head',hg),('bitwa',bg)]:
    (OUT/(name+'_reachable.lst')).write_text('\n'.join(f"{i['address']:04X} {i['hex']:<12} {i['op']}" for i in g['instructions']),encoding='utf-8')
print('head',len(hg['instructions']),'instructions',len(indices['head']['call_targets']),'functions',len(main_seeds),'external-proven entrypoints')
print('battle',len(bg['instructions']),'instructions',len(indices['battle']['call_targets']),'functions')
print('overlays',len(graphs),'modules',sum(len(g['instructions']) for g in graphs),'instructions',sum(len(g['call_targets']) for g in graphs),'called targets including external')
print('warnings',sum(len(g['warnings']) for g in graphs)+len(hg['warnings'])+len(bg['warnings']))
