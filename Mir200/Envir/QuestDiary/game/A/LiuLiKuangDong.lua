local LiuLiKuangDong = {}
LiuLiKuangDong.ID = "琉璃矿洞"
local npcID = 113
--local config = include("QuestDiary/cfgcsv/cfg_LiuLiKuangDong.lua") --配置
local mapID = "琉璃矿洞"
--接收请求
function LiuLiKuangDong.Request(actor)
    if FCheckLevel(actor, 150) then
        Player.sendmsgEx(actor,"等级超过150级,进入失败!")
        return
    end
    local monNum = getmoncount(mapID, -1, true)
    if monNum < 200 then
        genmon(mapID, 155, 127, "矿工杰夫", 150, 120, 145)
        genmon(mapID, 155, 127, "石头人", 150, 120, 145)
        genmon(mapID, 155, 127, "岩石人", 150, 120, 145)
    end
    FMapEx(actor, mapID, true)
end
--同步消息
-- function LiuLiKuangDong.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.LiuLiKuangDong_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.LiuLiKuangDong_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     LiuLiKuangDong.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LiuLiKuangDong)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.LiuLiKuangDong, LiuLiKuangDong)
return LiuLiKuangDong