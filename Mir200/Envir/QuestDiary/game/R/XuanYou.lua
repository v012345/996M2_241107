local XuanYou = {}
local npcID = 414
local taskId = 200
local cost = { { "���������", 38 } }
local give = { { "һ���", 1 } }
function XuanYou.OpenUI(actor)
    local flag = getflagstatus(actor, VarCfg["F_����_����"])
    Message.sendmsg(actor, ssrNetMsgCfg.XuanYou_OpenUI, flag)
end

--��ȡ����
function XuanYou.Request(actor)
    local flag = getflagstatus(actor, VarCfg["F_����_����"])
    if flag == 1 then
        Player.sendmsgEx(actor, "���Ѿ�����˸þ�������!#249")
        return
    end
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    Player.addTask(actor, taskId, 1)
    Task.SyncResponse(actor)
end

function XuanYou.RequestSubmit(actor)
    local flag = getflagstatus(actor, VarCfg["F_����_����"])
    if flag == 1 then
        Player.sendmsgEx(actor, "���Ѿ�����˸þ�������!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "���ľ���")
    Player.giveItemByTable(actor, give, "���ľ���", 1, true)
    Player.sendmsgEx(actor, "��ϲ���������,���|[һ���]#249")
    newdeletetask(actor, taskId)
    Player.removeTask(actor, taskId)
    Task.SyncResponse(actor)
    FSetTaskRedPoint(actor, VarCfg["F_����_����"], 15)
    Message.sendmsg(actor, ssrNetMsgCfg.XuanYou_OpenUI, 1)
end

Message.RegisterNetMsg(ssrNetMsgCfg.XuanYou, XuanYou)
return XuanYou
