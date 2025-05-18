local JingYanLaoRen = {}
JingYanLaoRen.cost = { { "灵石", 1 } }
function JingYanLaoRen.Request(actor)
    FSetTaskRedPoint(actor, VarCfg["F_经验老人完成"], 17)
    local level = getbaseinfo(actor,ConstCfg.gbase.level)
    if level >= 320 then
        Player.sendmsgEx(actor, "你的等级超过|320#249|级,无法继续提交...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, JingYanLaoRen.cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的#250|%s#249|不足|%d#249|枚,提交失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, JingYanLaoRen.cost, "经验老人")
    changeexp(actor, "+", 100000000, false)
    Player.sendmsgEx(actor, string.format("恭喜你,获得|100000000#249|经验!", name, num))
end

-----注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.JingYanLaoRen, JingYanLaoRen)

return JingYanLaoRen
