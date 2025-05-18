local ZhanJiangDuoQi = {}
ZhanJiangDuoQi.ID = "战将夺旗"
local npcID = 128
local config = include("QuestDiary/game/KuaFu/ZhanJiangDuoQi_Data_Config.lua") --配置
local cfg_ZhanJiangDuoQiPersonReward = include("QuestDiary/cfgcsv/cfg_ZhanJiangDuoQiPersonReward.lua") --配置
local cfg_ZhanJiangDuoQiGuildReward = include("QuestDiary/cfgcsv/cfg_ZhanJiangDuoQiGuildReward.lua") --配置
local campaignName = "斩将夺旗"
local dataVar = "斩将夺旗活动数据"
local rankVar = "斩将夺旗活动排名"
local areaDataTemp = "斩将夺旗占领详情"
local personDataTemp = "斩将夺旗玩家详情"
local guildDataTemp = "斩将夺旗行会详情"
local rewardDataTemp = "斩将夺旗领奖详情"
local npcVar = { "A33", "A32", "A31", "A30", "A29", "A28", "A27", "A26", "A25", "A24", "A23", "A22", "A21" }
local campaignData --活动数据
local personData   --玩家数据
--获取斩将夺旗活动数据
local function _getData()
    if not campaignData then
        campaignData = Player.GetGlobalTempTable2(dataVar)
    end
    return campaignData
end
--设置斩将夺旗活动数据
local function _setData(data)
    Player.SetGlobalTempTable2(dataVar, data)
    campaignData = data
end

--获取人物数据
local function _getPersonData()
    if not personData then
        personData = Player.GetGlobalTempTable2(personDataTemp)
    end
    return personData
end

--设置人物数据
local function _setPersonData(data)
    Player.SetGlobalTempTable2(personDataTemp, data)
    personData = data
end

--设置旗帜点占领行会
local function _setFlagGuiName(varName, guiName)
    if guiName == "" then
        guiName = "未占领"
    end
    setsysvar(varName, "旗帜点\\" .. guiName)
end

--回到安全
local function _back2BornPoint(actor, areaIndex)
    local x = math.random(config.BornPoint[areaIndex].x[1], config.BornPoint[areaIndex].x[2])
    local y = math.random(config.BornPoint[areaIndex].y[1], config.BornPoint[areaIndex].y[2])
    mapmove(actor, config.Map, x, y, 1)
end

--重新排名 每秒调用1次
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

--获取排名
local function _findSelfRank(name, tRank)
    for i = 1, #tRank do
        if tRank[i][1] == name then
            return i
        end
    end
    return 0
end
--进入斩将夺旗活动 --需要跨服传递
local function _onKFZhanJiangDuoQiEnter(actor)
    local playerName = Player.GetName(actor)
    local guildName = Player.GetGuildName(actor)

    if not guildName or guildName == "" then
        Player.sendmsgEx(actor, "你没有加入行会，无法参加活动!#249")
        --没有行会
        return
    end

    local mapKey = Player.MapKey(actor)
    if config.Map == mapKey then
        Player.sendmsgEx(actor, "已在活动地图!#249")
        return
    end

    --判断活动是否在进行中
    if getsysvar(VarCfg["G_斩将夺旗"]) == 0 then
        --当前没有开启活动
        Player.sendmsgEx(actor, "当前没有开启活动!#249")
        return
    end
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    sendmsg("0", 2, '{"Msg":"[' .. name .. ']参加了斩将夺旗活动","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","X":"-300"}')
    local data = _getData()
    local tGuildData = Player.GetGlobalTempTable2(guildDataTemp)
    local tPersonData = _getPersonData()

    local playerCode = data.playerCode or 100
    local guildCode = data.guildCode or 0
    local colorIndex = data.colorIndex or 1

    if not tPersonData[playerName] or not tGuildData[guildName] then
        --首次进入活动
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
                --循环
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
            Player.sendmsgEx(actor, string.format("退出活动地图后重新进入,扣除|%d%%#249|积分!", config.ReturnSubScorePct))
        end
    end

    --传送
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

