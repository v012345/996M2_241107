local ZhanJiangDuoQi = {}
ZhanJiangDuoQi.ID = "ս������"
local npcID = 128
local config = include("QuestDiary/game/KuaFu/ZhanJiangDuoQi_Data_Config.lua") --����
local cfg_ZhanJiangDuoQiPersonReward = include("QuestDiary/cfgcsv/cfg_ZhanJiangDuoQiPersonReward.lua") --����
local cfg_ZhanJiangDuoQiGuildReward = include("QuestDiary/cfgcsv/cfg_ZhanJiangDuoQiGuildReward.lua") --����
local campaignName = "ն������"
local dataVar = "ն����������"
local rankVar = "ն����������"
local areaDataTemp = "ն������ռ������"
local personDataTemp = "ն�������������"
local guildDataTemp = "ն�������л�����"
local rewardDataTemp = "ն�������콱����"
local npcVar = { "A33", "A32", "A31", "A30", "A29", "A28", "A27", "A26", "A25", "A24", "A23", "A22", "A21" }
local campaignData --�����
local personData   --�������
--��ȡն����������
local function _getData()
    if not campaignData then
        campaignData = Player.GetGlobalTempTable2(dataVar)
    end
    return campaignData
end
--����ն����������
local function _setData(data)
    Player.SetGlobalTempTable2(dataVar, data)
    campaignData = data
end

--��ȡ��������
local function _getPersonData()
    if not personData then
        personData = Player.GetGlobalTempTable2(personDataTemp)
    end
    return personData
end

--������������
local function _setPersonData(data)
    Player.SetGlobalTempTable2(personDataTemp, data)
    personData = data
end

--�������ĵ�ռ���л�
local function _setFlagGuiName(varName, guiName)
    if guiName == "" then
        guiName = "δռ��"
    end
    setsysvar(varName, "���ĵ�\\" .. guiName)
end

--�ص���ȫ
local function _back2BornPoint(actor, areaIndex)
    local x = math.random(config.BornPoint[areaIndex].x[1], config.BornPoint[areaIndex].x[2])
    local y = math.random(config.BornPoint[areaIndex].y[1], config.BornPoint[areaIndex].y[2])
    mapmove(actor, config.Map, x, y, 1)
end

