ReliveMain = {}
local equaldata = include("QuestDiary/cfgcsv/cfg_FuHuoZhuangBei.lua")
--遍历删除队列
local function findPosition(tbl, key)
    for i, item in ipairs(tbl) do
        if item.value == equaldata[key].Priority then
            return i
        end
    end
    return nil -- 如果没有找到，返回 nil
end

--获取复活数据
function ReliveMain.GetReliveTable(actor)
    -- return Player.getJsonTableByVar(actor, VarCfg["T_复活状态"])
    return Player.getJsonTableByPlayVar(actor, "KFZF3")
end

--设置复活数据
function ReliveMain.SetReliveTable(actor, ReliveQueue)
    Player.setJsonVarByTable(actor, VarCfg["T_复活状态"], ReliveQueue)
    Player.setJsonPlayVarByTable(actor, "KFZF3", ReliveQueue)
end

-- 入队操作
local function AddQueue(actor, itemname)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    local state = findPosition(ReliveQueue, itemname)
    if state == nil then                                                                    -- 查重
        table.insert(ReliveQueue, { key = itemname, value = equaldata[itemname].Priority }) --插入数组
    end
    table.sort(ReliveQueue, function(a, b)
        return a.value < b.value
    end)
    ReliveMain.SetReliveTable(actor, ReliveQueue) --设置复活数据
    ReliveMain.SyncResponse(actor)
end

-- 出队操作
local function DelQueue(actor, ReliveQueue, num)
    if #ReliveQueue > 0 then                          --数组队列大于0
        table.remove(ReliveQueue, num)
        ReliveMain.SetReliveTable(actor, ReliveQueue) --设置复活数据
        -- ReliveMain.SyncResponse(actor)
    end
end
--------------------------------------------------------------衣服--------------------------------------------------------------
-- 衣服位置 --穿
local function _onTakeOn0(actor, itemobj)
    local ItemName = getiteminfo(actor, itemobj, 7)
    if equaldata[ItemName] then
        setplaydef(actor, VarCfg["U_复活队列1"], equaldata[ItemName].times)
        setontimer(actor, 101, 1, 0, 1) --添加101号定时器
        ReliveMain.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onTakeOn0, _onTakeOn0, ReliveMain)

-- 衣服位置 --脱
local function _onTakeOff0(actor, itemobj)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    local ItemName = getiteminfo(actor, itemobj, 7)
    if equaldata[ItemName] then
        local number = findPosition(ReliveQueue, ItemName)
        if number ~= nil then
            DelQueue(actor, ReliveQueue, number)
        end
        setofftimer(actor, 101) --关闭101定时器
        setplaydef(actor, VarCfg["U_复活队列1"], 0)
        ReliveMain.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onTakeOff0, _onTakeOff0, ReliveMain)

--------------------------------------------------------------龙之心--------------------------------------------------------------
--穿戴龙之心位置
local function _onTakeOn9(actor, itemobj)
    local ItemName = getiteminfo(actor, itemobj, 7)
    if equaldata[ItemName] then
        setplaydef(actor, VarCfg["U_复活队列2"], equaldata[ItemName].times)
        setontimer(actor, 102, 1, 0, 1) --添加102号定时器
        ReliveMain.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onTakeOn9, _onTakeOn9, ReliveMain)

-- 龙之心 --脱
local function _onTakeOff9(actor, itemobj)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    local ItemName = getiteminfo(actor, itemobj, 7)
    if equaldata[ItemName] then
        local number = findPosition(ReliveQueue, ItemName)
        if number ~= nil then
            DelQueue(actor, ReliveQueue, number)
        end
        setofftimer(actor, 102) --关闭102定时器
        setplaydef(actor, VarCfg["U_复活队列2"], 0)
        ReliveMain.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onTakeOff9, _onTakeOff9, ReliveMain)

--升级龙之心的时候 处理一次脱下操作
local function _LongZhiXinUp(actor, ItemName)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    if equaldata[ItemName] then
        local number = findPosition(ReliveQueue, ItemName)
        if number ~= nil then
            DelQueue(actor, ReliveQueue, number)
        end
        setofftimer(actor, 102) --关闭102定时器
        setplaydef(actor, VarCfg["U_复活队列2"], 0)
        ReliveMain.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.LongZhiXinUp, _LongZhiXinUp, ReliveMain)

--六道轮回盘
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "六道轮回盘" then
        if equaldata[itemname] then
            setplaydef(actor, VarCfg["U_复活队列3"], equaldata[itemname].times)
            setontimer(actor, 103, 1, 0, 1) --添加103号定时器
            ReliveMain.SyncResponse(actor)
        end
    end