--延迟设置光圈颜色
function zjdq_delay_addmapEffect(actor, mapEffectIndex, mapKey, x, y, id, time, mode)
    mapEffectIndex = tonumber(mapEffectIndex)
    x = tonumber(x)
    y = tonumber(y)
    id = tonumber(id)
    time = tonumber(time)
    mode = tonumber(mode)
    callscriptex(actor, "MAPEFFECT", mapEffectIndex, mapKey, x, y, id, time, mode, 0)
end

-- tempOwnGuildName --临时行会
-- ownGuildName --当前占领
-- topGuildName --当前行会最多的
--玩家显示 占领进度条
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
    --tPlayers:全地图玩家列表
    leftLimitTime = leftLimitTime or 0
    for i = 1, #tPlayerList do
        --在区域的玩家
        Message.sendmsg(tPlayerList[i], ssrNetMsgCfg.ZhanJiangDuoQi_UpdateProgressbar, 0, 0, 0, data)
    end
end

--跨服执行 每秒执行
local function _onKFZhanJiangDuoQiSync()
    --获取到活动结束的时间
    local leftTime = GetSecondsUntil21()

    local function compare(a, b)
        return a[2] > b[2]
    end
    --获取活动地图的所有玩家
    local tMapPlayerList = Player.GetMapPlayerList(config.Map)
    local tFlagPlayers = {}
    --获取活动数据
    local data = _getData()
    --获取活动剩余倒计时
    data.LeftTime = leftTime
    --初始化旗帜区域的数据。
    local tFlagAreaData = data.tFlagAreaData or {}
    --获取当前时间
    local nowTime = os.time()
    --获取人物数据
    local tPersonData = _getPersonData()
    --获取行会数据
    local tGuildData = Player.GetGlobalTempTable2(guildDataTemp)

    --判断每个区域的玩家
    for i = 1, #config.FlagArea do
        local areaName = config.FlagArea[i][1]    --旗帜点名称
        local maxProgress = config.FlagArea[i][4] --需要占领进度
        local basicSpeed = config.FlagArea[i][5]  --基础占领速度
        local tThisAreaData = tFlagAreaData[areaName] or {}

        local canOccupy = true --标记当前旗帜是否可被占领。
        --如果是占领的是擂台
        if config.FlagArea[i].timeLimit then
            local runTime = nowTime - data.StartTick
            if runTime < config.FlagArea[i].timeLimit then
                --未到可占领时间
                tThisAreaData.LeftLimitTime = config.FlagArea[i].timeLimit - runTime
                canOccupy = false
            end
        end
        --获取占领区域内的玩家
        local tPlayerList = Player.GetMapPlayerList(config.Map, config.FlagArea[i][2][1], config.FlagArea[i][2][2],
            config.FlagArea[i][2][3])
        for j = 1, #tPlayerList do
            tFlagPlayers[tostring(tPlayerList[j])] = true
        end
        --如果可以占领
        if canOccupy then
            local ownGuildName = tThisAreaData.GuildName or ""         --当前占领
            local tempOwnGuildName = tThisAreaData.TempGuildName or "" --临时占领
            local curProgress = tThisAreaData.Progress or 0            --当前占领进度

            --记录每个行会在该区域内的玩家数量。
            local tGuildPlayerAmount = {}
            for j = 1, #tPlayerList do
                local playerName = getbaseinfo(tPlayerList[j], 1)
                if tPersonData[playerName] then
                    local guildName = getbaseinfo(tPlayerList[j], 36)
                    tGuildPlayerAmount[guildName] = tGuildPlayerAmount[guildName] or 0
                    tGuildPlayerAmount[guildName] = tGuildPlayerAmount[guildName] + 1
                end
            end

            -- 将行会和对应的玩家数量转化为列表，以便排序。
            local tGuildPlayerRank = {}
            for guildName, amount in pairs(tGuildPlayerAmount) do
                tGuildPlayerRank[#tGuildPlayerRank + 1] = { guildName, amount }
            end

            table.sort(tGuildPlayerRank, compare)

            local topGuildName = ""          --当前区域内玩家数量最多的行会名称。
            local topGuildPlayerAmount = 0   --该行会在该区域内的玩家数量。
            local otherGuildPlayerAmount = 0 --其他行会在该区域内的总玩家数量。
            if tGuildPlayerRank[1] then
                topGuildName = tGuildPlayerRank[1][1]
                topGuildPlayerAmount = tGuildPlayerRank[1][2]
            end

            for j = 2, #tGuildPlayerRank do
                otherGuildPlayerAmount = otherGuildPlayerAmount + tGuildPlayerRank[j][2]
            end
            --计算占领进度的变化
            local speed = 0
            if ownGuildName ~= "" then
                --已经有行会占领
                if ownGuildName ~= topGuildName then
                    --与当前人数最多行会不一致
                    --根据速度减占领进度
                    speed = basicSpeed * (topGuildPlayerAmount - otherGuildPlayerAmount)
                    if speed > 0 then
                        --速度大于0
                        curProgress = curProgress - speed
                        if curProgress < 0 then
                            --占领行会变无 临时占领行会变为人数最多的行会
                            curProgress = math.abs(curProgress)
                            ownGuildName = ""
                            tempOwnGuildName = topGuildName
                        end
                    end
                else
                    --与当前人数最多行会一致
                    --根据速度增加占领进度
                    speed = basicSpeed * (topGuildPlayerAmount - otherGuildPlayerAmount)
                    if speed > 0 then
                        --速度大于0
                        curProgress = curProgress + speed
                        curProgress = math.min(maxProgress, curProgress)
                    end
                end
            else
                --没有行会占领
                if tempOwnGuildName ~= "" then
                    --有临时占领
                    if tempOwnGuildName ~= topGuildName then
                        --与当前人数最多行会不一致
                        --根据速度减占领进度
                        speed = basicSpeed * (topGuildPlayerAmount - otherGuildPlayerAmount)
                        if speed > 0 then
                            curProgress = curProgress - speed
                            if curProgress < 0 then
                                --临时占领行会更迭
                                curProgress = math.abs(curProgress)
                                tempOwnGuildName = topGuildName
                            end
                        end
                    else
                        --与当前人数最多行会一致
                        --根据速度减占领进度
                        speed = basicSpeed * (topGuildPlayerAmount - otherGuildPlayerAmount)
                        if speed > 0 then
                            curProgress = curProgress + speed
                            curProgress = math.min(maxProgress, curProgress)
                            if curProgress >= maxProgress then
                                --进度满 设置当前占领
                                ownGuildName = topGuildName
                            end
                        end
                    end
                else
                    --没有临时占领
                    --根据速度加占领进度
                    --临时占领行会变为人数最多的行会
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

    --加地图特效 和小地图刷新
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
                local areaName = config.FlagArea[j][1]             --旗帜点名称
                local tThisAreaData = tFlagAreaData[areaName] or {}
                local ownGuildName = tThisAreaData.GuildName or "" --当前占领

                local mapEffectIndex = tonumber(playerOrder .. j)
                local mapEffectVar = "斩将夺旗光圈特效" .. mapEffectIndex

                local curEffectId = config.FlagArea[j].MapEffect[ownGuildName == guildName]
                if Player.GetGlobalTempInt(mapEffectVar) ~= curEffectId then
                    --先删除
                    Player.DelMapEffect(mapEffectIndex)
                    --再添加
                    local param = { mapEffectIndex, config.Map, config.FlagArea[j][2][1], config.FlagArea[j][2][2],
                        curEffectId, -1, 1 }
                    Player.DelayCall(actor, 100, "zjdq_delay_addmapEffect," .. table.concat(param, ","))
                    Player.SetGlobalTempInt(mapEffectVar, curEffectId)
                end
            end
        end
    end

    --每5秒根据占领加积分
    if leftTime % 5 == 0 then
        for i = 1, #config.FlagArea do
            local areaName = config.FlagArea[i][1] --旗帜点名称
            local tThisAreaData = tFlagAreaData[areaName] or {}

            local ownGuildName = tThisAreaData.GuildName or "" --当前占领
            if ownGuildName ~= "" then
                if tGuildData[ownGuildName] then
                    tGuildData[ownGuildName].score = tGuildData[ownGuildName].score or 0
                    tGuildData[ownGuildName].score = tGuildData[ownGuildName].score + config.FlagArea[i][3]
                    tGuildData[ownGuildName].scoreTime = nowTime
                end
                --有行会占领 行会加积分 行会玩家加积分
                for j = 1, #tMapPlayerList do
                    local guildName = getbaseinfo(tMapPlayerList[j], 36)
                    if guildName == ownGuildName then
                        --是占领行会成员
                        local playerName = getbaseinfo(tMapPlayerList[j], 1)
                        local map = getbaseinfo(tMapPlayerList[j], 3)
                        if config.Map == map and tPersonData[playerName] then
                            --在活动地图才加积分
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

        --行会积分是行会成员所有玩家积分总和
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
    --计算排名 更新UI显示
    local tGuildRank, tPersonRank = _rankSort()
    local RankData = {
        tGuildRank = tGuildRank,
        tPersonRank = tPersonRank,
        leftTime = leftTime
    }
    for i = 1, #tMapPlayerList do
        Message.sendmsg(tMapPlayerList[i],ssrNetMsgCfg.ZhanJiangDuoQi_ShowRank,0,0,0,RankData)
    end

    --保存数据
    _setData(data)
    _setPersonData(tPersonData)
    Player.SetGlobalTempTable2(guildDataTemp, tGuildData)
end
GameEvent.add(EventCfg.onKFZhanJiangDuoQiSync, _onKFZhanJiangDuoQiSync, ZhanJiangDuoQi)

--切换地图触发
local function _goSwitchMap(actor, cur_mapid, former_mapid, x, y)
    if cur_mapid == config.Map then
        if getsysvar(VarCfg["G_斩将夺旗"]) == 0 then
            return
        end
        local tPersonData = _getPersonData()
        local playerName = Player.GetName(actor)
        if tPersonData[playerName] then
            local playerOrder = tPersonData[playerName].order
            for j = 1, #config.FlagArea do
                local mapEffectIndex = tonumber(playerOrder .. j)
                local mapEffectVar = "斩将夺旗光圈特效" .. mapEffectIndex
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
--离开斩将夺旗触发
local function _onKFZhanJiangDuoQiLeaveMap(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhanJiangDuoQi_ClearProgressbar)
    setattackmode(actor, -1)
end
GameEvent.add(EventCfg.onKFZhanJiangDuoQiLeaveMap, _onKFZhanJiangDuoQiLeaveMap, ZhanJiangDuoQi)

--接收请求 --请求进入地图
function ZhanJiangDuoQi.Request(actor)
    if not checkkuafu(actor) then
        FMapMoveKF(actor, "kuafu2", 139, 160, 1)
        opennpcshowex(actor, 128, 0, 5)
    else
        FBenFuToKuaFuEvent(actor, EventCfg.onKFZhanJiangDuoQiEnter, "")
    end
end

--跨服执行
local function _onKFZhanJiangDuoQiGetRankData(actor)
    local tGuildRank, tPersonRank = _rankSort()
    local RankData = {
        tGuildRank = tGuildRank,
        tPersonRank = tPersonRank,
    }
    Message.sendmsg(actor, ssrNetMsgCfg.ZhanJiangDuoQi_GetRankData, 0, 0, 0, RankData)
end
GameEvent.add(EventCfg.onKFZhanJiangDuoQiGetRankData, _onKFZhanJiangDuoQiGetRankData, ZhanJiangDuoQi)

--请求获取排行数据
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
--请求显示地图数据
GameEvent.add(EventCfg.onKFZhanJiangDuoQiShowMap, _onKFZhanJiangDuoQiShowMap, ZhanJiangDuoQi)
--请求显示地图数据
function ZhanJiangDuoQi.zjdqShowMap(actor)
    FBenFuToKuaFuEvent(actor, EventCfg.onKFZhanJiangDuoQiShowMap, "")
end

-- 定义一个函数，获取最高的 score、kill、assist 的玩家名字和他们的点数
local function _getTopPlayers(data)
    -- 初始化最大值和对应的玩家名字
    local maxScore = -math.huge
    local maxKill = -math.huge
    local maxAssist = -math.huge

    local maxScorePlayer = nil
    local maxKillPlayer = nil
    local maxAssistPlayer = nil

    -- 遍历数据，找到最高的 score、kill、assist
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

    -- 准备结果表，只包含玩家名字和点数
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

--同步消息
-- function ZhanJiangDuoQi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ZhanJiangDuoQi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ZhanJiangDuoQi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ZhanJiangDuoQi.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhanJiangDuoQi)
--斩将夺取开始，开始前清理数据
local function _onKFZhanJiangDuoQiStart()
    for _, value in ipairs(npcVar) do
        setsysvar(value, "旗帜点\\未占领")
    end
    --初始化活动数据
    local data = {}
    local nowTime = os.time()
    data.StartTick = nowTime                --本场活动开启时间戳
    data.EndTick = data.StartTick + 30 * 60 --本场活动结束时间戳
    data.LeftTime = 30 * 60                 --本场活动剩余时间 秒
    Player.SetGlobalTempTable2(dataVar, data)
    if not checkkuafuserver() then
        FsendHuoDongGongGao("跨服斩将夺旗活动已开启！！！")
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

