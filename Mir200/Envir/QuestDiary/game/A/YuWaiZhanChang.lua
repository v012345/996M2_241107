local YuWaiZhanChang = {}
YuWaiZhanChang.ID = "域外战场"
local npcID = 3060
--local config = include("QuestDiary/cfgcsv/cfg_YuWaiZhanChang.lua") --配置
local cost = {{}}
local give = {{}}
local mapID = "域外战场"
--接收请求
function YuWaiZhanChang.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if not FCheckLevel(actor, 220) then
        Player.sendmsgEx(actor, "等级不足220级,进入失败!#249")
        return
    end
    FMapMoveEx(actor, mapID, 23 ,22,0)
end
--同步消息
-- function YuWaiZhanChang.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.YuWaiZhanChang_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.YuWaiZhanChang_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     YuWaiZhanChang.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YuWaiZhanChang)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YuWaiZhanChang, YuWaiZhanChang)
return YuWaiZhanChang