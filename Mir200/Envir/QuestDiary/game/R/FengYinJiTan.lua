local FengYinJiTan = {}
FengYinJiTan.ID = "封印祭坛"
local npcID = 231
local mapId = "神庙大厅"
--local config = include("QuestDiary/cfgcsv/cfg_FengYinJiTan.lua") --配置
local cost = { { "卡亚神符", 20 }, { "邪神印记", 20 }, { "金币", 300000 } }
--接收请求
function FengYinJiTan.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("召唤失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "封印祭坛")

    FSetTaskRedPoint(actor, VarCfg["F_封印祭坛_完成"], 11)
    
    genmon(mapId, 77, 76, "邪神.卡亚魔君[SSS]", 1, 1, 255)
    Player.sendmsgEx(actor, "提示：#251|你召唤了|[邪神.卡亚魔君[SSS]]#249")
    Message.sendmsg(actor, ssrNetMsgCfg.FengYinJiTan_Close, 0, 0, 0, {})
end

--同步消息
-- function FengYinJiTan.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.FengYinJiTan_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.FengYinJiTan_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     FengYinJiTan.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FengYinJiTan)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.FengYinJiTan, FengYinJiTan)
return FengYinJiTan
--init内容
