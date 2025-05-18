local QiXingGongYueZhen = {}
local cost = {{"异界神石", 588},{"混沌本源", 88}}

function QiXingGongYueZhen.Request(actor,var)
    local Verify = (var ~= 1) and (var ~= 2)
    if Verify then return end

    -- 开启地图
    if var == 1 then
        if getflagstatus(actor, VarCfg["F_七星拱月地图标识"]) == 1 then return end

        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,开启失败...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "开启七星拱月地图扣除")
        setflagstatus(actor, VarCfg["F_七星拱月地图标识"], 1)
        QiXingGongYueZhen.SyncResponse(actor)
    end

    --进入地图
    if var == 2 then
        if getflagstatus(actor, VarCfg["F_七星拱月地图标识"]) == 0 then return end
        mapmove(actor, "七星拱月阵", 100, 120, 2)
    end
end


--注册网络消息
function QiXingGongYueZhen.SyncResponse(actor, logindatas)
    local mapbool = getflagstatus(actor, VarCfg["F_七星拱月地图标识"])

    local _login_data = { ssrNetMsgCfg.QiXingGongYueZhen_SyncResponse, 0, 0, 0, {mapbool} }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.QiXingGongYueZhen_SyncResponse, 0, 0, 0, {mapbool})
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.QiXingGongYueZhen, QiXingGongYueZhen)


--登录触发
local function _onLoginEnd(actor, logindatas)
    QiXingGongYueZhen.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, QiXingGongYueZhen)

return QiXingGongYueZhen
