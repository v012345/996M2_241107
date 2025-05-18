local HuiShou = {}

local newConfig = {}

for i, v in ipairs(cfg_HuiShou) do
    v.id = i
    newConfig[v.idx] = v
end
local cfg_UseItem = include("QuestDiary/cfgcsv/cfg_UseItem.lua") --物品使用数据


--自动回收的物品
local function RecoveryItem(actor, itemName)
    if not itemName then
        return
    end
    local itemNum = getbagitemcount(actor, itemName)
    if itemNum <= 0 then
        return
    end
    local value = cfg_UseItem[itemName]
    if not value then
        return
    end
    if value.type == 1 then
        local total = value.value * itemNum
        if checkitemw(actor,"牛马主宰印",1) then
            if randomex(20) then
                total = total * 2
            end
        end
        local data = splitLargeNumber(4000000000, total)
        if #data > 0 then
            local liveMax = getplaydef(actor, VarCfg["U_等级上限"])
            local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
            if myLevel < liveMax then
                for _, v in ipairs(data) do
                    changeexp(actor, "+", v, true)
                end
            else
                sendmsg(actor,1,'{"Msg":"你的等级已经达到上限,使用经验卷无法继续获得经验!","FColor":255,"BColor":249,"Type":1,"Time":3,"SendName":"提示","SendId":"123"}')
            end
            takeitemex(actor, itemName, itemNum, 0, "自动吃经验")
        end
    elseif value.type == 2 then
        local total = value.value * itemNum
        local data = splitLargeNumber(2000000000, total)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, 2, "+", v, "自动吃" .. itemName, true)
            end
            takeitemex(actor, itemName, itemNum, 0, "自动吃元宝")
        end
    elseif value.type == 3 then
        local randomValue = math.random(value.value[1], value.value[2])
        local total = randomValue * itemNum
        if checkitemw(actor,"牛马主宰印",1) then
            if randomex(20) then
                total = total * 2
            end
        end
        local data = splitLargeNumber(2000000000, total)
        local goldId = FGetBindGoldId(actor)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, goldId, "+", v, "自动吃" .. itemName, true)
            end
            takeitemex(actor, itemName, itemNum, 0, "自动吃红包")
        end
    end
end

--MakeID回收
function HuiShou.Request(actor, arg1, arg2, arg3, datas)
    local isHuiShou = false
    local giveItems = {}
    local giveArray = {}
    local makeIdItems = {}
    for _, makeId in ipairs(datas) do
        local itemObj = getitembymakeindex(actor, makeId)
        if itemObj ~= "0" then
            local idx = getiteminfo(actor, itemObj, ConstCfg.iteminfo.idx)
            local itemInfo = newConfig[idx]
            -- dump(itemInfo)
            if itemInfo then
                table.insert(makeIdItems, makeId)
                local itemNum = getiteminfo(actor, itemObj, ConstCfg.iteminfo.overlap)
                if itemNum == 0 then
                    itemNum = 1
                end
                for _, value in ipairs(itemInfo.give) do
                    if not giveItems[value[1]] then --如果key是空的，就创建一个key
                        giveItems[value[1]] = value[2] * itemNum
                    else
                        giveItems[value[1]] = giveItems[value[1]] + value[2] * itemNum --如果不是空的就在原有的奖励累加
                    end
                end
            end
        end
    end
    local markupAttr = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 216)
    if markupAttr == 0 then markupAttr = 100 end
    local markup = markupAttr / 100
    --把奖励key转换成数组
    for key, value in pairs(giveItems) do
        if key == "金币" then
            value = math.floor(value * markup)
        end
        local Array = { key, value }
        table.insert(giveArray, Array)
    end
    -- dump(giveArray)
    isHuiShou = delitembymakeindex(actor, table.concat(makeIdItems, ","), 0, "系统回收")
    if isHuiShou then
        -- release_print(getflagstatus(actor, VarCfg["F_解绑状态"]))
        if getflagstatus(actor, VarCfg["F_解绑状态"]) == 0 then
            for i = 1, #giveArray do
                if giveArray[i][1] == "金币" then
                    giveArray[i][1] = "绑定金币"
                end
            end
            Player.giveItemByTable(actor, giveArray, "系统回收给予绑定", 1,true)
        else
            Player.giveItemByTable(actor, giveArray, "系统回收给予未绑定", 1,true)
        end
        GameEvent.push(EventCfg.onHuiShouFinish, actor, giveArray)
    end
end

