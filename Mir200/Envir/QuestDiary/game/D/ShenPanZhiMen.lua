local ShenPanZhiMen = {}
local cost = { { "时空门票", 1 }}

function ShenPanZhiMen.Request(actor)
    local bout = getplaydef(actor, VarCfg["J_审判次数"])

    if bout == 5 then
        Player.sendmsgEx(actor, "提示#251|:#255|你今天进入|审判之门#249|已经达到|5#249|次...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|张,进入失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "扣除材料")
    setplaydef(actor, VarCfg["J_审判次数"], bout + 1)

    local UserName = getconst(actor, "<$USERNAME>")
    -- local UserId = getconst(actor, "<$USERID>")
    local FormerMapId = "shenmi"
    local NewMapId = "shenmi"..UserName
    local NewMapName = UserName.."的审判副本"
    killmonsters("shenmi", "*", 0, false)   --杀死当前地图所有怪物

    if checkmirrormap(NewMapId) then
        delmirrormap(NewMapId)
        addmirrormap(FormerMapId, NewMapId, NewMapName, 300, "时间迷宫", 10059, 43, 41)
    else
        addmirrormap(FormerMapId, NewMapId, NewMapName, 300, "时间迷宫", 10059, 43, 41)
    end
    FSetTaskRedPoint(actor, VarCfg["F_时间迷宫完成"], 14)
    map(actor, NewMapId)
    genmon(NewMapId, 24, 33 , "无域≮超空间≯死神之镰", 0, 1, 249)
    delaygoto(actor, 500, "jin_ru_fu_ben_ti_shi,300")
    ShenPanZhiMen.SyncResponse(actor)
end

--注册网络消息
function ShenPanZhiMen.SyncResponse(actor, logindatas)
    local data = { getplaydef(actor, VarCfg["J_审判次数"]) }
    local _login_data = { ssrNetMsgCfg.ShenPanZhiMen_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShenPanZhiMen_SyncResponse, 0, 0, 0, data)
    end
end



--登录触发
local function _onLoginEnd(actor, logindatas)
    ShenPanZhiMen.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenPanZhiMen)

Message.RegisterNetMsg(ssrNetMsgCfg.ShenPanZhiMen, ShenPanZhiMen)
return ShenPanZhiMen