--�������� ÿ�����1��
local tPersonRankByName = {}
local tGuildRankByName = {}
local function _rankSort()
    local tGuildData = Player.GetGlobalTempTable2(guildDataTemp)
    local tPersonData = _getPersonData()

    local function compare(a, b)
        if a[2] == b[2] then
            return a[3] < b[3]
        else
            return a[2] > b[2]
        end
    end

    local tGuildRank = {}
    local tPersonRank = {}

    for guildName, v in pairs(tGuildData) do
        local score = v.score or 0
        local scoreTime = v.scoreTime or 0
        tGuildRank[#tGuildRank + 1] = { guildName, score, scoreTime }
    end

    for playerName, v in pairs(tPersonData) do
        local score = v.score or 0
        local scoreTime = v.scoreTime or 0
        tPersonRank[#tPersonRank + 1] = { playerName, score, scoreTime }
    end

    table.sort(tGuildRank, compare)
    table.sort(tPersonRank, compare)

    for i = 1, #tGuildRank do
        tGuildRankByName[tGuildRank[i][1]] = i
    end

    for i = 1, #tPersonRank do
        tPersonRankByName[tPersonRank[i][1]] = i
    end
    return tGuildRank, tPersonRank
end

--��ȡ����
local function _findSelfRank(name, tRank)
    for i = 1, #tRank do
        if tRank[i][1] == name then
            return i
        end
    end
    return 0
end
--����ն������ --��Ҫ�������
local function _onKFZhanJiangDuoQiEnter(actor)
    local playerName = Player.GetName(actor)
    local guildName = Player.GetGuildName(actor)

    if not guildName or guildName == "" then
        Player.sendmsgEx(actor, "��û�м����лᣬ�޷��μӻ!#249")
        --û���л�
        return
    end

    local mapKey = Player.MapKey(actor)
    if config.Map == mapKey then
        Player.sendmsgEx(actor, "���ڻ��ͼ!#249")
        return
    end

    --�жϻ�Ƿ��ڽ�����
    if getsysvar(VarCfg["G_ն������"]) == 0 then
        --��ǰû�п����
        Player.sendmsgEx(actor, "��ǰû�п����!#249")
        return
    end
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    sendmsg("0", 2, '{"Msg":"[' .. name .. ']�μ���ն������","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","X":"-300"}')
    local data = _getData()
    local tGuildData = Player.GetGlobalTempTable2(guildDataTemp)
    local tPersonData = _getPersonData()

    local playerCode = data.playerCode or 100
    local guildCode = data.guildCode or 0
    local colorIndex = data.colorIndex or 1

    if not tPersonData[playerName] or not tGuildData[guildName] then
        --�״ν���
        if not tPersonData[playerName] then
            playerCode = playerCode + 1
            tPersonData[playerName] = { order = playerCode }
        end

        if not tGuildData[guildName] then
            guildCode = guildCode + 1
            if not config.BornPoint[guildCode] then
                guildCode = 1
            end
            tGuildData[guildName] = { areaIndex = guildCode, color = colorIndex }
            colorIndex = colorIndex + 1

            if colorIndex > #config.GuildColor then
                --ѭ��
                colorIndex = 1
            end
        end

        data.playerCode = playerCode
        data.guildCode = guildCode
        data.colorIndex = colorIndex

        _setPersonData(tPersonData)
        _setData(data)
        Player.SetGlobalTempTable2(guildDataTemp, tGuildData)
    else
        tPersonData[playerName].score = tPersonData[playerName].score or 0
        if tPersonData[playerName].score > 0 then
            local subScore = math.ceil(tPersonData[playerName].score * config.ReturnSubScorePct / 100)
            tPersonData[playerName].score = math.max(tPersonData[playerName].score - subScore, 0)
            tPersonData[playerName].scoreTime = os.time()
            _setData(data)
            _setPersonData(tPersonData)
            Player.sendmsgEx(actor, string.format("�˳����ͼ�����½���,�۳�|%d%%#249|����!", config.ReturnSubScorePct))
        end
    end

    --����
    if mapKey ~= config.Map then
        local areaIndex = tGuildData[guildName].areaIndex % #config.BornPoint + 1
        _back2BornPoint(actor, areaIndex)
    end

    Player.SetNameColor(actor, config.GuildColor[tGuildData[guildName].color])
end
GameEvent.add(EventCfg.onKFZhanJiangDuoQiEnter, _onKFZhanJiangDuoQiEnter, ZhanJiangDuoQi)

function ZhanJiangDuoQi.Exit(actor)
    FMapMoveEx(actor, "kuafu2", 139, 160, 1)
end

--�ӳ����ù�Ȧ��ɫ
function zjdq_delay_addmapEffect(actor, mapEffectIndex, mapKey, x, y, id, time, mode)
    mapEffectIndex = tonumber(mapEffectIndex)
    x = tonumber(x)
    y = tonumber(y)
    id = tonumber(id)
    time = tonumber(time)
    mode = tonumber(mode)
    callscriptex(actor, "MAPEFFECT", mapEffectIndex, mapKey, x, y, id, time, mode, 0)
end

-- tempOwnGuildName --��ʱ�л�
-- ownGuildName --��ǰռ��
-- topGuildName --��ǰ�л�����
--�����ʾ ռ�������
local function _updateProgressbar(tPlayerList, areaName, curProgress, maxProgress, tempOwnGuildName, ownGuildName,
                                  topGuildName, speed, leftLimitTime)
    local data = {
        ["areaName"] = areaName,
        ["curProgress"] = curProgress,
        ["maxProgress"] = maxProgress,
        ["tempOwnGuildName"] = tempOwnGuildName,
        ["ownGuildName"] = ownGuildName,
        ["topGuildName"] = topGuildName,
        ["speed"] = speed,
        ["leftLimitTime"] = leftLimitTime,
    }
    --tPlayers:ȫ��ͼ����б�
    leftLimitTime = leftLimitTime or 0
    for i = 1, #tPlayerList do
        --����������
        Message.sendmsg(tPlayerList[i], ssrNetMsgCfg.ZhanJiangDuoQi_UpdateProgressbar, 0, 0, 0, data)
    end
end

--���ִ�� ÿ��ִ��
local function _onKFZhanJiangDuoQiSync()
    --��ȡ���������ʱ��
    local leftTime = GetSecondsUntil21()

    local function compare(a, b)
        return a[2] > b[2]
    end
    --��ȡ���ͼ���������
    local tMapPlayerList = Player.GetMapPlayerList(config.Map)
    local tFlagPlayers = {}
    --��ȡ�����
    local data = _getData()
    --��ȡ�ʣ�൹��ʱ
    data.LeftTime = leftTime
    --��ʼ��������������ݡ�
    local tFlagAreaData = data.tFlagAreaData or {}
    --��ȡ��ǰʱ��
    local nowTime = os.time()
    --��ȡ��������
    local tPersonData = _getPersonData()
    --��ȡ�л�����
    local tGuildData = Player.GetGlobalTempTable2(guildDataTemp)

    --�ж�ÿ����������
    for i = 1, #config.FlagArea do
        local areaName = config.FlagArea[i][1]    --���ĵ�����
        local maxProgress = config.FlagArea[i][4] --��Ҫռ�����
        local basicSpeed = config.FlagArea[i][5]  --����ռ���ٶ�
        local tThisAreaData = tFlagAreaData[areaName] or {}

        local canOccupy = true --��ǵ�ǰ�����Ƿ�ɱ�ռ�졣
        --�����ռ�������̨
        if config.FlagArea[i].timeLimit then
            local runTime = nowTime - data.StartTick
            if runTime < config.FlagArea[i].timeLimit then
                --δ����ռ��ʱ��
                tThisAreaData.LeftLimitTime = config.FlagArea[i].timeLimit - runTime
                canOccupy = false
            end
        end
        --��ȡռ�������ڵ����
        local tPlayerList = Player.GetMapPlayerList(config.Map, config.FlagArea[i][2][1], config.FlagArea[i][2][2],
            config.FlagArea[i][2][3])
        for j = 1, #tPlayerList do
            tFlagPlayers[tostring(tPlayerList[j])] = true
        end
        --�������ռ��
        if canOccupy then
            local ownGuildName = tThisAreaData.GuildName or ""         --��ǰռ��
            local tempOwnGuildName = tThisAreaData.TempGuildName or "" --��ʱռ��
            local curProgress = tThisAreaData.Progress or 0            --��ǰռ�����

            --��¼ÿ���л��ڸ������ڵ����������
            local tGuildPlayerAmount = {}
            for j = 1, #tPlayerList do
                local playerName = getbaseinfo(tPlayerList[j], 1)
                if tPersonData[playerName] then
                    local guildName = getbaseinfo(tPlayerList[j], 36)
                    tGuildPlayerAmount[guildName] = tGuildPlayerAmount[guildName] or 0
                    tGuildPlayerAmount[guildName] = tGuildPlayerAmount[guildName] + 1
                end
            end

            -- ���л�Ͷ�Ӧ���������ת��Ϊ�б��Ա�����
            local tGuildPlayerRank = {}
            for guildName, amount in pairs(tGuildPlayerAmount) do
                tGuildPlayerRank[#tGuildPlayerRank + 1] = { guildName, amount }
            end

            table.sort(tGuildPlayerRank, compare)

            local topGuildName = ""          --��ǰ������������������л����ơ�
            local topGuildPlayerAmount = 0   --���л��ڸ������ڵ����������
            local otherGuildPlayerAmount = 0 --�����л��ڸ������ڵ������������
            if tGuildPlayerRank[1] then
                topGuildName = tGuildPlayerRank[1][1]
                topGuildPlayerAmount = tGuildPlayerRank[1][2]
            end

            for j = 2, #tGuildPlayerRank do
                otherGuildPlayerAmount = otherGuildPlayerAmount + tGuildPlayerRank[j][2]
            end
            --����ռ����ȵı仯
            local speed = 0
            if ownGuildName ~= "" then
                --�Ѿ����л�ռ��
                if ownGuildName ~= topGuildName then
                    --�뵱ǰ��������л᲻һ��
                    --�����ٶȼ�ռ�����
                    speed = basicSpeed * (topGuildPlayerAmount - otherGuildPlayerAmount)
                    if speed > 0 then
                        --�ٶȴ���0
                        curProgress = curProgress - speed
                        if curProgress < 0 then
                            --ռ���л���� ��ʱռ���л��Ϊ���������л�
                            curProgress = math.abs(curProgress)
                            ownGuildName = ""
                            tempOwnGuildName = topGuildName
                        end
                    end
                else
                    --�뵱ǰ��������л�һ��
                    --�����ٶ�����ռ�����
                    speed = basicSpeed * (topGuildPlayerAmount - otherGuildPlayerAmount)
                    if speed > 0 then
                        --�ٶȴ���0
                        curProgress = curProgress + speed
                        curProgress = math.min(maxProgress, curProgress)
                    end
                end
            else
                --û���л�ռ��
                if tempOwnGuildName ~= "" then
                    --����ʱռ��
                    if tempOwnGuildName ~= topGuildName then
                        --�뵱ǰ��������л᲻һ��
                        --�����ٶȼ�ռ�����
                        speed = basicSpeed * (topGuildPlayerAmount - otherGuildPlayerAmount)
                        if speed > 0 then
                            curProgress = curProgress - speed
                            if curProgress < 0 then
                                --��ʱռ���л����
                                curProgress = math.abs(curProgress)
                                tempOwnGuildName = topGuildName
                            end
                        end
                    else
                        --�뵱ǰ��������л�һ��
                        --�����ٶȼ�ռ�����
                        speed = basicSpeed * (topGuildPlayerAmount - otherGuildPlayerAmount)
                        if speed > 0 then
                            curProgress = curProgress + speed
                            curProgress = math.min(maxProgress, curProgress)
                            if curProgress >= maxProgress then
                                --������ ���õ�ǰռ��
                                ownGuildName = topGuildName
                            end
                        end
                    end
                else
                    --û����ʱռ��
                    --�����ٶȼ�ռ�����
                    --��ʱռ���л��Ϊ���������л�
                    speed = basicSpeed * (topGuildPlayerAmount - otherGuildPlayerAmount)
                    if speed > 0 then
                        curProgress = curProgress + speed
                        curProgress = math.min(maxProgress, curProgress)
                        tempOwnGuildName = topGuildName
                    end
                end
            end

            _updateProgressbar(tPlayerList, areaName, curProgress, maxProgress, tempOwnGuildName, ownGuildName,
                topGuildName, speed, 0)
            _setFlagGuiName(config.FlagArea[i].guildNameVar, ownGuildName)

            tThisAreaData.GuildName = ownGuildName
            tThisAreaData.LastProgress = tThisAreaData.Progress
            tThisAreaData.Progress = curProgress
            tThisAreaData.TempGuildName = tempOwnGuildName
            tThisAreaData.canOccupy = canOccupy
            tFlagAreaData[areaName] = tThisAreaData
        else
            local tThisAreaData = tFlagAreaData[areaName] or {}
            tThisAreaData.GuildName = ""
            tThisAreaData.LastProgress = 0
            tThisAreaData.Progress = 0
            tThisAreaData.TempGuildName = ""
            tThisAreaData.canOccupy = canOccupy
            tFlagAreaData[areaName] = tThisAreaData
            _updateProgressbar(tPlayerList, areaName, 0, maxProgress, "", "", "", 0, tThisAreaData.LeftLimitTime)
        end
    end

    data.tFlagAreaData = tFlagAreaData

    --�ӵ�ͼ��Ч ��С��ͼˢ��
    for i = 1, #tMapPlayerList do
        local actor = tMapPlayerList[i]
        if not tFlagPlayers[tostring(actor)] then
            Message.sendmsg(actor, ssrNetMsgCfg.ZhanJiangDuoQi_ClearProgressbar)
        end
        local playerName = Player.GetName(actor)
        local guildName = Player.GetGuildName(actor)
        if tPersonData[playerName] then
            local playerOrder = tPersonData[playerName].order
            for j = 1, #config.FlagArea do
                local areaName = config.FlagArea[j][1]             --���ĵ�����
                local tThisAreaData = tFlagAreaData[areaName] or {}
                local ownGuildName = tThisAreaData.GuildName or "" --��ǰռ��

                local mapEffectIndex = tonumber(playerOrder .. j)
                local mapEffectVar = "ն�������Ȧ��Ч" .. mapEffectIndex

                local curEffectId = config.FlagArea[j].MapEffect[ownGuildName == guildName]
                if Player.GetGlobalTempInt(mapEffectVar) ~= curEffectId then
                    --��ɾ��
                    Player.DelMapEffect(mapEffectIndex)
                    --�����
                    local param = { mapEffectIndex, config.Map, config.FlagArea[j][2][1], config.FlagArea[j][2][2],
                        curEffectId, -1, 1 }
                    Player.DelayCall(actor, 100, "zjdq_delay_addmapEffect," .. table.concat(param, ","))
                    Player.SetGlobalTempInt(mapEffectVar, curEffectId)
                end
            end
        end
    end

    --ÿ5�����ռ��ӻ���
    if leftTime % 5 == 0 then
        for i = 1, #config.FlagArea do
            local areaName = config.FlagArea[i][1] --���ĵ�����
            local tThisAreaData = tFlagAreaData[areaName] or {}

            local ownGuildName = tThisAreaData.GuildName or "" --��ǰռ��
            if ownGuildName ~= "" then
                if tGuildData[ownGuildName] then
                    tGuildData[ownGuildName].score = tGuildData[ownGuildName].score or 0
                    tGuildData[ownGuildName].score = tGuildData[ownGuildName].score + config.FlagArea[i][3]
                    tGuildData[ownGuildName].scoreTime = nowTime
                end
                --���л�ռ�� �л�ӻ��� �л���Ҽӻ���
                for j = 1, #tMapPlayerList do
                    local guildName = getbaseinfo(tMapPlayerList[j], 36)
                    if guildName == ownGuildName then
                        --��ռ���л��Ա
                        local playerName = getbaseinfo(tMapPlayerList[j], 1)
                        local map = getbaseinfo(tMapPlayerList[j], 3)
                        if config.Map == map and tPersonData[playerName] then
                            --�ڻ��ͼ�żӻ���
                            --tPersonData[playerName] = tPersonData[playerName] or {}
                            local ifSafeArea = getbaseinfo(tMapPlayerList[j], 48)

                            tPersonData[playerName].score = tPersonData[playerName].score or 0
                            if ifSafeArea then
                                tPersonData[playerName].score = tPersonData[playerName].score + config.FlagArea[i][3] / 2
                            else
                                tPersonData[playerName].score = tPersonData[playerName].score + config.FlagArea[i][3]
                            end
                            tPersonData[playerName].scoreTime = nowTime
                            tPersonData[playerName].guildName = guildName
                        end
                    end
                end
            end
        end

        --[[         for guildName, v in pairs(tGuildData) do
            v.score = 0
        end

        --�л�������л��Ա������һ����ܺ�
        for playerName, v in pairs(tPersonData) do
            local guildName = v.guildName
            if guildName then
                tGuildData[guildName] = tGuildData[guildName] or {}
                tGuildData[guildName].score = tGuildData[guildName].score or 0
                tGuildData[guildName].score = tGuildData[guildName].score + v.score
                tGuildData[guildName].scoreTime = nowTime
            end
        end ]]
    end
    --�������� ����UI��ʾ
    local tGuildRank, tPersonRank = _rankSort()
    local RankData = {
        tGuildRank = tGuildRank,
        tPersonRank = tPersonRank,
        leftTime = leftTime
    }
    for i = 1, #tMapPlayerList do
        Message.sendmsg(tMapPlayerList[i],ssrNetMsgCfg.ZhanJiangDuoQi_ShowRank,0,0,0,RankData)
    end

    --��������
    _setData(data)
    _setPersonData(tPersonData)
    Player.SetGlobalTempTable2(guildDataTemp, tGuildData)
end
GameEvent.add(EventCfg.onKFZhanJiangDuoQiSync, _onKFZhanJiangDuoQiSync, ZhanJiangDuoQi)

--�л���ͼ����
local function _goSwitchMap(actor, cur_mapid, former_mapid, x, y)
    if cur_mapid == config.Map then
        if getsysvar(VarCfg["G_ն������"]) == 0 then
            return
        end
        local tPersonData = _getPersonData()
        local playerName = Player.GetName(actor)
        if tPersonData[playerName] then
            local playerOrder = tPersonData[playerName].order
            for j = 1, #config.FlagArea do
                local mapEffectIndex = tonumber(playerOrder .. j)
                local mapEffectVar = "ն�������Ȧ��Ч" .. mapEffectIndex
                Player.SetGlobalTempInt(mapEffectVar, 0)
            end
        end
        local data = _getData()
        setattackmode(actor, 5, data.LeftTime)
    elseif former_mapid == config.Map then
        GameEvent.push(EventCfg.onKFZhanJiangDuoQiLeaveMap, actor)
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, ZhanJiangDuoQi)
--�뿪ն�����촥��
local function _onKFZhanJiangDuoQiLeaveMap(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhanJiangDuoQi_ClearProgressbar)
    setattackmode(actor, -1)
end
GameEvent.add(EventCfg.onKFZhanJiangDuoQiLeaveMap, _onKFZhanJiangDuoQiLeaveMap, ZhanJiangDuoQi)

--�������� --��������ͼ
function ZhanJiangDuoQi.Request(actor)
    if not checkkuafu(actor) then
        FMapMoveKF(actor, "kuafu2", 139, 160, 1)
        opennpcshowex(actor, 128, 0, 5)
    else
        FBenFuToKuaFuEvent(actor, EventCfg.onKFZhanJiangDuoQiEnter, "")
    end
end

--���ִ��
local function _onKFZhanJiangDuoQiGetRankData(actor)
    local tGuildRank, tPersonRank = _rankSort()
    local RankData = {
        tGuildRank = tGuildRank,
        tPersonRank = tPersonRank,
    }
    Message.sendmsg(actor, ssrNetMsgCfg.ZhanJiangDuoQi_GetRankData, 0, 0, 0, RankData)
end
GameEvent.add(EventCfg.onKFZhanJiangDuoQiGetRankData, _onKFZhanJiangDuoQiGetRankData, ZhanJiangDuoQi)

--�����ȡ��������
function ZhanJiangDuoQi.GetRankData(actor)
    FBenFuToKuaFuEvent(actor, EventCfg.onKFZhanJiangDuoQiGetRankData, "")
end

local function _onKFZhanJiangDuoQiShowMap(actor)
    local tFlagAreaData = campaignData.tFlagAreaData or {}
    tFlagAreaData.MapW, tFlagAreaData.MapH = getmapinfo(config.Map, 0), getmapinfo(config.Map, 1)

    local data = {}
    data[1] = tFlagAreaData
    data[2] = Player.GetGlobalTempTable2(guildDataTemp)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhanJiangDuoQi_zjdqShowMap, 0, 0, 0, data)
end
--������ʾ��ͼ����
GameEvent.add(EventCfg.onKFZhanJiangDuoQiShowMap, _onKFZhanJiangDuoQiShowMap, ZhanJiangDuoQi)
--������ʾ��ͼ����
function ZhanJiangDuoQi.zjdqShowMap(actor)
    FBenFuToKuaFuEvent(actor, EventCfg.onKFZhanJiangDuoQiShowMap, "")
end

-- ����һ����������ȡ��ߵ� score��kill��assist ��������ֺ����ǵĵ���
local function _getTopPlayers(data)
    -- ��ʼ�����ֵ�Ͷ�Ӧ���������
    local maxScore = -math.huge
    local maxKill = -math.huge
    local maxAssist = -math.huge

    local maxScorePlayer = nil
    local maxKillPlayer = nil
    local maxAssistPlayer = nil

    -- �������ݣ��ҵ���ߵ� score��kill��assist
    for playerName, stats in pairs(data) do
        if stats.score and stats.score > maxScore then
            maxScore = stats.score
            maxScorePlayer = playerName
        end
        if stats.kill and stats.kill > maxKill then
            maxKill = stats.kill
            maxKillPlayer = playerName
        end
        if stats.assist and stats.assist > maxAssist then
            maxAssist = stats.assist
            maxAssistPlayer = playerName
        end
    end

    -- ׼�������ֻ����������ֺ͵���
    local result = {
        scorePlayer = {
            name = maxScorePlayer or 0,
            point = maxScore > -math.huge and maxScore or 0
        },
        killPlayer = {
            name = maxKillPlayer or 0,
            point = maxKill > -math.huge and maxKill or 0
        },
        assistPlayer = {
            name = maxAssistPlayer or 0,
            point = maxAssist > -math.huge and maxAssist or 0
        },
    }

    return result
end
local function _onKFZhanJiangDuoQiGetHonorData(actor)
    local data = _getTopPlayers(_getPersonData())
    Message.sendmsg(actor, ssrNetMsgCfg.ZhanJiangDuoQi_GetHonorData, 0, 0, 0, data)
end

GameEvent.add(EventCfg.onKFZhanJiangDuoQiGetHonorData, _onKFZhanJiangDuoQiGetHonorData, ZhanJiangDuoQi)
function ZhanJiangDuoQi.GetHonorData(actor)
    FBenFuToKuaFuEvent(actor, EventCfg.onKFZhanJiangDuoQiGetHonorData, "")
end

--ͬ����Ϣ
-- function ZhanJiangDuoQi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ZhanJiangDuoQi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ZhanJiangDuoQi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ZhanJiangDuoQi.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhanJiangDuoQi)
--ն����ȡ��ʼ����ʼǰ��������
local function _onKFZhanJiangDuoQiStart()
    for _, value in ipairs(npcVar) do
        setsysvar(value, "���ĵ�\\δռ��")
    end
    --��ʼ�������
    local data = {}
    local nowTime = os.time()
    data.StartTick = nowTime                --���������ʱ���
    data.EndTick = data.StartTick + 30 * 60 --���������ʱ���
    data.LeftTime = 30 * 60                 --�����ʣ��ʱ�� ��
    Player.SetGlobalTempTable2(dataVar, data)
    if not checkkuafuserver() then
        FsendHuoDongGongGao("���ն�������ѿ���������")
    end
    campaignData = nil
    personData = nil
    tPersonRankByName = {}
    tGuildRankByName = {}
    Player.SetGlobalTempTable2(areaDataTemp, {})
    Player.SetGlobalTempTable2(personDataTemp, {})
    Player.SetGlobalTempTable2(guildDataTemp, {})
    Player.SetGlobalTempTable2(rewardDataTemp, {})
