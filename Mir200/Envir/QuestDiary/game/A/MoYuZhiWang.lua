local MoYuZhiWang = {}
MoYuZhiWang.ID = "摸鱼之王"
local config = include("QuestDiary/cfgcsv/cfg_MoYuZhiWang.lua") --配置
local mapID = "moyu"
local pointMap = {
    ["潮鲅鱼群【十积分】"] = 10,
    ["沙丁鱼群【三十积分】"] = 30,
    ["大鱼群【五十积分】"] = 50,
    ["超大鱼群【八十积分】"] = 80,
    ["黄金鲸【一百二十积分】"] = 120,
    ["宝石鲸【一百二十积分】"] = 120,
    ["红锦鲤【二百积分】"] = 200,
}

local monNum = {
    { name = "潮鲅鱼群【十积分】", num = 500 },
    { name = "沙丁鱼群【三十积分】", num = 200 },
    { name = "大鱼群【五十积分】", num = 120 },
    { name = "超大鱼群【八十积分】", num = 60 },
    { name = "黄金鲸【一百二十积分】", num = 60 },
    { name = "宝石鲸【一百二十积分】", num = 60 },
    { name = "红锦鲤【二百积分】", num = 10 },
}

--接收请求
function MoYuZhiWang.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
    --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
    --return
    --end
end

function MoYuZhiWang.EnterMap(actor)
    local min = getsysvar(VarCfg["G_开区分钟计时器"])
    if min >= 105 and min < 115 then
        FMapEx(actor, mapID)
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        sendmsg("0", 2,
            '{"Msg":"[' ..
            name .. ']参加了摸鱼之王活动","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","X":"-300"}')
    else
        Player.sendmsgEx(actor, "当前不在开启时间段内，无法进入#249")
    end
end

--发送通知
local function _onMYZWTongZhi()
    FsendHuoDongGongGao("摸鱼之王活动1分钟后开启，请各位玩家合理安排时间，做好活动准备！！！")
end
GameEvent.add(EventCfg.onMYZWTongZhi, _onMYZWTongZhi, MoYuZhiWang)

local function _onMYZWStart()
    for index, value in ipairs(monNum) do
        genmon(mapID, 148, 144, value.name, 150, value.num, 250)
    end
end
--活动开始
GameEvent.add(EventCfg.onMYZWStart, _onMYZWStart, MoYuZhiWang)

--活动结束
local function _onMYZWEnd()
    killmonsters(mapID, "*", 0, false)
    for i = 1, 5, 1 do
        sendmsg("0", 2,
            '{"Msg":"摸鱼之王活动已结束！！！","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","Y":"0"}')
    end
    local list = getplaycount(mapID, 0, 0)
    if list ~= "0" then
        for _, actor in ipairs(list) do
            mapmove(actor, "n3", 330, 330, 3)
        end
    end
end
GameEvent.add(EventCfg.onMYZWEnd, _onMYZWEnd, MoYuZhiWang)

local function addPoints(actor, points)
    local currPoint = getplaydef(actor, VarCfg["U_摸鱼积分"])
    local userPoints = currPoint + points
    setplaydef(actor, VarCfg["U_摸鱼积分"], userPoints)
    Player.sendmsgEx(actor, string.format("摸鱼积分|+%d#249", points))
    local claimedRewards = Player.getJsonTableByVar(actor, VarCfg["T_摸鱼记录"])
    for i, info in ipairs(config) do
        if userPoints >= info.points and not claimedRewards[tostring(i)] then
            claimedRewards[tostring(i)] = true
            Player.setJsonVarByTable(actor, VarCfg["T_摸鱼记录"], claimedRewards)
            Player.sendmsgEx(actor, "摸鱼第|" .. i .. "#249|已发送到邮箱")
            local mailTitle = "摸鱼积分"
            local mailContent = "请领取您的第 " .. i .. " 档摸鱼奖励"
            local userID = getbaseinfo(actor, ConstCfg.gbase.id)
            Player.giveMailByTable(userID, 1, mailTitle, mailContent, info.rewards, 1, true)
        end
    end
    Message.sendmsg(actor, ssrNetMsgCfg.MoYuZhiWang_UpdateUI, userPoints, 0, 0, claimedRewards)
end

local function _onCollectTask(actor, monName, monMakeIndex, itemName)
    if FCheckMap(actor, mapID) then
        local points = pointMap[monName] or 0
        addPoints(actor, points)
    end
end
GameEvent.add(EventCfg.onCollectTask, _onCollectTask, MoYuZhiWang)

local function _goSwitchMap(actor, cur_mapid, former_mapid)
    if cur_mapid == mapID then
        setontimer(actor, 8, 2, 0)
        addbuff(actor, 31053)
        local points = getplaydef(actor, VarCfg["U_摸鱼积分"])
        local claimedRewards = Player.getJsonTableByVar(actor, VarCfg["T_摸鱼记录"])
        Message.sendmsg(actor, ssrNetMsgCfg.MoYuZhiWang_Enter, points, 0, 0, claimedRewards)
    end
    if former_mapid == mapID then
        FkfDelBuff(actor, 31053)
        setofftimer(actor, 8)
        Message.sendmsg(actor, ssrNetMsgCfg.MoYuZhiWang_Leave)
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, MoYuZhiWang)

--定时器
local function _onMYZWimer(actor)
    changemoney(actor, 3, "+", 2000, "摸鱼之王", true)
end
GameEvent.add(EventCfg.onMYZWimer, _onMYZWimer, MoYuZhiWang)


--同步消息
-- function MoYuZhiWang.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.MoYuZhiWang_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.MoYuZhiWang_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     MoYuZhiWang.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MoYuZhiWang)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.MoYuZhiWang, MoYuZhiWang)
return MoYuZhiWang
