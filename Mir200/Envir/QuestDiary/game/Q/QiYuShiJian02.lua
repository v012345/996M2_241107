local QiYuShiJian02 = {}

function QiYuShiJian02.Request(actor, arg1)

    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�2"])
    if verify ~= "������" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    if arg1 == 1 then
        local itemobj = linkbodyitem(actor, 0)
        if itemobj ~= "0" then
            if verify == "������" then
                local abilGroup = 1
                clearitemcustomabil(actor,itemobj,abilGroup)
                changecustomitemtext(actor, itemobj, "\n\n\n\n\n[��������]:", abilGroup)
                changecustomitemtextcolor(actor, itemobj, 254, abilGroup)
                Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 1, 251, 30, 30, 1, 10)
                Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,�·�����������|+10%#249|�Ŀ�������...")
                setplaydef(actor, VarCfg["S$�����¼�2"], "")
            end
        else
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��δ����|�·�#249|...")
        end
    elseif arg1 == 2 then
        local itemobj = linkbodyitem(actor, 1)
        if itemobj ~= "0" then
            if verify == "������" then
                local abilGroup = 1
                clearitemcustomabil(actor,itemobj,abilGroup)
                changecustomitemtext(actor, itemobj, "\n\n\n\n\n[��������]:", abilGroup)
                changecustomitemtextcolor(actor, itemobj, 254, abilGroup)
                Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 1, 251, 25, 25, 1, 10)
                Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,������ù����˺�|+10%#249|�Ŀ�������...")
                setplaydef(actor, VarCfg["S$�����¼�2"], "")
            end
        else
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��δ����|����#249|...")
        end
    end
end

function QiYuShiJian02.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�2"])
    if verify ~= "������" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�2"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "������" then
        setplaydef(actor, VarCfg["S$�����¼�2"], "������" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian02)



--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian02, QiYuShiJian02)

return QiYuShiJian02
