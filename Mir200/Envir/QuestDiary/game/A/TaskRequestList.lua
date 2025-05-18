--点击NPC执行
local TaskRequestList = {}
--入口
TaskRequestList.init = function(actor, taskID, cfg, npcId)
    local func = TaskRequestList[taskID]
    if func then
        return func(actor, taskID, cfg, npcId)
    end
end
--主线 起源村1
TaskRequestList[1] = function(actor, taskID, cfg, npcId)
    changeexp(actor, "+", 5000, false)
    Player.sendmsgEx(actor, "任务完成:获得|经验*5000#249")
    Player.nextTaskMain(actor, taskID, cfg)
    return true
end
--主线起 源村2
TaskRequestList[2] = function(actor, taskID, cfg, npcId)
    if taskID ~= 2 then
        return
    end
    local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
    if mainTaskStatus == 0 then
        setplaydef(actor, VarCfg["U_主线任务状态"], 1) --进行中
    elseif mainTaskStatus == 1 then
        if npcId == 1000 then
            banQfGotoNow(actor, 104, 219)
        end
    elseif mainTaskStatus == 2 then
        if npcId == 1000 then
            Player.sendmsgEx(actor, "任务已完成,正在前往领取奖励!")
            opennpcshowex(actor, 1001, 0, 2)
        end
    end
    return true
end
--主线起 源村3清毒莲
TaskRequestList[3] = function(actor, taskID, cfg, npcId)
    if taskID == 3 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus == 1 then
            banQfGotoNow(actor, 98, 169, 0)
        end
        return true
    end
end
TaskRequestList[4] = function(actor, taskID, cfg, npcId)
    local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
    if taskID == 4 then
        if npcId == 1001 then
            if mainTaskStatus == 0 then
                opennpcshowex(actor, 1002, 0, 2)
            end
        elseif npcId == 1002 then
            if mainTaskStatus == 0 then
                changeexp(actor, "+", 10000, false)
                Player.sendmsgEx(actor, "任务完成:获得|经验*10000#249")
                Player.updateProgress(actor, taskID, 1)
                setplaydef(actor, VarCfg["U_主线任务状态"], 1)
                return true
            elseif mainTaskStatus == 1 then
                banQfGotoNow(actor, 52, 171, 1)
            end
        end
        -- return true
    end
end
TaskRequestList[5] = function(actor, taskID, cfg, npcId)
    if taskID == 5 then
    local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if npcId == 1002 then
            if mainTaskStatus == 0 then
                opennpcshowex(actor, 1003, 0, 2)
            end
        elseif npcId == 1003 then
            if mainTaskStatus == 0 then
                Player.updateProgress(actor, taskID, 1)
                setplaydef(actor, VarCfg["U_主线任务状态"], 1)
                return true
            elseif mainTaskStatus == 1 then
                banQfGotoNow(actor, 29, 88, 1)
            end
        end
        -- return true
    end
end
TaskRequestList[6] = function(actor, taskID, cfg, npcId)
    if taskID == 6 then
    local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if npcId == 1003 then
            if mainTaskStatus == 0 then
                mapmove(actor,"起源村",120,49,3)
                opennpcshowex(actor, 1004, 0, 2)
            end
        elseif npcId == 1004 then
            if mainTaskStatus == 0 or mainTaskStatus == 1 then
                -- ShiZhiLieXi-HuanJing
                local time = 180
                local myName = getbaseinfo(actor, ConstCfg.gbase.name)
                local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
                local x = getbaseinfo(actor, ConstCfg.gbase.x)
                local y = getbaseinfo(actor, ConstCfg.gbase.y)
                local newMapId = myName .. "古神祭坛"
                if checkmirrormap(newMapId) then
                    delmirrormap(newMapId)
                end
                addmirrormap("ShiZhiLieXi-HuanJing", newMapId, "古神祭坛", time, oldMapId, 015034, x, y)
                mapmove(actor, newMapId, 23, 28, 1)
                genmon(newMapId, 26, 26, "古神祭祀", 5, 10, 255)
                startautoattack(actor)
                changemode(actor,22,1)
                setplaydef(actor, cfg.recordVar[1], 0)
                setplaydef(actor, cfg.recordVar[2], 0)
                newchangetask(actor, taskID, 0, 0)
                if mainTaskStatus == 0 then
                    Player.updateProgress(actor, taskID, 1)
                    setplaydef(actor, VarCfg["U_主线任务状态"], 1)
                    return true
                end
            end
        elseif taskID == 6 then
            local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
            if mainTaskStatus == 2 then
                Player.nextTaskMain(actor, taskID, cfg)
                confertitle(actor, "牛马实习生", 1)
                mapmove(actor, ConstCfg.main_city, 339, 335, 1)
                return true
            end
        end
        -- return true
    end
end
TaskRequestList[7] = function(actor, taskID, cfg, npcId)
    if taskID == 7 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if npcId == 1005 then
            if mainTaskStatus == 0 then
                -- Player.updateProgress(actor, taskID, 1)
                Player.nextTaskMain(actor, taskID, cfg)
                setplaydef(actor, VarCfg["U_主线任务状态"], 0)
                navigation(actor,110,8,"继续任务")
                return true
            end
        end
    end
end
return TaskRequestList
