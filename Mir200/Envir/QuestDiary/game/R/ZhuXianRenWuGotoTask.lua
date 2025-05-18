local ZhuXianRenWuGotoTask = {}
ZhuXianRenWuGotoTask[1] = function(actor, taskID, way, cfg)
    local currDalu = getplaydef(actor, VarCfg["U_��¼��½"])
    if currDalu < cfg.dalu then
        local chinaNumber = formatNumberToChinese(cfg.dalu)
        Player.sendmsgEx(actor, string.format("��û�н���|%s��½#249", chinaNumber))
        return
    end
    local mapID = way[2] or ""
    if mapID == "������" then
        FOpenNpcShowEx(actor, 413)
        return
    elseif mapID == "ʧ�����" then
        FOpenNpcShowEx(actor, 3064)
        return
    elseif mapID == "����֮��" then
        FOpenNpcShowEx(actor, 3456)
        return
    elseif mapID == "�粼�ֶ���" then
        FOpenNpcShowEx(actor, 513)
        return
    elseif mapID == "�����ܵ�1��" then
        messagebox(actor,"��ǰ��[����֮��]Ѱ������,���������ܵ�1���ɱ����!")
        return
    elseif mapID == "��ڤ����" then
        FOpenNpcShowEx(actor, 610)
        return
    elseif mapID == "����֮���ײ�" then
        FOpenNpcShowEx(actor, 706)
        return
    elseif mapID == "�ڶ�ͨ��" then
        FOpenNpcShowEx(actor, 708)
        return
    end
    FMapEx(actor, mapID, true)
end
ZhuXianRenWuGotoTask[2] = function(actor, taskID, way, cfg)
    local name = way[2] or ""
    --�״�����
    -- if name == "����̫����" then
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_UpdateGuideTask, ConstCfg.GuideTaskInfo["����"])
    local client = getconst(actor, "<$CLIENTFLAG>")
    if client == "1" then
        navigation(actor, 104, 1000, "���")
    else
        navigation(actor, 107, 1000, "���")
    end
    -- end
end
--�ȼ�
ZhuXianRenWuGotoTask[3] = function(actor, taskID, way)
    local level = way[2] or 0
    Player.sendmsgEx(actor, level .. "���������#249")
end

--����
ZhuXianRenWuGotoTask[4] = function(actor, taskID, way, cfg)
    local var   = way[2]
    local npcID = way[4]
    --�߹ؽ���
    if var == "U10" then
        if not FCheckLevel(actor, 80) then
            Player.sendmsgEx(actor, "�ȼ�����80,�޷�����!")
            return
        end
        FOpenNpcShowEx(actor, npcID)
    elseif var == "U53" then
        if not FCheckLevel(actor, 80) then
            Player.sendmsgEx(actor, "�ȼ�����80,�޷�����!")
            return
        end
        FOpenNpcShowEx(actor, npcID)
    elseif var == "U46" then
        FMapEx(actor,"��̳")
        Player.sendmsgEx(actor, "�ڼ�̳(35,17),�����ڳݱʼ�")
    elseif var == "U129" then
        Player.sendmsgEx(actor, "ͬʱ����6��ר�������������")
    elseif var == "U177" then
        FMapEx(actor,"��֮��Ѩ",true)
        Player.sendmsgEx(actor,"�Ѿ�Ϊ�㴫�͵������ͼ")
    elseif var == "U178" then
        FMapEx(actor,"ʪ��������",true)
        Player.sendmsgEx(actor,"�Ѿ�Ϊ�㴫�͵������ͼ")
    elseif var == "U179" then
        FMapEx(actor,"����֮�����",true)
        Player.sendmsgEx(actor,"�Ѿ�Ϊ�㴫�͵������ͼ")
    elseif var == "U185" then
        FMapEx(actor,"�����ڲ�",true)
        Player.sendmsgEx(actor,"�Ѿ�Ϊ�㴫�͵������ͼ")
    elseif var == "U186" then
        FMapEx(actor,"�����ڲ�",true)
        Player.sendmsgEx(actor,"�Ѿ�Ϊ�㴫�͵������ͼ")
    elseif var == "U181" then
        FMapEx(actor,"���ĵ�",true)
        Player.sendmsgEx(actor,"�Ѿ�Ϊ�㴫�͵������ͼ")
    elseif var == "U180" then
        FMapEx(actor,"���ĵ�",true)
        Player.sendmsgEx(actor,"�Ѿ�Ϊ�㴫�͵������ͼ")
    elseif var == "U182" then
        FMapEx(actor,"ħ��ɽ��",true)
        Player.sendmsgEx(actor,"�Ѿ�Ϊ�㴫�͵������ͼ")
    else
        FOpenNpcShowEx(actor, npcID)
    end 
