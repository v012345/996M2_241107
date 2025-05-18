local YiWangGuJi = {}
YiWangGuJi.ID = "遗忘古迹"
local npcID = 220
local mapID = "遗忘大陆"
--local config = include("QuestDiary/cfgcsv/cfg_YiWangGuJi.lua") --配置
local cost = {{}}
local give = {{}}
--接收请求
function YiWangGuJi.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        --return
    --end
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if not FCheckLevel(actor, 120) then
        Player.sendmsgEx(actor, "等级不足120级,进入失败!#249")
        return
    end
    FMapMoveEx(actor, mapID, 126,126,0)
end
--同步消息
-- function YiWangGuJi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.YiWangGuJi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.YiWangGuJi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     YiWangGuJi.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YiWangGuJi)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YiWangGuJi, YiWangGuJi)
return YiWangGuJi