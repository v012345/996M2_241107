local LiuDaoLunHuiPan = {}
LiuDaoLunHuiPan.ID = "六道轮回盘"
local npcID = 457
--local config = include("QuestDiary/cfgcsv/cfg_LiuDaoLunHuiPan.lua") --配置
local cost = { { "阴阳魂石", 188 }, { "轮回经", 1 }, { "灵石", 288 } }
local give = { { "六道轮回盘", 1 } }
--接收请求
function LiuDaoLunHuiPan.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "六道轮回盘")
    Player.giveItemByTable(actor, give, "六道轮回盘", 1, true)
    setflagstatus(actor,VarCfg["F_六道轮回盘_完成"],1)
    messagebox(actor,"恭喜你获得背包神器[六道轮回盘]")
end

--同步消息
-- function LiuDaoLunHuiPan.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.LiuDaoLunHuiPan_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.LiuDaoLunHuiPan_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     LiuDaoLunHuiPan.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LiuDaoLunHuiPan)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.LiuDaoLunHuiPan, LiuDaoLunHuiPan)
return LiuDaoLunHuiPan
