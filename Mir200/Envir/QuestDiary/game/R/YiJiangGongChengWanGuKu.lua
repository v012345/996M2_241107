local YiJiangGongChengWanGuKu = {}
YiJiangGongChengWanGuKu.ID = "一将功成万古枯"
local npcID = 326
local give = {{"骷髅将军[装扮时装]",1}}
--local config = include("QuestDiary/cfgcsv/cfg_YiJiangGongChengWanGuKu.lua") --配置
local config = {
    { var = VarCfg["F_剧情_一将功成万古枯1"], equipName = "黄泉" },
    { var = VarCfg["F_剧情_一将功成万古枯2"], equipName = "离火" },
    { var = VarCfg["F_剧情_一将功成万古枯3"], equipName = "深渊之行" },
}
--提交装备
function YiJiangGongChengWanGuKu.Request1(actor, index)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx("参数错误!")
        return
    end
    if getflagstatus(actor, cfg.var) == 1 then
        Player.sendmsgEx(actor, string.format("%s#249|已经提交过了!", cfg.equipName))
        return
    end
    local cost = { { cfg.equipName, 1 } }
    -- dump(cost)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.sendmsgEx(actor, string.format("%s#249|成功提交!", cfg.equipName))
    Player.takeItemByTable(actor, cost, "一将功成万古枯")
    setflagstatus(actor, cfg.var, 1)
    YiJiangGongChengWanGuKu.SyncResponse(actor)
end

--领取装备
function YiJiangGongChengWanGuKu.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if getflagstatus(actor,VarCfg["F_剧情_时装是否领取"]) == 1 then
        Player.sendmsgEx(actor, "你已经领取过了,请勿重复领取!#249")
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
        stop(actor)
    end
    local flag1 = getflagstatus(actor, VarCfg["F_剧情_一将功成万古枯1"])
    local flag2 = getflagstatus(actor, VarCfg["F_剧情_一将功成万古枯2"])
    local flag3 = getflagstatus(actor, VarCfg["F_剧情_一将功成万古枯3"])
    if flag1 == 1 and flag2 == 1 and flag3 == 1 then
        Player.giveItemByTable(actor, give, "一将功成万古枯", 1, true)
        Player.sendmsgEx(actor, "恭喜你获得|骷髅将军[时装]#249")
        YiJiangGongChengWanGuKu.SyncResponse(actor)
        setflagstatus(actor,VarCfg["F_剧情_时装是否领取"],1)
    else
        Player.sendmsgEx(actor, "你还有装备没提交呢!#249")
    end
end
--同步消息
function YiJiangGongChengWanGuKu.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        local flag = getflagstatus(actor, value.var)
        table.insert(data, flag)
    end
    local flag = getflagstatus(actor,VarCfg["F_剧情_时装是否领取"])
    local _login_data = {ssrNetMsgCfg.YiJiangGongChengWanGuKu_SyncResponse, flag, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YiJiangGongChengWanGuKu_SyncResponse, flag, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    YiJiangGongChengWanGuKu.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YiJiangGongChengWanGuKu)
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YiJiangGongChengWanGuKu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YiJiangGongChengWanGuKu, YiJiangGongChengWanGuKu)
return YiJiangGongChengWanGuKu