--凌晨清理活动数据
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
    if getflagstatus(actor, VarCfg["F_斩将夺旗是否领取"]) == 1 then
        Player.sendmsgEx(actor, "您已经领取过奖励了#249")
        return false
    end
    local isTime = isTimeInRange(21, 01, 21, 11)
    if not isTime then
        Player.sendmsgEx(actor, string.format("请在|21:01-21:11#249|领取奖励!"))
        return false
    end
    local weekDayNumber = tonumber(os.date("%w"))
    if weekDayNumber ~= 1 and weekDayNumber ~= 5 then
        Player.sendmsgEx(actor, string.format("请在活动日|(周一、周五)#249|领取奖励!"))
        return false
    end
    return true
end

--在本服务内领取奖励
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
        Player.sendmsgEx(actor, "没有获取到您在活动中的排名数据#249")
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
    local mailTitle = "请领取您的斩将夺旗活动"
    local mailContent1 = "请领取您的斩将夺旗个人第".. myRank .."名奖励"
    if myRank > 10 then
        mailContent1 = "请领取您的斩将夺旗个人参与奖励"
    end
    
    local uid = getbaseinfo(actor,ConstCfg.gbase.id)
    if reward1 then
        Player.giveMailByTable(uid, 1, mailTitle, mailContent1,reward1, 1, true)
        if myRank == 1 then
            confertitle(actor, "一举夺魁", 1)
            messagebox(actor,"恭喜你获得【斩将夺旗】个人积分第一名，获得称号【一举夺魁】。")
        end
    end
    if reward2 then
        local mailContent2 = "请领取您的斩将夺旗行会第".. myGuildRank .."名奖励"
        Player.giveMailByTable(uid, 1, mailTitle, mailContent2,reward2, 1, true)
    end
    Player.sendmsgEx(actor, "恭喜您领取奖励成功,请到邮件查收!")
    setflagstatus(actor, VarCfg["F_斩将夺旗是否领取"],1)
