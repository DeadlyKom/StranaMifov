from pathlib import Path
import sys,json,re
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze import entry,decoder,listing
ROOT=Path(__file__).resolve().parent
segments=json.loads((ROOT.parent/'main_analysis/segments.json').read_text(encoding='utf-8'))
for number,addresses in [(17,[0xB975]),(21,[0xB200])]:
    seg=next(x for x in segments if x['module_id']==number)
    _,source=entry(seg['slot'])
    blob=source[seg['offset']:seg['offset']+seg['code_payload_length']]
    mem=[0]*65536;mem[0xB200:0xB200+len(blob)]=blob
    if number==17:
        print('TABLE17',bytes(mem[0xB975:0xB983]).hex(' '))
        seeds=[mem[a]+256*mem[a+1] for a in range(0xB975,0xB983,2)]
        print('SEEDS17',[hex(s) for s in seeds])
        (ROOT/'overlay17_linear.txt').write_text(listing(mem,0xB405,0xB95A),encoding='utf-8')

        def walk(seeds):
            queue=list(seeds);seen={};calls={};external={};calcs=[]
            dec=decoder(mem)
            while queue:
                address=queue.pop()
                while 0xB200<=address<0xB200+len(blob) and address not in seen:
                    ins=dec.disassemble(address,address+1,'h')[0]
                    op=ins.operation
                    seen[address]=dict(address=address,hex=bytes(ins.data).hex(),op=op)
                    after=address+len(ins.data)
                    if op=='RST $28':
                        start=after
                        while after<0xB200+len(blob):
                            value=mem[after];after+=1
                            if value==0x38:break
                        calcs.append(dict(address=address,hex=bytes(mem[start:after]).hex()))
                    elif op.startswith(('CALL ','JP ','JR ','DJNZ ')):
                        match=re.search(r'\$([0-9A-F]{4})$',op)
                        if match:
                            target=int(match[1],16)
                            if op.startswith('CALL '):calls.setdefault(target,[]).append(address)
                            if 0xB200<=target<0xB200+len(blob):queue.append(target)
                            else:external.setdefault(target,[]).append(address)
                        if op.startswith(('JP $','JR $','JP (')):break
                    if op in ('RET','RETI','RETN') or (op.startswith('RST ') and op!='RST $28'):break
                    address=after
            return dict(origin=0xB200,end=0xB200+len(blob),seeds=seeds,
                instructions=[seen[a] for a in sorted(seen)],call_targets=calls,
                external_targets=external,calculator_blocks=calcs,module_id=17)

        graph=walk([0xB200,0xB405,0xB6D8,0xB749,0xB8F3,0xB819])
        (ROOT/'overlay17_expanded.json').write_text(json.dumps(graph,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
        starts=sorted(set(graph['seeds'])|{a for a in graph['call_targets'] if 0xB200<=a<graph['end']})
        lines=['CALL TARGETS '+','.join(f'{a:04X}' for a in starts)]
        for ins in graph['instructions']:
            if ins['address'] in starts:lines+=['','ROUTINE '+f'{ins["address"]:04X}']
            lines.append(f'{ins["address"]:04X} {ins["hex"]:<12} {ins["op"]}')
        (ROOT/'overlay17_expanded.txt').write_text('\n'.join(lines)+'\n',encoding='utf-8')
        print('EXPANDED17',len(graph['instructions']),'targets',[hex(a) for a in starts])
