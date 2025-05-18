local MieShiLingYu = {}
MieShiLingYu.ID = "灭世领域"
local npcID = 237
local cost = { { "〈古龙·意志〉", 1 }, { "〈古龙·之力〉", 1 }, { "太虚古龙的秘密", 1 } }
local give = { { "太虚古龙领域[完全体]", 1 } }
--local config = include("QuestDiary/cfgcsv/cfg_MieShiLingYu.lua") --配置
--接收请求
function MieShiLingYu.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "你的背包格子不足,至少留出5个空格!#249")
        stop(actor)
    end
    Player.takeItemByTable(actor, cost, "灭世领域剧情")
    Player.giveItemByTable(actor, give, "灭世领域剧情", 1, true)
    MieShiLingYu.SyncResponse(actor)
    setflagstatus(actor,VarCfg["F_合成太虚古龙领域"],1)
    Player.sendmsgEx(actor, "提示：#251|恭喜你获得了|太虚古龙领域[完全体]#249")
end
--同步消息
function MieShiLingYu.SyncResponse(actor, logindatas)
    local data = {}
    local _login_data = {ssrNetMsgCfg.MieShiLingYu_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MieShiLingYu_SyncResponse, 0, 0, 0, data)
    end
end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     MieShiLingYu.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MieShiLingYu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.MieShiLingYu, MieShiLingYu)
return MieShiLingYu
--init内容