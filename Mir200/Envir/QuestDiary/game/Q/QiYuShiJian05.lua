local QiYuShiJian05 = {}

function QiYuShiJian05.Request(actor, arg1)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�5"])
    if verify ~= "���߻����ֻ�" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------

    if arg1 == 1 then
        if verify == "���߻����ֻ�" then
            addbuff(actor, 31003, 3600, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�и�����|2222#249|��,����|3600#249|��...")
            setplaydef(actor, VarCfg["S$�����¼�5"], "")
            Player.setAttList(actor, "���Ը���")
        end
    elseif arg1 == 2 then
        if verify == "���߻����ֻ�" then
            addbuff(actor, 31004, 3600, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��������|20%#249|,����|3600#249|��...")
            setplaydef(actor, VarCfg["S$�����¼�5"], "")
            Player.setAttList(actor, "���ʸ���")
        end
    elseif arg1 == 3 then
        if verify == "���߻����ֻ�" then
            addbuff(actor, 31005, 3600, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��������|20%#249|,����|3600#249|��...")
            setplaydef(actor, VarCfg["S$�����¼�5"], "")
        end
    end
end

--buufɾ������
local function _onBuffChange(actor, buffid, groupid, model)
    if buffid ==  31003 then
        if model == 4 then
            Player.setAttList(actor, "���Ը���")
        end
    end
    if buffid ==  31004 then
        if model == 4 then
            Player.setAttList(actor, "���ʸ���")
        end
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, QiYuShiJian05)

function QiYuShiJian05.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�5"])
    if verify ~= "���߻����ֻ�" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�5"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "���߻����ֻ�" then
        setplaydef(actor, VarCfg["S$�����¼�5"], "���߻����ֻ�" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian05)




--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian05, QiYuShiJian05)

return QiYuShiJian05