end

GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ReliveMain)

--六道轮回盘
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "六道轮回盘" then
        local ReliveQueue = ReliveMain.GetReliveTable(actor)
        if equaldata[itemname] then
            local number = findPosition(ReliveQueue, itemname)
            if number ~= nil then
                DelQueue(actor, ReliveQueue, number)
            end
            setofftimer(actor, 103) --关闭103定时器
            setplaydef(actor, VarCfg["U_复活队列3"], 0)
            ReliveMain.SyncResponse(actor)
        end
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ReliveMain)


--定时器    101号
local function _ReliveCountdown_1(actor)
    local item_num = getplaydef(actor, VarCfg["U_复活队列1"])
    -- release_print("1号倒计时" .. item_num)
    if item_num > 0 then
        setplaydef(actor, VarCfg["U_复活队列1"], item_num - 1)
    elseif item_num == 0 then
        local ItemName = getconst(actor, "<$DRESS>")
        setofftimer(actor, 101) --关闭101定时器
        if equaldata[ItemName] then
            AddQueue(actor, ItemName)
        end
    end
end
GameEvent.add(EventCfg.ReliveCountdown_1, _ReliveCountdown_1, ReliveMain)


--定时器    102号
local function _ReliveCountdown_2(actor)
    local item_num = getplaydef(actor, VarCfg["U_复活队列2"])
    -- release_print("跨服2号倒计时" .. item_num)
    if item_num > 0 then
        setplaydef(actor, VarCfg["U_复活队列2"], item_num - 1)
    elseif item_num == 0 then
        local ItemName = getconst(actor, "<$BUJUK>")
        setofftimer(actor, 102) --关闭102定时器
        if equaldata[ItemName] then
            AddQueue(actor, ItemName)
        end
    end
end
GameEvent.add(EventCfg.ReliveCountdown_2, _ReliveCountdown_2, ReliveMain)

--定时器    103号
local function _ReliveCountdown_3(actor)
    local item_num = getplaydef(actor, VarCfg["U_复活队列3"])
    -- release_print("跨服3号倒计时" .. item_num)
    if item_num > 0 then
        setplaydef(actor, VarCfg["U_复活队列3"], item_num - 1)
    elseif item_num == 0 then
        local ItemName = "六道轮回盘"
        if checkitemw(actor, ItemName, 1) then
            setofftimer(actor, 103) --关闭103定时器
            if equaldata[ItemName] then
                AddQueue(actor, ItemName)
            end
        end
    end
end
GameEvent.add(EventCfg.ReliveCountdown_3, _ReliveCountdown_3, ReliveMain)



-- 死亡前触发
local function _onNextDie(actor, hiter, isplay)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    if ReliveQueue[1] ~= nil then --可复活队列不为空
        setplaydef(actor, VarCfg.Die_Flag, 1)
        setplaydef(actor, VarCfg["N$是否被破复活"], 1)
        changemode(actor, 23, 1, 1, 1) --添加复活状态
        if checkitemw(actor, ReliveQueue[1].key, 1) then
            if equaldata[ReliveQueue[1].key] then
                setplaydef(actor, VarCfg["U_复活队列" .. equaldata[ReliveQueue[1].key].Priority .. ""],
                    equaldata[ReliveQueue[1].key].times)
                setontimer(actor, "10" .. equaldata[ReliveQueue[1].key].Priority, 1, 0, 1) --添加10X号定时器
            end
        end
        -- release_print("出队装备-------" .. ReliveQueue[1].key)
        DelQueue(actor, ReliveQueue, 1) --执行出队操作
        ReliveMain.SyncResponse(actor)
    else
        --没有复活
        setplaydef(actor, VarCfg.Die_Flag, 1)
        setplaydef(actor, VarCfg["N$是否被破复活"], 0)
    end
end
GameEvent.add(EventCfg.onNextDie, _onNextDie, ReliveMain)

--破复活
function ReliveMain.DelRelive(actor, target)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    if ReliveQueue[1] ~= nil then --可复活队列不为空
        if checkitemw(actor, ReliveQueue[1].key, 1) then
            if equaldata[ReliveQueue[1].key] then
                setplaydef(actor, VarCfg["U_复活队列" .. equaldata[ReliveQueue[1].key].Priority .. ""],
                    equaldata[ReliveQueue[1].key].times)
                setontimer(actor, "10" .. equaldata[ReliveQueue[1].key].Priority, 1, 0, 1) --添加10X号定时器
            end
        end
        DelQueue(actor, ReliveQueue, 1) --执行出队操作
        ReliveMain.SyncResponse(actor)
    end