--请求回收装备idx回收
-- function HuiShou.Request(actor, arg1, arg2, arg3, datas)
--     local isHuiShou = false
--     local giveItems = {}
--     local giveArray = {}
--     for _, idx in ipairs(datas) do
--         local itemInfo = newConfig[idx]
--         -- dump(itemInfo)
--         if itemInfo then
--             local itemName = itemInfo.equipName
--             local itemNum = getbagitemcount(actor, itemName) --获取物品数量
--             if itemNum > 0 then
--                 local isSuccess = takeitemex(actor, itemName, itemNum, 0, "系统回收") --拿走物品
--                 if isSuccess then --是否成功拿走
--                     for _, value in ipairs(itemInfo.give) do
--                         if not giveItems[value[1]] then --如果key是空的，就创建一个key
--                             giveItems[value[1]] = value[2] * itemNum
--                         else
--                             giveItems[value[1]] = giveItems[value[1]] + value[2] * itemNum --如果不是空的就在原有的奖励累加
--                         end
--                     end
--                     isHuiShou = true
--                 end
--             end
--         end
--     end
--     --把奖励key转换成数组
--     for key, value in pairs(giveItems) do
--         local Array = { key, value }
--         table.insert(giveArray, Array)
--     end
--     if isHuiShou then
--         Player.giveItemByTable(actor, giveArray, "系统回收给予", 1)
--     end
-- end

--请求使用道具
function HuiShou.UseItem(actor, arg1, arg2, arg3, datas)
    for _, value in ipairs(datas) do
        local itemName = getstditeminfo(value, ConstCfg.stditeminfo.name)
        RecoveryItem(actor, itemName)
    end
end

--登录同步数据
function HuiShou.SyncResponse(actor, logindatas)
    local data = Player.getJsonTableByVar(actor, "T1")
    local flag1 = getflagstatus(actor, VarCfg.F_is_auto_money)
    local flag2 = getflagstatus(actor, VarCfg.F_is_auto_exp)
    local flag3 = getflagstatus(actor, VarCfg.F_is_auto_recovery)
    local flag4 = getflagstatus(actor, VarCfg.F_is_auto_custom_attributes)
    local flag5 = getflagstatus(actor, VarCfg["F_是否回收可提升装备"])
    data["markup"] = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 216)
    data["flag4"] = flag4
    data["flag5"] = flag5
    local _login_data = { ssrNetMsgCfg.HuiShou_SyncResponse, flag1, flag2, flag3, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.HuiShou_SyncResponse, flag1, flag2, flag3, data)
    end
end

--勾选数据
function HuiShou.RequestCheck(actor, arg1, arg2, arg3, data)
    Player.setJsonVarByTable(actor, "T1", data)
end

-- ssrNetMsgCfg.HuiShou_AutoHuiShou             = 11005      --勾选自动回收
-- ssrNetMsgCfg.HuiShou_AutoMoney               = 11006      --勾选自动回收
-- ssrNetMsgCfg.HuiShou_AutoExp                 = 11007      --勾选自动回收

--勾选自动回收
function HuiShou.AutoHuiShou(actor, arg1)
    local flag = getflagstatus(actor, VarCfg.F_is_auto_recovery) == 0 and 1 or 0
    setflagstatus(actor, VarCfg.F_is_auto_recovery, flag)
    Message.sendmsg(actor, ssrNetMsgCfg.HuiShou_AutoHuiShou, flag)
end

--自动吃货币
function HuiShou.AutoMoney(actor, arg1)
    local flag = getflagstatus(actor, VarCfg.F_is_auto_money) == 0 and 1 or 0
    setflagstatus(actor, VarCfg.F_is_auto_money, flag)
    Message.sendmsg(actor, ssrNetMsgCfg.HuiShou_AutoMoney, flag)
end

--自动吃经验
function HuiShou.AutoExp(actor, arg1)
    local flag = getflagstatus(actor, VarCfg.F_is_auto_exp) == 0 and 1 or 0
    setflagstatus(actor, VarCfg.F_is_auto_exp, flag)
    Message.sendmsg(actor, ssrNetMsgCfg.HuiShou_AutoExp, flag)
end

--是否回收鉴定强化
function HuiShou.CheckCustomAttributes(actor, arg1)
    local flag = getflagstatus(actor, VarCfg.F_is_auto_custom_attributes) == 0 and 1 or 0
    setflagstatus(actor, VarCfg.F_is_auto_custom_attributes, flag)
    Message.sendmsg(actor, ssrNetMsgCfg.HuiShou_CheckCustomAttributes, flag)
end

--是否回收鉴定强化
function HuiShou.CheckKeTiSheng(actor, arg1)
    local flag = getflagstatus(actor, VarCfg["F_是否回收可提升装备"]) == 0 and 1 or 0
    setflagstatus(actor, VarCfg["F_是否回收可提升装备"], flag)
    Message.sendmsg(actor, ssrNetMsgCfg.HuiShou_CheckKeTiSheng, flag)
end

Message.RegisterNetMsg(ssrNetMsgCfg.HuiShou, HuiShou)
--登录触发
local function _onLoginEnd(actor, logindatas)
    HuiShou.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HuiShou)

local function _onCalcAttr(actor, attrs)
    local shuxing = {
        [216] = 100
    }
    calcAtts(attrs, shuxing, "回收默认100%")
end
--属性
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, HuiShou)

return HuiShou
