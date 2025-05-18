local MiTuZhe = {}
local cost = {{"永恒的秘密", 1}}

function MiTuZhe.Request(actor)
    local bool = getflagstatus(actor, VarCfg["F_永恒密道_开启状态"])

    if bool == 1 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已|提交线索#249|了,请勿重复提交...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "时空穿梭")
    setflagstatus(actor, VarCfg["F_永恒密道_开启状态"], 1)
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得了|迷宫路线#249|了,快去探索吧...")
    MiTuZhe.SyncResponse(actor)
end


--注册网络消息
function MiTuZhe.SyncResponse(actor, logindatas)
    local bool = getflagstatus(actor, VarCfg["F_永恒密道_开启状态"])
    local _login_data = { ssrNetMsgCfg.MiTuZhe_SyncResponse, bool, 0, 0, nil }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MiTuZhe_SyncResponse, bool, 0, 0, nil)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.MiTuZhe, MiTuZhe)

--登录触发
local function _onLoginEnd(actor, logindatas)
    MiTuZhe.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MiTuZhe)

Message.RegisterNetMsg(ssrNetMsgCfg.MiTuZhe, MiTuZhe)

return MiTuZhe
