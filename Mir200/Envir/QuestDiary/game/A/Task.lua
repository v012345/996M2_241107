Task = {}
Task.ID = "任务模块"
local config = include("QuestDiary/cfgcsv/cfg_Task.lua") --任务配置
local TaskOnClickList = include("QuestDiary/game/A/TaskOnClickList.lua") --点击任务执行
local TaskRequestList = include("QuestDiary/game/A/TaskRequestList.lua") --点击任务执行NPC界面
local TaskUpdataList = include("QuestDiary/game/A/TaskUpdataList.lua")   --更新任务执行
local TaskClickNpc = include("QuestDiary/game/A/TaskClickNpc.lua")   --NPC点击触发
local cfg_TaskPickItemsById = include("QuestDiary/cfgcsv/cfg_TaskPickItemsById.lua") --任务配置
local cfg_TaskPickItemsByName = include("QuestDiary/cfgcsv/cfg_TaskPickItemsByName.lua") --任务配置

--更新任务状态
local function updataTask(actor, allTask)
    for taskID, value in pairs(allTask) do
        taskID = tonumber(taskID)
        local cfg = config[taskID] or {}
        local recordVar = cfg.recordVar or {}
        local schedule = {}
        for _, v in ipairs(recordVar) do
            table.insert(schedule, getplaydef(actor, v))
        end
        if value.progress == 0 then
            newpicktask(actor, taskID)                                                                       --任务未开始
        elseif value.progress == 1 then
            newchangetask(actor, taskID, schedule[1] or 0, schedule[2] or 0, schedule[3] or 0,
                schedule[4] or 0)                                                                            --任务进行中
            if cfg.loginUpdata == 1 then
                TaskUpdataList.init(actor, taskID, cfg, {})
            end
        elseif value.progress == 2 then
            newcompletetask(actor, taskID)                                                                   --完成任务
        end
    end
end

--更新任务状态，其他非主线任务，主要更新显示
local function updataTaskOther(actor)
    local allTask = Player.getJsonTableByVar(actor, VarCfg["T_记录任务"]) or {}
    for taskID, value in pairs(allTask) do
        taskID = tonumber(taskID)
        local cfg = config[taskID] or {}
        if value.progress == 1 then --任务进行中
            if cfg.loginUpdata == 1 then
                TaskUpdataList.init(actor, taskID, cfg, {})
            end
        end
    end
end

--主线任务NPC请求任务
function Task.Request(actor, npcId)
    local taskID = getplaydef(actor, VarCfg["U_主线任务进度"])
    local cfg = config[taskID]
    local result = TaskRequestList.init(actor, taskID ,cfg, npcId)
    if result then
        --同步任务状态
        Task.SyncResponse(actor)
    end
end

--同步任务信息
function Task.SyncResponse(actor, logindatas)
    local data = {}
    local taskInfo = {}
    taskInfo.mainTaskProgress = getplaydef(actor, VarCfg["U_主线任务进度"])
    taskInfo.sideTaskProgress = getplaydef(actor, VarCfg["U_支线任务进度"])
    taskInfo.finishCount = getplaydef(actor, VarCfg["U_剧情完成次数"])
    taskInfo.curTaskProgress1 = getplaydef(actor, VarCfg["U_当前任务进度1"])
    taskInfo.curTaskProgress2 = getplaydef(actor, VarCfg["U_当前任务进度2"])
    taskInfo.curTaskProgress3 = getplaydef(actor, VarCfg["U_当前任务进度3"])
    taskInfo.curTaskProgress4 = getplaydef(actor, VarCfg["U_当前任务进度4"])
    taskInfo.mainTaskStatus = getplaydef(actor, VarCfg["U_主线任务状态"])
    taskInfo.sideTaskStatus = getplaydef(actor, VarCfg["U_支线任务状态"])
    data.taskInfo = taskInfo
    data.allTask = Player.getJsonTableByVar(actor, VarCfg["T_记录任务"]) or {}
    local _login_data = { ssrNetMsgCfg.Task_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.Task_SyncResponse, 0, 0, 0, data)
    end
    --同步当前任务显示状态
    updataTask(actor, data.allTask)
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    if getplaydef(actor, VarCfg["U_主线任务进度"]) == 0 then
        setplaydef(actor, VarCfg["U_主线任务进度"], 1)
        Player.addTask(actor, 1, 0)
    end
    if getplaydef(actor, VarCfg["U_支线任务进度"]) == 0 then
        setplaydef(actor, VarCfg["U_支线任务进度"], 1)
    end
    Task.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, Task)

--点击任务触发
local function _onClickNewTask(actor, taskID)
    local cfg = config[taskID]
    local result = TaskOnClickList.init(actor, taskID ,cfg)
    if result then
        Task.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onClickNewTask, _onClickNewTask, Task)

--杀怪触发
local function _onKillMon(actor, monobj)
    local taskID = getplaydef(actor, VarCfg["U_主线任务进度"])
    local cfg = config[taskID]
    if cfg then
        --2是杀怪任务
        if cfg.taskType == 2 then
            local data = {monobj = monobj}
            local result = TaskUpdataList.init(actor, taskID, cfg, data)
            --完成任务同步一次数据
            if result then
                Task.SyncResponse(actor)
                if cfg.isYinDao == 1 then
                    navigation(actor,110,taskID,"继续任务")
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, Task)

--点击NPC触发
local function _onClicknpc(actor, npcid, npcobj)
    local taskID = getplaydef(actor, VarCfg["U_主线任务进度"])
    local cfg = config[taskID]
    local result = TaskClickNpc.init(actor, npcid, taskID, cfg)
    if result then
        Task.SyncResponse(actor)
    end

end
GameEvent.add(EventCfg.onClicknpc, _onClicknpc, Task)

--采集触发或者获取任务物品触发
local function _onCollectTask(actor, itemName, monMakeIndex)
    local taskID = getplaydef(actor, VarCfg["U_主线任务进度"])
    local cfg = config[taskID]
    local data = {itemName = itemName}
    if cfg then
        if cfg.taskType == 5 then
            local result = TaskUpdataList.init(actor, taskID, cfg, data)
            if result then
                Task.SyncResponse(actor)
                if cfg.isYinDao == 1 then
                    navigation(actor,110,taskID,"继续任务")
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onCollectTask, _onCollectTask, Task)

--捡取触发
local function _goPickUpItemEx(actor, itemobj, itemidx, itemMakeIndex)
    local cfg = cfg_TaskPickItemsById[itemidx]
    if cfg then
        updataTaskOther(actor)
    end
end
GameEvent.add(EventCfg.goPickUpItemEx, _goPickUpItemEx, Task)

--扔掉触发
local function _goDropItemEx(actor, itemobj, itemName)
    local cfg = cfg_TaskPickItemsByName[itemName]
    if cfg then
        updataTaskOther(actor)
    end
end
GameEvent.add(EventCfg.goDropItemEx, _goDropItemEx, Task)

Message.RegisterNetMsg(ssrNetMsgCfg.Task, Task)
return Task