local YeShouZhiSen = {}
YeShouZhiSen.ID = "野兽之森"
local npcID = 111
local mapID = "野兽之森"
--local config = include("QuestDiary/cfgcsv/cfg_YeShouZhiSen.lua") --配置
--接收请求
function YeShouZhiSen.Request(actor)
    if FCheckLevel(actor, 150) then
        Player.sendmsgEx(actor,"等级超过150级,进入失败!")
        return
    end

    local monNum = getmoncount(mapID, -1, true)
    if monNum < 500 then
        genmon(mapID, 180, 240, "黑猩猩", 200, 180, 150)
        genmon(mapID, 180, 240, "森林野人", 200, 180, 150)
        genmon(mapID, 180, 240, "狂暴野猪", 200, 180, 150)
    end

    FMapEx(actor, mapID, true)
end
--同步消息
-- function YeShouZhiSen.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.YeShouZhiSen_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.YeShouZhiSen_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     YeShouZhiSen.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YeShouZhiSen)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YeShouZhiSen, YeShouZhiSen)
return YeShouZhiSen