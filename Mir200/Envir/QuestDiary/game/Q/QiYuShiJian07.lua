local QiYuShiJian07 = {}


function QiYuShiJian07.Request(actor, arg1)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�7"])
    if verify ~= "��G���Ͼ�" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    if arg1 == 1 then
        if verify == "��G���Ͼ�" then
            addbuff(actor, 31009, 1800, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�и�����|1000#249|��,����|1800#249|��...")
            setplaydef(actor, VarCfg["S$�����¼�7"], "")
            Player.setAttList(actor, "���Ը���")
        end
    elseif arg1 == 2 then
        if verify == "��G���Ͼ�" then
            addbuff(actor, 31010, 1800, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��������|20%#249|,����|1800#249|��...")
            setplaydef(actor, VarCfg["S$�����¼�7"], "")
            Player.setAttList(actor, "���ʸ���")
        end
    end
end

local function _onBuffChange(actor, buffid, groupid, model)
    if buffid ==  31009 then
        if model == 4 then
            Player.setAttList(actor, "���Ը���")
        end
    end
    if buffid ==  31010 then
        if model == 4 then
            Player.setAttList(actor, "���ʸ���")
        end
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, QiYuShiJian07)



function QiYuShiJian07.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�7"])
    if verify ~= "��G���Ͼ�" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�7"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "��G���Ͼ�" then
        setplaydef(actor, VarCfg["S$�����¼�7"], "��G���Ͼ�" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian07)


--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian07, QiYuShiJian07)

return QiYuShiJian07
