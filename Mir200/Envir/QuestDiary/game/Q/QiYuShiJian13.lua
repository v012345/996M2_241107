local QiYuShiJian13 = {}



function QiYuShiJian13.Request(actor, arg1)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�13"])
    if verify ~= "����ı���" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    if arg1 == 1 then
        if verify == "����ı���" then
            addbuff(actor, 31017, 1800, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|���ܵ��˱��������...")
            setplaydef(actor, VarCfg["S$�����¼�13"], "")
        end
    elseif arg1 == 2 then
        if verify == "����ı���" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "����ı���", "��ϲ����100����","�󶨽��#1000000")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|100��#249|���...")
            setplaydef(actor, VarCfg["S$�����¼�13"], "")
        end
    end
end


function QiYuShiJian13.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�13"])
    if verify ~= "����ı���" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�13"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "����ı���" then
        setplaydef(actor, VarCfg["S$�����¼�13"], "����ı���")
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian13)


--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian13, QiYuShiJian13)

return QiYuShiJian13
