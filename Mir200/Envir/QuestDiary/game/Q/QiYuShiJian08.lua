local QiYuShiJian08 = {}
function QiYuShiJian08.Request(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�8"])
    if verify ~= "�����ı���" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    if verify == "�����ı���" then
        local UserId = getconst(actor, "<$USERID>")
        sendmail(UserId, 5001, "�����ı���", "��ϲ���[�����ı���]x1","�����ı���#1")
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|�����ı���x1#249|...")
        setplaydef(actor, VarCfg["S$�����¼�8"], "")
    end
end


function QiYuShiJian08.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�8"])
    if verify ~= "�����ı���" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�8"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "�����ı���" then
        setplaydef(actor, VarCfg["S$�����¼�8"], "�����ı���" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian08)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian08, QiYuShiJian08)

return QiYuShiJian08
