local SiWangZhiBaoDiCeng = {}
local cost = {{"����Կ��", 1}}

function SiWangZhiBaoDiCeng.Request(actor, var)
    if var == 1 then
        local bool = getflagstatus(actor, VarCfg["F_����֮���ײ㿪��״̬"])
        if bool == 1 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���ѿ���|����֮���ײ�#249|��ͼ��,�����ظ��ύ...")
            return
        end

        --�۳����籾Դ
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,����ʧ��...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "����֮���ײ㿪��")
        setflagstatus(actor, VarCfg["F_����֮���ײ㿪��״̬"], 1)
        SiWangZhiBaoDiCeng.SyncResponse(actor)
    end

    if var == 2 then
        local bool = getflagstatus(actor, VarCfg["F_����֮���ײ㿪��״̬"] )
        if bool == 0 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�㻹δ����|����֮���ײ�#249|��ͼ��,�޷�����...")
            return
        end
        map(actor, "����֮���ײ�")
    end
end

--ע��������Ϣ
function SiWangZhiBaoDiCeng.SyncResponse(actor, logindatas)
    local bool = getflagstatus(actor, VarCfg["F_����֮���ײ㿪��״̬"])
    local _login_data = { ssrNetMsgCfg.SiWangZhiBaoDiCeng_SyncResponse, bool, 0, 0, nil}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.SiWangZhiBaoDiCeng_SyncResponse, bool, 0, 0, nil)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.SiWangZhiBaoDiCeng, SiWangZhiBaoDiCeng)

--��¼����
local function _onLoginEnd(actor, logindatas)
    SiWangZhiBaoDiCeng.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, SiWangZhiBaoDiCeng)

return SiWangZhiBaoDiCeng
