local QiYuShiJian12 = {}


function QiYuShiJian12.Request(actor, arg1)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�12"])
    if verify ~= "��Լ" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    if arg1 == 1 then
        if verify == "��Լ" then
            addbuff(actor, 31015, 1800, 1, actor)
            Player.setAttList(actor, "���ʸ���")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|��ʥ��Լ#249|Buff...")
            setplaydef(actor, VarCfg["S$�����¼�12"], "")
        end
    elseif arg1 == 2 then
        if verify == "��Լ" then
            addbuff(actor, 31016, 1800, 1, actor)
            Player.setAttList(actor, "���ʸ���")
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|��ħ��Լ#249|Buff...")
            setplaydef(actor, VarCfg["S$�����¼�12"], "")
        end
    end
end

--��������ǰ����
local function _onAttackDamageMonster(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local buff1 = hasbuff(actor, 31015)
    if buff1 then
        attackDamageData.damage = attackDamageData.damage - math.floor(Damage * 0.2)
    end

    local buff2 = hasbuff(actor, 31016)
    if buff2 then
        attackDamageData.damage = attackDamageData.damage + math.floor(Damage * 0.2)
    end
end
GameEvent.add(EventCfg.onAttackDamageMonster, _onAttackDamageMonster, QiYuShiJian12)




local function _onBuffChange(actor, buffid, groupid, model)
    if buffid ==  31015 then
        if model == 4 then
            Player.setAttList(actor, "���ʸ���")
        end
    end
    if buffid ==  31016 then
        if model == 4 then
            Player.setAttList(actor, "���ʸ���")
        end
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, QiYuShiJian12)


function QiYuShiJian12.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�12"])
    if verify ~= "��Լ" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�12"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "��Լ" then
        setplaydef(actor, VarCfg["S$�����¼�12"], "��Լ" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian12)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian12, QiYuShiJian12)

return QiYuShiJian12
