-- Упаковка выполняется внутри sjasmplus, внешний упаковщик не требуется
-- Адреса и смещения взяты из исходного каталога и доказанного пути загрузки
local image_path = "MYTHLAND.trd"
local disk_size = 655360
local image
local written = {}
local kb_plain = {}

local function read_file(path)
    local file = assert(io.open(path, "rb"))
    local data = assert(file:read("a"))
    assert(file:close())
    return data
end

local function write_at(offset, data)
    -- Проверка границ исходного образа перед размещением блока
    assert(offset >= 4096 and offset + #data <= disk_size)
    for position = offset, offset + #data - 1 do
        assert(not written[position], "пересечение исходных файлов диска")
        written[position] = true
    end
    assert(image:seek("set", offset))
    assert(image:write(data))
end

function begin_image()
    -- Создание полного каркаса из служебных данных, хвостов и удалённых записей
    local layout = read_file("Tools/Disasm/Disk/layout.bin")
    assert(#layout == disk_size)
    image = assert(io.open(image_path, "w+b"))
    assert(image:write(layout))
end

function store_block(address, length, offset, key_path)
    -- Преобразование скомпилированного блока в исходное дисковое представление
    local key = key_path and read_file(key_path) or nil
    assert(not key or #key == length)
    local bytes = {}
    for index = 0, length - 1 do
        local value = sj.get_byte(address + index)
        if key then value = value ~ key:byte(index + 1) end
        bytes[#bytes + 1] = string.char(value)
    end
    write_at(offset, table.concat(bytes))
end

function capture_kb(address, length, original_offset)
    -- Сохранение открытых слоёв KB до обратного соседнего XOR-преобразования
    for index = 0, length - 1 do
        local position = original_offset + index + 1
        assert(kb_plain[position] == nil)
        kb_plain[position] = sj.get_byte(address + index)
    end
end

function finish_kb(offset)
    -- Восстановление промежуточной цепочки справа налево
    local inner = {}
    for index = 1, 406 do assert(kb_plain[index] ~= nil) end
    for index = 1, 299 do inner[index] = kb_plain[107 + index] end
    for index = 256, 0, -1 do
        inner[36 + index] = kb_plain[143 + index] ~ inner[37 + index]
    end
    -- Восстановление шифрования при переносе, затем наружных шести проходов
    local relocate_key = read_file("Tools/Disasm/Disk/Keys/KB_Relocate.xor")
    local outer_key = read_file("Tools/Disasm/Disk/Keys/KB_Outer.xor")
    assert(#relocate_key == 299 and #outer_key == 406)
    local output = {}
    for index = 1, 406 do
        local value
        if index <= 107 then value = kb_plain[index]
        else value = inner[index - 107] ~ relocate_key:byte(index - 107) end
        output[index] = string.char(value ~ outer_key:byte(index))
    end
    write_at(offset, table.concat(output))
end

function finish_image(compare_original)
    -- Проверка полной длины и исходного побайтового представления
    assert(image:flush())
    assert(image:seek("end") == disk_size)
    assert(image:close())
    image = nil
    local count = 0
    for _ in pairs(written) do count = count + 1 end
    assert(count == 348741, "неполное покрытие действующих файлов")
    if compare_original then
        local result = read_file(image_path)
        local original = read_file("Tools/Disasm/Disk/original.trd")
        assert(#result == #original)
        for index = 1, #result do
            if result:byte(index) ~= original:byte(index) then
                error(string.format("отличие от исходного диска по смещению #%06X", index - 1))
            end
        end
        print("MYTHLAND.TRD: byte-for-byte match, 655360 bytes")
    end
end
