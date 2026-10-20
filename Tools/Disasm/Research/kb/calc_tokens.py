import json
x=json.load(open('work/main_analysis/bitwa_reachable.json'))
for b in sorted(x['calculator_blocks'],key=lambda a:a['address']):print(f"{b['address']:04X} {b['bytes']}")
