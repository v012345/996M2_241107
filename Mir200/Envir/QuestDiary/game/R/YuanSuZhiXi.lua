local YuanSuZhiXi = {}
local npcID = 227
local give = { { "元素裂隙权杖", 1 } }
local cost = { { "放逐之心", 20 } }
--接取任务
function YuanSuZhiXi.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local flag = getflagstatus(actor, VarCfg["F_剧情_元素之隙"])
    if flag == 1 then
        Player.sendmsgEx(actor, "你已经完成了该剧情任务!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "元素之隙剧情")
    Player.giveItemByTable(actor, give, "元素之隙剧情", 1, true)
    -- setflagstatus(actor, VarCfg["F_剧情_元素之隙"], 1)
    FSetTaskRedPoint(actor, VarCfg["F_剧情_元素之隙"], 8)
    YuanSuZhiXi.SyncResponse(actor)
end
function YuanSuZhiXi.SyncResponse(actor)
    local flag = getflagstatus(actor, VarCfg["F_剧情_元素之隙"])
    Message.sendmsg(actor, ssrNetMsgCfg.YuanSuZhiXi_SyncResponse, flag, 0, 0, {})
end

Message.RegisterNetMsg(ssrNetMsgCfg.YuanSuZhiXi, YuanSuZhiXi)
return YuanSuZhiXi
