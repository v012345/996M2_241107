local JingYanLaoRen = {}
JingYanLaoRen.cost = { { "��ʯ", 1 } }
function JingYanLaoRen.Request(actor)
    FSetTaskRedPoint(actor, VarCfg["F_�����������"], 17)
    local level = getbaseinfo(actor,ConstCfg.gbase.level)
    if level >= 320 then
        Player.sendmsgEx(actor, "��ĵȼ�����|320#249|��,�޷������ύ...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, JingYanLaoRen.cost)
    if name then
        Player.sendmsgEx(actor, string.format("���#250|%s#249|����|%d#249|ö,�ύʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, JingYanLaoRen.cost, "��������")
    changeexp(actor, "+", 100000000, false)
    Player.sendmsgEx(actor, string.format("��ϲ��,���|100000000#249|����!", name, num))
end

-----ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.JingYanLaoRen, JingYanLaoRen)

return JingYanLaoRen
