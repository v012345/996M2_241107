local MoHuaTianShiB = {}
local cost1 = {{"[����]������", 1},{"����ħ����ʹ[���a]", 1},{"�칤֮��", 1288},{"����ʯ", 1288},{"���", 30000000}}
local cost2 = {{"[����]������", 1},{"����ħ����ʹ[���a]", 1},{"�칤֮��", 1288},{"����ʯ", 1288},{"Ԫ��", 2000000}}

function MoHuaTianShiB.Request(actor ,arg1)
    if arg1 == 1 then
        local name, num = Player.checkItemNumByTable(actor, cost1)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
            return
        end
        if randomex(25, 100) then    --  ��ʾ70%  ʵ��25%
            giveitem(actor, "����ħ����ʹ[����]", 1, 0)
            Player.takeItemByTable(actor, cost1, "�۳�����")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�ϳ�|����ħ����ʹ[���a]#249|�ɹ�...")
        else
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�ϳ�|����ħ����ʹ[���a]#249|ʧ��...")
            Player.takeItemByTable(actor, {{"���", 30000000}}, "ʧ�ܿ۳����")
        end
        MoHuaTianShiB.SyncResponse(actor)
    end

    if arg1 == 2 then
        local name, num = Player.checkItemNumByTable(actor, cost2)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost2, "�۳�����")
        giveitem(actor, "����ħ����ʹ[����]", 1, 0)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��ϳ�|����ħ����ʹ[����]#249|�ɹ�...")
        MoHuaTianShiB.SyncResponse(actor)
    end

end

function MoHuaTianShiB.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.MoHuaTianShiB_SyncResponse, 0, 0, 0, nil)
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.MoHuaTianShiB, MoHuaTianShiB)
return MoHuaTianShiB