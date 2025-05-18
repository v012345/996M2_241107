local ManHuangXueMai = {}
ManHuangXueMai.ID = "蛮荒血脉"
local npcID = 321
local config = include("QuestDiary/cfgcsv/cfg_ManHuangXueMai.lua") --配置
local cost1 = { { "幻灵水晶", 100 }, { "灵符", 100 } }
local cost2 = { { "蛮荒图腾", 66 }, { "金币", 18880000 } }
-- 封装一个函数，从1到数组长度之间随机生成一个索引，但排除指定的索引
local function randomIndexExclude(maxIndex, excludeIndex)
    local randomIdx = math.random(1, maxIndex)
    while randomIdx == excludeIndex do
        randomIdx = math.random(1, maxIndex)
    end
    return randomIdx
end
--随机给值
local function initializeAndIncrement(actor, exclude)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_蛮荒血脉洗练"])
    --初始化
    if #data == 0 then
        data = { 0, 0, 0, 0, 0, 0, 0, 0 }
    end
    local randomIndex
    if exclude == 0 or not exclude then
        randomIndex = math.random(1, #data)
        data[randomIndex] = data[randomIndex] + 1
        local cfg = config[randomIndex] or {}
        local name = cfg.name or ""
        Player.sendmsgEx(actor, string.format("觉醒成功|%s%s#249", name, "+1%"))
    else
        randomIndex = randomIndexExclude(#data, exclude)
        data[randomIndex] = data[randomIndex] + 1
        data[exclude] = data[exclude] - 1
        local cfg = config[randomIndex] or {}
        local name = cfg.name or ""
        local currCfg = config[exclude] or {}
        local currName = currCfg.name or ""
        Player.sendmsgEx(actor, string.format("洗练成功|%s%s#249|，|%s%s#249", name, "+1%",currName,"-1%"))
    end
    Player.setJsonVarByTable(actor, VarCfg["T_蛮荒血脉洗练"], data)
    Player.setAttList(actor, "属性附加")
end
--接收请求
function ManHuangXueMai.Request1(actor, arg1)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if arg1 > 8 or type(arg1) ~= "number" then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    if arg1 == 0 then
        Player.sendmsgEx(actor, "请勾选要洗练的属性!#249")
        return
    end
    local cfg = config[arg1] or {}
    if arg1 ~= 0 then
        local data = Player.getJsonTableByVar(actor, VarCfg["T_蛮荒血脉洗练"])
        if data[arg1] == 0 or not data[arg1] then
            local name = cfg.name or ""
            Player.sendmsgEx(actor,name .. "#249|属性为0,无法洗练!#250")
            return
        end
    end
    
    local name, num = Player.checkItemNumByTable(actor, cost1)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost1, "蛮荒血脉剧情")
    initializeAndIncrement(actor, arg1)
    ManHuangXueMai.SyncResponse(actor)
end

function ManHuangXueMai.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local count = getplaydef(actor, VarCfg["U_剧情_蛮荒血脉_觉醒次数"])
    if count >= 10 then
        Player.sendmsgEx(actor, "最多只能觉醒10次!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost2)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost2, "蛮荒血脉剧情")
    setplaydef(actor, VarCfg["U_剧情_蛮荒血脉_觉醒次数"], count + 1)
    if count + 1 == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 21 then
            FCheckTaskRedPoint(actor)
        end
    end
    --随机给
    initializeAndIncrement(actor)
    ManHuangXueMai.SyncResponse(actor)
end

--同步消息
function ManHuangXueMai.SyncResponse(actor, logindatas)
    local count = getplaydef(actor, VarCfg["U_剧情_蛮荒血脉_觉醒次数"])
    local data = Player.getJsonTableByVar(actor, VarCfg["T_蛮荒血脉洗练"])
    local _login_data = { ssrNetMsgCfg.ManHuangXueMai_SyncResponse, count, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ManHuangXueMai_SyncResponse, count, 0, 0, data)
    end
end

--附加属性
local function _onCalcAttr(actor, attrs)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_蛮荒血脉洗练"])
    if #data == 0 then
        return
    end
    local shuxing = {}
    for index, value in ipairs(config) do
        local attValue = 0
        if value.type == 2 then
            attValue = (data[index] or 0) * 100
        else
            attValue = data[index] or 0
        end
        shuxing[value.attrId] = attValue
    end
    calcAtts(attrs, shuxing, "剧情_蛮荒血脉")
end
--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, ManHuangXueMai)

--登录触发
local function _onLoginEnd(actor, logindatas)
    ManHuangXueMai.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ManHuangXueMai)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ManHuangXueMai, ManHuangXueMai)
return ManHuangXueMai
