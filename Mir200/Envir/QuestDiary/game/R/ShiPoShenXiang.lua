local ShiPoShenXiang = {}
local npcID = 228
local cost = { { "ʪ������", 2 }, { "���", 50000 } }
--��ȡ����
function ShiPoShenXiang.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local jindu = getplaydef(actor, VarCfg["U_����_ʪ������_����"])
    if jindu >= 100 then
        if not confertitle(actor,"ʪ����ͽ") then
            confertitle(actor, "ʪ����ͽ", 1)
            Player.setAttList(actor, "��Ѫ����")
        end
        if not getskillinfo(actor,6, 1) then
            addskill(actor, 6, 3)
        end
        Player.sendmsgEx(actor, "���ʪ����������Ѿ�����!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "ʪ���������")
    local addJindu = math.random(2, 8)
    setplaydef(actor, VarCfg["U_����_ʪ������_����"], addJindu + jindu)
    local addExp = math.random(10000000, 30000000)
    changeexp(actor, "+", addExp, false)
    Player.sendmsgEx(actor, string.format("��ʾ��#251|ʪ�����Ѹ�Ӧ���������,|�϶�|+%d#249|,����|+%d#249|��", addJindu, addExp))
    if addJindu + jindu >= 100 then
        confertitle(actor, "ʪ����ͽ", 1)
        GameEvent.push(EventCfg.onGetTaskTitle, actor, "ʪ����ͽ") --���񴥷�
        addskill(actor, 6, 3)
        Player.setAttList(actor, "��Ѫ����")
        messagebox(actor, "��ʾ��������˸þ��������óƺ�:[ʪ����ͽ],��ü���:[ʩ����]")
    end
    ShiPoShenXiang.SyncResponse(actor)
end

function ShiPoShenXiang.SyncResponse(actor)
    local jindu = getplaydef(actor, VarCfg["U_����_ʪ������_����"])
    Message.sendmsg(actor, ssrNetMsgCfg.ShiPoShenXiang_SyncResponse, jindu, 0, 0, {})
end

Message.RegisterNetMsg(ssrNetMsgCfg.ShiPoShenXiang, ShiPoShenXiang)
return ShiPoShenXiang
