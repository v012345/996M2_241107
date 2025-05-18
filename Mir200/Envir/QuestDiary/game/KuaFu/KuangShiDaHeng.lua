local KuangShiDaHeng = {}
KuangShiDaHeng.ID = "矿石大亨"
local npcID = 129
--local config = include("QuestDiary/cfgcsv/cfg_KuangShiDaHeng.lua") --配置
local cost = {{}}
local give = {{}}
--接收请求
function KuangShiDaHeng.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        --return
    --end
end
--同步消息
-- function KuangShiDaHeng.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.KuangShiDaHeng_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.KuangShiDaHeng_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     KuangShiDaHeng.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, KuangShiDaHeng)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.KuangShiDaHeng, KuangShiDaHeng)
return KuangShiDaHeng