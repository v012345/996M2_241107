--点击任务
local TaskClickNpc = {}
--入口
TaskClickNpc.init = function(actor, npcid, taskID, cfg)
    local func = TaskClickNpc[npcid]
    if func then
        return func(actor, npcid, taskID, cfg)
    end
end
--起源村杀怪
TaskClickNpc[1001] = function(actor, npcid, taskID, cfg)
    if taskID == 2 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        --可以完成起源村杀怪
        if mainTaskStatus == 2 then
            changeexp(actor, "+", 5000, false)
            addskill(actor, 66, 3)
            Player.sendmsgEx(actor, "任务完成:获得|经验*5000#249|学习技能|开天斩#249")
            Player.nextTaskMain(actor, taskID, cfg)
            return true
        end
    --采集清毒莲完成任务
    elseif taskID == 3 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus == 2 then
            changeexp(actor, "+", 5000, false)
            addskill(actor, 56, 3)
            local itemNum = getbagitemcount(actor,"清毒莲")
            if itemNum > 5 then
                itemNum = 5
            end
            local items = {{"清毒莲",itemNum}}
            Player.takeItemByTable(actor,items,"任务拿走")
            Player.sendmsgEx(actor, "任务完成:获得|经验*5000#249|学习技能|逐日剑法#249")
            Player.nextTaskMain(actor, taskID, cfg)
            return true
        end
    end
end

TaskClickNpc[1002] = function(actor, npcid, taskID, cfg)
    if taskID == 4 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus == 2 then
            changeexp(actor, "+", 20000, false)
            giveonitem(actor, 12, "杀戮刻印Lv.1", 1, ConstCfg.binding)
            Player.sendmsgEx(actor, "任务完成:获得|经验*20000#249|获得装备|疾风刻印Lv.1#249|装备已为你自动穿戴!")
            Player.nextTaskMain(actor, taskID, cfg)
            return true
        end
    end
end

TaskClickNpc[1003] = function(actor, npcid, taskID, cfg)
    if taskID == 5 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus == 2 then
            changeexp(actor, "+", 20000, false)
            giveonitem(actor, 14, "疾风刻印Lv.1", 1, ConstCfg.binding)
            Player.sendmsgEx(actor, "任务完成:获得|经验*20000#249|获得装备|疾风刻印Lv.1#249|装备已为你自动穿戴!")
            changemode(actor,22,300)
            Player.sendmsgEx(actor, "你隐身了,持续5分钟!")
            Player.nextTaskMain(actor, taskID, cfg)
            return true
        end
    end
end
TaskClickNpc[1005] = function(actor, npcid, taskID, cfg)
    if taskID == 7 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus == 0 then
            local where = 43
            local itemObj = linkbodyitem(actor, where)
            if itemObj == "0" then
                giveonitem(actor, where, "灵气枯竭的木匣", 1, 0, "修仙给予")
                XiuXian.addXiuXian(actor, 130)
                local gives = {{"绑定金币",10000}}
                Player.giveItemByTable(actor, gives, "修仙任务给金币")
                Player.sendmsgEx(actor, "任务完成:获得装备|灵气枯竭的木匣#249|,|修仙值*130#249|装备已为你自动穿戴!")
            end
        end
    end
end

return TaskClickNpc
