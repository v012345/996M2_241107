local HanShuangWangZuo = {}
HanShuangWangZuo.ID = "寒霜王座"
local npcID = 510
local mobName = "寒霜君主·塞林·SSSR"
--local config = include("QuestDiary/cfgcsv/cfg_HanShuangWangZuo.lua") --配置
local cost = { { "冰封之心", 66 }, { "金币", 5000000 } }
local mapId = "寒霜圣地"
--接收请求
function HanShuangWangZuo.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "寒霜王座")
    genmon(mapId, 102, 95, mobName, 1, 1, 255)
    Player.sendmsgEx(actor, "提示：#251|你召唤了|[" .. mobName .. "]#249")
    setflagstatus(actor,VarCfg["F_召唤寒霜君主·塞林"],1)
    local num = getplaydef(actor,VarCfg["U_寒霜王座"])
    if num < 3 then
        setplaydef(actor,VarCfg["U_寒霜王座"], num + 1)
    end
    Message.sendmsg(actor, ssrNetMsgCfg.HanShuangWangZuo_Close, 0, 0, 0, {})
end

--同步消息
-- function HanShuangWangZuo.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.HanShuangWangZuo_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.HanShuangWangZuo_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     HanShuangWangZuo.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HanShuangWangZuo)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HanShuangWangZuo, HanShuangWangZuo)
return HanShuangWangZuo
