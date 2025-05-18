local MiTuZhe = {}
local cost = {{"���������", 1}}

function MiTuZhe.Request(actor)
    local bool = getflagstatus(actor, VarCfg["F_�����ܵ�_����״̬"])

    if bool == 1 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,����|�ύ����#249|��,�����ظ��ύ...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "ʱ�մ���")
    setflagstatus(actor, VarCfg["F_�����ܵ�_����״̬"], 1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�����|�Թ�·��#249|��,��ȥ̽����...")
    MiTuZhe.SyncResponse(actor)
end


--ע��������Ϣ
function MiTuZhe.SyncResponse(actor, logindatas)
    local bool = getflagstatus(actor, VarCfg["F_�����ܵ�_����״̬"])
    local _login_data = { ssrNetMsgCfg.MiTuZhe_SyncResponse, bool, 0, 0, nil }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MiTuZhe_SyncResponse, bool, 0, 0, nil)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.MiTuZhe, MiTuZhe)

--��¼����
local function _onLoginEnd(actor, logindatas)
    MiTuZhe.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MiTuZhe)

Message.RegisterNetMsg(ssrNetMsgCfg.MiTuZhe, MiTuZhe)

return MiTuZhe
