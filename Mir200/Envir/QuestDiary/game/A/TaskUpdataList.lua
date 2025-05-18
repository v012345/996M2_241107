--点击任务
local TaskUpdataList = {}
--入口
TaskUpdataList.init = function(actor, taskID, cfg, data)
    data = data or {}
    local func = TaskUpdataList[taskID]
    if func then
        return func(actor, taskID, cfg, data)
    end
end
--起源村杀怪
TaskUpdataList[2] = function(actor, taskID, cfg, data)
    if taskID == 2 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus ~= 1 then
            return
        end
        local monobj = data.monobj
        local objName = getbaseinfo(monobj,ConstCfg.gbase.name)
        --不存在的怪
        if objName == cfg.monster[1] or objName == cfg.monster[2] then
            local num1 = getplaydef(actor, cfg.recordVar[1])
            local num2 = getplaydef(actor, cfg.recordVar[2])
            if objName == cfg.monster[1] then
                if num1 < cfg.taskNeed[1] then
                    setplaydef(actor, cfg.recordVar[1], num1 + 1)
                    newchangetask(actor, taskID, num1 + 1, num2)
                    Player.sendmsgEx(actor, string.format("%s#249|已击杀|%s/%s#249",cfg.monster[1],num1 +1,cfg.taskNeed[1]))
                end
            end
            if objName == cfg.monster[2] then
                if num2 < cfg.taskNeed[2] then
                    setplaydef(actor, cfg.recordVar[2], num2 + 1)
                    newchangetask(actor, taskID, num1, num2 +1)
                    Player.sendmsgEx(actor, string.format("%s#249|已击杀|%s/%s#249",cfg.monster[2],num2 +1,cfg.taskNeed[2]))
                end
            end
            if num1 + 1 >= cfg.taskNeed[1] and num2 + 1 >= cfg.taskNeed[2] then
                Player.sendmsgEx(actor,"你已经完成了|[起源村击杀任务]#249")
                Player.updateProgress(actor, taskID, 2)
                setplaydef(actor, VarCfg["U_主线任务状态"], 2)
                -- opennpcshowex(actor, 1001, 0, 2)
                -- navigation(actor,110,taskID,"继续任务")
                return true
            end
        end
        
    end
end
TaskUpdataList[3] = function(actor, taskID, cfg, data)
    local itemName = data.itemName
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus ~= 1 then
            return
        end
        if itemName == cfg.monster[1] then
        local num1 = getplaydef(actor, cfg.recordVar[1])
        if num1 < cfg.taskNeed[1] then
            setplaydef(actor, cfg.recordVar[1], num1 + 1)
            newchangetask(actor, taskID, num1 + 1)
            Player.sendmsgEx(actor, string.format("%s#249|已采集|%s/%s#249",cfg.monster[1],num1 +1,cfg.taskNeed[1]))
        end
        if num1 + 1 >= cfg.taskNeed[1] then
            Player.sendmsgEx(actor,"你已经完成了|[采集清毒莲任务]#249")
            Player.updateProgress(actor, taskID, 2)
            setplaydef(actor, VarCfg["U_主线任务状态"], 2)
            -- opennpcshowex(actor, 1001, 0, 2)
            -- navigation(actor,110,taskID,"继续任务")
            return true
        end
    end
end

--杀钉耙猫
TaskUpdataList[4] = function(actor, taskID, cfg, data)
    if taskID == 4 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus ~= 1 then
            return
        end
        local monobj = data.monobj
        local objName = getbaseinfo(monobj, ConstCfg.gbase.name)
        if objName == "腐化的稻草人" or objName == "腐化的钉耙猫" then
            local num1 = getplaydef(actor, VarCfg["U_当前任务进度1"])
            if num1 < cfg.taskNeed[1] then
                newchangetask(actor, taskID, num1 + 1)
                setplaydef(actor, VarCfg["U_当前任务进度1"], num1 + 1)
                Player.sendmsgEx(actor, string.format("%s#249|已击杀|%s/%s#249", objName, num1 + 1, cfg.taskNeed[1]))
            end
            if num1 + 1 >= cfg.taskNeed[1] then
                Player.sendmsgEx(actor, "你已经完成了|[起源村击杀任务]#249|正在前往领取奖励...")
                Player.updateProgress(actor, taskID, 2)
                setplaydef(actor, VarCfg["U_主线任务状态"], 2)
                -- opennpcshowex(actor, 1002, 0, 2)
                -- navigation(actor,110,taskID,"继续任务")
                return true
            end
        end
    end
end
--收集通灵花粉和净化晶矿
TaskUpdataList[5] = function(actor, taskID, cfg, data)
    local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
    if mainTaskStatus ~= 1 then
        return
    end
    local itemName = data.itemName
    local num1 = getplaydef(actor, cfg.recordVar[1])
    local num2 = getplaydef(actor, cfg.recordVar[2])
    if itemName == cfg.items[1] then
        if num1 < cfg.taskNeed[1] then
            setplaydef(actor, cfg.recordVar[1], num1 + 1)
            newchangetask(actor, taskID, num1 + 1, num2)
            Player.sendmsgEx(actor, string.format("%s#249|已获得|%s/%s#249",cfg.items[1],num1 +1,cfg.taskNeed[1]))
        end
    end
    if itemName == cfg.items[2] then
        if num2 < cfg.taskNeed[2] then
            setplaydef(actor, cfg.recordVar[2], num2 + 1)
            newchangetask(actor, taskID, num1, num2 + 1)
            Player.sendmsgEx(actor, string.format("%s#249|已采集|%s/%s#249",cfg.items[2],num2 +1,cfg.taskNeed[2]))
        end
    end
    if num1 + 1 >= cfg.taskNeed[1] and num2 + 1 >= cfg.taskNeed[2] then
        Player.sendmsgEx(actor,"你已经完成了|[采集清毒莲任务]#249")
        Player.updateProgress(actor, taskID, 2)
        setplaydef(actor, VarCfg["U_主线任务状态"], 2)
        -- opennpcshowex(actor, 1001, 0, 2)
        -- navigation(actor,110,taskID,"继续任务")
        return true
    end
