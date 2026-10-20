from analyze import *
for e in MANIFEST['entries']:
    if not e['deleted']:
        data = (ROOT/(e['path']+'.bin')).read_bytes()
        print('%02d %-8s %s %04X %5d %s' % (e['slot'],e['name'],e['type'],e['start'],e['length'],data[:32].hex(' ')))
for slot in (5,6,7,8,9,19,33,34,35,44,45,46,48,49,52):
    e,b=entry(slot)
    print('\n',slot,e['name'])
    print(listing(memory(slot),e['start'],e['start']+min(128,len(b))))
