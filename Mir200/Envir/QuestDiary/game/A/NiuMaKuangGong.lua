local NiuMaKuangGong = {}
NiuMaKuangGong.ID = "牛马旷工"
local npcID = 0
--local config = include("QuestDiary/cfgcsv/cfg_NiuMaKuangGong.lua") --配置
local cost = {{}}
local give = {{}}
--接收请求
function NiuMaKuangGong.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        --return
    --end
end
--同步消息
-- function NiuMaKuangGong.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.NiuMaKuangGong_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.NiuMaKuangGong_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     NiuMaKuangGong.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, NiuMaKuangGong)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.NiuMaKuangGong, NiuMaKuangGong)
return NiuMaKuangGong