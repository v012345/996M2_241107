local QiYuShiJian11 = {}

function QiYuShiJian11.Request(actor, arg1)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�11"])
    if verify ~= "��������" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------

    if arg1 == 1 then
        if verify == "��������" then
            changeexp(actor, "+", 50000000, false)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|5000��#249|�㾭��...")
            setplaydef(actor, VarCfg["S$�����¼�11"], "")
        end
    elseif arg1 == 2 then
        if verify == "��������" then
            addbuff(actor, 31014, 1800, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|����ӳ�����|20%#249|,����|1800#249|��...")
            setplaydef(actor, VarCfg["S$�����¼�11"], "")
        end
    end
end


function QiYuShiJian11.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�11"])
    if verify ~= "��������" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�11"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "��������" then
        setplaydef(actor, VarCfg["S$�����¼�11"], "��������" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian11)


--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian11, QiYuShiJian11)

return QiYuShiJian11
