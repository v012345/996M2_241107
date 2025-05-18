ChaoJiJuQing = {}
ChaoJiJuQing.ID = "超级剧情"
local config = include("QuestDiary/cfgcsv/cfg_JuQingCategories.lua")          --配置
local config2 = include("QuestDiary/cfgcsv/cfg_JuQing.lua")                   --配置
local MainConditions = include("QuestDiary/game/R/GetJQMainConditions.lua")   --配置
local ChildConditions = include("QuestDiary/game/R/GetJQChildConditions.lua") --配置
local function allTrue(array)
    for i = 1, #array do
        local element = array[i]
        if type(element) == "table" then
            if #element == 2 then
                if element[1] < element[2] then
                    return false
                end
            else
                return false
            end
        elseif type(element) == "boolean" then
            if not element then
                return false
            end
        else
            return false
        end
    end
    return true
end
--领取奖励1
function ChaoJiJuQing.Request1(actor, parentIndex, childIndex)
    local cfg = config[parentIndex]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local flag = getplayvar(actor, "HUMAN", cfg.var)
    if flag == "1" or flag == 1 then
        Player.sendmsgEx(actor, "已经领取过了#249")
        return
    end
    local data = MainConditions[parentIndex](actor)
    if not data then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local bool = allTrue(data)
    if not bool then
        Player.sendmsgEx(actor, "你没有完成全部剧情任务,无法领取#249")
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
        stop(actor)
        return
    end
    FSetPlayVar(actor, cfg.var, 1, 1)
    Player.giveItemByTable(actor, cfg.reward, "完成" .. cfg.name .. "奖励",1, true)
    local msgStr = getItemArrToStr(cfg.reward)
    Player.sendmsgEx(actor, string.format("[系统提示]： 领取成功：|[%s]#249", msgStr))
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoJiJuQing_SyncLingQu1, 1)
end

--领取奖励2
function ChaoJiJuQing.Request2(actor, parentIndex, childIndex)
    local cfg = config2[childIndex]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local flag = getplayvar(actor, "HUMAN", cfg.var)
    if flag == "1" or flag == 1 then
        Player.sendmsgEx(actor, "已经领取过了#249")
        return
    end
    local data = ChildConditions[childIndex](actor)
    if not data then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local bool = allTrue(data)
    if not bool then
        Player.sendmsgEx(actor, "你没有完成该剧情任务,无法领取#249")
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
        stop(actor)
        return
    end
    FSetPlayVar(actor, cfg.var, 1, 1)
    Player.giveItemByTable(actor, cfg.reward, "完成" .. cfg.name .. "奖励",1, true)
    local msgStr = getItemArrToStr(cfg.reward)
    Player.sendmsgEx(actor, string.format("[系统提示]： 领取成功：|[%s]#249", msgStr))
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoJiJuQing_SyncLingQu2, 1)
end

--处理主菜单
function ChaoJiJuQing.Sync1(actor, parentIndex, arg1, arg2, data)
    if not parentIndex or type(parentIndex) ~= "number" then
        Player.sendmsgEx(actor, "参数错误1#249")
        return
    end
    local func = MainConditions[parentIndex]
    if not func then
        Player.sendmsgEx(actor, "参数错误2#249")
        return
    end
    local data = func(actor)
    if not data then
        Player.sendmsgEx(actor, "参数错误3#249")
        return
    end
    local cfg =  config[parentIndex]
    local flag = getplayvar(actor, "HUMAN", cfg.var)
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoJiJuQing_Sync1, flag, 0, 0, data)
end

--处理子菜单
function ChaoJiJuQing.Sync2(actor, childIndex, arg2, arg2, data)
    if not childIndex or type(childIndex) ~= "number" then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local data = ChildConditions[childIndex](actor)
    if not data then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local cfg = config2[childIndex]
    local flag = getplayvar(actor, "HUMAN", cfg.var)
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoJiJuQing_Sync2, flag, 0, 0, data)
end

--同步消息
-- function ChaoJiJuQing.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ChaoJiJuQing_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ChaoJiJuQing_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ChaoJiJuQing.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ChaoJiJuQing)
--注册网络消息
--个人变量声明
local function _goPlayerVar(actor)
    for _, value in ipairs(config) do
        FIniPlayVar(actor, value.var)
    end
    for _, value in ipairs(config2) do
        FIniPlayVar(actor, value.var)
    end
end
GameEvent.add(EventCfg.goPlayerVar, _goPlayerVar, ChaoJiJuQing)

Message.RegisterNetMsg(ssrNetMsgCfg.ChaoJiJuQing, ChaoJiJuQing)
return ChaoJiJuQing
