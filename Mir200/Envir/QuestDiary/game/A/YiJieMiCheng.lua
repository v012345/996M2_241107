local YiJieMiCheng = {}
YiJieMiCheng.ID = "异界迷城"
local config = include("QuestDiary/cfgcsv/cfg_YiJieMiCheng.lua") --配置
local configRank = include("QuestDiary/cfgcsv/cfg_YiJieMiChengRank.lua") --配置
local configMap = {}
for _, value in ipairs(config) do
    configMap[value.mapID] = value
end
--地图位置坐标 上 右 下 左
local directions = {
    { x = 20, y = 18 },
    { x = 75, y = 18 },
    { x = 75, y = 74 },
    { x = 20, y = 74 }
}
--进入底层奖励
local enterBottomReward = { { "元宝", 100000 }, { "绑定金币", 1000000 }, { "焚天石", 333 }, { "天工之锤", 333 } }
--接收请求
function YiJieMiCheng.Request(actor)
    local isOpen = getsysvar(VarCfg["G_异界迷城开启标识"])
    if isOpen == 0 then
        Player.sendmsgEx(actor, "当前没有开启异界迷城活动#249")
        return
    end
    FMapMoveEx(actor, "异界迷城1", 47, 40, 3)
    local name = Player.GetName(actor)
    sendmsg("0", 2,
        '{"Msg":"[' ..
        name .. ']参加了异界迷城活动","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","X":"-300"}')
    local mapPosition = Player.getJsonTableByVar(actor, VarCfg["S$异界迷城记录地图位置"])
    Message.sendmsg(actor, ssrNetMsgCfg.YiJieMiCheng_EnterMap, 0, 0, 0, mapPosition)
    openhyperlink(actor, 110, 1)
end

--同步消息
-- function YiJieMiCheng.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.YiJieMiCheng_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.YiJieMiCheng_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     YiJieMiCheng.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YiJieMiCheng)

--清理玩家记录的变量
local function clearActorVar()
    local Players = getplayerlst(1)
    for _, actor in pairs(Players) do
        setplaydef(actor,VarCfg["S$异界迷城去过的地图"],"")
        setplaydef(actor,VarCfg["S$异界迷城记录地图位置"],"")
    end
end

--异界迷城开始
local function _onYiJieMiChengStart()
    FsendHuoDongGongGao("异界迷城活动已开启")
    clearActorVar() --清理玩家变量
    setsysvar(VarCfg["A_异界迷城底层记录"],"") --清理进入底层的记录
    setsysvar(VarCfg["G_异界迷城排行"],0) --清理排行榜
    for index, value in ipairs(config) do
        local tmpTbl = {
            value.linkPoint1,
            value.linkPoint2,
            value.linkPoint3,
            value.linkPoint4,
        }
        if #tmpTbl > 0 then
            table.shuffle(tmpTbl)
            -- dump(tmpTbl)
            for i, v in ipairs(directions) do
                local linkPoint = {
                    ["坐标x"] = v.x,
                    ["坐标y"] = v.y,
                    ["当前地图"] = value.mapID,
                    ["下层地图"] = tmpTbl[i][1],
                    ["下层地图x"] = value.x,
                    ["下层地图y"] = value.y,
                }
                addmapgate(linkPoint["当前地图"] .. i, linkPoint["当前地图"], linkPoint["坐标x"], linkPoint["坐标y"], 2,
                    linkPoint["下层地图"], linkPoint["下层地图x"], linkPoint["下层地图y"], 1200)
                mapeffect(2000 + index + i, linkPoint["当前地图"], linkPoint["坐标x"], linkPoint["坐标y"], 17009, 1200, 0, actor)
            end
        end
        --清怪， 刷怪
        killmonsters(value.mapID, "*", 0, false)
        genmon(value.mapID, value.x, value.y, value.monName, 0, 1, 251)
    end
end
GameEvent.add(EventCfg.onYiJieMiChengStart, _onYiJieMiChengStart, YiJieMiCheng)

--判断下图位置
local function getMapPositionIndex(actor, x, y)
    for index, value in ipairs(directions) do
        if FisInRange(x, y, value.x, value.y, 3) then
            return index
        end
    end
end

--判断是否已经下过地图
--已经下过返回true，没下过返回false
local function isHasVisitedMap(actor, mapID)
    local maps = Player.getJsonTableByVar(actor, VarCfg["S$异界迷城去过的地图"])
    local result = false
    for _, value in ipairs(maps) do
        if value == mapID then
            result = true
            break
        end
    end
    return result
end

--记录地图
local function setRecordMap(actor, mapID)
    local maps = Player.getJsonTableByVar(actor, VarCfg["S$异界迷城去过的地图"])
    table.insert(maps, mapID)
    Player.setJsonVarByTable(actor, VarCfg["S$异界迷城去过的地图"], maps)
