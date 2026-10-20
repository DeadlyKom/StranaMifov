from analyze import *
for name in ('head','bitwa'):
    d=json.loads((WORK/f'main_analysis/{name}_reachable.json').read_text())
    print(name,len(d['instructions']),'instructions',len(d['call_targets']),'CALL targets')
    for c in d['calculator_blocks']:
        print('%04X %s'%(c['address'],c['bytes']))