end
TaskUpdataList[6] = function(actor, taskID, cfg, data)
    if taskID == 6 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus ~= 1 then
            return
        end
        local monobj = data.monobj
        local objName = getbaseinfo(monobj,ConstCfg.gbase.name)
        --不存在的怪
        if objName == cfg.monster[1] or objName == cfg.monster[2] or objName == cfg.monster[3] then
            local num1 = getplaydef(actor, cfg.recordVar[1])
            local num2 = getplaydef(actor, cfg.recordVar[2])
            if objName == cfg.monster[1] then
                if num1 < cfg.taskNeed[1] then
                    setplaydef(actor, cfg.recordVar[1], num1 + 1)
                    newchangetask(actor, taskID, num1 + 1, num2)
                    Player.sendmsgEx(actor, string.format("%s#249|已击杀|%s/%s#249",cfg.monster[1],num1 +1,cfg.taskNeed[1]))
                    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
                    local monNum = getmoncount(mapId, -1, true)
                    if monNum == 0 then
                        scenevibration(actor,0,3,1)
                        genmon(mapId, 26, 26, "古神·阿古斯", 1, 1, 249)
                        sendcentermsg(actor, 250, 0, "[系统提示]：你击杀了所有的[古神祭祀],召唤出了[古神·阿古斯],请前往击杀!", 0, 8)
                    end
                end
            end
            if objName == cfg.monster[2] then
                if num2 < cfg.taskNeed[2] then
                    -- setplaydef(actor, cfg.recordVar[2], num2 + 1)
                    -- newchangetask(actor, taskID, num1, num2 +1)
                    -- Player.sendmsgEx(actor, string.format("%s#249|已击杀|%s/%s#249",cfg.monster[2],num2 +1,cfg.taskNeed[2]))
                    scenevibration(actor,0,3,1)
                    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
                    genmon(mapId, 26, 26, "古神·阿古斯·本体", 1, 1, 249)
                    sendcentermsg(actor, 250, 0, "[系统提示]：你击杀了所有的[古神·阿古斯],召唤出了[古神·阿古斯·本体],请前往击杀!", 0, 8)
                end
            end
            if objName == cfg.monster[3] then
                if num2 < cfg.taskNeed[2] then
                    setplaydef(actor, cfg.recordVar[2], num2 + 1)
                    newchangetask(actor, taskID, num1, num2 +1)
                    Player.sendmsgEx(actor, string.format("%s#249|已击杀|%s/%s#249",cfg.monster[3],num2 +1,cfg.taskNeed[2]))
                end
            end

            local num1 = getplaydef(actor, cfg.recordVar[1])
            local num2 = getplaydef(actor, cfg.recordVar[2])
            if num1 >= cfg.taskNeed[1] and num2 >= cfg.taskNeed[2] then
                Player.sendmsgEx(actor,"你已经完成了|[古神祭祀任务]#249")
                Player.updateProgress(actor, taskID, 2)
                setplaydef(actor, VarCfg["U_主线任务状态"], 2)
                -- opennpcshowex(actor, 1001, 0, 2)
                -- navigation(actor,110,taskID,"继续任务")
                return true
            end
        end 
    end
end
TaskUpdataList[7] = function(actor, taskID, cfg, data)
    if taskID == 7 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus == 1 then
            if FCheckMap(actor, cfg.map) then
                local num1 = getplaydef(actor, cfg.recordVar[1])
                if num1 < cfg.taskNeed[1] then
                    setplaydef(actor, cfg.recordVar[1], num1 + 1)
                    newchangetask(actor, taskID, num1 + 1)
                    Player.sendmsgEx(actor, string.format("已击杀怪物|%s/%s#249",num1 +1,cfg.taskNeed[1]))
                end
                if num1 + 1 >= cfg.taskNeed[1] then
                    Player.updateProgress(actor, taskID, 2)
                    setplaydef(actor, VarCfg["U_主线任务状态"], 2)
                    XiuXian.addXiuXian(actor, 150)
                    Player.sendmsgEx(actor, "恭喜你完成任务,获得|150修仙经验#249")
                    --如果已经升级了，直接开始下一个任务
                    local where = 43
                    local itemObj = linkbodyitem(actor, where)
                    if itemObj ~= "0" then
                        local itemName = getiteminfo(actor, itemObj, ConstCfg.iteminfo.name)
                        local level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29))
                        if level > 1 then
                            Player.sendmsgEx(actor, "你已经完成了提升修仙境界任务,直接开始下一个任务!")
                            Player.nextTaskMain(actor, taskID, cfg)
                            return true
                        end
                    end
                    return true
                end
            end
        end
    end
end
TaskUpdataList[200] = function(actor, taskID, cfg, data)
    local itemNum = getbagitemcount(actor, cfg.items[1])
    newchangetask(actor, taskID, itemNum)
end
return TaskUpdataList
