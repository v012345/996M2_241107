local GuDiXiaYiJi = {}
local cost = {{"���籾Դ", 38}}

function GuDiXiaYiJi.Request(actor, var)
    if var == 1 then
        local bool = getflagstatus(actor, VarCfg["F_�ŵ����ż�_����״̬"])
        if bool == 1 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���ѿ���|�ŵ����ż�#249|��ͼ��,�����ظ��ύ...")
            return
        end
        local DianFengLevel = getplaydef(actor,VarCfg["U_�۷�ȼ�2"])
        if DianFengLevel < 5 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,��δ�ﵽ|�۷����5#249|,����ʧ��...")
            return
        end
        --�۳����籾Դ
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,����ʧ��...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "�ŵ����ż�����")
        setflagstatus(actor, VarCfg["F_�ŵ����ż�_����״̬"], 1)
        GuDiXiaYiJi.SyncResponse(actor)
    end

    if var == 2 then
        local bool = getflagstatus(actor, VarCfg["F_�ŵ����ż�_����״̬"] )
        if bool == 0 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�㻹δ����|�ŵ����ż�#249|��ͼ��,�޷�����...")
            return
        end
        map(actor, "�ŵ����ż�")
    end
end

--ע��������Ϣ
function GuDiXiaYiJi.SyncResponse(actor, logindatas)
    local bool = getflagstatus(actor, VarCfg["F_�ŵ����ż�_����״̬"])
    local _login_data = { ssrNetMsgCfg.GuDiXiaYiJi_SyncResponse, bool, 0, 0, nil}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.GuDiXiaYiJi_SyncResponse, bool, 0, 0, nil)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.GuDiXiaYiJi, GuDiXiaYiJi)

--��¼����
local function _onLoginEnd(actor, logindatas)
    GuDiXiaYiJi.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, GuDiXiaYiJi)

return GuDiXiaYiJi