end
GameEvent.add(EventCfg.onKFZhanJiangDuoQiStart, _onKFZhanJiangDuoQiStart, ZhanJiangDuoQi)

--�賿��������
local function _roBeforedawn()
    campaignData = nil
    personData = nil
    tPersonRankByName = {}
    tGuildRankByName = {}
    Player.SetGlobalTempTable2(areaDataTemp, {})
    Player.SetGlobalTempTable2(personDataTemp, {})
    Player.SetGlobalTempTable2(guildDataTemp, {})
    Player.SetGlobalTempTable2(rewardDataTemp, {})
end
GameEvent.add(EventCfg.roBeforedawn,_roBeforedawn,ZhanJiangDuoQi)

local function CheckIsLinQu(actor)
    if getflagstatus(actor, VarCfg["F_ն�������Ƿ���ȡ"]) == 1 then
        Player.sendmsgEx(actor, "���Ѿ���ȡ��������#249")
        return false
    end
    local isTime = isTimeInRange(21, 01, 21, 11)
    if not isTime then
        Player.sendmsgEx(actor, string.format("����|21:01-21:11#249|��ȡ����!"))
        return false
    end
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber ~= 1 and weekDayNumber ~= 5 then
        Player.sendmsgEx(actor, string.format("���ڻ��|(��һ������)#249|��ȡ����!"))
        return false
    end
    return true
