local PoXiaoZhiYan = {}
local cost = {{"安晓的左眼", 1},{"造化结晶", 888},{"安晓的右眼", 1},{"灵符", 6666}}

function PoXiaoZhiYan.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "时空穿梭")
    giveitem(actor, "“破晓之眼”", 1, ConstCfg.binding)
    setflagstatus(actor, VarCfg["F_破晓之眼_合成"], 1)
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你合成|“破晓之眼”#249|成功...")
    PoXiaoZhiYan.SyncResponse(actor)
end


--注册网络消息
function PoXiaoZhiYan.SyncResponse(actor, logindatas)
    Message.sendmsg(actor, ssrNetMsgCfg.PoXiaoZhiYan_SyncResponse, 0, 0, 0, nil)
end
Message.RegisterNetMsg(ssrNetMsgCfg.PoXiaoZhiYan, PoXiaoZhiYan)

return PoXiaoZhiYan

