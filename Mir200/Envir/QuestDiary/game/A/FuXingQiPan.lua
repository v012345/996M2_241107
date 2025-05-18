local FuXingQiPan = {}
FuXingQiPan.ID = "福星棋盘"
local config = include("QuestDiary/cfgcsv/cfg_FuXingQiPan.lua") --配置
local cost = { {} }
local give = { {} }
local mapID = "福星棋盘"
--接收请求
function FuXingQiPan.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
    --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
    --return
    --end
end

function FuXingQiPan.EnterMap(actor)
    local min = getsysvar(VarCfg["G_开区分钟计时器"])
    --(G1>=15&G1<35)#(G1>=135&G1<155)
    if (min>=15 and min<35) or (min>=135 and min<155) then
        FMapEx(actor, mapID)
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        sendmsg("0", 2, '{"Msg":"['..name..']参加了福星棋盘活动","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","X":"-300"}')
    else
        Player.sendmsgEx(actor, "当前不在开启时间段内，无法进入#249")
    end
end

--发送通知

local function _onFXQPSendTongZhi()
    FsendHuoDongGongGao("福星棋盘活动1分钟后开启，请各位玩家合理安排时间，做好活动准备！！！")
end

GameEvent.add(EventCfg.onFXQPSendTongZhi, _onFXQPSendTongZhi, FuXingQiPan)

--活动开始
local function _onFXQPStart()
    for index, value in ipairs(config) do
        genmon(mapID, value.x, value.y, value.name, 0, value.num, value.color)
    end
end
GameEvent.add(EventCfg.onFXQPStart, _onFXQPStart, FuXingQiPan)

--刷新中间的boss
local function _onFXQPResreshBoss()
    FsendHuoDongGongGao("福星棋盘活动活动地图中间刷新了【牛马发财树】，击杀后可获得大量奖励！！！")
    genmon(mapID, 113, 127, "牛马发财树", 0, 1, 251)
end
GameEvent.add(EventCfg.onFXQPResreshBoss, _onFXQPResreshBoss, FuXingQiPan)

--活动结束
local function _onFXQPEnd()
    killmonsters(mapID, "*", 0, false)
    for i = 1, 5, 1 do
        sendmsg("0", 2, '{"Msg":"福星棋盘活动已结束！！！","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","Y":"0"}')
    end
    local list = getplaycount(mapID, 0, 0)
    if list ~= "0" then
        for _, actor in ipairs(list) do
            mapmove(actor, "n3", 330, 330, 3)
        end
    end
end
GameEvent.add(EventCfg.onFXQPEnd, _onFXQPEnd, FuXingQiPan)

--杀怪触发
local function _onKillMon(actor, monobj, monName)
    if FCheckMap(actor, mapID) and monName == "牛马发财树" then
        throwitem(actor, "福星棋盘", 113, 128, 10, "5元充值红包", 40, 30, true, false, false, false, 1, false)
        throwitem(actor, "福星棋盘", 113, 128, 10, "1元充值红包", 20, 30, true, false, false, false, 1, false)
        throwitem(actor, "福星棋盘", 113, 128, 10, "神秘专属盲盒", 1, 30, true, false, false, false, 1, false)
        throwitem(actor, "福星棋盘", 113, 128, 10, "高级神器盲盒", 1, 30, true, false, false, false, 1, false)
        throwitem(actor, "福星棋盘", 113, 128, 10, "金条", 2, 30, true, false, false, false, 1, false)
        throwitem(actor, "福星棋盘", 113, 128, 10, "境界丹", 4, 30, true, false, false, false, 1, false)
        throwitem(actor, "福星棋盘", 113, 128, 10, "精魄碎片", 3, 30, true, false, false, false, 1, false)
        throwitem(actor, "福星棋盘", 113, 128, 10, "转运之尘", 3, 30, true, false, false, false, 1, false)
        throwitem(actor, "福星棋盘", 113, 128, 10, "1000元宝", 10, 30, true, false, false, false, 1, false)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, FuXingQiPan)

local function _goSwitchMap(actor, cur_mapid, former_mapid)
    if cur_mapid == mapID then
        setontimer(actor, 6, 2, 0)
    end
    if former_mapid == mapID then
        setofftimer(actor, 6)
    end
end
--切换地图触发
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, FuXingQiPan)

--每秒
local function _onFXQPReward(actor)
    changemoney(actor, 3 , "+", 1000, "福星棋盘", true)
end
GameEvent.add(EventCfg.onFXQPReward, _onFXQPReward, FuXingQiPan)
--同步消息
-- function FuXingQiPan.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.FuXingQiPan_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.FuXingQiPan_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     FuXingQiPan.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FuXingQiPan)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.FuXingQiPan, FuXingQiPan)
return FuXingQiPan
