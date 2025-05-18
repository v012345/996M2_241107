local SiWangZhiBaoDiCeng = {}
local cost = {{"禁忌钥匙", 1}}

function SiWangZhiBaoDiCeng.Request(actor, var)
    if var == 1 then
        local bool = getflagstatus(actor, VarCfg["F_死亡之堡底层开启状态"])
        if bool == 1 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已开启|死亡之堡底层#249|地图了,请勿重复提交...")
            return
        end

        --扣除混沌本源
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,开启失败...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "死亡之堡底层开启")
        setflagstatus(actor, VarCfg["F_死亡之堡底层开启状态"], 1)
        SiWangZhiBaoDiCeng.SyncResponse(actor)
    end

    if var == 2 then
        local bool = getflagstatus(actor, VarCfg["F_死亡之堡底层开启状态"] )
        if bool == 0 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你还未开启|死亡之堡底层#249|地图了,无法进入...")
            return
        end
        map(actor, "死亡之堡底层")
    end
end

--注册网络消息
function SiWangZhiBaoDiCeng.SyncResponse(actor, logindatas)
    local bool = getflagstatus(actor, VarCfg["F_死亡之堡底层开启状态"])
    local _login_data = { ssrNetMsgCfg.SiWangZhiBaoDiCeng_SyncResponse, bool, 0, 0, nil}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.SiWangZhiBaoDiCeng_SyncResponse, bool, 0, 0, nil)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.SiWangZhiBaoDiCeng, SiWangZhiBaoDiCeng)

--登录触发
local function _onLoginEnd(actor, logindatas)
    SiWangZhiBaoDiCeng.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, SiWangZhiBaoDiCeng)

return SiWangZhiBaoDiCeng
