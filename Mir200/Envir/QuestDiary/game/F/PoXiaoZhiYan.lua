local PoXiaoZhiYan = {}
local cost = {{"����������", 1},{"�컯�ᾧ", 888},{"����������", 1},{"���", 6666}}

function PoXiaoZhiYan.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "ʱ�մ���")
    giveitem(actor, "������֮�ۡ�", 1, ConstCfg.binding)
    setflagstatus(actor, VarCfg["F_����֮��_�ϳ�"], 1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��ϳ�|������֮�ۡ�#249|�ɹ�...")
    PoXiaoZhiYan.SyncResponse(actor)
end


--ע��������Ϣ
function PoXiaoZhiYan.SyncResponse(actor, logindatas)
    Message.sendmsg(actor, ssrNetMsgCfg.PoXiaoZhiYan_SyncResponse, 0, 0, 0, nil)
end
Message.RegisterNetMsg(ssrNetMsgCfg.PoXiaoZhiYan, PoXiaoZhiYan)

return PoXiaoZhiYan