end
GameEvent.add(EventCfg.onKFZhanJiangDuoSendReward, _onKFZhanJiangDuoSendReward, ZhanJiangDuoQi)

--在跨服执行奖励检测
local function _onKFZhanJiangDuoQiLingQu(actor)
    local tGuildRank, tPersonRank = _rankSort()
    local playerName = Player.GetName(actor)
    local guildName = Player.GetGuildName(actor)
    local myRank = _findSelfRank(playerName, tPersonRank)
    local myGuildRank = _findSelfRank(guildName, tGuildRank)
    --跨服到本服发送奖励邮件
    FKuaFuToBenFuEvent(actor, EventCfg.onKFZhanJiangDuoSendReward, myRank.."#"..myGuildRank)
end
GameEvent.add(EventCfg.onKFZhanJiangDuoQiLingQu, _onKFZhanJiangDuoQiLingQu, ZhanJiangDuoQi)

--领取奖励本服接收消息
function ZhanJiangDuoQi.LingQuReward(actor)
    if not CheckIsLinQu(actor) then
        return
    end
    FBenFuToKuaFuEvent(actor, EventCfg.onKFZhanJiangDuoQiLingQu, "")
end

local function _onKFZhanJiangDuoQiEnd()
    FMoveMapPlay(config.Map, "kuafu2", 132, 165, 5)
    if not checkkuafuserver() then
        FsendHuoDongGongGao("跨服战将夺旗活动已结束!")
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
    setflagstatus(actor, VarCfg["F_人物死亡"], 0)

    if getsysvar(VarCfg["G_斩将夺旗"]) == 0 then
        return
    end
    local tPersonData = _getPersonData()
    local playerName = Player.GetName(actor)
    if tPersonData[playerName] then
        local playerOrder = tPersonData[playerName].order
        for j = 1, #config.FlagArea do
            local mapEffectIndex = tonumber(playerOrder .. j)
            local mapEffectVar = "斩将夺旗光圈特效" .. mapEffectIndex
            Player.SetGlobalTempInt(mapEffectVar, 0)
        end
    end
