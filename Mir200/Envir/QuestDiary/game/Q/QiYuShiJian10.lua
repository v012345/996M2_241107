local QiYuShiJian10 = {}
local cost = { { "���", 2000 } }
function QiYuShiJian10.Request(actor)
    local skillinfo = getskillinfo(actor, 2017, 1)
    local skillinfoUp = getskillinfo(actor, 2019, 1)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�10"])
    if verify ~= "����ؤ" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------

    if skillinfo == 3 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|������ϰ|��������#249|�����ظ���ϰ...")
        return
    end
    if skillinfoUp then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|������ϰ|������������#249|�����ظ���ϰ...")
        return
    end
    if verify == "����ؤ" then
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "��������")
        addskill(actor, 2017, 3)
        setplaydef(actor, VarCfg["S$�����¼�10"], "")
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,ѧ��|ն��#249|��|��������#249|...")
    end
end

--��������
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    if randomex(3, 100) then
        if getskilllevel(actor, 2017) == 3 then
            local x = getbaseinfo(Target, ConstCfg.gbase.x)
            local y = getbaseinfo(Target, ConstCfg.gbase.y)
            rangeharm(actor, x, y, 0, 0, 6, Player.getHpValue(Target, 1), 0, 2,63069)
        end
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, QiYuShiJian10)

function QiYuShiJian10.CloseUI(actor)
    ----------------��֤����----------------
    local verify = getplaydef(actor,VarCfg["S$�����¼�10"])
    if verify ~= "����ؤ" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$�����¼�10"],"")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "����ؤ" then
        setplaydef(actor, VarCfg["S$�����¼�10"], "����ؤ" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian10)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian10, QiYuShiJian10)

return QiYuShiJian10
