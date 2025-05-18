--�������
local TaskUpdataList = {}
--���
TaskUpdataList.init = function(actor, taskID, cfg, data)
    data = data or {}
    local func = TaskUpdataList[taskID]
    if func then
        return func(actor, taskID, cfg, data)
    end
end
--��Դ��ɱ��
TaskUpdataList[2] = function(actor, taskID, cfg, data)
    if taskID == 2 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_��������״̬"])
        if mainTaskStatus ~= 1 then
            return
        end
        local monobj = data.monobj
        local objName = getbaseinfo(monobj,ConstCfg.gbase.name)
        --�����ڵĹ�
        if objName == cfg.monster[1] or objName == cfg.monster[2] then
            local num1 = getplaydef(actor, cfg.recordVar[1])
            local num2 = getplaydef(actor, cfg.recordVar[2])
            if objName == cfg.monster[1] then
                if num1 < cfg.taskNeed[1] then
                    setplaydef(actor, cfg.recordVar[1], num1 + 1)
                    newchangetask(actor, taskID, num1 + 1, num2)
                    Player.sendmsgEx(actor, string.format("%s#249|�ѻ�ɱ|%s/%s#249",cfg.monster[1],num1 +1,cfg.taskNeed[1]))
                end
            end
            if objName == cfg.monster[2] then
                if num2 < cfg.taskNeed[2] then
                    setplaydef(actor, cfg.recordVar[2], num2 + 1)
                    newchangetask(actor, taskID, num1, num2 +1)
                    Player.sendmsgEx(actor, string.format("%s#249|�ѻ�ɱ|%s/%s#249",cfg.monster[2],num2 +1,cfg.taskNeed[2]))
                end
            end
            if num1 + 1 >= cfg.taskNeed[1] and num2 + 1 >= cfg.taskNeed[2] then
                Player.sendmsgEx(actor,"���Ѿ������|[��Դ���ɱ����]#249")
                Player.updateProgress(actor, taskID, 2)
                setplaydef(actor, VarCfg["U_��������״̬"], 2)
                -- opennpcshowex(actor, 1001, 0, 2)
                -- navigation(actor,110,taskID,"��������")
                return true
            end
        end
        
    end
end
TaskUpdataList[3] = function(actor, taskID, cfg, data)
    local itemName = data.itemName
        local mainTaskStatus = getplaydef(actor, VarCfg["U_��������״̬"])
        if mainTaskStatus ~= 1 then
            return
        end
        if itemName == cfg.monster[1] then
        local num1 = getplaydef(actor, cfg.recordVar[1])
        if num1 < cfg.taskNeed[1] then
            setplaydef(actor, cfg.recordVar[1], num1 + 1)
            newchangetask(actor, taskID, num1 + 1)
            Player.sendmsgEx(actor, string.format("%s#249|�Ѳɼ�|%s/%s#249",cfg.monster[1],num1 +1,cfg.taskNeed[1]))
        end
        if num1 + 1 >= cfg.taskNeed[1] then
            Player.sendmsgEx(actor,"���Ѿ������|[�ɼ��嶾������]#249")
            Player.updateProgress(actor, taskID, 2)
            setplaydef(actor, VarCfg["U_��������״̬"], 2)
            -- opennpcshowex(actor, 1001, 0, 2)
            -- navigation(actor,110,taskID,"��������")
            return true
        end
    end
end

--ɱ����è
TaskUpdataList[4] = function(actor, taskID, cfg, data)
    if taskID == 4 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_��������״̬"])
        if mainTaskStatus ~= 1 then
            return
        end
        local monobj = data.monobj
        local objName = getbaseinfo(monobj, ConstCfg.gbase.name)
        if objName == "�����ĵ�����" or objName == "�����Ķ���è" then
            local num1 = getplaydef(actor, VarCfg["U_��ǰ�������1"])
            if num1 < cfg.taskNeed[1] then
                newchangetask(actor, taskID, num1 + 1)
                setplaydef(actor, VarCfg["U_��ǰ�������1"], num1 + 1)
                Player.sendmsgEx(actor, string.format("%s#249|�ѻ�ɱ|%s/%s#249", objName, num1 + 1, cfg.taskNeed[1]))
            end
            if num1 + 1 >= cfg.taskNeed[1] then
                Player.sendmsgEx(actor, "���Ѿ������|[��Դ���ɱ����]#249|����ǰ����ȡ����...")
                Player.updateProgress(actor, taskID, 2)
                setplaydef(actor, VarCfg["U_��������״̬"], 2)
                -- opennpcshowex(actor, 1002, 0, 2)
                -- navigation(actor,110,taskID,"��������")
                return true
            end
        end
    end
end
--�ռ�ͨ�黨�ۺ;�������
TaskUpdataList[5] = function(actor, taskID, cfg, data)
    local mainTaskStatus = getplaydef(actor, VarCfg["U_��������״̬"])
    if mainTaskStatus ~= 1 then
        return
    end
    local itemName = data.itemName
    local num1 = getplaydef(actor, cfg.recordVar[1])
    local num2 = getplaydef(actor, cfg.recordVar[2])
    if itemName == cfg.items[1] then
        if num1 < cfg.taskNeed[1] then
            setplaydef(actor, cfg.recordVar[1], num1 + 1)
            newchangetask(actor, taskID, num1 + 1, num2)
            Player.sendmsgEx(actor, string.format("%s#249|�ѻ��|%s/%s#249",cfg.items[1],num1 +1,cfg.taskNeed[1]))
        end
    end
    if itemName == cfg.items[2] then
        if num2 < cfg.taskNeed[2] then
            setplaydef(actor, cfg.recordVar[2], num2 + 1)
            newchangetask(actor, taskID, num1, num2 + 1)
            Player.sendmsgEx(actor, string.format("%s#249|�Ѳɼ�|%s/%s#249",cfg.items[2],num2 +1,cfg.taskNeed[2]))
        end
    end
    if num1 + 1 >= cfg.taskNeed[1] and num2 + 1 >= cfg.taskNeed[2] then
        Player.sendmsgEx(actor,"���Ѿ������|[�ɼ��嶾������]#249")
        Player.updateProgress(actor, taskID, 2)
        setplaydef(actor, VarCfg["U_��������״̬"], 2)
        -- opennpcshowex(actor, 1001, 0, 2)
        -- navigation(actor,110,taskID,"��������")
        return true
    end
