local QiYuShiJian01 = {}


function QiYuShiJian01.Request(actor, arg1)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�1"])
    if verify ~= "��������" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    if arg1 == 1 then
        if verify == "��������" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "��������", "��ϲ����10����","�󶨽��#100000")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|10��#249|���...")
            setplaydef(actor, VarCfg["S$�����¼�1"], "")
        end
    elseif arg1 == 2 then
        if verify == "��������" then
            addbuff(actor, 31001, 3600, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�и�����|2222#249|��,����|3600#249|��...")
            setplaydef(actor, VarCfg["S$�����¼�1"], "")
        end
    end
end

function QiYuShiJian01.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�1"])
    if verify ~= "��������" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�1"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "��������" then
        setplaydef(actor, VarCfg["S$�����¼�1"], "��������" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian01)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian01, QiYuShiJian01)

return QiYuShiJian01