end

--人物死亡复活
local function _onKFZhanJiangDuoQiRlive(actor)
    setflagstatus(actor, VarCfg["F_人物死亡"], 1)
    showprogressbardlg(actor, 3, "@zjdq_die_fu_huo", "正在前往安全区复活%d...", 0)
end
GameEvent.add(EventCfg.onKFZhanJiangDuoQiRlive, _onKFZhanJiangDuoQiRlive, ZhanJiangDuoQi)

--被攻击前触发，用来记录助攻
local _Damage = {}
local function _onStruckDamagePlayer(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local mapKey = Player.MapKey(actor)
    if config.Map ~= mapKey then
        return
    end
    --当前没有开启活动
    if getsysvar(VarCfg["G_斩将夺旗"]) == 0 then
        return
    end
    local attackerName = Player.GetName(Target)
    local name = Player.GetName(actor)
    _Damage[name] = _Damage[name] or {}
    _Damage[name][attackerName] = os.time() + 5 --助攻记录
end
GameEvent.add(EventCfg.onStruckDamagePlayer, _onStruckDamagePlayer, ZhanJiangDuoQi)

local function _onkillplay(actor, play)
    local killerName = Player.GetName(actor) --击杀着
    local playerName = Player.GetName(play)  --被杀者

    local data = _getData()
    local tPersonData = _getPersonData()

    if tPersonData[playerName] then
        --被击杀者有数据
        --击杀数
        if tPersonData[killerName] then
            tPersonData[killerName].kill = tPersonData[killerName].kill or 0
            tPersonData[killerName].kill = tPersonData[killerName].kill + 1
        end
        local nowTime = os.time()
        _Damage[playerName] = _Damage[playerName] or {}
        for k, v in pairs(_Damage[playerName]) do
            if k ~= killerName and nowTime <= v then
                --助攻数
                if tPersonData[k] then
                    tPersonData[k].assist = tPersonData[k].assist or 0
                    tPersonData[k].assist = tPersonData[k].assist + 1
                end
            end
        end

        _Damage[playerName] = {} --重置助攻数据

        tPersonData[playerName].score = tPersonData[playerName].score or 0
        if tPersonData[playerName].score > 0 then
            --被击杀者有积分
            local getScore = math.ceil(tPersonData[playerName].score * 0.1)
            tPersonData[playerName].score = tPersonData[playerName].score - getScore
            tPersonData[playerName].scoreTime = nowTime

            if tPersonData[killerName] then
                --击杀者有数据
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

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ZhanJiangDuoQi, ZhanJiangDuoQi)

return ZhanJiangDuoQi