local KuangHuanXiaoZhen = {}
KuangHuanXiaoZhen.ID = "狂欢小镇"
local npcID = 122
--local config = include("QuestDiary/cfgcsv/cfg_KuangHuanXiaoZhen.lua") --配置
local cost = {{}}
local give = {{}}
--接收请求
function KuangHuanXiaoZhen.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        --return
    --end
end
--同步消息
-- function KuangHuanXiaoZhen.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.KuangHuanXiaoZhen_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.KuangHuanXiaoZhen_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     KuangHuanXiaoZhen.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, KuangHuanXiaoZhen)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.KuangHuanXiaoZhen, KuangHuanXiaoZhen)
return KuangHuanXiaoZhen