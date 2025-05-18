Task = {}
Task.ID = "����ģ��"
local config = include("QuestDiary/cfgcsv/cfg_Task.lua") --��������
local TaskOnClickList = include("QuestDiary/game/A/TaskOnClickList.lua") --�������ִ��
local TaskRequestList = include("QuestDiary/game/A/TaskRequestList.lua") --�������ִ��NPC����
local TaskUpdataList = include("QuestDiary/game/A/TaskUpdataList.lua")   --��������ִ��
local TaskClickNpc = include("QuestDiary/game/A/TaskClickNpc.lua")   --NPC�������
local cfg_TaskPickItemsById = include("QuestDiary/cfgcsv/cfg_TaskPickItemsById.lua") --��������
local cfg_TaskPickItemsByName = include("QuestDiary/cfgcsv/cfg_TaskPickItemsByName.lua") --��������

--��������״̬
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
            newpicktask(actor, taskID)                                                                       --����δ��ʼ
        elseif value.progress == 1 then
            newchangetask(actor, taskID, schedule[1] or 0, schedule[2] or 0, schedule[3] or 0,
                schedule[4] or 0)                                                                            --���������
            if cfg.loginUpdata == 1 then
                TaskUpdataList.init(actor, taskID, cfg, {})
            end
        elseif value.progress == 2 then
            newcompletetask(actor, taskID)                                                                   --�������
        end
    end
end

--��������״̬������������������Ҫ������ʾ
local function updataTaskOther(actor)
    local allTask = Player.getJsonTableByVar(actor, VarCfg["T_��¼����"]) or {}
    for taskID, value in pairs(allTask) do
        taskID = tonumber(taskID)
        local cfg = config[taskID] or {}
        if value.progress == 1 then --���������
            if cfg.loginUpdata == 1 then
                TaskUpdataList.init(actor, taskID, cfg, {})
            end
        end
    end
end

--��������NPC��������
function Task.Request(actor, npcId)
    local taskID = getplaydef(actor, VarCfg["U_�����������"])
    local cfg = config[taskID]
    local result = TaskRequestList.init(actor, taskID ,cfg, npcId)
    if result then
        --ͬ������״̬
        Task.SyncResponse(actor)
    end
end

--ͬ��������Ϣ
function Task.SyncResponse(actor, logindatas)
    local data = {}
    local taskInfo = {}
    taskInfo.mainTaskProgress = getplaydef(actor, VarCfg["U_�����������"])
    taskInfo.sideTaskProgress = getplaydef(actor, VarCfg["U_֧���������"])
    taskInfo.finishCount = getplaydef(actor, VarCfg["U_������ɴ���"])
    taskInfo.curTaskProgress1 = getplaydef(actor, VarCfg["U_��ǰ�������1"])
    taskInfo.curTaskProgress2 = getplaydef(actor, VarCfg["U_��ǰ�������2"])
    taskInfo.curTaskProgress3 = getplaydef(actor, VarCfg["U_��ǰ�������3"])
    taskInfo.curTaskProgress4 = getplaydef(actor, VarCfg["U_��ǰ�������4"])
    taskInfo.mainTaskStatus = getplaydef(actor, VarCfg["U_��������״̬"])
    taskInfo.sideTaskStatus = getplaydef(actor, VarCfg["U_֧������״̬"])
    data.taskInfo = taskInfo
    data.allTask = Player.getJsonTableByVar(actor, VarCfg["T_��¼����"]) or {}
    local _login_data = { ssrNetMsgCfg.Task_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.Task_SyncResponse, 0, 0, 0, data)
    end
    --ͬ����ǰ������ʾ״̬
    updataTask(actor, data.allTask)
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    if getplaydef(actor, VarCfg["U_�����������"]) == 0 then
        setplaydef(actor, VarCfg["U_�����������"], 1)
        Player.addTask(actor, 1, 0)
    end
    if getplaydef(actor, VarCfg["U_֧���������"]) == 0 then
        setplaydef(actor, VarCfg["U_֧���������"], 1)
    end
    Task.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, Task)

--������񴥷�
local function _onClickNewTask(actor, taskID)
    local cfg = config[taskID]
    local result = TaskOnClickList.init(actor, taskID ,cfg)
    if result then
        Task.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onClickNewTask, _onClickNewTask, Task)

--ɱ�ִ���
local function _onKillMon(actor, monobj)
    local taskID = getplaydef(actor, VarCfg["U_�����������"])
    local cfg = config[taskID]
    if cfg then
        --2��ɱ������
        if cfg.taskType == 2 then
            local data = {monobj = monobj}
            local result = TaskUpdataList.init(actor, taskID, cfg, data)
            --�������ͬ��һ������
            if result then
                Task.SyncResponse(actor)
                if cfg.isYinDao == 1 then
                    navigation(actor,110,taskID,"��������")
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, Task)

--���NPC����
local function _onClicknpc(actor, npcid, npcobj)
    local taskID = getplaydef(actor, VarCfg["U_�����������"])
    local cfg = config[taskID]
    local result = TaskClickNpc.init(actor, npcid, taskID, cfg)
    if result then
        Task.SyncResponse(actor)
    end

end
GameEvent.add(EventCfg.onClicknpc, _onClicknpc, Task)

--�ɼ��������߻�ȡ������Ʒ����
local function _onCollectTask(actor, itemName, monMakeIndex)
    local taskID = getplaydef(actor, VarCfg["U_�����������"])
    local cfg = config[taskID]
    local data = {itemName = itemName}
    if cfg then
        if cfg.taskType == 5 then
            local result = TaskUpdataList.init(actor, taskID, cfg, data)
            if result then
                Task.SyncResponse(actor)
                if cfg.isYinDao == 1 then
                    navigation(actor,110,taskID,"��������")
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onCollectTask, _onCollectTask, Task)

--��ȡ����
local function _goPickUpItemEx(actor, itemobj, itemidx, itemMakeIndex)
    local cfg = cfg_TaskPickItemsById[itemidx]
    if cfg then
        updataTaskOther(actor)
    end
end
GameEvent.add(EventCfg.goPickUpItemEx, _goPickUpItemEx, Task)

--�ӵ�����
local function _goDropItemEx(actor, itemobj, itemName)
    local cfg = cfg_TaskPickItemsByName[itemName]
    if cfg then
        updataTaskOther(actor)
    end
end
GameEvent.add(EventCfg.goDropItemEx, _goDropItemEx, Task)

Message.RegisterNetMsg(ssrNetMsgCfg.Task, Task)
return Task