end

--�ڱ���������ȡ����
local function _onKFZhanJiangDuoSendReward(actor, arg1)
    if not CheckIsLinQu(actor) then
        return
    end
    local val = string.split(arg1, "#")
    local myRank = val[1] or 0
    local myGuildRank = val[2] or 0
    myRank = tonumber(myRank) or 0
    myGuildRank = tonumber(myGuildRank)  or 0
    if myRank == 0 or myGuildRank == 0 then
        Player.sendmsgEx(actor, "û�л�ȡ�����ڻ�е���������#249")
        return
    end
    local cfg1 = cfg_ZhanJiangDuoQiPersonReward[myRank]
    local cfg2 = cfg_ZhanJiangDuoQiGuildReward[myGuildRank]
    local reward1 = {}
    if cfg1 then
        reward1 = cfg1.reward
    else
        reward1 = cfg_ZhanJiangDuoQiPersonReward[11].reward
    end
    local reward2 = cfg2.reward
    local mailTitle = "����ȡ����ն������"
    local mailContent1 = "����ȡ����ն��������˵�".. myRank .."������"
    if myRank > 10 then
        mailContent1 = "����ȡ����ն��������˲��뽱��"
    end
    
    local uid = getbaseinfo(actor,ConstCfg.gbase.id)
    if reward1 then
        Player.giveMailByTable(uid, 1, mailTitle, mailContent1,reward1, 1, true)
        if myRank == 1 then
            confertitle(actor, "һ�ٶ��", 1)
            messagebox(actor,"��ϲ���á�ն�����졿���˻��ֵ�һ������óƺš�һ�ٶ������")
        end
    end
    if reward2 then
        local mailContent2 = "����ȡ����ն�������л��".. myGuildRank .."������"
        Player.giveMailByTable(uid, 1, mailTitle, mailContent2,reward2, 1, true)
    end
    Player.sendmsgEx(actor, "��ϲ����ȡ�����ɹ�,�뵽�ʼ�����!")
    setflagstatus(actor, VarCfg["F_ն�������Ƿ���ȡ"],1)
