local QiYuShiJian18 = {}


function QiYuShiJian18.Request(actor, arg1)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�18"])
    if verify ~= "δ֪�Ķ���" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------

    if arg1 == 1 then
        if verify == "δ֪�Ķ���" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "δ֪�Ķ���", "��ϲ������ʯx3","��ʯ#3")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|��ʯ#249|x3...")
            setplaydef(actor, VarCfg["S$�����¼�18"], "")
        end
    elseif arg1 == 2 then
        if verify == "δ֪�Ķ���" then
            local num = getplaydef(actor, VarCfg["S$���ɾ���"])
            XiuXian.addXiuXian(actor, 100)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|100#249|��,���ɾ���...")
            setplaydef(actor, VarCfg["S$�����¼�18"], "")
        end
    end
end


function QiYuShiJian18.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�18"])
    if verify ~= "δ֪�Ķ���" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�18"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "δ֪�Ķ���" then
        setplaydef(actor, VarCfg["S$�����¼�18"], "δ֪�Ķ���")
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian18)


--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian18, QiYuShiJian18)


return QiYuShiJian18
