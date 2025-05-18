local NiuLeGeMa = {}
local give = { { "ʥ������", 50 }, { "ʥ������", 7 } }
--������
NiuLeGeMa.randomBlocks = { 14, 14 }
-- NiuLeGeMa.randomBlocks = { 2, 2 }

local function decrypt(hexstr, key)
    local klen = #key
    local idx = 1
    local bytes = {}
    for i = 1, #hexstr, 2 do
        local c = tonumber(hexstr:sub(i, i + 1), 16) -- ת��0~255
        local k = key:byte(((idx - 1) % klen) + 1)
        local d = bit.bxor(c, k)
        table.insert(bytes, d)
        idx = idx + 1
    end
    local decryptedStr = string.char(unpack(bytes))
    local magicPrefix = "flag|"
    if decryptedStr:sub(1, #magicPrefix) ~= magicPrefix then
        return nil
    end
    return decryptedStr:sub(#magicPrefix + 1)
end

--��������
local function shuffleArray(array)
    for i = #array, 2, -1 do
        local j = math.random(i)
        array[i], array[j] = array[j], array[i]
    end
    return array
end

local function genLevelBlockPos(blocks, minX, minY, maxX, maxY)
    local currentPosSet = {}
    for _, block in ipairs(blocks) do
        local newPosX, newPosY, key
        repeat
            newPosX = math.random(minX, maxX)
            newPosY = math.random(minY, maxY)
            key = newPosX .. "," .. newPosY
        until not currentPosSet[key]
        currentPosSet[key] = true
        block.x = newPosX
        block.y = newPosY
    end
end
-----------������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.NiuLeGeMa, NiuLeGeMa)

function NiuLeGeMa.Request(actor, arg1, arg2, arg3, data)
    --�ϳ�����Ĭ��3
    local composeNum = 3
    --�����������
    local typeNum = 12

    --����
    local levelNum = 7
    -- local levelNum = 1
    --ÿ������
    -- local levelBlockNum = 1
    local levelBlockNum = 40

    local blockNumUnit = composeNum * typeNum

    --�ŵ�������ܿ���
    local totalRandomBlockNum = 0
    for _, v in ipairs(NiuLeGeMa.randomBlocks) do
        totalRandomBlockNum = totalRandomBlockNum + v
    end
    --��Ҫ����С����
    local minBlockNum = levelNum * levelBlockNum + totalRandomBlockNum;

    local totalBlockNum = minBlockNum
    if totalBlockNum % blockNumUnit ~= 0 then
        totalBlockNum = math.floor(minBlockNum / blockNumUnit + 1) * blockNumUnit
    end
    ----ȫ����
    local totalBlockNum = totalBlockNum
    ----���ɿ�����
    local gameData = {}
    for i = 1, totalBlockNum do
        table.insert(gameData, (i - 1) % typeNum + 1)
    end
    --��������
    gameData = shuffleArray(gameData)

    --��ʼ��
    local allBlocks = {}
    for i = 1, totalBlockNum do
        local newBlock = {
            id = i - 1, --ID
            -- status = 0, --״̬
            -- level = 0, --�㼶
            type = gameData[i], --����
            -- H = {}, --����Ŀ�
            -- L = {} --����Ŀ�
        }
        table.insert(allBlocks, newBlock)
    end

    local pos = 1
    --�ŵ�����Ŀ飬1�� 2��
    local randomBlocks = {}
    for idx, randomBlock in ipairs(NiuLeGeMa.randomBlocks) do
        randomBlocks[idx] = {}
        for i = 1, randomBlock do
            table.insert(randomBlocks[idx], allBlocks[pos])
            pos = pos + 1
        end
    end
    local surplusBlockNum = totalBlockNum - totalRandomBlockNum
    --�����в㼶��ϵ�Ŀ�
    local levelBlocks = {}
    local minX, maxX, minY, maxY = 1, 24, 1, 18
    --�����趨�Ĳ�����ÿ��Ŀ���������ÿ��Ŀ�
    for i = 1, levelNum do
        --ѡ��һ����С��������������ÿ������
        local nextBlockNum = math.min(levelBlockNum, surplusBlockNum)
        if i == levelNum then
            nextBlockNum = surplusBlockNum
        end
        local nextGenBlocks = {}
        for j = pos, pos + nextBlockNum - 1 do
            table.insert(nextGenBlocks, allBlocks[j])
        end
        pos = pos + nextBlockNum
        for k = 1, #nextGenBlocks do
            levelBlocks[#levelBlocks + 1] = nextGenBlocks[k]
        end
        --����λ��
        genLevelBlockPos(nextGenBlocks, minX, minY, maxX, maxY)
        surplusBlockNum = surplusBlockNum - nextBlockNum
        if surplusBlockNum <= 0 then
            break
        end
    end

    local data = {
        levelBlocks = levelBlocks,
        randomBlocks = randomBlocks
    }
    -- local filepath = "levelBlocks.txt"
    -- local f = io.open(filepath, "a")
    -- if f then
    --     f:write(tbl2json(data).."\n")
    --     f:close()
    -- end
    local strdata = tbl2json(data)
    local chunkSize = 7000
    local chunks = math.ceil(#strdata / chunkSize)
    local isLong = 0
    if chunks > 1 then
        isLong = 1
    end
    for i = 1, chunks do
        local startIdx = (i - 1) * chunkSize + 1
        local endIdx = math.min(i * chunkSize, #strdata)
        local chunkData = strdata:sub(startIdx, endIdx)
        Message.sendmsg(actor, ssrNetMsgCfg.NiuLeGeMa_Response, totalBlockNum, isLong, 0, { chunkData })
        -- �����﷢�� chunkData ���ͻ���
    end
    setplaydef(actor, "N$ţ�˸���ʼʱ��", os.time())
end

local cost = { { "Ԫ��", 200000 } }
function NiuLeGeMa.RequestDoShuffle(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "����˳��", 1, true)
    Message.sendmsg(actor, ssrNetMsgCfg.NiuLeGeMa_ResponseDoShuffle)
end

function NiuLeGeMa.RequestFinish(actor, arg1, arg2, arg3, data)
    local startTime = getplaydef(actor, "N$ţ�˸���ʼʱ��")
    if startTime == 0 then
        Player.sendmsgEx(actor, "��ʼʱ�����#249")
        return
    end
    local endTime = os.time()
    local time = endTime - startTime
    if time < 60 then
        Player.sendmsgEx(actor, "error0#249")
        return
    end
    Player.sendmsgEx(actor, "��ϲ��ͨ���ˣ�")
    local isFinish = getplaydef(actor, VarCfg["J_ţ�˸����Ƿ����"])
    if isFinish == 0 then
        Player.sendmsgEx(actor, "��ϲ������״����ţ�˸��������ѷ��͵��ʼ���")
        setplaydef(actor, VarCfg["J_ţ�˸����Ƿ����"], 1)
        local uid = Player.GetUUID(actor)
        Player.giveMailByTable(uid, 1, "ţ�����״���ɽ���", "����ȡ����ţ�����״���ɽ���", give, 1, true)
    end
    local ranks = Player.getJsonTableByVar(nil, VarCfg["A_ţ�˸������а�"])
    local name = Player.GetName(actor)
    local lastTime = ranks[name] or 999999999999
    if data[1] < lastTime then
        Player.sendmsgEx(actor, "��ϲ��ˢ�������а�")
        ranks[name] = data[1]
    end
    Player.setJsonVarByTable(nil, VarCfg["A_ţ�˸������а�"], ranks)
end

return NiuLeGeMa
