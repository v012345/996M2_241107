local YanJiShiHeDaEr = {}
local cost = {{"�׻���Ƭ", 1}}
function YanJiShiHeDaEr.Request(actor,var)
    if var == 1 then
        local Number = getplaydef(actor, VarCfg["U_�׻���Ƭ_�ύ����"])
        if Number >= 10 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���ύ|�׻���Ƭ#249|�Ѿ�����|10��#249|��...")
            return
        end
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "�׻���Ƭ�۳�")
        setplaydef(actor, VarCfg["U_�׻���Ƭ_�ύ����"], Number+1)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�ύ|�׻���Ƭ#249|�ɹ�...")
        Player.setAttList(actor, "���Ը���")
        YanJiShiHeDaEr.SyncResponse(actor)
    end



    if var == 2 then
        local Number = getplaydef(actor, VarCfg["U_�׻���Ƭ_�ύ����"])
        if Number < 10 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���ύ|�׻���Ƭ#249|����|10��#249|�޷���ȡ...")
            return
        end

        local bool = getflagstatus(actor, VarCfg["F_��ҫ����_��ȡ״̬"] )
        if bool == 1 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,����ȡ|��ҫ����#249|��,�����ظ���ȡ...")
            return
        end
        giveitem(actor, "��ҫ����", 1, 0, "���������ҫ����")
        setflagstatus(actor, VarCfg["F_��ҫ����_��ȡ״̬"], 1)
       
    end
end

--��������
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    local num = getplaydef(actor, VarCfg["U_�׻���Ƭ_�ύ����"])
    if num > 0 then
        shuxing[1]   = 1000 * num  --����
        shuxing[200] = 388  * num  --�и�ֵ
    end
    calcAtts(attrs, shuxing, "���ʦ���մ��")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YanJiShiHeDaEr)

--ע��������Ϣ
function YanJiShiHeDaEr.SyncResponse(actor, logindatas)
    local num = getplaydef(actor, VarCfg["U_�׻���Ƭ_�ύ����"])
    local bool = getflagstatus(actor, VarCfg["F_��ҫ����_��ȡ״̬"] )
    local _login_data = { ssrNetMsgCfg.YanJiShiHeDaEr_SyncResponse, num, bool, 0, nil }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YanJiShiHeDaEr_SyncResponse, num, bool, 0, nil)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.YanJiShiHeDaEr, YanJiShiHeDaEr)

--��¼����
local function _onLoginEnd(actor, logindatas)
    YanJiShiHeDaEr.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YanJiShiHeDaEr)


return YanJiShiHeDaEr
