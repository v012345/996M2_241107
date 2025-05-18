local TaoHuaLin = {}
TaoHuaLin.ID = "桃花林"
local npcID = 112
local mapID = "桃花林"
--local config = include("QuestDiary/cfgcsv/cfg_TaoHuaLin.lua") --配置
--接收请求
function TaoHuaLin.Request(actor)
    if FCheckLevel(actor, 150) then
        Player.sendmsgEx(actor,"等级超过150级,进入失败!")
        return
    end
    local monNum = getmoncount(mapID, -1, true)
    if monNum < 500 then
        genmon(mapID, 206, 194, "绿骷髅", 150, 150, 213)
        genmon(mapID, 206, 194, "巡山者", 150, 150, 213)
        genmon(mapID, 206, 194, "魔之灵", 150, 150, 213)
    end
    FMapEx(actor, mapID, true)
end
--同步消息
-- function TaoHuaLin.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.TaoHuaLin_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.TaoHuaLin_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     TaoHuaLin.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TaoHuaLin)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.TaoHuaLin, TaoHuaLin)
return TaoHuaLin