local QiYuShiJian14 = {}

function QiYuShiJian14.Request(actor, arg1)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�14"])
    if verify ~= "����ļ�̳" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    if arg1 == 1 then
        if verify == "����ļ�̳" then
            addbuff(actor, 31018, 1800, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|���Ķ���#249|Buff...")
            setplaydef(actor, VarCfg["S$�����¼�14"], "")
        end
    elseif arg1 == 2 then
        if verify == "����ļ�̳" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "����ļ�̳", "��ϲ����1��Ԫ��","Ԫ��#10000")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|1��#249|Ԫ�����ܵ�|���Ľ���#249|�˺�...")
            addbuff(actor, 31019, 9, 1, actor)
            setplaydef(actor, VarCfg["S$�����¼�14"], "")
        end
    end
end


function QiYuShiJian14.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�14"])
    if verify ~= "����ļ�̳" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�14"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "����ļ�̳" then
        setplaydef(actor, VarCfg["S$�����¼�14"], "����ļ�̳")
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian14)


--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian14, QiYuShiJian14)

return QiYuShiJian14
