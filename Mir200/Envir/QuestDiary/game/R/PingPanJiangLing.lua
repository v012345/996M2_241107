local PingPanJiangLing = {}
PingPanJiangLing.ID = "平叛将领"
local npcID = 331
--local config = include("QuestDiary/cfgcsv/cfg_PingPanJiangLing.lua") --配置
local cost = { { "叛军首领的头颅", 1 } }
local give = "洞察之眼"
--接收请求
function PingPanJiangLing.Request(actor)
    if checktitle(actor,give) then
        Player.sendmsgEx(actor, "你已经获得了|洞察之眼#249|称号!")
        return
    end
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提交失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "平叛将领")
    confertitle(actor, give)
    Player.sendmsgEx(actor, "恭喜你获得了|洞察之眼#249|称号!")
    PingPanJiangLing.SyncResponse(actor)
end

--同步消息
function PingPanJiangLing.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.PingPanJiangLing_SyncResponse, 0, 0, 0, data)
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.PingPanJiangLing, PingPanJiangLing)
return PingPanJiangLing
