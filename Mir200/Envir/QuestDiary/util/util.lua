--[[
���߿�
]]
--�жϳɹ���:����ɹ�����false
--suc_rate:�ɹ���
--ratio:����
--return:����trueû�ɹ�
function FProbabilityHit(suc_rate, ratio)
    ratio = ratio or 100
    local rate = math.random(1, ratio)
    return rate > suc_rate
end

--���һ������ķ�Χ
function UCheckRange(x, y, range, obj)
    local min_x, max_x = x - range, x + range
    local min_y, max_y = y - range, y + range
    local cur_x, cur_y = getbaseinfo(obj, ConstCfg.gbase.x), getbaseinfo(obj, ConstCfg.gbase.y)

    if (cur_x >= min_x) and (cur_x <= max_x) and
        (cur_y >= min_y) and (cur_y <= max_y) then
        return true
    end

    return false
end

--����Լ���npc�ľ���
function UCheckNPCRange(actor, moduleid, npcidx, range)
    range = range or 10
    local npcobj = getnpcbyindex(npcidx)
    local npc_mapid = getbaseinfo(npcobj, ConstCfg.gbase.mapid)
    local my_mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    if npc_mapid ~= my_mapid then return false end

    local npc_x = getbaseinfo(npcobj, ConstCfg.gbase.x)
    local npc_y = getbaseinfo(npcobj, ConstCfg.gbase.y)
    return UCheckRange(npc_x, npc_y, range, actor)
end

--�س�
function FBackZone(actor)
    local taskID = getplaydef(actor, VarCfg["U_�����������"])
    if taskID < 7 then
        mapmove(actor, "��Դ��", 113, 249, 2)
        return
    end
    mapmove(actor, "n3", 330, 330, 5)
end

--�ɵ�ͼ�̶������
function FMapMove(actor, mapid, x, y, x_ran, y_ran)
    if type(mapid) ~= "string" then mapid = mapid .. "" end
    if x and y then
        if x_ran then x = math.random(x - x_ran, x + x_ran) end
        if y_ran then y = math.random(y - y_ran, y + y_ran) end
        mapmove(actor, mapid, x, y)
    else
        map(actor, mapid)
    end
end

--����ȫ��������������
--Ĭ�ϵ�ɫ��ɫ
function FSendMsgNew(actor, msg)
    sendmsgnew(actor, 250, 0, msg, 1, 3)
end

--�����ʼ�
function FSendmail(sender, id, ...)
    local cfg = cfg_mail[id]
    if not cfg then return end

    --�ʼ�����
    local content
    if cfg.content then
        if cfg.parameter then
            content = string.format(cfg.content, ...)
        else
            content = cfg.content
        end
    end

    --�ʼ���Ʒ
    local stritem
    if cfg.items then
        if type(cfg.items) == "table" then
            local items
            for _, item in ipairs(cfg.items) do
                if type(item) == "table" then
                    items = items or {}
                    if item[3] == 1 then item[3] = ConstCfg.binding end
                    table.insert(items, table.concat(item, "#"))
                else
                    stritem = table.concat(cfg.items, "&")
                    break
                end
            end

            if items then stritem = table.concat(items, "&") end
        else
            stritem = cfg.items .. "#1"
        end
    end
    --����
    sendmail(sender, 1, cfg.title, content, stritem)
end

--�����ʼ�2
function _Fsendmail(name, id, reward, ...)
    local cfg = cfg_mail[id]
    if not cfg then return end
    --�ʼ�����
    local content
    if cfg.content then
        if cfg.parameter then
            content = string.format(cfg.content, ...)
        else
            content = cfg.content
        end
    end
    local stritem
    --�ʼ���Ʒ
    if reward then
        if type(reward) == "table" then
            local items
            for _, item in ipairs(reward) do
                if type(item) == "table" then
                    items = items or {}
                    if item[3] == 1 then item[3] = ConstCfg.binding end
                    table.insert(items, table.concat(item, "#"))
                else
                    stritem = table.concat(reward, "&")
                    break
                end
            end

            if items then stritem = table.concat(items, "&") end
        else
            stritem = reward .. "#1"
        end
    end
    sendmail("#" .. name, 1, cfg.title, content, stritem)