end
GameEvent.add(EventCfg.onKFZhanJiangDuoSendReward, _onKFZhanJiangDuoSendReward, ZhanJiangDuoQi)

--�ڿ��ִ�н������
local function _onKFZhanJiangDuoQiLingQu(actor)
    local tGuildRank, tPersonRank = _rankSort()
    local playerName = Player.GetName(actor)
    local guildName = Player.GetGuildName(actor)
    local myRank = _findSelfRank(playerName, tPersonRank)
    local myGuildRank = _findSelfRank(guildName, tGuildRank)
    --������������ͽ����ʼ�
    FKuaFuToBenFuEvent(actor, EventCfg.onKFZhanJiangDuoSendReward, myRank.."#"..myGuildRank)
end
GameEvent.add(EventCfg.onKFZhanJiangDuoQiLingQu, _onKFZhanJiangDuoQiLingQu, ZhanJiangDuoQi)

--��ȡ��������������Ϣ
function ZhanJiangDuoQi.LingQuReward(actor)
    if not CheckIsLinQu(actor) then
        return
    end
    FBenFuToKuaFuEvent(actor, EventCfg.onKFZhanJiangDuoQiLingQu, "")
end

local function _onKFZhanJiangDuoQiEnd()
    FMoveMapPlay(config.Map, "kuafu2", 132, 165, 5)
    if not checkkuafuserver() then
        FsendHuoDongGongGao("���ս�������ѽ���!")
    end
