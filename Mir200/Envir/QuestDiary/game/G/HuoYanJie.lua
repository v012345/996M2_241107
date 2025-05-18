local HuoYanJie = {}
HuoYanJie.ID = "火焰劫"
local cost = {{"神魂碎片",44},{"混沌本源",88},{"元宝",4444444}}

-- 溶血之池	69	73

--接收请求
function HuoYanJie.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|数量不足|%d#249|,挑战失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "进入火焰劫扣除")

    local NowMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local NowX,NowY = getbaseinfo(actor, ConstCfg.gbase.x),getbaseinfo(actor, ConstCfg.gbase.y)

    local HuiChenginfo = {["NowMapID"] = NowMapID,["NowX"] = NowX,["NowY"] = NowY}
    Player.setJsonVarByTable(actor, VarCfg["T_进入副本记录退出信息"] , HuiChenginfo)

    -- zytzg1 火焰劫
    local UserName = getbaseinfo(actor, ConstCfg.gbase.name)
    local NewMapId = "zytzg1"..UserName --根据原始地图id  配置新地图ID
    local NewMapName = "火焰劫".."[副本]"

    if checkmirrormap(NewMapId) then
        killmonsters(NewMapId, "*", 0, false)   --杀死当前地图所有怪物
        delmirrormap(NewMapId)              --删除镜像地图
        addmirrormap("zytzg1", NewMapId, NewMapName, 300, NowMapID, nil, NowX, NowY)
    else
        addmirrormap("zytzg1", NewMapId, NewMapName, 300, NowMapID, nil, NowX, NowY)
    end
    map(actor, NewMapId)
    --刷Boss
    genmon(NewMapId, 24, 25,"[火之天尊]炎魔·拉格纳罗斯", 1, 1, 249)
    --同步前端消息
    HuoYanJie.SyncResponse(actor)
end

--任意地图击杀怪物触发
local function _onKillMon(actor, monobj, monName)
    if monName ~= "[火之天尊]炎魔·拉格纳罗斯" then return end
    local Bool = getflagstatus(actor,VarCfg["F_火焰劫击杀标识"] )
    if Bool == 1 then return end
    setflagstatus(actor,VarCfg["F_火焰劫击杀标识"],1)
    HuoYanJie.SyncResponse(actor)
    release_print(actor, "触发火焰劫Boss击杀")
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, HuoYanJie)

-- 同步消息
function HuoYanJie.SyncResponse(actor, logindatas)
    local Bool = getflagstatus(actor,VarCfg["F_火焰劫击杀标识"])
    local data = {Bool}
    local _login_data = {ssrNetMsgCfg.HuoYanJie_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.HuoYanJie_SyncResponse, 0, 0, 0, data)
    end
end
-- 注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HuoYanJie, HuoYanJie)

--登录触发
local function _onLoginEnd(actor, logindatas)
    HuoYanJie.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HuoYanJie)

return HuoYanJie