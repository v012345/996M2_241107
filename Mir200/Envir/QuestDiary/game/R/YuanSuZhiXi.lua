local YuanSuZhiXi = {}
local npcID = 227
local give = { { "Ԫ����϶Ȩ��", 1 } }
local cost = { { "����֮��", 20 } }
--��ȡ����
function YuanSuZhiXi.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local flag = getflagstatus(actor, VarCfg["F_����_Ԫ��֮϶"])
    if flag == 1 then
        Player.sendmsgEx(actor, "���Ѿ�����˸þ�������!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "Ԫ��֮϶����")
    Player.giveItemByTable(actor, give, "Ԫ��֮϶����", 1, true)
    -- setflagstatus(actor, VarCfg["F_����_Ԫ��֮϶"], 1)
    FSetTaskRedPoint(actor, VarCfg["F_����_Ԫ��֮϶"], 8)
    YuanSuZhiXi.SyncResponse(actor)
end
function YuanSuZhiXi.SyncResponse(actor)
    local flag = getflagstatus(actor, VarCfg["F_����_Ԫ��֮϶"])
    Message.sendmsg(actor, ssrNetMsgCfg.YuanSuZhiXi_SyncResponse, flag, 0, 0, {})
end

Message.RegisterNetMsg(ssrNetMsgCfg.YuanSuZhiXi, YuanSuZhiXi)
return YuanSuZhiXi
