local QuanMinHuaShui = {}
QuanMinHuaShui.ID = "全民划水"
local config = include("QuestDiary/cfgcsv/cfg_QuanMinHuaShui.lua") --配置
local mapID = "quanminghuashui"
local HuaShuiY = 100
--请求领取奖励
function QuanMinHuaShui.Request(actor)
    if not FCheckNPCRange(actor, 124, 5) then
        Player.sendmsgEx(actor, "请离我近一点！")
        return
    end
    local falg = getflagstatus(actor, VarCfg["F_全民划水领取"])
    if falg == 1 then
        Player.sendmsgEx(actor, "你已经领取过奖励了")
        return
    end
    setflagstatus(actor, VarCfg["F_全民划水领取"], 1)
    local Gglobal = getsysvar(VarCfg["G_全民划水名字"]) + 1
    if Gglobal <= 10 then
        local cfg         = config[Gglobal]
        local rankFont    = formatNumberToChinese(Gglobal)
        local mailTitle   = "全民划水第" .. rankFont .. "名奖励"
        local mailContent = "恭喜你获得全民划水第" .. rankFont .. "名，请领取您的奖励！"
        local userID      = getbaseinfo(actor, ConstCfg.gbase.id)
        -- release_print(userID)
        Player.giveMailByTable(userID, 1, mailTitle, mailContent, cfg.reward, 1, true)
        setsysvar(VarCfg["G_全民划水名字"], Gglobal)
        local rankList = Player.getJsonTableByVar(nil, VarCfg["A_全民划水排名"])
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        table.insert(rankList, myName)
        Player.setJsonVarByTable(nil, VarCfg["A_全民划水排名"], rankList)
        Player.sendmsgEx(actor,"恭喜你获得全民划水第" .. rankFont .. "名,奖励已发送到邮件!")
        mapmove(actor,"n3", 330, 330, 3)
        local rewardStr = getItemArrToStr(cfg.reward)
        local str = string.format("{【恭喜】/FCOLOR=249}：{%s/FCOLOR=250} {在划水活动中获得第%s名，奖励/FCOLOR=249}{%s/FCOLOR=250} ", Player.GetName(actor),rankFont, rewardStr)
        sendmovemsg(actor, 1,249, 0,HuaShuiY,1,str)
        HuaShuiY = HuaShuiY + 40
    else
        local cost        = { { "5元充值红包", 1 } }
        local mailTitle   = "全民划水参与奖奖励"
        local mailContent = "恭喜你获得全民划水参与奖，请领取您的奖励！"
        local userID      = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.giveMailByTable(userID, 1, mailTitle, mailContent, cost, 1, true)
        setsysvar(VarCfg["G_全民划水名字"], Gglobal)
        Player.sendmsgEx(actor,"恭喜你获得全民划水参与奖,奖励已发送到邮件!")
        mapmove(actor,"n3", 330, 330, 3)
    end
end

function QuanMinHuaShui.EnterMap(actor)
    local falg = getflagstatus(actor, VarCfg["F_全民划水领取"])
    if falg == 1 then
        Player.sendmsgEx(actor, "你已经领取过奖励了,无法进入了!#249")
        return
    end
    local min = getsysvar(VarCfg["G_开区分钟计时器"])
    --(G1>=15&G1<35)#(G1>=135&G1<155)
    if min >= 45 and min < 55 then
        FMapMoveEx(actor, mapID, 147, 188, 0)
        local name = getbaseinfo(actor, ConstCfg.gbase.name)
        sendmsg("0", 2, '{"Msg":"['..name..']参加了全民划水活动","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","X":"-300"}')
    else
        Player.sendmsgEx(actor, "当前不在开启时间段内，无法进入#249")
        return
    end
end

--发送通知
local function _onQMHSSendTongZhi()
    FsendHuoDongGongGao("全民划水活动1分钟后开启，请各位玩家合理安排时间，做好活动准备！！！")
end
GameEvent.add(EventCfg.onQMHSSendTongZhi, _onQMHSSendTongZhi, QuanMinHuaShui)


--活动结束
local function _onQMHSEnd()
    for i = 1, 5, 1 do
        sendmsg("0", 2, '{"Msg":"全民划水活动已结束！！！","FColor":250,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","Y":"0"}')
    end
    local list = getplaycount(mapID, 0, 0)
    if list ~= "0" then
        for _, actor in ipairs(list) do
            mapmove(actor, "n3", 330, 330, 3)
        end
    end
end
GameEvent.add(EventCfg.onQMHSEnd, _onQMHSEnd, QuanMinHuaShui)

--切换地图触发
local function _goSwitchMap(actor, cur_mapid, former_mapid)
    if cur_mapid == mapID then
        setontimer(actor, 7, 1, 0)
        addbuff(actor, 31053)
    end
    if former_mapid == mapID then
        FkfDelBuff(actor, 31053)
        setofftimer(actor, 7)
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, QuanMinHuaShui)
local randomState = {}
randomState[1] = function(actor)
    --麻痹
    makeposion(actor, 5, 3)
end
randomState[2] = function(actor)
    --冰冻
    makeposion(actor, 12, 3)
end
randomState[3] = function(actor)
    --减速
    makeposion(actor, 13, 3)
end

local function _onQMHTimer(actor)
    if randomex(10) then
        local randomIndex = math.random(3)
        local func = randomState[randomIndex]
        func(actor)
    end
end
GameEvent.add(EventCfg.onQMHTimer, _onQMHTimer, QuanMinHuaShui)

--点击NPC触发
local function _onClicknpc(actor, npcid, npcobj)
    if npcid == 124 then
        if not FCheckNPCRange(actor, 124, 5) then
            Player.sendmsgEx(actor, "请离我近一点！")
            return
        end
        local rankList = Player.getJsonTableByVar(nil, VarCfg["A_全民划水排名"])
        Message.sendmsg(actor, ssrNetMsgCfg.QuanMinHuaShui_OpenUI, 0, 0, 0, rankList)
    end
    
end
GameEvent.add(EventCfg.onClicknpc, _onClicknpc, QuanMinHuaShui)

--同步消息
-- function QuanMinHuaShui.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.QuanMinHuaShui_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.QuanMinHuaShui_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     QuanMinHuaShui.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, QuanMinHuaShui)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QuanMinHuaShui, QuanMinHuaShui)
return QuanMinHuaShui
