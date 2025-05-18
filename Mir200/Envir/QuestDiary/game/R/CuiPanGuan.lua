local CuiPanGuan = {}
CuiPanGuan.ID = "崔判官"
local npcID = 452
local config = include("QuestDiary/cfgcsv/cfg_CuiPanGuan.lua") --配置
local config2 = include("QuestDiary/cfgcsv/cfg_CuiPanGuan_config.lua") --配置
local cost = {{"灵符",200}}
local give = {{}}
local function generateString(config, excludeLast)
    local result = {}
    
    -- 遍历数组 config
    for i = 1, #config do
        -- 如果 excludeLast 为 true，并且当前元素是最后一个，则跳过
        if i ~= #config or not excludeLast then
            -- 生成 索引#weight 字符串
            table.insert(result, i .. "#" .. config[i].weight)
        end
    end
    
    -- 将结果连接为一个字符串
    return table.concat(result, "|")
end
--随机抽出来两个数组
local function getTwoUniqueElements(arr)
    if #arr < 2 then
        return
    end

    -- 随机获取第一个索引
    local index1 = math.random(1, #arr)

    -- 随机获取第二个索引，确保不与第一个重复
    local index2
    repeat
        index2 = math.random(1, #arr)
    until index2 ~= index1

    -- 返回对应的两个不重复的元素
    return arr[index1], arr[index2]
end

--接收请求
function CuiPanGuan.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if not checkitemw(actor,"生死簿",1) then
        Player.sendmsgEx(actor, "你身上没有穿戴装备:|生死簿#249|无法更改命格!")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "崔判官剧情")
    --获取帝品数量
    local diNum = TianMing.GetTianMingNum(actor, 5)
    local weightString = generateString(config2, diNum >= 10)
    local result = ransjstr(weightString, 1, 3)
    local cfg2 = config2[tonumber(result)]
    local attrs1, attrs2 = getTwoUniqueElements(config)
    local shuxing = {}
    --赋值第一个属性ID和属性
    if attrs1 then
        for _, value in ipairs(attrs1.attrs) do
            if value == 75 then
                shuxing[value] = tonumber(cfg2.attrValue1) * 100
            else
                shuxing[value] = tonumber(cfg2.attrValue1)
            end
        end
    end
    --赋值第二个属性ID和属性
    if attrs2 then
        for _, value in ipairs(attrs2.attrs) do
            if value == 75 then
                shuxing[value] = tonumber(cfg2.attrValue2) * 100
            else
                shuxing[value] = tonumber(cfg2.attrValue2)
            end
        end
    end
    --给属性到buff
    if hasbuff(actor,31031) then
        FkfDelBuff(actor,31031)
    end
    addbuff(actor, 31031, 0, 1, actor, shuxing)

    --创建一个新的表同步数据
    local newTable = {}
    if attrs1 and attrs2 then
        newTable = {
            tonumber(result),
            attrs1.idx,
            attrs2.idx,
        }
    end
    Player.setJsonVarByTable(actor,VarCfg["T_记录判官改名"],newTable)
    local num = getplaydef(actor, VarCfg["U_判官改名次数"])
    if num < 3 then
        setplaydef(actor, VarCfg["U_判官改名次数"], num + 1)
        if num + 1 == 1 then
            local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
            if taskPanelID == 36 then
                FCheckTaskRedPoint(actor)
            end
        end
    end
    CuiPanGuan.SyncResponse(actor)
end
--同步消息
function CuiPanGuan.SyncResponse(actor, logindatas)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_记录判官改名"])
    local _login_data = {ssrNetMsgCfg.CuiPanGuan_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.CuiPanGuan_SyncResponse, 0, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    CuiPanGuan.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, CuiPanGuan)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.CuiPanGuan, CuiPanGuan)
return CuiPanGuan