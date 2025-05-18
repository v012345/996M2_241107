local HeiShuiMiJi = {}
HeiShuiMiJi.ID = "黑水秘技"
local npcID = 455
--local config = include("QuestDiary/cfgcsv/cfg_HeiShuiMiJi.lua") --配置
local cost = { { "黑水残页", 222 }, { "书页", 2222 } }
local give = { {} }
--接收请求
function HeiShuiMiJi.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local skillInfo = getskillinfo(actor, 2018, 1)
    if skillInfo then
        Player.sendmsgEx(actor, "你已经学习过该技能!#249")
        FSetTaskRedPoint(actor, VarCfg["F_黑水秘技_完成"], 40)
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "黑水秘技")
    -- setflagstatus(actor,VarCfg["F_黑水秘技_完成"],1)
    FSetTaskRedPoint(actor, VarCfg["F_黑水秘技_完成"], 40)
    addskill(actor, 2018, 3)
    messagebox(actor, "恭喜你学习技能[黑水沼泽]")
end

--同步消息
-- function HeiShuiMiJi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.HeiShuiMiJi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.HeiShuiMiJi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     HeiShuiMiJi.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HeiShuiMiJi)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HeiShuiMiJi, HeiShuiMiJi)
return HeiShuiMiJi