end

--���
---* object����������
function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function getRanomByWeight(t, weights)
    local sum = 0
    for i = 1, #weights do
        sum = sum + weights[i]
    end
    local compareWeight = math.random(1, sum)
    local weightIndex = 1
    while sum > 0 do
        sum = sum - weights[weightIndex]
        if sum < compareWeight then
            return t[weightIndex]
        end
        weightIndex = weightIndex + 1
    end
    return weightIndex
end

--��תʱ����  100 = 00:01:40
function ssrSecToHMS(sec)
    sec = sec or 0

    local h, m, s = 0, 0, 0
    if sec > 3600 then
        h = math.floor(sec / 3600)
    end
    sec = sec % 3600
    if sec > 60 then
        m = math.floor(sec / 60)
    end
    s = sec % 60

    return string.format("%02d:%02d:%02d", h, m, s)
end

--ʱ��ת��
function getTodayTimeStamp(hour, min, sec)
    local cDateCurrectTime = os.date("*t")
    local cDateTodayTime = os.time({ year = cDateCurrectTime.year, month = cDateCurrectTime.month, day = cDateCurrectTime
    .day, hour = hour, min = min, sec = sec })
    return cDateTodayTime
end

--��996��ֵ�Ը�ʽת����table
function parseStringToTable(str)
    local t = {}
    for key, value in string.gmatch(str, "([^,=]+)=([^,=]+)") do
        t[key] = value
    end
    return t
end

--�򿪳�ֵ���
function openrecharge(actor)
    openhyperlink(actor, 26)
end

--λ������
function BitAND(a, b)
    local p, c = 1, 0
    while a > 0 and b > 0 do
        local ra, rb = a % 2, b % 2
        if ra + rb > 1 then c = c + p end
        a, b, p = (a - ra) / 2, (b - rb) / 2, p * 2
    end
    return c
end

--ʹ���ַ����Ƚ�
function compareValues(value1, operator, value2)
    if operator == ">" then
        return value1 > value2
    elseif operator == "<" then
        return value1 < value2
    elseif operator == ">=" then
        return value1 >= value2
    elseif operator == "<=" then
        return value1 <= value2
    elseif operator == "==" then
        return value1 == value2
    elseif operator == "~=" then
        return value1 ~= value2
    else
        return false
    end
end

function dump(t)
    release_print(tbl2json(t))
end

--����Ʒ����ת���ɷ����ʼ��ĸ�ʽ
---imemTable:��Ʒ����
---@return string
function itemToMailStr(itemTable)
    if type(itemTable) ~= "table" then
        return
    end
    local itemList = {}
    for index, value in ipairs(itemTable) do
        if type(value) ~= "table" then
            return
        end
        table.insert(itemList, table.concat(value, "#"))
    end
    local str = table.concat(itemList, "&")
    return str
end

--�ж϶�����ĳ��ʱ��֮�䣬֧�ֿ���ҹ
---* startHour: ��ʼСʱ
---* startMinute: ��ʼ����
---* endHour: ����Сʱ
---* endMinute: ��������
function isTimeInRange(startHour, startMinute, endHour, endMinute)
    local now = os.date("*t") -- ��ȡ��ǰʱ��ı����ʽ
    local startTime = os.time({ year = now.year, month = now.month, day = now.day, hour = startHour, min = startMinute })
    local endTime = os.time({ year = now.year, month = now.month, day = now.day, hour = endHour, min = endMinute })
    local currentTime = os.time(now)

    -- �������ʱ��С�ڿ�ʼʱ�䣬��˵����Խ����ҹ
    if endTime < startTime then
        endTime = os.time({ year = now.year, month = now.month, day = now.day + 1, hour = endHour, min = endMinute })
    end

    return currentTime >= startTime and currentTime <= endTime
end


--��ȡ���賿������
function GetReaminSecondsTo24()
	local toYear=os.date("*t").year
	local toMonth=os.date("*t").month
	local toDay=os.date("*t").day
	local toTime = os.time({year =toYear, month = toMonth, day =toDay, hour =23, min =59, sec = 59})
	local time=os.time()
	return toTime-time+1