end

--记录地图位置
local function recordMapPosition(actor, mapID, index)
    local mapPosition = Player.getJsonTableByVar(actor, VarCfg["S$异界迷城记录地图位置"])
    mapPosition[mapID] = index
    Player.setJsonVarByTable(actor, VarCfg["S$异界迷城记录地图位置"], mapPosition)
end

--记录进入底层
local function recordEnterUnderground(actor)
    local playerList = Player.getJsonTableByVar(nil, VarCfg["A_异界迷城底层记录"])
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    table.insert(playerList, name)
    Player.setJsonVarByTable(nil, VarCfg["A_异界迷城底层记录"], playerList)
end

--判断是否进入过底层
local function isEnterUnderground(actor)
    local playerList = Player.getJsonTableByVar(nil, VarCfg["A_异界迷城底层记录"])
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    for i, v in ipairs(playerList) do
        if v == name then
            return true
        end
    end
    return false
end

--延迟处理地图
function yi_jie_mi_cheng_qie_huan_di_tu(actor, former_mapid, currMapID, formerX, formerY)
    local cur_mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    formerX = tonumber(formerX)
    formerY = tonumber(formerY)
    local cfg = configMap[former_mapid]
    if cfg then
        if cfg.linkPoint4[1] == cur_mapid then
            Player.sendmsgEx(actor, "恭喜你进入下一层(" .. currMapID .. "层)")
            if not isHasVisitedMap(actor, currMapID) then                             --如果没有下过地图
                setRecordMap(actor, currMapID)                                        --记录下过的地图
                local MapPositionIndex = getMapPositionIndex(actor, formerX, formerY) --根据下图获取位置
                recordMapPosition(actor, former_mapid, MapPositionIndex)              --记录地图位置
            end
            if FCheckMap(actor, "异界深渊") then
                if not isEnterUnderground(actor) then --如果没有 underground记录
                    recordEnterUnderground(actor)     --记录
                    local rank = getsysvar(VarCfg["G_异界迷城排行"])
                    local currRank = rank + 1
                    setsysvar(VarCfg["G_异界迷城排行"], currRank)
                    local cfgRank = configRank[currRank]
                    local give = {}
                    if cfgRank then
                        give = cfgRank.reward
                    else
                        give = enterBottomReward
                    end
                    local rewardSrt = getItemArrToStr(give)
                    local userid = getbaseinfo(actor, ConstCfg.gbase.id)
                    Player.giveMailByTable(userid, 1, "异界迷城进入底层奖励", "请领取您的异界迷城底层奖励", give)
                    local name = Player.GetName(actor)
                    local rankChinese = ""
                    if currRank < 10 then
                        rankChinese = '第'..formatNumberToChinese(currRank) ..'个'
                    else
                        rankChinese = ""
                    end
                    sendmsg("0", 2,
                        '{"Msg":"恭喜玩家['..name..']'.. rankChinese ..'进入异界迷城底层,获得奖励:' ..
                        rewardSrt .. '","FColor":249,"BColor":0,"Type":5,"Time":3,"SendId":"123","Y":"100"}')
                end
            end
        else
            Player.sendmsgEx(actor, "糟糕,你返回了" .. cur_mapid .. "层#249")
        end
        local mapPosition = Player.getJsonTableByVar(actor, VarCfg["S$异界迷城记录地图位置"])
        Message.sendmsg(actor, ssrNetMsgCfg.YiJieMiCheng_EnterMap, 0, 0, 0, mapPosition)
    end
end

--踩点触发
local function _onBeforerOute(actor, mapid, x, y)
    local cfg = configMap[mapid]
    if cfg then
        local former_mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local formerX = getbaseinfo(actor, ConstCfg.gbase.x)
        local formerY = getbaseinfo(actor, ConstCfg.gbase.y)
        delaygoto(actor, 300,
            string.format("yi_jie_mi_cheng_qie_huan_di_tu,%s,%s,%d,%d", former_mapid, mapid, formerX, formerY))
    end
end
GameEvent.add(EventCfg.onBeforerOute, _onBeforerOute, YiJieMiCheng)

--异界迷城结束
local function _onYiJieMiChengEnd()
    FsendHuoDongGongGao("异界迷城活动已结束")
    for _, value in ipairs(config) do
        callscriptex("0", "MoveMapPlay", value.mapID, "n3", 330, 330, 3)
    end
end
GameEvent.add(EventCfg.onYiJieMiChengEnd, _onYiJieMiChengEnd, YiJieMiCheng)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YiJieMiCheng, YiJieMiCheng)
return YiJieMiCheng
