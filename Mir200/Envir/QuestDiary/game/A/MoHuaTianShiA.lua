local MoHuaTianShiA = {}
local cost = {{"ħ��������", 1},{"ʥ�����+10", 1},{"�칤֮��", 888},{"����ʯ", 888},{"���", 6000000}}

function MoHuaTianShiA.Request(actor ,arg1)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�۳�����")
    giveitem(actor, "����ħ����ʹ[���a]", 1, 0)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��ϳ�|����ħ����ʹ[���a]#249|�ɹ�...")
    MoHuaTianShiA.SyncResponse(actor)
end

function MoHuaTianShiA.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.MoHuaTianShiA_SyncResponse, 0, 0, 0, nil)
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.MoHuaTianShiA, MoHuaTianShiA)
return MoHuaTianShiA