local MoHuaTianShiD = {}
local cost1 = {{"[����]�ǻ�֮��", 1},{"����ħ����ʹ[�o�M]", 1},{"�칤֮��", 2888},{"����ʯ", 2888},{"Ԫ��", 4000000}}
local cost2 = {{"[����]�ǻ�֮��", 1},{"����ħ����ʹ[�o�M]", 1},{"�칤֮��", 2888},{"����ʯ", 2888},{"���", 10000}}

function MoHuaTianShiD.Request(actor ,arg1)
    if arg1 == 1 then
        local _num = getplaydef(actor,VarCfg["U_ħ����ʹ[����]"])
        local name, num = Player.checkItemNumByTable(actor, cost1)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
            return
        end
        _num = _num + 1
        setplaydef(actor, VarCfg["U_ħ����ʹ[����]"], _num)
        if _num == 1 or _num == 2 or _num == 3 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�ϳ�|����ħ����ʹ[����]#249|ʧ��...")
            Player.takeItemByTable(actor, {{"Ԫ��", 4000000}}, "����ħ����ʹ[����]ʧ�ܿ۳�Ԫ��")
        elseif _num == 4 or _num == 5 then
            if randomex(1, 2) then --4-5��50%
                giveitem(actor, "����ħ����ʹ[����]", 1, ConstCfg.binding)
                Player.takeItemByTable(actor, cost1, "���ɳɹ��۳�����")
                setflagstatus(actor,VarCfg["F_����ħ����ʹ[����]_���"],1)
                Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�ϳ�|����ħ����ʹ[���a]#249|�ɹ�...")
            else
                Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�ϳ�|����ħ����ʹ[����]#249|ʧ��...")
                Player.takeItemByTable(actor, {{"Ԫ��", 4000000}}, "����ħ����ʹ[����]ʧ�ܿ۳�Ԫ��")
            end
        elseif _num >= 6 then
            giveitem(actor, "����ħ����ʹ[����]", 1, ConstCfg.binding)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�ϳ�|����ħ����ʹ[���a]#249|�ɹ�...")
            Player.takeItemByTable(actor, cost1, "���ɳɹ��۳�����")
            setflagstatus(actor,VarCfg["F_����ħ����ʹ[����]_���"],1)
        end
        MoHuaTianShiD.SyncResponse(actor)
    end

    if arg1 == 2 then
        local name, num = Player.checkItemNumByTable(actor, cost2)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost2, "���ɳɹ��۳�����")
        giveitem(actor, "����ħ����ʹ[����]", 1, ConstCfg.binding)
        setflagstatus(actor,VarCfg["F_����ħ����ʹ[����]_���"],1)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��ϳ�|����ħ����ʹ[�o�M]#249|�ɹ�...")
        MoHuaTianShiD.SyncResponse(actor)
    end

end

function MoHuaTianShiD.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.MoHuaTianShiD_SyncResponse, 0, 0, 0, nil)
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.MoHuaTianShiD, MoHuaTianShiD)
return MoHuaTianShiD