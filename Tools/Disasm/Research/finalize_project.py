from pathlib import Path
from collections import Counter
import hashlib
import json

root=Path(__file__).resolve().parent.parent/'outputs/MYTHLAND'
functions=json.loads((root/'Docs/functions.json').read_text(encoding='utf-8'))
coverage=json.loads((root/'Docs/coverage.json').read_text(encoding='utf-8'))
missing={}
for fn in functions:
    absent=[key for key in ('inputs','outputs','corrupt') if not fn['analysis'].get(key)]
    if absent: missing[f"{fn['block']}:{fn['address']:04X}"]=absent
    source=(root/fn['source']).read_text(encoding='utf-8').splitlines()
    expected=fn.get('symbol','F%04X'%fn['address']).split('.')[-1]
    assert source[fn['line']-1][:16].strip()==expected, (fn['block'],fn['address'],'index line')
assert not missing,missing
assert all(fn['annotated'] and fn['analysis'].get('algorithm') for fn in functions)
assert not any(block['conflicts'] for block in coverage)
assert not any('полный контракт не установлен' in path.read_text(encoding='utf-8') for path in (root/'Source').rglob('*.asm'))
report=dict(source_blocks=len(coverage),decoded_instructions=sum(item['instructions'] for item in coverage),
    procedures_and_additional_entries=len(functions),annotated_algorithms=len(functions),
    complete_contract_headers=len(functions),missing_contracts=missing,
    function_index_points_to_instruction_lines=True,overlap_conflicts=0,
    active_content_bytes=sum(item['length'] for item in coverage),
    by_block=dict(Counter(fn['block'] for fn in functions)),
    limits='Completeness covers the identified static entry points. Runtime paths and every possible indirect entry were not exhaustively executed.')
(root/'Docs/SourceAudit.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
files=sorted(path for path in root.rglob('*') if path.is_file() and path.name!='PROJECT_FILES.sha256' and '__pycache__' not in path.parts)
manifest=''.join(hashlib.sha256(path.read_bytes()).hexdigest()+'  '+path.relative_to(root).as_posix()+'\n' for path in files)
(root/'PROJECT_FILES.sha256').write_text(manifest,encoding='utf-8')
print(json.dumps({key:value for key,value in report.items() if key!='by_block'},ensure_ascii=False,indent=2))
print('Project files:',len(files)+1)
