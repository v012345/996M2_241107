local MoHuaTianShiC = {}
local cost1 = {{"[�o�M]����֮��", 1},{"����ħ����ʹ[����]", 1},{"�칤֮��", 1888},{"����ʯ", 1888},{"���", 60000000}}
local cost2 = {{"[�o�M]����֮��", 1},{"����ħ����ʹ[����]", 1},{"�칤֮��", 1888},{"����ʯ", 1888},{"Ԫ��", 5000000}}

function MoHuaTianShiC.Request(actor ,arg1)
    if arg1 == 1 then
        local name, num = Player.checkItemNumByTable(actor, cost1)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
            return
        end
        MoHuaTianShiC.SyncResponse(actor)

        if randomex(15, 100) then    --  ��ʾ40%  ʵ��15%
            giveitem(actor, "����ħ����ʹ[�o�M]", 1, 0)
            Player.takeItemByTable(actor, cost1, "�۳�����")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�ϳ�|����ħ����ʹ[���a]#249|�ɹ�...")
        else
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�ϳ�|����ħ����ʹ[���a]#249|ʧ��...")
            Player.takeItemByTable(actor, {{"���", 60000000}}, "ʧ�ܿ۳����")
        end
    end

    if arg1 == 2 then
        local name, num = Player.checkItemNumByTable(actor, cost2)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost2, "�۳�����")
        giveitem(actor, "����ħ����ʹ[�o�M]", 1, 0)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��ϳ�|����ħ����ʹ[�o�M]#249|�ɹ�...")
        MoHuaTianShiC.SyncResponse(actor)
    end
end

function MoHuaTianShiC.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.MoHuaTianShiC_SyncResponse, 0, 0, 0, nil)
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.MoHuaTianShiC, MoHuaTianShiC)
return MoHuaTianShiC