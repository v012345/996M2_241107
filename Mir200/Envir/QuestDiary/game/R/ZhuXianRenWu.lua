ZhuXianRenWu = {}
ZhuXianRenWu.ID = "��������"
local npcID = 0
local config = include("QuestDiary/cfgcsv/cfg_ZhuXianRenWu.lua")             --����
local GetTaskData = include("QuestDiary/game/R/ZhuXianRenWuGetTaskData.lua") --��ȡ��������
local GotoTask = include("QuestDiary/game/R/ZhuXianRenWuGotoTask.lua")       --ǰ������
local cost = { {} }
local give = { {} }

--�жϵ�ǰ�Ƿ��������
local function IsFinishTask(actor, taskPanelID, cfg)
    local data = {}
    if cfg then
        data = GetTaskData.GetData(actor, taskPanelID, cfg)
        for i, value in ipairs(data) do
            if table.isempty(value) then
                Player.sendmsgEx(actor, "��ȡʧ��,��ȡ��������ʧ��!#249")
                return false
            end
            local desc = cfg["show" .. i]
            local title = desc[1]
            for j, v in ipairs(value) do
                if type(v) == "table" then
                    if v[1] < v[2] then
                        Player.sendmsgEx(actor, string.format("��ȡʧ��|%s#249|δ���!", title))
                        return false
                    end
                elseif type(v) == "boolean" then
                    if not v then
                        Player.sendmsgEx(actor, string.format("��ȡʧ��|%s#249|δ���!", title))
                        return false
                    end
                end
            end
        end
    else
        return false
    end
    return true
end

--����������
local function ClearTaskvar(actor)
    setplaydef(actor, VarCfg["U_��������������_1_1"], 0)
    setplaydef(actor, VarCfg["U_��������������_1_2"], 0)
    setplaydef(actor, VarCfg["U_��������������_2_1"], 0)
    setplaydef(actor, VarCfg["U_��������������_2_2"], 0)
    setplaydef(actor, VarCfg["U_��������������_3_1"], 0)
    setplaydef(actor, VarCfg["U_��������������_3_2"], 0)
    setplaydef(actor, VarCfg["U_��������������_4_1"], 0)
    setplaydef(actor, VarCfg["U_��������������_4_2"], 0)
end

--��������
function ZhuXianRenWu.Request(actor)
    local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
    local cfg = config[taskPanelID]
    local isFinish = IsFinishTask(actor, taskPanelID, cfg)
    if isFinish then
        ClearTaskvar(actor)
        setplaydef(actor, VarCfg["U_��������������"], cfg.next)
        local userId = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.giveMailByTable(userId, 8, "����������", "���[" .. cfg.name .. "]����!", cfg.reward, 1, true)
        Player.sendmsgEx(actor, "�����ѷ����ʼ�,��ע�����")
        ZhuXianRenWu.SyncResponse(actor)
    end
end

local function CheckTaskIsFinish(taskData)
    if type(taskData) == "table" then
        if taskData[1] < taskData[2] then
            return false
        end
    elseif type(taskData) == "boolean" then
        if not taskData then
            return false
        end
    else
        return false
    end
    return true
end

--��������
function ZhuXianRenWu.Goto(actor, index, wayID)
    local cfg = config[index]
    if not cfg then
        return
    end
    local ways = cfg["way" .. wayID]
    local taskDatas = GetTaskData.getTaskDatas(actor, index, ways)
    for index, value in ipairs(taskDatas) do
        if not CheckTaskIsFinish(value) then
            local way = ways[index]
            local taskType = way[1]
            local func = GotoTask[taskType]
            if func then
                func(actor, index, way, cfg)
            end
            break
        end
    end
end

--����������ʾ����ֹǰ�ߴ��ں���
local function takeShow(data)
    for i = 1, #data do
        for j = 1, #data[i] do
            -- ȷ����һ�������鲢�����������ͲŽ��д���
            if type(data[i][j]) == "table" and type(data[i][j][1]) == "number" and type(data[i][j][2]) == "number" then
                if data[i][j][1] > data[i][j][2] then
                    data[i][j][1] = data[i][j][2]
                end
            end
        end
    end
