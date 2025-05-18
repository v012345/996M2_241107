local YouLingChenChuan = {}
local cost = {{"����������", 1}}

function YouLingChenChuan.Request(actor, var)
    if var == 1 then
        local bool = getflagstatus(actor, VarCfg["F_�������_����״̬"] )
        if bool == 1 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���ѿ���|�������#249|��ͼ��,�����ظ��ύ...")
            return
        end
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,�ύʧ��...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "�۳�����������")
        setflagstatus(actor, VarCfg["F_�������_����״̬"], 1)
        YouLingChenChuan.SyncResponse(actor)
    end


    if var == 2 then
        local bool = getflagstatus(actor, VarCfg["F_�������_����״̬"] )
        if bool == 0 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�㻹δ����|�������#249|��ͼ��,�޷�����...")
            return
        end
        map(actor, "��ڤ����")
    end

end


--ע��������Ϣ
function YouLingChenChuan.SyncResponse(actor, logindatas)
    local bool = getflagstatus(actor, VarCfg["F_�������_����״̬"])
    local data ={ bool}
    local _login_data = { ssrNetMsgCfg.YouLingChenChuan_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YouLingChenChuan_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.YouLingChenChuan, YouLingChenChuan)



--��¼����
local function _onLoginEnd(actor, logindatas)
    YouLingChenChuan.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YouLingChenChuan)



return YouLingChenChuan
