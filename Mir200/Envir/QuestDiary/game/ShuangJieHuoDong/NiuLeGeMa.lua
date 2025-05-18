local NiuLeGeMa = {}
local give = { { "圣诞花环", 50 }, { "圣诞饼干", 7 } }
--下面排
NiuLeGeMa.randomBlocks = { 14, 14 }
-- NiuLeGeMa.randomBlocks = { 2, 2 }

local function decrypt(hexstr, key)
    local klen = #key
    local idx = 1
    local bytes = {}
    for i = 1, #hexstr, 2 do
        local c = tonumber(hexstr:sub(i, i + 1), 16) -- 转成0~255
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

--打乱数组
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
-----------网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.NiuLeGeMa, NiuLeGeMa)

function NiuLeGeMa.Request(actor, arg1, arg2, arg3, data)
    --合成数量默认3
    local composeNum = 3
    --块的类型数量
    local typeNum = 12

    --层数
    local levelNum = 7
    -- local levelNum = 1
    --每层数量
    -- local levelBlockNum = 1
    local levelBlockNum = 40

    local blockNumUnit = composeNum * typeNum

    --放到下面的总块数
    local totalRandomBlockNum = 0
    for _, v in ipairs(NiuLeGeMa.randomBlocks) do
        totalRandomBlockNum = totalRandomBlockNum + v
    end
    --需要的最小块数
    local minBlockNum = levelNum * levelBlockNum + totalRandomBlockNum;

    local totalBlockNum = minBlockNum
    if totalBlockNum % blockNumUnit ~= 0 then
        totalBlockNum = math.floor(minBlockNum / blockNumUnit + 1) * blockNumUnit
    end
    ----全部块
    local totalBlockNum = totalBlockNum
    ----生成块数据
    local gameData = {}
    for i = 1, totalBlockNum do
        table.insert(gameData, (i - 1) % typeNum + 1)
    end
    --打乱数组
    gameData = shuffleArray(gameData)

    --初始化
    local allBlocks = {}
    for i = 1, totalBlockNum do
        local newBlock = {
            id = i - 1, --ID
            -- status = 0, --状态
            -- level = 0, --层级
            type = gameData[i], --类型
            -- H = {}, --上面的块
            -- L = {} --下面的块
        }
        table.insert(allBlocks, newBlock)
    end

    local pos = 1
    --放到下面的块，1左 2右
    local randomBlocks = {}
    for idx, randomBlock in ipairs(NiuLeGeMa.randomBlocks) do
        randomBlocks[idx] = {}
        for i = 1, randomBlock do
            table.insert(randomBlocks[idx], allBlocks[pos])
            pos = pos + 1
        end
    end
    local surplusBlockNum = totalBlockNum - totalRandomBlockNum
    --计算有层级关系的块
    local levelBlocks = {}
    local minX, maxX, minY, maxY = 1, 24, 1, 18
    --根据设定的层数和每层的块数，计算每层的块
    for i = 1, levelNum do
        --选出一个最小的数，用来划分每层数量
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
        --计算位置
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
        -- 在这里发送 chunkData 给客户端
    end
    setplaydef(actor, "N$牛了个马开始时间", os.time())
end

local cost = { { "元宝", 200000 } }
function NiuLeGeMa.RequestDoShuffle(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "打乱顺序", 1, true)
    Message.sendmsg(actor, ssrNetMsgCfg.NiuLeGeMa_ResponseDoShuffle)
end

function NiuLeGeMa.RequestFinish(actor, arg1, arg2, arg3, data)
    local startTime = getplaydef(actor, "N$牛了个马开始时间")
    if startTime == 0 then
        Player.sendmsgEx(actor, "开始时间错误！#249")
        return
    end
    local endTime = os.time()
    local time = endTime - startTime
    if time < 60 then
        Player.sendmsgEx(actor, "error0#249")
        return
    end
    Player.sendmsgEx(actor, "恭喜你通关了！")
    local isFinish = getplaydef(actor, VarCfg["J_牛了个马是否完成"])
    if isFinish == 0 then
        Player.sendmsgEx(actor, "恭喜你今日首次完成牛了个马，奖励已发送到邮件！")
        setplaydef(actor, VarCfg["J_牛了个马是否完成"], 1)
        local uid = Player.GetUUID(actor)
        Player.giveMailByTable(uid, 1, "牛了马首次完成奖励", "请领取您的牛了马首次完成奖励", give, 1, true)
    end
    local ranks = Player.getJsonTableByVar(nil, VarCfg["A_牛了个马排行榜"])
    local name = Player.GetName(actor)
    local lastTime = ranks[name] or 999999999999
    if data[1] < lastTime then
        Player.sendmsgEx(actor, "恭喜你刷新了排行榜！")
        ranks[name] = data[1]
    end
    Player.setJsonVarByTable(nil, VarCfg["A_牛了个马排行榜"], ranks)
end

return NiuLeGeMa
