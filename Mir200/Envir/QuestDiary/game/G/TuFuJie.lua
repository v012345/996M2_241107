local TuFuJie = {}
TuFuJie.ID = "土缚劫"
local cost = {{"神魂碎片",44},{"混沌本源",88},{"元宝",4444444}}

-- 暮色余晖	28	29
--接收请求
function TuFuJie.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|数量不足|%d#249|,挑战失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "进入土缚劫扣除")

    local NowMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local NowX,NowY = getbaseinfo(actor, ConstCfg.gbase.x),getbaseinfo(actor, ConstCfg.gbase.y)

    local HuiChenginfo = {["NowMapID"] = NowMapID,["NowX"] = NowX,["NowY"] = NowY}
    Player.setJsonVarByTable(actor, VarCfg["T_进入副本记录退出信息"] , HuiChenginfo)

    -- lytzg1 土缚劫
    local UserName = getbaseinfo(actor, ConstCfg.gbase.name)
    local NewMapId = "lytzg1"..UserName --根据原始地图id  配置新地图ID
    local NewMapName = "土缚劫".."[副本]"

    if checkmirrormap(NewMapId) then
        killmonsters(NewMapId, "*", 0, false)   --杀死当前地图所有怪物
        delmirrormap(NewMapId)              --删除镜像地图
        addmirrormap("lytzg1", NewMapId, NewMapName, 300, NowMapID, nil, NowX, NowY)
    else
        addmirrormap("lytzg1", NewMapId, NewMapName, 300, NowMapID, nil, NowX, NowY)
    end
    map(actor, NewMapId)
    --刷Boss
    genmon(NewMapId, 24, 25,"[土之天尊]石母·瑟拉塞恩", 1, 1, 249)
    --同步前端消息
    TuFuJie.SyncResponse(actor)
end

--任意地图击杀怪物触发
local function _onKillMon(actor, monobj, monName)
    if monName ~= "[土之天尊]石母·瑟拉塞恩" then return end
    local Bool = getflagstatus(actor,VarCfg["F_土缚劫击杀标识"] )
    if Bool == 1 then return end
    setflagstatus(actor,VarCfg["F_土缚劫击杀标识"],1)
    TuFuJie.SyncResponse(actor)
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, TuFuJie)


--同步消息
function TuFuJie.SyncResponse(actor, logindatas)
    local Bool = getflagstatus(actor,VarCfg["F_土缚劫击杀标识"])
    local data = {Bool}
    local _login_data = {ssrNetMsgCfg.TuFuJie_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.TuFuJie_SyncResponse, 0, 0, 0, data)
    end
end
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.TuFuJie, TuFuJie)

--登录触发
local function _onLoginEnd(actor, logindatas)
    TuFuJie.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TuFuJie)

return TuFuJie