end
TaskUpdataList[6] = function(actor, taskID, cfg, data)
    if taskID == 6 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_��������״̬"])
        if mainTaskStatus ~= 1 then
            return
        end
        local monobj = data.monobj
        local objName = getbaseinfo(monobj,ConstCfg.gbase.name)
        --�����ڵĹ�
        if objName == cfg.monster[1] or objName == cfg.monster[2] or objName == cfg.monster[3] then
            local num1 = getplaydef(actor, cfg.recordVar[1])
            local num2 = getplaydef(actor, cfg.recordVar[2])
            if objName == cfg.monster[1] then
                if num1 < cfg.taskNeed[1] then
                    setplaydef(actor, cfg.recordVar[1], num1 + 1)
                    newchangetask(actor, taskID, num1 + 1, num2)
                    Player.sendmsgEx(actor, string.format("%s#249|�ѻ�ɱ|%s/%s#249",cfg.monster[1],num1 +1,cfg.taskNeed[1]))
                    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
                    local monNum = getmoncount(mapId, -1, true)
                    if monNum == 0 then
                        scenevibration(actor,0,3,1)
                        genmon(mapId, 26, 26, "���񡤰���˹", 1, 1, 249)
                        sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]�����ɱ�����е�[�������],�ٻ�����[���񡤰���˹],��ǰ����ɱ!", 0, 8)
                    end
                end
            end
            if objName == cfg.monster[2] then
                if num2 < cfg.taskNeed[2] then
                    -- setplaydef(actor, cfg.recordVar[2], num2 + 1)
                    -- newchangetask(actor, taskID, num1, num2 +1)
                    -- Player.sendmsgEx(actor, string.format("%s#249|�ѻ�ɱ|%s/%s#249",cfg.monster[2],num2 +1,cfg.taskNeed[2]))
                    scenevibration(actor,0,3,1)
                    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
                    genmon(mapId, 26, 26, "���񡤰���˹������", 1, 1, 249)
                    sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]�����ɱ�����е�[���񡤰���˹],�ٻ�����[���񡤰���˹������],��ǰ����ɱ!", 0, 8)
                end
            end
            if objName == cfg.monster[3] then
                if num2 < cfg.taskNeed[2] then
                    setplaydef(actor, cfg.recordVar[2], num2 + 1)
                    newchangetask(actor, taskID, num1, num2 +1)
                    Player.sendmsgEx(actor, string.format("%s#249|�ѻ�ɱ|%s/%s#249",cfg.monster[3],num2 +1,cfg.taskNeed[2]))
                end
            end

            local num1 = getplaydef(actor, cfg.recordVar[1])
            local num2 = getplaydef(actor, cfg.recordVar[2])
            if num1 >= cfg.taskNeed[1] and num2 >= cfg.taskNeed[2] then
                Player.sendmsgEx(actor,"���Ѿ������|[�����������]#249")
                Player.updateProgress(actor, taskID, 2)
                setplaydef(actor, VarCfg["U_��������״̬"], 2)
                -- opennpcshowex(actor, 1001, 0, 2)
                -- navigation(actor,110,taskID,"��������")
                return true
            end
        end 
    end
end
TaskUpdataList[7] = function(actor, taskID, cfg, data)
    if taskID == 7 then
        local mainTaskStatus = getplaydef(actor, VarCfg["U_��������״̬"])
        if mainTaskStatus == 1 then
            if FCheckMap(actor, cfg.map) then
                local num1 = getplaydef(actor, cfg.recordVar[1])
                if num1 < cfg.taskNeed[1] then
                    setplaydef(actor, cfg.recordVar[1], num1 + 1)
                    newchangetask(actor, taskID, num1 + 1)
                    Player.sendmsgEx(actor, string.format("�ѻ�ɱ����|%s/%s#249",num1 +1,cfg.taskNeed[1]))
                end
                if num1 + 1 >= cfg.taskNeed[1] then
                    Player.updateProgress(actor, taskID, 2)
                    setplaydef(actor, VarCfg["U_��������״̬"], 2)
                    XiuXian.addXiuXian(actor, 150)
                    Player.sendmsgEx(actor, "��ϲ���������,���|150���ɾ���#249")
                    --����Ѿ������ˣ�ֱ�ӿ�ʼ��һ������
                    local where = 43
                    local itemObj = linkbodyitem(actor, where)
                    if itemObj ~= "0" then
                        local itemName = getiteminfo(actor, itemObj, ConstCfg.iteminfo.name)
                        local level = tonumber(getstditeminfo(itemName, ConstCfg.stditeminfo.custom29))
                        if level > 1 then
                            Player.sendmsgEx(actor, "���Ѿ�������������ɾ�������,ֱ�ӿ�ʼ��һ������!")
                            Player.nextTaskMain(actor, taskID, cfg)
                            return true
                        end
                    end
                    return true
                end
            end
        end
    end
end
TaskUpdataList[200] = function(actor, taskID, cfg, data)
    local itemNum = getbagitemcount(actor, cfg.items[1])
    newchangetask(actor, taskID, itemNum)
end
return TaskUpdataList
