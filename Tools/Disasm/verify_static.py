"""Verify transcription and disk representation without invoking any assembler.

Instruction mnemonics and resolved operands are compared to the preserved
disassembler reference before its instruction bytes are used. Data directives
and resources are read directly from the current source. No assembler is invoked.
This check deliberately cannot establish that SjASMPlus accepts the source.
"""
from pathlib import Path
import hashlib
import ast
import json
import re
import sys

ROOT = Path(__file__).resolve().parents[2]

def source_lines(relative,stack=()):
    path=(ROOT/relative).resolve()
    assert path.is_relative_to(ROOT.resolve()) and path not in stack
    for number,line in enumerate(path.read_text(encoding='utf-8').splitlines(),1):
        match=re.match(r'^\s*include\s+"([^"]+)"\s*(?:;.*)?$',line,re.I)
        if match:
            yield from source_lines(match[1],stack+(path,))
        else:
            yield path.relative_to(ROOT).as_posix(),number,line


def read_source(block, reference, symbols):
    address = block['origin']
    data = bytearray()
    labels = set()
    scope = ''
    symbol_values=symbols.get('values',{})
    module=symbols.get('modules',{}).get(block['block'],block['block'])
    def lookup(token):
        if token in symbol_values: return symbol_values[token]
        qualified = module+'.'+(scope+token if token.startswith('.') else token)
        if qualified in symbol_values: return symbol_values[qualified]
        if re.fullmatch('[FL][0-9A-F]{4}',token): return int(token[1:],16)
        return None
    def parse_number(value):
        # Определение значения константы или смещения без исполнения выражения Python
        expression=re.sub(r'#([0-9A-Fa-f]+)',lambda m:str(int(m[1],16)),value.strip())
        expression=expression.replace('$',str(address))
        def name(match):
            result=lookup(match[0])
            assert result is not None, (block['source'],'unknown data symbol',match[0])
            return str(result)
        expression=re.sub(r'(?<![A-Za-z0-9_.])\.?[A-Za-z_][A-Za-z0-9_.]*',name,expression)
        def number(node):
            if isinstance(node,ast.Constant) and isinstance(node.value,int): return node.value
            if isinstance(node,ast.UnaryOp) and isinstance(node.op,(ast.UAdd,ast.USub)):
                result=number(node.operand)
                return result if isinstance(node.op,ast.UAdd) else -result
            if isinstance(node,ast.BinOp) and isinstance(node.op,(ast.Add,ast.Sub,ast.Mult)):
                left,right=number(node.left),number(node.right)
                if isinstance(node.op,ast.Add): return left+right
                if isinstance(node.op,ast.Sub): return left-right
                return left*right
            raise AssertionError((block['source'],'unsupported data expression',value))
        return number(ast.parse(expression,mode='eval').body)
    def canonical(instruction):
        def symbol(match):
            token=match[0]
            result=lookup(token)
            if result is not None: return str(result)
            return token.upper()
        instruction=re.sub(r'(?<![A-Za-z0-9_.])\.?[A-Za-z_][A-Za-z0-9_.]*',symbol,instruction)
        instruction=re.sub(r'#([0-9A-Fa-f]+)',lambda m:str(int(m[1],16)),instruction)
        instruction=re.sub(r'\(\s*(I[XY])\s*\)',r'(\1+0)',instruction)
        def arithmetic(match):
            return str(parse_number(match[0]))
        instruction=instruction.replace('+-','-')
        instruction=re.sub(r'(?<![A-Z0-9_])\d+(?:\s*[+*-]\s*\d+)+',arithmetic,instruction).replace('+-','-')
        return re.sub(r'\s+','',instruction).replace('+-','-')
    for source_file,number,line in source_lines(block['source']):
        if ';' in line and line[:line.index(';')].strip():
            label_only=line.index(';')==16 and not line.startswith(' ')
            assert line.index(';') == 80 or label_only, (source_file, number, 'comment column')
        code, _, comment = line.partition(';')
        if not code.strip():
            continue
        if code[0] != ' ':
            assert code[16:17] != ' ', (source_file,number,'label column')
            label = code[:16].strip()
            if label.startswith('.'):
                label=scope+label
            else: scope=label
            assert label not in labels,label
            labels.add(label)
            # Проверка фактического адреса именованной метки по реестру
            qualified = module+'.'+label
            definition=code[16:].strip()
            if definition.upper().startswith('EQU '):
                # Проверка адреса именованного операнда самомодифицируемой команды
                value=parse_number(definition[4:])
                assert qualified in symbol_values,(source_file,number,'unregistered EQU',qualified)
                assert symbol_values[qualified]==value,(source_file,number,'EQU value',qualified,value)
                continue
            if qualified in symbol_values:
                assert symbol_values[qualified] == address, (source_file, number, 'symbol address', qualified)
            code = code[16:]
        code = code.strip()
        if not code: continue
        if code.lower().startswith(('module ', 'org ', 'assert ', 'endmodule')):
            continue
        if code.startswith('INCBIN '):
            match=re.fullmatch(r'INCBIN "([^"]+)"',code)
            assert match,(block['source'],number,'incbin syntax')
            path=(ROOT/match[1]).resolve()
            assert path.is_relative_to(ROOT.resolve())
            chunk=path.read_bytes()
            assert not any(str(p) in reference for p in range(address,address+len(chunk))), (block['block'],address,'resource overlaps instructions')
        elif code.startswith('DW '):
            chunk=b''.join(parse_number(value).to_bytes(2,'little') for value in code[3:].split(','))
        elif code.startswith('DB '):
            data_values=code[3:].split(',')
            chunk=bytes(parse_number(value) for value in data_values)
            if str(address) in reference:
                expected=reference[str(address)]
                # Проверка данных или явной записи исходной команды ED 71
                assert (expected[2] or expected[0].startswith('DEFB ')
                        or (expected[0] == 'OUT (C),0' and expected[1] == 'ed71'))
                assert chunk.hex()==expected[1]
        else:
            # Проверка мнемоники и разрешённых операндов до получения эталонных байтов
            assert str(address) in reference, (source_file,number,'instruction address',address)
            expected=reference[str(address)]
            assert not expected[2], (source_file,number,'data decoded as instruction')
            normalized=canonical(code)
            assert normalized==canonical(expected[0]),(source_file,number,'mnemonic transcription',code,expected[0])
            chunk=bytes.fromhex(expected[1])
            # Check that literal-label targets still match the original branch bytes.
            match=re.search(r'\b[FL]([0-9A-F]{4})$',code)
            if match:
                target=int(match[1],16)
                if chunk[0] in (0x18,0x20,0x28,0x30,0x38,0x10):
                    delta=chunk[1] if chunk[1]<128 else chunk[1]-256
                    assert address+2+delta==target
                elif len(chunk)==3:
                    assert chunk[1]|chunk[2]<<8==target
        data.extend(chunk)
        address += len(chunk)
    assert len(data)==block['length'],(block['block'],len(data),block['length'])
    return data


