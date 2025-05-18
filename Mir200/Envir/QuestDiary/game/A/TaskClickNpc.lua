--�������
local TaskClickNpc = {}
--���
TaskClickNpc.init = function(actor, npcid, taskID, cfg)
    local func = TaskClickNpc[npcid]
    if func then
        return func(actor, npcid, taskID, cfg)
    end
end
--��Դ��ɱ��
TaskClickNpc[1001] = function(actor, npcid, taskID, cfg)
    if taskID == 2 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_��������״̬"])
        --���������Դ��ɱ��
        if mainTaskStatus == 2 then
            changeexp(actor, "+", 5000, false)
            addskill(actor, 66, 3)
            Player.sendmsgEx(actor, "�������:���|����*5000#249|ѧϰ����|����ն#249")
            Player.nextTaskMain(actor, taskID, cfg)
            return true
        end
    --�ɼ��嶾���������
    elseif taskID == 3 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_��������״̬"])
        if mainTaskStatus == 2 then
            changeexp(actor, "+", 5000, false)
            addskill(actor, 56, 3)
            local itemNum = getbagitemcount(actor,"�嶾��")
            if itemNum > 5 then
                itemNum = 5
            end
            local items = {{"�嶾��",itemNum}}
            Player.takeItemByTable(actor,items,"��������")
            Player.sendmsgEx(actor, "�������:���|����*5000#249|ѧϰ����|���ս���#249")
            Player.nextTaskMain(actor, taskID, cfg)
            return true
        end
    end
end

TaskClickNpc[1002] = function(actor, npcid, taskID, cfg)
    if taskID == 4 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_��������״̬"])
        if mainTaskStatus == 2 then
            changeexp(actor, "+", 20000, false)
            giveonitem(actor, 12, "ɱ¾��ӡLv.1", 1, ConstCfg.binding)
            Player.sendmsgEx(actor, "�������:���|����*20000#249|���װ��|�����ӡLv.1#249|װ����Ϊ���Զ�����!")
            Player.nextTaskMain(actor, taskID, cfg)
            return true
        end
    end
end

TaskClickNpc[1003] = function(actor, npcid, taskID, cfg)
    if taskID == 5 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_��������״̬"])
        if mainTaskStatus == 2 then
            changeexp(actor, "+", 20000, false)
            giveonitem(actor, 14, "�����ӡLv.1", 1, ConstCfg.binding)
            Player.sendmsgEx(actor, "�������:���|����*20000#249|���װ��|�����ӡLv.1#249|װ����Ϊ���Զ�����!")
            changemode(actor,22,300)
            Player.sendmsgEx(actor, "��������,����5����!")
            Player.nextTaskMain(actor, taskID, cfg)
            return true
        end
    end
end
TaskClickNpc[1005] = function(actor, npcid, taskID, cfg)
    if taskID == 7 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_��������״̬"])
        if mainTaskStatus == 0 then
            local where = 43
            local itemObj = linkbodyitem(actor, where)
            if itemObj == "0" then
                giveonitem(actor, where, "�����ݽߵ�ľϻ", 1, 0, "���ɸ���")
                XiuXian.addXiuXian(actor, 130)
                local gives = {{"�󶨽��",10000}}
                Player.giveItemByTable(actor, gives, "������������")
                Player.sendmsgEx(actor, "�������:���װ��|�����ݽߵ�ľϻ#249|,|����ֵ*130#249|װ����Ϊ���Զ�����!")
            end
        end
    end
end

return TaskClickNpc