end
--��ʶ
ZhuXianRenWuGotoTask[5] = function(actor, taskID, way, cfg)
    local flag = way[2]
    local npcID = way[4]
    --�˽�����
    if flag == 186 then
        Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_UpdateGuideTask, ConstCfg.GuideTaskInfo["����"])
        local client = getconst(actor, "<$CLIENTFLAG>")
        if client == "1" then
            navigation(actor, 104, 1000, "���")
        else
            navigation(actor, 107, 1000, "���")
        end
        --�ռ䷨ʦ
    elseif flag == 9 then
        if not FCheckLevel(actor, 60) then
            Player.sendmsgEx(actor, "�ȼ�����60,�޷�����!")
            return
        end
        -- local cost = { { "�����ħ����", 20 } }
        -- local name, num = Player.checkItemNumByTable(actor, cost)
        -- if name then
        --     Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|,�Ѿ�Ϊ�㴫�͵������ͼ!", name, num))
        --     local mapIDs = { "��ɽ", "����ɽ��", "��ľ��", "��֮��Ѩ" }
        --     local mapID = mapIDs[math.random(1, 4)]
        --     FMapEx(actor, mapID, true)
        --     return
        -- end
        -- FOpenNpcShowEx(actor, npcID)
    -- elseif flag == 8 then
    --     if not FCheckLevel(actor, 60) then
    --         Player.sendmsgEx(actor, "�ȼ�����60,�޷�����!")
    --         return
    --     end
    --     local cost = { { "С������", 88 } }
    --     local name, num = Player.checkItemNumByTable(actor, cost)
    --     if name then
    --         Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|,�Ѿ�Ϊ�㴫�͵������ͼ!", name, num))
    --         local mapIDs = { "��ɽ", "����ɽ��", "��ľ��", "��֮��Ѩ" }
    --         local mapID = mapIDs[math.random(1, 4)]
    --         FMapEx(actor, mapID, true)
    --         return
    --     end
        FOpenNpcShowEx(actor, npcID)
    elseif flag == 188 then
        if not FCheckLevel(actor, 120) then
            Player.sendmsgEx(actor, "�ȼ�����120,�޷�����!")
            return
        end
        FOpenNpcShowEx(actor, npcID)
    elseif flag == 189 then
        if not FCheckLevel(actor, 120) then
            Player.sendmsgEx(actor, "�ȼ�����120,�޷�����!")
            return
        end
        FOpenNpcShowEx(actor, npcID)
    elseif flag == 190 then
        if not FCheckLevel(actor, 120) then
            Player.sendmsgEx(actor, "�ȼ�����120,�޷�����!")
            return
        end
        FOpenNpcShowEx(actor, npcID)
    elseif flag == 199 then
        Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_UpdateGuideTask, ConstCfg.GuideTaskInfo["�������˿���"])
        local client = getconst(actor, "<$CLIENTFLAG>")
        if client == "1" then
            navigation(actor, 104, 1000, "���")
        else
            navigation(actor, 107, 1000, "���")
        end
    else
        FOpenNpcShowEx(actor, npcID)
    end
end

ZhuXianRenWuGotoTask[6] = function(actor, taskID, way)
    local mapID = way[2] or 0
    FMapEx(actor, mapID, true)
end

--ɱ¾��ӡLv.5
ZhuXianRenWuGotoTask[7] = function(actor, taskID, way)
    local npcID = way[3]
    FOpenNpcShowEx(actor, npcID)
end

--�����ӡLv.5
ZhuXianRenWuGotoTask[8] = function(actor, taskID, way)
    local npcID = way[3]
    FOpenNpcShowEx(actor, npcID)
end
--�ƺ�
ZhuXianRenWuGotoTask[9] = function(actor, taskID, way)
    local npcID = way[3]
    FOpenNpcShowEx(actor, npcID)
end
--�Ƚϴ�С
ZhuXianRenWuGotoTask[10] = function(actor, taskID, way)
    local var = way[2]
    local npcID = way[4]
    if var == "U148" then
        local client = getconst(actor, "<$CLIENTFLAG>")
        if client == "1" then
            navigation(actor, 104, 1000, "���")
        else
            navigation(actor, 107, 1000, "���")
        end
        Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_UpdateGuideTask, ConstCfg.GuideTaskInfo["װ��"])
    else
        FOpenNpcShowEx(actor, npcID)
    end
end

ZhuXianRenWuGotoTask[11] = function(actor, taskID, way)
    local level = way[2] or 0
    local npcID = way[3]
    if npcID then
        FOpenNpcShowEx(actor, npcID)
    end
    
    -- Player.sendmsgEx(actor, level .. "ת�������#249")
end

--����
ZhuXianRenWuGotoTask[12] = function(actor, taskID, way)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuXianRenWu_UpdateGuideTask, ConstCfg.GuideTaskInfo["����"])
    local client = getconst(actor, "<$CLIENTFLAG>")
    if client == "1" then
        navigation(actor, 104, 1000, "���")
    else
        navigation(actor, 107, 1000, "���")
    end
end

--װ��
ZhuXianRenWuGotoTask[13] = function(actor, taskID, way)
    local num = way[2]
    Player.sendmsgEx(actor, "�ռ�" .. num .. "��װ�缴���������!")
end

--�����Ʒ
ZhuXianRenWuGotoTask[14] = function(actor, taskID, way)
    local itemName = way[2]
    local itemNum = way[3]
    local mapID = way[4]
    local npcID = way[5]
    if mapID ~= "��" then
        Player.sendmsgEx(actor, string.format("�㱳����|%s#249|����|%d#249|,�Ѿ�Ϊ�㴫�͵������ͼ!", itemName, itemNum))
        FMapEx(actor, mapID, true)
        return
    end
    if npcID > 0 then
        FOpenNpcShowEx(actor, npcID)
    end
end


return ZhuXianRenWuGotoTask
