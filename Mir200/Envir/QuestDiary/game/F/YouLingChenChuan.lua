local YouLingChenChuan = {}
local cost = {{"沉船的线索", 1}}

function YouLingChenChuan.Request(actor, var)
    if var == 1 then
        local bool = getflagstatus(actor, VarCfg["F_幽灵沉船_开启状态"] )
        if bool == 1 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已开启|幽灵沉船#249|地图了,请勿重复提交...")
            return
        end
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,提交失败...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "扣除沉船的线索")
        setflagstatus(actor, VarCfg["F_幽灵沉船_开启状态"], 1)
        YouLingChenChuan.SyncResponse(actor)
    end


    if var == 2 then
        local bool = getflagstatus(actor, VarCfg["F_幽灵沉船_开启状态"] )
        if bool == 0 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你还未开启|幽灵沉船#249|地图了,无法进入...")
            return
        end
        map(actor, "幽冥沉船")
    end

end


--注册网络消息
function YouLingChenChuan.SyncResponse(actor, logindatas)
    local bool = getflagstatus(actor, VarCfg["F_幽灵沉船_开启状态"])
    local data ={ bool}
    local _login_data = { ssrNetMsgCfg.YouLingChenChuan_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YouLingChenChuan_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.YouLingChenChuan, YouLingChenChuan)



--登录触发
local function _onLoginEnd(actor, logindatas)
    YouLingChenChuan.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YouLingChenChuan)



return YouLingChenChuan