end
GameEvent.add(EventCfg.onKFZhanJiangDuoQiEnd, _onKFZhanJiangDuoQiEnd, ZhanJiangDuoQi)

function zjdq_die_fu_huo(actor)
    realive(actor)
    addhpper(actor, "=", 100)
    local guildName = Player.GetGuildName(actor)
    local tGuildData = Player.GetGlobalTempTable2(guildDataTemp)
    if not tGuildData[guildName] then
        return
    end
    local areaIndex = tGuildData[guildName].areaIndex % 4 + 1
    _back2BornPoint(actor, areaIndex)
    setflagstatus(actor, VarCfg["F_��������"], 0)

    if getsysvar(VarCfg["G_ն������"]) == 0 then
        return
    end
    local tPersonData = _getPersonData()
    local playerName = Player.GetName(actor)
    if tPersonData[playerName] then
        local playerOrder = tPersonData[playerName].order
        for j = 1, #config.FlagArea do
            local mapEffectIndex = tonumber(playerOrder .. j)
            local mapEffectVar = "ն�������Ȧ��Ч" .. mapEffectIndex
            Player.SetGlobalTempInt(mapEffectVar, 0)
        end
    end
end

--������������
local function _onKFZhanJiangDuoQiRlive(actor)
    setflagstatus(actor, VarCfg["F_��������"], 1)
    showprogressbardlg(actor, 3, "@zjdq_die_fu_huo", "����ǰ����ȫ������%d...", 0)
