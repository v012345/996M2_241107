local QiYuShiJian06 = {}


function QiYuShiJian06.Request(actor, arg1)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�6"])
    if verify ~= "��������ĵ���" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------

    if arg1 == 1 then
        if verify == "��������ĵ���" then
            addbuff(actor, 31006, 1800, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�����ٶ�����|30%#249|,����|1800#249|��...")
            setplaydef(actor, VarCfg["S$�����¼�6"], "")
            Player.setAttList(actor, "���ٸ���")
        end
    elseif arg1 == 2 then
        if verify == "��������ĵ���" then
            changespeed(actor, 1, 1)
            addbuff(actor, 31007, 1800, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�ƶ��ٶ�����|5%#249|,����|1800#249|��...")
            setplaydef(actor, VarCfg["S$�����¼�6"], "")
        end
    elseif arg1 == 3 then
        if verify == "��������ĵ���" then
            addbuff(actor, 31008, 1800, 1, actor)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�����˺�����|10%#249|,����|1800#249|��...")
            setplaydef(actor, VarCfg["S$�����¼�6"], "")
        end
    end
end

function QiYuShiJian06.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�6"])
    if verify ~= "��������ĵ���" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�6"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "��������ĵ���" then
        setplaydef(actor, VarCfg["S$�����¼�6"], "��������ĵ���" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian06)



--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian06, QiYuShiJian06)

--���ӹ����ٶ�
local function _onCalcAttackSpeed(actor, attackSpeeds)
    local buff = hasbuff(actor, 31006)
    if buff then
        attackSpeeds[1] = attackSpeeds[1] + 30
    end
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, QiYuShiJian06)

--buufɾ������
local function _onBuffChange(actor, buffid, groupid, model)
    if buffid ==  31006 then
        if model == 4 then
            Player.setAttList(actor, "���ٸ���")
        end
    end
    if buffid ==  31007 then
        if model == 4 then
            changespeed(actor, 1, 0)
        end
    end

end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, QiYuShiJian06)

return QiYuShiJian06
