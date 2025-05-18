--[[
    ������: table.isempty
    ����: �������ı��Ƿ�Ϊ��
    ����:
      - t (table): Ҫ���ı�
    ����:
      - (boolean): �����Ϊ���򷵻� true�����򷵻� false
    ˵��:
      - �˺���ʹ�� Lua �����ú��� `next()` ���жϱ��Ƿ�Ϊ�ա�`next()` �᷵�ر��еĵ�һ����ֵ�ԡ�
      - �������û��Ԫ�أ�`next()` �᷵�� nil���������� true��
]]
--- �����Ƿ�Ϊ��
--- @param t table ��Ҫ���ı�
--- @return boolean �����Ϊ�գ����� true�����򷵻� false
function table.isempty(t)
    return next(t) == nil
end

--��ѯ������
function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

function table.keys(hashtable)
    local keys = {}
    for k, v in pairs(hashtable) do
        keys[#keys + 1] = k
    end
    return keys
end
    
function table.values(hashtable)
    local values = {}
    for k, v in pairs(hashtable) do
        values[#values + 1] = v
    end
    return values
end

function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

--- ���ڶ������鸽�ӵ���һ�����鲢����һ��������
-- @param array1 table ��һ������
-- @param array2 table �ڶ�������
-- @return table ���Ӻ��������
function table.appendArray(array1, array2)
    local result = {}
    -- ����һ�������Ԫ�ظ��Ƶ��������
    for i = 1, #array1 do
        result[i] = array1[i]
    end
    -- ���ڶ��������Ԫ��׷�ӵ��������
    for i = 1, #array2 do
        result[#array1 + i] = array2[i]
    end
    return result
end


function table.insertto(dest, src, begin)
    begin = begin or 0
    if begin <= 0 then
        begin = #dest + 1
    end

    local len = #src
    for i = 0, len - 1 do
        dest[i + begin] = src[i + 1]
    end
end

function table.indexof(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then return i end
    end
    return false
end

function table.keyof(hashtable, value)
    for k, v in pairs(hashtable) do
        if v == value then return k end
    end
    return nil
end

function table.removebyvalue(array, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then break end
        end
        i = i + 1
    end
    return c
end

function table.map(t, fn)
    for k, v in pairs(t) do
        t[k] = fn(v, k)
    end
end

function table.walk(t, fn)
    for k,v in pairs(t) do
        fn(v, k)
    end
end

function table.filter(t, fn)
    for k, v in pairs(t) do
        if not fn(v, k) then t[k] = nil end
    end
end
--ɾ���ظ���ֵ
function table.unique(t, bArray)
    local check = {}
    local n = {}
    local idx = 1
    for k, v in pairs(t) do
        if not check[v] then
            if bArray then
                n[idx] = v
                idx = idx + 1
            else
                n[k] = v
            end
            check[v] = true
        end
    end
    return n
end

--ɾ���ظ�������
function table.uniqueArray(t)
    if not t or #t == 0 then
        return
    end
    local seen = {}
    local len = #t
    local idx = 1

    for i = 1, len do
        local v = t[i]
        if not seen[v] then
            seen[v] = true
            t[idx] = v
            idx = idx + 1
        end
    end

    -- ��������Ԫ��
    for i = idx, len do
        t[i] = nil
    end
end

function table.findtbykv(t, key, value)
    for _,v in pairs(t) do
        if v[key] == value then
            return v
        end
    end
end

function table.findarrvalue(t, fn, reverse)
    local size = #t
    local begin = reverse and size or 1
    local toend = reverse and 1 or size
    local change = reverse and -1 or 1

    local result
    for i=begin,toend,change do
        result = fn(t[i], i)
        if result then return result end
    end
end

function table.arrequal(arr1, arr2)
    local size1, size2 = #arr1, #arr2
    if size1 ~= size2 then return false end

    for k,v1 in ipairs(arr1) do
        local v2 = arr2[k]
        if v1 ~= v2 then return false end
    end

    return true
end

--���������Ƿ����ĳ��Ԫ��
---* array��Ҫ���ҵ�����
---* element��Ҫ���ҵ�Ԫ��
function table.contains(array, element)
    for _, value in ipairs(array) do
        if value == element then
            return true
        end
    end
    return false
end


--[[
    ������: table.random
    ����: ���������������һ��Ԫ�ء�
    ����:
      - t (table): Ҫѡ������顣
    ����:
      - (any): ���ѡ�е�Ԫ�ء�
    ˵��:
      - �������Ϊ�գ����� `nil`��
]]
--- ���������������һ��Ԫ��
--- @param t table Ҫѡ�������
--- @return any �������ѡ�е�Ԫ��
function table.random(t)
    if #t == 0 then return nil end
    local index = math.random(1, #t)
    return t[index]
end

--- ϴ���㷨����������˳��
---@param array table ��Ҫ���ҵ�����
function table.shuffle(array)
    local n = #array
    for i = n, 2, -1 do
        local j = math.random(1, i)
        array[i], array[j] = array[j], array[i]
    end
end