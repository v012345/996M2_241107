local ZhuXianRenWuGetTaskData = {}

local getTypeFunc = {}
--ɱ������
getTypeFunc[1] = function(actor, data)
    local mapID = data[2] or ""
    local monName = data[3] or ""
    local var = data[4]
    local max = data[5]
    local currNum = getplaydef(actor, var)
    return { currNum, max }
end
--����װ��
getTypeFunc[2] = function(actor, data)
    local equipName = data[2]
    if not equipName then
        return false
    end
    local equipObj = linkbodyitem(actor, 43)
    if equipObj == "0" then
        return false
    end
    local currNum = getiteminfo(actor, equipObj, ConstCfg.iteminfo.idx)
    local max = getstditeminfo(equipName, ConstCfg.stditeminfo.idx)
    return currNum >= max
end
--����ȼ�
getTypeFunc[3] = function(actor, data)
    local currLevel = getbaseinfo(actor,ConstCfg.gbase.level)
    local maxLvel = data[2]
    if currLevel < maxLvel then
        return {currLevel, maxLvel}
    else
        return true
    end
    
end
--����
getTypeFunc[4] = function(actor, data)
    local cuurnum = getplaydef(actor,data[2])
    local max = data[3]
    return {cuurnum, max}
end
--��ʶ
getTypeFunc[5] = function(actor, data)
    local cuurnum = getflagstatus(actor,data[2])
    return {cuurnum, 1}
end
--�ռ���Ʒ
getTypeFunc[6] = function(actor, data)
    local cuurnum = getplaydef(actor,data[4])
    local max = data[5]
    return {cuurnum, max}
end
--ɱ¾��ӡ
getTypeFunc[7] = function(actor, data)
    local equipName = data[2]
    if not equipName then
        return false
    end
    local equipObj = linkbodyitem(actor, 12)
    if equipObj == "0" then
        return false
    end
    local currNum = getiteminfo(actor, equipObj, ConstCfg.iteminfo.idx)
    local max = getstditeminfo(equipName, ConstCfg.stditeminfo.idx)
    return currNum >= max
end
--�����ӡ
getTypeFunc[8] = function(actor, data)
    local equipName = data[2]
    if not equipName then
        return false
    end
    local equipObj = linkbodyitem(actor, 14)
    if equipObj == "0" then
        return false
    end
    local currNum = getiteminfo(actor, equipObj, ConstCfg.iteminfo.idx)
    local max = getstditeminfo(equipName, ConstCfg.stditeminfo.idx)
    return currNum >= max
end
--�ƺ�
getTypeFunc[9] = function(actor, data)
    local titleName = data[2]
    return checktitle(actor, titleName)
end
--�����ƺ�
getTypeFunc[10] = function(actor, data)
    local cuurnum = getplaydef(actor,data[2])
    local max = data[3]
    return cuurnum >= max
end
--ת��
getTypeFunc[11] = function(actor, data)
    local reLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
    local maxLvel = data[2]
    return {reLevel, maxLvel}
end
--��������
getTypeFunc[12] = function(actor, data)
    local num = TianMing.GetTianMingNum(actor, data[2])
    local max = data[3]
    return {num, max}
end
--װ��
getTypeFunc[13] = function(actor, data)
    local num = ZhuangBan.GetZhuangBanTotalNum(actor)
    local max = data[2]
    return {num, max}
end
--��ⱳ����Ʒ
getTypeFunc[14] = function(actor, data)
    local itemName = data[2]
    if not itemName then
        return
    end
    local num = getbagitemcount(actor, itemName)
    local max = data[3]
    return {num, max}
end
function ZhuXianRenWuGetTaskData.getTaskDatas(actor, taskID, way)
    if not way then
        return {}
    end
    local result = {}
    for _, value in ipairs(way) do
        local taskType = value[1]
        local func = getTypeFunc[taskType]
        if func then
            local tmpTbl = func(actor, value)
            table.insert(result, tmpTbl)
        end
    end
    return result
end
ZhuXianRenWuGetTaskData.GetData = function(actor, taskID, cfg)
    local data1 = {}
    local data2 = {}
    local data3 = {}
    local data4 = {}
    data1 = ZhuXianRenWuGetTaskData.getTaskDatas(actor, taskID, cfg.way1)
    data2 = ZhuXianRenWuGetTaskData.getTaskDatas(actor, taskID, cfg.way2)
    data3 = ZhuXianRenWuGetTaskData.getTaskDatas(actor, taskID, cfg.way3)
    data4 = ZhuXianRenWuGetTaskData.getTaskDatas(actor, taskID, cfg.way4)
    return { data1, data2, data3, data4 }
end



return ZhuXianRenWuGetTaskData