end

--获取当前复活是否可复活
function ReliveMain.GetReliveState(actor)
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    if ReliveQueue[1] ~= nil then
        return true
    else
        return false
    end
end

--查找最小的复活CD
local function findMinCd(equipments)
    local min_cd = nil
    -- 遍历所有装备
    for _, equipment in ipairs(equipments) do
        local name = ""
        if equipment.name == "" or not equipment.name then
            name = "空"
        else
            name = equipment.name
        end
        if equaldata[name] then
            if equipment.cd then
                if not min_cd or equipment.cd < min_cd then
                    min_cd = equipment.cd
                end
            end
        end
    end
    return min_cd
    --如果返回nil就是没穿戴
end

--发送网络消息
function ReliveMain.SyncResponse(actor, logindatas)
    local ItemName1 = getconst(actor, "<$DRESS>") --衣服位置
    local ItemName2 = getconst(actor, "<$BUJUK>") --毒符位置
    local ItemName3 = "空"
    if checkitemw(actor, "六道轮回盘", 1) then
        ItemName3 = "六道轮回盘" --六道轮回盘
    end
    local time1 = getplaydef(actor, VarCfg["U_复活队列1"])
    local time2 = getplaydef(actor, VarCfg["U_复活队列2"])
    local time3 = getplaydef(actor, VarCfg["U_复活队列3"])
    local ReliveQueue = ReliveMain.GetReliveTable(actor)
    local equipments = {
        { name = ItemName1, cd = time1 },
        { name = ItemName2, cd = time2 },
        { name = ItemName3, cd = time3 },
    }
    local state = nil
    local reliveState = "1"
    if #ReliveQueue > 0 then
        state = "可复活+" .. #ReliveQueue
        reliveState = "1"
    else
        local min_cd = findMinCd(equipments)
        if not min_cd then
            state = "未穿戴"
        else
            state = min_cd
        end
        reliveState = "0"
    end
    --复活改变状态触发
    if checkkuafu(actor) then
        FKuaFuToBenFuEvent(actor, EventCfg.onRliveNotice, reliveState)
    else
        GameEvent.push(EventCfg.onRliveNotice, actor, reliveState)
    end
    local _login_data = { ssrNetMsgCfg.LeftAttr_FuHuo, 0, 0, 0, { state } }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.LeftAttr_FuHuo, 0, 0, 0, { state })
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    local item_num1 = getplaydef(actor, VarCfg["U_复活队列1"])
    local item_num2 = getplaydef(actor, VarCfg["U_复活队列2"])
    local item_num3 = getplaydef(actor, VarCfg["U_复活队列3"])
    if item_num1 > 0 then
        setontimer(actor, 101, 1, 0, 1) --添加101号定时器
    end
    if item_num2 > 0 then
        setontimer(actor, 102, 1, 0, 1) --添加102号定时器
    end
    if item_num3 > 0 then
        setontimer(actor, 103, 1, 0, 1) --添加103号定时器
    end
    ReliveMain.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ReliveMain)

GameEvent.add(EventCfg.onKuaFuEnd, _onLoginEnd, ReliveMain)

local function _onRliveNotice(actor, reliveState)
    -- release_print(actor, reliveState,Player.GetNameEx(actor))
    local Tbl = {31083, 31089, 31090, 31091}
    for _, v in ipairs(Tbl) do
        if hasbuff(actor, v) then
            delbuff(actor, v)
        end
    end
    if reliveState == "0" then
        if checkitemw(actor, "无序的邪力", 1) then
            addbuff(actor, 31083)
        end

        --〝回魂〞 复活后,不可复活状态下，增加100%防御
        if checkitemw(actor, "〝回魂〞", 1) then
            addbuff(actor, 31089)
        end
 
        --無上生霊″魂灭生 不可用时增加15%神魂血量
        if checkitemw(actor, "無上生霊″魂灭生", 1) then
            addbuff(actor, 31091)
        end
    else
        if checkitemw(actor, "無上生霊″魂灭生", 1) then
            addbuff(actor, 31090)
        end
    end
end
--复活状态改变触发
GameEvent.add(EventCfg.onRliveNotice, _onRliveNotice, ReliveMain)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.LeftAttr, ReliveMain)

return ReliveMain
