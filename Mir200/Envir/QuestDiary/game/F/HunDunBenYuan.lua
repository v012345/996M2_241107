local HunDunBenYuan = {}
local config = include("QuestDiary/cfgcsv/cfg_HunDunBenYuan.lua") --配置
-- 获取开关状态
function HunDunBenYuan.CheckSwitchState(actor)
    local State1 = getplaydef(actor, VarCfg["N$混沌本源开关1"])
    local State2 = getplaydef(actor, VarCfg["N$混沌本源开关2"])
    local State3 = getplaydef(actor, VarCfg["N$混沌本源开关3"])
    local data = { State1, State2, State3 }
    return data
end
--切换选取状态按钮
function HunDunBenYuan.Switch(actor,var)
    local Switch = (var ~= 1) and (var ~= 2) and (var ~= 3)
    if Switch then return end
    local data = HunDunBenYuan.CheckSwitchState(actor)
    if data[var] == 0 then
        setplaydef(actor, VarCfg["N$混沌本源开关".. var ..""], 1)
    else
        setplaydef(actor, VarCfg["N$混沌本源开关".. var ..""], 0)
    end
    HunDunBenYuan.SyncResponse(actor)
end
--执行回收
function HunDunBenYuan.Request(actor)
    local data = HunDunBenYuan.CheckSwitchState(actor)
    local CheckData = (data[1] ~= 1) and (data[2] ~= 1) and (data[3] ~= 1)
    if CheckData then
        Player.sendmsgEx(actor, "提示#251|:#255|请勾选分类后再来分解...")
        return
    end
    local HunDunNum = 0
    local BagList = getbagitems(actor)                       --获取玩家背包内所有物品对象
    for _, v in ipairs(BagList) do                           --遍历背包所有物品
        local ItemName = getiteminfo(actor, v, 7)            --获取物品名字
        if config[ItemName] then                             --查询是否在表里
            local cfg = config[ItemName]
            if data[cfg.Type] == 1 then
                HunDunNum = HunDunNum + cfg.AwardNum
                takeitem(actor, ItemName, 1, 0, "混沌本源回收扣除")
            end
        end
    end
    if HunDunNum > 0 then
        giveitem(actor, "混沌本源", HunDunNum, 0, "混沌本源回收奖励")
        Player.sendmsgEx(actor, "提示#251|:#255|分解获得|".. HunDunNum .."枚#249|混沌本源...")
    else
        Player.sendmsgEx(actor, "提示#251|:#255|背包内|没有可回收#249|的物品...")
    end
end

--注册网络消息
function HunDunBenYuan.SyncResponse(actor, logindatas)
    local data = HunDunBenYuan.CheckSwitchState(actor)
    local _login_data = { ssrNetMsgCfg.HunDunBenYuan_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.HunDunBenYuan_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.HunDunBenYuan, HunDunBenYuan)

--登录触发
local function _onLoginEnd(actor, logindatas)
    HunDunBenYuan.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HunDunBenYuan)

return HunDunBenYuan
