--点击任务
local TaskOnClickList = {}
--入口
TaskOnClickList.init = function(actor, taskID, cfg)
    local func = TaskOnClickList[taskID]
    if func then
        return func(actor, taskID, cfg)
    end
end
--第一个任务
TaskOnClickList[1] = function(actor, taskID, cfg)
    if taskID == 1 then
        opennpcshowex(actor, 1000, 0, 2)
        return true
    end
end

--主线起 源村2
TaskOnClickList[2] = function(actor, taskID, cfg)
    if taskID ~= 2 then
        return
    end
    local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
    if mainTaskStatus == 1 then
        banQfGotoNow(actor, 104, 219)
    elseif mainTaskStatus == 2 then
        opennpcshowex(actor, 1001, 0, 2)
    end
    return true
end

--采集清毒莲
TaskOnClickList[3] = function(actor, taskID, cfg)
    local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
    if mainTaskStatus == 1 then
        banQfGotoNow(actor, 98, 169, 0)
    elseif mainTaskStatus == 2 then
        opennpcshowex(actor, 1001, 0, 2)
    end
end

TaskOnClickList[4] = function(actor, taskID, cfg)
    if taskID == 4 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus == 0 then
            opennpcshowex(actor, 1002, 0, 2)
        elseif mainTaskStatus == 1 then
            banQfGotoNow(actor, 52, 171, 1)
        elseif mainTaskStatus == 2 then
            opennpcshowex(actor, 1002, 0, 2)
        end
        -- return true
    end
end
TaskOnClickList[5] = function(actor, taskID, cfg)
    if taskID == 5 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus == 0 then
            opennpcshowex(actor, 1003, 0, 2)
        elseif mainTaskStatus == 1 then
            banQfGotoNow(actor, 29, 88, 1)
        elseif mainTaskStatus == 2 then
            opennpcshowex(actor, 1003, 0, 2)
        end
        -- return true
    end
end
TaskOnClickList[6] = function(actor, taskID, cfg)
    if taskID == 6 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus == 0 then
            if FCheckNPCRange(actor, 1004, 20) then
                opennpcshowex(actor, 1004, 0, 2)
            else
                mapmove(actor, "起源村", 120, 49, 3)
                opennpcshowex(actor, 1004, 0, 2)
            end
        elseif mainTaskStatus == 1 then
            local myName = getbaseinfo(actor, ConstCfg.gbase.name)
            local newMapId = myName .. "古神祭坛"
            if FCheckMap(actor, newMapId) then
                Player.sendmsgEx(actor, "已在任务地图!")
                return
            end
            opennpcshowex(actor, 1004, 1, 2)
        elseif mainTaskStatus == 2 then
            mapmove(actor, "起源村", 93, 200, 3)
            opennpcshowex(actor, 1001, 0, 2)
        end
    end
end

TaskOnClickList[7] = function(actor, taskID, cfg)
    if taskID == 7 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
        if mainTaskStatus == 0 then
            local npcId = cfg.npcId
            FMoveNpc(actor, npcId, 10, "n3", 350, 339, 1)
        elseif mainTaskStatus == 1 then
            if FCheckMap(actor, cfg.map) then
                Player.sendmsgEx(actor, "你当前已在任务地图!")
                return
            end
            local npcId = 111
            FMoveNpc(actor, npcId, 10, "n3", 331, 331, 2)
        elseif mainTaskStatus == 2 then
            local client = getconst(actor, "<$CLIENTFLAG>")
            if client == "1" then
                navigation(actor, 104, 1000, "点击")
            else
                navigation(actor, 107, 1000, "点击")
            end
        end
    end
end
TaskOnClickList[8] = function(actor, taskID, cfg)
    local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
    if taskPanelID == 0 then
        setplaydef(actor,VarCfg["U_主线任务面板进度"],1)
    end
    ZhuXianRenWu.OpenUI(actor)
    
end

TaskOnClickList[200] = function(actor, taskID, cfg)
    Player.sendmsgEx(actor, "[超级护身符]#249|二大陆所有怪物均可爆出,BOSS爆率更高!")
end
TaskOnClickList[201] = function(actor, taskID, cfg)
    if taskID == 201 then
        local taskBuffId = 31036
        if hasbuff(actor, taskBuffId) then
            Player.sendmsgEx(actor, "极恶大陆地图均有分布...")
        elseif getflagstatus(actor, VarCfg["F_剧情_丹尘_采集任务完成"]) == 1 then
            opennpcshowex(actor, 504, 1, 3)
        end
    end
end
TaskOnClickList[202] = function(actor, taskID, cfg)
    if taskID == 202 then
        GameEvent.push(EventCfg.onClickTaskJieJiuShaoNv, actor, taskID)
    end
end
return TaskOnClickList