end

function ZhuXianRenWu.OpenUI(actor)
    local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
    local cfg = config[taskPanelID]
    local data = {}
    if cfg then
        data = GetTaskData.GetData(actor, taskPanelID, cfg)
    end
    -- dump(data)
    takeShow(data)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_OpenUI, taskPanelID, 0, 0, data)
    setflagstatus(actor, VarCfg["F_����������"],0)
end

--ͬ����Ϣ
function ZhuXianRenWu.SyncResponse(actor)
    local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
    local cfg = config[taskPanelID]
    local data = {}
    takeShow(data)
    if cfg then
        data = GetTaskData.GetData(actor, taskPanelID, cfg)
    end
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_SyncResponse, taskPanelID, 0, 0, data)
end

-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ZhuXianRenWu.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhuXianRenWu)
--ɱ�ִ���
local function _onKillMon(actor, monobj, monName)
    local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
    local cfg = config[taskPanelID]
    if cfg then
        local ways = { cfg.way1, cfg.way2, cfg.way3, cfg.way4 }
        for _, way in ipairs(ways) do
            for _, value in ipairs(way) do
                local taskType = value[1] --ȥ����
                if taskType == 1 then     --����1��ɱ��
                    local mapID = value[2]
                    local name = value[3]
                    local var = value[4]
                    local max = value[5]
                    local varValu = getplaydef(actor, var)
                    if varValu < max then
                        if name == "��" then
                            if FCheckMap(actor, mapID) then
                                setplaydef(actor, var, varValu + 1)
                            end
                        else
                            if name == monName then
                                setplaydef(actor, var, varValu + 1)
                            end
                        end
                    elseif varValu == max then
                        if name == "��" then
                            if FCheckMap(actor, mapID) then
                                FCheckTaskRedPoint(actor)
                                setplaydef(actor, var, varValu + 1)
                            end
                        else
                            if name == monName then
                                FCheckTaskRedPoint(actor)
                                setplaydef(actor, var, varValu + 1)
                            end
                        end
                    end
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, ZhuXianRenWu)


--ö�ٵȼ���Ӧ���������
local enumLevelTaskId = {
   [60] = 1,
   [100] = 5,
   [120] = 12,
   [130] = 14,
   [150] = 16,
   [180] = 20,
   [220] = 23,
   [240] = 28,
}
local function _onPlayLevelUp(actor, cur_level, before_level)
    local taskID = enumLevelTaskId[cur_level]
    if taskID then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == taskID then
            FCheckTaskRedPoint(actor)
        end
    end
end
GameEvent.add(EventCfg.onPlayLevelUp, _onPlayLevelUp, ZhuXianRenWu)
-- 2^����̫����|
-- 2^��ħ������|
-- 2^������ħ��|
-- 2^�Ź�������|
local enumXiuXianTaskId = {
    ["����̫����"] = 1,
    ["��ħ������"] = 6,
    ["������ħ��"] = 13,
    ["�Ź�������"] = 27,
}
--�������ɺ��
local function _onXiuXianUP(actor, itemName)
    local taskID = enumXiuXianTaskId[itemName]
    if enumXiuXianTaskId then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == taskID then
            FCheckTaskRedPoint(actor)
        end
    end
end

GameEvent.add(EventCfg.onXiuXianUP, _onXiuXianUP, ZhuXianRenWu)

--�����óƺź��
-- 7
-- 42
-- 45
-- 49
local enumTitleTaskId = {
    ["ʪ����ͽ"] = 7,
    ["���ָ���"] = 9,
    ["��������"] = 21,
    ["������"] = 42,
    ["���֮��"] = 45,
    ["�¹�����"] = 49,
}
local function _onGetTaskTitle(actor, titleName)
    local titileIndexTaskID = enumTitleTaskId[titleName]
    if titileIndexTaskID then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == titileIndexTaskID then
            FCheckTaskRedPoint(actor)
        end
    end
end

GameEvent.add(EventCfg.onGetTaskTitle, _onGetTaskTitle, ZhuXianRenWu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ZhuXianRenWu, ZhuXianRenWu)
return ZhuXianRenWu
