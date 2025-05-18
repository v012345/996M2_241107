local LianHunLu = {}
LianHunLu.ID = "炼魂炉"
local npcID = 447
--local config = include("QuestDiary/cfgcsv/cfg_LianHunLu.lua") --配置
local cost = { { "幽冥残魂", 10 }, { "焚天石", 888 }, { "元宝", 888888 } }
local give = { { "四象轮转魂", 1 } }
--接收请求
function LianHunLu.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "炼魂炉")
    Player.giveItemByTable(actor, give, "炼魂炉", 1, true)
    Player.sendmsgEx(actor, "恭喜你获得|[四象轮转魂]#250|,快去转生吧!")
end

--同步消息
-- function LianHunLu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.LianHunLu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.LianHunLu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     LianHunLu.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LianHunLu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.LianHunLu, LianHunLu)
return LianHunLu
