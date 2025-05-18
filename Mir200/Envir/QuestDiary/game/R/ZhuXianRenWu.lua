ZhuXianRenWu = {}
ZhuXianRenWu.ID = "主线任务"
local npcID = 0
local config = include("QuestDiary/cfgcsv/cfg_ZhuXianRenWu.lua")             --配置
local GetTaskData = include("QuestDiary/game/R/ZhuXianRenWuGetTaskData.lua") --获取任务数据
local GotoTask = include("QuestDiary/game/R/ZhuXianRenWuGotoTask.lua")       --前往任务
local cost = { {} }
local give = { {} }

--判断当前是否完成任务
local function IsFinishTask(actor, taskPanelID, cfg)
    local data = {}
    if cfg then
        data = GetTaskData.GetData(actor, taskPanelID, cfg)
        for i, value in ipairs(data) do
            if table.isempty(value) then
                Player.sendmsgEx(actor, "领取失败,获取任务数据失败!#249")
                return false
            end
            local desc = cfg["show" .. i]
            local title = desc[1]
            for j, v in ipairs(value) do
                if type(v) == "table" then
                    if v[1] < v[2] then
                        Player.sendmsgEx(actor, string.format("领取失败|%s#249|未完成!", title))
                        return false
                    end
                elseif type(v) == "boolean" then
                    if not v then
                        Player.sendmsgEx(actor, string.format("领取失败|%s#249|未完成!", title))
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

--清空任务变量
local function ClearTaskvar(actor)
    setplaydef(actor, VarCfg["U_主线任务面板进度_1_1"], 0)
    setplaydef(actor, VarCfg["U_主线任务面板进度_1_2"], 0)
    setplaydef(actor, VarCfg["U_主线任务面板进度_2_1"], 0)
    setplaydef(actor, VarCfg["U_主线任务面板进度_2_2"], 0)
    setplaydef(actor, VarCfg["U_主线任务面板进度_3_1"], 0)
    setplaydef(actor, VarCfg["U_主线任务面板进度_3_2"], 0)
    setplaydef(actor, VarCfg["U_主线任务面板进度_4_1"], 0)
    setplaydef(actor, VarCfg["U_主线任务面板进度_4_2"], 0)
end

--接收请求
function ZhuXianRenWu.Request(actor)
    local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
    local cfg = config[taskPanelID]
    local isFinish = IsFinishTask(actor, taskPanelID, cfg)
    if isFinish then
        ClearTaskvar(actor)
        setplaydef(actor, VarCfg["U_主线任务面板进度"], cfg.next)
        local userId = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.giveMailByTable(userId, 8, "主线任务奖励", "完成[" .. cfg.name .. "]奖励!", cfg.reward, 1, true)
        Player.sendmsgEx(actor, "奖励已发到邮件,请注意查收")
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

--传送任务
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

--处理任务显示，防止前者大于后者
local function takeShow(data)
    for i = 1, #data do
        for j = 1, #data[i] do
            -- 确保是一个子数组并且是数字类型才进行处理
            if type(data[i][j]) == "table" and type(data[i][j][1]) == "number" and type(data[i][j][2]) == "number" then
                if data[i][j][1] > data[i][j][2] then
                    data[i][j][1] = data[i][j][2]
                end
            end
        end
    end
end

function ZhuXianRenWu.OpenUI(actor)
    local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
    local cfg = config[taskPanelID]
    local data = {}
    if cfg then
        data = GetTaskData.GetData(actor, taskPanelID, cfg)
    end
    -- dump(data)
    takeShow(data)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_OpenUI, taskPanelID, 0, 0, data)
    setflagstatus(actor, VarCfg["F_主线任务红点"],0)
end

--同步消息
function ZhuXianRenWu.SyncResponse(actor)
    local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
    local cfg = config[taskPanelID]
    local data = {}
    takeShow(data)
    if cfg then
        data = GetTaskData.GetData(actor, taskPanelID, cfg)
    end
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_SyncResponse, taskPanelID, 0, 0, data)
end

-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ZhuXianRenWu.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhuXianRenWu)
--杀怪触发
local function _onKillMon(actor, monobj, monName)
    local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
    local cfg = config[taskPanelID]
    if cfg then
        local ways = { cfg.way1, cfg.way2, cfg.way3, cfg.way4 }
        for _, way in ipairs(ways) do
            for _, value in ipairs(way) do
                local taskType = value[1] --去类型
                if taskType == 1 then     --等于1是杀怪
                    local mapID = value[2]
                    local name = value[3]
                    local var = value[4]
                    local max = value[5]
                    local varValu = getplaydef(actor, var)
                    if varValu < max then
                        if name == "无" then
                            if FCheckMap(actor, mapID) then
                                setplaydef(actor, var, varValu + 1)
                            end
                        else
                            if name == monName then
                                setplaydef(actor, var, varValu + 1)
                            end
                        end
                    elseif varValu == max then
                        if name == "无" then
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


--枚举等级对应的任务进度
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
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == taskID then
            FCheckTaskRedPoint(actor)
        end
    end
end
GameEvent.add(EventCfg.onPlayLevelUp, _onPlayLevelUp, ZhuXianRenWu)
-- 2^鸿蒙太初镜|
-- 2^噬魔两仪轮|
-- 2^五行炼魔壺|
-- 2^九宫龙皇钟|
local enumXiuXianTaskId = {
    ["鸿蒙太初镜"] = 1,
    ["噬魔两仪轮"] = 6,
    ["五行炼魔壺"] = 13,
    ["九宫龙皇钟"] = 27,
}
--处理修仙红点
local function _onXiuXianUP(actor, itemName)
    local taskID = enumXiuXianTaskId[itemName]
    if enumXiuXianTaskId then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == taskID then
            FCheckTaskRedPoint(actor)
        end
    end
end

GameEvent.add(EventCfg.onXiuXianUP, _onXiuXianUP, ZhuXianRenWu)

--处理获得称号红点
-- 7
-- 42
-- 45
-- 49
local enumTitleTaskId = {
    ["湿婆信徒"] = 7,
    ["武林高手"] = 9,
    ["江湖侠客"] = 21,
    ["风行者"] = 42,
    ["洪荒之力"] = 45,
    ["月光余晖"] = 49,
}
local function _onGetTaskTitle(actor, titleName)
    local titileIndexTaskID = enumTitleTaskId[titleName]
    if titileIndexTaskID then
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == titileIndexTaskID then
            FCheckTaskRedPoint(actor)
        end
    end
end

GameEvent.add(EventCfg.onGetTaskTitle, _onGetTaskTitle, ZhuXianRenWu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ZhuXianRenWu, ZhuXianRenWu)
return ZhuXianRenWu
