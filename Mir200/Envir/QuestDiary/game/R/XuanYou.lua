local XuanYou = {}
local npcID = 414
local taskId = 200
local cost = { { "超级护身符", 38 } }
local give = { { "一念花尘", 1 } }
function XuanYou.OpenUI(actor)
    local flag = getflagstatus(actor, VarCfg["F_剧情_玄幽"])
    Message.sendmsg(actor, ssrNetMsgCfg.XuanYou_OpenUI, flag)
end

--接取任务
function XuanYou.Request(actor)
    local flag = getflagstatus(actor, VarCfg["F_剧情_玄幽"])
    if flag == 1 then
        Player.sendmsgEx(actor, "你已经完成了该剧情任务!#249")
        return
    end
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    Player.addTask(actor, taskId, 1)
    Task.SyncResponse(actor)
end

function XuanYou.RequestSubmit(actor)
    local flag = getflagstatus(actor, VarCfg["F_剧情_玄幽"])
    if flag == 1 then
        Player.sendmsgEx(actor, "你已经完成了该剧情任务!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "玄幽剧情")
    Player.giveItemByTable(actor, give, "玄幽剧情", 1, true)
    Player.sendmsgEx(actor, "恭喜你完成任务,获得|[一念花尘]#249")
    newdeletetask(actor, taskId)
    Player.removeTask(actor, taskId)
    Task.SyncResponse(actor)
    FSetTaskRedPoint(actor, VarCfg["F_剧情_玄幽"], 15)
    Message.sendmsg(actor, ssrNetMsgCfg.XuanYou_OpenUI, 1)
end

Message.RegisterNetMsg(ssrNetMsgCfg.XuanYou, XuanYou)
return XuanYou