end

-- ��ȡ�� 21:00 ��ʣ��������������� 21:00 ���� 0
function GetSecondsUntil21()
    local current_time = os.time()
    -- ��ȡ���� 21:00 ��ʱ���
    local current_date = os.date("*t", current_time)
    current_date.hour = 21
    current_date.min = 0
    current_date.sec = 0
    local target_time = os.time(current_date)
    local remaining_seconds = target_time - current_time
    if remaining_seconds < 0 then
        remaining_seconds = 0
    end
    return remaining_seconds
end

--�ɹ���
---successRate���ɹ��ʣ����ӣ�
---range����Χ(��ĸ)
function randomex(successRate, range)
    range = range or 100
    local randomNumber = math.random(1, range)
    if randomNumber <= successRate then
        return true
    else
        return false
    end
end

--����ٷֱȾ�����ֵ
function calculatePercentageResult(total, num)
    if total == 0 then
        return 0
    end
    local value = (num / 100) * total
    return math.floor(value + 0.5) -- ��������
end

--����ٷֱ�ֵ
---* numerator������
---* denominator����ĸ
function calculatePercentage(numerator, denominator)
    if denominator == 0 then
        return 0
    end
    local percentage = (numerator / denominator) * 100
    return percentage
end

--��һ�����ֲ��Ϊ�������
---* limit���������
---* num���������
--- @param limit integer
--- @param num integer
--- @return any
function splitLargeNumber(limit, num)
    if limit == nil or num == nil or limit == 0 or num == 0 then
        return
    end
    local parts = {}
    while num > limit do
        table.insert(parts, limit)
        num = num - limit
    end
    if num > 0 then
        table.insert(parts, num)
    end
    return parts
end

--�Ѽ�ֵ��ƴ�ӳ��ַ���
function concatenateKeyValuePairs(tbl)
    local result = {}
    for key, value in pairs(tbl) do
        table.insert(result, key .. "=" .. tostring(value))
    end
    return table.concat(result, ", ")
end

--�����ۼ�����
function calcAtts(attrs, currAttrs, desc)
    -- release_print(desc,concatenateKeyValuePairs(currAttrs))
    for key, value in pairs(currAttrs) do
        if attrs[key] then
            attrs[key] = attrs[key] + value
        else
            attrs[key] = value
        end
    end
end

--���Ժϲ�
function attsMerge(currAtt,attrs)
    for index, value in pairs(currAtt) do
        if not attrs[index] then
            attrs[index] = value
        else
            attrs[index] = attrs[index] + value
        end
    end
end

--������������С��ֵ
function findMinValue(array)
    if #array == 0 then
        return nil
    end
    return math.min(unpack(array))
end

-- �жϵ�ǰʱ���Ƿ���ָ��ʱ�����
---* sethour_1����ʼСʱ
---* setmin_1����ʼ����
---* sethour_2������Сʱ
---* setmin_2����������(���ô���59��)
function checktimeInPeriod(sethour_1, setmin_1, sethour_2, setmin_2)
    local current_time = os.date("*t") -- ��ȡ��ǰʱ��
    local hour = current_time.hour     -- ��ǰСʱ
    local min = current_time.min       -- ��ǰ����
    -- �жϵ�ǰʱ���Ƿ���ָ����Χ��
    if (hour > sethour_1) or (hour == sethour_1 and min >= setmin_1) or (hour < sethour_2) or (hour == sethour_2 and min < setmin_2) then
        return true
    else
        return false
    end
end

--����һ���ų���������������
---* exclude:�ų�������
---* upperNum:�ų�������������
---@param exclude table
---@param upperNum number
---@return number|boolean
function generateRandomExclude(exclude, upperNum)
    if #exclude >= upperNum then
        return false
    end
    local randomNum
    local found
    repeat
        randomNum = math.random(upperNum)
        found = false
        for _, v in ipairs(exclude) do
            if v == randomNum then
                found = true
                break
            end
        end
    until not found
    return randomNum
end


