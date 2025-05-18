local ShiPoShenXiang = {}
local npcID = 228
local cost = { { "湿婆神像", 2 }, { "金币", 50000 } }
--接取任务
function ShiPoShenXiang.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local jindu = getplaydef(actor, VarCfg["U_剧情_湿婆神像_进度"])
    if jindu >= 100 then
        if not confertitle(actor,"湿婆信徒") then
            confertitle(actor, "湿婆信徒", 1)
            Player.setAttList(actor, "回血计算")
        end
        if not getskillinfo(actor,6, 1) then
            addskill(actor, 6, 3)
        end
        Player.sendmsgEx(actor, "你的湿婆神像进度已经满了!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "湿婆神像剧情")
    local addJindu = math.random(2, 8)
    setplaydef(actor, VarCfg["U_剧情_湿婆神像_进度"], addJindu + jindu)
    local addExp = math.random(10000000, 30000000)
    changeexp(actor, "+", addExp, false)
    Player.sendmsgEx(actor, string.format("提示：#251|湿婆神已感应到你的虔诚祈祷,|虔诚度|+%d#249|,经验|+%d#249|。", addJindu, addExp))
    if addJindu + jindu >= 100 then
        confertitle(actor, "湿婆信徒", 1)
        GameEvent.push(EventCfg.onGetTaskTitle, actor, "湿婆信徒") --任务触发
        addskill(actor, 6, 3)
        Player.setAttList(actor, "回血计算")
        messagebox(actor, "提示：你完成了该剧情任务获得称号:[湿婆信徒],获得技能:[施毒术]")
    end
    ShiPoShenXiang.SyncResponse(actor)
end

function ShiPoShenXiang.SyncResponse(actor)
    local jindu = getplaydef(actor, VarCfg["U_剧情_湿婆神像_进度"])
    Message.sendmsg(actor, ssrNetMsgCfg.ShiPoShenXiang_SyncResponse, jindu, 0, 0, {})
end

Message.RegisterNetMsg(ssrNetMsgCfg.ShiPoShenXiang, ShiPoShenXiang)
return ShiPoShenXiang
