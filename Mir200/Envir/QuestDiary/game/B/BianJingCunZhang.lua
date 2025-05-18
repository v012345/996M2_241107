local BianJingCunZhang = {}
local cost = {{"小妖精魄", 88}}
local give = {{"老村长的怀表", 1}}
function BianJingCunZhang.Request(actor)
    if getflagstatus(actor, VarCfg["F_老村长的怀表"]) == 1 then
        Player.sendmsgEx(actor, "你已经完成了该任务!#250")
        return
    end
    local name, num = Player.checkItemNumByTable(actor,cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|个,无法完成任务!", name, num))
        return
    end
    Player.takeItemByTable(actor,cost,"边境村长")
    Player.giveItemByTable(actor,give,"边境村长")
    Player.sendmsgEx(actor, "恭喜你完成任务,获得|[老村长的怀表]#250")
    FSetTaskRedPoint(actor, VarCfg["F_老村长的怀表"], 4)
    BianJingCunZhang.SyncResponse(actor)
end

Message.RegisterNetMsg(ssrNetMsgCfg.BianJingCunZhang, BianJingCunZhang)

function BianJingCunZhang.SyncResponse(actor, logindatas)
    local flag = getflagstatus(actor, VarCfg["F_老村长的怀表"])
    local _login_data = {ssrNetMsgCfg.BianJingCunZhang_SyncResponse, flag}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.BianJingCunZhang_SyncResponse, flag)
    end

end

--登录触发
local function _onLoginEnd(actor, logindatas)
    BianJingCunZhang.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, BianJingCunZhang)

return BianJingCunZhang