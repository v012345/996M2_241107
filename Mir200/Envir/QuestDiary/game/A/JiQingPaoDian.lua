local JiQingPaoDian = {}
JiQingPaoDian.ID = "激情泡点"
--local config = include("QuestDiary/cfgcsv/cfg_JiQingPaoDian.lua") --配置
local mapID = "激情泡点"
--接收请求
function JiQingPaoDian.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
    --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
    --return
    --end
end

function JiQingPaoDian.EnterMap(actor)
    local min = getsysvar(VarCfg["G_开区分钟计时器"])
    if min >= 75 and min < 85 then
        FMapMoveEx(actor, mapID, 27, 26, 5)
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        sendmsg("0", 2, '{"Msg":"['..name..']参加了激情泡点活动","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","X":"-300"}')
    else
        Player.sendmsgEx(actor, "当前不在开启时间段内，无法进入#249")
    end
end

--切换地图
local function _goSwitchMap(actor, cur_mapid, former_mapid)
    if cur_mapid == mapID then
        setontimer(actor, 9, 2, 0)
    end
    if former_mapid == mapID then
        setofftimer(actor, 9)
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, JiQingPaoDian)

--定时器
local function _onJQPDimer(actor)
    if FCheckMap(actor, mapID) then
        local min = getsysvar(VarCfg["G_开区分钟计时器"])
        local bool = min >= 75 and min < 85
        if not bool then
            return
        end
        local x = getbaseinfo(actor, ConstCfg.gbase.x)
        local y = getbaseinfo(actor, ConstCfg.gbase.y)
        if FisInRange(x, y, 40, 28, 1) or
            FisInRange(x, y, 29, 36, 1) or
            FisInRange(x, y, 14, 31, 1) or
            FisInRange(x, y, 33, 17, 1) or
            FisInRange(x, y, 17, 19, 1)
        then
            changeexp(actor, "+", 200000, false)
            changemoney(actor, 3, "+", 5000, "激情泡点", true)
        elseif FisInRange(x, y, 27, 26, 5) then
            changeexp(actor, "+", 500000, false)
            changemoney(actor, 3, "+", 10000, "激情泡点", true)
        else
            changeexp(actor, "+", 100000, false)
            changemoney(actor, 3, "+", 1000, "激情泡点", true)
        end
    end
end
GameEvent.add(EventCfg.onJQPDimer, _onJQPDimer, JiQingPaoDian)

--枚举地图特效
local emunMapEffect = {
    { x = 17, y = 19, effID = 63031 },
    { x = 33, y = 17, effID = 63031 },
    { x = 40, y = 28, effID = 63031 },
    { x = 29, y = 36, effID = 63031 },
    { x = 14, y = 31, effID = 63031 },
    { x = 27, y = 26, effID = 63032 },
}
--开始
local function _onJQPDStart()
    for index, value in ipairs(emunMapEffect) do
        mapeffect(index, mapID, value.x, value.y, value.effID, 600, nil, 0)
    end
end
GameEvent.add(EventCfg.onJQPDStart, _onJQPDStart, JiQingPaoDian)
--活动结束
local function _onJQPDEnd()
    for i = 1, 5, 1 do
        sendmsg("0", 2, '{"Msg":"激情泡点活动已结束！！！","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","Y":"0"}')
    end
    local list = getplaycount(mapID, 0, 0)
    if list ~= "0" then
        for _, actor in ipairs(list) do
            mapmove(actor, "n3", 330, 330, 3)
        end
    end
end
GameEvent.add(EventCfg.onJQPDEnd, _onJQPDEnd, JiQingPaoDian)
--通知
local function _onJQPDTongZhi()
    FsendHuoDongGongGao("激情泡点活动1分钟后开启，请各位玩家合理安排时间，做好活动准备！！！")
end
GameEvent.add(EventCfg.onJQPDTongZhi, _onJQPDTongZhi, JiQingPaoDian)
--同步消息
-- function JiQingPaoDian.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.JiQingPaoDian_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.JiQingPaoDian_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     JiQingPaoDian.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JiQingPaoDian)
--注册网络消息

Message.RegisterNetMsg(ssrNetMsgCfg.JiQingPaoDian, JiQingPaoDian)
return JiQingPaoDian
