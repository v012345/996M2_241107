local QiYuShiJian09 = {}

function QiYuShiJian09.Request(actor, arg1)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�9"])
    if verify ~= "��Ů��ԡ" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    if arg1 == 1 then
        if verify == "��Ů��ԡ" then
            addbuff(actor, 31011, 1800, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|������������|5%#249|��,����|3600#249|��...")
            setplaydef(actor, VarCfg["S$�����¼�9"], "")
        end
    elseif arg1 == 2 then
        if verify == "��Ů��ԡ" then
            addbuff(actor, 31012, 1800, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|���������������|5%#249|,����|1800#249|��...")
            setplaydef(actor, VarCfg["S$�����¼�9"], "")
        end
    end

end

function QiYuShiJian09.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�9"])
    if verify ~= "��Ů��ԡ" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�9"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "��Ů��ԡ" then
        setplaydef(actor, VarCfg["S$�����¼�9"], "��Ů��ԡ" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian09)


--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian09, QiYuShiJian09)

return QiYuShiJian09
