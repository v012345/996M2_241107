local QiYuShiJian04 = {}
local num = nil

function QiYuShiJian04.Request(actor, arg1)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�4"])
    if verify ~= "��Ұ�Թ�" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end

    if num ~=  arg1 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------

    if arg1 == 1 then
        if verify == "��Ұ�Թ�" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "��Ұ�Թ�", "��ϲ���÷���ʯx10","����ʯ#10")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|����ʯx10#249|...")
            setplaydef(actor, VarCfg["S$�����¼�4"], "")
        end
    elseif arg1 == 2 then  --����20Ѫ��
        humanhp(actor, "-", Player.getHpValue(actor, 20), 1)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�������������,|����ֵ#249|����|20%#249|...")
        setplaydef(actor, VarCfg["S$�����¼�4"], "")
    elseif arg1 == 3 then
        if verify == "��Ұ�Թ�" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "��Ұ�Թ�", "��ϲ����10����","�󶨽��#100000")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|10��#249|���...")
            setplaydef(actor, VarCfg["S$�����¼�4"], "")
        end
    elseif arg1 == 4 then
        addmpper(actor, "=", 0)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�������������,|ħ��ֵ#249|����|100%#249|...")
        setplaydef(actor, VarCfg["S$�����¼�4"], "")
    end
end

function QiYuShiJian04.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�4"])
    if verify ~= "��Ұ�Թ�" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�4"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "��Ұ�Թ�" then
        setplaydef(actor, VarCfg["S$�����¼�4"], "��Ұ�Թ�" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian04)

--ע��������Ϣ
function QiYuShiJian04.SyncResponse(actor, logindatas)
    num = math.random(1, 4)
    local data = {num}
    Message.sendmsg(actor, ssrNetMsgCfg.QiYuShiJian04_SyncResponse, 0, 0, 0, data)
end
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian04, QiYuShiJian04)


return QiYuShiJian04