-- ���ڼ��� GBK �ַ������ַ�����
function GbkLength(str)
    local len = 0
    local i = 1

    while i <= #str do
        local charByte = string.byte(str, i)

        if charByte > 0 and charByte <= 127 then
            -- ���ֽ��ַ���ASCII �ַ���
            i = i + 1
        else
            -- ˫�ֽ��ַ���GBK ���֣�
            i = i + 2
        end

        len = len + 1
    end

    return len
end


-- ����һ���������������ɸ������
function getRandomDifference(baseNumber)
    -- ���ø�����Χ
    local minRange = 0.9
    local maxRange = 1.2
    
    -- ���������
    local randomFactor = math.random() * (maxRange - minRange) + minRange
    
    -- ���㸡�����
    local result = baseNumber * randomFactor
    
    -- �����ֵ
    local difference = result - baseNumber
    
    -- �������븡������Ͳ�ֵΪ����
    local roundedResult = math.floor(result + 0.5)
    local roundedDifference = math.floor(difference + 0.5)
    
    return roundedResult, roundedDifference
end
--��Ʒ����ת����Ʒ*�����ַ�
function getItemArrToStr(items)
    local itemStrArray = {}
    for _, value in ipairs(items) do
        local tmpStr = table.concat(value, "*")
        table.insert(itemStrArray, tmpStr)
    end
    local msgStr = table.concat(itemStrArray, ",")
    return msgStr
end
--Lua ���ֻ�����������
function formatNumberToChinese(num)
    local chineseNum = {"��", "һ", "��", "��", "��", "��", "��", "��", "��", "��"}
    local units = {"", "ʮ", "��", "ǧ", "��"}

    if num == 0 then
        return chineseNum[1]
    end

    local numStr = tostring(num)
    local numLen = #numStr
    local result = {}
    local lastDigitZero = false

    for i = 1, numLen do
        local digit = tonumber(string.sub(numStr, i, i))
        local unitIndex = numLen - i + 1
        local unit = units[unitIndex]

        if digit ~= 0 then
            if lastDigitZero then
                table.insert(result, chineseNum[1])  -- ��ӡ��㡱
                lastDigitZero = false
            end
            table.insert(result, chineseNum[digit + 1])  -- �������
            if unit ~= "" then
                table.insert(result, unit)  -- ��ӵ�λ
            end
        else
            lastDigitZero = true
        end
    end

    -- �Ƴ����ĩβ�ġ��㡱
    if result[#result] == chineseNum[1] then
        table.remove(result)
    end

    -- ��������������������"һʮ"��ͷʱ��ȥ��ǰ���"һ"
    if result[1] == "һ" and result[2] == "ʮ" then
        table.remove(result, 1)
    end

    local resultStr = table.concat(result)

    return resultStr
end


-- ���㵱��ʣ�������ĺ���
function getSecondsLeftInDay()
    -- ��ȡ��ǰʱ���
    local current_time = os.time()

    -- ��ȡ��ǰ���ڵ���Ϣ
    local date_info = os.date("*t")

    -- ���쵱����ҹ 00:00:00 ��ʱ���
    local midnight_today = os.time({
        year = date_info.year,
        month = date_info.month,
        day = date_info.day,
        hour = 0,
        min = 0,
        sec = 0
    })

    -- ����ڶ�����ҹ 00:00:00 ��ʱ���
    local midnight_tomorrow = midnight_today + 24 * 60 * 60

    -- ���㵱��ʣ�������
    local seconds_left = midnight_tomorrow - current_time

    return seconds_left
end


function GetCurrentDateAsNumber()
    return tonumber(os.date("%Y%m%d"))
end

--��������
function numberRound(num)
    local decimal = num % 1 -- ��ȡС������
    if decimal >= 0.5 then
        return math.ceil(num)
    else
        return math.floor(num)
    end
end

--����������
function getDaysDiff(startDate, endDate)
    local sy = math.floor(startDate / 10000)
    local sm = math.floor((startDate % 10000) / 100)
    local sd = startDate % 100
    local ey = math.floor(endDate / 10000)
    local em = math.floor((endDate % 10000) / 100)
    local ed = endDate % 100
    local startTime = os.time({year = sy, month = sm, day = sd})
    local endTime = os.time({year = ey, month = em, day = ed})
    return math.floor((endTime - startTime) / (24 * 60 * 60))
end