def verify():
    coverage=json.loads((ROOT/'Tools/Disasm/Reports/coverage.json').read_text(encoding='utf-8'))
    manifest=json.loads((ROOT/'Tools/Disasm/Disk/manifest.json').read_text(encoding='utf-8'))
    references=json.loads((ROOT/'Tools/Disasm/Reports/InstructionReference.json').read_text(encoding='utf-8'))
    symbols=json.loads((ROOT/'Tools/Disasm/Reports/Symbols.json').read_text(encoding='utf-8')) if (ROOT/'Tools/Disasm/Reports/Symbols.json').exists() else {}
    result=bytearray((ROOT/'Tools/Disasm/Disk/layout.bin').read_bytes())
    original=(ROOT/'Tools/Disasm/Disk/original.trd').read_bytes()
    written=bytearray(len(result))
    kb=bytearray(406)
    kb_written=bytearray(406)
    for block in coverage:
        assert not block['conflicts'],block['block']
        data=read_source(block,references[block['block']],symbols)
        if block['slot']==3:
            p=block['offset']; kb[p:p+len(data)]=data
            assert not any(kb_written[p:p+len(data)])
            kb_written[p:p+len(data)]=b'\1'*len(data)
            continue
        if block['key']:
            key=(ROOT/block['key']).read_bytes()
            assert len(key)==len(data)
            data=bytes(x^y for x,y in zip(data,key))
        p=manifest['entries'][block['slot']]['offset']+block['offset']
        assert not any(written[p:p+len(data)])
        written[p:p+len(data)]=b'\1'*len(data)
        result[p:p+len(data)]=data
    assert all(kb_written)
    inner=bytearray(kb[107:])
    for j in range(256,-1,-1):
        inner[35+j]=kb[142+j]^inner[36+j]
    relocation=(ROOT/'Tools/Disasm/Disk/Keys/KB_Relocate.xor').read_bytes()
    outer=(ROOT/'Tools/Disasm/Disk/Keys/KB_Outer.xor').read_bytes()
    assert len(relocation)==299 and len(outer)==406
    kb[107:]=bytes(x^y for x,y in zip(inner,relocation))
    kb=bytes(x^y for x,y in zip(kb,outer))
    p=manifest['entries'][3]['offset']
    result[p:p+406]=kb
    written[p:p+406]=b'\1'*406
    assert result==original,'disk transcription differs from original'
    functions=json.loads((ROOT/'Tools/Disasm/Reports/functions.json').read_text(encoding='utf-8'))
    report=dict(transcription_byte_identical=True,
        sha256=hashlib.sha256(result).hexdigest(),image_bytes=len(result),
        source_blocks=len(coverage),source_bytes=sum(written),
        decoded_instructions=sum(b['instructions'] for b in coverage),
        procedures=len(functions),semantically_annotated=sum(f['annotated'] for f in functions),
        mnemonics_match_disassembler_reference=True,
        assembler_executed_by_this_check=False,full_machine_executed=False,
        limitation='Instruction mnemonics and resolved operands matched the immutable reference before reference instruction bytes were used. Data and resources were read from source. This is not assembly validation.')
    return report


if __name__=='__main__':
    try:
        print(json.dumps(verify(),ensure_ascii=False,indent=2))
    except (AssertionError,ValueError,OSError) as error:
        print('Verification failed:',error,file=sys.stderr)
        sys.exit(1)