end
GameEvent.add(EventCfg.onKFZhanJiangDuoQiRlive, _onKFZhanJiangDuoQiRlive, ZhanJiangDuoQi)

--������ǰ������������¼����
local _Damage = {}
local function _onStruckDamagePlayer(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local mapKey = Player.MapKey(actor)
    if config.Map ~= mapKey then
        return
    end
    --��ǰû�п����
    if getsysvar(VarCfg["G_ն������"]) == 0 then
        return
    end
    local attackerName = Player.GetName(Target)
    local name = Player.GetName(actor)
    _Damage[name] = _Damage[name] or {}
    _Damage[name][attackerName] = os.time() + 5 --������¼
end
GameEvent.add(EventCfg.onStruckDamagePlayer, _onStruckDamagePlayer, ZhanJiangDuoQi)

local function _onkillplay(actor, play)
    local killerName = Player.GetName(actor) --��ɱ��
    local playerName = Player.GetName(play)  --��ɱ��

    local data = _getData()
    local tPersonData = _getPersonData()

    if tPersonData[playerName] then
        --����ɱ��������
        --��ɱ��
        if tPersonData[killerName] then
            tPersonData[killerName].kill = tPersonData[killerName].kill or 0
            tPersonData[killerName].kill = tPersonData[killerName].kill + 1
        end
        local nowTime = os.time()
        _Damage[playerName] = _Damage[playerName] or {}
        for k, v in pairs(_Damage[playerName]) do
            if k ~= killerName and nowTime <= v then
                --������
                if tPersonData[k] then
                    tPersonData[k].assist = tPersonData[k].assist or 0
                    tPersonData[k].assist = tPersonData[k].assist + 1
                end
            end
        end

        _Damage[playerName] = {} --������������

        tPersonData[playerName].score = tPersonData[playerName].score or 0
        if tPersonData[playerName].score > 0 then
            --����ɱ���л���
            local getScore = math.ceil(tPersonData[playerName].score * 0.1)
            tPersonData[playerName].score = tPersonData[playerName].score - getScore
            tPersonData[playerName].scoreTime = nowTime

            if tPersonData[killerName] then
                --��ɱ��������
                tPersonData[killerName].score = tPersonData[killerName].score or 0
                tPersonData[killerName].score = tPersonData[killerName].score + getScore
                tPersonData[killerName].scoreTime = nowTime
            end
        end

        _setPersonData(tPersonData)
        _setData(data)
    end
end

GameEvent.add(EventCfg.onkillplay, _onkillplay, ZhanJiangDuoQi)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ZhanJiangDuoQi, ZhanJiangDuoQi)

return ZhanJiangDuoQi